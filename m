Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704502;
	b=MpFqXo1ngsuhyC0ZW8XMq5mcoPkHohyNTSD9tCWGUBKpZLQWDSiFJcy8H5BAUYycB9H9
	 jcJXFufmNgjec8piM7CuzAIHR6voVr3kKcL4A9lAifRtYScZdhyZirpVKDiw1f4pvrKxf
	 BHrwC5oVuyfwcAyYf6iTm7txBGUXdqM5iHBxCoGPwQ3LwKy2xLtTUPcw0BmOB1x3TsiMV
	 IF2C6/aG8GudSdjWCDzjA0Ma2JKUDn6gUPEMGOa8We4sqS064rIIxuW3/gAwPwSNEltYD
	 fZmvVJONOpDhi/HZrL8I46+cy/VnItnRhnA4KZtw8ROMWgQ4vTRERxIgrlFeZB3A3Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704502;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FqFkEa1Wf24oHm/ydD3AaExm05JqCxeJcFBeUKnuAzg=;
	b=nWtLWMjBLPE9tqpzTm3bj++T65bCquddb8lnSISXh0+3V//GZJZInvMAKaUdgt4zY6Ta
	 CCBamxD887ais7Qqa4apgd6mNa0URmZ5vZakd9AzYThoM7cBCKweQkkxilnxSmc7QlHsz
	 HExmBDK/tC9tKPBAfWtDHt5S9LaZez46yn/ZelPitIRjuu4hDEIbW7fZVMxe9LIS0wNJL
	 pUK2s3vvlH4i6tNvhW++eTxxuT0je8a4AUn+JkMWVy56o+BiF2bECpQ8xQi7PPSx8ULIh
	 AyG061DFHeGg/xmCIgytqmTslLgaFXIt0nU9lGCP2Jkg8jdvIyGBrvJwm2EH/KBlh0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PERKkOYa;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDA0606A82D
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 11:15:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DDA0606A82D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PERKkOYa
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4301e334ceso302707366b.1
        for <linux-cifs@vger.kernel.org>; Tue, 03 Nov 2026 03:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793704501; x=1794309301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FqFkEa1Wf24oHm/ydD3AaExm05JqCxeJcFBeUKnuAzg=;
        b=PERKkOYaShx0AfUcvg3glaGUkDjcU+eiSZK1M0atlWYClrtMCNETno5tQmbA2D03Jp
         hssa2xi9vaeUhTseMPme7sq43Gz399dWzXFDA3BRj8Hpd41Cxf0QC01ZIbT3sGAMsHhV
         9jECDUetyiBXHBXrZlhrvP8clv8ONj8jE3cGNyRyTuF7xTxLTdM6W+RsW//rwvq/7vqk
         7UoFiqrU9tEvMf+tN+iqj4MzZyQ+DnV3ogkM70ewdakuOSbj7Uu1kXVnu/g17RufdLAF
         xzxIMnzQbz2r7vRgxZbZZCbxVDrHkkLIYuYUxEtH0H8HIFn4b46YWTYs83FrKJQ4Drji
         VaRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793704501; x=1794309301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FqFkEa1Wf24oHm/ydD3AaExm05JqCxeJcFBeUKnuAzg=;
        b=DCg1e4FUMFdzuIcKumtzZIL3jPZ0rXp1cc5Et0miz9e8By2wBMj7GmP9Bj5dkhRHeY
         zNGadHrnLiUZ8b6LpjmRo/77038+tItNiGzlL+ovdEETd54oY1rA69a6XnPv1Ijb56YD
         cLyjCQcZhilEa9Ho8Nlt6EbGPHtpIw0dYVq6Vynedc35X0KHUMyyxaypkz+3L0yo+j+/
         c2GSFoJZ9PYBs6r4FV1FDi2HQukCI74vID1LHqleU82pnqPpj4spjtg7LsWVNuBdCtrl
         29zk7Qy4fkB/4UawIIZyzLF4XmVG9ZrWLJADo+iu9k4KTiLsbyuYos9UU375y1pzxDOZ
         V0Cg==
X-Forwarded-Encrypted: i=1; AKwUvBytGeCDWJFcWduMJeiJhjfaQnMT+Ms+xwS8wtM7qhxKAovROwHEmInvxONV4RjXT0SI4cn05LHmcMpB@vger.kernel.org
X-Gm-Message-State: APuU4Z8fUWgTdXz6vSS+bFX4cGVDuPgFcqhx26RR+6DjIogaHCWKjCim
	zkQqqS1Rjw+jPUXJU2PwDh38tDlk/dHtcUOVD0uGmsG24nyEuEOchHlG
X-Gm-Gg: AYBFou0Hqf1p9eiO2j+8kjdtr924w4cVVuJQdVEH2Oz66pTgT6tluzUSZdcS5zbfLJC
	RIAmFTdk2Xzi18c55srlUbE1G6z1EUZpPK24x03nsLLzpwVCriZkbLuvvFOCZOW5Xyrl/kko26H
	kBGmgBgMZDB/0hu/ZhWxrcaIpo5K/Y9oN1JhjvMGcnr91cc9mkUzx9m/KANViJEQTy5w8svu086
	PPu0NeUiX743zgD0/HAlmRf8Yp9JqkV3eEY5Hs8ub3VAXPWOS0GzsgIfNm3k4c6tDbmmS935UJz
	FMBQJn35drTbopivrq0+PvtUSBiUQ0mXFP+lk3UM75ZLNhNBbtTr5bu2WRU8x5drSTHz4YeLLcP
	9RKU7clhjXlWqrlBz6JXnm5yuS1rbpVvU48P9G7CqRG6pXGSvYz+y6iVUg+A7fzJz9OtLg/8I7t
	uFql4chy1kKnZ9Fnuhsofn/6yt28cBRYYxpIuKMBjkWSPNWc6nTqafl9j9bPg1dOe+XiOjHp8mB
	DxnueX0DmMelxkKYMCnwpHeZBK4S/s10XnW0uQDnsTknecTyKRYChiPdOUmsERz3j7dGE266WLb
	ifK/mTbdzhmybMbjb8tuDcMMDaktWuQxjk/thYRlTprE7GPr1Wzg2HENtPZ0hr0AT0lNTp3w7ru
	kbMYXEVEkfBqmFthnAiJ00IA1+FjMOU6uzsoNRPBK
