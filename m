Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795084698;
	b=oYQJPtg2GT/+IUfoXdYu6eB+iaf8Ighp/9Hq9F97u6JY5p3lUOTw5VF1ZqN52O81mnbM
	 o0Kq8Od4AO6L58VjZscOIbmIzmjLNnSqLWQLygooxBMorsbr8e1iFJUvQU6AFNY/ry2qR
	 8Tk3dlxsPpgYs4vQlUufr4iu0AHwqB+yJOWDc8qJlkHAvjYiNG2Tk48ZqmmZj/nz0hnvk
	 gBWYoPCCSK1MkXjxnDN+K7ZcAWPvT/Z+06iyonSzkNuzq0lk2tZuajSa8RAYtur0M7RpO
	 zFsGlOocZqrIxdSD3Y91pJOunDNA4Se47/UW7HYi7rID/7oPQSmLgKR9Jc63pCwr6sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084698;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VVyqYLZTV+/+pFE18MYA7QP5vsPlZNWN0V7yac5lwY4=;
	b=RL6HAUqpwwLdaJjE6r0QSy9PwZnwpt08QyrdWAaT2acTZc6vUPRLAzK8kNgIZkga5kdf
	 n2OReTmK/qaa0PLnlGtW6atOF3GeuLedZ/nrK297ft9mAHXY2rSxAwOWu9rvTjXSOP9zQ
	 f9qaPfSTOsE2PKN/gqvhXcBvM0ZKcqiaZNcjaTF2W7yT6PDt64Zhp7F2XvvLyk+IoBSVr
	 W17Meki5OLKUS/KouH/aenceJ4JIt1vhy2ReA8xeud3N2WR4ZC3L/d/3lAM1cU8nAZz7q
	 HHaurW4r5Hn1vg91SdaAgG6gCUxCpVk/9QZfFFpiz5Hac38T43diuKp9CQHV3Basx4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=MtMRUfe2;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B4606A320
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 10:38:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA4B4606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=MtMRUfe2
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so15327385e9.3
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 02:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795084696; x=1795689496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VVyqYLZTV+/+pFE18MYA7QP5vsPlZNWN0V7yac5lwY4=;
        b=MtMRUfe2W1xsMLBtqGoRNeWnl5lPVIW88SPaXxzN9pDLauN/GjnuqR2fRGkoz9i0sH
         XsGNVPOFkQMt+o+bpS/X6THTX8U8wurconT4WESlr+4ZkW0it7joxj1GQRykTAqYuonH
         k/VYft9MXL2o9K0II+X0FRZUpeZjiXaQkc4O9vl04RX/0tsy8f5UZn4jLP9lv277YKRe
         FCHBqu4Rn45kAN9CeXYhMO+m6ciWSXcoSZrVtfQ31Egr1pqqcuMjoi9fyXlDC2H9g1Gf
         W2Rd8i05Y0lgkzHQEEyN7Vp02RgjohyV56Rhld/4GRtu48YtOJFPfyIQxEbl/A1tjXJf
         mW0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795084696; x=1795689496;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VVyqYLZTV+/+pFE18MYA7QP5vsPlZNWN0V7yac5lwY4=;
        b=eWRMphB8fOte8RAOBDMV1TK74F8oxhSzUDr+0TXGW6u8DdztxvCrshtFc/evngbHt+
         0UlBlXFICgVElCHlIGVTOoGtnAQx5AXdiE6e9o9h8GYZTBa9zhq4qmoxEX8Sv8PuyD4R
         znPxbuqYNAq35/vZD6bPTSVLbdzQ8JaQSuyRoLlNqldu/ORDwpMyJBPr9JRbPhu9XaYu
         SVZkQnMB+tOP9RA2Gn0Y8/pV6yNYRg1MX6tNm5g7hH1cErUcLK3XEs0N+6WObI6lhVzN
         OwG8qozkqjP+pNhm8E6jGYGS1CsWibATKls5j9jzvHzKjp3fGTXg9J5VXuFyK1ETh7x3
         4hiQ==
X-Forwarded-Encrypted: i=1; AL+hErGTjdqOcJFtyymlqwhzUoee2+wD6b9jmYjDifZEclXMyTWY1RgX1amw69baiMe4lkNAd7bgTrkpOS0Y@vger.kernel.org
X-Gm-Message-State: APuU4Z+WTw8riSwyAO+yqS4Xd63yavBUq6yHKk9cJgXhPcxvs0UV7bA2
	HG2laQEGQi9HxQsMmy2oOdiKNKM3rloByj6ZONLf7r5cWI3viRHZaBhwy4BIpfIvz+YC
X-Gm-Gg: AYBFou2oBpUuOfEcTJiC+85+xY7LmVspfk61QROxFOicf80xPy6ASTMS/O46j9Vy+ID
	8Ky0Q+2mTZZ1Up7KVHDH9ekxmRaJ41IbiQiKALXW0Ox7FTcqh9/aSNTX8yiPyPTZ/fuxeXiMiQG
	6wL7x37fTqq4S3zgIwixAZ48Cg3fejPXNULDmYbd3frblYMvJnGQTQqk/UN5YtlavXHV8pEcxEn
	jCdzSACPeFwQxAFruwjdg8b2EXVNWoJ1rfYa29GwJPcBDaa4DsEFwOsBQjKUPTm1yTHw1qtkTVz
	NKcqx7+MvzYCqBp4tHzIY3EkNkLcMtXjdEL4VMqmaC+ToO7gryTN8nzKNi5FNr9VmH+A3qt8xKA
	Gwsdc4Nz5qExEAgA/aUgPA4v64kCw9I5lGeYc/svYUsJeaHuAmgzrqUNw7I3iylfw5/8/5uFwTz
	q2ED80KaHRntno7DAuTC3FD8cjGCorW0iY+NMoxKlVNfA2kPWJ/kOZ0nvxy9DbWik+uxcA15W++
	aIVlnpHLgpJS7E0VwjcabCgh58OC53mXv8uKwMUSxSQUHGH/L80tiqVCx4ShaLnLT/G+dcmwPYi
	Z9hv8id8oUOLQ3wsDLlaZTaKjxpaoXdAEyOkxZN6CBXaoOwo59nniZF3yiBT4kp5rY2x
