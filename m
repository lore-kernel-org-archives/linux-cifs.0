From: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6 v3]cifs Fix warnings variables set but not used
Date: Sun, 20 Jun 2010 18:23:21 -0700
Message-ID: <1277083401-6459-1-git-send-email-justinmattock@gmail.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Below is a redu from the original(or similar) fixing
gcc warningds generated while compiling:

  CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function 'CIFSSMBSetFileSize':
fs/cifs/cifssmb.c:4855:8: warning: variable 'data_offset' set but not used
 
  CC [M]  fs/cifs/file.o
fs/cifs/file.c: In function 'cifs_partialpagewrite':
fs/cifs/file.c:1315:23: warning: variable 'pTcon' set but not used

(the warning below is funky i.g. removing pTcon generates the warning below
but if I use the __unused option there is no warning at all).

 CC [M]  fs/cifs/file.o
fs/cifs/file.c: In function 'cifs_partialpagewrite':
fs/cifs/file.c:1314:23: warning: variable 'cifs_sb' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 fs/cifs/cifssmb.c |    3 ---
 fs/cifs/file.c    |    4 ----
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c65c341..4653aaa 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4852,7 +4852,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
 		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
-	char *data_offset;
 	struct file_end_of_file_info *parm_data;
 	int rc = 0;
 	__u16 params, param_offset, offset, byte_count, count;
@@ -4876,8 +4875,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
 	param_offset = offsetof(struct smb_com_transaction2_sfi_req, Fid) - 4;
 	offset = param_offset + params;
 
-	data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
-
 	count = sizeof(struct file_end_of_file_info);
 	pSMB->MaxParameterCount = cpu_to_le16(2);
 	/* BB find exact max SMB PDU from sess structure BB */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 75541af..661f868 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1311,8 +1311,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	char *write_data;
 	int rc = -EFAULT;
 	int bytes_written = 0;
-	struct cifs_sb_info *cifs_sb;
-	struct cifsTconInfo *pTcon;
 	struct inode *inode;
 	struct cifsFileInfo *open_file;
 
@@ -1320,8 +1318,6 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 		return -EFAULT;
 
 	inode = page->mapping->host;
-	cifs_sb = CIFS_SB(inode->i_sb);
-	pTcon = cifs_sb->tcon;
 
 	offset += (loff_t)from;
 	write_data = kmap(page);
-- 
1.7.1.rc1.21.gf3bd6
