Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329927;
	b=d62ZdUdQyEGv0NHjTL+Yom9idsU9gk8DEsNqoFbQzMqHjIVu/DXk77gpErzAJKj05cZh
	 CNg3pFPaLhUBdawwdtTWEsC/rDnI0cV+H3ZLGGuMGBacjMLo0HJKJA6hHAkUPeX2U3Mh+
	 MdlR1IRnGuTAfGi60X2dSMXPm+w0Yi20YfPptXTtSbeShw5y8B4gZ2Pk1BBAmaupgdoDl
	 FSk+32bRRRnQmIFDsmn58xdC73vwvYeE1juXb9T4SVkvtwAIbJcrtJbhC+xhMdkDJ+5El
	 Xn5p9qthHC9jr+DHoa0xu1JukaJLBhMgLGg6RvFCVhe+swSwkFueFLZNgHAKfsGW9ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329927;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4WuqVXrjAHcNCbBhH0GU+TGhVg7H3NItgvBFauT8hq0=;
	b=rY/ylGv8irzLcRQG8h9chrjDLlHaMK18m10ct7Ur3w+RlxdhT6h7edpQqWF+3RzrMiVW
	 1tN+e6OSQCzRVlxzd9NdFFju1mCuvkV8t5/tz8y5ydooeQBgywWOO4F61q7+VSfNm7soT
	 LTksxXiezlu6TOQsiIOgIeRK8+eQCXn1jPgfF5uNq6RTC4YfBtTKSxj6WHtS5UQpSSJjM
	 gRxijKRr6W9Efrhr+l25zBVTr4DljYv4UTFAWKH+A/Tg7KTjt45OdJRn38lYAlM0AaTzZ
	 VRtwQi2WOzHdvYA+rG01nGenc1VamEozxtAx/qXOGvVRE81EhzmMGh5KD10Z/LOan0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sDWcWRKI;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28A1606A803
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 16:58:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F28A1606A803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sDWcWRKI
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a070755c8cso1147589b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 08:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794329926; x=1794934726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4WuqVXrjAHcNCbBhH0GU+TGhVg7H3NItgvBFauT8hq0=;
        b=sDWcWRKIfUUCcA/N01Zh4Mg8CUpTGsCQUh6Dcxwh6y75biVggNyJFTafNSlC1Vr0eU
         AZLUn2fWh18BPpxHIdhfSumjjztU2Jd56ZUAS+lbTRABHedH0SNXdDqQ9x2iTgYZ/1F0
         z2aNyxi5VvA8t9Sr1igAq38z+rDViJoF4V4EpBJxfWn6LqD9yggd6PCgnwhRlnCe/Z9m
         uJ2PItpo3rSddmrk6OAPUCqJAZhdO8KSNXXO5ETSSsfaaSxiODEDHkJyqVDIjKOp/TOW
         b1sEQAcs19c3r0NqA1itPd1aHICl3nHYh9gsHxxgfJ+ff/Ogp+BnSzR9rXQfivR0RQ46
         b0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794329926; x=1794934726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4WuqVXrjAHcNCbBhH0GU+TGhVg7H3NItgvBFauT8hq0=;
        b=Hxa/abofk2qUowGo1k8J7YiM5u7VryK3Ngj60GSOY5eLXfnvfGUnpNyWJpfjlUCrBU
         HL6v3H5NkXz3UpZuAphEMXrbxc0tLl3fsfBzwQ2/ArTa/gHtFOI6ct74oG5BcD3CXVfF
         XXcopgwWf9kQEWQANuLVNukhaovLcEIpC7NwUlHMZYsFCvY8a6ERPmxF2RSyus5n+eJC
         6OU4H5kZ85JWnKITAAhvImorZlozQ3W5vHy9RW1jQX3xIO0eUAAa0EDeBS6uIIFt5MA3
         OehNjJyfpNnSpNCKwQlcFJhovgxg/WGJ2De0/cJ0fyVyFYCSnL5u+0c0H0bgsvMOhgNG
         2Abw==
