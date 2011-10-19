From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cifs: allow cifs to do readpages larger and asynchronously (try #7)
Date: Wed, 19 Oct 2011 09:24:50 -0400
Message-ID: <1319030695-4115-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is a respin to fix a bug that Pavel identified in the
readv error handling, and to also fix up some merge conflicts that crept
in with some other patches that Steve merged recently. Other than those
changes, this is essentially the same patchset as the earlier versions
in this series.

This set is also available via my git tree on samba.org:

    http://git.samba.org/?p=jlayton/linux.git;a=summary

Jeff Layton (5):
  cifs: fix protocol definition for READ_RSP
  cifs: add cifs_async_readv
  cifs: convert cifs_readpages to use async reads
  cifs: allow for larger rsize= options and change defaults
  cifs: tune bdi.ra_pages in accordance with the rsize

 fs/cifs/cifspdu.h   |    4 +-
 fs/cifs/cifsproto.h |   24 ++++
 fs/cifs/cifssmb.c   |  359 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/connect.c   |  167 +++++++++++++++---------
 fs/cifs/file.c      |  293 ++++++++++++++++++------------------------
 5 files changed, 612 insertions(+), 235 deletions(-)

-- 
1.7.6.4
