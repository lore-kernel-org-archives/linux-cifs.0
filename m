Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D47445AF2
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594471; cv=none; b=XXVtNrh0BY/7Q/4CUj5xemBCw/apKKrYtnm6iJ80CyiQqqf/lyzTt1pfjEuRbHYyO433qfWYJLjzaV/kgSwve0KJSEv8Per2L1+7CD5dGUPVAAtiwDdqn2p4PhLMcdokRd9l1oq2ebrqVmAp7bk/546dXE6P7vvoEm9Tgn0hLN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594471; c=relaxed/simple;
	bh=HaZ/NgU8SzIy2Swk2Pf8H1wW1yAr5cbU1KSFRp4UFKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3Mp2lzKu8pcpoNx9njyyfugTIRFvy1x+ailD/URiuN8NeoLZe+t5PmQQotU7a0r/3QthvSwTuiXfoMIPo4MIDQNcmJdPeU9OmmLZAMzBdSvqgwvs7WanrTEqkpV3zYEYmNKFT6FqsxEQ3E6yUiwWPyg9SjHaOUl8+uDrRmuGAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gdPQhixt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EFtvJExa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdPQhixt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EFtvJExa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hf2f32r13JSomMDfZfoKXuayA2BGq1ZV685GJZYKi8c=;
	b=gdPQhixtfIPamOi2EaPd9Y63lwNAhDJVtvmiymCRpyGNfG7BLE5dJ3g/fgXBdOv164YhNL
	8ElhE0CYSSuj+wZtyS2lEDBDDa8M5y7kswrq1gmYYJJDqLRFMppgSBuhAqgz+dpzRRH8xc
	uow8cgiWk8+lT4/ePoHQEEz5aNc0Sfc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-B-1w_qtpPQ-JYRkNfdCIZg-1; Wed, 16 Sep 2026 17:34:13 -0400
X-MC-Unique: B-1w_qtpPQ-JYRkNfdCIZg-1
X-Mimecast-MFC-AGG-ID: B-1w_qtpPQ-JYRkNfdCIZg_1789594453
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52f9e903b02so1831791cf.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594453; x=1790199253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hf2f32r13JSomMDfZfoKXuayA2BGq1ZV685GJZYKi8c=;
        b=EFtvJExaZGxQLxptMw79aqXnzt7bbMruBseTi+7SjC5cxBrL8jfANYZ6ul3QydV8k3
         TYmnfmd4/1PRJC117dcOrIBE4PWbcBgbeSwyibyle9NwahgD690ke6jbWY93MlxVKGGJ
         sPvp5DXHmzJuWW+SGgYohf+TQmaXNFKVs1OddmoaaUqirkzPT50mthZntOrtZVeVEUah
         YZiPvOD0cugZo0ZSy9Pqr7YawgsCBbhqKrtrYZ6u8h9WpySRHTSpx5pgzY+xAhgNDV88
         wic1KsIoRDXXwR2xtiIsa8bDRhrAdP1iSG1lETt5/yP6t2GQfsyV6CwckEyuoDa0qn2V
         9EOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594453; x=1790199253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hf2f32r13JSomMDfZfoKXuayA2BGq1ZV685GJZYKi8c=;
        b=M17jAP992wmrJeHzYfT2PuUDjcEJUNRhQ0MjBBiegdYObW4eO1q4EPVNkZWmN8Hhm3
         H4Os2cyQiT2QR7qsOXjJqDxUVq3ZvpB01D+lnnWvUCfWGLS2JDpJmp1z13ZKrx8oZnlF
         snkIBuxtZGo+fdWX9oU0PPJoLTbr60QPQRgBUr689ULzNj4fff8/8vDoQln+JDvlWKxG
         zGJPvaZC+Lvi2fIDB08MQAWOecsHjLbvLJGTjkm09uWZeEiUpRBLmyUKEcrEtXuybs0r
         mIifhLkzgJ5nqX+rmjkuJ3xrAkM426Aq23qaRDthb33aSq0vz4RVx1WL00gAc2bIaJ/5
         1VoA==
