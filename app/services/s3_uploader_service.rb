class S3UploaderService
  require "aws-sdk-s3"

  def initialize(file, user_id)
    @file = file
    @user_id = user_id
    @s3_client = Aws::S3::Resource.new(
      region: ENV["AWS_REGION"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    )
  end

  def upload
    bucket = @s3_client.bucket(ENV["AWS_S3_BUCKET"])

    filename = "recipes/user_#{@user_id}/#{SecureRandom.uuid}_#{@file.original_filename}"

    obj = bucket.object(filename)
    obj.upload_file(@file.tempfile, acl: "public-read")

    # Return the public URL
    obj.public_url
  rescue Aws::S3::Errors::ServiceError => e
    Rails.logger.error "S3 Upload failed: #{e.message}"
    raise "File upload failed. Please check your AWS credentials and try again."
  end
end
