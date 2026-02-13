shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled;
uniform float mote_time_scale = 0.25; // ↓ tiempo = movimiento más lento

// ===== COLOR Y FUERZA =====
uniform vec3 light_color = vec3(1.0, 0.85, 0.6);
uniform float intensity = 0.45;
uniform float alpha_strength = 0.14;

// ===== ALTURA TOTAL =====
uniform float light_height = 2.0;

// ===== CONO =====
uniform float cone_angle = 1.0;
uniform float cone_softness = 1.6;

// ===== FADE =====
uniform float fade_power = 2.0;

// ===== MOTAS DE LUZ =====
uniform float mote_density = 12.0;     // cantidad
uniform float mote_size = 0.08;        // tamaño
uniform float mote_speed = 0.4;        // velocidad
uniform float mote_intensity = 1.8;    // brillo

varying vec3 v_local_pos;

// -------------------------
// HASH SIMPLE
// -------------------------
float hash(vec3 p) {
    return fract(sin(dot(p, vec3(12.9898,78.233,45.164))) * 43758.5453);
}

void vertex() {
    v_local_pos = VERTEX;
}

void fragment() {

    // =========================
    // POSICIÓN NORMALIZADA
    // =========================
    float y = v_local_pos.y / (light_height * 1.5);
    float radial = length(v_local_pos.xz);

    // =========================
    // CONO ARRIBA
    // =========================
    float up = clamp(y, 0.0, 1.0);
    float up_radius = up * cone_angle;
    float cone_up = 1.0 - smoothstep(
        up_radius,
        up_radius * cone_softness,
        radial
    );
    float fade_up = pow(1.5 - up, fade_power);
    cone_up *= fade_up;

    // =========================
    // CONO ABAJO
    // =========================
    float down = clamp(-y, 0.0, 1.0);
    float down_radius = down * cone_angle;
    float cone_down = 1.0 - smoothstep(
        down_radius,
        down_radius * cone_softness,
        radial
    );
    float fade_down = pow(1.5 - down, fade_power);
    cone_down *= fade_down;

    float cone_light = max(cone_up, cone_down);

// =========================
// MOTAS DE LUZ ORGÁNICAS
// =========================
vec2 uv = UV;
float t = TIME * mote_time_scale;

// Movimiento base vertical
uv.y += t * mote_speed;

// Ruido para desordenar el movimiento
float n1 = hash(vec3(uv * 3.0, floor(t)));
float n2 = hash(vec3(uv * 7.0, floor(t + 10.0)));


uv += vec2(
    sin(t + n1 * 6.28),
    cos(t * 0.7 + n2 * 6.28)
) * 0.08;

// Celdas grandes → pocas motas
vec2 cell = floor(uv * mote_density);
vec2 local = fract(uv * mote_density) - 0.5;

float rnd = hash(vec3(cell, 1.0));
float dist = length(local);

// Mota suave y grande
float mote = smoothstep(
    mote_size,
    mote_size * 0.25,
    dist
);

// Aparición aleatoria (no todas las celdas tienen mota)
float spawn = step(0.75, rnd);
mote *= spawn;

// Parpadeo irregular
float flicker = 0.6 + 0.4 * sin(t * 0.8 + rnd * 10.0);
mote *= flicker;

// Respetar el cono
mote *= cone_light;

    // =========================
    // COMBINACIÓN FINAL
    // =========================
    float final_light = cone_light + mote * mote_intensity;

    ALBEDO = light_color * final_light * intensity;
    ALPHA  = final_light * alpha_strength;
}
