From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Question about notify.
Date: Mon, 25 Apr 2011 11:06:03 +0200
Message-ID: <BANLkTimAs2y121N6RZbzgmKC1+St4xuHrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

some of you may already know I'm busy with this, I've posted here
before and at other places about this topic.

see:

http://marc.info/?l=linux-fsdevel&m=130052497829681&w=2


In short, I want to make fs's like my FUSE fs and cifs handle inotify
request, done on userspace.

For my fs it would really make it more consistent when it's able to
handle inotify.

The idea is that when notify watch is set on an inode, part of a
mounted fs, the fs (FUSE fs or cifs or ....)
is notified by the VFS that a watch is set on an inode. So here the
VFS should inform the fs somehowe.

Next, it's up to the fs to handle this. Ignore is one, another is to
set a inotify watch on the backend when dealing
with a simple overlay FUSE fs, or forwarding to the backend (server) with cifs.

It's also up to the fs to get events back to the VFS. So the VFS
should listen somehow to incoming events coming from the fs for that
inode.

I've been thinking that an userspace daemon like gamin is the way to
go, but that's not ideal.
The fact that a watch is set on a inode is very usefull for my fs.

I would very much like to know what your opinion is.

Is this doable? I know that - like said in the message on
linux-fsdevel - other projects like NFS - are also be of interest. If
so I will contact them also.

Stef
