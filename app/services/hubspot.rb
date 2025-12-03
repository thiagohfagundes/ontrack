require 'faraday'
require 'json'

class Hubspot
  API_BASE = "https://api.hubapi.com"

  # Default properties for each object in Hubspot

  TASKS_PROPERTIES = [
    "hs_task_body",                # Corpo/texto da tarefa
    "hs_timestamp",                # Data e hora programada da tarefa
    "hs_task_priority",            # Prioridade: HIGH, MEDIUM, LOW
    "hs_task_status",              # Status: NOT_STARTED, COMPLETED, etc.
    "hs_task_subject",            # Título/assunto da tarefa
    "hubspot_owner_id",           # ID do responsável pela tarefa
    "hs_note_body",               # Também armazena o corpo para atividades em geral
    "hs_createdate",              # Data de criação
    "hs_lastmodifieddate",        # Data da última modificação
    "hs_activity_type",           # Deve ser 'TASK' para esse tipo de objeto
    "hs_task_type",               # Tipo da tarefa (customizável, ex: FOLLOW_UP)
    "hs_task_reminders",          # Lembretes definidos
    "hs_task_completion_date",    # Data de conclusão
    "hs_task_due_date",           # Data de vencimento (se existir)
    "hs_task_associated_contacts",# Contatos relacionados
    "hs_task_associated_companies", # Empresas relacionadas
    "hs_task_associated_deals",   # Negócios relacionados
    "hs_task_associated_tickets", # Tickets relacionados
    "hs_object_id"                # ID da tarefa
  ]

  NOTES_PROPERTIES = [
    "hs_timestamp",         # Data/hora da criação da nota (posiciona na timeline do CRM)
    "hs_note_body",         # Conteúdo textual da nota (até 65.536 caracteres)
    "hubspot_owner_id",     # ID do proprietário (usuário que criou a nota no HubSpot)
    "hs_attachment_ids"     # IDs de anexos da nota (separados por ponto e vírgula)
  ]

  CONTACTS_PROPERTIES = [
    "firstname",                    # Primeiro nome do contato
    "lastname",                     # Sobrenome do contato
    "email",                        # E-mail principal
    "phone",                        # Telefone principal
    "company",                      # Nome da empresa (campo de texto livre)
    "jobtitle",                     # Cargo do contato
    "hs_lastmodifieddate"           # Data da última modificação no contato
  ]

  TICKETS_PROPERTIES = [
    "subject",
    'content',
    'hs_object_id',
    'hs_pipeline',
    'hs_pipeline_stage',
    "createdate",
    "closed_date",
    "hubspot_owner_id",
  ]

  MEETINGS_PROPERTIES = [
    "hs_meeting_title",             # Título da reunião
    "hs_meeting_body",              # Descrição ou pauta da reunião
    "hubspot_owner_id",             # ID do responsável pela reunião (usuário HubSpot)
    "hs_internal_meeting_notes",    # Notas internas (visíveis apenas internamente)
    "hs_meeting_external_url",      # Link externo da reunião (ex: Zoom, Meet)
    "hs_meeting_location",          # Local da reunião (físico ou virtual)
    "hs_meeting_start_time",        # Data e hora de início da reunião
    "hs_meeting_end_time",          # Data e hora de término da reunião
    "hs_meeting_outcome",           # Resultado da reunião (ex: "Completed", "Scheduled", etc.)
    "hs_activity_type",             # Tipo de atividade (deve ser "MEETING")
    "hs_attachment_ids"             # IDs de arquivos anexados à reunião
  ]

  EMAILS_PROPERTIES = [
    "hs_timestamp",               # Data/hora do e-mail (define a posição na timeline do CRM)
    "hubspot_owner_id",          # ID do proprietário do HubSpot (usuário associado ao e-mail)
    "hs_email_direction",        # Direção do e-mail (INCOMING_EMAIL, FORWARDED_EMAIL, etc.)
    "hs_email_html",             # Corpo do e-mail em HTML (se enviado do CRM)
    "hs_email_status",           # Status do envio (BOUNCED, FAILED, SCHEDULED, SENDING, SENT)
    "hs_email_subject",          # Assunto do e-mail
    "hs_email_text",             # Corpo do e-mail em texto simples
    "hs_attachment_ids",         # IDs dos anexos do e-mail (separados por ponto e vírgula)
    "hs_email_headers",          # Headers do e-mail (campos técnicos do e-mail)
    "hs_email_from_email",       # E-mail do remetente
    "hs_email_from_firstname",   # Primeiro nome do remetente
    "hs_email_from_lastname",    # Sobrenome do remetente
    "hs_email_to_email",         # E-mail(s) do(s) destinatário(s)
    "hs_email_to_firstname",   # Primeiro nome do(s) destinatário(s)
    "hs_email_to_lastname"       # Sobrenome do(s) destinatário(s)
  ]

  COMPANIES_PROPERTIES = [
    "hs_object_id",
    "name",
    "createdate",
    "domain",
    "hs_lastmodifieddate"
  ]

  def initialize(access_token)
    @access_token = access_token
    @tipo_pipeline = "tickets"
  end

  def connection
    Faraday.new(url: API_BASE) do |f|
      f.headers["Authorization"] = "Bearer #{@access_token}"
      f.headers["Content-Type"] = "application/json"
    end
  end

  def success?(response)
    response.status >= 200 && response.status < 300
  end

  def get(path, params = {})
    response = connection.get(path, params)

    unless success?(response)
      raise "Erro na requisição: #{response.status} - #{response.body}"
    end

    JSON.parse(response.body)
  end

  def test_connection
    response = get("/account-info/v3/details")
    puts "Sucesso na conexão"
  end

  def batch_read_objects(object_type, ids, properties: [])
    raise ArgumentError, "ids must be an Array" unless ids.is_a?(Array)
    return [] if ids.empty?

    results = []
    # HubSpot limita 100 inputs por batch
    ids.each_slice(100) do |slice|
      body = { "inputs" => slice.map { |i| { "id" => i.to_s } } }
      body["properties"] = properties if properties.any?

      resp = connection.post("/crm/v3/objects/#{object_type}/batch/read") do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = JSON.generate(body)
      end

      # tratamento básico de status
      unless resp.status.between?(200, 299)
        raise "Batch read failed (#{resp.status}): #{resp.body}"
      end

      parsed = JSON.parse(resp.body)
      # a resposta tem geralmente uma chave "results" com os objetos
      results.concat(parsed.fetch("results", []))
    end

    results
  end

  def get_owners
    all_owners = []

    response = get("/crm/v3/owners")
    all_owners.concat(response.fetch("results", []))

    while response['paging']
      response = get("/crm/v3/owners", { after: response['paging']['next']['after'] })
      all_owners.concat(response.fetch("results", []))
    end

    all_owners
  end

  def get_pipelines
    response = get("/crm/v3/pipelines/#{@tipo_pipeline}")
  end

  def get_pipeline_details(id)
    response = get("/crm/v3/pipelines/tickets/#{id}")
  end

  def get_pipeline_stages(pipeline_id)
    stages = get_pipeline_details(pipeline_id).fetch('stages', [])
  end

  def get_pipeline_closed_stages(pipeline_id)
    closed_stages = get_pipeline_stages(pipeline_id).select do |stage|
      stage.dig("metadata", "isClosed") == "true"
    end
  end

  def get_object_details(id, properties = TICKETS_PROPERTIES)
    response = get("/crm/v3/objects/#{@tipo_pipeline}/#{id}", { properties: properties }).fetch("properties", [])
  end

  def get_ongoing_onboardings(pipeline_id)
    closed_stages = get_pipeline_closed_stages(pipeline_id)
    closed_stages_ids = closed_stages.map {|stage| stage['id']}

    body = {
      "limit": 100,
      "properties": TICKETS_PROPERTIES,
      "filterGroups": [
        {
          "filters": [
            {
              "propertyName": "hs_pipeline",
              "operator": "EQ",
              "value": pipeline_id
            },
            {
              "propertyName": "hs_pipeline_stage",
              "operator": "NOT_IN",
              "values": closed_stages_ids
            }
          ]
        }
      ]
    }

    all_onboardings = []

    loop do
      response = connection.post("/crm/v3/objects/#{@tipo_pipeline}/search") do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = JSON.generate(body)
      end

      unless response.status.between?(200, 299)
        raise "Search failed (#{response.status}): #{response.body}"
      end

      results = JSON.parse(response.body)

      all_onboardings.concat(results.fetch("results", []))

      break unless results["paging"]&.dig("next", "after")
      body[:after] = results["paging"]["next"]["after"]
    end

    all_onboardings.map {|onboarding| onboarding['properties']}
  end

  def get_associated_objects(object_id, associated_objects_type, properties = [])
    response = get("/crm/v3/objects/#{@tipo_pipeline}/#{object_id}/associations/#{associated_objects_type}")
    results = response.fetch("results", [])
    ids = results.map { |result| result["id"] }
    
    associated_objects = batch_read_objects(associated_objects_type, ids, properties: properties)
  end

  # Functions for getting all the interesting associated objects from the main object in Hubspot

  def get_associated_companies(object_id, properties = COMPANIES_PROPERTIES)
    response = get_associated_objects(object_id, "companies", properties).map {|company| company['properties']}
  end

  def get_associated_contacts(object_id, properties = CONTACTS_PROPERTIES)
    response = get_associated_objects(object_id, "contacts", properties).map {|contact| contact['properties'] }
  end

  def get_associated_meetings(object_id, properties = MEETINGS_PROPERTIES)
    response = get_associated_objects(object_id, "meetings", properties).map {|meeting| meeting['properties'] }
  end

  def get_associated_tasks(object_id, properties = TASKS_PROPERTIES)
    response = get_associated_objects(object_id, "tasks", properties).map {|task| task['properties'] }
  end

  def get_associated_notes(object_id, properties = NOTES_PROPERTIES)
    response = get_associated_objects(object_id, "notes", properties).map {|note| note['properties']}
  end

  def get_associated_emails(object_id, properties = EMAILS_PROPERTIES)
    response = get_associated_objects(object_id, "emails", properties).map {|email| email['properties']}
  end

  def catch_all_ticket_items(hubspot_id)
    {
      details: get_object_details(hubspot_id),
      companies: get_associated_companies(hubspot_id),
      tasks: get_associated_tasks(hubspot_id),
      emails: get_associated_emails(hubspot_id),
      participants: get_associated_contacts(hubspot_id),
      notes: get_associated_notes(hubspot_id),
      meetings: get_associated_meetings(hubspot_id)
    }
  end
end