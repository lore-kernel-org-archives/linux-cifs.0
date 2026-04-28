Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC2A450902
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382330; cv=none; b=tMxUw+O8kpRBiLcqcVoAKVisdYN6lNsHGUDhAOxPZA7WCch73ri3XPkc5x64zJeo5Rh01ys1jCLlZTjprAH0y96E+2xIarteaQRnNKr7T4sOtSMiUBFnQhncaao9Sku3QqCkLrWeRyyrtapQkhxZuOrCTp3kRtu8qH2x6GAzqVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382330; c=relaxed/simple;
	bh=pPM0SJ1S1cvk3LnQV16ZbOsgL0uWCrEXA3zCN4WXIh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D0d9pXWibIfces/bq2clJBDhrStktB88j+h6fCYSXouzxbC/A8Lpe3xECkFhXg4dtbbmOwdiL75RNLcsr+Y5KqgUI1ArnDnn0Gf8wx4sfCMbzkNbhGZnh+IKj3ckwHoPWtFBWrG9nzBVNFkC6Qp52WsWPUJETr5FZrBsxQrjw04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FGrlfbwn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FGrlfbwn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zXHGu2pKvh6nQppVcpyB9iSH+ygOF6hMG1YLx9PkNMc=;
	b=FGrlfbwneWZB736Zoc4oZyIPkRgR0xKtyVKv0uf0JW0plVyjiE5htE0WhvslgP9qZaYwey
	X7Sk89Z9Uc9G7J/WlL42UisDBq/CakbbDM+YEXfuCScfH4wXVjA4ODymD4KLgklQC0IY1A
	3BB6qWnTzlzP2aKawLFS0jlfBpuocPU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-316-QRUePlQQOV-Vk5ir6dmz8g-1; Tue,
 28 Apr 2026 09:18:42 -0400
X-MC-Unique: QRUePlQQOV-Vk5ir6dmz8g-1
X-Mimecast-MFC-AGG-ID: QRUePlQQOV-Vk5ir6dmz8g_1777382321
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE2DA188263F;
	Tue, 28 Apr 2026 13:18:02 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 13221180047F;
	Tue, 28 Apr 2026 13:17:58 +0000 (UTC)
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
Subject: [PATCH v5 00/24] netfs: Miscellaneous fixes
Date: Tue, 28 Apr 2026 14:17:30 +0100
Message-ID: <20260428131756.922303-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Christian,

Here are the outstanding miscellaneous fixes for netfslib gathered together
and with some fixes-to-fixes folded down and one rearrangement.  Various
Sashiko review comments[1][2][3][4] are addressed:

 (1) Fix subrequest cancellation cleanup in DIO read and single-read.

 (2) Fix read and write result collection to use barriering correctly to
     access a request's subrequest lists without taking a lock.

     This adds list_add_tail_release() and
     list_first_entry_or_null_acquire() to appropriate incorporate
     barriering into some list functions.

 (3) Fix missing locking around retry adding new subrequests.

 (4) Fix netfs_read_to_pagecache() to pause on subrequest I/O failure.

 (5) Fix the potential for 64-bit tearing on a 32-bit machine when reading
     netfs_inode->remote_i_size and ->zero_point by using much the same
     mechanism as is used for ->i_size.

 (6) Fix the calculation of zero_point in netfs_release_folio() to limit it
     to ->remote_i_size, not ->i_size.

 (7) Fix triggering of a VM_BUG_ON_FOLIO() in netfs_write_begin().

 (8) Fix error handling in netfs_extract_user_iter().

 (9) Fix overrun checking in netfs_extract_user_iter().

(10) Fix a potentially uninitialised error value in
     netfs_extract_user_iter().

(11) Fix netfs_invalidate_folio() to clear the folio dirty bit if all dirty
     data removed.

(12) Defer the emission of trace_netfs_folio() in netfs_perform_write().
     This allows the next patch to emit the correct traces.

(13) Fix the handling of a partially failed copy (ie. EFAULT) into a
     streaming write folio.  Also remove the netfs_folio if a streaming
     write folio is entirely overwritten.

(14) Fix a potential deadlock in writethrough writing.

(15) Fix netfs_read_gaps() to remove the netfs_folio from a filled folio.

(16) Fix netfs_perform_write() to not disable streaming writes when writing
     to an fd that's open O_RDWR.

(17) Fix an early put of the sink page used in netfs_read_gaps(), before
     the request has completed.

(18) Fix request leak in netfs_write_begin() error handling.

(19) Fix a potential UAF in netfs_unlock_abandoned_read_pages() due to
     trying to check index of each folio we're abandoning to see if that
     folio is actually owned by the caller (in which case, we're not
     actually allowed to dereference it).

(20) Fix incorrect adjustment of dirty region when partially invalidating a
     streaming write folio.

(21) Fix the handling of folio->private in netfs_perform_write() and the
     attached netfs_folio and/or group when a streaming write folio is
     modified.

(22) Fix netfs_read_folio() to wait on writeback first (it holds the folio
     lock) otherwise we aren't allowed to look at the netfs_folio struct as
     that could be modified at any time by the writeback collector.

(23) Fix write skipping in dir/symlink writepages.

(24) Fix the locking used by afs_get_link().

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

[1] https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
[2] https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com
[3] https://sashiko.dev/#/patchset/20260425125426.3855807-1-dhowells%40redhat.com
[4] https://sashiko.dev/#/patchset/20260427154639.180684-1-dhowells%40redhat.com

