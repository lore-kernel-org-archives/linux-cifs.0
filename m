Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705720;
	b=3+mxBc/sABfpxaqBJJmuQ+6Cznx6rt/fKAKa5G5VaCK4BcIdpZBkEaGC4isCPn5Idj7w
	 tnaUIHQwuPpEibnT5beM2U1W8FcBSuF5zc7m/uqkaQsapjrDRGUilF7bP59hRaHUNLtIF
	 klvmDCyGSyRpY+2kRLLSwqUpSV15pVifRN53+FWxDQQnzMdDCCK5n6QxV0K870mpi0G13
	 5/sHpa7eUGsO5rkpw6xR9hb4uwVOirkgMTCWNwpJqCfwq2s+hLaHWIOgQKP4shmZafijJ
	 F8acyouQJGwhJXyu6pcXdggHDjDzwYjKwWae/B7OydR9pSD+x83psaVugTC8MSaiS6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705720;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F+pemLdMavBpUhvirOkrglF1IQk74cgV/zlxd3rVwe8=;
	b=aPVGqtWdSGB5mvs4sll4AT6BWtCQzAtwwkyBSs53JlMmCKQiIlTsuzQ2LYMak0k4UETI
	 KsPyU1ZHoSZb12+kKOsmHBoGJV7TXEtYf+CKg2pCeIEdd0dFMl3Pq1X26QlwP8bAofwZW
	 /ImgJpVeg8bVM7xt93a9WzJit+S9qttR9DFEBBLUWzjOBmoR0CQFL9hOE/cf6O48a1fRF
	 tX5x2UYQAgn8+NvHnF5DZlgS81/H06Tpif3eRULwUUwzHvDCMT4fbO0YZaKXid5hD4d5k
	 id0oxDJ7ue/8pdRRqGMW+i9kAtiQFckgXdJhuzElOmEu79xbGWP3irCv42vPBNG7sEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=Q4wlzjEN;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21316606A32E
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 15:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21316606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=Q4wlzjEN
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so68207315e9.3
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 07:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795705718; x=1796310518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F+pemLdMavBpUhvirOkrglF1IQk74cgV/zlxd3rVwe8=;
        b=Q4wlzjENfgH0gxnBNAbuJS4cpIr1E1yhtOBRq+J3E0Rgopbwa8Ux2vzxbv2XkraIcl
         KLSXNTN1ofu0vCaO0Cf3RhwQos/zk0/PN8IQ1/ZdSW13622RKSNmOG0DGVtQU3J5Nyqe
         4FSHd8SDfeGQEKMBFeMEdWfSPCA0lcDTNXEfSIDIRFIzVznLKuvgi+T7N4xyPqWygtYb
         a6e2AWbH9htzuiCH4dWWz3c6N9Dk8tdSyMGXl5tmKDkUlQiANHbDU6aMmJUQJA4MTJiX
         CF878i4rlivJGhN1q7WyuKOIBLNMnU4E13XhWFSZkXZCH9pY/j4b2n21gSUYeQDZHjay
         KeBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705718; x=1796310518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F+pemLdMavBpUhvirOkrglF1IQk74cgV/zlxd3rVwe8=;
        b=aWX7ySSK0q9jqb/2T92kmfJ3Tty1sqgLhoeGqa14gHcvjd3zqnvwXSO5CrtmFQs5ud
         LZ9HOk19Fr7pAueiuEun8YwxBP7nDnDQkTKe+llSClMencgmoYlcUwcOIjDxr5Gn6fH8
         fOV3zcMpnQpG43eOlVxJoToD2JWcTJ7vwjO7d510dDoSy8kEHKBxKjTYe5HxURCQrlrP
         IP5qsWs+9f3BvV9I7o4Nf0tcs58/Wel1Ztbdk8pZToB8WZqfgbD/MtIrCfb1c/8BeWOr
         q/MrjxxlGJuPimvV41DIvFwwyluCG60s70LaO2ltyK6h8XN++Z2tm7Sf6NRMh8EDXtw1
         lw2w==
