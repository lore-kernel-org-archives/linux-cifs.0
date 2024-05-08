Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BAB1A2C05;
	Wed,  8 May 2024 15:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715181563; cv=none; b=W5bI8eL0uF7RPcDxfu1FEIkHFXxAgP3LJ7nm4QM2+kvXTrjtbq/WqxK0Wn50wbfO4j/P4newS8H6wLn7JmgqS+PMNt22XAmS8na5IF7swCbbai6YvcH/5K/CrdE9N6I5zwTNBzXv3TVQ7RDm7g9kve/njBsWzAnwUA6scWTJogE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715181563; c=relaxed/simple;
	bh=RDgZFIRWFAsYzacA2jE3u0koUD8JEkZ3FTaoS1xbQzo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rd75BNrYv1s/s7tu0wM44eiqjxkLaLb7CyJF3EpOvvTqmEYZ4Is4iG2FRKOAQqFHk7dxgQ880K1XyNaRin3cyl5c2tSareSK0iBFwcjnCti39M0YpKkTTwJxXxnuQlVhqWvu3b7nlEABJ2/ZQeSkKVDesHJW1dJFhRnUaz3au20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PnsAL4Hu; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PnsAL4Hu"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2e428242a38so27479231fa.2;
        Wed, 08 May 2024 08:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715181560; x=1715786360; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VcQPlzrDQgRkPj7R1y1WUS01giEukkyq4WKKdpmpB7Q=;
        b=PnsAL4HuiG2+lPmhUSJXcjqATUl3th8v25SaPxjqdz+UoCeO583Vczkor9luOkoQ3B
         2MUPDDng8RWeU4inCFLW0n5RRUFw5BCrvMtxPneXUMMoPfZEVl4nrakmHKmaTYKKxT+X
         bWRt9E0tKxtVUJhcpmwqkNR3zz5dKGZoGRhxT5dSQCXP2ttcKLYuDXKiKjN6nh8HFDue
         qKN1WVxq926cJLu/+itlTs6lxEMtvvGGPM3poKJRh/Hp70ofqKWQjVkpwJeNjQIQuagm
         DwJaDocscOX9+NwY+HQFBI+OItJiGUGdUTvvK+cqM7Nze70ksbEMOY0gmCLHTuHEUpVA
         CUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715181560; x=1715786360;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VcQPlzrDQgRkPj7R1y1WUS01giEukkyq4WKKdpmpB7Q=;
        b=oxXTXg4U+z38/WM7tqBcxiwtQqCw/Pmb3nwoJawwn+EP4/TkbdtyQ2AZkMFlaA5iui
         lVrNbS36NOqUqAJnLygbAjG7gIZu3XZYvxskyYNGGZK2Sbo4qTLgFtpA90l64D8iXwFW
         p7zdT6+DhEWWTzw2BKCIzEGY6Rv9bjKd//ehG6zFSmDzCTjpX1m0ZM7zxBIJGO2TNjmh
         w/xpYtw8e+CwSCLnap91cIj4bpstSMKAf/kpnrKyzE+T/ry99K35Gi+9JOsybJfTtsW/
         FsyXt+fkOL7ZQxEHh+O0+DXVcIMVUgGdz4QZxZzkcxbHwDfh6NjgyRlx8lL2/0vBB0MR
         S6QA==
X-Forwarded-Encrypted: i=1; AJvYcCUoONbdxSCdg59hFLljFTZTk8wzxDWVKU0/2w8HxdE3tssWJE4BRC+TIW/pswlrOdJLRwejWMY9OI7cbFhXpsQBzzDAmX5vUO0D8A==
X-Gm-Message-State: AOJu0YwBvFDJ+j+GhXQFE0pacWGfYBi6tTOUkUTo6J8/n3k0jjLGVvQb
	XPaJlkxRZCvU0jdn0KgHtqrI7NA0Zk9rueY2yA8HBLIIPTW5Heov8NgvLmZ6zxg3sB+H5a2NROh
	AMVcA0/mQ23eEokVkuDyJDu7WGGnl/5VH
X-Google-Smtp-Source: AGHT+IHSZ0xp3QCT9NGnc4t9ud5lmOaRsX5swKxd7bOZQ2fPeSzch2OQJOXeKr2uQ5fp+3wOuWZsUwcyZnEKpIpLDOM=
X-Received: by 2002:a05:6512:3101:b0:51f:4d57:6812 with SMTP id
 2adb3069b0e04-5217c567135mr2201292e87.19.1715181559991; Wed, 08 May 2024
 08:19:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 May 2024 10:19:07 -0500
Message-ID: <CAH2r5mtdSGPTs-FEWJFzn_uED8Ni0LLSCXbrRs2s8nrxZt+3Ow@mail.gmail.com>
Subject: [GIT PULL] ksmbd fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e67572cd2204894179d89bd7b984072f19313b03:

  Linux 6.9-rc6 (2024-04-28 13:47:24 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.9-rc7-ksmbd-fixes

for you to fetch changes up to 691aae4f36f9825df6781da4399a1e718951085a:

  ksmbd: do not grant v2 lease if parent lease key and epoch are not
set (2024-05-04 23:53:36 -0500)

----------------------------------------------------------------
Five ksmbd server fixes, all also for stable
- Three fixes related to SMB3 leases (fixes two xfstests, and a locking issue)
- Unitialized variable fix
- Socket creation fix when bindv6only is set
----------------------------------------------------------------
Namjae Jeon (5):
      ksmbd: fix uninitialized symbol 'share' in smb2_tree_connect()
      ksmbd: off ipv6only for both ipv4/ipv6 binding
      ksmbd: avoid to send duplicate lease break notifications
      ksmbd: use rwsem instead of rwlock for lease break
      ksmbd: do not grant v2 lease if parent lease key and epoch are not set

 fs/smb/server/oplock.c        | 65 +++++++++++++++++++++++--------------------
 fs/smb/server/smb2pdu.c       |  8 +++---
 fs/smb/server/smb_common.c    |  4 +--
 fs/smb/server/transport_tcp.c |  4 +++
 fs/smb/server/vfs_cache.c     | 28 +++++++++----------
 fs/smb/server/vfs_cache.h     |  2 +-
 6 files changed, 60 insertions(+), 51 deletions(-)

-- 
Thanks,

Steve
