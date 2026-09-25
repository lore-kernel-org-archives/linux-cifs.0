Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C9A3EC687;
	Fri, 25 Sep 2026 20:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367330; cv=none; b=WUleexwlxtAd6veCTeXy5ifYLfDIWCNuwC77i40xsUHBo59XFDpiRAOGggmcSMoN/R9KCKtXsCxwWeQbU/OQST3wtValfsJyxKADnoF4ODBUy7HcHiQnmkW4+RQuyb3z0kdskPZz/Amu2L3wMPweWEziO+6P7TSM2NRYTvSMDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367330; c=relaxed/simple;
	bh=bIDBNIy/5chIx5nRU9KfYKK/L5HEQOu4SsTuxvrJXaI=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=TpTo4uxI8w/xlkki0UZ41U2eLP8+4F4DtJ5LF9VIVGl0G7DT6te22BxkzGHdwuZ34Ani9arF0M3cMrG+M4vGtmVaw81poUOxVyHuB7fSfA3QQzo3Ac5MkobYgEbuEHhoH+NdtFjSt5JCktmaPJoowgZRbyC8efXZ+r+Ld8rTmJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=RK/5IDo9; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="RK/5IDo9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:Subject:Cc:To:From:
	Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=xzy9TlQ6M5+iVJFbg6+raosjbZr1YWi/iBB3SrVcAiY=; b=RK/5IDo9v906muKxgLa+sKbB2p
	cPgGoalikBfujg+pXAJCr0Hy6NtdfTP5pzrLuN3y4SqicHcyyOefVkuVWjHTdobXBArMC/C1pmVUu
	tQ52rGlCAJSuVvQMYWRgnkKOt/ERmjn6E2zoxnsrvGV0JaYEvMD1l0hgbbvDZORFU5GfOzYgzgaCN
	23Dl+e02LjJ0De0sEyqhVFBOCAxQ+jziV7al4+aqaesgVyOrz0vRxHwsFXYXPwUQKCFYEAM9JoIJ2
	Miv3+3iUZyTSaiKXfhTi2WpcmmTeS49n6yBdmf3x27O10dq7COy2Q1wdcNFjF50KlpDTBvqYC7l0e
	UwwwtMmA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xACKJ-00000002IDW-1ljq;
	Fri, 25 Sep 2026 17:15:23 -0300
Message-ID: <b3008a6b831ccdad2e1f403795a2d568@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: [GIT PULL] smb client fixes for 7.3-rc5
Date: Fri, 25 Sep 2026 17:15:23 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Linus,

Please consider pulling these smb client fixes for v7.3-rc5.  They
address leaked server handles and dropped errors in the SMB2 compound
create path, out-of-bounds reads when parsing create contexts from a
malicious server, a double credit decrement found by syzbot and a
minor POSIX specification reference update.  Most fixes are for
stable.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit 17e7b8eacf4cac800a4fc89a28729df72a2dabda:

  Merge tag 'cifs-fixes-7.3-rc4' of https://git.manguebit.org/linux (2026-09-18 13:44:59 -0700)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc5

for you to fetch changes up to e66cf1625ec4a3fe68346119f371def713fd0a4d:

  smb: client: use finish_no_open() for non-regular inodes (2026-09-24 10:50:39 -0300)

----------------------------------------------------------------
smb client fixes for v7.3-rc5

 - Fix leaked server handles and dropped errors in the SMB2 compound
   create path: a parsing error reported as success, an earlier CREATE
   left open when a later command fails, the cached directory open
   losing the FID needed for cleanup, and SMB2_open() not closing the
   handle after a create-context parse failure

 - Fix out-of-bounds reads when parsing create contexts from a
   malicious server: bound each context by its Next field, parse the
   lease and QFid contexts from their declared offsets and validate
   the POSIX create context length

 - Fix a double credit decrement, and its warning, when a compound
   send fails and triggers a reconnect; found by syzbot

 - Fix a dentry and server handle leak in cifs_atomic_open() when an
   O_CREAT open resolves to a symlink or other non-regular inode

 - Use GFP_KERNEL in the DFS get_targets() path

 - Minor update to the POSIX extension specification references

----------------------------------------------------------------
Adarsh Das (1):
      smb: client: delete compound mids on send failure before unlock

Fredric Cover (1):
      smb: client: use GFP_KERNEL in get_targets()

Namjae Jeon (1):
      smb: client: use finish_no_open() for non-regular inodes

ZhangGuoDong (1):
      smb: client: update POSIX extension specification references

Zihan Xi (6):
      smb: client: fix create context out-of-bounds reads
      smb: client: validate POSIX create context length
      smb: client: close handle after create-context parsing failure
      smb: client: clean up failed cached directory opens
      smb: client: close completed creates on compound wait errors
      smb: client: preserve create-context parsing errors

 fs/smb/client/cached_dir.c | 32 ++++++++++++++-------
 fs/smb/client/dfs_cache.c  |  4 +--
 fs/smb/client/dir.c        | 52 ++++++++++++++++++++++++---------
 fs/smb/client/smb2inode.c  |  6 ++--
 fs/smb/client/smb2misc.c   |  9 ++++--
 fs/smb/client/smb2ops.c    | 28 ++++++++++++------
 fs/smb/client/smb2pdu.c    | 54 +++++++++++++++++++++++++++--------
 fs/smb/client/smb2pdu.h    | 10 +++++--
 fs/smb/client/transport.c  | 71 +++++++++++++++++++++++++++++++++++++---------
 9 files changed, 200 insertions(+), 66 deletions(-)