X-Received: by 2002:a05:600c:1c1f:b0:4bb:6651:9eda with SMTP id 5b1f17b1804b1-4bb7da1a21bmr125700265e9.14.1795084695902;
        Thu, 19 Nov 2026 02:38:15 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655f9f4a7sm10030927f8f.34.2026.11.19.02.38.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:38:15 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
X-Google-Original-From: RootSys GmbH Research <research@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	mike.michalo@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH 0/4] ksmbd: enforce mandatory signing and encryption on requests
Date: Thu, 19 Nov 2026 11:38:01 +0100
Message-ID: <20261119103805.29514-1-research@rootsys.at>
X-Mailer: git-send-email 2.54.0
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

ksmbd does not enforce "server signing = mandatory" or "smb3 encryption =
mandatory" on requests once a client has offered a cipher in NEGOTIATE,
which the Linux and current Windows clients always do. sess->sign is
cleared for such sessions, and the gate added by 2bebf2470af1 ("ksmbd:
enforce signing required by the session") only looks at sess->sign, so
an unsigned plaintext request is executed on a session that requires
signing, and a plaintext request on a session that was told
SMB2_SESSION_FLAG_ENCRYPT_DATA. A client that offers no cipher at all
gets a plaintext session even with mandatory encryption. On SMB 3.0 and
3.0.2, one client's SMB2_GLOBAL_CAP_ENCRYPTION is ORed into the static
per-dialect table and changes how every later session of that dialect
is set up, until the module is reloaded.

The consequence is that a man-in-the-middle between a client and ksmbd
can inject requests into an authenticated session and have them run
with the victim's credentials, and that an NTLM relay to ksmbd is not
stopped by either setting, which is what the two settings exist for.

The session handling goes back to e2f34481b24d ("cifsd: add server-side
procedures for SMB3"); the signing part is what is left after
2bebf2470af1 (v7.2-rc5). We reproduced it on mainline 4405c18c95d2
(v7.4-rc3-230), on v7.3 and on ksmbd-for-next 267029b35ad1. A
reproducer is available to the maintainers on request.

The series is based on ksmbd-for-next 267029b35ad1, because patch 1
uses sess->sign_required from the session setup signing series queued
there. On mainline it applies on top of that series' first three
commits, 16ab0adace8f ("ksmbd: verify the signature of session binding
requests"), 42a1d80e64a3 ("ksmbd: sign with the negotiated SMB 3.1.1
signing algorithm") and ea472ddf7a9a ("ksmbd: use the channel signing
key for session setup on a bound channel").

Patch 1 makes the request gate honour sess->sign_required. Patch 2
refuses plaintext requests on sessions that were told to encrypt. Patch
3 applies the existing per-share "needs a negotiated cipher" check to
tree connects when encryption is mandatory for the whole server, so an
SMB 2.1 client can no longer connect in that configuration, as
ksmbd.conf(5) documents. Patch 4 gives each connection its own copy of
its dialect's capability table.

Testing: built with W=1 for CONFIG_SMB_SERVER=y and =m without
warnings, each patch on its own, and checkpatch --strict clean. On
KASAN kernels built from ksmbd-for-next 267029b35ad1 and from mainline
4405c18c95d2 (with the three commits above), each with this series,
every unsigned or plaintext TREE_CONNECT that gets through on the
unpatched trees is refused with STATUS_ACCESS_DENIED, and the next
NEGOTIATE no longer advertises a capability another client offered. The
in-kernel cifs client still mounts, writes and reads with sign and with
seal under mandatory signing (vers=2.1, 3.0, 3.0.2 and 3.1.1; seal with
3.0 and 3.1.1), and with seal under mandatory encryption. Not tested:
Kerberos sessions (krb5_authenticate() gets the same change), SMB
Direct and multichannel binding.

We found this with AI-assisted code review and testing; the reproducer
and the fix were tested by us on current mainline.

RootSys GmbH Research (4):
  ksmbd: require signing on sessions that negotiated encryption
  ksmbd: reject plaintext requests on sessions that must be encrypted
  ksmbd: refuse tree connect without a cipher when encryption is
    mandatory
  ksmbd: keep negotiated capabilities per connection

 fs/smb/server/connection.h        |  2 ++
 fs/smb/server/mgmt/user_session.h |  2 ++
 fs/smb/server/server.c            | 14 ++++++++++++--
 fs/smb/server/smb2ops.c           | 19 +++++++++++++++----
 fs/smb/server/smb2pdu.c           | 16 ++++++++++++----
 5 files changed, 43 insertions(+), 10 deletions(-)


base-commit: 267029b35ad1245a36d069cafe93b4ea654e0f81
-- 
2.43.0

