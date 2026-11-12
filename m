Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794498155;
	b=LN5298tR8U3hj/n45PJyju04bkZep0eQuA+st33zgW1t5g6UoleKZeEiV/qquYJPlsJg
	 nzl7x3yKO8F8XP0o97m3qZrO8VKFdaubx3wTujOOGjRay7OIbNealBEAve4tdVY2Gm8uy
	 tH2YG+NO58w7OTDovN5mrt5rMuZG8r9K6RhxnWk7ydKFgFjzLs7DlIW7bgDcRFat93eM8
	 snJw1o6hKVVCxTJ4gI+bc6BkCkozVbxQdqrA+oZx1oXXeC88jolzGDyafRFLGRjtJskOF
	 zjDvk5p+/aPST46AKyIPY8u5yCzM9n9qaD93M4TuKqAXnt7IlUeISr0OuI3eypileeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498155;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQaDZUFARmg0vK0ubYlvR/6wjOF+eKzsBGsqgcT0Th8=;
	b=odqQ5GJJ2ZiOakvTXBmwXEsCVGCVLKknVAVM/TSCV/1L3W9oCh/NgXOAYnrhXBP24l1G
	 sCkgV/z7yISWb2QMDIiUK1Wxkp7ODoHGbmlrOzsn4424eNLCSMhBCMbdev+QcO6ORsMtk
	 pGvufrdAUxXUVai9YXMGL4FfjNxd2HnVDXtrxTytFRKtM2BEiP0FGJjXDR4v7id62unPE
	 ZTzSWOXqMSDvbCRwuaq//2CR21s4SPmH3Y+zDOZ9YLqXYG6o75+i8TQjyEFcyP8iDnGSp
	 nSjZL4wD+RNHWb0rwzEXSb4fta24eVtiD0CPYSG6EUnQirnzZytGSVs4YYgj3KZwfHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n+iHftg8;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA30606A89D
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 15:42:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDA30606A89D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n+iHftg8
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b3577deeb0so2218343b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 07:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498154; x=1795102954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZQaDZUFARmg0vK0ubYlvR/6wjOF+eKzsBGsqgcT0Th8=;
        b=n+iHftg87qCl54RLdix5C2y9fS9IPoE5PdJXVS0FFnroFU/fJxsS6riEEIE8E76793
         FOQTJ0myMYAzrtcqhUA6RbEO+edY7gnnWPV9LLndNCv56DoC8jaWLZTFRTj4S2Ycr7IE
         +8tNKHD9KZ99n3CO6qWPalMn5aJrM71+eIRx6jU1BsL2cOh9rbzD614IE3qc5RObWgQZ
         qreeSSzA5OQkLNgxsNXBzA9QMbEcm0b0U+bbzNzO9Xzvg/mm2xg1hEAS26jK9B+30RAd
         ksBTHM4gpW/jmzELDbhkmt29sNooQzoVhucwm7V2vVT/WUhm2T4mUQtY+6MiMjTOqO0F
         uwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498154; x=1795102954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZQaDZUFARmg0vK0ubYlvR/6wjOF+eKzsBGsqgcT0Th8=;
        b=vS/MJbXM0vDxV0jiDMIeQ0KirUpm8j2Ua1+ClNiFGCOs2s48JAeaAQic4bFNoH3be5
         LIPLGeXeDvWJToahcSJDyIrBJX8L/76xcSmHk27qhVndZ3v6jSr0bQlQtfw1IGuhmxwY
         e3vMJB66/HX5XBmZ6f5+uBXsiE+LYLsa1wRUs+PaGXc70fOZ6PJmIKa++P+4Xk0v6rCf
         45b30bHgc4kVGLtsBm6Mt3qus++1WbPvxT6Yr17WJub8dQJTEEC5IjsJq1mwAs05hd+0
         bXq5M1qIFeoPZkvTkkzBeU3WsJA9C7vHeXdhrLV3t7cOXl03euLH4+u0hinoxaDotFhC
         Kjyg==
X-Forwarded-Encrypted: i=1; AL+hErGFGLnrvIAs8KGqJvnJqsjRm8qHaidMxDV79U1/Nioz5tZcxgjT5N9HEP5zUo7Y6HgSqFWjo2vbHgNx@vger.kernel.org
X-Gm-Message-State: APuU4Z9H683014MqfGVb29bAUPx3QuRFmOsTWxEhKsOUDdnujiz5h34q
	O9hkusr4T3Sago84uamdFlTMnRcuTkmBCzG55DinjcnEOdgwUC8frJaZ
X-Gm-Gg: AYBFou0KNPckPHFaHYvglktCFkYW1yG6S4HWp8wthWysFpBkLgBUqshbUa22jEFmbyE
	a23oGXItwr8tIm/SxsBpSJIz63PGvm3+GilMfinGujewDV3AOXiCXFYdyUPAQoAcj3EGNIkQCS4
	4div09w+z2WFJixbbL4schlKXBs8ybABUIq9sS0mBeeHSzQQ+H9yA87HuhM4og605GQrRJgB88o
	CDUTpumkhamnO6uy0IrhJOCWj7MxJF//Ynt9SJoG4/cj+bZA5uepjoLaXxb/nyvgb9xEkOyQi4F
	OLY1H8b9KUG3Md6U9BLFHHUj4d9dKYqcqMm/P6VTLnbJ4mP49o54dBQ4gGXUoVeguRXWAWDILuS
	QIPf5oGPOKHeiJwVmDAG1hvqg1tCEl/qGKAKU9nLLYEU0w38FOA/6pZ0ga5V7os0/YJW18XxTwE
	Z1HVU4tLty1oRa2yrZ9beTXOWh7jhwHpVWkY8B1qCM/DYqwqKuLntBZXu4SFEYEctJ/L7yMjPNS
	unwhA7WyX0yEX9tn06SaRF0naKPvQSgki4d6nEomoF/Ui0VUE5+7zVUCHlBSLnA2CjzyLGmYCdO
	6qDA9mrtCRqE8chGUqiy/RFjuZhb98zr0vBImo4aW3YcHkyKSWrxNheRafoVe6OaOVVvTwdWtzY
	C/h/FApltlO2glBMPoRERzBeVVZw=
X-Received: by 2002:a05:6a21:d82:b0:3e0:dbf5:59f1 with SMTP id adf61e73a8af0-3f2ff1dcab2mr5672388637.91.1794498154026;
        Thu, 12 Nov 2026 07:42:34 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:21c4:c32f:67c1:d87c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa7de3619sm3790596b3a.5.2026.11.12.07.42.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 07:42:33 -0800 (PST)
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
Subject: [PATCH v6 6/8] ksmbd: use the current command's header for signing in a compound
Date: Thu, 12 Nov 2026 22:41:53 +0700
Message-ID: <20261112154155.20255-7-mike.michalo@gmail.com>
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
index ca0c78447f454..32bed8672dd2e 100644
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
 			/*
 			 * A refused binding request is answered with the key
 			 * of the session, which can be of another dialect
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 186a497f83c62..1267114b79379 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -13000,6 +13000,10 @@ bool smb2_is_sign_req(struct ksmbd_work *work, unsigned int command)
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

