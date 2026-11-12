Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794509485;
	b=OFMMO23rWleJ5rgEQO7CUs1B4EJVaTLY5nCMrkgI5m+V2ld1MHuAmdor2O0BkX9WG+Ib
	 UvUMjrHRWvFlD0AJ2+OJ45CGXc5OfWSq6fmA2/jsAtgWu11ZqpI2bD59ITECTr8XMS2ET
	 VXNs6rKnjqUcpML4VccpQ48e3NIiGM5GaQ8SEXzQjAMUcXHqKs+ZVNJ0hPh8c2GyGbqm0
	 gkZ0yx8h3uFk7ta2Ob1lwQRSzpTMHZ4ChV+UUD4Fo4RL0A/aPFj0/M7OE/Y56NIuSsSJT
	 +hQlwIHNC7O6ptTA1zBZCEkyoz5iqXD4lmhKwplOESXEupFGvhAbhe+OV2UnOAEWqnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794509485;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oYX2qRr8l1svLfkLSgI6YJjNFCjAsPL/QF0j4Jxr+wo=;
	b=ovvSS6/BaFBagB0pjLDJblc0OE8NwM03/pOk7sDbsmutATsapevFGFWIASkVcjolTmhx
	 ReM/vGF933VdBkxalAjbqLft+H2gn6Jvt/yElBjf6uI0qR3M8FFfv622WqnBYzLVYrluU
	 t7DI5J2mR4HHNOqb+wpngWXiUhKyZAKZDGWPOUQ/7qzAxjVAoGXNu0vVgJd1EaG9yCY84
	 f0EG8ZRUpNt+87FdiE7G6Dbndm6zpoVvbCDhwA0kqoHjkspCqX6CZOsfS/SG9+b0D5Ecs
	 iXfTZj6tElqBPWejhuwNvsrGWCSS/loIyZsk77W4AL7JmGu2BwfwCV6EoFQAkeQmwpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r8ZqqTsO;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434C160A262C
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 18:51:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 434C160A262C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r8ZqqTsO
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ed408b0d9dso875505ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 10:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794509483; x=1795114283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oYX2qRr8l1svLfkLSgI6YJjNFCjAsPL/QF0j4Jxr+wo=;
        b=r8ZqqTsOYRMaAs2KKWMB2yPZM5iN4soxNuQyTy2+QoNLD6p36T+o4RRrW3rusOHiBU
         EceS2eAN7QTtiV4wsjt3Lzo0oIGe5qqoF1tg4wDwDorRiZORVC93eevltB3BSiu3i0eH
         CJ9Sqqh/E+wkif1rlSldMojX4oejKk7QatbDIrrc0ZOxAFbXdzRxZ6r/3kJIBydyxx1l
         02pEYpFhSeFMK5VUAZ851Uv0fpWjYtUG26FFW4Y0ziU+j4rhS2RXSzP6rLVM+OIoEviL
         28QOJWfog36ypFteIDo091gIFN59uu4J3QP2I32R2rwoa8dr3tmwu5GlHo2aoHXNqB6l
         VqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794509483; x=1795114283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oYX2qRr8l1svLfkLSgI6YJjNFCjAsPL/QF0j4Jxr+wo=;
        b=0dU9BC4/IeyOgGgH8ObcYsRDuKK/j2aG5u1qf+NiCbXWCvCIcXr+WzDKnRqslwHoIy
         aOQtTqm/fEqP2/OABBOgZM6Dbw15khLhX7w9eNZQ9QFUkiYNN1B/vA5BnH3FxazRPzAE
         lclFSKxxeUc76M43l/3Uy9X4v+fx3NZb78clSh+5/c1rhZeeEp4WI9y7ldsD7JdxzsKd
         9nDJ+XnqsdqtgpfJma5CE3DPnjMbAe3xntIJFFB/Zgf7mtuMUfv8Ci2FhDdN213Or7VP
         sse8NPqsMyEbXV3pwk5poPHQ8mPxR7SMa41f4TovCNDizLbnJjIR9Iqhs1c9peLgheA/
         dXgA==
