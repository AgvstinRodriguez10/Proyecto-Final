shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

// === TEXTURAS ===
uniform sampler2D albedo_texture : source_color;
uniform sampler2D normal_texture : hint_normal;
uniform sampler2D orm_texture; // R=AO, G=Roughness, B=Metallic

// === COLORES / PROPIEDADES ===
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform float metallic = 0.7;
uniform float roughness = 0.1;
uniform float specular = 0.5;

// === ANIMACIÓN ===
uniform float amplitude = 0.03;
uniform float speed = 2.0;
uniform float phase_offset = 0.0;

void vertex() {
	// animación SOLO hacia arriba y vuelve al origen
	float t = (sin(TIME * speed + phase_offset) + 1.0) * 0.5; // 0..1
	VERTEX.y += t * amplitude;
}

void fragment() {
	vec3 albedo_tex = texture(albedo_texture, UV).rgb;
	ALBEDO = albedo_tex * albedo_color.rgb;

	vec3 orm = texture(orm_texture, UV).rgb;
	AO = orm.r;
	ROUGHNESS = orm.g * roughness;
	METALLIC = orm.b * metallic;

	NORMAL_MAP = texture(normal_texture, UV).rgb;
	SPECULAR = specular;
}