X-Gm-Message-State: AFuF++lie4uaTAqiasMc+2+3UyxasHsnQjwdPZjfIWpJx3ONDHsk1uXU
	MBW7EhWXu3xxn15y87p70trLo561GDmGTLamUmRh7Rp1bM2wX8Sg5x72Hr8/C+XyYQtaNyjmpwn
	iEUpBkpcfadDJr5ec4qiG24apRx89zavT3EHsTxFvjhnGS38PxDWDg6iNKOz/ns0p2rdQg4GX1n
	CzUAF2YoP2oU8FaJ+1CGeySTzvWZAU0fjtsmLPVJp98/KFp/o=
X-Gm-Gg: AYBFou14BUgSv4p7IIJ4G/cz4x+weDZFi1Df5IIjIRJN5rrhlvfJ/DPBUYLGXbTeSMO
	7kucSEqe2LsFZi5ABExe/39gCKYI2jnxUtMW9mmsiGPR8N+CDZEa7DymelDtek6Z8OycF55EqDo
	QsJvOraVcc+7pWFFYnLwaxzGD8tcvquRRx/gAqUbl/HjwxYYgyv6ZVMB7ca/bHZW58peFfPlPRM
	+TAWHXGOk0mER3CKpGStk1VCTYi/Q8YGSdkcvjgBHoWkEY86Zc8YOj8dz0ZKWtbAaIhKOTKVae/
	7pD4bKjSTcqCHl8SaGlkH1YWaUNNK0l7JDGnm+qS3NkIERY7gzSucFyjvVE7FQN91ED2Kx8/8AB
	TTLgsFwfovuWNoR+mNrj4UzgdUOeXxlpBooldSNl+ToOpzueJ3p5L/EjcT6upgc3Dxg==
X-Received: by 2002:a05:622a:1baa:b0:531:2394:9663 with SMTP id d75a77b69052e-5328cedfe08mr18954911cf.7.1789594452769;
        Wed, 16 Sep 2026 14:34:12 -0700 (PDT)
X-Received: by 2002:a05:622a:1baa:b0:531:2394:9663 with SMTP id d75a77b69052e-5328cedfe08mr18954401cf.7.1789594452173;
        Wed, 16 Sep 2026 14:34:12 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:11 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Subject: [PATCH v5 2/9] smb: client: validate minimum PDU size before smb2_get_data_area_len()
Date: Wed, 16 Sep 2026 16:33:53 -0500
Message-ID: <20260916213406.1496960-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916213406.1496960-1-sorenson@redhat.com>
References: <20260916213406.1496960-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__smb2_calc_size() calls smb2_get_data_area_len(), which reads
command-specific struct fields to locate the data area. However,
smb2_check_message() only validates StructureSize2, meaning a truncated
response could cause smb2_get_data_area_len() to read out-of-bounds.

Replace has_smb2_data_area[] with smb2_min_pdu_len[], which is now
used to indicate both whether a command's response has a data area
and the size of that fixed response struct.  A non-zero entry means
the command has a data area, and is the minimum length required
before the struct is read.

For each command with a data area, PDUs shorter than this minimum size
are rejected instead of parsed.

The minimum is not applied to SMB2 error responses, which carry only
the 9-byte error body, the same exemption the StructureSize2 check
above it already makes.  STATUS_MORE_PROCESSING_REQUIRED is
treated as a normal reply, since an in-progress SESSION_SETUP
response carries a full body and a security blob.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2misc.c | 69 ++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 28 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 9068175e57cd..0cfe60ae42c3 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -85,6 +85,36 @@ static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 	/* SMB2_OPLOCK_BREAK */ cpu_to_le16(24)
 };
 
