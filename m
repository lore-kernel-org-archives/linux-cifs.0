Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E6727146A
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068781; cv=none; b=tBhU1xrIrAi1SI3IGbbR7FrcCDhF4KufDFcEpycumEHsOK/IsE5OEgioBTLCoW5H+/cX/h1O+fRvf7cnmqmyT/p6dRA+LeK1ilECtZLhSAanogFYFpEKp6v4tmrGJ6t2z11IiEluOgUjnJzUGnbIhGkQQLNEt2bVQABfSWqFoUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068781; c=relaxed/simple;
	bh=wT0PpTe2z12rvP6Z9ocX8LWsGlGChGxOnPDpCjaFylo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SP/cJy8wvCW9yj/Cee8THuAB5W14GgsqlApL850hxswjyOVcq0cv6aEkoBMkZhfdtuzPR53xZsjGd/vbz9wLoWSjbgbBVy4ldHCQUAK3DA7fVaJf+42IWdpT4l/C0myhXmleCLudtNliHvsg0cJscjFML1P7Y8dx4qF50EObCQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N3/i4PAC; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N3/i4PAC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qB2UNV52fAw/I60yv97J92+2dNhltJxXqVwN/sDmeMw=;
	b=N3/i4PACG2kf1fTLWooNB7IPcgAu5UQnVsDtvgn0pSdgk9yYvca2W/3HTQqF/Ee9euuasr
	cb43ELRS3GWSDFD0nrB54k3If0WtTbJrJr5MSwemKSRtzrwdifM/0q90vQMBqcjTOzifC2
	xJdnjL8BvB0awaQ9zW6uO6EfqOA9/OE=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 14/14] smb: fix some warnings reported by scripts/checkpatch.pl
Date: Sun,  2 Nov 2025 15:30:59 +0800
Message-ID: <20251102073059.3681026-15-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Fix the following warnings:

  WARNING: __always_unused or __maybe_unused is preferred over \
                                    __attribute__((__unused__))
  WARNING: Prefer __packed over __attribute__((packed))

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 250 ++++++++++++++++++-------------------
 fs/smb/client/connect.c    |   4 +-
 fs/smb/client/ntlmssp.h    |   8 +-
 fs/smb/client/rfc1002pdu.h |   8 +-
 fs/smb/common/smbacl.h     |   8 +-
 5 files changed, 139 insertions(+), 139 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 37e78ec47574..49f35cb3cf2e 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -425,8 +425,8 @@ typedef struct smb_negotiate_rsp {
 		struct {
 			unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
 			unsigned char SecurityBlob[];
-		} __attribute__((packed)) extended_response;
-	} __attribute__((packed)) u;
+		} __packed extended_response;
+	} __packed u;
 } __packed SMB_NEGOTIATE_RSP;
 
 /* SecurityMode bits */
@@ -474,7 +474,7 @@ typedef union smb_com_session_setup_andx {
 		unsigned char SecurityBlob[];	/* followed by */
 		/* STRING NativeOS */
 		/* STRING NativeLanMan */
-	} __attribute__((packed)) req;	/* NTLM request format (with
+	} __packed req;	/* NTLM request format (with
 					extended security */
 
 	struct {		/* request format */
@@ -497,7 +497,7 @@ typedef union smb_com_session_setup_andx {
 		/* STRING PrimaryDomain */
 		/* STRING NativeOS */
 		/* STRING NativeLanMan */
-	} __attribute__((packed)) req_no_secext; /* NTLM request format (without
+	} __packed req_no_secext; /* NTLM request format (without
 							extended security */
 
 	struct {		/* default (NTLM) response format */
@@ -512,7 +512,7 @@ typedef union smb_com_session_setup_andx {
 /*      unsigned char  * NativeOS;      */
 /*	unsigned char  * NativeLanMan;  */
 /*      unsigned char  * PrimaryDomain; */
-	} __attribute__((packed)) resp;	/* NTLM response
+	} __packed resp;	/* NTLM response
 					   (with or without extended sec) */
 
 	struct {		/* request format */
@@ -532,7 +532,7 @@ typedef union smb_com_session_setup_andx {
 		/* STRING PrimaryDomain */
 		/* STRING NativeOS */
 		/* STRING NativeLanMan */
-	} __attribute__((packed)) old_req; /* pre-NTLM (LANMAN2.1) req format */
+	} __packed old_req; /* pre-NTLM (LANMAN2.1) req format */
 
 	struct {		/* default (NTLM) response format */
 		struct smb_hdr hdr;	/* wct = 3 */
@@ -544,8 +544,8 @@ typedef union smb_com_session_setup_andx {
 		unsigned char NativeOS[];	/* followed by */
 /*	unsigned char * NativeLanMan; */
 /*      unsigned char * PrimaryDomain; */
-	} __attribute__((packed)) old_resp; /* pre-NTLM (LANMAN2.1) response */
-} __attribute__((packed)) SESSION_SETUP_ANDX;
+	} __packed old_resp; /* pre-NTLM (LANMAN2.1) response */
+} __packed SESSION_SETUP_ANDX;
 
 /* format of NLTMv2 Response ie "case sensitive password" hash when NTLMv2 */
 
@@ -559,7 +559,7 @@ struct ntlmssp2_name {
 	__le16 type;
 	__le16 length;
 	__u8 data[];
-} __attribute__((packed));
+} __packed;
 
 struct ntlmv2_resp {
 	union {
@@ -567,15 +567,15 @@ struct ntlmv2_resp {
 	    struct {
 		__u8 reserved[8];
 		__u8 key[CIFS_SERVER_CHALLENGE_SIZE];
-	    } __attribute__((packed)) challenge;
-	} __attribute__((packed));
+	    } __packed challenge;
+	} __packed;
 	__le32 blob_signature;
 	__u32  reserved;
 	__le64  time;
 	__u64  client_chal; /* random */
 	__u32  reserved2;
 	/* array of name entries could follow ending in minimum 4 byte struct */
-} __attribute__((packed));
+} __packed;
 
 
 #define CIFS_NETWORK_OPSYS "CIFS VFS Client for Linux"
