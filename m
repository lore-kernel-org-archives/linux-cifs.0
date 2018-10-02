From: Rodrigo Freire <rfreire@redhat.com>
Subject: [PATCH] CIFS: Print message when attempting mount
Date: Mon,  1 Oct 2018 21:58:46 -0300
Message-ID: <463f424e3d4724a4ab7b84c395e7b0cf3068e31f.1538441538.git.rfreire@redhat.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

By default, no messages are printed when mounting a CIFS filesystem.
This information is valuable when troubleshooting and/or forensic
analyzing a system and finding out if was a CIFS endpoint mount
attempted.
Other filesystems such as XFS, EXT* does issue a printk() when mounting
their filesystems.

Sample output:

[root@ll-rhel7 ~]# mount -o user=administrator //172.25.250.18/c$ /mnt
(non-existent system)

[root@ll-rhel7 ~]# mount -o user=administrator //172.25.250.19/c$ /mnt
(Valid system)

Kernel message log:

[  450.464543] CIFS VFS: Attempting to mount //172.25.250.18/c$
[  456.478186] CIFS VFS: Error connecting to socket. Aborting operation.
[  456.478381] CIFS VFS: cifs_mount failed w/return code = -113
[  467.688866] CIFS VFS: Attempting to mount //172.25.250.19/c$

Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
---
 fs/cifs/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 7065426..3f5a31e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -707,6 +707,7 @@ static int cifs_set_super(struct super_block *sb, void *data)
 	struct cifs_mnt_data mnt_data;
 	struct dentry *root;
 
+	cifs_dbg(VFS, "Attempting to mount %s\n", dev_name);
 	cifs_dbg(FYI, "Devname: %s flags: %d\n", dev_name, flags);
 
 	volume_info = cifs_get_volume_info((char *)data, dev_name, is_smb3);
-- 
1.8.3.1
