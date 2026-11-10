Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329951;
	b=lniC0WGOncB9LapoeYQj7G/WmPwCka8gQoBH+AsyKVkh+lVYQj+oc2jBPtDHRe/NrFl4
	 /b4qgA3jPvc1YQavRw94lHpyeo9FTQy2fl7k+sKkGgUCkaVHEJzgESoA/XikUmAbXh6Kv
	 nNVNy2LAxRDHGcgnaFvFHE06r3lcfW4av1B3Vbpfn9nPES5j3JxXE4cVk3Idi0n9Xo4nu
	 ICPE/Y5uq2RXLkWh3Z3W/sldkWKwPQcO0kGJoYNJrJF8WP0aumBccBZNdlMyiic5DAknb
	 klwm57HINt9bkKBOmLq5Zsnfc9RA6r0owocXVYMiHODgYx2LwU6tTqPDqG1EYsHloow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329951;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D45L3fPRhObdeDNJWurd+/N9L/g975IX6M+u32F2JVg=;
	b=ydGKJfewzcsLwwEiasGDS8I3wJh0XOBHNGXSsgc7LjveVLyDwD/8dfMh4ETZ0H2zkXVv
	 L+hBWtmq81WLm27cWF/CQXMJJ0PaYoyujcGCJvzHZ7E06IR5qQZFnbLOlTF0VoB9vkTMf
	 EWJ6v65VM+kG7lD7Nc7N8nfvrYrFrC8uwiSRspyx5paEfNFEyG3WksGCdrePCIjEuOjNR
	 FOETjq5XiqX8culN1fH0t3TB/YuIBxd8Hxhx3rhy3aQd2IVRUd7v3agPOkBXqmuDsFQxZ
	 4GzqadoHPyFrVp2UzPxt4Dac0EdhUzfwtRLwOkO7m8PwtHz6JYfwdDAcLK9HHlIaypA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AAyoIJWQ;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665AD606A321
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 16:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 665AD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AAyoIJWQ
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8b904d10882so1023888b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 08:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794329951; x=1794934751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D45L3fPRhObdeDNJWurd+/N9L/g975IX6M+u32F2JVg=;
        b=AAyoIJWQn9m194HohnVrgyQmygSrD2P8CKEjj6TTNjNFgBn80wxvkQiAw2asly+02h
         I+65I6e6wSSrpHMKlFJs5ItvELIQPhOGvJC8u7FZxxnuFYzkhBd8tWmJwCM/0R8UtvyY
         tF+g6Bwk5r2+klsXTahj7DsxxdBa5NfRIkN80i//f6S/zEUDlmvP2T6F31Bxg7NbYQNc
         BhsjjUxiLJXbdsZThvvI62AwOcfYs95PE9FtJ6VwgVto9OqjkHb3xUhf5TpyU7X7uX8n
         atwgZILm/mlFq+50OCGeZl5pa6DfuQnoJcvoZYg5Vc3E7zA1s8ATwTVweaHyYpt5pAon
         JQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794329951; x=1794934751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D45L3fPRhObdeDNJWurd+/N9L/g975IX6M+u32F2JVg=;
        b=xu9pBI+jNke5JT7UWvvAVJIel1q4DfNV0uUj84eptiYe707+5Sc/f4TqWTQGsOy+Ar
         /I4RofTWO5Mmo/M9ADTfEWTCoWzub0oy7I1KoCHaLu+taFcdWuF2dUfwbxCUrf9LQ1tj
         UWwpCF04k79ziNCf1to06iiDvwfn9K5SLz9F1wZJ9BpwmYmJfxPcfVaAwBjWJmWQ2bXj
         iGLiYgvV1O2+RmSdsZzeGdWLp14Edkt4x3RQiGFA/TXbLZAsSLlYus3Gw+m2mJr2y9pD
         wAYASHfcoTKHrR9ttGPkOr573PafvenkuBKbjO93TFtxEpsKKvRqx6vTcVucmU5cLwFS
         4HXg==
X-Forwarded-Encrypted: i=1; AL+hErEFOSYPGgWbHRPDbFb7A9cgiJwNOhHIo3fDzd0qxW3aGaN5lG/6LtbIbo1Z4Ipgsq6dpHQYjVvddN7x@vger.kernel.org
X-Gm-Message-State: APuU4Z/1BfnacIpk9BLVLnbnZZ3u9P5/+MQUQ+jKBvI46n13NdrLKFJX
	pgCmWGF4f27bbkJMBP7Q1YsBQiJ7jMEWZdasJbSZQagQzRV+9FWRX9Us
X-Gm-Gg: AYBFou1hx5omoUHWS/TPfU183Q2iOfb+yU0Hr/VTfkIMtbty1ZPeRQMP08PuggyWKps
	5g+du1J3PPADCBQqwTTru6ODHeQFuwj/oNjtVxBr3ZQTEnEUhNhPemP3UDOfQkQz4LHYXZCHYOh
	VQDMO7qkKq3kp0utStA6LtflIAUdAlD/RVWc4hgNNGRz23RbWld7V0nwgtQDpETLY2+w0C/NHlA
	F4UAjRW0BSLgkY7S+rzzuPuZZ8ld9Z+Eu+6JBmffM9fPYDQMlaVbUBR2/R3rMdbyUrsszoSkUwt
	qlfONahWpKVTznKZBSVU1OjPvZG1T3Pu1ymxb3ikKGviODe+WGjOQjmCBy2W6TjH2r0Y4naAA0U
	/fJtmKFoj5ae9nZln0k0zddEW4nf0iq1PehBCcPViesS3k2y/YnxvfYI8HJHkDwfc4nxvSizTlF
	56iBeDgabIQsXMGoEXTcqBRazOwKzQjbH1bhNW91H2LS89ieVLkW2Rb4EYgRVg3/NIHaQyjBmvK
	bEx44TlZKtalgEmDsTIMtproFFCnI8xGfIOSSowvcuIlnXzxkexERmR7bmjzKo7y7in7D94Y3ee
	l/3AfPJHFfKlPPnJ7MMcSUEY7bXlUezhq+5GcGFVrZ1JvMytdr2qKIYK9WLC7VqijiycFatRR3I
	lfqxZ6PbCuxv+eS2n56AG3d/D8qBsjxeDw1p6/ot7JaudasH/GvjjFCU=
X-Received: by 2002:a05:6a00:3a1c:b0:8b5:7fc8:866f with SMTP id d2e1a72fcca58-8ba8773de56mr3437547b3a.44.1794329950745;
        Tue, 10 Nov 2026 08:59:10 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm1157154b3a.46.2026.11.10.08.59.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 08:59:10 -0800 (PST)
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
Subject: [PATCH v4 4/6] ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED
Date: Tue, 10 Nov 2026 23:58:32 +0700
Message-ID: <20261110165834.28162-5-mike.michalo@gmail.com>
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
index 064f99427ca6f..276dbbd986503 100644
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
 
@@ -265,7 +291,7 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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

