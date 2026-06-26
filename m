Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF5D3F825A
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 14:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782483512; cv=pass; b=qyavw8zgljz7wxvtIovi+RKjovxEbAHt/cIpKjKNqB28ILcP3YEUfBZBI+eC9GY/Hcj93iItCEfxx5TFLEJw9RKTL+x5DQ3RHg2tVzbERum8vichCSNd5g/dqgZFZtJaQtn7RHlt3mHyH/lS35LmlzFWwUkYKS4/TyEcOuKPQT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782483512; c=relaxed/simple;
	bh=K5nHqCCdb25EO5yVV2MufDJeYXQjXQQW85da/2EVvK0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=T2m5Cg0BI05IE7Rtpu1LDMEmYOntRdNm0FiKbTgPsqU2KIREQbNwOjuXwF4nN6ZQ8tKNQdZ3adnJKTvYkdXjeCBFGmj3Ddyq02KjrAnGm7FV11kRAhNztkRDeQ+l4PR4ZCMo0By7Of46oh4Mt8gmY3Xhak1wNXY5uB1jeRMQaAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ViFKKjPr; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ViFKKjPr"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8de2adc59d8so7473446d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 07:18:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782483509; cv=none;
        d=google.com; s=arc-20260327;
        b=fuV9S1NUNaYMyQ2GRt4Y0aSjRYKFFEd0c5Q8mvgUnCE14lb2bnSc72xnfYIz2/WYI8
         sbZgJ6cpM1jm8331+WhW2B7FAOfKc/fQxt5tfEqxi/yl61HgbLGAXrwOh6VKEIn941Sb
         qbDI+KInuOX0Y9gaLEw92NYWDVPxtwXh3ccn1jsC23Ek1Ubos78u0bPQaYPcYnXxlK9R
         Vp+07t6wCTerHPD72so7Q6UbY2m8pgvqxFtzXFhcjJV9SUgvhTL9YJEwrIvBSlIxJMs3
         qFa5fut6ZtXOPuUG89TPv6YkA0bYBj7cqPmNhGrDXzC2Hbik1MNXX+Eh9fW37Z5TyGVU
         TDsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Oowkz/hD1OhmfJZd8T4dNIlTNgvQOjvzadljQUgr2tA=;
        fh=WlzPkBfdhYCsngrgTa7ULTXqgjCyxNkkH2JuHAVyoMs=;
        b=ZqDz+zD/Oq7qUBhypTT8ojKFDWigL5kHBPZGSdlZI88nzd+x/h10eI7WtfgElcuEuT
         8dWCJGsXoN0kEtypF1Men/6loRpV8jQPszQoc0EMwSk/OCfB3i85WAutpVG7IR4+7bua
         iLtjd1e0TrbjfwgP0RC0prLBXmjgKhKJ9DwTVKcFnPMjGsz7efelQRa2HfR2PGErH/XY
         9OL665ffU0K8zVcCerbwxO9H7Pl8hBBboM8k3GtMpi3B2fKtH5Gg3NupxnV+z2fz7wkn
         xd5xu5xrg1H93lLY22xPVUtuYQxqoaC+9LJkJSSIDmq2LlalJph4vsOBwZAgXYUuw0Nv
         o4Lw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782483509; x=1783088309; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Oowkz/hD1OhmfJZd8T4dNIlTNgvQOjvzadljQUgr2tA=;
        b=ViFKKjPr9i7kwx6uYEX4hrq1/k5kVXD3S+OXYnpVUs84Skwm9hXCMUuO2/xzy3+3Oc
         Ih6gpEMon7Dou/Q53euVcjfVKTy3xTSPXnBhD4PyVRvM49+koUJnQO6z5lTbEhDHt76F
         YETi4jX8/BAN8hz/6nzrFtXEk9Q0MGiQEWTdVwmxDQmdgu2yHVzbguZT70dq2sKvkJrT
         jZaNHxqpNAb/P0PA0GXk4+PWC7SO4VhAlwrIOIQYlQ1KiUR8XBw0dpyPFyYVBid0oMTj
         Iu9nMzy7j1GiM2GMGTtGwwHp0GA3BjS8AuCwdAspwTiyXxyvoDTa25JQJYiZrQkk+Dxb
         V9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782483509; x=1783088309;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oowkz/hD1OhmfJZd8T4dNIlTNgvQOjvzadljQUgr2tA=;
        b=Pk2UDV3DlVHeI5qTW4xSeSkDsOcsm2oYUcSq6XzdcPtvXW790b0i366SHjIHQrHb1J
         XXLXJCTcd3ol1oTWrhjdvVQjhk6koVupnHw46u0Cg7MfrqNXHciF9lxTxC29DveJYwSu
         SmAE5a8bJkodhAxob1FJzeB2wdXpTa1/GzXEaw+xP0JBQKY47ZOZps+5Y5imua6eWFhQ
         ygRtWBIwH/E5Wvy6TwdWp1A6z3Jd5vL7FO8OKae1Mt+wV6Mj7z0BZVO62DFcQo2ybh7Z
         b0KJXDWf8/wIrvY8mEHVQgo0yTHBgDpWyJA7TBScYkz7pGEr33lVyJ/LHd6fHf+cltuv
         Y+xQ==
