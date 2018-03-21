# frozen_string_literal: true

require 'sinatra/base'

module Lambda
  # Helpers used for displaying errors in the HTML pages.
  module Helpers
    def lambda_to_html_row(lambda)
      <<~HEREDOC
        <tr id="#{lambda[:name]}">
          <td>#{lambda[:name]}</td>
          <td>#{lambda[:last_triggered] || 'N/A'}</td>
          <td>#{lambda[:created_at].strftime '%Y-%m-%d'}</td>
          <td>
            <i class="fas fa-trash-alt" onclick="deleteLambda('#{lambda[:name]}')"></i>
          </td>
        </tr>
      HEREDOC
    end

    Sinatra.helpers Lambda::Helpers
  end
end
