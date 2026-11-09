Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794253315;
	b=mUIxKnM2xdY+nEaH2A7dlXZQ3tAeNMZf+arJh1P/lIquDkdOwhbHiDa3UOO5fByX5CqP
	 tL+DxFWngI0S3mF5sbweLGUCSk4tI5HDU864tyHebHHEXGHtkuCeM08MVv8oso3Ke9r8j
	 89Vqvzy/pLerMgvSJcdYDm+qB4VOLfakaSON3kothP1x7dCYuZNdVU9OE+Mn9MVz6DZ2B
	 CjDlDAoCi4BLGHDY1DUnwP2Zpi8A4Tm/E4/f0OYdxbAeaWYwEsBRZ5R25mnSG7k1cZ0Ox
	 e6dJcALQ5wfwk2biH3/h9oiueEqdvmOTXTCprDgGXJWto7ICFo8TyZYgm1h823e87Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794253315;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=85yyBQIzKGZBCqGcTfxQFWl/kJjPTDSYq01hGWqbZYQ=;
	b=A4HVpqKNQRiAQZg2zkNhK5YWMJOJ1H3+4NnWq+Lm0TNq+qT41SfAGZreYZbcAgkPGpyh
	 K7zcUOsmRu9KX/U8Hq0c3+1pUOZAeBwyF7njqLoQMZrcVf7Yx8XqNipIH82S4d0Ot5RMD
	 Ta4hXSOmzNCq+EEhuSXVyxawDdBviGTEpBJcPFR7yC4bDx+gjjZ98eiX9wi5tGS1aCD1E
	 z9Y3kD2Ba435DLv8K62RaDXeGf2BvqPoYeTogs6MF5+stlSX62Evd0lbKqsVF3aS85xsi
	 qTQMGpDRPbPJvkQT4g/p04nV0VwMpu0aHCEDP7L1HmZv0MfImxPJ6xqjN4au/FLRwyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HBoqutWe;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD34D606A31C
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 19:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD34D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HBoqutWe
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e942864693so6311135ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 11:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794253314; x=1794858114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=85yyBQIzKGZBCqGcTfxQFWl/kJjPTDSYq01hGWqbZYQ=;
        b=HBoqutWebrHtLpZ4SJEKm5jb+nZ8nMjLKG4NkFYg7QbzsZLrkASRuAP0dhoWoIO4D4
         16Wyyo/X9IaDgz/nRSGE9POzoQaKrI+385PbcygGHA3Co0UWJNujsxoSd6zo4CqS+Niz
         OIFhfWjPTzEWI3Tb3I7w3qW+Aey8Ziv/kymegynrz1Hyifx+EpBj7XXlXyjinRgVWuNm
         ET/QdWVnU2pht0nD+PA0+4aF1fzw8+2kT80McBMxfNMhTi589lYDTIy4ZDuBBq3G9wg7
         ofX1EE0UHTaa0KiXdgOm+Z5nh2We/5Vz77FUKv8/29fRwn2uMColTanVg2VtUgbhgXQE
         B/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794253314; x=1794858114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=85yyBQIzKGZBCqGcTfxQFWl/kJjPTDSYq01hGWqbZYQ=;
        b=UK9XDrjHtF7Uy3j4yN6WBq7gu2Yk60lhvvSSkndEYH3sdQX5j6BEpffixIstguReUt
         40PchMT9PuifRtm4e1/HP2qrIjBADueoKpi6IODPGmVPzfteXnK2yLWhm5CJMkOZpaCL
         wUfOM2kpI4coUED/t+iIJa0nNTg/fLbrvAsrtvxoOh71UAh8fawibMc+GiehbuVcElMj
         O7XThaeo+VIg/vvzBvGAwr1jBmZJmlHodri59xapt7gtBJUaUurvrk7NnT4SEf3RHmmu
         MMA/7nb4OPX3gn4CP4WzvL7Vt1Id0gEN+N8n9VrxZWz4Gw3mwwRKP6GvdrAHvXfAIT7v
         Zrbw==
