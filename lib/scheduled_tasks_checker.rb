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

      issue.subject.gsub!('**DATE**', Time.now.strftime("%d"))
      issue.subject.gsub!('**WEEK**', Time.now.strftime("%W"))
      issue.subject.gsub!('**MONTH**', Time.now.strftime("%m"))
      issue.subject.gsub!('**MONTHNAME**', I18n.localize(Time.now, :format => "%B"))
      issue.subject.gsub!('**YEAR**', Time.now.strftime("%Y"))
      issue.subject.gsub!('**PREVIOUS_MONTHNAME**', I18n.localize(Time.now - 2592000, :format => "%B"))

      issue.description.gsub!('**DATE**', Time.now.strftime("%d"))
      issue.description.gsub!('**WEEK**', Time.now.strftime("%W"))
      issue.description.gsub!('**MONTH**', Time.now.strftime("%m"))
      issue.description.gsub!('**MONTHNAME**', I18n.localize(Time.now, :format => "%B"))
      issue.description.gsub!('**YEAR**', Time.now.strftime("%Y"))
      issue.description.gsub!('**PREVIOUS_MONTHNAME**', I18n.localize(Time.now - 2592000, :format => "%B"))

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
