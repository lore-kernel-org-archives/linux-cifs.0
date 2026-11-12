Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794509455;
	b=yVf9gnoVlxKsWBA1/yXCaqsv0Ic+LPsC7J1067IIV/b9a1FO9To+KvfqxjGe7VgXaVGM
	 02xPW4H898p4eAPQTwmK3Tce2KQuN478wz/BpGGUmAgwLLLarv3ueqpzq8JqckLyt2Scg
	 Y1iT7UMeQgtfTP6To/p7KCW552t0fXtP35U/3J1nT5awWw/oK6yGbAqQ8FHEYmWQmVOhW
	 gY0V2WL3eEjdMGutC60IcICuzuW7sgInFgeJTzYO98pRvckSGKe73IGYUwB/h2X7Ymq6N
	 u35k0cRHhxAEUp3Rg17wBpfM1SM8cCao/sSJSRWtZoF8+odT98JpPdKp1lsoKceRvsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794509455;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zuKhdwcg6xd8KF4Q3PnkLCNayc4OKSSyagTSgW7VKKY=;
	b=m1aV3Yo0QHU1dKf/hhTYNtPzPl1JmAVyKqeaW0TudVQp9kKXA2J5fc4+QrXxuHXmnkbu
	 tbXZdq7A+oK8W279v/OffNlXF1FLRvw0bhGPXKW43JHI5U569ZVqRe5Pa9v9NyU70FPmZ
	 jNz+/abatEFp8gMDU4us4ISMxFwbOrdnR/AOgCsr2fzXnOF/YEfI5T/aUqBsZM0DafThm
	 L8d0qEuYpgAKj47e40FUEK0+etOYFCPaMaqx6ydx+dAzod1u8T/5P1YekwYL5hBJnVSh6
	 THzYkzdYvDUNEprt6uF0NYdMIPc4JEpUtuWRAXeoEdDx/f3s3Z+cwZHNDT8ZHeErkWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=feb2Sqbs;
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F53606A330
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 18:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8F53606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=feb2Sqbs
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e96502e447so1509985ad.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 10:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794509454; x=1795114254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zuKhdwcg6xd8KF4Q3PnkLCNayc4OKSSyagTSgW7VKKY=;
        b=feb2SqbsisFvrimJqNYW4esJf6nzR/AfyfZ/DRLeUzQzzocJHZlibJVqpMaFeNVCfI
         GufC0Sjcu1CLHN1WJzJPm8FwsF9AaLVZx/WJAocVN7NT0z+7dS3NWUTvgwsDgOBYoed/
         SC3JIwHvPcy59OMGiiVZC1kdQ0AGZa2TOZprPr7lcIGZEdE6bgGkYLyX5HtUYdbAWjbP
         PBbvUhiKzAM6jHEUjuR7vjWJ2+A/v34OiPIgAgqbxeunKhuiBSZVnSjWoNO4WJx+Srzb
         xr30uA0ya8oFmdNWBMLoe2oHE19hGMjknfuoMf+41Zt3AP1inNhQhaPxvb9a8RVAJ7F5
         2Qzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794509454; x=1795114254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zuKhdwcg6xd8KF4Q3PnkLCNayc4OKSSyagTSgW7VKKY=;
        b=ZlClysfRW+xisfxK8YNAntfvjmuYcO2eQIOML3DI7R1Z3h+7t/d6f4dGqJQQi2T4PQ
         Pbep1INputzHJqYTUGNe547kP5YP+AwBesT9GnMXn+Ss5rHycMnJOP/bmYLwOC//F1Kp
         WLsalwaukAnJIB08UOQnFuIqh18uOatGVgJkjKhu+2fUEp0yNsENFTBnlD0YhrIg0wpM
         a8V7sCZFEYnZ8cdxbODMBISjEIHekx4u6o16BTr76DKfGG9CMrvbLAF2+3xdl2ssTqbg
         ud6nmfj6n+vFE8WVuaijyiRxZtU7mpBpaC92OzGzWoob8+ZNOO1rob/LvouIPHbQ5YqV
         7tug==
X-Forwarded-Encrypted: i=1; AL+hErHINucZB/Ix1pMeo9hY29iK+leIKhtFyZ3YiAeaC7GoIXV7v0Kcg7ihitVU7nor9VKghxzV+aNB8C8w@vger.kernel.org
X-Gm-Message-State: APuU4Z/DKFD8RHK1K14wgABmocoQfL+y7ACCUZ0f2r54eGx08XnDyy7o
	mdermC5fnuUWTJbszHwALlz5EGFgiRjJHzyHIQGMJ6HwRS9dL5Sp7Dwo
