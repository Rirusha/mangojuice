using Gtk;
using GLib;
using Adw;
using Gee;

public class MangoJuice : Adw.Application {
    private Button save_button;
    private Button reset_button;
    private Button logs_path_button;
    private Button intel_power_fix_button;
    private Switch[] gpu_switches;
    private Switch[] cpu_switches;
    private Switch[] other_switches;
    private Switch[] system_switches;
    private Switch[] wine_switches;
    private Switch[] options_switches;
    private Switch[] battery_switches;
    private Switch[] other_extra_switches;
    private Switch[] inform_switches;
    private Label[] gpu_labels;
    private Label[] cpu_labels;
    private Label[] other_labels;
    private Label[] system_labels;
    private Label[] wine_labels;
    private Label[] options_labels;
    private Label[] battery_labels;
    private Label[] other_extra_labels;
    private Label[] inform_labels;
    private Entry custom_command_entry;
    private Entry custom_logs_path_entry;
    private DropDown logs_key_combo;
    private DropDown fps_limit_method;
    private DropDown toggle_fps_limit;
    private DropDown vulcan_dropdown;
    private DropDown opengl_dropdown;
    private Scale duracion_scale;
    private Scale autostart_scale;
    private Scale interval_scale;
    private Scale scale;
    private Label duracion_value_label;
    private Label autostart_value_label;
    private Label interval_value_label;
    private Label fps_limit_label;
    private Gtk.StringList logs_key_model;
    private DropDown filter_dropdown;
    private Scale af;
    private Scale picmip;
    private Label af_label;
    private Label picmip_label;
    private const string GPU_TITLE = "GPU";
    private const string CPU_TITLE = "CPU";
    private const string OTHER_TITLE = "Other";
    private const string SYSTEM_TITLE = "System";
    private const string WINE_TITLE = "Wine";
    private const string OPTIONS_TITLE = "Options";
    private const string BATTERY_TITLE = "Battery";
    private const string OTHER_EXTRA_TITLE = "Other";
    private const string INFORM_TITLE = "Information";
    private const string LIMITERS_TITLE = "Limiters FPS";
    private const string FILTERS_TITLE = "Filters";
    private const int MAIN_BOX_SPACING = 10;
    private const int FLOW_BOX_ROW_SPACING = 10;
    private const int FLOW_BOX_COLUMN_SPACING = 10;
    private const int FLOW_BOX_MARGIN = 10;
    private string[] gpu_config_vars = {
        "gpu_stats", "gpu_load_change", "vram", "gpu_core_clock", "gpu_mem_clock",
        "gpu_temp", "gpu_mem_temp", "gpu_junction_temp", "gpu_fan", "gpu_name",
        "gpu_power", "gpu_voltage", "throttling_status", "throttling_status_graph", "vulkan_driver"
    };
    private string[] cpu_config_vars = {
        "cpu_stats", "cpu_load_change", "core_load", "core_bars", "cpu_mhz", "cpu_temp",
        "cpu_power"
    };
    private string[] other_config_vars = {
        "ram", "io_read", "procmem", "swap"
    };
    private string[] system_config_vars = {
        "exec=lsb_release -d | cut -f2", "refresh_rate", "resolution", "exec=echo $XDG_SESSION_TYPE",
        "time", "arch"
    };
    private string[] wine_config_vars = {
        "wine", "engine", "engine_short_names"
    };
    private string[] battery_config_vars = {
        "battery", "battery_watt", "battery_time", "device_battery"
    };
    private string[] other_extra_config_vars = {
        "media_player", "network", "full", "log_versioning", "upload_logs"
    };
    private string[] inform_config_vars = {
        "fps", "fps_color_change", "fps_metrics=avg,0.01", "fps_metrics=avg,0.001", "show_fps_limit", "frame_timing", "histogram", "frame_count"
    };
    private string[] options_config_vars = {
        "version", "gamemode", "vkbasalt", "fcat", "fsr", "hdr"
    };
    private string[] gpu_label_texts = {
        "GPU Load", "Load Color", "VRAM", "Core Freq", "Mem Freq",
        "GPU Temp", "Memory Temp", "Juntion", "Fans", "Model",
        "Power", "Voltage", "Throttling", "Throttling GRAPH", "Vulcan Driver"
    };
    private string[] cpu_label_texts = {
        "CPU Load", "CPU Load Color", "CPU Core Load", "CPU Core Bars", "CPU Freq", "CPU Temp",
        "CPU Power"
    };
    private string[] other_label_texts = {
        "RAM", "Disk IO", "Procces", "Swap"
    };
    private string[] system_label_texts = {
        "Distro", "Refresh rate*", "Resolution", "Session",
        "Time", "Arch"
    };
    private string[] wine_label_texts = {
        "Version", "Engine Ver", "Short names"
    };
    private string[] options_label_texts = {
        "Hud Version", "Gamemode", "VKbasalt", "Fcat", "FSR*", "HDR*"
    };
    private string[] battery_label_texts = {
        "Percentage", "Wattage", "Time remain", "Device"
    };
    private string[] other_extra_label_texts = {
        "Media", "Network", "Full ON", "Log Versioning", "Upload Results"
    };
    private string[] inform_label_texts = {
        "FPS", "FPS Color", "FPS low 1%", "FPS low 0.1%", "Frame limit", "Frame time", "Histogram/Curve", "Frame"
    };
    private bool test_button_pressed = false;
    private Entry custom_text_center_entry;
    private Switch custom_switch;
    private Scale borders_scale;
    private Scale alpha_scale;
    private Label borders_value_label;
    private Label alpha_value_label;
    private DropDown position_dropdown;
    private Scale colums_scale;
    private Label colums_value_label;
    private Entry toggle_hud_entry;
    private Scale font_size_scale;
    private Label font_size_value_label;
    private DropDown font_dropdown;

    private string[] vulcan_values = { "Unset", "ON", "Adaptive", "Mailbox", "OFF" };
    private string[] vulcan_config_values = { "0", "3", "0", "2", "1" };

    private string[] opengl_values = { "Unset", "ON", "Adaptive", "Mailbox", "OFF" };
    private string[] opengl_config_values = { "-1", "n", "-1", "1", "0" };

    private Entry gpu_text_entry;
    private ColorDialogButton gpu_color_button;
    private Entry cpu_text_entry;
    private ColorDialogButton cpu_color_button;

    public MangoJuice () {
        Object (application_id: "io.github.radiolamp.mangojuice", flags: ApplicationFlags.DEFAULT_FLAGS);
        set_resource_base_path ("/usr/local/share/icons/hicolor/scalable/apps/");
    }

    protected override void activate () {
        var window = new Adw.ApplicationWindow (this);
        window.set_default_size (955, 600);
        window.set_title ("MangoJuice");

        var main_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        main_box.set_homogeneous (true);

        var scrolled_window = new ScrolledWindow ();
        scrolled_window.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
        scrolled_window.set_vexpand (true);

        var view_stack = new ViewStack ();
        var toolbar_view_switcher = new ViewSwitcher ();
        toolbar_view_switcher.stack = view_stack;

        var metrics_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var extras_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var performance_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var visual_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);

        initialize_switches_and_labels (metrics_box, extras_box, performance_box, visual_box);
        initialize_custom_controls (extras_box, visual_box);

