Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF70359A77;
	Sat, 28 Feb 2026 18:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302393; cv=none; b=jcVwISlcL76Q2z8g4ep+Kj2yVJBHtScUxvg5/CAU8CsRZRha1Krm4bCrC/BLgTSpBrB5re1MYOEYtlpNtiVhXimbScI0bMRpIScJOS9LWtF8LJJTNnEmw6/orDj8s0j1hBE1B9m+OqaxKh6xkNUcG2GGeK+vEUhsov7vrLuYbXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302393; c=relaxed/simple;
	bh=1Xb7rnPRiUR5wm7KwtKCz/ySZVf07W31390beM/Ffu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4v4u4KI3iZE1KAbx9vxdXI9JVLJ/t6vlxf4j8XnWeu7ik1k86TRQW9wa/S8B0uB3yRf6oIDZgJCGEEmDtPD5jKLQcvxTn2/Hsw000q7FeBIg7tRrSX31e6qv9JwJqReDIXpBXBwZ473QF8cE4fz6ypYXCxxZ5csnhTGsZ88+uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFUc8sSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFUc8sSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2179FC116D0;
	Sat, 28 Feb 2026 18:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302393;
	bh=1Xb7rnPRiUR5wm7KwtKCz/ySZVf07W31390beM/Ffu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFUc8sSQoglX8rtsorxbhdfP80PfFBNIfwHDW0P8VS4SswRgx3hcrDk2kHyYV3w09
	 Ufz2kWzV6BNS43PHYSo00XKQlJEU0OvrUkmdwrwXIGLZl8oBbTukySDT4rsqlTtv4B
	 zvGb94gZ5IFCrcw70IEViGy+s0d9dPn4A9chfqWXZHHUyuaqZkZ4m1RMo/MjkiMRUc
	 L7nYIo2sv5re8QikNsqrgJNox7ncCDGvVhC2/GABCeB4Kx7eYFQtqvktJFm++W0hb1
	 UEYrpJGLu49impznPuDoJ0uZy4bm8zIF8i6O+eomFFJgP9NeA2WCL+prIqy55opFze
	 iOIs61Est02LQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Stefan Metzmacher <metze@samba.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/232] smb: client: correct value for smbd_max_fragmented_recv_size
Date: Sat, 28 Feb 2026 13:09:35 -0500
Message-ID: <20260228181127.1592657-122-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index b648bb30401d5..9b16840952c09 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -86,8 +86,23 @@ int smbd_send_credit_target = 255;
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

