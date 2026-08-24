Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3B432E12E;
	Mon, 24 Aug 2026 22:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787609210; cv=none; b=UbUgYIqVEUtqrJTYIjA6NOcn0qa9EdmgwmS94nAiGSf+ZEkt5RVMCUJ6CpbpMeNbHbYx6pO9R2GwDpDULQHTyQJXpjxfZXxVjkp85FqY91FxwiNFRWN0WfJBQLq1yH7NR72WtopQROjFtVZq930YLwWx526zonXcE22id/+ZCQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787609210; c=relaxed/simple;
	bh=n8sJirqAL/MBV0zCDuk9VPsuLhc4CNLlMHr4ZMphosQ=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=hrQY7aXZ/wcov+ZqtuGKbFQB2QtIoi8nUwO/nXthA7iyuFO+z2DFQk8i1p8zMt+U2WXHniyLTmrbzCWdd3CE2aXJY9dKJGiTLbkUjvwqVTYTFgOYM73S7pANfscBXGcJX9aDnoGsYMSFon+zl5glMbXZ3kP+/sFq7K7X8FdL6/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=B+Z88aKW; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="B+Z88aKW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:Subject:Cc:To:From:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=FpgZ5xXKZxGeaNs8cH+qovd1GUtXCcwwh73I40sfwF4=; b=B+Z88aKWGlAzk7qTRk96/tALqG
	F06ImnrIrT8BAnuOCSCiGKGuy/hIVDb5q8fVnWaSAljll/64WStAiofexcs+nE1aZQNqiaZnHQ9X2
	1L5wVpSc31aYZ2+obU903G2vBsmkr7z/t33WA3WiHbH2HDrbJ50mvmnCDnYD44xAJrAU1AiMgQ/PW
	8uaufFwwtXSRk37iICXQXNGLX6LtJ5vCI7qOZiri3Lmk1Q0MEUfabmeBTqFHv+hQxU8za1K2fjVkg
	5UJ5llCSqXKarBdgGAXura8i9Jgtk8WEGan6lpzgAonjuVLU9IXZYLCoUvIhVzo3uNjW17KCzupMw
	ysUpxh3g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wycoX-00000000bDT-38Vb;
	Mon, 24 Aug 2026 19:06:45 -0300
Message-ID: <d2674464b7dc751afe232f31411d5379@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: [GIT PULL] smb client fixes for 7.3-rc1
Date: Mon, 24 Aug 2026 19:06:45 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Due to the sudden degradation of Steve French's health, I've inherited
a collection of cifs fixes that I'm not sure whether to send you
immediately or soak in linux-next for a week first.=C2=A0 What approach
would you prefer?=C2=A0 Attached is a pull request for the patches if you
are willing to take them immediately.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit db2ddb87143519e20a95aa36c60b36107b736a58:

  Linux 7.2-rc7 (2026-08-09 14:54:50 -0700)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc1

for you to fetch changes up to 6c322f5cf7476ded7a9a20f7be72462065a03c68:

  cifs: fix loff_t underflow in cifs_remap_file_range() when len =3D=3D 0 (=
2026-08-24 17:08:53 -0300)

----------------------------------------------------------------
There are thirty-three client fixes:

- five sensitive data leak fixes (clear stack and heap cryptographic
  keys/hashes)
- six file size and cache synchronization fixes (fscache cookie
  serialization and truncation handling)
- seven protocol validation and buffer safety fixes (prevent OOB
  access and loff_t underflow)
- six metadata and POSIX attribute fixes (proper hard-link counts and
  setuid/setgid stripping)
- three DFS cache and unmount fixes (prevent target-hint UAF and
  unmount hangs)
