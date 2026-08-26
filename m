Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2527F29AB1A
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758343; cv=none; b=fmh2G20/W11mIEPB+tayg/TZaHlI3uXWER/icvSYkMcJl2LfI0wHxfqckgfyhiLF5FAGR0Zxrf2D8jOVDD3TWMiPWuAoe6DcMg/r/oAPogw7CqV0LOqoLt8sniJngmh3viN4ynb56wAa4TgnlWhB+PYQPRFxnjDPF81BfnXPVMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758343; c=relaxed/simple;
	bh=csgHV6LFt7MnHDiJaQT7bFvX/3ED7DXDvndv/OGxjkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qeo1BNp1ZzQ/hRTa2W5RraQGkMaIrQe1MvwCvN3wonb5u2nESW+mJa1B+EW424EG4N+IBKTSt260iECGJYkeKODmw0U0agRkULoVSWUpwdja+PAOxrwRF+YZEMpa7pNbE9cvJoNyXWiITjaFcyIQg8f1h5SsceizAntg42koplc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LegOFGEn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z3ijhXJj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LegOFGEn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z3ijhXJj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2a/AkRhb9wyMJG5QZt+fxYvwq5pSpxdXrOHx44h+9MY=;
	b=LegOFGEnjqCUYBJwbZSPs9sWv1euSBWvtva7jTgXGhXhlbZq2zfeSfXojfNNgFGxe+D8SK
	4yy7ZlTN7YmYyd3N9uUJia1OVelsi+0pq2r9M3n6uwSW/Vd8/S7picdOuY+5k0wWGmIvtc
	JUNIG0sDXr8c80le+xyETl50TbUIJdY=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-ljRkti-4O9q7ZDxl2It84Q-1; Wed, 26 Aug 2026 11:32:14 -0400
X-MC-Unique: ljRkti-4O9q7ZDxl2It84Q-1
X-Mimecast-MFC-AGG-ID: ljRkti-4O9q7ZDxl2It84Q_1787758334
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66ac41b4883so1851803d50.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758334; x=1788363134; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2a/AkRhb9wyMJG5QZt+fxYvwq5pSpxdXrOHx44h+9MY=;
        b=Z3ijhXJjGY2YKuV02XnG1XmV2ShLtazW3QFhtNdEfkjbRxGhvuTMRL9xF1wtA6JD/K
         rgD71qZKq6hDm66gYDQGrqSgaXa58GQFaEblEAVCOdyYvV/4ncYH6VLGE4MCiVFzJRAv
         6000Ur3XU3CJ1D8I5jX8DgxT5nmPm8FkUD4Bi81XXRhMQ2xDmzmlKWBriDXwoo0RnADH
         deY1AP67GvNyowL2kwEBKOjz31eJ7crrY8RRy/slGWD61uTrpF+1JUVNTd2AQps9bMZU
         blLTi3ekd015SnaQxq/2Gfke6Km4drULzJcZSwCbaN4VSPtYMWC8no5POQ9I7MZL8/lt
         1IyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758334; x=1788363134;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2a/AkRhb9wyMJG5QZt+fxYvwq5pSpxdXrOHx44h+9MY=;
        b=aRWRX3AManMxFHo5sJiaJtvHZBK3MJ1Anpfseg8rSdpZuzZDc40TTtbD8UxLfqLmfv
         8VBV0/HYz4YMKE/qCRxNvrWpoC7VRaMAVmWsWiMiwjcmf0QwdYBE2s1MBCrBsMGVSNCn
         gYLeJosjcnVrp9CA6cREW+a2MS+XBjCDWJvn4/QviGWyAzXN6InXzNwzOYq/IWGcfRoM
         RQLvOTb6bdYF5LrLc5wvGYsHL0Ag9j8KXj5dspF4mqYQk0E4FKHZwhVpzkOveBTOwDyI
         INKOWb0qQ2Xy76j5N/ELci2m733kN2JADdPjzZAjKp3ILa3n+uOVmpt1xdFtCH1vJLyb
         KoDg==
X-Gm-Message-State: AFuF++kpzgx/01P4y5sQv6MTX4jfo9J5jathFPbx5UUYkILY1MLeW1bF
	oCN7UEGaIgKtdPdbsylfMDO8q+ZNmvM6MWr1gr+92SsB2/8uE+RN5plZ2wyi6LLqJPgulB1m+hq
	IEmU+opWq13QIgcwry27dJciM/UTDgkRy/z14gWwb0KyfSSlhHYo1KhWk4XPRe6eET+2/1A2Gjf
	I1UJlyjWHpBOzyHm9TFRlxKg1YJGAYG/+87SJGGVr+XKGH1AU=
X-Gm-Gg: AR+sD12tbx1/RU19/PYnDWexws9hCNwo8JS+4RjRxw3GLHP062t8jp44jzbQlNiABWX
	gYrMNBE8iq7e+XZSxPxjzZkL05yuYtKwP5+hGQf4Na/bDXZfOPInoXoYrUfbwX7qAyWru9Scz/d
	Hwe8WpsNxwht3eQWafZNH1KMEq6Lfkz9O+L4GKcfzJgl9tEoO+BS9UndWo7srjeAypIbgYPCiC5
	46YEqckA1Rya1VLBtwF5r8hgjgesG2Kp/A7LEL+cIBHwmsaVm5VhoN0As9zwlXxHFYGVv9wGC47
	vGsXrGzlil4O7eXeBHUUQ+eCWmeuDj1tK8T+KSX3INUeVSXZ4A5kx2WQSLjwRFh63Zj2tKf9cc4
	4uWWWh4bd+waO/b+vEXa82SHyJ8K+4vuncvTMWE+E4XGFa3EY8zBGedt5L4zJsPJxpQ==
X-Received: by 2002:a05:690e:b43:b0:66d:16dc:8ed9 with SMTP id 956f58d0204a3-66d256e50d9mr2995557d50.23.1787758334067;
        Wed, 26 Aug 2026 08:32:14 -0700 (PDT)
X-Received: by 2002:a05:690e:b43:b0:66d:16dc:8ed9 with SMTP id 956f58d0204a3-66d256e50d9mr2995471d50.23.1787758332771;
        Wed, 26 Aug 2026 08:32:12 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:12 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org
Subject: [PATCH v3 02/11] smb: client: validate PDU length before smb2_get_data_area_len() struct access
Date: Wed, 26 Aug 2026 10:31:38 -0500
Message-ID: <20260826153147.4112943-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826153147.4112943-1-sorenson@redhat.com>
References: <20260826153147.4112943-1-sorenson@redhat.com>
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