X-Forwarded-Encrypted: i=1; AL+hErGh9JHgjzrxiYWIFEHxy3Q3fqOCukrtBLYaUxwnqaUlapTp6+5AIycczbj9If3+eYYG8Gzg5+eYyZX7@vger.kernel.org
X-Gm-Message-State: APuU4Z/Z4PUy9wqd5Qj80CwARrQ0oglk4NcBnbLM7hCZwwTDMdLC9j5r
	glY8pN25aMiZRswZDQqswG1pawX+UF+Tmtoy6Hlu6tvHW1vgPel0bByb
X-Gm-Gg: AYBFou3QkHmIyhacYeXQVCMX2pW+MEGAkeB2jxFP2LSmR3r1C3yfdKzV9m3tXnurpKv
	D0VggXfPdeYxYd6ddBeybPkeJpn+KBk3AkaaNBZWO/2qsFANz2x2TxAnm09lr46leRWn8DnxmSg
	8uPAdEOCFGqjo82YwI22FrZ/dFdOVU7A5m+ACQWgC2C4qnfz0CIsIM1St9dzIZp6vWqAqcxL7Kn
	6g9RKCWjWsJkuPPB/jj4t+0WznyYxC7pu5BT94DqLVJycgLednAMq4Vg/zyS6jbKIz69lytuwHu
	RoS/dfYvRWqihoJ1k5sUFexfc5ip+9xun717qaAQMGEtvPDqJtV0XkIfkXPJPT2bVtbgkMLpWT+
	QkOOgPCx6WlouS3ZF+QhFf29IGIQPCfEb/8CAfpsKl3xOEL0D6XRxBfkpo0Flx0MnrSiVFoVW4o
	jTko9HkdJNe+UWzLDD+aiW87wu6vNrBSO2aU4sD2uRg5EB4RuBFhXOxlpZkMZTR/soaQDAWCnEk
	CladmIpvr73quSINuigHWDnUs4y9Nc8p2Gyd7plJhNxJKtAAutSnKCR9RCLP3V4Y/WqEcbVtLWH
	XGWrCBnfT07wA4YJLyUFGbLgOetfmz3sXpEIZO7Xlpiiq6wzB+2zznkCvSTQp/l/TWYHOwm3fqW
	B1FWB8wTk5pXsn8TPv6cBJtWfXQ==
X-Received: by 2002:a17:902:fd8e:b0:2ed:107a:4f5d with SMTP id d9443c01a7336-2ee0d9e6eb1mr2506175ad.1.1794509483454;
        Thu, 12 Nov 2026 10:51:23 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:cbb:dbe2:bd9d:a035])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7cf7bbsm66205ad.29.2026.11.12.10.51.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 10:51:23 -0800 (PST)
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
Subject: [PATCH v7 6/8] ksmbd: use the current command's header for signing in a compound
Date: Fri, 13 Nov 2026 01:50:42 +0700
Message-ID: <20261112185044.41571-7-mike.michalo@gmail.com>
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

smb2_send_interim_resp() also uses smb2_is_sign_req() to decide whether
to sign the final response of an async command (STATUS_CANCELLED for a
blocking LOCK or a CHANGE_NOTIFY, STATUS_NOTIFY_CLEANUP), so in a
compound that now follows the async command's own header as well.

When the session does not require signing, this mattered in three ways:
an unsigned command after a signed one was verified anyway and refused
with STATUS_ACCESS_DENIED; a signed command after an unsigned one was
processed without its signature being checked, so a wrong signature
was accepted, contrary to MS-SMB2 3.3.5.2.4; and the response to that
signed command was not signed. When the session requires signing, an
unsigned first command is still refused and every signed command was
and is verified against its own header, so mandatory signing is not
bypassed.

In an encrypted message, a later command with SMB2_FLAGS_SIGNED is now
verified, as the first command already was. 3.3.5.2.4 does not require
verifying an encrypted message; that is left as it is.

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
index 7790aa618fcbb..9c6e740180a4b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -13004,6 +13004,10 @@ bool smb2_is_sign_req(struct ksmbd_work *work, unsigned int command)
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

