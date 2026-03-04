Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD2C39B941
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 12:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772627368; cv=none; b=rLN9hRbCNzDkfeJyFzDLhbtq0BY5qK/C8Leu8tRzcVB0YmsnZ31bLw0c5WauFugOepT2l3TDYeV6HkuxQtAyNPATzvV7FUwNX9AAXUSOfDSCEHP7DQTLnOVAwhA6uAgFWiWkzNlEmzGsnYQgdvElgHjpHkp8rRfKeB6hFvVfwU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772627368; c=relaxed/simple;
	bh=+iWAdrBhjrhaskeXve0aFfP2NmGytwmqpU8ZRhwu04M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SUd4YEilHSX+z0L64q7HfCbB6OTAy2eQ3o4D3+RUNYRQHgVcDZ0Tpd2JLcotXJsWTMLth3ujs2wjQ5P3TKD1ethMy9tpH8MJ3OpHSbtrJjhOvk6LibPJhAb8pm65SqLlwar68ocJ8pfRSyGhHZC7mohRXeYsqUfkLIuxwZVg/So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gMflFDm0; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gMflFDm0"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82748095963so3424017b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 04:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772627366; x=1773232166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rq06hpr37zJfHaKJ4GilAFSQqrn5EpPJ7Tfd1pWduB0=;
        b=gMflFDm01bzNMPJB4WuLUzdRPgS3GIhUj6ofBgaEEVSUwDtt0afU50uhCbNPJvxFJ8
         x2BGejvBflWeW8Clnqf6blYRSxNQSwDGEwf+dKhAVtCnL1Ayh8a2mrrbTxjDEzKA3WJv
         y/Fw6WSdosmyaeApwAxCWVVqI5Rm25wio2mI+mbqFwY+Z0HDr1ypi7+TFWhArrEGTT3D
         i2PxVThTC+Jo98EJKwtkU+/v1LZBZh/p8J4kMeARR28EPOuGkpQKFaD7nd3/PLB6jSvD
         0SiO8GEFYK7z0fFzKgF58oJJmr8S+QhYW3CET82rhNzHoPZNKyiTjZg3f4wOLdRuU6TM
         H7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772627366; x=1773232166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rq06hpr37zJfHaKJ4GilAFSQqrn5EpPJ7Tfd1pWduB0=;
        b=gndIq8XswRTlbseZr2bPTrxRB8VrjR+4CYRMycUUv6juDDvGSi8NI0S68qPOQesQ/e
         Bb6S76UGEHSdes48IgW9XPkt6j+cDbH0gSqGuM6AcEyWmpvjclMMOlJf6i+wkKx7D3rQ
         UN8XcOxA8XLtAHe7tc7z6EMqJSZ4lH7zlqXPQvVOr4FQFNuOWDGS2hzdJM++FElCTL1g
         LDKiFV/nWUHJpnq572vgmQvojGAqpCpykNn+L/UZKj5IMFHhm0OBgV14UQZmV6UMf0wv
         1uOY/2glyvoF6fA6qk7zviCTZ7Vkpn38cdzj3d7ghpg1POk42N2bA5P9cZwA1NtTw0sf
         5gwQ==
X-Gm-Message-State: AOJu0YyK/QyXuG4qlHJeEMNS91ZNDz69snPDo7QWRpPgA5nNbrk1ShT2
	u+wrOAqQqhFJaaeARepoaOyW7pM420Fc/jtzYEt51hPSpmenA61I/1xpF9LZty1X
X-Gm-Gg: ATEYQzyoCFURHvytAPgWBKHLvktvyO2jasD3zjdxuZHQErJgzVQ6KAj9xWbaarEh7GO
	3wlDteW/Z0V8MnmuY1WPdqwLzixGy20vDNOy5Il8/KiwFhw2kD0ii5itfeEU3eDU35MnhkjypxQ
	+Z8mcUF20qmuQLFLo1WffgrERSrGsC7gkss9hBAZZg9c1Jbqg8qAMEPxrnEtp1bcaW0k6omGU8R
	UQHRUQQPSisR2MB5DVZuyzLsvqWaJc/saltzrY0O9eLHxvU4H4QPFrWjXUtYB/ceFsvBD7IWn9S
	GINOA776TCuDqfceHjRqV7m/QWoPtqDHzxpjY7O/QFsc+9DZ/VzRzzIeLuVfcggeSHXFg3/rN+k
	3Mc5+/yIoSCpoJKCRArAhaeryZpKC9tn0ByyzL3Tt76IEqhCaFChKAn9G85wRFfF0KNbmjSdVQw
	1jX1bIPzqhtMlea5pxgNiddRMCv81uIE7sTKkG/w+BF4BqEBmgVxkH
