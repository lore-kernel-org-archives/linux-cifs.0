From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/3] getcifsacl/setcifsacl: more endianness fixes
Date: Wed,  7 Nov 2012 06:51:57 -0500
Message-ID: <1352289120-29327-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With these fixes, I can confirm that getcifsacl and setcifsacl now
work correctly on big-endian boxes, at least in fairly rudimentary
testing.

As a side note, I'll probably cut a new release within the next few days
in order to get these fixes out to distros. Post 'em if you've got 'em.

Jeff Layton (3):
  getcifsacl: fix endianness bug in getcifsacl and add better bounds
    checks
  setcifsacl: fix up ACE mask handling
  setcifsacl: fix endianness of ->size in build_cmdline_aces

 getcifsacl.c | 14 +++++++---
 setcifsacl.c | 85 ++++++++++++++++++++++++++++++------------------------------
 2 files changed, 53 insertions(+), 46 deletions(-)

-- 
1.7.12.1