X-Gm-Gg: AYBFou3xuFKHscMbQn6vGoYWXTE0e0dm9JzssuhmYnkoApDUuDbHl6sWM0JoLEeL/gv
	YdhUsCUm+uiW0MBsSfJUiKkEWBGbDnDZ7i0GeI+NMobY5yUCqOVLij55p42WiyK4920vj0KbjJV
	rr4xLpMbkKdb82spGwtIaHdD+G7qH2zPWeD1hn80tA+hjYeA+W1GmSnR85suSkVYHC1LP2uwAV4
	uQQ9CIT6p/Fz1AkQqJXKX1eL2vaY1WRCLernsvsQmFjxidiwqBYrHWBFuE82aGo9ZVbcaYbq4jr
	uNV6jvhTCYr7w+SQn12AQFj26hVspa1v4v+b/HUucIAVr1of7lVyd11D1miA7JPf5mBxple5dta
	L34j4rm3cVfOICDbo0q/dhtwaqErPoHR3oQb1SIfnF8sUI+dzZVSCMtVCX1XXN56umtweIvI9iv
	gADyqrZgq0iqsoHPK5fLnk6KRNLtzvA7GLBN+8DpXH1eoe3iKEsH/2as6vgmr2DeGTDvsyUftkj
	oQIualF1nn9i8WIxYEWXndHMR/IV9RTVa5km6VZBQ9f3XnkcFEzljp9yVjiHX8z5dzdsIRtJBcu
	ytob13cWwKyWd150xnvFgZUOaH/t6JwXLZ12Wt2uypnyqXTNzYpVb8dI2NzoKvicFsZwzRvewLi
	9iRy1Y32R6HoVt+0T+03V9EWFug==
X-Received: by 2002:a17:902:f60d:b0:2e2:e240:57eb with SMTP id d9443c01a7336-2ee0daa3531mr2660585ad.12.1794509453510;
        Thu, 12 Nov 2026 10:50:53 -0800 (PST)
Received: from localhost.localdomain ([2405:9800:b901:33ad:cbb:dbe2:bd9d:a035])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7cf7bbsm66205ad.29.2026.11.12.10.50.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 10:50:53 -0800 (PST)
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
Subject: [PATCH v7 0/8] ksmbd: verify session setup requests before signing with their key
Date: Fri, 13 Nov 2026 01:50:36 +0700
Message-ID: <20261112185044.41571-1-mike.michalo@gmail.com>
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

1/8 verifies multichannel binding requests with the session signing key
    (MS-SMB2 3.3.5.2.4), as reported by Ian Bridges.
2/8 keeps the negotiated SMB 3.1.1 signing algorithm instead of always
    using AES-CMAC, and signs each key with its own algorithm.
3/8 verifies signed reauthentication requests and uses the channel key
    for session setup on a bound channel. A reauthentication with a
    forged signature used to get a response signed with the session key.
4/8 refuses a binding request on a connection that is already a channel
    of the session.
5/8 checks the MessageId and signature of a request before signing
    STATUS_NETWORK_SESSION_EXPIRED, also reported by Ian Bridges.
6/8 makes the signing decision in a compound follow each command's own
    header instead of the first command's.
7/8 consumes the MessageId of a request on an unknown, invalid or
    expired session, which the error path skipped.
8/8 charges and grants credits for such a request, which the error path
    also skipped.

Changes in v7, following Sashiko's review of v6:
- 3/8: do not apply the reauthentication checks to a guest or anonymous
  session. ksmbd derives the keys of such a session from an all-zero
  session key, so a signature proves nothing, and when the client had
  asked for signing, an unsigned reauthentication of such a session was
  refused with STATUS_ACCESS_DENIED, which it was not before the series.
  The binding branches leave these sessions out since v6.
- Commit messages only, following another review of v6: describe
  behaviour changes they left out. 1/8: with multichannel disabled, a
  binding request for a session of the connection itself is now refused
  with STATUS_REQUEST_NOT_ACCEPTED instead of being processed as a
  reauthentication. 6/8: the signing of the final response of an async
  command in a compound follows that command's header too, and in an
  encrypted message a later signed command is now verified as the first
  one already was. 7/8 and 8/8: the failed-session path also answers
  requests on a connection that is not in a good state, including one
  sent before NEGOTIATE, which now consumes its MessageId.
Not changed:
- 6/8: Sashiko repeated the note on a SESSION_SETUP chained after a
  command; see under v6 below.

Testing of v7, on the same kernel as v6 with v7 applied: an unsigned
reauthentication of a guest or an anonymous session, with the client
requiring signing, is accepted as without the series (v6:
STATUS_ACCESS_DENIED); the tests listed for v6 and v5 below pass as
before; smbtorture gives the same results as with v6; and 3/8 and the
whole series build with W=1.

v6: https://lore.kernel.org/linux-cifs/20261112154155.20255-1-mike.michalo@gmail.com/

