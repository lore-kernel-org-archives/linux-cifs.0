Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705725;
	b=DmFuzuzrCmZNGTCXc7DdbL9ZxnSiLn/jGb1qcF7E7Arz5EJGWKXsEZlUYNAIk5Mxs4sQ
	 JjKIxOREcK8aOfzecP16os8yMkUXqvMNmz5OXZx1G0ReXIhEkC0rZ0tSLAoPdpoLFGGFp
	 ZN27NO85yL8wMkd52SuVhNxYJyu5aMigxUuZyh6wAA8pgfruYIe0uTibD5EWZncvo/wHf
	 AUcUYvNt9xxqcOZh8tX3CIB2KHY1ciEAp2RcG+Dga/onO58AdD0pBjA2xMv007LUJC8of
	 ACqiBHOFY1uTVYfWpcybBwZA3n4NoImRZljQHEQP59ZanesSPeLYRY/So9HyGZgMUWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705725;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KeC5eWf5hMeKptsQ2ueKHB3C2sqGyzZwcIt9dwm3x3A=;
	b=DI4tCxqgZghs3laL/zaGjneddJELBe/P8h0NEHk9P77sr7ZkVWuR+xT0rsVXVfX5idew
	 QNPFKH71uE9qbWaK46dOO/riPEiaun8tvQQpxkfT7dIx4d784gQMYexk9WBiAB6vVQov/
	 mkWsWLC8BlkGA4MTat9Q223jzhXsTEalYXn8NgGS6mnX1bLmoFtFuFsH8wWcMsao27/ZO
	 z4c5/ONqTBcBfAxnr77ycssAyIAh8LqB6JfFP9Bf6REtQRXHE3ntI+HWW0S3xzb2TATo0
	 Xfta+7VcrGqJPckPZFcnYksiH3cvXFXWM7U36TgzBboR9zttKXynAOiOtZGvNoDPkWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=zoLwP4N3;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B326B606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 15:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B326B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=zoLwP4N3
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4b467581b98so69317305e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 07:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795705723; x=1796310523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KeC5eWf5hMeKptsQ2ueKHB3C2sqGyzZwcIt9dwm3x3A=;
        b=zoLwP4N388IcxZbOILcsvNxLS/NolvE+8eTVXOjY63HtnK71yy/j4q3yGkKGZYSfiH
         Iwt6gTx1q4kr9yZR/PMRzysFHgXc4A/BJqDXNIQ0es0RR7MEEa/LmB3bImbEzj5bzFTX
         XxKE0dVLFpE7T3rYtBeYxmPohA3tQ0fJtJ0+A558fqxP/BzvyISVJ6tqt8xrDUjYFukM
         JJN0SRcFjR12iZIx6lgmdUJaBCvtk+0Zf4YmA0eOSmeBPeCjPd1OZzPFumP9vn5E23pB
         AqSyyJSSifT57UGP7trd7r49adbNfSmJ34RbOaucDJNcgHAK7nw/g5NZ/eA2HdLQHCnI
         ld6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705723; x=1796310523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KeC5eWf5hMeKptsQ2ueKHB3C2sqGyzZwcIt9dwm3x3A=;
        b=f4S47uUkkMOz184I7lSikk6vu51X9CjsbKWzaHiOCs4gFiLmTFAnPbZ8jBQeSklrBu
         ET5Qfs7HqALQu0L1mLJwiUtaoqHde+uX9cGB/7rIVVMUzoTgdTLxDPAAV/Y3BpvVbeLF
         FqvJ62TqZPlvi2FNNdWGXRbP/U2hZp23SyyNlJ+2n4n/SifTQkaf3pNCD9rQK+qxeUMa
         HL74eBqvPuEqUhCx0Lp0erzXCp8+EEWpOkA7A+WCkn0BQ9BpWSnfaKIUBnpr3yno/ItG
         P6wppYuLOC4KYON7WWH2koVZRstQJLDNelmyZ1dYr/DsDvU7lRPU0F1UdYfoVDbobprx
         NQpg==
X-Forwarded-Encrypted: i=1; AL+hErHTAMHOAWXfvy2x1leTZ6FOhQez2ukPfKOnC9DlUk20HDmy3kPqM/GCIE/e1I+coLWt4tn/7KwcM0oY@vger.kernel.org
X-Gm-Message-State: APuU4Z9YcODUtmJcv81AMe4yTgk+FxDfdUaLDib29kzJOme+pEi+yIIa
	55Hx/+lQvKZT4lQoh/HiHmaodFX8vJdQ/IoJHVlttAPijswhcSOzzAvG/nZ43pt5SXqD
