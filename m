From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] consistently use smb_buf_length as be32 for cifs (try 2)
Date: Thu, 17 Mar 2011 10:53:19 -0500
Message-ID: <AANLkTin8sS=mNszHtEO2vG9yOs9pFjahgUpq9ekTqK5P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

    [CIFS] consistently use smb_buf_length as be32 for cifs (try 2)

        There is one big endian field in the cifs protocol, the RFC1001
        length, which cifs code (unlike in the smb2 code) had been handling as
        u32 until the last possible moment, when it was converted to be32 (its
        native form) before sending on the wire.   To remove the last sparse
        endian warning, and to make this consistent with the smb2
        implementation  (which always treats the fields in their
        native size and endianness), convert all uses of smb_buf_length to
        be32.

        This version incorporates Christoph's comment about
        using be32_add_cpu

    CC: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
    Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5e71531..5bb4b09 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -59,7 +59,7 @@ static int cifs_calculate_signature(const struct
smb_hdr *cifs_pdu,
 		server->session_key.response, server->session_key.len);

 	crypto_shash_update(&server->secmech.sdescmd5->shash,
-		cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
+		cifs_pdu->Protocol, be32_to_cpu(cifs_pdu->smb_buf_length));

 	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index b5c8cc5..eac95e2 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -397,9 +397,9 @@
 #define GETU32(var)  (*((__u32 *)var))	/* BB check for endian issues */

 struct smb_hdr {
-	__u32 smb_buf_length;	/* big endian on wire *//* BB length is only two
-		or three bytes - with one or two byte type preceding it that are
-		zero - we could mask the type byte off just in case BB */
+	__be32 smb_buf_length;	/* BB length is only two (rarely three) bytes,
+		with one or two byte "type" preceding it that will be
+		zero - we could mask the type byte off */
 	__u8 Protocol[4];
 	__u8 Command;
 	union {
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 3c72e66..cc3e04f 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -357,6 +357,13 @@ vt2_err:
 	return -EINVAL;
 }

+static void inc_rfc1001_len(void *pSMB, int count)
+{
+	struct smb_hdr *psmb = (struct smb_hdr *)pSMB;
+
+	be32_add_cpu(&pSMB->hdr.smb_buf_length, count);
+}
+
 int
 CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 {
@@ -409,7 +416,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 		count += strlen(protocols[i].name) + 1;
 		/* null at end of source and target buffers anyway */
 	}
-	pSMB->hdr.smb_buf_length += count;
+	inc_rfc1001_len(pSMB, count);
 	pSMB->ByteCount = cpu_to_le16(count);

 	rc = SendReceive(xid, ses, (struct smb_hdr *) pSMB,
@@ -730,7 +737,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	put_unaligned_le16(1, &smb->EchoCount);
 	put_bcc_le(1, &smb->hdr);
 	smb->Data[0] = 'a';
-	smb->hdr.smb_buf_length += 3;
+	inc_rfc1001_len(smb, 3);

 	rc = cifs_call_async(server, (struct smb_hdr *)smb,
 				cifs_echo_callback, server);
@@ -848,7 +855,7 @@ PsxDelete:
 	pSMB->TotalParameterCount = pSMB->ParameterCount;
 	pSMB->InformationLevel = cpu_to_le16(SMB_POSIX_UNLINK);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -894,7 +901,7 @@ DelFileRetry:
 	pSMB->SearchAttributes =
 	    cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM);
 	pSMB->BufferFormat = 0x04;
-	pSMB->hdr.smb_buf_length += name_len + 1;
+	inc_rfc1001_len(pSMB, name_len + 1);
 	pSMB->ByteCount = cpu_to_le16(name_len + 1);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -938,7 +945,7 @@ RmDirRetry:
 	}

 	pSMB->BufferFormat = 0x04;
-	pSMB->hdr.smb_buf_length += name_len + 1;
+	inc_rfc1001_len(pSMB, name_len + 1);
 	pSMB->ByteCount = cpu_to_le16(name_len + 1);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -981,7 +988,7 @@ MkDirRetry:
 	}

 	pSMB->BufferFormat = 0x04;