@@ -610,7 +610,7 @@ typedef struct smb_com_tconx_req {
 	unsigned char Password[];	/* followed by */
 /* STRING Path    *//* \\server\share name */
 	/* STRING Service */
-} __attribute__((packed)) TCONX_REQ;
+} __packed TCONX_REQ;
 
 typedef struct smb_com_tconx_rsp {
 	struct smb_hdr hdr;	/* wct = 3 , not extended response */
@@ -621,7 +621,7 @@ typedef struct smb_com_tconx_rsp {
 	__u16 ByteCount;
 	unsigned char Service[];	/* always ASCII, not Unicode */
 	/* STRING NativeFileSystem */
-} __attribute__((packed)) TCONX_RSP;
+} __packed TCONX_RSP;
 
 typedef struct smb_com_tconx_rsp_ext {
 	struct smb_hdr hdr;	/* wct = 7, extended response */
@@ -634,7 +634,7 @@ typedef struct smb_com_tconx_rsp_ext {
 	__u16 ByteCount;
 	unsigned char Service[];	/* always ASCII, not Unicode */
 	/* STRING NativeFileSystem */
-} __attribute__((packed)) TCONX_RSP_EXT;
+} __packed TCONX_RSP_EXT;
 
 
 /* tree connect Flags */
@@ -670,14 +670,14 @@ typedef struct smb_com_echo_req {
 	__le16	EchoCount;
 	__le16	ByteCount;
 	char	Data[];
-} __attribute__((packed)) ECHO_REQ;
+} __packed ECHO_REQ;
 
 typedef struct smb_com_echo_rsp {
 	struct	smb_hdr hdr;
 	__le16	SequenceNumber;
 	__le16	ByteCount;
 	char	Data[];
-} __attribute__((packed)) ECHO_RSP;
+} __packed ECHO_RSP;
 
 typedef struct smb_com_logoff_andx_req {
 	struct smb_hdr hdr;	/* wct = 2 */
@@ -685,7 +685,7 @@ typedef struct smb_com_logoff_andx_req {
 	__u8 AndXReserved;
 	__u16 AndXOffset;
 	__u16 ByteCount;
-} __attribute__((packed)) LOGOFF_ANDX_REQ;
+} __packed LOGOFF_ANDX_REQ;
 
 typedef struct smb_com_logoff_andx_rsp {
 	struct smb_hdr hdr;	/* wct = 2 */
@@ -693,7 +693,7 @@ typedef struct smb_com_logoff_andx_rsp {
 	__u8 AndXReserved;
 	__u16 AndXOffset;
 	__u16 ByteCount;
-} __attribute__((packed)) LOGOFF_ANDX_RSP;
+} __packed LOGOFF_ANDX_RSP;
 
 typedef union smb_com_tree_disconnect {	/* as an alternative can use flag on
 					tree_connect PDU to effect disconnect */
@@ -701,36 +701,36 @@ typedef union smb_com_tree_disconnect {	/* as an alternative can use flag on
 	struct {
 		struct smb_hdr hdr;	/* wct = 0 */
 		__u16 ByteCount;	/* bcc = 0 */
-	} __attribute__((packed)) req;
+	} __packed req;
 	struct {
 		struct smb_hdr hdr;	/* wct = 0 */
 		__u16 ByteCount;	/* bcc = 0 */
-	} __attribute__((packed)) resp;
-} __attribute__((packed)) TREE_DISCONNECT;
+	} __packed resp;
+} __packed TREE_DISCONNECT;
 
 typedef struct smb_com_close_req {
 	struct smb_hdr hdr;	/* wct = 3 */
 	__u16 FileID;
 	__u32 LastWriteTime;	/* should be zero or -1 */
 	__u16 ByteCount;	/* 0 */
-} __attribute__((packed)) CLOSE_REQ;
+} __packed CLOSE_REQ;
 
 typedef struct smb_com_close_rsp {
 	struct smb_hdr hdr;	/* wct = 0 */
 	__u16 ByteCount;	/* bct = 0 */
-} __attribute__((packed)) CLOSE_RSP;
+} __packed CLOSE_RSP;
 
 typedef struct smb_com_flush_req {
 	struct smb_hdr hdr;	/* wct = 1 */
 	__u16 FileID;
 	__u16 ByteCount;	/* 0 */
-} __attribute__((packed)) FLUSH_REQ;
+} __packed FLUSH_REQ;
 
 typedef struct smb_com_findclose_req {
 	struct smb_hdr hdr; /* wct = 1 */
 	__u16 FileID;
 	__u16 ByteCount;    /* 0 */
-} __attribute__((packed)) FINDCLOSE_REQ;
+} __packed FINDCLOSE_REQ;
 
 /* OpenFlags */
 #define REQ_MORE_INFO      0x00000001  /* legacy (OPEN_AND_X) only */
@@ -777,7 +777,7 @@ typedef struct smb_com_open_req {	/* also handles create */
 	__u8 SecurityFlags;
 	__le16 ByteCount;
 	char fileName[];
-} __attribute__((packed)) OPEN_REQ;
+} __packed OPEN_REQ;
 
 /* open response: oplock levels */
 #define OPLOCK_NONE  	 0
@@ -809,7 +809,7 @@ typedef struct smb_com_open_rsp {
 	__le16 DeviceState;
 	__u8 DirectoryFlag;
 	__u16 ByteCount;	/* bct = 0 */
-} __attribute__((packed)) OPEN_RSP;
+} __packed OPEN_RSP;
 
 typedef struct smb_com_open_rsp_ext {
 	struct smb_hdr hdr;     /* wct = 42 but meaningless due to MS bug? */
@@ -834,7 +834,7 @@ typedef struct smb_com_open_rsp_ext {
 	__le32 MaximalAccessRights;
 	__le32 GuestMaximalAccessRights;
 	__u16 ByteCount;        /* bct = 0 */
-} __attribute__((packed)) OPEN_RSP_EXT;
+} __packed OPEN_RSP_EXT;
 
 
 /* format of legacy open request */
@@ -854,7 +854,7 @@ typedef struct smb_com_openx_req {
 	__le32 Reserved;
 	__le16  ByteCount;  /* file name follows */
 	char   fileName[];
-} __attribute__((packed)) OPENX_REQ;
+} __packed OPENX_REQ;
 
 typedef struct smb_com_openx_rsp {
 	struct smb_hdr	hdr;	/* wct = 15 */
@@ -872,7 +872,7 @@ typedef struct smb_com_openx_rsp {
 	__u32  FileId;
 	__u16  Reserved;
 	__u16  ByteCount;
-} __attribute__((packed)) OPENX_RSP;
+} __packed OPENX_RSP;
 
 /* For encoding of POSIX Open Request - see trans2 function 0x209 data struct */
 
