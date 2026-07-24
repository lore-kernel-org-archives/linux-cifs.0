Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B75F282F05
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 16:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784910645; cv=none; b=Y5ePYM4uYLE20+fLixv/pymBXKvacZLY7NP6lHkG4lWhch+pWw30GuIH/O8GmVZpZodSduZmuTVDXbfdHQpbt31aE4BWo2hOjfpUU1x8J7uXc8ZBt6kv75i++B4FQh20md6KTpoWzjeIYT7PdCcEy83uSdAt176Njk8gjspV2SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784910645; c=relaxed/simple;
	bh=m4NfqStn3dHSVwJlePm/RShsjylU/+Xu2ihfWAISPJE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uSY11t507J9YaKfEHaIzKJ2lr0pTzmrGNV/bwvD/HdlZ/zCrx7bsy1W+G7XKYaCM231145G+XmF1hBuyK7BD2DK9CXF0ruLPi6z2Mzw+1UOfy+8gIdu8oFMxpKIFBwnNYwrKGcOA9W2f7dvfaP3nhfgirx3tTTBukEYn2fxSygY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bi86NL4E; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nzTjL42V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bi86NL4E";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nzTjL42V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784910642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Te+0iAWkx5T+cuweZo8p6ImAj4HdRDh4EEN8jv/GWA0=;
	b=bi86NL4E3CsqIY7tNOfDQVNqqz70vIu5ebXfqkgUkzIFg4HfUDfAgZnf70jMYflPLPu6Fh
	1KG1ch2H1Ole00mW6GlCZuVcGnxJczApqVXUOTntsGMZkP8USIR+hdBHjdPjMpIAwYDJyz
	iHH4Pw/mHX6UtiPM3M+/O6d6fHtkjS0=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-I3Ruon5VNP222qAgH8SuUg-1; Fri, 24 Jul 2026 12:30:41 -0400
X-MC-Unique: I3Ruon5VNP222qAgH8SuUg-1
X-Mimecast-MFC-AGG-ID: I3Ruon5VNP222qAgH8SuUg_1784910639
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e6b5976d74so555109a34.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 09:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784910639; x=1785515439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Te+0iAWkx5T+cuweZo8p6ImAj4HdRDh4EEN8jv/GWA0=;
        b=nzTjL42VbayX6652kKhATt4YXGAXVk3M/g4D6bSwIliAJH55B68DLkdHxPhG3ty/3x
         b5tI9+LjEOXBgzN91rfnLFKik8iH8pVs++2KDXu2mjsHRA+4spcw2XSe8WV3rn8IaHCT
         y0Jx7Db6pWSJZiBmtaQBqOiwlr0DcN3sgisWJJV8sZjo/qUqDgLecUTyQuzNcRd5t/Lx
         f/pCAPML+wL3s1Es+p3ymDcvs0c2swspSDN2pvCxzoRelr4O9LXnCvMnJWBq5IqRVnUx
         yjSaTGFWZzQg91EFYLIGyrbpJ6Q+/HRGJ8S2qx3bfB/tnBRZAKIbP5tCYu1cZn2MfPGn
         LMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784910639; x=1785515439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Te+0iAWkx5T+cuweZo8p6ImAj4HdRDh4EEN8jv/GWA0=;
        b=TNycV6vA6IhwfdF9jRB+5wi8v8UH9eUuvR35IxmX4NuJjrMehDhuJN0axpudqKrFvO
         eZ1AhiEm1vJVXOeJCHA1VldO2MO4v1TIlQUMJ4lr/8ib0RmFw8b/vzXEjlsl69v36tZ8
         d7pZPunYeSMvwZFaI3c2YEJ8ZhmFP86kTPM80Xx0fWstkf3v71GEDX2frUn7hA9OgLig
         lGJyNOLuB7oFLkH4t7y/RucRnKXxOlpTWiHkwmJMneusBQkqhyvYLT3CL8/F+wQYx4ei
         B7ce6zZy/7cWHm4fW+xVGNWxUH+qh8AA4l7PL+/j/4ibPKyjcqQb5HQJhUesiLStAJKv
         3zOw==
X-Gm-Message-State: AOJu0YzWhTAn2jYvYPaOfGD+62szurBE4lxcZ8Ysnh7Rz4d3KYi3xha3
	s6ZhmoW2+vDPbopt5VbVH75WQka7aD318fg9qG4pDxAVVOIoq8E+NL1WMgKqhjdHMJ6gY4D3BaY
	KmzdXNBxabaCNNKtvKTHxCVBFgrShag5pCiD6YrwpUNReq5vk/2Pb7CUe8Y3jtNHxmNdG5wEtK8
	jb0XdTi5eWKI1xxK8VOTKObbJa4zQT6nxY/MzI8gjyUF+PW0M=
