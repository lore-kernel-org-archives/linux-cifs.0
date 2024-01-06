Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEDA101E3
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jan 2024 23:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="p25RYI1u"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704582331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JRhjFw8YBYVIRlMqPflU8xZzCZ1+enrUh24U1eFTbeg=;
	b=p25RYI1u+SYK710O1W43qHvGiSCqxOsaPqj6+a+k/j4EPtB1puChUaRz0sYXPqTnQvY53o
	y98Dy7MPjgi6Ok3anvzlnL3juXthaKIsn8ICBupPYOy5FSwrWgqA2Ggd1yOo7LYsrq1X/y
	A49ezY6gowg8zbFlv3Xf/EGx3n8TbpJjkwGb5U2BGpQbmRYvsf5g3vmdlhcGyA7CVTbws/
	i7VZtn1xj6r46Dd+Z9kCbs1/dPTe5BVBzmeY7mdhA5uUM2De6QE1VSYR7nF0YmLShAhmnv
	C139Zz4u61DErwsQZsiIRS/gmHzOyOy5YupWYE3ZzmxYmCq8Hg2PSl7sf6mKGw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1704582331; a=rsa-sha256;
	cv=none;
	b=c0ieiMsmBi7DIE2sj0rR/2ACTh0/4X3NBRqdResEnJccyvhn+soH2Q6MrXmSntyacm80E3
	2I52yEeKgsgp+P16KJk7SENBvZR4IX51bo+qMvjNrv2Y01qu8DOa5801GMgIotqcM9rVzJ
	enXue9oGbWIHxUCENAajMlUC2E5TjjE9q9XoEQUO16G4NXJsKZChge9tugi9pzz4qf4Dl9
	KzEsc7JgRLDnHmbanKRN3m9VVEZlTjRzy3Wn8w/00TRZ+8wBlrVe0EzdypcmexBG7iXGI/
	Nu9UmWhz/EE2TLkKQU8P5kQSDJhrHqPMu/5PRIf8VP1OPttchpotC/OJ6rTdBw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704582331; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JRhjFw8YBYVIRlMqPflU8xZzCZ1+enrUh24U1eFTbeg=;
	b=HbSuMu4QvYukwIot5o0rPcnoR+peRJObNcDebHn+s9XGvcmL0LKWLjF9+IAIUCt00/F8z5
	Pb3ZftlD91ntC2EV++CWTVTRNqgCplZ8B/UP6wAk7vQgK1urYjb6FnGCGXHBsaal2eEAFM
	GhYPym5pTttZvPF9y2mlcdVu/4n4kQjkxtTKapmeF8T4rdoZ4MaPiFTtzJyAvw1zvge1WY
	lSy5ZaRO0vS1DhYuUFgIE1L6XRW/sNPJycfXZer4iRTZbZKBPY21WYvc8N96FdSpUlHdYh
	t2afARnZ3lJ5oPj4URgYm7SzZUIixWGVbRYqDoh8r1XhDYYy5VGu/bwNIfadEQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/2] cifs: get rid of dup length check in parse_reparse_point()
Date: Sat,  6 Jan 2024 20:05:18 -0300
Message-ID: <20240106230518.29920-2-pc@manguebit.com>
In-Reply-To: <20240106230518.29920-1-pc@manguebit.com>
References: <20240106230518.29920-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_compound_op(SMB2_OP_GET_REPARSE) already checks if ioctl response
has a valid reparse data buffer's length, so there's no need to check
it again in parse_reparse_point().

In order to get rid of duplicate check, validate reparse data buffer's
length also in cifs_query_reparse_point().

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifssmb.c | 14 ++++++++++++--
 fs/smb/client/smb2ops.c | 12 ------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index e9e33b0b3ac4..01e89070df5a 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2700,11 +2700,12 @@ int cifs_query_reparse_point(const unsigned int xid,
 			     u32 *tag, struct kvec *rsp,
 			     int *rsp_buftype)
 {
+	struct reparse_data_buffer *buf;
 	struct cifs_open_parms oparms;
 	TRANSACT_IOCTL_REQ *io_req = NULL;
 	TRANSACT_IOCTL_RSP *io_rsp = NULL;
 	struct cifs_fid fid;
-	__u32 data_offset, data_count;
+	__u32 data_offset, data_count, len;
 	__u8 *start, *end;
 	int io_rsp_len;
 	int oplock = 0;
@@ -2774,7 +2775,16 @@ int cifs_query_reparse_point(const unsigned int xid,
 		goto error;
 	}
 
-	*tag = le32_to_cpu(((struct reparse_data_buffer *)start)->ReparseTag);
+	data_count = le16_to_cpu(io_rsp->ByteCount);
+	buf = (struct reparse_data_buffer *)start;
+	len = sizeof(*buf);
+	if (data_count < len ||
+	    data_count < le16_to_cpu(buf->ReparseDataLength) + len) {
+		rc = -EIO;
+		goto error;
+	}
+
+	*tag = le32_to_cpu(buf->ReparseTag);
 	rsp->iov_base = io_rsp;
 	rsp->iov_len = io_rsp_len;
 	*rsp_buftype = CIFS_LARGE_BUFFER;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 938d51a88dd6..01a5bd7e6a30 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2947,18 +2947,6 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			bool unicode, struct cifs_open_info_data *data)
 {
-	if (plen < sizeof(*buf)) {
-		cifs_dbg(VFS, "%s: reparse buffer is too small. Must be at least 8 bytes but was %d\n",
-			 __func__, plen);
-		return -EIO;
-	}
-
-	if (plen < le16_to_cpu(buf->ReparseDataLength) + sizeof(*buf)) {
-		cifs_dbg(VFS, "%s: invalid reparse buf length: %d\n",
-			 __func__, plen);
-		return -EIO;
-	}
-
 	data->reparse.buf = buf;
 
 	/* See MS-FSCC 2.1.2 */
-- 
2.43.0

