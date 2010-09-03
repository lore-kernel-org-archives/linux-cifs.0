From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] cifs: stop cifsd from exiting prematurely
Date: Fri,  3 Sep 2010 08:25:08 -0400
Message-ID: <1283516711-15073-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We've had some sporradic reports of problems recently where the
ses->server pointers have been NULL. That pointer should only get set to
NULL when cifs_demultiplex_thread exits. That should only happen when
the last reference to it is put. If it gets cleaned up before then,
other structures will hold pointers to it, and we'll get NULL pointer
dereferences.

Unfortunately, there are some places in cifs_demuliplex_thread where
this rule is broken. In certain error conditions, cifsd will exit even
though the reference count hasn't gone to zero yet. This patchset is
intended to close these holes. With it, cifsd should only exit when the
last reference to it is put.

Exiting from the loop early is a serious error that's likely to cause an
oops. I think we ought to consider this patchset for 2.6.36 and maybe
for stable.

Thoughts?

Jeff Layton (3):
  cifs: prevent cifsd from exiting prematurely
  cifs: eliminate some more premature cifsd exits
  cifs: prevent possible memory corruption in cifs_demultiplex_thread

 fs/cifs/cifsproto.h |    3 +-
 fs/cifs/connect.c   |   58 +++++++++++++++++---------------------------------
 fs/cifs/netmisc.c   |   22 +++++++++++--------
 3 files changed, 35 insertions(+), 48 deletions(-)
