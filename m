From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Implement fsnotify for cifs (and others).
Date: Tue, 31 Dec 2013 19:51:06 +0100
Message-ID: <CANXojcw72QZz6aXb3Kor2omWu13g=aDAuzvtispwD=9z7y6RXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

earlier we spoke about making fs change notify work for cifs, nfs and fuse.

I've contacted Jan Kara about this issue. I've explained that the big
issue is how the fsevent calls can contact the different filesystems
about the fact a watch has been set or removed.

A callback/hook in fsnotify_add_inode_mark() and
fsnotify_destroy_inode_mark() is required to make this work.
The problem here that the original syscall should not wait for the
setting of the watch has finished on the server, especially
when dealing with a network fs. Maybe a special fsnotify queue per
connection/mount is a good idea. The fsnotify
callback for cifs will put a fs notify watch request on that queue,
and signal the cifs process about it.

What do you think?

Stef