-	pSMB->hdr.smb_buf_length += name_len + 1;
+	inc_rfc1001_len(pSMB, name_len + 1);
 	pSMB->ByteCount = cpu_to_le16(name_len + 1);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -1059,7 +1066,7 @@ PsxCreat:
 	pSMB->TotalParameterCount = pSMB->ParameterCount;
 	pSMB->InformationLevel = cpu_to_le16(SMB_POSIX_OPEN);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -1224,7 +1231,7 @@ OldOpenRetry:
 	pSMB->Sattr = cpu_to_le16(ATTR_HIDDEN | ATTR_SYSTEM | ATTR_DIRECTORY);
 	pSMB->OpenFunction = cpu_to_le16(convert_disposition(openDisposition));
 	count += name_len;
-	pSMB->hdr.smb_buf_length += count;
+	inc_rfc1001_len(pSMB, count);

 	pSMB->ByteCount = cpu_to_le16(count);
 	/* long_op set to 1 to allow for oplock break timeouts */
@@ -1337,7 +1344,7 @@ openRetry:
 	    SECURITY_CONTEXT_TRACKING | SECURITY_EFFECTIVE_ONLY;

 	count += name_len;
-	pSMB->hdr.smb_buf_length += count;
+	inc_rfc1001_len(pSMB, count);

 	pSMB->ByteCount = cpu_to_le16(count);
 	/* long_op set to 1 to allow for oplock break timeouts */
@@ -1422,7 +1429,7 @@ CIFSSMBRead(const int xid, struct cifs_tcon
*tcon, const int netfid,
 	}

 	iov[0].iov_base = (char *)pSMB;
-	iov[0].iov_len = pSMB->hdr.smb_buf_length + 4;
+	iov[0].iov_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4;
 	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs */,
 			 &resp_buf_type, CIFS_LOG_ERROR);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
@@ -1556,7 +1563,7 @@ CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,

 	pSMB->DataLengthLow = cpu_to_le16(bytes_sent & 0xFFFF);
 	pSMB->DataLengthHigh = cpu_to_le16(bytes_sent >> 16);
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);

 	if (wct == 14)
 		pSMB->ByteCount = cpu_to_le16(byte_count);
@@ -1640,11 +1647,12 @@ CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,

 	pSMB->DataLengthLow = cpu_to_le16(count & 0xFFFF);
 	pSMB->DataLengthHigh = cpu_to_le16(count >> 16);
-	smb_hdr_len = pSMB->hdr.smb_buf_length + 1; /* hdr + 1 byte pad */
+	/* header + 1 byte pad */
+	smb_hdr_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 1;
 	if (wct == 14)
-		pSMB->hdr.smb_buf_length += count+1;
+		inc_rfc1001_len(pSMB, count + 1);
 	else /* wct == 12 */
-		pSMB->hdr.smb_buf_length += count+5; /* smb data starts later */
+		inc_rfc1001_len(pSMB, count + 5); /* smb data starts later */
 	if (wct == 14)
 		pSMB->ByteCount = cpu_to_le16(count + 1);
 	else /* wct == 12 */ /* bigger pad, smaller smb hdr, keep offset ok */ {
@@ -1744,7 +1752,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 		/* oplock break */
 		count = 0;
 	}
