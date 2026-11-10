Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329961;
	b=mK7teWHxE98rZhG70G+gRGL/oXyD+9kfTrdBVvHXZ1MnHCEJto3zsrz0/U/XHEzA2Fgy
	 0CMxWWSi41RTL3fO6lo1UV9x1gtomJxdN0slMyJOZGyUhBnSKE7ZJBgGW85rmspWvdYg9
	 Prf94KvgmqnxeHHCRknZc5VI/6bkeTGnJTs5p73ECmg7L6okNAuCcvMnX2w948XmBWJtg
	 XD+LoW06jZT7X4UUxENO+eYgir1Jppoxj6sXRKVsiqwcWX3TO3jrhoKX+ZjzF7weTP2P6
	 0kGsFQeRQqEz4khipQ2x13Lo2Z149bZxUM1iR/G+MCmRG1zLnDA6zG25KS8hKbEE4Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UZ/ExlSldP4/rbOita3JeRaRAyJwH7hKfGTv9i0JcTE=;
	b=e05IZjiXffVDUbOd76ktmESqlvY7vCTUyMtdhDvBw5NeBfZElL+pFhBXOlAtyDJpj8Fk
	 Io3YAJpKRVvMErlte2e7wANHOHP2ZRCGPuQRkt/hEJUlcWnj5YWe9nC3eO9nLnnzca12w
	 IMck/w6V8/t5XapYA6Ky89cdthNzYclE0yWPEjK1Y/w5jOqwqxduHXFzaC0pS/mmtGgtU
	 hUkdx8+432WaqQKFg+OryrbJSIeCIKyuYgUFzhh5WQrQu/5o5DTINCI/HCVvN0s9lJZ3Q
	 ItBPZyNdUGcXpQ0l5arpvm1xSaR0X3c8nZCfR099YAKTuoxBEiRBLiBhhNOvBjne+lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vxf7Nh1Z;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C46F606A9C4
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 16:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C46F606A9C4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vxf7Nh1Z
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-89d6bd67045so1266405b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 08:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794329960; x=1794934760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UZ/ExlSldP4/rbOita3JeRaRAyJwH7hKfGTv9i0JcTE=;
        b=vxf7Nh1Z24RTvN9FwqKW0jSRILebSLzBbZ6KAEGfd4PmUlkxFBJQCuTnRzp3AXm1Et
         zRHX1slxIq9ysn3jLVyshOndV81B+Qke4y7juBfkv+yZaxJNzuA1OgjyzBuquphAZ2Ro
         nHBMzoVVKK8t3RxnDVfg3eCLakSu9oSJx+yuJV2yOO9twhiCFsEcZZEV+iKJMvf0e07g
         WG45Wb7K3rE3/pIwExDayq4UG3SyzIErBCelC/GQA5z+Z7X2vK4SrGUWG35bsIlzA8Zt
         OveDWV47W/Lr/2az7oRvmoUJGjcA6GpBm7iuphnQp2rTtQDOnteaJFXdepdYrZCmdRr8
         wVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794329960; x=1794934760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UZ/ExlSldP4/rbOita3JeRaRAyJwH7hKfGTv9i0JcTE=;
        b=yvJvwhJp6XqXGzbSNT7Ie7dsc97+PvMFebKA98MCJrItuJQA0orlMt8YdKVHmsqoZC
         cxOmeBqkrkQnjQ2Hy3E/sfst9cyGtHlQVdWtkGMvkbhH6fImm6Q5wIUZwtIL0x+WkUN/
         fZOUNggz0RU8s+X+OPFerJyZATTaZhq0XG9X+lbTqZ9s+I/TccHBN8GOObCtJO2Nlb/j
         rOcFlaipQPkWDch14bGO9V8YnSUkm366Zm9ujdPvhUeYIxbguvJVmGqDR83hhK4xAGD7
         E8nV/Na0TOolFx3+YDv9Hxo6AzJOqmxnR6g85C6SynX5gg5/k8OuzLlcpyy3G1X8vGsX
         P4Hg==
X-Forwarded-Encrypted: i=1; AL+hErEy/qHUbiWa56snQztf5teGml4K3QkLEirS49KSWytB2zJsZQdoRuJTMdN2JM3K3SqULu/GK9Y9jfhq@vger.kernel.org
X-Gm-Message-State: APuU4Z+hEfILcHsmG94ckeD0rXv7EjcvH9zcoyYuSsg64dn1r2jUGX+I
	75GgkLRH7qGii8HlUBoO1zaGJrYkh8zQgy/y3+uls3YybuJlGsOkkbDT
