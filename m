From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/6] cifs-utils: a pile of random patches
Date: Tue,  4 Dec 2012 10:16:38 -0500
Message-ID: <1354634204-21602-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Here's a pile of random patches I've accumulated so for for cifs-utils.
They should be fairly straightforward, but let me know if anyone has
concerns with them.

Jeff Layton (6):
  mount.cifs: treat uid=,gid=,cruid= options as name before assuming
    they're a number
  mount.cifs: don't pass "flag" options to the kernel
  autotools: remove unnecessary files from distro
  getcifsacl: use "size" instead of reconverting original field to host
    endian
  getcifsacl: free strings returned by wbcLookupSid
  getcifsacl: ensure that we don't overrun the wbcDomainSid when
    converting

 INSTALL      | 365 ----------------------------------
 depcomp      | 630 -----------------------------------------------------------
 getcifsacl.c |  12 +-
 install-sh   | 520 ------------------------------------------------
 missing      | 376 -----------------------------------
 mount.cifs.c |  74 +++----
 6 files changed, 40 insertions(+), 1937 deletions(-)
 delete mode 100644 INSTALL
 delete mode 100755 depcomp
 delete mode 100755 install-sh
 delete mode 100755 missing

-- 
1.7.11.7
