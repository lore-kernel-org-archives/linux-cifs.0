From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Alpha release of fuse-workspace.
Date: Tue, 28 Aug 2012 15:49:40 +0200
Message-ID: <CANXojczhA5dqNJYM_e8sG9CfDG0gGZgaKmZBR5hjgKE8jE8y7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I would like to announce the alpha release of fuse-workspace, a tool
which takes care of access to all kinds
of resources.

It's independent of the GUI, this works in every environment, so also
in the textconsole.

It gives access on filesystem level, via FUSE for virtual maps and
uses external mount commands when mounting SMB shares, and cifs is
used.

Please test, and try!

Access to smb shares can be internal (then libsmbclient is used) and
cifs (then fuse-workspace mounts using cifs).

See:

https://github.com/stefbon/fuse-workspace

Apart from access the smb network, it supports an audio cd, and I'm
working on access to FTP servers.

I've tested it on some machines, but it's alpha.

Stef
