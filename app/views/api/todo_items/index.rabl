collection @todo_items
attributes :id, :name, :status, :is_deleted
child(:tags) { attributes :id, :name }