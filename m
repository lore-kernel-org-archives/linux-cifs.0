Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E69338945C
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 08:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674241; cv=none; b=lG6MClMy+k4kEqsc/GVH2mUROhI3wiYC98hCdbOR052CihbR7YlG0J3krTZUm373jCKvziDS6m8brCtK7Opa2c++ZvPKHH0vbepciIWprP6SbJ8UemfMoNqsAV7ZduLaI0d4b3BcU1NRrU7R/jqA6SNyIUkF7J0sjYi2uouQwUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674241; c=relaxed/simple;
	bh=HHzZW79uNqFYtnh17CbdC+S5FUFfAD3faFM1gcXFMIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=njODgTmGBpTtSeuolOwO+8buq8snCZwtxev7GY2Hnr8v4jk5HHYyec9OKY/RQVVdx2aOPfYxK0WQKqKpqEi5fDi8Oz8qiFhCweE0Yo5QgfV258yYod6YnVnRkOj0UC2Uhhp2cwynnRVe1p1Szbu8Q5A3gKoFXFUgaYhCQe5CvEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JntNMLLx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JntNMLLx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776674238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WfuRXW6PO7eHQomUNdqzWCM5UdKk2eW774Sgalu0km4=;
	b=JntNMLLxznRHoeF0JEFDFsKEA5M0MUPbOqugrybbIoSI/JSE7YYsl62ycEmno/pcFwlI10
	VbhSOKpz+PJ+ifNtcR9okfSNuW9bVa9Fz85alA28eyIZcfv6bLYCHxPl7wSnoEq/yS4sKc
	R25ppKmFfa0bBUW5jM0uz9RppfpoO+k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-QXkkHxJ9MweldKo0LKm6Jw-1; Mon,
 20 Apr 2026 04:37:15 -0400
X-MC-Unique: QXkkHxJ9MweldKo0LKm6Jw-1
X-Mimecast-MFC-AGG-ID: QXkkHxJ9MweldKo0LKm6Jw_1776674234
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 695AE1800358;
	Mon, 20 Apr 2026 08:37:13 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 84BF519560AB;
	Mon, 20 Apr 2026 08:37:09 +0000 (UTC)
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
Subject: [PATCH 00/11] netfs: Further miscellaneous fixes
Date: Mon, 20 Apr 2026 09:36:51 +0100
Message-ID: <20260420083705.1009074-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Christian,

Here are some more miscellaneous fixes for netfslib, found by Sashiko.dev's
AI review[1] in response to the previous miscellaneous fix posting[2], plus
a repeat of another patch you haven't picked up yet:

 (1) Fix an early put of the sink page used in netfs_read_gaps(), before
     the request has completed.

 (2) Fix request leak in netfs_write_begin() error handling.

 (3) Fix a potential UAF in netfs_unlock_abandoned_read_pages() due to
     trying to check index of each folio we're abandoning to see if that
     folio is actually owned by the caller (in which case, we're not
     actually allowed to dereference it).

 (4) Fix a potentially uninitialised error value in
     netfs_extract_user_iter().

 (5) Fix incorrect adjustment of dirty region when partially invalidating a
     streaming write folio.

 (6) Fix the trace displayed by the total overwrite of a streaming-write
     folio.

 (7) Fix the handling of folio->private in netfs_perform_write() and the
     attached netfs_folio and/or group when a streaming write folio is
     modified.

 (8) Fix the handling of a group attached to the netfs_folio attached to
     folio->private when netfs_read_gaps() fills out the folio.

 (9) Fix the potential for 64-bit tearing on a 32-bit machine when reading
     netfs_inode->remote_i_size and ->zero_point by using much the same
     mechanism as is used for ->i_size.

(10) Fix a comment about avoiding streaming write on O_RDWR files as that
     bit of code is removed in vfs.fixes.  This could be folded down, but
     makes no change of behaviour.

(11) Fix netfs_read_folio() to wait on writeback first (it holds the folio
     lock) otherwise we aren't allowed to look at the netfs_folio struct as
     that could be modified at any time by the writeback collector.

These are applied on top of your vfs.fixes branch.  Patch 6 fixes a commit
in vfs.fixes, but would need moving before that patch rather than simply
folding down - and as it just changes the trace output, it's probably not
worth moving.  Patch 8 fixes a bug in one of the commits in vfs.fixes.
Patch 10 just tidies up a comment in one of the vfs.fixes commits.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

[1] https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com

[2] https://lore.kernel.org/r/20260414082004.3756080-1-dhowells@redhat.com/

David Howells (11):
  netfs: Fix early put of sink folio in netfs_read_gaps()
  netfs: Fix leak of request in netfs_write_begin() error handling
  netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()
  netfs: Fix potential uninitialised var in netfs_extract_user_iter()
  netfs: Fix partial invalidation of streaming-write folio
  netfs: Fix the trace displayed for the total overwrite of a streamed
    write
  netfs: Fix folio->private handling in netfs_perform_write()
  netfs: Fix group handling in netfs_read_gaps()
  netfs: Fix potential for tearing in ->remote_i_size and ->zero_point
  netfs: Fix comment about write-streaming avoidance
  netfs: Fix netfs_read_folio() to wait on writeback

 fs/9p/vfs_inode.c            |   2 +-
 fs/9p/vfs_inode_dotl.c       |   4 +-
 fs/afs/inode.c               |   8 +-
 fs/afs/write.c               |   2 +-
 fs/netfs/buffered_read.c     |  25 +--
 fs/netfs/buffered_write.c    | 100 +++++++-----
 fs/netfs/direct_write.c      |   4 +-
 fs/netfs/iterator.c          |   2 +-
 fs/netfs/misc.c              |  15 +-
 fs/netfs/read_collect.c      |   2 +-
 fs/netfs/read_retry.c        |   2 +-
 fs/netfs/write_collect.c     |   3 +-
 fs/smb/client/cifsfs.c       |  24 +--
 fs/smb/client/cifssmb.c      |   2 +-
 fs/smb/client/file.c         |   9 +-
 fs/smb/client/inode.c        |   9 +-
 fs/smb/client/readdir.c      |   3 +-
 fs/smb/client/smb2ops.c      |  16 +-
 fs/smb/client/smb2pdu.c      |   2 +-
 include/linux/netfs.h        | 301 +++++++++++++++++++++++++++++++++--
 include/trace/events/netfs.h |   3 +
 21 files changed, 426 insertions(+), 112 deletions(-)

