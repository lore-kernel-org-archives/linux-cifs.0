Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6433D3644C4
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 13:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161496; cv=none; b=lqzzez3nurvA3MY/8SpZo85g8T5BwP9K2IClB8Mb1kkHqkE4l/FrXZEcunQC9eSleBaKVSqjWeTfipq12MmGw0y/SMc3Dj1JlvnYan0sQFXHVm8P1vtEKnZfqWVVyji/NrHyoS6EXBsweiVizer+UhMD5rfgVSH+5LcTC4gP/BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161496; c=relaxed/simple;
	bh=1zMesP5eqh2Ra/D6ILJY5CEWAuE3sXPAhGU4jEi+Ics=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RdKeEllevbkQefoJXYe6rGoeY8sCIyFKdhev52ogjya1laruSvlLypMfMDpai7ddLu2GvLFq8XAxd0iu3OyWJCrCiCYeYgBSDzP9CWZ6QOEtLtjTDv+vlT4e1cqd8UB2dnmZdgNkM9QSuNmbEy4e12sdY9NKnWF0WiFigK60mpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B9SbkZ3W; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B9SbkZ3W"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-366087480d8so638167a91.3
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 06:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778161494; x=1778766294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WMEESWHWQz2qsh/9diQqomfBJ7Etl6kbIyKvZTnl2iQ=;
        b=B9SbkZ3WQ+gLR2VpKBIbHY+4HCuSj2DAEz1RxVgyYBUO5ZeQkoppzoO+T+suS1f3aW
         xfrwwsZkrCddx0suSdx48jb/15r3ZOpJZP5eKGCJX2W3keUaWB/vZ+nqtb6s1lV+PfGV
         0iLuNBPWBS9M097D42yDg5BhkEaezmiiB/4uBuXIciiPAMvbEuJMA9C9UTBoNAxaQSKQ
         c5A0Cpzmgh6RA00YwYA4JukjqFamKqd5zzUVWg4WOircxHuO6B4hA1jLzqg1qbnfHQAc
         2yu2voEu5whr+ogZkbcj1ixoWeuzuxysjKUT+fsrt9lAQEDzp07lAhM4s8JaogkukXj0
         xf3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778161494; x=1778766294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMEESWHWQz2qsh/9diQqomfBJ7Etl6kbIyKvZTnl2iQ=;
        b=gVMiBCkRDPcOj9E49zeHdhbYqv9mhH8OyMzRwvI2AyFKJDJYwT+xix5yIebD5IoNrz
         0KZ8tOZCygb1Iq6Yswb3gDekXnVsWA0B+lHbRebMvEn2liS4hcekoeB+kL2NbFCBTAq3
         ANhiHTt81c26gxpSayLiBBNTuoK9DWdc2glmrU0Fa7ZrebrI/XAgh1DKRmzyqR2VEn60
         9R/MuGafiOhL/CWePRDJb5WmM/nhHMHaz3oa7n9KLqbpmOQy3AVJGgzDXbCBr5lyP/Pc
         d9y6AAiOIC/3fQpZgSf0+C8lC8Q1yZ/8AJUKHTowzHO0IR9OvPvJYdu84r59MXZfSBPP
         n6IQ==
X-Gm-Message-State: AOJu0Yw1nfYyJGDQhDw2YoVSIQjXQrbwBeV+NQKTin1VSgkluTe+U65X
	g6Axs6bk95oMd9Sm2WVOewFaguqlfTUpcv+t2ojs3LO87Y+WUFJo8Fp0a0ZjpQ==