X-Forwarded-Encrypted: i=1; AL+hErH+xywrke+2Yh90EPJjRNxv7jvWRLuSu/nN3EVOodYgU51kKbLCmCFDdI+bQj1JE3AuNVhTslUiqM1C@vger.kernel.org
X-Gm-Message-State: APuU4Z/28O2n2EW3ysB26YkGYf7jrWUDK9m/6OaXnmWJqJRaERzLzdEX
	FmRlBdsth0wlndoTlUhlSij80HWP2nX59cVqeFxr5FWW3ux7SY23eExE
X-Gm-Gg: AYBFou3f3sCTNG+DHS5bMPi5AdpdV37m0HVZ1AeUbSpQyVl7jxwvB+TeC6O1pLmckfz
	rSxFSOYYrCUbGeornixGGo3vPONCpn0dDS4W0Bag3f/129qKpGVEh1O4Htpj7zLk4mH69/Wd0eN
	BPeWSx/r0aYn2lXf2CgeBv2Xa7sfJmixFOmnUk033Cxpi2KkKUrdtNpQ6jjOJOIF0UwB8GCRCpu
	emkXIRW0zCkA21Toi+gu2zrjfQR20V8rbBBgT7sJSmb7xoP0I6PYJ7wrGoIRq5cycnotyGhU/Nb
	Xsb1LzbSzZrXWYFW9qvsn1twKQJ3cgXWDOptXUv2isc9w26VS/uWmH56eq3qdyrB4yq7GzRk+Sx
	vOjmBWzFf9tVqBOAa1GOfaYkJ3DfUv3nql7lz85v6Y7UxmyjjDdC+vh3m4zM5mInmxmueDtPW+2
	/ez9WWcODDlXgBIvZG1D5wq/sPV210DlOjbR2anET7l8BQ1StKliIV3e5GYpxBAH+zFLp/DGRcy
	Sg8T4Qj4LkDBjA+9TIvR+blMjRxhp7Mj5UdFcQesy4245n7zziH8A76/bT9lA/ddco3sC7azQHL
	+sNx0X8Ed+OcZ3hoFzK+1zXuYHfqvhwLUG4tgYPRJdX3hhyeu6jElJOoeSZ9tBdFypOi5A/iHg6
	5dfcR2HrAyB7NV3w9ralsNnTRdlkR2P58YpMdPx2KY5cagIUyHY4CFig=
X-Received: by 2002:a05:6a00:44ce:b0:89f:fc75:6d99 with SMTP id d2e1a72fcca58-8ba881e82c4mr3179615b3a.60.1794329926340;
        Tue, 10 Nov 2026 08:58:46 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm1157154b3a.46.2026.11.10.08.58.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 08:58:45 -0800 (PST)
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
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Subject: [PATCH v4 0/6] ksmbd: verify session setup requests before signing with their key
Date: Tue, 10 Nov 2026 23:58:28 +0700
Message-ID: <20261110165834.28162-1-mike.michalo@gmail.com>
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

ksmbd signs some SESSION_SETUP and error responses with a session's key
without having verified the request, which lets a peer that does not hold
the key obtain signatures made with it. This series fixes those cases,
makes ksmbd sign with the SMB 3.1.1 signing algorithm it negotiated, and
fixes three related problems found in review of v2.

1/6 verifies multichannel binding requests with the session signing key
    (MS-SMB2 3.3.5.2.4), as reported by Ian Bridges.
2/6 keeps the negotiated SMB 3.1.1 signing algorithm instead of always
    using AES-CMAC, and signs each key with its own algorithm.
3/6 verifies signed reauthentication requests and uses the channel key
    for session setup on a bound channel. A reauthentication with a
    forged signature used to get a response signed with the session key.
4/6 checks the MessageId and signature of a request before signing
    STATUS_NETWORK_SESSION_EXPIRED, also reported by Ian Bridges.
5/6 makes the signing decision in a compound follow each command's own
    header instead of the first command's.
6/6 consumes the MessageId of a request on an unknown, invalid or
    expired session, which the error path skipped.

Changes in v4, following Namjae's review of v3:
- 1/6: smb2_check_sign_req() and smb3_check_sign_req() now restore the
  Signature field themselves, using their signature_req buffer, instead
  of the session-setup helper saving and restoring it.
- 2/6: use SMB2_HMACSHA256_SIZE for the HMAC-SHA256 buffer.
- 3/6: no longer changes __process_request(), as the check helpers now
  restore the field it used to restore there.

