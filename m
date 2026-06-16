Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961DA3D6695
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 05:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589245; cv=none; b=UxpMoq5bLw14Gi2N+ZS1/8jw0S+65gpOULTpMrmZgd81Ft8KCnVV9I5sqcTCx0otHdtYc3ivXN7+FiWy/9RDFMwfn5NkL8gUJKEgAj3e3CyaDLqxbkJNziZY5hleu7P3eFsbLB17R2eBlp7uRb8bNDeoyqLYWx6PzX+dp6HjtyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589245; c=relaxed/simple;
	bh=ohlBA6OjGb5sacDjDDv5cwC1UclzdTXG+7md+1MZE68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pdT5OkxqteBIPz54fuzLqmrNxDu4i3hm4x4P9HYVmHsPNCE7Hlw9WsH6CyBcisdpvgPanm0PuVOqeThxhplCZI+u0+4fK+l0VH9Ue16z7T+tlWstdaliymNa0cFY1og8ICBTCuf3Xv4afaqnoI7bWCqFe2bPAac1nmG85EjdXdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VENt3zQP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VENt3zQP"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c0c2a68d01so26276675ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 22:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781589244; x=1782194044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KJQwR3cAzc2s2HyBgIYrJ6ZfIeFUrWnQYbWiFvZI1I0=;
        b=VENt3zQPnUeHcXfX41/x0oxo5IBVJWUyoMglWx7lTargXuaj16Ov4u1B2ZJHSkZIDY
         tjP5Td0lzXKfO3MGJ1LZIKRa5Vbj1XEgHd1IfobQpjxD4hyJFDt4P7g6umcv/BqeJQXy
         vFoSuwxEi+qEZDeBCme+WY6xFgj89SG0A/fB7sSMhUsyFH1cWep5AeRWETUL6JD1RH0m
         zVXTawfX1G7UQafNofjRdJSxFFlKaihugWKXtEUCnet9BW9yIsZ6CeS9RB3z0b1dBM2w
         3enwQiflWVfGJq+Fp+4s0aA4qmP9fy5sCbp0pqhq/GP1BlE6dHaYwnEAIh7BS2jB48tO
         4/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781589244; x=1782194044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJQwR3cAzc2s2HyBgIYrJ6ZfIeFUrWnQYbWiFvZI1I0=;
        b=cnCqNur30j2jKeBU5r+euBIEvbeHcAPO6sHeCKbmJksIrAkW6PVwFAQgWn7pgSi91P
         bSqmsZS73ET5tEzzg4HNoOl/J//sFc7K2aQ5JTaHstHs00+4RDSKetf8UH3S2e1C0x43
         jUx/VrmvFLQdB3j0ZZPvMah10KS+FunpRyxduV7fC2CFReVDs48ykfVaXgKuBdfszk4P
         SAZZTqYiksDmKnWXsKde8HzvGlvAMhd7EX+jJmNYqRH0r0gpvu4wKufpASenIgFtxhub
         x4zxi90aFaLFTxB/WkvovKR6cE2AIuwFjpTeC/3bT2NeV8OhUEGMM2soZVtGgK16oiLO
         bteA==
X-Gm-Message-State: AOJu0YxHlgH7+K6GYTMwcRt1k4FyG0vUdyfymA/O09XxDJ5Z9slgLvrB
	jgDNOmbd5qFZZ+J/BxIS5pqVqGqYhlz4ghi9X+eBpWrlk0/dC0Fta8eX
