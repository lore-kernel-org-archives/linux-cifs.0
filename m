Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295AD28C852;
	Tue, 22 Jul 2025 14:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193735; cv=none; b=gNNp9DpHzfKnc6vEA2SWNDXmSjHJrb8XQ4c+tySGKbqqgdjNNvCaMJYB+r61JDht/DTw8lB4VZ331Ey463oUau1W52SKsyXtS0G5l3ewU95Ac3ROKNpuxfraqeHKnxUX5UY6yThc8MTSsVGcSoK9czySBRsUSRHUM9erdBM2Y7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193735; c=relaxed/simple;
	bh=oFReC/Hn+6JGXZPlXXBa8vVl4NnoF0Kj9pjEVEVBPQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJkgNgdnrrQHH44HrJTjZOzN8lZL1LLge2fQ5tXm+06cufU1hrErJoayCfOwwx6G3YWBgmGbAkrU5rbsNcIaUnaPbMPS7KJ1Ygi9cUeNE572cFC3NkRlYp176cJPChpKRDlSmFJ/z29CLQIC8r4g70uXWSNEqQ4xzf84ih70Sw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAOlnTZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAOlnTZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4D8C4CEEB;
	Tue, 22 Jul 2025 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193734;
	bh=oFReC/Hn+6JGXZPlXXBa8vVl4NnoF0Kj9pjEVEVBPQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAOlnTZfMt0x3zls5F3u+C8xiCnZhX0TzbXL8KJaRYWqikF00EvxNTuvvsZwi87+P
	 qZdG08CA/XUEYivTCF4o7CMWErEBEcvO2Iq/CNYbrzGEXEoAhAqP5Z10TqwzvT087e
	 nFksGTobyQZvvGy9YXq/gQqtsgWRP7LaPG4UJKkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 174/187] smb: smbdirect: add smbdirect_pdu.h with protocol definitions
Date: Tue, 22 Jul 2025 15:45:44 +0200
Message-ID: <20250722134352.252880111@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 00fab6cf323fa5850e6cbe283b23e605e6e97912 upstream.

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smbdirect/smbdirect_pdu.h |   55 ++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h

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


