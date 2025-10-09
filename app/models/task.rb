# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: { message: 'を入力してください' }
  validates :title, length: { maximum: 100, message: '100文字以内で入力してください' }
  validates :content, presence: { message: 'を入力してください' }
  validates :content, length: { maximum: 1000 }
  validates :deadline, presence: { message: 'を選択してください' }

  # Rails 7.1 enum syntax
  enum status: { not_started: 0, in_progress: 1, completed: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }
end