v3: https://lore.kernel.org/linux-cifs/20261109194144.22814-1-mike.michalo@gmail.com/

Changes in v3, following Sashiko's review of v2:
- 1/6: correct a missing negation on the multichannel flag, so an SMB 3.x
  binding request received while multichannel is disabled is verified
  and rejected in the non-multichannel branch instead of falling through
  to the reauthentication path.
- 3/6: also refuse an unsigned, unencrypted reauthentication when the
  session requires signing or encryption. Negotiating encryption clears
  sess->sign even when the connection required signing, so the v2 check
  let such a reauthentication through. Merely having negotiated
  encryption is not treated as a requirement, since clients routinely
  negotiate it and then send unsigned, unencrypted requests.
- 5/6 is new. With signing not required, a signed later command was
  processed without its signature being checked, a correctly signed one
  got an unsigned response, and an unsigned one after a signed first
  command was refused. It also decides whether to sign each response
  before moving on to the next command of the compound.
- 6/6 is new. Only a signed request on an expired session had its
  MessageId checked (by 4/6); any other failed-session request left it
  unconsumed, pinning the command sequence window and letting a replayed
  MessageId be answered again. 4/6's own check moves to the common path,
  so the MessageId is consumed exactly once.

Testing of v4, on a KASAN/lockdep UML kernel based on next-20261105:
the binding, expired-session, compound (including SESSION_SETUP inside
a compound), encrypted-reauthentication and sequence-number tests pass
as with v3, and the Linux cifs client works signed and encrypted.

Testing of v3, on a KASAN/lockdep UML kernel with ksmbd-tools:
- forged and replayed binding, reauthentication and expired-session
  requests, also inside compounds, get unsigned refusals with AES-CMAC
  and HMAC-SHA256;
- new targeted tests for 3/6, 5/6 and 6/6, each failing on the kernel
  without the fix and passing with it (5/6: each response of a compound
  mixing signed and unsigned commands is signed exactly when its request
  is). The 3/6 test uses an SMB 3.1.1 client with AES-128-GCM
  encryption: an unsigned reauthentication is allowed when the session
  requires neither signing nor encryption, refused when the client
  required signing, and an encrypted one is allowed;
- randomized requests against these paths, and 8- and 16-thread
  bind/reauth/logoff stress (about 130,000 operations), found no signed
  response to an unverified request and no KASAN or lockdep report;
- the Linux cifs client works with SMB 2.1 to 3.1.1, signed and
  encrypted, and recovers after its session expires;
- smbtorture's session, signing, I/O, compound, lock, oplock, lease,
  notify and ioctl suites give the same results as without the series.
  With multichannel disabled, the session tests also pass and fail as
  without the series; six binding tests that fail either way (the d and
  s variants of bind_negative_smb2to3, smb3to3 and smb3encGtoC) now get
  STATUS_ACCESS_DENIED or STATUS_REQUEST_NOT_ACCEPTED instead of
  STATUS_USER_SESSION_DELETED (they expect STATUS_INVALID_PARAMETER),
  since 1/6 now rejects such a binding request in the binding branch.
Ian Bridges also tested an earlier revision with his own probes and
smbtorture. Not tested: Windows clients, and Kerberos expiry with a real
KDC (it was emulated with a test-only change).

An AI assistant was used to draft the patches and as an independent
reviewer.

Michail Andreas Michalopoulos (6):
  ksmbd: verify the signature of session binding requests
  ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
  ksmbd: use the channel signing key for session setup on a bound
    channel
  ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED
  ksmbd: use the current command's header for signing in a compound
  ksmbd: consume the sequence number of a request on a failed session

 fs/smb/server/auth.c              |  14 ++-
 fs/smb/server/auth.h              |   4 +-
 fs/smb/server/mgmt/user_session.c |   1 +
 fs/smb/server/mgmt/user_session.h |   2 +
 fs/smb/server/server.c            |  69 ++++++++++++--
 fs/smb/server/smb2ops.c           |   4 +-
 fs/smb/server/smb2pdu.c           | 145 ++++++++++++++++++++++++++----
 7 files changed, 210 insertions(+), 29 deletions(-)


base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
-- 
2.43.0

