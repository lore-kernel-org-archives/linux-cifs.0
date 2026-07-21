Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4853346EC87
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 23:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784678161; cv=none; b=YFLWjyrzPCyS2F6oO393b7p80NFE5iYumCENzsWDMZ8V8KwmdTFdxZa5oQyNaN79A0fG8vw01r3pkseADH5QMhnwOfGd+jCdIhkJaeeGX9G8qc6ydednS0K3woG6yoyVqwwyIVhQxvsWbLShLcz7Ih7WXUPPE/WzwqwkwkfJHAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784678161; c=relaxed/simple;
	bh=TXiu+kBFvr67w/7WQTA3y+odpgr97Wx4LBHkkzNfpkk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=G6pynrvWNXcvSZyVloN2bOYBmbi/3lDnqFFb0WnC85wnkGgyDH+1ii1zPJp2knaW2i+IwDfloJwJ2FJe/KVsiV7gU61NuJBzt+xhE+FvU9FeXap5hX7AYbSq+XxzaXnxauEHkjAoZ+dj/DLmDNrLVjsD0CuloibsULuodkSv5Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dd3MC1Lr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WBpNHq/l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dd3MC1Lr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBpNHq/l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784678158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ehxXhI1m/Q5zeXAtc1dZMBrg8jwUuuqDs28nGUsST64=;
	b=Dd3MC1LrC2HUoD2Xq9Decc12/8iyTRpJYf5DzbC5VRZQ1hAo2KyElpJUslbuoFA3/7oCPq
	RwfVAU958T3lQhpTTMHrIcntUxIhDiC9SvqpCLQ3FwqZc5rG1tn6n0FwnVMwvgW0c/qXB7
	h9z4cgFda1D6LE4ZFodkA0gjYuDQ+pk=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-Xwa8crMJOKS7Pyp5TP7vPQ-1; Tue, 21 Jul 2026 19:55:55 -0400
X-MC-Unique: Xwa8crMJOKS7Pyp5TP7vPQ-1
X-Mimecast-MFC-AGG-ID: Xwa8crMJOKS7Pyp5TP7vPQ_1784678155
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-456cde91306so4650093fac.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 16:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784678155; x=1785282955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ehxXhI1m/Q5zeXAtc1dZMBrg8jwUuuqDs28nGUsST64=;
        b=WBpNHq/l4dP7RD8bZgmudb+7IUObuyQfxCGvdyGJBISkROvov6iXD4Jlbi3Jniu4aq
         3QhbEDZ7ygHk7Jl7umtDCdYRYF3vcl23NjxfSozvuCXC10t/DFKIocptIoPEGp0QIYYf
         NPoWM7id4ey99uhxMAwMeEKAudrIqvjmrgskz2dLZ0BQOBq0UzLx5Z4rVHsRf8bHg/uX
         wjGOtl+KOknShz26eSD7V6Lp95hooPDbmJ3x82dUyYEZQaIFWrShY2tVlb2bMLusKVRi
         gz4YuqQke8Tukm83tNtL4ud7QbqquX0E84mlGbs3txQujNNMrc7/UJDR9jmtVTebMP0v
         p2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784678155; x=1785282955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ehxXhI1m/Q5zeXAtc1dZMBrg8jwUuuqDs28nGUsST64=;
        b=mVsb2VutV8V1crQwK/qpKB4XA0RoyvoirDYpcX6uh7NYfBA4JA6pV9oNurECFIRrbL
         Bzc052otc5X93NzO6nvoernM7Bbnb57QVn5OVVqWYPFHlHV9q1RFCVRt0fDlWXlHsAc0
         +Rur9tGGDNjsaSCbLitocQxe1fQm0CCQsc3C5ckmt+bpbzTdIQZM0QnuicTmW8Tiwa3j
         LGdJ/15yOJjK4DD1GMIhFdnROsARmQp+5LP5wcHmuS8yS+8Nyq5b0sbKU9bKVFSbEurg
         vZOVk7w2RoFSwN63WKuAWT+HBpbwxJvUQCab2QeNjgsHi14l35n+NhHcScoi+la2fV+P
         EC5g==
X-Gm-Message-State: AOJu0Yy0ngdLr7ODZtFX8bCzYR+PqQ8Fq4nxeNpS9ix8wmEjVJXsluo/
	AlTl/M9Cy3fUiNbHcVHfd4ZjD9305QyDJwI3HAZop+ezSOWcYvzMxIiqUmjNQe/nL3vPMs+s+jO
	xti5VpLK0VGeKPlOaJU8iofx71XwNTeEuLJCaMmMnMHfyUknjuh1KDExLacE6etE2l8sHhNWRy5
	SsDMnWMAwMDhJD/GHDc6PYQtu7ET7g8exbgrS64oqDnwRX8bY=
