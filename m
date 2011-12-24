From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Any interest in inotify messages via netlink.
Date: Sat, 24 Dec 2011 11:14:37 +0100
Message-ID: <CANXojcycznnzbzrM8eX19b6hEDwzQ29MMTOedAGDCXX=HRqPFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

earlier I mentioned here I'm working on the ability for filesystems
like FUSE based, cifs and nfs.

Recently I've created a patch for the kernel, which makes the calls
inotify_add_watch and inotify_remove_watch
send a message to userspace, containing (pid, fd, wd, [mask], [path]).

(in case of add watch the values between [] are sent also, when remove not)

My idea for a FUSE based fs is to listen to this messages (familiy
GENERIC, group VFS_INOTIFY),
filter messages out which do not apply (only those messages for the
used mountpoint for fs) and then let the FUSE fs take proper action,
which suits the backend.

In case of a simple overlay fs, this means that it sets watch on the
underlying fs, and send change events (which fits the mask) to the
kernel. Recent FUSE versions have calls added which can notify the
kernel about a change, without the need of a related request, like
getattr, open, lookup etc.
The fs has to remove this/stop this when a remove watch message is
received. A proper adiminstration of current watches set is required.


Can this also work for cifs?? I always thought that cifs is just like
FUSE in userspace, but that isn't the case is it?

Stef