X-Forwarded-Encrypted: i=1; AHgh+RrqE5rrXlwcr9wN26AUHZzFf35BAFaQOktNzqGzgx9Gz5INXgZhfZlxD5p/7LtNvqtK5M+sgIurv+fJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc+IBp13Lx4Jcy0vpi7MMnrO1kSC+9tqd8bCHna+ZLuyZshSiY
	neD2uN0VAtmllD+ouFaf6Wo4U2huhlkccK1RXwNgpigEF8c8JuJAlY2ioP7pIUyCrgr+hpgr7JT
	GRB6cRGmsGsceXJvq+RcD0ee/+MfshtM=
X-Gm-Gg: AfdE7cmENAHEw860ntDhFg/xiO/QVrzECHevXUDAc9cz+O1VFU5m8r3JV0x4NMSapxa
	PXhSA3adrxFmK64lGcpqpJhzrEHu1+oXqUbWGX3rzBMetE4IzPa0UWrWkV+zt8tlUMU82Slr1DK
	nyKSh7ZrxtKexN7G2+7BdMuMrZl/D+NoS5yCwiVPdC99LngLNM86LfoHtVL51I2Vw12PzsnYMJf
	YeCzkP5Vlah06WVQiDiKu30qyyY6YyEubMvwhCq4UgmDsWnzK08f6/dvS80nLe8OaqbQlyJDPt+
	Wm6mabHIzEYlL0VaMxOTUJ+SPVS0rG95IWZY5PXawUgXmGuChPnx5tX0oZGBNfOHOmkvWaCsJYJ
	kOm7C/E5+vY3jVqfJpE9gDI2alG7HIMMtRCXqe/xLKuK1LcPNWxuK0DthC/tRd/pjE51QQfodmF
	qV4vRxNO80ow==
X-Received: by 2002:a05:6214:230f:b0:8e8:3c38:194b with SMTP id
 6a1803df08f44-8e83c381a0amr36651576d6.25.1782483508920; Fri, 26 Jun 2026
 07:18:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 26 Jun 2026 09:18:17 -0500
X-Gm-Features: AVVi8Cfddz7OvhEUmg-u9SqToNKt6ZtwIiVVbbw9rMuqcnL6PLcDlam-k_E3BKs
Message-ID: <CAH2r5mujFFjYs-5LTVycOv9AYVo6Pz0bd8VpPpCCtTpjGoPK8A@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
dac3b26eae7bee261fa05f20c3fcc24988a7c233:

  Merge tag 'v7.2-rc-part1-ksmbd-fixes' of git://git.samba.org/ksmbd
