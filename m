Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281CF3A8F7;
	Tue, 17 Sep 2024 06:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726554225; cv=none; b=EUH10F7aXrHa9XHff9HHG52diLChmqqfzh0ir+Zh9RVXd8ziC0N0cWMrs29lPmxta3ShrMfQVlaq76ATDgNYLyKX52c8FunEEIzqcro/eeApzIpbqHHAIHFr2C6IamGwYtOyEMBDa7I8DSCQBdREE653SpjpT2nPDO5L67ebghE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726554225; c=relaxed/simple;
	bh=0/Z8IpGMnPVF85y9VmcieKJEoBMNXOSKXTdO2gOQbWI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=oiV9G/HzPtowq350Yji4NPd1mxXrY4q8jrf9Vni5w8lUw4TWIYxxtyYloBeKUrday7l3b71TYU7HyPj6jUjkLGkdgCp5Mn9JgbzOtmhwWKlkfn9DUjaPBTFv4WAmNU7DDXdhVMIxSEiPNaklRZeHsyHiYSJ40z2aTB60425qTQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XX1z+fyp; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XX1z+fyp"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-536562739baso4254404e87.1;
        Mon, 16 Sep 2024 23:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726554222; x=1727159022; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kdXezKVi8wVMNco9JlH4OMJNOoS1t1UfiPgsoBgiquM=;
        b=XX1z+fypdTi9qyI65bChRTD18uQ5OprwmFK4pez0jgcabAi+lpPvk1ZbIaNcD09ozL
         8+DHDO/h/pLkm80QwFxBcneChmUcvKlrlqNbFyOhAn0y1xzKQodRf27pYR0oRsODf7E2
         dpJI7VWwhixz80Pm1lqTlMN3Vxvy94pyv1otXrumRaCUmSju4nDPI2CGtG9ixdtk2Oqf
         Mkwd+mnI0BR8cIsu3Ec+EtQvRwEWnY+ZuCJse47PUP6Fa44VU4Td4z80O71QcEuB2Ovy
         Riuy8BqX9TnVnJx5xOeFRObcVVBXIe/N9HNxV/Ayl3iLdklufznX+uD1tw0SZaThWea9
         WjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726554222; x=1727159022;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kdXezKVi8wVMNco9JlH4OMJNOoS1t1UfiPgsoBgiquM=;
        b=aKjAi6gh+vpTnigFKbnHewSoB0Ql+UTGwxvLUFJ+RO0mUi1iKoFQ/Uw//xCPtnJ/EZ
         pmc1kF3MVYdrECl0d/MDf4YbIdQJWmf+4jy21pMy4ESfJ46CHhiMgbt7ovj+zi5f9ckw
         Zu0kdbCmV4CRyX1M2IL/wwVSqoJHo6MRDB+vHi4lup3nnMIZE028fDA2Dx1uuJnJRvgN
         u2T7DE1Qv7UFcR87/4kxDKgS9MawY8RsY4yi9OMBXzXRsfsCftEHVlpTtoUFIs2SQ9H2
         MZ0HmmcvPGZ4BgJcdBxlx1YioswCU7QTNZCCaVG/oAB4WHhHYJ0st01LKx5ODEqk28Mb
         3CLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8u2m6YuhRAMT6aLp7WMaJv5sgn97vVOQCFtR9rA/pofH9azS5VsBYfBx9i1vBLdAcUO9bH87lnUuz@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1kgwpvigxGDYtC0MSzRKr4UV2UWVSDxvPvsbOAhRinofSZfzE
	RbfeTPwpcmLNhUPhcV6cjdgdy9uUImsim1ezidK6xb6HMzLbz6mjv6T6ZkpwKs1+SvNPkJnJjaZ
	kdAHFoAv68OToBjsG7OOmkPYD7FP5W5m5lYs=
X-Google-Smtp-Source: AGHT+IH+zFP6kEMEy+Z0PJGVt/6mZsuIrGzUHMtHAdEUdh0LHFi/cQ89fHLaonUoJJlPgAh6ER58I+hPJFk4FyC7HFE=
X-Received: by 2002:a05:6512:1325:b0:535:6aa9:9868 with SMTP id
 2adb3069b0e04-53678fc23dcmr9602468e87.19.1726554221811; Mon, 16 Sep 2024
 23:23:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Sep 2024 01:23:30 -0500
Message-ID: <CAH2r5mtbB4soi6ZYq_ajFy_RaHRm=DdUTfNNbnj0UtfXF5dmEw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
da3ea35007d0af457a0afc87e84fddaebc4e0b63:

  Linux 6.11-rc7 (2024-09-08 14:50:28 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.12-rc-ksmbd-server-fixes-part1

for you to fetch changes up to c5a709f08d40b1a082e44ffcde1aea4d2822ddd5:

  ksmbd: handle caseless file creation (2024-09-14 00:03:15 -0500)

----------------------------------------------------------------
Four ksmbd server fixes, three for stable
- Fix the issue where the directory can't be deleted if the share is
on a file system that does not provide dot and dotdot entries.
- Fix file creation failure if the parent name of pathname is case sensitive.
- Fix write failure with FILE_APPEND_DATA flags.
- Add reference count to connection struct to protect UAF of oplocks
on multichannel.
----------------------------------------------------------------
Hobin Woo (1):
      ksmbd: make __dir_empty() compatible with POSIX

Namjae Jeon (3):
      ksmbd: allow write with FILE_APPEND_DATA
      ksmbd: add refcnt to ksmbd_conn struct
      ksmbd: handle caseless file creation

 fs/smb/server/connection.c |  4 +++-
 fs/smb/server/connection.h |  1 +
 fs/smb/server/oplock.c     | 55
++++++++++++++++---------------------------------------
 fs/smb/server/vfs.c        | 19 ++++++++-----------
 fs/smb/server/vfs_cache.c  |  3 +++
 5 files changed, 31 insertions(+), 51 deletions(-)

-- 
Thanks,

Steve
