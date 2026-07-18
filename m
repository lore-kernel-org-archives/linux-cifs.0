Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD0725DB12
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 02:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784342781; cv=pass; b=S3FN7kcsb2ROsG29lSG0zYogmCAflbIcFhytimSiTmPpXlOqb2H9A91mOTDHzcEutfNVloHkN7skE3rwo1EQAgNSFrJVaZJKWjoNcC5QfOvDYQ8vvrIyhmKFF2RKjUfRwPDeYCwYN5e0rolUEOPxUghVSyNJPyqc+7bww78y3OA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784342781; c=relaxed/simple;
	bh=FtA5Zwx1NN9yeaKIyTRkswnCrsrAOG5nnGxttcsnefg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=flJnzwOt0pSw7w4xOJI7B0vEbCRS5NTtypRaulKi4OO7mwb8Z4a39LC4+urFq0MkyF4OCIOGHKKIjNxFerSzVFp9cHSe8Kh7SnBErQvU5je2X4TQpBxqzn5JZrapz4wgGS4/o1ljYN93L945q+QQVFWoYvVLirM2UFv4WLbJitc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ez9fkbfG; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ez9fkbfG"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so34068196d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 19:46:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784342778; cv=none;
        d=google.com; s=arc-20260327;
        b=iZMGyHzM7cnYePHIUiQCLCbBsBgEmxxktjws3IHyC2++SGXWazrtib2xD1U61erTYR
         A4oKAukLfmcXTXz7OkZrj+P1eWNOqRy6Vrry5dZA0+bR33ZbzX9611gGfR44i86NW5sK
         xCCQ1gR3CrIMovv5lkAlnYqUjUQy/Dy1vFd4WASTuk9yDQg16c+/qyAdbvTyJ8eK01LC
         hWpgfIJefB6h+sIXLOpfM7UmhwvSzV3aWN4ksCir19KmrObBh5PzBN/NhfufvmzOSEQL
         QV+Wl7oUWonGOpj8YybalfVYaME4Ry4V+GLedEIawyn+Y98k6YCtUCZj3n9ajy9nHB2L
         McKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=QJ6GePZG9ZsFhMWRph0e4jJsGfCxJYgzIetdhlBQq9U=;
        fh=dyHrhriXj+vXm+DRx9CYRCE6m2yo+zCadSHvxYALRwg=;
        b=MAdVXorMTt4PaT++j5mTTBtv9rfYXe30Wobi7i3CR2OXE9sdl8AO3RujRNky5sVU77
         8P3Sqp155osBfccGJ8NMaFprYnsMfCuQJd8kkBD3IHjHBdlxNz+upkHMlsawA8RJ8BTx
         74MAEdD9EjVhhiuXuY0GyxoYYL7O1wzSl3swwZzpePLPVpEwiHD55nZyNSfdy3gKTU4K
         kG/koL4JlnRfQZpPQsO/RTq1vIxuGpxo0J1rFZfILYjlCsahJFiuTJ66rXpMlls0x9B5
         nEJZj219TIdHeZtFlWlIOMSoKCEko5Qeqs/CsUcws8wrHksE+c3gm8LfuMPWAkBsSyMG
         tmrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784342778; x=1784947578; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QJ6GePZG9ZsFhMWRph0e4jJsGfCxJYgzIetdhlBQq9U=;
        b=ez9fkbfG+fMV2+qMRExsrwmIjhpR5dQLAx8jML8eq3MUj7UmW9rHEpBsbqEoIUReRy
         R6ksSqm5aXowSCBQb9Jtf+UAYwVqG5WxlSHQt0vvTa27Es8jMHHG9LcuqPKGb9ckMOBe
         KkxluyfJ6ru4PsxEQ8Qsg9WljhuzZ906u4uq7R/5pibICWADpPekVRfyZHzGSRYz+QTd
         laTFOGcHnSOC2nPNFv7XpJ5vlsE3AX4Hi59RVk/wqFf8iFWS59JcqQVPZFprjKcT+8gD
         74k4oRDjIbC2jCSWO7lGjLo6GiQqmxfAQ9p+JNZAkfjRo5Io87Z7Z3nFZ7d2Hp6f2w/K
         ztbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784342778; x=1784947578;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QJ6GePZG9ZsFhMWRph0e4jJsGfCxJYgzIetdhlBQq9U=;
        b=cmkxpxWhVFaUOQT+lSCv/GlRf8EqICVr7QudfNJHksbGwXZ4ftqj1aWZ9yI1zP1l3c
         g/DTi+wBFDVd3nI2IXT3UO2TUDMcAus4p6u6/crodAnybCXmDtEtgHPNM2nTOEEWK8bE
         Oj2Hj7UmWZvXZrJCWblCEaC3ZlyR2l8rSO+zN557WfL8KlUes5iqL9C4V4GzF06cY2l6
         2WXNZOBmMNTYufk8+djpD26u2yKYH0UoXFUNKGf3+POa1HvecjzV1Ce/UmWKC9ltdgNG
         U8bTd9aJxlYsOURswqKbQTUsCXE/CFe26r0Cn17ygLQU37vUd9AevYYnA8pKC+3bFONi
         tTOw==
