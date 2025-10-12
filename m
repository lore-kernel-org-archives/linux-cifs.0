Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CDA2ECD14;
	Sun, 12 Oct 2025 15:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.154.54.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282681; cv=none; b=bYUuCRDsjMzxvPcgFngIlPZ/8JVG4GXMuJ4QvQM+vFAEfEPfnOQE9CFsxNISBGh96s3j4OG1CLXOepf2QybjU1MMm1kH9T3eqSLQX0oas1/EUZnJE9lLsrSzAs7d5g/QAZZ6FtMH0hSscYCb/RHUt2vIbs21fVVGbi7J9Fui4CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282681; c=relaxed/simple;
	bh=oteY2DB6t8StVBkclNm0ZCXNfCcJGBmqqtuWOd8wqCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHF8o9s1YQkn/6SLdC/YK8MjWxJh+D44/QwUo8DEh21gSAoFX4J2GHgijGCby+w+nRAsOY9+95/Tn7GhbOuDyB54uz/RA7i/PiCAph1QMuLdhdLSVdiOca7C+MPbantTC/Bln45fSljTjKeY7heMEa+AY7ln0cQ+YYUWd7Gmt54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.154.54.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282605te752ffbc
X-QQ-Originating-IP: OuMNtN2W6jYOj+sLnw7J0GXxjKemOmM2JkzhJ2vAqT4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 5724110339125376165
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
Subject: [PATCH RESEND 09/22] smb: move copychunk definitions to common/smb2pdu.h
Date: Sun, 12 Oct 2025 23:22:34 +0800
Message-ID: <FAC03A5D78319886+20251012152247.2992573-10-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
References: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MpkFjxbZx3u4a8DtBarFgXIdGnWj0kzSXfM3bsYcMJI6fu3PiFJZzEI0
	UkCW0gLAmtgtwVQ/cOfMaM2ZzPVSkHYOfC5N9K8ZhP7vaLROijy1LNNHzCwmBDbRTa38P7c
	csi4x9SOzZnJBxI8Hc8ejESVyJHXCpIzHY1iP9ty/SnrOg1XsbgLdwHD2DM2Zg8WBg80I6e
	rTwGeStsscGzrz2FpUX0hlMdORB3T7AMk0S/0v3pXPkq3eP6vN/wBN3jraPA0NKZ+gEKBkQ
	uRf+rjrI1Ltu0zwiTkY0OJJ6sA0ASGIAZpAr7CcwZupaGVTOA7zDUiwpMNeylnyK/6gpicB
	j8ECIEmq/cH9gGDRJsCpzejjHYTpwGx1V+v9RmWHhGEli/xgD9FVG0yKA7dBKSnkC24IEZZ
	ynJBlx9MvFdFqApGzaWszeVpVsIQyEK1r/KiNRl6NwzxdRK0XU93hCL8cySNv8C57GCKBgF
	20WKcd64/wV1M4DcXyb7/swe4WHgryEtRHqK3KrEQdIqgJUMS5Bh+BLZUc9dizobobfYupx
	ZiqhgvZqyhGEbfPzaNsKiJ2LvRnFWzA16gFCdt8V6CdQkPVD3NXQZg1r/JBqLjzZigT1AeN
	jl6ViPaYJaXD/J5uJoCZf+zMQkj6z+yNkkF0tbS3KluaIgrShDxcZ6RkEBFFVhnnT1/mAIl
	K2UZ+ypreE4fDaP/9PTEsdWCDfvCX1nnqQ5hAqTFDpWXIz5kS6ukYSzqQXJVw8qzVoYSjd0
	NciLPpppZZ+AtRteX8hPEpqY7mPLw3wnSTir9Zn2LMF5wONQB38ft75WYpryyQhg6hlX3YX
	jmbsmnhorgoHeUeoiQDTVHq66XDXJ/4OC8vtQfQs7mJ9pCSb6KJ3iraIp4tnufx2fgtnRpJ
	Bt19R/r+0YMaCrtr3oYxib7kCsnlqQOEJmDdRt30802ULUqKaZk21bpefaM3TbxZCsux/D+
	S8JfS+emheETkAQVlVVYCJGkrZDZBLw+gxJev6q6Ubsb39mVDjFUhD49h7e0BZXwJu0+GUb
	O1LXts5ID/FDRYT6rBlsH30k38WzvlSVtqrKWymrnfWo9jAjLGeKk5dJ6nxuFl8CdB9GbRC
	rGxZ0ZRJr14U1964dvNl/b+6RtU39RsDg==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Rename 3 places:

  - copychunk_ioctl -> copychunk_ioctl_req
  - copychunk -> srv_copychunk
  - server: ResumeKey -> SourceKeyU64

Merge the struct members of the server and the client, then move duplicate
definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/cifspdu.h |  8 --------
 fs/smb/client/smb2ops.c |  6 +++---
 fs/smb/client/smb2pdu.h | 24 ------------------------
 fs/smb/common/smb2pdu.h | 29 +++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c |  4 ++--
 fs/smb/server/smb2pdu.h | 20 --------------------
 6 files changed, 34 insertions(+), 57 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index d9cf7db0ac35..c86a329e5822 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1323,14 +1323,6 @@ typedef struct smb_com_ntransact_rsp {
 	/* parms and data follow */
 } __attribute__((packed)) NTRANSACT_RSP;
 
