#!/usr/bin/env python3
import argparse
import json
import logging
import signal
import sys

import gi

gi.require_version("Playerctl", "2.0")
from gi.repository import GLib, Playerctl

logger = logging.getLogger(__name__)


def write_output(text, player):
    logger.info("Writing output")

    output = {
        "text": text,
        "class": "custom-" + player.props.player_name,
        "alt": player.props.player_name,
    }

    sys.stdout.write(json.dumps(output) + "\n")
    sys.stdout.flush()


def on_play(player, status, manager):
    logger.info("Received new playback status")
    on_metadata(player, player.props.metadata, manager)


def on_metadata(player, metadata, manager):
    logger.info("Received new metadata")
    track_info = ""
    artist = player.get_artist() or ""
    title = player.get_title() or ""

    if (
        player.props.player_name == "spotify"
        and metadata is not None
        and "mpris:trackid" in metadata.keys()  # noqa: SIM118 (GLib.Variant lacks __contains__)
        and ":ad:" in str(player.props.metadata["mpris:trackid"])
    ):
        track_info = "AD PLAYING"
    elif artist and title:
        track_info = f"{artist} - {title}"
    else:
        track_info = title

    if player.props.status != "Playing" and track_info:
        track_info = " " + track_info
    write_output(track_info, player)


def on_player_appeared(manager, player, selected_player=None):
    if player is not None and (
        selected_player is None or player.name == selected_player
    ):
        init_player(manager, player)
    else:
        logger.debug("New player appeared, but it's not the selected player, skipping")


def on_player_vanished(manager, player):
    logger.info("Player has vanished")
    sys.stdout.write("{}\n")
    sys.stdout.flush()


def init_player(manager, name):
    logger.debug(f"Initialize player: {name.name}")
    player = Playerctl.Player.new_from_name(name)
    player.connect("playback-status", on_play, manager)
    player.connect("metadata", on_metadata, manager)
    manager.manage_player(player)
    on_metadata(player, player.props.metadata, manager)


def signal_handler(loop):
    logger.debug("Received signal to stop, exiting")
    try:
        sys.stdout.write("{}\n")
        sys.stdout.flush()
    except OSError:
        pass
    loop.quit()


def on_stdout_closed(_channel, _condition, loop):
    logger.debug("Waybar stdout pipe closed, exiting")
    loop.quit()
    return False


def parse_arguments():
    parser = argparse.ArgumentParser()

    # Increase verbosity with every occurrence of -v
    parser.add_argument("-v", "--verbose", action="count", default=0)

    # Define for which player we're listening
    parser.add_argument("--player")

    return parser.parse_args()


def main():
    arguments = parse_arguments()

    # Initialize logging
    logging.basicConfig(
        stream=sys.stderr,
        level=logging.DEBUG,
        format="%(name)s %(levelname)s %(message)s",
    )

    # Logging is set by default to WARN and higher.
    # With every occurrence of -v it's lowered by one
    logger.setLevel(max((3 - arguments.verbose) * 10, 0))

    # Log the sent command line arguments
    logger.debug(f"Arguments received {vars(arguments)}")

    manager = Playerctl.PlayerManager()
    loop = GLib.MainLoop()

    manager.connect(
        "name-appeared", lambda *args: on_player_appeared(*args, arguments.player)
    )
    manager.connect("player-vanished", on_player_vanished)

    signal.signal(signal.SIGINT, lambda _sig, _frame: signal_handler(loop))
    signal.signal(signal.SIGTERM, lambda _sig, _frame: signal_handler(loop))
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)

    GLib.io_add_watch(
        GLib.IOChannel.unix_new(sys.stdout.fileno()),
        GLib.PRIORITY_DEFAULT,
        GLib.IOCondition.HUP | GLib.IOCondition.ERR,
        on_stdout_closed,
        loop,
    )

    for player in manager.props.player_names:
        if arguments.player is not None and arguments.player != player.name:
            logger.debug(f"{player.name} is not the filtered player, skipping it")
            continue

        init_player(manager, player)

    loop.run()


if __name__ == "__main__":
    main()