- six general client improvements (fix read request leaks, stats
  loops, handle servers that don't support O_TMPFILE)

----------------------------------------------------------------
Bryam Vargas (2):
      smb: client: restore the data_offset bound in is_valid_oplock_break()
      smb: client: reject a tree connect response whose byte count is too s=
mall

ChenXiaoSong (2):
      smb/client: return EOPNOTSUPP for unsupported O_TMPFILE
      smb/client: fix nlink of an overwritten open file

Christopher Lusk (2):
      smb: client: fix request buffer leak in smb2_new_read_req()
      smb: client: set replay flag on the read send-error retry path

Dmitry Antipov (1):
      smb: client: simplify __build_path_from_dentry_optional_prefix()

Frank Sorenson (13):
      cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
      cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() =
under i_rwsem
      cifs: remove redundant size-update block in cifs_remap_file_range()
      cifs: remove dead size-update blocks in cifs_setattr_unix/nounix
      cifs: fix clearing stats for fastest execution of each smb2 command
      smb: client: fix OOB read/write from unvalidated DataOffset in coales=
ce_t2()
      smb: client: fix UAF and buffer leak in cifs_check_trans2() for malfo=
rmed secondary T2
      smb: client: fix ALIGN() overflow in symlink_data() error context loop
      smb: client: fix use-before-check of ReparseDataLength in reparse_buf=
_ptr()
      cifs: clear tcon after cifsFileInfo_put() in cifs_file_set_size()
      smb: client: fix copy-paste error in WSL EA length accounting for $LX=
DEV
      cifs: call pagecache_isize_extended() in cifs_setsize() when extending
      cifs: fix loff_t underflow in cifs_remap_file_range() when len =3D=3D=
 0

Fredric Cover (2):
      smb: client: harden DFS cache against invalid target hints
      smb: client: clear ce->tgthint in free_tgts()

Jiangshan Yi (1):
      smb: client: clear setuid/setgid bit on write with cifsacl/modefromsi=
d/posix extensions

Mohammad Shahid (1):
      smb: client: remove redundant NULL check before kfree()

Thomas Huth (5):
      smb: client: Clear sensitive stack data in smb2transport.c
      smb: client: Clear sensitive stack and heap data in smb2ops.c
      smb: client: Clear sensitive stack data in cifsencrypt.c
      smb: client: Clear sensitive stack data in smb1encrypt.c
      smb: client: Avoid leaking sensitive data to the heap in connect.c

Ze Tan (3):
      smb/client: mark missing nlink values as unknown
      smb/client: preserve open info type across compound queries
      smb/client: decode reparse metadata using its payload type

Zizhi Wo (1):
      Revert "cifs: remove all cifs files before kill super"

 fs/smb/client/cifs_debug.c    |  2 +-
 fs/smb/client/cifsencrypt.c   | 12 ++++--
 fs/smb/client/cifsfs.c        | 21 ++++++----
 fs/smb/client/cifsfs.h        |  1 +
 fs/smb/client/cifssmb.c       |  6 +++
 fs/smb/client/connect.c       |  5 +--
 fs/smb/client/dfs_cache.c     | 33 ++++++++++++----
 fs/smb/client/dir.c           |  8 ++--
 fs/smb/client/file.c          |  1 +
 fs/smb/client/inode.c         | 90 +++++++++++++++++++++++++++------------=
----
 fs/smb/client/ioctl.c         |  3 +-
 fs/smb/client/reparse.h       | 17 ++++----
 fs/smb/client/smb1encrypt.c   | 19 +++++----
 fs/smb/client/smb1misc.c      |  3 +-
 fs/smb/client/smb1ops.c       | 10 ++++-
 fs/smb/client/smb1transport.c | 35 +++++++++++++++--
 fs/smb/client/smb2file.c      |  5 ++-
 fs/smb/client/smb2inode.c     | 22 +++++++----
 fs/smb/client/smb2ops.c       | 13 +++----
 fs/smb/client/smb2pdu.c       | 18 +++++++--
 fs/smb/client/smb2transport.c |  4 ++
 fs/smb/client/trace.h         |  3 +-
 22 files changed, 223 insertions(+), 108 deletions(-)
