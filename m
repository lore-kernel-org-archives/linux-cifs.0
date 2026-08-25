Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F4C471D1F
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664063; cv=none; b=BnskwvYwkrUhpPIV4AGhYIPK4Bgv/t4oGs6Va/5NPL5a/s/J7kML0qZnAFkewJRrd36qxwUT3ORiNb/tXxfrHTl3dzYaFWbLpqtBt40HtazXpuZFZYgN9FIt7E4Z7XS+t/JWwmpYD1XQ5eHNhZ06QL5ZcYBMSNc7tMcHnqNPMOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664063; c=relaxed/simple;
	bh=BcJCMy69lPvz5s1VBS7M4DTzyiq/Kdej4pjQTUhKZKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OdYOQFD16d/lIs0TgEGU8Tp37vZ4seMhY11ATi4Xh2L1OF8Sf9ytCPtyJ2w+f9ObIDfDpZiR3R9Ou5+MzbgIFVvMxY1ZxQYvdUYwt0oNblKhW/CW7PswV3gi4kkpID3zBbp0sZsyMOOu3JvLpe/2+xwvk9qRd4TXPOWsiSJ1COo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R77Y7gqI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R77Y7gqI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787664058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FH+mL3pEdzp4qCOfZxAdB+diWavPTT2ubz66fxS2n60=;
	b=R77Y7gqIP9R6AGOSJshOLshQGJ/c35xhbnOmWGJp3/LvBW9uKGIRvmtfAalA9/QRfsiD3E
	HVkj1i/v+E79I4q2AlPhIoHFWOabAUlsg3Zcij9QPGkM4WXfVr9CYUUped/scjOGVfl4W0
	xXkFfpYOvTOY+PphsQ0ulf9hjdJ+97o=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-xBSV6FO0NNi9YcwHwt8Eng-1; Tue,
 25 Aug 2026 09:20:55 -0400
X-MC-Unique: xBSV6FO0NNi9YcwHwt8Eng-1
X-Mimecast-MFC-AGG-ID: xBSV6FO0NNi9YcwHwt8Eng_1787664053
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2741B186065B;
	Tue, 25 Aug 2026 13:20:53 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C173530002F2;
	Tue, 25 Aug 2026 13:20:49 +0000 (UTC)
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
Subject: [PATCH v2 0/9] netfs, cachefiles: Miscellaneous fixes
Date: Tue, 25 Aug 2026 14:20:34 +0100
Message-ID: <20260825132045.1000787-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

 (8) Fix read progress reporting to avoid 64-bit tearing on a 32-bit
     machine.  This has been modified from the previous submission as part
     of a different series to take account of a sashiko reported issue[1].

 (9) Fix a potential UAF/KASAN warning reported by sashiko[1] in cachefiles
     in which the coherency data buffer is cast to a __be64* and
     dereferenced in a tracepoint - even though it might not be at least
     that large (or aligned).

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

Changes
=======
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

David Howells (7):
  netfs: Fix unbuffered/DIO write partial transfer error return
  netfs: Fix error vs transferred passed to ->ki_complete()
  netfs: Fix i_size update for partial transfer
  netfs: Fix subreq ref leak
  netfs: Fix readahead synchronisation issues by loading all folios
    upfront
  netfs: Fix read progress reporting
  cachefiles: Fix potential UAF/KASAN warning

Edward Adam Davis (1):
  netfs: break unbuffered write when netfs_alloc_subrequest() fails

Karl Mehltretter (1):
  netfs: Fix uninitialized return value in netfs_unbuffered_write()

 fs/cachefiles/xattr.c             |  16 ++---
 fs/netfs/buffered_read.c          | 103 ++++++++++++++++++------------
 fs/netfs/direct_write.c           |  30 +++++----
 fs/netfs/internal.h               |   2 +
 fs/netfs/misc.c                   |  19 ++++++
 fs/netfs/objects.c                |  32 ++++++----
 fs/netfs/read_collect.c           |  65 +++++++++++++++----
 fs/netfs/read_retry.c             |   7 ++
 fs/netfs/read_single.c            |   2 +
 fs/netfs/rolling_buffer.c         |  81 ++++++++++++++---------
 fs/netfs/write_issue.c            |   2 +
 include/linux/netfs.h             |   3 +-
 include/linux/rolling_buffer.h    |   6 +-
 include/trace/events/cachefiles.h |  19 +++++-
 include/trace/events/netfs.h      |  24 +++++++
 15 files changed, 291 insertions(+), 120 deletions(-)

