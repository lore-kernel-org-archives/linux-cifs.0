Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872231E89C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155580; cv=none; b=HRANqP8uOTfxjnFJSR1rlf5fEBmQAFoYz0YP5bbzIphrjtM3T4qpqIXenIqYjDaphdFB2/Lr+A40XmSlAJ+LnFnhHakm62ukv5RveUNGBz2vYdOOWNJpWfXqMySAWOZXguouOVrrDykvuIllwKiFGdUVVeIbdQsihyuALB4QHpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155580; c=relaxed/simple;
	bh=OsCu+vWlLMfu7e0mE/kNBlXK+bf5ojYIuVvJGoTGnt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAp9VBpRW0o4e9ht6mCV9KiYEJmXb0gvjMESc3m/bZiRAoFy1PMzqYe/BDQGSHv1APgeRcorpvG+kTrQY+hBBM8OOvSMkISU/WxYxtgIDO4lnDDK2M9FXPk/u3wEQtRtBVo+OaKUoTzdCQ4kYJTJXUczEh0LcZetLaC7cTwzxtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jsxwxpDF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jsxwxpDF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=79n6oU4o6fuFIfZ6VlNDRIbfI47efxK3S4Xd/LWOWdA=; b=jsxwxpDFXSDGcsPkNDIQgCUx6w
	Ygvif2JB7sZ8OUbwosE0CH0gGr/hvQ1DzAQK36/fECMeJ0PtTFqBG0Qyn4hF2/oqTtxG5VpMmfb2t
	b5ZiwUOg0iLC66AL98UeRtd2W7F+q3MBJp1CXuqtdbIdRzX5cDGW/V5d2fCLjDbXKjuxNvGqve/z9
	QwFgGUV0bA+AsETuIW0gtiU+Fn/WKxPfWa7EP9Ws4oWysejRBqFqC5IA/FszOFYLwaZsyu1CgVB97
	EczVcO6yF24Ii0F9oKBxX7FL2/kKuIPX/QagkB4JzrgXZ6ZVWzSMjpAfDp5aj8FG9BdN+HuO4pMmO
	9jcxLcZ3kaGRnbR8hlqG+mOlxn9cXlV7hlJdUO9YppavBmz3udMctVNusk0evDMcBN8HGfEJB/5sS
	piKgUcHx6iUDlrzsMK/JBI6SOha7+1xlMmBIlBxNur8v/FMFr/VbKRX2IUQCBApe97TfgkE/Kzz8t
	qOIVKRzqcviQyqFVHic8hZnR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeHu-000mlL-2V;
	Mon, 25 Aug 2025 20:59:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 107/142] smb: server: remove useless casts from KSMBD_TRANS/SMBD_TRANS
Date: Mon, 25 Aug 2025 22:41:08 +0200
Message-ID: <67fe9152f886014715eeda774c7c5e7267be4158.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At best they gain nothing, at worst we procude real bugs.
Note container_of() already casts to a pointer of the
given type.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 133898b0cd08..09838efa12bd 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -99,8 +99,8 @@ struct smb_direct_transport {
 	u8			responder_resources;
 };
 
-#define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
-#define SMBD_TRANS(t)	((struct smb_direct_transport *)container_of(t, \
+#define KSMBD_TRANS(t) (&(t)->transport)
+#define SMBD_TRANS(t)	(container_of(t, \
 				struct smb_direct_transport, transport))
 
 static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops;
-- 
2.43.0