X-Gm-Gg: AR+sD11LtqdXdwWi0krp+6RoZCNjJURPpMS8qWs8UKNh832+SIf0ho0SE0aWVewvVbC
	bEJrXUXq4Nzb69YSac6Iq7MMI4A2ZZIfxOH2kEKCQBimpvN1KWGtvxOL3RF6PAIfECgmOy3eYzK
	bVYq1gZjf8EdcIfUwjUTOMK/myyPl4oTwnfUtcP7Ck6PwBNRe4x3Nrw5ltwGiyo8Dhd+2UIkK4T
	c14PrL3vy7YEXtcqTDUH1d/wW0OKnHDoocYSDKGibJGfDOrGz+0gZVjotryK/KSpN+aRCI+RYHu
	IYxjTZfuVq48nChTqkuJA9gr0yedLBvesToC+dMQGb8+7z5e3OJU/e3b3iukpHR7DvoosI6JkEE
	zQjnYNvTGDh5Xb1AVbdfZBH168IKoSWE9XZEa1NWaH/HwbH47YCPVBQfEgAgu
X-Received: by 2002:a05:6830:67f6:b0:7e9:df18:c53a with SMTP id 46e09a7af769-7ee4405d470mr5419028a34.14.1784910639436;
        Fri, 24 Jul 2026 09:30:39 -0700 (PDT)
X-Received: by 2002:a05:6830:67f6:b0:7e9:df18:c53a with SMTP id 46e09a7af769-7ee4405d470mr5418994a34.14.1784910638820;
        Fri, 24 Jul 2026 09:30:38 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee2a03d30asm6351819a34.18.2026.07.24.09.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 09:30:38 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH 0/2] cifs: follow-on fixes to time_last_write mechanism
Date: Fri, 24 Jul 2026 11:30:34 -0500
Message-ID: <20260724163036.2670328-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series addresses two correctness issues in commit e8a8d54c2d50
("cifs: prevent readdir from changing file size due to stale directory
metadata"), which introduced the time_last_write field to protect cached
file sizes from stale Windows Server directory enumeration metadata.

Patch 1 consolidates the time_last_write stamp into _cifsFileInfo_put().
The original commit scattered the stamp across cifs_close(),
smb2_deferred_work_close(), and three deferred-close drain functions in
misc.c.  This missed the case where background I/O holds the final file
reference after userspace close() returns -- the stamp was anchored to
the earlier userspace-close time rather than the actual server close,
allowing the protection window to expire before the handle was removed
from openFileList.  Moving the stamp into _cifsFileInfo_put() under
open_file_lock provides a single canonical location that covers all close
paths and uses the spinlock's store-release/load-acquire pairing with
is_inode_writable() for correct memory ordering.

Patch 2 fixes the stamp placement in the setattr/truncate paths.
cifs_file_set_size() calls cifs_setsize() on success, which calls
i_size_write() and updates i_size.  The subsequent check
attrs->ia_size != i_size_read() therefore always evaluates false after a
successful cifs_file_set_size(), making the stamp dead code -- the
truncate path was completely unprotected.  The fix moves the stamp to
before the RPC call, guarded by attrs->ia_size != i_size_read() to
exclude no-op same-size ftruncate(2) calls.  On failure the stamp is
left in place rather than restored: restoring a stale snapshot (prev_tlw)
could silently erase a concurrent _cifsFileInfo_put() close stamp if that
close arrived between the READ_ONCE and the smp_store_release.  readdir
is suppressed until the stamp expires; stat() is unaffected because
cifs_revalidate_dentry_attr() uses from_readdir=false, bypassing the
time_last_write check entirely and always returning an authoritative
QUERY_INFO result.

Frank Sorenson (2):
  cifs: consolidate time_last_write stamp into _cifsFileInfo_put()
  cifs: fix time_last_write stamp placement in setattr/truncate paths

 fs/smb/client/file.c  | 37 ++++++++++++++++---------------------
 fs/smb/client/inode.c | 26 ++++++++++++++++++++++----
 fs/smb/client/misc.c  | 51 ++++++---------------------------------------------
 3 files changed, 44 insertions(+), 70 deletions(-)

--
2.55.0