X-Gm-Gg: AfdE7ckDlyaqNKGUMnQ5cDqG7J1LRFq/g4JnSMa888DqZvI7Qaoxk7vO9uswThC8wfy
	5dxTyDlJj9UcuFCApUbT3yJvdzPvJKXleN4dxIxoY7PJDwGBCdc5GMMQFHKe1xVcxsYs4WHHwXq
	/cWciH5dEqxZy/yoqt3YdiMhJ6HAqrKc41ooyuygFFGwYsDRQAsIQ3S/yY5YHPyziVwT7zkrt6a
	mGGSHQ7sGs59DUghJxlurUxNZGmiagc3vF8y9rG9U+JOqpQnB7vFp4awGRsUWpz/FuLCA6lfTV5
	WxFLD0artu9eZaxN21ity3D8YZlFrz9YaChyehspqWSIqMmaJ0FihnTgSYIRYKYb7rc6JCDJ5lq
	zDEFNa/yW1Fj6qEUHWkzGan25rra1J7yyOQBfH4O5u5IzPvwXAn41hSWZDpsF
X-Received: by 2002:a05:6820:1797:b0:6a1:50eb:2119 with SMTP id 006d021491bc7-6a536ad63a7mr10598628eaf.61.1784678154789;
        Tue, 21 Jul 2026 16:55:54 -0700 (PDT)
X-Received: by 2002:a05:6820:1797:b0:6a1:50eb:2119 with SMTP id 006d021491bc7-6a536ad63a7mr10598608eaf.61.1784678154253;
        Tue, 21 Jul 2026 16:55:54 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-457673e1f1fsm731805fac.9.2026.07.21.16.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 16:55:53 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH v4 0/2] cifs: fix readdir stale size bug and deferred-close reference leak
Date: Tue, 21 Jul 2026 18:55:50 -0500
Message-ID: <20260721235552.1839780-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two bugs in the cifs/smb3 client: a race where
readdir overwrites cached file sizes with stale server directory
metadata, and a pre-existing reference leak in the deferred-close
drain paths.

Patch 1 fixes a bug where stat() returns the wrong file size after a
write+close or rename against Windows Server.  Windows Server's directory
enumeration metadata (EndOfFile) lags behind the actual file state
immediately after a modification.  If a concurrent readdir() runs during
that lag, it overwrites the correctly cached i_size with the stale server
value; a subsequent stat() within the actimeo window then returns the
wrong size.  Both the write+close and rename cases share the same root
cause.  The bug does not reproduce against Samba or with actimeo=0.

The fix adds cifsInodeInfo->time_last_write, stamped at writable close
and at truncate.  is_size_safe_to_change() blocks readdir from updating
i_size within acregmax jiffies of that timestamp.  When a size update is
blocked and the server value differs from the cached one, the attribute
cache is invalidated, forcing a fresh QUERY_INFO on the next stat().
time_last_write is refreshed at the actual server close in
smb2_deferred_work_close() and the cifs_close_deferred_file*() drain
paths to ensure the protection window is anchored to the real close time
when closetimeo > 0.

Testing
-------
Reproduces against Windows Server 2022 with SMB 3.1.1 with multiple
concurrent threads; does not reproduce against Samba or with actimeo=0.
A reproducer exercising concurrent write+close+stat and rename+stat with
concurrent readdir was run for 50,000+ iterations without hitting the bug.

A reproducer is available at https://github.com/fsorenson/cifs_cache_race_repro/


Patch 2 addresses a pre-existing reference leak in the deferred-close
drain paths; when cancel_delayed_work() succeeds but the subsequent
kmalloc_obj() for the processing list fails, the cancelled work's
cifsFileInfo reference is silently dropped without calling
_cifsFileInfo_put(), leaking the reference and the open server handle.

The fix saves the affected cfile and calls _cifsFileInfo_put() after
releasing the lock.


v4: add memory barrier comments required by checkpatch; fix pre-existing
    cifsFileInfo reference leak on kmalloc failure in deferred-close
    drain paths (patch 2)
v3: replace CIFS_INO_LOCK serialization approach with time_last_write
    tracking; single patch covered both observed symptoms
v2: fix malformed patch

Frank Sorenson (2):
  cifs: prevent readdir from changing file size due to stale directory metadata
  cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths

 fs/smb/client/cifsfs.c   |  1 +
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 69 +++++++++++++++++++++++++++++++++++++++++++----
 fs/smb/client/inode.c    |  6 ++++
 fs/smb/client/misc.c     | 72 +++++++++++++++++++++++++++++++++++++++++++------
 5 files changed, 135 insertions(+), 14 deletions(-)

--
2.55.0