X-Forwarded-Encrypted: i=1; AL+hErGvqI/6b/dtySstKy0iWNiEeVE1XlkOiO0lUk5aV/JOGezZsslbAlg1MZr5b6Vcl9qW0TE1pigOa01j@vger.kernel.org
X-Gm-Message-State: APuU4Z+f27U+y2mafBkvoJxSUy+CIe8C+/tAGTnj2jFwhi+JOEx0ds6q
	zFg/nxF8joN8Y88dDuJFkeN2Xs8T4WCD+wvSmsW6XW9yuPrfPTZmzxn1fPOzvEuicJOe
X-Gm-Gg: AZFdTZdUi/Hd+DSIEAzPTRIjA90rplRhwt5DrFfFQ3FBlwlsFvSLaR8MkWJNxXUpzyR
	baEJJphdTxMdxy1HjzDHA0ZUnIO2qO2OD+699fut8/oaKtGSu9xTes9n05kpxR1R2bZYX1WdfMO
	YlZI1L9VhH1EyYuU4lu//+tipUhbAWBD/I9jn/XfqsovXfFHD9HA7t5dgdDCvV8THbieuyL2yux
	AJgBbKhChML7SO46UHSiP6nC2AmCdASD+bhv7PEGLnc1ZADLfxqYrLMCb/Sn9Am5Uo32rQ/QhHl
	oGFe1mXYtNDZ+w4eIlRGUg/CV+XsYAkMTvMNzUHxjAk0JZzL+UNFZ4fjTJFNDN47dgWy1SD7PwA
	flCQ0Ihc3MvhmGvQTr6gZz+Sv3U42II0ADEZEOsMgnvQ4RSpYA/8+VeL2bfCUEA4XbNLR/J6I7T
	4I+UvoCdJWmvcKqTKJejBhFqh3OKXMwurcS6eg+RD3VoZvzRauKjzQHyvp9ynXslwPkf7dgoD4K
	o4gOT2SzNJ67gDrZvpuqGJ/w1UWHoLJkakdv43sRjOVy9nQN8m67NY/AsOhMoKWroizV9RD90cz
	tJi9mjKR417hRJ79LcQpv139YVjci+fo4jwtsv/awuE5qY+UpFEpOvcUWxNtJyv1Kf25
X-Received: by 2002:a05:600c:4e0e:b0:4a1:da58:1ee with SMTP id 5b1f17b1804b1-4bb88938dc9mr450553585e9.31.1795705718295;
        Thu, 26 Nov 2026 07:08:38 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm599850045e9.5.2026.11.26.07.08.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 07:08:37 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Ian Bridges <icb@fastmail.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	RootSys GmbH Research <research@rootsys.at>
Subject: [PATCH v2 0/4] ksmbd: enforce mandatory signing and encryption on requests
Date: Thu, 26 Nov 2026 16:08:32 +0100
Message-ID: <cover.1795701726.git.research@rootsys.at>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119103805.29514-1-research@rootsys.at>
References: <20261119103805.29514-1-research@rootsys.at>
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

Patch 1 gives each connection its own copy of its dialect's capability
table. Patch 2 makes the request gate honour sess->sign_required. Patch
3 refuses plaintext requests on sessions that were told to encrypt.
Patch 4 fails SESSION_SETUP with STATUS_ACCESS_DENIED, as MS-SMB2
3.3.5.5 requires, when encryption is mandatory and the connection
cannot encrypt (SMB 2.x, or SMB 3.1.1 without a common cipher).

