Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1545B3C3C03
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391763; cv=none; b=XkBpkeW1tEw401G16ZgMX4vboNrYbOYFQAof6uV5cYuHBeSu83U0eXXplswMfbFd+Fsgmuot0L1J+SpciLC5WRgNAwaWOxpJTSrCdDKDobz3cCmhDsjFdnEFTDkeOac3OGRrBQAMPozN/sczJnD0ChC7ryPiMQ+A0VU46cF4AxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391763; c=relaxed/simple;
	bh=lQ5DpuALbgTsXOKgwn74AyoacGYenQNBVH9tON40P7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlyoBa+9+ZUu42q6WYtsjlQTCjSJ+64sXM9Sb/kn5x8W/JDugBiK/hh9NXoXxHYjYuIUSsGW8q+JBtfYFV+fL6ImT3nAHS6YufiKfCG7eolDevI2lbNZhRqw5cIBzTDqTrT4WU+1gv9/3hew3MOeWlyi7/+Ocon9gecQhJeXDac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=coQOvt62; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="coQOvt62"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b150559bso91545985e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391760; x=1777996560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycsCVSVbXnO73EBGsa9NkUp/8I4UNQARemQ6U5oYXqA=;
        b=coQOvt62SFvhOkRoe9RXDRqvX+nU6A+7SWcF2VqKb0PsDoeAAdl70+ynTtXtByTGh9
         fvv+wq9B8Ge084X1ECpM+eV/5o7Cuf3y6Z3bxtYTdBHD95v3WUz9vSvPKqNQEa0CF/Mr
         n6Xr1CHCUVSpd/ruS64ln+VZdb3AoR5iCycbcMmpzgjz0Wwj24/QQxQzG67izNLC6Zmw
         qSuWLrndsp/kaa9sjQhr4uPPG3ysB14QfFQALfq3DWn2QH6U5EPpXJELVIMIM62y2/mq
         EVpiX2/oDLbn53QSR5QgveG4hWy52O/ILpHLPO3cJIGyhZKAMH5isRIj8ynZyuENDsX5
         VB4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391760; x=1777996560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ycsCVSVbXnO73EBGsa9NkUp/8I4UNQARemQ6U5oYXqA=;
        b=f4h1+wL9HPKHzqvoacmufMnzjWZb3+WWEOTqKt5i5TXZ5Y2urJXa4hxxTZz0MROG4p
         xYFOftUx4vaPdt99Et2O00mVJJeEz2XyuVnjNjGadL+a/yvcK9siMH07TEEu83h/Js2R
         cWh1sXYqfloLzcwGbdu33DU8zIUnrPLqlsLXON7lyc/IFR+8lfPt5zKVuPy2Rnsm0kCD
         c/mQ7gbc++ADkyYuenu3VOq5oUbGoHF6ZTTXgrHLY938H47wKzCCcJs6ge0HE9/U0hX0
         cKKRiUK2wPi0XrBX0Nv2NvvqezY+NRUhWIHHgCSO91nEC5LG7higCUiX8StLjGTi6Yrc
         2uaA==
X-Gm-Message-State: AOJu0YyPNcCXiWJeiQeOYg0HNQHE17StY2Q0vjZJYse/XetXJ/1fItC0
	+yiaG9QSOUsIaUddkqwAteg98e0dL0j4vNmm216gMTO/QOAJI5LxK0/ze2bTQ4Qf5zzw2TD4SVH
	h6dBi2W8xhQ==
X-Gm-Gg: AeBDiev0Z1YiwM0LCJQyAoiQpVO1CfxsLTt0/ciLy3eTvGK9I3Yf32802Ar0WTzUCQC
	2gRcomX7JlUJsdtf08TOoJ3nlr5psrKAY4t0GnldEIyRT0jqKcPwC5iAomSftm25oQu1gp1oeSX
	/4lgYhunIzWTKxx7Aab3ntvbl1AoFgzkxGFN2RjQStVcJfxrDmyleyoIiPa9DfFXvySifXkQacQ
	jy0gzJZGIgvrIc+MzXQrqeresO3aGjcUqf3gL3bFvbaqVOeZwHBIbCExkIY39S4gBmqUL0AX3GC
	ThCMEQp7h6hPLtcm86H7GFDZw8af1ynf2BhBtuPk5k6A/++AJ92OuF5btmMrYiOW6a8FEcdguPV
	qnAOcmKcSevjpsvM7uqndiREE7oVvJWo6G5SaAMvVq/MiUgD4FVSWX2+t5aVT7FSWPvGO43EIdd
	0K9s/Yx4PzWdQkheyqspnDdoLvPolh+67IRPD7Or1fBHcb
