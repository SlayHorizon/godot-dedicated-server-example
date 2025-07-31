# Godot Dedicated Server Example

*Compatible with Godot 4.x – 4.5*

This repository provides a minimal and functional example of a dedicated server and client built entirely with Godot.  
The server and client are organized as two separate Godot projects like this:
```bash
.
├── client/  # Godot client project
└── server/  # Godot server project
```

### Why?

In non–peer-to-peer multiplayer games, sometimes you want to keep server logic completely separate from the client.  
> As for peer-to-peer game, having both client and server in same project may be necessary but that’s not the topic here.

Developers might choose this approach for several reasons:
* **Security**: You may not want any server code or logic exposed on the client side.
* **Clarity & Modularity**: Separating responsibilities helps keep the codebase organized and easier to maintain.
* **Testing & Debugging**: Isolating server logic makes it easier to test and debug without interference from client-side systems.

> My opinion is these points can still be handled in single project since Godot 4, as demonstrated [here](https://github.com/SlayHorizon/godot-tiny-mmo-demo).

---

## Getting Started

1. Clone this repository.
2. Open both the `client` and `server` projects separately in Godot.
3. Run the `server` project first, then run the `client`. The client should connect automatically.

---

## Resources

Useful links to the official Godot documentation:

* [Networking Overview](https://docs.godotengine.org/en/stable/tutorials/networking/index.html)
* [High-Level Multiplayer API](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html)

---

## Related Project

Looking for a more advanced example?
Check out https://github.com/SlayHorizon/godot-tiny-mmo-demo:  
A more complete project that combines both client and server in a single Godot project, and includes additional multiplayer features.
