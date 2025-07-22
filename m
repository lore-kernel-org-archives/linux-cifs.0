Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3C42EA16D;
	Tue, 22 Jul 2025 14:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193760; cv=none; b=k2ZjkL+hkYiY8OnxqsNNWbmxvrCrqiPu/L9JFnh1R+hKc6gtMoUxMS7eoinUuVjXYylFjrA6p4BUUJ6t+/6NRUlj4yn/M1I0zS39v5Zt9j+lbvVBAE7AkryqXDhRwxfnjz38BnfXF9pm6ilebGUq50HGWKQ0ASA+Vh/KySapCeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193760; c=relaxed/simple;
	bh=2E2QIngg8etpdIB8mS2bpx7x89rPN0T0vYC+WhxclRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCdFaavTHJ5aLI+LTB7bcjeW+otzMXL4XazhIatHI9rRFwk742JId+eQa0yhysricz2Ko0vWhqikrCEgSLx3q1carKV7wVQVm6xPlixMFXye7I3UIpI35FERLQv/C771ectbBypAqbcjKHmkoavYfFjAFhjs+5Le6y8ZOBwe/mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+wlqNlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+wlqNlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1ECC4CEEB;
	Tue, 22 Jul 2025 14:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193760;
	bh=2E2QIngg8etpdIB8mS2bpx7x89rPN0T0vYC+WhxclRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+wlqNlcXUanoSkTSESHpS723iwOepmTu3aAJNHDGRalmCldeQnfPXi93OgImqroV
	 dV/96w5yIHRXRR4WYcqzKub95jxKaf6r3SrY+BoYZ1lBOhGrxrggOUKf0lP1de3naf
	 BXC4Jw5tuxPPFyz0/uArVD7NAa/CGCWNPpWMFfKI=
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
Subject: [PATCH 6.15 177/187] smb: smbdirect: add smbdirect_socket.h
Date: Tue, 22 Jul 2025 15:45:47 +0200
Message-ID: <20250722134352.363245084@linuxfoundation.org>
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

commit 22234e37d7e97652cb53133009da5e14793d3c10 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h |   41 +++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_socket.h

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


