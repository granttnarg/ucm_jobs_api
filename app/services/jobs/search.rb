module Jobs
  module Search
    class Service
      def self.search(params)
        adapter = StandardAdapter.new
        adapter.search(params)
      end
    end

    # Follow Base Adaptor pattern as we extend search functionality in future
    class BaseAdapter
      def search(params)
        raise NotImplementedError, "#{self.class.name} must implement #search"
      end
    end

    class StandardAdapter < BaseAdapter
      def search(params)
        scope = Job.includes(:languages)

        if params[:title].present?
          scope = scope.where("title ILIKE ?", "%#{params[:title]}%")
        end

        if params[:language_codes].present?
          language_codes = Array(params[:language_codes])
          if language_codes.size == 1
            scope = scope.joins(:languages).where(languages: { code: language_codes.first })
          else
            language_ids = Language.where(code: language_codes).pluck(:id)
            scope = scope.where(
              "jobs.id IN (
                SELECT job_id FROM jobs_languages
                WHERE language_id IN (?)
                GROUP BY job_id
                HAVING COUNT(DISTINCT language_id) = ?
              )", language_ids, language_codes.size
            )
          end
        end

        scope
      end
    end
  end
end
