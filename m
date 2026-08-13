Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89C03C8728
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 09:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614179; cv=none; b=pNpUurkKdd1xfa9ersSoW3Kn/+/TSBEOjAsV9PqoJLr5v+lf3/4Xvy7Iy3XXOn5uFarysULZSiXE5mabUunNVu5ofun8Au1bilYcXiH68Ha2lGoIQzxi/IgeFRepuM7i4TXUOqH2QpSrddmi7VfeqV6AnhUkBcfBxEu7H/vCHH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614179; c=relaxed/simple;
	bh=9mvBF2sil5wlEu+QJZY8wyHsKLmPvVXugUWC4kHzU0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOeoCKw5ta6G+yVt1tDMuQixb3vD+M89Lk8cdiHzgMri1El2DFV9N8LD7oqiLeRy/EdDFw7u4lUPmaYdR1U7wZ/6nhhvRWwTx9L6ty6P0LJb6Ao/K1QEUGFt/m3FMDfGVgeDOhH4SW1XqdpccBEMLD5qOaLwbAQhDrLLCnnL01I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sAG5CJA1; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sAG5CJA1"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso1243784a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786614177; x=1787218977; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3XIsF1pMZ6DjIzxJfBkIYCV0KQ8I4JOcJCgF6v+CcKs=;
        b=sAG5CJA17RI4v6tnW3znGd1YOBc4VfLKBx7F8zrReeCpmESzKcDi4J54bYfDBpUPWd
         S4Dc5X/eB20oXVWwwhJeTZ368yLN7NjXKAt23QpIrey4uzCn/Mm+L/UmLMV2aqY+aX3+
         TKZUIro+InouszC8pL1XrmGVSAf0uuaxKGrdcKc6SvfD1nx4/dXJ7Q0VKJRlIE4jSsse
         HNvytDovJnyqI20RxN9761scmKQwVGRFwYySunha2qxAEyIJ0bwFbxB7CSb1azaPHGlz
         g5tHA9OsP4YGWUxNIuv1uOXPSppJL07GXAai6b63SQoFPEX/xy+V1Sd7LA6tkUKyduRm
         9+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786614177; x=1787218977;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3XIsF1pMZ6DjIzxJfBkIYCV0KQ8I4JOcJCgF6v+CcKs=;
        b=HGhvpupquBKZvuywkQ/hpHQp1RNC7qfxa9tmwfOVMFMU9ne/c5Yc9HLCwzbgxrScvg
         L85XDfxw8q+ALct0GHFppEUnaLrOHpMdz7uaS6gTGIw5VYq7Y1AQJ6b5F/xc7aU695SE
         ucHd3yipGuze/GFHkA+FIMfQ9v/TS++IDsa5IXpR5XW2dYN+Eji0DCKp61xxgf7qo6Xc
         g6Lmq3nkE9Y2mJUec1xV6CUlHgNXnCEpO2RriQ/ap/m/TgsLYUeJld0lQyu0UYsq+1KS
         4S4UzolTA7I+jiXt9ni1qwnjfM1iUkBkcZW2Yjr5N/nhseNmxy+vf+3fkTaw4aHIedgx
         7Z0w==
X-Forwarded-Encrypted: i=1; AHgh+RqyfKnE0qLQj0j6XejJU/eQqpNwSvxTmzpf7lQnbEKYYgyeZjydQC6XkN8roKJNrH5EPSRVWdfrZ4zv@vger.kernel.org
X-Gm-Message-State: AOJu0YxjjnTM2ucUWhVLiCASq6xFo70pULHfhk62kwmtSNxOrMMREqkk
	2iDM0j92VMo6KcsfcION3oDw6XSQd8vmZxUNgym/aTY3SJ6OT70/RBp9
X-Gm-Gg: AR+sD10IhcwIXp69lLVz9wLUlIZIBnck478YkqTTe860kbdXRN/jRWT8mTJoavxtuy8
	PAdrg3tUWFsox0KYxZvy5CR1+1GcZDw6N4anWLYXJKdsmxo1dW+E9exXbyI5bTjMUwtVNLD/xrn
	+u5A8ZfdvjqkpeAKIRPKWTZbXjV3iYxaOmVC9w3avu85XEBM7ZAq3pkfVzjAQWNbWWPp4q1fSdW
	EXViq1Pl0jsL75tQUng2P9mgIlowTZzDcYVr0A1hpZqp7BlZOKMBHSxOQ2xlh3U4smScblVRHZF
	gx2OvH8EEHOEdFk+Z2zysrQrtnFqNoR3WSVMw8jQjpAxzVf+v/c+sW0VaSDFJkz3MKF+I55Dbev
	IZIkU6vUhTNwVv2sYECNbRxcpG4c1vk8IYnmgFG0eSyX5rlfCtEWN8CYM1DqIhCRBwyHkr3hDiO
	mR0StzAosGH2dpUDIqDN96FK6j4Po+AnCCrfbRWy0QZBSytsHh66fvGKwQ2FnsOi27A3h4ub21A
	O36kjjdR1F/eFkU+HRwvq1nEE4Idi+uvw4lxpD3RohiUHMKgNSYoOZNO/UzDoG6qY0FGKbeBG1D
	x3AXYf0ffEp50JYn
X-Received: by 2002:a05:6a20:7f98:b0:3c6:3c5b:fe5f with SMTP id adf61e73a8af0-3cc550cb970mr5607450637.2.1786614176901;
        Thu, 13 Aug 2026 02:42:56 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc760524sm6409135eec.1.2026.08.13.02.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 02:42:56 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2 0/8] smb: client: remount reconfigure option fixes
