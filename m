Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5D442A99
	for <linux-cifs@vger.kernel.org>; Thu,  2 Oct 2025 17:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759425644; cv=none; b=tHjgTrH2Av1/270khxdDY1sT5wqRn37az4b1k493XDybwwW6YbscB/S6tK6/xK40TuFW/dv2xAaMQybnZtiWoodLRNJWRqoPEfUbUgBq/2hfykXBPatnSXaX2dpKRSmysKa55pZButCXmtpr+p58xpFf5FnCUMWoka3sUIZL04s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759425644; c=relaxed/simple;
	bh=dk1NQw2VERkubWjw6V1HZnO05TMxyayltyTZKNX/AzM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=pAKNvjXMwQAXnJzxB+NvINJ8zkUiXElZngPYJtmtLy6idACJxOt9Ekf7ogADr0oBJAZBeiUaDVsILT3fqdsIetFOtQ/yYp5DbiDPowiSTNat9stSem9HemUrzoBxVu1UWJnATpuo/k6giGpa4N52V8/LF3VIqwisTFWVeK+vWHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SDd0KsRZ; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SDd0KsRZ"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-78f75b0a058so13559596d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Oct 2025 10:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759425641; x=1760030441; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SAtu6/ctQVIzK5vPxGcQc/s7kZti3z+hmRQu3O4UCtY=;
        b=SDd0KsRZoZR19Le3LD7ViwLmE3XXbpJz1XgB21Ik0R8sSqMXl1ktKhOTFSp4F1/dzk
         ZSBOZve0k0xjS7YC1GD0fAAZUD4DJq1wILwbzyHHwUuYTLmfCCIAZX8WAMtaYlozcSnR
         zwciR8/hecUtLNllbc2iCT/UQkWT2Y3tRjWVq6JBhfMkDmbBUBxjYZRcYmvdcTHbzag9
         1uAf+szf0dpOQ6fRJoFRymPq2a/02+gl15PhuiVPBIUCliUqPSoo75e10zjHNQgLadlI
         9avXNaHT1gPNXiyOeGMUkiTo/+9Kc0QwFLQlz+3ASwJX1kRqujdCzhRmw/P+Hg36fMZb
         1V2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759425641; x=1760030441;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SAtu6/ctQVIzK5vPxGcQc/s7kZti3z+hmRQu3O4UCtY=;
        b=ko4ybcq8ih83T20lCP1m6jujCIbqcQu4xkIMlh2FQ46GIujpV2caO7tQW51ABJ0qxS
         //epeGR5nu6Zl9mqlLWU1u1punoXJOga5M/qk2Hbft7cvNqqgY2HfjMT2JXDbOIbYTVp
         1GJ4d57MdwKuOF24PGhVmTEj2MzFMk/FQcQD/udeQ3elIDgocMuTujd9aP4GhibrkuS+
         Ep5aq90qRVxuEIfkKzdz94NUFARBuyto+zAe/xgrz43iy8jLBKjH4CH2x5CKAXrpGj0y
         3wIpw68T7UByBnFo59GC2FWX7ZO2eVa8YhTg+1RPcZszfeRAdsKgOjeJFnUcLqiV9XXb
         iyCw==
X-Forwarded-Encrypted: i=1; AJvYcCWd1wQK/+XcZNDhjxk4mUrDJGTneDqqkX6G+j31A9nW942jWDEaU//6B+BKuv3ofyXLLJzVcB4AbA4t@vger.kernel.org
X-Gm-Message-State: AOJu0YzTZ4B22yydGeLgW+z0mJdcyxzFh+cq0Sp98raBDZQDD3ncIOu2
	xE1KH0kL1JzKytU6vJVqKv8OgFWcitkHlXiDQJ+qPyumpryusSDLkNjD6L6OqHbIS3v0l2saLH3
	aD0qjsP+KA13AJ9P/+hcLWs6J8WZiFI0=
