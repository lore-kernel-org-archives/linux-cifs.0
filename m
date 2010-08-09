From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 7/7] cifs: add "mfsymlinks" mount option
Date: Mon,  9 Aug 2010 19:07:15 +0200
Message-ID: <1281373635-16202-8-git-send-email-metze@samba.org>
References: <1281373635-16202-1-git-send-email-metze@samba.org>
 <1281373635-16202-2-git-send-email-metze@samba.org>
 <1281373635-16202-3-git-send-email-metze@samba.org>
 <1281373635-16202-4-git-send-email-metze@samba.org>
 <1281373635-16202-5-git-send-email-metze@samba.org>
 <1281373635-16202-6-git-send-email-metze@samba.org>
 <1281373635-16202-7-git-send-email-metze@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281373635-16202-7-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the start for an implementation of "Minshall+French Symlinks"
(see http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks).

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/README    |    5 +++++
 fs/cifs/cifsfs.c  |    2 ++
 fs/cifs/connect.c |   11 +++++++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index a7081ee..6baf1b4 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -517,6 +517,11 @@ A partial list of the supported mount options follows:
 		SFU does).  In the future the bottom 9 bits of the
 		mode also will be emulated using queries of the security
 		descriptor (ACL).
+ mfsymlinks     Enable support for Minshall+French symlinks
+		(see http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks)
+		This option is ignored when specified together with the
+		'sfu' option. Minshall+French symlinks are used even if
+		the server supports the CIFS Unix Extensions.
  sign           Must use packet signing (helps avoid unwanted data modification
 		by intermediate systems in the route).  Note that signing
 		does not work with lanman or plaintext authentication.
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a5ed10c..8121a86 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -420,6 +420,8 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 		seq_printf(s, ",dynperm");
 	if (m->mnt_sb->s_flags & MS_POSIXACL)
 		seq_printf(s, ",acl");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+		seq_printf(s, ",mfsymlinks");
 
 	seq_printf(s, ",rsize=%d", cifs_sb->rsize);
 	seq_printf(s, ",wsize=%d", cifs_sb->wsize);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 95c2ea6..1a8472d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -100,6 +100,7 @@ struct smb_vol {
 	bool noautotune:1;
 	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
 	bool fsc:1;	/* enable fscache */
+	bool mfsymlinks:1; /* use Minshall+French Symlinks */
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
@@ -1343,6 +1344,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
 		} else if (strnicmp(data, "fsc", 3) == 0) {
 			vol->fsc = true;
+		} else if (strnicmp(data, "mfsymlinks", 10) == 0) {
+			vol->mfsymlinks = true;
 		} else
 			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
 						data);
@@ -2482,6 +2485,14 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 		cFYI(1, "mounting share using direct i/o");
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
 	}
+	if (pvolume_info->mfsymlinks) {
+		if (pvolume_info->sfu_emul) {
+			cERROR(1,  "mount option mfsymlinks ignored if sfu "
+				   "mount option is used");
+		} else {
+			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MF_SYMLINKS;
+		}
+	}
 
 	if ((pvolume_info->cifs_acl) && (pvolume_info->dynperm))
 		cERROR(1, "mount option dynperm ignored if cifsacl "
-- 
1.7.0.4