        view_stack.add_titled (metrics_box, "metrics_box", "Metrics").icon_name = "io.github.radiolamp.mangojuice-metrics-symbolic";
        view_stack.add_titled (extras_box, "extras_box", "Extras").icon_name = "io.github.radiolamp.mangojuice-extras-symbolic";
        view_stack.add_titled (performance_box, "performance_box", "Performance").icon_name = "io.github.radiolamp.mangojuice-performance-symbolic";
        view_stack.add_titled (visual_box, "visual_box", "Visual").icon_name = "io.github.radiolamp.mangojuice-visual-symbolic";

        var header_bar = new Adw.HeaderBar ();
        header_bar.set_title_widget (toolbar_view_switcher);

        save_button = new Button.with_label ("Save");
        save_button.add_css_class ("suggested-action");
        header_bar.pack_end (save_button);
        save_button.clicked.connect ( () => {
            save_states_to_file ();
            if (test_button_pressed) restart_vkcube ();
        });

        var test_button = new Button.with_label ("Test");
        test_button.clicked.connect ( () => {
            try {
                Process.spawn_command_line_sync ("pkill vkcube");
                Process.spawn_command_line_async ("mangohud vkcube");
                test_button_pressed = true;
            } catch (Error e) {
                stderr.printf ("Ошибка при запуске команды: %s\n", e.message);
            }
        });
        header_bar.pack_start (test_button);

        var content_box = new Box (Orientation.VERTICAL, 0);
        content_box.append (header_bar);
        content_box.append (scrolled_window);
        window.set_content (content_box);
        scrolled_window.set_child (view_stack);

        window.present ();
        load_states_from_file ();

        var gpu_color = Gdk.RGBA ();
        gpu_color.parse ("#2e9762");
        gpu_color_button.set_rgba (gpu_color);

        var cpu_color = Gdk.RGBA ();
        cpu_color.parse ("#2e97cb");
        cpu_color_button.set_rgba (cpu_color);

        window.close_request.connect ( () => {
            if (is_vkcube_running ()) {
                try {
                    Process.spawn_command_line_sync ("pkill vkcube");
                } catch (Error e) {
                    stderr.printf ("Ошибка при закрытии vkcube: %s\n", e.message);
                }
            }
            return false;
        });

        inform_switches[1].notify["active"].connect ( () => {
            if (inform_switches[1].active) inform_switches[2].active = false;
        });

        inform_switches[2].notify["active"].connect ( () => {
            if (inform_switches[2].active) inform_switches[1].active = false;
        });

        add_scroll_event_handler (duracion_scale);
        add_scroll_event_handler (autostart_scale);
        add_scroll_event_handler (interval_scale);
        add_scroll_event_handler (scale);
        add_scroll_event_handler (af);
        add_scroll_event_handler (picmip);
        add_scroll_event_handler (borders_scale);
        add_scroll_event_handler (colums_scale);
        add_scroll_event_handler (font_size_scale);

        var css_provider = new Gtk.CssProvider ();
        css_provider.load_from_string ("""
            .viewswitcher .viewswitcher-icon {
                color: @theme_fg_color;
            }
            .bold-label {
                font-weight: bold;
            }
        """);

        toolbar_view_switcher.add_css_class ("viewswitcher");
        var style_manager = Adw.StyleManager.get_default ();
        style_manager.set_color_scheme (Adw.ColorScheme.DEFAULT);

