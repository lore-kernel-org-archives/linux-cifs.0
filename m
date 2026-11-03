Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728987;
	b=n9ZZouqwooAkDWJQzg/h75qKCq6ok/XSCx/SQG923Yrwwi0WUb0tYTvbIgOlkZflAlmc
	 A6QuUA0tGGq+BGuQMm8wnNnBR42ON3suuRXkTDHCxzcwCSyOfCBIa6N0GqYMat1wsGrs5
	 VzaKfFNC3SVU83JPeEafvmCpi2wbIYpd0lgkzeEaiOcOKAo8OfC006LgMoFSpfZhc4HOU
	 Xe3Zlc12a/Alce2uFC8WFpCpK4Pi6xKEFOCklTnK14nXXvkEPYqY5elicW32epvVnEZi8
	 KDzQotANDcUSWQjvInuXHSCBRfk/V27m0k8C4klziNSKF6+E5BKkrHcJJh2DZoU9MTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728987;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=CLeVYwSdTm3uoxLPioNfEMyYKiJEN97Wm9xYay5/kVU=;
	b=jrHoD4rWd1HnCjLm4fcedfdZzOUoUDYKqTzK1QF4+AMcDUhfeskQqXFz5/ruo0W3SAn3
	 b6NLZzuw1Z+GncIGUeGY+v7b3LPx1ORszJ4N0RK8LdLaL53lSUsUD6q41z1EA3lrA6x4p
	 LFmb6SfT5IRDxMcRKZh2RG5ciuILZ4afEOB20WH4P+NkbGbTjkfG2KgDDVRm8BAeCv0be
	 blfCRSf0yv0jU4gzRnOk5WUJ9NXLFaDiSxi6tCX99q3SFpQDVOhD3/7JtoSKse3/tsci9
	 TEZvIZKoS8OilScEZfOduiFS4/EN2mPuxZOWtR3VqyqniaBjqjJlr1Yc+JY5M9ybX+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="kR25iUu/";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A252606A32C;
	Tue,  3 Nov 2026 18:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A252606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=kR25iUu/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CLeVYwSdTm3uoxLPioNfEMyYKiJEN97Wm9xYay5/kVU=; b=kR25iUu/lOVtaJivBlxlc54vBX
	P4NIlXs0auwmD/8izPBMAIx2HAOY5VqDseRgnobOfbUFsMVlphhIvokTpg+hIm/HS3tACFKvp0oNV
	BnGkdkO+F/6dxZX3xMwKNfG57FuxsZ6LkoMzeUzuEEmn4PfgsBhYU6Bl1l0XqdRfWCXaD5GS2dx5x
	j03nSreEQOpX9quqN7Z1ogkeTp0T11MVPq7jkNJ2k3jGZW0H1eDzvNBA7nRigsDdpGNfOeBo1iR5g
	KxTf70t/lMswtFWLe431j7n/8U27QZ/GWxZA6+Fd8CqPAn+vlqy1JtMTcIvMw+GPDCW9ec+vmol7q
	7uAKPvpw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOIqU-00000000itT-3PIJ;
	Tue, 03 Nov 2026 15:02:56 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 00/16] smb: client: fix data loss in writeback
Date: Tue,  3 Nov 2026 15:02:39 -0300
Message-ID: <20261103180255.1482516-1-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

A task killed while close() flushes its dirty pages gets its writes
refused by __smb_send_rqst() (fatal signal pending), and netfs then ends
writeback with the folios clean.  The data never reaches the server and
no error reaches the application: stat() still reports the cached size
while the file on the server is short.  It was reported against a RHEL 9
kernel, where the same trigger makes stat() fail with -EIO after a
rename(2), and it reproduces on mainline as this silent lost write.

Any other failure that is only transient hits the same wall: since the
move to netfslib, a failed upload ends writeback with the folios clean,
so a reconnect, a lost handle, an interrupted wait or an -ENOMEM
silently drops the data.

This series makes writeback retry instead of giving up:

 - a dying task's writeback is issued from a workqueue, and the close()
   and fsync() waits for it are killable
 - writeback is retried with exponential backoff on replayable errors,
   interrupts, -ENOMEM and on losing the connection, share or handle,
   and handle reopens are retried the same way
 - umount -f aborts the retries and reconnect waits of the mount's
   earlier requests, and writeback no longer blocks in the reconnect
   wait so the unmount's own sync can't hang there