X-Received: by 2002:a05:600c:1d8c:b0:48a:568f:ae82 with SMTP id 5b1f17b1804b1-48a77adfebfmr65313715e9.10.1777391760215;
        Tue, 28 Apr 2026 08:56:00 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a775f56fcsm23475685e9.25.2026.04.28.08.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:55:59 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	linkinjeon@kernel.org,
	metze@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 02/11] smb: client: refactor negotiate context assembly
Date: Tue, 28 Apr 2026 12:55:40 -0300
Message-ID: <20260428155542.226234-3-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428155542.226234-1-henrique.carvalho@suse.com>
References: <20260428155542.226234-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce struct neg_ctx, smb2_neg_context_len() and add_context() to
handle alignment, pointer advancement, and counter increment in one
place, eliminating repetitive code.

Also fix missing ALIGN() for posix negotiate context.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2pdu.c | 106 +++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 50 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index cddb1ae04e83..bac88a612d5d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -618,7 +618,15 @@ static int smb2_ioctl_req_init(u32 opcode, struct cifs_tcon *tcon,
 
 /* For explanation of negotiate contexts see MS-SMB2 section 2.2.3.1 */
 
-static void
+static inline unsigned int
+smb2_neg_context_len(const void *p)
+{
+	const struct smb2_neg_context *ctx = p;
+
+	return sizeof(*ctx) + le16_to_cpu(ctx->DataLength);
+}
+
+static unsigned int
 build_preauth_ctxt(struct smb2_preauth_neg_context *pneg_ctxt)
 {
 	pneg_ctxt->ContextType = SMB2_PREAUTH_INTEGRITY_CAPABILITIES;
@@ -627,9 +635,10 @@ build_preauth_ctxt(struct smb2_preauth_neg_context *pneg_ctxt)
 	pneg_ctxt->SaltLength = cpu_to_le16(SMB311_SALT_SIZE);
 	get_random_bytes(pneg_ctxt->Salt, SMB311_SALT_SIZE);
 	pneg_ctxt->HashAlgorithms = SMB2_PREAUTH_INTEGRITY_SHA512;
+	return smb2_neg_context_len(pneg_ctxt);
 }
 
-static void
+static unsigned int
 build_compression_ctxt(struct smb2_compression_capabilities_context *pneg_ctxt)
 {
 	pneg_ctxt->ContextType = SMB2_COMPRESSION_CAPABILITIES;
@@ -640,13 +649,13 @@ build_compression_ctxt(struct smb2_compression_capabilities_context *pneg_ctxt)
 	pneg_ctxt->CompressionAlgorithms[0] = SMB3_COMPRESS_LZ77;
 	pneg_ctxt->CompressionAlgorithms[1] = SMB3_COMPRESS_LZ77_HUFF;
 	pneg_ctxt->CompressionAlgorithms[2] = SMB3_COMPRESS_LZNT1;
+	return smb2_neg_context_len(pneg_ctxt);
 }
 
 static unsigned int
 build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
 {
-	unsigned int ctxt_len = sizeof(struct smb2_signing_capabilities);
-	unsigned short num_algs = 1; /* number of signing algorithms sent */
+	const unsigned short num_algs = 1; /* number of signing algorithms sent */
 
 	pneg_ctxt->ContextType = SMB2_SIGNING_CAPABILITIES;
 	/*
@@ -658,13 +667,11 @@ build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
 	pneg_ctxt->SigningAlgorithmCount = cpu_to_le16(num_algs);
 	pneg_ctxt->SigningAlgorithms[0] = cpu_to_le16(SIGNING_ALG_AES_CMAC);
 
-	ctxt_len += sizeof(__le16) * num_algs;
-	ctxt_len = ALIGN(ctxt_len, 8);
-	return ctxt_len;
+	return smb2_neg_context_len(pneg_ctxt);
 	/* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA256 */
 }
 
-static void
+static unsigned int
 build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
 {
 	pneg_ctxt->ContextType = SMB2_ENCRYPTION_CAPABILITIES;
@@ -684,6 +691,7 @@ build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
 		pneg_ctxt->Ciphers[0] = SMB2_ENCRYPTION_AES128_GCM;
 		pneg_ctxt->Ciphers[1] = SMB2_ENCRYPTION_AES128_CCM;
 	}
+	return smb2_neg_context_len(pneg_ctxt);
 }
 
 static unsigned int
@@ -695,11 +703,11 @@ build_netname_ctxt(struct smb2_netname_neg_context *pneg_ctxt, char *hostname)
 
 	/* copy up to max of first 100 bytes of server name to NetName field */
 	pneg_ctxt->DataLength = cpu_to_le16(2 * cifs_strtoUTF16(pneg_ctxt->NetName, hostname, 100, cp));
-	/* context size is DataLength + minimal smb2_neg_context */
-	return ALIGN(le16_to_cpu(pneg_ctxt->DataLength) + sizeof(struct smb2_neg_context), 8);
+
+	return smb2_neg_context_len(pneg_ctxt);
 }
 
