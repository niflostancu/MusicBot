#!/bin/bash
# Docker entrypoint to choose the appropriate source for the configuration files
# and copy them to /home/discord/config

CONFIG_LOCATION=/home/discord/config
CONFIG_INITIAL=/home/discord/config.initial
CONFIG_READONLY=/home/discord/config.ro

# if the config.ro is mounted, copy it to the config location
if [[ -d "$CONFIG_READONLY" ]]; then
	mkdir -p "$CONFIG_LOCATION"
	cp -rfT "$CONFIG_READONLY" "$CONFIG_LOCATION"

# if the config directory is empty, copy the config templates there
elif [[ ! -d "$COFIG_LOCATION" ]] || [ "$(find "$COFIG_LOCATION" -mindepth 1 -print -quit 2>/dev/null)" ]; then
	mkdir -p "$CONFIG_LOCATION"
	cp -rfT "$CONFIG_INITIAL" "$CONFIG_LOCATION"
	cp -f config/example_aliases.json config/aliases.json
	cp -f config/example_options.ini config/options.ini
	cp -f config/example_permissions.ini config/permissions.ini
fi

if [[ ! -d "$CONFIG_LOCATION/i18n" ]]; then
	mkdir -p "$CONFIG_LOCATION/i18n"
	cp -rfT "$CONFIG_INITIAL/i18n/" "$CONFIG_LOCATION/i18n"
fi

# run the original command
"$@"