X-Gm-Gg: Acq92OGrzmfjp9HXkjtfjfph6aIc6YnbKKl5qB9oeoYe8JBkRY+8YyUCvxhIJOZP/m6
	32U976ddyeZ03kWvQ5RIflScQp5mkGZbb3RqeH6M0RP21FcnkT2Sp+6eBfzQFzxSxo4MgN3R4JB
	oIazMypBh5x1aDLXDZ8OZswOueNghaionKhbUQYsvPLsQHS38Rm4vw8ruNUbw0BtvqDercAC1CK
	myDGOilArivRTQnE+iDVgDpOlqFpRN7NyThiGkbc94fMh1Z5ismpzdaE8p9OAQ97PoOxuBCWPQu
	t4HAxtbno4kWv122ZXy/7ODVc+yVZf5+GAgbbrSOCxZ8PAt6xc0RzSlOHqEAfBY7REcFNQXPAZ1
	yFvSFxudc9nYTPtGI657XK7nkyiWovFRQGJl/l9YtkFHW4HDI/TkpkCsm0O17YCgA1ArjHKWABc
	kc3zJt0ftVN7VZh/Q54lleBZI3EWyi6EPN0VaxbcgdIxUmR0RJAPbX9lfK/wCRZUaNVDuKIsHTb
	GVJ5tVIx/HHZFnQZeLc8k0=
X-Received: by 2002:a17:903:2447:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2c699dfc3c0mr21373265ad.0.1781589243909;
        Mon, 15 Jun 2026 22:54:03 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm120805275ad.7.2026.06.15.22.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:54:03 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v4 0/7] smb: client: make more mount options take effect on remount
Date: Tue, 16 Jun 2026 05:53:50 +0000
Message-ID: <20260616055357.3798387-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Several mount options are accepted by the remount (reconfigure) path but
silently have no effect: the new value is stored in cifs_sb->ctx but never
propagated to the live server/tcon structures, or the option is simply
ignored.  This is confusing -- the user passes an option on
'mount -o remount' and nothing changes, with no error.

This series makes the reconfigure path honest:

  - It first establishes a correct baseline for comparing old vs new
    options on remount by duplicating the live context (with runtime
    state synced in) instead of rebuilding from init defaults.

  - Options that are genuinely reconfigurable (retrans, rasize, nolease)
    are now applied to the running mount.

  - Options that are connection-tied and cannot take effect without
    tearing down the connection (seal, sign, vers, ip, srcaddr, rdma,
    cache=ro/singleclient, etc.) are now explicitly rejected with a clear
    error message instead of being silently dropped.

Patch 1 is preparatory plumbing (duplicate live ctx + sync runtime
state) that makes the simple != comparisons in the rejection checks
sound.  Patches 2 and 4 add the rejection checks.  Patches 3, 5 and 7
apply the reconfigurable options.  Patch 6 is a small no-functional-change
move of struct tcon_list so the nolease patch can reuse it.

Changes since v3:
  - nolease: moved tcon->no_lease out of the bitfield word into a plain
    bool, so propagating it on remount cannot race (via a bitfield
    read-modify-write) with the lockless need_reconnect/need_reopen_files
    writers on the reconnect/reopen paths.
  - srcaddr remount check now uses cifs_match_ipaddr() instead of a raw
    memcmp over sockaddr_storage, matching the adjacent ip check and
    avoiding port/padding fragility.

Rajasi Mandal (7):
  smb: client: sync runtime state into ctx on reconfigure
  smb: client: block non-reconfigurable option changes on remount
  smb: client: sync retrans on remount
  smb: client: block cache=ro and cache=singleclient on remount
  smb: client: apply rasize on remount
  smb: client: move struct tcon_list to cifsglob.h
  smb: client: allow nolease option to be reconfigured on remount

 fs/smb/client/cached_dir.c |  44 +++++
 fs/smb/client/cached_dir.h |   1 +
 fs/smb/client/cifs_swn.h   |  14 +-
 fs/smb/client/cifsglob.h   |   7 +-
 fs/smb/client/fs_context.c | 332 ++++++++++++++++++++++++++++++++++++-
 fs/smb/client/misc.c       |   5 -
 fs/smb/client/smb1ops.c    |   7 +-
 fs/smb/client/smb2pdu.c    |  11 +-
 fs/smb/client/trace.h      |   2 +
 9 files changed, 411 insertions(+), 12 deletions(-)


base-commit: 0eb17dea51eff940230b5e562df29ce457124d41
-- 
2.43.0

