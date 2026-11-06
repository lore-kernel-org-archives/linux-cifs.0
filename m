Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979439;
	b=D9lWeE92VWmYgJSqDqs3/d88O2vX9mQSdR1eSvNltAv9xbGEDiy6X+krxVi2htgOJnoL
	 76srHKuO+kF4oO/sDXEU925HAU5O/sYZdBayrfyiSrKgm+KLSsHgT4vWlw5GDvKfmn1Ds
	 DI78ZbEa2xVmDciE+icvyZuHGXrdnoDIu0mkOddWhVkbUGxloObLSIG7f4GV3ic8mZDfW
	 UHvNY2rFbyCh/t7qqVnU44DOSnC9D+uAHXM771lieS7e0+WR+/kQxio9t1oTF+8g1W1ga
	 +Htf3wFpOEyFrhMJKHWnBLNBbOu8pxYt/Hr1qL+6akYMa+6I/banwO5R5HwG7cgtD0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979439;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=uod00NzH5OzvPch+HmcGlYibNHOiGa/43U74CxK6E6k=;
	b=cketIXeT0+RaMnVa6gP2oavpvBw5ycbQFgt8FSDjisy4MQdH8hrfl9pHbRAcNDaSEA8X
	 sBE/XaT9op/4llzxlQt+Vonsgv5TOhJhwkeGa81kbprwF/hZ0lui/YwZBsGFAdUuij9ib
	 dvBObf6yqUslMdEHL3Ame5g9/HF4MdEbrkF2JiIjPqiVdKjHZkgbTtclMbF2OMnly5Da/
	 3rHiDm5T2m6WoOeGOgllntr+r0rcyfnFMV3HWAayFXGFQEjzFaikMwLGp1bxvU/rwQtiN
	 btUBRGls08HQAzcjjhyYbHVPke80md2UUu1OJ82DX0DkT5NIcSMxuarqH4UQnjQ4lWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Srz9x78v;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C060F606A330;
	Fri,  6 Nov 2026 15:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C060F606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Srz9x78v
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=uod00NzH5OzvPch+HmcGlYibNHOiGa/43U74CxK6E6k=; b=Srz9x78vswIsRnjDq51hX7M/t7
	o0MziYLgIv4JrvUfZn1sxumYgOkn0bDz8OkGJSmEZv0MvowwIQWvz/yyH6keVh0y8ZHIaV3XMA2F/
	+JwyHnzuR5OR80f29fOSROFkHUD0y2+DHD0xeTur6W1/TR1at2Qj555/tdw8ipYAuIHNy4tx8b7Hn
	Ep4CsJ03qkM0iU9D9Tjjaap9kxNQPkSxEWAqKWnaYz4tMTPILYvKMboKqHOssvqYXmf6VJTrWEcpD
	UIUwjgAa3ovG3bLSrWVpUQsXnrQ6Fs/HuX67ct2s7TBvWYM0KKxNqhK7NQ+NWAHV1ubkJSYMOeSyo
	wMM2eBBQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPM06-000000012YA-1KYB;
	Fri, 06 Nov 2026 12:37:11 -0300
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
Subject: [PATCH v6 00/18] smb: client: fix data loss in writeback
Date: Fri,  6 Nov 2026 12:36:52 -0300
Message-ID: <20261106153710.2498773-1-pc@manguebit.org>
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
 - umount -f aborts the retries, reconnect waits and replay loops of the
   mount's requests, and writeback no longer blocks in the reconnect or
   credit waits so the unmount's own sync can't hang there

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

Patches 2-4 are netfs fixes the cifs patches depend on: patch 2 is
Ivan's (20261028181229.1408342-1-ivanrwcm25@gmail.com), keeping the
prepare_write() errno across a reissue; patch 3 does the same for
prepare_read() when read retries are abandoned, and patch 4 keeps such
a read from hanging.

Not covered by this series:

 - after a umount -f that fails with -EBUSY, reads and writes retrying
   (e.g. across a reconnect) give up while a remount, freeze or new mount
   of the same superblock waits on s_umount
 - if every writable handle of an inode is O_DIRECT (e.g. mmap of an
   O_DIRECT fd), its unaligned writeback still fails, with the error
   reported

