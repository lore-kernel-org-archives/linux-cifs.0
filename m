From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/18] cifs: overhaul request timeout behavior in CIFS (try #4)
Date: Sun, 26 Dec 2010 21:29:48 -0500
Message-ID: <1293417006-6417-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the fourth patchset to clean up request timeout behavior in
cifs.  There are only minor changes since the last set. Some of the
patches still need review. Here's an overview of what has changed:

- minor comment fix in patch 10

- the server echo "timeout" is now tunable via module parameter. It's
  also possible to set the timeout to 0, to stop the client from
  performing a reconnect at all.

The main impetus of this patchset is to change the way CIFS handles SMB
requests that are taking a long time. I won't rewrite all of that
information, but the description is available here:

    http://marc.info/?l=linux-cifs&m=129199588315592&w=2

Another discussion thread surrounding this change is also available
here:

    http://marc.info/?l=linux-cifs&m=129142970724511&w=2

I think there is some further work needed in this area, but this is a
good stopping point for 2.6.38 and it seems to fix the most glaring
problems. I'd like to see this merged during the next merge window if
possible.

Comments and suggestions welcome...

Jeff Layton (18):
  cifs: don't fail writepages on -EAGAIN errors
  cifs: no need to mark smb_ses_list as cifs_demultiplex_thread is
    exiting
  cifs: make wait_for_free_request take a TCP_Server_Info pointer
  cifs: clean up accesses to midCount
  cifs: move locked sections out of DeleteMidQEntry and AllocMidQEntry
  cifs: move mid result processing into common function
  cifs: wait indefinitely for responses
  cifs: don't reconnect server when we don't get a response
  cifs: clean up sync_mid_result
  cifs: allow for different handling of received response
  cifs: handle cancelled requests better
  cifs: add cifs_call_async
  cifs: add ability to send an echo request
  cifs: set up recurring workqueue job to do SMB echo requests
  cifs: reconnect unresponsive servers
  cifs: remove code for setting timeouts on requests
  cifs: mangle existing header for SMB_COM_NT_CANCEL
  cifs: send an NT_CANCEL request when a process is signalled

 fs/cifs/cifs_debug.c |   10 +-
 fs/cifs/cifsglob.h   |   25 ++-
 fs/cifs/cifspdu.h    |   15 ++
 fs/cifs/cifsproto.h  |    7 +
 fs/cifs/cifssmb.c    |   55 ++++++-
 fs/cifs/connect.c    |  150 +++++++++--------
 fs/cifs/file.c       |   93 +++++------
 fs/cifs/sess.c       |    2 +-
 fs/cifs/transport.c  |  463 ++++++++++++++++++++++++++------------------------
 9 files changed, 459 insertions(+), 361 deletions(-)

-- 
1.7.3.3
