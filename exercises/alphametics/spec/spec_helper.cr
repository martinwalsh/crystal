macro bonus(*args, &block)
  pending({{ *args }}) do
    {{ block.body }}
  end
end