Changes
=======
ver #5)
- Fix more Sashiko issues[4].
  - Handle missed cancellations in netfs_read_to_pagecache().
  - Fixed potential double dio-end/put if no subreqs were submitted in dio
    read.
  - In netfs_single_dispatch_read(), cancellation needs to set ALL_QUEUED
    and invoke the collector.
  - In read/write retry, lock around deletion of subreqs also.
  - Renamed list_first_entry_acquire() to
    list_first_entry_or_null_acquire().
  - In netfs_push_back_zero_point(), fix use of cmpxchg().
  - Provide netfs_write_remote_i_size_locked() that can be used by a func
    holding inode->i_lock (e.g. cifs_fattr_to_inode()).
  - In netfs_extract_user_iter(), improved overrun checking.
  - Added a patch to fix a potential deadlock with write-through writes.
  - In netfs_page_mkwrite(), skip the flush if no group set on the folio.
  - In the single-write users, mark the inode dirty again if a contended
    lock was skipped due to WB_SYNC_NONE.

ver #4)
- Rebase on v7.0-rc1
- Fix more Sashiko issues[3].
  - Move the ->subrequests barriering patch up front as it modifies
    linux/list.h.
  - Split that barriering patch and make the first patch to harmonise the
    order of adding a read subreq to the queue, for buffered, dio and
    single reads and to fix cancellation on prep failure.  The second patch
    then fixes the barriering.
  - Lock ->subrequests in retry when adding in extra subreqs.
  - Use a spinlock as well when modifying ->zero_point with a seq lock.
  - Atomically check and change ->zero_point when bumping it up.
  - Merged the two patches sorting out the locking in afs symlink handling,
    then fixed a number of issues in them.
- Added a patch to make afs dir and symlink writepages skip if the
  validate_lock is held and WB_SYNC_NONE is set.

ver #3)
- Rebase on linus/master.
- Consolidate the various sets of fixes for reposting.
- Fold down fixes-to-fixes.
- Move the tracing change in netfs_perform_write() down to below the patch
  it primarily affects.

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731

David Howells (22):
  netfs: Fix cancellation of a DIO and single read subrequests
  netfs: Fix missing locking around retry adding new subreqs
  netfs: Fix missing barriers when accessing stream->subrequests
    locklessly
  netfs: Fix netfs_read_to_pagecache() to pause on subreq failure
  netfs: Fix potential for tearing in ->remote_i_size and ->zero_point
  netfs: Fix zeropoint update where i_size > remote_i_size
  netfs: Fix overrun check in netfs_extract_user_iter()
  netfs: Fix potential uninitialised var in netfs_extract_user_iter()
  netfs: Fix netfs_invalidate_folio() to clear dirty bit if all changes
    gone
  netfs: Defer the emission of trace_netfs_folio()
  netfs: Fix streaming write being overwritten
  netfs: Fix potential deadlock in write-through mode
  netfs: Fix read-gaps to remove netfs_folio from filled folio
  netfs: Fix write streaming disablement if fd open O_RDWR
  netfs: Fix early put of sink folio in netfs_read_gaps()
  netfs: Fix leak of request in netfs_write_begin() error handling
  netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()
  netfs: Fix partial invalidation of streaming-write folio
  netfs: Fix folio->private handling in netfs_perform_write()
  netfs: Fix netfs_read_folio() to wait on writeback
  netfs, afs: Fix write skipping in dir/link writepages
  afs: Fix the locking used by afs_get_link()

Paulo Alcantara (1):
  netfs: fix error handling in netfs_extract_user_iter()

Viacheslav Dubeyko (1):
  netfs: fix VM_BUG_ON_FOLIO() issue in netfs_write_begin() call

 fs/9p/vfs_inode.c            |   2 +-
 fs/9p/vfs_inode_dotl.c       |   4 +-
 fs/afs/Makefile              |   1 +
 fs/afs/dir.c                 |  79 ++++----
 fs/afs/fsclient.c            |   4 +-
 fs/afs/inode.c               | 104 +---------
 fs/afs/internal.h            |  34 +++-
 fs/afs/symlink.c             | 270 ++++++++++++++++++++++++++
 fs/afs/validation.c          |   8 +-
 fs/afs/write.c               |   2 +-
 fs/afs/yfsclient.c           |   4 +-
 fs/netfs/buffered_read.c     |  71 +++----
 fs/netfs/buffered_write.c    | 161 ++++++++++------
 fs/netfs/direct_read.c       |  42 ++--
 fs/netfs/direct_write.c      |   4 +-
 fs/netfs/internal.h          |   3 +
 fs/netfs/iterator.c          |  36 ++--
 fs/netfs/misc.c              |  22 ++-
 fs/netfs/read_collect.c      |  19 +-
 fs/netfs/read_retry.c        |  17 +-
 fs/netfs/read_single.c       |  23 +--
 fs/netfs/write_collect.c     |   9 +-
 fs/netfs/write_issue.c       |  18 +-
 fs/netfs/write_retry.c       |   6 +-
 fs/smb/client/cifsfs.c       |  28 +--
 fs/smb/client/cifssmb.c      |   2 +-
 fs/smb/client/file.c         |   9 +-
 fs/smb/client/inode.c        |   9 +-
 fs/smb/client/readdir.c      |   3 +-
 fs/smb/client/smb2ops.c      |  16 +-
 fs/smb/client/smb2pdu.c      |   2 +-
 include/linux/list.h         |  37 ++++
 include/linux/netfs.h        | 364 ++++++++++++++++++++++++++++++++++-
 include/trace/events/netfs.h |   8 +
 34 files changed, 1056 insertions(+), 365 deletions(-)
 create mode 100644 fs/afs/symlink.c

