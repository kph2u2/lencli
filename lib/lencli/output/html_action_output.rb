require "lencli/output/base_output_service"
require "erb"

module LenCLI
  class HtmlActionOutput < BaseOutputService
    def output
      template.result(binding)
    end

    private

    def massage_column_value(value)
      value && value.length ? value : "N/A"
    end

    def template
      @template ||= ERB.new <<~OUTPUT
        <style>
          table {
            border-collapse: collapse;
            min-width: 615px;
          }

          table th, 
          table td, 
          table th:last-child,
          table td:last-child {
            border: 1px solid #e1edff;
            padding: 7px 17px;
          }
          table caption {
            margin: 7px;
          }

          /* Table Header */
          table thead th {
            background-color: #508abb;
            color: #FFFFFF;
            border-color: #6ea1cc !important;
            text-transform: uppercase;
          }

          /* Table Body */
          table tbody td {
            color: #353535;
          }
          table tbody td:nth-child(4) {
            text-align: right;
          }
          table tbody td:last-child {
            text-align: right;
          }
          table tbody tr:nth-child(odd) td {
            background-color: #f4fbff;
          }
          table tbody tr:hover td {
            background-color: #ffffa2;
            border-color: #ffff0f;
          }

          /* Table Footer */
          table tfoot th {
            background-color: #e5f5ff;
            text-align: right;
          }
          table tfoot th:first-child {
            text-align: left;
          }
          table tbody td:empty
          {
            background-color: #ffcccc;
          }
        </style>

        <table>
          <caption>
            Geolocation Data compiled at <%=Time.now.strftime "%Y-%m-%d %H:%M"%>
          </caption>
          <thead>
            <tr>
              <% @action.headers.each do |header_value| %>
                <th><%= header_value %></th>
              <% end %>
            </tr>
          </thead>
          <tbody>
            <% @action.results.each do |row| %>
              <tr>
                <% row.each do |column_value| %>
                  <td><%= massage_column_value(column_value) %></td>
                <% end %>
              </tr>
            <% end %>
          <tbody>
        </table>
      OUTPUT
    end
  end
end
