# name: custom-post-fields
# about: 
# version: 0.1
# authors: 
# url: 

enabled_site_setting :custom_fields_enabled
PLUGIN_NAME ||= "custom_fields".freeze


after_initialize do


  module ::CustomFields
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace CustomFields
    end
  end

  # Overwriting create_params methods in Posts Controller to permit custom_fields
  PostsController.class_eval do
    alias_method :old_create_params, :create_params
    def create_params
      result = old_create_params
      result.merge(params.permit(custom_fields: SiteSetting.custom_fields.split('|')))
    end
  end


  #Post.register_custom_field_type(CUSTOM_FIELD, :string)

  TopicView.add_post_custom_fields_whitelister do |user|
    whitelisted = SiteSetting.custom_fields.split('|')
    whitelisted
  end

  SiteSetting.custom_fields.split("|").each do |field|
    add_to_serializer(:post, field.to_sym, false) { post_custom_fields[field] }
    add_to_serializer(:post, "include_#{field}?".to_sym) { post_custom_fields.present? && post_custom_fields[field].present? }
  end


  # Add meta-data to serializers
  TopicViewSerializer.attributes_from_topic([:meta_data])
  

  add_to_serializer(:topic_list_item, :meta_data, false) { object.meta_data }
  add_to_serializer(:topic_list_item, :include_meta_data?) { object.meta_data.present? }


  
end