@@ -894,7 +894,7 @@ typedef struct smb_com_writex_req {
 	__u8 Pad;		/* BB check for whether padded to DWORD
 				   boundary and optimum performance here */
 	char Data[];
-} __attribute__((packed)) WRITEX_REQ;
+} __packed WRITEX_REQ;
 
 typedef struct smb_com_write_req {
 	struct smb_hdr hdr;	/* wct = 14 */
@@ -914,7 +914,7 @@ typedef struct smb_com_write_req {
 	__u8 Pad;		/* BB check for whether padded to DWORD
 				   boundary and optimum performance here */
 	char Data[];
-} __attribute__((packed)) WRITE_REQ;
+} __packed WRITE_REQ;
 
 typedef struct smb_com_write_rsp {
 	struct smb_hdr hdr;	/* wct = 6 */
@@ -926,7 +926,7 @@ typedef struct smb_com_write_rsp {
 	__le16 CountHigh;
 	__u16  Reserved;
 	__u16 ByteCount;
-} __attribute__((packed)) WRITE_RSP;
+} __packed WRITE_RSP;
 
 /* legacy read request for older servers */
 typedef struct smb_com_readx_req {
@@ -941,7 +941,7 @@ typedef struct smb_com_readx_req {
 	__le32 Reserved;
 	__le16 Remaining;
 	__le16 ByteCount;
-} __attribute__((packed)) READX_REQ;
+} __packed READX_REQ;
 
 typedef struct smb_com_read_req {
 	struct smb_hdr hdr;	/* wct = 12 */
@@ -956,7 +956,7 @@ typedef struct smb_com_read_req {
 	__le16 Remaining;
 	__le32 OffsetHigh;
 	__le16 ByteCount;
-} __attribute__((packed)) READ_REQ;
+} __packed READ_REQ;
 
 typedef struct smb_com_read_rsp {
 	struct smb_hdr hdr;	/* wct = 12 */
@@ -972,7 +972,7 @@ typedef struct smb_com_read_rsp {
 	__u64 Reserved2;
 	__u16 ByteCount;
 	/* read response data immediately follows */
-} __attribute__((packed)) READ_RSP;
+} __packed READ_RSP;
 
 typedef struct locking_andx_range {
 	__le16 Pid;
@@ -981,7 +981,7 @@ typedef struct locking_andx_range {
 	__le32 OffsetLow;
 	__le32 LengthHigh;
 	__le32 LengthLow;
-} __attribute__((packed)) LOCKING_ANDX_RANGE;
+} __packed LOCKING_ANDX_RANGE;
 
 #define LOCKING_ANDX_SHARED_LOCK     0x01
 #define LOCKING_ANDX_OPLOCK_RELEASE  0x02
@@ -1002,7 +1002,7 @@ typedef struct smb_com_lock_req {
 	__le16 NumberOfLocks;
 	__le16 ByteCount;
 	LOCKING_ANDX_RANGE Locks[];
-} __attribute__((packed)) LOCK_REQ;
+} __packed LOCK_REQ;
 
 /* lock type */
 #define CIFS_RDLCK	0
@@ -1015,7 +1015,7 @@ typedef struct cifs_posix_lock {
 	__le64	start;
 	__le64	length;
 	/* BB what about additional owner info to identify network client */
-} __attribute__((packed)) CIFS_POSIX_LOCK;
+} __packed CIFS_POSIX_LOCK;
 
 typedef struct smb_com_lock_rsp {
 	struct smb_hdr hdr;	/* wct = 2 */
@@ -1023,7 +1023,7 @@ typedef struct smb_com_lock_rsp {
 	__u8 AndXReserved;
 	__le16 AndXOffset;
 	__u16 ByteCount;
-} __attribute__((packed)) LOCK_RSP;
+} __packed LOCK_RSP;
 
 typedef struct smb_com_rename_req {
 	struct smb_hdr hdr;	/* wct = 1 */
@@ -1033,7 +1033,7 @@ typedef struct smb_com_rename_req {
 	unsigned char OldFileName[];
 	/* followed by __u8 BufferFormat2 */
 	/* followed by NewFileName */
-} __attribute__((packed)) RENAME_REQ;
+} __packed RENAME_REQ;
 
 	/* copy request flags */
 #define COPY_MUST_BE_FILE      0x0001
@@ -1053,7 +1053,7 @@ typedef struct smb_com_copy_req {
 	unsigned char OldFileName[];
 	/* followed by __u8 BufferFormat2 */
 	/* followed by NewFileName string */
-} __attribute__((packed)) COPY_REQ;
+} __packed COPY_REQ;
 
 typedef struct smb_com_copy_rsp {
 	struct smb_hdr hdr;     /* wct = 1 */
@@ -1061,7 +1061,7 @@ typedef struct smb_com_copy_rsp {
 	__u16 ByteCount;    /* may be zero */
 	__u8 BufferFormat;  /* 0x04 - only present if errored file follows */
 	unsigned char ErrorFileName[]; /* only present if error in copy */
-} __attribute__((packed)) COPY_RSP;
+} __packed COPY_RSP;
 
 #define CREATE_HARD_LINK		0x103
 #define MOVEFILE_COPY_ALLOWED		0x0002
