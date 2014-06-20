From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] cifs: fix error code in cifs_match_super()
Date: Fri, 20 Jun 2014 22:22:05 +0300
Message-ID: <20140620192205.GC19824@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It looks like there is a typo here where return "rc" which is "success"
instead of PTR_ERR(tlink) which is a negative error code.

I have also removed the unneeded initialization so that GCC has a chance
to warn about this sort of thing next time.

Fixes: 25c7f41e9234 ('CIFS: Migrate to shared superblock model')
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
This is a static checker warning and I'm not certain this is the correct
fix.  Please review this one carefully.

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 20d75b8..a5704e1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2730,14 +2730,14 @@ cifs_match_super(struct super_block *sb, void *data)
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
-	int rc = 0;
+	int rc;
 
 	spin_lock(&cifs_tcp_ses_lock);
 	cifs_sb = CIFS_SB(sb);
 	tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
 	if (IS_ERR(tlink)) {
 		spin_unlock(&cifs_tcp_ses_lock);
-		return rc;
+		return PTR_ERR(tlink);
 	}
 	tcon = tlink_tcon(tlink);
 	ses = tcon->ses;
