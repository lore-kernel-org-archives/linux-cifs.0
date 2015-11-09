From: Steve French <smfrench@gmail.com>
Subject: Samba server bug: CopyChunk from one share to a different share on
 same server
Date: Sun, 8 Nov 2015 20:52:16 -0600
Message-ID: <CAH2r5mvf87XmR_VwiHa6B0LV0WDRb8Ro=cRzQbUDV-9yHAjW3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mohammad Samian Yusuf <s.yusuf91@hotmail.com>,
 David Disseldorp <ddiss@samba.org>
To: samba-technical <samba-technical@lists.samba.org>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

Tried a quick experiment using cloner (David's tool - xfstests/src/cloner)
to copy a file from share1 to share2 on the same target server (using
CopyChunk and SMB3).  Works fine for Windows (tried Windows 8.1) but failed
for Samba 4.2.

This is one of the more important cases to support (copying a file from one
share to another)

Samba returns STATUS_OBJECT_NAME_NOT_FOUND on FSCTL_SRV_COPYCHUNK_WRITE
unless source and target are on the same share.  I didn't try it with
vfs_btrfs (the test system was running ext4, and both exports are on the
same volume on the server).

Was testing the change below where I relax the copy offload check as
follows (to allow cross share copy chunk as Windows does)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 28a77bf..35cf990 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -85,9 +85,14 @@ static long cifs_ioctl_clone(unsigned int xid, struct
file *dst_file,
     src_tcon = tlink_tcon(smb_file_src->tlink);
     target_tcon = tlink_tcon(smb_file_target->tlink);

-    /* check if source and target are on same tree connection */
-    if (src_tcon != target_tcon) {
-        cifs_dbg(VFS, "file copy src and target on different volume\n");
+    /* check source and target on same server (or volume if dup_extents) */
+    if (dup_extents && (src_tcon != target_tcon)) {
+        cifs_dbg(VFS, "source and target of copy not on same share\n");
+        goto out_fput;
+    }
+
+    if (!dup_extents && (src_tcon->ses != target_tcon->ses)) {
+        cifs_dbg(VFS, "source and target of copy not on same server\n");
         goto out_fput;
     }


-- 
Thanks,

Steve
