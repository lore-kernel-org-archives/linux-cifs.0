Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3258E2EE99C;
	Thu,  3 Jul 2025 14:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554233; cv=none; b=Jca5oI6Zhtz7V6RMZWikwUOkNqsLxabGMGGL5+bu/MssGClLVY0GRUGr1K8o4pspiuoX17kFWIRuqxY7s0/BiCnPfw4yhTZgrxkyyGK9VAl8O8ulwDay66dIGpycsO/VZLSjcMC5ITy4QeAcbcRjsApPFwFjH3AoN/fNtgCuEOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554233; c=relaxed/simple;
	bh=Wz/UHFMKLhlswTESC90CzmPM2fdNvMk8fiFo0jWttuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPnvuHmejU9cYlhlrrz6pCRkmINKqroZGyt2l7y6jhPkZBr/ytvgO825OEc/flogigz7waxGV5mcz09FCqvDTd+0yr4yapgcTZFEZs3jeackdNfyOPIMBsYUS8tJjrDwOEXsOsN6m5TKGEDT9EQNpozIWH913zn5+SuIbpstF9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGzKQkuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGzKQkuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6CCC4CEE3;
	Thu,  3 Jul 2025 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554233;
	bh=Wz/UHFMKLhlswTESC90CzmPM2fdNvMk8fiFo0jWttuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGzKQkuIW4IlmKyqJrCHqlQ9sl7qtdEcb4YlCs9NFjE5vBe1AVNJ2c1GL8F7L4795
	 B8sOzlzMiAQdYmDpMd/xMXFtzq2aQxJk4VX7ggbvnqitqSGGibqUiaC7GBwS7gyZ8m
	 4jvZQLpJ1pEUqhQdFOYhy6Icd+Vh+QKw7oyHI9wU=
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
Subject: [PATCH 6.12 121/218] smb: smbdirect: add smbdirect_socket.h
Date: Thu,  3 Jul 2025 16:41:09 +0200
Message-ID: <20250703144000.775347106@linuxfoundation.org>
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

[ Upstream commit 22234e37d7e97652cb53133009da5e14793d3c10 ]

This abstracts the common smbdirect layer.

Currently with just a few things in it,
but that will change over time until everything is
in common.

Will be used in client and server in the next commits

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
 fs/smb/common/smbdirect/smbdirect_socket.h | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_socket.h

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
new file mode 100644
index 0000000000000..69a55561f91ae
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (c) 2025 Stefan Metzmacher
+ */
+
+#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
+#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
+
+enum smbdirect_socket_status {
+	SMBDIRECT_SOCKET_CREATED,
+	SMBDIRECT_SOCKET_CONNECTING,
+	SMBDIRECT_SOCKET_CONNECTED,
+	SMBDIRECT_SOCKET_NEGOTIATE_FAILED,
+	SMBDIRECT_SOCKET_DISCONNECTING,
+	SMBDIRECT_SOCKET_DISCONNECTED,
+	SMBDIRECT_SOCKET_DESTROYED
+};
+
+struct smbdirect_socket {
+	enum smbdirect_socket_status status;
+
+	/* RDMA related */
+	struct {
+		struct rdma_cm_id *cm_id;
+	} rdma;
+
+	/* IB verbs related */
+	struct {
+		struct ib_pd *pd;
+		struct ib_cq *send_cq;
+		struct ib_cq *recv_cq;
+
+		/*
+		 * shortcuts for rdma.cm_id->{qp,device};
+		 */
+		struct ib_qp *qp;
+		struct ib_device *dev;
+	} ib;
+};
+
+#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.39.5



