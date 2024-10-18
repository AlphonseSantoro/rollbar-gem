module Rollbar
  class ErrorSubscriber
    def report(error, handled:, severity:, context:, source: nil)
      # The default `nil` for capture_uncaught means `true`. so check for false.
      return unless handled || Rollbar.configuration.capture_uncaught != false

      controller = context[:controller]
      scope = {
        person: controller.rollbar_person_data,
        request: controller.rollbar_request_data
      }
      Rollbar.scoped(scope) do
        extra = context.is_a?(Hash) ? context.deep_dup : {}
        extra[:custom_data_method_context] = source
        Rollbar.log(severity, error, extra)
      end
    end
  end
end
