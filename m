Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A833822AE
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 16:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565350; cv=none; b=rD6esLA0PttzUG8kYcEgjbF+aV0MWBADJX5L/RB7kbJk4Z4vgKyp5PW9iMqW5P6HKsPPUbXlaybfdHpYY2RFXeZm09IpSxGgT6N0goEA5RVnA+MuLTb9AktIy5K6Ru/WBJVNDlwFT0XIAB1vajxj/NntCBFRvGU92VJimuGnFMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565350; c=relaxed/simple;
	bh=qnhIt+xpNt2J/xVyWV5y8zj9+aOkEGQiDmQBlhlTCYw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=H/9MIliqXMzSB7gwU2YCbVeDWE4trfcCy1IGRJ+HrukFUf1OiRN8kO40bzNezOmGFOQdBqTZb9cvJSNDv+Zwt3x7KS/MkGHSxNflsf8ZU3UnJqhq7qDxW+iCYoZYailaDElP1UPigd1mQjtfdx1Ym4ZcD+D+gOB8svyOdTLE7DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JmngBMfn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ieF/u+Cx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JmngBMfn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ieF/u+Cx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784565348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lP7o+lzN9Ard8VipcZAEZJJmRkZkQmw+8AwZ67JSzeQ=;
	b=JmngBMfnu4LOl0zk4+zaVou0NQe50zQG5/5JUiny80XGWrx6sGTN4lmk0uq1o8Vy78u8cx
	AXAhwQK7wKZwNjIVsC2Um9qyk+TQl/RNzQibyUOwulsMUSbydV0Pr4g57nm+7/VrrjmV2h
	X3xH28MLDyUkChHL8zCfeP35vdUJof0=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601--QfiC3cfPIugAULHAy5trQ-1; Mon, 20 Jul 2026 12:35:44 -0400
X-MC-Unique: -QfiC3cfPIugAULHAy5trQ-1
X-Mimecast-MFC-AGG-ID: -QfiC3cfPIugAULHAy5trQ_1784565344
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7eb89852728so6642489a34.3
        for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 09:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784565344; x=1785170144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lP7o+lzN9Ard8VipcZAEZJJmRkZkQmw+8AwZ67JSzeQ=;
        b=ieF/u+Cxbqe0kec+hJyUaEFP9XnPHtd4skgyIjxmC3+4dmCghwO86ZSzcj7T08VSdW
         slpVDLSlpt7M/0nmI6oiomWpSUTrh3cG+IfvTjIr9zXJHAxeNTwwO5g4orHV4fBc8XeV
         L0zgPYZiO0nTzcyf75efYwNftIfaPubBtB3oi0ZCn8zE4Wk366o3XMiepqLaPMGWWKdG
         DCYbldNtzA0qOhT9iUfP9VA809KkfKLximXzN3qVJbxj8oKsJhhVE3uJhwiy3b6NPdU6
         D49cbL2BXDl0rR8DszweRG/AmcDAfD17HXxi+tfuzP9VjvqolE0UE1RoaHxt+ooYOHsk
         g2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784565344; x=1785170144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lP7o+lzN9Ard8VipcZAEZJJmRkZkQmw+8AwZ67JSzeQ=;
        b=f9dDvtmBeM634zYwEIYVhHLkbJa5t8xNS6a8V5QPvV0rWLNvHIDaKVPnxzhiMzOb+g
         JRryq/ZfRIH5nYyNEzmOvM3WxSAntwzS4+I4ein6w7uhOyWXji62QllJ+eA86hujJc35
         PG0qUsg/jcGFm7xD81cslhZVYUaxGCFzEwDCppeIXE7pFW6gFDmtgcmalIs6cBJ596BG
         hqTzvyu/x4NE3zaeFta3ymQ5hr2BkUZldVw3Mf/nSSHZ4q04IuK85ytt/9/tMDFfXW3T
         sHkj34tR1TmTZJpoOXSqAzRA0hAlVq4JNJiY/5/WbNO5cbSADp30CMazGl3YEFVW38Sv
         H8mQ==
X-Gm-Message-State: AOJu0Yx6POkPWXpj+oZT0St44h5ITun5neZ3om6ZrFIPi1eBp3Lvrg8X
	twHjKtiYuQbItaoyUVs4EBpAIig2Q71ZT/PhgarVV+u2ecCOJ+XLJV2BcFd6ffk8H7v6qdkoc6T
	4zTBgK2JBMlm1hn95Py934IbFBDpSpO/35oXt70FOnKKTjVytGVlH4pzWcbN+053kneNBnX2B52
	1vd3sWVxx2VKpj0f7z+c7RM5o4Zziv7MlOgXJo3WABF0Yl3fg=
