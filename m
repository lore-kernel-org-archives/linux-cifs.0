Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992025;
	b=YEWMp/09nlH9dT0D4jz7dz8rTIkzVEJYu0bTNMug7k61LT3o0WDBZqrqT7cBGOz7rOl8
	 lmSJLYBtpxfwEPeiAW2yQI1XbgIbsSdq3BuA8HM7FCRwWSz4VFKjJXE5pDOvLS+c8TRsq
	 aJzbJ5qkimNSCvSaCccZcN2Wtbh0Dxq8RE81FVS8JlMQHMIEgtvoTJYn8ch0LwuyKqWx6
	 AE3nxa89jqjhAxiOyfaVrK/3VAsRZ4xBkIdP3Cud6lU0wtPJttbWvEFt+NugWxQDJSomD
	 jLixKR0ACA6AHi4OCC8XC2q+wN4ZZvzfGNfKngwZHQXODjSews93c2maB2ysGORVD7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992025;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YMJu4XLBqQ/fEGisX73M6D244sbUdTxsQ1NSbRoweVc=;
	b=Jueads9PNAY10frkiYXB1INqolgcoeW49TUWp/28p3raecBo42trEEvjJJEhNc74SOLn
	 Ghj0okGk5AmbRu8+f0QxkB0AVliKduvuE72kF5lr+YrKO12+5KtTSToAoSFw3VLYAc3IO
	 K2/lJE1PxiMs4J1uCU8/ljGMj07Vh84o4VZUgtvrNA0E/1hr+/ur3uwcdi1N6tKOVaHPp
	 bsa23DegLHiKH1x1bK53yesK5qxXpqX5k55S6JchS+IDNgETRA8mdOQVtUMhjDibAC3br
	 iCCNrF7mK3f+pw3VLGmUg0G5NJqg1vNe1xYcGaSFbdPZdE78gNbRWyItsKEyjWnIJkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="wUtTXUy/";
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D99E606A32F
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 19:07:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D99E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wUtTXUy/
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-491aaed7565so587431f8f.2
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 11:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793992023; x=1794596823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YMJu4XLBqQ/fEGisX73M6D244sbUdTxsQ1NSbRoweVc=;
        b=wUtTXUy/GvL1ymzkcDRgg6xpVxA1BZEB7KkgnwMqpQO5bTNN74ON1+fT6zkGlJlm34
         /rbI2zJZETBP6tU5Oq+AqkP2KvVuvPOTe22ruPWbPBtmUcm5yih9bOelUjfTMz2V9mkT
         b7+mbqaqSfYM2ZAoKchwTcRJiEQCpP1gznRY3tI+eAla24c/cjrC2b7sP3yq5AaHKmco
         p3P8j5L04jyBAqNPs9RRushrAlNAZSExy/fLKZNVdKh/q3Sv3BRZuk3M4ut1AwvBp+dU
         A35pGA+70UDUHabCbUdhKjQOgrl0cQceDy9caSk2RpIwDmDNNQfnhS/jQ7wBG8s87FnV
         QsUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793992023; x=1794596823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YMJu4XLBqQ/fEGisX73M6D244sbUdTxsQ1NSbRoweVc=;
        b=ZK+uxdK1oWjrZBO8lpleilzB2mICBHHkwxLgHtKdoq8aU/qEwXN9h9sUlaLyt39f4H
         fE4qAaShRB5kJ0gop9g1qhNsC8xJitwnZvSOQEcphwRgUd449ywysWEqAjnAzn8cDTte
         rt26y/UWHj4lysbu8teOGXfKnFWRKRcx1Ifn5RZTiyVPBrlAWUh7kbhEt9uzEGigI4/p
         qXEBzIhQQH01utp+AL0xKdvvxnNspywwwcxd8+AzqLuyzbc+LTc+rh5syODK5grPuQuS
         B5+iAiOTE4jiFnC8YBV3Yt2u2IYU9wUN8vjlJQWQ5bmWc/CfzdziMYVtkIqW2QTuIg0b
         1/Yg==
X-Forwarded-Encrypted: i=1; AL+hErHvc1F1Qj63dPm/Y6iZxmG17xUTe9QQFxsW/D2k6aX4H7lOP24PlAGyjZksEDvUL+14zGervVUWZmR9@vger.kernel.org
X-Gm-Message-State: APuU4Z9NZF+8j9NqbJd0ZyT6E7qCTF+t2tW2BwWDkzO6FiBzHIUZBp1F
	whpAp3GJAyJx1bIL9X85OaOM1e4Un5BSY1SzK+ZNBdPNh467ay38ILLV
X-Gm-Gg: AYBFou30KW2bCGgbd+h3+/FxuLV3hxraZVzTF4WeL92rEcJPvNBQeuIARWr6dCJQgI2
	rpLqBGXhElfeiNuCVO1DxzMKJMvMuquuRpHavgorJTVc1dEZj17XNl84vhF/SB0cOGnaR3fnBOM
	ypsyfAjHQxV60ApgruVMfHgTWkM9Rw9JvceEPWUEEUER7y+KHmtk6o3Rc66UnIcekL65CAqlu6/
	Y2XRPR4a/zQ0aQXPqEC2OeGk8u6FP01SvEUOaLJm/nm/Mz1I4MNBmlwjTKCjm4ZxJF0gv8odUIf
	KZJn9rL3De2XefhB3wx2FHnlPN637H6juHSmQ1eExZVRz6Qsf+HRUNcHPgvtuMV3tZh4RFG73CN
	XCAB3kO3ufWQAZ+2SWNbRigh/kwN3YxG6OEVcgCxbAVoQJ0eyv9kJ4diecQUq1WePqy7Bu0o8oF
	C/82wuCP8ObBkZB+bMMnErdb1kPePJmfH7em5s5n2OzCpjhVH3V0/Jfkc8TdN1nfULE9uN/D796
	+Ws7np+VEpLup1rSKnV4QvaeaOsBfm20Suy8JheHjJiYcnVpMesIPOK0JbiOkjXKLfgAmv01nd7
	lTennA5rdT4EACAEqCV3tAcJdYDiMAgf9VBHATmNO0x/hPmYAqk+nDxMTAH0TAX8yRYuSPspzFL
	MdJUqynICBuKgHhs=
X-Received: by 2002:a5d:5d83:0:b0:48d:fbf4:895e with SMTP id ffacd0b85a97d-492764aedeemr6683116f8f.11.1793992022611;
        Fri, 06 Nov 2026 11:07:02 -0800 (PST)
Received: from localhost.localdomain ([74.244.226.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4930a5a91dbsm3960533f8f.35.2026.11.06.11.06.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 11:07:02 -0800 (PST)
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
Subject: [PATCH v2 4/4] ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED
Date: Fri,  6 Nov 2026 20:06:22 +0100
Message-ID: <20261106190622.20990-5-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106190622.20990-1-mike.michalo@gmail.com>
References: <20261103171742.18816-1-icb@fastmail.org>
 <20261106190622.20990-1-mike.michalo@gmail.com>
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
signing oracle. Reauthentication keeps the session's keys, so the effect
lasts for the rest of the session.

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
index 4430c8d6393e..bd4db44f06cd 100644
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
 
@@ -276,7 +302,7 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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

