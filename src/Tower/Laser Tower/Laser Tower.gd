extends Tower

func fire(target):
	target.queue_free()

func can_fire_at(body):
	return true
