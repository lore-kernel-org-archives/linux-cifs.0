Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7703234
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448125; cv=none; b=igPZWSefHL12KaS4VhJtxw15ytKreCupFK5K79pc27F6QSDQ9Ucnv4pxwG0EOeyNsBDkAp09CztTSoNUaex73SdbZxexdy6FWYsXmXim7GF2LSo7wFBZMweBlOZlw3Rw4xig7mX7xMYa50+cGMgmiGgqjXwtXdLwLmYQ5izwzwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448125; c=relaxed/simple;
	bh=ptw+nBADGJTejwv38wfHF0vF7mnUbcqPDiI1U8fTBjE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P/OA7inV4zVhqJ6QgUEFBqCVUb1lDexlCqgfvjEmyyXJ4vytXuy/wMcKkqIG7TB9Qr0Mseh97DIiNS1jfOhdGPdQt0bfMtVUkCar8ryqP+ztbHbz3hrBg5lUHW9URHfDMQfC6Q5Se5SUmAOvkSOkK/Vpf2t5OIL6dOgPrXdao/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=erD8bbbU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="erD8bbbU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=N0h/3pLVEke8r15CZcuBdoGauKbz3Rij7+uIytPOFG0=; b=erD8bbbU+6dMyuTZzx8vUaBBA8
	k8gwQpttGJNqjVFwpZ47IDgncgSi7uCWDk/vNB+QlhgnYD6vcm3UbyeOxh/cJh23/MqUizdSrr0mX
	4E/cUPoOAzKFPVnBHykKZw6hbUmMPucVJLB6Qa2wNkIpholoDcGqJpr0OmQEwGBO1O/faz7WAxmm2
	0xjQeOlU75VHfE0AfR70bt3IkeszpGYzmQ4ZG+NA5lMUwLjlOOQbjTwAjKpo3dj3eOKiDh0LWkR4a
	PeLI9x0MegbRfCVYdMgGSnQOnllHgiscg/MfCuCCdjO/ZY5ezIFMDiAjfHuIpbXIb5sIPWaBHphwA
	OJ2WkRJAyXWonKwXmhOMtleUUoiHo2rAup4dHcb0flPKknrdgZFM5yml313Lb625cOVKxzJRbf8kM
	Xr355ml7ig9rIJUwY1bbiNqZGxOv8M/Wj9S3QRKnNXm7+qGWyiX1+g9AP0GKBBHxZBwkWRMUe3rur
	ZbZn8zBUCuo1uCeMJ4aBE3j2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJE9-007hGw-0E;
	Wed, 28 May 2025 16:02:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with protocol definitions
Date: Wed, 28 May 2025 18:01:30 +0200
Message-Id: <b43ee94c3db13291156e70d37a3e843ad7d08b31.1748446473.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748446473.git.metze@samba.org>
References: <cover.1748446473.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is just a start moving into a common smbdirect layer.

It will be used in the next commits...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_pdu.h | 55 +++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h

diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/common/smbdirect/smbdirect_pdu.h
new file mode 100644
index 000000000000..ae9fdb05ce23
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (c) 2017 Stefan Metzmacher
+ */
+
+#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PDU_H__
+#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PDU_H__
+
+#define SMBDIRECT_V1 0x0100
+
+/* SMBD negotiation request packet [MS-SMBD] 2.2.1 */
+struct smbdirect_negotiate_req {
+	__le16 min_version;
+	__le16 max_version;
+	__le16 reserved;
+	__le16 credits_requested;
+	__le32 preferred_send_size;
+	__le32 max_receive_size;
+	__le32 max_fragmented_size;
+} __packed;
+
+/* SMBD negotiation response packet [MS-SMBD] 2.2.2 */
+struct smbdirect_negotiate_resp {
+	__le16 min_version;
+	__le16 max_version;
+	__le16 negotiated_version;
+	__le16 reserved;
+	__le16 credits_requested;
+	__le16 credits_granted;
+	__le32 status;
+	__le32 max_readwrite_size;
+	__le32 preferred_send_size;
+	__le32 max_receive_size;
+	__le32 max_fragmented_size;
+} __packed;
+
+#define SMBDIRECT_DATA_MIN_HDR_SIZE 0x14
+#define SMBDIRECT_DATA_OFFSET       0x18
+
+#define SMBDIRECT_FLAG_RESPONSE_REQUESTED 0x0001
+
+/* SMBD data transfer packet with payload [MS-SMBD] 2.2.3 */
+struct smbdirect_data_transfer {
+	__le16 credits_requested;
+	__le16 credits_granted;
+	__le16 flags;
+	__le16 reserved;
+	__le32 remaining_data_length;
+	__le32 data_offset;
+	__le32 data_length;
+	__le32 padding;
+	__u8 buffer[];
+} __packed;
+
+#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PDU_H__ */
-- 
2.34.1

