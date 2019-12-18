require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'sampleapp21'
    config.asset_host = 'https://s3.amazonaws.com/sampleapp21' #url間違い
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => 'ap-northeast-1' ,
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY'],
      path_style: true
    }
  end
end