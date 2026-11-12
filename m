Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794509479;
	b=36dhRO4SMpLEmOVd5aQ2nAOANMq8+k1FtmPM3vRC4Tf/4uPz+V6+I5Z7bnCorzNE0eE5
	 fdzTfjlTzSlvioDTdHOPClzKXz7WAywSAwTsIUxa6hkXxwFkv903BWlSnYBJjXKgr5ASP
	 y89I4dPXIizuh1fXK0t07zabHlKrwM6E3JVz3Ccx+ZBeSjuZt3rmitsp9r/N5mPLO0BFe
	 27w9N1nhcCXzgNu6CyzrbFj274XM6uzv17RGmiy40NrHooC4Fj+lAaERY79GqnjGHTabA
	 ttLE+RGJGE2CmMa8XbjI8946xdsix18Nimqk/u4C+kMMnME8pBQbQnmM6X9upLyknxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794509479;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBLCGcqufQIhkN3sBdqHjkVXfZZ4ZTmimDtIq4+w0iU=;
	b=2TxRGypOec2z4Z3oR3GN8F56Sa3gT8e+OJQd0RSnN4X1JdEn6y1Wi987UjarmyxpHszv
	 lSQLqxcQYxesz+2gx8gXPTRmmYBzRTEOpOSEVT/bquJSRgcluUrYUi3wAsf4Mzy5FZ/oT
	 FFORqr1yHX74kQ9rxCOcXim1u3NJOZrOxkp34EwxKX0zNNCi+D9cfEWRsYLPRZbI46uba
	 jG+naB9VvVMk0/4wLblqoj1Xdc7w5Nj+skPerYj3MnXi3G6XCpryMUms48zDBb1f9DBD3
	 R0WGtjRi8pvJ6EupQC92SvCCt/Es39+oET8YlMeEstskoHcXo/w3HroXGwyl+U49yog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hwY+5RzN;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08594606A339
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 18:51:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08594606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hwY+5RzN
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e95bd1c14cso1723555ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 10:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794509478; x=1795114278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HBLCGcqufQIhkN3sBdqHjkVXfZZ4ZTmimDtIq4+w0iU=;
        b=hwY+5RzNav+Xc5/KpFV9xLus3XSbeulNc1inwJafWYz6t1MVYNLqq9e/ngVg+8C2Ac
         /Gtrm5PvDOypykO+PIdnHhEQJQGEDU+8ZVs67b/Pdxfxd39qEu9wC19A0P0kgO5lwIl3
         Wquap4g8Yc1wS743xxxBAGvn2pMoU+hPOHECvFpzlmLpBaj69gEa0Khbf6vFCGGCJbpa
         Xe68BwnEsEP04T91N9PiOz/j/La6lJbfkCWd5DeVbtFY9MXir61abyt+LYkpgi6+KqbX
         g/IfldT/1zVA7VltJIkiiEKDvrlDfy8ZsSFzFzDgsD0vItBIFmsrJft0254rz4jbmdoJ
         BqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794509478; x=1795114278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HBLCGcqufQIhkN3sBdqHjkVXfZZ4ZTmimDtIq4+w0iU=;
        b=Y32ypDeFWNI4jPAluAlCEdGEoJKPxb1LSHilBbcjrl7fvfcXJo71tLonZM29lKJbrI
         regFUWmmbVK3Fv/ZsFzWN0lzVQS/DucEDEKs9I9JMLFZLp7V/lkov864TQiWMPPdtmnS
         JvK952iC2aoLAmKUc+Di4tTXJNbdlf8aBU6rTgpFH1VNFV3SvjTsjx9FsupFAeiw+d12
         C+MC1fsicyi2/dMGDxVTn/MfOwBqVkZqMBtEZ3o4C7qeZls3QNa5THgJYApWtPySZi5C
         3eaJ3f/AmJ9h3ls289G8ZSeBHRT0KjkMtCPiPSFJ3UNTm6OStTClyIQmD+dQfQ1IAIsz
         D63Q==
X-Forwarded-Encrypted: i=1; AL+hErGArL65kYNtjGRboN5qwjU9OoMxmwkOngf9i4MkOC9PPD5kj6aEm0rVeVCNY2hZBhSC8PCoJGwE1MuP@vger.kernel.org
X-Gm-Message-State: APuU4Z/0+I2EjSkE8hJ4gRcZj7ycffHj1nsRdZ8PQGq44xQtfLN63JqK
	CN9wHpDbKxlJenFJjn5NdEqbtXqXAxY7yIqBk2ooXa/WTO6Q+9ZLRV0M
X-Gm-Gg: AYBFou00GkuObf++4QBZzapRsETGEIvoc4kYRGmf4DqgS+2kyUh8madd2TOpLm6lJ9p
	OIdYRklm8zWLOw7gZRlf3WMe+++ixPeIuQQ3+a0PTBO4s9GbfIdLCvNn4bpwyjBQ7rsICR2xoru
	VAUyNQCsR+daXKXf59+TyJRSwwTMpp75ThekonAkgC+I4ifHnXnMVrplix4IgVDxf9E17Bmhcqa
	FcwdFtbmHW2op5LKAhSDlrGIwEvBTQNS+pnYDQar2M4e1VWku0Vfc17TJ/Zabqg4jKKh+hmkc5g
	1d7iLhC4YumT5Jqq4FCyV79eZM1r6soHHcvXa4fqWzrZh73Yh3MvPoBJJFeSx/T1Ea/h1WtmlaW
	3/uqb7KuwZz787peTej+iRGD355BB372WeTc+PrkYXAjm8VNRu0mEBqFhf3KVFm5qP+Tki1V6pn
	F0bIlnRtKa4SPgMVTYRXXkoUm9cmcL3PtpvTT14uKVXHfYXkiC3ui3Z5CXXeOAK0nUms+M70mwp
	dpsnHNx18Hpm42O2u7NnTzRpWd6WzoJFFNX9qRs0ZamF5c7F21YBdrcSxPJgJaDQmEOynwdYLqp
	XghDVZBscqHBSPMkYsv0L8AL2NW9RRfZUvZdX8f4GwHugC69WfxuxW8do4YA5SFZbVUS+XDluia
	xgz6x9QFfFbuP31BcUBVwijcTvw==
X-Received: by 2002:a17:902:f54e:b0:2ed:3f47:9696 with SMTP id d9443c01a7336-2ee0de14c65mr2745765ad.35.1794509478186;
        Thu, 12 Nov 2026 10:51:18 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:cbb:dbe2:bd9d:a035])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7cf7bbsm66205ad.29.2026.11.12.10.51.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 10:51:17 -0800 (PST)
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
Subject: [PATCH v7 5/8] ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED
Date: Fri, 13 Nov 2026 01:50:41 +0700
Message-ID: <20261112185044.41571-6-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112185044.41571-1-mike.michalo@gmail.com>
References: <20261112185044.41571-1-mike.michalo@gmail.com>
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

