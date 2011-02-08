From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: reacquire CAP_DAC_READ_SEARCH before calling mount(2)
Date: Tue,  8 Feb 2011 15:02:24 -0500
Message-ID: <1297195344-4460-1-git-send-email-jlayton@samba.org>
Cc: erik-nLcryBYLV+bMkAkIaI5Geg@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's possible that the user is trying to mount onto a directory to which
he doesn't have execute perms. If that's the case then the mount will
currently fail. Fix this by reenabling CAP_DAC_READ_SEARCH before
calling mount(2). That will ensure that the kernel's permissions check
for this is bypassed.

Reported-by: Erik Logtenberg <erik-nLcryBYLV+bMkAkIaI5Geg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 3a2b539..8e1e32b 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1898,8 +1898,13 @@ mount_retry:
 	else
 		fstype = cifs_fstype;
 
-	if (!parsed_info->fakemnt
-	    && mount(dev_name, ".", fstype, parsed_info->flags, options)) {
+	if (!parsed_info->fakemnt) {
+		toggle_dac_capability(0, 1);
+		rc = mount(dev_name, ".", fstype, parsed_info->flags, options);
+		toggle_dac_capability(0, 0);
+		if (rc == 0)
+			goto do_mtab;
+
 		switch (errno) {
 		case ECONNREFUSED:
 		case EHOSTUNREACH:
@@ -1934,6 +1939,7 @@ mount_retry:
 		goto mount_exit;
 	}
 
+do_mtab:
 	if (!parsed_info->nomtab && !mtab_unusable())
 		rc = add_mtab(orig_dev, mountpoint, parsed_info->flags, fstype);
 
-- 
1.7.4
