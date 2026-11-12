Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458841;
	b=JsR1AbbNGwQUuMtCMyldV1ZrYfQ3hUOm+6HD9LK4Yt6xikb9i7SKSs8Ob2EwVZcuRI/Q
	 OYjcr0UeCc06xxsNdoisQZ8DmMLbOHsmQYyBDEYXUOXE5ptxYuWVg/Ozs+fJBRGg+dpMG
	 KMxZoFol6AZWQLfZXsojx/TVDN0M9b2Kinz/KcToIoegBHfoK9YuJrwUSTEX+v/1ra6be
	 GuSIRHSO/F04CiQCxzMUCggflrUgGDTPWCuL35UpLwHtUwT+4VFVAAHLKiBT3gmt1hyE9
	 XqZEPwM+qePxu/kERT/nX4+4ZrYHjNjxdn+FRTK6uSqsvc/uNdqJ3Oj3cwSdQSeIbGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458841;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBLCGcqufQIhkN3sBdqHjkVXfZZ4ZTmimDtIq4+w0iU=;
	b=ZZgAn8x/qJqmPRSpnrDvFn4P8Jzutn4VSEF7gpTQrh2qfaShOiw+Bfd9YHePnnP81bMs
	 YuC/ye6RNme0MOXGYHqRDN9SjSgUF5Cz/YZEgo8/PyIz8nPnDHKiEplcQ+WZY4JwnB7fs
	 RGekhjx0Z9Fc4GPsPePPEwPstqT1IoP55REqm0yTH/ggIJQUrMjd/i35/xSoYv4pCcECx
	 VJD7iC08pSoKJIAW5D1LMUkaKhQsyQ2ZDHCQI6f5PNlE12y5hyPwp0/pGp1vhhx9YC039
	 NjzXuvJx1o68MhlvqRUML3xV5hAKTaId80FEPksJ/hKtC4DwCUFnpq86ItxXwewXnuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xh+OLvCP;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208F9606A88B
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 04:47:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 208F9606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xh+OLvCP
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so1890474c88.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 20:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794458840; x=1795063640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HBLCGcqufQIhkN3sBdqHjkVXfZZ4ZTmimDtIq4+w0iU=;
        b=Xh+OLvCPlLgl4eFIfpTLOuY4nuytx/msPDTuB7c6Urj9vS1TSnm/0RxeGI0eGL+u+8
         xgQffiVkq39/OpendSdKiGdPUpReKeb+FIMFzlgw63KuxCqmZ2+NYYy4LOD0TW2dVMBW
         gqNW8LgvpOZYtG1EIAHfUEeWxvWqnvE+Y4KKQ09+Ql9+eBMxqB0O3V6gGqkRHIDMW2+C
         1Iyrb66AZIqjtJWd4vUsAhYk/p19yJIbMKmDLAdJv6uSsV3Z+7apwjZ4wzb9rgzNFqeL
         4mKxbdL+8oJxUp9mjLltQrhZDq0H1y3zM84Eu3OY6ebBVXDJ7Y7diy7um5Rr9TlY9Afx
         jLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794458840; x=1795063640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HBLCGcqufQIhkN3sBdqHjkVXfZZ4ZTmimDtIq4+w0iU=;
        b=bwsF1eGZPmkonGKSM4O2fGOU7CaQe8OMlYMDMzbXpYHNCiAzWaglIT8gLG1Dv61GfQ
         Wyo8RMEzq7DwzFM3DuEto4Jn5KaXESgmAGrSRpA/1hR75zCVQr8ejn3iJc5iLjp1eGQB
         IVjyIWaNn29CSguR1K4Pl+YU/w6X9VRs6Tu2Yjk8mK6cnqS0ggBKNnEYj5rpoqS0p6R5
         K1mcI9CXJYVccUMgqqJcnd7+oUHHOPS1BLar+0qXQeen3xV7bylQ2BfCN6xf/7ZThdzK
         BseR58pcJzlvqtLV9iDuXnxqhH/YJUNlz5dVoeqcC/LiEMWxJPbJFq5YA6zHiI8Wc4v3
         PLYA==
X-Forwarded-Encrypted: i=1; AL+hErFK1CEFlKhJO5doM4X4/URCyx7K4i9IN0AOqeDRV6CGZlJsuetdUdbGvkhNUQROhPxeFKoFFlYBDPhq@vger.kernel.org
X-Gm-Message-State: APuU4Z+wncTGAJRUPFNxZ8x3dnluAJnJhqZQJlFav6rwTS7kUTozRklr
	XwL5tOpWz74Esc8qGw7C8mBMQLUTqNvYO6aL787GIEcsedphvV3v2ptk
X-Gm-Gg: AYBFou1Di+c4pUtZ/3eX2gs7dzrxmct/PlYYT73YBKytw1hKMz7GF2OwHJKzpNVF9hU
	aZqb6TL/O4ZhMOOQZa17fa1UfwwesvF9VT82LAux8Z48wpUplOJE8PAWfhW6qn/WleExtbaCOZI
	xbqykCX8vV+OT7VwSRsXkKqPA8GvZVU+g4GLxfkSWihSP8YrhQEm6nv4oOvKo2mHK9AF8+9+0cX
	aH/7wF+8YgCakus21A11I5gxHzHOKKc77y0RTtASgdTpCoj17kyrRBIUY2mmv7mRvNKk6W6fafw
	UfkbN5nRn9PrVkh+rJnkf5RhyNnU6nxXeWvBBWDmWuteGTrX3G5NYsbvInzrOT7S0y5S3UN+tRn
	2/aVWCNCi5WJ4n/hI3y7A8LRzUYRauQu86iv68ZvtozROnsX4xJnc+kLfyxwUELFeZjKuJfH8+M
	PdOrqr8KLUDlA2AeT7cCJpVm9n77NQchYC8CAWuhve/ZGBXtElRU6IOO80Ul+pcJL9Y1hrXivOe
	7DD9ZP1Lu8aURA8PX98fXJ2OMoW3+JRHBq+RA2svXV1DljBD8HmznHvNfbmgSRpTuES0EAjgsxQ
	scSGHmqCRhNildZLK/w+y/1rdYDFcqQcaU0GhafjVVlbjkGrHUzaTt+xLeEsflSkMp8ryaTKCRs
	1X0aOjR8l2IY3EdPwvE/8BhIe
X-Received: by 2002:a05:7023:c082:b0:188:e51:e86a with SMTP id a92af1059eb24-1b3c023c45fmr3692481c88.2.1794458840206;
        Wed, 11 Nov 2026 20:47:20 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:5d51:6f:e2db:335d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc14sm21024827c88.12.2026.11.11.20.47.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 20:47:19 -0800 (PST)
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
Subject: [PATCH v5 5/8] ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED
Date: Thu, 12 Nov 2026 11:46:42 +0700
Message-ID: <20261112044645.4074-6-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112044645.4074-1-mike.michalo@gmail.com>
References: <20261112044645.4074-1-mike.michalo@gmail.com>
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

