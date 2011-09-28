From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] allow freezing of tasks with netfs calls in flight
Date: Wed, 28 Sep 2011 07:52:37 -0400
Message-ID: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
Cc: linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john-D0fwSNaahy58zQARNC3f2A@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org,
	rjw-KKrjLPT3xs0@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We've had a number of reports recently of people with NFS and CIFS
mounts that were unable to suspend or hibernate their machines. Here
are a couple of Fedora bugs that illustrate the problem:

    https://bugzilla.redhat.com/show_bug.cgi?id=712088
    https://bugzilla.redhat.com/show_bug.cgi?id=717735

When it occurs the problem is pretty clear. We have a task that's
sleeping in the kernel in TASK_KILLABLE sleep, generally waiting
for a reply to come in. Often though, userspace has already taken
down the interface so that reply will never come. The process then
fails to freeze and the suspend fails.

This patch fixes this by allowing the TASK_KILLABLE sleeps in NFS and
CIFS to be awoken by the freezer and then to try to freeze. If a freeze
event does occur, then the code will treat it as if a schedule() has
already occured.

I've had a number of people test versions of this set and the results
have been positive. Part of the problem though is that there are
sometimes still unrelated problems with suspend/resume that seem to
cloud the results. As best we can tell though, this patchset does work
as advertised.

Jeff Layton (4):
  freezer: make fake_signal_wake_up wake TASK_KILLABLE tasks too
  cifs, freezer: add wait_event_freezekillable and have cifs use it
  sunrpc: make rpc_wait_bit_killable handle freeze events
  nfs: make TASK_KILLABLE sleeps attempt to freeze

 fs/cifs/transport.c     |    3 ++-
 fs/nfs/inode.c          |    4 +++-
 fs/nfs/nfs3proc.c       |    3 ++-
 fs/nfs/nfs4proc.c       |   12 ++++++++----
 fs/nfs/proc.c           |    3 ++-
 include/linux/freezer.h |   19 +++++++++++++++++--
 kernel/freezer.c        |    2 +-
 net/sunrpc/sched.c      |    4 +++-
 8 files changed, 38 insertions(+), 12 deletions(-)

-- 
1.7.6.2
