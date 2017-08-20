From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 0/8] CIFS: Adjustments for several function implementations
Date: Sun, 20 Aug 2017 18:32:12 +0200
Message-ID: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-GB
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sun, 20 Aug 2017 18:24:56 +0200

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (8):
  Delete 11 error messages for a failed memory allocation
  Improve 27 size determinations
  One function call less in cifs_lookup() after error detection
  Use common error handling code in cifs_mknod()
  Less function calls in cifs_mknod() after error detection
  Return directly after a failed build_path_from_dentry() in cifs_do_create()
  Delete an unnecessary variable initialisation in cifs_do_create()
  One function call less in cifs_do_create() after error detection

 fs/cifs/cifsacl.c       |  8 +++----
 fs/cifs/cifsfs.c        |  2 +-
 fs/cifs/cifssmb.c       |  4 +---
 fs/cifs/connect.c       | 17 ++++-----------
 fs/cifs/dir.c           | 55 +++++++++++++++++++++++++------------------------
 fs/cifs/ioctl.c         |  2 +-
 fs/cifs/readdir.c       |  2 +-
 fs/cifs/sess.c          |  9 +++-----
 fs/cifs/smb1ops.c       |  2 +-
 fs/cifs/smb2file.c      |  4 ++--
 fs/cifs/smb2misc.c      |  2 +-
 fs/cifs/smb2ops.c       | 21 ++++++++-----------
 fs/cifs/smb2pdu.c       | 17 +++++----------
 fs/cifs/smb2transport.c |  1 -
 14 files changed, 61 insertions(+), 85 deletions(-)

-- 
2.14.0
