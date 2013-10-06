From: Jan Klos <honza.klos@gmail.com>
Subject: cifs: Fix inability to write files >2GB to SMB2/3 shares
Date: Sun, 6 Oct 2013 19:57:46 +0200
Message-ID: <CAMm4rXL3dLeLK0LJpyoxVprr95532mCfQzA4KaUZ09ZM_2gVcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: trivial@kernel.org, linux-cifs@vger.kernel.org, Jan Klos <honza.klos@gmail.com>, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

When connecting to SMB2/3 shares, maximum file size is set to non-LFS
maximum in superblock. This is due to cap_large_files bit being different
for SMB1 and SMB2/3 (where it is just an internal flag that is not
negotiated and the SMB1 one corresponds to multichannel capability) while
capabilities are checked always for the SMB1 bit in cifs_read_super().

The patch fixes this by checking for the correct bit according to the
protocol version.


Signed-off-by: Jan Klos <honza.klos@gmail.com>

---

diff -uprN a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c 2013-10-05 16:18:07.000000000 +0200
+++ b/fs/cifs/cifsfs.c 2013-10-06 16:18:13.488378000 +0200
@@ -120,14 +120,16 @@ cifs_read_super(struct super_block *sb)
 {
  struct inode *inode;
  struct cifs_sb_info *cifs_sb;
+ struct cifs_tcon *tcon;
  int rc = 0;

  cifs_sb = CIFS_SB(sb);
+ tcon = cifs_sb_master_tcon(cifs_sb);

  if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
  sb->s_flags |= MS_POSIXACL;

- if (cifs_sb_master_tcon(cifs_sb)->ses->capabilities & CAP_LARGE_FILES)
+ if (tcon->ses->capabilities & tcon->ses->server->vals->cap_large_files)
  sb->s_maxbytes = MAX_LFS_FILESIZE;
  else
  sb->s_maxbytes = MAX_NON_LFS;
@@ -147,7 +149,7 @@ cifs_read_super(struct super_block *sb)
  goto out_no_root;
  }

- if (cifs_sb_master_tcon(cifs_sb)->nocase)
+ if (tcon->nocase)
  sb->s_d_op = &cifs_ci_dentry_ops;
  else
  sb->s_d_op = &cifs_dentry_ops;
