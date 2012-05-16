From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/4] cifs: pave way for change to "strictcache" by default
Date: Wed, 16 May 2012 07:55:50 -0400
Message-ID: <1337169354-19045-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second version of this patchset. The first version of this
lays out the rationale for this change and is available here:

    http://permalink.gmane.org/gmane.linux.kernel.cifs/6007

In discussing this, Steve pointed out that fsc is not necessarily
mutually exclusive with cache=strict. While I've always tended to think
of fsc as a mechanism to cache data across reboots, it can also function
as a "swap for pagecache" mechanism as well, allowing you to cache more
data locally than you have RAM.

That said, I don't think the intersection of cache=strict and fsc will
work properly today. I'm skeptical that the fscache is being invalidated
correctly when an oplock is lost and reacquired. That should probably be
fixed at some point if we want this to work.

Still, that's good enough reason not to make fsc mutually exclusive with
the other cache= options. This patchset then removes fsc from that
mutual exclusion and the warnings.

I've left Pavel's Reviewed-by's in place since this patchset is in the
same spirit as the previous one. Pavel, let me know if you'd like those
removed.

Jeff Layton (4):
  cifs: add a cache= option to better describe the different cache
    flavors
  cifs: add deprecation warnings to strictcache and forcedirectio
  cifs: display cache= option in /proc/mounts
  cifs: add warning about change in default cache semantics in 3.7

 fs/cifs/cifsfs.c  |   18 ++++++++++---
 fs/cifs/connect.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 87 insertions(+), 7 deletions(-)

-- 
1.7.7.6
