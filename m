Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BDC199252
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 21:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731966641; cv=none; b=bVuOqatm5KjMG+/n6+9e+8vl0aPH1tH/N6Z7M1kZqHb59n25ZOm4Uh54L4kdOUhFOOr5bLZ52kCQgbpnOo3jNVb49SkjaIEYxf2yoQztFHN0nET84OR/4CkuIoljyVznRztLoNg77sWZ1a2w1OrGQzbkcRYHe2ecN0ZNWyElkhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731966641; c=relaxed/simple;
	bh=r3gIwCFgARespgglR9gPEzORqU0u9lVcSr2aZqf99uw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fg2zzFFbZJrI7vbRWd5I50utco6Y7snn46n6y2woi2G8qrsIN0aesa7ZIcwXGYkscVYmbCXIoc6EVAdCFFB1BDhaFx9V1V8UJl4UkeJFwvK3Ix6md/T4+Nn/DQAYrLXlu8zRJ/vwYNuj61J0P1F41YiuHMPMo1cY2AtRd/l1rnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=TEHHLPFg; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=qFh+Lvo1; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="TEHHLPFg";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="qFh+Lvo1"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1731966633; h=from : to : cc : subject : date : message-id :
 mime-version : content-transfer-encoding : from;
 bh=CypxzNUY+Fri2KnhnBaoxs+/5wkzepMR1gFO1Z0TrO0=;
 b=TEHHLPFgOAYDzZvkuN1e/cmCPsvaLkFQb5fAqOBck317vyseTYTWmidR7gw8E12y6ZKBF
 0m6Zg+mErk/a3EhAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1731966633; h=from : to
 : cc : subject : date : message-id : mime-version :
 content-transfer-encoding : from;
 bh=CypxzNUY+Fri2KnhnBaoxs+/5wkzepMR1gFO1Z0TrO0=;
 b=qFh+Lvo13DZX5hM57Kr6S3EYL8usZ6GFXEBad0xsJmngpp/XV6iBu1nzsOWAE39KyHgfN
 fczKv+sCfI5v0yKNwuExxKKXhIAbo1yg39pQr+ZW4jtFC9bhi8rbmbQdL4VVLKWvm08GSdP
 BiDg2t5031/HaYvHKcQuhpvIZz2is/S6kcIq5S+UiHksALR7SSIeVu5CtAnYiJJfZWGD7WE
 piDnUeU91jKCPxGTLgVmzIyEuOrflucKVzk3kRAxW92BwbgB+YWzvFg4KK2Ykb4b/K02aZD
 EIOna7jj8wKvEBPC2XyUS713v5kTXwPBTViPn3pNOISEzS3KUWZyE9sr74Xg==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by o-chul.darkrain42.org (Postfix) with ESMTPSA id D38D48379;
	Mon, 18 Nov 2024 13:50:32 -0800 (PST)
From: Paul Aurich <paul@darkrain42.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: paul@darkrain42.org,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH v2 0/4] SMB cached directory fixes around reconnection/unmounting
Date: Mon, 18 Nov 2024 13:50:24 -0800
Message-ID: <20241118215028.1066662-1-paul@darkrain42.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
- Added locking in closed_all_cached_dirs()
- Replaced use of the cifsiod_wq with a new workqueue used for dropping cached
  dir dentries, and split out the "drop dentry" work from "potential
  SMB2_close + cleanup" work so that close_all_cached_dirs() doesn't block on
  server traffic, but can ensure all "drop dentry" work has run.
- Repurposed the (essentially unused) cfid->fid_lock to protect cfid->dentry


The SMB client cached directory functionality can either leak a cfid if
open_cached_dir() races with a reconnect, or can have races between the
unmount process and cached dir cleanup/lease breaks that all lead to
a cached_dir instance not dropping its dentry ref in close_all_cached_dirs().
These all manifest as a pair of BUGs when unmounting:

    [18645.013550] BUG: Dentry ffff888140590ba0{i=1000000000080,n=/}  still in use (2) [unmount of cifs cifs]
    [18645.789274] VFS: Busy inodes after unmount of cifs (cifs)

These issues started with the lease directory cache handling introduced in
commit ebe98f1447bb ("cifs: enable caching of directories for which a lease is
held"), and go away if I mount with 'nohandlecache'.

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
Paul Aurich (4):
  smb: cached directories can be more than root file handle
  smb: Don't leak cfid when reconnect races with open_cached_dir
  smb: prevent use-after-free due to open_cached_dir error paths
  smb: During unmount, ensure all cached dir instances drop their dentry

 fs/smb/client/cached_dir.c | 228 +++++++++++++++++++++++++------------
 fs/smb/client/cached_dir.h |   6 +-
 fs/smb/client/cifsfs.c     |  14 ++-
 fs/smb/client/cifsglob.h   |   3 +-
 fs/smb/client/inode.c      |   3 -
 fs/smb/client/trace.h      |   3 +
 6 files changed, 179 insertions(+), 78 deletions(-)

--
2.45.2

