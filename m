Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A26C1F2B8D
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371680; cv=none; b=c0IoxVM3iEaZEUuKtYcV+TBPqBlJpcUrvBnevt6nD5ZtrHfaW+2FaLiVRM9eEZe915POvjobzxv4/FEQY4Rh/mB8Hf7nLEdX460UN4wIfLyufASRd/59QBToMsr7YsjVgbxWGxwetPNf/lMPhPYxINmd9iNQL2mHtRNmaUmqykI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371680; c=relaxed/simple;
	bh=aJXcUe96mYNYpMc7nreTsMLl5qNEWscVW0C0ZqUYfg8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NpluaJgxvUJWC+ob08qf5ooxDHKCKn4ExBCcQWt2xBA4S4vFWno+IJA45Ixlw4bRsVnJX/+HchBjYUmH5Qlozri7eMR9vzHC9ChP25LmdXyos6o446qhLngPz+PB4xEnqZc0zLnCEI3K5+5WybSiWPW/aLgOFKgGqW6AlJt66Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IJBijoB7; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJBijoB7"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c8021c8c42fso2633774a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 06:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779371679; x=1779976479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+VMZum6rbvcq8SNvCs1usF5qoZjgULqc5UsCB3krkjA=;
        b=IJBijoB7GW5jjrYMk/D45zcu1b7f4Gw8wGKy43UyZVuoFovXPdgRl7VUP9m5WNWayU
         V8XfuR1q7tt8cVd3Crm3MXMZeNTtKifATn5jMTbuLa5zFNN/wCoPOI56zFa3yOqc1iTD
         guTJR7RiE/eEfNmCiH/1y83v9c7QFq3Thz82luf5uBKsVPF4aiJ/YCeQKM0mBYyVhRtL
         r4WYDBdIx5MYpVW4JXr7b5GWqXRlg833H0hiLatPG6KBqc1WMuK1E0F31m40Lg33Dys/
         L/Q4cT3YqvrQtKk1t/RbK7td/fKnIWv0WiE+L5tF9wyxkeu6SGMdVQmxkfAewZdYgSWG
         zCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371679; x=1779976479;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+VMZum6rbvcq8SNvCs1usF5qoZjgULqc5UsCB3krkjA=;
        b=K2NK3nKidWdeNkTM0EUzdtZPdfm/QZFxWxyYwWItQyn9qa8Kl833cxktvq/hUC6IGG
         iT+aM4Y/fkZOJEaAbVmbXZ3txBoXG4+HauRwM3sdGhLuLtXOmshPkT8lQ5GP6qfC08BK
         EEqVftpwZetWbWeF3ewhkLoctQedUW20aP/nfL8rWORk0Ol3s+DaQG9B/Zx8RSArAnBP
         OqErPyhiOy3nkLR4G96mvJAKJ1qVUVbz2tGZ7Oz1yVmGZr8Ej0MBDvZN6vROcXwdiKYd
         H7H0Y2J8Nc74LTOJUYLgaEAqx0RWvn/I4awhjZJtrx6KnEHd7ELR4BvNUyXgNZ05an0w
         S/Yg==
X-Gm-Message-State: AOJu0Yy/X/HF4u3MSqNczOwM+7EXW94Oe3kCBi4N3BJJnsOV3w8Cn0Wt
	PlsqsZsbnxYCX5P8j3f4QtC/UtBP2HbJzBU9j/H+8qEjyTEaRAVuup7G
X-Gm-Gg: Acq92OFUMTBSbEH55/ArM7wIy5bAP2R+nxBZpbplYo6sf7eCYsFGFDCfkFp+2Wij5sF
	AyfWU3Eag1OVD/2DIVvtabHkldDUtshIpFBSMQcskl7SLlhaJ8SZyYTYrUhDZbd5VmFVFrWTAgV
	Pcl1SoLlDXNPhTHQ+pHFxXeBY5xbfqZysZIVNTzadO/GQ0ICjzMt06+89aEz2KIg0+YnicKaVDh
	SculAk0eFhB5p7nIG39k4vRAOHlr2v561Czjo0KHfBLFtNZ8IHGOHvWxiT/e2v27BZ8W9w9GXfw
	eqKl6vfDW6o5e58Bck+GZfHcVropvdyeMwucCl1417Wu7CqrRqR5mJ895t5hnJW/pV678G78kk2
	aaCkmbeARk5K01OruazYMGcmC5HvMgcSsSlp8DnQd0OTijRAP0j4KJsr7mOOU6GweKzHtdW8TuW
	/Sx0hPMoy80omQjd7954viHWMJzVOtgdiekKDKhr+pXWWZyKPmHZXOmCgEOTxbe8zOtLaI7RCZp
	S0OhjZZzY21rKdPd/SHWBqQJaCXTMOWQA==
X-Received: by 2002:a05:6a21:329d:b0:3a2:dc51:449 with SMTP id adf61e73a8af0-3b3086e8ec8mr3669926637.12.1779371678713;
        Thu, 21 May 2026 06:54:38 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85197c72b3sm455378a12.4.2026.05.21.06.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:54:38 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v3 0/9] smb: client: make remount option handling correct and consistent
Date: Thu, 21 May 2026 13:54:06 +0000
Message-ID: <cover.1779371115.git.rajasimandal@microsoft.com>
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


Rajasi Mandal (9):
  smb: client: sync runtime state into ctx on reconfigure
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
 fs/smb/client/cifs_swn.h   |  14 +-
 fs/smb/client/cifsglob.h   |   5 +
 fs/smb/client/fs_context.c | 355 ++++++++++++++++++++++++++++++++++++-
 fs/smb/client/misc.c       |   5 -
 fs/smb/client/smb1ops.c    |   7 +-
 fs/smb/client/smb2pdu.c    |  11 +-
 fs/smb/client/trace.h      |   2 +
 9 files changed, 431 insertions(+), 13 deletions(-)


base-commit: 19d8c94787da866318eead464fb9c9d70815af56
-- 
2.43.0

