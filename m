Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794579067;
	b=Ok5g6GEJ4B5kKwORN3sDm3mz6gUbA62tgfUU/MdN+UjrURHj5SJzfpEqpUrRAc2bz8/D
	 bUmji0TdePXZI02bDWMgighS7VNb0Y8z1kzKSrIgf8Zf9RU0sl0gks3WG0OUiu097d8H2
	 DTVUMFys72ex76aeqI3RKP4fqyu117HFf7nz++zAbjIQTstr1StFrhNVtIKIcbvpFoidu
	 H/Xaiw1fI0xCGsuxY4z/B6/ccwURIGRM0TGw+wJ9TQO/dZQR3aGUmbQFsNW3davn/dUnX
	 ifKCuNbHaOg7p5n77NeiUgN2tscJItePSxdeupz5sKNrN6h8bW0U/RTI1byFhQ+9jGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794579067;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2Df+5Hg2+npbDZ7+hcsNFY6BQrrU81o8opyCf0Uj9Ww=;
	b=ezlBNycz7es74p9whaOMkoV+vGlce1mxIV8OkEMXSKW5g2ReaBSQzyqE+IU3GQ7II4J1
	 p78c8pdUtxyoPwef1rqUakII9P7pjn6sXAempITychCock28TkwV/rQhV8/nIQhc0OnyM
	 YDd8VJLEzza+4/gT37BLriMwGUIiHQr4zOY5f/8P6XoTX2bIY+Y7EC/pC+1vNpyA9ipns
	 /yUyi9Np0fSC6ZvXONmiryWCSj3xDwPGs7ZOCG847OiN264TDb4/mgQpYB6Cw3rVxFJWX
	 Lo3Y2Z/3XCDQWSHx3siNikPcDsu9zzV+NPzJajaylDNETmsGRIMqtc90o3JvS72cS/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=kpbj15ra;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B480606A88F;
	Fri, 13 Nov 2026 14:11:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B480606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=kpbj15ra
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:Subject:Cc:To:From:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=2Df+5Hg2+npbDZ7+hcsNFY6BQrrU81o8opyCf0Uj9Ww=; b=kpbj15rahdsmtK07ab/8LF9Jar
	i8Lihj8rKEaMtoI4u2pgYcEA33fE6oB3Iv/SXwR15XxpR6Xc7f9k6IXrNe2lIXHL4krteMPgBWV6g
	dU2wup+MzzTPqiqg/ZBsAVWt68hkzCNOuugNMA90ZlXMI33XJxz36yLzl5yXhbZ+Jnzl3DMoCjDI1
	UBTIzmzgGp/DaD6z2MgrLCVqt8pUxVuI5VT8yYy23scGGbltjUrkQbX4ViR8vNqXdAG/pHHyfzrix
	evyI3YdjnoxAZRMzlvhiOo7Gz3gHrE6XP8KLRr+AjvHqSYLAoEakS9Kyo2FGKlxmkOSBaPwStQ8R5
	3r49rf+g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xRrzT-00000001fbo-3TBn;
	Fri, 13 Nov 2026 11:10:57 -0300
Message-ID: <e7592016e8a893d7c859ba1e6ee0db61@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: [GIT PULL] smb client fixes for 7.4-rc3
Date: Fri, 13 Nov 2026 11:10:56 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Linus,

Please consider pulling these smb client fixes for v7.4-rc3.  Most of
them fix silent data loss in writeback since the move to netfslib; the
rest are memory-safety and smaller fixes.  All of them are for stable.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit 51b4bf5fe7c90ebf08599b9a3c7620b4a3fd4b22:

  Merge tag 'cifs-fixes-7.4-rc1' of https://git.manguebit.org/linux (2026-1=
0-30 13:40:03 -1000)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-fixes-7.4-rc3

for you to fetch changes up to 25912ed3b75dcf5ff623dcb549b925dd0d0948f7:

  smb: client: flush deferred handles of other names before a hard link ope=
n (2026-11-11 13:51:10 -0300)

