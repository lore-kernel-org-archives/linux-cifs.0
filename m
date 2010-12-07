From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] cifs: remove CIFSSMBQueryReparseLinkInfo and CONFIG_CIFS_EXPERIMENTAL
Date: Tue,  7 Dec 2010 09:23:54 -0500
Message-ID: <1291731835-1120-4-git-send-email-jlayton@redhat.com>
References: <1291731835-1120-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291731835-1120-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Nothing calls this function. Remove it.

With this, the last user of CONFIG_CIFS_EXPERIMENTAL has been
removed. Also, update the README.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/Kconfig     |   13 ------
 fs/cifs/README      |   12 ------
 fs/cifs/cifsproto.h |    6 ---
 fs/cifs/cifssmb.c   |  104 ---------------------------------------------------
 4 files changed, 0 insertions(+), 135 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index ee45648..27917a5 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -151,16 +151,3 @@ config CIFS_ACL
 	    Allows to fetch CIFS/NTFS ACL from the server.  The DACL blob
 	    is handed over to the application/caller.
 
-config CIFS_EXPERIMENTAL
-	  bool "CIFS Experimental Features (EXPERIMENTAL)"
-	  depends on CIFS && EXPERIMENTAL
-	  help
-	    Enables cifs features under testing. These features are
-	    experimental and currently include DFS support and directory
-	    change notification ie fcntl(F_DNOTIFY), as well as the upcall
-	    mechanism which will be used for Kerberos session negotiation
-	    and uid remapping.  Some of these features also may depend on
-	    setting a value of 1 to the pseudo-file /proc/fs/cifs/Experimental
-	    (which is disabled by default). See the file fs/cifs/README
-	    for more details.  If unsure, say N.
-
diff --git a/fs/cifs/README b/fs/cifs/README
index 46af99a..60a8ba5 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -715,18 +715,6 @@ the start of smb requests and responses can be enabled via:
 
 	echo 1 > /proc/fs/cifs/traceSMB
 
-Two other experimental features are under development. To test these
-requires enabling CONFIG_CIFS_EXPERIMENTAL
-
-	cifsacl support needed to retrieve approximated mode bits based on
-		the contents on the CIFS ACL.
-
-	lease support: cifs will check the oplock state before calling into
-	the vfs to see if we can grant a lease on a file.
-
-	DNOTIFY fcntl: needed for support of directory change 
-			    notification and perhaps later for file leases)
-
 Per share (per client mount) statistics are available in /proc/fs/cifs/Stats
 if the kernel was configured with cifs statistics enabled.  The statistics
 represent the number of successful (ie non-zero return code from the server) 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index cb65499..fe77e69 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -296,12 +296,6 @@ extern int CIFSSMBUnixQuerySymLink(const int xid,
 			struct cifsTconInfo *tcon,
 			const unsigned char *searchName, char **syminfo,
 			const struct nls_table *nls_codepage);
