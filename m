Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794253344;
	b=OVKv8kWHvn1i95ZZvuRw2ch0VlgGWDiFbKozDh4UBerRXGy29/D7kRQPzUC4TrA6VCmS
	 7TpbW8nR8rgPgPXDlQwk7dGIOCmWanE8Kf1ekeYH2kYyLGFKYGTYCayRxUMePMxIhPCHY
	 Tf5hTjBZlhQTcE6CjdDQ2RsypX0BefYRgu73z1dkl/huBBPfFkn2B49mnB42odFFUgz++
	 6KdZpyixLjo2W/F/Rfm9xxoie7uctUmtXOuFsGpE3bPX1nQpyGpJJ9gAXOnZW55M7R5NN
	 P283D9So01AYG/HV9hmHANA+XUbX1MqgzMJLYTbhnt6mEuQ3oyAt/Jp2mzIEM3GZK8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794253344;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gTCtd7kUwVe5VTZFqC1PznWnEbiMuYwV17eKK+NQQ90=;
	b=ZTf1Cac4H664C5tYZzKJPdvLlvv/AjU05siYs3/DEyla/hqeJtE6EqkHT2JDwXq1gppg
	 hGN9OoIrjIY2pq80NlAkOcH6wpf8y5flTiviaTK9mp0cV7ZmkyTiepr1emCV6FNF3EiWt
	 LyGeUtt68oORUnXW5rYMsE/TjEged8/pHlitNr4plJo+18NGUFwCKG+HPMB9UyYcKF61n
	 BDcUp+QObBt9//MJKoj8d5Ar8t5wlndyGcla93Vc40i4yO4cCFu55yBdqOg73AbyzPdc9
	 /LC5so6LxY+Sh9DLxv8qFdnTYg/OjpBpKY2fFFLVZqAFdmN0XICS3BJCaa+/C65aUng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WI4gLQ90;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A42606A339
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 19:42:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11A42606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WI4gLQ90
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso7423165ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 11:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794253343; x=1794858143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gTCtd7kUwVe5VTZFqC1PznWnEbiMuYwV17eKK+NQQ90=;
        b=WI4gLQ90VGyyexRY5w3wAZFIw90EiaJZMjEayscPoAymwuF2abH92loKyY3FvHVgfs
         DLZtcGPeBQoAHqiN19DHwhSxTbAA5g8AyO66tt5I0aFfw4garNedRjnHvIKBN53jPA/p
         fvzK0fBa8NrdmzFyG8e2e+k4PBZ9X8t95DEKYQQDIa9As/PkhdjnZlNkadIh3jq2APn4
         76dkOpnby4AN2GmAiyy+Tv3gOc/Pwhb6tMTZ/z8k4ys7xHVaKkHo5lYgzOWkkTXdUaVt
         3tWjY+PGuOMSqAvcu/QB/rwFQnInzWl+DW3/97sl1Sg/P9K57pbVsIQcQm5aoYfIBrV9
         spxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794253343; x=1794858143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gTCtd7kUwVe5VTZFqC1PznWnEbiMuYwV17eKK+NQQ90=;
        b=J6+fb6tXTfu869ARg1SrhKi50OVpbdwfuEJxinZeArUctyQJYCcU9VsHwDpps9S270
         9Tg4ruNmoSDLcHTuv+Y1U13sMaHA6wCkxLIpzYCOHa9bSRSZI/lr7omQdQ0Bp7kgr+cM
         BZ9JRVhdI6EhyjUkqD8x3DGUuTd06eBHIjeUz4smh3E+sGSzOShRPZOI4k7smEBSk5kz
         8f8D/+fV/tK9X2c2GVPaTsOWBpr4aw4rmBfWNNixQCN+X6MTie6RO9SkQw0paYrPAbG0
         Hc77mFDophxMyzD9Gaa3rYa64Lz3MR93RammMr8P0N6gzXB3bY5cBLPASFFgBv7+Cvn2
         VxsQ==
