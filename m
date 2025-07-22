Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E847D2EA748;
	Tue, 22 Jul 2025 14:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193758; cv=none; b=qkx8hl8Jh3nidd8uKUwiJSR2mfQXBE8fIn75WBzHwqe9LjM0VBRdxOHmXrpyR+KsxpN/WaGk8kjFslTbvb8Hiy2wYR0ezOfZ+UtjIRUjkPBtfdkVDoIuPjyA/R2gv6YB9+NkwMyeI8MBWLOts5cdSkkpYkscU+FjvKuu9RnfCLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193758; c=relaxed/simple;
	bh=JYBZmLSxZ8ZVqG0CEtMSedj+89s3PP+su4WjpgzH8nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKQOloCHN1GpdorpJHhjeJxwSPSsyDYmOekCiN04WrieHMlDWjYidXPbDZ2fU3hqG/SMG5mqdntwY27NVHNxHpSaN3xV29qzsvi8sW6MEgsfB6e6SMRbefQaWxJ/l7PY+xho0REynBGZ/U/GaqceMMOp3nGWdtfEExhWlY29qv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTesIAfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTesIAfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABAFC4CEEB;
	Tue, 22 Jul 2025 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193757;
	bh=JYBZmLSxZ8ZVqG0CEtMSedj+89s3PP+su4WjpgzH8nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTesIAfQP7Ndzy+NOi/8DWez5pNYocUw2gJ10TtHbFbRjJ8iyAWIbkAi73A9dlwVN
	 Hl2cqmfP7kDutrgW9DBUxrqKc8WGnii5wMDqn8yPUoEL1NtAPz2aJ0dqMZDhExvA9D
	 gIgDdsneWk4k9UJbeBEvnjl6EPunhTZrXo4cMb44=
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
Subject: [PATCH 6.15 176/187] smb: smbdirect: add smbdirect.h with public structures
Date: Tue, 22 Jul 2025 15:45:46 +0200
Message-ID: <20250722134352.327222366@linuxfoundation.org>
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

commit 7e136a718633b2c54764e185f3bfccf0763fc1dd upstream.

Will be used in client and server in the next commits.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
CC: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smbdirect/smbdirect.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect.h

--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *   Copyright (C) 2018, LG Electronics.
+ */
+
+#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
+#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
+
+/* SMB-DIRECT buffer descriptor V1 structure [MS-SMBD] 2.2.3.1 */
+struct smbdirect_buffer_descriptor_v1 {
+	__le64 offset;
+	__le32 token;
+	__le32 length;
+} __packed;
+
+#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__ */