-	pSMB->hdr.smb_buf_length += count;
+	inc_rfc1001_len(pSMB, count);
 	pSMB->ByteCount = cpu_to_le16(count);

 	if (waitFlag) {
@@ -1835,14 +1843,14 @@ CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 	pSMB->Fid = smb_file_id;
 	pSMB->InformationLevel = cpu_to_le16(SMB_SET_POSIX_LOCK);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	if (waitFlag) {
 		rc = SendReceiveBlockingLock(xid, tcon, (struct smb_hdr *) pSMB,
 			(struct smb_hdr *) pSMBr, &bytes_returned);
 	} else {
 		iov[0].iov_base = (char *)pSMB;
-		iov[0].iov_len = pSMB->hdr.smb_buf_length + 4;
+		iov[0].iov_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4;
 		rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs */,
 				&resp_buf_type, timeout);
 		pSMB = NULL; /* request buf already freed by SendReceive2. Do
@@ -2008,7 +2016,7 @@ renameRetry:
 	}

 	count = 1 /* 1st signature byte */  + name_len + name_len2;
-	pSMB->hdr.smb_buf_length += count;
+	inc_rfc1001_len(pSMB, count);
 	pSMB->ByteCount = cpu_to_le16(count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -2088,7 +2096,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct
cifs_tcon *pTcon,
 	pSMB->InformationLevel =
 		cpu_to_le16(SMB_SET_FILE_RENAME_INFORMATION);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, pTcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -2155,7 +2163,7 @@ copyRetry:
 	}

 	count = 1 /* 1st signature byte */  + name_len + name_len2;
-	pSMB->hdr.smb_buf_length += count;
+	inc_rfc1001_len(pSMB, count);
 	pSMB->ByteCount = cpu_to_le16(count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -2245,7 +2253,7 @@ createSymLinkRetry:
 	pSMB->DataOffset = cpu_to_le16(offset);
 	pSMB->InformationLevel = cpu_to_le16(SMB_SET_FILE_UNIX_LINK);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -2331,7 +2339,7 @@ createHardLinkRetry:
 	pSMB->DataOffset = cpu_to_le16(offset);
 	pSMB->InformationLevel = cpu_to_le16(SMB_SET_FILE_UNIX_HLINK);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -2402,7 +2410,7 @@ winCreateHardLinkRetry:
 	}

 	count = 1 /* string type byte */  + name_len + name_len2;
-	pSMB->hdr.smb_buf_length += count;
+	inc_rfc1001_len(pSMB, count);
 	pSMB->ByteCount = cpu_to_le16(count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -2473,7 +2481,7 @@ querySymLinkRetry:
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_UNIX_LINK);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -2820,7 +2828,7 @@ queryAclRetry:
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_POSIX_ACL);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -2914,7 +2922,7 @@ setAclRetry:
 	pSMB->ParameterCount = cpu_to_le16(params);
 	pSMB->TotalParameterCount = pSMB->ParameterCount;
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -2972,7 +2980,7 @@ GetExtAttrRetry:
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_ATTR_FLAGS);
 	pSMB->Pad = 0;
 	pSMB->Fid = netfid;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->t2.ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -3130,9 +3138,9 @@ CIFSSMBGetCIFSACL(const int xid, struct
cifs_tcon *tcon, __u16 fid,
 	pSMB->AclFlags = cpu_to_le32(CIFS_ACL_OWNER | CIFS_ACL_GROUP |
 				     CIFS_ACL_DACL);
 	pSMB->ByteCount = cpu_to_le16(11); /* 3 bytes pad + 8 bytes parm */
-	pSMB->hdr.smb_buf_length += 11;
+	inc_rfc1001_len(pSMB, 11);
 	iov[0].iov_base = (char *)pSMB;
-	iov[0].iov_len = pSMB->hdr.smb_buf_length + 4;
+	iov[0].iov_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4;

 	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovec */, &buf_type,
 			 0);
@@ -3241,10 +3249,9 @@ setCifsAclRetry:
 		memcpy((char *) &pSMBr->hdr.Protocol + data_offset,
 			(char *) pntsd,
 			acllen);
-		pSMB->hdr.smb_buf_length += (byte_count + data_count);
-
+		inc_rfc1001_len(pSMB, byte_count + data_count);
 	} else
-		pSMB->hdr.smb_buf_length += byte_count;
+		inc_rfc1001_len(pSMB, byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -3295,7 +3302,7 @@ QInfRetry:
 	}
 	pSMB->BufferFormat = 0x04;
 	name_len++; /* account for buffer type byte */