@@ -1077,12 +1077,12 @@ typedef struct smb_com_nt_rename_req {	/* A5 - also used for create hardlink */
 	unsigned char OldFileName[];
 	/* followed by __u8 BufferFormat2 */
 	/* followed by NewFileName */
-} __attribute__((packed)) NT_RENAME_REQ;
+} __packed NT_RENAME_REQ;
 
 typedef struct smb_com_rename_rsp {
 	struct smb_hdr hdr;	/* wct = 0 */
 	__u16 ByteCount;	/* bct = 0 */
-} __attribute__((packed)) RENAME_RSP;
+} __packed RENAME_RSP;
 
 typedef struct smb_com_delete_file_req {
 	struct smb_hdr hdr;	/* wct = 1 */
@@ -1090,43 +1090,43 @@ typedef struct smb_com_delete_file_req {
 	__le16 ByteCount;
 	__u8 BufferFormat;	/* 4 = ASCII */
 	unsigned char fileName[];
-} __attribute__((packed)) DELETE_FILE_REQ;
+} __packed DELETE_FILE_REQ;
 
 typedef struct smb_com_delete_file_rsp {
 	struct smb_hdr hdr;	/* wct = 0 */
 	__u16 ByteCount;	/* bct = 0 */
-} __attribute__((packed)) DELETE_FILE_RSP;
+} __packed DELETE_FILE_RSP;
 
 typedef struct smb_com_delete_directory_req {
 	struct smb_hdr hdr;	/* wct = 0 */
 	__le16 ByteCount;
 	__u8 BufferFormat;	/* 4 = ASCII */
 	unsigned char DirName[];
-} __attribute__((packed)) DELETE_DIRECTORY_REQ;
+} __packed DELETE_DIRECTORY_REQ;
 
 typedef struct smb_com_delete_directory_rsp {
 	struct smb_hdr hdr;	/* wct = 0 */
 	__u16 ByteCount;	/* bct = 0 */
-} __attribute__((packed)) DELETE_DIRECTORY_RSP;
+} __packed DELETE_DIRECTORY_RSP;
 
 typedef struct smb_com_create_directory_req {
 	struct smb_hdr hdr;	/* wct = 0 */
 	__le16 ByteCount;
 	__u8 BufferFormat;	/* 4 = ASCII */
 	unsigned char DirName[];
-} __attribute__((packed)) CREATE_DIRECTORY_REQ;
+} __packed CREATE_DIRECTORY_REQ;
 
 typedef struct smb_com_create_directory_rsp {
 	struct smb_hdr hdr;	/* wct = 0 */
 	__u16 ByteCount;	/* bct = 0 */
-} __attribute__((packed)) CREATE_DIRECTORY_RSP;
+} __packed CREATE_DIRECTORY_RSP;
 
 typedef struct smb_com_query_information_req {
 	struct smb_hdr hdr;     /* wct = 0 */
 	__le16 ByteCount;	/* 1 + namelen + 1 */
 	__u8 BufferFormat;      /* 4 = ASCII */
 	unsigned char FileName[];
-} __attribute__((packed)) QUERY_INFORMATION_REQ;
+} __packed QUERY_INFORMATION_REQ;
 
 typedef struct smb_com_query_information_rsp {
 	struct smb_hdr hdr;     /* wct = 10 */
@@ -1135,7 +1135,7 @@ typedef struct smb_com_query_information_rsp {
 	__le32 size;
 	__u16  reserved[5];
 	__le16 ByteCount;	/* bcc = 0 */
-} __attribute__((packed)) QUERY_INFORMATION_RSP;
+} __packed QUERY_INFORMATION_RSP;
 
 typedef struct smb_com_setattr_req {
 	struct smb_hdr hdr; /* wct = 8 */
@@ -1145,12 +1145,12 @@ typedef struct smb_com_setattr_req {
 	__le16 ByteCount;
 	__u8   BufferFormat; /* 4 = ASCII */
 	unsigned char fileName[];
-} __attribute__((packed)) SETATTR_REQ;
+} __packed SETATTR_REQ;
 
 typedef struct smb_com_setattr_rsp {
 	struct smb_hdr hdr;     /* wct = 0 */
 	__u16 ByteCount;        /* bct = 0 */
-} __attribute__((packed)) SETATTR_RSP;
+} __packed SETATTR_RSP;
 
 /* empty wct response to setattr */
 
@@ -1178,7 +1178,7 @@ typedef struct smb_com_ntransact_req {
 	__le16 ByteCount;
 	__u8 Pad[3];
 	__u8 Parms[];
-} __attribute__((packed)) NTRANSACT_REQ;
+} __packed NTRANSACT_REQ;
 
 typedef struct smb_com_ntransact_rsp {
 	struct smb_hdr hdr;     /* wct = 18 */
@@ -1195,7 +1195,7 @@ typedef struct smb_com_ntransact_rsp {
 	__u16 ByteCount;
 	/* __u8 Pad[3]; */
 	/* parms and data follow */
-} __attribute__((packed)) NTRANSACT_RSP;
+} __packed NTRANSACT_RSP;
 
 typedef struct smb_com_transaction_ioctl_req {
 	struct smb_hdr hdr;	/* wct = 23 */
@@ -1219,7 +1219,7 @@ typedef struct smb_com_transaction_ioctl_req {
 	__le16 ByteCount;
 	__u8 Pad[3];
 	__u8 Data[];
-} __attribute__((packed)) TRANSACT_IOCTL_REQ;
+} __packed TRANSACT_IOCTL_REQ;
 
 typedef struct smb_com_transaction_compr_ioctl_req {
 	struct smb_hdr hdr;	/* wct = 23 */
@@ -1243,7 +1243,7 @@ typedef struct smb_com_transaction_compr_ioctl_req {
 	__le16 ByteCount;
 	__u8 Pad[3];
 	__le16 compression_state;  /* See below for valid flags */
-} __attribute__((packed)) TRANSACT_COMPR_IOCTL_REQ;
+} __packed TRANSACT_COMPR_IOCTL_REQ;
 
 /* compression state flags */
 #define COMPRESSION_FORMAT_NONE		0x0000
@@ -1264,7 +1264,7 @@ typedef struct smb_com_transaction_ioctl_rsp {
 	__u8 SetupCount;	/* 1 */
 	__le16 ReturnedDataLen;
 	__le16 ByteCount;
-} __attribute__((packed)) TRANSACT_IOCTL_RSP;
+} __packed TRANSACT_IOCTL_RSP;
 
 #define CIFS_ACL_OWNER 1
 #define CIFS_ACL_GROUP 2
@@ -1291,7 +1291,7 @@ typedef struct smb_com_transaction_qsec_req {
 	__u16 Fid;
 	__u16 Reserved2;
 	__le32 AclFlags;
-} __attribute__((packed)) QUERY_SEC_DESC_REQ;
+} __packed QUERY_SEC_DESC_REQ;
 
 
 typedef struct smb_com_transaction_ssec_req {
@@ -1314,7 +1314,7 @@ typedef struct smb_com_transaction_ssec_req {
 	__u16 Fid;
 	__u16 Reserved2;
 	__le32 AclFlags;
-} __attribute__((packed)) SET_SEC_DESC_REQ;
+} __packed SET_SEC_DESC_REQ;
 
 typedef struct smb_com_transaction_change_notify_req {
 	struct smb_hdr hdr;     /* wct = 23 */
@@ -1338,7 +1338,7 @@ typedef struct smb_com_transaction_change_notify_req {
 	__le16 ByteCount;
 /*	__u8 Pad[3];*/
 /*	__u8 Data[];*/
-} __attribute__((packed)) TRANSACT_CHANGE_NOTIFY_REQ;
+} __packed TRANSACT_CHANGE_NOTIFY_REQ;
 
 /* BB eventually change to use generic ntransact rsp struct
       and validation routine */
@@ -1356,7 +1356,7 @@ typedef struct smb_com_transaction_change_notify_rsp {
 	__u8 SetupCount;   /* 0 */
 	__u16 ByteCount;
 	/* __u8 Pad[3]; */
-} __attribute__((packed)) TRANSACT_CHANGE_NOTIFY_RSP;
+} __packed TRANSACT_CHANGE_NOTIFY_RSP;
 /* Completion Filter flags for Notify */
 #define FILE_NOTIFY_CHANGE_FILE_NAME    0x00000001
 #define FILE_NOTIFY_CHANGE_DIR_NAME     0x00000002
