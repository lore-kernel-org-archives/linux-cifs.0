Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D572DE6E9;
	Tue, 12 Aug 2025 18:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021785; cv=none; b=OKxXZ1I2g+rVecOi7gjOgqn8ibPNGZCKcTwif3RiVO0j0ZDHBogo57lJZOM7OkK1iORuF6djHonw8elIYEA2jtqAD1z/awZ+iTETJ4psx898HakkGH7WH/e12Hr5E+bAe2sMfKlWLddR31IbqBP76TIC5L1vOjWd31cgPzVjhXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021785; c=relaxed/simple;
	bh=m1dhUjASm09tcti22IiPVagsvrJNWx2675L8yaJeeY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktnR/+jASTdGWq8Rklwp9c1zF56HBH9VjdJBpimwGcUHJvEC5AbikZcKPM71uWEk8cvWQ2WCSHLSCqHVyg5GE0LSQHzjSAsTFuwZv/T4a1aWT1VKvrb/3NAJvbPadNtjzEnm4VOhzC1kq35QXgqU31eTw4N70EkNYXOxB2GGYmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJkbhdsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJkbhdsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E99DC4CEF8;
	Tue, 12 Aug 2025 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021785;
	bh=m1dhUjASm09tcti22IiPVagsvrJNWx2675L8yaJeeY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJkbhdsAVxaSJFKiuaa7aiJoVvvkvUUoJhbwiJa1iOcnkzo4qNBtwLQbFuLtkuN9S
	 MQGtPrxqvJwhmR2b7effiNptxRds7i6Ib1vC6gDttUP/jmtADjF5uFnn1qPM4SvlqV
	 AXsQD6ZkiGF8qwQLesmy6NTmIAGYhx4fJsTtSeL0=
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
Subject: [PATCH 6.6 223/262] smb: smbdirect: add smbdirect_socket.h
Date: Tue, 12 Aug 2025 19:30:11 +0200
Message-ID: <20250812173002.648251706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 5349ae5e05fa ("smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_socket.h

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
new file mode 100644
index 000000000000..69a55561f91a
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



