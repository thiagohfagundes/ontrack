module OnboardingsHelper
  def status_badge_class(status)
    case status.to_s.upcase
    when 'COMPLETED'
      'bg-green-100 text-green-800'
    when 'IN_PROGRESS', 'PENDING'
      'bg-yellow-100 text-amber-800'
    when 'OVERDUE'
      'bg-red-100 text-red-800'
    else
      'bg-slate-100 text-slate-700'
    end
  end

  def status_label(status)
    return 'Done' if status.to_s.upcase == 'COMPLETED'
    return 'In Progress' if status.to_s.upcase == 'IN_PROGRESS'
    return 'Overdue' if status.to_s.upcase == 'OVERDUE'
    status.to_s.titleize
  end

  def avatar_for(entity)
    # entity can be a Participant, User, Task.assignee...
    # Adjust: if you use ActiveStorage or gravatar, replace this with real implementation.
    if entity.respond_to?(:avatar_url) && entity.avatar_url.present?
      entity.avatar_url
    else
      "https://ui-avatars.com/api/?name=#{ERB::Util.url_encode([entity.try(:firstname), entity.try(:lastname)].compact.join(' '))}&background=DDDDDD&color=555555&size=128"
    end
  end

  def meeting_icon_svg(size: 18, classes: "inline-block mr-2")
    <<~SVG.html_safe
      <svg class="#{classes}" width="#{size}" height="#{size}" viewBox="0 0 24 24" fill="none"
           xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <path d="M7 11H13" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M7 16H13" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <rect x="3" y="4" width="18" height="18" rx="2" stroke="currentColor" stroke-width="1.5"/>
        <path d="M16 2V6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        <path d="M8 2V6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
      </svg>
    SVG
  end

  def email_svg_icon(classes: "w-5 h-5")
    <<~SVG.html_safe
      <svg class="#{classes}" viewBox="0 0 24 24" fill="none"
           xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <path d="M3 8.5v7c0 .83.67 1.5 1.5 1.5h15c.83 0 1.5-.67 1.5-1.5v-7"
              stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M21 8.5l-9 6-9-6"
              stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    SVG
  end
end
