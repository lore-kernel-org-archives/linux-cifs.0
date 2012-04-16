From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] automake: add -Werror to CFLAGS
Date: Mon, 16 Apr 2012 14:13:30 -0400
Message-ID: <1334600010-27430-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With the recent patch to fix the warnings in asn1.c, cifs-utils now
builds without any warnings. Ban them henceforth by adding -Werror for
builds.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 17ad8e1..d95142a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-AM_CFLAGS = -Wall -Wextra
+AM_CFLAGS = -Wall -Wextra -Werror
 ACLOCAL_AMFLAGS = -I aclocal
 
 root_sbindir = $(ROOTSBINDIR)
-- 
1.7.7.6