@@ -1387,7 +1387,7 @@ struct file_notify_information {
 	__le32 Action;
 	__le32 FileNameLength;
 	__u8  FileName[];
-} __attribute__((packed));
+} __packed;
 
 struct cifs_quota_data {
 	__u32	rsrvd1;  /* 0 */
@@ -1397,7 +1397,7 @@ struct cifs_quota_data {
 	__u64	soft_limit;
 	__u64	hard_limit;
 	char	sid[];  /* variable size? */
-} __attribute__((packed));
+} __packed;
 
 /* quota sub commands */
 #define QUOTA_LIST_CONTINUE	    0
@@ -1423,12 +1423,12 @@ struct trans2_req {
 	__u8 Reserved3;
 	__le16 SubCommand; /* 1st setup word - SetupCount words follow */
 	__le16 ByteCount;
-} __attribute__((packed));
+} __packed;
 
 struct smb_t2_req {
 	struct smb_hdr hdr;
 	struct trans2_req t2_req;
-} __attribute__((packed));
+} __packed;
 
 struct trans2_resp {
 	/* struct smb_hdr hdr precedes. Note wct = 10 + setup count */
@@ -1447,12 +1447,12 @@ struct trans2_resp {
 	__u16 ByteCount;
 	__u16 Reserved2;*/
 	/* data area follows */
-} __attribute__((packed));
+} __packed;
 
 struct smb_t2_rsp {
 	struct smb_hdr hdr;
 	struct trans2_resp t2_rsp;
-} __attribute__((packed));
+} __packed;
 
 /* PathInfo/FileInfo infolevels */
 #define SMB_INFO_STANDARD                   1
@@ -1549,14 +1549,14 @@ typedef struct smb_com_transaction2_qpi_req {
 	__le16 InformationLevel;
 	__u32 Reserved4;
 	char FileName[];
-} __attribute__((packed)) TRANSACTION2_QPI_REQ;
+} __packed TRANSACTION2_QPI_REQ;
 
 typedef struct smb_com_transaction2_qpi_rsp {
 	struct smb_hdr hdr;	/* wct = 10 + SetupCount */
 	struct trans2_resp t2;
 	__u16 ByteCount;
 	__u16 Reserved2; /* parameter word is present for infolevels > 100 */
-} __attribute__((packed)) TRANSACTION2_QPI_RSP;
+} __packed TRANSACTION2_QPI_RSP;
 
 typedef struct smb_com_transaction2_spi_req {
 	struct smb_hdr hdr;	/* wct = 15 */
@@ -1582,21 +1582,21 @@ typedef struct smb_com_transaction2_spi_req {
 	__le16 InformationLevel;
 	__u32 Reserved4;
 	char FileName[];
-} __attribute__((packed)) TRANSACTION2_SPI_REQ;
+} __packed TRANSACTION2_SPI_REQ;
 
 typedef struct smb_com_transaction2_spi_rsp {
 	struct smb_hdr hdr;	/* wct = 10 + SetupCount */
 	struct trans2_resp t2;
 	__u16 ByteCount;
 	__u16 Reserved2; /* parameter word is present for infolevels > 100 */
-} __attribute__((packed)) TRANSACTION2_SPI_RSP;
+} __packed TRANSACTION2_SPI_RSP;
 
 struct set_file_rename {
 	__le32 overwrite;   /* 1 = overwrite dest */
 	__u32 root_fid;   /* zero */
 	__le32 target_name_len;
 	char  target_name[];  /* Must be unicode */
-} __attribute__((packed));
+} __packed;
 
 struct smb_com_transaction2_sfi_req {
 	struct smb_hdr hdr;	/* wct = 15 */
@@ -1623,14 +1623,14 @@ struct smb_com_transaction2_sfi_req {
 	__le16 InformationLevel;
 	__u16 Reserved4;
 	__u8  payload[];
-} __attribute__((packed));
+} __packed;
 
 struct smb_com_transaction2_sfi_rsp {
 	struct smb_hdr hdr;	/* wct = 10 + SetupCount */
 	struct trans2_resp t2;
 	__u16 ByteCount;
 	__u16 Reserved2; /* parameter word reserved - present for infolevels > 100 */
-} __attribute__((packed));
+} __packed;
 
 struct smb_t2_qfi_req {
 	struct	smb_hdr hdr;
@@ -1638,14 +1638,14 @@ struct smb_t2_qfi_req {
 	__u8	Pad;
 	__u16	Fid;
 	__le16	InformationLevel;
-} __attribute__((packed));
+} __packed;
 
 struct smb_t2_qfi_rsp {
 	struct smb_hdr hdr;     /* wct = 10 + SetupCount */
 	struct trans2_resp t2;
 	__u16 ByteCount;
 	__u16 Reserved2; /* parameter word reserved - present for infolevels > 100 */
-} __attribute__((packed));
+} __packed;
 
 /*
  * Flags on T2 FINDFIRST and FINDNEXT
@@ -1687,13 +1687,13 @@ typedef struct smb_com_transaction2_ffirst_req {
 	__le16 InformationLevel;
 	__le32 SearchStorageType;
 	char FileName[];
-} __attribute__((packed)) TRANSACTION2_FFIRST_REQ;
+} __packed TRANSACTION2_FFIRST_REQ;
 
 typedef struct smb_com_transaction2_ffirst_rsp {
 	struct smb_hdr hdr;	/* wct = 10 */
 	struct trans2_resp t2;
 	__u16 ByteCount;
-} __attribute__((packed)) TRANSACTION2_FFIRST_RSP;
+} __packed TRANSACTION2_FFIRST_RSP;
 
 typedef struct smb_com_transaction2_ffirst_rsp_parms {
 	__u16 SearchHandle;
@@ -1701,7 +1701,7 @@ typedef struct smb_com_transaction2_ffirst_rsp_parms {
 	__le16 EndofSearch;
 	__le16 EAErrorOffset;
 	__le16 LastNameOffset;
-} __attribute__((packed)) T2_FFIRST_RSP_PARMS;
+} __packed T2_FFIRST_RSP_PARMS;
 
 typedef struct smb_com_transaction2_fnext_req {
 	struct smb_hdr hdr;	/* wct = 15 */
@@ -1729,20 +1729,20 @@ typedef struct smb_com_transaction2_fnext_req {
 	__u32 ResumeKey;
 	__le16 SearchFlags;
 	char ResumeFileName[];
-} __attribute__((packed)) TRANSACTION2_FNEXT_REQ;
+} __packed TRANSACTION2_FNEXT_REQ;
 
 typedef struct smb_com_transaction2_fnext_rsp {
 	struct smb_hdr hdr;	/* wct = 10 */
 	struct trans2_resp t2;
 	__u16 ByteCount;
-} __attribute__((packed)) TRANSACTION2_FNEXT_RSP;
+} __packed TRANSACTION2_FNEXT_RSP;
 
 typedef struct smb_com_transaction2_fnext_rsp_parms {
 	__le16 SearchCount;
 	__le16 EndofSearch;
 	__le16 EAErrorOffset;
 	__le16 LastNameOffset;
-} __attribute__((packed)) T2_FNEXT_RSP_PARMS;
+} __packed T2_FNEXT_RSP_PARMS;
 
 /* QFSInfo Levels */
 #define SMB_INFO_ALLOCATION         1
