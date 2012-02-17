From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] cifs: allocate dedicated cifsiod_workqueue
Date: Fri, 17 Feb 2012 09:31:41 -0500
Message-ID: <1329489104-7823-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org,
	tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As Alan Stern pointed out yesterday, cifs queues most of its workqueue
jobs to the system_nrt_wq. There are a couple of problems with that:

1/ That workqueue isn't freezable. Some workqueue jobs from cifs (like
   oplock breaks) can take quite some time to run since they have to
   kickoff writeback. That can end up making the freezer give up in
   some cases.

2/ We queue the async write completion handler to this codepath. Since
   that can be called in memory reclaim codepaths, we really ought to be
   queueing it to a workqueue with WQ_MEM_RECLAIM set.

This patch fixes this by allocating a new workqueue to which we'll queue
all the cifs jobs. The first two patches in the series do a little
cleanup work in the exit_cifs code, and the last patch adds the new
workqueue and has the callers queue their work to it.

This patchset is probably best suited for 3.4.

Jeff Layton (3):
  cifs: clean up call to cifs_dfs_release_automount_timer()
  cifs: clean up ordering in exit_cifs
  cifs: add new cifsiod_wq workqueue

 fs/cifs/cifsfs.c    |   25 +++++++++++++++++--------
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/cifsproto.h |    6 ++++++
 fs/cifs/cifssmb.c   |    4 ++--
 fs/cifs/connect.c   |    8 ++++----
 fs/cifs/misc.c      |    2 +-
 6 files changed, 31 insertions(+), 15 deletions(-)

-- 
1.7.7.6