(2026-06-18 09:21:50 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.2-rc-part2-smb3-server-fixes

for you to fetch changes up to da793cf6d60233f47ea5e7e9e39425d71dfcdb79:

  ksmbd: fix kernel-doc warnings in smb2_lease_break_noti()
(2026-06-23 17:52:42 -0500)

----------------------------------------------------------------
50 ksmbd server fixes
This is mostly a correctness and compatibility update for ksmbd's SMB2/3
  lease, oplock, durable handle, compound request, CREATE, rename, stream and
  share-mode handling.  A large part of the series fixes cases found by
  smbtorture where ksmbd diverged from the SMB2/3 protocol requirements.

  The main changes are:
  - Rework SMB2 lease state handling so lease state is shared per
    ClientGuid/LeaseKey across opens, with better validation of lease create
    contexts, ACK handling, epochs, break-in-progress reporting, v2 lease
    notification routing, and chained lease breaks.
  - Fix several oplock break corner cases, including ACK validation, timeout
    downgrade behavior, level-II break handling on unlink, share-conflict
    lease breaks, and read-control/stat-open behavior.
  - Fix durable handle behavior around delete-on-close, stale reconnects,
    reconnect context parsing, oplock/lease break invalidation, and durable
    v2 AppInstanceId replacement.
  - Fix compound request handling so related commands propagate failed
    statuses correctly, preserve response framing across chained errors, keep
    compound FIDs across READ/WRITE/FLUSH, and send interim STATUS_PENDING
    where clients expect cancellable compound I/O.
  - Tighten CREATE and stream semantics, including create attribute
    validation, allocation size reporting, explicit create security
    descriptors, unnamed DATA stream handling, stream directory validation,
    and stream delete sharing against the base file.
  - Fix rename and metadata behavior, including parent directory sharing
    checks, denying directory rename with open children, and preserving SMB
    ChangeTime across rename for open handles.
  - Fix two important safety issues: a multichannel byte-range lock list
    owner race that could lead to use-after-free, and an NTLMv2 session key
    update before authentication proof validation.
  - Fix a concurrent SMB2 NEGOTIATE preauth use-after-free, a UBSAN warning
    in compression capability parsing, a false hung-task warning in the
    durable handle scavenger, endian debug logging, Smatch indentation
    warnings, and kernel-doc warnings.
  - Increase the default SMB3 transaction size from 1MB to 4MB to better
    match modern read/write negotiation and improve sequential I/O behavior.
----------------------------------------------------------------
ChenXiaoSong (1):
      smb/server: fix debug log endianness in smb2_cancel()

Gil Portnoy (1):
      ksmbd: fix use-after-free of conn->preauth_info in concurrent
SMB2 NEGOTIATE

Haofeng Li (1):
      ksmbd: validate NTLMv2 response before updating session key

Namjae Jeon (47):
      ksmbd: track the connection owning a byte-range lock
      ksmbd: validate SMB2 lease create contexts
      ksmbd: use connection ClientGUID for lease lookup
      ksmbd: fix lease break and ack state handling
      ksmbd: clean up lease response flags and directory leases
      ksmbd: share SMB2 lease state across opens
      ksmbd: align SMB2 oplock break ack handling
      ksmbd: treat unnamed DATA stream as base file
      ksmbd: compute lease break-in-progress flag on response
      ksmbd: chain pending lease breaks before waking waiters
      ksmbd: do not wait for RH lease break ack on overwrite
      ksmbd: honor SMB2 v2 lease epochs
      ksmbd: break RH leases before delete-on-close
      ksmbd: route v2 lease breaks on the client lease channel
      ksmbd: keep common response iovecs in the work item
      ksmbd: handle missing create contexts for lease opens
      ksmbd: supersede disconnected delete-on-close durable handle
      ksmbd: invalidate durable handles on oplock break
      ksmbd: fix durable reconnect context parsing
      ksmbd: handle durable v2 app instance id
      ksmbd: preserve open change time across rename
      ksmbd: check parent directory sharing conflicts on rename
      ksmbd: deny renaming directory with open children
      ksmbd: propagate failed command status in related compounds
      ksmbd: validate handle for create or get object id
      ksmbd: preserve compound responses for chained errors
      ksmbd: return success for deferred final close
      ksmbd: send pending interim for last compound I/O
      ksmbd: honor stream delete sharing for base file
      ksmbd: reject empty-attribute synchronize-only create
      ksmbd: tighten create file attribute validation
      ksmbd: return requested create allocation size
      ksmbd: apply create security descriptor first
      ksmbd: downgrade oplock after break timeout
      ksmbd: avoid level II oplock break notification on unlink
      ksmbd: return oplock protocol error for level II ack
      ksmbd: normalize ungrantable lease states
      ksmbd: break handle caching for share conflicts
      ksmbd: break conflicting-open leases only as far as needed
      ksmbd: validate :: stream type against directory create
      ksmbd: treat read-control opens as stat opens only for leases
      ksmbd: start file id allocation at 1
      ksmbd: sleep interruptibly in the durable handle scavenger
      ksmbd: fix UBSAN array-index-out-of-bounds in decode_compress_ctxt()
      ksmbd: increase SMB3_DEFAULT_TRANS_SIZE from 1MB to 4MB
      ksmbd: fix inconsistent indenting warnings
      ksmbd: fix kernel-doc warnings in smb2_lease_break_noti()

 fs/smb/server/auth.c       |  20 +-
 fs/smb/server/ksmbd_work.c |  58 ++--
 fs/smb/server/ksmbd_work.h |   4 +
 fs/smb/server/misc.c       |  14 +-
 fs/smb/server/oplock.c     | 679 +++++++++++++++++++++++++++++++--------------
 fs/smb/server/oplock.h     |  14 +-
 fs/smb/server/smb2pdu.c    | 676 +++++++++++++++++++++++++++++++-------------
 fs/smb/server/smb2pdu.h    |   2 +-
 fs/smb/server/vfs.c        |  12 +-
 fs/smb/server/vfs_cache.c  | 265 +++++++++++++++++-
 fs/smb/server/vfs_cache.h  |  18 +-
 11 files changed, 1317 insertions(+), 445 deletions(-)


-- 
Thanks,

Steve