X-Received: by 2002:a17:907:d9f:b0:c40:b477:dfa0 with SMTP id a640c23a62f3a-c4ca7a46ab6mr975704366b.18.1793704500712;
        Tue, 03 Nov 2026 03:15:00 -0800 (PST)
Received: from wlan-199066.nbw.tue.nl (wlan-199066.nbw.tue.nl. [131.155.199.66])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4eca0f376sm4349291a12.26.2026.11.03.03.14.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Nov 2026 03:15:00 -0800 (PST)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ksmbd: AES-GMAC signing support
Date: Tue,  3 Nov 2026 12:14:51 +0100
Message-ID: <20261103111453.84804-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
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

SMB 3.1.1 clients choose the signing algorithm in the
SMB2_SIGNING_CAPABILITIES negotiate context. ksmbd parses the client's
list, but init_smb3_11_server() then overwrites the choice with
AES-CMAC, so a client that does not offer AES-CMAC cannot connect.
Patch 1 fixes that and keeps each signing key paired with the
algorithm it was created for. Patch 2 adds AES-GMAC, which Windows and
macOS offer first, using the lib/crypto AES-GCM API.

Discussion:
https://lore.kernel.org/linux-cifs/D0F05F9A-5097-4A2D-9235-AE395961F456@gmail.com/

Testing:
- smbtorture 4.19 with each algorithm forced
  (clientsmb3signingalgorithms): without the series an HMAC-SHA256
  only client fails smb2.connect with NT_STATUS_INVALID_NETWORK_RESPONSE
  and an AES-GMAC only client cannot negotiate. With it, all three
  connect and sign with the forced algorithm; smb2.connect then stops
  at its tree disconnect check (STATUS_ACCESS_DENIED instead of
  STATUS_NETWORK_NAME_DELETED), as it does for AES-CMAC without the
  series.
- smb2.session (smbtorture 4.19, multichannel off): 21 tests pass
  instead of 12. signing-hmac-sha-256, signing-aes-128-cmac,
  signing-aes-128-gmac, encryption-aes-{128,256}-{ccm,gcm} and
  bind_negative_smb3signGtoH2X{d,s} need signing negotiation and now
  run and pass instead of being skipped. 26 other
  bind_negative_smb3sign*/smb3sne* tests now run too and fail with
  STATUS_USER_SESSION_DELETED, because binding needs multichannel;
  see the next item for them with multichannel enabled. No test that
  passed before fails.
- smb2.bench.echo and smb2.bench.read with each algorithm forced,
  smbtorture 4.19 (x86) and 4.23 (arm64).
- smb2.session.bind_negative* with multichannel enabled (smbtorture
  4.19): all tests involving AES-GMAC pass. Without the series most
  smb3sign* tests were skipped, as ksmbd could not negotiate anything
  but AES-CMAC. The four AES-CMAC <-> HMAC-SHA256 tests now run and
  fail on existing binding behaviour that this series does not touch:
  the *d variants because ksmbd rejects binding from a different
  ClientGUID (Windows accepts it), the *s variants because a session
  setup without the binding flag on an already bound connection
  succeeds instead of failing with STATUS_ACCESS_DENIED.
- Windows Server 2025: offered AES-GMAC, AES-CMAC, HMAC-SHA256 and
  ksmbd answered AES-GMAC (checked in a packet capture). A 1 GiB copy
  to and from the share came back identical (SHA256), with signing
  required and encryption off.
- macOS 26: negotiated AES-GMAC, 256 MiB copy identical.
- No "bad smb2 signature" messages in any of these runs.

End to end, smbtorture smb2.bench.read with 1 MiB reads, MB/s:

                               HMAC-SHA256   AES-CMAC   AES-GMAC
  arm64, Apple M4 VM, loopback        1354        924        797
  x86, AMD EPYC VMs, 3.56 Gbit/s       449        341        469

On arm64 AES-GMAC is currently the slowest because the arm64 GHASH
library code does not use PMULL for bulk data; I'll send a separate
lib/crypto series for that, as discussed in the thread above.

Not tested: multichannel with Windows or macOS clients (binding was
only tested with smbtorture), and SMB over RDMA.

An AI assistant was used to draft the patches and as an independent
reviewer. I ran the Windows, macOS and benchmark tests; the smbtorture
runs were done by the assistant under UML.

Michail Andreas Michalopoulos (2):
  ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
  ksmbd: add AES-GMAC signing support

 Documentation/filesystems/smb/ksmbd.rst |  2 +-
 fs/smb/server/Kconfig                   |  1 +
 fs/smb/server/auth.c                    | 60 ++++++++++++++++++++++++-
 fs/smb/server/auth.h                    |  4 +-
 fs/smb/server/mgmt/user_session.c       |  1 +
 fs/smb/server/mgmt/user_session.h       |  2 +
 fs/smb/server/smb2ops.c                 |  4 +-
 fs/smb/server/smb2pdu.c                 | 53 +++++++++++++++++++---
 8 files changed, 116 insertions(+), 11 deletions(-)


base-commit: af8c72f6550744fe948ef2dbc7ab8739c149aab2
-- 
2.43.0

