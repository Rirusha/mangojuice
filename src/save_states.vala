// save_states.vala

using Gtk;
using Adw;
using Gee;

public class SaveStates {
    public static void save_states_to_file (MangoJuice mango_juice) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");

        try {
            if (!config_dir.query_exists ()) {
                config_dir.make_directory_with_parents ();
            }

            var data_stream = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            data_stream.put_string ("# Config Generated by MangoJuice #\n");
            data_stream.put_string ("legacy_layout=false\n");

            var custom_text_center = mango_juice.custom_text_center_entry.text;
            if (custom_text_center != "") {
                data_stream.put_string ("custom_text_center=%s\n".printf (custom_text_center));
            }

            var order_map = new HashMap<string, ArrayList<int>> ();

            var inform_start = new ArrayList<int> ();
            for (int i = 0; i < 4; i++) {
                inform_start.add (i);
            }
            order_map.set ("inform_start", inform_start);

            var inform_end = new ArrayList<int> ();
            inform_end.add (8);
            for (int i = 4; i < 8; i++) {
                inform_end.add (i);
            }
            order_map.set ("inform_end", inform_end);

            var gpu_start = new ArrayList<int> ();
            gpu_start.add (0);
            gpu_start.add (1);
            gpu_start.add (2);
            gpu_start.add (3);
            gpu_start.add (4);
            gpu_start.add (5);
            gpu_start.add (6);
            gpu_start.add (7);
            gpu_start.add (8);
            gpu_start.add (10);
            gpu_start.add (11);
            gpu_start.add (12);
            gpu_start.add (13);
            order_map.set ("gpu_start", gpu_start);

            var gpu_end = new ArrayList<int> ();
            gpu_end.add (9);
            gpu_end.add (14);
            order_map.set ("gpu_end", gpu_end);

            var system_start = new ArrayList<int> ();
            system_start.add (0);
            system_start.add (1);
            system_start.add (2);
            system_start.add (4);
            order_map.set ("system_start", system_start);

            var system_end = new ArrayList<int> ();
            system_end.add (3);
            order_map.set ("system_end", system_end);

            save_switches_to_file (data_stream, mango_juice.gpu_switches, mango_juice.gpu_config_vars, (int[]) order_map.get ("gpu_start").to_array ());

            int[] cpu_order = {0, 1, 2, 3, 4, 5, 6};
            save_switches_to_file (data_stream, mango_juice.cpu_switches, mango_juice.cpu_config_vars, cpu_order);

            int[] other_order = {0, 1, 2, 3, 4};
            save_switches_to_file (data_stream, mango_juice.other_switches, mango_juice.other_config_vars, other_order);

            save_switches_to_file (data_stream, mango_juice.inform_switches, mango_juice.inform_config_vars, (int[]) order_map.get ("inform_start").to_array ());

            save_switches_to_file (data_stream, mango_juice.system_switches, mango_juice.system_config_vars, (int[]) order_map.get ("system_end").to_array ());

            int[] options_order = {0 ,1, 2, 3, 4, 5, 6, 7, 8, 9};
            save_switches_to_file (data_stream, mango_juice.options_switches, mango_juice.options_config_vars, options_order);

            save_switches_to_file (data_stream, mango_juice.gpu_switches, mango_juice.gpu_config_vars, (int[]) order_map.get ("gpu_end").to_array ());

            save_switches_to_file (data_stream, mango_juice.system_switches, mango_juice.system_config_vars, (int[]) order_map.get ("system_start").to_array ());

            save_switches_to_file (data_stream, mango_juice.inform_switches, mango_juice.inform_config_vars, (int[]) order_map.get ("inform_end").to_array ());

            int[] battery_order = {0, 1, 2, 3, 4};
            save_switches_to_file (data_stream, mango_juice.battery_switches, mango_juice.battery_config_vars, battery_order);

            int[] other_extra_order = {1, 2, 0, 3, 4};
            save_switches_to_file (data_stream, mango_juice.other_extra_switches, mango_juice.other_extra_config_vars, other_extra_order);

            int[] wine_order = {0, 1, 2, 3};
            save_switches_to_file (data_stream, mango_juice.wine_switches, mango_juice.wine_config_vars, wine_order);

            var custom_command = mango_juice.custom_command_entry.text;
            if (custom_command != "") {
                data_stream.put_string ("%s\n".printf (custom_command));
            }

            if (mango_juice.logs_key_combo.selected_item != null) {
                var logs_key = (mango_juice.logs_key_combo.selected_item as StringObject)?.get_string () ?? "";
                if (logs_key != "") {
                    data_stream.put_string ("toggle_logging=%s\n".printf (logs_key));
                }
            }

            if (mango_juice.duracion_scale != null && (int)mango_juice.duracion_scale.get_value() != 0) {
                data_stream.put_string ("log_duration=%d\n".printf ( (int)mango_juice.duracion_scale.get_value ()));
            }
            if (mango_juice.autostart_scale != null && (int)mango_juice.autostart_scale.get_value() != 0) {
                data_stream.put_string ("autostart_log=%d\n".printf ( (int)mango_juice.autostart_scale.get_value ()));
            }
            if (mango_juice.interval_scale != null && (int)mango_juice.interval_scale.get_value() != 0) {
                data_stream.put_string ("log_interval=%d\n".printf ( (int)mango_juice.interval_scale.get_value ()));
            }

            var custom_logs_path = mango_juice.custom_logs_path_entry.text;
            if (custom_logs_path != "") {
                data_stream.put_string ("output_folder=%s\n".printf (custom_logs_path));
            }

            if (mango_juice.fps_limit_method.selected_item != null) {
                var fps_limit_method_value = (mango_juice.fps_limit_method.selected_item as StringObject)?.get_string () ?? "";
                data_stream.put_string ("fps_limit_method=%s\n".printf (fps_limit_method_value));
            }

            if (mango_juice.toggle_fps_limit.selected_item != null) {
                var toggle_fps_limit_value = (mango_juice.toggle_fps_limit.selected_item as StringObject)?.get_string () ?? "";
                data_stream.put_string ("toggle_fps_limit=%s\n".printf (toggle_fps_limit_value));
            }

            if (mango_juice.scale != null && (int)mango_juice.scale.get_value() != 0) {
                data_stream.put_string ("fps_limit=%d\n".printf ( (int)mango_juice.scale.get_value ()));
            }

            if (mango_juice.vulkan_dropdown.selected_item != null) {
                var vulkan_value = (mango_juice.vulkan_dropdown.selected_item as StringObject)?.get_string () ?? "";
                var vulkan_config_value = mango_juice.get_vulkan_config_value (vulkan_value);
                data_stream.put_string ("vsync=%s\n".printf (vulkan_config_value));
            }

            if (mango_juice.opengl_dropdown.selected_item != null) {
                var opengl_value = (mango_juice.opengl_dropdown.selected_item as StringObject)?.get_string () ?? "";
                var opengl_config_value = mango_juice.get_opengl_config_value (opengl_value);
                data_stream.put_string ("gl_vsync=%s\n".printf (opengl_config_value));
            }

            if (mango_juice.filter_dropdown.selected_item != null) {
                var filter_value = (mango_juice.filter_dropdown.selected_item as StringObject)?.get_string () ?? "";
                if (filter_value != "none") {
                    data_stream.put_string ("%s\n".printf (filter_value));
                }
            }

            if (mango_juice.af != null && (int)mango_juice.af.get_value () != 0) {
                data_stream.put_string ("af=%d\n".printf ( (int)mango_juice.af.get_value ()));
            }
            if (mango_juice.picmip != null && (int)mango_juice.picmip.get_value() != 0) {
                data_stream.put_string ("picmip=%d\n".printf ( (int)mango_juice.picmip.get_value ()));
            }

            if (mango_juice.custom_switch.active) {
                data_stream.put_string ("horizontal\n");
            }

            if (mango_juice.borders_scale != null) {
                data_stream.put_string ("round_corners=%d\n".printf ( (int)mango_juice.borders_scale.get_value ()));
            }

            if (mango_juice.alpha_scale != null) {
                double alpha_value = mango_juice.alpha_scale.get_value () / 100.0;
                string alpha_value_str = "%.1f".printf (alpha_value).replace (",", ".");
                data_stream.put_string ("background_alpha=%s\n".printf (alpha_value_str));
            }

            if (mango_juice.position_dropdown.selected_item != null) {
                var position_value = (mango_juice.position_dropdown.selected_item as StringObject)?.get_string () ?? "";
                data_stream.put_string ("position=%s\n".printf (position_value));
            }

            if (mango_juice.colums_scale != null) {
                data_stream.put_string ("table_columns=%d\n".printf ( (int)mango_juice.colums_scale.get_value ()));
            }

            if (mango_juice.toggle_hud_entry != null) {
                var toggle_hud_value = mango_juice.toggle_hud_entry.text;
                data_stream.put_string ("toggle_hud=%s\n".printf (toggle_hud_value));
            }

            if (mango_juice.font_size_scale != null) {
                data_stream.put_string ("font_size=%d\n".printf ( (int)mango_juice.font_size_scale.get_value ()));
            }

            if (mango_juice.font_dropdown.selected_item != null) {
                var font_file = (mango_juice.font_dropdown.selected_item as StringObject)?.get_string () ?? "";
                if (font_file != "Default") {
                    data_stream.put_string ("font_file=%s\n".printf (font_file));
                    data_stream.put_string ("font_glyph_ranges=korean, chinese, chinese_simplified, japanese, cyrillic, thai, vietnamese, latin_ext_a, latin_ext_b\n");
                }
            }

            if (mango_juice.gpu_text_entry != null) {
                var gpu_text = mango_juice.gpu_text_entry.text;
                if (gpu_text != "") {
                    data_stream.put_string ("gpu_text=%s\n".printf (gpu_text));
                }
            }

            if (mango_juice.gpu_color_button != null) {
                var gpu_color = mango_juice.rgba_to_hex (mango_juice.gpu_color_button.get_rgba ());
                if (gpu_color != "") {
                    data_stream.put_string ("gpu_color=%s\n".printf (gpu_color));
                }
            }

            if (mango_juice.cpu_text_entry != null) {
                var cpu_text = mango_juice.cpu_text_entry.text;
                if (cpu_text != "") {
                    data_stream.put_string ("cpu_text=%s\n".printf (cpu_text));
                }
            }

            if (mango_juice.cpu_color_button != null) {
                var cpu_color = mango_juice.rgba_to_hex (mango_juice.cpu_color_button.get_rgba ());
                if (cpu_color != "") {
                    data_stream.put_string ("cpu_color=%s\n".printf (cpu_color));
                }
            }

            if (mango_juice.fps_value_entry_1 != null && mango_juice.fps_value_entry_2 != null) {
                var fps_value_1 = mango_juice.fps_value_entry_1.text;
                var fps_value_2 = mango_juice.fps_value_entry_2.text;
                if (fps_value_1 != "" && fps_value_2 != "") {
                    data_stream.put_string ("fps_value=%s,%s\n".printf (fps_value_1, fps_value_2));
                }
            }

            if (mango_juice.fps_color_button_1 != null && mango_juice.fps_color_button_2 != null && mango_juice.fps_color_button_3 != null) {
                var fps_color_1 = mango_juice.rgba_to_hex (mango_juice.fps_color_button_1.get_rgba ());
                var fps_color_2 = mango_juice.rgba_to_hex (mango_juice.fps_color_button_2.get_rgba ());
                var fps_color_3 = mango_juice.rgba_to_hex (mango_juice.fps_color_button_3.get_rgba ());
                if (fps_color_1 != "" && fps_color_2 != "" && fps_color_3 != "") {
                    data_stream.put_string ("fps_color=%s,%s,%s\n".printf (fps_color_1, fps_color_2, fps_color_3));
                }
            }

            if (mango_juice.gpu_load_value_entry_1 != null && mango_juice.gpu_load_value_entry_2 != null) {
                var gpu_load_value_1 = mango_juice.gpu_load_value_entry_1.text;
                var gpu_load_value_2 = mango_juice.gpu_load_value_entry_2.text;
                if (gpu_load_value_1 != "" && gpu_load_value_2 != "") {
                    data_stream.put_string ("gpu_load_value=%s,%s\n".printf (gpu_load_value_1, gpu_load_value_2));
                }
            }

            if (mango_juice.gpu_load_color_button_1 != null && mango_juice.gpu_load_color_button_2 != null && mango_juice.gpu_load_color_button_3 != null) {
                var gpu_load_color_1 = mango_juice.rgba_to_hex (mango_juice.gpu_load_color_button_1.get_rgba ());
                var gpu_load_color_2 = mango_juice.rgba_to_hex (mango_juice.gpu_load_color_button_2.get_rgba ());
                var gpu_load_color_3 = mango_juice.rgba_to_hex (mango_juice.gpu_load_color_button_3.get_rgba ());
                if (gpu_load_color_1 != "" && gpu_load_color_2 != "" && gpu_load_color_3 != "") {
                    data_stream.put_string ("gpu_load_color=%s,%s,%s\n".printf (gpu_load_color_1, gpu_load_color_2, gpu_load_color_3));
                }
            }

            if (mango_juice.cpu_load_value_entry_1 != null && mango_juice.cpu_load_value_entry_2 != null) {
                var cpu_load_value_1 = mango_juice.cpu_load_value_entry_1.text;
                var cpu_load_value_2 = mango_juice.cpu_load_value_entry_2.text;
                if (cpu_load_value_1 != "" && cpu_load_value_2 != "") {
                    data_stream.put_string ("cpu_load_value=%s,%s\n".printf (cpu_load_value_1, cpu_load_value_2));
                }
            }

            if (mango_juice.cpu_load_color_button_1 != null && mango_juice.cpu_load_color_button_2 != null && mango_juice.cpu_load_color_button_3 != null) {
                var cpu_load_color_1 = mango_juice.rgba_to_hex (mango_juice.cpu_load_color_button_1.get_rgba ());
                var cpu_load_color_2 = mango_juice.rgba_to_hex (mango_juice.cpu_load_color_button_2.get_rgba ());
                var cpu_load_color_3 = mango_juice.rgba_to_hex (mango_juice.cpu_load_color_button_3.get_rgba ());
                if (cpu_load_color_1 != "" && cpu_load_color_2 != "" && cpu_load_color_3 != "") {
                    data_stream.put_string ("cpu_load_color=%s,%s,%s\n".printf (cpu_load_color_1, cpu_load_color_2, cpu_load_color_3));
                }
            }

            if (mango_juice.background_color_button != null) {
                var background_color = mango_juice.rgba_to_hex (mango_juice.background_color_button.get_rgba ());
                if (background_color != "") {
                    data_stream.put_string ("background_color=%s\n".printf (background_color));
                }
            }

            if (mango_juice.frametime_color_button != null) {
                var frametime_color = mango_juice.rgba_to_hex (mango_juice.frametime_color_button.get_rgba ());
                if (frametime_color != "") {
                    data_stream.put_string ("frametime_color=%s\n".printf (frametime_color));
                }
            }

            if (mango_juice.vram_color_button != null) {
                var vram_color = mango_juice.rgba_to_hex (mango_juice.vram_color_button.get_rgba ());
                if (vram_color != "") {
                    data_stream.put_string ("vram_color=%s\n".printf (vram_color));
                }
            }

            if (mango_juice.ram_color_button != null) {
                var ram_color = mango_juice.rgba_to_hex (mango_juice.ram_color_button.get_rgba ());
                if (ram_color != "") {
                    data_stream.put_string ("ram_color=%s\n".printf (ram_color));
                }
            }

            if (mango_juice.wine_color_button != null) {
                var wine_color = mango_juice.rgba_to_hex (mango_juice.wine_color_button.get_rgba ());
                if (wine_color != "") {
                    data_stream.put_string ("wine_color=%s\n".printf (wine_color));
                }
            }

            if (mango_juice.engine_color_button != null) {
                var engine_color = mango_juice.rgba_to_hex (mango_juice.engine_color_button.get_rgba ());
                if (engine_color != "") {
                    data_stream.put_string ("engine_color=%s\n".printf (engine_color));
                }
            }

            if (mango_juice.text_color_button != null) {
                var text_color = mango_juice.rgba_to_hex (mango_juice.text_color_button.get_rgba ());
                if (text_color != "") {
                    data_stream.put_string ("text_color=%s\n".printf (text_color));
                }
            }

            if (mango_juice.media_player_color_button != null) {
                var media_player_color = mango_juice.rgba_to_hex (mango_juice.media_player_color_button.get_rgba ());
                if (media_player_color != "") {
                    data_stream.put_string ("media_player_color=%s\n".printf (media_player_color));
                }
            }

            if (mango_juice.network_color_button != null) {
                var network_color = mango_juice.rgba_to_hex (mango_juice.network_color_button.get_rgba ());
                if (network_color != "") {
                    data_stream.put_string ("network_color=%s".printf (network_color));
                }
            }

            data_stream.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public static void save_switches_to_file (DataOutputStream data_stream, Switch[] switches, string[] config_vars, int[] order) {
        for (int i = 0; i < order.length; i++) {
            int index = order[i];
            if (switches[index].active) {
                try {
                    string config_var = config_vars[index];
                    if (config_var == "io_read \n io_write") {
                        data_stream.put_string ("io_read\n");
                        data_stream.put_string ("io_write\n");
                    } else {
                        data_stream.put_string ("%s\n".printf (config_var));
                    }
                } catch (Error e) {
                    stderr.printf ("Error writing to the file: %s\n", e.message);
                }
            }
        }
    }
}

