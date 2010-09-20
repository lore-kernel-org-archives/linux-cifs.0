From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 11/15] cifs: fix cifs_show_options to show "username=" or "multiuser"
Date: Mon, 20 Sep 2010 16:01:40 -0700
Message-ID: <1285023704-2159-12-git-send-email-jlayton@redhat.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

...based on CIFS_MOUNT_MULTIUSER flag.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsfs.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 2b897e3..51090cec 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -371,8 +371,12 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
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
1.7.2.3

