From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS] various endian fixes to cifs
Date: Sat, 12 Mar 2011 23:05:51 -0600
Message-ID: <AANLkTinKT2123BKR3RypvJ3Up3yvd3gs1J366WJ6C0kJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In checking new smb2 code for missing endian conversions, I noticed
some endian errors had crept in over the last few releases into the
cifs code (symlink, ntlmssp, posix lock, and less problematic warning
in fscache).   Patch follows:

diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
index 29b20ae..dd8584d 100644
--- a/fs/cifs/cache.c
+++ b/fs/cifs/cache.c
@@ -50,7 +50,7 @@ void cifs_fscache_unregister(void)
  */
 struct cifs_server_key {
 	uint16_t	family;		/* address family */
-	uint16_t	port;		/* IP port */
+	__be16		port;		/* IP port */
 	union {
 		struct in_addr	ipv4_addr;
 		struct in6_addr	ipv6_addr;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6488a52..3c72e66 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -725,7 +725,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 		return rc;

 	/* set up echo request */
-	smb->hdr.Tid = cpu_to_le16(0xffff);
+	smb->hdr.Tid = 0xffff;
 	smb->hdr.WordCount = 1;
 	put_unaligned_le16(1, &smb->EchoCount);
 	put_bcc_le(1, &smb->hdr);
@@ -1880,10 +1880,10 @@ CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 					__constant_cpu_to_le16(CIFS_WRLCK))
 				pLockData->fl_type = F_WRLCK;

-			pLockData->fl_start = parm_data->start;
-			pLockData->fl_end = parm_data->start +
-						parm_data->length - 1;
-			pLockData->fl_pid = parm_data->pid;
+			pLockData->fl_start = le64_to_cpu(parm_data->start);
+			pLockData->fl_end = pLockData->fl_start +
+					le64_to_cpu(parm_data->length) - 1;
+			pLockData->fl_pid = le32_to_cpu(parm_data->pid);
 		}
 	}

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 2904baa..3a097b6 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -239,7 +239,7 @@ CIFSQueryMFSymLink(const int xid, struct cifs_tcon *tcon,
 	if (rc != 0)
 		return rc;

-	if (file_info.EndOfFile != CIFS_MF_SYMLINK_FILE_SIZE) {
+	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		CIFSSMBClose(xid, tcon, netfid);
 		/* it's not a symlink */
 		return -EINVAL;
@@ -316,7 +316,7 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 	if (rc != 0)
 		goto out;

-	if (file_info.EndOfFile != CIFS_MF_SYMLINK_FILE_SIZE) {
+	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		CIFSSMBClose(xid, pTcon, netfid);
 		/* it's not a symlink */
 		goto out;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 16831c7..e982890 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -404,8 +404,8 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
 		we must set the MIC field of the AUTHENTICATE_MESSAGE */
 	ses->ntlmssp->server_flags = le32_to_cpu(pblob->NegotiateFlags);
-	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
-	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
+	tioffset = le32_to_cpu(pblob->TargetInfoArray.BufferOffset);
+	tilen = le16_to_cpu(pblob->TargetInfoArray.Length);
 	if (tilen) {
 		ses->auth_key.response = kmalloc(tilen, GFP_KERNEL);
 		if (!ses->auth_key.response) {

-- 
Thanks,

Steve
