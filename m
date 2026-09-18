Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88844521222;
	Fri, 18 Sep 2026 20:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789764084; cv=none; b=EJmtQn3jn7xNEHH3SysytilzNSeFoF6gbLNOYrTYcBgvh2bIgI23ldD7ooKjnfHjOaTwvrnC9pWrA9E5kW2zaCyeuaaG5a+Basm7XCgdliOztXeCpvBmPij+D/OFZCHSecpUI16AIaXLXPZkSqTAZNu5ZIvmpYc51XjUgQ80Q0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789764084; c=relaxed/simple;
	bh=krnEVcPRjsvI/YheRRigqAj60jRYDADgWthzf5WX6yw=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=Wi8boQYN9yz1aZYGMCcBhEDeimwBtoAnDSvY+oYW3BsrklEE4LMZvOZ7aVCLhbBOaFanAqZ+woSrlurvOMMRyBNsTXksBbRSf5EN3Ul9xcUcuibCQptbosrHTYTkSFkDrDI33CB6Z7EtqzLxedxg2JmygI+5v/N0yx0xDsbOPww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=c+zPaT7a; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="c+zPaT7a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:Subject:Cc:To:From:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Sym3cY4YlURqJS9d12+xAmHD4/clM5+K3eTe1dMcLSc=; b=c+zPaT7aJsIT52dwRUVswWyD+8
	LhO0btr0WcRBADo63tk1Wfa9w/23m7yweE5YUQkgYesgp3iNudWyzXBzAyP36f2mQ8xuph455BFvn
	yiNcyq4Wy9nCd6Expi+EhQuJeSbhujT5DLQuNxYhC9eU9EHE2Ivgfi1uX+3miSFtSw6x8I73NCpsf
	PdBhLC3kZNIgn6gMGL2e2BtcUGdsSH795q3yoqv9RNFk4Rs4f2vuIlTbxbfNXyVTV0vAv93BIooGY
	LCZnXNqx8BMHA+fYrunNMVHFkWXdvXjOYXMDSRtDy90FZfc7pMOa5XQmA8PQ5yoNveMJC5WDiJ87I
	QSI1338g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x7fOT-00000001lpK-25Ip;
	Fri, 18 Sep 2026 17:41:13 -0300
Message-ID: <e1bfb4b2fa19f5f67b17ed2fcf141c7b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: [GIT PULL] smb client fixes for 7.3-rc4
Date: Fri, 18 Sep 2026 17:41:13 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Linus,

Please consider pulling these smb client fixes for v7.3-rc4. They
address out-of-bounds reads and use-after-frees in the SMB2/3 receive
path reachable from a malicious server, use-after-frees and races in
multichannel and connection teardown, a heap overflow in the native
symlink parser, WSL reparse point parsing bugs, wrong-session lease
break ACKs on multiuser mounts and an RDMA connection leak. Most fixes
are for stable.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit 0a96d0d726cd380423ac38e2c28f538db2940a1d:

  Merge tag 'cifs-fixes-7.3-rc3' of https://git.manguebit.org/linux (2026-0=
9-10 14:03:48 -0700)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc4

for you to fetch changes up to 717e0a25036b6c92cecace30913b2d874a4c22b8:

  cifs: Fix server use-after-free in cifs_chan_skip_or_disable() (2026-09-1=
7 19:29:25 -0300)

----------------------------------------------------------------
smb client fixes for v7.3-rc4

A batch of bug fixes for the smb client:

 - Fix multiple out-of-bounds reads and use-after-frees in the SMB2/3
   receive path that are reachable from a malicious or compromised
   server: a stale next_buffer pointer and an integer overflow in
   compound encrypted frame handling, missing minimum-PDU-size and
   per-sub-PDU length validation before parsing command-specific
   response fields, missing bounds checks in DFS referral, server
   interface list, EA list, POSIX SID, snapshot enumeration and SMB1
   reparse point parsing

 - Fix use-after-frees and races in multichannel and connection
   teardown, including an interface freed while still in use when
   adding channels, a server used after its channel reference was
   dropped, a reconnect work item left queued after the server is
   freed and an uninitialized reconnect list node

 - Fix a heap overflow in the native symlink parser: an absolute
   target without an NT drive prefix caused out-of-bounds writes and a
   u16 length underflow leading to a 64K memcpy into a small buffer,
   triggerable by a user with write access to a mounted share under
   default settings

 - Fix WSL reparse point parsing: use unaligned accessors for the
   packed extended-attribute payload to avoid alignment faults on some
   architectures and stop leaving partially mutated fattr fields on
   parse failure

 - Fix lease break ACKs being sent through the wrong session on
   multiuser mounts, which caused read failures (e.g. on NetApp
   ONTAP/Azure Files) when copying files

 - Fix an smbd_connection leak when cifs_get_tcp_session() fails after
   an RDMA connection was already established

----------------------------------------------------------------
April Cardenas (1):
      smb/client: send lease break ACKs thru correct session for multiuser =
mounts

Frank Sorenson (9):
      smb: client: fix next_buffer UAF and NextCommand bounds in compound P=
DUs
      smb: client: validate minimum PDU size before smb2_get_data_area_len()
      smb: client: fix server->total_read for compound encrypted PDUs
      smb: client: fix missing lower-bound check on DFS referral string off=
sets
      smb: client: reject short Next offsets in parse_server_interfaces()
      smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
      smb: client: fix missing iov bounds check in parse_posix_sids()
      smb: client: fix potential OOB read in smb3_enum_snapshots()
      smb: client: fix reparse buffer bounds in cifs_query_reparse_point()

Joseph Qi (1):
      smb: client: fix use-after-free of iface in cifs_try_adding_channels()

J=C3=A9r=C3=A9my Jean (1):
      smb: client: validate absolute native symlink targets before NT fixups

Paulo Alcantara (5):
      smb: client: cancel reconnect work in clean_demultiplex_info()
      smb: client: fix rlist race and missing initialization
      smb: client: fix smbd_connection leak on cifs_get_tcp_session() error
      smb: client: fix unaligned access in WSL reparse point parser
      smb: client: fix fattr leaking on wsl_to_fattr() failure

Wentao Liang (1):
      cifs: Fix server use-after-free in cifs_chan_skip_or_disable()

 fs/smb/client/cifssmb.c   |   2 +-
 fs/smb/client/connect.c   |   9 ++++
 fs/smb/client/file.c      |   4 +-
 fs/smb/client/misc.c      |  12 +++++-
 fs/smb/client/reparse.c   |  58 ++++++++++++++++----------
 fs/smb/client/reparse.h   |   7 ++--
 fs/smb/client/sess.c      | 104 ++++++++++++++++++++++++++++--------------=
----
 fs/smb/client/smb2inode.c |  11 +++++
 fs/smb/client/smb2misc.c  |  69 +++++++++++++++++-------------
 fs/smb/client/smb2ops.c   |  51 +++++++++++++++++------
 fs/smb/client/smb2pdu.c   |  13 +++---
 fs/smb/client/trace.h     |   1 +
 12 files changed, 223 insertions(+), 118 deletions(-)