X-Received: by 2002:a05:6a00:391d:b0:823:64e:9e52 with SMTP id d2e1a72fcca58-82972bc5b3dmr1856417b3a.21.1772627366459;
        Wed, 04 Mar 2026 04:29:26 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.200])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82976293f47sm1301044b3a.33.2026.03.04.04.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 04:29:25 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: implementation id context as negotiate context
Date: Wed,  4 Mar 2026 17:57:15 +0530
Message-ID: <20260304122910.1612435-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

MS-SMB2 does not allow any fields for the client to communicate
the client version details to the server. This change is a
proof-of-concept to add client details in a new negotiate context.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2pdu.c | 78 +++++++++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h | 32 +++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ef655acf673df..9c89f6b4a6709 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -24,6 +24,7 @@
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include <linux/netfs.h>
+#include <linux/utsname.h>
 #include <trace/events/netfs.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -45,6 +46,7 @@
 #include "cached_dir.h"
 #include "compress.h"
 #include "fs_context.h"
+#include "cifsfs.h"
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -724,6 +726,75 @@ build_posix_ctxt(struct smb2_posix_neg_context *pneg_ctxt)
 	pneg_ctxt->Name[15] = 0x7C;
 }
 
+static unsigned int
+build_implementation_id_ctxt(struct smb2_implementation_id_context *pneg_ctxt)
+{
+	struct nls_table *cp = load_nls_default();
+	struct new_utsname *uts = utsname();
+	const char *impl_domain = "kernel.org";
+	const char *impl_name = "fs/smb/client";
+	const char *os_name = "Linux";
+	unsigned int data_len = 0;
+	__u8 *data_ptr;
+	int len;
+
+	pneg_ctxt->ContextType = SMB2_IMPLEMENTATION_ID_CONTEXT_ID;
+	data_ptr = pneg_ctxt->Data;
+
+	/* ImplDomain */
+	len = cifs_strtoUTF16((__le16 *)data_ptr, impl_domain,
+			      SMB2_IMPL_ID_MAX_DOMAIN_LEN, cp);
+	pneg_ctxt->ImplDomainLength = cpu_to_le16(len * 2);
+	data_ptr += len * 2;
+	data_len += len * 2;
+
+	/* ImplName */
+	len = cifs_strtoUTF16((__le16 *)data_ptr, impl_name,
+			      SMB2_IMPL_ID_MAX_NAME_LEN, cp);
+	pneg_ctxt->ImplNameLength = cpu_to_le16(len * 2);
+	data_ptr += len * 2;
+	data_len += len * 2;
+
+	/* ImplVersion - CIFS_VERSION from cifsfs.h */
+	len = cifs_strtoUTF16((__le16 *)data_ptr, CIFS_VERSION,
+			      SMB2_IMPL_ID_MAX_VERSION_LEN, cp);
+	pneg_ctxt->ImplVersionLength = cpu_to_le16(len * 2);
+	data_ptr += len * 2;
+	data_len += len * 2;
+
+	/* HostName - from utsname()->nodename */
+	len = cifs_strtoUTF16((__le16 *)data_ptr, uts->nodename,
+			      SMB2_IMPL_ID_MAX_HOSTNAME_LEN, cp);
+	pneg_ctxt->HostNameLength = cpu_to_le16(len * 2);
+	data_ptr += len * 2;
+	data_len += len * 2;
+
+	/* OSName */
+	len = cifs_strtoUTF16((__le16 *)data_ptr, os_name,
+			      SMB2_IMPL_ID_MAX_OS_NAME_LEN, cp);
+	pneg_ctxt->OSNameLength = cpu_to_le16(len * 2);
+	data_ptr += len * 2;
+	data_len += len * 2;
+
+	/* OSVersion - from utsname()->release */
+	len = cifs_strtoUTF16((__le16 *)data_ptr, uts->release,
+			      SMB2_IMPL_ID_MAX_OS_VERSION_LEN, cp);
+	pneg_ctxt->OSVersionLength = cpu_to_le16(len * 2);
+	data_ptr += len * 2;
+	data_len += len * 2;
+
+	/* Arch - from utsname()->machine */
+	len = cifs_strtoUTF16((__le16 *)data_ptr, uts->machine,
+			      SMB2_IMPL_ID_MAX_ARCH_LEN, cp);
+	pneg_ctxt->ArchLength = cpu_to_le16(len * 2);
+	data_len += len * 2;
+
+	pneg_ctxt->Reserved2 = 0;
+	pneg_ctxt->DataLength = cpu_to_le16(data_len + 14); /* 14 = 7 length fields * 2 bytes */
+	/* Context size is DataLength + minimal smb2_neg_context, aligned to 8 */
+	return ALIGN(le16_to_cpu(pneg_ctxt->DataLength) + sizeof(struct smb2_neg_context), 8);
+}
+
 static void
 assemble_neg_contexts(struct smb2_negotiate_req *req,
 		      struct TCP_Server_Info *server, unsigned int *total_len)
