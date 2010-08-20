From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 15/15] cifs: add "multiuser" mount option
Date: Fri, 20 Aug 2010 15:32:11 -0400
Message-ID: <1282332731-17444-16-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This allows someone to declare a mount as a multiuser mount.

Multiuser mounts also imply "noperm" since we want to allow the server
to handle permission checking. It also (for now) requires Kerberos
authentication. Eventually, we could expand this to other authtypes, but
that requires a scheme to allow per-user credential stashing in some
form.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index da861c1..3ea93f9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -100,6 +100,7 @@ struct smb_vol {
 	bool noautotune:1;
 	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
 	bool fsc:1;	/* enable fscache */
+	bool multiuser:1;
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
@@ -1346,6 +1347,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
 		} else if (strnicmp(data, "fsc", 3) == 0) {
 			vol->fsc = true;
+		} else if (strnicmp(data, "multiuser", 8) == 0) {
+			vol->multiuser = true;
 		} else
 			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
 						data);
@@ -1377,6 +1380,13 @@ cifs_parse_mount_options(char *options, const char *devname,
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
 
@@ -2499,6 +2509,9 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
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
1.7.2.1

