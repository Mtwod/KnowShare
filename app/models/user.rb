class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username,  presence: true,
                        uniqueness: true

  has_many  :lessons, dependent: :destroy
  has_many  :bookings, dependent: :destroy
  has_many  :followed_lessons,
            through: :bookings,
            foreign_key: 'followed_lesson_id',
            class_name: 'Lesson',
            dependent: :destroy

  has_one_attached :avatar

  before_create :assign_student_role, :assign_default_credit
  after_create :send_welcome_email

  def role_include?(searched_role)
    role.split.include?(searched_role)
  end

  def student?
    role_include?('student')
  end

  def teacher?
    role_include?('teacher')
  end

  def assign_teacher_role
    new_role = role + ' ' + 'teacher'
    update(role: new_role)
  end

  def has_first_name?
    first_name
  end

  def has_last_name?
    last_name
  end

  def has_description?
    description
  end 
  
  def add_credit(number_of_credit)
    new_personal_credit = personal_credit + number_of_credit
    update(personal_credit: new_personal_credit)
  end

  def remove_credit(number_of_credit)
    new_personal_credit = personal_credit - number_of_credit
    update(personal_credit: new_personal_credit)
  end

  def past_bookings
    bookings.select { |booking| booking.start_date < DateTime.now }
  end

  def future_bookings
    bookings.select { |booking| booking.start_date > DateTime.now }
  end

  def past_lessons
    past_lessons = Array.new
    past_bookings.each { |booking| past_lessons << booking.followed_lesson } 
    past_lessons 
  end

  def future_lessons
    future_lessons = Array.new
    future_bookings.each { |booking| future_lessons << booking.followed_lesson } 
    future_lessons 
  end
  
  private

  def assign_student_role
    self.role = 'student'
  end

  def assign_default_credit
    default_given_credit = 4
    self.personal_credit = default_given_credit
  end

  def send_welcome_email
    UserMailer.welcome_send(self).deliver_now
  end
end
