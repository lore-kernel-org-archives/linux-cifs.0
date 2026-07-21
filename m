Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8517B3346A6
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655573; cv=none; b=JqLJRmr83JGC+nFByjLWQbA4nJQs3NN+I7uAj0FTcjJuokWYTesQKLP1H51swKIES2xNWTnWD1LnYmlbil5+rWo6SMBxuAsNM7mUMF/AukcXoamGB3pnH5DdMg0nn6wt2JHvheYYuKK+SfJZv5813ifLQVSm0tKp/0AIfbbpfTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655573; c=relaxed/simple;
	bh=+L8MdUEvTj2MjZqUrMqpGL/lUYgZeDaNp0Uz5WhYpkQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=aLScCvLjoD3UWal+ovO5dww4D2bS/nNG/fuy+k10pc7ALinHaDQ/Ikw9r8T3G7OyS/AcMgcIHj//cmVILJcXgHlJTCxsTk/XpBzWEfJILhHtx+JG91tAZ9hn97dZUbWb2qjqwGDPpJMTqarAliP/Lz2Y2681138gn1VPt+Jzp7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g+PwvBBW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hgEHwe2y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g+PwvBBW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hgEHwe2y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784655570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gJz5iUlyv/NdPbFpRN3csUjLJoXPSpQQJIaHJrreKsM=;
	b=g+PwvBBWf6WDgmMgfCUTZNU9hfXboiqZcb7AgvrluZeswa9E9P2loeQ1hwrXwGDGSeuWYs
	ffCQQS3r6b78tw6f8ZhpIPVCUhT2rCV4ljPmn5F6Ez/Z+aD34tFnNugDJjOKvvTX12bZnC
	0pPxD4OxxMmY1sVzpohPNwc5TQrAAZk=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-jbY7V12FPd6lYERa6e3CVQ-1; Tue, 21 Jul 2026 13:39:28 -0400
X-MC-Unique: jbY7V12FPd6lYERa6e3CVQ-1
X-Mimecast-MFC-AGG-ID: jbY7V12FPd6lYERa6e3CVQ_1784655567
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-4567d0ff357so6421155fac.2
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 10:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784655567; x=1785260367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gJz5iUlyv/NdPbFpRN3csUjLJoXPSpQQJIaHJrreKsM=;
        b=hgEHwe2yCU8paNmXdFMkt8BpwtGdCM4KtsnsBpkkoP6emK/MMofmtsEH7E/QOcyTsq
         1f0/Djpw8Ys71gJRMJkB9MaJi0rupQBonisnm2AOmERX+wAAtRRp7p10nwUj7K2brZ4v
         nJxA8s5w8YBSO1ptLs1/ksLQPLo8VAdHvFtIN8nT68/Ov9jKYHsEE+B6nhs2cMXLQrER
         /k71go2/TfvwbarKiKOBkeAmS5gKGYdLC5MqXoS3RvkOvVy7TlnWl/gbFcJfaSerr4WD
         tGH5MN/On525LK3MYtBbfrk2ylUfnETBtqC19FQF9+SJiZRd0aVim/pQPlEFCDJAwFFj
         SEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655567; x=1785260367;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gJz5iUlyv/NdPbFpRN3csUjLJoXPSpQQJIaHJrreKsM=;
        b=jwLhi523FVvUlWInhCoed4DCEQwYgm0L9QqpXR4eMk2NOxKH0MIP6gqUn+pw6uPpL1
         /ruRTnrHl76xDB8skXt8S8jAoJXXhE3AMxeYehApduyT0KFqM/Mgcni/SmKQ0sKap4hz
         UTRyGsX4W+yjGm4w5wbU7bBAkaj6Mg8PeLH6dETzto2gZZG9VHvHZa3PJn9KMPyYZGdP
         xNTdu+qd9XjmPT5zFrE4zvhiIsm7kTg3Pf8kudiJDf1C1cPQzWNZDXyK8tR3XQw2nMTO
         ZoUEvznIqrhmDZPEYzHKp2Ic3XdZb5BrOHktWSTGgoV92QSicYj6uv7JYmz9emB+zppQ
         Skrg==
X-Gm-Message-State: AOJu0YxWUbIs4YDBAuUqBsh/TlKgT+gGJQ+WQJ4XzWR+oCuAI/wiWEr6
	tDIVNiWAPNiMhGPKmPDKwD8wzDBxf7Kc/89MX1IsFhFIsX3BIDJSidb0JV5dnlmpd+dqJQonm7d
	WuQYbk71wKIpeaE+BjvQtKoGFeXgcx+DkgUYyoLUSqueZUwBSs38BpobZqZ0ShQ9xAObvbZAeXd
	GPDYvajwiI4Up/Tpad4RxoctgEjUYLmpUbMmFOhkUCX8WISAY=
