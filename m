Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794498150;
	b=MHFNlBeR//vSmzZICHxKFwyHGIW8fHSWPIA7i+NO23deQlQmtMHSiYMyRYE74WwWjz/S
	 C3dJHEGCtERTHQAenz70/QmVNnlj65RkwDZm57Js1WSq1Dxgb2p96Q/LHzEjqkZJUjEKW
	 YUycEspAMhcu6t65rOmbX7SLQF7yuCjxYDnVy78EIKYXm9NMrn59lldzQBufMm4GJspeB
	 RYZtc4rM7gpONXBZ0k1+9nlydgWFs/ITW46hR4K6iks1FuRWNURNAYvDA5D4x/BX0qTWc
	 FrsDK2ZpNw5mmF+fSMqwU/KrPUVSWdZpj7BJCDBFigQelDAxlsXApPdDqaEcc/vYLbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498150;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBLCGcqufQIhkN3sBdqHjkVXfZZ4ZTmimDtIq4+w0iU=;
	b=XANMuy4Z0xw9Bz/hCSQ5EJXmofHDdKPmaqkuqaTV+OTUB/v2lxJ1uR4voGfGoZzcxc3z
	 otgBT1AAa5kk+vYtr9wM1WRzxjDVfRvkQFSIvR9lQGVXg3pP8DaZ6GWCJyoLzEWpj14uJ
	 Ahrnv5l4VrS4+cUXyw2E70kVuxz8ph6Otf88w/VnVMVOYpBbsG412IOg9HI8WFiBIYTKK
	 T4WtYLM+h6Ie9b58Q44kFDctletjEjG+jN+eukdlVtRScnsNh2ERFV3qam7qTNgduxsb1
	 2UcCYvuG4lhTJ5AnUgT7Sp5ieRBBXWco05K/qqBc1rddn9xOwcxXfKznpa9zdVsZlZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q0BCfTY5;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D68606A89F
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 15:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7D68606A89F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q0BCfTY5
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso3174291a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 07:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498149; x=1795102949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HBLCGcqufQIhkN3sBdqHjkVXfZZ4ZTmimDtIq4+w0iU=;
        b=q0BCfTY5Rtk/u+c1WRC+vhl5bYaNgeAz/F0fVXViwEGncWv1eFzIWRapxJ7b/nGHcg
         74ySBPr8UY4G6hDI0KvwNEYmG9+UAv911kQUjyqQj6HJzTZkFsN8Tcca/S43Wfw8QCjT
         9kelHhqR+Ri5DO6izPoCKHpuHR6L/kNsCEaLwMHNboygQtruOQMH7ozYh/BvKzck/AGS
         U88L3vAqjkBVMYVXua5bAvX+T0mTNUOFlkJPWE6VNlpqA643S/gpfk/nhd1fnzGSH13q
         PQw1pvC5boWSzTl+05NCUpU1Y/k3Ld+qJUlOGeC6DThi/u6i7+oVtfnTvlX2b5b0wG58
         vY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498149; x=1795102949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HBLCGcqufQIhkN3sBdqHjkVXfZZ4ZTmimDtIq4+w0iU=;
        b=EorEIqB2U4Pe0ZnIo3r8y1ihZsjEGbunaHCBMg9yQQbtbR/j2dBGheum2IfDiVHib6
         dSlDBPl1sd8VXKjUfiy2FDDeLLv/USKFghXv5ApfwvEjPUzV9W0nAuYyWoF7bC0TnO/j
         GLZ3LUc5ft5jIpOcj/71qFadLfdyvJMM6eDj9iJOf3e7LFZSpE6jHhBIYT+kdSlJ6ocK
         ZgE5v5qXV/QpQvBE/r6trM88n+qK1cxfM+MA0128Ljkyi0AHLUzGaUj33KHucNLorWw4
         4uVfX7KvMxpMhp0wa7oZi3GkgbGe+asfBL5Bopp4nEHsz/qXwrYAxcPPXgz6lMwARQLg
         DZ7Q==
X-Forwarded-Encrypted: i=1; AL+hErE1KCH/WfbNnYytgTXZmy3yAJdIvTpnD9YtGD/UK6B3rx8+x0+iP+tvyT6VLs7BPV4SIRY9uzDa5hNh@vger.kernel.org
X-Gm-Message-State: APuU4Z+BVIiDZaUmFtLOd6nyJGxC2gPQw3/CAbzY2Vhw+y5lrY5iLxum
	FPouOgob/tIW7fWKdDxElR+2vjhD9iJl6Ge/KH6OpJr9xSLv94wTucee
