object @todo_item
attributes :id, :name, :status
child :tags do 
    attributes :name
end