X-Forwarded-Encrypted: i=1; AHgh+RpnrbOjkw1bmM+HQTmf1o+gG1wcIwy2un0eFQ0/VndFhdMyfwYkf6Oa1e2PhBugsc1Yde3HeCozpQ/A@vger.kernel.org
X-Gm-Message-State: AOJu0YyjZLcSi+wawknmfKfjlpU0KL1bhvIdMtdMXvKeZ+/q0vpKI38V
	aVEcs9eC7HEs1f+QVXIY82wEHDxJFTKf4aSI82OTaetMIInGoXyiejimCi4AqdYZgNWa2j1MriO
	FNeGbAxmGLMXuHBMhkmzH/ChejY9ms92kqhPmbMA=
X-Gm-Gg: AfdE7clDm1Zm2OwPTtWQmjJ87EwblTD9lRU/HJB96qttYfJhQZ+ji6gce8S7/BDhSPX
	tvhPDbwWyB4JZSAheTzCDr7sW7TaMyAippbHMX02yct04+oQ+W7LxySuwmOxg4VBxA+G9clZL9o
	O4tyElahG2yzdfGzpmAiRs2hh/iegXGLZLKfDrSSvYXnkWwhftMIPiTfNSDj2iNmCsa1aLSj/8I
	w4ikAyatQhIJhL12uaNO4QIPuNV7Ju2bsvVGXqAPmwSKOcShNQHI+0YvfgWfX9PwDwMhaYtxj8z
	+j0wMVvpDPOqsUYVJSSWKGg9NGVM3W5gYebm90w8VrkPmLlUugLO5fxCD2JLTPofU7iPipzpRw8
	hf3zi6hKJjrqT9x7Zmbh91c7Qm5x1LbhSdC8hKJgqXD3HrMe/MtsGQlk1JtvPxv6B4JssXm8PpY
	rg
X-Received: by 2002:a05:6214:404:b0:8ef:76c:cb18 with SMTP id
 6a1803df08f44-907783159f0mr62664096d6.11.1784342778448; Fri, 17 Jul 2026
 19:46:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 17 Jul 2026 21:46:06 -0500
X-Gm-Features: AUfX_mzSaTDUqGddzcqsCfavDVxryLxVQOBkcJUo3HmGdwU0o0oyUHnNTBZuSM8
Message-ID: <CAH2r5mv5dhHd5Z4YXTM4rPNTV4hD5dApeqsrurc-VErRoi5URw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
a13c140cc289c0b7b3770bce5b3ad42ab35074aa:

  Linux 7.2-rc3 (2026-07-12 14:16:39 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.2-rc3-smb3-server-fixes

for you to fetch changes up to 15b38176fd1530372905c602fde51fe89ec8c877:

  ksmbd: validate compound request size before reading StructureSize2
(2026-07-16 10:18:25 -0500)

----------------------------------------------------------------
This contains a set of eight ksmbd server fixes, mostly addressing malformed
SMB request handling and connection/session lifetime issues, including two
information-disclosure or memory-safety bugs in the SMB2 request/response
paths.

- validate FILE_ALLOCATION_INFORMATION before block rounding to prevent a
  client-controlled overflow from truncating a file.
- pin connections while asynchronous oplock and lease-break notifications
  are pending.
- initialize compound SMB2 READ alignment padding, preventing disclosure of
  uninitialized heap bytes.
- release the allocated alternate-stream xattr name after rename.
- size multichannel binding session-key buffers for the largest permitted
  key, avoiding a stack buffer overflow.
- remove a disconnecting connection's channels from every session, including
  channels whose binding state has since changed.
- serialize binding preauthentication-session lookup and update against its
  teardown.
- check that every compound request element contains StructureSize2 before
  reading it.
----------------------------------------------------------------
Gil Portnoy (5):
      ksmbd: zero the smb2_read alignment tail to avoid an infoleak
      ksmbd: fix memory leak of xattr_stream_name in smb2_rename()
      ksmbd: fix stack buffer overflow in multichannel session-key copy
      ksmbd: remove stale channels from all sessions on teardown
      ksmbd: lock the binding preauth session in smb3_preauth_hash_rsp

Ibrahim Hashimov (1):
      ksmbd: fix integer overflow in set_file_allocation_info()

Qihang (1):
      ksmbd: pin conn during async oplock break notification

Xiang Mei (Microsoft) (1):
      ksmbd: validate compound request size before reading StructureSize2

 fs/smb/server/mgmt/user_session.c | 25 +++++++++-----------
 fs/smb/server/mgmt/user_session.h |  2 +-
 fs/smb/server/oplock.c            |  6 +++--
 fs/smb/server/smb2misc.c          |  5 ++++
 fs/smb/server/smb2pdu.c           | 50 +++++++++++++++++++++++++++------------
 5 files changed, 56 insertions(+), 32 deletions(-)

-- 
Thanks,

Steve
