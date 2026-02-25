Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C712C21DF;
	Wed, 25 Feb 2026 06:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002587; cv=none; b=l/oR6JzO1ABLYcPKsQrz3Cd2nMJL4qqOiH6MBtdv+LorZMpmY4nCSXjswtY4htgXTqO9GHRI3pYAJoMh7k5Us6uJOwqAuu2+Ya+umQwF9AFXsco/VNgM0QVe+X1rJe5xioTLJ0JM4hGkl3hJ6UDo0D92f2S5MTUbS9wk4cLNk10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002587; c=relaxed/simple;
	bh=qno82xjE0r43n84cCm9gH5I548Dos3zTYYNX+9a9KIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFpmTgYN74e5jeMLM9S8CwbmSKYiXaWcl5AGfZ59ItL/shiSzdMlHnjde42FI60+MnvIizyfJuwGQXHpCMGvus57S1VCuaKh/1l6+GAnHWkiDTsOBJL4RTpCG4jprdqjmBn9EuqJ9wjzgpYDyK/UEAo1sXpXZNEXsJ9lcELE2eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKzZL4q4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKzZL4q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF70C116D0;
	Wed, 25 Feb 2026 06:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002587;
	bh=qno82xjE0r43n84cCm9gH5I548Dos3zTYYNX+9a9KIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKzZL4q40CQhmupNEAXovA1Crdk9Q6iHP32LcuS0o5dspNScXndtg3c/zvY4G0+lh
	 ZTJNWtYzwuQDVzW5uBbzUa3k8kWZYo0f06PmOI1fYDwY4rHyA6HFXE03yrAZz/N7lG
	 uRzC28chQQCA3LSAh2yoxqov+01qqtQpWoTc0VZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 325/641] smb: client: correct value for smbd_max_fragmented_recv_size
Date: Tue, 24 Feb 2026 17:20:51 -0800
Message-ID: <20260225012356.574749527@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 4a93d1ee2d0206970b6eb13fbffe07938cd95948 ]

When we download a file without rdma offload or get
a large directly enumeration from the server,
the server might want to send up to smbd_max_fragmented_recv_size
bytes, but if it is too large all our recv buffers
might already be moved to the recv_io.reassembly.list
and we're no longer able to grant recv credits.

The maximum fragmented upper-layer payload receive size supported

Assume max_payload_per_credit is
smbd_max_receive_size - 24 = 1340

The maximum number would be
smbd_receive_credit_max * max_payload_per_credit

                      1340 * 255 = 341700 (0x536C4)

The minimum value from the spec is 131072 (0x20000)

For now we use the logic we used in ksmbd before:
                (1364 * 255) / 2 = 173910 (0x2A756)

Fixes: 03bee01d6215 ("CIFS: SMBD: Add SMB Direct protocol initial values and constants")
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 01d55bcc6d0f9..c8cef098d4806 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -101,8 +101,23 @@ int smbd_send_credit_target = 255;
 /* The maximum single message size can be sent to remote peer */
 int smbd_max_send_size = 1364;
 
-/*  The maximum fragmented upper-layer payload receive size supported */
-int smbd_max_fragmented_recv_size = 1024 * 1024;
+/*
+ * The maximum fragmented upper-layer payload receive size supported
+ *
+ * Assume max_payload_per_credit is
+ * smbd_max_receive_size - 24 = 1340
+ *
+ * The maximum number would be
+ * smbd_receive_credit_max * max_payload_per_credit
+ *
+ *                       1340 * 255 = 341700 (0x536C4)
+ *
+ * The minimum value from the spec is 131072 (0x20000)
+ *
+ * For now we use the logic we used in ksmbd before:
+ *                 (1364 * 255) / 2 = 173910 (0x2A756)
+ */
+int smbd_max_fragmented_recv_size = (1364 * 255) / 2;
 
 /*  The maximum single-message size which can be received */
 int smbd_max_receive_size = 1364;
-- 
2.51.0



