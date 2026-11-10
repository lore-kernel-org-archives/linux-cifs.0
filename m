Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329956;
	b=BogvThEz1kyZ/VNnvsUZJFIiprweGi8Rp+Z/YPWl9baVYzMzCmqDgaybbXoY6x5Bv7gy
	 BjLEuqjFde9Y35OpXW13ivpcrQouZaXOo/Qdi52uq/mt7xeBJQvM38pB5f9JVRhsvtjny
	 r/IckpNAkxN+L0owy2xFNaPI8rR5WpN2KKxAjPDHKx+K5WfBqZCKI8tEluvoPX3ETvA48
	 kEWzo+u14V869FJNR9Biw/zz7vJmn5DbScOITd2h4tFL+sLYSyiEfa/zixGcLV8ccXW6b
	 iIWBBSSEv74FXbJXR/nE1Aj6YhSPuYAMM/rQhiJwmr2eKhLBTKb7IR+gvkOTfVB1rlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329956;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wh50IvgwJbMrkzWwEQjBdL/7srYLJHLHjfrmuIC6sM=;
	b=yV92j/2Vs8rCroOLjigK1wPKOF8fB4LpXDuat7Jjpk+CT+OBnsjKVJZGKsbzkl37vuMs
	 2mSguOcNfwHhcmiUAwxCsrTPnl9n5CrGbez3hD20n0HxLEHj37AP45962CYvvUP6RlC53
	 BLnNNjwaqVXbMfiqiVQ35+poyera880NighoDPrCzqzOkmIWwS78AdUYrQqUA6+WhxW95
	 MLkV3p0YkufdngCF+WP2HUAPuQ8uE9NASUojMY1cW26j1yWfteUvxb+/QSNHiX18YaYLD
	 ogQePFz9+WY0WNZGUVCRMsXQ6o4pm2mbrY06SSmyHgsZ9cnnPuo54mXydrY2ifwV47g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YTIXWTeP;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644B4606A834
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 16:59:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 644B4606A834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YTIXWTeP
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-89d6bd67045so1266354b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 08:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794329956; x=1794934756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9wh50IvgwJbMrkzWwEQjBdL/7srYLJHLHjfrmuIC6sM=;
        b=YTIXWTePtkw3i+wutj1MmTvW7sBAUKZYIRuFN1h843U5ToTaw31jnGd8OXeykrwYgA
         75zpjH8yNvicMUgV17D4V2JWUNOWOylBeAGrqi+i6mh3qlThlh7bvUTafOWc8YudU9ZG
         YBeh6CISViDEIP6KWl2OXWoPwphgQmkz/npAFRoMV1GwP0DdYiCo5itVlF2UjPS5OYrR
         Jmkv+MGoj/mh/2kEsrbk+ffXdvLvEg5UZEO/eT+Bj5RipjZbXcggXC4PRExYRE5gTzpE
         kBzM3nZ5kORhENn3JS6eLl6Sf6HJGXjTYRSoPiSRm9gTU913E8udXvt5oM2S/Ox9VexM
         qCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794329956; x=1794934756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9wh50IvgwJbMrkzWwEQjBdL/7srYLJHLHjfrmuIC6sM=;
        b=ODuNKlK2Z9dGLnWlT/gEFmKE6x/PTUXrgqFVwIxG+T51adYQcg0iY8EYPZxryQjS/P
         y8z3pUW8vwWPG2b0JBNUhO1Y+NJhilIIT/psDcTvjQO2JDDeTFwzVW3dewWYOGcifyvL
         0MQt8FIx3U3fFOdhzDEW/bEvEHtKdoR5BClpMGtwd+F/1edg56J+uK9WTmxsH7YB27pQ
         ml9utBV1FNVaL97W5MQ5iLQEiVaVMk435Avh5Amb8lYnXq6uc6T6xsSGNAWFZeqvC14K
         TdvSd2CbiejfP7lTMekNqWC6oS4tI3xnKuhF3J5vHneK1bDtihP6zar7ciZ7vu7Q1cLC
         eTwQ==
X-Forwarded-Encrypted: i=1; AL+hErFhLk94J4h4gYrez231BWVYP2Zu3KGBOn8Ca5JqGng+f2vAj2QnbUzhRDF/8Pst0crw67i736wIkImG@vger.kernel.org
X-Gm-Message-State: APuU4Z8vIgHmTHsHYQol3AYzahf//lRELOcOIc9q/XplVOjbZjSUiFxa
	JFdjdL5OzZsv6FSQ/sS1mHfuWhofvHjY5H60T07KjkF0whnV5UxOYT6y
X-Gm-Gg: AYBFou1HeY3CIviAwLsx5V387dHutgeZsDcIlllmm8kha56UqtjTXSxjxgiRYE2rh4a
	s0jGsGCiRJViJv00RnIhCINJWLsPY83B2Eb9W+kfYw20uuhy4BU+zXVImQi1SqL0tBRASrnPCnA
	5z1Lxb4/wv8RLhuCr2Mi51chnk1Y8QrqOUiHMg601W3kMxEEbEHI4rj2gBsPy1AZxUnDeYMx6dj
	FUNovQtkt1ShfGwxD5KQDAHxtchdSpVdIhWB8VqWJfBhNPZw9V0UJYnEuTkBZgYw/oYezDta4M+
	8v1KNUuB1wqTKN7x+ZEvXqU1jrhQ3tOhXNYR5MB+4ZTXSxHwEClZII5Zr8UM3zStR4BemAn1b6u
	6EXuuSExsYX5qHV/6vyKBNOCqQ7QIpW+CV4QJW76FzPCF0DCxUL58LwcFfY9vjeAWc2yOLgBkvw
	ZUaGJ6hU3x6HWkjYgXCuwXHv28auS7cGLsyUzOWaMsZ2+GzX5Sf7jIWG2RaBW5ay7cITxEIcpV1
	IWDDQ3EY6p7tVQPGPDK2q9B/GYTEdIEzx9eaCvQyZGMZOUfKC9s/fjpFQnU8yAJ3J+ZjK7aXaGp
	RPSbv5HxXMYVhTIimOgCJq7T9mVPh5hQ26fEuqxxQkObR7baGkYuuSccRtirw2/41c6FRtph5bn
	gP3b3A36iNgpmUWpMGarrxN73CBEtqcmp0OTFNVlntV2xdrxBEg/LEWbsdVLjENSeaFLcSVMfx7
	lI