-static void
+static unsigned int
 build_posix_ctxt(struct smb2_posix_neg_context *pneg_ctxt)
 {
 	pneg_ctxt->ContextType = SMB2_POSIX_EXTENSIONS_AVAILABLE;
@@ -721,15 +729,31 @@ build_posix_ctxt(struct smb2_posix_neg_context *pneg_ctxt)
 	pneg_ctxt->Name[13] = 0x8B;
 	pneg_ctxt->Name[14] = 0xCD;
 	pneg_ctxt->Name[15] = 0x7C;
+	return smb2_neg_context_len(pneg_ctxt);
+}
+
+struct neg_ctx {
+	char *pos;
+	unsigned int len;
+	unsigned int cnt;
+};
+
+static inline void
+add_context(struct neg_ctx *nc, unsigned int ctx_len)
+{
+	unsigned int aligned_len = ALIGN(ctx_len, 8);
+
+	nc->pos += aligned_len;
+	nc->len += aligned_len;
+	nc->cnt++;
 }
 
 static void
 assemble_neg_contexts(struct smb2_negotiate_req *req,
 		      struct TCP_Server_Info *server, unsigned int *total_len)
 {
-	unsigned int ctxt_len, neg_context_count;
+	struct neg_ctx nc;
 	struct TCP_Server_Info *pserver;
-	char *pneg_ctxt;
 	char *hostname;
 
 	if (*total_len > 200) {
@@ -744,18 +768,15 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	 */
 	*total_len = ALIGN(*total_len, 8);
 
-	pneg_ctxt = (*total_len) + (char *)req;
 	req->NegotiateContextOffset = cpu_to_le32(*total_len);
 
-	build_preauth_ctxt((struct smb2_preauth_neg_context *)pneg_ctxt);
-	ctxt_len = ALIGN(sizeof(struct smb2_preauth_neg_context), 8);
-	*total_len += ctxt_len;
-	pneg_ctxt += ctxt_len;
+	nc.pos = (*total_len) + (char *)req;
+	nc.len = *total_len;
+	nc.cnt = 0;
+
+	add_context(&nc, build_preauth_ctxt((struct smb2_preauth_neg_context *)nc.pos));
 
-	build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt);
-	ctxt_len = ALIGN(sizeof(struct smb2_encryption_neg_context), 8);
-	*total_len += ctxt_len;
-	pneg_ctxt += ctxt_len;
+	add_context(&nc, build_encrypt_ctxt((struct smb2_encryption_neg_context *)nc.pos));
 
 	/*
 	 * secondary channels don't have the hostname field populated
@@ -764,41 +785,26 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
 	cifs_server_lock(pserver);
 	hostname = pserver->hostname;
-	if (hostname && (hostname[0] != 0)) {
-		ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
-					      hostname);
-		*total_len += ctxt_len;
-		pneg_ctxt += ctxt_len;
-		neg_context_count = 3;
-	} else
-		neg_context_count = 2;
+	if (hostname && (hostname[0] != 0))
+		add_context(&nc,
+			    build_netname_ctxt((struct smb2_netname_neg_context *)nc.pos,
+					       hostname));
 	cifs_server_unlock(pserver);
 
-	build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
-	*total_len += sizeof(struct smb2_posix_neg_context);
-	pneg_ctxt += sizeof(struct smb2_posix_neg_context);
-	neg_context_count++;
+	add_context(&nc, build_posix_ctxt((struct smb2_posix_neg_context *)nc.pos));
 
-	if (server->compression.requested) {
-		build_compression_ctxt((struct smb2_compression_capabilities_context *)
-				pneg_ctxt);
-		ctxt_len = ALIGN(sizeof(struct smb2_compression_capabilities_context), 8);
-		*total_len += ctxt_len;
-		pneg_ctxt += ctxt_len;
-		neg_context_count++;
-	}
+	if (server->compression.requested)
+		add_context(&nc,
+			    build_compression_ctxt(
+				    (struct smb2_compression_capabilities_context *)nc.pos));
 
-	if (enable_negotiate_signing) {
-		ctxt_len = build_signing_ctxt((struct smb2_signing_capabilities *)
-				pneg_ctxt);
-		*total_len += ctxt_len;
-		pneg_ctxt += ctxt_len;
-		neg_context_count++;
-	}
+	if (enable_negotiate_signing)
+		add_context(&nc, build_signing_ctxt((struct smb2_signing_capabilities *)nc.pos));
 
 	/* check for and add transport_capabilities and signing capabilities */
-	req->NegotiateContextCount = cpu_to_le16(neg_context_count);
+	req->NegotiateContextCount = cpu_to_le16(nc.cnt);
 
+	*total_len = nc.len;
 }
 
 /* If invalid preauth context warn but use what we requested, SHA-512 */
-- 
2.53.0

