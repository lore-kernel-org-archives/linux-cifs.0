Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E329283C89
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 02:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773195585; cv=pass; b=lGcXKiBMaq8ENMiLWBQEhTkT/Ugj+Jyk5jVV+x6oKbDOb3knGJBR0a+u2g1+VcLR5B1p5wuLkDy1clauwGGDUeuLThNvJKXLfWpxHaXXQ07SrjlJIkgCVPNZ9zDAZotLDRjIDgHze3UfLRIJcAonAfeIOddbvbNiqKe6ztwWoWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773195585; c=relaxed/simple;
	bh=mPoFdD9NrZARI1n7NjZFdnqbmreJZZqySF5lcFRSjcY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XnIvq9KAriMnjpqlj+F8ukF/hTdjflLQzygkmCieR/9x2FaYoyGwFG6y+MII3BUlDsGCDfGWXounibrsCZHqVaEMsTqAy4BezrEwZZHF03xiR+1BGnCLyv/KTVoSEp4KyspD1S2nosF4DO6Ez82yFLBHSaviHhBa+OF8vvJz81M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZlZ3AXrI; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZlZ3AXrI"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-89a61cb72b4so11958336d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 19:19:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773195582; cv=none;
        d=google.com; s=arc-20240605;
        b=AcAVzPRTKIkxMnl78bGHgKC3A7vCrWIJ+hR71BshtPpCKK+b3Vo9PNnIqNj1MZ7Bs9
         9sv5kPGJRsZUcgqpse1fSYpT+IMAv0jIof/Z5jv1YTHV7qLiNQA5e0d9NtLYa0rpdVcW
         uhW73cK8w+WWWgqIeNFLg/eCqxA8ZOp6HlbXyDn0smc4OM7pSCDNz1/RUILQ06muJBgD
         vjfmhIPpcvxAoRb1G/ninh9vmXdfGVQ0WkopVjDytRZgQOaA+XSrQ8Uyi0I/xtMZIaBu
         juTo2w1HrHhQrMxnxW36lhG8EU+Og/X24mNMDSKMuoB0Fwe4dhk3yNcLZMPBTNmP5wue
         VCUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=DCipTKYdHy6MyRMFx8gE7GksOqTaVJv/F7ceGuWVFdg=;
        fh=J0rK1hVQjOgBrMV+ZN6wOc5RJfvXD6FEbgHIZxoj/CQ=;
        b=SvMfGDsgH1jLWOJLHwcHJFtITPhmYEzGXcajMPXcEqwtf3ynzGzw1ovU54XrCKkB9f
         XAF37kBa4Crf9pMDLfHJgNSN9eZ5peD21CgNQGVKkJkOu8QhCm5GvdTBKHHlwOtc2BXm
         d0ZWVtnUQa8wLsCu2ax5rVkEiC4sH2eqoOSsN0uFBZ5iEDP9Ddk5aD1QRA2dRcDRBmbo
         smml0rdUdgIrsYe0g5Mj+ZyvHralX2CT+NjJyoJkyIJ764iSyHqMQvoUJR9XONUkrqJD
         0CLnRpnNc14KqWDPYNp9dClFMeHTR7gJE2T36Rw15oftwqWvU15xj9a/O2VQzcPS8qn7
         WgEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773195582; x=1773800382; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DCipTKYdHy6MyRMFx8gE7GksOqTaVJv/F7ceGuWVFdg=;
        b=ZlZ3AXrIjb+TM4tFXQtGc717BpRAIX4Y0q9DolZRh4wB30cAbRS/ohQ/YsGF+FKSKH
         pLw/eChkKaEvVBb5D1/dqDlccPwznjf6b918lGYqhbUZIWGbimqz9Y2GRObkrKxdm+hF
         n0A9iwGu/IM7lBcJvxZ7iJ/et48c0lyPpGIF6TACRXDmjHG/bPtQEny2UMmkQ+CZQSAI
         sci2M+0Z7BuixTLZXCNWAmHlaYSsSsTMKZCwrQNExBGIvOiI3pA4f3wzFp2I8qPjrLfC
         RmpUu7uVsqYBXUhWctw1gD450bc8Xy+A96AqNW1RwkkKsfqEerdF+f4mNfuzAJMhcd1K
         TYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773195582; x=1773800382;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCipTKYdHy6MyRMFx8gE7GksOqTaVJv/F7ceGuWVFdg=;
        b=bDiaZmHEmFRbxp1MsOwy6vhq2yXJvDQ28NXDtn0jEhzDtZLge9hgf4m2ai8hlD3tQg
         x3HK4w07h4cidT8aTiodr65a0XhPBqNpG95Frqmd1go+qnhD4N9h0AVXA08mZ1mznp/Z
         KSkvrKS7U/fF2AxByLAck7Ku1SnLQsLRZxpbn3PanEWTnye2poMAH8JjBc9j60tdTVAt
         EeLbNViS+KK3WgAM4QF1OlKiXeietoGWx6d/GsUywkjQI/EIwIZMKlQlTJsPqWZQEIwY
         CrCcPkscCYQaQTjAtMoTWWDZ+OL+F+JURU9IU+6K0lbV1bG/MG+rBA32Eg0ny6VvHVdA
         pusw==
