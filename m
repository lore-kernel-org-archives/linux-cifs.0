Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B601BD9C9
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511527; cv=none; b=Tg/mTBML/ljYlD/tsKH5KWg8lt3PfJ6awXgSLDMyPpmdVAqJniR4r8KXhzsWE9eHZ/GGhXKswr/7uap9DWQxWMC4rILYfk5XVA/B7JWF2vL4BRR8Og1+Fhxq8CGabzZ4x3g6DyatLX0j33fu2/Hxc1kWLFyjBzZmJOVXtwmLeqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511527; c=relaxed/simple;
	bh=csgHV6LFt7MnHDiJaQT7bFvX/3ED7DXDvndv/OGxjkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pbh32VkC1MoC0mUWYc4P8DQnhVLGJbNC7IWrecajKrgRu2iR1+Q0c0EJ8ETFrsviGoaYieE1dtDue2t0y9v0xOW+7eTYkX9D2yYy+ra/sXoAkVpF1nzngLKQkQZrbNNgG5n9rJBVyIR952CFVWWj+dZRBbMmBzhE24NdjEMyrZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3OBi9Lw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rjXnnE7V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3OBi9Lw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rjXnnE7V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2a/AkRhb9wyMJG5QZt+fxYvwq5pSpxdXrOHx44h+9MY=;
	b=e3OBi9LwYAQ4g0fqnM1sTtIVC9xHrca6SaGwOGi2NK6Wu5z6XcKVXoWXy39v3X5u9QgIVa
	+r8THxS+8P9gI39BiSp6dXtTRuZ5n9j3SPP9IpEQbrGChgj7pLrTjbpmQ3gaAacG+Fd5wY
	yR4FtNzhqjfhuMDao3DMkENtHsweCWU=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-i8j4a6awOfWayzTyKh8jmQ-1; Sun, 23 Aug 2026 14:58:38 -0400
X-MC-Unique: i8j4a6awOfWayzTyKh8jmQ-1
X-Mimecast-MFC-AGG-ID: i8j4a6awOfWayzTyKh8jmQ_1787511516
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7f36427abfdso6014718a34.3
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511516; x=1788116316; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2a/AkRhb9wyMJG5QZt+fxYvwq5pSpxdXrOHx44h+9MY=;
        b=rjXnnE7VJTnb5WQ9/zG+9YTV3FZN6yBMS3O4KEJMYzT/RUcVeJp/je6ceXulmGUpXL
         l5lGBmAZYyiTi8tB5odM6DhFk5Jv5JYrF0pHuKtp2u7IjSlKuJPOgLkG9CtG+Vcmq54l
         cLCQOF8FKlV6n4MC/eiLcercDpTwn90Xef1XLAe+W2fYY2DEZYTtxXZIjwNyWe0Ey+3m
         xj+oFoHBEEY2qMwn3E33OV9KW3a8xO7xlIj39uWMDFIpN/kbjRO5hkbtPoqxyVqf9eYK
         lu+5CWUtbjy/ucu+BjRIgzDALJscK6xuRH8dah6apXeKezWSgvR6LrYpUYaTyAid5NDt
         0KlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511516; x=1788116316;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2a/AkRhb9wyMJG5QZt+fxYvwq5pSpxdXrOHx44h+9MY=;
        b=HQZQVtehQMTng7+e49Bygk8Mf9Fi2Dx9h/PyXBNY7zbZYaNV7VNGMlZFPkYHkHRDec
         pCeZKhqFU4SZFgPmfRi+54JZRDPivclF7fqU9tiAvX9woeFNH/vTuX4aTZzHvU+pPsuD
         7exyaEL0BhPrynbAGv8pnaBuQxJ60+ZQ5aXNYZd/Mr67wU/NSvlaPWN527jZNG+owTto
         ReE7Jf8fK2p73lNtnwtK1IrSCnNSOs+NlC0gKSA4618RNpfRJAfijO9aYQ8HAbTKislW
         sNDCazNbHuG+flf3rH4gDPH6s+Tn/q5las641j4k18seG8OXZfUUvEUp0PRYQQ0mXt30
         jrsg==
X-Gm-Message-State: AFuF++k3SdMY8cN1hEJEuHqq5kxq7w7414OdWvsU3mumH9YvPop6vljL
	c8LJKBhTj83TxPZ8tsBoCPru91AMDhDMN3Np9SVsSF1+AuLFANtRUHunLC5DHMUe+zSRFvO7tyO
	G0V4I55hSzNgN15YH2birczTzpZKo1/eMaTvtV7lrFEJWi+ZaVEduvWTubgRwE9DGMtFcEWjgWd
	5/DxU6UsuhBLtMxtigGYJoZaGMDBdnMFQbN9/g+y+cS2BWGlo=
