Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024588;
	b=sJvUY5R1x/BylO9okgwWdeq9219FU0KxqsmmX5E+2ZMNy0XFql7hcL1pp7B1kY+O7+3I
	 Qc2+A8lep1JvPodbhrLlKt/a5amLax88SCYOt7q+8+MOkAimSh0nt40JcqNER/6NAt70f
	 OAlNsDP9xuy7p4sphmawl3Cj8xgwgkqgo3yforeeYBd9bnHCtdirReOvJR04ejy/98Sdw
	 e/RNnHAKJ/mip37r2LNGKPZ9otawCMWvE1oO/D6Eo33YMFRo3appFai3Tm5k1Y457v/SS
	 t1bZNC2uiW6zOyyZucd4u7v7RWyHbcb8jH8iNb4IsatM8RC/fAGwmeG6zhsjsxr1O3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024588;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=/gcnyWwc3Q9nHXn2cQoktNt1Ix/qEitW8UtUmF1p7p8=;
	b=1/7sotb414DibS+VR//N4EsxISPWXzMuAOj6lYnlzw3Q7pgrMYSjqSpYaCzZryHzw9TK
	 RvV5fdVtWpgbvDRRTMY1VeLK+slvkb8g18pzpjYpz8731+ZoovvoTVmYgJUX0c/SQdIOI
	 hosSzl0Gbj3q/dKwicxhP/fw+cwtnb956sEZS5OGV/+GnUboc4hfpZ+Njn/tWeqVTs/y5
	 oUOmRG26llxtldHVYiZh4H/Fnge1dqvk5m2gyIeUByf6yIq5PBTaCxsuGeDCevYY95AH5
	 PSG9e7GU3zORg90gnqoarvJiLCiAdgXHPAlH3rdMTgY/DroghZa4k/nPaVetS1MaW5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=GVMHflLB;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB8E606A332;
	Sat,  7 Nov 2026 04:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FB8E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=GVMHflLB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=/gcnyWwc3Q9nHXn2cQoktNt1Ix/qEitW8UtUmF1p7p8=; b=GVMHflLBsyjZMNc16tvj6QsLaq
	DGnW07Ga+BRBo+i/jDZSqv/7Lc1jFi2LFSLLRTfIzGWa24Sc921G/C2y7Ow5FzhCcbfSV7G4IwVoY
	5Eb3hrEX/t4Hi2O9EM6JoXGGz8+rhvz4vp/a+Dur4widB/hA2YR3O37RKIf2jNVglJ5AmRc2xM9j9
	Z0SgOMmygIcoD7rs5Fep/nP3AUKum8j4bWmNLWXSnp0kTp8nMZkYWMrPsa2PkcR5/XeSttmdJvWCm
	mjsYk8KqoQNzBxeWdMujyb5T5utsdeoQIILmt9pf+QsXh3kXgxrHHNg3j4Efg3i+WeDypEtGWU6wF
	x7tuHqmA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkK-000000015LI-05dd;
	Sat, 07 Nov 2026 01:09:41 -0300
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
Subject: [PATCH v8 00/19] smb: client: fix data loss in writeback
Date: Sat,  7 Nov 2026 01:09:21 -0300
Message-ID: <20261107040940.2692656-1-pc@manguebit.org>
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

Changes since v7:
 - count a mount's references on a tcon while its tlink is in the
   superblock's tree, and decide whether umount -f may abort a tcon under
   the tree lock, so pruning or building a tlink can't skew it; wake the
   waiters when a tcon loses its last mount
 - durable reopens: keep the access fallbacks of the create being
   replayed, and treat only a server's answer as settling it
 - writeback reopens: serialize them per request, sharing a permanent
   failure, never block on fh_mutex, and keep the retry state per span of
   re-sliced subrequests

Changes since v6:
 - don't spend a mount's retries on direct writes cut short by a
   reconnect, which are retried regardless, and new patch doing the same
   for reads
 - durable reopens: replay the last create, reconnects included, with its
   access, only if it got no answer, tracking that across SMB2_open()'s
   own retries and leaving it alone after an interrupted attempt
 - split pieces of a retried write take the retry state of the whole
   pass, only one subrequest per request retries a reopen per pass, the
   flusher no longer takes fh_mutex, and a dropped connection is caught
   by the compound credit wait too
 - keep a tcon dying when mounts sharing it are force-unmounted
   concurrently, and never reuse a tcon that no mount references
 - point the close patch's Fixes: at the commit that made it wait

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

Paulo Alcantara (18):
  smb: client: don't write back through O_DIRECT handles
  netfs: keep the prepare_read errno when abandoning read retries
  netfs: don't hang a read whose retry is abandoned
  smb: client: let umount -f abort retried reads and writes
  smb: client: don't give up writeback on the first replayable error
  smb: client: don't retry failed writes forever regardless of mount
    options
  smb: client: don't spend read retries on reads cut short by a
    reconnect
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
 fs/smb/client/cifsfs.c     | 187 ++++++++++--
 fs/smb/client/cifsglob.h   |  48 ++-
 fs/smb/client/cifsproto.h  |  12 +-
 fs/smb/client/cifssmb.c    |  15 +-
 fs/smb/client/connect.c    |  58 +++-
 fs/smb/client/file.c       | 599 ++++++++++++++++++++++++++++++++++---
 fs/smb/client/misc.c       |  22 +-
 fs/smb/client/smb2file.c   |  15 +-
 fs/smb/client/smb2ops.c    |  22 +-
 fs/smb/client/smb2pdu.c    | 147 ++++++---
 fs/smb/client/smb2proto.h  |   9 +
 fs/smb/client/transport.c  |  22 +-
 15 files changed, 1019 insertions(+), 160 deletions(-)

-- 
2.56.0