-	pSMB->hdr.smb_buf_length += (__u16) name_len;
+	inc_rfc1001_len(pSMB, (__u16)name_len);
 	pSMB->ByteCount = cpu_to_le16(name_len);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -3370,7 +3377,7 @@ QFileInfoRetry:
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_ALL_INFO);
 	pSMB->Pad = 0;
 	pSMB->Fid = netfid;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -3457,7 +3464,7 @@ QPathInfoRetry:
 	else
 		pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_ALL_INFO);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -3538,7 +3545,7 @@ UnixQFileInfoRetry:
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_UNIX_BASIC);
 	pSMB->Pad = 0;
 	pSMB->Fid = netfid;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -3623,7 +3630,7 @@ UnixQPathInfoRetry:
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_UNIX_BASIC);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -3737,7 +3744,7 @@ findFirstRetry:

 	/* BB what should we set StorageType to? Does it matter? BB */
 	pSMB->SearchStorageType = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -3866,7 +3873,7 @@ int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
 	byte_count = params + 1 /* pad */ ;
 	pSMB->TotalParameterCount = cpu_to_le16(params);
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4028,7 +4035,7 @@ GetInodeNumberRetry:
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_INTERNAL_INFO);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4252,7 +4259,7 @@ getDFSRetry:
 	pSMB->ParameterCount = cpu_to_le16(params);
 	pSMB->TotalParameterCount = pSMB->ParameterCount;
 	pSMB->MaxReferralLevel = cpu_to_le16(3);
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, ses, (struct smb_hdr *) pSMB,
@@ -4326,7 +4333,7 @@ oldQFSInfoRetry:
 	pSMB->Reserved3 = 0;
 	pSMB->SubCommand = cpu_to_le16(TRANS2_QUERY_FS_INFORMATION);
 	pSMB->InformationLevel = cpu_to_le16(SMB_INFO_ALLOCATION);
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4405,7 +4412,7 @@ QFSInfoRetry:
 	pSMB->Reserved3 = 0;
 	pSMB->SubCommand = cpu_to_le16(TRANS2_QUERY_FS_INFORMATION);
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FS_SIZE_INFO);
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4485,7 +4492,7 @@ QFSAttributeRetry:
 	pSMB->Reserved3 = 0;
 	pSMB->SubCommand = cpu_to_le16(TRANS2_QUERY_FS_INFORMATION);
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FS_ATTRIBUTE_INFO);
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4556,7 +4563,7 @@ QFSDeviceRetry:
 	pSMB->Reserved3 = 0;
 	pSMB->SubCommand = cpu_to_le16(TRANS2_QUERY_FS_INFORMATION);
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FS_DEVICE_INFO);
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4625,7 +4632,7 @@ QFSUnixRetry:
 	pSMB->Reserved3 = 0;
 	pSMB->SubCommand = cpu_to_le16(TRANS2_QUERY_FS_INFORMATION);
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_CIFS_UNIX_INFO);
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4708,7 +4715,7 @@ SETFSUnixRetry:
 	pSMB->ClientUnixMinor = cpu_to_le16(CIFS_UNIX_MINOR_VERSION);
 	pSMB->ClientUnixCap = cpu_to_le64(cap);

