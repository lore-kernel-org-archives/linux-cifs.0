Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416002ED16C;
	Sun, 12 Oct 2025 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286060; cv=none; b=mieiqMklvAl7D/k4WpAiquxX75lpqdVWHyTHwyIvSNSuzbdrdvJnQD5MGAINjiQ2yAD5XTsbL4grgteDJxMzFIgW+lbTgDTlN2paiMZIpchU5U/l2EwTztaktenNWtWXKi0wPajjSjtLu+0ogmtK2U6hCeJ0Fhk2zsqahoVOhyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286060; c=relaxed/simple;
	bh=qKW1ea93q6vZqFG50LDILT19TfQEPrMuEhgjiQtZhBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFftIGyZhPf9FpZ8VivkNQGyCK3wpj0q5fd4+zZ12S5Z3gjAWOqeZCloCLWxl46SxYolX4WSiSo+XWvyuIzUg6v+hcchzDoFKxIVgpUI7vSvl0W79lZIK1rRLPk2la6hhrzHi33PqPw1oQjUMgYdsb+nTJGT4k1S6ZaITf8vtZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285923t493bab1a
X-QQ-Originating-IP: bRq+z7NaAExQdTGteobaTLsJLwnYh6SVVzHT1c/Z9a0=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8115490951391816187
From: chenxiaosong@chenxiaosong.com
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 14/22] smb: move SMB frame definitions to common/cifspdu.h
Date: Mon, 13 Oct 2025 00:17:41 +0800
Message-ID: <04548991C0A16454+20251012161749.2994033-15-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NNpgjv0kGmhMDtu1KrWwyaO6398Wv2RTQVSLymyEJfotBbe2NZ+uh4+m
	qfaEtpI5qeVicABHAdKLrpjiapyGs1w4J4kW66tVSVDxOPKMjh6kuMCrhPGwHKgRt60wVpe
	m9Mo/h3G7ERixcqMQkLnJaHnADHj2QgGHfdSSGLciTGxxQni6hJXuDwJLbA4WzqduHBxdqV
	vnPxEIFHDALW+oSZVyBs5ej+Awx+QCDaPpifX1XCfUMZRzqAXm4cZU17pgc5qvIAVVJ1H9e
	19g+oSz7i66Dh9VIN48zSA1yxi2Q+6u64/hpHHMZoQa/St7v1kyJtR4Vfq4+/KcdIS8lImV
	YHjlcgu8uX3Uc4HJ9ZVVzqvTLfSHFPvvVA/Su3XshYYx7l8GIUxNfXS0vrmYEn1bRwCZqrf
	b2ZFLyF7MyLqxkoIkEGoRFHkrl9tgRvhJF7D3abv1wyezpmPneHsmSrw/WqB8l/1OiedGmQ
	VYpgtPcZZmzeaRJci4mUNhyX4vXWwhktFkVoxYTx4E1QOe9GjV23fZPrJIyqDQ2YZheWewd
	f5DgBHg+28QNRO2RmRGHAUvFwfp8h9Lt/iYr7rnvMVoEqF77CmcqY8pgPxwuj30KFhbiEF/
	FqOWixSaSS1rh71Krnta9eiRM2+8TK4ZKEf4Gagtwv7N3+yL4xv9u8NeJ6Otg32eTgrnzjz
	ksVu7EdG1PuQy41hvxOiiC2bSc1e4bpCvI0Y0T6qtnqt5XoD5Kc03sACmgbK9AaO8DM7Ay2
	AqVxtnmQDXRAvDW2J8ns7zIdV7n0CuNiHwU7/KkTBhDHqaX/PachiOwF3yUACD6/DzCoiUJ
	lEQco9z/klzqyX+dCuCfa4KYm5Gohm/KGfaCNKGpUpw8KOVVRYdJ1KSMbTAUylowK7rJmf5
	+SOeapLVtBHYObRusHTE15D/49671Cj5Zpj8s73vcc2VP/SML9NOSse/SXAgjdWb0Kg40Sw
	JD6QL9V8KrICagi4HEumUOYg+pVjUrNFtM2297KIMaEMLSBhpluAQ+BJzRKfYlCTIrsIXLi
	ZLhYlEZMM71tpzusz3u11zAGX21YjIL5ONKFTU8Uk5Vftlbpfk5bdXe04yQ5ijj44Ymgz9Y
	6Wrr2LoPtYr
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The client and server have different struct negotiate_rsp, perhaps in the
future we can change them to be the same.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 58 ----------------------------------
 fs/smb/client/cifssmb.c    |  4 +--
 fs/smb/common/cifspdu.h    | 65 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb_common.c | 10 +++---
 fs/smb/server/smb_common.h | 14 --------
 5 files changed, 72 insertions(+), 79 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index a0883b1fda16..07eb821654e1 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -266,64 +266,6 @@ put_bcc(__u16 count, struct smb_hdr *hdr)
  */
 #define MAX_PATHCONF 256
 
