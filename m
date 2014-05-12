From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 0/3] cifs: small clean up series
Date: Mon, 12 May 2014 19:55:04 +0300
Message-ID: <1399913707-31262-1-git-send-email-andriy.shevchenko@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>,
	Alexander Bokovoy <ab-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is small clean up series against CIFS kernel module.

Changes since v2:
 - patch 1 got ACK and Reviwed-by tags
 - patch 2 incorporates new piece of code similar that it used to have already,
   thus tags were dropped for this round
 - new patch 3

Andy Shevchenko (3):
  cifs: call strtobool instead of custom implementation
  cifs: convert to print_hex_dump() instead of custom implementation
  cifs: convert printk(LEVEL...) to pr_<level>

 fs/cifs/cifs_debug.c | 77 ++++++++++++++++++++++------------------------------
 fs/cifs/cifs_debug.h |  7 ++---
 fs/cifs/connect.c    | 51 ++++++++++++----------------------
 fs/cifs/misc.c       | 32 ++--------------------
 fs/cifs/netmisc.c    |  2 +-
 fs/cifs/transport.c  |  4 +--
 6 files changed, 59 insertions(+), 114 deletions(-)

-- 
2.0.0.rc2