The series is based on ksmbd-for-next 3c31349456c5, because patch 2
uses sess->sign_required from the session setup signing series queued
there. On mainline it applies on top of that series' first three
commits, 16ab0adace8f ("ksmbd: verify the signature of session binding
requests"), 42a1d80e64a3 ("ksmbd: sign with the negotiated SMB 3.1.1
signing algorithm") and ea472ddf7a9a ("ksmbd: use the channel signing
key for session setup on a bound channel"). Patch 1 has no
dependencies.

Changes in v2, following the review of v1:

- Order: the per-connection capability patch (v1 4/4) is now patch 1,
  since it depends on nothing. Its changelog now says that in the
  default "auto" mode the leaked capability gives a later SMB 3.0
  client that offered no encryption sess->enc and clears sess->sign,
  which is the gap patch 2 closes.

- Stable: patch 2 needs sess->sign_required, so its stable tags now
  name the three commits above as prerequisites, in the format of
  stable-kernel-rules.rst. The other patches keep a plain stable tag.

- v1 3/4 ("refuse tree connect without a cipher when encryption is
  mandatory") is replaced by patch 4, which follows MS-SMB2 3.3.5.5
  and fails the SESSION_SETUP itself, so a relayed login is stopped
  before authentication completes. On SMB 3.0 and 3.0.2,
  init_smb3_0_server() and init_smb3_02_server() set
  SMB2_GLOBAL_CAP_ENCRYPTION unconditionally under mandatory
  encryption, so the check does not trigger there; such sessions are
  told to encrypt, and patch 3 refuses their plaintext requests.

- A signed plaintext SESSION_SETUP reauthentication on a session that
  was told to encrypt is still accepted. In MS-SMB2, 3.3.5.2.9 applies
  where a command section calls for it: 3.3.5.6 (LOGOFF) to 3.3.5.21
  (SET_INFO) locate or verify the session "as specified in section
  3.3.5.2.9". 3.3.5.5 looks the session up itself and does not refer to
  3.3.5.2.9; its only encryption requirement is the dialect and
  capability check at its start, and neither 3.3.5.5.2
  (reauthentication) nor 3.3.5.5.3 asks whether the request was
  encrypted. Signature verification (3.3.5.2.4) does apply, and ksmbd
  does it.

- CANCEL (thanks, Ian): patch 3 drops a plaintext SMB2 CANCEL on a
  session that must encrypt without a response, where v1 answered it
  with STATUS_ACCESS_DENIED:
  MS-SMB2 3.3.5.16 never answers a CANCEL and verifies the session as
  in 3.3.5.2.9 only for a signed one. The signing check in patch 2 still
  answers an unsigned CANCEL on a session that requires signing with
  STATUS_ACCESS_DENIED, as ksmbd already does when sess->sign is set:
  3.3.5.16 exempts a CANCEL only from 3.3.5.2.3, and 3.3.5.2.4 fails an
  unsigned request on a session that requires signing.

- Sashiko's review of v1 2/4 (now patch 3) raised four points. We
  checked each one on a KASAN kernel:

  - Reauthentication: SESSION_SETUP is outside the new check on
    purpose; smb2_sess_setup() checks the session it reauthenticates.
    It refuses an unsigned plaintext reauthentication of a user session
    that must encrypt with STATUS_ACCESS_DENIED at the first leg, and
    the session stays usable. smb2_sess_needs_protection() is true for
    every such session, since sess->enc_required implies sess->enc and
    the global flag. A guest session is not checked there, so an
    injected reauthentication can expire it, with or without this
    series; its keys are derived from an all-zero session key, so an
    attacker on the path could send the same request encrypted. No
    change.

  - Compounds: reproduced. After a plaintext SESSION_SETUP that
    completes a session, a chained ECHO with SessionId 0 and a chained
    SESSION_SETUP for a new session got STATUS_ACCESS_DENIED. The check
    now leaves SESSION_SETUP to smb2_sess_setup() and skips an ECHO
    with SessionId 0 (3.3.5.17); a related ECHO, which uses the new
    session, is still refused.

  - Order: reproduced for the tree connect. A plaintext request got
    STATUS_NETWORK_NAME_DELETED for an invalid TreeId and
    STATUS_ACCESS_DENIED for a valid one. The check now runs where the
    session is verified, before the tree connect is looked up, so both
    get STATUS_ACCESS_DENIED. A session whose Kerberos ticket has
    expired still answers STATUS_NETWORK_SESSION_EXPIRED first, since
    3.3.5.2.9 checks Session.State before EncryptData.

  - Reauthentication response: reproduced, the response to an
    encrypted NTLM reauthentication had SessionFlags 0. Patch 3 now
    sets SMB2_SESSION_FLAG_ENCRYPT_DATA there, as 3.3.5.5.3 requires.
    The Linux client is not affected either way: it sends a non-binding
    SESSION_SETUP only with SessionId 0, so after a reconnect it sets up
    a new session, and a vers=3.1.1 mount without "seal" under mandatory
    encryption kept working across a server restart, with and without
    the series.

- Tested-by added to patches 1 and 2, whose code is unchanged from v1.
  Patch 3 has changed (CANCEL and the points above) and patch 4 is new
  code; they carry none.

- The patches carry an in-body From: research@rootsys.at, so the author
  matches Signed-off-by:. The mail itself goes out through the
  team@rootsys.at mailbox, which research@rootsys.at is an alias of.

v1: https://lore.kernel.org/linux-cifs/20261119103805.29514-1-research@rootsys.at/

Testing: W=1 builds of fs/smb/server after each patch, with
CONFIG_SMB_SERVER=y (and CONFIG_SMB_SERVER_KERBEROS5=y) and =m, give no
warnings. checkpatch --strict reports no errors or warnings, only
CamelCase checks for the MS-SMB2 field names SessionId and
SessionFlags. On KASAN kernels built from
ksmbd-for-next 3c31349456c5 and from mainline 8dac6df92a2e (with the
three commits above), each with this series:

- every unsigned or plaintext request that gets through on the
  unpatched trees is refused with STATUS_ACCESS_DENIED: TREE_CONNECT
  after an NTLM login over SMB 3.1.1 with a cipher offered (mandatory
  signing, and mandatory encryption), and over SMB 3.0 after another
  client offered SMB2_GLOBAL_CAP_ENCRYPTION;
- under mandatory encryption, SMB 2.1 and SMB 3.1.1 clients that offer
  no cipher fail the first SESSION_SETUP with STATUS_ACCESS_DENIED, and
  an SMB 3.0 client without SMB2_GLOBAL_CAP_ENCRYPTION is told to
  encrypt and its plaintext TREE_CONNECT is refused;
- the next NEGOTIATE no longer advertises a capability another client
  offered;
- an unsigned plaintext CANCEL for a request that is not pending gets
  no response on a session that must encrypt, as without the series; on
  a session that requires signing it gets STATUS_ACCESS_DENIED, as it
  did without the series when the client offered no cipher;
- on a session that must encrypt, a plaintext request is refused with
  STATUS_ACCESS_DENIED whether its TreeId is valid or not, an unsigned
  plaintext reauthentication is refused and the session stays usable,
  and the response to an encrypted reauthentication carries
  SMB2_SESSION_FLAG_ENCRYPT_DATA;
- in a plaintext compound, after the SESSION_SETUP that completes a
  session, an ECHO with SessionId 0 and a SESSION_SETUP for a new
  session are processed as without the series, and a related ECHO is
  refused;
- the in-kernel cifs client mounts, writes and reads under mandatory
  signing with vers=2.1, 3.0, 3.0.2 and 3.1.1 using sign, and with
  vers=3.0, 3.0.2 and 3.1.1 using seal; under mandatory encryption with
  vers=3.0, 3.0.2 and 3.1.1, sign or seal. vers=2.1 under mandatory
  encryption fails at SESSION_SETUP with STATUS_ACCESS_DENIED, as
  intended. A vers=3.1.1 mount without "seal" under mandatory
  encryption keeps working across a server restart.

No KASAN, UBSAN or WARN reports. Not tested: Kerberos sessions
(krb5_authenticate() gets the same change as ntlm_authenticate() in
patch 3), SMB Direct, multichannel binding, and a signed plaintext
CANCEL on a session that must encrypt.

We found this with AI-assisted code review and testing; the reproducer
and the fix were tested by us on current mainline.

RootSys GmbH Research (4):
  ksmbd: keep negotiated capabilities per connection
  ksmbd: require signing on sessions that negotiated encryption
  ksmbd: reject plaintext requests on sessions that must be encrypted
  ksmbd: refuse session setup without encryption when it is mandatory

 fs/smb/server/connection.h        |  2 ++
 fs/smb/server/mgmt/user_session.h |  2 ++
 fs/smb/server/server.c            | 41 ++++++++++++++++++++++++++++---
 fs/smb/server/smb2ops.c           | 19 +++++++++++---
 fs/smb/server/smb2pdu.c           | 25 +++++++++++++++++--
 5 files changed, 80 insertions(+), 9 deletions(-)


base-commit: 3c31349456c5b71edc837270cf9075b28dc59ee3
-- 
2.43.0

