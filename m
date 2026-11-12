Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458851;
	b=b1QWWB0Ip09w2i7ph0Uuv4F/tf0pZCLiWf2RR/BQMpisZYHGXeKjW8Uzt2cGG0CMbF0n
	 cXcfnPz0T5PfmvmQDvI1xPrIKtyCBTGKHN9NtDsMdpeEkeozIMXHYIRVyzNAJ7+rWfRYG
	 rdEgSFLCrR6jP0UquuTE8jI2wBT0+Ia/g161S2aH9Sm66RpBJjk19DmCuWOKBKUR/c54R
	 pX5SSYp9fNSdW+Gwua8Qs73QHRnrgNZyR9mspMfsiwWjZr6ZsCWeBl0XRQJ5P0LqAYMt7
	 ahfuoxjiQcpuKT9omkajNur5feM0u7PZIOVs6T23hPD4hkz9PLG/6Wg+2dbWTDRwO1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458851;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WR8j2TwPDUPevNVljLnHtKoNr8/4X2azosuFtL+wyfU=;
	b=BOIndXFOE+C1tB1g9wu8BESicjKMefOAw4wint9UCksdmp6hBRglcF7go3MVjr7llWH/
	 B5ofNremq50OVObYcM1X6hnbsCITiUIVyHf8QDSj33YtdFNQWvksQd0KnPHYOXzD986sa
	 +n6t0w0Jz/PtU4Dq/aNK2ixnrqll29eadPgd1NXe/2cG+EaCjAzMey0pg/yFllzP8p+kV
	 RBUw2CiQoq2nsVyE1QiEB9JDtmGsuz3pdiJexJavuG+aetm1XejmuMyqDvOmpJLGMyOiF
	 e0OKKRc+z/MZXIpsOPDhooyGMckiCWnpmX6aVm09yw2csLtdElZRsRmOG1IvlXWFixg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VKMwDZF2;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449C160A3833
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 04:47:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 449C160A3833
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VKMwDZF2
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1931ff67a29so7041622c88.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 20:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794458850; x=1795063650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WR8j2TwPDUPevNVljLnHtKoNr8/4X2azosuFtL+wyfU=;
        b=VKMwDZF2V7rHE+kLkatC4a8bzZpq5qG5dbBrzyfhl8TA2vUfIu2E8cFgnr0muNEQNM
         z4iVImathAoImGHzpath9hFOwWxYv4V/6bCEye6KEovXsMAfWGVG6JGrbZhAT2Q3Y5xM
         xNWJXVXWiN2bSxZzoxAc+Mnvhu2z0u6nAdXf2wtL8gSj/avjLdEH29kXFYD6DqvULih4
         bPC4JYAuvo9OjkgcJlNAXNXDqSyDnIJoHnnFAac6Mdt/SkFLSbb2G+eR/AzGvkNsdIlG
         kvbAdjeVDGFfudjVfQR9CvBHhApl77XX/aM51orYfm3Cxt7VQ1exiG3pI4t1Y/TrcSqW
         hI1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794458850; x=1795063650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WR8j2TwPDUPevNVljLnHtKoNr8/4X2azosuFtL+wyfU=;
        b=ZPURXXeoD6Ki8LxEIHWVyDMKYPdIdLrYDJacerljxnGtkjVlScjhh0pO/3g3Jo4eGE
         +RSxcZ/C1JiltAcd3fCRLLMi3w5mmcd3pYgBQi0WV8nEqUe2nhH22w/W6r7eCPnH2koH
         N0PASxHB0mx1u8cdaMxDZd5Xp9MdeVldB+vj8CVHOP076FhYecX0KqUNffLsV3EhP4zX
         fx3+5ogHqJRZBPlNVw0jReAArIyVtM71A/UFhDCDOvbDics4VOQBbT5pHwN3XUONGLSp
         L2y9WGi/zY1QpQ8bFnLo9X3HntIrIhyWOISWU0q4de+by/A0ihHuy7b+2DPU28qK7lC1
         sSdg==
X-Forwarded-Encrypted: i=1; AL+hErF4OKquSsFCE4fL8dLB17DJwHMXQwhJ+kiaBbG89PPhJngbAEPRvdkFLh7AYlloO0/whK7j9d7/HifK@vger.kernel.org
X-Gm-Message-State: APuU4Z/su6YVNvL0+33va4gm5zIUJDPk03TbS1uopG1OT7MEnh/+0s13
	5D3AmeYHcIdNlc5ev9q9B6DI1608jZKcb+WbF74Pa+gWKeoeisJiNNJA
X-Gm-Gg: AYBFou3tsCqE+oBowjTxPm6mVaOxGcXxbapL6loy1F3vQXLLhr/HFRq1A8yP1+e1n3A
	lNfWXfMIZ8CQKvuP+GSt8s+NRR5/bUbc7v56C3PdV1QZSHAjARg+6NA9aTV1sRr0iq6XxEhnCdU
	N7JdYBxLCM5QvDfxleRWuRSNPP3WZ6FiU55jUmK5rakZ5vISYBxqz1yA44Kmatz1br9tWffurgZ
	ywoQ5O6Rc8e82Oxn7it2YP3qNlPPFMj2sdEgIB+5fh1EFvqIyGvEcwDckhRl91sYYich1zZoc64
	SXIFbQCem7NA/xzzvQo+G+RTDE0C51XR/kNOUmVJ9PuMChXseYlKrtWA3iejz7QHPh90dhgT+iz
	EXJ1FYM6L8D3Be+YKPmnDJ+qxxS7R+DnSHrL3lGNOUSfD8SDKLnd+jOPndVHipgXrqmo8mcWUXW
	nv8tMNmFD07wn6lE7kb69z+mQf2UmwR3EhSiy2J3E8WKn2yyOCLORj4WrthI4tw5zjA2lC+N0fv
	m1SMeatPaPn2INsFvI4PZAeE0k8BW3awTJz+9rCR1vLTSbFtqqrIdLzWncnGCxRrSrgtlk0R0wW
	QshMib2DG/rO4US0yZox9+BSttf2vhT4hMJIp1AemDgtmvX3fCNBcVBbUHDLI3H8za/O8JZkATx
	ZlOOk3iQyhtTabYxJ4B128bkS
X-Received: by 2002:a05:701b:251c:b0:193:9aa3:474c with SMTP id a92af1059eb24-1b3c03179a5mr4030746c88.21.1794458850321;
        Wed, 11 Nov 2026 20:47:30 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:5d51:6f:e2db:335d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc14sm21024827c88.12.2026.11.11.20.47.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 20:47:30 -0800 (PST)
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
Subject: [PATCH v5 7/8] ksmbd: consume the sequence number of a request on a failed session
Date: Thu, 12 Nov 2026 11:46:44 +0700
Message-ID: <20261112044645.4074-8-mike.michalo@gmail.com>
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