On hard mounts writeback is retried until the server comes back or
umount -f.  On soft mounts it gives up after max(3, retrans) *
echo_interval from the first failure of each write (3 minutes, and about
6 minutes from the outage since that is when cifs declares the server
dead), recording -EIO.  Reads and direct writes still follow the hard
and retrans mount options.

Patch 1 is independent: writeback could pick a handle opened with
O_DIRECT, and Windows rejects unaligned writes on those with
STATUS_INVALID_PARAMETER, dropping 1.2% of the writes in xfstests
generic/051.  It is first so it can be backported on its own.

Patches 2 and 3 are netfs fixes the cifs patches depend on: patch 2 is
Ivan's (20261028181229.1408342-1-ivanrwcm25@gmail.com), keeping the
prepare_write() errno across a reissue; patch 3 does the same for
prepare_read() when read retries are abandoned.

Tested against a Windows server, all passing:

 - the reporter's case: a writer killed by SIGKILL mid-close(), and a
   multithreaded program exiting without close(), then rename()+stat()
   (loses data without the series)
 - xfstests generic/051 (no rejected writes left after patch 1)
 - umount -f with writeback in flight, on hard and multiuser mounts
 - a soft mount with the server down shorter and longer than the window
 - reads with a handle reopened after a reconnect

Not covered by this series:

 - reconnect waits of reads and metadata, and the credit wait, don't
   stop on umount -f; nor do tcons shared with another mount
 - if every writable handle of an inode is O_DIRECT (e.g. mmap of an
   O_DIRECT fd), its unaligned writeback still fails, with the error
   reported

Thanks,
Paulo

Changes since v1:
 - new patch to not write back through O_DIRECT handles (data loss of its
   own, found by generic/051); put first for an independent backport
 - dropped the netfs patch that deferred write retries until all
   subrequests were queued (could deadlock writeback under memory
   pressure); keep the prepare_read() errno on abandoned read retries
   instead
 - issue writeback sends and handle reopens without waiting for a
   reconnect, and make umount -f also stop the credit wait, cover
   multiuser per-user tcons, and not be gated by tc_count, so the
   unmount's own sync can't hang
 - make the reopen retry reconnect-aware and bounded, don't replay
   reopens inside SMB2_open(), track the bad handle (-EBADF) per request,
   and fix a retried read failing with -EAGAIN and a dying-task writeback
   looping on a reopen that gave up
 - record -EIO (not a transient errno) when writeback finally gives up

Iván Ezequiel Rodriguez (1):
  netfs: preserve prepare_write errno on reissue

Paulo Alcantara (15):
  smb: client: don't write back through O_DIRECT handles
  netfs: keep the prepare_read errno when abandoning read retries
  smb: client: let umount -f abort retried reads and writes
  smb: client: don't give up writeback on the first replayable error
  smb: client: don't retry failed writes forever regardless of mount
    options
  smb: client: don't block dying tasks waiting for writeback on close
  smb: client: issue writes from a worker if the task is dying
  smb: client: don't fail writeback preparation if the task is dying
  smb: client: retry writeback on interrupts and allocation failures
  smb: client: don't block dying tasks waiting for writeback on fsync
  smb: client: retry writes that couldn't be issued due to a reconnect
  smb: client: retry writeback after losing the connection, share or
    handle
  smb: client: let umount -f stop waiting for reconnects on hard mounts
  smb: client: don't replay handle reopens inside SMB2_open()
  smb: client: fail writeback sends and reopens fast when the server is
    gone

 fs/netfs/read_retry.c      |  16 +-
 fs/netfs/write_issue.c     |   4 +-
 fs/smb/client/cifs_fs_sb.h |   1 +
 fs/smb/client/cifsfs.c     | 117 +++++++++---
 fs/smb/client/cifsglob.h   |  18 ++
 fs/smb/client/cifsproto.h  |   5 +-
 fs/smb/client/cifssmb.c    |  15 +-
 fs/smb/client/file.c       | 368 ++++++++++++++++++++++++++++++++++---
 fs/smb/client/misc.c       |  16 +-
 fs/smb/client/smb2ops.c    |   9 +-
 fs/smb/client/smb2pdu.c    | 103 ++++++-----
 fs/smb/client/smb2proto.h  |   9 +
 fs/smb/client/trace.h      |   4 +-
 13 files changed, 573 insertions(+), 112 deletions(-)

-- 
2.56.0