-/* See MS-SMB 2.2.7.2.1.1 */
-struct srv_copychunk {
-	__le64 SourceOffset;
-	__le64 DestinationOffset;
-	__le32 CopyLength;
-	__u32  Reserved;
-} __packed;
-
 typedef struct smb_com_transaction_ioctl_req {
 	struct smb_hdr hdr;	/* wct = 23 */
 	__u8 MaxSetupCount;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e90ca77d2ac7..ea9709d81851 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1524,7 +1524,7 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 static int
 SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid,
-		     struct copychunk_ioctl *pcchunk)
+		     struct copychunk_ioctl_req *pcchunk)
 {
 	int rc;
 	unsigned int ret_data_len;
@@ -1857,10 +1857,10 @@ smb2_copychunk_range(const unsigned int xid,
 {
 	int rc = 0;
 	unsigned int ret_data_len = 0;
-	struct copychunk_ioctl *cc_req = NULL;
+	struct copychunk_ioctl_req *cc_req = NULL;
 	struct copychunk_ioctl_rsp *cc_rsp = NULL;
 	struct cifs_tcon *tcon;
-	struct copychunk *chunk;
+	struct srv_copychunk *chunk;
 	u32 chunks, chunk_count, chunk_bytes;
 	u32 copy_bytes, copy_bytes_left;
 	u32 chunks_written, bytes_written;
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 0be63c00f848..9b5880e60a4e 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -191,36 +191,12 @@ struct crt_sd_ctxt {
 	struct smb3_sd sd;
 } __packed;
 
-
-#define COPY_CHUNK_RES_KEY_SIZE	24
 struct resume_key_req {
 	char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
 	__le32	ContextLength;	/* MBZ */
 	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
-
-struct copychunk {
-	__le64 SourceOffset;
-	__le64 TargetOffset;
-	__le32 Length;
-	__le32 Reserved;
-} __packed;
-
-/* this goes in the ioctl buffer when doing a copychunk request */
-struct copychunk_ioctl {
-	char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32 ChunkCount;
-	__le32 Reserved;
-	struct copychunk Chunks[];
-} __packed;
-
-struct copychunk_ioctl_rsp {
-	__le32 ChunksWritten;
-	__le32 ChunkBytesWritten;
-	__le32 TotalBytesWritten;
-} __packed;
-
 /* See MS-FSCC 2.3.29 and 2.3.30 */
 struct get_retrieval_pointer_count_req {
 	__le64 StartingVcn; /* virtual cluster number (signed) */
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index b01114108d23..857e6a577e84 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1392,6 +1392,35 @@ struct smb2_ioctl_req {
 	__u8   Buffer[];
 } __packed;
 
+/* See MS-SMB2 2.2.31.1.1 */
+struct srv_copychunk {
+	__le64 SourceOffset;
+	__le64 TargetOffset;
+	__le32 Length;
+	__le32 Reserved;
+} __packed;
+
+#define COPY_CHUNK_RES_KEY_SIZE	24
+
+/* See MS-SMB2 2.2.31.1 */
+/* this goes in the ioctl buffer when doing a copychunk request */
+struct copychunk_ioctl_req {
+	union {
+		char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
+		__le64 SourceKeyU64[3];
+	};
+	__le32 ChunkCount;
+	__le32 Reserved;
+	struct srv_copychunk Chunks[] __counted_by_le(ChunkCount);
+} __packed;
+
+/* See MS-SMB2 2.2.32.1 */
+struct copychunk_ioctl_rsp {
+	__le32 ChunksWritten;
+	__le32 ChunkBytesWritten;
+	__le32 TotalBytesWritten;
+} __packed;
+
 struct smb2_ioctl_rsp {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index dd6f1375a833..846cca45195b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7757,11 +7757,11 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	}
 
 	src_fp = ksmbd_lookup_foreign_fd(work,
-					 le64_to_cpu(ci_req->ResumeKey[0]));
+					 le64_to_cpu(ci_req->SourceKeyU64[0]));
 	dst_fp = ksmbd_lookup_fd_slow(work, volatile_id, persistent_id);
 	ret = -EINVAL;
 	if (!src_fp ||
-	    src_fp->persistent_id != le64_to_cpu(ci_req->ResumeKey[1])) {
+	    src_fp->persistent_id != le64_to_cpu(ci_req->SourceKeyU64[1])) {
 		rsp->hdr.Status = STATUS_OBJECT_NAME_NOT_FOUND;
 		goto out;
 	}
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 5a76b706ccd9..eecd1f1f5505 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -157,26 +157,6 @@ struct resume_key_ioctl_rsp {
 	__u8 Context[4]; /* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
-struct srv_copychunk {
-	__le64 SourceOffset;
-	__le64 TargetOffset;
-	__le32 Length;
-	__le32 Reserved;
-} __packed;
-
-struct copychunk_ioctl_req {
-	__le64 ResumeKey[3];
-	__le32 ChunkCount;
-	__le32 Reserved;
-	struct srv_copychunk Chunks[] __counted_by_le(ChunkCount);
-} __packed;
-
-struct copychunk_ioctl_rsp {
-	__le32 ChunksWritten;
-	__le32 ChunkBytesWritten;
-	__le32 TotalBytesWritten;
-} __packed;
-
 struct file_sparse {
 	__u8	SetSparse;
 } __packed;
-- 
2.43.0

