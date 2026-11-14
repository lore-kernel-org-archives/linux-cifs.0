Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794634169;
	b=IeWPgGUiuzbJJkAPoY05zOi8zrRFuz6S/G/HYcKCcYl31cdkAHgqPMED1pLin6zN2U/J
	 hOah8I8dGfZsOL4AdhR3So4zFWGzWA1bMZdF89Rb4puUuLlP+SOfl0kkJ0CxYqe603v+j
	 H9DYbeJwBXb3Hcse8FKXW9TZE5W658+GSkrHwJkZkHS0apmi9bX729nuVZobSGEhXGeZW
	 +Xacr0G8Sv3F5DohNXnWovoT3AtJl0mUlWjKlSXvldihoL3M93dCFAKc4S40Z8rylN06i
	 tLMelbpx0rAKMJ7Hrlf44vEJMInn5li4Jg4bSfQtMD2euNYhL10cNjshtnz5aJ9Fn7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794634169;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=uM796BQB6ycmrFIWzMEeX2i4plvDgCgY8fOJiwq52UE=;
	b=nc6D1u/9Sdof4EKno+53g/KsTzaZzBYVSta9+ESqinyH/8zC3yFi3juTeP1wEkBd7h63
	 wXxncvQJkvCb3m/VzCU6X4ovGFw4WOY1LH6EexSaU1oskKu/kbGjLtSYZNJ2zwqm/CMaC
	 oqBpDQdLAMCy2Z2qZInc6hVph5Xc5ZNZoIAjvoTtAT6mUqIqQKFlN4hNHnhl3teC0Ziiz
	 knlpQKvdW1/bbmiSOuaF2mhmH8jBGe45uNBprroobKrGhkDHT5Ybw2hyWNwbIIjImzZ7p
	 dZ/C96UtpRjnKUA3gARLdJda6+8GhKhCg/rtjRoLCsbFeOklqIh+I4NaY0KHQk4kv6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kenupOW4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257BC606A329
	for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 05:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kenupOW4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFDA1F000C6
	for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 05:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794634168;
	bh=uM796BQB6ycmrFIWzMEeX2i4plvDgCgY8fOJiwq52UE=;
	h=From:Date:Subject:To:Cc;
	b=kenupOW4lfaOdYPTzgGL118op9FCVAxavx52Flyr7l1ppaX3LqqNQFnmGnojjBA5z
	 whSP+2ox3yAapZRamWQ8VanG+/XTgvnj88iIqvw4yEsbD1w12u9rVjx+Hknd4DLQMD
	 p+WrMzBifrxB1c/elVR2vRp2Zc5ofyeEecULlUr1i7dcfSUxkEnNxSh7keIBhNhJWi
	 myTNG9rzuygSVg7qwE1nBMXFXa6Fo94hAIiNYqldPfxcy/Wi++6Dm3GomfpnRiKeJ0
	 8SpCnYMkVsU02+oIRnMEVaFojb0J/PWl3ZA99WXoNIQoeV4W9F0yzVa3ZNzcWXdauB
	 csQKB5Kr2Jdsw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c50bf13091eso4800566b.2
        for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 21:29:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFEx/O0nRTK99WZXPiV2DfORi8k8dMl0WLzn/NPXmcqzEFvWwH7Vm3zqH8D96QxV1mKiP0wmIvPQtHP@vger.kernel.org
X-Gm-Message-State: APuU4Z9nRcSAp0pcr5RQSfEjFPvJyAcGiIiSXR8F9Q4e8pk5JHgyojWe
	kC5cFMVWz0O73W8pc4fia4N0E/UhNpFtT0j2yy/n2eyWM3cX2Ao2egGUNFVsYTHVnlOitPe1CV5
	+EbMuTMlU8yHy7viwh6+tE+ddR85Yon4=
X-Received: by 2002:a17:906:12d7:b0:c50:ac4e:3770 with SMTP id
 a640c23a62f3a-c50ac4e5041mr133330466b.34.1794634166974; Fri, 13 Nov 2026
 21:29:26 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 14 Nov 2026 14:29:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8oLzyQkLpZ9AFxVc=GvdN1GTYN3yGOcV-n0U7uPGrPQQ@mail.gmail.com>
X-Gm-Features: AclHuK8tCaw3EDMrmZHa0qZVz4dqKOIao8TDfIpYGT4hD_V7e3XYydoY-qkkWoY
Message-ID: <CAKYAXd8oLzyQkLpZ9AFxVc=GvdN1GTYN3yGOcV-n0U7uPGrPQQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes for 7.4-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is ksmbd server fixes pull request for v7.4-rc3. I add a description o=
f
this pull request below. Please pull ksmbd with following ones.

Thanks!

The following changes since commit fa4ad798f6f681031775266044ba1b0cf3c670bd=
:

  Merge tag 'for-7.4-rc1-tag' of
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux (2026-11-07
13:52:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git
tags/ksmbd-for-7.4-rc3

for you to fetch changes up to b0af9a3e6b1534d353ca6ac23caaf46127f62e4a:

  ksmbd: keep group denials when a POSIX ACL entry decides access
(2026-11-10 23:56:21 +0900)

----------------------------------------------------------------
- Evaluate explicit-access requests in DACL order with exact SID matching,
  and prevent guest and anonymous sessions from matching Authenticated
  Users.

- Apply Unix group and OWNER RIGHTS ACEs, and keep their denials
  when POSIX ACL fallback determines access.

- Allow the parent directory=E2=80=99s DACL to grant explicitly requested D=
ELETE
  and FILE_READ_ATTRIBUTES through FILE_DELETE_CHILD and FILE_LIST_DIRECTOR=
Y.

- Exclude metadata-only file and stream opens from sharing conflicts and
  stream delete-sharing checks, while accounting for writes implied by
  overwrites and named-stream creation.

- Return STATUS_ACCESS_DENIED for reads on files lacking FMODE_READ,
  preventing warnings in __kernel_read() and potential panics.

- Pin parent dentries during SMB2 CREATE permission, status, and ACL
  inheritance operations to prevent use-after-free races with concurrent
  rename and removal.

- Keep expired sessions bound to their original user during NTLM
  reauthentication, preventing identity changes and a user-object leak.

----------------------------------------------------------------
Ian Bridges (6):
      ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow
      ksmbd: skip metadata-only opens in sharing checks
      ksmbd: skip metadata-only stream opens in the delete check
      ksmbd: evaluate the DACL in order for explicit access requests
      ksmbd: let the parent's DACL grant DELETE and FILE_READ_ATTRIBUTES
      ksmbd: keep group denials when a POSIX ACL entry decides access

Jiwoo Kim (1):
      ksmbd: pin parent dentries in SMB2 CREATE ACL path

Michail Andreas Michalopoulos (1):
      ksmbd: refuse reauthentication of an expired session as another user

Wahid Khan (1):
      ksmbd: refuse to read a handle that is not open for reading

 fs/smb/server/mgmt/user_config.h   |   5 +
 fs/smb/server/smb2pdu.c            |  91 +++++++++---
 fs/smb/server/smb_common.c         |  34 ++++-
 fs/smb/server/smb_common.h         |   5 +
 fs/smb/server/smbacl.c             | 291 ++++++++++++++++++++++++++++++---=
----
 fs/smb/server/smbacl.h             |   2 +-
 fs/smb/server/tests/smbacl_kunit.c |   4 +-
 fs/smb/server/vfs.c                |   4 +
 fs/smb/server/vfs_cache.c          |   7 +-
 fs/smb/server/vfs_cache.h          |   2 +
 10 files changed, 368 insertions(+), 77 deletions(-)