X-Gm-Gg: AfdE7cnFUlqt0ibag8/nCpruYVMdHUJoqKCOqDhYD6jRdCYo/DHmBPdCGpifgt6nKMr
	CqYYuEo1iz4zZiQKkhogmAEo+z7P0DwoLpVDQWLOFjEnyBEPokVVxvmWPWHuAc/Ei74tz2/TKFr
	9B3TDNaI67bnTi8t2luWa6N1IgrN96rZGzcW8N2eAwZljGWslcl6/8RNdAzbAyHx0/RFoqBb8E3
	cJpD4Nl4ier/7lwvRC3rNZi9EsFOdzUuCBZ49N+4tKtaj7bXnaYG2jQ7sdVIIgmBxrFeew1bHSH
	N+q3Oj2TXFYurmS2l6HLMo1VU3qlkWcX4hP5woV0DLfwzuo8Uyqp03b558D6r99TrG33HEvjppc
	Aq+DabwM00kKr9npcTnRo9j0a27TKhtt3sNVJdbX9VfviH0PoDhKtok/YMgfF
X-Received: by 2002:a05:6830:82c6:b0:7e9:bf64:b70b with SMTP id 46e09a7af769-7eda06fdb40mr7476895a34.1.1784565343712;
        Mon, 20 Jul 2026 09:35:43 -0700 (PDT)
X-Received: by 2002:a05:6830:82c6:b0:7e9:bf64:b70b with SMTP id 46e09a7af769-7eda06fdb40mr7476872a34.1.1784565343093;
        Mon, 20 Jul 2026 09:35:43 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7edaf9cd6f4sm8662312a34.23.2026.07.20.09.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 09:35:42 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH v2 0/2] cifs: fix attribute cache corruption from concurrent directory operations
Date: Mon, 20 Jul 2026 11:35:39 -0500
Message-ID: <20260720163541.1428872-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two distinct but related race conditions in the
cifs/smb3 client where directory operations (lease breaks and readdir)
can corrupt the attribute cache of recently modified files, causing
subsequent stat() calls to return incorrect file sizes or fail with EIO.

Both issues stem from the fundamental problem that directory-level
metadata -- whether from a lease break notification or a readdir
enumeration -- is not strictly synchronized with the authoritative state
of open or recently closed files.

Both bugs require as few as 2 concurrent threads performing directory
and file operations simultaneously.  They only reproduce against Windows
Server (where directory lease breaks occur and directory enumeration
metadata lags behind file state); they do not reproduce against Samba.
The workaround for both is to mount with actimeo=0, which forces every
stat() to query the server directly rather than trusting the cache.


Patch 1: cifs: serialize readdir with directory cache invalidation from lease breaks
-------------------------------------------------------------------------------------
When a directory lease break occurs while readdir is actively traversing
the directory cache, the lease break handler calls cifs_revalidate_mapping()
-> cifs_zap_mapping() while holding CIFS_INO_LOCK, racing with
cifs_readdir() which traverses the same cache without that lock.  The
resulting corruption causes subsequent stat() calls to return wrong file
sizes or EIO errors.

Fix: acquire CIFS_INO_LOCK at the start of cifs_readdir() so that lease
break cache invalidation and readdir traversal are mutually exclusive.


Patch 2: cifs: prevent readdir from changing file size due to stale directory metadata
---------------------------------------------------------------------------------------
After writing to a file and closing it, concurrent readdir() can fetch
stale directory metadata from the server (EndOfFile=0 for a recently
written file) and overwrite the correct cached i_size.  The race window
is between cifsFileInfo_put() removing the handle from openFileList
(after which is_inode_writable() returns false) and stat() being called.
The existing is_size_safe_to_change() check only blocks this when an
active RW lease was held -- not after the last writable handle is closed.

Fix: track the time of the last writable close or truncate in a new
cifsInodeInfo->time_last_write field.  If readdir attempts to change
i_size within acregmax jiffies of that timestamp, the update is
suppressed.  When the suppressed size differs from the cached value,
cifs_i->time is set to zero, forcing the next stat() to issue a fresh
QUERY_INFO RPC.  QUERY_INFO returns the authoritative size from the
server's open-file table rather than stale directory enumeration metadata,
which is the same path taken by actimeo=0.


Testing
-------
Both bugs reproduce against Windows Server 2022 with SMB 3.1.1 and
at least 2 concurrent threads.  A reproducer program exercising
concurrent rename+readdir (bug 1) and write+close+stat with concurrent
readdir (bug 2) was run for 400000 iterations with both patches applied
without hitting either bug.

A reproducer is available at https://github.com/fsorenson/cifs_cache_race_repro/


v2: fix malformed patch 2


Frank Sorenson (2):
  cifs: serialize readdir with directory cache invalidation from lease breaks
  cifs: prevent readdir from changing file size due to stale directory metadata

 fs/smb/client/cifsfs.c   |  1 +
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/cifsproto.h |  1 +
 fs/smb/client/file.c     | 24 +++++++++++++++++++++---
 fs/smb/client/inode.c    |  6 +++++-
 fs/smb/client/readdir.c  | 12 ++++++++++++
 6 files changed, 45 insertions(+), 4 deletions(-)

--
2.55.0

