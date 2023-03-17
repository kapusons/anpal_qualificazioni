ActiveAdmin.register Application do

  permit_params translations_attributes: [ :id, :locale, :title, :description ]

  form do |f|
    f.inputs do
      f.translate_inputs do |t|
        t.input :title
        t.input :description, as: :action_text
      end
    end
    f.actions
  end
  
end
