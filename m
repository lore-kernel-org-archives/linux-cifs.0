Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D23F43F0BE
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 21:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784498060; cv=none; b=isvLwpD3MHCqan8TitAHL8OqvzaqdQUZ4Aib/yK3NmOLCKXsCt54m9pZCA2R+lw2BC8eSKEnmi9vboHKnlZkq35OEsYGQSD4YXhS94gD0xAxtfIOiA9vOelYyyAO/wBo3lov2qWBfvH7McQUQpEzwEKbYrGZbVLIm/ufYJKxcog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784498060; c=relaxed/simple;
	bh=TwZ+kFC5txMYnUisC39CD5kX+fRSgq7OhFWPgxz4Gv8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Oe02hWByqAKxvxmLSunqd7K3ytIK8DSnSguLIhTq7UUycC3jM7c50WuvPvLWLww1TzPol7ZiyNjLK7BMCD4qnX0ylnayuFHtat0eG2Prp4NslAlw+LOmBDVTCE7t7zw+y6JC0d7b+u+7SiXU+cw8yVvYP4hgFvkUi6ny4o4BOpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Waz+x2gV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DFWBeMwU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Waz+x2gV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DFWBeMwU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784498057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EC3EY+6a//1zfXqDJ7g6CwsYlK1WNZGT1N/7vb/3bsM=;
	b=Waz+x2gV4IzrZ8jJB6I6xB/VcWSiYeUWJGo3bZQ2fpIJxRCgEnSM3f9ypq8pHqw1dsEp/7
	Zwfr5DXgdt4VP7WOmcRE2z6HMGCQD9R5vyxo2grLNtjGyaFChGefZ9tL7XxrcDtnt6D2sy
	x1mLDb8yrn1o0vZFCMJVRRhUyead5Hw=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-AEp0NBQrPDu8zu4tQtakJw-1; Sun, 19 Jul 2026 17:54:16 -0400
X-MC-Unique: AEp0NBQrPDu8zu4tQtakJw-1
X-Mimecast-MFC-AGG-ID: AEp0NBQrPDu8zu4tQtakJw_1784498055
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7e9dee2f7b5so8924074a34.1
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 14:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784498055; x=1785102855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EC3EY+6a//1zfXqDJ7g6CwsYlK1WNZGT1N/7vb/3bsM=;
        b=DFWBeMwUGRkpkl6U0W1vcAMzNilt/Vta5Ys34IDbaVd2eUIQMHbRyEPN3MU/d5DWm/
         oUjsbfGBfNo9lTbMqF4laztAINprhmDjZohCBVsbHlzau/CP1E7VsZL/H6ifDahWr37q
         0gVw35FGA52fJS+4gTXNrFjqXTlypDOSTeJNUvcSkXEbJ90gwPajwpXaHZ+M+1d5xQpg
         leweMwIiRfGxbqeh7EmRx1yEvpb17TgpxFQuKRUdOQzENhHtX3r7pPcZfWMJ3IJI2JK0
         HHIWT+IePm53/+7AlXxvYgQAObfU+e4fNqUJzY79GxKOc3nUlcrN5nE7r8t4J2RKbaLk
         bOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784498055; x=1785102855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EC3EY+6a//1zfXqDJ7g6CwsYlK1WNZGT1N/7vb/3bsM=;
        b=FN0FMj/v4cg1RHIOX+i3LZJZqAL09iW49oNAYDauZcwAsC+C0ewgv7NvxcXNA0+bok
         2I9X/QbwmgA20oq+mhBBcNmjn+ywnE5KVMwXLjyDOWJxRJIvHF+izsOwgireNolspeqo
         LpottSfRDN8fCQ/P0jReFDSGlNgI46okINi8SiM3rjztrHcszVunaZ1cn+vxvnkcDZxj
         9ajQ6Kj1xZ4282e0xLhqOZKIsF6NwsZB9l/5O0hurBWoJL1Y2nwhRzsbGzmjGW8TkHfD
         FFcaPLwb+Nu2rVQOELPFg6NmIksm+LCaA2/HI7/J4BN6ksNIK712+ikde07blPEBpEYg
         AltA==
X-Gm-Message-State: AOJu0Yz7Yc2ia18GaB9VAgIhkZD8KvAQC+IrgmD7YfQHon3t3UzLKb3P
	w3GZlGUdRNZK5DjxIL7TsDZM8u3y6mar+W3IiqouTqS4ghFmpj8t8o46Evbk21HaMvqhBk3ap33
	mOoU6Sl0jooP9IfqWzLIU256vvHeGCellx2ZuICJAqRnW1q00Lmgaj+Xe/bScFv+3UHU14BXLak
	yEd1wHd/V2JlepTLqU5px9Ngdum3b+EkCx9kKO8iqaUXtZqaA=
X-Gm-Gg: AfdE7clJXqlmHrGvmwzM5A7IC/tFaxsT05cqiQ//k/DIb8vqjRLEUOJITLZL9o+zCDi
	21i5w/12+dqdU2VC730ES5fk/tZtnOqkEE4PWkSTi8TaPMmxkWZyu0wEC9t/OrYBZxQQoI8qLhP
	5keG6ohJ39M1h8CBwNPOEiEUXq3AHNnwPMvSSDmyup7p1d9tiqnGyijvFFjnXRY8Ajn6RNvnY7z
	eJAI7P8taiMjNP91l8Ny8pmGwakXlyzCd3WwcLncyymiBKP2FE6fyh4+YIlWIPo6niEFqy9sJSr
	kMKds8yYSoKP231K6mge1napbWh3pngfpMN6MqxUegC84+OGn+iYFLR1+/c2Jru0DcK4LPbwLyF
	0kVnWvAbCkIWqBZ3jWbGc5me+5wFrMTVPbuaFzj2tEna6kP+QHYTujFVXUNVS
X-Received: by 2002:a05:6830:8382:b0:7ec:61e4:9d61 with SMTP id 46e09a7af769-7eda08f4c2emr5935711a34.20.1784498055122;
        Sun, 19 Jul 2026 14:54:15 -0700 (PDT)
X-Received: by 2002:a05:6830:8382:b0:7ec:61e4:9d61 with SMTP id 46e09a7af769-7eda08f4c2emr5935702a34.20.1784498054603;
        Sun, 19 Jul 2026 14:54:14 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7edaf98c5f4sm6469018a34.20.2026.07.19.14.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 14:54:14 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH 0/2] cifs: fix attribute cache corruption from concurrent directory operations
Date: Sun, 19 Jul 2026 16:54:10 -0500
Message-ID: <20260719215412.1218034-1-sorenson@redhat.com>
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
readdir (bug 2) was run for 50000 iterations with both patches applied
without hitting either bug.

A reproducer is available at https://github.com/fsorenson/cifs_cache_race_repro/


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

