Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793991993;
	b=wypAEEbbuezf5f79kok2ZA2Ig4z+VNd0cX2btfgRPkF/vvF0quimZQGP51dIj1XPPMiZ
	 Y9Jl0APMENt+IF5oiEpPZO+1G07ZbQWU1rYqjSvYqxG3bChWW8vpZuS69vtWthzJbZ4bu
	 2NFlq0xPEOTkk7alPxtKP5Pb9gHT42wfVqPPu83i+yavNdPBabqpRQefIGSTS/tcG3xdB
	 VB1HXl/4SzBbItKFXj43wsF2d2ABsmXnMzEKR4mWnMkQzdyNymybYGDrt0921wTQRsh6Q
	 PDO+M1sN/M+hzOm39wfc0PW+XI24TWClXwfau1T/VR1upyx9Vw/WlZ9pbY5lqmKW9pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991993;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bSA9v8W3T7lo5Myhbr3wCFSrLSSjl8OXlhbS86xJyGM=;
	b=OWtdNplnd9r3UOHCirElQqpQcFYpOxAtkYIyriPdC5LA+V+oQuPUtWSAaLncry0dQRaw
	 PoDOn4bGBfK/2rU2L5HOXEpRFhBek3biC7oiSbGq/xPf+2eu/vEktUJV13EODadZTcOTK
	 odaKhJzcXBCfOE1qCNgPfpx+bxCLoC8FdptnMWnlLRhfJVYIPuqizuSfsuov35W3S5QXw
	 P41A62OYr+mwETCNR+FPuY46ilHJigrUNb5BTWzW80vS/e/gdmW5sZZWPV2x9j/QjwJ6a
	 9n2V14He8GdbH827gwDmheAfTdvnaZC8cpbhi9Y1MX/Cs8g8bi+M030rP4nmIBmoanw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yBfT0MUb;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A83606A329
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 19:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9A83606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yBfT0MUb
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so1133697f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 11:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793991991; x=1794596791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bSA9v8W3T7lo5Myhbr3wCFSrLSSjl8OXlhbS86xJyGM=;
        b=yBfT0MUb8h87VbQCan7nkpZMlMecNwwSNQcSV5CcfwLQY7KQcYy0j28hZ3gKVcVYto
         7OYDt7qTQbxxLTSgGRZTCGfLaCP8C/suZo7bvIp4K5ugbZcPqZ8ZGLaKett5LXtweDBr
         ShR0WZV8d3OjUiAdHZGXaoUHnfrpn8LVLTTRIkSM+6UHkTlZLfouEPUDe8Sdlp0JhPMs
         f/X/NHOzLVKfncmthvQu8bn3SMw9tJXR8aG8NyrsQfnw8xCJd7G/cOXvey+2OR36N4HH
         fHi2QbAdAKqwUQVoGmWJ8+bZSGtCxWbmq7UYzd+t0ikThdYK3AayPHCSfDARV0rmNk0F
         Wf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793991991; x=1794596791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bSA9v8W3T7lo5Myhbr3wCFSrLSSjl8OXlhbS86xJyGM=;
        b=2CQ66q4qggh3ay5cEux9ukZ+nGdEfRE2PLx+71IdemDshrwxz2mPrHSDDmO9TfH3uL
         SdWzKisbWxJO8XKfVBmq79XXPfFLo5zWj9xMi0z9z+SgjKUNskjjsXtcJQNc2oeugSB7
         2LmV/gmHZN0bZIuEJbGb4NgQhx31VrPHYHI/PAhucydE7HxEBY0iRYRFvTK/5XRCcUo9
         sq5JfA83PIlG6fYwKudGs+uIoWaEZ8fnfu14A+N3QPaNfCDTDQP7KjD1NFaLKAJdKhhJ
         5oLVI4WDbd+ZBaXRU11v6l67ywaaQeID37HPEXGVJgdhWuVOwM5Zy/RXXrXSdSJmp0uX
         4jiw==
X-Forwarded-Encrypted: i=1; AL+hErF97lc4jlxAq7bUfrCBpwzwvU7ORC4H1STsidy3KlWS7l9nilwbc3A0jTqw8HY/+aODgMLWp5lyM6hE@vger.kernel.org
X-Gm-Message-State: APuU4Z8mcRcSTqUMWQuovJ9QQKqWx7EbMhgFbiCifPNBtb+ML3qYHFJG
	9e9Sb9/rtwby0N4fDQKD/1Jo6+oscOUQ8R2wBjcRRnrR+fg6QYWw8S7k
