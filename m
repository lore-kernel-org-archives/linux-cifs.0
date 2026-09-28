Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E3E3CE4B5;
	Mon, 28 Sep 2026 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626189; cv=none; b=e66tUP5pLMHYjURf43cHYQWa0Q8VZy7jECgz+FDatl08vJ6dBkTqD0www2PVkyWUOIIVHFmWXsXR3AxF8smZqYCnqVojgSEp7+juLB8OR6KJjzOZB5AtqH3iXeO8UceHv6NqPRSHdUYAiEzSR3TvtHfgWRaQfa81rUj2+Gv2Tso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626189; c=relaxed/simple;
	bh=XQMsBMqLszkcUbZRRAZkipjWwIDWQ5kztILXmcdNqgw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qyV/tRu5zEe+tfEWNUWUs1NxNjV+zlFAgGkr05PlUIT9+a9lOFh6BFRbcAkHDZYdNWM6B+8deTFKoN75rJYCX+wh0uvUz8Nb/78aFekYe5xOCmstYhq12WqqhlH4oI7lfFB/uhC3/2PBbIcnxrX/OCJHgoDuaa5L8r+EuDf9lF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=IQg0ZjqB; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="IQg0ZjqB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=vI9hnkyTXmIp3v3C49B0iA4VlEHobWDvjNpSEFmIUX0=; b=IQg0ZjqBT515fYp2aL6OeKQZJs
	uMZ+IdLfqyK7SfzJpBBCLOlN7x83mEl+Rxce6rXIoDNbODlu1cXZVDog+3W9S7JSdApWI6vlTiNix
	c6zTazdqgBUJXXqvpEAkkJC+vSj182qi3IalOK6wmRKjRw8kT9ETsifu1StaKHa7KdLnrAf4YEcNU
	nIbYGR90qS2HAYaT4UaAqxd1tTZoiLU2rrrlqNab2SlHNDDxA+je/CwX/sImtN7kjaYtSARfyOzih
	jOpK4HOn7JtYupPaIILZ9k372bDr3pr+UONqKy02Dty/xBlsHwSkM6p6Zoxca6/cfHa3W5rKBsXib
	TwPxsdqg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfK-00000002UIs-2UTu;
	Mon, 28 Sep 2026 17:09:34 -0300
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
Subject: [PATCH 00/15] netfs, cifs: data corruption fixes
Date: Mon, 28 Sep 2026 17:09:19 -0300
Message-ID: <20260928200934.1040189-1-pc@manguebit.org>
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

 Documentation/filesystems/netfs_library.rst | 25 ++++++
 fs/netfs/buffered_read.c                    |  7 ++
 fs/netfs/buffered_write.c                   |  9 ++
 fs/netfs/direct_write.c                     |  9 ++
 fs/netfs/misc.c                             | 71 +++++++++++++++
 fs/netfs/read_collect.c                     | 24 +++++
 fs/smb/client/cifsfs.c                      | 25 +++++-
 fs/smb/client/file.c                        |  2 +
 fs/smb/client/inode.c                       | 19 ++--
 fs/smb/client/smb2ops.c                     | 97 ++++++++++++++++-----
 fs/smb/client/smb2pdu.c                     | 10 ++-
 include/linux/netfs.h                       |  2 +
 12 files changed, 267 insertions(+), 33 deletions(-)

-- 
2.55.0

