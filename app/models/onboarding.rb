class Onboarding < ApplicationRecord
  belongs_to :user
  after_commit :hubspot_caching, on: :create
  has_many :tasks, dependent: :destroy
  has_many :completed_tasks, -> { where(status: 'COMPLETED') }, class_name: 'Task'
  has_many :pending_tasks, -> { where.not(status: 'COMPLETED') }, class_name: 'Task'
  has_many :overdue_tasks, -> { where("due_date < ? AND status != ?", Date.today, 'COMPLETED') }, class_name: 'Task'
  has_many :upcoming_tasks, -> { where("due_date >= ? AND status != ?", Date.today, 'COMPLETED') }, class_name: 'Task'
  has_many :today_tasks, -> { where(due_date: Date.today, status: 'PENDING') }, class_name: 'Task'
  has_many :participants, dependent: :destroy
  has_many :meetings, dependent: :destroy
  has_one :latest_meeting, -> { order(start_time: :desc) }, class_name: 'Meeting'
  has_one :next_meeting, -> { where("start_time >= ?", Time.current).order(start_time: :asc) }, class_name: 'Meeting'
  has_one :last_meeting, -> { where("start_time < ?", Time.current).order(start_time: :desc) }, class_name: 'Meeting'
  has_many :emails, dependent: :destroy
  has_one :latest_email, -> { order(timestamp: :desc) }, class_name: 'Email'

  def progress_percentage
    total_tasks = tasks.count
    return 0 if total_tasks.zero?
    total = (completed_tasks.count.to_f / total_tasks * 100).round
    if total == 100 && !closed
      99
    else
      total
    end
  end

  def meetings_percentage
    total_meetings = meetings.count
    return 0 if total_meetings.zero?
    percentage = (total_meetings * 100 / meetings_limit).round
    if percentage > 100
      100
    else
      percentage
    end
  end

  def overdue?
    overdue_tasks.exists?
  end

  def days_in_progress
    if start_date.present? && end_date.present?
      (end_date.to_date - start_date.to_date).to_i
    elsif start_date.present?
      (Date.current - start_date.to_date).to_i
    else
      0
    end
  end

  private
  def hubspot_caching
    if hubspot_id.present?
      hubspot = Hubspot.new(ENV['HUBSPOT_API_KEY'])

      tarefas = hubspot.get_associated_tasks(hubspot_id)
      participantes = hubspot.get_associated_contacts(hubspot_id)
      reunioes = hubspot.get_associated_meetings(hubspot_id)
      emails_trocados = hubspot.get_associated_emails(hubspot_id)

      tarefas.each do |task|
        tasks.create(
          subject: task["hs_task_subject"],
          body: task["hs_task_body"],
          status: task["hs_task_status"],
          due_date: task["hs_task_due_date"]&.to_date,
          completion_date: task["hs_task_completion_date"]&.to_date,
          onboarding_id: id,
          hubspot_id: task["hs_object_id"]
        )
      end

      participantes.each do |participant|
        participants.create(
          firstname: participant["firstname"],
          lastname: participant["lastname"],
          email: participant["email"],
          phone: participant["phone"],
          jobtitle: participant["jobtitle"],
          onboarding_id: id,
          hubspot_id: participant["hs_object_id"]
        )
      end

      reunioes.each do |meeting|
        meetings.create(
          title: meeting["hs_meeting_title"],
          body: meeting["hs_meeting_body"],
          start_time: meeting["hs_meeting_start_time"]&.to_datetime,
          end_time: meeting["hs_meeting_end_time"]&.to_datetime,
          outcome: meeting["hs_meeting_outcome"],
          internal_notes: meeting["hs_meeting_internal_notes"],
          onboarding_id: id,
          hubspot_id: meeting["hs_object_id"]
        )
      end

      emails_trocados.each do |email|
        emails.create(
          from_email: email["hs_email_from_email"],
          to_email: email["hs_email_to_email"],
          subject: email["hs_email_subject"],
          body_text: email["hs_email_text_body"],
          body_html: email["hs_email_html_body"],
          email_status: email["hs_email_status"],
          email_direction: email["hs_email_direction"],
          timestamp: email["hs_timestamp"]&.to_datetime,
          onboarding_id: id,
        )

      update(
        hubspot_synced_at: Time.current
      )
      #falta a lógica para atrelar as empresas
      end
    end
  end
end