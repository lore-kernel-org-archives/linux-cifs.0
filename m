Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77492FFDEA;
	Fri,  2 Oct 2026 20:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790973754; cv=none; b=uKjevBvqDDpNlDkGcAmGsv1AcAGas8FgrCKhZanuc6lA7eGC4syGUnGYpkqUSqaVSG+HTukse340u39f9LWKlqgLMcPlHCWOxbn/qEblHOkwEUdRv0u4GjNdF+tmhIOn2GxAKAgv+hVklS3LKKPTrgw+VGf2TWbHs4SOxZZU4XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790973754; c=relaxed/simple;
	bh=Oc39FeL0TokucPuY9FbV5p65O8+TC0abLNbXBbGxlvk=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=dUMbfX053IyDZOv7VYuQd34b37twG9+Q9nWCnMVA7YmU7p3Vt+ADZ+hBjQ8ONd3MWZq7Z6o/+ylnHC2KZZ9RoKQF7xzjOiYlDmKT/7v6qbXTmxAcLLboTiuWiuXwpP4bYXU/feGYxKCnOpoA1uEfqPhkDY776ER1nJDNO88zGOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=xb8h+dTC; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="xb8h+dTC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:Subject:Cc:To:From:
	Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=6hc86ywzTBUbmMRmQu0woMFmHlCOIAamMlpF2NOCxYQ=; b=xb8h+dTCelyO/W8Q3YoY5pTurZ
	xsZtPzu1NETwFea1Q0rxcxe2KH3x6w98bXZV1W2Pk/ElmWFnJjeUaATSs9Mo61Q+T5KPEXcHF9P9Q
	B0HPL0X55oYcvskogDhxyKNOCI0kiFLpjulDQ7cSrfetzQvAnxA+LGLme6/0vUSZuh6IhsNKx0cl2
	kRMEvZ6ECw2dO1JnhE5SLMdnR18Y2J6icxPIjPmGkYsGyBlKMkWOsfppKi99pvWzNG/rIz0rQmPlt
	++DxBhThgCmH9Cquh9QlAX1QMW6iejqJBWyk6e0sQ5opL1OTnYLN5kg4iO0yW2wE/Fv/k9hjAmVXN
	ZwMCIVgw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xCk5I-00000002nrC-0ooy;
	Fri, 02 Oct 2026 17:42:24 -0300
Message-ID: <7af974fcbddc7e739dc7d18aaf1ea69f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: [GIT PULL] smb client fixes for 7.3-rc6
Date: Fri, 02 Oct 2026 17:42:23 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Linus,

Please consider pulling these smb client fixes for v7.3-rc6.  They fix
a series of data corruption and I/O error bugs found by running
generic/363 (fsx) in a loop against Windows Server 2022 and Samba.
All -stable material.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit f14572c203d57492e1d4e5d7851a3b143e083b82:

  Merge tag 'cifs-fixes-7.3-rc5' of https://git.manguebit.org/linux (2026-09-25 13:30:04 -0700)

are available in the Git repository at:

  https://git.manguebit.org/linux tags/cifs-fixes-7.3-rc6

for you to fetch changes up to 19465a9aeb664f1d710d0d22c07c31bfb7c85446:

  smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races (2026-09-30 23:17:30 -0300)

----------------------------------------------------------------
smb client fixes for v7.3-rc6

 - Stop data dirtied past EOF through an mmap from reappearing as file
   content once the file is extended by a write, truncate, zero range,
   copy range or clone range

 - Flush dirty data and drain in-flight I/O before operations that
   assume the pagecache and the server agree on the file: querying
   allocated ranges, the O_TRUNC open, interior zero range, and
   server-side copy/clone

 - Stop a genuine size-extending zero range or preallocate from being
   refused with -EOPNOTSUPP when the inode is not read caching, by
   querying the server's authoritative EOF instead of trusting a stale
   cached i_size

 - Zero the untransferred tail of a short read, both in the netfs
   read-gaps path (where stale folio content could otherwise be written
   back to the server) and in the DIO/unbuffered read collector, and
   tell a real EOF apart from a stale cached remote_i_size after a lease
   downgrade

 - Require stable pages on signed connections so a buffered write can't
   modify a folio whose signature has already been computed and is in
   flight, which the server rejected with STATUS_ACCESS_DENIED and the
   client surfaced as -EIO

 - Split several cifsFileInfo flags out of a shared bitfield byte so
   concurrent updates taken under different locks no longer clobber each
   other through a byte-level RMW

----------------------------------------------------------------
Frank Sorenson (1):
      smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races

Paulo Alcantara (15):
      netfs: clear post-EOF pagecache when extending a file via write
      smb: client: clear post-EOF pagecache when extending a file via truncate
      smb: client: discard post-EOF pagecache when extending a file via zero range
      smb: client: discard post-EOF pagecache when extending a file via copy range
      smb: client: discard post-EOF pagecache when extending a file via clone range
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

 Documentation/filesystems/netfs_library.rst |  26 ++++++
 fs/netfs/buffered_read.c                    |   7 ++
 fs/netfs/buffered_write.c                   |   9 ++
 fs/netfs/direct_write.c                     |   9 ++
 fs/netfs/internal.h                         |   2 +
 fs/netfs/misc.c                             |  99 +++++++++++++++++++++
 fs/netfs/read_collect.c                     |  24 +++++
 fs/smb/client/cifsfs.c                      |  41 +++++++--
 fs/smb/client/cifsfs.h                      |   5 +-
 fs/smb/client/cifsglob.h                    |  10 +--
 fs/smb/client/file.c                        |   5 +-
 fs/smb/client/inode.c                       |  24 +++--
 fs/smb/client/smb2ops.c                     | 130 +++++++++++++++++++++-------
 fs/smb/client/smb2pdu.c                     |  10 ++-
 include/linux/netfs.h                       |   2 +
 15 files changed, 347 insertions(+), 56 deletions(-)