Changes in v6, following Sashiko's review of v5:
- 1/8: read the session state once in the multichannel binding branch.
  The signature check sits between the checks for a session in setup
  and for an expired one, and a reauthentication on another channel
  could move the session from expired to in progress in between.
- 1/8: refuse a binding request for a guest or anonymous session before
  verifying its signature, with STATUS_NOT_SUPPORTED. ksmbd derives the
  signing key of such a session from an all-zero session key, so a
  request signed with it proved nothing, and the other binding branch
  signed its refusal with it.
- 3/8: an unsigned reauthentication of a session that requires signing
  was accepted if it arrived in an encrypted message and the session
  uses encryption. A related operation in an encrypted compound can name
  another session than the one whose key encrypted the message, so the
  session of the transform header must now be the one being
  reauthenticated.
- 3/8: take work->session_setup_binding from the request's
  SMB2_SESSION_REQ_FLAG_BINDING instead of conn->binding. conn->binding
  is not yet set when a binding request fails early, and stays set after
  a binding has completed on the connection. So the refusal of a binding
  request with multichannel disabled could be added to the session's
  preauth integrity hash, and a failed SESSION_SETUP chained after a
  command on a channel could be signed with the session key instead of
  the channel key.
- 8/8: when a CANCEL answered on the failed-session path ends a
  compound, its response now reports the credits granted to the earlier
  commands. v5 left them out.
- Based on ksmbd-for-next, to which v5 applied without changes.
Not changed:
- 6/8: Sashiko noted again that a SESSION_SETUP chained after a command
  is checked against that command's session. A binding request in a
  compound is already refused during message validation, since commit
  19f8fd6b5ced ("ksmbd: prevent session binding in compound requests").
  An unsigned SESSION_SETUP for a new session, chained after a signed
  command on a session that requires signing, was refused with
  STATUS_ACCESS_DENIED before the series as well. See also the note on
  6/8 under v5 below.

Testing of v6, on a KASAN/lockdep UML kernel based on next-20261105
with the ksmbd-for-next commits since then: a compound of an ECHO and a
CANCEL that names an unknown session now reports the ECHO's credits
(v5: none); the tests listed for v5 below pass as before; smbtorture
gives the same results as with v5; and each patch builds on its own with
W=1. The other changes in v6 have no test of their own.

v5: https://lore.kernel.org/linux-cifs/20261112044645.4074-1-mike.michalo@gmail.com/

Changes in v5, following Sashiko's and Ian Bridges' reviews of v4 and
another review of the series:
- 1/8: refuse a binding request for a session that is still being set
  up before verifying its signature, in both binding branches. Such a
  session has no signing key yet, and v4 verified the request against
  the all-zero key. It gets the STATUS_REQUEST_NOT_ACCEPTED of 3.3.5.5
  (3.3.5.2.4 would answer STATUS_NOT_SUPPORTED, as the key is NULL).
  SMB2_SESSION_VALID is now set with smp_store_release(), so a session
  seen as valid has its key.
- 1/8: with multichannel disabled, the refusal of a correctly signed
  binding request from an SMB 3.x connection to an SMB 2.x session was
  signed with the session's SMB 3.x signing key, which is all zeroes for
  such a session. It is now signed with smb2_set_sign_rsp().
- 1/8: drop the unused hdr argument of the session-setup helper, and
  shorten the commit message.
- 2/8: no code change. The commit message presented using the session
  key with the algorithm of the connection that set up the session as
  something MS-SMB2 requires. As Ian Bridges pointed out, the
  specification takes the algorithm from the connection; the patch
  follows what the Samba client and smbd do, and the message now says
  so.
- 3/8: remember in sess->sign_required that signing was required when
  the session was set up, since negotiating encryption clears
  sess->sign. v4 derived it from the connection, which missed a client
  that asks for signing only in SESSION_SETUP and a channel whose
  connection does not require signing.
- 3/8: apply the reauthentication checks to every session that has a
  user rather than only where the connection is a channel. SMB 2.x
  sessions have no channels, so the second leg of the reauthentication
  of an expired SMB 2.x session was not checked, and a forged one
  destroyed the session.
- 3/8: copy conn->binding into work->session_setup_binding before the
  error path clears it.
- 3/8: treat an encrypted request as authenticated only on a session
  that uses encryption.
- 4/8 is new: refuse a binding request on a connection that is already
  a channel of the session. Sashiko noted it on 3/6; it was already so
  before the series, so it is a patch of its own.
- 3/8 and 5/8: commit message corrections. 3/8 now lists what MS-SMB2
  says about the key of a reauthentication on a bound channel; see
  below.
- 8/8 is new. Sashiko noted on 4/6 that a request answered on the
  failed-session path is never charged its credits and gets none. That
  was already so before the series, so it is fixed in a patch of its
  own. It leaves out SMB2 CANCEL, which consumes no credit. The problem
  goes back to the first version of ksmbd's request loop, so its Fixes
  tag points there.