        if (!is_vkcube_available ()) {
            test_button.set_visible (false);
        }

    }

    private void add_scroll_event_handler (Scale scale) {
        var controller = new EventControllerScroll (EventControllerScrollFlags.VERTICAL);
        controller.scroll.connect ( (dx, dy) => {
            double delta = 0;
            if (dy > 0) {
                delta = -1;
            } else if (dy < 0) {
                delta = 1;
            }
            scale.set_value (scale.get_value () + delta);
            return true;
        });
        scale.add_controller (controller);
    }

    private void initialize_switches_and_labels (Box metrics_box, Box extras_box, Box performance_box, Box visual_box) {
        gpu_switches = new Switch[gpu_config_vars.length];
        cpu_switches = new Switch[cpu_config_vars.length];
        other_switches = new Switch[other_config_vars.length];
        system_switches = new Switch[system_config_vars.length];
        wine_switches = new Switch[wine_config_vars.length];
        options_switches = new Switch[options_config_vars.length];
        battery_switches = new Switch[battery_config_vars.length];
        other_extra_switches = new Switch[other_extra_config_vars.length];
        inform_switches = new Switch[inform_config_vars.length];

        gpu_labels = new Label[gpu_label_texts.length];
        cpu_labels = new Label[cpu_label_texts.length];
        other_labels = new Label[other_label_texts.length];
        system_labels = new Label[system_label_texts.length];
        wine_labels = new Label[wine_label_texts.length];
        options_labels = new Label[options_label_texts.length];
        battery_labels = new Label[battery_label_texts.length];
        other_extra_labels = new Label[other_extra_label_texts.length];
        inform_labels = new Label[inform_label_texts.length];

        create_switches_and_labels (metrics_box, GPU_TITLE, gpu_switches, gpu_labels, gpu_config_vars, gpu_label_texts);
        create_switches_and_labels (metrics_box, CPU_TITLE, cpu_switches, cpu_labels, cpu_config_vars, cpu_label_texts);
        create_switches_and_labels (metrics_box, OTHER_TITLE, other_switches, other_labels, other_config_vars, other_label_texts);
        create_switches_and_labels (extras_box, SYSTEM_TITLE, system_switches, system_labels, system_config_vars, system_label_texts);
        create_switches_and_labels (extras_box, WINE_TITLE, wine_switches, wine_labels, wine_config_vars, wine_label_texts);
        create_switches_and_labels (extras_box, OPTIONS_TITLE, options_switches, options_labels, options_config_vars, options_label_texts);
        create_switches_and_labels (extras_box, BATTERY_TITLE, battery_switches, battery_labels, battery_config_vars, battery_label_texts);
        create_switches_and_labels (extras_box, OTHER_EXTRA_TITLE, other_extra_switches, other_extra_labels, other_extra_config_vars, other_extra_label_texts);
        create_scales_and_labels (extras_box);
        create_switches_and_labels (performance_box, INFORM_TITLE, inform_switches, inform_labels, inform_config_vars, inform_label_texts);
        create_limiters_and_filters (performance_box);

        cpu_switches[3].notify["active"].connect ( () => {
            if (cpu_switches[3].active) {
                cpu_switches[2].active = true;
            }
        });

        cpu_switches[3].notify["active"].connect ( () => {
            if (!cpu_switches[3].active) {
                cpu_switches[2].active = false;
            }
        });

        inform_switches[5].notify["active"].connect ( () => {
            if (inform_switches[5].active) {
                inform_switches[4].active = true;
            }
        });

        inform_switches[5].notify["active"].connect ( () => {
            if (!inform_switches[5].active) {
                inform_switches[4].active = false;
            }
        });

        for (int i = 1; i < gpu_switches.length; i++) {
            gpu_switches[i].notify["active"].connect ( () => {
                update_gpu_stats_state ();
            });
        }

        for (int i = 1; i < cpu_switches.length; i++) {
            cpu_switches[i].notify["active"].connect ( () => {
                update_cpu_stats_state ();
            });
        }
    }

    private void update_gpu_stats_state () {
        bool any_gpu_switch_active = false;

        for (int i = 1; i < gpu_switches.length; i++) {
            if (gpu_switches[i].active && gpu_config_vars[i] != "vram" && gpu_config_vars[i] != "gpu_name") {
                any_gpu_switch_active = true;
                break;
            }
        }

        gpu_switches[0].active = any_gpu_switch_active;
    }

    private void update_cpu_stats_state () {
        bool any_cpu_switch_active = false;

        for (int i = 1; i < cpu_switches.length; i++) {
            if (cpu_switches[i].active && cpu_config_vars[i] != "core_load" && cpu_config_vars[i] != "core_bars") {
                any_cpu_switch_active = true;
                break;
            }
        }

        cpu_switches[0].active = any_cpu_switch_active;
    }

    private void initialize_custom_controls (Box extras_box, Box visual_box) {
        custom_command_entry = new Entry ();
        custom_command_entry.placeholder_text = "Raw Custom Cmd";
        custom_command_entry.hexpand = true;

        custom_logs_path_entry = new Entry ();
        custom_logs_path_entry.placeholder_text = "Home";

        logs_path_button = new Button.with_label ("Folder logs");
        logs_path_button.clicked.connect ( () => open_folder_chooser_dialog ());

        intel_power_fix_button = new Button.with_label ("Intel Power Fix");
        intel_power_fix_button.clicked.connect ( () => {
            try {
                Process.spawn_command_line_sync ("pkexec chmod 0644 /sys/class/powercap/intel-rapl\\:0/energy_uj");
            } catch (Error e) {
                stderr.printf ("Ошибка при выполнении команды: %s\n", e.message);
            }
        });

        logs_key_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "Shift_L+F2", "Shift_L+F3", "Shift_L+F4", "Shift_L+F5" }) {
            logs_key_model.append (item);
        }
        logs_key_combo = new DropDown (logs_key_model, null);
        logs_key_combo.notify["selected-item"].connect ( () => {
            update_logs_key_in_file ( (logs_key_combo.selected_item as StringObject)?.get_string () ?? "");
        });

        reset_button = new Button.with_label ("Reset Config");
        reset_button.add_css_class ("destructive-action");
        reset_button.clicked.connect ( () => {
            delete_mangohub_conf ();
            restart_application ();
        });

        var custom_command_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        custom_command_box.set_margin_start (FLOW_BOX_MARGIN);
        custom_command_box.set_margin_end (FLOW_BOX_MARGIN);
        custom_command_box.set_margin_top (FLOW_BOX_MARGIN);
        custom_command_box.set_margin_bottom (FLOW_BOX_MARGIN);
        custom_command_box.append (custom_command_entry);
        custom_command_box.append (new Label ("Logs key"));
        custom_command_box.append (logs_key_combo);
        custom_command_box.append (new Label (""));
        custom_command_box.append (custom_logs_path_entry);
        custom_command_box.append (logs_path_button);
        custom_command_box.append (intel_power_fix_button);
        custom_command_box.append (reset_button);
        extras_box.append (custom_command_box);

        var customize_label = new Label ("Customize");
        customize_label.set_halign (Align.CENTER);
        customize_label.set_margin_top (FLOW_BOX_MARGIN);
        customize_label.set_margin_start (FLOW_BOX_MARGIN);
        customize_label.set_margin_end (FLOW_BOX_MARGIN);
        var customize_font_description = new Pango.FontDescription ();
        customize_font_description.set_weight (Pango.Weight.BOLD);
        var customize_attr_list = new Pango.AttrList ();
        customize_attr_list.insert (new Pango.AttrFontDesc (customize_font_description));
        customize_label.set_attributes (customize_attr_list);
        visual_box.append (customize_label);

        custom_text_center_entry = new Entry ();
        custom_text_center_entry.placeholder_text = "You text";
        custom_text_center_entry.hexpand = true;

        var customize_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        customize_box.set_margin_start (FLOW_BOX_MARGIN);
        customize_box.set_margin_end (FLOW_BOX_MARGIN);
        customize_box.set_margin_top (FLOW_BOX_MARGIN);
        customize_box.set_margin_bottom (FLOW_BOX_MARGIN);
        customize_box.append (custom_text_center_entry);
        visual_box.append (customize_box);

        var custom_switch_label = new Label ("Horizontal Hud");
        custom_switch_label.set_halign (Align.CENTER);

        custom_switch = new Switch ();
        custom_switch.set_valign (Align.CENTER);
        custom_switch.set_margin_end (FLOW_BOX_MARGIN);

        borders_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 15, -1);
        borders_scale.set_hexpand (true);
        borders_value_label = new Label ("");
        borders_value_label.set_halign (Align.END);
        borders_scale.value_changed.connect ( () => borders_value_label.label = "%d".printf ( (int)borders_scale.get_value ()));

        alpha_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 100, 1);
        alpha_scale.set_hexpand (true);
        alpha_scale.set_value (50);
        alpha_value_label = new Label ("");
        alpha_value_label.set_halign (Align.END);
        alpha_scale.value_changed.connect ( () => {
            double value = alpha_scale.get_value ();
            alpha_value_label.label = "%.1f".printf (value / 100.0);
        });

        var custom_switch_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        custom_switch_box.set_margin_start (FLOW_BOX_MARGIN);
        custom_switch_box.set_margin_end (FLOW_BOX_MARGIN);
        custom_switch_box.set_margin_top (FLOW_BOX_MARGIN);
        custom_switch_box.set_margin_bottom (FLOW_BOX_MARGIN);
        custom_switch_box.append (custom_switch_label);
        custom_switch_box.append (custom_switch);
        custom_switch_box.append (new Label ("Borders"));
        custom_switch_box.append (borders_scale);
        custom_switch_box.append (borders_value_label);
        custom_switch_box.append (new Label ("Alpha"));
        custom_switch_box.append (alpha_scale);
        custom_switch_box.append (alpha_value_label);
        visual_box.append (custom_switch_box);

        var position_model = new Gtk.StringList (null);
        foreach (var item in new string[] {
            "top-left", "top-center", "top-right",
            "middle-left", "middle-right",
            "bottom-left", "bottom-center", "bottom-right"
        }) {
            position_model.append (item);
        }
        position_dropdown = new DropDown (position_model, null);
        position_dropdown.set_size_request (100, -1);
        position_dropdown.set_valign (Align.CENTER);
        position_dropdown.notify["selected-item"].connect ( () => {
            update_position_in_file ( (position_dropdown.selected_item as StringObject)?.get_string () ?? "");
        });

        colums_scale = new Scale.with_range (Orientation.HORIZONTAL, 1, 6, -1);
        colums_scale.set_hexpand (true);
        colums_scale.set_value (3);
        colums_value_label = new Label ("");
        colums_value_label.set_halign (Align.END);
        colums_scale.value_changed.connect ( () => colums_value_label.label = "%d".printf ( (int)colums_scale.get_value ()));

        toggle_hud_entry = new Entry ();
        toggle_hud_entry.placeholder_text = "Shift_R+F12";
        toggle_hud_entry.set_size_request (20, -1);
        toggle_hud_entry.set_margin_top (FLOW_BOX_MARGIN);
        toggle_hud_entry.set_margin_bottom (FLOW_BOX_MARGIN);
        toggle_hud_entry.changed.connect ( () => {
            update_toggle_hud_in_file (toggle_hud_entry.text);
        });

        var position_colums_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        position_colums_box.set_margin_start (FLOW_BOX_MARGIN);
        position_colums_box.set_margin_end (FLOW_BOX_MARGIN);
        position_colums_box.set_margin_top (FLOW_BOX_MARGIN);
        position_colums_box.set_margin_bottom (FLOW_BOX_MARGIN);
        position_colums_box.append (new Label ("Position"));
        position_colums_box.append (position_dropdown);
        position_colums_box.append (new Label ("Colums"));
        position_colums_box.append (colums_scale);
        position_colums_box.append (colums_value_label);
        position_colums_box.append (new Label ("Toggle HUD"));
        position_colums_box.append (toggle_hud_entry);
        visual_box.append (position_colums_box);

        var fonts_label = new Label ("Font");
        fonts_label.set_halign (Align.CENTER);
        fonts_label.set_margin_top (FLOW_BOX_MARGIN);
        fonts_label.set_margin_start (FLOW_BOX_MARGIN);
        fonts_label.set_margin_end (FLOW_BOX_MARGIN);
        var fonts_font_description = new Pango.FontDescription ();
        fonts_font_description.set_weight (Pango.Weight.BOLD);
        var fonts_attr_list = new Pango.AttrList ();
        fonts_attr_list.insert (new Pango.AttrFontDesc (fonts_font_description));
        fonts_label.set_attributes (fonts_attr_list);
        visual_box.append (fonts_label);

        font_size_scale = new Scale.with_range (Orientation.HORIZONTAL, 8, 64, 1);
        font_size_scale.set_hexpand (true);
        font_size_scale.set_value (24);
        font_size_value_label = new Label ("");
        font_size_value_label.set_halign (Align.END);
        font_size_scale.value_changed.connect ( () => {
            font_size_value_label.label = "%d".printf ( (int)font_size_scale.get_value ());
            update_font_size_in_file ("%d".printf ( (int)font_size_scale.get_value ()));
        });

        initialize_font_dropdown (visual_box);

        var fonts_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        fonts_box.set_margin_start (FLOW_BOX_MARGIN);
        fonts_box.set_margin_end (FLOW_BOX_MARGIN);
        fonts_box.set_margin_top (FLOW_BOX_MARGIN);
        fonts_box.set_margin_bottom (FLOW_BOX_MARGIN);
        fonts_box.append (new Label ("Font"));
        fonts_box.append (font_dropdown);
        fonts_box.append (new Label ("Size"));
        fonts_box.append (font_size_scale);
        fonts_box.append (font_size_value_label);
        visual_box.append (fonts_box);

        var color_label = new Label ("Color");
        color_label.set_halign (Align.CENTER);
        color_label.set_margin_top (FLOW_BOX_MARGIN);
        color_label.set_margin_start (FLOW_BOX_MARGIN);
        color_label.set_margin_end (FLOW_BOX_MARGIN);
        var color_font_description = new Pango.FontDescription ();
        color_font_description.set_weight (Pango.Weight.BOLD);
        var color_attr_list = new Pango.AttrList ();
        color_attr_list.insert (new Pango.AttrFontDesc (color_font_description));
        color_label.set_attributes (color_attr_list);
        visual_box.append (color_label);

        gpu_text_entry = new Entry ();
        gpu_text_entry.placeholder_text = "GPU custom name";
        gpu_text_entry.hexpand = true;
        gpu_text_entry.changed.connect ( () => {
            update_gpu_text_in_file (gpu_text_entry.text);
        });

        var color_dialog = new ColorDialog ();
        gpu_color_button = new ColorDialogButton (color_dialog);
        gpu_color_button.notify["rgba"].connect ( () => {
            var rgba = gpu_color_button.get_rgba ().copy ();
            update_gpu_color_in_file (rgba_to_hex (rgba));
        });

        cpu_text_entry = new Entry ();
        cpu_text_entry.placeholder_text = "CPU custom name";
        cpu_text_entry.hexpand = true;
        cpu_text_entry.changed.connect ( () => {
            update_cpu_text_in_file (cpu_text_entry.text);
        });

        cpu_color_button = new ColorDialogButton (color_dialog);
        cpu_color_button.notify["rgba"].connect ( () => {
            var rgba = cpu_color_button.get_rgba ().copy ();
            update_cpu_color_in_file (rgba_to_hex (rgba));
        });

        var color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        color_box.set_margin_start (FLOW_BOX_MARGIN);
        color_box.set_margin_end (FLOW_BOX_MARGIN);
        color_box.set_margin_top (FLOW_BOX_MARGIN);
        color_box.set_margin_bottom (FLOW_BOX_MARGIN);
        color_box.append (gpu_text_entry);
        color_box.append (gpu_color_button);
        color_box.append (cpu_text_entry);
        color_box.append (cpu_color_button);
        visual_box.append (color_box);
    }

    private void initialize_font_dropdown (Box visual_box) {
        var font_model = new Gtk.StringList (null);
        font_model.append ("Default");

        var fonts = new Gee.ArrayList<string> ();

        fonts.add_all (find_fonts ("/usr/share/fonts"));

        var local_fonts_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".local/share/fonts");
        if (!local_fonts_dir.query_exists ()) {
            try {
                local_fonts_dir.make_directory_with_parents ();
            } catch (Error e) {
                stderr.printf ("Ошибка при создании директории: %s\n", e.message);
            }
        }
        fonts.add_all (find_fonts (local_fonts_dir.get_path ()));

        foreach (var font in fonts) {
            font_model.append (font);
        }

        font_dropdown = new DropDown (font_model, null);
        font_dropdown.set_size_request (100, -1);
        font_dropdown.set_valign (Align.CENTER);
        font_dropdown.notify["selected-item"].connect ( () => {
            update_font_file_in_file ( (font_dropdown.selected_item as StringObject)?.get_string () ?? "");
        });
    }

    private Gee.List<string> find_fonts (string directory) {
        var fonts = new Gee.ArrayList<string> ();
        var dir = File.new_for_path (directory);

        try {
            var enumerator = dir.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ( (file_info = enumerator.next_file ()) != null) {
                var file = dir.get_child (file_info.get_name ());
                if (file_info.get_file_type () == FileType.DIRECTORY) {
                    fonts.add_all (find_fonts (file.get_path ()));
                } else if (file_info.get_name ().has_suffix (".ttf")) {
                    fonts.add (file.get_path ());
                }
            }
        } catch (Error e) {
            stderr.printf ("Ошибка при поиске шрифтов: %s\n", e.message);
        }

        return fonts;
    }

    private void create_switches_and_labels (Box parent_box, string title, Switch[] switches, Label[] labels, string[] config_vars, string[] label_texts) {
        var label = new Label (title);
        label.set_halign (Align.CENTER);
        label.set_margin_top (FLOW_BOX_MARGIN);
        label.set_margin_start (FLOW_BOX_MARGIN);
        label.set_margin_end (FLOW_BOX_MARGIN);

        var font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        var attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        label.set_attributes (attr_list);

        parent_box.append (label);

        var flow_box = new FlowBox ();
        flow_box.set_homogeneous (true);
        flow_box.set_max_children_per_line (5);
        flow_box.set_min_children_per_line (3);
        flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        flow_box.set_column_spacing (FLOW_BOX_COLUMN_SPACING);
        flow_box.set_margin_start (FLOW_BOX_MARGIN);
        flow_box.set_margin_end (FLOW_BOX_MARGIN);
        flow_box.set_margin_top (FLOW_BOX_MARGIN);
        flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        flow_box.set_selection_mode (SelectionMode.NONE);

        for (int i = 0; i < config_vars.length; i++) {
            var row_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            switches[i] = new Switch ();
            labels[i] = new Label (label_texts[i]);
            labels[i].set_halign (Align.START);
            row_box.append (switches[i]);
            row_box.append (labels[i]);
            flow_box.insert (row_box, -1);
        }

        parent_box.append (flow_box);
    }

    private void create_scales_and_labels (Box parent_box) {
        duracion_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 200, 1);
        duracion_scale.set_value (0);
        duracion_scale.set_hexpand (true);
        duracion_scale.set_margin_start (FLOW_BOX_MARGIN);
        duracion_scale.set_margin_end (FLOW_BOX_MARGIN);
        duracion_scale.set_margin_top (FLOW_BOX_MARGIN);
        duracion_scale.set_margin_bottom (FLOW_BOX_MARGIN);
        duracion_value_label = new Label ("");
        duracion_value_label.set_halign (Align.END);
        duracion_scale.value_changed.connect ( () => duracion_value_label.label = "%d s".printf ( (int)duracion_scale.get_value ()));

        autostart_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 30, 1);
        autostart_scale.set_value (0);
        autostart_scale.set_hexpand (true);
        autostart_scale.set_margin_start (FLOW_BOX_MARGIN);
        autostart_scale.set_margin_end (FLOW_BOX_MARGIN);
        autostart_scale.set_margin_top (FLOW_BOX_MARGIN);
        autostart_scale.set_margin_bottom (FLOW_BOX_MARGIN);
        autostart_value_label = new Label ("");
        autostart_value_label.set_halign (Align.END);
        autostart_scale.value_changed.connect ( () => autostart_value_label.label = "%d s".printf ( (int)autostart_scale.get_value ()));

        interval_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 500, 1);
        interval_scale.set_value (0);
        interval_scale.set_hexpand (true);
        interval_scale.set_margin_start (FLOW_BOX_MARGIN);
        interval_scale.set_margin_end (FLOW_BOX_MARGIN);
        interval_scale.set_margin_top (FLOW_BOX_MARGIN);
        interval_scale.set_margin_bottom (FLOW_BOX_MARGIN);
        interval_value_label = new Label ("");
        interval_value_label.set_halign (Align.END);
        interval_scale.value_changed.connect ( () => interval_value_label.label = "%d ms".printf ( (int)interval_scale.get_value ()));

        var scales_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        scales_box.set_margin_start (FLOW_BOX_MARGIN);
        scales_box.set_margin_end (FLOW_BOX_MARGIN);
        scales_box.set_margin_top (FLOW_BOX_MARGIN);
        scales_box.set_margin_bottom (FLOW_BOX_MARGIN);
        scales_box.append (new Label ("Duracion"));
        scales_box.append (duracion_scale);
        scales_box.append (duracion_value_label);
        scales_box.append (new Label ("Autostart"));
        scales_box.append (autostart_scale);
        scales_box.append (autostart_value_label);
        scales_box.append (new Label ("Interval"));
        scales_box.append (interval_scale);
        scales_box.append (interval_value_label);

        var logging_label = new Label ("Logging");
        logging_label.set_valign (Align.CENTER);
        logging_label.set_margin_top (FLOW_BOX_MARGIN);
        logging_label.set_margin_start (FLOW_BOX_MARGIN);
        logging_label.set_margin_end (FLOW_BOX_MARGIN);

        var font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        var attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        logging_label.set_attributes (attr_list);

        parent_box.append (logging_label);
        parent_box.append (scales_box);
    }

    private void create_limiters_and_filters (Box performance_box) {
        var limiters_label = new Label (LIMITERS_TITLE);
        limiters_label.set_halign (Align.CENTER);
        limiters_label.set_margin_top (FLOW_BOX_MARGIN);
        limiters_label.set_margin_start (FLOW_BOX_MARGIN);
        limiters_label.set_margin_end (FLOW_BOX_MARGIN);

        var font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        var attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        limiters_label.set_attributes (attr_list);

        performance_box.append (limiters_label);

        var fps_limit_method_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "late", "early" }) {
            fps_limit_method_model.append (item);
        }
        fps_limit_method = new DropDown (fps_limit_method_model, null);

        scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 240, 1);
        fps_limit_label = new Label ("");
        scale.value_changed.connect ( () => fps_limit_label.label = "%d".printf ( (int)scale.get_value ()));

        var toggle_fps_limit_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "Shift_L+F1", "Shift_L+F2", "Shift_L+F3", "Shift_L+F4" }) {
            toggle_fps_limit_model.append (item);
        }
        toggle_fps_limit = new DropDown (toggle_fps_limit_model, null);

        var fps_color_switch = new Switch ();
        var fps_color_label = new Label ("FPS Color");
        fps_color_label.set_halign (Align.START);

        var limiters_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        limiters_box.set_margin_start (FLOW_BOX_MARGIN);
        limiters_box.set_margin_end (FLOW_BOX_MARGIN);
        limiters_box.set_margin_top (FLOW_BOX_MARGIN);
        limiters_box.set_margin_bottom (FLOW_BOX_MARGIN);
        scale.set_hexpand (true);

        limiters_box.append (fps_limit_method);
        limiters_box.append (scale);
        limiters_box.append (fps_limit_label);
        limiters_box.append (toggle_fps_limit);
        limiters_box.append (fps_color_switch);
        limiters_box.append (fps_color_label);
        performance_box.append (limiters_box);

        var vsync_label = new Label ("VSync");
        vsync_label.set_halign (Align.CENTER);
        vsync_label.set_margin_top (FLOW_BOX_MARGIN);
        vsync_label.set_margin_start (FLOW_BOX_MARGIN);
        vsync_label.set_margin_end (FLOW_BOX_MARGIN);

        font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        vsync_label.set_attributes (attr_list);

        performance_box.append (vsync_label);

        var vulcan_model = new Gtk.StringList (null);
        foreach (var item in vulcan_values) {
            vulcan_model.append (item);
        }
        vulcan_dropdown = new DropDown (vulcan_model, null);

        var opengl_model = new Gtk.StringList (null);
        foreach (var item in opengl_values) {
            opengl_model.append (item);
        }
        opengl_dropdown = new DropDown (opengl_model, null);

        var vulcan_label = new Label ("Vulcan");
        vulcan_label.set_halign (Align.START);
        vulcan_label.set_margin_start (FLOW_BOX_MARGIN);
        vulcan_label.set_margin_end (FLOW_BOX_MARGIN);

        var opengl_label = new Label ("OpenGL");
        opengl_label.set_halign (Align.START);
        opengl_label.set_margin_start (FLOW_BOX_MARGIN);
        opengl_label.set_margin_end (FLOW_BOX_MARGIN);

        var vsync_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        vsync_box.set_halign (Align.CENTER);
        vsync_box.set_margin_start (FLOW_BOX_MARGIN);
        vsync_box.set_margin_end (FLOW_BOX_MARGIN);
        vsync_box.set_margin_top (FLOW_BOX_MARGIN);
        vsync_box.set_margin_bottom (FLOW_BOX_MARGIN);
        vsync_box.append (vulcan_dropdown);
        vsync_box.append (vulcan_label);
        vsync_box.append (opengl_dropdown);
        vsync_box.append (opengl_label);
        performance_box.append (vsync_box);

        var filters_label = new Label (FILTERS_TITLE);
        filters_label.set_halign (Align.CENTER);
        filters_label.set_margin_top (FLOW_BOX_MARGIN);
        filters_label.set_margin_start (FLOW_BOX_MARGIN);
        filters_label.set_margin_end (FLOW_BOX_MARGIN);

        font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        filters_label.set_attributes (attr_list);

        performance_box.append (filters_label);

        var filter_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "none", "bicubic", "trilinear", "retro" }) {
            filter_model.append (item);
        }
        filter_dropdown = new DropDown (filter_model, null);
        filter_dropdown.set_size_request (100, -1);
        filter_dropdown.set_valign (Align.CENTER);

        af = new Scale.with_range (Orientation.HORIZONTAL, 0, 16, 1);
        af.set_hexpand (true);
        af_label = new Label ("");
        af_label.set_halign (Align.END);
        af.value_changed.connect ( () => af_label.label = "%d".printf ( (int)af.get_value ()));

        picmip = new Scale.with_range (Orientation.HORIZONTAL, -16, 16, 1);
        picmip.set_hexpand (true);
        picmip.set_value (0);
        picmip_label = new Label ("");
        picmip_label.set_halign (Align.END);
        picmip.value_changed.connect ( () => picmip_label.label = "%d".printf ( (int)picmip.get_value ()));

        var filters_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        filters_box.set_margin_start (FLOW_BOX_MARGIN);
        filters_box.set_margin_end (FLOW_BOX_MARGIN);
        filters_box.set_margin_top (FLOW_BOX_MARGIN);
        filters_box.set_margin_bottom (FLOW_BOX_MARGIN);
        filters_box.append (filter_dropdown);
        filters_box.append (new Label ("Anisotropic filtering"));
        filters_box.append (af);
        filters_box.append (af_label);
        filters_box.append (new Label ("Mipmap LoD bias"));
        filters_box.append (picmip);
        filters_box.append (picmip_label);
        performance_box.append (filters_box);
    }

    private void save_states_to_file () {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        if (!config_dir.query_exists ()) {
            try {
                config_dir.make_directory_with_parents ();
            } catch (Error e) {
                stderr.printf ("Ошибка при создании директории: %s\n", e.message);
                return;
            }
        }

        var file = config_dir.get_child ("MangoHud.conf");
        try {
            var file_stream = file.replace (null, false, FileCreateFlags.NONE);
            var data_stream = new DataOutputStream (file_stream);
            data_stream.put_string ("################### File Generated by MangoJuice ###################\n");
            data_stream.put_string ("legacy_layout=false\n");

            var custom_text_center = custom_text_center_entry.text;
            if (custom_text_center != "") {
                data_stream.put_string ("custom_text_center=%s\n".printf (custom_text_center));
            }

            save_switches_to_file (data_stream, inform_switches, inform_config_vars);
            save_switches_to_file (data_stream, gpu_switches, gpu_config_vars);
            save_switches_to_file (data_stream, cpu_switches, cpu_config_vars);
            save_switches_to_file (data_stream, other_switches, other_config_vars);
            save_switches_to_file (data_stream, system_switches, system_config_vars);
            save_switches_to_file (data_stream, battery_switches, battery_config_vars);
            save_switches_to_file (data_stream, other_extra_switches, other_extra_config_vars);
            save_switches_to_file (data_stream, wine_switches, wine_config_vars);
            save_switches_to_file (data_stream, options_switches, options_config_vars);

            var custom_command = custom_command_entry.text;
            if (custom_command != "") {
                data_stream.put_string ("%s\n".printf (custom_command));
            }

            if (logs_key_combo.selected_item != null) {
                var logs_key = (logs_key_combo.selected_item as StringObject)?.get_string () ?? "";
                if (logs_key != "") {
                    data_stream.put_string ("toggle_logging=%s\n".printf (logs_key));
                }
            }

            if (duracion_scale != null) {
                data_stream.put_string ("log_duration=%d\n".printf ( (int)duracion_scale.get_value ()));
            }
            if (autostart_scale != null) {
                data_stream.put_string ("autostart_log=%d\n".printf ( (int)autostart_scale.get_value ()));
            }
            if (interval_scale != null) {
                data_stream.put_string ("log_interval=%d\n".printf ( (int)interval_scale.get_value ()));
            }

            var custom_logs_path = custom_logs_path_entry.text;
            if (custom_logs_path != "") {
                data_stream.put_string ("output_folder=%s\n".printf (custom_logs_path));
            }

            if (fps_limit_method.selected_item != null) {
                var fps_limit_method_value = (fps_limit_method.selected_item as StringObject)?.get_string () ?? "";
                data_stream.put_string ("fps_limit_method=%s\n".printf (fps_limit_method_value));
            }

            if (toggle_fps_limit.selected_item != null) {
                var toggle_fps_limit_value = (toggle_fps_limit.selected_item as StringObject)?.get_string () ?? "";
                data_stream.put_string ("toggle_fps_limit=%s\n".printf (toggle_fps_limit_value));
            }

            if (scale != null) {
                data_stream.put_string ("fps_limit=%d\n".printf ( (int)scale.get_value ()));
            }

            if (vulcan_dropdown.selected_item != null) {
                var vulcan_value = (vulcan_dropdown.selected_item as StringObject)?.get_string () ?? "";
                var vulcan_config_value = get_vulcan_config_value (vulcan_value);
                data_stream.put_string ("vsync=%s\n".printf (vulcan_config_value));
            }

            if (opengl_dropdown.selected_item != null) {
                var opengl_value = (opengl_dropdown.selected_item as StringObject)?.get_string () ?? "";
                var opengl_config_value = get_opengl_config_value (opengl_value);
                data_stream.put_string ("gl_vsync=%s\n".printf (opengl_config_value));
            }

            if (filter_dropdown.selected_item != null) {
                var filter_value = (filter_dropdown.selected_item as StringObject)?.get_string () ?? "";
                if (filter_value != "none") {
                    data_stream.put_string ("%s\n".printf (filter_value));
                }
            }

            if (af != null) {
                data_stream.put_string ("af=%d\n".printf ( (int)af.get_value ()));
            }
            if (picmip != null) {
                data_stream.put_string ("picmip=%d\n".printf ( (int)picmip.get_value ()));
            }

            var custom_switch_state = custom_switch.active ? "" : "#";
            data_stream.put_string ("%shorizontal\n".printf (custom_switch_state));
            if (borders_scale != null) {
                data_stream.put_string ("round_corners=%d\n".printf ( (int)borders_scale.get_value ()));
            }

            if (alpha_scale != null) {
                double alpha_value = alpha_scale.get_value () / 100.0;
                string alpha_value_str = "%.1f".printf (alpha_value).replace (",", ".");
                data_stream.put_string ("background_alpha=%s\n".printf (alpha_value_str));
            }

            if (position_dropdown.selected_item != null) {
                var position_value = (position_dropdown.selected_item as StringObject)?.get_string () ?? "";
                data_stream.put_string ("position=%s\n".printf (position_value));
            }

            if (colums_scale != null) {
                data_stream.put_string ("table_columns=%d\n".printf ( (int)colums_scale.get_value ()));
            }

            if (toggle_hud_entry != null) {
                var toggle_hud_value = toggle_hud_entry.text;
                data_stream.put_string ("toggle_hud=%s\n".printf (toggle_hud_value));
            }

            if (font_size_scale != null) {
                data_stream.put_string ("font_size=%d\n".printf ( (int)font_size_scale.get_value ()));
            }

            if (font_dropdown.selected_item != null) {
                var font_file = (font_dropdown.selected_item as StringObject)?.get_string () ?? "";
                if (font_file != "Default") {
                    data_stream.put_string ("font_file=%s\n".printf (font_file));
                    data_stream.put_string ("font_glyph_ranges=korean, chinese, chinese_simplified, japanese, cyrillic, thai, vietnamese, latin_ext_a, latin_ext_b\n");
                }
            }

            var io_read_state = other_switches[1].active ? "" : "#";
            data_stream.put_string ("%sio_read\n".printf (io_read_state));
            data_stream.put_string ("%sio_write\n".printf (io_read_state));

            var gpu_text = gpu_text_entry.text;
            if (gpu_text != "") {
                data_stream.put_string ("gpu_text=%s\n".printf (gpu_text));
            }

            var gpu_color = rgba_to_hex (gpu_color_button.get_rgba ());
            if (gpu_color != "") {
                data_stream.put_string ("gpu_color=%s\n".printf (gpu_color));
            }

            var cpu_text = cpu_text_entry.text;
            if (cpu_text != "") {
                data_stream.put_string ("cpu_text=%s\n".printf (cpu_text));
            }

            var cpu_color = rgba_to_hex (cpu_color_button.get_rgba ());
            if (cpu_color != "") {
                data_stream.put_string ("cpu_color=%s\n".printf (cpu_color));
            }

            if (inform_switches[7].active) {
                data_stream.put_string ("fps_color_change\n");
            }

            data_stream.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void save_switches_to_file (DataOutputStream data_stream, Switch[] switches, string[] config_vars) {
        for (int i = 0; i < switches.length; i++) {
            var state = switches[i].active ? "" : "#";
            try {
                data_stream.put_string ("%s%s\n".printf (state, config_vars[i]));
            } catch (Error e) {
                stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
            }
        }
    }

    private void load_states_from_file () {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                load_switch_from_file (line, gpu_switches, gpu_config_vars);
                load_switch_from_file (line, cpu_switches, cpu_config_vars);
                load_switch_from_file (line, other_switches, other_config_vars);
                load_switch_from_file (line, system_switches, system_config_vars);
                load_switch_from_file (line, wine_switches, wine_config_vars);
                load_switch_from_file (line, battery_switches, battery_config_vars);
                load_switch_from_file (line, other_extra_switches, other_extra_config_vars);
                load_switch_from_file (line, inform_switches, inform_config_vars);
                load_switch_from_file (line, options_switches, options_config_vars);

                if (line.has_prefix ("custom_command=")) {
                    custom_command_entry.text = line.substring ("custom_command=".length);
                }

                if (line.has_prefix ("toggle_logging=")) {
                    var logs_key = line.substring ("toggle_logging=".length);
                    for (uint i = 0; i < logs_key_model.get_n_items (); i++) {
                        var item = logs_key_model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == logs_key) {
                            logs_key_combo.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("log_duration=")) {
                    if (duracion_scale != null) {
                        duracion_scale.set_value (int.parse (line.substring ("log_duration=".length)));
                        if (duracion_value_label != null) {
                            duracion_value_label.label = "%d s".printf ( (int)duracion_scale.get_value ());
                        }
                    }
                }
                if (line.has_prefix ("autostart_log=")) {
                    if (autostart_scale != null) {
                        autostart_scale.set_value (int.parse (line.substring ("autostart_log=".length)));
                        if (autostart_value_label != null) {
                            autostart_value_label.label = "%d s".printf ( (int)autostart_scale.get_value ());
                        }
                    }
                }
                if (line.has_prefix ("log_interval=")) {
                    if (interval_scale != null) {
                        interval_scale.set_value (int.parse (line.substring ("log_interval=".length)));
                        if (interval_value_label != null) {
                            interval_value_label.label = "%d ms".printf ( (int)interval_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("output_folder=")) {
                    custom_logs_path_entry.text = line.substring ("output_folder=".length);
                }

                if (line.has_prefix ("fps_limit_method=")) {
                    var fps_limit_method_value = line.substring ("fps_limit_method=".length);
                    for (uint i = 0; i < fps_limit_method.model.get_n_items (); i++) {
                        var item = fps_limit_method.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == fps_limit_method_value) {
                            fps_limit_method.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("toggle_fps_limit=")) {
                    var toggle_fps_limit_value = line.substring ("toggle_fps_limit=".length);
                    for (uint i = 0; i < toggle_fps_limit.model.get_n_items (); i++) {
                        var item = toggle_fps_limit.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == toggle_fps_limit_value) {
                            toggle_fps_limit.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("fps_limit=")) {
                    if (scale != null) {
                        scale.set_value (int.parse (line.substring ("fps_limit=".length)));
                        if (fps_limit_label != null) {
                            fps_limit_label.label = "%d".printf ( (int)scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("vsync=")) {
                    var vulcan_config_value = line.substring ("vsync=".length);
                    var vulcan_value = get_vulcan_value_from_config (vulcan_config_value);
                    for (uint i = 0; i < vulcan_dropdown.model.get_n_items (); i++) {
                        var item = vulcan_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == vulcan_value) {
                            vulcan_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("gl_vsync=")) {
                    var opengl_config_value = line.substring ("gl_vsync=".length);
                    var opengl_value = get_opengl_value_from_config (opengl_config_value);
                    for (uint i = 0; i < opengl_dropdown.model.get_n_items (); i++) {
                        var item = opengl_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == opengl_value) {
                            opengl_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("filter=")) {
                    var filter_value = line.substring ("filter=".length);
                    for (uint i = 0; i < filter_dropdown.model.get_n_items (); i++) {
                        var item = filter_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == filter_value) {
                            filter_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("af=")) {
                    if (af != null) {
                        af.set_value (int.parse (line.substring ("af=".length)));
                        if (af_label != null) {
                            af_label.label = "%d".printf ( (int)af.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("picmip=")) {
                    if (picmip != null) {
                        picmip.set_value (int.parse (line.substring ("picmip=".length)));
                        if (picmip_label != null) {
                            picmip_label.label = "%d".printf ( (int)picmip.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("custom_text_center=")) {
                    custom_text_center_entry.text = line.substring ("custom_text_center=".length);
                }

                if (line.has_prefix ("horizontal")) {
                    custom_switch.active = !line.has_prefix ("#");
                }

                if (line.has_prefix ("round_corners=")) {
                    if (borders_scale != null) {
                        borders_scale.set_value (int.parse (line.substring ("round_corners=".length)));
                        if (borders_value_label != null) {
                            borders_value_label.label = "%d".printf ( (int)borders_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("background_alpha=")) {
                    if (alpha_scale != null) {
                        double alpha_value = double.parse (line.substring ("background_alpha=".length));
                        alpha_scale.set_value (alpha_value * 100);
                        if (alpha_value_label != null) {
                            alpha_value_label.label = "%.1f".printf (alpha_value);
                        }
                    }
                }

                if (line.has_prefix ("position=")) {
                    var position_value = line.substring ("position=".length);
                    for (uint i = 0; i < position_dropdown.model.get_n_items (); i++) {
                        var item = position_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == position_value) {
                            position_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("table_columns=")) {
                    if (colums_scale != null) {
                        colums_scale.set_value (int.parse (line.substring ("table_columns=".length)));
                        if (colums_value_label != null) {
                            colums_value_label.label = "%d".printf ( (int)colums_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("toggle_hud=")) {
                    var toggle_hud_value = line.substring ("toggle_hud=".length);
                    toggle_hud_entry.text = toggle_hud_value;
                }

                if (line.has_prefix ("font_size=")) {
                    if (font_size_scale != null) {
                        font_size_scale.set_value (int.parse (line.substring ("font_size=".length)));
                        if (font_size_value_label != null) {
                            font_size_value_label.label = "%d".printf ( (int)font_size_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("font_file=")) {
                    var font_file = line.substring ("font_file=".length);
                    for (uint i = 0; i < font_dropdown.model.get_n_items (); i++) {
                        var item = font_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == font_file) {
                            font_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("io_read") || line.has_prefix ("#io_read")) {
                    other_switches[1].active = !line.has_prefix ("#");
                }
                if (line.has_prefix ("io_write") || line.has_prefix ("#io_write")) {
                    other_switches[1].active = !line.has_prefix ("#");
                }

                if (line.has_prefix ("gpu_text=")) {
                    gpu_text_entry.text = line.substring ("gpu_text=".length);
                }

                if (line.has_prefix ("gpu_color=")) {
                    var gpu_color = line.substring ("gpu_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + gpu_color);
                    gpu_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("cpu_text=")) {
                    cpu_text_entry.text = line.substring ("cpu_text=".length);
                }

                if (line.has_prefix ("cpu_color=")) {
                    var cpu_color = line.substring ("cpu_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + cpu_color);
                    cpu_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("fps_color_change")) {
                    inform_switches[7].active = true;
                }
            }
        } catch (Error e) {
            stderr.printf ("Ошибка при чтении файла: %s\n", e.message);
        }
    }

    private void load_switch_from_file (string line, Switch[] switches, string[] config_vars) {
        for (int i = 0; i < config_vars.length; i++) {
            if (line.has_prefix ("#%s".printf (config_vars[i]))) {
                switches[i].active = false;
            } else if (line.has_prefix ("%s".printf (config_vars[i]))) {
                switches[i].active = true;
            }
        }
    }

    private void restart_vkcube () {
        try {
            Process.spawn_command_line_sync ("pkill vkcube");
            Process.spawn_command_line_async ("mangohud vkcube");
        } catch (Error e) {
            stderr.printf ("Ошибка при перезапуске vkcube: %s\n", e.message);
        }
    }

    private bool is_vkcube_running () {
        try {
            string[] argv = { "pgrep", "vkcube" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

            return exit_status == 0;
        } catch (Error e) {
            stderr.printf ("Ошибка при проверке запущенных процессов: %s\n", e.message);
            return false;
        }
    }

    private void delete_mangohub_conf () {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (file.query_exists ()) {
            try {
                file.delete ();
                warning ("MangoHud.conf file deleted.");
            } catch (Error e) {
                stderr.printf ("Ошибка при удалении файла: %s\n", e.message);
            }
        } else {
            warning ("MangoHud.conf file does not exist.");
        }
    }

    private void update_logs_key_in_file (string logs_key) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("toggle_logging=")) {
                    line = "toggle_logging=%s".printf (logs_key);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void update_position_in_file (string position_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("position=")) {
                    line = "position=%s".printf (position_value);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void update_toggle_hud_in_file (string toggle_hud_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("toggle_hud=")) {
                    line = "toggle_hud=%s".printf (toggle_hud_value);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void update_font_size_in_file (string font_size_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("font_size=")) {
                    line = "font_size=%s".printf (font_size_value);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void update_font_file_in_file (string font_file_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            bool glyph_ranges_added = false;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("font_file=")) {
                    line = "font_file=%s".printf (font_file_value);
                }
                if (line.has_prefix ("font_glyph_ranges=")) {
                    glyph_ranges_added = true;
                }
                lines.add (line);
            }

            // Добавляем строку font_glyph_ranges, если выбран шрифт, отличный от Default
            if (font_file_value != "Default" && !glyph_ranges_added) {
                lines.add ("font_glyph_ranges=korean, chinese, chinese_simplified, japanese, cyrillic, thai, vietnamese, latin_ext_a, latin_ext_b");
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void open_folder_chooser_dialog () {
        var dialog = new Gtk.FileDialog ();
        dialog.select_folder.begin (this.active_window, null, (obj, res) => {
            try {
                var folder = dialog.select_folder.end (res);
                custom_logs_path_entry.text = folder.get_path ();
            } catch (Error e) {
                stderr.printf ("Ошибка при выборе папки: %s\n", e.message);
            }
        });
    }

    private string get_vulcan_config_value (string vulcan_value) {
        for (int i = 0; i < vulcan_values.length; i++) {
            if (vulcan_values[i] == vulcan_value) {
                return vulcan_config_values[i];
            }
        }
        return "0";
    }

    private string get_opengl_config_value (string opengl_value) {
        for (int i = 0; i < opengl_values.length; i++) {
            if (opengl_values[i] == opengl_value) {
                return opengl_config_values[i];
            }
        }
        return "-1";
    }

    private string get_vulcan_value_from_config (string vulcan_config_value) {
        for (int i = 0; i < vulcan_config_values.length; i++) {
            if (vulcan_config_values[i] == vulcan_config_value) {
                return vulcan_values[i];
            }
        }
        return "Unset";
    }

    private string get_opengl_value_from_config (string opengl_config_value) {
        for (int i = 0; i < opengl_config_values.length; i++) {
            if (opengl_config_values[i] == opengl_config_value) {
                return opengl_values[i];
            }
        }
        return "Unset";
    }

    private void restart_application () {
        this.quit ();
        string mangojuice_path = Environment.find_program_in_path ("mangojuice");
        if (mangojuice_path != null) {
            try {
                Process.spawn_command_line_async (mangojuice_path);
            } catch (Error e) {
                stderr.printf ("Ошибка при перезапуске приложения: %s\n", e.message);
            }
        } else {
            stderr.printf ("Исполняемый файл mangojuice не найден в PATH.\n");
        }
    }

    private bool is_vkcube_available () {
        try {
            string[] argv = { "which", "vkcube" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

            if (exit_status != 0) {
                stderr.printf ("vkcube not found. If you want a test button, install vulkan-tools.\n");
            }

            return exit_status == 0;
        } catch (Error e) {
            stderr.printf ("Ошибка при проверке доступности vkcube: %s\n", e.message);
            return false;
        }
    }

    private void update_gpu_text_in_file (string gpu_text) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("gpu_text=")) {
                    line = "gpu_text=%s".printf (gpu_text);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void update_gpu_color_in_file (string gpu_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("gpu_color=")) {
                    line = "gpu_color=%s".printf (gpu_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void update_cpu_text_in_file (string cpu_text) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("cpu_text=")) {
                    line = "cpu_text=%s".printf (cpu_text);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void update_cpu_color_in_file (string cpu_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("cpu_color=")) {
                    line = "cpu_color=%s".printf (cpu_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private string rgba_to_hex (Gdk.RGBA rgba) {
        return "%02x%02x%02x".printf ((int) (rgba.red * 255), (int) (rgba.green * 255), (int) (rgba.blue * 255));
    }

    public static int main (string[] args) {
        var app = new MangoJuice ();
        return app.run (args);
    }
}
