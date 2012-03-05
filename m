From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Connect notifyfs to cifs possible.
Date: Mon, 5 Mar 2012 09:54:27 +0100
Message-ID: <CANXojczcNTpzgWf95Np9OHhFRu2hGqh=SrOe+UMm294t8HNuPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I'm working on a successor of gamin, a file system change notifier.

Like with gamin client apps can connect to it and instruct it to watch
a specific path.

It's up to the notifyfs service to decide what backend (inotify,
polling etc) to use.

New in my fs is the ability to "forward" the request to set a watch to
a fs. I do not have
a working example, but what I've got looks promising. I've got a
simple FUSE overlay fs, and this will use,
whenever it receives a request to set a watch from notifyfs, it set's
a inotify watch on the underlying fs, and send any event back to
notify fs.

To make this possible the filesystem, here thus the FUSE overlay fs,
has to connect to noitifyfs when it starts up, and register itself as
client fs, and also has to send it's own mountpoint to notifyfs.

I looked into the code of mount.cifs, but it's not that easy to
connect to via a socket, because the mainloop is in the kernel, not in
userspace. Is this somehowe (event fd??) still possible?

Stef