----------------------------------------------------------------
smb client fixes for v7.4-rc3

 - Fix silent data loss in writeback: since the move to netfslib a
   transient failure (a reconnect, a lost handle, an interrupted wait,
   -ENOMEM, or a task killed while close() flushes its dirty pages)
   ended writeback with the folios clean and no error, dropping the
   write; retry it instead, bounded by the hard and retrans mount
   options, and have umount -f abort the retries and the reconnect and
   credit waits so the unmount's own sync can't hang

 - Prefer a non-O_DIRECT handle for writeback, as Windows rejects
   unaligned I/O on O_DIRECT handles and silently dropped about 1% of
   the writes in generic/051

 - netfs: keep the prepare_read() and prepare_write() errno across a
   reissue, and don't hang a read whose retry is abandoned (the
   writeback fixes depend on these)

 - Fix an out-of-bounds write when compounding an encrypted SMB2_IOCTL
   with a large input, which an unprivileged user can trigger with a
   long symlink target

 - Fix an out-of-bounds read parsing a DFS target referral, and a double
   conversion of the DFS path in setup_dfs_ref()

 - Validate security descriptor headers before allocating the query
   result, and compare owner and group SIDs by their encoded lengths

 - Hold a server reference while queueing reconnect work so the server
   can't be freed under the worker

 - Hold the inode across cifs_oplock_break() so dropping the handle
   reference can't free it before the break is acknowledged

 - Flush an inode's deferred handles before opening another of its hard
   links, so the open doesn't reuse the lease key under a mismatched
   name and get rejected with STATUS_INVALID_PARAMETER

 - Skip a NULL channel in __cifs_put_smb_ses()

 - Bound the invalid NTLMSSP signature diagnostic

----------------------------------------------------------------
Andrey Misiurov (1):
      smb: client: fix OOB write when compounding SMB2_IOCTL with encryption

Fredric Cover (2):
      smb: client: fix out-of-bounds read in dfs_parse_target_referral()
      smb: client: fix double conversion of DFS path in setup_dfs_ref()

Iv=C3=A1n Ezequiel Rodriguez (1):
      netfs: preserve prepare_write errno on reissue

Joseph Qi (3):
      smb: client: skip NULL channel in __cifs_put_smb_ses()
      smb: client: hold server ref while queueing reconnect work
      smb: client: hold the inode across cifs_oplock_break()

Paulo Alcantara (19):
      smb: client: don't write back through O_DIRECT handles
      netfs: keep the prepare_read errno when abandoning read retries
      netfs: don't hang a read whose retry is abandoned
      smb: client: let umount -f abort retried reads and writes
      smb: client: don't give up writeback on the first replayable error
      smb: client: don't retry failed writes forever regardless of mount op=
tions
      smb: client: don't spend read retries on reads cut short by a reconne=
ct
      smb: client: don't block dying tasks waiting for writeback on close
      smb: client: issue writes from a worker if the task is dying
      smb: client: don't fail writeback preparation if the task is dying
      smb: client: retry writeback on interrupts and allocation failures
      smb: client: don't block dying tasks waiting for writeback on fsync
      smb: client: retry writes that couldn't be issued due to a reconnect
      smb: client: retry writeback after losing the connection, share or ha=
ndle
      smb: client: let umount -f stop waiting for reconnects on hard mounts
      smb: client: don't replay handle reopens inside SMB2_open()
      smb: client: fail writeback sends and reopens fast when the server is=
 gone
      smb: client: stop reconnecting and replaying during a forced unmount
      smb: client: flush deferred handles of other names before a hard link=
 open

Yifan Zhang (1):
      smb: client: bound invalid NTLMSSP signature diagnostic

liuyong (2):
      smb: client: validate descriptor headers before query result allocati=
on
      smb: client: compare owner and group SIDs using their encoded lengths

 fs/netfs/read_retry.c      |  17 +-
 fs/netfs/write_issue.c     |   4 +-
 fs/smb/client/cifs_fs_sb.h |   2 +
 fs/smb/client/cifsacl.c    |   5 +-
 fs/smb/client/cifsacl.h    |  14 -
 fs/smb/client/cifsfs.c     | 186 ++++++++++---
 fs/smb/client/cifsglob.h   |  50 +++-
 fs/smb/client/cifsproto.h  |  12 +-
 fs/smb/client/cifssmb.c    |  15 +-
 fs/smb/client/connect.c    |  78 +++++-
 fs/smb/client/dfs.c        |  12 +-
 fs/smb/client/file.c       | 667 +++++++++++++++++++++++++++++++++++++++++=
+---
 fs/smb/client/misc.c       |  22 +-
 fs/smb/client/sess.c       |   4 +-
 fs/smb/client/smb2file.c   |  18 +-
 fs/smb/client/smb2ops.c    |  22 +-
 fs/smb/client/smb2pdu.c    | 206 ++++++++++----
 fs/smb/client/smb2proto.h  |   9 +
 fs/smb/client/transport.c  |  22 +-
 19 files changed, 1158 insertions(+), 207 deletions(-)
