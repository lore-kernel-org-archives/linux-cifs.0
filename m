From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cifs: pave way for change to "strictcache" by default
Date: Fri, 27 Apr 2012 06:56:15 -0400
Message-ID: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs.ko currently does not follow the CIFS protocol as it should by
default. The protocol specifies (paraphrasing) "Thou shalt not cache
file data without an oplock." cifs.ko by default *does* do this however,
opting for a more NFS-like cache coherency scheme. It caches file data
in the pagecache, and invalidate it when the attributes look like the
file has changed.

Unfortunately, this can and does cause cache coherency problems. The
kernel can end up buffering up writes for longer than it should. In
particular, internal testing at RH with Samba/CTDB has shown cache
coherency problems when we don't mount on the clients with
strictcache:

    https://bugzilla.redhat.com/show_bug.cgi?id=742314

Up until now, we've shied away from changing this default primarily for
performance reasons. The code to handle uncached reads and writes was
synchronous, and very slow. With the addition of async uncached writes
in 3.4 and async uncached reads in 3.5, I think performance is good
enough that we ought to change the defaults to be "strictcache" for
better adherence to the protocol.

This patchset begins this transition by cleaning up the mount options
that we use to control the cache behavior, and adding some warnings
about the impending behavior change. I'm proposing that we follow the
kernel convention of warning for 2 releases about user-visible changes
and then we'll make the switch in 3.7.

At the same time, it corrects a problem with the current code. The
different cache behaviors are not considered to be mutually exclusive
even though they should be. If someone (for instance) specifies
"strictcache" and "fsc" the results are poorly defined. The first
patch corrects this.

If this looks acceptable, I'll also plan to spin up a manpage patch
to help document this change.

Jeff Layton (4):
  cifs: add a cache= option to better describe the different cache
    flavors
  cifs: add deprecation warnings to strictcache, forcedirectio, and fsc
  cifs: display cache= option in /proc/mounts
  cifs: add warning about change in default cache semantics in 3.7

 fs/cifs/cifsfs.c  |   22 +++++++++---
 fs/cifs/connect.c |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 109 insertions(+), 9 deletions(-)

-- 
1.7.7.6
