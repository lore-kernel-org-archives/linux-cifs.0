From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cifs: various cleanups pointed out by David Howells...
Date: Thu, 31 Mar 2011 17:36:40 -0400
Message-ID: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

David reviewed a set of cifs patches that I backported and pointed out
a few problems. This set is intended to fix them. Most are pretty
straightforward.

This should apply cleanly on top of the patch to switch the BCC to
little-endian. They compile cleanly without warnings and passed some
basic smoke testing with the connectathon tests.

Jeff Layton (5):
  cifs: turn BCC into a static inlined function
  cifs: remove unneeded variable initialization in cifs_reconnect_tcon
  cifs: fix comment in validate_t2
  cifs: clean up length checks in check2ndT2
  cifs: clean up various nits in unicode routines

 fs/cifs/cifs_unicode.c |   35 +++++++++++++++++------------------
 fs/cifs/cifs_unicode.h |    2 +-
 fs/cifs/cifspdu.h      |    9 ++++++---
 fs/cifs/cifssmb.c      |    7 ++++---
 fs/cifs/connect.c      |   26 +++++++++++++-------------
 5 files changed, 41 insertions(+), 38 deletions(-)

-- 
1.7.4