X-Forwarded-Encrypted: i=1; AL+hErHxRU/CA9AC4dy6gJH0KRTbicucV/a2ZdwCVNBPPyQ08yTKf03Csyc1ylk5LXdrN8xDbUZ7e6sr1ATE@vger.kernel.org
X-Gm-Message-State: APuU4Z/4b/1t3LgeCHCqCo2qDaVL4Q6bZ5Ib01J4Q7w60F8ZGPV3+4yl
	K+NuHVDqesQASJwkCQAnXhexDW2SnwDV3n+s2hTFSVcuXrItCO/M9tLx
X-Gm-Gg: AYBFou0NcLk4ArHx+1s7kvSPusx89DNmvpHZiSKmH/dxtt28JbkPn8LAKKfvZpJOuYW
	WznfYmcx1/BK6y3xESmWk00e6ATvAXKhqtfWjTZWo4L1JlThFI0P/SPpYgFCD77u6q9cIIfVw03
	X+6gZF/ppwEqwbhJKZ0aKZKWwsixMz91dZsoPaJ847aQxLTqHx+XvHIX1293IVU+pLujX1NO0cG
	ars7AFEVAtgFIcF8AFU4Xe7Y6Hq26e07Cryb8x4J3LQWlEweOijipdKwPJOE8rV39732EPZGLG5
	0b1p6MduorYS+ZvX9jvNvPJ4IdtljjQR2bTa2MjbV7/3NL5ea32F/h88lcMiHM8XYiFzAz8BU7D
	7EfmqSNxrXpHYHR5gkyhvLKFf4rbu4rZTnSuMUkIcyVCs4t1uqXuzqoH4Q0YZJo90KakdIKlLXi
	gpOUCjWjHkcLjWmO9jI3jkLWwlNwt3ZufcDTtdFpZuXrqdT6sX6/vZljB/dYaRUGLOvV8i5F8Gk
	BIypxJ7oKx7sbuJ/BUyAtAO+U0+coGcPi1b6ZeVtYliatBjFyU060xWwdAZRQH+Lh6lBPlwXn8x
	L+IxCX5AKFqA/oJjgAo2fAJRvNP6pu5kJq0tuVTD6OWptJic0wlnYUFGIsEkzG2vLzGNq5nOV0S
	oZNSAJoLgkHo5P+BNS4dphDZBUprx8QB2ft55Mpyx0LCe/1KGx7f2v2M=
X-Received: by 2002:a17:902:f541:b0:2ed:3be3:c63d with SMTP id d9443c01a7336-2edb91e2b78mr1330605ad.23.1794253313947;
        Mon, 09 Nov 2026 11:41:53 -0800 (PST)
Received: from localhost.localdomain (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4b950sm1388585ad.13.2026.11.09.11.41.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 11:41:53 -0800 (PST)
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
Subject: [PATCH v3 0/6] ksmbd: verify session setup requests before signing with their key
Date: Tue, 10 Nov 2026 02:41:38 +0700
Message-ID: <20261109194144.22814-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <CAKYAXd-Jo-ObBDs-AdGfaM+QmDsot3gj1g0oJiyDKczoUDg2TA@mail.gmail.com>
References: <CAKYAXd-Jo-ObBDs-AdGfaM+QmDsot3gj1g0oJiyDKczoUDg2TA@mail.gmail.com>
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

Changes since v2, following Sashiko's review of v2:
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

Testing, on a KASAN/lockdep UML kernel with ksmbd-tools:
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
  since 1/6 now rejects such a binding request in the binding branch;
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
 fs/smb/server/server.c            |  80 +++++++++++++++--
 fs/smb/server/smb2ops.c           |   4 +-
 fs/smb/server/smb2pdu.c           | 145 ++++++++++++++++++++++++++----
 7 files changed, 221 insertions(+), 29 deletions(-)


base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
-- 
2.43.0
