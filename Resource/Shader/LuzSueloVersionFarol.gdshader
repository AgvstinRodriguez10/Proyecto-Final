shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never;

// =================================================
// PARÁMETROS BASE
// =================================================
uniform vec3 light_color : source_color = vec3(1.0, 0.9, 0.7);
uniform float radius = 5.0;
uniform float intensity = 1.5;

// =================================================
// RESPIRACIÓN (MUY SUAVE)
// =================================================
uniform float breathe_strength = 0.06; // NO subir mucho
uniform float breathe_speed = 0.6;

// =================================================
// MOTAS DE LUZ
// =================================================
uniform float dust_density = 3.5;   // cuántas motas
uniform float dust_size = 0.12;     // tamaño de cada mota
uniform float dust_speed = 3.0;     // velocidad (rápida)
uniform float dust_strength = 0.25; // brillo de motas

varying vec3 v_local_pos;

// -------------------------------------------------
// HASH SIMPLE
// -------------------------------------------------
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void vertex() {
    v_local_pos = VERTEX;
}

void fragment() {

    // =================================================
    // LUZ BASE (RADIAL, LOCAL)
    // =================================================
    float dist = length(v_local_pos.xz);
    float base_light = clamp(1.0 - dist / radius, 0.0, 1.0);

    // =================================================
    // RESPIRACIÓN (SOLO INTENSIDAD)
    // =================================================
    float breathe =
        1.0 + sin(TIME * breathe_speed) * breathe_strength;

    float light = base_light * breathe;

    // =================================================
    // MOTAS DE LUZ (RÁPIDAS, PEQUEÑAS)
    // =================================================
    vec2 uv = v_local_pos.xz * dust_density;

    // desplazamiento rápido y caótico
    uv += vec2(
        sin(TIME * dust_speed + uv.y),
        cos(TIME * dust_speed * 1.3 + uv.x)
    );

    vec2 cell = floor(uv);
    vec2 local = fract(uv) - 0.5;

    float rnd = hash(cell);
    float d = length(local);

    float dust = smoothstep(
        dust_size,
        dust_size * 0.3,
        d
    );

    // no todas las celdas tienen mota
    dust *= step(0.85, rnd);

    // las motas SOLO dentro del fade
    dust *= base_light;

    // =================================================
    // COMBINACIÓN FINAL
    // =================================================
    float final_light =
        light + dust * dust_strength;

    ALBEDO = light_color * final_light * intensity;
    ALPHA  = final_light;
}