X-Gm-Gg: AYBFou1DhPVEH5FC/oixjAUFv1EtzSwMVeAhYOJEH/qdY3gBl3B/2abuVnUOJVshjZQ
	Cb9z/hsBq4A46M5bSsV78BAxz0MAM8kjxqxxqq2B36zZrddd0rmcrLwkXv6D0xv/qbRUdXxhGxl
	Bcw7X+xv5FG52WyngJ/qaxkJWkUuu1+p8tFEsQvtIOTVv6I20H/vLvNyh8JQWYeik/rM3QoGrnV
	rGMnJXXw0e+WqbfN8A5QDGflZCa1z9J9/FNwQEX98FUxscJF3TURKlqaDCdGavUeqtyzGaq9ces
	deYorX0fD43A502h7X0ATFRQSVdg+Gx6wGCPS/UQvf6WxS3RaXZUHEAx3CGSxb1lSPSuKJ45hxH
	M1XzpwKglUpAvTt1g2JsoyE/VdVDFsF62iS+5NAwwqRULGKMbRCJaHl2jqz9XY3sqgH5TsiZiUN
	LuEV6JGEEsXaQUsOu+NKc5RU69X0/BN0rDi/H64tKaLx5Z0D28PyPXm79zGEHtQkzGPSVQAH3OG
	k0s58WY3vCsf0TJSC0VMGaAyXPYHGlxyZVVMC48kj4TEHf1lOZwXxrkwfTXKduiAUiKTtez135Y
	Drs1U8LXfLXAEA8CiEO8bIAxMUek5Dvs/4ieZ3QcTAzV9Cc4CWEnFVxttJaLRmaPFcCZ7JzfuwY
	UyXIUcT8mMaLPNELth/lvEjm/q8tcI7LF6vLl9w==
X-Received: by 2002:a05:6000:2089:b0:491:1e11:9ffe with SMTP id ffacd0b85a97d-49273f50710mr7197658f8f.2.1793991991245;
        Fri, 06 Nov 2026 11:06:31 -0800 (PST)
Received: from localhost.localdomain ([74.244.226.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4930a5a91dbsm3960533f8f.35.2026.11.06.11.06.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 11:06:30 -0800 (PST)
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
Subject: [PATCH v2 0/4] ksmbd: verify session setup requests before signing with their key
Date: Fri,  6 Nov 2026 20:06:18 +0100
Message-ID: <20261106190622.20990-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103171742.18816-1-icb@fastmail.org>
References: <20261103171742.18816-1-icb@fastmail.org>
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
the key obtain signatures made with it. This series fixes those cases and
makes ksmbd sign with the SMB 3.1.1 signing algorithm it negotiated.

1/4 verifies multichannel binding requests with the session signing key
    (MS-SMB2 3.3.5.2.4), as reported by Ian Bridges.
2/4 keeps the negotiated SMB 3.1.1 signing algorithm instead of always
    using AES-CMAC, and signs each key with its own algorithm.
3/4 verifies signed reauthentication requests and uses the channel key
    for session setup on a bound channel. A reauthentication with a
    forged signature used to get a response signed with the session key.
4/4 checks the MessageId and signature of a request before signing
    STATUS_NETWORK_SESSION_EXPIRED, also reported by Ian Bridges.

Changes since v1:
- 1/4 is new: verify the signature of session binding requests, as
  reported by Ian Bridges.
- 2/4 (v1 1/2): reset the negotiated signing state on every NEGOTIATE;
  Cc stable, since 3/4 depends on it.
- 3/4 and 4/4 are new.
- The AES-GMAC signing patch (v1 2/2) is dropped from this series and
  will be posted separately.

Testing, on a KASAN/lockdep UML kernel with ksmbd-tools: forged and
replayed binding, reauthentication and expired-session requests, also
inside compounds, get unsigned refusals with AES-CMAC and HMAC-SHA256;
randomized requests against these paths and concurrent bind/reauth/
logoff stress found no signed response to an unverified request and no
KASAN or lockdep report; the Linux cifs client works with SMB 2.1 to
3.1.1, signed and encrypted; smbtorture's session, signing, I/O,
compound, lock, oplock, lease, notify and ioctl suites give the same
results as without the series. Ian Bridges also tested an earlier
revision with his own probes and smbtorture. Not tested: Windows
clients, and Kerberos expiry with a real KDC (it was emulated with a
test-only change).

An AI assistant was used to draft the patches and as an independent
reviewer.

Michail Andreas Michalopoulos (4):
  ksmbd: verify the signature of session binding requests
  ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
  ksmbd: use the channel signing key for session setup on a bound
    channel
  ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED

 fs/smb/server/auth.c              |  14 +++-
 fs/smb/server/auth.h              |   4 +-
 fs/smb/server/mgmt/user_session.c |   1 +
 fs/smb/server/mgmt/user_session.h |   2 +
 fs/smb/server/server.c            |  39 +++++++++-
 fs/smb/server/smb2ops.c           |   4 +-
 fs/smb/server/smb2pdu.c           | 114 +++++++++++++++++++++++++-----
 7 files changed, 154 insertions(+), 24 deletions(-)


base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
-- 
2.43.0

