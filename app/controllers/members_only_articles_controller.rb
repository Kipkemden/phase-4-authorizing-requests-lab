class MembersOnlyArticlesController < ApplicationController
  before_action :authorize_user
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])

    if article.is_member_only?
      render json: article
    else
      render json: { error: "Article is not member-only" }, status: :unprocessable_entity
    end
  end

  private

  def authorize_user
    return if current_user.present?

    render json: { error: "Not authorized" }, status: :unauthorized
  end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end
end
