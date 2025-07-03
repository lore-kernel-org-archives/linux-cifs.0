Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD85E126BFF;
	Thu,  3 Jul 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554220; cv=none; b=gIBo/wyX38JWm04/kTwQB7XYZH4UncDQmLk9tyeKH/e0KRue0+FCR5mfc388RrURQZRvnRI5j10kQMceYsrNh1a5/Tk4lUunnumgOrbUWANfrTP35jgatEejf7g3SVFfD6239rhzQEJt4ASzf7K27I87bGOhCWHnKxofar5A85M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554220; c=relaxed/simple;
	bh=2n+AKnp0746EWkbHGtxyq1yMV4U7H6CaUoTPNdNZTXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOUZI9UKX6ysh1TNeSqQlHOQwBU60LPK1M2wvZ2zLK3E8jHA+m9LrUFObvqYltNnR6iKj48go8+yclQN+/hD+C1FnN2uoyO8/XMTgBWNpxWPNOPH8GY/n0IJgdBl+ZVnqdlxK5v4XvaR/KeUWf+5VgH5eht99Q2Kq9CCFDgaK5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xy3GxlZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xy3GxlZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DAEC4CEE3;
	Thu,  3 Jul 2025 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554220;
	bh=2n+AKnp0746EWkbHGtxyq1yMV4U7H6CaUoTPNdNZTXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy3GxlZqw6kgGojNSIeeunfSXFdGHccIGQqACAioTlg/cCSQaZ645fmXcTHZLhm3H
	 YJhNqPaC3MXsf8ZPm709/r01bBPsuYd6KRbG3O6LJE8Hyz8muGnOPcGpcjqDX07qmJ
	 L45KNatZAaiQylB4qFGXI6r/955YBq+YMb/yUoEk=
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
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/218] smb: smbdirect: add smbdirect_pdu.h with protocol definitions
Date: Thu,  3 Jul 2025 16:41:06 +0200
Message-ID: <20250703144000.660120631@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 00fab6cf323fa5850e6cbe283b23e605e6e97912 ]

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
Stable-dep-of: 43e7e284fc77 ("cifs: Fix the smbd_response slab to allow usercopy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smbdirect/smbdirect_pdu.h | 55 +++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h

diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/common/smbdirect/smbdirect_pdu.h
new file mode 100644
index 0000000000000..ae9fdb05ce231
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
2.39.5



