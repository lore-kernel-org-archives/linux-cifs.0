From: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH cifs-next] fs: cifs: make smb_echo_interval tunable
Date: Thu,  8 Nov 2012 14:50:28 -0600
Message-ID: <1352407828-23339-1-git-send-email-chris.j.arges@canonical.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Change SMB_ECHO_INTERVAL to make it a module parameter.

BugLink: http://bugs.launchpad.net/bugs/1017622
BugLink: https://bugzilla.samba.org/show_bug.cgi?id=9006

Reported-by: Oliver Dumschat-Hoette <dumschat-hoette-cpG9vB2psbIb1SvskN2V4Q@public.gmane.org>
Signed-off-by: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    5 +++++
 fs/cifs/cifsglob.h |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5e62f44..25748b3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -82,6 +82,11 @@ MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
 module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
+unsigned short smb_echo_timeout = 60;
+module_param(smb_echo_timeout, ushort, 0644);
+MODULE_PARM_DESC(smb_echo_timeout, "Timeout between two echo requests. "
+				   "Default: 60. Timeout in seconds ");
+
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f5af252..d64dcd3 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -78,8 +78,9 @@
 /*           (max path length + 1 for null) * 2 for unicode    */
 #define MAX_NAME 514
 
-/* SMB echo "timeout" -- FIXME: tunable? */
-#define SMB_ECHO_INTERVAL (60 * HZ)
+/* SMB echo "timeout" */
+extern unsigned short smb_echo_timeout;
+#define SMB_ECHO_INTERVAL (smb_echo_timeout * HZ)
 
 #include "cifspdu.h"
 
-- 
1.7.10.4