-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4770,7 +4777,7 @@ QFSPosixRetry:
 	pSMB->Reserved3 = 0;
 	pSMB->SubCommand = cpu_to_le16(TRANS2_QUERY_FS_INFORMATION);
 	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_POSIX_FS_INFO);
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4896,7 +4903,7 @@ SetEOFRetry:
 	pSMB->ParameterCount = cpu_to_le16(params);
 	pSMB->TotalParameterCount = pSMB->ParameterCount;
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	parm_data->FileSize = cpu_to_le64(size);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -4975,7 +4982,7 @@ CIFSSMBSetFileSize(const int xid, struct
cifs_tcon *tcon, __u64 size,
 				cpu_to_le16(SMB_SET_FILE_END_OF_FILE_INFO);
 	}
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
 	if (rc) {
@@ -5043,7 +5050,7 @@ CIFSSMBSetFileInfo(const int xid, struct cifs_tcon *tcon,
 	else
 		pSMB->InformationLevel = cpu_to_le16(SMB_SET_FILE_BASIC_INFO);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
@@ -5102,7 +5109,7 @@ CIFSSMBSetFileDisposition(const int xid, struct
cifs_tcon *tcon,
 	pSMB->Fid = fid;
 	pSMB->InformationLevel = cpu_to_le16(SMB_SET_FILE_DISPOSITION_INFO);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	*data_offset = delete_file ? 1 : 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
@@ -5175,7 +5182,7 @@ SetTimesRetry:
 	else
 		pSMB->InformationLevel = cpu_to_le16(SMB_SET_FILE_BASIC_INFO);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -5227,7 +5234,7 @@ SetAttrLgcyRetry:
 	}
 	pSMB->attr = cpu_to_le16(dos_attrs);
 	pSMB->BufferFormat = 0x04;
-	pSMB->hdr.smb_buf_length += name_len + 1;
+	inc_rfc1001_len(pSMB, name_len + 1);
 	pSMB->ByteCount = cpu_to_le16(name_len + 1);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -5332,7 +5339,7 @@ CIFSSMBUnixSetFileInfo(const int xid, struct
cifs_tcon *tcon,
 	pSMB->Fid = fid;
 	pSMB->InformationLevel = cpu_to_le16(SMB_SET_FILE_UNIX_BASIC);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	cifs_fill_unix_set_info(data_offset, args);
@@ -5408,7 +5415,7 @@ setPermsRetry:
 	pSMB->TotalDataCount = pSMB->DataCount;
 	pSMB->InformationLevel = cpu_to_le16(SMB_SET_FILE_UNIX_BASIC);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);

 	cifs_fill_unix_set_info(data_offset, args);

@@ -5493,7 +5500,7 @@ QAllEAsRetry:
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
 	pSMB->InformationLevel = cpu_to_le16(SMB_INFO_QUERY_ALL_EAS);
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);

 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
@@ -5706,7 +5713,7 @@ SetEARetry:
 	pSMB->ParameterCount = cpu_to_le16(params);
 	pSMB->TotalParameterCount = pSMB->ParameterCount;
 	pSMB->Reserved4 = 0;
-	pSMB->hdr.smb_buf_length += byte_count;
+	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c19f00a..19d7898 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -320,12 +320,12 @@ static int coalesce_t2(struct smb_hdr *psecond,
struct smb_hdr *pTargetSMB)
 	byte_count += total_in_buf2;
 	put_bcc_le(byte_count, pTargetSMB);

-	byte_count = pTargetSMB->smb_buf_length;
+	byte_count = be32_to_cpu(pTargetSMB->smb_buf_length);
 	byte_count += total_in_buf2;

 	/* BB also add check that we are not beyond maximum buffer size */

-	pTargetSMB->smb_buf_length = byte_count;
+	pTargetSMB->smb_buf_length = cpu_to_be32(byte_count);

 	if (remaining == total_in_buf2) {
 		cFYI(1, "found the last secondary response");
@@ -490,8 +490,7 @@ incomplete_rcv:
 		/* Note that FC 1001 length is big endian on the wire,
 		but we convert it here so it is always manipulated
 		as host byte order */
-		pdu_length = be32_to_cpu((__force __be32)smb_buffer->smb_buf_length);
-		smb_buffer->smb_buf_length = pdu_length;
+		pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);

 		cFYI(1, "rfc1002 length 0x%x", pdu_length+4);

@@ -2299,7 +2298,7 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 		smb_buf = (struct smb_hdr *)ses_init_buf;

 		/* sizeof RFC1002_SESSION_REQUEST with no scope */
-		smb_buf->smb_buf_length = 0x81000044;
+		smb_buf->smb_buf_length = cpu_to_be32(0x81000044);
 		rc = smb_send(server, smb_buf, 0x44);
 		kfree(ses_init_buf);
 		/*
@@ -3097,7 +3096,8 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	bcc_ptr += strlen("?????");
 	bcc_ptr += 1;
 	count = bcc_ptr - &pSMB->Password[0];
-	pSMB->hdr.smb_buf_length += count;
+	pSMB->hdr.smb_buf_length = cpu_to_be32(be32_to_cpu(
+					pSMB->hdr.smb_buf_length) + count);
 	pSMB->ByteCount = cpu_to_le16(count);

 	rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1640a6e..6863acf 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -304,12 +304,10 @@ header_assemble(struct smb_hdr *buffer, char
smb_command /* command */ ,

 	memset(temp, 0, 256); /* bigger than MAX_CIFS_HDR_SIZE */

-	buffer->smb_buf_length =
+	buffer->smb_buf_length = cpu_to_be32(
 	    (2 * word_count) + sizeof(struct smb_hdr) -
 	    4 /*  RFC 1001 length field does not count */  +
-	    2 /* for bcc field itself */ ;
-	/* Note that this is the only network field that has to be converted
-	   to big endian and it is done just before we send it */
+	    2 /* for bcc field itself */) ;

 	buffer->Protocol[0] = 0xFF;
 	buffer->Protocol[1] = 'S';
@@ -424,7 +422,7 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
 int
 checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 {
-	__u32 len = smb->smb_buf_length;
+	__u32 len = be32_to_cpu(smb->smb_buf_length);
 	__u32 clc_len;  /* calculated length */
 	cFYI(0, "checkSMB Length: 0x%x, smb_buf_length: 0x%x", length, len);

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index e982890..6b140e1 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -634,7 +634,7 @@ ssetup_ntlmssp_authenticate:
 	and rest of bcc area. This allows us to avoid
 	a large buffer 17K allocation */
 	iov[0].iov_base = (char *)pSMB;
-	iov[0].iov_len = smb_buf->smb_buf_length + 4;
+	iov[0].iov_len = be32_to_cpu(smb_buf->smb_buf_length) + 4;

 	/* setting this here allows the code at the end of the function
 	   to free the request buffer if there's an error */
@@ -872,7 +872,8 @@ ssetup_ntlmssp_authenticate:
 	iov[2].iov_len = (long) bcc_ptr - (long) str_area;

 	count = iov[1].iov_len + iov[2].iov_len;
-	smb_buf->smb_buf_length += count;
+	smb_buf->smb_buf_length =
+		cpu_to_be32(be32_to_cpu(smb_buf->smb_buf_length) + count);

 	put_bcc_le(count, smb_buf);

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 1a2930d..fd43ac6 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -129,7 +129,7 @@ smb_sendv(struct TCP_Server_Info *server, struct
kvec *iov, int n_vec)
 	unsigned int len = iov[0].iov_len;
 	unsigned int total_len;
 	int first_vec = 0;
-	unsigned int smb_buf_length = smb_buffer->smb_buf_length;
+	unsigned int smb_buf_length = be32_to_cpu(smb_buffer->smb_buf_length);
 	struct socket *ssocket = server->ssocket;

 	if (ssocket == NULL)
@@ -144,17 +144,10 @@ smb_sendv(struct TCP_Server_Info *server, struct
kvec *iov, int n_vec)
 	else
 		smb_msg.msg_flags = MSG_NOSIGNAL;

-	/* smb header is converted in header_assemble. bcc and rest of SMB word
-	   area, and byte area if necessary, is converted to littleendian in
-	   cifssmb.c and RFC1001 len is converted to bigendian in smb_send
-	   Flags2 is converted in SendReceive */
-
-
 	total_len = 0;
 	for (i = 0; i < n_vec; i++)
 		total_len += iov[i].iov_len;

-	smb_buffer->smb_buf_length = cpu_to_be32(smb_buffer->smb_buf_length);
 	cFYI(1, "Sending smb:  total_len %d", total_len);
 	dump_smb(smb_buffer, len);

@@ -243,7 +236,7 @@ smb_sendv(struct TCP_Server_Info *server, struct
kvec *iov, int n_vec)

 	/* Don't want to modify the buffer as a
 	   side effect of this call. */
-	smb_buffer->smb_buf_length = smb_buf_length;
+	smb_buffer->smb_buf_length = cpu_to_be32(smb_buf_length);

 	return rc;
 }
@@ -402,7 +395,7 @@ cifs_call_async(struct TCP_Server_Info *server,
struct smb_hdr *in_buf,
 #ifdef CONFIG_CIFS_STATS2
 	atomic_inc(&server->inSend);
 #endif
-	rc = smb_send(server, in_buf, in_buf->smb_buf_length);
+	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 #ifdef CONFIG_CIFS_STATS2
 	atomic_dec(&server->inSend);
 	mid->when_sent = jiffies;
@@ -437,7 +430,7 @@ SendReceiveNoRsp(const unsigned int xid, struct
cifs_ses *ses,
 	int resp_buf_type;

 	iov[0].iov_base = (char *)in_buf;
-	iov[0].iov_len = in_buf->smb_buf_length + 4;
+	iov[0].iov_len = be32_to_cpu(in_buf->smb_buf_length) + 4;
 	flags |= CIFS_NO_RESP;
 	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags);
 	cFYI(DBG2, "SendRcvNoRsp flags %d rc %d", flags, rc);
@@ -503,7 +496,7 @@ send_nt_cancel(struct TCP_Server_Info *server,
struct smb_hdr *in_buf,
 	int rc = 0;

 	/* -4 for RFC1001 length and +2 for BCC field */
-	in_buf->smb_buf_length = sizeof(struct smb_hdr) - 4  + 2;
+	in_buf->smb_buf_length = cpu_to_be32(sizeof(struct smb_hdr) - 4  + 2);
 	in_buf->Command = SMB_COM_NT_CANCEL;
 	in_buf->WordCount = 0;
 	put_bcc_le(0, in_buf);
@@ -514,7 +507,7 @@ send_nt_cancel(struct TCP_Server_Info *server,
struct smb_hdr *in_buf,
 		mutex_unlock(&server->srv_mutex);
 		return rc;
 	}
-	rc = smb_send(server, in_buf, in_buf->smb_buf_length);
+	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	mutex_unlock(&server->srv_mutex);

 	cFYI(1, "issued NT_CANCEL for mid %u, rc = %d",
@@ -627,7 +620,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		return rc;
 	}

-	receive_len = midQ->resp_buf->smb_buf_length;
+	receive_len = be32_to_cpu(midQ->resp_buf->smb_buf_length);

 	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
 		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
@@ -713,9 +706,10 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	   to the same server. We may make this configurable later or
 	   use ses->maxReq */

-	if (in_buf->smb_buf_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+	if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSize +
+			MAX_CIFS_HDR_SIZE - 4) {
 		cERROR(1, "Illegal length, greater than maximum frame, %d",
-			   in_buf->smb_buf_length);
+			   be32_to_cpu(in_buf->smb_buf_length));
 		return -EIO;
 	}

@@ -748,7 +742,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 #ifdef CONFIG_CIFS_STATS2
 	atomic_inc(&ses->server->inSend);
 #endif
-	rc = smb_send(ses->server, in_buf, in_buf->smb_buf_length);
+	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 #ifdef CONFIG_CIFS_STATS2
 	atomic_dec(&ses->server->inSend);
 	midQ->when_sent = jiffies;
@@ -783,7 +777,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		return rc;
 	}

-	receive_len = midQ->resp_buf->smb_buf_length;
+	receive_len = be32_to_cpu(midQ->resp_buf->smb_buf_length);

 	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
 		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
@@ -796,7 +790,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,

 	if (midQ->resp_buf && out_buf
 	    && (midQ->midState == MID_RESPONSE_RECEIVED)) {
-		out_buf->smb_buf_length = receive_len;
+		out_buf->smb_buf_length = cpu_to_be32(receive_len);
 		memcpy((char *)out_buf + 4,
 		       (char *)midQ->resp_buf + 4,
 		       receive_len);
@@ -815,7 +809,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			}
 		}