@@ -1786,14 +1786,14 @@ typedef struct smb_com_transaction2_qfsi_req {
 	__le16 ByteCount;
 	__u8 Pad;
 	__le16 InformationLevel;
-} __attribute__((packed)) TRANSACTION2_QFSI_REQ;
+} __packed TRANSACTION2_QFSI_REQ;
 
 typedef struct smb_com_transaction_qfsi_rsp {
 	struct smb_hdr hdr;	/* wct = 10 + SetupCount */
 	struct trans2_resp t2;
 	__u16 ByteCount;
 	__u8 Pad;	/* may be three bytes? *//* followed by data area */
-} __attribute__((packed)) TRANSACTION2_QFSI_RSP;
+} __packed TRANSACTION2_QFSI_RSP;
 
 typedef struct whoami_rsp_data { /* Query level 0x202 */
 	__u32 flags; /* 0 = Authenticated user 1 = GUEST */
@@ -1806,7 +1806,7 @@ typedef struct whoami_rsp_data { /* Query level 0x202 */
 	__u32 pad; /* reserved - MBZ */
 	/* __u64 gid_array[0]; */  /* may be empty */
 	/* __u8 * psid_list */  /* may be empty */
-} __attribute__((packed)) WHOAMI_RSP_DATA;
+} __packed WHOAMI_RSP_DATA;
 
 /* SETFSInfo Levels */
 #define SMB_SET_CIFS_UNIX_INFO    0x200
@@ -1839,7 +1839,7 @@ typedef struct smb_com_transaction2_setfsi_req {
 	__le16 ClientUnixMajor; /* Data start. */
 	__le16 ClientUnixMinor;
 	__le64 ClientUnixCap;   /* Data end */
-} __attribute__((packed)) TRANSACTION2_SETFSI_REQ;
+} __packed TRANSACTION2_SETFSI_REQ;
 
 /* level 0x203 request structure follows */
 typedef struct smb_com_transaction2_setfs_enc_req {
@@ -1865,14 +1865,14 @@ typedef struct smb_com_transaction2_setfs_enc_req {
 	__u16  Reserved4;	/* Parameters start. */
 	__le16 InformationLevel;/* Parameters end. */
 	/* NTLMSSP Blob, Data start. */
-} __attribute__((packed)) TRANSACTION2_SETFSI_ENC_REQ;
+} __packed TRANSACTION2_SETFSI_ENC_REQ;
 
 /* response for setfsinfo levels 0x200 and 0x203 */
 typedef struct smb_com_transaction2_setfsi_rsp {
 	struct smb_hdr hdr;	/* wct = 10 */
 	struct trans2_resp t2;
 	__u16 ByteCount;
-} __attribute__((packed)) TRANSACTION2_SETFSI_RSP;
+} __packed TRANSACTION2_SETFSI_RSP;
 
 typedef struct smb_com_transaction2_get_dfs_refer_req {
 	struct smb_hdr hdr;	/* wct = 15 */
@@ -1898,7 +1898,7 @@ typedef struct smb_com_transaction2_get_dfs_refer_req {
 				   seem to matter though */
 	__le16 MaxReferralLevel;
 	char RequestFileName[];
-} __attribute__((packed)) TRANSACTION2_GET_DFS_REFER_REQ;
+} __packed TRANSACTION2_GET_DFS_REFER_REQ;
 
 #define DFS_VERSION cpu_to_le16(0x0003)
 
@@ -1920,7 +1920,7 @@ typedef struct dfs_referral_level_3 { /* version 4 is same, + one flag bit */
 	__le16 DfsAlternatePathOffset;
 	__le16 NetworkAddressOffset; /* offset of the link target */
 	__u8   ServiceSiteGuid[16];  /* MBZ, ignored */
-} __attribute__((packed)) REFERRAL3;
+} __packed REFERRAL3;
 
 struct get_dfs_referral_rsp {
 	__le16 PathConsumed;
@@ -1960,7 +1960,7 @@ struct serverInfo {
 	unsigned char versionMinor;
 	unsigned long type;
 	unsigned int commentOffset;
-} __attribute__((packed));
+} __packed;
 
 /*
  * The following structure is the format of the data returned on a NetShareEnum
@@ -1972,20 +1972,20 @@ struct shareInfo {
 	char pad;
 	unsigned short type;
 	unsigned int commentOffset;
-} __attribute__((packed));
+} __packed;
 
 struct aliasInfo {
 	char aliasName[9];
 	char pad;
 	unsigned int commentOffset;
 	unsigned char type[2];
-} __attribute__((packed));
+} __packed;
 
 struct aliasInfo92 {
 	int aliasNameOffset;
 	int serverNameOffset;
 	int shareNameOffset;
-} __attribute__((packed));
+} __packed;
 
 typedef struct {
 	__le32 fsid;
@@ -1993,13 +1993,13 @@ typedef struct {
 	__le32 TotalAllocationUnits;
 	__le32 FreeAllocationUnits;
 	__le16  BytesPerSector;
-} __attribute__((packed)) FILE_SYSTEM_ALLOC_INFO;
+} __packed FILE_SYSTEM_ALLOC_INFO;
 
 typedef struct {
 	__le16 MajorVersionNumber;
 	__le16 MinorVersionNumber;
 	__le64 Capability;
-} __attribute__((packed)) FILE_SYSTEM_UNIX_INFO; /* Unix extension level 0x200*/
+} __packed FILE_SYSTEM_UNIX_INFO; /* Unix extension level 0x200*/
 
 /* Version numbers for CIFS UNIX major and minor. */
 #define CIFS_UNIX_MAJOR_VERSION 1
@@ -2092,7 +2092,7 @@ typedef struct { /* data block encoding of response to level 263 QPathInfo */
 		char __pad;
 		DECLARE_FLEX_ARRAY(char, FileName);
 	};
-} __attribute__((packed)) FILE_ALL_INFO;	/* level 0x107 QPathInfo */
+} __packed FILE_ALL_INFO;	/* level 0x107 QPathInfo */
 
 typedef struct {
 	__le64 AllocationSize;
@@ -2101,7 +2101,7 @@ typedef struct {
 	__u8 DeletePending;
 	__u8 Directory;
 	__u16 Pad;
-} __attribute__((packed)) FILE_STANDARD_INFO;	/* level 0x102 QPathInfo */
+} __packed FILE_STANDARD_INFO;	/* level 0x102 QPathInfo */
 
 
 /* defines for enumerating possible values of the Unix type field below */