X-Gm-Gg: AYBFou2/xRdI1A4fBXdLyTAXItsBG2q+q8bbT1pN8F1Op/ywEjROUWNp7EdN3JrGijZ
	kFaRVPyyPRl0qygIA8RcinCZjsAQYCYfdbxFHOKi6IWPUMaJHU3Cl5Zuk1LbwpcC28osQJQrlFD
	tf0vXKaRhC6HXWX1dvAlbSFFaUNxJwkLzMmntLs6GZ20vxSvJnU5/hh3VkU6pzb84RVcWAUTa8b
	eCRcFuQ/I8KLcFhAM1dNpVtw76CFFQ3WVq1pQjMoXeZL2RtUOBcQ331wT7Ej4RrM/kG3LTrrD75
	WvU4f/qAF4G93sP8xlYHRUi21JiRACfYXUYl86ehUMLfRqCRvHlzYXqw5ktAQfDMNUwrA3yTEnR
	Fs4Ob0QXGmLk4c8ohWwrV6KNNngtrL6nug69chbYNOKvQoqDckBIrsgjr+RMUohwjBptuyg9hUD
	vk1EPcqBKVrhHZjVqrnOEO1aTvKARjbzZVsLeDRDh5Y4bhPAQ0wdR/6h/HfgV5CeVNpnGKHzhjB
	vV8Y7dUY6Jds+zgGHpykKypsyPTsPd8cA3oyVKSbqXZ3boVQh0rssn5tzN9k9+dJjpVU80R/R1q
	Art3nyQ+ipje+QbEjRMypPrgz5s+BMw7c4VUdq1JgYll6Dq5dAqeHjCh5SxY06gDozBqr9A0KX+
	voZWflryR9Kcd8dEHenXRoKaBd1b/AU+ZHBqXMurPftoxsZJvj5tmJU4=
X-Received: by 2002:a05:6a00:430e:b0:8b9:227b:bfc with SMTP id d2e1a72fcca58-8ba9474056bmr2246885b3a.1.1794329960411;
        Tue, 10 Nov 2026 08:59:20 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm1157154b3a.46.2026.11.10.08.59.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 08:59:19 -0800 (PST)
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
Subject: [PATCH v4 6/6] ksmbd: consume the sequence number of a request on a failed session
Date: Tue, 10 Nov 2026 23:58:34 +0700
Message-ID: <20261110165834.28162-7-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110165834.28162-1-mike.michalo@gmail.com>
References: <20261110165834.28162-1-mike.michalo@gmail.com>
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

__handle_ksmbd_work() calls check_user_session() before
__process_request(). When the session is unknown, invalid or expired, it
sets the error status and jumps straight to send, skipping
__process_request() and therefore ksmbd_verify_smb_message(), which is
where smb2_check_sequence_number() consumes the request's MessageId from
the command sequence window and refuses a replay.

Only a signed request on an expired session had its MessageId checked,
by ksmbd_sign_expired_rsp(). Any other failed-session request (unsigned,
encrypted, or on an unknown or invalid session) left its MessageId
unconsumed: conn->seq_low then stays pinned at it while conn->seq_high
advances as credits are granted, until the window of
KSMBD_CMD_SEQ_WINDOW ids is full and the connection stalls. A replayed
MessageId on such a session is not refused either.

Verify the message once at the start of the failed-session path, as
__process_request() would have, and drop the now redundant check from
ksmbd_sign_expired_rsp(); verifying twice would consume the MessageId
twice and refuse a genuine request.

The commands of a compound that follow the failed one are still neither
answered nor consumed, as after any error that ends a compound; that is
a separate problem.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: fd8c97d7c1cc ("ksmbd: implement the command sequence window")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/server.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 13341ff38aeeb..e3fe856a8258a 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -109,9 +109,10 @@ static inline int check_conn_state(struct ksmbd_work *work)
 
 /*
  * The keys of a session whose Kerberos ticket has expired are still valid,
- * so STATUS_NETWORK_SESSION_EXPIRED is signed. Check the MessageId and the
- * signature first (MS-SMB2 3.3.5.2.3 and 3.3.5.2.4), so that the key never
- * signs a response to a request it did not sign.
+ * so STATUS_NETWORK_SESSION_EXPIRED is signed. The caller has already
+ * checked the MessageId (MS-SMB2 3.3.5.2.3); check the signature
+ * (3.3.5.2.4) too, so that the key never signs a response to a request it
+ * did not sign.
  */
 static void ksmbd_sign_expired_rsp(struct ksmbd_work *work)
 {
@@ -125,9 +126,7 @@ static void ksmbd_sign_expired_rsp(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off)
 		return;
 
-	if (ksmbd_verify_smb_message(work))
-		conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
-	else if (!conn->ops->check_sign_req(work))
+	if (!conn->ops->check_sign_req(work))
 		conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
 	else
 		conn->ops->set_sign_rsp(work);
@@ -277,6 +276,21 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 		if (conn->ops->check_user_session) {
 			rc = conn->ops->check_user_session(work);
 			if (rc < 0) {
+				/*
+				 * The error reply below skips
+				 * __process_request(), so check the message
+				 * and consume its sequence number here, as it
+				 * would. Otherwise a request on an unknown,
+				 * invalid or expired session leaves its
+				 * MessageId unconsumed, which pins the command
+				 * sequence window, and a replayed MessageId
+				 * is not refused.
+				 */
+				if (ksmbd_verify_smb_message(work)) {
+					conn->ops->set_rsp_status(work,
+						STATUS_INVALID_PARAMETER);
+					goto send;
+				}
 				if (rc == -EINVAL)
 					conn->ops->set_rsp_status(work,
 						STATUS_INVALID_PARAMETER);
-- 
2.43.0

