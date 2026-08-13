Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C74B3C5526
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 07:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607124; cv=none; b=ABYfTKaBdLUSHfLu84kzHE02sgzJj95q/6C1GSQhkM6WlcCvukVguQw6zez44vLsCefGPmSRJ9kSo4WdPmZv21wcgbJZZ3hRwcCs7uZ4hQuuAC1qx1fwzccHse5e+KSDMyktT0erJSZq1skpVVcTXF2Rk1dl85kxHWmdywJktOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607124; c=relaxed/simple;
	bh=guIxsW/VKcF3TCYcK7b/nm3rAet2/NRfPQiWcjKYktw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rgW+ZYa+TK7xaL8BTIG56VOI8ySm999ZrEVjDhBeKAtZnoiFmdK/KMYjrZespUPTldEBgJYk69ioU8+S5PrViHfiiEkpvIL2KiI69jdLIhtH0a4zFOyZbgC9a69ytjHsaJ/vW8NpaZrVoNCK5kL34Aqa2x4toA5eBas/XOxPfBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UFYwL0KH; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFYwL0KH"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38e88b60121so423245a91.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 00:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607122; x=1787211922; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YW3iXl4S0/9y9ThdjtL2ZycQq/RfH6ucqoDo0HmSIF4=;
        b=UFYwL0KHuPy1gL2xq5gCnDBd5YDtnhUNarodbR9TS5D3S6/E7kJl3L3CqbooMaWyRA
         IFfoAqcTeN/ZqkuM7QW2etVskeNNuLkR+k8lr6aM+BeErzNpbRYiHANUqa11rT/00Lbb
         ihDWK1OuXDP+z58X0XfhcI0Qny291SHATUi8q4zthplWNAOXHdzRvqfYfZlfmFvCVniE
         tSE29oWhK9pziylyflulnTGalPzjWkCj/Qx1oo7dzYmHwTvfdjz6cGCceefM52AWv6cZ
         t+N4VWpXWv8DGIvQRTCZPKdEcMsu4CllycoeDXKtAMghV79IGPxBqF9Y+yYRMkQ5GlNT
         B2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607122; x=1787211922;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YW3iXl4S0/9y9ThdjtL2ZycQq/RfH6ucqoDo0HmSIF4=;
        b=YVWTqQK7jXb+Wcs4CzSQ9XrY+ZuAo0y6ATkVU4u/2HcC4PsQYAn0WIuHg9SBB/NsN8
         RlpTXtCqBwf72mhS5VvCwb4K2xgtT/NY7OLuSO7AQ896Ctz2OgDQVg7v8F84IJgWYF3t
         G9Y2KAfqVMo6EDkiTRrWrakuNtK5YqqRggeYXmx3uv8+dMtrZPQARLA6SKHcIisIoxif
         0l0RfIw014di15z8kk/jM7wGXBzF3rVKsI9QGOZ8TDss4uxkwpW+vKnXMn0F9U4xZ5rk
         dOqBnLaVohWXMnw9otL5mK0bYUh/d61oE2aRwT7ZKUo11J/UTJWRC201ooUvQpXl6RuG
         TKRQ==
X-Forwarded-Encrypted: i=1; AHgh+RpsV+zY68qf63k0Fp7srhePm4FcHYcgezsK5KTJCT8pLFFFw+lFJ0Bfigyx/uv/x3TVA/GRx22dBWRV@vger.kernel.org
X-Gm-Message-State: AOJu0YzCGLLiX4h1frpePmlu77PJrBgTD1YiNuIWqwO39XymWAfRO7Js
	w4XKMliPCJD/vkEr/r7g323CdXUP5uBQ2OQsVOJn1O47EXVI8eGk81bl
X-Gm-Gg: AR+sD11ZTYMIzuqpyR1WQF7h+2r6GGHBdCyiATtdXJS6XR2A+64KOCJ8qNZ8gabVHNb
	Cg9EXnw+POX4DWxXpRcJE68WDRl6TDpGAu1uOgHwz+oXEviP62cC5J3b2wb2WqNqUMU2yu8WGF7
	PPzRDMpGKpvjlwHnC/XgkRFvZS8vDXZVZFunJGC7C0EcCD8mPDPQ0o4ANaA+W4QdaZdZ4Jw/Zr6
	HPXCrGqcjyt0HBigEO+SSRgnM2QElgWJvADq6iNWM0Gjp20RxdS3LOvJcp/2AGWTZ0y67v58AIv
	MjPcElVVfp9jU0t6pvdp/+1uNYWwlZODGZ7OWiNS12EUmrACoEF6gfNDjHjl2mmW9Mp06oKEXT7
	9DmeSr8QRlP0IEr1w52kFk0pl0aBqeVGfuSg5hsUaayRg0H/GPdIv75IZDRPwyOfw0ehPBgfKyy
	irs4WHj/4P2TRkB1TWM3U2xNz08ETr4WyKmYICV+075L3MRS13XwQIk5SOT380pdBqjpn+jHmda
	3rHClS6h3hMPboOP6zqkXum9k3bqrHKFz6jDPG54U4uzEfW6FTd3q/27JLf0LhF+sHCqnVxhec/
	2ex1KA0LBNe/nmgBqWtyoBJumhKd