-extern int CIFSSMBQueryReparseLinkInfo(const int xid,
-			struct cifsTconInfo *tcon,
-			const unsigned char *searchName,
-			char *symlinkinfo, const int buflen, __u16 fid,
-			const struct nls_table *nls_codepage);
-
 extern int CIFSSMBOpen(const int xid, struct cifsTconInfo *tcon,
 			const char *fileName, const int disposition,
 			const int access_flags, const int omode,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4df1d10..9af98f6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2474,110 +2474,6 @@ querySymLinkRetry:
 	return rc;
 }
 
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-int
-CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
-			const unsigned char *searchName,
-			char *symlinkinfo, const int buflen, __u16 fid,
-			const struct nls_table *nls_codepage)
-{
-	int rc = 0;
-	int bytes_returned;
-	struct smb_com_transaction_ioctl_req *pSMB;
-	struct smb_com_transaction_ioctl_rsp *pSMBr;
-
-	cFYI(1, "In Windows reparse style QueryLink for path %s", searchName);
-	rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
-		      (void **) &pSMBr);
-	if (rc)
-		return rc;
-
-	pSMB->TotalParameterCount = 0 ;
-	pSMB->TotalDataCount = 0;
-	pSMB->MaxParameterCount = cpu_to_le32(2);
-	/* BB find exact data count max from sess structure BB */
-	pSMB->MaxDataCount = cpu_to_le32((tcon->ses->server->maxBuf -
-					  MAX_CIFS_HDR_SIZE) & 0xFFFFFF00);
-	pSMB->MaxSetupCount = 4;
-	pSMB->Reserved = 0;
-	pSMB->ParameterOffset = 0;
-	pSMB->DataCount = 0;
-	pSMB->DataOffset = 0;
-	pSMB->SetupCount = 4;
-	pSMB->SubCommand = cpu_to_le16(NT_TRANSACT_IOCTL);
-	pSMB->ParameterCount = pSMB->TotalParameterCount;
-	pSMB->FunctionCode = cpu_to_le32(FSCTL_GET_REPARSE_POINT);
-	pSMB->IsFsctl = 1; /* FSCTL */
-	pSMB->IsRootFlag = 0;
-	pSMB->Fid = fid; /* file handle always le */
-	pSMB->ByteCount = 0;
-
-	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
-			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	if (rc) {
-		cFYI(1, "Send error in QueryReparseLinkInfo = %d", rc);
-	} else {		/* decode response */
-		__u32 data_offset = le32_to_cpu(pSMBr->DataOffset);
-		__u32 data_count = le32_to_cpu(pSMBr->DataCount);
-		if ((pSMBr->ByteCount < 2) || (data_offset > 512)) {
-		/* BB also check enough total bytes returned */
-			rc = -EIO;	/* bad smb */
-			goto qreparse_out;
-		}
-		if (data_count && (data_count < 2048)) {
-			char *end_of_smb = 2 /* sizeof byte count */ +
-				pSMBr->ByteCount + (char *)&pSMBr->ByteCount;
-
-			struct reparse_data *reparse_buf =
-						(struct reparse_data *)
-						((char *)&pSMBr->hdr.Protocol
-								 + data_offset);
-			if ((char *)reparse_buf >= end_of_smb) {
-				rc = -EIO;
-				goto qreparse_out;
-			}
-			if ((reparse_buf->LinkNamesBuf +
-				reparse_buf->TargetNameOffset +
-				reparse_buf->TargetNameLen) > end_of_smb) {
-				cFYI(1, "reparse buf beyond SMB");
-				rc = -EIO;
-				goto qreparse_out;
-			}
-
-			if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE) {
-				cifs_from_ucs2(symlinkinfo, (__le16 *)
-						(reparse_buf->LinkNamesBuf +
-						reparse_buf->TargetNameOffset),
-						buflen,
-						reparse_buf->TargetNameLen,
-						nls_codepage, 0);
-			} else { /* ASCII names */
-				strncpy(symlinkinfo,
-					reparse_buf->LinkNamesBuf +
-					reparse_buf->TargetNameOffset,
-					min_t(const int, buflen,
-					   reparse_buf->TargetNameLen));
-			}
-		} else {
-			rc = -EIO;
-			cFYI(1, "Invalid return data count on "
-				 "get reparse info ioctl");
-		}
-		symlinkinfo[buflen] = 0; /* just in case so the caller
-					does not go off the end of the buffer */
-		cFYI(1, "readlink result - %s", symlinkinfo);
-	}
-
-qreparse_out:
-	cifs_buf_release(pSMB);
-
-	/* Note: On -EAGAIN error only caller can retry on handle based calls
-		since file handle passed in no longer valid */
-
-	return rc;
-}
-#endif /* CIFS_EXPERIMENTAL */
-
 #ifdef CONFIG_CIFS_POSIX
 
 /*Convert an Access Control Entry from wire format to local POSIX xattr format*/
-- 
1.7.3.2
