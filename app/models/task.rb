# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: { message: 'を入力してください' }
  validates :title, length: { maximum: 100, message: '100文字以内で入力してください' }
  validates :content, presence: { message: 'を入力してください' }
  validates :content, length: { maximum: 1000 }
  validates :deadline, presence: { message: 'を選択してください' }
  enum :status, {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }
  scope :completed, -> { where(completed: true) }
  scope :incomplated, -> { where(completed: false) }
end
