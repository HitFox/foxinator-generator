require 'rails_helper'

feature '<%=class_name.underscore.singularize.humanize%>', :integration do

  fixtures :permissions 
  fixtures :roles
  fixtures :admins
  
  before :each do
    login_super_admin
  end

  feature 'The <%=class_name.underscore.singularize.humanize.downcase%> index feature' do

    let!(:resource) { create(:<%=class_name.underscore.downcase.singularize%>) }
    let(:expected_text) { [] }
    let(:path) { admin_<%=class_name.underscore.downcase.pluralize%>_path(locale: :en) }

    it_behaves_like "an index feature"
  end

  feature 'The <%=class_name.underscore.singularize.humanize.downcase%> create feature' do

    let(:fill_ins) { {} }
    let(:selects) { {} }
    let(:checkboxes) { [] }
    let(:expected_text) { [] }
    let(:path) { new_admin_<%=class_name.underscore.downcase.singularize%>_path(locale: :en) }

    it_behaves_like "a create feature", <%=class_name.singularize%>
  end

  feature 'The <%=class_name.underscore.singularize.humanize.downcase%> update feature' do

    let!(:resource) { create(:<%=class_name.underscore.downcase.singularize%>) }
    let(:fill_ins) { {} }
    let(:selects) { {} }
    let(:expected_text) { [] }
    let(:expected_input_values) { [] }
    let(:path) { edit_admin_<%=class_name.underscore.downcase.singularize%>_path(resource, locale: :en) }

    it_behaves_like "an update feature", <%=class_name.singularize%>
  end

  feature 'The <%=class_name.underscore.singularize.humanize.downcase%> destroy feature' do

    let!(:resource) { create(:<%=class_name.underscore.downcase.singularize%>) }
    let(:index_path) { admin_<%=class_name.underscore.downcase.pluralize%>_path(locale: :en) }
    let(:delete_path) { admin_<%=class_name.underscore.downcase.singularize%>_path(resource, locale: :en) }

    it_behaves_like "a destroy feature", <%=class_name.singularize%>
  end
end
