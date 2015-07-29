require 'pry'

require 'sinatra'
require 'slim'
require 'sinatra/activerecord'
require 'carrierwave'
require 'carrierwave/orm/activerecord'

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :thumb do
    process convert: :png
    process resize_to_fill: [200, 200]

    def full_filename(filename)
      "thumb_#{File.basename(filename, '.*')}.png"
    end
  end
end

ActiveRecord::Base.raise_in_transactional_callbacks = true

class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
end

get '/' do
  slim :index
end

post '/' do
  # uploader = AvatarUploader.new
  # uploader.store!(params[:avatar][:tempfile])

  user = User.new
  user.avatar = params[:avatar][:tempfile]
  user.save!

  redirect to('/')
end