@@ -2126,11 +2126,11 @@ typedef struct {
 	__le64 UniqueId;
 	__le64 Permissions;
 	__le64 Nlinks;
-} __attribute__((packed)) FILE_UNIX_BASIC_INFO;	/* level 0x200 QPathInfo */
+} __packed FILE_UNIX_BASIC_INFO;	/* level 0x200 QPathInfo */
 
 typedef struct {
 	DECLARE_FLEX_ARRAY(char, LinkDest);
-} __attribute__((packed)) FILE_UNIX_LINK_INFO;	/* level 0x201 QPathInfo */
+} __packed FILE_UNIX_LINK_INFO;	/* level 0x201 QPathInfo */
 
 /* The following three structures are needed only for
 	setting time to NT4 and some older servers via
@@ -2139,13 +2139,13 @@ typedef struct {
 	__u16 Day:5;
 	__u16 Month:4;
 	__u16 Year:7;
-} __attribute__((packed)) SMB_DATE;
+} __packed SMB_DATE;
 
 typedef struct {
 	__u16 TwoSeconds:5;
 	__u16 Minutes:6;
 	__u16 Hours:5;
-} __attribute__((packed)) SMB_TIME;
+} __packed SMB_TIME;
 
 typedef struct {
 	__le16 CreationDate; /* SMB Date see above */
@@ -2158,7 +2158,7 @@ typedef struct {
 	__le32 AllocationSize;
 	__le16 Attributes; /* verify not u32 */
 	__le32 EASize;
-} __attribute__((packed)) FILE_INFO_STANDARD;  /* level 1 SetPath/FileInfo */
+} __packed FILE_INFO_STANDARD;  /* level 1 SetPath/FileInfo */
 
 typedef struct {
 	__le64 CreationTime;
@@ -2167,7 +2167,7 @@ typedef struct {
 	__le64 ChangeTime;
 	__le32 Attributes;
 	__u32 Pad;
-} __attribute__((packed)) FILE_BASIC_INFO;	/* size info, level 0x101 */
+} __packed FILE_BASIC_INFO;	/* size info, level 0x101 */
 
 struct file_allocation_info {
 	__le64 AllocationSize; /* Note old Samba srvr rounds this up too much */
@@ -2175,11 +2175,11 @@ struct file_allocation_info {
 
 struct file_end_of_file_info {
 	__le64 FileSize;		/* offset to end of file */
-} __attribute__((packed)); /* size info, level 0x104 for set, 0x106 for query */
+} __packed; /* size info, level 0x104 for set, 0x106 for query */
 
 struct file_alt_name_info {
 	DECLARE_FLEX_ARRAY(__u8, alt_name);
-} __attribute__((packed));      /* level 0x0108 */
+} __packed;      /* level 0x0108 */
 
 struct file_stream_info {
 	__le32 number_of_streams;  /* BB check sizes and verify location */
@@ -2196,7 +2196,7 @@ struct file_compression_info {
 	__u8   ch_shift;
 	__u8   cl_shift;
 	__u8   pad[3];
-} __attribute__((packed));      /* level 0x10b */
+} __packed;      /* level 0x10b */
 
 /* POSIX ACL set/query path info structures */
 #define CIFS_ACL_VERSION 1
@@ -2204,7 +2204,7 @@ struct cifs_posix_ace { /* access control entry (ACE) */
 	__u8  cifs_e_tag;
 	__u8  cifs_e_perm;
 	__le64 cifs_uid; /* or gid */
-} __attribute__((packed));
+} __packed;
 
 struct cifs_posix_acl { /* access control list  (ACL) */
 	__le16	version;
@@ -2212,7 +2212,7 @@ struct cifs_posix_acl { /* access control list  (ACL) */
 	__le16	default_entry_count; /* default ACL - count of entries */
 	struct cifs_posix_ace ace_array[];
 	/* followed by struct cifs_posix_ace default_ace_array[] */
-} __attribute__((packed));  /* level 0x204 */
+} __packed;  /* level 0x204 */
 
 /* types of access control entries already defined in posix_acl.h */
 /* #define CIFS_POSIX_ACL_USER_OBJ	 0x01
@@ -2247,7 +2247,7 @@ typedef struct {
 	__le32 PosixOpenFlags;
 	__le64 Permissions;
 	__le16 Level; /* reply level requested (see QPathInfo levels) */
-} __attribute__((packed)) OPEN_PSX_REQ; /* level 0x209 SetPathInfo data */
+} __packed OPEN_PSX_REQ; /* level 0x209 SetPathInfo data */
 
 typedef struct {
 	__le16 OplockFlags;
@@ -2256,27 +2256,27 @@ typedef struct {
 	__le16 ReturnedLevel;
 	__le16 Pad;
 	/* struct following varies based on requested level */
-} __attribute__((packed)) OPEN_PSX_RSP; /* level 0x209 SetPathInfo data */
+} __packed OPEN_PSX_RSP; /* level 0x209 SetPathInfo data */
 
 #define SMB_POSIX_UNLINK_FILE_TARGET		0
 #define SMB_POSIX_UNLINK_DIRECTORY_TARGET	1
 
 struct unlink_psx_rq { /* level 0x20a SetPathInfo */
 	__le16 type;
-} __attribute__((packed));
+} __packed;
 
 struct file_internal_info {
 	__le64  UniqueId; /* inode number */
-} __attribute__((packed));      /* level 0x3ee */
+} __packed;      /* level 0x3ee */
 
 struct file_mode_info {
 	__le32	Mode;
-} __attribute__((packed));      /* level 0x3f8 */
+} __packed;      /* level 0x3f8 */
 
 struct file_attrib_tag {
 	__le32 Attribute;
 	__le32 ReparseTag;
-} __attribute__((packed));      /* level 0x40b */
+} __packed;      /* level 0x40b */
 
 
 /********************************************************/
@@ -2291,7 +2291,7 @@ typedef struct {
 		char __pad;
 		DECLARE_FLEX_ARRAY(char, FileName);
 	};
