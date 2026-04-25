Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D0535BDD5
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121681; cv=none; b=L4bjfsy2kO0T5UcqwgB4zZU8WnrbTHZYXHrpH91EkNgAswEkjLm3eQOi73O2ZLOyODwn5AIp7jjOUMMy15sMuJAq7CpBt8mPrPNqkERJWSYFRWuu1K/gA6/b5iFUOWRAY624rorQBaUCtoMhoBF0Lyikaoj/jJvOM+W657CxrXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121681; c=relaxed/simple;
	bh=RRQ0IXdttCveiiHSEJbAsHURjxw1HDI3FgodXfjDv7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AAfOoEwJOpoK07PjleLBGVnXr9uS6tlM/D/UJDaZzXVA+yg34EaLC6hP5RWbdMLpbTRSt2+8HMU9846d3cML7zFtc6VC1yi/LCJRfFbmwa63o13SuuxtcS3FVb5YozYM0Ea7RM9iRoZ7z14eg7pkvaLUTBeXFrpDkJCdlmtkEbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DDCHbm+P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DDCHbm+P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pVwB7OIP/Kn8ajofvoCHRiXa+pRDIyAY5VS4PTcDuJ8=;
	b=DDCHbm+P+so2YAJn4nYgwVrieIQyQ0tSOvRTCsLgOmV7OokW1pJ/FOTE0g1Ota6GIN+JQd
	/hyHPqCjdgUFF3iEaR6ZSGCtxI+YXmv6lDGm4zMGWR22ZgcBNDNJXeVM+AZ5K38LBD6rUH
	7Kpc6fO7x94//LD7gsBCxKOqbVWV8OM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-jZgm73z_OD-3sDHpzV6hkQ-1; Sat,
 25 Apr 2026 08:54:35 -0400
X-MC-Unique: jZgm73z_OD-3sDHpzV6hkQ-1
X-Mimecast-MFC-AGG-ID: jZgm73z_OD-3sDHpzV6hkQ_1777121674
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F40E195608B;
	Sat, 25 Apr 2026 12:54:33 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6307819560AB;
	Sat, 25 Apr 2026 12:54:29 +0000 (UTC)
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
Subject: [PATCH v3 00/19] netfs: Miscellaneous fixes
Date: Sat, 25 Apr 2026 13:54:04 +0100
Message-ID: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Christian,

Here are the outstanding miscellaneous fixes for netfslib gathered together
and with some fixes-to-fixes folded down and one rearrangement.  Various
Sashiko review comments[1][2] are addressed:

 (1) Fix triggering of a VM_BUG_ON_FOLIO() in netfs_write_begin().

 (2) Fix error handling in netfs_extract_user_iter().

 (3) Fix netfs_invalidate_folio() to clear the folio dirty bit if all dirty
     data removed.

 (4) Defer the emission of trace_netfs_folio() in netfs_perform_write().
     This allows the next patch to emit the correct traces.

 (5) Fix the handling of a partially failed copy (ie. EFAULT) into a
     streaming write folio.  Also remove the netfs_folio if a streaming
     write folio is entirely overwritten.

 (6) Fix netfs_read_gaps() to remove the netfs_folio from a filled folio.

 (7) Fix the calculation of zero_point in netfs_release_folio() to limit it
     to ->remote_i_size, not ->i_size.

 (8) Fix netfs_perform_write() to not disable streaming writes when writing
     to an fd that's open O_RDWR.

 (9) Fix an early put of the sink page used in netfs_read_gaps(), before
     the request has completed.

(10) Fix request leak in netfs_write_begin() error handling.

(11) Fix a potential UAF in netfs_unlock_abandoned_read_pages() due to
     trying to check index of each folio we're abandoning to see if that
     folio is actually owned by the caller (in which case, we're not
     actually allowed to dereference it).

(12) Fix a potentially uninitialised error value in
     netfs_extract_user_iter().

(13) Fix incorrect adjustment of dirty region when partially invalidating a
     streaming write folio.

(14) Fix the handling of folio->private in netfs_perform_write() and the
     attached netfs_folio and/or group when a streaming write folio is
     modified.

(15) Fix the potential for 64-bit tearing on a 32-bit machine when reading
     netfs_inode->remote_i_size and ->zero_point by using much the same
     mechanism as is used for ->i_size.

(16) Fix netfs_read_folio() to wait on writeback first (it holds the folio
     lock) otherwise we aren't allowed to look at the netfs_folio struct as
     that could be modified at any time by the writeback collector.

