Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A5B38F62C;
	Sat, 28 Feb 2026 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302156; cv=none; b=ET3wKwqjDsoMTRJEzeQ3f5n5yNjsGsyRKAw/PVOIyAcnpjH1VyL6CgOKwN+vh1iiTj/zbF6scVKuhg4M/OU3eN53SfPcflL2KupCQCT8JZdRew0eqqT4ZPA41+sMT1ROmOlkPsFp7EGTJPPWLV4JKd1iT1Pbm5hpkLcjHtEs4rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302156; c=relaxed/simple;
	bh=nsgsaktJb3rTZJaRELnd3zg802ys78bGbm5rBVacZsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhE8EGYdqdlQJX/rRfyL9yI/IGbjMR4Xz79i7O3ZMQnjMECYTFoxH+PY/26+7slspjtbszR3v/dBOVJxkGJgKFTq5w6hdCXZtPaGGdN4b4U+sTXwGrH6IkvHgoBwBuVnjgJ9JODfKL09YZdCiv6N+ezETQVNa6Y+VVKuMdqQSNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mp+NDgjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mp+NDgjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DEEC116D0;
	Sat, 28 Feb 2026 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302156;
	bh=nsgsaktJb3rTZJaRELnd3zg802ys78bGbm5rBVacZsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mp+NDgjs8WpRA67tgONp4O1cL9r658GqYK86qZaZoxgwoBOxNxh2/QmqlHQrv3QEQ
	 A5Qfbhy5tgwYAxChSZScwGvoIdfine+7K+IkKz5w0r/AANXHeCkHC5B48UEBB56z4I
	 42ddgI3zWqaaPkxKhMlSmJBi6bd4w/R9lqrp/+f8u+74d4klVOO5r6RpRc66CPtMyT
	 SuPxxMSaF/Vi1JHsNp2s87Um3BaYIFNxMOABXjKMrdeBb+5LMEO0Y6bFYBfTmATgtv
	 uxkfl+9d7c/Pyp5iCMH36pYO+iahrJ4YyXPvhDNbQuxvh36gEt18MKCKh/6+/Q4k86
	 EsuNSRKtkRy4g==
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
Subject: [PATCH 6.6 151/283] smb: client: correct value for smbd_max_fragmented_recv_size
Date: Sat, 28 Feb 2026 13:04:53 -0500
Message-ID: <20260228180709.1583486-151-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index be9be8f363319..359ab64e17d99 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -91,8 +91,23 @@ int smbd_send_credit_target = 255;
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

