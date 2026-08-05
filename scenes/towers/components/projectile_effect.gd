extends GPUParticles3D
class_name ProjectileEffect

func set_projectile_velocity(velocity: Vector3):
	var mat = self.process_material as ParticleProcessMaterial
	mat.direction = velocity.normalized()
	mat.initial_velocity_min = velocity.length()
	mat.initial_velocity_max = velocity.length()
