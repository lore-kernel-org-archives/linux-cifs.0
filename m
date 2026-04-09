Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796C63BE17B
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 10:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728817; cv=none; b=YPBIQeifEHN177jgVRtobsm+fsYoGRPuBMbFudJ/th9fnFTTDX1qzT34oFf7rsDeABFLniUr7OlR2ia0QuTc3FHIakhkKC3x0gG/8ohjVu622AwqsjYkAUkUIupTRkGOxyEgQCN2xmgaGyx5McF05EKfj+xPVmtaUpWlsvfFtKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728817; c=relaxed/simple;
	bh=iVLJ2lod5R2JDz1cIrkKG1CXH3xzWLlnArZjx/SFbJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvF9XFokcrXT9CXZDY35S3DfpUPbFO8uCk1iRX9j80zLyN/yeU8RayCOq0z7/p1M90bfSIv3NPQ7AyyapJEytz6TSFgvbBZOEQAzlvD6LDZS8BtGbUbV/VA/lvVF9gnK0jz1S/woor5+pu0YstWK3kd55yYvsFbVWe0udFPhIqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WExFgz4b; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WExFgz4b"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c742723c863so470697a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 03:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728813; x=1776333613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jz4zNE+M7pi3tWDtuAf/A5LJVd6SnwS9PUa/d+0Kxas=;
        b=WExFgz4beBDbnFehO9Tk/QAZeYV+VhHf032DcQA5wNSvYjQl2Pp5lMICgGDcy3S2HN
         XWVb6u6/PTXySiUli+T7Fgqm4qnzJ3YRtlBFSbDs7CM2ebDVBW+uWE6RaACm9DDkEfL0
         KWmVpyLzbkxK/XOPNjQuhBtXRgsUvfp5VwNjKv3PbloHDYaEBUcANsFk/nApuzMIb49n
         vWXkCE02Fr9SLETyroyuVTuQe4IwrO2B6wmIHuPKv6qc/HdJxVswr+j4k9Sikl+SFDhD
         rMsKrb4ZM4YzG4xbjYZh0UnxgiqTdgDpx9jdSYkqQyQSWs0w2suOaKkGzIQXAQGkoGaC
         EY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728813; x=1776333613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jz4zNE+M7pi3tWDtuAf/A5LJVd6SnwS9PUa/d+0Kxas=;
        b=p0t9p2l2HiY6bYcKuhw5RYfxXsrGXhsW8JKVJPjRSkxR/25BcP39lZDo6VXvcMTqNl
         Gbn+iI5XwEwGUFpmYh3zt7faAIPrL83YgeU8ZCko1oXnkdU/VJHeRA2EGuwEMO67j5p1
         hwiZwYuom+HdnIbL+Q4VnNZV2KIb9Czr9VhHu5U8C+19JxVrbqZuemqf3WaqmS7dC/pE
         1lf9X0rkqipnqa/6jCGu6MVuDHVVuQCDOoaaJ+MOQssEVMKSJE+gr7XBkAMh8LIlsbZU
         rt65cwzcoLkv/F7VhjVa9Oek6I7mzoPSPfVZGmR1N0q/VMZwg7+20wGejTp96I5VK9xA
         8fug==
X-Forwarded-Encrypted: i=1; AJvYcCWQfJjCX++QPYW6r+BEsrAHigBvDvVSzu9qSa3EJE2JDXisxcBqAlKlknu4+e5pMPPVxUpsXivH6f3B@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5eXZ+xKlZhXGSc5oIYIOHvqiYQm0mv0JVnnhLD9LNhDkLWApC
	c5Y4sJPq7v6BpyV5Bfb96B6vBr7U67799PMNz8Kv9vpA/pke6XO2+0wR
X-Gm-Gg: AeBDieukIrk++XOmriv1Z7E1dobXNplKyBhEHmmJKvaIqD6GeHpft1Zkc7z7+5JXeyx
	RX3UsFlSA15WPAi5St2cKMCJvyPgJng+TUUwfYF1nEaXWsAdVUkTjuGuUK8uy5h77CK/6rxXjZs
	UGwv+90mjTlmM+X8BNwqmKFLQTCTVkGR88jrtF5b5bDiVI2XRg69VEwkXb+ilWjWsmLXlC7t5Oh
	st1VLxMI4qyGvKRNtibSmFa2qDMY7P75hQ5aicTFxybblB6GdlpYm+aPEbYkq2lp1jmf7XBrfvL
	SjFAA5+k/dANqte3cn7DIXonCQ7ZVnxQ0bHxmjSY4aNaKmeG1vyyjuUODLiqxfNFrA2XET1T7R/
	IBZ7Y+h4zQZ6QSIQOrsXRzQPzTXte5zHgsIjWnl0ZpUStg4CcrRr09Ym5UGCJA/1pQTHbXlxaSl
	NUyOSsfNEKqzHO9A/8I/sXqO8NPEMs91JfLHEYk0bE1wsjk/pX9t+/L4OmaujruTMDNOdrBYDKK
	kkTT3T7i0zRp3JBEUmJncE=
X-Received: by 2002:a05:6a00:bc0b:b0:829:af4a:5ebc with SMTP id d2e1a72fcca58-82d0da284c1mr24255682b3a.7.1775728808218;
        Thu, 09 Apr 2026 03:00:08 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm29113671b3a.42.2026.04.09.03.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:00:07 -0700 (PDT)
From: rajasimandalos@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	metze@samba.org,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 6/9] smb: client: allow nolease option to be reconfigured on remount
Date: Thu,  9 Apr 2026 09:59:23 +0000
Message-ID: <20260409095926.905020-6-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-1-rajasimandalos@gmail.com>
References: <20260409095926.905020-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

The nolease mount option (tcon->no_lease) controls whether the client
requests oplocks/leases from the server during SMB2 opens.  Previously,
changing this option via remount was silently accepted but had no effect
because the value was never synced from the updated ctx to the live tcon.

Add no_lease to smb3_sync_tcon_opts() so the flag is propagated to all
tcons on remount, matching the pattern used by retry, nodelete, and
max_cached_dirs.

When switching to nolease, also close all deferred file handles via
cifs_close_all_deferred_files(). Deferred handles retain their
original lease from the previous open; without closing them, a
subsequent open would reuse the cached handle and inherit the stale
lease, preventing nolease from taking effect.

Both transitions are safe:
 - lease -> nolease: deferred handles are force-closed, and future
   opens get OPLOCK_LEVEL_NONE.
 - nolease -> lease: future opens will request leases; existing
   uncached files remain uncached until reopened.

On reconnect, cifs_reopen_file() reads the current tcon->no_lease and
the server grants (or not) accordingly, so the per-inode cache state
is naturally updated.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 5f0637035172..ce4842e778c4 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1330,8 +1330,12 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 
 		spin_lock(&tcon->tc_lock);
 		tcon->retry = ctx->retry;
+		tcon->no_lease = ctx->no_lease;
 		tcon->max_cached_dirs = ctx->max_cached_dirs;
 		spin_unlock(&tcon->tc_lock);
+
+		if (ctx->no_lease)
+			cifs_close_all_deferred_files(tcon);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 }
-- 
2.43.0

