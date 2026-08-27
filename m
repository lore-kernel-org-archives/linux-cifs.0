Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2943E3D90
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 09:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787823531; cv=none; b=YSOWlWbNywPt+dwZlhEzqWc1x5hQzgrJ3uykw80Gs0rC8nFFmEsQO3CmKKK9+OmZ7eQcPrRakTiwfOTKDd3nRK0XmAXSLOlxlVH/LyogTwlr44fJ+XIsbR7yyKXb7MwMN2SpQnG30s4eCl32iBebJW8r3hgzq0AGV0u581y5J7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787823531; c=relaxed/simple;
	bh=xjb5979/QIug4PmWxujJWqtP1uK1jBCSYMrRh2EIv5s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ntWLrYdywn0qIUQyroyfi3snIc050H6X+zfldYxlQ63gqZPrPhxDdF331Oq3FAiIm2O48vVXK/h7ZqXwTmP5qcXABTXLDlkb1pBmPPPVLqNzWzYl/M0M+jiIr6ZfjujeMJcARLs6bNmvDa3TMjgMRfg0gKptlSPWSCfuO1eD8nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UG4qMzy0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UG4qMzy0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787823527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kULfUyQq7EqkKb8DB+KYwFU87ezqhr1+/Exo1PKTlDQ=;
	b=UG4qMzy0C2YMiYzD/nN2KIDAWjSMy6sT8feghXRhzQwrHzJk/Ojt3gAo/bn5IXqvClSEJk
	F0GqloHyn0KQceivBwqbpgIr3vmntMzuDYp/zMc05erngubdzTpfNZqoJa0Tt1E80FZ0wl
	6KII4BQT8C4gvkRiMoMcYWUDSSwvnHM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-Jlguz078NyalceJlyShADQ-1; Thu,
 27 Aug 2026 05:38:43 -0400
X-MC-Unique: Jlguz078NyalceJlyShADQ-1
X-Mimecast-MFC-AGG-ID: Jlguz078NyalceJlyShADQ_1787823521
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C3561801344;
	Thu, 27 Aug 2026 09:38:41 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 92B661955F04;
	Thu, 27 Aug 2026 09:38:38 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/10] netfs, cachefiles: Miscellaneous fixes
Date: Thu, 27 Aug 2026 10:38:15 +0100
Message-ID: <20260827093828.1956211-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Christian,

Here are some miscellaneous fixes for netfslib and one for cachefiles, if
you could pick them up?

The first six are all in unbuffered/DIO write:

 (1) Fix an uninitialised return value from netfs_unbuffered_write().

 (2) Fix the normal error return, preferring partial transfer size over
     request error over immediate error (e.g. EINTR).

 (3) Fix the async error return, preferring partial transfer size over
     error.

 (4) Fix the update of i_size on partial transfer ending in an error.

 (5) Fix a subrequest leak in an error path.

 (6) Fix the code to handle subrequest allocation failure.

Then there's:

 (7) Fix synchronisation issues with using a progressive rolling buffer for
     readahead by fetching everything into it upfront so that the issues
     don't arise.  Dropping the refs so acquired is deferred until after
     I/O is begun.

 (8) Change the marking of folios to be copied to the cache to be done
     whilst subreqs are being issued rather than at the time they're
     collected.  Whilst this is not strictly a fix, it means that the
     collector thread doesn't need to try and keep track of that, which
     means that delayed progress reporting will not be a problem in patch
     (9).

 (9) Fix read progress reporting to avoid 64-bit tearing on a 32-bit
     machine.  This has been modified from the previous submission as part
     of a different series to take account of a sashiko reported issue[1].

(10) Fix a potential UAF/KASAN warning reported by sashiko[1] in cachefiles
     in which the coherency data buffer is cast to a __be64* and
     dereferenced in a tracepoint - even though it might not be at least
     that large (or aligned).

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

Changes
=======
ver #3)
- Fixed a number of issues reported by Sashiko[3]:
  - Fixed netfs_unbuffered_write() to return -ENOMEM to async writes too.
  - Added a patch to preload the entire readahead folio collection up front
    to avoid producer-consumer synchronisation issues.
  - Added a patch to premark buffered read folios with whether or not
    they're going to require caching so that the read-progress fix works
    correctly.

ver #2)
- Imported a patch to add subreq alloc failure handling in unbuffered/DIO
  write.
- Fixed a number of issues reported by Sashiko[2]:
  - Added four patches to fix bugs in unbuffered/DIO write.
  - Added a patch to fix readahead rolling buffer issues.
  - Fixed the cachefiles xattr stuff to use max() not min() when
    allocating.
  - Fixed the cachefiles trace comment with regard to alignment.
  - Fixed netfs_read_set_unlock_at() to use folioq_count(), not
    folio_nr_slots().

[1] https://sashiko.dev/#/patchset/20260810144746.574036-1-dhowells%40redhat.com
[2] https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
[3] https://sashiko.dev/#/patchset/20260825132045.1000787-1-dhowells%40redhat.com

David Howells (8):
  netfs: Fix unbuffered/DIO write partial transfer error return
  netfs: Fix error vs transferred passed to ->ki_complete()
  netfs: Fix i_size update for partial transfer
  netfs: Fix subreq ref leak
  netfs: Fix readahead synchronisation issues by loading all folios
    upfront
  netfs: Mark folios with COPY_TO_CACHE whilst issuing subreqs
  netfs: Fix read progress reporting
  cachefiles: Fix potential UAF/KASAN warning

Edward Adam Davis (1):
  netfs: break unbuffered write when netfs_alloc_subrequest() fails

Karl Mehltretter (1):
  netfs: Fix uninitialized return value in netfs_unbuffered_write()

 fs/cachefiles/xattr.c             |  16 +--
 fs/netfs/buffered_read.c          | 165 ++++++++++++++++++++++--------
 fs/netfs/direct_write.c           |  31 ++++--
 fs/netfs/internal.h               |   2 +
 fs/netfs/misc.c                   |  19 ++++
 fs/netfs/objects.c                |  32 +++---
 fs/netfs/read_collect.c           | 103 ++++++++++++-------
 fs/netfs/read_pgpriv2.c           |  13 ++-
 fs/netfs/read_retry.c             |   7 ++
 fs/netfs/read_single.c            |   2 +
 fs/netfs/rolling_buffer.c         |  81 +++++++++------
 fs/netfs/write_issue.c            |   2 +
 include/linux/netfs.h             |   5 +-
 include/linux/rolling_buffer.h    |   6 +-
 include/trace/events/cachefiles.h |  19 +++-
 include/trace/events/netfs.h      |  30 +++++-
 16 files changed, 381 insertions(+), 152 deletions(-)

