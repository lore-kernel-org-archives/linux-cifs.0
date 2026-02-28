Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F47D34252B;
	Sat, 28 Feb 2026 18:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301819; cv=none; b=uJlLIHxfk2H6TSqP6lj2likGYQ8Hgcgu3wZYJTHSVU8mHTPvU74mgw9J697l75SD11zApsqtJVPx/2IBDATTIdvVJxNiURB33+3ViaKNj7025X7Dt4cObI/0qwu46CCnTwlo7xQxEctU2WCKN/Ec9TStAn9+ZrZHbDaFkR26z0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301819; c=relaxed/simple;
	bh=CNY85JueAw5MiVJ0/2JJgvFVqCylomqPXk1gc0vwIOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDlTrURlhHff9NIk1ZRmhWNAhuI9NMNUBSsOiZiRXnffdPhQnr1VkSf4jDeEVVhhDDyhTpp+V6MSFC4Ao4GrebR8IWEM9JQxPDg75juCqTP/zAZHnJy67dO9fuddq38Qk0zr7QEOtheUtjUovwx95kWXtWDog2jBPPR2OeLcH40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9MBHt1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9MBHt1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A50C116D0;
	Sat, 28 Feb 2026 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301819;
	bh=CNY85JueAw5MiVJ0/2JJgvFVqCylomqPXk1gc0vwIOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9MBHt1QHCgJEj9dU0Ha/Dn1ZHyO4BgFkAxCiPQrd9HCZ4Fc04238sOkRlSMv6MDL
	 N+SnQRJaFC8nkYO0s8OKgR9vrhnhOOldQ16MsgPA73WHuzST2Sko+le/gguQD1Fcg6
	 MF0uBUe9+786ECScNe+h5l/stLgtcm2+xa+UdgaXzdXP+krZxyW5C3O371VSQE35c3
	 mWBQKNesLOEeazMDS1iUd08XdyvkiH6kA8x7cd4h3tEqq7hE+oUgPQgyY+sqMgyDMu
	 92KSR+B7qLjYk/0KHTpBYCSje/QsUNlw4DzBZq8SbEv0cY40aofDYxlJl7NbWma8ue
	 K/opRn1mx7P5Q==
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
Subject: [PATCH 6.12 233/385] smb: client: correct value for smbd_max_fragmented_recv_size
Date: Sat, 28 Feb 2026 12:57:35 -0500
Message-ID: <20260228180011.1568201-233-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index b1548269c308a..07f71a9481a36 100644
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