X-Gm-Gg: AeBDieuD+TNbboRnum3eVT+Vw0hZxIY9VGCC+rmbf1qFwK7VKkFezMKNiRYC4DpZH2Q
	tOdX5OZir40QW6haWQo432COYf/LY+KUMyd5xQc4TZ23QoHPexfBbwYfvB/gZadD5odQIuShNM7
	ywoEXnFk9hop1JHUBZVyxnEFNtETysQ+/fk7E2ZBKxvJtBIYu70MuFhSzANtHVBugRZoOm17KdK
	48qhXzZllUmj6poJJQjIbY6U9cRUJIkyzoDzDBd19or0yMZqM8rTZHeiUM9P+Aav6UahJYC/P0a
	4YK9rPMjQc2HwPmj/HMpLovaczuNSmrV9+mX70GiHTgMP/BYDOwgDCidgyoBlqTUC7tlPxeVcwX
	yMd0MYULo9+56t2/mHOfzNpdj24/nNkIJlHYO14L3Z3UmKRb6VJzdChIACQ2sl1Odthb3SSsAnb
	76RcvdNYIO4FVhyx7JuhaLpac53g1puYR+0Po1wGyLKQh7JBcrt7Pzx9v2SvRJ5G1aiXeNIK3gA
	1M+6LogFb8JsIUcbDMRqKnmUHasNneDlQ==
X-Received: by 2002:a17:90b:4c07:b0:35c:30a8:31f with SMTP id 98e67ed59e1d1-365ab3e5b2cmr8077449a91.2.1778161494116;
        Thu, 07 May 2026 06:44:54 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4c8a8e7sm8316609a91.13.2026.05.07.06.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 06:44:53 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	enzo@kernel.org
Subject: [PATCH v2 0/8] Remount patches v2
Date: Thu,  7 May 2026 13:44:40 +0000
Message-ID: <20260507134448.168602-1-rajasimandalos@gmail.com>
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

This series fixes several long-standing problems with how the SMB
client handles mount options at remount time:

  - Options that affect runtime behaviour were silently ignored on
    remount because smb3_reconfigure() only updated cifs_sb->ctx and
    never propagated the new values to the live tcon / TCP_Server_Info
    structures (retrans, echo_interval, the per-tcon options, rasize).

  - Options that have no meaningful semantics on a live mount were
    accepted by the parser, leading to confusing behaviour where the
    user thinks the change took effect (vers, sec, multiuser, UNC,
    username, ...).  These are now rejected with a clear error.

  - Toggling 'lease' / 'nolease' on remount used to leave behind
    deferred file handles and cached directory entries that were
    obtained under the previous lease setting.  This series closes
    deferred files and invalidates cached dirs across the superblock
    when transitioning to nolease.

  - cache=ro and cache=singleclient are special-cased to be rejected
    on remount because changing them at runtime would be unsafe.

Patch 5 is a small refactor that moves struct tcon_list out of misc.c
into cifsglob.h so it can be shared between the new
invalidate_all_cached_dirs_sb() helper in cached_dir.c and the
existing cifs_close_all_deferred_files_sb() in misc.c.  Patch 6 then
uses the shared struct.

Testing
=======

  - Ran xfstests on the patch series.
  - A targeted nolease/cached_dir stress test (lease<->nolease toggle
    cycles, parallel remounters, concurrent I/O, GET/PUT trace pairing,
    deadlock/starvation bounds, hung-task scan).
  - A general remount test covering both reconfigurable and rejected
    option changes plus repeated mount/umount/remount cycles.

All runs clean, no WARN/BUG/UAF/hung-task in dmesg.

Rajasi Mandal (8):
  smb: client: block non-reconfigurable option changes on remount
  smb: client: sync tcon-level options on remount
  smb: client: sync retrans on remount
  smb: client: sync echo_interval on remount
  smb: client: move struct tcon_list to cifsglob.h
  smb: client: allow nolease option to be reconfigured on remount
  smb: client: block cache=ro and cache=singleclient on remount
  smb: client: apply rasize on remount

 fs/smb/client/cached_dir.c |  44 +++++
 fs/smb/client/cached_dir.h |   1 +
 fs/smb/client/cifsglob.h   |   5 +
 fs/smb/client/fs_context.c | 355 ++++++++++++++++++++++++++++++++++++-
 fs/smb/client/misc.c       |   5 -
 fs/smb/client/trace.h      |   2 +
 6 files changed, 403 insertions(+), 9 deletions(-)

-- 
2.43.0

