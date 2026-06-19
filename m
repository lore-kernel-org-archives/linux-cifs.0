Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0E5273D8F
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jun 2026 14:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781878021; cv=none; b=kLqchAfJCCYvS1g0M3xJkH+R1YxcP+BO9RR3+k0hEXmsFstfndVWdPj6wIj/ZzsERe1ECkSbdniP/ql1HgD1oRi+9+WScwKeIpL7OlhEUvTgdOrIPWgTwmYw/ZVydIIRwptVdPiAEcMwXJ3xxAf5/8c1wZEDBZG6DoTJAJ6hMR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781878021; c=relaxed/simple;
	bh=90/tqKQLg5Mw54cQk0/epqqZmZVhh6jha/RrCAxKEmI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l30Sg1Y+FhF1Mugw3YK6tyPWeSOeodBjOPX8CzvEmRfz83O4TExgAWddR/AzOOEgvdPrpYf2xI9LjtRcN291vPHpLpx8EddIW2q+6a168u4NSN1sHcGi13cZ7ZH6HvGZfVL5kZBTeoGK0cWLWOvV+OpPR9u8LbtD5FyOs/jdI6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5N9CsYN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5N9CsYN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781878019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Qw58C1XrBetXfQP/iSYx++FDGmKpgIeMlOWrQbDiOFQ=;
	b=Q5N9CsYNja7N7iu8H/gz/sP9hB7Avky1zpOlm1S0gHKXj4VApyLg6kSdRqnbFj7ptDg0jv
	XZLNYyQOkNa7k2LDtY3/EOT+LzxCv+5ssZG/v/v9WzxZPTSxMQHcRHg/gssjLXw/XObGyZ
	GVhXvmdSwIzfBGSVOwJVA7XhxkjPxw8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-47LyOxksMpSU6sTHtNAPtQ-1; Fri,
 19 Jun 2026 10:06:55 -0400
X-MC-Unique: 47LyOxksMpSU6sTHtNAPtQ-1
X-Mimecast-MFC-AGG-ID: 47LyOxksMpSU6sTHtNAPtQ_1781878014
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 858B21955D71;
	Fri, 19 Jun 2026 14:06:53 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 54E531766;
	Fri, 19 Jun 2026 14:06:49 +0000 (UTC)
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
Subject: [PATCH 00/11] netfs: Miscellaneous fixes
Date: Fri, 19 Jun 2026 15:06:04 +0100
Message-ID: <20260619140646.2633762-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Hi Christian,

Here are some miscellaneous fixes for netfslib.  I separated them from my
netfs-next branch.  Various Sashiko review comments[1][2] are addressed:

 (1) Fix the decision whether to disallow write-streaming due to fscache
     use.

 (2) Fix a double fput in cachefiles_create_tmpfile().

 (3) Fix alteration of S_KERNEL_FILE inode flag without holding inode lock.

 (4) Fix a potential mathematical underflow in
     iov_iter_extract_xarray_pages() and make it return 0 and free the
     array if no pages could be extracted.

 (5) Fix a missing alloc failure check in iov_iter_extract_bvec_pages().

 (6) Fix iov_iter_extract_user_pages() so that it doesn't leak the pages
     array if it returns an error or 0 (inasmuch as the leak is really in
     the callers).

 (7) Remove an unused variable in kunit_iov_iter.c.

 (8) Fix extract_xarray_to_sg() to calculate folio offset correctly.

 (9) Fix a kdoc comment.

(10) Replace the netfs_inode::wb_lock mutex with a bit lock so that the
     lock can be passed to the collector so that multiple asynchronous
     writebacks won't interfere with each other.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

[1] https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
[2] https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40redhat.com

Changes
=======
ver #1)
- Added a fix for S_KERNEL_FILE in cachefiles_bury_object().
- Fixed how iov_iter_extract_*_pages() deals with *pages when returning 0
  or error.
- Fixed the replacement of wb_lock with bit lock:
  - Only release the bit lock for writeback, writethrough and write-single,
    not for PG_private_2-based I/O, which doesn't take the lock.
  - In netfs_writeback_single(), need to redirty the inode if can't get the
    lock.

David Howells (11):
  netfs: Fix decision whether to disallow write-streaming due to fscache
    use
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

 fs/afs/symlink.c           |  4 +-
 fs/cachefiles/namei.c      |  3 +-
 fs/netfs/buffered_write.c  |  2 +-
 fs/netfs/internal.h        | 12 +++++
 fs/netfs/locking.c         | 95 ++++++++++++++++++++++++++++++++++++++
 fs/netfs/write_collect.c   | 10 ++++
 fs/netfs/write_issue.c     | 38 +++++----------
 include/linux/netfs.h      | 13 ++++--
 lib/iov_iter.c             | 20 +++++++-
 lib/scatterlist.c          |  1 +
 lib/tests/kunit_iov_iter.c |  5 +-
 11 files changed, 164 insertions(+), 39 deletions(-)

