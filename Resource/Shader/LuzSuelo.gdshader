shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled;

// =================================================
// COLOR Y FUERZA
// =================================================
uniform vec3 light_color : source_color = vec3(1.0, 0.9, 0.75);
uniform float intensity = 1.2;
uniform float alpha_strength = 0.45;

// =================================================
// CÍRCULO DE LUZ (XZ)
// =================================================
uniform float radius = 1.25;
uniform float softness = 0.7;

// =================================================
// POSICIÓN DEL CÍRCULO (LOCAL)
// =================================================
uniform vec3 light_offset = vec3(0.0, 0.0, 0.0);

// =================================================
// POLVO DE LUZ (PARTÍCULAS)
// =================================================
uniform float dust_density = 14.0;     // cuántas partículas
uniform float dust_size = 0.04;        // tamaño de cada mota
uniform float dust_speed = 0.25;       // velocidad general
uniform float dust_intensity = 0.35;

varying vec3 v_local_pos;

// =================================================
// HASH RANDOM ESTABLE
// =================================================
float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// =================================================
// RUIDO SUAVE PARA MOVIMIENTO
// =================================================
vec2 drift(vec2 p, float t) {
    return vec2(
        sin(t + p.y * 6.0),
        cos(t * 1.3 + p.x * 6.0)
    );
}

void vertex() {
    v_local_pos = VERTEX;
}

void fragment() {

    // =================================================
    // POSICIÓN EN EL SUELO
    // =================================================
    vec2 pos = v_local_pos.xz - light_offset.xz;
    float dist = length(pos);

    // =================================================
    // CÍRCULO DE LUZ
    // =================================================
    float circle = 1.0 - smoothstep(
        radius,
        radius + softness,
        dist
    );

    // =================================================
    // ESPACIO DE PARTÍCULAS
    // =================================================
    vec2 uv = pos * dust_density;

    // Tiempo suavizado
    float t = TIME * dust_speed;

    // Offset aleatorio suave (browniano)
    uv += drift(uv, t) * 0.15;

    // Celda y posición local
    vec2 cell = floor(uv);
    vec2 local = fract(uv) - 0.5;

    // Random por partícula
    float rnd = hash21(cell);

    // Cada partícula se mueve un poco distinto
    local += vec2(
        sin(t + rnd * 6.28),
        cos(t * 0.8 + rnd * 6.28)
    ) * 0.15;

    float d = length(local);

    // Partícula pequeña y suave
    float dust = smoothstep(
        dust_size,
        dust_size * 0.3,
        d
    );

    // No todas las celdas tienen partícula
    dust *= step(0.35, rnd);

    // Parpadeo leve
    dust *= 0.6 + 0.4 * sin(t + rnd * 10.0);

    // Recorte por círculo
    dust *= circle;

    // =================================================
    // FINAL
    // =================================================
    float final_light = circle + dust * dust_intensity;

    ALBEDO = light_color * final_light * intensity;
    ALPHA  = final_light * alpha_strength;
}