X-Forwarded-Encrypted: i=1; AL+hErEFeEvIH/FX7IrKcCRC8QkyXi5HY913dI7pE5NONuyqj7xgL/1GfwhxyPMq3uDG2F1oQeqe4UnhJgLO@vger.kernel.org
X-Gm-Message-State: APuU4Z8PXu+bFDXIXx+qoUozFybLL4w0z0Pg0dcpdTwFKZKHzLY0x0bE
	boPg7WKd8oeLgZjUeTxn83z/Q1dd6D2qNUN6rL3pATY5ZMRzb3JR8XAs
X-Gm-Gg: AYBFou12o3TFjHeE48Ox5Aqb/zdue5I4Wd1Wb/j9Eam9AL4+ADFmayXukSja3eog8QC
	SkUGulqLVOIpTwDShfxDl8nbRXya1S0A2OrFzuNAjxJjA8JFpVBAAYGcvLA+iEYazAx9OpOcZGs
	pE8cL+ZXIhsaSJzgDwXL2AydMliRG4OzUI+DsA26mLDS/xJdeA5Xb3NaN1JDV22jp2FUznviizc
	uqSm8tgORT8bnV6CTpwRXovd0ieEDQTIlg/pL9ee+10Rwh2jKVCZP71Hnwc7XInJ/0pJ7NmaGtd
	XD0kmIs9dhO9vC2nhzE3QqpQaYR+REa2s42JPaG0KL1NRr1ADhhjSYkOMP2wN1Hj0nlgl2df8uJ
	14cby5bB0MgXU0Y0Pl46TXfivXzAztbFq9NAIBhUZbKycVuesNh42jS7T5U8Iv+3bLZ5DoUYunx
	gNYIUfYgoG+gkFyZFTAutUYPzwKe5h70xD0w0P5in2axD1F56sK/axUihK7VewnU+cXR/jRtp8W
	nAw4KtOMfmIS9xmmvA1khcJJPRmN4H+Rc4XD8oJrPAzbq9tWh9KkMZTNh45nF8AhAFlXYmKLrSr
	higTfPAYG+JGNd+tFf07A0P5SAPWT//QJUqIpMoQ7ZuvxdNgSx6vRqEEdd9NvsT2gcbc7j7Ncap
	xgDnhnl+cR4i9SIkIP9Fc7Z9Z5qwPwXB3YtQJ6z10m6Vv9J4OYsmqeuo=
X-Received: by 2002:a17:903:3d0f:b0:2ed:38c0:332d with SMTP id d9443c01a7336-2edb91b1659mr1447805ad.23.1794253343386;
        Mon, 09 Nov 2026 11:42:23 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4b950sm1388585ad.13.2026.11.09.11.42.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 11:42:22 -0800 (PST)
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
Subject: [PATCH v3 5/6] ksmbd: use the current command's header for signing in a compound
Date: Tue, 10 Nov 2026 02:41:43 +0700
Message-ID: <20261109194144.22814-6-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109194144.22814-1-mike.michalo@gmail.com>
References: <CAKYAXd-Jo-ObBDs-AdGfaM+QmDsot3gj1g0oJiyDKczoUDg2TA@mail.gmail.com>
 <20261109194144.22814-1-mike.michalo@gmail.com>
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
index bd4db44f06cd2..7604fdb919a2a 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -224,6 +224,7 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	u16 command = 0;
 	int rc;
 	bool is_chained = false;
+	bool sign_rsp;
 
 	if (conn->ops->is_transform_hdr &&
 	    conn->ops->is_transform_hdr(work->request_buf)) {
@@ -299,7 +300,15 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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
@@ -354,11 +363,21 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 
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
index 7d107a61626ad..b77c93b3ba4c6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12892,6 +12892,10 @@ bool smb2_is_sign_req(struct ksmbd_work *work, unsigned int command)
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

