Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBACD48F014;
	Thu, 10 Sep 2026 15:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789055146; cv=none; b=YvVgdMQyerq5ZlrsLxbnxf3VBmkWxOrgjk1f45Z4Rxuhw8pybC+t1l3BTxtqjwnd+jKHN5LcQd0m0m7ipj0/GjXKgHRDGY71UC/MU0QkRqMzQSDyvtyHqKLxtsS2tX0hgAa3ZPcNJ3fW6wV9bpNRnL/Xus6F1CB5K+rLuSod5yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789055146; c=relaxed/simple;
	bh=7SB5qyohHH+hDP9LCv7Qz6cDndRdllhbweSCueLi6Wk=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=pwamt0rpSubAxEF6aI2JxAoCnNzr6PKWBv352xwb1lzxzyeYmW5YGP/NUysDYv9hHGUt3POkB8jSlzM8WL2+Paq249/9roGm6aQaqMnyZqJ7qfYp5AwX2gRWqn9JfZ2ZtgdQn5t391ALu4ZskEAf62AXg/H1RatmDNuulo01jLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=36slLMdu; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="36slLMdu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:Subject:Cc:To:From:
	Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=WesXDRHOFhnI+QD4gqp8GWvY93+z4uLfHjnUTfl9m+Y=; b=36slLMduVuNDfk9FShAHoH17SI
	rcaLfy6kbaxJ3LcqEvsP36RhBT9FySRENpq6pcXs6nUFP/QzJ0xoKaLjh+EkszE8q3G2azABy96/X
	9pix9qwAeonFfi7f1zbihKjeg7KB/fzVHARvlSNs6vxH7ccGeKkHSICaroeODkkm+Vn9qcmn8mka+
	avO9Gmkt3uR3d5SQGCakBepvO+/yYJqFuubmPzeQDF9U13XYQ4UBjxIpxjELuqqVysDXay8D0edhU
	aoY/5kBI9Cv+FNWj9ZUHKwqLNmERwGkT97A1T7PmaU3cP26504e60/stHCBmeiQJylh+RrJTkwTpa
	oQ1/ecLA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x4gy5-000000018V6-3urn;
	Thu, 10 Sep 2026 12:45:41 -0300
Message-ID: <bb769b6f6f976d75cbfca3ed00556bde@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: [GIT PULL] smb client fixes for 7.3-rc3
Date: Thu, 10 Sep 2026 12:45:41 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Linus,

Please consider pulling these smb client fixes for v7.3-rc3. They
address file type corruption in reparse point handling, uid/gid
ownership mapping bugs, heap overflows in DACL rewriting, reference
count leaks, a DFS use-after-free and hardening of legacy smb1 input
validation. All fixes are for stable.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit 89a312991dc6e638a36adc43ccb91dbc25504c04:

  Merge tag 'cifs-fixes-7.3-rc2' of https://git.manguebit.org/linux (2026-09-01 13:37:14 -0700)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc3

for you to fetch changes up to cb26524ef4ac28fcfa554c0656e8dc412c38a8ff:

  smb: client: fix one-byte OOB read in smb2_parse_native_symlink() (2026-09-09 22:06:05 -0300)

----------------------------------------------------------------
smb client fixes for v7.3-rc3

A batch of bug fixes for the smb client:

 - File type corruption fixes in reparse point handling: setting S_IFMT
   bits without clearing the existing type first corrupted the file mode
   (e.g. S_IFREG | S_IFCHR == S_IFLNK). Fixed in the WSL, POSIX and
   native symlink reparse parsers. Also fixes an uninitialized SID
   structure in the POSIX readdir path when parsing fails.

 - Ownership mapping fixes: forceuid/forcegid mount options were
   ignored in several code paths (SID-to-id mapping, WSL extended
   attributes, POSIX extensions getattr), allowing an untrusted server
   to dictate local file ownership despite explicit mount overrides.

 - Heap overflow and overflow fixes in DACL rewriting: replacing short
   SIDs with long ones could overflow the DACL buffer, and the u16
   accumulator for DACL size could wrap around with enough ACEs.

 - Reference count leak fixes in oplock break and deferred close:
   duplicate oplock breaks on a queued work item leaked a
   cifsFileInfo reference, and deferred close had a similar leak when
   requeueing a running work item. Both cause busy-inode oopses on
   unmount.

 - DFS superblock use-after-free fix: the iterator callback stored a
   raw superblock pointer without pinning it, racing with automount
   expiry.

 - One-byte slab OOB read in the native symlink parser when handling
   share-root relative paths.

 - Hardening of legacy SMB1 input: reject userspace-crafted
   cifs.idmap key descriptions that bypass kernel origin checks, and
   validate DataOffset in CIFSSMBRead() to prevent heap info
   disclosure from a malicious server.

 - DFS cache fix: defer metadata updates until target copying
   succeeds to prevent partial-state cache entries on allocation
   failure.

----------------------------------------------------------------
Aohan Mei (1):
      smb: client: reject userspace cifs.idmap descriptions

Bjoern Doebel (4):
      smb: client: avoid leaking refcount in cifs_queue_oplock_break()
      smb: client: avoid leaking refcount when cifs_sb_tlink() fails
      smb: client: fix heap overflow in DACL owner/group rewrite
      smb: client: fail DACL rewrite when the new DACL exceeds 64K

Diego Oliva (2):
      smb: client: reject short READ responses in CIFSSMBRead()
      smb: client: reject out-of-bounds DataOffset in CIFSSMBRead()

Fan Wu (1):
      smb: client: fix cifsFileInfo reference leak in deferred close

Fredric Cover (1):
      smb: client: fill cache fields after populating cache in copy_ref_data()

Karl Mehltretter (1):
      smb: client: pin DFS superblock in iterator callback

Paulo Alcantara (8):
      smb: client: fix uid/gid override in getattr with posix extensions
      smb: client: honor forceuid/forcegid when mapping SIDs to uid/gid
      smb: client: fix WSL reparse point uid/gid override
      smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()
      smb: client: fix file type corruption in wsl_to_fattr()
      smb: client: fix file type corruption in posix_reparse_to_fattr()
      smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
      smb: client: fix one-byte OOB read in smb2_parse_native_symlink()

 fs/smb/client/cifsacl.c   | 95 ++++++++++++++++++++++++++++++++---------------
 fs/smb/client/cifssmb.c   | 26 ++++++++++---
 fs/smb/client/dfs_cache.c | 18 ++++-----
 fs/smb/client/file.c      | 22 ++++++++---
 fs/smb/client/inode.c     | 17 ++++++---
 fs/smb/client/misc.c      | 24 ++++++------
 fs/smb/client/readdir.c   | 17 +++++++--
 fs/smb/client/reparse.c   | 33 ++++++++++------
 fs/smb/client/trace.h     |  1 +
 9 files changed, 172 insertions(+), 81 deletions(-)