Date: Thu, 13 Aug 2026 09:42:43 +0000
Message-ID: <20260813094251.666373-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813074517.607275-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

This series makes several mount options actually take effect (or be
cleanly rejected) on remount instead of being silently ignored, and
fixes the option-comparison baseline so a bare 'mount -o remount' is
neither wrongly rejected nor allowed to clobber live runtime state.

Overview:
  1: build the reconfigure baseline from the live mount (a private,
     runtime-synced dup of cifs_sb->ctx) instead of init defaults.
  2: reject connection-tied options that cannot change on remount,
     using that baseline so bare remounts and /proc/mounts replays
     are still accepted.
  3: propagate retrans to the live server on remount.
  4: reject cache=ro / cache=singleclient changes on remount.
  5: apply rasize on remount.
  6: move struct tcon_list to cifsglob.h (no functional change).
  7: make nolease take effect on remount and evict lease-bearing
     cached state.
  8: take tc_lock around the tc_count bump in cached_dir_lease_break().

Changes since v1:
  - Patch 1: corrected the "Not addressed" note.  The pre-existing
    unserialized cifs_sb->ctx access is a potential use-after-free
    read of freed string fields (e.g. iocharset), not merely a torn
    or stale value as v1 claimed; the note now also acknowledges that
    the reconfigure-time dup adds one more reader on that same
    footing.  No code change.
  - Patch 3: cifs_construct_tcon() (sess.c) now reads server->retrans
    with READ_ONCE(); it was the one remaining plain read that would
    race the new WRITE_ONCE() writer.  (Reported by automated review.)
  - Patch 5: documented in the commit message the two pre-existing
    items previously noted only here (sub-PAGE_SIZE rsize/wsize
    realign, and the STEAL_STRING() source NULL window vs DFS
    reconnect).
  - Patch 7: invalidate_all_cached_dirs_sb() is now documented as
    best-effort if the tcon-array allocation fails under memory
    pressure -- future opens still honor the new nolease via the
    tcon->no_lease propagation, and the n<count walk bound is
    commented.  (Reported by automated review.)
  - New Patch 8: take tcon->tc_lock around the tc_count bump in
    cached_dir_lease_break() -- the sole tc_count writer that lacked
    it, letting a lease break race another put/get.  (Reported by
    automated review.)

Known pre-existing issues intentionally NOT addressed here (each is
called out in the relevant commit message):
  - cifs_sb->ctx has no lifetime protection: cifs_show_options() and
    other lockless readers can take a use-after-free read of string
    fields while smb3_reconfigure() frees/replaces them in place.  The
    reader side (/proc/mounts) is unprivileged but a hit still needs a
    concurrent privileged remount of that same mount.  The correct fix
    is an RCU/refcount ctx lifetime touching every reader (iocharset,
    source/devname, the reconfigure dup, DFS source lookup, ...) and
    is best done as its own change.  (Patch 1, Patch 5)
  - tcon->unix_ext shares a bitfield word with other lockless writers;
    theoretical word-tearing only.  (Patch 1)
  - Explicit 'mount -o remount,port=<active-default>' is rejected; not
    reachable via tooling since port is not in /proc/mounts.  (Patch 2)
  - A bare remount realigns a sub-PAGE_SIZE negotiated rsize/wsize up
    to PAGE_SIZE via CIFS_ALIGN_*; pre-existing and independent of the
    rasize change here.  (Patch 5)
  - cfids_laundromat_worker() can resurrect a tcon from tc_count 0
    while cifs_put_tcon() tears it down, and the cifs_debug dirs knob
    invalidates with close_handles=false.  Pre-existing and unrelated
    to nolease.  (Patch 7)

Testing:
  - checkpatch --strict clean (bar one pre-existing CamelCase CHECK on
    ses->domainName); each patch builds standalone (bisectable).
  - Functional testing on Azure Files (SMB 3.1.1): a bare remount
    preserves the full /proc/mounts option set; retrans/nolease/rasize
    apply on remount; vers / echo_interval and other non-reconfigurable
    changes are rejected with -EINVAL; a remount replaying a
    server-displayed option is accepted; I/O works and dmesg is clean.

Rajasi Mandal (8):
  smb: client: sync runtime state into ctx on reconfigure
  smb: client: block non-reconfigurable option changes on remount
  smb: client: sync retrans on remount
  smb: client: block cache=ro and cache=singleclient on remount
  smb: client: apply rasize on remount
  smb: client: move struct tcon_list to cifsglob.h
  smb: client: allow nolease option to be reconfigured on remount
  smb: client: take tc_lock around tc_count bump in
    cached_dir_lease_break()

 fs/smb/client/cached_dir.c |  91 +++++++-
 fs/smb/client/cached_dir.h |   4 +-
 fs/smb/client/cifs_debug.c |   2 +-
 fs/smb/client/cifs_swn.h   |  14 +-
 fs/smb/client/cifsfs.c     |   6 +-
 fs/smb/client/cifsglob.h   |   7 +-
 fs/smb/client/connect.c    |   4 +-
 fs/smb/client/file.c       |   2 +-
 fs/smb/client/fs_context.c | 446 ++++++++++++++++++++++++++++++++++++-
 fs/smb/client/misc.c       |   5 -
 fs/smb/client/sess.c       |   2 +-
 fs/smb/client/smb1ops.c    |   7 +-
 fs/smb/client/smb2ops.c    |   2 +-
 fs/smb/client/smb2pdu.c    |  13 +-
 fs/smb/client/trace.h      |   2 +
 15 files changed, 576 insertions(+), 31 deletions(-)


base-commit: c0a27675eaf08255017b3cabc28c99c0cd71f468
-- 
2.43.0