-/*
- *  SMB frame definitions  (following must be packed structs)
- *  See the SNIA CIFS Specification for details.
- *
- *  The Naming convention is the lower case version of the
- *  smb command code name for the struct and this is typedef to the
- *  uppercase version of the same name with the prefix SMB_ removed
- *  for brevity.  Although typedefs are not commonly used for
- *  structure definitions in the Linux kernel, their use in the
- *  CIFS standards document, which this code is based on, may
- *  make this one of the cases where typedefs for structures make
- *  sense to improve readability for readers of the standards doc.
- *  Typedefs can always be removed later if they are too distracting
- *  and they are only used for the CIFSs PDUs themselves, not
- *  internal cifs vfs structures
- *
- */
-
-typedef struct negotiate_req {
-	struct smb_hdr hdr;	/* wct = 0 */
-	__le16 ByteCount;
-	unsigned char DialectsArray[];
-} __attribute__((packed)) NEGOTIATE_REQ;
-
-#define MIN_TZ_ADJ (15 * 60) /* minimum grid for timezones in seconds */
-
-#define READ_RAW_ENABLE 1
-#define WRITE_RAW_ENABLE 2
-#define RAW_ENABLE (READ_RAW_ENABLE | WRITE_RAW_ENABLE)
-#define SMB1_CLIENT_GUID_SIZE (16)
-typedef struct negotiate_rsp {
-	struct smb_hdr hdr;	/* wct = 17 */
-	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
-	__u8 SecurityMode;
-	__le16 MaxMpxCount;
-	__le16 MaxNumberVcs;
-	__le32 MaxBufferSize;
-	__le32 MaxRawSize;
-	__le32 SessionKey;
-	__le32 Capabilities;	/* see below */
-	__le32 SystemTimeLow;
-	__le32 SystemTimeHigh;
-	__le16 ServerTimeZone;
-	__u8 EncryptionKeyLength;
-	__u16 ByteCount;
-	union {
-		/* cap extended security off */
-		DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
-		/* followed by Domain name - if extended security is off */
-		/* followed by 16 bytes of server GUID */
-		/* then security blob if cap_extended_security negotiated */
-		struct {
-			unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
-			unsigned char SecurityBlob[];
-		} __attribute__((packed)) extended_response;
-	} __attribute__((packed)) u;
-} __attribute__((packed)) NEGOTIATE_RSP;
-
 /* SecurityMode bits */
 #define SECMODE_USER          0x01	/* off indicates share level security */
 #define SECMODE_PW_ENCRYPT    0x02
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 9a346d67e298..e37a00c9251c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -361,7 +361,7 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
 }
 
 static int
