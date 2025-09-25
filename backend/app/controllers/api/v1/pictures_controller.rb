# app/controllers/api/v1/pictures_controller.rb
class API::V1::PicturesController < API::V1::BaseMediaController
  include Rails.application.routes.url_helpers

  def index
    pictures = Picture.all
    render json: pictures.map { |p| serialize_picture(p) }
  end

  def show
    picture = Picture.find(params[:id])
    render json: serialize_picture(picture)
  end

  def create
    picture = Picture.new(picture_params)
    if picture.save
      render json: serialize_picture(picture), status: :created
    else
      render json: { errors: picture.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def serialize_picture(p)
    p.as_json.merge(
      image_url: p.image.attached? ? url_for(p.image) : nil
    )
  end

  def picture_params
    params.require(:picture).permit(:post_id, :image)
  end
end
