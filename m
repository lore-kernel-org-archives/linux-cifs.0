Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671701E130F
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 22:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731105298; cv=none; b=WgiH6hq2gC1YJIsh5WR5nHXOlLX/KNt6KhMJyJ+nmBc+3Ml7voW6BAowok0MnVWH7tRnMrdiPOcmCbXY45mFxnXwO011bxrZ9cT1SzjuZGExv1T1H/cgOlcxAYZGv0T976LiwmFZ0dGlGmfMOLV4W4+Kyf9GV0xLk6D4Q+MlBXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731105298; c=relaxed/simple;
	bh=SxY495CM3RF5NhVkK7ZuveFJBvRpnpE+wP+CCfKbnSI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G15ykFXXcQ0YlfuWjsUpcIfTCMwC8D0Ni+KfBWPUhQ9y7nxmCaT9qTzDq1K76j6JToYto9saDVaTbjNb0up1tFbUrKqaCln7hfJ+kogaZZzS4hZn6l/BIaUm13+ggX/T6eBpbUCl7VmIOcaWufmbIzeOi9sks6xOECvsV+LSyAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=rVD7n6/D; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=lrKJT7B3; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="rVD7n6/D";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="lrKJT7B3"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1731104985; h=from : to : cc : subject : date : message-id :
 mime-version : content-transfer-encoding : from;
 bh=M3PcAgWGn8hQHG99sYUiz7MNvBuSE0VeAi/AiCJrygU=;
 b=rVD7n6/D+rlLHZNILD/oZsymQWXKYOT7ZlCNoRm0SGtOfh39rNiKHK4ExhjdTAj9nWqcx
 x8zrV5lpYdNN4//CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1731104985; h=from : to
 : cc : subject : date : message-id : mime-version :
 content-transfer-encoding : from;
 bh=M3PcAgWGn8hQHG99sYUiz7MNvBuSE0VeAi/AiCJrygU=;
 b=lrKJT7B3Zydx16Dh/RCg5MwuokS8FBf3iQgX1V6Cs+LkWYETOAHEWHsotyzHMSbvElOsw
 11nqL6SJvsI/36ydSHMNzBD+3dU00yRYDTLswTLx5EXxIQgJPmCRADogN9bgUAPnLXkJJlB
 fG6IWnlxfl75M2cuPRpWTsP+GgB5H23vj/0dVySUB0tfVD8TEN7j9lj8Lg8eBRndTmRG+23
 BvZQvpPoEmlTRcz38ZAaNKcFPe5nTEOZO8fT2cqkVoZuSY5i16SX/2P2M6hi9Y1xPf4rJ91
 m3FzaIEBsxi4W9pJBksEe5O4Q7QhocFqPBpLrZ8dWMr2crAGX7o57lAZro8A==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by o-chul.darkrain42.org (Postfix) with ESMTPSA id 0464180CE;
	Fri,  8 Nov 2024 14:29:44 -0800 (PST)
From: Paul Aurich <paul@darkrain42.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: paul@darkrain42.org,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 0/5] SMB cached directory fixes around reconnection/unmounting
Date: Fri,  8 Nov 2024 14:29:01 -0800
Message-ID: <20241108222906.3257172-1-paul@darkrain42.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SMB client cached directory functionality has a few problems around
flaky/lost server connections, which manifest as a pair of BUGs when
eventually unmounting the server connection:

    [18645.013550] BUG: Dentry ffff888140590ba0{i=1000000000080,n=/}  still in use (2) [unmount of cifs cifs]
    [18645.789274] VFS: Busy inodes after unmount of cifs (cifs)

Based on bisection, these issues started with the lease directory cache
handling introduced in commit ebe98f1447bb ("cifs: enable caching of
directories for which a lease is held"), and go away if I mount with
'nohandlecache'.  I started seeing these on Debian Bookworm stable kernel
(v6.1.x), but the issues persist even in current git versions.  I think the
situation was improved (occurrence frequency went down) with
commit 5c86919455c1 ("smb: client: fix use-after-free in
smb2_query_info_compound()").


I'm able to reproduce the "Dentry still in use" errors by connecting to an
actively-used SMB share (the server organically generates lease breaks) and
leaving these running for 'a while':

- while true; do cd ~; sleep 1; for i in {1..3}; do cd /mnt/test/subdir; echo $PWD; sleep 1; cd ..; echo $PWD; sleep 1; done; echo ...; done
- while true; do iptables -F OUTPUT; mount -t cifs -a; for _ in {0..2}; do ls /mnt/test/subdir/ | wc -l; done; iptables -I OUTPUT -p tcp --dport 445 -j DROP; sleep 10; echo "unmounting"; umount -l -t cifs -a; echo "done unmounting"; sleep 20; echo "recovering"; iptables -F OUTPUT; sleep 10; done

('a while' is anywhere from 10 minutes to overnight. Also, it's not the
cleanest reproducer, but I stopped iterating once I had something that was
even remotely reliable for me...)

This series attempts to fix these, as well as a use-after-free that could
occur because open_cached_dir() explicitly frees the cached_fid, rather than
relying on reference counting.


The last patch in this series (smb: During umount, flush any pending lease
breaks for cached dirs) is a work-in-progress, and should not be taken as-is.
The issue there:

Unmounting an SMB share (cifs_kill_sb) can race with a queued lease break from
the server for a cached directory.  When this happens, the cfid is removed
from the linked list, so close_all_cached_dirs() cannot drop the dentry.  If
cifs_kill_sb continues on before the queued work puts the dentry, we trigger
the "Dentry still in use" BUG splat.  Flushing the cifsiod_wq seems to help
this, but some thoughts:

1. cifsiod_wq is a global workqueue, rather than per-mount.  Flushing the
   entire workqueue is potentially doing more work that necessary.  Should
   there be a workqueue that's more appropriately scoped?
2. With an unresponsive server, this causes umount (even umount -l) to hang
   (waiting for SMB2_close calls), and when I test with backports on a 6.1
   kernel, appears to cause a deadlock between kill_sb and some cifs
   reconnection code calling iterate_supers_type.  (Pretty sure the deadlock
   was addressed by changes to fs/super.c, so not really an SMB problem, but
   just an indication that flush_waitqueue isn't the right solution).
3. Should cached_dir_lease_break() drop the dentry before queueing work
   (and if so, is it OK to do this under the spinlock, or should the spinlock
   be dropped first)?
4. Related to #3 -- shouldn't close_all_cached_dirs() be holding the spinlock
   while looping?


Lastly, patches 2, 3, and 5 (in its final form) are beneficial going back to
v6.1 for stable, but it's not a clean backport because some other important
fixes (commit 5c86919455c1 ("smb: client: fix use-after-free in
smb2_query_info_compound()") weren't picked up.

Paul Aurich (5):
  smb: cached directories can be more than root file handle
  smb: Don't leak cfid when reconnect races with open_cached_dir
  smb: prevent use-after-free due to open_cached_dir error paths
  smb: No need to wait for work when cleaning up cached directories
  smb: During umount, flush any pending lease breaks for cached dirs

 fs/smb/client/cached_dir.c | 106 ++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 59 deletions(-)

--
2.45.2

