From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/5] Add SMB/CIFS section in tests.init
Date: Wed,  6 Aug 2014 16:01:11 +0400
Message-ID: <1407326472-13853-5-git-send-email-pshilovsky@samba.org>
References: <1407326472-13853-1-git-send-email-pshilovsky@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407326472-13853-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---
 tests.init | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests.init b/tests.init
index 4d16e1b..4b574fc 100644
--- a/tests.init
+++ b/tests.init
@@ -33,6 +33,10 @@ MOUNTCMD='./domount -o $MNTOPTIONS $SERVER\:$SERVPATH $MNTPOINT'
 #	DG/UX
 #MOUNTCMD='./domount -t nfs -o $MNTOPTIONS $SERVER\:$SERVPATH $MNTPOINT'
 
+# Use this mount command if using:
+#	SMB/CIFS
+#MOUNTCMD='./domount -t cifs -o $MNTOPTIONS //$SERVER/$SERVPATH $MNTPOINT'
+
 UMOUNTCMD='./domount -u $MNTPOINT'
 
 # Use the next two lines if using:
-- 
1.8.1.2
