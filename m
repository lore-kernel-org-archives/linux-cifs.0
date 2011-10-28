From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 50/53] CIFS: Introduce smb2 mounts as vers=2
Date: Fri, 28 Oct 2011 23:55:01 +0400
Message-ID: <1319831704-3572-51-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

As with Linux nfs client, which uses "nfsvers=" or "vers=" to
indicate which protocol to use for mount, specifying

"vers=smb2" or "vers=2"

will force an smb2 mount. When vers is not specified cifs is used

ie "vers=cifs" or "vers=1"

We can eventually autonegotiate down from smb2 to cifs
when smb2 is stable enough to make it the default, but this
is for the future.  At that time we could also implement a
"maxprotocol" mount option as smbclient and Samba have today,
but that would be premature until smb2 is stable.

Intially the smb2 Kconfig option will depend on "BROKEN"
until the merge is complete, and then be "EXPERIMENTAL"
When it is no longer experimental we can consider changing
the default protocol to attempt first.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c8a94a4..cd1c85c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1274,6 +1274,13 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				   (strnicmp(value, "1", 1) == 0)) {
 				/* this is the default */
 				continue;
+			} else if ((strnicmp(value, "smb2", 4) == 0) ||
+				   (strnicmp(value, "2", 1) == 0)) {
+#ifdef CONFIG_CIFS_SMB2
+				vol->use_smb2 = true;
+#else
+				cERROR(1, "smb2 support not enabled");
+#endif /* CONFIG_CIFS_SMB2 */
 			}
 		} else if ((strnicmp(data, "unc", 3) == 0)
 			   || (strnicmp(data, "target", 6) == 0)
-- 
1.7.1
