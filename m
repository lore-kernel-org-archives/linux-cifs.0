Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA503749EB;
	Wed, 30 Sep 2026 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790738913; cv=none; b=DOlth8/fO9k86bXu0bTUPf2iLzlrMSIwwv/GQEU3Tik+H3Iqe04cSFExw4uN9jQKsAK7FxmSlLjWfnRqg9xwmpdcFA7F8n5jiczbvqOAweUcsM4GlKguXHFKcXMe5sdH9ULVwiJT9MZSJIeJZIG25PF6uMLZZB1pd44bepEC3Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790738913; c=relaxed/simple;
	bh=th68Ydoejtv5D8f4jTDalhKVzOkwowg/HncxMY9PQiw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I1e/M0eFgULeM5CNkFCL4ZuIni+SmIzCJD4rb20FnjvoVhMPFIZBS9SF09nRIvSDAZ95IkCh135cuGphMH1Eyp0OFpUrNX6Q/FeGvLQn8aEWFkAykwl9qC1os23KC2kK1Tyos8G6qHGHgjkGN8a9r6InQ03Rs/oJSK407WyvGlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=GUSgcZSS; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="GUSgcZSS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ACbr8oPA5byQCZ5h4UTEsUVoWO3v7Zmg+F7C+ZUpO68=; b=GUSgcZSSE60ItEeRHjyJJ5KQyz
	+5eH5eA7LTP5RDZmcAttEbwyc+BX8CTgFMpUbGOJIkCiowvWReD+kEMQ3REc0Q9b34jzMEbtXf1AU
	G9S9w+eJUIdOsWkVlKsRpdpP2YlrP2AMraqT0ovx/xrj4UgtIwBESmIyAuU2xbgyiHhzalL0C+fUj
	NWk6fFhGECnnuTbCJzneQu3A4GtSLBKC+c4vHB8fzQnFfB4teU/earbe76JftEYU9fm9NsQVNsxJD
	1LUSvmEDk9zahA1JGDCwt9VKIk2HELLl0QlRB8lQ1EO6JGj7WI4H7ifjfYsCGmYB+Ld6Don99yJMb
	jIPELPqw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBkzX-00000002aro-157E;
	Wed, 30 Sep 2026 00:28:23 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH v3 00/15] netfs, cifs: data corruption fixes
Date: Wed, 30 Sep 2026 00:28:07 -0300
Message-ID: <20260930032822.1835287-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes a number of data corruption and spurious I/O error
bugs found by running generic/363 (fsx) in a loop against Windows
Server 2022 and Samba 4.24 servers.

* Post-EOF pagecache poisoning on extend (1-5)

  Data dirtied past EOF through an mmapped region was never discarded,
  so it reappeared as file content once the file was extended by an
  ordinary write, a truncate, a zero range, a copy range or a clone
  range.  pagecache_isize_extended() doesn't help here: it's a no-op on
  cifs because i_blkbits is 14.  Only the one folio straddling the old
  EOF can hold such data, since pages wholly beyond EOF can't be
  faulted in, so each extending path now zeroes or discards that folio.

* Missing flush or drain before trusting server or pagecache state (6-9)

  FSCTL_QUERY_ALLOCATED_RANGES can report just-written data as a hole
  unless it has been committed to disk first, and the O_TRUNC open,
  interior zero range and server-side copy/clone paths did not flush
  dirty data or drain in-flight I/O before an operation that assumes
  the pagecache and the server agree on the file's contents.

* fallocate refused without a read lease (10, 12)

  smb3_zero_range() and smb3_simple_falloc() returned -EOPNOTSUPP for
  any size-extending request whenever the inode wasn't read caching,
  since the cached i_size couldn't be trusted.  Query the server's EOF
  in that case instead of refusing the request outright.

* Short reads leaving stale data behind (11, 13, 14)

  The read-gaps path and the DIO/unbuffered read collector left the
  untransferred tail of a short read untouched, and cifs could not
  tell a genuine EOF from a stale cached remote_i_size after a lease
  downgrade.  A read racing an extending write could come back short
  and, in the read-gaps case, have that stale folio content written
  back to the server.

* Unstable pages during a signed write (15)

  cifs signs the pagecache folios in place before handing them to the
  socket.  A buffered write could modify a folio while a write
  subrequest built from it was still in flight, so the signature no
  longer matched the data that followed it; the server answered
  STATUS_ACCESS_DENIED, which surfaced later as -EIO.

================================================================
Changes since v2:
* Patch 12: zero the stale folio against the client's local i_size
  instead of the server-queried EOF, so an extending, leaseless
  preallocate can't skip zeroing past the client's real EOF.

Changes since v1:
* Patch 1: split the helper into netfs_clear_stale_pre_isize()
  (unexported) and netfs_clear_stale_post_isize() (exported for CIFS).
* Patch 2: capture old_size before the resize RPC and call
  netfs_clear_stale_post_isize() after i_size is updated, closing a
  stat() race.
* Patch 9: restore unmap_mapping_pages() before the flush/invalidate so
  a concurrent mmap store can't redirty the destination folio.
* Patch 10: refuse -EOPNOTSUPP when the queried server EOF still falls
  short, and re-check a fresh i_size before the final SMB2_set_eof().
* Patch 12: thread old_eof into smb3_simple_fallocate_range() so it
  doesn't misjudge a range as past EOF from a stale i_size.
* Picked up Reviewed-by from Namjae Jeon on patches 3-8, 11 and 13-14.

Paulo Alcantara (15):
  netfs: clear post-EOF pagecache when extending a file via write
  smb: client: clear post-EOF pagecache when extending a file via
    truncate
  smb: client: discard post-EOF pagecache when extending a file via zero
    range
  smb: client: discard post-EOF pagecache when extending a file via copy
    range
  smb: client: discard post-EOF pagecache when extending a file via
    clone range
  smb: client: flush and commit data before querying allocated ranges
  smb: client: drain outstanding I/O before truncating on O_TRUNC open
  smb: client: flush dirty data before zeroing a range
  smb: client: drain and invalidate before server-side copy/clone
  smb: client: only require read lease for size-extending zero range
  netfs: zero gaps in read-gaps folio to avoid writing back stale data
  smb: client: only require read lease for size-extending preallocate
  netfs: zero the tail of a short DIO/unbuffered read
  smb: client: distinguish real EOF from a stale remote_i_size on read
  smb: client: require stable pages for signed connections

 Documentation/filesystems/netfs_library.rst |  26 ++++
 fs/netfs/buffered_read.c                    |   7 ++
 fs/netfs/buffered_write.c                   |   9 ++
 fs/netfs/direct_write.c                     |   9 ++
 fs/netfs/internal.h                         |   2 +
 fs/netfs/misc.c                             |  99 +++++++++++++++
 fs/netfs/read_collect.c                     |  24 ++++
 fs/smb/client/cifsfs.c                      |  41 +++++-
 fs/smb/client/cifsfs.h                      |   5 +-
 fs/smb/client/file.c                        |   5 +-
 fs/smb/client/inode.c                       |  24 ++--
 fs/smb/client/smb2ops.c                     | 130 +++++++++++++++-----
 fs/smb/client/smb2pdu.c                     |  10 +-
 include/linux/netfs.h                       |   2 +
 14 files changed, 342 insertions(+), 51 deletions(-)

-- 
2.55.0

