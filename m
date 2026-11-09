Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794253350;
	b=M5t0wQZFYhST+fDWGyJlyf7ZT8ahY8eNF6ja3nZYdTjFklxO9JvtZoJ2227SN54qyySz
	 DZYnWggpuzIcE/M+QYfDLy0FqlXaz43EncMZ40mzzuevE5O3ZYS/L8UkBg0Fpu0iBSeyy
	 JVbhiS/dOkoZTX1+7iyfT/891lZaQ7B3WKoG5HVwHXAsyjhTSYEIz5mLLK7y8o2B1isZn
	 tWaMRpIV1c1+iZrrrc+yd5QWtLm8ZiW6CrvlPdPdXvinPUKAtno99HydzYL4abU2DJlXv
	 Lx9EdiXFmEUNQSERAz+RAyuROETDtbWiP04vu9mWKvUW1CmA6rpAfDqp/lUiCX1YBpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794253350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UEhZmesMv0jigQ7cD/Kn5QG1oqSQq9Q4U814VKFftdc=;
	b=KJFqL9v88d7/ClcmwbXVVeCuT+30zQjmTEhnVfmVJ8QL9Vo9DNEE//2JAXUurU7T1CjN
	 St42woRxV9+xIisrUSMI21tRrM+beomW3ZJh6+dyFb8OBYZi8WenV4rNlGeosqQr+JWXW
	 Id9aGjRhZfcQDSx83jxtUijTkbkpxHSTlYSDiY6zCnorg7txkjgy8pL3XrR+NQZMdcBQc
	 G3lW4nhDzpsnbIG65oCLLDSGpEZffIfes6aZ2HNIcB4r445zSk91m9Ke8f8LVOdZuvtiV
	 dUjjCVecCCyo0bWAtgT0NpWLsQMYEVIDfcOk69T/Gm38OdyuZ7JEbAyO0cDWzPGqjng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EKc2b8Wl;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B07B606A335
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 19:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B07B606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EKc2b8Wl
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e98798cbddso5945925ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 11:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794253349; x=1794858149; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UEhZmesMv0jigQ7cD/Kn5QG1oqSQq9Q4U814VKFftdc=;
        b=EKc2b8WlVQAK+QDBBLBJs3pHzNBRz6SdjfsrdP9tAslpxwZc5moiXJfRT9tI5WQCQQ
         zrAl/FZzen2FYuI3vqvOem38LgmsVVcGmmq90rFjJ6ZO1rFAwz5sT5X5puJiV4QWpf02
         8dozWpc9Bsb/euLqwJLLlSdltxIUPG50x/JDZ4+YYXlWJpWHuhS8Zp25OqaXxTN+T2OY
         ANCZ5EQd9Y0k0SH2NgLL5qStUKPB4L6Djwsi6aKpPOZlnpcPDCTZxK379BLIbtSUe4AC
         S5pNZEF0oE0YUuehpm1rcSf9PK8eL0IuqvHRXvZlWDrsdh7xxTt88VHifS224YuFwXTd
         PcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794253349; x=1794858149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UEhZmesMv0jigQ7cD/Kn5QG1oqSQq9Q4U814VKFftdc=;
        b=Mgk2eftMgztLjT5WjLhnYVJGLcFpGpPG2D7/qQsr+C+v5slxbnU1/NrQ8icGlfu7zE
         lDbBdOsaIu0fF4wolBt1Mh6vKP9+k1eREQPv6Zmd86mTEZ89TL5ZBlXL2D11XGJd68E9
         7KzSgH2LffmTAGkIKURpRIATmIUdSnkaZSGdElrd5rQsty5lGmcqmwiiz0KZmaGLSnqf
         bxAEptD5iRXqWeqKQTb47B/bhCQUCKO6k5A92VhjmpM730u48voSKqLBgSbAt493Uvn5
         QuV2q+4CCPAr4daGgpnoLxy816wWTdLPYthqmsc0wZ/ClC6Sg0KCLjT+LKTS1BOVaAOI
         nPfw==
X-Forwarded-Encrypted: i=1; AL+hErFNrWEzheOuIk4Db71nxr1QJdsVzgjlu9vxTLCam2CTnzda0e1JwJIQISw3rO8j6SpWu1k/4gfH2Efb@vger.kernel.org
X-Gm-Message-State: APuU4Z/DtJECWIrC55m7M+22OgIl5Cp65aGQaeHIwVWasuaooAjGJLm2
	OqhdD1zp1erAvtj6dFEG07CZnvzKYElYJnwWKPhX4Tb/3PJwv+PMLV0W
X-Gm-Gg: AYBFou2FIEa9aPv055J9ACzTrXug61bYV8m3rhBidiErEbXgFy3RtWCrkRNWB2T9nEX
	62LXlvVQbjpreWStjNlKkLgS4OXuUMII7AiEOFePQbSARmMtgeqUbicyPdEV3nA9D6rEemJriY+
	Bi51r7/9a6TLFFeEZfAtJGJo9Ilz86YXxh6jyw6RfmlSuLs/e+JCtDFIykFjDakq1VRXO+XCQp9
	M1mcNt3FK0X0aZWyYXUS1idIn03GMZe2N8N4sICABPkZYu04SIy3GUm2iNd9rik43qO+D8z/vky
	EVpdSDvkSmqUgdmpyV6HAD7J73pk+xCGzYB//jS7tyJ2q3GenmGvwQdL1yDqyfg55gdbfjV6NLG
	NqXX0+vl5OtwBGxwWumnY2+RUoipmcQOnJKC0rheOcucM2s3rkuM4UA3sN9t97auA2hyu75OZPF
	6z6XCnfkUPOYDhj9xOLrqcUYduCqYgqbaowhJDLDAS2DtE/RtoQkSnq12n7K4C0kEHeFOtdsRYs
	ZR0AMJm45jkIm/YSzwwVhr1gecO6jxBW72y/Iu7r2TtbevyfaHD+Z6OwgpxPtjgEGVGVATZK9JV
	XGIzFnoMQdVVnUUAKO12KrDMjMn8p5Pt9+fN/Ccfb18+bE0th0V8LjauTmE37+r/ACaqiwdTM1B
	dEu1RRK3rLDwuPMYAJv8giPt1GbSlNh/3PakKcgYshE7GzDMIBm6CPoQ=
X-Received: by 2002:a17:902:da8b:b0:2e9:9c65:1af9 with SMTP id d9443c01a7336-2edb9227047mr1360425ad.53.1794253348909;
        Mon, 09 Nov 2026 11:42:28 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4b950sm1388585ad.13.2026.11.09.11.42.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 11:42:28 -0800 (PST)
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
Subject: [PATCH v3 6/6] ksmbd: consume the sequence number of a request on a failed session
Date: Tue, 10 Nov 2026 02:41:44 +0700
Message-ID: <20261109194144.22814-7-mike.michalo@gmail.com>
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
index 7604fdb919a2a..df04b0dd9f2f6 100644
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
@@ -288,6 +287,21 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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

