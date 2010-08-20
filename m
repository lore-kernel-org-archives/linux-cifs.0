From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 12/15] cifs: fix cifs_show_options to show "username=" or "multiuser"
Date: Fri, 20 Aug 2010 15:32:08 -0400
Message-ID: <1282332731-17444-13-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

...based on CIFS_MOUNT_MULTIUSER flag.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsfs.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c6b8776..eea0897 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -368,8 +368,12 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	seq_printf(s, ",unc=%s", tcon->treeName);
-	if (tcon->ses->userName)
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
+		seq_printf(s, ",multiuser");
+	else if (tcon->ses->userName)
 		seq_printf(s, ",username=%s", tcon->ses->userName);
+
 	if (tcon->ses->domainName)
 		seq_printf(s, ",domain=%s", tcon->ses->domainName);
 
-- 
1.7.2.1

