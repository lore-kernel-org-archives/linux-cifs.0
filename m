From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: [PATCH 2/4] Fix Bug#31092: Unable to mount DFS filesystems from Windows 2008 servers
Date: Fri, 1 Apr 2011 13:53:02 +0200
Message-ID: <E1Q5dRc-0005jb-QI@seldlx2151.corpusers.net>
References: <20110401073256.70180710@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110401073256.70180710-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Windows 2008 CIFS servers do not always return PATH_NOT_COVERED when
attempting to access a DFS share.  Therefore, when checking for remote
shares, unconditionally ask for a DFS referral for the UNC (w/out prepath)
before continuing with previous behavior of attempting to access the UNC +
prepath and checking for PATH_NOT_COVERED.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=31092
---
 fs/cifs/connect.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7a9b2da..9425c7b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2934,6 +2934,24 @@ try_mount_again:
 			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
 
 remote_path_check:
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	/*
+	 * Perform an unconditional check for whether there are DFS
+	 * referrals for this path without prefix, to provide support
+	 * for DFS referrals from w2k8 servers which don't seem to respond
+	 * with PATH_NOT_COVERED to requests that include the prefix.
+	 * Chase the referral if found, otherwise continue normally.
+	 */
+	if (referral_walks_count == 0) {
+		int refrc = expand_dfs_referral(xid, pSesInfo, volume_info,
+						cifs_sb, &mount_data, false);
+		if (!refrc) {
+			referral_walks_count++;
+			goto try_mount_again;
+		}
+	}
+#endif
+
 	/* check if a whole path (including prepath) is not remote */
 	if (!rc && tcon) {
 		/* build_path_to_root works only when we have a valid tcon */
-- 
1.7.2.3