X-Forwarded-Encrypted: i=1; AJvYcCXLbBNYlp0M5/YU51BJH3ehlLqpSR+l7f4rEHu6yRb7CgxuZIVfyKvgpqjzZJYIXk9ZsuE5b0tBA8fX@vger.kernel.org
X-Gm-Message-State: AOJu0YyPSUXedUGBihcmwIX7Nnb6fVu8ZCf5C+OICJfWkcEPEEZSMF+C
	DDHbF2AuR6GQ1a2EocZNYdGbmQpjrJqB/UL1BgAyMe/vvJS5zgbcpAZuvYeQhf/IuXVZDSvRKi7
	YQgTv/82JRNU5iT0iTVWy5cUcxlJcGthg6LqX
X-Gm-Gg: ATEYQzzIHE8w/qxkv6H8n9u6N7TWuMtS7x9s0tFMrzoMkeLDWgYOG/6rqsgZbDGeaM6
	F/x0fGLyl+s68OTiB9kzCOp0RcOlQRD2K04T01ovzkHnYcBQhY0+nl3klMcCcLx93G86JN1xyUg
	2zr4cAUYxWH9/r5rniUAX2PmYn5TPhtxwysfxZM6IYOOtRQQeWR4LnWij9ybExAkF9LSVXUXTcQ
	GX12noktK+hYJHCwi5Egl9kZ5AJiVQn3apMExhwmN+tLJQjgcbTBrASAibLF3DXIMCAiPSioDqZ
	xCh636+XGqOGLI0hWLy5PPjmPfziYlXOPcsQqnbE9h4/eEWO6UL4F9gqb19lFUiGPDrL4jQ3lve
	q5NIgdG0/2XA1xIbUsLXnAOQhJKVjFlFljn6UG7jIj8qX7bqhdi9Q8Cld9AvEAQ==
X-Received: by 2002:a05:6214:ca7:b0:899:ea7c:4d97 with SMTP id
 6a1803df08f44-89a66a24687mr11131106d6.9.1773195582213; Tue, 10 Mar 2026
 19:19:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 10 Mar 2026 21:19:31 -0500
X-Gm-Features: AaiRm51hYHL0T5tBTLVLhjScZwzoNj4vuz3ZPjCKJ6Qo7hO8BUMQk8sv2Wq2YlM
Message-ID: <CAH2r5mu0GQ2mg3z3495AjZVcyYr-LFu-BOOWbDT5Oeg10u07BQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
1f318b96cc84d7c2ab792fcc0bfd42a7ca890681:

  Linux 7.0-rc3 (2026-03-08 16:56:54 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.0-rc3-ksmbd-server-fixes

for you to fetch changes up to 441336115df26b966575de56daf7107ed474faed:

  ksmbd: Don't log keys in SMB3 signing and encryption key generation
(2026-03-08 21:28:39 -0500)

----------------------------------------------------------------
Six server fixes
- Fix four potential use after free errors
- Fix refcount leak in smb2 open error path
- Prevent allowing logging signing or encryption keys
----------------------------------------------------------------
Ali Khaledi (1):
      ksmbd: fix use-after-free in proc_show_files due to early rcu_read_unlock

Guenter Roeck (1):
      smb/server: Fix another refcount leak in smb2_open()

Marios Makassikis (1):
      smb: server: fix use-after-free in smb2_open()

Namjae Jeon (2):
      ksmbd: fix use-after-free by using call_rcu() for oplock_info
      ksmbd: fix use-after-free in smb_lazy_parent_lease_break_close()

Thorsten Blum (1):
      ksmbd: Don't log keys in SMB3 signing and encryption key generation

 fs/smb/server/auth.c      | 22 ++-----------------
 fs/smb/server/oplock.c    | 35 ++++++++++++++++++++++---------
 fs/smb/server/oplock.h    |  5 +++--
 fs/smb/server/smb2pdu.c   |  8 +++----
 fs/smb/server/vfs_cache.c | 10 ++++-----
 5 files changed, 39 insertions(+), 41 deletions(-)

-- 
Thanks,

Steve
