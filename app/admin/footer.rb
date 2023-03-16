module ActiveAdmin
  module Views
    class Footer < Component

      def build(namespace)
        super :id => "footer"

        para I18n.t('active_admin.powered_by',
                    active_admin: link_to("Kapusons srl", "http://kapusons.it", target: '_blank'),
                    version: '').html_safe
      end

    end
  end
end