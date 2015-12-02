class ScheduledTasksChecker
  def self.checktasks!
    Periodictask.where("next_run_date <= ? ", Time.now).each do |task| 

      # replace variables (set locale from shell)
      I18n.locale = ENV['LOCALE'] || I18n.default_locale

      issue = Issue.new(
                        :project_id=>task.project_id,
                        :tracker_id=>task.tracker_id,
                        :category_id=>task.issue_category_id,
                        :assigned_to_id=>task.assigned_to_id,
                        :author_id=>task.author_id,
                        :subject=>task.subject,
                        :description=>task.description
      );

      issue.subject.gsub!('**DATE**',               I18n.localize(Time.now,                      :format => "%-d"))
      issue.subject.gsub!('**PREV_DATE**',          I18n.localize(Time.now.yesterday,            :format => "%-d"))
      issue.subject.gsub!('**NEXT_DATE**',          I18n.localize(Time.now.tomorrow,             :format => "%-d"))
      issue.subject.gsub!('**WEEK**',               I18n.localize(Time.now,                      :format => "%-W"))
      issue.subject.gsub!('**PREV_WEEK**',          I18n.localize(Time.now.prev_week,            :format => "%-W"))
      issue.subject.gsub!('**NEXT_WEEK**',          I18n.localize(Time.now.next_week,            :format => "%-W"))
      issue.subject.gsub!('**MONTH**',              I18n.localize(Time.now,                      :format => "%-m"))
      issue.subject.gsub!('**PREV_MONTH**',         I18n.localize(Time.now.prev_month,           :format => "%-m"))
      issue.subject.gsub!('**NEXT_MONTH**',         I18n.localize(Time.now.next_month,           :format => "%-m"))
      issue.subject.gsub!('**MONTHNAME**',          I18n.localize(Time.now,                      :format => "%-B"))
      issue.subject.gsub!('**PREV_MONTHNAME**',     I18n.localize(Time.now.prev_month,           :format => "%-B"))
      issue.subject.gsub!('**NEXT_MONTHNAME**',     I18n.localize(Time.now.next_month,           :format => "%-B"))
      issue.subject.gsub!('**YEAR**',               I18n.localize(Time.now,                      :format => "%-Y"))
      issue.subject.gsub!('**NEXT_YEAR**',          I18n.localize(Time.now.next_year,            :format => "%-Y"))
      issue.subject.gsub!('**PREV_YEAR**',          I18n.localize(Time.now.prev_year,            :format => "%-Y"))

      issue.description.gsub!('**DATE**',           I18n.localize(Time.now,                      :format => "%-d"))
      issue.description.gsub!('**PREV_DATE**',      I18n.localize(Time.now.yesterday,            :format => "%-d"))
      issue.description.gsub!('**NEXT_DATE**',      I18n.localize(Time.now.tomorrow,             :format => "%-d"))
      issue.description.gsub!('**WEEK**',           I18n.localize(Time.now,                      :format => "%-W"))
      issue.description.gsub!('**PREV_WEEK**',      I18n.localize(Time.now.prev_week,            :format => "%-W"))
      issue.description.gsub!('**NEXT_WEEK**',      I18n.localize(Time.now.next_week,            :format => "%-W"))
      issue.description.gsub!('**MONTH**',          I18n.localize(Time.now,                      :format => "%-m"))
      issue.description.gsub!('**PREV_MONTH**',     I18n.localize(Time.now.prev_month,           :format => "%-m"))
      issue.description.gsub!('**NEXT_MONTH**',     I18n.localize(Time.now.next_month,           :format => "%-m"))
      issue.description.gsub!('**MONTHNAME**',      I18n.localize(Time.now,                      :format => "%-B"))
      issue.description.gsub!('**PREV_MONTHNAME**', I18n.localize(Time.now.prev_month,           :format => "%-B"))
      issue.description.gsub!('**NEXT_MONTHNAME**', I18n.localize(Time.now.next_month,           :format => "%-B"))
      issue.description.gsub!('**YEAR**',           I18n.localize(Time.now,                      :format => "%-Y"))
      issue.description.gsub!('**NEXT_YEAR**',      I18n.localize(Time.now.next_year,            :format => "%-Y"))
      issue.description.gsub!('**PREV_YEAR**',      I18n.localize(Time.now.prev_year,            :format => "%-Y"))

      issue.start_date ||= Date.today if task.set_start_date?

      if task.due_date_number
        due_date = task.due_date_number
        due_date_units = task.due_date_units
        issue.due_date = due_date.send(due_date_units.downcase).from_now
      end

      print "assigning #{issue.subject}\n"
      issue.save

      interval = task.interval_number
      units = task.interval_units
      interval_steps = ((Time.now - task.next_run_date) / interval.send(units.downcase)).ceil

      task.next_run_date += (interval * interval_steps).send(units.downcase)

      print "next #{task.next_run_date}\n"
      task.save

    end

  end
end
