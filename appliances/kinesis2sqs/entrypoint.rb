require 'aws-sdk-kinesis'
require 'aws-sdk-sqs'

puts 'Starting kinesis2sqs'

sleep ENV.fetch('SLEEP_LENGTH', 0).to_i
request_delay = ENV.fetch('REQUEST_DELAY', 2).to_i

aws_config = {
  region: ENV.fetch('AWS_REGION'),
  access_key_id: ENV.fetch('AWS_ACCESS_KEY'),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
}

def get_shard_iterator(kinesis:, **opts)
  opts = {
    stream_name: ENV.fetch('AWS_KINESIS_STREAM_NAME'),
    shard_id: ENV.fetch('AWS_KINESIS_SHARD_ID', 'shardId-000000000000'),
    shard_iterator_type: ENV.fetch('AWS_KINESIS_SHARD_ITERATOR_TYPE', 'LATEST')
  }.merge(opts)

  kinesis.get_shard_iterator(opts).shard_iterator
end

sqs = Aws::SQS::Client.new(
  aws_config.merge endpoint: ENV.fetch('AWS_SQS_ENDPOINT')
)

sqs_queue_url = sqs.get_queue_url(
  queue_name: ENV.fetch('AWS_SQS_QUEUE_NAME')
).queue_url

kinesis = Aws::Kinesis::Client.new(
  aws_config.merge endpoint: ENV.fetch('AWS_KINESIS_ENDPOINT')
)

shard_iterator = get_shard_iterator(kinesis: kinesis)
last_seq_num = nil

def clean(value)
  if value.class == Hash
    Hash[value.map { |k, v| [k, clean(v)] }].reject do |_, entry|
      entry.nil?
    end
  else
    value
  end
end

while shard_iterator
  begin
    response = kinesis.get_records(
      shard_iterator: shard_iterator
    )

    response.records.each do |record|
      message = record.data
      attrs = {}
      json = JSON.parse(message)
      json = clean(json)
      if json['attributes']
        # transform message to match behavior of Live Events Publisher
        json['metadata'] = json.delete('attributes')
        message = JSON.generate(json)
        attrs = Hash[json['metadata'].map { |k, v| [k, { string_value: v, data_type: 'String' }] }]
      end
      sqs.send_message(
        queue_url: sqs_queue_url,
        message_attributes: attrs,
        message_body: message
      )
      last_seq_num = record.sequence_number
    end

    shard_iterator = response.next_shard_iterator
    sleep request_delay
  rescue Aws::Kinesis::Errors::InvalidArgumentException
    shard_iterator = get_shard_iterator(
      kinesis: kinesis,
      shard_iterator_type: 'AFTER_SEQUENCE_NUMBER',
      starting_sequence_number: last_seq_num
    )
  end
end