@@ -797,6 +868,13 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 		neg_context_count++;
 	}
 
+	/* Add implementation ID context */
+	ctxt_len = build_implementation_id_ctxt((struct smb2_implementation_id_context *)
+				pneg_ctxt);
+	*total_len += ctxt_len;
+	pneg_ctxt += ctxt_len;
+	neg_context_count++;
+
 	/* check for and add transport_capabilities and signing capabilities */
 	req->NegotiateContextCount = cpu_to_le16(neg_context_count);
 
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index e482c86ceb00d..1ad7b57ce2952 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -457,6 +457,7 @@ struct smb2_tree_disconnect_rsp {
 #define SMB2_TRANSPORT_CAPABILITIES		cpu_to_le16(6)
 #define SMB2_RDMA_TRANSFORM_CAPABILITIES	cpu_to_le16(7)
 #define SMB2_SIGNING_CAPABILITIES		cpu_to_le16(8)
+#define SMB2_IMPLEMENTATION_ID_CONTEXT_ID	cpu_to_le16(0xF100)
 #define SMB2_POSIX_EXTENSIONS_AVAILABLE		cpu_to_le16(0x100)
 
 struct smb2_neg_context {
@@ -596,6 +597,37 @@ struct smb2_signing_capabilities {
 	/*  Followed by padding to 8 byte boundary (required by some servers) */
 } __packed;
 
+/*
+ * For implementation ID context see MS-SMB2 2.2.3.1.8
+ * Maximum string lengths per specification
+ */
+#define SMB2_IMPL_ID_MAX_DOMAIN_LEN	128
+#define SMB2_IMPL_ID_MAX_NAME_LEN	260
+#define SMB2_IMPL_ID_MAX_VERSION_LEN	260
+#define SMB2_IMPL_ID_MAX_HOSTNAME_LEN	64
+#define SMB2_IMPL_ID_MAX_OS_NAME_LEN	64
+#define SMB2_IMPL_ID_MAX_OS_VERSION_LEN	64
+#define SMB2_IMPL_ID_MAX_ARCH_LEN	64
+
+struct smb2_implementation_id_context {
+	__le16	ContextType; /* 9 */
+	__le16	DataLength;
+	__le32	Reserved;
+	__le16	ImplDomainLength;
+	__le16	ImplNameLength;
+	__le16	ImplVersionLength;
+	__le16	HostNameLength;
+	__le16	OSNameLength;
+	__le16	OSVersionLength;
+	__le16	ArchLength;
+	__le16	Reserved2;
+	/* Followed by variable length UTF-16 strings:
+	 * ImplDomain, ImplName, ImplVersion, HostName,
+	 * OSName, OSVersion, Arch
+	 */
+	__u8	Data[];
+} __packed;
+
 #define POSIX_CTXT_DATA_LEN	16
 struct smb2_posix_neg_context {
 	__le16	ContextType; /* 0x100 */
-- 
2.43.0

