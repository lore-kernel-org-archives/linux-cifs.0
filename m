Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827702;
	b=ZZyrSpFcBK7XIQQpOJYOHg5CRlesp8zETQLpqLr6fJ7meeaVanKo/NAuixxfCrOU9zHE
	 l9RPuXXShzuN0OH8aXExA7i0v5Ev1VLfH0heo8goyH+wpM9HgrPipKorTM0RbB4HL7965
	 ELns4gDOr0i9vKpaTyyIcxi4H6TRpxzVXIcN1+i6qpc1Y1TFsxsqsTU7rMc9y4JfYa84i
	 L2n+wOfdvZgznbjdOJc3ncsraxJgHYVBMibq/q3bL8osVFusB7eVP5hC5g0GmSdav3SnA
	 TJ5stU70IMwBUISsJK4yVHV84MPAWEui3mF2PcFE+Y7I25C2wn9RVr3299wMxaq4gqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827702;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=vR95LxHJk/lHdPMgpfCm5aW8juhltjdfFYjWMbq2oFM=;
	b=tEJE5lZQeIlEKOfv/gjbiGieTLHrk7Jbc9YRitue+30w0sKxkuwmkvOxycoONtrXBdIm
	 omWiFpVjt+qEwVfD3RmkEIUytQLGDt51TiOQc3NGDfXx4vd4xz2GM/Z0i0s0zKA+/7lEp
	 E+TJc+fNFBvIIxSYhicu0rBr6T0cJlBU+Ekox5ZMHjZ90Nd0iGuvOxM6O/aXzQ4kdh5aO
	 QHgM3XK270FyaR5riu94M4V09wgkzhwoTr3Cvi36pmV3fj6leY3FHlyGaI+1LTomHH/uY
	 8zpUNyJV/PONRisrb/m9t0o2ZmhcekKqsZ1nf3K275Wz8icURBwn2F3hFKKcxFoJ7FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Zf8F82gV;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E677606C59F;
	Wed,  4 Nov 2026 21:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E677606C59F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Zf8F82gV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=vR95LxHJk/lHdPMgpfCm5aW8juhltjdfFYjWMbq2oFM=; b=Zf8F82gVKdK7DSs4p9vTYcZrIs
	N06KGgIIOLNY0S0Tascarwbaq5TN+YFtU0IEqlRpLh3xr46pXwPnz1tmqAC+LZUtR/RdxCDqfGqBW
	PyjV/QrsotTdacCBijrpeGZxvJda+jaNOmGM2DOWPuFefntCAJ1uzuatrDhA1/DAHCTOc7/2EieR8
	IXElKAMjY4xPXHbVQ9Rlb1GQKOwJeooGUl7ug3+Fny4NXVI6sV6eW6TdWFXsjTn0TpWXxCEYnby0e
	dfs0DEOwIlkZwN9KVeIpoe5EglGozBBNCXPdYx92c2xWXt5SjL02e2U2nvw6Qh8Gtwt2jpR76aeu3
	ZY3UUGwQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOiWf-00000000rFp-3Ku8;
	Wed, 04 Nov 2026 18:28:10 -0300
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
Subject: [PATCH v4 00/17] smb: client: fix data loss in writeback
Date: Wed,  4 Nov 2026 18:27:53 -0300
Message-ID: <20261104212810.1935575-1-pc@manguebit.org>
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
   mount's requests, and writeback no longer blocks in the reconnect wait
   so the unmount's own sync can't hang there

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

 - the credit wait doesn't stop on umount -f, so a request blocked
   waiting for credits from a gone server can still hang the teardown
 - if every writable handle of an inode is O_DIRECT (e.g. mmap of an
   O_DIRECT fd), its unaligned writeback still fails, with the error
   reported

Thanks,
Paulo

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

Paulo Alcantara (16):
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
  smb: client: stop reconnecting and replaying during a forced unmount

 fs/netfs/read_retry.c      |  16 +-
 fs/netfs/write_issue.c     |   4 +-
 fs/smb/client/cifs_fs_sb.h |   2 +
 fs/smb/client/cifsfs.c     | 165 ++++++++++++---
 fs/smb/client/cifsglob.h   |  19 ++
 fs/smb/client/cifsproto.h  |   6 +-
 fs/smb/client/cifssmb.c    |  15 +-
 fs/smb/client/file.c       | 408 ++++++++++++++++++++++++++++++++++---
 fs/smb/client/misc.c       |  22 +-
 fs/smb/client/smb2ops.c    |  13 +-
 fs/smb/client/smb2pdu.c    | 113 ++++++----
 fs/smb/client/smb2proto.h  |   9 +
 fs/smb/client/trace.h      |   4 +-
 13 files changed, 678 insertions(+), 118 deletions(-)

-- 
2.56.0

