if Rails.env.production?
  require 'carrierwave/storage/abstract'
  require 'carrierwave/storage/file'
  require 'carrierwave/storage/fog'
  
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => ENV['S3_REGION'],     # 例: 'ap-northeast-1'
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory  = 'sampleapp21'
    config.asset_host = 'https://s3-ap-northeast1.amazonaws.com/sampleapp21' #url間違い
    config.asset_host = 'https://sampleapp21.s3.amazonaws.com' #このように修正
  end
end