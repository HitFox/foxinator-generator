class Create<%= class_name.gsub('::','').pluralize %> < ActiveRecord::Migration

  def change
    create_table :<%= table_name %> do |t|
    <%- model_attrs.each do |attr| -%>
      t.<%= attr.type %> :<%= attr.name %>
    <%- end -%>
      t.timestamps
    end
  end

end