X-Gm-Gg: AR+sD13civtXh3QKUvX/lT+jotBS+p9ZhKAaXtX/ggChxUqFO0gl+XNUxXuvfPkf56P
	G6nfjF8AJYmFktgzgUlk4Gez8Sdaur+Oburd3MBinKIfxSNDSZg/k7HQ/LknVzXw7eBNalYu8b7
	b4U7FQx5nL271NvW/QYWpKYKF2GFCJuOLFrYwLL5yYbWxlMf7cCgewtLjLrVpL1nAR0dhOWUrYZ
	iHDTXaXy2JUw1W+WzoHglMYYb8Nqtdq/SCrpk4HaQZ8k8JgNjspaNmDCWa43SrjXJnNjf+eLVp4
	1SytEmt8WpxsYAM2zxrq/JmJBV3jJ/aLc+xAYFQYJYKd5VtlYNC1Kq/GQMeEEW2yJzwAASTyiLr
	sz/+8jUcwYWQkpi/u0cGqfc7+ZYolWgcvII7R2HB6Ck1TVluylq13G4WAqn6t1Sl/iQ==
X-Received: by 2002:a05:6830:83b7:b0:7e7:5e4:ee11 with SMTP id 46e09a7af769-7f476544b05mr15699196a34.16.1787511515680;
        Sun, 23 Aug 2026 11:58:35 -0700 (PDT)
X-Received: by 2002:a05:6830:83b7:b0:7e7:5e4:ee11 with SMTP id 46e09a7af769-7f476544b05mr15699160a34.16.1787511515195;
        Sun, 23 Aug 2026 11:58:35 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:32 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org
Subject: [PATCH 02/11] smb: client: validate PDU length before smb2_get_data_area_len() struct access
Date: Sun, 23 Aug 2026 13:57:58 -0500
Message-ID: <20260823185807.3115901-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823185807.3115901-1-sorenson@redhat.com>
References: <20260823185807.3115901-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

smb2_check_message() validates StructureSize2 but not that the received
PDU is large enough to hold the fixed response struct before calling
__smb2_calc_size() -> smb2_get_data_area_len().

smb2_get_data_area_len() reads command-specific struct fields (e.g.,
CreateContextsOffset at offset 144 in smb2_create_rsp) to locate the
data area before the length is validated.  A rogue server can send a
truncated response that passes the StructureSize2 check but causes
smb2_get_data_area_len() to read stale kmalloc'd content.

Add smb2_min_pdu_len[], parallel to smb2_rsp_struct_sizes[], holding
the minimum PDU size (sizeof the fixed response struct) for each command
with a data area.  Reject responses shorter than this minimum before
calling __smb2_calc_size().

The guard condition is the complement of smb2_get_data_area_len()'s
early-return predicate: fires when Status == 0, Status ==
STATUS_MORE_PROCESSING_REQUIRED, or StructureSize2 !=
SMB2_ERROR_STRUCTURE_SIZE2_LE.

SESSION_SETUP with STATUS_MORE_PROCESSING_REQUIRED is covered by the
second term; READ and IOCTL with STATUS_BUFFER_OVERFLOW by the third —
their StructureSize2 (17 and 49 respectively) differs from the error
struct size 9, so smb2_get_data_area_len() reaches the switch without
the guard.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2misc.c | 53 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 9068175e57cd..7bf7c602cda0 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -85,6 +85,49 @@ static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 	/* SMB2_OPLOCK_BREAK */ cpu_to_le16(24)
 };
 
+/*
+ * Minimum received PDU size for commands whose fixed response struct is read
+ * by smb2_get_data_area_len() before the packet length is validated.  Must
+ * be non-zero for every command where has_smb2_data_area[] is true; zero
+ * otherwise (guard in smb2_check_message() is skipped).  Keep in sync with
+ * has_smb2_data_area[] above: adding a data area for a currently-zero command
+ * requires a matching sizeof() entry here.
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
+/* Enforce: smb2_min_pdu_len[x] != 0 for every x where has_smb2_data_area[x]. */
+static void __maybe_unused smb2_check_min_pdu_len_table(void)
+{
+	BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_NEGOTIATE_HE]);
+	BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_SESSION_SETUP_HE]);
+	BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_CREATE_HE]);
+	BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_READ_HE]);
+	BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_IOCTL_HE]);
+	BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_QUERY_DIRECTORY_HE]);
+	BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_CHANGE_NOTIFY_HE]);
+	BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_QUERY_INFO_HE]);
+}
+
 #define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_hdr) + sizeof(struct smb2_negotiate_rsp))
 
 static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
@@ -233,6 +276,16 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 		}
 	}
 
+	if ((shdr->Status == 0 ||
+	     shdr->Status == STATUS_MORE_PROCESSING_REQUIRED ||
+	     pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE) &&
+	    smb2_min_pdu_len[command] &&
+	    len < smb2_min_pdu_len[command]) {
+		cifs_dbg(VFS, "SMB2 command %d response too short: %u < %zu\n",
+			 command, len, smb2_min_pdu_len[command]);
+		return 1;
+	}
+
 	have_data = false;
 	data_area_overlap = false;
 	calc_len = __smb2_calc_size(buf, &have_data, &data_area_overlap);
-- 
2.55.0

