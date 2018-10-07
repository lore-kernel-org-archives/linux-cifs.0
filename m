From: Rodrigo Freire <rfreire@redhat.com>
Subject: [PATCH v3 2/2] CIFS: Print message when attempting a mount
Date: Sun,  7 Oct 2018 12:21:26 -0300
Message-ID: <ecd759a4ee4ac73b1157702761f6458e18f38906.1538873915.git.rfreire@redhat.com>
References: <cover.1538873915.git.rfreire@redhat.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, piastryyy@gmail.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538873915.git.rfreire@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Currently, no messages are printed when mounting a CIFS filesystem and
no debug configuration is enabled.

However, a CIFS mount information is valuable when troubleshooting
and/or forensic analyzing a system and finding out if was a CIFS
endpoint mount attempted.

Other filesystems such as XFS, EXT* does issue a printk() when mounting
their filesystems.

A terse log message is printed only if cifsFYI is not enabled. Otherwise,
the default full debug message is printed.

In order to not clutter and classify correctly the event messages, these
are logged as KERN_INFO level.

Sample mount operations:

[root@corinthians ~]# mount -o user=administrator //172.25.250.18/c$ /mnt
(non-existent system)

[root@corinthians ~]# mount -o user=administrator //172.25.250.19/c$ /mnt
(Valid system)

Kernel message log for the mount operations:

[  450.464543] CIFS: Attempting to mount //172.25.250.18/c$
[  456.478186] CIFS VFS: Error connecting to socket. Aborting operation.
[  456.478381] CIFS VFS: cifs_mount failed w/return code = -113
[  467.688866] CIFS: Attempting to mount //172.25.250.19/c$

Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
---
 fs/cifs/cifsfs.c    | 7 ++++++-
 fs/cifs/transport.c | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 7065426..ebdf25e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -707,7 +707,12 @@ static int cifs_set_super(struct super_block *sb, void *data)
 	struct cifs_mnt_data mnt_data;
 	struct dentry *root;
 
-	cifs_dbg(FYI, "Devname: %s flags: %d\n", dev_name, flags);
+	/* Prints in Kernel / CIFS log the attempted mount operation *
+ 	 *	IF CIFS_DEBUG && cifs_FYI */
+	if (cifsFYI)
+		cifs_dbg(FYI, "Devname: %s flags: %d\n", dev_name, flags);
+	else
+		cifs_info("Attempting to mount %s\n", dev_name);
 
 	volume_info = cifs_get_volume_info((char *)data, dev_name, is_smb3);
 	if (IS_ERR(volume_info))
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 78f96fa..c2afd6a 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -128,7 +128,7 @@ void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
 		if (cifsFYI & CIFS_TIMER) {
 			pr_debug(" CIFS slow rsp: cmd %d mid %llu",
 			       midEntry->command, midEntry->mid);
-			pr_info(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
+			cifs_info(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
 			       now - midEntry->when_alloc,
 			       now - midEntry->when_sent,
 			       now - midEntry->when_received);
-- 
1.8.3.1
