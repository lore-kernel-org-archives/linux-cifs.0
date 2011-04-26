From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cifs: fix some bounds checking problems
Date: Tue, 26 Apr 2011 08:03:16 -0400
Message-ID: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset fixes a number of problems that David pointed out while
reviewing some backports for RHEL. I think they're appropriate for
2.6.39 and probably the stable series as well.

Jeff Layton (5):
  cifs: change bleft in decode_unicode_ssetup back to signed type
  cifs: check for bytes_remaining going to zero in CIFS_SessSetup
  cifs: sanitize length checking in coalesce_t2
  cifs: refactor mid finding loop in cifs_demultiplex_thread
  cifs: handle errors from coalesce_t2

 fs/cifs/connect.c |  117 +++++++++++++++++++++++++++++-----------------------
 fs/cifs/sess.c    |   19 ++-------
 2 files changed, 69 insertions(+), 67 deletions(-)

-- 
1.7.4.4