-decode_ext_sec_blob(struct cifs_ses *ses, NEGOTIATE_RSP *pSMBr)
+decode_ext_sec_blob(struct cifs_ses *ses, CLIENT_NEGOTIATE_RSP *pSMBr)
 {
 	int	rc = 0;
 	u16	count;
@@ -420,7 +420,7 @@ CIFSSMBNegotiate(const unsigned int xid,
 		 struct TCP_Server_Info *server)
 {
 	NEGOTIATE_REQ *pSMB;
-	NEGOTIATE_RSP *pSMBr;
+	CLIENT_NEGOTIATE_RSP *pSMBr;
 	int rc = 0;
 	int bytes_returned;
 	int i;
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 59e5425cdc8d..1109c20f7bf8 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -256,6 +256,71 @@ struct smb_hdr {
 	__u8 WordCount;
 } __attribute__((packed));
 
+/*
+ *  SMB frame definitions  (following must be packed structs)
+ *  See the SNIA CIFS Specification for details.
+ *
+ *  The Naming convention is the lower case version of the
+ *  smb command code name for the struct and this is typedef to the
+ *  uppercase version of the same name with the prefix SMB_ removed
+ *  for brevity.  Although typedefs are not commonly used for
+ *  structure definitions in the Linux kernel, their use in the
+ *  CIFS standards document, which this code is based on, may
+ *  make this one of the cases where typedefs for structures make
+ *  sense to improve readability for readers of the standards doc.
+ *  Typedefs can always be removed later if they are too distracting
+ *  and they are only used for the CIFSs PDUs themselves, not
+ *  internal cifs vfs structures
+ *
+ */
+
+typedef struct negotiate_req {
+	struct smb_hdr hdr;	/* wct = 0 */
+	__le16 ByteCount;
+	unsigned char DialectsArray[];
+} __attribute__((packed)) NEGOTIATE_REQ;
+
+#define MIN_TZ_ADJ (15 * 60) /* minimum grid for timezones in seconds */
+
+#define READ_RAW_ENABLE 1
+#define WRITE_RAW_ENABLE 2
+#define RAW_ENABLE (READ_RAW_ENABLE | WRITE_RAW_ENABLE)
+#define SMB1_CLIENT_GUID_SIZE (16)
+
+typedef struct client_negotiate_rsp {
+	struct smb_hdr hdr;	/* wct = 17 */
+	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
+	__u8 SecurityMode;
+	__le16 MaxMpxCount;
+	__le16 MaxNumberVcs;
+	__le32 MaxBufferSize;
+	__le32 MaxRawSize;
+	__le32 SessionKey;
+	__le32 Capabilities;	/* see below */
+	__le32 SystemTimeLow;
+	__le32 SystemTimeHigh;
+	__le16 ServerTimeZone;
+	__u8 EncryptionKeyLength;
+	__u16 ByteCount;
+	union {
+		/* cap extended security off */
+		DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
+		/* followed by Domain name - if extended security is off */
+		/* followed by 16 bytes of server GUID */
+		/* then security blob if cap_extended_security negotiated */
+		struct {
+			unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
+			unsigned char SecurityBlob[];
+		} __attribute__((packed)) extended_response;
+	} __attribute__((packed)) u;
+} __attribute__((packed)) CLIENT_NEGOTIATE_RSP;
+
+typedef struct server_negotiate_rsp {
+	struct smb_hdr hdr;     /* wct = 17 */
+	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
+	__le16 ByteCount;
+} __attribute__((packed)) SERVER_NEGOTIATE_RSP;
+
 /* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
 #define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
 #define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index b23203a1c286..e1e89bc1c43f 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -280,13 +280,13 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
 
 	proto = *(__le32 *)((struct smb_hdr *)buf)->Protocol;
 	if (proto == SMB1_PROTO_NUMBER) {
-		struct smb_negotiate_req *req;
+		struct negotiate_req *req;
 
-		req = (struct smb_negotiate_req *)buf;
+		req = (struct negotiate_req *)buf;
 		if (le16_to_cpu(req->ByteCount) < 2)
 			goto err_out;
 
-		if (offsetof(struct smb_negotiate_req, DialectsArray) - 4 +
+		if (offsetof(struct negotiate_req, DialectsArray) - 4 +
 			le16_to_cpu(req->ByteCount) > smb_buf_length) {
 			goto err_out;
 		}
@@ -572,12 +572,12 @@ static int __smb2_negotiate(struct ksmbd_conn *conn)
 
 static int smb_handle_negotiate(struct ksmbd_work *work)
 {
-	struct smb_negotiate_rsp *neg_rsp = work->response_buf;
+	struct server_negotiate_rsp *neg_rsp = work->response_buf;
 
 	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
 
 	if (ksmbd_iov_pin_rsp(work, (void *)neg_rsp + 4,
-			      sizeof(struct smb_negotiate_rsp) - 4))
+			      sizeof(struct server_negotiate_rsp) - 4))
 		return -ENOMEM;
 
 	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 90015cd8fe4e..a5dd656c36f1 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -56,20 +56,6 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
-#define SMB1_CLIENT_GUID_SIZE		(16)
-
-struct smb_negotiate_req {
-	struct smb_hdr hdr;     /* wct = 0 */
-	__le16 ByteCount;
-	unsigned char DialectsArray[];
-} __packed;
-
-struct smb_negotiate_rsp {
-	struct smb_hdr hdr;     /* wct = 17 */
-	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
-	__le16 ByteCount;
-} __packed;
-
 struct filesystem_attribute_info {
 	__le32 Attributes;
 	__le32 MaxPathNameComponentLength;
-- 
2.43.0

