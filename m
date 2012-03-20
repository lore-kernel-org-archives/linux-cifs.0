From: Thomas Hadig <thomas.hadig-O4KOoiensp/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] fixes issue mounting of DFS ROOT mount when redirecting
 from one domain controller to the next
Date: Tue, 20 Mar 2012 15:35:44 -0400
Message-ID: <7B8A1CD01838314387266CEE4CEB05600A137972A0@EX-002.mail.navisite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch fixes an issue when cifs_mount receives a STATUS_BAD_NETWORK_NAME error during cifs_get_tcon but is able to continue after an DFS ROOT referral. In this case, the return code variable is not reset prior to trying to mount from the system referred to. Thus, is_path_accessible is not executed and the final DFS referral is not performed causing a mount error.

Use case:
In DNS,  example.com  resolves to the secondary AD server   ad2.example.com
Our primary domain controller is ad1.example.com and has a DFS redirection set up from \\ad1\share\Users to \\files\share\Users.
Mounting \\example.com\share\Users fails.

Signed-off-by: Thomas Hadig <thomas at intapp.com>
Reviewed-by:  Jeff Layton <jlayton at redhat.com>

diff -Naur a/fs/cifs/connect.c b/fs/cifs/connect.c
--- a/fs/cifs/connect.c 2012-02-29 16:32:49.000000000 -0800
+++ b/fs/cifs/connect.c 2012-03-20 12:09:35.195182223 -0700
@@ -3220,7 +3220,7 @@
 int
 cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 {
-       int rc = 0;
+       int rc;
        int xid;
        struct cifs_ses *pSesInfo;
        struct cifs_tcon *tcon;
@@ -3252,6 +3252,7 @@
        srvTcp = NULL;
        full_path = NULL;
        tlink = NULL;
+        rc = 0;
 
        xid = GetXid();


Thanks
Thomas