X-Received: by 2002:a05:6a20:d81b:b0:3b4:75c0:3ec0 with SMTP id adf61e73a8af0-3cc553fc62bmr5680908637.30.1786607122368;
        Thu, 13 Aug 2026 00:45:22 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ec022acabsm4587594eec.27.2026.08.13.00.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:45:21 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 0/7] smb: client: remount reconfigure option fixes
Date: Thu, 13 Aug 2026 07:45:10 +0000
Message-ID: <20260813074517.607275-1-rajasimandalos@gmail.com>
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

Changes since the previous posting ("[PATCH RESEND 0/9]"):
  - Folded the two "review fixes" commits into the patches they fix;
    the series is now 7 self-contained, bisectable patches.
  - Patch 1: do not fabricate no_linux_ext (mirrors the existing
    nopersistent handling); sync the server-shared display fields into
    the baseline so a bare remount on a shared connection is not
    wrongly rejected.
  - Patch 7: invalidate_all_cached_dirs_sb() counts tcons and
    allocates with GFP_KERNEL outside tlink_tree_lock instead of a
    per-tcon GFP_ATOMIC allocation that could fail mid-walk.

Known pre-existing issues intentionally NOT addressed here (each is
called out in the relevant commit message):
  - cifs_sb->ctx is read locklessly while smb3_reconfigure() overwrites
    it in-place, so a /proc/mounts read racing a remount of the same
    mount can observe a torn pointer.  This predates the series; the
    proper fix (RCU-style ctx replacement) is left as its own change.
    (Patch 1)
  - tcon->unix_ext shares a bitfield word with other lockless writers;
    theoretical word-tearing only.  (Patch 1)
  - Explicit 'mount -o remount,port=<active-default>' is rejected; not
    reachable via tooling since port is not in /proc/mounts.  (Patch 2)
  - cached_dir_lease_break() updates tcon->tc_count without tc_lock;
    cfids_laundromat_worker() can resurrect a tcon from tc_count 0
    while cifs_put_tcon() tears it down; and the cifs_debug dirs knob
    invalidates with close_handles=false.  All pre-existing and
    unrelated to nolease.  (Patch 7)

Testing:
  - checkpatch --strict clean (bar one pre-existing CamelCase CHECK on
    ses->domainName); each patch builds standalone (bisectable).
  - Functional testing on Azure Files (SMB 3.1.1): a bare remount
    preserves the full /proc/mounts option set; retrans/nolease/rasize
    apply on remount; vers / echo_interval and other non-reconfigurable
    changes are rejected with -EINVAL; a remount replaying a
    server-displayed option is accepted; I/O works and dmesg is clean.

Rajasi Mandal (7):
  smb: client: sync runtime state into ctx on reconfigure
  smb: client: block non-reconfigurable option changes on remount
  smb: client: sync retrans on remount
  smb: client: block cache=ro and cache=singleclient on remount
  smb: client: apply rasize on remount
  smb: client: move struct tcon_list to cifsglob.h
  smb: client: allow nolease option to be reconfigured on remount

 fs/smb/client/cached_dir.c |  83 ++++++-
 fs/smb/client/cached_dir.h |   4 +-
 fs/smb/client/cifs_debug.c |   2 +-
 fs/smb/client/cifs_swn.h   |  14 +-
 fs/smb/client/cifsfs.c     |   6 +-
 fs/smb/client/cifsglob.h   |   7 +-
 fs/smb/client/connect.c    |   4 +-
 fs/smb/client/file.c       |   2 +-
 fs/smb/client/fs_context.c | 446 ++++++++++++++++++++++++++++++++++++-
 fs/smb/client/misc.c       |   5 -
 fs/smb/client/smb1ops.c    |   7 +-
 fs/smb/client/smb2ops.c    |   2 +-
 fs/smb/client/smb2pdu.c    |  13 +-
 fs/smb/client/trace.h      |   2 +
 14 files changed, 567 insertions(+), 30 deletions(-)


base-commit: c0a27675eaf08255017b3cabc28c99c0cd71f468
-- 
2.43.0

