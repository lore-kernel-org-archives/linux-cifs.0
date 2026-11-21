Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795280028;
	b=cT1iM9GMtwiY4h+f3U1mnmDOcgNU/MEza+IptAnM+vk1GKbM/tmgb9bWLB+EAzs7cEj9
	 6bj0pPiKHtX38bgVe2DYrrweIakC3ZKVByUj4JXWPpAnKENWZHziPn0WWe4MPnT+Ev5H0
	 V6VCZBul//hnoNaR+r6o5B+BiWhe9Iy8OFINS+NRtvR5RH8BdwIWc6DKsdkME4tgknYsf
	 05es9g2eOSA4MPo+rOVHkk/sydvA4EP0aExt6nJyon7I0FMoYmaMPfLCeG7A9xZrvBXur
	 tBmdTnC6EgoDbZFrt/o+Dylz1J5qqk0c1x/ZofVzCdYv9NwnVJaAHVOoU2xX2kH3GAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795280028;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 Date:MIME-Version:Content-Type;
	bh=71/vZ+6SlAhlKpr2/pRAGRVZmNz47utIjOuG4CCzQE8=;
	b=z7b9ujm6N0G+ZP6sHc6vSgwniwsSlthBL55Q1OyC1dVqy5zWBUOaWgzZuXy6m2Hwf1qU
	 H91HRq88235oD/jLBhpH+AZ+q/U5ajsjpouSDwQOP9dhtAZvYxqSLMpzLtKu0A44Eckfb
	 XTQB7F+/NW48AkfiYjws3z8xYazxCwZiW6ESGAMzA93PRNrRMXa5ywrNuxchAX9skzxuk
	 3r8njqHjBeGbpC9axaEEdLESnfHGStWpeqdu4y7q3m0sjKNG+slX94McT2UFGLsJld8ec
	 YBmwo0Gjg9tFLjzQO25ngIEOqQOW7I8yAImXx+PjA8h1A+19OxYuohnog0eTEypjtJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="gKMiCl/h";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E4A606A320;
	Sat, 21 Nov 2026 16:53:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3E4A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=gKMiCl/h
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:Subject:Cc:To:From:
	Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=71/vZ+6SlAhlKpr2/pRAGRVZmNz47utIjOuG4CCzQE8=; b=gKMiCl/hc8t4mdWPpP5n3dF1RB
	MfzJlSu/P7ncgIKp7fpRFVEPjXYdR09KCyEiEIbNQ9CPzGFS+OnnnOYBdJVdDHt7dgBZq/m5cJxT7
	f03nd0NYYC2pCZyKCs2RI4rN0koQqxGuYhu9XEMePoMzyYJSpbiGow/9rk02T+RmwfW6wmH59rJSc
	llh/ln7wrm9urq58+BMbEAaup9y5+YKZ2DZn1UA+/0KFDHc0gwijeUzXOIoBER0zPJrqWhTTYtncL
	Y7H6BU/EjgA8wWEH+FWSt6O2HueaE7F7pRPVMs7us0z0tQZpkCh2YGghbQDF/KBndH+i2jrVlNzqI
	FWsPRuFA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xUoLL-00000000ZrI-2kzA;
	Sat, 21 Nov 2026 13:53:39 -0300
Message-ID: <bada6649ca5eb9e4603216c71aff0a85@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] smb client fixes for 7.4-rc4
Date: Sat, 21 Nov 2026 13:53:39 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Linus,

Please consider pulling these smb client fixes for v7.4-rc4.  The main
ones are a server-triggerable use-after-free and two fixes that stop the
client from accepting SMB2 responses and read data with a bad signature;
the rest are a couple of busy-inode-on-unmount races and some metadata
fixes.  All of them are for stable.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit 3db1c74a20f0552fadc2c6886a43feee8894fa19:

  Merge tag 'cifs-fixes-7.4-rc3' of https://git.manguebit.org/linux (2026-11-13 09:56:22 -0800)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-fixes-7.4-rc4

for you to fetch changes up to a1a0ef3ba8e802060bfc2b0ebf131a2cf98c3b71:

  smb: client: don't use read data that failed signature verification (2026-11-19 12:02:54 -0300)

----------------------------------------------------------------
smb client fixes for v7.4-rc4

 - Fix a use-after-free in the netfs write collector that a malicious or
   broken server can trigger by returning a write count larger than the
   request

 - Reject SMB2 responses whose signature fails verification instead of
   using them, so a tampered response on a signed connection is no
   longer accepted

 - Don't return read data whose signature failed verification when the
   read lands at the remote end of file

 - Fix a busy inode and dentry on unmount caused by a late oplock break
   queued after the workqueues were already flushed

 - Fix a busy dentry on unmount caused by a persistent-handle reopen
   racing the unmount

 - Fix creation and change time assignments in the SMB2 POSIX readdir
   path, which clobbered ctime and could give a hard link a separate
   in-memory inode

 - Normalise pre-epoch timestamps read from the server so stat no longer
   reports a garbled time

 - Fix DFS prefix paths being truncated on non-utf8 mounts, where
   path_consumed was applied in the wrong charset and the mount failed
   with -ENOENT

----------------------------------------------------------------
Fredric Cover (1):
      smb: client: convert path_consumed to mount charset units

Siddharth Chintamaneni (2):
      smb: client: fix busy dentry and inode on unmount from late oplock break
      smb: client: fix busy dentry on unmount from persistent handle reopen

Suyuan Wang (2):
      smb: client: fail SMB2 responses with a bad signature
      smb: client: don't use read data that failed signature verification

koraynilay (2):
      smb: client: fix negative timestamps being read from smb
      smb: client: fix times assignments in cifs_posix_to_fattr()

ozgun kultekin (1):
      smb: client: do not let the server grow a write subrequest

 fs/smb/client/cifsfs.c        | 10 +++---
 fs/smb/client/dfs.c           | 77 +++++++++++++++++++++++++++++++++++++++++--
 fs/smb/client/file.c          |  8 +++++
 fs/smb/client/misc.c          |  6 +++-
 fs/smb/client/netmisc.c       |  3 +-
 fs/smb/client/readdir.c       |  3 +-
 fs/smb/client/smb2pdu.c       | 22 +++++++++----
 fs/smb/client/smb2transport.c |  7 ++--
 fs/smb/client/trace.h         |  1 +
 fs/smb/client/transport.c     |  5 +++
 10 files changed, 122 insertions(+), 20 deletions(-)
