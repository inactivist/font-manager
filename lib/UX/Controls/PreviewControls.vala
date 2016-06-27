/* PreviewControls.vala
 *
 * Copyright (C) 2009 - 2016 Jerry Casiano
 *
 * This file is part of Font Manager.
 *
 * Font Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Font Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Font Manager.  If not, see <https://opensource.org/licenses/GPL-3.0>.
 *
 * Author:
 *        Jerry Casiano <JerryCasiano@gmail.com>
*/

namespace FontManager {

    /**
     * PreviewControls:
     *
     * Toolbar providing controls to justify, edit and reset preview text.
     *
     * -------------------------------------------------------------------
     * |                                                                 |
     * | justify controls                                   edit  reset  |
     * |                                                                 |
     * -------------------------------------------------------------------
     */
    public class PreviewControls : Gtk.EventBox {

        /**
         * PreviewControls::justification_set:
         *
         * Emitted when the user toggles justification
         */
        public signal void justification_set (Gtk.Justification justification);

        /**
         * PreviewControls::editing:
         *
         * Emitted when editing mode has changed.
         */
        public signal void editing (bool enabled);

        /**
         * PreviewControls::on_clear_clicked:
         *
         * Emitted when user has requested text be reset to default
         */
        public signal void on_clear_clicked ();

        /**
         * PreviewControls:clear_is_sensitive:
         *
         * Whether reset function is available.
         */
        public bool clear_is_sensitive {
            get {
                return clear.get_sensitive();
            }
            set {
                clear.set_sensitive(value);
            }
        }

        Gtk.Box box;
        Gtk.Button clear;
        Gtk.ToggleButton edit;
        Gtk.RadioButton justify_left;
        Gtk.RadioButton justify_center;
        Gtk.RadioButton justify_fill;
        Gtk.RadioButton justify_right;

        construct {
            box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 2);
            box.border_width = 1;
            justify_left = new Gtk.RadioButton(null);
            justify_center = new Gtk.RadioButton.from_widget(justify_left);
            justify_fill = new Gtk.RadioButton.from_widget(justify_left);
            justify_right = new Gtk.RadioButton.from_widget(justify_left);
            edit = new Gtk.ToggleButton();
            edit.set_image(new Gtk.Image.from_icon_name("insert-text-symbolic", Gtk.IconSize.MENU));
            edit.set_tooltip_text(_("Edit preview text"));
            clear = new Gtk.Button();
            clear.set_image(new Gtk.Image.from_icon_name("edit-undo-symbolic", Gtk.IconSize.MENU));
            clear.set_tooltip_text(_("Undo changes"));
            edit.relief = Gtk.ReliefStyle.NONE;
            clear.relief = Gtk.ReliefStyle.NONE;
            Gtk.RadioButton [] buttons = { justify_left, justify_center, justify_fill, justify_right };
            string [] icons = { "format-justify-left-symbolic", "format-justify-center-symbolic", "format-justify-fill-symbolic", "format-justify-right-symbolic" };
            string [] tooltips = { _("Left Aligned"), _("Centered"), _("Fill"), _("Right Aligned") };
            for (int i = 0; i < buttons.length; i++) {
                var button = buttons[i];
                button.relief = Gtk.ReliefStyle.NONE;
                ((Gtk.ToggleButton) button).draw_indicator = false;
                button.get_style_context().add_class(Gtk.STYLE_CLASS_LINKED);
                button.set_image(new Gtk.Image.from_icon_name(icons[i], Gtk.IconSize.MENU));
                button.set_tooltip_text(tooltips[i]);
                box.pack_start(button, false, false, 0);
            }
            box.pack_end(clear, false, false, 0);
            box.pack_end(edit, false, false, 0);
            get_style_context().add_class(Gtk.STYLE_CLASS_VIEW);
            add(box);
            justify_center.active = true;
            edit.active = false;
            clear.sensitive = false;
            connect_signals();
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            clear.show();
            edit.show();
            justify_left.show();
            justify_center.show();
            justify_fill.show();
            justify_right.show();
            box.show();
            base.show();
            return;
        }

        void connect_signals () {
            justify_left.toggled.connect(() => { justification_set(Gtk.Justification.LEFT); });
            justify_center.toggled.connect(() => { justification_set(Gtk.Justification.CENTER); });
            justify_fill.toggled.connect(() => { justification_set(Gtk.Justification.FILL); });
            justify_right.toggled.connect(() => { justification_set(Gtk.Justification.RIGHT); });
            clear.clicked.connect(() => { on_clear_clicked(); });
            edit.toggled.connect(() => { editing(edit.get_active()); });
            return;
        }

    }

}