+/*
+ * Minimum received PDU size for commands whose response carries a
+ * variable-length data area.  A non-zero entry marks the command as
+ * having one, and gives the length smb2_check_message() requires
+ * before smb2_get_data_area_len() reads the offset and length fields
+ * out of the fixed response struct.
+ */
+static const size_t smb2_min_pdu_len[NUMBER_OF_SMB2_COMMANDS] = {
+	/* SMB2_NEGOTIATE */       sizeof(struct smb2_negotiate_rsp),
+	/* SMB2_SESSION_SETUP */   sizeof(struct smb2_sess_setup_rsp),
+	/* SMB2_LOGOFF */          0,
+	/* SMB2_TREE_CONNECT */    0,
+	/* SMB2_TREE_DISCONNECT */ 0,
+	/* SMB2_CREATE */          sizeof(struct smb2_create_rsp),
+	/* SMB2_CLOSE */           0,
+	/* SMB2_FLUSH */           0,
+	/* SMB2_READ */            sizeof(struct smb2_read_rsp),
+	/* SMB2_WRITE */           0,
+	/* SMB2_LOCK */            0,
+	/* SMB2_IOCTL */           sizeof(struct smb2_ioctl_rsp),
+	/* SMB2_CANCEL */          0,
+	/* SMB2_ECHO */            0,
+	/* SMB2_QUERY_DIRECTORY */ sizeof(struct smb2_query_directory_rsp),
+	/* SMB2_CHANGE_NOTIFY */   sizeof(struct smb2_change_notify_rsp),
+	/* SMB2_QUERY_INFO */      sizeof(struct smb2_query_info_rsp),
+	/* SMB2_SET_INFO */        0,
+	/* SMB2_OPLOCK_BREAK */    0,
+};
+
+#define smb2_has_data_area(cmd) (smb2_min_pdu_len[cmd] != 0)
 #define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_hdr) + sizeof(struct smb2_negotiate_rsp))
 
 static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
@@ -233,6 +263,16 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 		}
 	}
 
+	if ((shdr->Status == STATUS_SUCCESS ||
+	     shdr->Status == STATUS_MORE_PROCESSING_REQUIRED ||
+	     pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE) &&
+	    smb2_has_data_area(command) &&
+	    len < smb2_min_pdu_len[command]) {
+		cifs_server_dbg(VFS, "SMB2 command %d response too short: %u < %zu\n",
+				command, len, smb2_min_pdu_len[command]);
+		return 1;
+	}
+
 	have_data = false;
 	data_area_overlap = false;
 	calc_len = __smb2_calc_size(buf, &have_data, &data_area_overlap);
@@ -298,33 +338,6 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 	return 0;
 }
 
-/*
- * The size of the variable area depends on the offset and length fields
- * located in different fields for various SMB2 responses. SMB2 responses
- * with no variable length info, show an offset of zero for the offset field.
- */
-static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
-	/* SMB2_NEGOTIATE */ true,
-	/* SMB2_SESSION_SETUP */ true,
-	/* SMB2_LOGOFF */ false,
-	/* SMB2_TREE_CONNECT */	false,
-	/* SMB2_TREE_DISCONNECT */ false,
-	/* SMB2_CREATE */ true,
-	/* SMB2_CLOSE */ false,
-	/* SMB2_FLUSH */ false,
-	/* SMB2_READ */	true,
-	/* SMB2_WRITE */ false,
-	/* SMB2_LOCK */	false,
-	/* SMB2_IOCTL */ true,
-	/* SMB2_CANCEL */ false, /* BB CHECK this not listed in documentation */
-	/* SMB2_ECHO */ false,
-	/* SMB2_QUERY_DIRECTORY */ true,
-	/* SMB2_CHANGE_NOTIFY */ true,
-	/* SMB2_QUERY_INFO */ true,
-	/* SMB2_SET_INFO */ false,
-	/* SMB2_OPLOCK_BREAK */ false
-};
-
 /*
  * Returns the pointer to the beginning of the data area. Length of the data
  * area and the offset to it (from the beginning of the smb are also returned.
@@ -451,7 +464,7 @@ __smb2_calc_size(void *buf, bool *have_data, bool *data_area_overlap)
 	 */
 	len += le16_to_cpu(pdu->StructureSize2);
 
-	if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)
+	if (!smb2_has_data_area(le16_to_cpu(shdr->Command)))
 		goto calc_size_exit;
 
 	smb2_get_data_area_len(&offset, &data_length, shdr);
-- 
2.55.0