X-Gm-Gg: AfdE7ckli4Dr/nilp8gFST94NdR122rGfv2LbMtBgOBEDeHjSoNmm/55wOAtzir41ar
	mL9Po/3dGltYXByp9bBHJTWxZY63Cvan3+d+Vx7sBzIA53y1QQ2uAPLHShjGwesc8NFpksbUP1m
	p2hKsvkLJE0iFiTQ3QRGzav9yzfie+yaxkk9gPvH+Jck6uO8cRPgCSmO0GH4X2jl4RK66p1Qiz/
	M5oEyUIBwX1a6xyQidT6pG7riEa1cqHiK38oGfAaf715O6RyQ05Pyw33UBBknJCH7ln7uzltbcf
	Hkg8N8MqWOMxijiL13bWeT80BMjQnzrpcyd0ypMvUvO5jNFV/XeE4vHQ9w7LauCrG8/InO1z9P4
	F+ryuQboDzBB4hwpki9Fx6MKGVn6FpVkKzf4gzXS6B6EYFZpIl5YUWVseM2Jl
X-Received: by 2002:a05:6871:6984:b0:447:1ceb:52d3 with SMTP id 586e51a60fabf-456903ee8b0mr10048818fac.31.1784655562420;
        Tue, 21 Jul 2026 10:39:22 -0700 (PDT)
X-Received: by 2002:a05:6871:6984:b0:447:1ceb:52d3 with SMTP id 586e51a60fabf-456903ee8b0mr10048777fac.31.1784655561875;
        Tue, 21 Jul 2026 10:39:21 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-457673e1f1fsm86696fac.9.2026.07.21.10.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:39:21 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH v3] cifs: prevent readdir from changing file size due to stale directory metadata
Date: Tue, 21 Jul 2026 12:39:18 -0500
Message-ID: <20260721173919.1762653-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Windows Server's directory enumeration metadata lags behind the actual
file state immediately after a local modification.  If a concurrent
readdir() runs while this lag exists, it overwrites the correct locally-
cached i_size with the stale value from the server's directory listing.
A subsequent stat() within the actimeo window returns the wrong size.

This manifests in two ways:

  - After write+close: stat() returns 0 for a file just written
  - After rename: stat() on the renamed file returns 0

Both are the same root cause.  The bug does not reproduce against Samba
(no directory metadata lag) or with actimeo=0 (bypasses the attribute
cache).

The existing is_size_safe_to_change() check only blocked stale readdir
size updates while an active RW lease was held.  It does not protect
the window after the last writable handle closes, which is when the
race occurs.

The fix adds cifsInodeInfo->time_last_write, stamped at writable close
and at truncate.  is_size_safe_to_change() blocks readdir from updating
i_size within acregmax jiffies of that timestamp.  When a size update is
blocked and the server value differs from the cached one, the attribute
cache is invalidated, forcing a fresh QUERY_INFO on the next stat() that
returns the authoritative size from the server's open-file table rather
than the stale directory enumeration.

time_last_write is refreshed at the actual server close in
smb2_deferred_work_close() and in the cifs_close_deferred_file*() drain
paths (triggered by lease/oplock breaks and tcon teardown) to ensure the
protection window is anchored to the real close time when closetimeo > 0.

Memory ordering: time_last_write uses smp_store_release() at all write
sites.  For the close path, the spinlock release in _cifsFileInfo_put()
forms the store-release that pairs with is_inode_writable()'s
spin_lock() (load-acquire), guaranteeing that the subsequent
smp_load_acquire() on time_last_write observes any concurrent close.
The setattr path uses smp_store_release() directly, relying on
acquire-release semantics; store propagation (nanoseconds) is negligible
relative to acregmax (seconds).

Testing
-------
Reproduces against Windows Server 2022 with SMB 3.1.1 with multiple
concurrent threads; does not reproduce against Samba or with actimeo=0.
A reproducer exercising concurrent write+close+stat and rename+stat with
concurrent readdir was run for 50,000+ iterations without hitting the bug.

A reproducer is available at https://github.com/fsorenson/cifs_cache_race_repro/

v3: replace CIFS_INO_LOCK serialization approach with time_last_write
    tracking; single patch now covers both observed symptoms
v2: fix malformed patch

Frank Sorenson (1):
  cifs: prevent readdir from changing file size due to stale directory metadata

 fs/smb/client/cifsfs.c   |  1 +
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 64 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/smb/client/inode.c    |  4 +++
 fs/smb/client/misc.c     | 21 +++++++++++++---
 5 files changed, 83 insertions(+), 8 deletions(-)

--
2.55.0