X-Received: by 2002:a05:6a00:181b:b0:8b6:5a07:7761 with SMTP id d2e1a72fcca58-8ba98e399eemr2347530b3a.38.1794329955618;
        Tue, 10 Nov 2026 08:59:15 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm1157154b3a.46.2026.11.10.08.59.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 08:59:14 -0800 (PST)
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
Subject: [PATCH v4 5/6] ksmbd: use the current command's header for signing in a compound
Date: Tue, 10 Nov 2026 23:58:33 +0700
Message-ID: <20261110165834.28162-6-mike.michalo@gmail.com>
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

Three places in the signing path read the wrong command of a compound
request instead of the command being processed:

- smb2_is_sign_req() always inspects smb_get_msg(work->request_buf)->Flags,
  so the per-command signing decision in __process_request() follows the
  first command's SMB2_FLAGS_SIGNED bit rather than the current one.
  smb2_check_sign_req() already uses ksmbd_req_buf_next() for a chained
  command; do the same here.

- When check_user_session() fails on a chained command,
  set_smb2_rsp_status() writes the error into ksmbd_resp_buf_next(), but
  __handle_ksmbd_work() then set SMB2_FLAGS_SIGNED on
  ksmbd_resp_buf_curr(), i.e. the previous command's response. Flag the
  response that actually holds the error.

- After each command, __handle_ksmbd_work() decides whether to sign its
  response only after is_chained_smb2_message() has moved on to the next
  command, so smb2_is_sign_req() and smb3_11_final_sess_setup_resp()
  would see the next command's request and response. Decide before
  moving on, and still sign afterwards, once NextCommand and the padding
  of the response are final.

When the session does not require signing, this mattered in three ways:
an unsigned command after a signed one was verified anyway and refused
with STATUS_ACCESS_DENIED; a signed command after an unsigned one was
processed without its signature being checked, so a wrong signature
was accepted, contrary to MS-SMB2 3.3.5.2.4; and the response to that
signed command was not signed. When the session requires signing, an
unsigned first command is still refused and every signed command was
and is verified against its own header, so mandatory signing is not
bypassed.

An AI assistant was used to draft the patch and as an independent
reviewer.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 fs/smb/server/server.c  | 27 +++++++++++++++++++++++----
 fs/smb/server/smb2pdu.c |  4 ++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 276dbbd986503..13341ff38aeeb 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -213,6 +213,7 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	u16 command = 0;
 	int rc;
 	bool is_chained = false;
+	bool sign_rsp;
 
 	if (conn->ops->is_transform_hdr &&
 	    conn->ops->is_transform_hdr(work->request_buf)) {
@@ -288,7 +289,15 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 				if (conn->ops->is_sign_req(work, conn->ops->get_cmd_val(work))) {
 					struct smb2_hdr *rsp_hdr;
 
-					rsp_hdr = ksmbd_resp_buf_curr(work);
+					/*
+					 * set_smb2_rsp_status() wrote the error
+					 * into the next response for a chained
+					 * command, so flag that one, not curr.
+					 */
+					if (work->next_smb2_rcv_hdr_off)
+						rsp_hdr = ksmbd_resp_buf_next(work);
+					else
+						rsp_hdr = ksmbd_resp_buf_curr(work);
 					if (rc == -EKEYEXPIRED && work->sess &&
 					    conn->ops->set_sign_rsp)
 						ksmbd_sign_expired_rsp(work);
@@ -343,11 +352,21 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 
 		smb2_complete_request_open(work);
 
+		/*
+		 * Decide now whether to sign this command's response:
+		 * is_chained_smb2_message() moves on to the next command of a
+		 * compound, after which the request and response helpers see
+		 * that command. The response is still signed afterwards, once
+		 * its NextCommand and padding are final.
+		 */
+		sign_rsp = work->sess &&
+			   (work->sess->sign ||
+			    smb3_11_final_sess_setup_resp(work) ||
+			    conn->ops->is_sign_req(work, command));
+
 		is_chained = is_chained_smb2_message(work);
 
-		if (work->sess &&
-		    (work->sess->sign || smb3_11_final_sess_setup_resp(work) ||
-		     conn->ops->is_sign_req(work, command))) {
+		if (sign_rsp) {
 			if (command == SMB2_SESSION_SETUP_HE &&
 			    work->sess->dialect >= SMB30_PROT_ID &&
 			    conn->dialect < SMB30_PROT_ID)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 293e660265c95..f918744870a8f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12888,6 +12888,10 @@ bool smb2_is_sign_req(struct ksmbd_work *work, unsigned int command)
 {
 	struct smb2_hdr *rcv_hdr2 = smb_get_msg(work->request_buf);
 
+	/* In a compound, test the current command, not the first one. */
+	if (work->next_smb2_rcv_hdr_off)
+		rcv_hdr2 = ksmbd_req_buf_next(work);
+
 	if ((rcv_hdr2->Flags & SMB2_FLAGS_SIGNED) &&
 	    command != SMB2_NEGOTIATE_HE)
 		return true;
-- 
2.43.0

