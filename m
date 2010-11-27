From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH 00/14] cifs: overhaul request timeout behavior in CIFS (try #1)
Date: Sat, 27 Nov 2010 08:01:12 -0500
Message-ID: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is intended to fix the unreliable behavior in CIFS in the
face of a server that's taking a long time to process requests.

In general, the current code sets a timeout for all requests that are
sent on the wire. If the server doesn't respond to the request within
that timeout, the client performs a reconnect and retries the request.

This is dangerous and wasteful behavior for the client. Much of the
state of a CIFS mount is bound to the socket connection. Break the
socket connection and state is lost.

I believe this the root cause of some data corruption issues that have
been reported to me. We had a partner report that when they copied a
large file to a CIFS server and then compare the result to the original,
there is sometimes a mismatch. The problem is highly correlated to
messages in the ring buffer that indicate that the client reconnected
the socket during the test run.

Another problem that I can reliably reproduce -- I have win2k8
installed as a VM guest. When I run connectathon tests to that server,
it frequently fails on the test that writes 4GB past the EOF. The
storage on this server is slow, and it can take longer than 180s for
it to zero-fill the output file.

The intent of this patchset is to fundamentally change when the client
decides to reconnect the socket. Instead of the old behavior, this
patchset makes the client wait indefinitely for a response. Rather than
waiting in TASK_UNINTERRUPTIBLE sleep however, the client waits in
TASK_KILLABLE sleep so that fatal signals will end the sleep and
return -ERESTARTSYS to the caller.

In order to determine whether the server is completely dead or just
taking a long time to process requests, this patchset has the client
do an asynchronous SMB echo request every 60s when the client hasn't
gotten a reponse. If the server doesn't respond after 5 mins, the
client will attempt to reconnect the socket.

With this patchset, I can reliably run the connectathon tests against
my slow server. Preliminary results using the proprietary test that
was seeing data corruption have also been promising.

I'd like to see this set considered for inclusion into 2.6.38.

Comments and suggestions welcome.

Jeff Layton (14):
  cifs: move mid result processing into common function
  cifs: wait indefinitely for responses
  cifs: don't reconnect server when we don't get a response
  cifs: clean up handle_mid_response
  cifs: allow for different handling of received response
  cifs: don't fail writepages on -EAGAIN errors
  cifs: handle cancelled requests better
  cifs: make wait_for_free_request take a TCP_Server_Info pointer
  cifs: add cifs_call_async
  cifs: add ability to send an echo request
  cifs: set up recurring workqueue job to do SMB echo requests
  cifs: reconnect unresponsive servers
  cifs: make hard mounts the default
  cifs: remove code for setting timeouts on requests

 fs/cifs/cifs_debug.c |    8 +-
 fs/cifs/cifsglob.h   |   19 ++--
 fs/cifs/cifspdu.h    |   15 +++
 fs/cifs/cifsproto.h  |    7 +
 fs/cifs/cifssmb.c    |   55 ++++++++-
 fs/cifs/connect.c    |  128 +++++++++++++++----
 fs/cifs/file.c       |   48 ++------
 fs/cifs/sess.c       |    2 +-
 fs/cifs/transport.c  |  344 ++++++++++++++++++++++----------------------------
 9 files changed, 355 insertions(+), 271 deletions(-)

-- 
1.7.3.2