-		*pbytes_returned = out_buf->smb_buf_length;
+		*pbytes_returned = be32_to_cpu(out_buf->smb_buf_length);

 		/* BB special case reconnect tid and uid here? */
 		rc = map_smb_to_linux_error(out_buf, 0 /* no log */ );
@@ -892,9 +886,10 @@ SendReceiveBlockingLock(const unsigned int xid,
struct cifs_tcon *tcon,
 	   to the same server. We may make this configurable later or
 	   use ses->maxReq */

-	if (in_buf->smb_buf_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
+	if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSize +
+			MAX_CIFS_HDR_SIZE - 4) {
 		cERROR(1, "Illegal length, greater than maximum frame, %d",
-			   in_buf->smb_buf_length);
+			   be32_to_cpu(in_buf->smb_buf_length));
 		return -EIO;
 	}

@@ -925,7 +920,7 @@ SendReceiveBlockingLock(const unsigned int xid,
struct cifs_tcon *tcon,
 #ifdef CONFIG_CIFS_STATS2
 	atomic_inc(&ses->server->inSend);
 #endif
-	rc = smb_send(ses->server, in_buf, in_buf->smb_buf_length);
+	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 #ifdef CONFIG_CIFS_STATS2
 	atomic_dec(&ses->server->inSend);
 	midQ->when_sent = jiffies;
@@ -992,7 +987,7 @@ SendReceiveBlockingLock(const unsigned int xid,
struct cifs_tcon *tcon,
 	if (rc != 0)
 		return rc;

-	receive_len = midQ->resp_buf->smb_buf_length;
+	receive_len = be32_to_cpu(midQ->resp_buf->smb_buf_length);
 	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
 		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
 			receive_len, xid);
@@ -1008,7 +1003,7 @@ SendReceiveBlockingLock(const unsigned int xid,
struct cifs_tcon *tcon,
 		goto out;
 	}

-	out_buf->smb_buf_length = receive_len;
+	out_buf->smb_buf_length = cpu_to_be32(receive_len);
 	memcpy((char *)out_buf + 4,
 	       (char *)midQ->resp_buf + 4,
 	       receive_len);
@@ -1027,7 +1022,7 @@ SendReceiveBlockingLock(const unsigned int xid,
struct cifs_tcon *tcon,
 		}
 	}

-	*pbytes_returned = out_buf->smb_buf_length;
+	*pbytes_returned = be32_to_cpu(out_buf->smb_buf_length);

 	/* BB special case reconnect tid and uid here? */
 	rc = map_smb_to_linux_error(out_buf, 0 /* no log */ );

-- 
Thanks,

Steve
