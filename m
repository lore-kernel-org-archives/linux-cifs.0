From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/4] CIFS: Cleanup CIFSSMBOpen
Date: Thu, 16 Jan 2014 15:53:33 +0400
Message-ID: <1389873217-17519-2-git-send-email-piastry@etersoft.ru>
References: <1389873217-17519-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389873217-17519-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Remove indentation, fix comment style, rename camel case
variables in preparation to make it work with cifs_open_parms
structure as a parm.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |    8 +--
 fs/cifs/cifssmb.c   |  150 ++++++++++++++++++++++++++++-----------------------
 2 files changed, 86 insertions(+), 72 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e88c3b1..582ae61 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -363,10 +363,10 @@ extern int CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
 extern int CIFSSMB_set_compression(const unsigned int xid,
 				   struct cifs_tcon *tcon, __u16 fid);
 extern int CIFSSMBOpen(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *fileName, const int disposition,
-			const int access_flags, const int omode,
-			__u16 *netfid, int *pOplock, FILE_ALL_INFO *,
-			const struct nls_table *nls_codepage, int remap);
+		       const char *path, const int disposition,
+		       const int desired_access, const int create_options,
+		       __u16 *netfid, int *oplock, FILE_ALL_INFO *buf,
+		       const struct nls_table *nls, int remap);
 extern int SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *fileName, const int disposition,
 			const int access_flags, const int omode,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d707edb..8e1ebc2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1274,103 +1274,117 @@ OldOpenRetry:
 
 int
 CIFSSMBOpen(const unsigned int xid, struct cifs_tcon *tcon,
-	    const char *fileName, const int openDisposition,
-	    const int access_flags, const int create_options, __u16 *netfid,
-	    int *pOplock, FILE_ALL_INFO *pfile_info,
-	    const struct nls_table *nls_codepage, int remap)
+	    const char *path, const int disposition, const int desired_access,
+	    const int create_options, __u16 *netfid, int *oplock,
+	    FILE_ALL_INFO *buf, const struct nls_table *nls, int remap)
 {
 	int rc = -EACCES;
-	OPEN_REQ *pSMB = NULL;
-	OPEN_RSP *pSMBr = NULL;
+	OPEN_REQ *req = NULL;
+	OPEN_RSP *rsp = NULL;
 	int bytes_returned;
 	int name_len;
 	__u16 count;
 
 openRetry:
-	rc = smb_init(SMB_COM_NT_CREATE_ANDX, 24, tcon, (void **) &pSMB,
-		      (void **) &pSMBr);
+	rc = smb_init(SMB_COM_NT_CREATE_ANDX, 24, tcon, (void **)&req,
+		      (void **)&rsp);
 	if (rc)
 		return rc;
 
-	pSMB->AndXCommand = 0xFF;	/* none */
+	/* no commands go after this */
+	req->AndXCommand = 0xFF;
 
-	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		count = 1;	/* account for one byte pad to word boundary */
-		name_len =
-		    cifsConvertToUTF16((__le16 *) (pSMB->fileName + 1),
-				       fileName, PATH_MAX, nls_codepage, remap);
-		name_len++;	/* trailing null */
+	if (req->hdr.Flags2 & SMBFLG2_UNICODE) {
+		/* account for one byte pad to word boundary */
+		count = 1;
+		name_len = cifsConvertToUTF16((__le16 *)(req->fileName + 1),
+					      path, PATH_MAX, nls, remap);
+		/* trailing null */
+		name_len++;
 		name_len *= 2;
-		pSMB->NameLength = cpu_to_le16(name_len);
-	} else {		/* BB improve check for buffer overruns BB */
-		count = 0;	/* no pad */
-		name_len = strnlen(fileName, PATH_MAX);
-		name_len++;	/* trailing null */
-		pSMB->NameLength = cpu_to_le16(name_len);
-		strncpy(pSMB->fileName, fileName, name_len);
+		req->NameLength = cpu_to_le16(name_len);
+	} else {
+		/* BB improve check for buffer overruns BB */
+		/* no pad */
+		count = 0;
+		name_len = strnlen(path, PATH_MAX);
+		/* trailing null */
+		name_len++;
+		req->NameLength = cpu_to_le16(name_len);
+		strncpy(req->fileName, path, name_len);
 	}
-	if (*pOplock & REQ_OPLOCK)
-		pSMB->OpenFlags = cpu_to_le32(REQ_OPLOCK);
-	else if (*pOplock & REQ_BATCHOPLOCK)
-		pSMB->OpenFlags = cpu_to_le32(REQ_BATCHOPLOCK);
-	pSMB->DesiredAccess = cpu_to_le32(access_flags);
-	pSMB->AllocationSize = 0;
-	/* set file as system file if special file such
-	   as fifo and server expecting SFU style and
-	   no Unix extensions */
+
+	if (*oplock & REQ_OPLOCK)
+		req->OpenFlags = cpu_to_le32(REQ_OPLOCK);
+	else if (*oplock & REQ_BATCHOPLOCK)
+		req->OpenFlags = cpu_to_le32(REQ_BATCHOPLOCK);
+
+	req->DesiredAccess = cpu_to_le32(desired_access);
+	req->AllocationSize = 0;
+
+	/*
+	 * Set file as system file if special file such as fifo and server
+	 * expecting SFU style and no Unix extensions.
+	 */
 	if (create_options & CREATE_OPTION_SPECIAL)
-		pSMB->FileAttributes = cpu_to_le32(ATTR_SYSTEM);
+		req->FileAttributes = cpu_to_le32(ATTR_SYSTEM);
 	else
-		pSMB->FileAttributes = cpu_to_le32(ATTR_NORMAL);
+		req->FileAttributes = cpu_to_le32(ATTR_NORMAL);
 
-	/* XP does not handle ATTR_POSIX_SEMANTICS */
-	/* but it helps speed up case sensitive checks for other
-	servers such as Samba */
+	/*
+	 * XP does not handle ATTR_POSIX_SEMANTICS but it helps speed up case
+	 * sensitive checks for other servers such as Samba.
+	 */
 	if (tcon->ses->capabilities & CAP_UNIX)
-		pSMB->FileAttributes |= cpu_to_le32(ATTR_POSIX_SEMANTICS);
+		req->FileAttributes |= cpu_to_le32(ATTR_POSIX_SEMANTICS);
 
 	if (create_options & CREATE_OPTION_READONLY)
-		pSMB->FileAttributes |= cpu_to_le32(ATTR_READONLY);
+		req->FileAttributes |= cpu_to_le32(ATTR_READONLY);
+
+	req->ShareAccess = cpu_to_le32(FILE_SHARE_ALL);
+	req->CreateDisposition = cpu_to_le32(disposition);
+	req->CreateOptions = cpu_to_le32(create_options & CREATE_OPTIONS_MASK);
 
-	pSMB->ShareAccess = cpu_to_le32(FILE_SHARE_ALL);
-	pSMB->CreateDisposition = cpu_to_le32(openDisposition);
-	pSMB->CreateOptions = cpu_to_le32(create_options & CREATE_OPTIONS_MASK);
 	/* BB Expirement with various impersonation levels and verify */
-	pSMB->ImpersonationLevel = cpu_to_le32(SECURITY_IMPERSONATION);
-	pSMB->SecurityFlags =
-	    SECURITY_CONTEXT_TRACKING | SECURITY_EFFECTIVE_ONLY;
+	req->ImpersonationLevel = cpu_to_le32(SECURITY_IMPERSONATION);
+	req->SecurityFlags = SECURITY_CONTEXT_TRACKING|SECURITY_EFFECTIVE_ONLY;
 
 	count += name_len;
-	inc_rfc1001_len(pSMB, count);
+	inc_rfc1001_len(req, count);
 
-	pSMB->ByteCount = cpu_to_le16(count);
-	/* long_op set to 1 to allow for oplock break timeouts */
-	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
-			(struct smb_hdr *)pSMBr, &bytes_returned, 0);
+	req->ByteCount = cpu_to_le16(count);
+	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *)req,
+			 (struct smb_hdr *)rsp, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
 	if (rc) {
 		cifs_dbg(FYI, "Error in Open = %d\n", rc);
-	} else {
-		*pOplock = pSMBr->OplockLevel; /* 1 byte no need to le_to_cpu */
-		*netfid = pSMBr->Fid;	/* cifs fid stays in le */
-		/* Let caller know file was created so we can set the mode. */
-		/* Do we care about the CreateAction in any other cases? */
-		if (cpu_to_le32(FILE_CREATE) == pSMBr->CreateAction)
-			*pOplock |= CIFS_CREATE_ACTION;
-		if (pfile_info) {
-			memcpy((char *)pfile_info, (char *)&pSMBr->CreationTime,
-				36 /* CreationTime to Attributes */);
-			/* the file_info buf is endian converted by caller */
-			pfile_info->AllocationSize = pSMBr->AllocationSize;
-			pfile_info->EndOfFile = pSMBr->EndOfFile;
-			pfile_info->NumberOfLinks = cpu_to_le32(1);
-			pfile_info->DeletePending = 0;
-		}
+		cifs_buf_release(req);
+		if (rc == -EAGAIN)
+			goto openRetry;
+		return rc;
 	}
 
-	cifs_buf_release(pSMB);
-	if (rc == -EAGAIN)
-		goto openRetry;
+	/* 1 byte no need to le_to_cpu */
+	*oplock = rsp->OplockLevel;
+	/* cifs fid stays in le */
+	*netfid = rsp->Fid;
+
+	/* Let caller know file was created so we can set the mode. */
+	/* Do we care about the CreateAction in any other cases? */
+	if (cpu_to_le32(FILE_CREATE) == rsp->CreateAction)
+		*oplock |= CIFS_CREATE_ACTION;
+
+	if (buf) {
+		/* copy from CreationTime to Attributes */
+		memcpy((char *)buf, (char *)&rsp->CreationTime, 36);
+		/* the file_info buf is endian converted by caller */
+		buf->AllocationSize = rsp->AllocationSize;
+		buf->EndOfFile = rsp->EndOfFile;
+		buf->NumberOfLinks = cpu_to_le32(1);
+		buf->DeletePending = 0;
+	}
+
+	cifs_buf_release(req);
 	return rc;
 }
 
-- 
1.7.10.4