X-Gm-Gg: ASbGncvSbijUYvL6XHmCJ0ZvCe8fGNFwJSrZmwOx26peKZih8o4QK8IUlPPceqWmuHl
	4UM9DAD1ZpwCNTGHNZ52LpBs98YG+hnffkpa/ydDtpBYEdkeyp1s0lDrRw25DriZK/PrTis5evT
	bXG0EBskUoWj+WJll5qfPKwuK4vdbpPzNBqSepCMM1WhdSQLMThcqJMXgyhf7MEwHn3CQ4S9UbN
	28PBCXlpaw7CVtcQqyOpYFp2eE/ucuqZVZvdNb7LFt3AiBF69ptu1pmLFpZrbL1ftZ2ubMS1eCo
	fw8hshUihL1l/IXpu8qCLackzmJKs1yTEuxvnM/RCCt+TQHbss6o9s/JOs8yjRCOSv8ljFNsZFQ
	lCGPE7NpP3w==
X-Google-Smtp-Source: AGHT+IGUWZdm9D8d2hudPZnCFmi7yXKHA1CZ7wWJsKITJ/TXMFKIEesjighOYb/MimXVQCCocKK7yApm2jAOKPOJVLY=
X-Received: by 2002:a05:6214:248a:b0:786:d65c:1c3e with SMTP id
 6a1803df08f44-879dc7c5521mr1370446d6.30.1759425640960; Thu, 02 Oct 2025
 10:20:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 2 Oct 2025 12:20:28 -0500
X-Gm-Features: AS18NWB6qxj8HQdJyEZA2jhJoBIVUzGipHmStWEneP1xhBuJnOXCHOyGk4pTsjY
Message-ID: <CAH2r5mv8=AvJBTE7cxz=BQsjrR8ZOVS_ZkvVSrLzJqrLiomX8g@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
a9401710a5f5681abd2a6f21f9e76bc9f2e81891:

  Merge tag 'v6.18-rc-part1-smb3-common' of git://git.samba.org/ksmbd
(2025-09-29 14:57:08 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.18rc1-part1-ksmbd-server-fixes

for you to fetch changes up to e28c5bc45640bc851e8f7f0b8d5431fdaa420c8e:

  ksmbd: increase session and share hash table bits (2025-09-30 21:37:55 -0500)

----------------------------------------------------------------
Nine ksmbd server fixes
- Fix potential UAFs and corruptions in rpc open and close
- Fix copy_file_range when ranges overlap
- Improve session, share, connection lookup performance
- Fix potential hash collisions in share and session lists
- Debugging improvement - making per-connection threads easier to identify
- Improve socket creation
- Fix return code mapping for posix query fs info
- Two patches add support for limiting the maximum number of
connections per IP address, extending the existing connection limiting
mechanism to enforce per-IP connection limits alongside the global
connection limit
----------------------------------------------------------------
Matvey Kovalev (1):
      ksmbd: fix error code overwriting in smb2_get_info_filesystem()

Namjae Jeon (7):
      ksmbd: make ksmbd thread names distinct by client IP
      ksmbd: use sock_create_kern interface to create kernel socket
      ksmbd: copy overlapped range within the same file
      ksmbd: add max ip connections parameter
      ksmbd: add an error print when maximum IP connections limit is reached
      ksmbd: replace connection list with hash table
      ksmbd: increase session and share hash table bits

Yunseong Kim (1):
      ksmbd: Fix race condition in RPC handle list access

 fs/smb/server/connection.c        | 23 +++++----
 fs/smb/server/connection.h        |  6 ++-
 fs/smb/server/ksmbd_netlink.h     |  5 +-
 fs/smb/server/mgmt/share_config.c |  2 +-
 fs/smb/server/mgmt/user_session.c | 28 +++++++----
 fs/smb/server/server.h            |  1 +
 fs/smb/server/smb2pdu.c           |  7 +--
 fs/smb/server/transport_ipc.c     |  3 ++
 fs/smb/server/transport_rdma.c    |  5 ++
 fs/smb/server/transport_tcp.c     | 98 ++++++++++++++++++++++-----------------
 fs/smb/server/vfs.c               | 16 ++++++-
 11 files changed, 119 insertions(+), 75 deletions(-)

-- 
Thanks,

Steve