X-Gm-Gg: AYBFou3yPjjTHuOpcCJMQdEQbSjZf6CavmtX0u+qfh58pmngAB/X7OlEhwRbMZdhaXB
	mZkLxBN8OSGjLECXoWpL+OXASZHeUmMj+vKmtX1HHUO3Z7Q24BBZHweGvXxUDqZQ7gMbNbRYn8w
	PSKnSqYM1VZpS9nCdaMQUyBuFvP+umZ/oDAS5G2cIvg7oiS5wdd56kAeswGZoIB5zforEgs25ao
	k578ToeJqvgtcHwDI0bGY1mTfUKZb8xN4nN1Zu7Stdatzs7NlrtZV/+1ImldXT8NX/K7cfAm4po
	XJLV5JEoIM/qiOre2Iq7byTxneP2VncozgV5Snk/FeBgHFoeaWNPGMFuSug6ho3SfNFN0oU4KMZ
	mK4nSTkN4DCsBfrEGeXgEsbDtwzqOtXn7UdbkzWIlxTVX2OkEZQP2/wXNhs0u8p9hfDuhd/Ot2l
	wbqs173h5FgPk0G6vgpFn8GpqDTJ7p+m4K9Ghl3T6CgUzKFqwYH/Ff/2yLR6oNZr8GnbvkW/n5W
	dqXV1KiwXQLd6XOlnDVKFKpc/sW4DkqCGNW5lrMSjfikRlGy6gDhfW1mgr+I7BOozskH3ppnwC7
	go2Fk9enzulAYF91pfZvnuLM3IWoMtCB1WiTpq94/VawzlNv0So5emWQcP+MFdJrJvoNGGetAL7
	LCyLsyI7frNC7FvJZy/cxTTa0yIk=
X-Received: by 2002:a05:6a21:6450:b0:3e2:86b6:9be8 with SMTP id adf61e73a8af0-3f2fe0a8506mr5804970637.35.1794498149028;
        Thu, 12 Nov 2026 07:42:29 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:21c4:c32f:67c1:d87c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa7de3619sm3790596b3a.5.2026.11.12.07.42.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 07:42:28 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: linkinjeon@kernel.org,
	stfrench@microsoft.com
Cc: icb@fastmail.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	ematsumiya@suse.de,
	lsahlber@redhat.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v6 5/8] ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED
Date: Thu, 12 Nov 2026 22:41:52 +0700
Message-ID: <20261112154155.20255-6-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112154155.20255-1-mike.michalo@gmail.com>
References: <20261112154155.20255-1-mike.michalo@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a session's Kerberos ticket has expired, smb2_check_user_session()
returns -EKEYEXPIRED and __handle_ksmbd_work() signs the
STATUS_NETWORK_SESSION_EXPIRED response if the request has
SMB2_FLAGS_SIGNED set. This happens before __process_request(), which
is where the MessageId and the request signature are checked. So the
response is signed with the session's key for a request whose
signature was never verified, at a MessageId that was never checked.

Anyone who can inject requests into the connection can then get
responses signed with that key at MessageIds of their choice: a
signing oracle. A Kerberos reauthentication keeps the session's keys, so
the effect lasts for the rest of the session.

MS-SMB2 checks the MessageId (3.3.5.2.3) and the signature (3.3.5.2.4)
before the session (3.3.5.2.9). Do the same: sign the response only if
the request passes both checks, and otherwise answer with an unsigned
STATUS_INVALID_PARAMETER or STATUS_ACCESS_DENIED, as
__process_request() does.

For a later command of a compound, the response that is current at this
point is still the previous one, so the old code re-signed that response
instead. Leave the expired response of such a command unsigned.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets expire")
Reported-by: Ian Bridges <icb@fastmail.org>
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/server.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 51aa981bcef4e..ca0c78447f454 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -107,6 +107,32 @@ static inline int check_conn_state(struct ksmbd_work *work)
 	return 0;
 }
 
+/*
+ * The keys of a session whose Kerberos ticket has expired are still valid,
+ * so STATUS_NETWORK_SESSION_EXPIRED is signed. Check the MessageId and the
+ * signature first (MS-SMB2 3.3.5.2.3 and 3.3.5.2.4), so that the key never
+ * signs a response to a request it did not sign.
+ */
+static void ksmbd_sign_expired_rsp(struct ksmbd_work *work)
+{
+	struct ksmbd_conn *conn = work->conn;
+
+	/*
+	 * For a later command of a compound, the current response is still
+	 * the previous one here, so signing would corrupt that response.
+	 * Leave this one unsigned.
+	 */
+	if (work->next_smb2_rcv_hdr_off)
+		return;
+
+	if (ksmbd_verify_smb_message(work))
+		conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
+	else if (!conn->ops->check_sign_req(work))
+		conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
+	else
+		conn->ops->set_sign_rsp(work);
+}
+
 #define SERVER_HANDLER_CONTINUE		0
 #define SERVER_HANDLER_ABORT		1
 
@@ -265,7 +291,7 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 					rsp_hdr = ksmbd_resp_buf_curr(work);
 					if (rc == -EKEYEXPIRED && work->sess &&
 					    conn->ops->set_sign_rsp)
-						conn->ops->set_sign_rsp(work);
+						ksmbd_sign_expired_rsp(work);
 					else
 						rsp_hdr->Flags |= SMB2_FLAGS_SIGNED;
 				}
-- 
2.43.0