Not changed:
- 1/8: Sashiko suggested checking the ClientGUID, the session state and
  the user before the signature, in the order 3.3.5.5 lists them. The
  signature stays first: 3.3.5.2.4 verifies it while the request is
  received, before the command is processed, as 5/8 also assumes, and
  a request without the key then learns little about the session:
  whether it exists, is still being set up or (since v6) is a guest or
  anonymous session. The
  refusals of a binding request before it has been verified are
  unsigned, as they were before the series.
- 3/8: a reauthentication on a channel that was bound to the session is
  verified and answered with that channel's key, as the Samba client
  and smbd do. MS-SMB2 does not give one key for it: 3.3.5.2.4 has the
  server verify the request with Channel.SigningKey and 3.2.4.1.1 has
  the client sign it with Session.SigningKey; 3.3.4.1.1 has the server
  sign a SESSION_SETUP response with Session.SigningKey unless it is
  STATUS_SUCCESS, and 3.3.5.5.3 a final non-binding response too. On
  the session's first connection the two keys are the same. I have not
  tested this against Windows.
- 6/8: Sashiko noted that a signed SESSION_SETUP for another session,
  chained after a command, is now checked against the earlier
  command's session and refused. That is right for related operations
  (3.3.5.2.7.2), and ksmbd already refuses unrelated commands on
  different sessions in one compound, although 3.3.5.2.7.1 would handle
  them separately. The same check keeps the refusal of a forged chained
  SESSION_SETUP from being signed with the earlier session's key:
  leaving SESSION_SETUP out of it made the refusal signed. A test now
  covers this.

v4: https://lore.kernel.org/linux-cifs/20261110165834.28162-1-mike.michalo@gmail.com/

Changes in v4, following Namjae's review of v3 (numbered as in v4; v4's
4/6 to 6/6 are now 5/8 to 7/8):
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

Testing of v5, on a KASAN/lockdep UML kernel based on next-20261105.
New tests, each failing on v4 and passing on v5:
- a binding request for a session still in setup gets
  STATUS_REQUEST_NOT_ACCEPTED whether its signature is random or made
  with an all-zero key (v4 answered the two differently);
- a binding request with a bad signature gets STATUS_ACCESS_DENIED
  whatever its ClientGUID and for an expired session, while a correctly
  signed one gets STATUS_USER_SESSION_DELETED and
  STATUS_NETWORK_SESSION_EXPIRED there (this one passes on v4 too);
- the refusal of an SMB 3.1.1 bind to an SMB 2.1 session verifies with
  the session key (v4: with an all-zero key);
- during the reauthentication of an expired SMB 2.1 session, an unsigned
  or badly signed second leg is refused and the real one then succeeds
  (v4: the forged leg destroyed the session);
- a second binding request on a bound channel is refused (v4: answered
  with STATUS_MORE_PROCESSING_REQUIRED);
- with signing asked for only in SESSION_SETUP and encryption
  negotiated, an unsigned, unencrypted reauthentication is refused (v4:
  accepted), and an encrypted one is still accepted;
- 8/8: 40 requests on an unknown session right after NEGOTIATE, and 300
  on an expired session, are all answered and their responses grant
  credits (without 8/8: one and 127 answered, then the connection is
  dropped); a signed one still gets a response that verifies; and
  CANCELs naming an unknown session are granted no credits and leave
  their MessageId usable;
- a signed reauthentication of one session chained after a command on
  another session, or a forged one, is refused, and the refusal is
  signed with neither session's key.
The binding, expired-session, compound (including SESSION_SETUP inside a
compound), encrypted-reauthentication and sequence-number tests pass as
with v3 and v4, the Linux cifs client works signed and encrypted, and
each patch builds on its own with W=1.

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

Michail Andreas Michalopoulos (8):
  ksmbd: verify the signature of session binding requests
  ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
  ksmbd: use the channel signing key for session setup on a bound
    channel
  ksmbd: refuse a binding request on a connection that is already a
    channel
  ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED
  ksmbd: use the current command's header for signing in a compound
  ksmbd: consume the sequence number of a request on a failed session
  ksmbd: account for the credits of a request on a failed session

 fs/smb/server/auth.c              |  14 +-
 fs/smb/server/auth.h              |   4 +-
 fs/smb/server/mgmt/user_session.c |   1 +
 fs/smb/server/mgmt/user_session.h |   4 +
 fs/smb/server/server.c            | 124 ++++++++++++++-
 fs/smb/server/smb2ops.c           |   4 +-
 fs/smb/server/smb2pdu.c           | 251 +++++++++++++++++++++++++-----
 7 files changed, 349 insertions(+), 53 deletions(-)


base-commit: a4277e7b7682540e23334fc927f201e5bb7df5a3
-- 
2.43.0

