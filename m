From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: show sec= option in /proc/mounts
Date: Mon, 13 Jun 2011 11:50:41 -0400
Message-ID: <1307980241-2265-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 989442d..e9def99 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -352,6 +352,37 @@ cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
 	}
 }
 
+static void
+cifs_show_security(struct seq_file *s, struct TCP_Server_Info *server)
+{
+	seq_printf(s, ",sec=");
+
+	switch (server->secType) {
+	case LANMAN:
+		seq_printf(s, "lanman");
+		break;
+	case NTLMv2:
+		seq_printf(s, "ntlmv2");
+		break;
+	case NTLM:
+		seq_printf(s, "ntlm");
+		break;
+	case Kerberos:
+		seq_printf(s, "krb5");
+		break;
+	case RawNTLMSSP:
+		seq_printf(s, "ntlmssp");
+		break;
+	default:
+		/* shouldn't ever happen */
+		seq_printf(s, "unknown");
+		break;
+	}
+
+	if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+		seq_printf(s, "i");
+}
+
 /*
  * cifs_show_options() is for displaying mount options in /proc/mounts.
  * Not all settable options are displayed but most of the important
@@ -365,6 +396,8 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 	struct sockaddr *srcaddr;
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
+	cifs_show_security(s, tcon->ses->server);
+
 	seq_printf(s, ",unc=%s", tcon->treeName);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
-- 
1.7.5.2