X-Gm-Gg: AZFdTZcAwowp6YGojxiRpxCY/4M7POfdiNf8FC38lFqKNqWe93EUkzAcMAc1zg6DmVp
	2L68EbYbf5635KDu+jjfbNnv7OEBiiKeSRqjEbScOuGPFjZ2OhA7icpUB5B4ifuDK6lAhnFbAKI
	7xX6SjkkiZjLVoq5gWdF1vJ7zlOgAcAGerM2SVVsGOhzEUlBZS+CTQn/VWK7nhRI0kg28LCEl76
	Ke1AEe7ThJU3mF30ZSy0gisZgjd2xnf5mq2Bd4SPB3hYgTTG71DioUEjYGAP/TL3g90I3xG23mn
	gx0rdRkYzdKsA7OMlSniuYToFPpLWdvmgKx6cAroJ9CBLNwm+F18dwGH8jJOwQgnRWQ0b2D4QMn
	SChUYrb0W2kBjDdNqkHsqgHRL+IQvWIDGR0mVG5ySIfsh4p47JXkXhqJarzap7QE7kRZP9uBmFA
	dwkFhit9mHZx5uPj8+1UEGolSqBgs4iv2+4HrdqCURco87KsvodKVx2KAqEpEVS7NG/g78QWOfW
	tc3hf52y7cZKST1pJ3f8Jf96XWmxDC19gLK6+SXSOR3TPFhtFFZo+DGPr9636hvWxa4xujnidaT
	Pls3pDn2T/AC4+6UcQkk/mZJ8NV6huE8G8vuFxdbMUmeriBCHii1PND8DZdkuJLFE2ma
X-Received: by 2002:a05:600c:828e:b0:4a1:cd83:b23e with SMTP id 5b1f17b1804b1-4bb88786ddemr395665735e9.0.1795705723030;
        Thu, 26 Nov 2026 07:08:43 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm599850045e9.5.2026.11.26.07.08.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 07:08:42 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Ian Bridges <icb@fastmail.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	RootSys GmbH Research <research@rootsys.at>
Subject: [PATCH v2 4/4] ksmbd: refuse session setup without encryption when it is mandatory
Date: Thu, 26 Nov 2026 16:08:36 +0100
Message-ID: <77bf8917c216359ba7fa0d837688b98d3e1a798b.1795701726.git.research@rootsys.at>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1795701726.git.research@rootsys.at>
References: <20261119103805.29514-1-research@rootsys.at> <cover.1795701726.git.research@rootsys.at>
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

From: RootSys GmbH Research <research@rootsys.at>

ksmbd.conf(5) documents "smb3 encryption = mandatory" as "clients that
do not support encryption will be denied access to all shares". The
kernel does not do that: KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION only makes
the server advertise the capability and set
SMB2_SESSION_FLAG_ENCRYPT_DATA on sessions that negotiated encryption.
A client that cannot encrypt (SMB 2.1, or SMB 3.1.1 without an
encryption context) gets an ordinary plaintext session and can use
every share. That includes an attacker relaying a victim's NTLM
authentication, who chooses the dialect and NEGOTIATE contexts itself.

MS-SMB2 3.3.5.5 stops such a client at SESSION_SETUP, before it
authenticates:

  If the server implements the SMB 3.x dialect family,
  Connection.Dialect does not belong to the SMB 3.x dialect family,
  EncryptData is TRUE, and RejectUnencryptedAccess is TRUE, the server
  MUST fail the request with STATUS_ACCESS_DENIED.

  If Connection.Dialect belongs to the SMB 3.x dialect family,
  EncryptData is TRUE, RejectUnencryptedAccess is TRUE, and
  Connection.ClientCapabilities does not include the
  SMB2_GLOBAL_CAP_ENCRYPTION bit, the server MUST fail the request with
  STATUS_ACCESS_DENIED.

Do the same: when encryption is mandatory, fail every SESSION_SETUP
with STATUS_ACCESS_DENIED on a connection that has not negotiated
encryption, that is SMB 2.x, or SMB 3.1.1 without a common cipher.

On SMB 3.0 and 3.0.2 this check does not trigger:
init_smb3_0_server() and init_smb3_02_server() set
SMB2_GLOBAL_CAP_ENCRYPTION unconditionally when encryption is
mandatory, so every such session is told to encrypt, whatever the
client offered, and "ksmbd: reject plaintext requests on sessions that
must be encrypted" refuses its plaintext requests.

Found with AI-assisted code review and testing.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: RootSys GmbH Research <research@rootsys.at>
---
 fs/smb/server/smb2pdu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a133437b94ab..a0dfe13894ba 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2658,6 +2658,17 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	rsp->SecurityBufferLength = 0;
 
 	ksmbd_conn_lock(conn);
+	/*
+	 * MS-SMB2 3.3.5.5: when encryption is mandatory, a connection that
+	 * cannot encrypt gets no session. SMB 3.0 and 3.0.2 connections always
+	 * negotiate encryption then, see init_smb3_0_server().
+	 */
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION &&
+	    !smb3_encryption_negotiated(conn)) {
+		rc = -EKEYREJECTED;
+		goto out_err;
+	}
+
 	if (!req->hdr.SessionId) {
 		/* Bound abandoned SessionId-zero authentication exchanges. */
 		if (ksmbd_too_many_session_setups(conn)) {
-- 
2.43.0