(17) Fix read and write result collection to use barriering correctly to
     access a request's subrequest lists without taking a lock.

     This adds list_add_tail_release() and list_first_entry_acquire() to
     appropriate incorporate barriering into some list functions.

(18) Fix afs_get_link() to take the vnode->validate_lock around
     afs_read_single() to prevent a race with another caller of
     afs_get_link() also trying to read the symlink content.

(19) Fix the RCU handling of symlinks in RCU pathwalk.  The problems were
     that afs_get_link() didn't use proper RCU pointer dereferencing and
     that AFS symlinks can be updated remotely, potentially causing the
     buffer memory to be changed.

These are applied on top of your vfs.fixes branch.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

[1] https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
[2] https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com

Changes
=======
ver #3)
- Rebase on linus/master.
- Consolidate the various sets of fixes for reposting.
- Fold down fixes-to-fixes.
- Move the tracing change in netfs_perform_write() down to below the patch
  it primarily affects.

base-commit: 27d128c1cff64c3b8012cc56dd5a1391bb4f1821

David Howells (17):
  netfs: Fix netfs_invalidate_folio() to clear dirty bit if all changes
    gone
  netfs: Defer the emission of trace_netfs_folio()
  netfs: Fix streaming write being overwritten
  netfs: Fix read-gaps to remove netfs_folio from filled folio
  netfs: Fix zeropoint update where i_size > remote_i_size
  netfs: Fix write streaming disablement if fd open O_RDWR
  netfs: Fix early put of sink folio in netfs_read_gaps()
  netfs: Fix leak of request in netfs_write_begin() error handling
  netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()
  netfs: Fix potential uninitialised var in netfs_extract_user_iter()
  netfs: Fix partial invalidation of streaming-write folio
  netfs: Fix folio->private handling in netfs_perform_write()
  netfs: Fix potential for tearing in ->remote_i_size and ->zero_point
  netfs: Fix netfs_read_folio() to wait on writeback
  netfs: Fix missing barriers when accessing stream->subrequests
    locklessly
  afs: Fix afs_get_link() to take validate_lock around afs_read_single()
  afs: Fix RCU handling of symlinks in RCU pathwalk

Paulo Alcantara (1):
  netfs: fix error handling in netfs_extract_user_iter()

Viacheslav Dubeyko (1):
  netfs: fix VM_BUG_ON_FOLIO() issue in netfs_write_begin() call

 fs/9p/vfs_inode.c            |   2 +-
 fs/9p/vfs_inode_dotl.c       |   4 +-
 fs/afs/Makefile              |   1 +
 fs/afs/dir.c                 |  33 +++-
 fs/afs/fsclient.c            |   4 +-
 fs/afs/inode.c               | 104 +-----------
 fs/afs/internal.h            |  35 +++-
 fs/afs/symlink.c             | 242 ++++++++++++++++++++++++++++
 fs/afs/write.c               |   2 +-
 fs/afs/yfsclient.c           |   4 +-
 fs/netfs/buffered_read.c     |  39 +++--
 fs/netfs/buffered_write.c    | 111 ++++++++-----
 fs/netfs/direct_read.c       |  15 +-
 fs/netfs/direct_write.c      |   4 +-
 fs/netfs/internal.h          |   3 +
 fs/netfs/iterator.c          |  15 +-
 fs/netfs/misc.c              |  21 ++-
 fs/netfs/read_collect.c      |   6 +-
 fs/netfs/read_retry.c        |  11 +-
 fs/netfs/read_single.c       |  12 +-
 fs/netfs/write_collect.c     |   7 +-
 fs/netfs/write_issue.c       |   3 +-
 fs/smb/client/cifsfs.c       |  24 +--
 fs/smb/client/cifssmb.c      |   2 +-
 fs/smb/client/file.c         |   9 +-
 fs/smb/client/inode.c        |   9 +-
 fs/smb/client/readdir.c      |   3 +-
 fs/smb/client/smb2ops.c      |  16 +-
 fs/smb/client/smb2pdu.c      |   2 +-
 include/linux/list.h         |  37 +++++
 include/linux/netfs.h        | 298 +++++++++++++++++++++++++++++++++--
 include/trace/events/netfs.h |   8 +
 32 files changed, 826 insertions(+), 260 deletions(-)
 create mode 100644 fs/afs/symlink.c

