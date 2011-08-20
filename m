From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/14] cifs: cleanup and overhaul of the receive codepath
Date: Fri, 19 Aug 2011 21:55:25 -0400
Message-ID: <1313805339-1233-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset cleans up and overhauls the receive codepath. This can be
considered phase one of a patchset to add support for larger and
asynchronous reads to cifs.ko.

This builds on the work that Pavel did in 3.1 to break up
cifs_demultiplex_thread into multiple functions. It genericizes many of
the receive routines and simplifies the functions further.

It also adds the ability to do a receive into an array of iovecs, which
will be a key to allowing reads that exceed the size of the
CIFSMaxBufSize and minimizing copying in the read codepath.

It also fixes a number of bugs in the current code that I found while
scraping through here. Most of them are unreported as far as I know, but
they're still worth fixing.

I think this set of changes is probably ready for consideration for 3.2.
It passes basic smoke testing. The series is bisectable, and most of the
patches have been tested individually. It would be safest to commit
these in order. Getting them into linux-next ASAP would be best to make
sure that I didn't regress anything.

Once I know that these patches are queued for merge, I'll plan to start
work on the async readpages work in earnest. That shouldn't be too
difficult once these changes are in place.

Comments and suggestions welcome...

Jeff Layton (14):
  cifs: trivial: remove obsolete comment
  cifs: make smb_msg local to read_from_socket
  cifs: check for unresponsive server every time we call kernel_recvmsg
  cifs: simplify read_from_socket
  cifs: turn read_from_socket into a wrapper around a vectorized
    version
  cifs: clean up check_rfc1002_header
  cifs: add a third receive phase to cifs_demultiplex_thread
  cifs: clean up checkSMB
  cifs: move mid finding into separate routine
  cifs: eliminate is_multi_rsp parm to find_cifs_mid
  cifs: move buffer pointers into TCP_Server_Info
  cifs: find mid earlier in receive codepath
  cifs: break out 3rd receive phase into separate function
  cifs: add a callback function to receive the rest of the frame

 fs/cifs/cifsglob.h |   27 +++-
 fs/cifs/connect.c  |  505 +++++++++++++++++++++++++++++----------------------
 fs/cifs/misc.c     |   51 +++---
 3 files changed, 336 insertions(+), 247 deletions(-)

-- 
1.7.6
