From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH] cifs: Do not enable debugging code by default
Date: Mon, 17 Dec 2012 10:38:05 +0100
Message-ID: <1355737085-6671-1-git-send-email-bp@alien8.de>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Debugging code is generally disabled in the configurator since it is
only for devs and testers and not for the majority of the installations.

Cc: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
---
 fs/cifs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 21ff76c22a17..241a0e2853c5 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -124,7 +124,6 @@ config CIFS_ACL
 
 config CIFS_DEBUG
 	bool "Enable CIFS debugging routines"
-	default y
 	depends on CIFS
 	help
 	   Enabling this option adds helpful debugging messages to
-- 
1.8.1.rc2
