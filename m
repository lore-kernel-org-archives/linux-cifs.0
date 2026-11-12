Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458847;
	b=ehyRNpkeqS/JS8Ut/VaV/eTgdUJUnrvYV7UXMMV3RDGiGzVA+NDBj5bNd9u9LY4h7bg5
	 U8eYk95V7MhhvAKXBb3tqAIdPwO5TBvU0JikKU1blNPWJi/uhXHnc4yP7SDHjBe2i5mHR
	 /7TvpyyRJNDYOrEgyHsrZP6KVQgRN4mO/IpXkT/SZU86VsV65DsguCagNvuFK4HteasUa
	 Nq+p+vneU18AcKbilvY5fuuvCGns/vC+2W2ZuhiVpEJO31dXEDzgX7BsveAZmE7MDgdBA
	 Hxm2kUuOVgP/DnvHyWt8V95iLIs2T4mJBUE9XrwainID8gqMN6a/faVQgAAgQpdWHGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458847;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qmOf0+Mz2RzAvVtbWE9XdegsQdLNi/Pfhu8f72ZNC7c=;
	b=TkkewDVhVhAetyKgnCZMMANZLsB+O7Nec/Y42Cb85a7eYCyOq8IYfDbgwBAtkEq7ZRSv
	 V6cu9WelXmJULvP5+zRTo6ux8qomAKBj/BqA1+6KHjpZmzqNnyR153AIk5zk9+HcMIdp4
	 P74vJ2jP8M9rHURtz5+s+lm0+KC06CHyPZrgbIgyBMespSRzsbG0/dOPYOl2F2sfcTBnn
	 aAIKejkBZJG+ACtBTlm5QjlNsj5cWKdFCSJL5ejxDOkKWhiQOYJLO0wmankAKLsDj65mP
	 WawVCkf1HWASeNttaUb8JOweTalAqgoxBIbaPkuZGedgZXGYMBUcA4ZSA3J6mu7GCUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aZYpAKZ0;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEF160A381B
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 04:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BEF160A381B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aZYpAKZ0
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so1890540c88.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 20:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794458846; x=1795063646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qmOf0+Mz2RzAvVtbWE9XdegsQdLNi/Pfhu8f72ZNC7c=;
        b=aZYpAKZ0fCBc/qKARHnJbH7QqUHZukSGgq966QSZEQkkCrdgPMCB4UrkwrZ5Zinpz3
         C+cFJQkppWMg7UIFKyM5DwJvAeqbPlvEHtZgxF8WvEUsykPUy9njIKrZFiZ+8TPPF7lb
         a9EMWLNWmb9k+kqyR6veAmpQAZkUUYhSUXrsmeG7okKEIecXDYTX/BXS7UJ6qekCW1qb
         G+rZWMHRn9Qi1u86LUWq6c+p7aUsQbnSCzpj/3QoNIpy8TkjTQjpCCPWNen5qs0IN3b0
         z0L0A4IbFBTDJKE66x0786x+8zYiMa4CrRN3vbwQZn8cf9vmp2VsAXreIZVHGExHGDIZ
         nlsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794458846; x=1795063646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qmOf0+Mz2RzAvVtbWE9XdegsQdLNi/Pfhu8f72ZNC7c=;
        b=ffdCoyChy7BEXhRjA4ZOlYWW4J5ASw96W0LieisSqBUOZObaOn9n3ZGRlBv25F3eT4
         8jc+ehMzkBJ9ISGf20U0swph7R2QNONyCmTj48T9UyViS/RXX8bje5BTAwpo4JRVi/Kr
         MxJGZPsfdmMqGqb/csAE9QAcdc1czvW6OVRyRhUcjHdAu3fkav/KNz+IoDw6/mXHY8jZ
         MVkhYJNYM3NVG40LDvUxEcXvQjekrQE27o7BPpfHuYP0JGop+n4DC1ixROWc3uyKy7Iv
         6/GZh+2cV6H43LcSYOTYTR+PLvMHzS0Jy161prRK1pj6AX48OgPBP88U+0HdkctIp6Pf
         OdIg==
X-Forwarded-Encrypted: i=1; AL+hErEXCkiYj0Ivix710YjUkHgbvxX+tr+9pg/801P18gIq6f2oivLa4nhk8J/z7G75GLFIgn0WR3Mz7hMf@vger.kernel.org
X-Gm-Message-State: APuU4Z/8l09Ro4gILSR6URVIz9Onk4tuT6VQNGELY3uyKHpN5A3dkZKA
	PhF7KRQ1k1b78ZrRJF3Tj9AxRy3wX1viLL2AFaI19DidmmGYaFw2f8MI
X-Gm-Gg: AYBFou0A4LVrhX0+9u3GracHB7w7e6o/l4GHDcoaBAWhIZxJ9YtYpPNWgYplopOQm5i
	ZxVitOX8Ht1AAQbBO0ygkNdhRFuAhVMCh5X1KqpWCciNZbn5HvAlS18zzasRi2Q3c/Nx4we53Sf
	v1U4RYsfAsHlRNLYNLhQrtpQ/16xIBIu8YJpaUYwlsUihZZo5Ejmi72GrhogmVnT5JIN2FsFC2U
	ReWnT/F6m+t5z5fh7FUwD0vPmdPHvO93L83hB4a91omppN7mpTtznS42IB9UZUvS6p91MkLLYCY
	CTKkjKmrMNHRLyEuqPH2RSQItM7gVekDUk1QR9NaAlcY7EEdg7rqzCDqkL9mNNtGV7K7l/UwpxX
	gJAdr+wMTJj2HQETgV2erKM9zATjCwolCCM7WBlr6qCtsSRh2jQD1l6jZhdd8SbYq6kv5s06KPU
	OBUnENEzUb2f7lj8L8VsFN3Kg0OYag8VEjanSwB/jKx5a/992Xfxco3ptlmmozFScYc7N7i0cRP
	/AoouDFGuIyd3iFTBtLEhkZShsfK5vo4/cgUlsJwkT2MgsemcCKxeW7mFwdbXiI5BL6BXmdpZYy
	2CXOnn0Emv0wbPDYZKjAa/el8PDcThofCqeagOXSvooDFBzXs7QSZQDbwfw8MidcyAEW6Zf0Vt7
	Tuc4GjXFUgBFtxwKEk/ciQswvzw==
X-Received: by 2002:a05:701b:2610:b0:199:e38c:29a0 with SMTP id a92af1059eb24-1b3c03390c1mr3592446c88.31.1794458846120;
        Wed, 11 Nov 2026 20:47:26 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:5d51:6f:e2db:335d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc14sm21024827c88.12.2026.11.11.20.47.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 20:47:24 -0800 (PST)
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
Subject: [PATCH v5 6/8] ksmbd: use the current command's header for signing in a compound
Date: Thu, 12 Nov 2026 11:46:43 +0700
Message-ID: <20261112044645.4074-7-mike.michalo@gmail.com>
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
index 0271ee4753236..895afb41adacf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12904,6 +12904,10 @@ bool smb2_is_sign_req(struct ksmbd_work *work, unsigned int command)
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

