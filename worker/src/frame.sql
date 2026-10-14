WITH ammo_defs AS (SELECT attributes->>'ammo_type' AS "ammo_type", CAST(CAST(attributes->>'cap' AS DOUBLE) AS INT) AS "cap", CAST(CAST(attributes->>'backpack_cap' AS DOUBLE) AS INT) AS "backpack_cap" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.ammo_defs'),
colormap_rows AS (SELECT CAST(CAST(attributes->>'pal' AS DOUBLE) AS INT) AS "pal", CAST(CAST(attributes->>'level' AS DOUBLE) AS INT) AS "level", attributes->>'hex' AS "hex" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.colormap_rows'),
effect_sprite_defs AS (SELECT attributes->>'effect_type' AS "effect_type", attributes->>'sprite' AS "sprite", attributes->>'frame_sequence' AS "frame_sequence", CAST(CAST(attributes->>'tics_per_frame' AS DOUBLE) AS INT) AS "tics_per_frame", CAST(attributes->>'fullbright' AS BOOLEAN) AS "fullbright" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.effect_sprite_defs'),
flat_textures AS (SELECT CAST(CAST(attributes->>'flat_id' AS DOUBLE) AS INT) AS "flat_id", attributes->>'name' AS "name" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.flat_textures'),
linedefs AS (SELECT CAST(CAST(attributes->>'id' AS DOUBLE) AS INT) AS "id", CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'flags' AS DOUBLE) AS INT) AS "flags", CAST(CAST(attributes->>'special' AS DOUBLE) AS INT) AS "special", CAST(attributes->>'scrolls' AS BOOLEAN) AS "scrolls" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.linedefs'),
monster_ai AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'thing_id' AS DOUBLE) AS INT) AS "thing_id", attributes->>'state' AS "state", CAST(CAST(attributes->>'seq_index' AS DOUBLE) AS INT) AS "seq_index", CAST(CAST(attributes->>'sector_id' AS DOUBLE) AS INT) AS "sector_id" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.monster_ai'),
monster_projectiles AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'projectile_id' AS DOUBLE) AS BIGINT) AS "projectile_id", attributes->>'projectile_type' AS "projectile_type", CAST(CAST(attributes->>'x' AS DOUBLE) AS FLOAT) AS "x", CAST(CAST(attributes->>'y' AS DOUBLE) AS FLOAT) AS "y", CAST(CAST(attributes->>'z' AS DOUBLE) AS FLOAT) AS "z", CAST(CAST(attributes->>'vx' AS DOUBLE) AS FLOAT) AS "vx", CAST(CAST(attributes->>'vy' AS DOUBLE) AS FLOAT) AS "vy", CAST(CAST(attributes->>'sector_id' AS DOUBLE) AS INT) AS "sector_id", attributes->>'state' AS "state", CAST(CAST(attributes->>'age' AS DOUBLE) AS INT) AS "age" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.monster_projectiles'),
mp_players AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'slot' AS DOUBLE) AS INT) AS "slot", CAST(CAST(attributes->>'player_thing_id' AS DOUBLE) AS INT) AS "player_thing_id" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.mp_players'),
node_children AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'node_id' AS DOUBLE) AS INT) AS "node_id", attributes->>'side' AS "side", CAST(CAST(attributes->>'bbox_top' AS DOUBLE) AS INT) AS "bbox_top", CAST(CAST(attributes->>'bbox_bottom' AS DOUBLE) AS INT) AS "bbox_bottom", CAST(CAST(attributes->>'bbox_left' AS DOUBLE) AS INT) AS "bbox_left", CAST(CAST(attributes->>'bbox_right' AS DOUBLE) AS INT) AS "bbox_right" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.node_children'),
node_path_steps AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'ssector_id' AS DOUBLE) AS INT) AS "ssector_id", CAST(CAST(attributes->>'depth' AS DOUBLE) AS INT) AS "depth", CAST(CAST(attributes->>'node_id' AS DOUBLE) AS INT) AS "node_id", attributes->>'side' AS "side" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.node_path_steps'),
nodes AS (SELECT CAST(CAST(attributes->>'id' AS DOUBLE) AS INT) AS "id", CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'x' AS DOUBLE) AS INT) AS "x", CAST(CAST(attributes->>'y' AS DOUBLE) AS INT) AS "y", CAST(CAST(attributes->>'dx' AS DOUBLE) AS INT) AS "dx", CAST(CAST(attributes->>'dy' AS DOUBLE) AS INT) AS "dy" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.nodes'),
picked_up_items AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'thing_id' AS DOUBLE) AS INT) AS "thing_id" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.picked_up_items'),
player_state AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'player_thing_id' AS DOUBLE) AS INT) AS "player_thing_id", CAST(CAST(attributes->>'health' AS DOUBLE) AS INT) AS "health", CAST(attributes->>'alive' AS BOOLEAN) AS "alive", CAST(CAST(attributes->>'level_tics' AS DOUBLE) AS BIGINT) AS "level_tics", CAST(CAST(attributes->>'base_z' AS DOUBLE) AS FLOAT) AS "base_z", CAST(CAST(attributes->>'sector_id' AS DOUBLE) AS INT) AS "sector_id", CAST(CAST(attributes->>'pain_face_tics' AS DOUBLE) AS INT) AS "pain_face_tics", CAST(CAST(attributes->>'armor' AS DOUBLE) AS INT) AS "armor", CAST(attributes->>'backpack' AS BOOLEAN) AS "backpack", CAST(CAST(attributes->>'ammo_bullets' AS DOUBLE) AS INT) AS "ammo_bullets", CAST(CAST(attributes->>'ammo_shells' AS DOUBLE) AS INT) AS "ammo_shells", CAST(CAST(attributes->>'ammo_rockets' AS DOUBLE) AS INT) AS "ammo_rockets", CAST(CAST(attributes->>'ammo_cells' AS DOUBLE) AS INT) AS "ammo_cells", CAST(attributes->>'key_blue' AS BOOLEAN) AS "key_blue", CAST(attributes->>'key_yellow' AS BOOLEAN) AS "key_yellow", CAST(attributes->>'key_red' AS BOOLEAN) AS "key_red", CAST(CAST(attributes->>'radsuit_tics' AS DOUBLE) AS INT) AS "radsuit_tics", CAST(CAST(attributes->>'invis_tics' AS DOUBLE) AS INT) AS "invis_tics", CAST(CAST(attributes->>'damage_count' AS DOUBLE) AS INT) AS "damage_count", CAST(CAST(attributes->>'bonus_count' AS DOUBLE) AS INT) AS "bonus_count", CAST(CAST(attributes->>'light_amp_tics' AS DOUBLE) AS INT) AS "light_amp_tics", CAST(CAST(attributes->>'invuln_tics' AS DOUBLE) AS INT) AS "invuln_tics", attributes->>'message' AS "message", CAST(CAST(attributes->>'message_tics' AS DOUBLE) AS INT) AS "message_tics", attributes->>'sprite_frame' AS "sprite_frame" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.player_state'),
player_weapon_owned AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'player_thing_id' AS DOUBLE) AS INT) AS "player_thing_id", CAST(CAST(attributes->>'weapon_id' AS DOUBLE) AS INT) AS "weapon_id" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.player_weapon_owned'),
player_weapons AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'player_thing_id' AS DOUBLE) AS INT) AS "player_thing_id", CAST(CAST(attributes->>'current_weapon' AS DOUBLE) AS INT) AS "current_weapon", attributes->>'state' AS "state", CAST(CAST(attributes->>'seq_index' AS DOUBLE) AS INT) AS "seq_index", CAST(CAST(attributes->>'flash_seq_index' AS DOUBLE) AS INT) AS "flash_seq_index", CAST(CAST(attributes->>'sx' AS DOUBLE) AS FLOAT) AS "sx", CAST(CAST(attributes->>'sy' AS DOUBLE) AS FLOAT) AS "sy" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.player_weapons'),
projectile_defs AS (SELECT attributes->>'projectile_type' AS "projectile_type", attributes->>'name' AS "name", attributes->>'fly_sprite' AS "fly_sprite", attributes->>'impact_sprite' AS "impact_sprite" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.projectile_defs'),
render_segs AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'seg_id' AS DOUBLE) AS INT) AS "seg_id", CAST(CAST(attributes->>'ssector_id' AS DOUBLE) AS INT) AS "ssector_id", CAST(CAST(attributes->>'linedef_id' AS DOUBLE) AS INT) AS "linedef_id", CAST(CAST(attributes->>'x1' AS DOUBLE) AS INT) AS "x1", CAST(CAST(attributes->>'y1' AS DOUBLE) AS INT) AS "y1", CAST(CAST(attributes->>'x2' AS DOUBLE) AS INT) AS "x2", CAST(CAST(attributes->>'y2' AS DOUBLE) AS INT) AS "y2", CAST(CAST(attributes->>'seg_u1' AS DOUBLE) AS DOUBLE) AS "seg_u1", CAST(CAST(attributes->>'seg_u2' AS DOUBLE) AS DOUBLE) AS "seg_u2", CAST(CAST(attributes->>'fsec' AS DOUBLE) AS INT) AS "fsec", CAST(CAST(attributes->>'bsec' AS DOUBLE) AS INT) AS "bsec", CAST(CAST(attributes->>'x_offset' AS DOUBLE) AS INT) AS "x_offset", CAST(CAST(attributes->>'y_offset' AS DOUBLE) AS INT) AS "y_offset", attributes->>'upper_tex' AS "upper_tex", attributes->>'mid_tex' AS "mid_tex", attributes->>'lower_tex' AS "lower_tex", CAST(CAST(attributes->>'flags' AS DOUBLE) AS INT) AS "flags", CAST(CAST(attributes->>'f_floor' AS DOUBLE) AS INT) AS "f_floor", CAST(CAST(attributes->>'f_ceil' AS DOUBLE) AS INT) AS "f_ceil", attributes->>'f_ceil_tex' AS "f_ceil_tex", CAST(CAST(attributes->>'f_light' AS DOUBLE) AS INT) AS "f_light", CAST(CAST(attributes->>'b_floor' AS DOUBLE) AS INT) AS "b_floor", CAST(CAST(attributes->>'b_ceil' AS DOUBLE) AS INT) AS "b_ceil", attributes->>'b_ceil_tex' AS "b_ceil_tex", CAST(CAST(attributes->>'b_light' AS DOUBLE) AS INT) AS "b_light", CAST(CAST(attributes->>'light_bias' AS DOUBLE) AS INT) AS "light_bias" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.render_segs'),
render_things AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'thing_id' AS DOUBLE) AS INT) AS "thing_id", CAST(CAST(attributes->>'sector_id' AS DOUBLE) AS INT) AS "sector_id", attributes->>'sprite' AS "sprite", attributes->>'frame' AS "frame", CAST(attributes->>'fullbright' AS BOOLEAN) AS "fullbright", CAST(attributes->>'spawn_ceiling' AS BOOLEAN) AS "spawn_ceiling", CAST(CAST(attributes->>'thing_height' AS DOUBLE) AS INT) AS "thing_height" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.render_things'),
sector_light_fx AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'sector_id' AS DOUBLE) AS INT) AS "sector_id", CAST(CAST(attributes->>'special' AS DOUBLE) AS INT) AS "special", CAST(CAST(attributes->>'base_light' AS DOUBLE) AS INT) AS "base_light", CAST(CAST(attributes->>'dark_light' AS DOUBLE) AS INT) AS "dark_light" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.sector_light_fx'),
sectors AS (SELECT CAST(CAST(attributes->>'id' AS DOUBLE) AS INT) AS "id", CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'floor_height' AS DOUBLE) AS INT) AS "floor_height", CAST(CAST(attributes->>'ceil_height' AS DOUBLE) AS INT) AS "ceil_height", attributes->>'floor_tex' AS "floor_tex", attributes->>'ceil_tex' AS "ceil_tex", CAST(CAST(attributes->>'light_level' AS DOUBLE) AS INT) AS "light_level", CAST(CAST(attributes->>'special' AS DOUBLE) AS INT) AS "special" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.sectors'),
sprite_frames AS (SELECT attributes->>'sprite' AS "sprite", attributes->>'frame' AS "frame", CAST(CAST(attributes->>'rotation' AS DOUBLE) AS INT) AS "rotation", attributes->>'lump_name' AS "lump_name", CAST(attributes->>'flipped' AS BOOLEAN) AS "flipped", CAST(CAST(attributes->>'width' AS DOUBLE) AS INT) AS "width", CAST(CAST(attributes->>'height' AS DOUBLE) AS INT) AS "height", CAST(CAST(attributes->>'left_offset' AS DOUBLE) AS INT) AS "left_offset", CAST(CAST(attributes->>'top_offset' AS DOUBLE) AS INT) AS "top_offset" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.sprite_frames'),
sprite_lumps AS (SELECT CAST(CAST(attributes->>'lump_id' AS DOUBLE) AS INT) AS "lump_id", attributes->>'lump_name' AS "lump_name" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.sprite_lumps'),
texel_chunks AS (SELECT CAST(CAST(attributes->>'ckey' AS DOUBLE) AS BIGINT) AS "ckey", attributes->>'s' AS "s" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.texel_chunks'),
thing_ai_frames AS (SELECT CAST(CAST(attributes->>'thing_type' AS DOUBLE) AS INT) AS "thing_type", attributes->>'state' AS "state", CAST(CAST(attributes->>'seq_index' AS DOUBLE) AS INT) AS "seq_index", attributes->>'frame' AS "frame", CAST(attributes->>'fullbright' AS BOOLEAN) AS "fullbright" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.thing_ai_frames'),
thing_combat_defs AS (SELECT CAST(CAST(attributes->>'thing_type' AS DOUBLE) AS INT) AS "thing_type", attributes->>'death_sprite' AS "death_sprite", attributes->>'death_frame' AS "death_frame", CAST(attributes->>'death_fullbright' AS BOOLEAN) AS "death_fullbright", attributes->>'xdeath_frame' AS "xdeath_frame", attributes->>'name' AS "name", CAST(CAST(attributes->>'height' AS DOUBLE) AS INT) AS "height", CAST(attributes->>'floats' AS BOOLEAN) AS "floats", CAST(attributes->>'explodes' AS BOOLEAN) AS "explodes", CAST(attributes->>'fuzzy' AS BOOLEAN) AS "fuzzy" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.thing_combat_defs'),
thing_health AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'thing_id' AS DOUBLE) AS INT) AS "thing_id", CAST(CAST(attributes->>'health' AS DOUBLE) AS INT) AS "health", CAST(CAST(attributes->>'max_health' AS DOUBLE) AS INT) AS "max_health", CAST(attributes->>'alive' AS BOOLEAN) AS "alive" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.thing_health'),
things AS (SELECT CAST(CAST(attributes->>'id' AS DOUBLE) AS INT) AS "id", CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'x' AS DOUBLE) AS FLOAT) AS "x", CAST(CAST(attributes->>'y' AS DOUBLE) AS FLOAT) AS "y", CAST(CAST(attributes->>'z' AS DOUBLE) AS FLOAT) AS "z", CAST(CAST(attributes->>'angle' AS DOUBLE) AS FLOAT) AS "angle", CAST(CAST(attributes->>'type' AS DOUBLE) AS INT) AS "type", CAST(CAST(attributes->>'flags' AS DOUBLE) AS INT) AS "flags" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.things'),
ui_hud_pixels AS (SELECT attributes->>'name' AS "name", CAST(CAST(attributes->>'dx' AS DOUBLE) AS INT) AS "dx", CAST(CAST(attributes->>'dy' AS DOUBLE) AS INT) AS "dy", CAST(CAST(attributes->>'palette_index' AS DOUBLE) AS INT) AS "palette_index" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.ui_hud_pixels'),
ui_patches AS (SELECT attributes->>'name' AS "name", CAST(CAST(attributes->>'width' AS DOUBLE) AS INT) AS "width", CAST(CAST(attributes->>'height' AS DOUBLE) AS INT) AS "height", CAST(CAST(attributes->>'left_offset' AS DOUBLE) AS INT) AS "left_offset", CAST(CAST(attributes->>'top_offset' AS DOUBLE) AS INT) AS "top_offset" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.ui_patches'),
ui_static_pixels AS (SELECT CAST(CAST(attributes->>'x' AS DOUBLE) AS INT) AS "x", CAST(CAST(attributes->>'y' AS DOUBLE) AS INT) AS "y", CAST(CAST(attributes->>'rgb' AS DOUBLE) AS INT) AS "rgb", CAST(CAST(attributes->>'palette_index' AS DOUBLE) AS INT) AS "palette_index" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.ui_static_pixels'),
walltex_meta AS (SELECT CAST(CAST(attributes->>'tex_id' AS DOUBLE) AS INT) AS "tex_id", attributes->>'name' AS "name", CAST(CAST(attributes->>'width' AS DOUBLE) AS INT) AS "width", CAST(CAST(attributes->>'height' AS DOUBLE) AS INT) AS "height" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.walltex_meta'),
weapon_defs AS (SELECT CAST(CAST(attributes->>'weapon_id' AS DOUBLE) AS INT) AS "weapon_id", attributes->>'name' AS "name", CAST(CAST(attributes->>'slot' AS DOUBLE) AS INT) AS "slot", attributes->>'ammo_type' AS "ammo_type", attributes->>'sprite' AS "sprite", attributes->>'flash_sprite' AS "flash_sprite", attributes->>'projectile_type' AS "projectile_type" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.weapon_defs'),
weapon_frames AS (SELECT CAST(CAST(attributes->>'weapon_id' AS DOUBLE) AS INT) AS "weapon_id", attributes->>'state' AS "state", CAST(CAST(attributes->>'seq_index' AS DOUBLE) AS INT) AS "seq_index", attributes->>'frame' AS "frame", CAST(attributes->>'fullbright' AS BOOLEAN) AS "fullbright" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.weapon_frames'),
world_effects AS (SELECT CAST(CAST(attributes->>'map_id' AS DOUBLE) AS INT) AS "map_id", CAST(CAST(attributes->>'effect_id' AS DOUBLE) AS BIGINT) AS "effect_id", attributes->>'effect_type' AS "effect_type", CAST(CAST(attributes->>'x' AS DOUBLE) AS FLOAT) AS "x", CAST(CAST(attributes->>'y' AS DOUBLE) AS FLOAT) AS "y", CAST(CAST(attributes->>'z' AS DOUBLE) AS FLOAT) AS "z", CAST(CAST(attributes->>'sector_id' AS DOUBLE) AS INT) AS "sector_id", CAST(CAST(attributes->>'age' AS DOUBLE) AS INT) AS "age" FROM records WHERE service_name = '${svc}' AND span_name = 'doom.world_effects'),
frame_clock AS (
  SELECT CAST(COALESCE(MAX(level_tics), 0) AS BIGINT) AS t
  FROM player_state
  WHERE map_id = 1 AND player_thing_id = 157
),
animated_light AS (
  SELECT k.sector_id,
    LEAST(255, GREATEST(0,
    CASE k.special
      WHEN 2  THEN CASE WHEN ((k.t + k.phase) % 20) < 5 THEN k.base_light ELSE k.dark_light END
      WHEN 13 THEN CASE WHEN (k.t % 20) < 5 THEN k.base_light ELSE k.dark_light END
      WHEN 3  THEN CASE WHEN ((k.t + k.phase) % 40) < 5 THEN k.base_light ELSE k.dark_light END
      WHEN 12 THEN CASE WHEN (k.t % 40) < 5 THEN k.base_light ELSE k.dark_light END
      WHEN 1  THEN CASE WHEN ((k.sector_id*2654435761 + (k.t / 4)) % 8) < 2
                        THEN k.dark_light ELSE k.base_light END
      WHEN 17 THEN GREATEST(k.dark_light,
                     k.base_light - CAST(((((((k.t / 3) % 1000) * (((k.t / 3) % 1000))
                                        * 1103515245) + k.sector_id * 40503)
                                      % 1009) % 4
                       * GREATEST(1, (k.base_light - k.dark_light) / 4)) AS INT))
      WHEN 8  THEN (k.dark_light + 8 * (
                      CASE WHEN ((k.t + k.phase) % (2*k.glow_steps)) < k.glow_steps
                           THEN ((k.t + k.phase) % (2*k.glow_steps))
                           ELSE 2*k.glow_steps - ((k.t + k.phase) % (2*k.glow_steps))
                      END))
      ELSE k.base_light
    END)) AS light_level
  FROM (
    SELECT f.sector_id, f.base_light, f.dark_light, f.special,
           (f.sector_id*7919) % 64 AS phase,
           GREATEST(1, (f.base_light - f.dark_light) / 8) AS glow_steps,
           fc.t
    FROM frame_clock fc CROSS JOIN sector_light_fx f
    WHERE f.map_id = 1
  ) k
),
sectors_lit AS (
  SELECT s.id, s.floor_height, s.ceil_height, s.floor_tex, s.ceil_tex,
         COALESCE(a.light_level, s.light_level) AS light_level
  FROM sectors s
  LEFT JOIN animated_light a ON a.sector_id = s.id
  WHERE s.map_id = 1
),
weapon_runtime AS (
  SELECT COALESCE(w.sx, 1) AS sx, COALESCE(w.sy, 32) AS sy,
         CASE WHEN COALESCE(ps2.light_amp_tics, 0) > 0 THEN 16
              ELSE COALESCE(w.flash_seq_index, -1) + 1 END AS extra_light,
         COALESCE(ps2.invuln_tics, 0) > 0 AS invuln,
         wd.sprite, wd.flash_sprite,
         CASE WHEN COALESCE(w.state, 'ready') IN ('up', 'down')
              THEN rf.frame ELSE mf.frame END AS frame,
         CASE WHEN COALESCE(w.state, 'ready') IN ('up', 'down')
              THEN rf.fullbright ELSE mf.fullbright END AS fullbright,
         ff.frame AS flash_frame, ff.fullbright AS flash_fullbright
  FROM (SELECT 1 AS one) rc
  LEFT JOIN player_weapons w ON w.map_id = 1 AND w.player_thing_id = 157
  LEFT JOIN player_state ps2 ON ps2.map_id = 1 AND ps2.player_thing_id = 157
  JOIN weapon_defs wd ON wd.weapon_id = COALESCE(w.current_weapon, 2)
  LEFT JOIN weapon_frames rf ON rf.weapon_id = wd.weapon_id
    AND rf.state = 'ready' AND rf.seq_index = 0
  LEFT JOIN weapon_frames mf ON mf.weapon_id = wd.weapon_id
    AND mf.state = COALESCE(w.state, 'ready') AND mf.seq_index = COALESCE(w.seq_index, 0)
  LEFT JOIN weapon_frames ff ON ff.weapon_id = wd.weapon_id
    AND ff.state = 'flash' AND ff.seq_index = w.flash_seq_index
),

visible_children AS (
  SELECT nc.node_id, nc.side,
    (CAST(${px} AS DOUBLE) BETWEEN nc.bbox_left AND nc.bbox_right
     AND CAST(${py} AS DOUBLE) BETWEEN nc.bbox_bottom AND nc.bbox_top)
    OR (
      ((SIN(-radians(CAST(${angle} AS DOUBLE))) - tan(radians(90.0) / 2.0)*COS(-radians(CAST(${angle} AS DOUBLE))))
         * (CASE WHEN (SIN(-radians(CAST(${angle} AS DOUBLE))) - tan(radians(90.0) / 2.0)*COS(-radians(CAST(${angle} AS DOUBLE)))) >= 0
                 THEN nc.bbox_left ELSE nc.bbox_right END)
       + (COS(-radians(CAST(${angle} AS DOUBLE))) + tan(radians(90.0) / 2.0)*SIN(-radians(CAST(${angle} AS DOUBLE))))
         * (CASE WHEN (COS(-radians(CAST(${angle} AS DOUBLE))) + tan(radians(90.0) / 2.0)*SIN(-radians(CAST(${angle} AS DOUBLE)))) >= 0
                 THEN nc.bbox_bottom ELSE nc.bbox_top END)
       + (-CAST(${px} AS DOUBLE)*SIN(-radians(CAST(${angle} AS DOUBLE))) - CAST(${py} AS DOUBLE)*COS(-radians(CAST(${angle} AS DOUBLE)))
          + tan(radians(90.0) / 2.0)*(CAST(${px} AS DOUBLE)*COS(-radians(CAST(${angle} AS DOUBLE))) - CAST(${py} AS DOUBLE)*SIN(-radians(CAST(${angle} AS DOUBLE)))))
      ) <= 0.5
      AND
      ((-SIN(-radians(CAST(${angle} AS DOUBLE))) - tan(radians(90.0) / 2.0)*COS(-radians(CAST(${angle} AS DOUBLE))))
         * (CASE WHEN (-SIN(-radians(CAST(${angle} AS DOUBLE))) - tan(radians(90.0) / 2.0)*COS(-radians(CAST(${angle} AS DOUBLE)))) >= 0
                 THEN nc.bbox_left ELSE nc.bbox_right END)
       + (-COS(-radians(CAST(${angle} AS DOUBLE))) + tan(radians(90.0) / 2.0)*SIN(-radians(CAST(${angle} AS DOUBLE))))
         * (CASE WHEN (-COS(-radians(CAST(${angle} AS DOUBLE))) + tan(radians(90.0) / 2.0)*SIN(-radians(CAST(${angle} AS DOUBLE)))) >= 0
                 THEN nc.bbox_bottom ELSE nc.bbox_top END)
       + (CAST(${px} AS DOUBLE)*SIN(-radians(CAST(${angle} AS DOUBLE))) + CAST(${py} AS DOUBLE)*COS(-radians(CAST(${angle} AS DOUBLE)))
          + tan(radians(90.0) / 2.0)*(CAST(${px} AS DOUBLE)*COS(-radians(CAST(${angle} AS DOUBLE))) - CAST(${py} AS DOUBLE)*SIN(-radians(CAST(${angle} AS DOUBLE)))))
      ) <= 0.5
      AND
      ((-COS(-radians(CAST(${angle} AS DOUBLE))))
         * (CASE WHEN (-COS(-radians(CAST(${angle} AS DOUBLE)))) >= 0 THEN nc.bbox_left ELSE nc.bbox_right END)
       + (SIN(-radians(CAST(${angle} AS DOUBLE))))
         * (CASE WHEN SIN(-radians(CAST(${angle} AS DOUBLE))) >= 0 THEN nc.bbox_bottom ELSE nc.bbox_top END)
       + (1e-3 + CAST(${px} AS DOUBLE)*COS(-radians(CAST(${angle} AS DOUBLE))) - CAST(${py} AS DOUBLE)*SIN(-radians(CAST(${angle} AS DOUBLE))))
      ) <= 0.5
    ) AS keep
  FROM node_children nc
  WHERE nc.map_id = 1
),
bsp_order AS (
  SELECT s.ssector_id, ROW_NUMBER() OVER (ORDER BY s.sort_key) AS bsp_seq
  FROM (
    SELECT st.ssector_id,
           SUM(CASE WHEN st.side = (CASE
                      WHEN CAST((CASE WHEN (CAST(${px} AS DOUBLE) - n.x) - floor(CAST(${px} AS DOUBLE) - n.x) = 0.5 THEN 2.0 * round((CAST(${px} AS DOUBLE) - n.x) / 2.0) ELSE round(CAST(${px} AS DOUBLE) - n.x) END) AS BIGINT) * CAST(n.dy AS BIGINT)
                         - CAST((CASE WHEN (CAST(${py} AS DOUBLE) - n.y) - floor(CAST(${py} AS DOUBLE) - n.y) = 0.5 THEN 2.0 * round((CAST(${py} AS DOUBLE) - n.y) / 2.0) ELSE round(CAST(${py} AS DOUBLE) - n.y) END) AS BIGINT) * CAST(n.dx AS BIGINT) > 0
                        THEN 'R' ELSE 'L' END)
                    THEN CAST(0 AS BIGINT)
                    ELSE ((CAST(1 AS BIGINT)) << (40 - st.depth)) END) AS sort_key,
           bool_and(vc.keep) AS visible
    FROM node_path_steps st
    JOIN nodes n ON n.map_id = st.map_id AND n.id = st.node_id
    JOIN visible_children vc ON vc.node_id = st.node_id AND vc.side = st.side
    WHERE st.map_id = 1
    GROUP BY st.ssector_id
  ) s
  WHERE s.visible
),

seg_stream AS (
  
  
  SELECT s.seg_id, s.linedef_id, s.x1, s.y1, s.x2, s.y2, s.seg_u1, s.seg_u2,
         s.fsec, s.bsec, s.x_offset, s.y_offset, s.upper_tex, s.mid_tex,
         s.lower_tex, s.flags, s.f_floor, s.f_ceil, s.f_ceil_tex, s.f_light,
         s.b_floor, s.b_ceil, s.b_ceil_tex, s.b_light, s.light_bias,
         bo.bsp_seq,
         MIN(CASE WHEN bo.bsp_seq = 1
                  THEN ((CAST(s.seg_id AS BIGINT)) << (24)) | CAST(s.fsec AS BIGINT) END)
           OVER () AS ps_key,
         ROW_NUMBER() OVER (ORDER BY s.seg_id) AS rn
  FROM render_segs s
  JOIN bsp_order bo ON bo.ssector_id = s.ssector_id
  WHERE s.map_id = 1
),
seg_seeded AS (
  
  
  SELECT st.*,
         unnest(CASE WHEN st.rn = 1 THEN range(CAST(-1 AS BIGINT), CAST(320 - 1 AS BIGINT) + 1) ELSE make_array(-1) END) AS seed_x
  FROM seg_stream st
),
seg_ps AS (
  SELECT r.*, ps.id AS ps_id, ps.floor_height AS ps_floor, ps.ceil_height AS ps_ceil,
         ps.light_level AS ps_light, ps.ceil_tex AS ps_ceil_tex
  FROM seg_seeded r
  LEFT JOIN sectors_lit ps ON ps.id = CAST(r.ps_key & 16777215 AS INT)
),
segs_view AS (
  SELECT r.*,
    (r.x1 - CAST(${px} AS DOUBLE)) * cos(-radians(CAST(${angle} AS DOUBLE))) - (r.y1 - CAST(${py} AS DOUBLE)) * sin(-radians(CAST(${angle} AS DOUBLE))) AS vx1,
    -((r.x1 - CAST(${px} AS DOUBLE)) * sin(-radians(CAST(${angle} AS DOUBLE))) + (r.y1 - CAST(${py} AS DOUBLE)) * cos(-radians(CAST(${angle} AS DOUBLE)))) AS vy1,
    (r.x2 - CAST(${px} AS DOUBLE)) * cos(-radians(CAST(${angle} AS DOUBLE))) - (r.y2 - CAST(${py} AS DOUBLE)) * sin(-radians(CAST(${angle} AS DOUBLE))) AS vx2,
    -((r.x2 - CAST(${px} AS DOUBLE)) * sin(-radians(CAST(${angle} AS DOUBLE))) + (r.y2 - CAST(${py} AS DOUBLE)) * cos(-radians(CAST(${angle} AS DOUBLE)))) AS vy2
  FROM seg_ps r
  WHERE r.seed_x >= 0
     OR CAST(r.x2 - r.x1 AS BIGINT) * CAST((CASE WHEN (CAST(${py} AS DOUBLE) - r.y1) - floor(CAST(${py} AS DOUBLE) - r.y1) = 0.5 THEN 2.0 * round((CAST(${py} AS DOUBLE) - r.y1) / 2.0) ELSE round(CAST(${py} AS DOUBLE) - r.y1) END) AS BIGINT)
      - CAST(r.y2 - r.y1 AS BIGINT) * CAST((CASE WHEN (CAST(${px} AS DOUBLE) - r.x1) - floor(CAST(${px} AS DOUBLE) - r.x1) = 0.5 THEN 2.0 * round((CAST(${px} AS DOUBLE) - r.x1) / 2.0) ELSE round(CAST(${px} AS DOUBLE) - r.x1) END) AS BIGINT) < 0
),
segs_clipped AS (
  SELECT v.*,
    CASE WHEN v.vx1 < 1e-3 THEN 1e-3 ELSE v.vx1 END AS cx1,
    CASE WHEN v.vx1 < 1e-3 THEN v.vy1 + (1e-3 - v.vx1)*(v.vy2 - v.vy1)/(v.vx2 - v.vx1) ELSE v.vy1 END AS cy1,
    CASE WHEN v.vx2 < 1e-3 THEN 1e-3 ELSE v.vx2 END AS cx2,
    CASE WHEN v.vx2 < 1e-3 THEN v.vy2 + (1e-3 - v.vx2)*(v.vy1 - v.vy2)/(v.vx1 - v.vx2) ELSE v.vy2 END AS cy2
  FROM segs_view v
  WHERE v.seed_x >= 0 OR v.vx1 > 0 OR v.vx2 > 0
),
segs_projected AS (
  SELECT c.*,
    160.0 + (160.0 / tan(radians(90.0) / 2.0))*(c.cy1/c.cx1) AS screen_x1,
    160.0 + (160.0 / tan(radians(90.0) / 2.0))*(c.cy2/c.cx2) AS screen_x2,
    1.0/c.cx1 AS invx1,
    1.0/c.cx2 AS invx2
  FROM segs_clipped c
),
heights AS (
  SELECT p.*,
    (p.x_offset + CASE WHEN ld.id IS NULL THEN 0 ELSE fc.t END) AS x_off,
    COALESCE(alf.light_level, p.f_light) AS f_light_lit
  
  
  FROM frame_clock fc
  CROSS JOIN segs_projected p
  LEFT JOIN animated_light alf ON alf.sector_id = p.fsec
  LEFT JOIN linedefs ld ON ld.map_id = 1 AND ld.id = p.linedef_id AND ld.scrolls
  WHERE p.seed_x >= 0
     OR (GREATEST(p.screen_x1, p.screen_x2) >= 0
         AND LEAST(p.screen_x1, p.screen_x2) < 320)
),

parts AS (
  SELECT h.*, h.pt['part'] AS part, h.pt['tex'] AS tex, h.pt['z_bot'] AS z_bot, h.pt['z_top'] AS z_top,
         h.pt['v_anchor_base'] AS v_anchor_base, h.pt['v_anchor_add_tex_h'] AS v_anchor_add_tex_h
  FROM (
    
    
    
    
    SELECT h0.*, unnest(CASE WHEN h0.seed_x < 0 THEN make_array(
        CASE WHEN h0.bsec IS NULL AND h0.f_ceil > h0.f_floor THEN
          named_struct('part', 'solid', 'tex', h0.mid_tex, 'z_bot', h0.f_floor, 'z_top', h0.f_ceil,
                       'v_anchor_base', CASE WHEN (h0.flags & 16)<>0 THEN h0.f_floor ELSE h0.f_ceil END,
                       'v_anchor_add_tex_h', (h0.flags & 16)<>0) END,
        CASE WHEN h0.bsec IS NOT NULL AND h0.b_ceil < h0.f_ceil
              AND ((h0.f_ceil_tex IS DISTINCT FROM 'F_SKY1') OR (h0.b_ceil_tex IS DISTINCT FROM 'F_SKY1')) THEN
          named_struct('part', 'upper', 'tex', h0.upper_tex, 'z_bot', h0.b_ceil, 'z_top', h0.f_ceil,
                       'v_anchor_base', CASE WHEN (h0.flags & 8)<>0 THEN h0.f_ceil ELSE h0.b_ceil END,
                       'v_anchor_add_tex_h', (h0.flags & 8)=0) END,
        CASE WHEN h0.bsec IS NOT NULL AND h0.b_ceil > h0.f_ceil
              AND ((h0.f_ceil_tex IS DISTINCT FROM 'F_SKY1') OR (h0.b_ceil_tex IS DISTINCT FROM 'F_SKY1')) THEN
          named_struct('part', 'upper_open', 'tex', CAST(NULL AS STRING), 'z_bot', h0.f_ceil, 'z_top', h0.b_ceil,
                       'v_anchor_base', h0.b_ceil, 'v_anchor_add_tex_h', FALSE) END,
        CASE WHEN h0.bsec IS NOT NULL AND h0.b_ceil = h0.f_ceil
              AND ((h0.f_ceil_tex IS DISTINCT FROM 'F_SKY1') OR (h0.b_ceil_tex IS DISTINCT FROM 'F_SKY1')) THEN
          named_struct('part', 'upper_flush', 'tex', CAST(NULL AS STRING), 'z_bot', h0.f_ceil, 'z_top', h0.b_ceil,
                       'v_anchor_base', h0.b_ceil, 'v_anchor_add_tex_h', FALSE) END,
        CASE WHEN h0.bsec IS NOT NULL AND h0.b_floor > h0.f_floor THEN
          named_struct('part', 'lower', 'tex', h0.lower_tex, 'z_bot', h0.f_floor, 'z_top', h0.b_floor,
                       'v_anchor_base', CASE WHEN (h0.flags & 16)<>0 THEN h0.f_ceil ELSE h0.b_floor END,
                       'v_anchor_add_tex_h', FALSE) END,
        CASE WHEN h0.bsec IS NOT NULL AND h0.b_floor <= h0.f_floor THEN
          named_struct('part', 'lower_down', 'tex', CAST(NULL AS STRING), 'z_bot', h0.b_floor, 'z_top', h0.f_floor,
                       'v_anchor_base', h0.f_floor, 'v_anchor_add_tex_h', FALSE) END,
        CASE WHEN h0.bsec IS NOT NULL AND h0.mid_tex IS NOT NULL AND h0.mid_tex <> '-'
              AND h0.f_ceil > h0.f_floor THEN
          named_struct('part', 'midmask', 'tex', h0.mid_tex, 'z_bot', h0.f_floor, 'z_top', h0.f_ceil,
                       'v_anchor_base', CASE WHEN (h0.flags & 16)<>0 THEN GREATEST(h0.f_floor, h0.b_floor)
                                             ELSE LEAST(h0.f_ceil, h0.b_ceil) END,
                       'v_anchor_add_tex_h', (h0.flags & 16)<>0) END,
        
        CASE WHEN h0.bsec IS NULL OR h0.b_ceil <= h0.b_floor THEN
          named_struct('part', 'occl', 'tex', CAST(NULL AS STRING), 'z_bot', 0, 'z_top', 0,
                       'v_anchor_base', 0, 'v_anchor_add_tex_h', FALSE) END
      ) ELSE make_array(CASE WHEN h0.seed_x < 0 THEN NULL ELSE
        named_struct('part', 'seed', 'tex', CAST(NULL AS STRING), 'z_bot', 0, 'z_top', 0,
                     'v_anchor_base', 0, 'v_anchor_add_tex_h', FALSE) END) END) AS pt
    FROM heights h0
  ) h
  WHERE h.pt IS NOT NULL
),
part_cols AS (
  SELECT p.*,
         COALESCE(m.width, 64) AS tex_w, COALESCE(m.height, 64) AS tex_h,
         m.width AS tex_width, m.tex_id,
         unnest(CASE
           WHEN p.part = 'seed' THEN make_array(p.seed_x)
           WHEN p.screen_x1 <> p.screen_x2
            AND GREATEST(0, CAST(FLOOR(LEAST(p.screen_x1, p.screen_x2)) AS INT))
                <= LEAST(320 - 1, CAST(CEIL(GREATEST(p.screen_x1, p.screen_x2)) AS INT))
           THEN range(CAST(GREATEST(0, CAST(FLOOR(LEAST(p.screen_x1, p.screen_x2)) AS INT)) AS BIGINT), CAST(LEAST(320 - 1, CAST(CEIL(GREATEST(p.screen_x1, p.screen_x2)) AS INT)) AS BIGINT) + 1)
         END) AS col_x
  FROM parts p
  LEFT JOIN walltex_meta m ON m.name = p.tex
),
columns AS (
  SELECT c.*,
    (c.x_off + c.seg_u1) AS u1,
    (c.x_off + c.seg_u2) AS u2,
    LEAST(1.0, GREATEST(0.0,
      (c.col_x - c.screen_x1) / NULLIF(c.screen_x2 - c.screen_x1, 1e-6))) AS t
  FROM (
    SELECT pc.*,
           MIN(CASE WHEN pc.part = 'occl' THEN pc.bsp_seq END) OVER (PARTITION BY pc.col_x) AS min_bsp_seq
    FROM part_cols pc
  ) c
  WHERE c.part = 'seed'
     OR (c.part <> 'occl' AND c.bsp_seq <= COALESCE(c.min_bsp_seq, c.bsp_seq))
),
per_column AS (
  SELECT c.*,
    c.invx1 + c.t * (c.invx2 - c.invx1) AS invx,
    (c.u1 * c.invx1) + c.t * ((c.u2 * c.invx2) - (c.u1 * c.invx1)) AS u_over_x
  FROM columns c
),
per_column2 AS (
  SELECT c.*,
    1.0 / c.invx AS depth_x,
    c.u_over_x / NULLIF(c.invx, 1e-6) AS u_col,
    (160.0 / tan(radians(90.0) / 2.0)) * c.invx AS scale
  FROM per_column c
),
vertical AS (
  SELECT p.*,
    (84.0 - p.scale * (p.z_top - CAST(${pz} AS DOUBLE))) AS y_top_f,
    (84.0 - p.scale * (p.z_bot - CAST(${pz} AS DOUBLE))) AS y_bot_f,
    p.v_anchor_base + CASE WHEN p.v_anchor_add_tex_h THEN p.tex_h ELSE 0 END AS v_anchor_z
  FROM per_column2 p
),

panel AS (
  SELECT v.*,
    v.part <> 'seed'
      AND (v.part IN ('upper_open', 'upper_flush', 'lower_down')
           OR (LEAST(v.y_top_f, v.y_bot_f) < 168 AND GREATEST(v.y_top_f, v.y_bot_f) >= 0)) AS is_panel,
    CASE WHEN v.part = 'lower_down' THEN v.y_top_f ELSE v.y_bot_f END AS f_floor_y_f,
    CASE WHEN v.part = 'upper_open' THEN v.y_bot_f ELSE v.y_top_f END AS f_ceil_y_f,
    (v.f_ceil_tex = 'F_SKY1') AS f_ceil_is_sky,
    
    CAST(CEIL(LEAST(168 - 1.0, GREATEST(0.0, LEAST(v.y_top_f, v.y_bot_f)))) AS INT) AS y_start,
    CAST(FLOOR(LEAST(168 - 1.0, GREATEST(0.0, GREATEST(v.y_top_f, v.y_bot_f)))) AS INT) AS y_end
  FROM vertical v
),
panel_win AS (
  SELECT p.*,
    COALESCE(MAX(CASE
          WHEN p.is_panel AND p.part IN ('solid', 'upper')
            THEN CAST(FLOOR(LEAST(168 - 1.0, GREATEST(0.0, p.y_bot_f))) AS INT) + 1
          WHEN p.is_panel AND p.part = 'upper_flush'
            THEN GREATEST(0, CAST(FLOOR(LEAST(168 - 1.0, p.y_bot_f)) AS INT) + 1)
        END) OVER (PARTITION BY p.col_x ORDER BY p.depth_x, p.bsp_seq, p.part, p.seg_id
                   ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0) AS cc_before,
    COALESCE(MIN(CASE WHEN p.is_panel AND p.part IN ('solid', 'lower', 'lower_down')
                      THEN LEAST(168 - 1, CAST(CEIL(GREATEST(0.0, p.y_top_f)) AS INT) - 1) END)
        OVER (PARTITION BY p.col_x ORDER BY p.depth_x, p.bsp_seq, p.part, p.seg_id
              ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 168 - 1) AS fc_before,
    last_value(CASE WHEN p.is_panel AND p.f_ceil > CAST(${pz} AS DOUBLE)
              THEN named_struct('sec', p.fsec, 'z', p.f_ceil, 'light', p.f_light_lit,
                                'sky', p.f_ceil_is_sky) END) IGNORE NULLS
      OVER (PARTITION BY p.col_x ORDER BY p.depth_x, p.bsp_seq, p.part, p.seg_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS pc,
    last_value(CASE WHEN p.is_panel AND p.f_floor < CAST(${pz} AS DOUBLE)
              THEN named_struct('sec', p.fsec, 'z', p.f_floor, 'light', p.f_light_lit) END) IGNORE NULLS
      OVER (PARTITION BY p.col_x ORDER BY p.depth_x, p.bsp_seq, p.part, p.seg_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS pf,
    MIN(CASE WHEN p.is_panel AND p.part IN ('solid', 'lower', 'lower_down') THEN p.depth_x END)
      OVER (PARTITION BY p.col_x) AS near_floor_depth,
    MIN(CASE WHEN p.is_panel AND p.part IN ('solid', 'upper', 'upper_open', 'upper_flush') THEN p.depth_x END)
      OVER (PARTITION BY p.col_x) AS near_ceil_depth
  FROM panel p
),
panel_bounds AS (
  SELECT k.*,
    k.f_ceil > CAST(${pz} AS DOUBLE) OR k.f_ceil_is_sky AS own_ceil,
    k.f_floor < CAST(${pz} AS DOUBLE) AS own_floor,
    COALESCE(k.pc['sky'], FALSE) AS carried_ceil_is_sky,
    CAST(CEIL(LEAST(168 - 1.0, GREATEST(0.0,
      CASE WHEN k.f_ceil > CAST(${pz} AS DOUBLE) OR k.f_ceil_is_sky THEN k.f_ceil_y_f
           ELSE LEAST(k.f_ceil_y_f, 84.0 - (160.0 / tan(radians(90.0) / 2.0)) * (k.pc['z'] - CAST(${pz} AS DOUBLE)) / (16.0 * (160.0 / tan(radians(90.0) / 2.0))))
      END))) AS INT) - 1 AS ceil_y1,
    CAST(FLOOR(LEAST(168 - 1.0, GREATEST(0.0,
      CASE WHEN k.f_floor < CAST(${pz} AS DOUBLE) THEN k.f_floor_y_f
           ELSE GREATEST(k.f_floor_y_f, 84.0 - (160.0 / tan(radians(90.0) / 2.0)) * (k.pf['z'] - CAST(${pz} AS DOUBLE)) / (16.0 * (160.0 / tan(radians(90.0) / 2.0))))
      END))) AS INT) + 1 AS floor_y0,
    k.v_anchor_z - (CAST(${pz} AS DOUBLE) + (84.0 - CAST(k.y_start AS DOUBLE)) / NULLIF(k.scale, 1e-9))
      + CAST(k.y_offset AS DOUBLE) AS v0,
    1.0 / NULLIF(k.scale, 1e-9) AS v_step
  FROM panel_win k
),

spans AS (
  
  SELECT b.col_x, b.ps_light, b.sp['kind'] AS kind, b.sp['y0'] AS y0, b.sp['y1'] AS y1, b.sp['sector_id'] AS sector_id, b.sp['plane_z'] AS plane_z, b.sp['plane'] AS plane, b.sp['span_sky'] AS span_sky, b.sp['sector_light'] AS sector_light, b.sp['source_priority'] AS source_priority, b.sp['stable_id'] AS stable_id, b.sp['depth'] AS depth, b.sp['u_col'] AS u_col, b.sp['v0'] AS v0, b.sp['v_step'] AS v_step, b.sp['ystart'] AS ystart, b.sp['tex_w'] AS tex_w, b.sp['tex_h'] AS tex_h, b.sp['tex_width'] AS tex_width, b.sp['tex_id'] AS tex_id, b.sp['light_bias'] AS light_bias
  FROM (
    SELECT k.col_x, k.ps_light, unnest(CASE WHEN k.part = 'seed' THEN make_array(
      CASE WHEN k.ps_id IS NOT NULL THEN named_struct(
        'kind', 1, 'y0',
        CASE WHEN k.near_floor_depth IS NULL THEN CAST(FLOOR(84.0) AS INT) + 1
             ELSE CAST(FLOOR(LEAST(168 - 1.0, GREATEST(0.0,
                    84.0 - (160.0 / tan(radians(90.0) / 2.0)) * (k.ps_floor - CAST(${pz} AS DOUBLE)) / k.near_floor_depth))) AS INT) + 1 END,
        'y1', 168 - 1,
        'sector_id', k.ps_id, 'plane_z', k.ps_floor, 'plane', 'floor', 'span_sky', FALSE,
        'sector_light', k.ps_light, 'source_priority', 0,
        'stable_id', CAST(NULL AS BIGINT), 'depth', CAST(NULL AS DOUBLE), 'u_col', CAST(NULL AS DOUBLE),
        'v0', CAST(NULL AS DOUBLE), 'v_step', CAST(NULL AS DOUBLE), 'ystart', CAST(NULL AS INT),
        'tex_w', CAST(NULL AS INT), 'tex_h', CAST(NULL AS INT), 'tex_width', CAST(NULL AS INT),
        'tex_id', CAST(NULL AS INT), 'light_bias', CAST(NULL AS INT)) END,
      CASE WHEN k.ps_id IS NOT NULL THEN named_struct(
        'kind', 1, 'y0', 0,
        'y1', CASE WHEN k.near_ceil_depth IS NULL THEN CAST(CEIL(84.0) AS INT) - 1
                   ELSE CAST(CEIL(LEAST(168 - 1.0, GREATEST(0.0,
                          84.0 - (160.0 / tan(radians(90.0) / 2.0)) * (k.ps_ceil - CAST(${pz} AS DOUBLE)) / k.near_ceil_depth))) AS INT) - 1 END,
        'sector_id', k.ps_id, 'plane_z', k.ps_ceil, 'plane', 'ceil', 'span_sky', k.ps_ceil_tex = 'F_SKY1',
        'sector_light', k.ps_light, 'source_priority', 0,
        'stable_id', CAST(NULL AS BIGINT), 'depth', CAST(NULL AS DOUBLE), 'u_col', CAST(NULL AS DOUBLE),
        'v0', CAST(NULL AS DOUBLE), 'v_step', CAST(NULL AS DOUBLE), 'ystart', CAST(NULL AS INT),
        'tex_w', CAST(NULL AS INT), 'tex_h', CAST(NULL AS INT), 'tex_width', CAST(NULL AS INT),
        'tex_id', CAST(NULL AS INT), 'light_bias', CAST(NULL AS INT)) END,
      named_struct(
        'kind', 2, 'y0', 0, 'y1', 168 - 1,
        'sector_id', CAST(NULL AS INT), 'plane_z', CAST(NULL AS INT), 'plane', CAST(NULL AS STRING),
        'span_sky', CAST(NULL AS BOOLEAN), 'sector_light', CAST(NULL AS INT), 'source_priority', CAST(NULL AS INT),
        'stable_id', CAST(NULL AS BIGINT), 'depth', CAST(NULL AS DOUBLE), 'u_col', CAST(NULL AS DOUBLE),
        'v0', CAST(NULL AS DOUBLE), 'v_step', CAST(NULL AS DOUBLE), 'ystart', CAST(NULL AS INT),
        'tex_w', CAST(NULL AS INT), 'tex_h', CAST(NULL AS INT), 'tex_width', CAST(NULL AS INT),
        'tex_id', CAST(NULL AS INT), 'light_bias', CAST(NULL AS INT))
    ) ELSE make_array(
      
      CASE WHEN k.tex IS NOT NULL AND k.tex <> '-'
            AND LEAST(k.y_top_f, k.y_bot_f) < 168 AND GREATEST(k.y_top_f, k.y_bot_f) >= 0
            AND k.y_end >= k.y_start THEN named_struct(
        'kind', 0, 'y0', k.y_start, 'y1', k.y_end,
        'sector_id', CAST(NULL AS INT), 'plane_z', CAST(NULL AS INT), 'plane', CAST(NULL AS STRING),
        'span_sky', CAST(NULL AS BOOLEAN), 'sector_light', k.f_light_lit, 'source_priority', CAST(NULL AS INT),
        'stable_id', CAST(CAST(k.seg_id AS BIGINT) * 8 + CASE k.part
            WHEN 'solid' THEN 0 WHEN 'upper' THEN 1 WHEN 'lower' THEN 2
            WHEN 'lower_down' THEN 3 ELSE 7 END AS BIGINT),
        'depth', k.depth_x, 'u_col', k.u_col, 'v0', k.v0, 'v_step', k.v_step, 'ystart', k.y_start,
        'tex_w', k.tex_w, 'tex_h', k.tex_h, 'tex_width', k.tex_width, 'tex_id', k.tex_id,
        'light_bias', k.light_bias) END,
      
      CASE WHEN k.is_panel AND k.part IN ('solid', 'upper', 'upper_open', 'upper_flush', 'midmask')
            AND k.ceil_y1 >= k.cc_before
            AND (k.own_ceil OR k.carried_ceil_is_sky OR k.cc_before > 0) THEN named_struct(
        'kind', 1, 'y0', GREATEST(0, k.cc_before), 'y1', k.ceil_y1,
        'sector_id', CASE WHEN k.own_ceil THEN k.fsec ELSE k.pc['sec'] END,
        'plane_z', CASE WHEN k.own_ceil THEN k.f_ceil ELSE k.pc['z'] END,
        'plane', 'ceil',
        'span_sky', CASE WHEN k.own_ceil THEN k.f_ceil_is_sky ELSE k.carried_ceil_is_sky END,
        'sector_light', CASE WHEN k.own_ceil THEN k.f_light_lit ELSE k.pc['light'] END,
        'source_priority', 1,
        'stable_id', CAST(NULL AS BIGINT), 'depth', CAST(NULL AS DOUBLE), 'u_col', CAST(NULL AS DOUBLE),
        'v0', CAST(NULL AS DOUBLE), 'v_step', CAST(NULL AS DOUBLE), 'ystart', CAST(NULL AS INT),
        'tex_w', CAST(NULL AS INT), 'tex_h', CAST(NULL AS INT), 'tex_width', CAST(NULL AS INT),
        'tex_id', CAST(NULL AS INT), 'light_bias', CAST(NULL AS INT)) END,
      
      CASE WHEN k.is_panel AND k.part IN ('solid', 'midmask', 'lower', 'lower_down')
            AND k.floor_y0 <= k.fc_before
            AND (k.own_floor OR k.fc_before < 168 - 1) THEN named_struct(
        'kind', 1, 'y0', k.floor_y0, 'y1', LEAST(168 - 1, k.fc_before),
        'sector_id', CASE WHEN k.own_floor THEN k.fsec ELSE k.pf['sec'] END,
        'plane_z', CASE WHEN k.own_floor THEN k.f_floor ELSE k.pf['z'] END,
        'plane', 'floor', 'span_sky', FALSE,
        'sector_light', CASE WHEN k.own_floor THEN k.f_light_lit ELSE k.pf['light'] END,
        'source_priority', 1,
        'stable_id', CAST(NULL AS BIGINT), 'depth', CAST(NULL AS DOUBLE), 'u_col', CAST(NULL AS DOUBLE),
        'v0', CAST(NULL AS DOUBLE), 'v_step', CAST(NULL AS DOUBLE), 'ystart', CAST(NULL AS INT),
        'tex_w', CAST(NULL AS INT), 'tex_h', CAST(NULL AS INT), 'tex_width', CAST(NULL AS INT),
        'tex_id', CAST(NULL AS INT), 'light_bias', CAST(NULL AS INT)) END
    ) END) AS sp
    FROM panel_bounds k
  ) b
  WHERE b.sp IS NOT NULL
),
spans_dedup AS (
  
  
  SELECT kind, col_x, y0, y1, sector_id, plane_z, plane, span_sky, stable_id,
         MIN(sector_light) AS sector_light, MIN(source_priority) AS source_priority,
         MIN(depth) AS depth, MIN(u_col) AS u_col, MIN(v0) AS v0, MIN(v_step) AS v_step,
         MIN(ystart) AS ystart, MIN(tex_w) AS tex_w, MIN(tex_h) AS tex_h,
         MIN(tex_width) AS tex_width, MIN(tex_id) AS tex_id, MIN(light_bias) AS light_bias,
         MAX(ps_light) AS ps_light
  FROM spans
  WHERE kind <> 1
     OR (y1 >= y0
         AND ((plane = 'floor' AND plane_z < CAST(${pz} AS DOUBLE))
              OR (plane = 'ceil' AND (plane_z > CAST(${pz} AS DOUBLE) OR span_sky))))
  GROUP BY kind, col_x, y0, y1, sector_id, plane_z, plane, span_sky, stable_id
),
spans_tex AS (
  SELECT d.*,
         CASE WHEN d.plane = 'floor' THEN s.floor_tex ELSE s.ceil_tex END AS tex_name,
         ft.flat_id
  FROM spans_dedup d
  LEFT JOIN sectors_lit s ON d.kind = 1 AND s.id = d.sector_id
  LEFT JOIN flat_textures ft
    ON ft.name = CASE WHEN d.plane = 'floor' THEN s.floor_tex ELSE s.ceil_tex END
  WHERE d.kind <> 1 OR s.id IS NOT NULL
),

span_pixels AS (
  SELECT d.*, unnest(range(CAST(d.y0 AS BIGINT), CAST(d.y1 AS BIGINT) + 1)) AS y FROM spans_tex d
),
plane_geom AS (
  SELECT p.*,
    CASE WHEN p.kind <> 1 THEN p.depth
         WHEN p.span_sky THEN 1e7
         ELSE ((160.0 / tan(radians(90.0) / 2.0)) * (p.plane_z - CAST(${pz} AS DOUBLE))) / NULLIF(84.0 - p.y, 0.0) END AS pdepth,
    (p.col_x - 160.0) / (160.0 / tan(radians(90.0) / 2.0)) AS tan_alpha,
    (p.tex_name = 'F_SKY1') AS tex_sky
  FROM span_pixels p
  WHERE p.kind <> 1 OR p.span_sky
     OR ((160.0 / tan(radians(90.0) / 2.0)) * (p.plane_z - CAST(${pz} AS DOUBLE))) / NULLIF(84.0 - p.y, 0.0) > 1e-3
),
plane_uv AS (
  SELECT g.*,
    CASE WHEN g.kind = 0 THEN
           CAST(FLOOR(g.u_col - g.tex_w * FLOOR(g.u_col / g.tex_w)) AS INT)
         WHEN g.kind = 1 AND g.tex_sky THEN
           ((CAST(FLOOR(degrees(radians(CAST(${angle} AS DOUBLE)) - ATAN(g.tan_alpha)) * (256.0 / 90.0)) AS INT)
             % CAST(256.0 AS INT)) + CAST(256.0 AS INT)) % CAST(256.0 AS INT)
         WHEN g.kind = 1 THEN
           ((CAST(FLOOR(CAST(${px} AS DOUBLE) + g.pdepth * COS(radians(CAST(${angle} AS DOUBLE))) + (g.tan_alpha * g.pdepth) * SIN(radians(CAST(${angle} AS DOUBLE)))) AS INT)
             % 64) + 64) % 64
    END AS u_i,
    CASE WHEN g.kind = 0 THEN
           ((CAST(FLOOR(g.v0 + (g.y - g.ystart) * g.v_step) AS INT) % g.tex_h + g.tex_h) % g.tex_h)
         WHEN g.kind = 1 AND g.tex_sky THEN
           (((g.y - 100) % 128) + 128) % 128
         WHEN g.kind = 1 THEN
           ((CAST(FLOOR(CAST(${py} AS DOUBLE) + g.pdepth * SIN(radians(CAST(${angle} AS DOUBLE))) - (g.tan_alpha * g.pdepth) * COS(radians(CAST(${angle} AS DOUBLE)))) AS INT)
             % 64) + 64) % 64
    END AS v_i
  FROM plane_geom g
),
view_fragments AS (
  
  SELECT u.kind, u.col_x AS x, u.y, u.pdepth AS depth, u.ps_light,
    CASE WHEN u.kind = 0 THEN
           ((CAST(1 AS BIGINT)) << (40)) | ((CAST(u.tex_id AS BIGINT)) << (20))
             | CAST(u.v_i * u.tex_width + u.u_i AS BIGINT)
         WHEN u.kind = 1 AND u.tex_sky THEN
           CASE WHEN u.v_i * 256 + u.u_i >= 0 THEN
             ((CAST(1 AS BIGINT)) << (40)) | ((CAST(691 AS BIGINT)) << (20))
               | CAST(u.v_i * 256 + u.u_i AS BIGINT) END
         WHEN u.kind = 1 THEN
           ((CAST(2 AS BIGINT)) << (40)) | ((CAST(u.flat_id AS BIGINT)) << (20))
             | CAST(u.v_i * 64 + u.u_i AS BIGINT)
    END AS tkey,
    CASE WHEN u.kind = 0 THEN u.stable_id
         ELSE CAST(CAST(u.sector_id AS BIGINT) * 2
                   + CASE WHEN u.plane = 'floor' THEN 0 ELSE 1 END AS BIGINT) END AS stable_id,
    CASE WHEN u.kind = 1 THEN u.source_priority ELSE 0 END AS source_priority,
    u.sector_light, u.light_bias, u.tex_sky,
    CAST(NULL AS BOOLEAN) AS fuzz, CAST(NULL AS BOOLEAN) AS fullbright,
    CAST(NULL AS INT) AS slot, CAST(NULL AS INT) AS layer
  FROM plane_uv u
),

thing_src AS (
  SELECT 0 AS src, CAST(t.id AS BIGINT) AS thing_id, CAST(t.x AS FLOAT) AS x, CAST(t.y AS FLOAT) AS y,
    CASE WHEN COALESCE(d.explodes, FALSE) AND ai.state='die' THEN d.death_sprite
         WHEN h.alive = FALSE AND (ai.state IS NULL OR ai.state = 'dead')
         THEN d.death_sprite ELSE rt.sprite END AS sprite,
    CASE WHEN h.alive = FALSE AND (ai.state IS NULL OR ai.state = 'dead')
           THEN CASE WHEN h.health < -h.max_health AND d.xdeath_frame IS NOT NULL
                     THEN d.xdeath_frame ELSE d.death_frame END
         WHEN f.frame IS NOT NULL THEN f.frame
         ELSE rt.frame END AS frame,
    CASE WHEN h.alive = FALSE AND (ai.state IS NULL OR ai.state = 'dead')
           THEN d.death_fullbright
         WHEN f.frame IS NOT NULL THEN f.fullbright
         ELSE rt.fullbright END AS fullbright,
    COALESCE(ai.sector_id, rt.sector_id) AS sector_ref,
    rt.spawn_ceiling, rt.thing_height, d.floats, h.alive, CAST(t.z AS FLOAT) AS z_raw,
    (t.x - CAST(${px} AS DOUBLE)) * COS(radians(CAST(${angle} AS DOUBLE))) + (t.y - CAST(${py} AS DOUBLE)) * SIN(radians(CAST(${angle} AS DOUBLE))) AS depth,
    (t.x - CAST(${px} AS DOUBLE)) * SIN(radians(CAST(${angle} AS DOUBLE))) - (t.y - CAST(${py} AS DOUBLE)) * COS(radians(CAST(${angle} AS DOUBLE))) AS side,
    (((CAST(FLOOR((DEGREES(ATAN2(t.y - CAST(${py} AS DOUBLE), t.x - CAST(${px} AS DOUBLE))) - t.angle + 202.5)
        / 45.0) AS INT) % 8) + 8) % 8 + 1) AS wanted_rotation,
    COALESCE(d.fuzzy, FALSE) AS fuzz
  FROM render_things rt
  JOIN things t ON t.map_id = rt.map_id AND t.id = rt.thing_id
  LEFT JOIN thing_health h ON h.map_id = rt.map_id AND h.thing_id = rt.thing_id
  LEFT JOIN thing_combat_defs d ON d.thing_type = t.type
  LEFT JOIN monster_ai ai ON ai.map_id = rt.map_id AND ai.thing_id = rt.thing_id
  LEFT JOIN thing_ai_frames f ON f.thing_type = t.type AND f.state = ai.state
    AND f.seq_index = ai.seq_index
  LEFT JOIN picked_up_items pu ON pu.map_id = rt.map_id AND pu.thing_id = rt.thing_id
  WHERE rt.map_id = 1
    AND (t.flags & 4) <> 0
    AND (t.flags & 16) = 0
    AND pu.thing_id IS NULL
    AND NOT (COALESCE(d.explodes, FALSE) AND ai.state='dead')
  UNION ALL
  SELECT 1, -e.effect_id, e.x, e.y, ed.sprite,
    substring(ed.frame_sequence,
              LEAST(length(ed.frame_sequence) - 1, e.age / ed.tics_per_frame) + 1, 1),
    ed.fullbright, e.sector_id, FALSE, 0, FALSE, TRUE, e.z,
    (e.x - CAST(${px} AS DOUBLE)) * COS(radians(CAST(${angle} AS DOUBLE))) + (e.y - CAST(${py} AS DOUBLE)) * SIN(radians(CAST(${angle} AS DOUBLE))),
    (e.x - CAST(${px} AS DOUBLE)) * SIN(radians(CAST(${angle} AS DOUBLE))) - (e.y - CAST(${py} AS DOUBLE)) * COS(radians(CAST(${angle} AS DOUBLE))),
    0, FALSE
  FROM world_effects e
  JOIN effect_sprite_defs ed ON ed.effect_type = e.effect_type
  WHERE e.map_id = 1
  UNION ALL
  SELECT 2, CAST(ot.id AS BIGINT), CAST(ot.x AS FLOAT), CAST(ot.y AS FLOAT),
    'PLAY', op.sprite_frame, FALSE, op.sector_id, FALSE, 0, FALSE, TRUE, CAST(NULL AS FLOAT),
    (ot.x - CAST(${px} AS DOUBLE)) * COS(radians(CAST(${angle} AS DOUBLE))) + (ot.y - CAST(${py} AS DOUBLE)) * SIN(radians(CAST(${angle} AS DOUBLE))),
    (ot.x - CAST(${px} AS DOUBLE)) * SIN(radians(CAST(${angle} AS DOUBLE))) - (ot.y - CAST(${py} AS DOUBLE)) * COS(radians(CAST(${angle} AS DOUBLE))),
    (((CAST(FLOOR((DEGREES(ATAN2(ot.y - CAST(${py} AS DOUBLE), ot.x - CAST(${px} AS DOUBLE)))
        - ot.angle + 202.5) / 45.0) AS INT) % 8) + 8) % 8 + 1),
    (op.invis_tics > 0)
  FROM player_state op
  JOIN things ot ON ot.map_id = op.map_id AND ot.id = op.player_thing_id
  WHERE op.map_id = 1 AND op.player_thing_id <> 157
  UNION ALL
  SELECT 3, -(CAST(1000000000000 AS BIGINT) + mp.projectile_id), mp.x, mp.y,
    CASE WHEN mp.state='fly' THEN pd.fly_sprite ELSE pd.impact_sprite END,
    CASE
      WHEN mp.projectile_type='rocket' THEN
        CASE WHEN mp.state='fly' THEN 'A' WHEN mp.age<8 THEN 'B'
             WHEN mp.age<14 THEN 'C' ELSE 'D' END
      WHEN mp.projectile_type='plasma' THEN
        CASE WHEN mp.state='fly' THEN CASE WHEN (mp.age%12)<6 THEN 'A' ELSE 'B' END
             WHEN mp.age<4 THEN 'A' WHEN mp.age<8 THEN 'B'
             WHEN mp.age<12 THEN 'C' WHEN mp.age<16 THEN 'D' ELSE 'E' END
      WHEN mp.projectile_type='bfg' THEN
        CASE WHEN mp.state='fly' THEN CASE WHEN (mp.age%8)<4 THEN 'A' ELSE 'B' END
             WHEN mp.age<8 THEN 'A' WHEN mp.age<16 THEN 'B'
             WHEN mp.age<24 THEN 'C' WHEN mp.age<32 THEN 'D'
             WHEN mp.age<40 THEN 'E' ELSE 'F' END
      ELSE CASE WHEN mp.state='fly'
             THEN CASE WHEN (mp.age%8)<4 THEN 'A' ELSE 'B' END
             WHEN mp.age<5 THEN 'C' WHEN mp.age<10 THEN 'D' ELSE 'E' END
    END,
    TRUE, mp.sector_id, FALSE, 0, FALSE, TRUE, mp.z,
    (mp.x - CAST(${px} AS DOUBLE)) * COS(radians(CAST(${angle} AS DOUBLE))) + (mp.y - CAST(${py} AS DOUBLE)) * SIN(radians(CAST(${angle} AS DOUBLE))),
    (mp.x - CAST(${px} AS DOUBLE)) * SIN(radians(CAST(${angle} AS DOUBLE))) - (mp.y - CAST(${py} AS DOUBLE)) * COS(radians(CAST(${angle} AS DOUBLE))),
    CASE WHEN mp.state='fly' THEN
      (((CAST(FLOOR((DEGREES(ATAN2(mp.y - CAST(${py} AS DOUBLE), mp.x - CAST(${px} AS DOUBLE)))
          - DEGREES(ATAN2(mp.vy, mp.vx)) + 202.5) / 45.0) AS INT) % 8) + 8) % 8 + 1)
      ELSE 0 END,
    FALSE
  FROM monster_projectiles mp
  JOIN projectile_defs pd ON pd.projectile_type = mp.projectile_type
  WHERE mp.map_id = 1
),
thing_view AS (
  
  
  SELECT ts.*,
    CAST(CASE WHEN ts.src = 0 THEN
                CASE WHEN ts.spawn_ceiling THEN s.ceil_height - ts.thing_height
                     WHEN ts.floats AND COALESCE(ts.alive, TRUE) THEN ts.z_raw
                     ELSE s.floor_height END
              WHEN ts.src = 2 THEN s.floor_height
              ELSE ts.z_raw END AS FLOAT) AS base_z,
    s.light_level AS sector_light
  FROM thing_src ts
  LEFT JOIN sectors_lit s ON s.id = ts.sector_ref
  WHERE ts.src IN (1, 3) OR s.id IS NOT NULL
),
thing_frame_choice AS (
  SELECT tv.*, f.lump_name, f.flipped, f.width, f.height, f.left_offset, f.top_offset,
         ROW_NUMBER() OVER (
           PARTITION BY tv.thing_id
           ORDER BY CASE WHEN f.rotation = tv.wanted_rotation THEN 0 ELSE 1 END
         ) AS pick
  FROM thing_view tv
  JOIN sprite_frames f
    ON f.sprite = tv.sprite AND f.frame = tv.frame
   AND f.rotation IN (0, tv.wanted_rotation)
),
thing_bounds AS (
  SELECT tp.*,
    tp.origin_x - tp.scale * tp.left_offset AS x_left_f,
    tp.origin_x + tp.scale * (tp.width - tp.left_offset) AS x_right_f,
    84.0 - tp.scale * (tp.base_z + tp.top_offset - CAST(${pz} AS DOUBLE)) AS y_top_f,
    84.0 - tp.scale * (tp.base_z + tp.top_offset - tp.height - CAST(${pz} AS DOUBLE)) AS y_bottom_f
  FROM (
    SELECT tv.*, sl.lump_id,
      (160.0 / tan(radians(90.0) / 2.0)) / tv.depth AS scale,
      160.0 + (160.0 / tan(radians(90.0) / 2.0)) * tv.side / tv.depth AS origin_x
    FROM thing_frame_choice tv
    JOIN sprite_lumps sl ON sl.lump_name = tv.lump_name
    WHERE tv.pick = 1 AND tv.depth >= 4.0 AND ABS(tv.side) <= tv.depth * 2.0
  ) tp
),
thing_cells AS (
  SELECT tb.*, unnest(range(CAST(GREATEST(0, CAST(FLOOR(tb.y_top_f) AS INT)) AS BIGINT), CAST(LEAST(168 - 1, CAST(CEIL(tb.y_bottom_f) AS INT) - 1) AS BIGINT) + 1)) AS screen_y
  FROM (
    SELECT tb0.*, unnest(range(CAST(GREATEST(0, CAST(FLOOR(tb0.x_left_f) AS INT)) AS BIGINT), CAST(LEAST(320 - 1, CAST(CEIL(tb0.x_right_f) AS INT) - 1) AS BIGINT) + 1)) AS screen_x
    FROM thing_bounds tb0
    WHERE tb0.x_right_f > 0 AND tb0.x_left_f < 320
      AND tb0.y_bottom_f > 0 AND tb0.y_top_f < 168
  ) tb
),
sprite_fragments AS (
  SELECT 3 AS kind, c.screen_x AS x, c.screen_y AS y, c.depth, CAST(NULL AS INT) AS ps_light,
    ((CAST(3 AS BIGINT)) << (40)) | ((CAST(c.lump_id AS BIGINT)) << (20))
      | CAST(c.v_i * c.width
             + CASE WHEN c.flipped THEN c.width - 1 - c.raw_u ELSE c.raw_u END AS BIGINT) AS tkey,
    c.thing_id AS stable_id, 0 AS source_priority, c.sector_light,
    CAST(NULL AS INT) AS light_bias, CAST(NULL AS BOOLEAN) AS tex_sky,
    c.fuzz, c.fullbright, mpl.slot, CAST(NULL AS INT) AS layer
  FROM (
    SELECT tc.*,
      LEAST(tc.height - 1, GREATEST(0,
        CAST(FLOOR((tc.screen_y - tc.y_top_f) / tc.scale) AS INT))) AS v_i,
      LEAST(tc.width - 1, GREATEST(0,
        CAST(FLOOR((tc.screen_x - tc.x_left_f) / tc.scale) AS INT))) AS raw_u
    FROM thing_cells tc
  ) c
  LEFT JOIN mp_players mpl ON mpl.map_id = 1 AND mpl.player_thing_id = c.thing_id
),

psprite_fragments AS (
  SELECT 4 AS kind, q.x, q.y, CAST(NULL AS DOUBLE) AS depth, CAST(NULL AS INT) AS ps_light,
    ((CAST(3 AS BIGINT)) << (40)) | ((CAST(q.lump_id AS BIGINT)) << (20))
      | CAST((q.y - CAST(FLOOR(q.y_top_f) AS INT)) * q.width
             + (q.x - CAST(FLOOR(q.x_left_f) AS INT)) AS BIGINT) AS tkey,
    CAST(NULL AS BIGINT) AS stable_id, 0 AS source_priority, CAST(NULL AS INT) AS sector_light,
    CAST(NULL AS INT) AS light_bias, CAST(NULL AS BOOLEAN) AS tex_sky,
    CAST(NULL AS BOOLEAN) AS fuzz, q.fullbright, CAST(NULL AS INT) AS slot, q.layer
  FROM (
    SELECT p.*, unnest(range(CAST(GREATEST(0, CAST(FLOOR(p.y_top_f) AS INT)) AS BIGINT), CAST(LEAST(168 - 1, CAST(FLOOR(p.y_top_f) AS INT) + p.height - 1) AS BIGINT) + 1)) AS y
    FROM (
      SELECT p0.*, unnest(range(CAST(GREATEST(0, CAST(FLOOR(p0.x_left_f) AS INT)) AS BIGINT), CAST(LEAST(320 - 1, CAST(FLOOR(p0.x_left_f) AS INT) + p0.width - 1) AS BIGINT) + 1)) AS x
      FROM (
        SELECT x0.l0['layer'] AS layer, x0.l0['fullbright'] AS fullbright, sf.width, sf.height, sl.lump_id,
               x0.l0['sx'] - sf.left_offset AS x_left_f,
               x0.l0['sy'] - sf.top_offset + 84.0 - 100.0 - 0.5 AS y_top_f
        FROM (
          SELECT unnest(make_array(
            named_struct('layer', 1, 'sprite', wr.sprite, 'frame', wr.frame,
                         'sx', CAST(wr.sx AS DOUBLE), 'sy', CAST(wr.sy AS DOUBLE),
                         'fullbright', COALESCE(wr.fullbright, FALSE)),
            CASE WHEN wr.flash_sprite IS NOT NULL AND wr.flash_frame IS NOT NULL THEN
              named_struct('layer', 2, 'sprite', wr.flash_sprite, 'frame', wr.flash_frame,
                           'sx', CAST(wr.sx AS DOUBLE), 'sy', CAST(wr.sy AS DOUBLE),
                           'fullbright', COALESCE(wr.flash_fullbright, TRUE)) END)) AS l0
          FROM weapon_runtime wr
        ) x0
        JOIN sprite_frames sf ON sf.sprite = x0.l0['sprite'] AND sf.frame = x0.l0['frame'] AND sf.rotation = 0
        JOIN sprite_lumps sl ON sl.lump_name = sf.lump_name
      ) p0
    ) p
  ) q
),

fragments AS (
  SELECT f.*,
         MAX(f.ps_light) OVER () AS cam_light,
         wr.extra_light, wr.invuln
  FROM weapon_runtime wr
  CROSS JOIN (
    SELECT * FROM view_fragments
    UNION ALL SELECT * FROM sprite_fragments
    UNION ALL SELECT * FROM psprite_fragments
  ) f
),
sampled AS (
  SELECT f.kind, f.y * 320 + f.x AS pix, f.depth, f.stable_id, f.source_priority, f.layer,
    CASE
      WHEN f.kind = 3 AND f.slot > 1 AND NULLIF(ascii(substr(tx.s, CAST(f.tkey & 255 AS INT) + 1, 1)) - 256, -210) BETWEEN 112 AND 127
        THEN NULLIF(ascii(substr(tx.s, CAST(f.tkey & 255 AS INT) + 1, 1)) - 256, -210) - 112 + CASE f.slot WHEN 2 THEN 96 WHEN 3 THEN 64 ELSE 32 END
      ELSE COALESCE(NULLIF(ascii(substr(tx.s, CAST(f.tkey & 255 AS INT) + 1, 1)) - 256, -210), 0) END AS palette_index,
    CASE
      WHEN f.kind = 0 THEN
        CASE WHEN f.invuln THEN 32
             ELSE GREATEST(0, LEAST(31, (15 - LEAST(15, GREATEST(0, CAST(FLOOR(CAST(f.sector_light AS DOUBLE) / 16.0) AS INT) + (f.light_bias + f.extra_light)))) * 4 - (CAST(FLOOR(LEAST(47.0, GREATEST(0.0, 2560.0 / NULLIF(CAST(f.depth AS DOUBLE), 0.0))) / 2.0) AS INT)))) END
      WHEN f.kind = 1 THEN
        CASE WHEN f.tex_sky THEN 0
             WHEN f.invuln THEN 32
             ELSE GREATEST(0, LEAST(31, (15 - LEAST(15, GREATEST(0, CAST(FLOOR(CAST(f.sector_light AS DOUBLE) / 16.0) AS INT) + (f.extra_light)))) * 4 - (CAST(FLOOR(80.0 / (LEAST(127, CAST(FLOOR(CAST(f.depth AS DOUBLE) / 16.0) AS INT)) + 1)) AS INT)))) END
      WHEN f.kind = 3 THEN
        CASE WHEN f.fuzz THEN CAST(26 + ((f.x * 7 + f.y * 13 + CAST((CASE WHEN (f.depth) - floor(f.depth) = 0.5 THEN 2.0 * round((f.depth) / 2.0) ELSE round(f.depth) END) AS INT)) % 5) AS INT)
             WHEN f.invuln THEN 32
             WHEN f.fullbright THEN 0
             ELSE GREATEST(0, LEAST(31, (15 - LEAST(15, GREATEST(0, CAST(FLOOR(CAST(COALESCE(f.sector_light, f.cam_light) AS DOUBLE) / 16.0) AS INT) + (f.extra_light)))) * 4 - (CAST(FLOOR(LEAST(47.0, GREATEST(0.0, 2560.0 / NULLIF(CAST(f.depth AS DOUBLE), 0.0))) / 2.0) AS INT)))) END
      WHEN f.kind = 4 THEN
        CASE WHEN f.invuln THEN 32
             WHEN f.fullbright THEN 0
             ELSE GREATEST(0, LEAST(31, (15 - LEAST(15, GREATEST(0, CAST(FLOOR(CAST(f.cam_light AS DOUBLE) / 16.0) AS INT) + (f.extra_light)))) * 4 - (23))) END
    END AS light_index
  FROM fragments f
  LEFT JOIN texel_chunks tx ON tx.ckey = (f.tkey >> 8)
  WHERE f.kind IN (0, 1, 2) OR NULLIF(ascii(substr(tx.s, CAST(f.tkey & 255 AS INT) + 1, 1)) - 256, -210) IS NOT NULL
),
resolved AS (
  SELECT pix,
    MIN(CASE WHEN kind IN (0, 1, 3) THEN
      ((CAST((CASE WHEN (GREATEST(0.0, LEAST(depth, 131071.0)) * 4096) - floor(GREATEST(0.0, LEAST(depth, 131071.0)) * 4096) = 0.5 THEN 2.0 * round((GREATEST(0.0, LEAST(depth, 131071.0)) * 4096) / 2.0) ELSE round(GREATEST(0.0, LEAST(depth, 131071.0)) * 4096) END) AS BIGINT)) << (34))
      | ((CAST(CASE kind WHEN 0 THEN 0 WHEN 3 THEN 1 ELSE 2 END AS BIGINT)) << (32))
      | ((LEAST(CAST(source_priority AS BIGINT), CAST(3 AS BIGINT))) << (30))
      | ((LEAST(CAST(65535 AS BIGINT), GREATEST(CAST(0 AS BIGINT), stable_id + 32768))) << (14))
      | ((CAST(light_index AS BIGINT)) << (8))
      | CAST(palette_index AS BIGINT) END) AS wk,
    MAX(CASE WHEN kind = 4 THEN
      ((CAST(layer AS BIGINT)) << (16)) | ((CAST(light_index AS BIGINT)) << (8))
      | CAST(palette_index AS BIGINT) END) AS pk
  FROM sampled
  GROUP BY pix
),

hud AS (
  SELECT ps.health, ps.alive, ps.pain_face_tics, ps.armor,
         ps.ammo_bullets, ps.ammo_shells, ps.ammo_rockets, ps.ammo_cells,
         ps.key_blue, ps.key_yellow, ps.key_red, ps.message, ps.message_tics,
         ps.backpack, wd.ammo_type AS current_ammo_type,
         CASE
           WHEN ps.damage_count > 0 THEN LEAST(7, (ps.damage_count + 7) / 8) + 1
           WHEN ps.bonus_count > 0 THEN LEAST(3, (ps.bonus_count + 7) / 8) + 9
           WHEN ps.radsuit_tics > 128 OR (ps.radsuit_tics & 8) <> 0 THEN 13
           ELSE 0 END AS pal
  FROM player_state ps
  LEFT JOIN player_weapons w ON w.map_id = ps.map_id AND w.player_thing_id = ps.player_thing_id
  LEFT JOIN weapon_defs wd ON wd.weapon_id = COALESCE(w.current_weapon, 2)
  WHERE ps.map_id = 1 AND ps.player_thing_id = 157
),
hud_numbers AS (
  
  SELECT x.n0['txt'] AS txt, x.n0['right_x'] AS right_x, x.n0['y'] AS y, x.n0['font'] AS font, x.n0['w'] AS w
  FROM (
    SELECT unnest(make_array(
      named_struct('txt', CAST(h.health AS STRING), 'right_x', 90, 'y', 168 + 4, 'font', 'STTNUM', 'w', 14),
      named_struct('txt', CAST(h.armor AS STRING), 'right_x', 221, 'y', 168 + 4, 'font', 'STTNUM', 'w', 14),
      CASE WHEN h.current_ammo_type IS NOT NULL THEN
        named_struct('txt', CAST(CASE h.current_ammo_type
            WHEN 'bullets' THEN h.ammo_bullets WHEN 'shells' THEN h.ammo_shells
            WHEN 'rockets' THEN h.ammo_rockets WHEN 'cells' THEN h.ammo_cells END AS STRING),
          'right_x', 44, 'y', 168 + 4, 'font', 'STTNUM', 'w', 14) END,
      named_struct('txt', CAST(h.ammo_bullets AS STRING), 'right_x', 288, 'y', 173, 'font', 'STYSNUM', 'w', 4),
      named_struct('txt', CAST(h.ammo_shells AS STRING), 'right_x', 288, 'y', 179, 'font', 'STYSNUM', 'w', 4),
      named_struct('txt', CAST(h.ammo_rockets AS STRING), 'right_x', 288, 'y', 185, 'font', 'STYSNUM', 'w', 4),
      named_struct('txt', CAST(h.ammo_cells AS STRING), 'right_x', 288, 'y', 191, 'font', 'STYSNUM', 'w', 4),
      named_struct('txt', CAST(CASE WHEN h.backpack THEN a.bullets_bp ELSE a.bullets END AS STRING), 'right_x', 314, 'y', 173, 'font', 'STYSNUM', 'w', 4),
      named_struct('txt', CAST(CASE WHEN h.backpack THEN a.shells_bp ELSE a.shells END AS STRING), 'right_x', 314, 'y', 179, 'font', 'STYSNUM', 'w', 4),
      named_struct('txt', CAST(CASE WHEN h.backpack THEN a.rockets_bp ELSE a.rockets END AS STRING), 'right_x', 314, 'y', 185, 'font', 'STYSNUM', 'w', 4),
      named_struct('txt', CAST(CASE WHEN h.backpack THEN a.cells_bp ELSE a.cells END AS STRING), 'right_x', 314, 'y', 191, 'font', 'STYSNUM', 'w', 4)
    )) AS n0
    FROM hud h
    CROSS JOIN (
      SELECT MAX(CASE WHEN ammo_type = 'bullets' THEN cap END) AS bullets,
             MAX(CASE WHEN ammo_type = 'bullets' THEN backpack_cap END) AS bullets_bp,
             MAX(CASE WHEN ammo_type = 'shells' THEN cap END) AS shells,
             MAX(CASE WHEN ammo_type = 'shells' THEN backpack_cap END) AS shells_bp,
             MAX(CASE WHEN ammo_type = 'rockets' THEN cap END) AS rockets,
             MAX(CASE WHEN ammo_type = 'rockets' THEN backpack_cap END) AS rockets_bp,
             MAX(CASE WHEN ammo_type NOT IN ('bullets', 'shells', 'rockets') THEN cap END) AS cells,
             MAX(CASE WHEN ammo_type NOT IN ('bullets', 'shells', 'rockets') THEN backpack_cap END) AS cells_bp
      FROM ammo_defs
    ) a
  ) x
  WHERE x.n0 IS NOT NULL
),
hud_layers AS (
  SELECT 1 AS layer, d.font || substring(d.txt, d.i, 1) AS patch,
         d.right_x - (length(d.txt) - d.i + 1) * d.w AS x, d.y
  FROM (SELECT hn.*, unnest(range(CAST(1 AS BIGINT), CAST(length(hn.txt) AS BIGINT) + 1)) AS i FROM hud_numbers hn) d
  UNION ALL
  SELECT y0.l0['layer'], y0.l0['patch'], y0.l0['x'], y0.l0['y']
  FROM (
    SELECT unnest(make_array(
      CASE WHEN h.key_blue THEN named_struct('layer', 1, 'patch', 'STKEYS0', 'x', 239, 'y', 171) END,
      CASE WHEN h.key_yellow THEN named_struct('layer', 1, 'patch', 'STKEYS1', 'x', 239, 'y', 181) END,
      CASE WHEN h.key_red THEN named_struct('layer', 1, 'patch', 'STKEYS2', 'x', 239, 'y', 191) END,
      named_struct('layer', 1, 'patch',
        CASE WHEN NOT h.alive THEN 'STFDEAD0'
             WHEN h.pain_face_tics > 0 THEN
               'STFOUCH' || CAST(LEAST(4, GREATEST(0, (100 - GREATEST(0, LEAST(100, h.health))) / 20)) AS STRING)
             ELSE 'STFST' || CAST(LEAST(4, GREATEST(0, (100 - GREATEST(0, LEAST(100, h.health))) / 20)) AS STRING) || '0'
        END, 'x', 143, 'y', 168)
    )) AS l0
    FROM hud h
  ) y0
  WHERE y0.l0 IS NOT NULL
  UNION ALL
  SELECT 2 AS layer,
         (CASE WHEN o.weapon_id IS NOT NULL THEN 'STYSNUM' ELSE 'STGNUM' END)
           || CAST(s.weapon_id AS STRING) AS patch,
         111 + ((s.weapon_id - 2) % 3) * 12 AS x,
         172 + ((s.weapon_id - 2) / 3) * 10 AS y
  FROM (SELECT unnest(range(CAST(2 AS BIGINT), CAST(7 AS BIGINT) + 1)) AS weapon_id) s
  LEFT JOIN (
    SELECT DISTINCT weapon_id FROM player_weapon_owned
    WHERE map_id = 1 AND player_thing_id = 157
  ) o ON o.weapon_id = s.weapon_id
),
hud_pixels AS (
  SELECT (l.y - p.top_offset + px.dy) * 320 + (l.x - p.left_offset + px.dx) AS pix,
         first_value(px.palette_index ORDER BY l.layer DESC) AS palette_index
  FROM hud_layers l
  JOIN ui_patches p ON p.name = l.patch
  JOIN ui_hud_pixels px ON px.name = l.patch
  GROUP BY (l.y - p.top_offset + px.dy) * 320 + (l.x - p.left_offset + px.dx)
),
message_pixels AS (
  SELECT (1 + px.dy) * 320 + CAST(COALESCE(mp.pen, 0) AS INT) + px.dx AS pix,
         MIN(px.palette_index) AS palette_index
  FROM (
    SELECT g.pos, g.patch,
           SUM(CASE WHEN g.ch = ' ' THEN 4 ELSE COALESCE(p.width, 4) END)
             OVER (ORDER BY g.pos ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS pen
    FROM (
      SELECT m.i AS pos, substring(upper(m.message), m.i, 1) AS ch,
             CASE WHEN substring(upper(m.message), m.i, 1) = ' ' THEN NULL
                  ELSE 'STCFN' || lpad(CAST(ascii(substring(upper(m.message), m.i, 1)) AS STRING), 3, '0')
             END AS patch
      FROM (SELECT h.message, unnest(range(CAST(1 AS BIGINT), CAST(length(h.message) AS BIGINT) + 1)) AS i FROM hud h
            WHERE h.message IS NOT NULL AND h.message_tics > 0) m
    ) g
    LEFT JOIN ui_patches p ON p.name = g.patch
  ) mp
  JOIN ui_hud_pixels px ON px.name = mp.patch
  WHERE CAST(COALESCE(mp.pen, 0) AS INT) + px.dx BETWEEN 0 AND 319
    AND 1 + px.dy BETWEEN 0 AND 167
  GROUP BY (1 + px.dy) * 320 + CAST(COALESCE(mp.pen, 0) AS INT) + px.dx
),

frame_index AS (
  
  SELECT r.pix,
    CASE WHEN m.palette_index IS NOT NULL THEN 0
         WHEN r.pk IS NOT NULL THEN CAST(((r.pk) >> (8)) & 255 AS INT)
         WHEN r.wk IS NOT NULL THEN CAST(((r.wk) >> (8)) & 63 AS INT) END AS level,
    CASE WHEN m.palette_index IS NOT NULL THEN m.palette_index
         WHEN r.pk IS NOT NULL THEN CAST(r.pk & 255 AS INT)
         WHEN r.wk IS NOT NULL THEN CAST(r.wk & 255 AS INT) END AS palette_index,
    0 AS fallback
  FROM resolved r
  LEFT JOIN message_pixels m ON m.pix = r.pix
  UNION ALL
  SELECT s.y * 320 + s.x,
    CASE WHEN o.palette_index IS NOT NULL OR h.pal <> 0 THEN 0 END,
    CASE WHEN o.palette_index IS NOT NULL THEN o.palette_index
         WHEN h.pal <> 0 THEN s.palette_index END,
    s.rgb
  FROM hud h
  CROSS JOIN ui_static_pixels s
  LEFT JOIN hud_pixels o ON o.pix = s.y * 320 + s.x
),
frame_px AS (
  SELECT f.pix, COALESCE(substr(cm.hex, f.palette_index * 6 + 1, 6), lpad(to_hex(f.fallback), 6, '0')) AS hex
  FROM frame_index f
  LEFT JOIN (SELECT cm.level, cm.hex FROM colormap_rows cm JOIN hud h ON cm.pal = h.pal) cm ON cm.level = f.level
)
SELECT y, line FROM (
  SELECT CAST(pix / 320 AS INT) AS y, string_agg(hex, '' ORDER BY pix) AS line FROM frame_px GROUP BY 1
  UNION ALL
  SELECT -1 AS y, CAST(MIN(ps_floor) AS VARCHAR) AS line FROM seg_ps
) ORDER BY y