-} __attribute__((packed)) FILE_UNIX_INFO; /* level 0x202 */
+} __packed FILE_UNIX_INFO; /* level 0x202 */
 
 typedef struct {
 	__u32  ResumeKey;
@@ -2306,7 +2306,7 @@ typedef struct {
 	__le16 Attributes; /* verify not u32 */
 	__u8   FileNameLength;
 	char FileName[];
-} __attribute__((packed)) FIND_FILE_STANDARD_INFO; /* level 0x1 FF resp data */
+} __packed FIND_FILE_STANDARD_INFO; /* level 0x1 FF resp data */
 
 
 struct fea {
@@ -2315,21 +2315,21 @@ struct fea {
 	__le16 value_len;
 	char name[];
 	/* optionally followed by value */
-} __attribute__((packed));
+} __packed;
 /* flags for _FEA.fEA */
 #define FEA_NEEDEA         0x80	/* need EA bit */
 
 struct fealist {
 	__le32 list_len;
 	struct fea list;
-} __attribute__((packed));
+} __packed;
 
 /* used to hold an arbitrary blob of data */
 struct data_blob {
 	__u8 *data;
 	size_t length;
 	void (*free) (struct data_blob *data_blob);
-} __attribute__((packed));
+} __packed;
 
 
 #ifdef CONFIG_CIFS_POSIX
@@ -2432,7 +2432,7 @@ struct xsymlink {
 	char cr2;        /* \n */
 /* if room left, then end with \n then 0x20s by convention but not required */
 	char path[1024];
-} __attribute__((packed));
+} __packed;
 
 typedef struct file_xattr_info {
 	/* BB do we need another field for flags? BB */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 22f37ae7a66a..786303b799ba 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2326,8 +2326,8 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 }
 #else /* ! CONFIG_KEYS */
 static inline int
-cifs_set_cifscreds(struct smb3_fs_context *ctx __attribute__((unused)),
-		   struct cifs_ses *ses __attribute__((unused)))
+cifs_set_cifscreds(struct smb3_fs_context *ctx __maybe_unused,
+		   struct cifs_ses *ses __maybe_unused)
 {
 	return -ENOSYS;
 }
diff --git a/fs/smb/client/ntlmssp.h b/fs/smb/client/ntlmssp.h
index 875de43b72de..a11fddc321f6 100644
--- a/fs/smb/client/ntlmssp.h
+++ b/fs/smb/client/ntlmssp.h
@@ -73,7 +73,7 @@ typedef struct _SECURITY_BUFFER {
 	__le16 Length;
 	__le16 MaximumLength;
 	__le32 BufferOffset;	/* offset to buffer */
-} __attribute__((packed)) SECURITY_BUFFER;
+} __packed SECURITY_BUFFER;
 
 typedef struct _NEGOTIATE_MESSAGE {
 	__u8 Signature[sizeof(NTLMSSP_SIGNATURE)];
@@ -85,7 +85,7 @@ typedef struct _NEGOTIATE_MESSAGE {
 	   do not set the version is present flag */
 	char DomainString[];
 	/* followed by WorkstationString */
-} __attribute__((packed)) NEGOTIATE_MESSAGE, *PNEGOTIATE_MESSAGE;
+} __packed NEGOTIATE_MESSAGE, *PNEGOTIATE_MESSAGE;
 
 #define NTLMSSP_REVISION_W2K3 0x0F
 
@@ -121,7 +121,7 @@ typedef struct _CHALLENGE_MESSAGE {
 	SECURITY_BUFFER TargetInfoArray;
 	/* SECURITY_BUFFER for version info not present since we
 	   do not set the version is present flag */
-} __attribute__((packed)) CHALLENGE_MESSAGE, *PCHALLENGE_MESSAGE;
+} __packed CHALLENGE_MESSAGE, *PCHALLENGE_MESSAGE;
 
 typedef struct _AUTHENTICATE_MESSAGE {
 	__u8 Signature[sizeof(NTLMSSP_SIGNATURE)];
@@ -136,7 +136,7 @@ typedef struct _AUTHENTICATE_MESSAGE {
 	struct	ntlmssp_version Version;
 	/* SECURITY_BUFFER */
 	char UserString[];
-} __attribute__((packed)) AUTHENTICATE_MESSAGE, *PAUTHENTICATE_MESSAGE;
+} __packed AUTHENTICATE_MESSAGE, *PAUTHENTICATE_MESSAGE;
 
 /*
  * Size of the session key (crypto key encrypted with the password
diff --git a/fs/smb/client/rfc1002pdu.h b/fs/smb/client/rfc1002pdu.h
index ac82c2f3a4a2..f5b143088b90 100644
--- a/fs/smb/client/rfc1002pdu.h
+++ b/fs/smb/client/rfc1002pdu.h
@@ -33,17 +33,17 @@ struct rfc1002_session_packet {
 			__u8 calling_len;
 			__u8 calling_name[32];
 			__u8 scope2; /* null */
-		} __attribute__((packed)) session_req;
+		} __packed session_req;
 		struct {
 			__be32 retarget_ip_addr;
 			__be16 port;
-		} __attribute__((packed)) retarget_resp;
+		} __packed retarget_resp;
 		__u8 neg_ses_resp_error_code;
 		/* POSITIVE_SESSION_RESPONSE packet does not include trailer.
 		SESSION_KEEP_ALIVE packet also does not include a trailer.
 		Trailer for the SESSION_MESSAGE packet is SMB/CIFS header */
-	} __attribute__((packed)) trailer;
-} __attribute__((packed));
+	} __packed trailer;
+} __packed;
 
 /* Negative Session Response error codes */
 #define RFC1002_NOT_LISTENING_CALLED  0x80 /* not listening on called name */
diff --git a/fs/smb/common/smbacl.h b/fs/smb/common/smbacl.h
index a624ec9e4a14..70bba5ff7fc1 100644
--- a/fs/smb/common/smbacl.h
+++ b/fs/smb/common/smbacl.h
@@ -92,14 +92,14 @@ struct smb_ntsd {
 	__le32 gsidoffset;
 	__le32 sacloffset;
 	__le32 dacloffset;
-} __attribute__((packed));
+} __packed;
 
 struct smb_sid {
 	__u8 revision; /* revision level */
 	__u8 num_subauth;
 	__u8 authority[NUM_AUTHS];
 	__le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth] */
-} __attribute__((packed));
+} __packed;
 
 /* size of a struct smb_sid, sans sub_auth array */
 #define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
@@ -109,7 +109,7 @@ struct smb_acl {
 	__le16 size;
 	__le16 num_aces;
 	__le16 reserved;
-} __attribute__((packed));
+} __packed;
 
 struct smb_ace {
 	__u8 type; /* see above and MS-DTYP 2.4.4.1 */
@@ -117,6 +117,6 @@ struct smb_ace {
 	__le16 size;
 	__le32 access_req;
 	struct smb_sid sid; /* ie UUID of user or group who gets these perms */
-} __attribute__((packed));
+} __packed;
 
 #endif /* _COMMON_SMBACL_H */
-- 
2.43.0

