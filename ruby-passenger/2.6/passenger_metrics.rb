#!/usr/bin/env ruby
#
#Metrics collecter for Passenger phusion 3 and 4.
#This script work in conjuction with sensu and graphite
#Author: Allen Sanabria <https://github.com/linuxdynasty>
# Released under the same terms as Sensu (the MIT license);
# see LICENSE for details.
# Source: https://github.com/linuxdynasty/Linuxdynasty/blob/master/scripts/sensu/metrics/passenger_metrics.rb
#
require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'socket'
require 'nokogiri'

class PassengerMetrics < Sensu::Plugin::Metric::CLI::Graphite

  option :command,
         :description => "Full location of passenger-status",
         :short       => '-c COMMAND',
         :long        => '--command COMMAND',
         :default     => 'passenger-status'

  option :scheme,
         :description => "Metric naming scheme, text to prepend to $queue_name.$metric",
         :long        => "--scheme SCHEME",
         :default     => "#{Socket.gethostname}.passenger"

  def output_process(process, app_group, count, timestamp)
    processed = process.xpath('.//processed')[0].children.to_s
    pid = process.xpath('.//pid')[0].children.to_s
    memory_node = process.xpath('.//real_memory')
    if !memory_node.empty?
      memory = memory_node[0].children.to_s
    end
    cpu_percent = process.xpath('.//cpu')[0].children.to_s
    start_time = Time.at(process.xpath('.//spawn_end_time').children[0].to_s.to_i/1000000)
    last_used = Time.at(process.xpath('.//last_used').children[0].to_s.to_i/1000000)
    uptime = Integer(Time.at(timestamp) - start_time)
    output "#{config[:scheme]}.#{app_group}.process_#{count}.processed", processed, timestamp
    output "#{config[:scheme]}.#{app_group}.process_#{count}.pid", pid, timestamp
    output "#{config[:scheme]}.#{app_group}.process_#{count}.uptime", uptime, timestamp
    output "#{config[:scheme]}.#{app_group}.process_#{count}.memory", memory, timestamp
    output "#{config[:scheme]}.#{app_group}.process_#{count}.cpu_percent", cpu_percent, timestamp
  end


  def process_application_groups_v3(supergroups, timestamp)
    for group in supergroups.children.xpath('//group')
      app_group = group.xpath('//group/name')[0].children.to_s.gsub("\/", "_")
      i = 1
      for process in group.xpath('//group/processes/process').children.xpath('//process')
        output_process(process, app_group, i, timestamp)
        i = i + 1
      end
    end
  end

  def process_application_groups_v4(supergroups, timestamp)
    for group in supergroups.children.xpath('//supergroup')
      app_group = group.xpath('//supergroup/name')[0].children.to_s.gsub("\/", "_")
      app_queue = group.xpath('.//group/get_wait_list_size')[0].children.to_s
      app_capacity_used = group.xpath('//supergroup/capacity_used')[0].children.to_s
      processes_being_spawned = group.xpath('//supergroup/group/processes_being_spawned')[0].children.to_s
      output "#{config[:scheme]}.#{app_group}.queue", app_queue, timestamp
      output "#{config[:scheme]}.#{app_group}.processes", app_capacity_used, timestamp
      output "#{config[:scheme]}.#{app_group}.processes_being_spawned", processes_being_spawned, timestamp
      i = 1
      for process in group.xpath('//supergroup/group/processes').children.xpath('//process')
        output_process(process, app_group, i, timestamp)
        i = i + 1
      end
    end
  end

  def parser_main_v3(command_output, timestamp)
      processes = command_output.xpath('//count').children[0].to_s
      max_pool_size = command_output.xpath('//max').children[0].to_s
      top_level_queue = command_output.xpath('//global_queue_size').children[0].to_s
      return max_pool_size, processes, top_level_queue, timestamp
  end

  def parser_main_v4(command_output, timestamp)
      processes = command_output.xpath('//process_count').children[0].to_s
      max_pool_size = command_output.xpath('//max').children[0].to_s
      top_level_queue = command_output.xpath('//get_wait_list_size').children[0].to_s
      return max_pool_size, processes, top_level_queue, timestamp
  end

  def main_output(max_pool_size, processes, top_level_queue, timestamp)
      output "#{config[:scheme]}.max_pool_size", max_pool_size, timestamp
      output "#{config[:scheme]}.processes", processes, timestamp
      output "#{config[:scheme]}.top_level_queue", top_level_queue, timestamp
  end

  def run
    timestamp = Time.now.to_i
    passenger_version = `passenger -v|grep version|awk {'print $4'}`.to_f
    command_output = Nokogiri::XML.parse `passenger-status --show=xml`
    if command_output
      if passenger_version > 3
        main_output(*parser_main_v4(command_output, timestamp))
        process_application_groups_v4(command_output.xpath('//supergroups').xpath('//supergroup'), timestamp)
      else
        main_output(*parser_main_v3(command_output, timestamp))
        process_application_groups_v3(command_output.xpath('//groups').xpath('//group'), timestamp)
      end
    end
    ok
  end
end
