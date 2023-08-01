class NestedSelectLocalizedInput < NestedSelectInput

  def level_options(data)
    @options.merge(class: 'nested-level-input').merge(data).merge(as: :nested_level_localized)
  end


end
