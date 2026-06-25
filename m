Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4930351C1E
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396426; cv=none; b=YlGf+oB+/fKaO/qIpHmmt4yo1EGR5kFeEIbOUgCmWNZ8MaO3owJ+6WKLbBQXNvH5f9X9+cYWFakLn0bp5wGqjOGzeKwn07Cxfyr+/7Ecxl6Z+UxlZ7HK1cfiZ3d5cq7wGNpwAmMtRdC8wWAtrzjVVyvJQe5ljfVdTQHkfvvPFXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396426; c=relaxed/simple;
	bh=7tcZgU8bfqE0wXlxXrCFNaghRQFDKVfr+le4KLDifbU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WMVQtFt57+bzRTunoZkRtoW82sxAFLGXJV3IVm2LJCb1mmDchIY+Hput8uyTcV2XKrPxHAyhdfafktm/IKtijaidQpghiCmEFRWpTHNvP0hWnMWoT5HYaHasEEfASoH0zSCzF/rBONzgE0scsA5PpevNpUwGJC5v5phS82d1Sbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DaKYQHqo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DaKYQHqo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782396424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yPMszipsehEHbDwFN6/VRckHTpEfI2yoQJ9SiHNODMg=;
	b=DaKYQHqooi+fCTI2Dyd4b1DRnhzJ/oGWhy/o/15dPjguT3KP5Vpuj/fLb3p0HahW/mKaUC
	Xu9kyiCAjytTE0sQ1yguoFVHJ1zIoWZIoKxWJrNJ7+gctaWlHCkRCAravv0PVzsRgmxdsH
	DkZLx0Nkosd1MN/IGzYL8uoQ/0Rq+34=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-x_jyWUqZOdWhoZ6eM57jwA-1; Thu,
 25 Jun 2026 10:06:58 -0400
X-MC-Unique: x_jyWUqZOdWhoZ6eM57jwA-1
X-Mimecast-MFC-AGG-ID: x_jyWUqZOdWhoZ6eM57jwA_1782396417
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FDEB1956067;
	Thu, 25 Jun 2026 14:06:56 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 291F01956088;
	Thu, 25 Jun 2026 14:06:51 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Christoph Hellwig <hch@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/15] netfs: Miscellaneous fixes
Date: Thu, 25 Jun 2026 15:06:18 +0100
Message-ID: <20260625140640.3116900-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Christian,

Here are some miscellaneous fixes for netfslib.  I separated them from my
netfs-next branch.  Various Sashiko review comments[1][2][3] are addressed:

 (1) Fix the decision whether to disallow write-streaming due to fscache
     use.

 (2) Fix netfs_create_write_req() to better handle async cache object
     creation.

 (3) Fix a double fput in cachefiles_create_tmpfile().

 (4) Fix alteration of S_KERNEL_FILE inode flag without holding inode lock.

 (5) Fix a potential mathematical underflow in
     iov_iter_extract_xarray_pages() and make it return 0 and free the
     array if no pages could be extracted.

 (6) Fix a missing alloc failure check in iov_iter_extract_bvec_pages().

 (7) Fix iov_iter_extract_user_pages() so that it doesn't leak the pages
     array if it returns an error or 0 (inasmuch as the leak is really in
     the callers).

 (8) Remove an unused variable in kunit_iov_iter.c.

 (9) Fix extract_xarray_to_sg() to calculate folio offset correctly.

(10) Fix a kdoc comment.

(11) Replace the netfs_inode::wb_lock mutex with a bit lock so that the
     lock can be passed to the collector so that multiple asynchronous
     writebacks won't interfere with each other.

(12) Fix writeback error handling to go through writeback_iter() so that it
     can clean up its state.

(13) Fix ENOMEM handling in writeback to clean up the current folio if we
     can't allocate a rolling buffer segment.

(14) Fix unbuffered/DIO write retry for filesystems that don't have a
     ->prepare_write() method.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

[1] https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
[2] https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40redhat.com
[3] https://sashiko.dev/#/patchset/20260619140646.2633762-1-dhowells%40redhat.com
[4] https://sashiko.dev/#/patchset/20260624115737.2964520-1-dhowells%40redhat.com

Changes
=======
ver #3)
- Addressed more Sashiko comments[4]:
  - Applied the disallow write-streaming fix to netfs_write_begin() also.
  - Improve the synchronisation with async cache object creation in
    netfs_create_write_req().
  - Fix netfs_writepages() so it doesn't both redirty and kill folios (and
    double unlock) if it can't create the request.
  - Move the cleanup of the folio on ENOMEM from netfs_write_folio() to
    netfs_writepages() as writethrough shouldn't do this.
  - Alter the unbuffered/DIO write retry fix so that it sets the
    IN_PROGRESS flag.  Also made it clear the MADE_PROGRESS flag and update
    wreq->transferred.

ver #2)
- Addressed various Sashiko comments[3]:
  - Changed some kfree() to kvfree().
  - Added some writeback error handling patches.
- Fixed DIO write retry.

ver #1)
- Added a fix for S_KERNEL_FILE in cachefiles_bury_object().
- Fixed how iov_iter_extract_*_pages() deals with *pages when returning 0
  or error.
- Fixed the replacement of wb_lock with bit lock:
  - Only release the bit lock for writeback, writethrough and write-single,
    not for PG_private_2-based I/O, which doesn't take the lock.
  - In netfs_writeback_single(), need to redirty the inode if can't get the
    lock.

David Howells (15):
  netfs: Fix decision whether to disallow write-streaming due to fscache
    use
  netfs: Fix netfs_create_write_req() to handle async cache object
    creation
  cachefiles: Fix double fput
  cachefiles: Fix file burial to take lock when unsetting S_KERNEL_FILE
  iov_iter: Fix potential underflow in iov_iter_extract_xarray_pages()
  iov_iter: Fix missing alloc fail check in
    iov_iter_extract_bvec_pages()
  iov_iter: Fix a memory leak in iov_iter_extract_user_pages()
  iov_iter: Remove unused variable in kunit_iov_iter.c
  scatterlist: Fix offset in folio calc in extract_xarray_to_sg()
  netfs: Fix kdoc warning
  netfs: Replace wb_lock with a bit lock for asynchronicity
  netfs: Fix writethrough to use collection offload
  netfs: Fix writeback error handling
  netfs: Fix folio state after ENOMEM whilst under writeback iteration
  netfs: Fix DIO write retry for filesystems without a ->prepare_write()

 fs/afs/symlink.c           |  4 +-
 fs/cachefiles/namei.c      |  3 +-
 fs/netfs/buffered_read.c   |  2 +-
 fs/netfs/buffered_write.c  |  2 +-
 fs/netfs/direct_write.c    | 18 +++-----
 fs/netfs/internal.h        | 12 +++++
 fs/netfs/locking.c         | 95 ++++++++++++++++++++++++++++++++++++++
 fs/netfs/write_collect.c   | 10 ++++
 fs/netfs/write_issue.c     | 55 ++++++++++------------
 include/linux/netfs.h      | 13 ++++--
 lib/iov_iter.c             | 20 +++++++-
 lib/scatterlist.c          |  1 +
 lib/tests/kunit_iov_iter.c |  5 +-
 13 files changed, 185 insertions(+), 55 deletions(-)

