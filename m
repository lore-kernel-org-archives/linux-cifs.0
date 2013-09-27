From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Distinguishing between different types of reparse point symlinks
Date: Fri, 27 Sep 2013 00:58:05 -0500
Message-ID: <CAH2r5mvhJ+pqJTEV4Hc8QNzVu7WWXhdvuGUJiGrxp2C-GAe8OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have to make some minor fixes to the patch below to account for
little endian specific fields in symlink reparse point structure, but
it does fix the problem ("ls -l" to windows 8 or later share which has
multiple types of reparse points in the same directory, not all of
which are NTFS symlinks).

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Thu, 26 Sep 2013 19:49:14 -0500
Subject: [PATCH] [CIFS] do not treat non-symlink reparse points as valid
 symlinks

Windows 8 and later can create NFS symlinks (within reparse points)
which we were assuming were normal NTFS symlinks and thus reporting
corrupt paths for.  Add check for reparse points to make sure that
they really are normal symlinks before we try to parse the pathname.

This fixes commit d244bf2dfbebfded05f494ffd53659fa7b1e32c1
which implemented follow link for non-Unix CIFS mounts

CC: Stable <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifspdu.h  |  2 +-
 fs/cifs/cifssmb.c  |  9 +++++++--
 fs/cifs/smbfsctl.h | 14 ++++++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index a630475..5f295f3 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1491,7 +1491,7 @@ struct file_notify_information {
  __u8  FileName[0];
 } __attribute__((packed));

-struct reparse_data {
+struct reparse_symlink_data {
  __u32 ReparseTag;
  __u16 ReparseDataLength;
  __u16 Reserved;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4baf359..0bf7635 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3088,7 +3088,7 @@ CIFSSMBQuerySymLink(const unsigned int xid,
struct cifs_tcon *tcon,
  bool is_unicode;
  unsigned int sub_len;
  char *sub_start;
- struct reparse_data *reparse_buf;
+ struct reparse_symlink_data *reparse_buf;
  __u32 data_offset, data_count;
  char *end_of_smb;

@@ -3137,12 +3137,17 @@ CIFSSMBQuerySymLink(const unsigned int xid,
struct cifs_tcon *tcon,
  goto qreparse_out;
  }
  end_of_smb = 2 + get_bcc(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;
- reparse_buf = (struct reparse_data *)
+ reparse_buf = (struct reparse_symlink_data *)
  ((char *)&pSMBr->hdr.Protocol + data_offset);
  if ((char *)reparse_buf >= end_of_smb) {
  rc = -EIO;
  goto qreparse_out;
  }
+ if (reparse_buf->ReparseTag != IO_REPARSE_TAG_SYMLINK) {
+ rc = -EOPNOTSUPP;
+ goto qreparse_out;
+ }
+
  if ((reparse_buf->PathBuffer + reparse_buf->PrintNameOffset +
  reparse_buf->PrintNameLength) > end_of_smb) {
  cifs_dbg(FYI, "reparse buf beyond SMB\n");
diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
index d952ee4..3a10e1c 100644
--- a/fs/cifs/smbfsctl.h
+++ b/fs/cifs/smbfsctl.h
@@ -97,9 +97,23 @@
 #define FSCTL_QUERY_NETWORK_INTERFACE_INFO 0x001401FC /* BB add struct */
 #define FSCTL_SRV_READ_HASH          0x001441BB /* BB add struct */

+/* See FSCC 2.1.2.5 */
 #define IO_REPARSE_TAG_MOUNT_POINT   0xA0000003
 #define IO_REPARSE_TAG_HSM           0xC0000004
 #define IO_REPARSE_TAG_SIS           0x80000007
+#define IO_REPARSE_TAG_HSM2          0x80000006
+#define IO_REPARSE_TAG_DRIVER_EXTENDER 0x80000005
+/* Used by the DFS filter. See MS-DFSC */
+#define IO_REPARSE_TAG_DFS           0x8000000A
+/* Used by the DFS filter See MS-DFSC */
+#define IO_REPARSE_TAG_DFSR          0x80000012
+#define IO_REPARSE_TAG_FILTER_MANAGER 0x8000000B
+/* See section MS-FSCC 2.1.2.4 */
+#define IO_REPARSE_TAG_SYMLINK       0xA000000C
+#define IO_REPARSE_TAG_DEDUP         0x80000013
+#define IO_REPARSE_APPXSTREAM     0xC0000014
+/* NFS symlinks, Win 8/SMB3 and later */
+#define IO_REPARSE_TAG_NFS           0xA0000014

 /* fsctl flags */
 /* If Flags is set to this value, the request is an FSCTL not ioctl request */
-- 
1.7.11.7


-- 
Thanks,

Steve
