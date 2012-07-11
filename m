From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] cifs: fix kmap deadlock on CONFIG_HIGHMEM machines with large r/wsizes
Date: Wed, 11 Jul 2012 09:09:34 -0400
Message-ID: <1342012176-14783-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The current read/write code in cifs.ko relies on being able to kmap all
of the data at once. This is a problem on machines with high memory.
kmap addresses are a limited resource and you can easily end up
exhausting it if your rsize/wsize is too large.

One such report of this problem is here:

    https://bugzilla.redhat.com/show_bug.cgi?id=832252

This patchset is intended as a temporary workaround on those machines
that should help prevent that sort of exhaustion.

The right fix for this is to teach the code how to deal with lists of
pages directly instead of relying on being able to kmap them all. I have
a patchset in progress that does just that, but it's not complete yet
and is pretty invasive. Until that's ready, I think this set is a
reasonable workaround.

Jeff Layton (2):
  cifs: on CONFIG_HIGHMEM machines, limit the rsize/wsize to the kmap
    space
  cifs: when CONFIG_HIGHMEM is set, serialize the read/write kmaps

 fs/cifs/cifssmb.c |   30 +++++++++++++++++++++++++++++-
 fs/cifs/connect.c |   18 ++++++++++++++++++
 2 files changed, 47 insertions(+), 1 deletions(-)

-- 
1.7.7.6
