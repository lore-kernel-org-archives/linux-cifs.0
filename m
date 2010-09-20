From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/15] cifs: add "multiuser" mount option
Date: Mon, 20 Sep 2010 16:01:43 -0700
Message-ID: <1285023704-2159-15-git-send-email-jlayton@redhat.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285023704-2159-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This allows someone to declare a mount as a multiuser mount.

Multiuser mounts also imply "noperm" since we want to allow the server
to handle permission checking. It also (for now) requires Kerberos
authentication. Eventually, we could expand this to other authtypes, but
that requires a scheme to allow per-user credential stashing in some
form.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3e2b069..c980003 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -101,6 +101,7 @@ struct smb_vol {
 	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
 	bool fsc:1;	/* enable fscache */
 	bool mfsymlinks:1; /* use Minshall+French Symlinks */
+	bool multiuser:1;
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
@@ -1349,6 +1350,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 			vol->fsc = true;
 		} else if (strnicmp(data, "mfsymlinks", 10) == 0) {
 			vol->mfsymlinks = true;
+		} else if (strnicmp(data, "multiuser", 8) == 0) {
+			vol->multiuser = true;
 		} else
 			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
 						data);
@@ -1380,6 +1383,13 @@ cifs_parse_mount_options(char *options, const char *devname,
 			return 1;
 		}
 	}
+
+	if (vol->multiuser && !(vol->secFlg & CIFSSEC_MAY_KRB5)) {
+		cERROR(1, "Multiuser mounts currently require krb5 "
+			  "authentication!");
+		return 1;
+	}
+
 	if (vol->UNCip == NULL)
 		vol->UNCip = &vol->UNC[2];
 
@@ -2585,6 +2595,9 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
 	if (pvolume_info->fsc)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_FSCACHE;
+	if (pvolume_info->multiuser)
+		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
+					    CIFS_MOUNT_NO_PERM);
 	if (pvolume_info->direct_io) {
 		cFYI(1, "mounting share using direct i/o");
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
-- 
1.7.2.3
