From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] cifs: cifsacl cleanup, pile #3
Date: Fri, 19 Oct 2012 15:59:42 -0400
Message-ID: <1350676785-8525-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A few more fixes for the cifsacl set. Steve, I can roll these into the
other patches if you'd prefer...

Jeff Layton (3):
  cifs: extra sanity checking for cifs.idmap keys
  cifs: fix hardcoded default security descriptor length
  cifs: deal with id_to_sid embedded sid reply corner case

 fs/cifs/cifsacl.c | 35 ++++++++++++++++++++++++++++++-----
 fs/cifs/cifsacl.h | 11 ++++++++---
 2 files changed, 38 insertions(+), 8 deletions(-)

-- 
1.7.11.7
