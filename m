Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794498162;
	b=0xy4tqJUJuS1ylwS3WbJU1yqIjIcdyeqT4bXl0BOYWeLN24Z1kaNuUqG85VgeyjyTazZ
	 SyZSdq8EG12qnUUlNwa5nnwY0KSDH68M2VMyEatgJZKI/+2y/QXn0jlmzFLp+SVxIJPbz
	 Am6/9c106ExmB3Jt1GrAgcZ/zcewDx0R10OMRTl30EUPcEFwBOrehOdso2+Bi3VjxIFTq
	 /nv7Ho1qdaHNoELYsCOsvy6SkPG+9qrTpy0g+p+4E93lH091/Kzzy65BQFy4bjyKD+/58
	 gJlI8HmI1YRMFKI07iUtGs5a4ea5p54ZXfNTJAv5IYrdiX/N5wgWdOdN5H7VZ2yjyGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498162;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oadj/k+YUbXCuqf8XiX+YDF2IH/fTwUIifcUE08h3Aw=;
	b=JrNSLdbC15rkQa38qTjHl4Y+ePxbGAsuYSHnyXwkDBm6otPLx3Bt0V4GsMlHbH3MVWro
	 ISoz6g6k2OHdbaLsvOMRIH5fqpi8R7LXE8nMUBQPC2mtCjPaSgeAGoejE3ONayblFpABY
	 IIM7Dr6/tC5VRX9qU344Quw/pmIlhyrZZZTgm4R8nFvgToyH8vOZD/igGiSwTjTT118I4
	 /nvgRE5QkY4AWdT26yYa+cmgBcsqZk8S4eXGmu4LIKvJnZh/3j7FOxTfKVr7eDr2inPtZ
	 4sXhzU+xAokf4DHeBsGOqX6GunsJ/KV6t53YP8WpUcjY2Yu9xZq/4n4337UkDY/ZSwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IajlPuVg;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51821606A33F
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 15:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51821606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IajlPuVg
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a06cc097c7so885918b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 07:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498161; x=1795102961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oadj/k+YUbXCuqf8XiX+YDF2IH/fTwUIifcUE08h3Aw=;
        b=IajlPuVgKrGxSLaKBXCFVvTjOWrJ45wqfmbFNCXWvH3GOxsz9PtFqOzjeKDjHrRxq4
         UDtDoDfpw8v9ofu7III84PY0yzFnBRUQ58F+ilH8hOVIGKLQrAVIR2A0oX76nqOfJemo
         1+zNV4az6Do0gJ3onTQFcgvIzkRI0ox7waMjTyShxaUfXkQbUa4DJbgOKDBD25f8D625
         TjM2Q0gJcF75eAxiuSNN4kK0qTh48V/fUV1QGApW9Wc0B5zrhnOQwzEG5rzosJeTOyhw
         H124mEZQG009gT+LWic5p3tatTu2qkzXwDG1uHRLLSfR4kRB39S9Xnd1l4tN8OWqrYV9
         jLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498161; x=1795102961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Oadj/k+YUbXCuqf8XiX+YDF2IH/fTwUIifcUE08h3Aw=;
        b=27ezjiGrs7y5iDvFzBiT+c2C46YYv5VpJYeDbMCP7jCs7AQFL8Jp00pr4IrnNRKWKS
         1u0kUTtGt/T8EtZc5pbbqvJPNaJV3s7KZeqIcsCiVGTTfG1EmIo1v8HBGHgMylVBFpns
         Jnu0WVfhV7mFqHdgEVLTw/h34suO0Vjo2jS/5TPsRInCf4wl/OpcjuorUQ+T18dzN+Ty
         i/VYQI/l8WNHyrm6Vm9iGJ6ys3fky4xyaOZOkA4L9ptCtxINL1etqoZaaphkZIL0W7zc
         kDqIp5JF1vkhWPQ7GzyUrVNa4l7VjSauUtyO/m+cKWVYOT9jFKyzCYHz23ZPsHqpPhPL
         xQWg==
X-Forwarded-Encrypted: i=1; AL+hErFiPOggnrK8cQ9sX3vvPrC67RcYCtHLFmFzi/i2qB39otKhMQyPUO0w7//4qyR5d2m5IoAbkfFzxCFA@vger.kernel.org
X-Gm-Message-State: APuU4Z+TA814lnNCxA5kaf6HfdqV4UqV0FAsV5oq0ovGV8B1lhdk5AiZ
	c3uaKmJUMUese+aQPLY9t/qVVnB2Zr6Ng/GAg0Y7yq+zCvubJAJ5It3c
X-Gm-Gg: AYBFou1JzDfna9H/UVaoX91ZBcWIMWpFHWUkwo25sTqMv40KjqdwUzx5LfoJLQKJGUK
	XaSU8qYhlsfQplkZnhJvL21dAqGO+nU6Hqrlq7SH7ixcCVn/Bi/zKX12adlqB2AaGGoVeeS57jO
	xEW/7wEIbF/TgoEKG2DYkYh2R1uk/zx0DiDTKXNJT08pVCPSY3+zrVHQsUvJgTPq3ORqqgM11z0
	THHimMpikEN2lR7+X1CGaBKMU61i+YNFymEK0ag2kJcEyoM5RHDDbmv0CaUVLqnhDlnj21cOdbD
	TMsUcvG+dYD8D7kvth9j+w1L7+h6dy/s5ZdnlC/t6Ah0aIBUg+md8FmrQhebhN6TCu8qCgmEHLY
	osI8/yILdEGOQfewltzpMeuVTv/IV1c1Dm6TYutTBtJIdSgu+LVMKKibDaq8PMyCnbp0xpf1uhd
	o928/7LYIvMTgmHHCpN/E83ualQ04a7H0LYlvOimB/7IEBAEpi/fcPyfR0fzi1Fh94Dcp6vyiWz
	PZRNcb1dAHbzltwIKE7Vm7etA8KOPomcynsRH33K5D+Qhf8rLFAEq7w2Qs71UiUghg64J5h5DpK
	Wp6d9VcWVJLIR2IhczUcas4Tbvhas7hvAaZstmnYf3zBXxmuHP/RWHlcCAw/RDXnMBpzUspMAmF
	Kgxr6hbrBJq+iUrx+CkB9x/FTyEg=
X-Received: by 2002:a05:6a00:f8d:b0:857:7337:5db7 with SMTP id d2e1a72fcca58-8bc1bdceb15mr5652943b3a.21.1794498161442;
        Thu, 12 Nov 2026 07:42:41 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:21c4:c32f:67c1:d87c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa7de3619sm3790596b3a.5.2026.11.12.07.42.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 07:42:41 -0800 (PST)
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
Subject: [PATCH v6 7/8] ksmbd: consume the sequence number of a request on a failed session
Date: Thu, 12 Nov 2026 22:41:54 +0700
Message-ID: <20261112154155.20255-8-mike.michalo@gmail.com>
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
answered nor consumed, as after any error that ends a compound, and a
request refused by the tree connect checks that follow has the same
problem as this one; those are separate changes.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: fd8c97d7c1cc ("ksmbd: implement the command sequence window")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/server.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 32bed8672dd2e..52eee04e0d93a 100644
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

