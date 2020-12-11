class LessonSearchesController < ApplicationController
  before_action :searched_lessons
  def index
  end

  private

  def searched_lessons
    @searched_lessons = Lesson.all.sort.reverse.select { |lesson| lesson.title.downcase.include?(params[:search_input].downcase) }
    @searched_lessons
  end
end