Thanks,
Paulo

Changes since v5:
 - new netfs patch so an abandoned read retry can't hang the read
 - durable reopens: never fall back to a reconnect once the durable handle
   is gone, and replay the fresh open only if it was built and not
   interrupted
 - back off once per retry pass instead of per subrequest, let pieces
   split off by a retry keep their retry state, and fail the remaining
   subrequests once a writeback reopen gives up
 - check a write's credits for a reconnect before sending, as for reads
 - make the writeback reopen's own credit wait fail fast too
 - pin the mount's tlinks during umount -f so pruning can't race it, and
   treat tcons no mount references as dying, so their leftover closes
   and tree disconnect don't hang

Changes since v4:
 - don't let the flusher block the unmount under s_umount in a writeback
   reopen or credit wait, nor a sync(2) racing umount -f
 - keep the forced-unmount teardown from reconnecting and replaying until
   the tree disconnects are done, wake per-user sessions too, and keep
   doing so on tcons no mount uses any more
 - replay a durable reopen only when its fresh open had an unknown
   outcome, tracked per open file, and stop retrying a failed durable
   reconnect as a fresh open with a stale GUID
 - don't let umount -f abort reconnect waits on a tcon another mount uses
 - retry reads that couldn't be sent due to a stale handle or credits
 - resend direct writes cut short by a reconnect as replays, or fail them
   with -EIO under umount -f
 - reopen writeback handles from the worker only once per retry, so a
   dead mount can't tie it up for the other mounts
 - reopen persistent handles from the reconnect worker without waiting,
   rescheduling it only after transient failures

Changes since v3:
 - new patch to stop a mount's tcons from reconnecting and replaying for
   the duration of the forced-unmount teardown, so a reconnect wait or a
   per-PDU replay loop (a close work item in particular) entered after the
   unmount began can't hang cifs_kill_sb(); it also covers tcons shared
   with another mount for those moments, and fails the reconnect worker
   fast so it can't pin and leak the tcon, session, server and cifsd thread

Changes since v2:
 - stop writeback started after a forced unmount (e.g. the unmount's own
   sync) from retrying forever on a hard mount
 - fail writeback sends and reopens fast at every point in
   smb2_reconnect(), not only the first, so a reconnect that starts
   midway can't still block the unmount
 - abort a write's first retry under umount -f even before netfs bumps
   its retry count
 - keep a dying task from looping in the reopen retry, and keep a read
   from looping on a forced -EAGAIN retry
 - track the bad handle (-EBADF) across out-of-order subrequest failures,
   and recheck the handle after the backoff sleep

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

Paulo Alcantara (17):
  smb: client: don't write back through O_DIRECT handles
  netfs: keep the prepare_read errno when abandoning read retries
  netfs: don't hang a read whose retry is abandoned
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
  smb: client: stop reconnecting and replaying during a forced unmount

 fs/netfs/read_retry.c      |  17 +-
 fs/netfs/write_issue.c     |   4 +-
 fs/smb/client/cifs_fs_sb.h |   2 +
 fs/smb/client/cifsfs.c     | 191 ++++++++++++---
 fs/smb/client/cifsglob.h   |  43 +++-
 fs/smb/client/cifsproto.h  |  11 +-
 fs/smb/client/cifssmb.c    |  15 +-
 fs/smb/client/connect.c    |  16 +-
 fs/smb/client/file.c       | 483 ++++++++++++++++++++++++++++++++++---
 fs/smb/client/misc.c       |  22 +-
 fs/smb/client/smb2file.c   |   2 +
 fs/smb/client/smb2ops.c    |  22 +-
 fs/smb/client/smb2pdu.c    | 132 ++++++----
 fs/smb/client/smb2proto.h  |   9 +
 fs/smb/client/transport.c  |  19 +-
 15 files changed, 839 insertions(+), 149 deletions(-)

-- 
2.56.0

