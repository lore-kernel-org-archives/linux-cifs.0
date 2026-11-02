Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632541;
	b=xFh1+cKuv02DD6fMbBynSpqnofv/CztW1ssyEqWEC2Z63p/Hqe+nwehRRjZuzANHQSFZ
	 5byO9xVMERMfyj4edQdBstTq/S5x5z8yjvIgp+St3cnsZYJQrcMdFl4N+i6no1mR1KO8b
	 m259UJc0wSbgms5eHUlLJr/tmTxwVypwT0n0O3O4Ul4ARDEmSrmMj05HdB0v+OE5FLObc
	 lG2h6ZWyAtkdT6srThZWMIYIor1mzqFry8N3gC7T/Z9/IzOVEKrm3Z301vs20KtvPjph2
	 xsfzoMJ0luArgjqgKpqYLuZvOZHNCiGf0vGSXUHsw+WafUc5dWv0P5tXt+kNrS0e+vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632541;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=t5XMK8fX1ODVt+XRhOo7ezBUw2V7gunMfrulrUxZdAg=;
	b=Eh7OjiThyCs/fDbOrpeOAe10piWsQEjMgPxycRpo1j8aaQWcZCuMQ/z/53tU2EIT9BsV
	 2HpUt7oZXygY/gv7/ImYhpsYjxe2laDjBhg3cD/nSOzGhaF3QQ95wU99c+s6Ci4u7Q1V/
	 9F8yrvz9pTjANKI+UlWOqFdlzfFij9E8A765xqoXErrqjOR4OmEzKtu3M6wcJ5wi4e5hq
	 jOMhacOvz3iMuurt4+IkCoS1y17v/sy7JCZt868eHnPPESs1L4396Pb9Q7NQYf39EHqm5
	 XQQ9WbKVCD5h8bbFEtuSznxquUBCj5BfaaN7jedzoMe/DNL1kqMSSKKuzwVB1asraXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=OGDOQqss;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0304560B57DA;
	Mon,  2 Nov 2026 15:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0304560B57DA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=OGDOQqss
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=t5XMK8fX1ODVt+XRhOo7ezBUw2V7gunMfrulrUxZdAg=; b=OGDOQqss1rV+zM6cDWwBM3qcfZ
	k5pSRLhsAcTG9F58EKM5GfinkK6KR96/m2S2LlSzvXVm4pga1FpmChd2ABFMqev1qDIADivkPQZEZ
	btoi8e/M6BEwxV1UNthM6ecuazg2nZDJJzxr0Big9jHy5KYfeY3s9M3vhL4tKB+nEGY9p8p/IeANL
	qW2Z5BHJY0OpxY0QTv/+7ecI7VhEEiyEMjaRi5sm3eE56iZy9HVfTSzd80dEkiWIunq+e0IpgPsRh
	TK0KtOs4FGkyPK+0j2ujO0GFWKkTieq6qkXmKC08vBpuJH91Q66d7TcQgVoV+wQ+VC3r58bF5UnNi
	zFg9UlvA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtkq-00000000aQR-38FV;
	Mon, 02 Nov 2026 12:15:25 -0300
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
Subject: [PATCH 00/15] smb: client: fix data loss in writeback
Date: Mon,  2 Nov 2026 12:15:10 -0300
Message-ID: <20261102151525.925058-1-pc@manguebit.org>
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

 - writes of a dying task are issued from a new workqueue, and the waits
   on close() and fsync() are killable (patches 8-10, 12)
 - writeback is retried with exponential backoff, up to 2 seconds, on
   replayable errors, interrupts, -ENOMEM, and on losing the connection,
   the share or the handle (patches 6, 7, 11, 13, 14)
 - reopening a handle is retried the same way for all kinds of I/O,
   instead of looping forever on -EAGAIN (patch 14)
 - umount -f aborts the retries and the reconnect waits of requests that
   started before it (patches 5, 15)

On hard mounts writeback is retried until the server comes back or
umount -f.  On soft mounts it gives up after max(3, retrans) *
echo_interval from the first failure of each write, which is 3 minutes
by default.  Since cifs only declares a server dead after 3 echo
intervals, that is about 6 minutes from the outage.  The error recorded
then is -EIO.  Reads and direct writes still follow the hard and
retrans mount options.

Patch 1 is independent: writeback could pick a handle opened with
O_DIRECT, and Windows rejects unaligned writes on those with
STATUS_INVALID_PARAMETER.  The pages were dropped, 1.2% of the writes in
xfstests generic/051.  It is first so it can be backported on its own.

Patches 2-4 are netfs fixes the cifs patches depend on.  Patch 2 is
Ivan's, taken from his posting
(20261028181229.1408342-1-ivanrwcm25@gmail.com).  Patch 3 stops netfs
from retrying writes while subrequests are still being prepared, which
raced on stream->sreq_max_len.  Patch 4 keeps the ->prepare_read() errno
instead of -ENOMEM when read retries are abandoned.

Tested against a Windows server:

 - a reproducer for the problem above: a writer is killed with SIGKILL
   while close() flushes a large write, or a multithreaded program exits
   right after writing without closing the file.  The file is then
   renamed, stat()ed and checked on the server.  The data is lost
   without the series
 - xfstests generic/051: no rejected writes left after patch 1
 - umount -f with writeback in flight
 - a soft mount with the server down for shorter and longer than the
   retry window
 - reads with a handle that has to be reopened after a reconnect

Not covered by this series:

 - writeback started by the unmount itself after umount -f can still
   wait on a hard mount
 - tcons shared with other mounts and the per-user tcons of multiuser
   mounts are not covered by umount -f
 - credit waits and the shutdown ioctl don't stop on umount -f
 - if every writable handle of an inode was opened with O_DIRECT, its
   unaligned writeback still fails, and the error is reported
   (e.g. mmap of an O_DIRECT file descriptor)

Thanks,
Paulo

Iván Ezequiel Rodriguez (1):
  netfs: preserve prepare_write errno on reissue

Paulo Alcantara (14):
  smb: client: don't write back through O_DIRECT handles
  netfs: don't retry writes while subrequests are still being prepared
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

 fs/netfs/read_pgpriv2.c    |   3 +-
 fs/netfs/read_retry.c      |  16 +-
 fs/netfs/write_collect.c   |   2 +
 fs/netfs/write_issue.c     |  16 +-
 fs/smb/client/cifs_fs_sb.h |   1 +
 fs/smb/client/cifsfs.c     |  35 +++-
 fs/smb/client/cifsglob.h   |  15 ++
 fs/smb/client/cifsproto.h  |   5 +-
 fs/smb/client/cifssmb.c    |  15 +-
 fs/smb/client/file.c       | 320 ++++++++++++++++++++++++++++++++++---
 fs/smb/client/misc.c       |  16 +-
 fs/smb/client/smb2ops.c    |   9 +-
 fs/smb/client/smb2pdu.c    |  55 +++----
 fs/smb/client/smb2proto.h  |   9 ++
 14 files changed, 427 insertions(+), 90 deletions(-)

-- 
2.56.0

