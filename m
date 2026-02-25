Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7E318B0A;
	Wed, 25 Feb 2026 01:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983293; cv=none; b=lN2objda002iyPCAoANuDDPl5xC5wijqzU9Kq+qg+OHeb+cR9Jp1lQUuTOc+SU/ng3re4xmngMXR5HuuoImRemg0rNG4HYw9YCPlzDlRuWwlQheA1j7uDV3WcmnSDfRb60Z0g/v4hQFRfSc5Hk6T/YzJClzOpJB4quAAMR068Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983293; c=relaxed/simple;
	bh=0JM3g76itItSZcuTgviLI0+yvWUzlMpDIrUZBWxJAeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzT4UAGYnbobKmyYz8hPkRsEbFf+A97CaDuW9vlhKMKyxOkYjWDHAyt8uGfWQO99c8YQPwtqzmybqtgCoiwWQxMUiIS5KL/b+YykgJi5Ro+MheaXk1Xe6Yj8vHM9RjzV3DzUL+UfakfaNvzaJtzucfSOts/wS+5k8UDOcEs7+qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrZo0Hq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrZo0Hq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D7BC116D0;
	Wed, 25 Feb 2026 01:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983292;
	bh=0JM3g76itItSZcuTgviLI0+yvWUzlMpDIrUZBWxJAeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrZo0Hq/GkYouxfrqqaO0a1oq6Y89nS+1b002JJw9iY9zNi5eX/7cg2SclGlx7R1G
	 ImyEqBxJPMeV3ZiYOdPTNf2789lvkjTlnysT1VHrfhO2zSgmYt7cHRaxAeYMcNc9GB
	 1RHYVBuSZ6Y/cLa+1Yd6EKCXEOitrQGdkuhepe6w=
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
Subject: [PATCH 6.19 427/781] smb: client: correct value for smbd_max_fragmented_recv_size
Date: Tue, 24 Feb 2026 17:18:56 -0800
Message-ID: <20260225012410.174214663@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



