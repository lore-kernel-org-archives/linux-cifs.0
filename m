Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D233485516;
	Tue,  1 Sep 2026 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788293690; cv=none; b=M8rp3zgl93Q18c8GHMDbGbeqghaYp0lOHrA/Wc7fvQWzNB30QHefkZ4qkViD2Sv+u0dPN8jVb0l9rRaoUoED/o4x2typ5LsqBbQtIkWv3VRX5TKsZ2TL3OZTVcyuwJCSArAMY+dwQkGdrqfLlhwR97fIApd1+zjzo0ASvCgQM/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788293690; c=relaxed/simple;
	bh=cONvZ9VMq397XbxuAVnhR5tBd6PC1wL0EzVZTTnTiCw=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=Zc9iI3olr1kveuWdWUTDVUaeLyCa0nr9LhwGMMzSTgAieRB8wbBMhi8YrUhrYhqbKiJScEOE76pVOTdmFdRsd9UkNyvwpGMPtUlks5AL39RzpMFbqFC1JPqbl5G3FTHLwilz8TKY/ceGtOJPmgurArvkKf9Pek8EuJBXnYpJ2QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=9acK4i5K; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="9acK4i5K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:Subject:Cc:To:From:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=gVULXO/0fQg84dpKqhqqkw+U2olTmmNeBB81/cbxFgw=; b=9acK4i5KKRpgynOEoP2Xc5f7o2
	7G3zmCmRWfNzKPNYCk3rfB0GKBPpk3tC4+/sxS/TUPHWQVaLYpgTIBqubaffIrnim2OMapB3KIML0
	ZMxiKy0qJeEL2a8blI19ImH+Xm5Mn0rmADf4q6hK5IeS/zRs5dLScPg3RHeynDElZDKrRikbhtBsU
	n55++tCSHV6ibt9mQc5yyB6FpCnZ8pDbMYcVeJ9zPA861z290VRst9mNZJUBbZMC8O/KSz2qa3PbH
	8N8so+/w8KOlabJJGJKmjLYUyCLRfOsbo21YnSL1GmQqZRIZJIAcx+ahWG7sSzLN3DHlFHZtjm1Yi
	pCBjwQDQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x1UsX-00000000SFa-2Ptg;
	Tue, 01 Sep 2026 17:14:45 -0300
Message-ID: <9b4b26eaff2ed89ee2da77e8d32881fb@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: [GIT PULL] smb client fixes for 7.3-rc2
Date: Tue, 01 Sep 2026 17:14:45 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Linus,

Please consider pulling these SMB client fixes for v7.3-rc2. They
address data corruption in fallocate range operations and O_TRUNC with
concurrent writes, heap overflows in SMB1 extended attribute and ACL
handling, a krb5 multiuser mount regression and a minor debug print
fix.  All fixes are for stable.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit 45c13f3f9e3bb15fd89ff2864c6f627a3b4b4229:

  Merge tag 'hwlock-v7.3' of git://git.kernel.org/pub/scm/linux/kernel/git/=
remoteproc/linux (2026-08-25 14:21:47 -0700)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc2

for you to fetch changes up to 4aa2c106aef4bf3dfd97c30842db0767b26e8428:

  smb: client: reject SetEA requests that do not fit the request buffer (20=
26-08-31 12:01:07 -0300)

----------------------------------------------------------------
SMB client fixes for v7.3-rc2

A batch of bug fixes for the SMB client:

 - Fixes for fallocate range operations (insert, collapse, zero, punch
   hole): the insert range implementation copied overlapping chunks in
   the wrong direction, corrupting file data on every server except
   Windows.  Several related issues in the same area are also
   addressed =E2=80=94 stale page cache and FS-Cache readback, an integer
   truncation on large files, missing RLIMIT_FSIZE validation and
   missing sparse file marking.

 - Data corruption fixes in the O_TRUNC open path: one where i_size
   was zeroed before the server confirmed the truncate and another
   where the lack of locking allowed concurrent buffered writes to be
   silently discarded.

 - Heap overflow fixes in legacy SMB1 paths: one in extended attribute
   writes and one in POSIX ACL handling, both exploitable via
   unprivileged setxattr(2).

 - Fix for multiuser mount with krb5 failing because the username
   option was not propagated to new per-user connections.

 - Fix for split debug message in __release_mid() after a printk
   conversion.

----------------------------------------------------------------
Andy Shevchenko (1):
      smb: client: transport: Fix debug printing in __release_mid()

Frank Sorenson (3):
      cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
      smb: client: fix heap overflow in cifs_do_set_acl()
      cifs: don't update i_size in cifs_do_truncate without a cached handle

Huiwen He (7):
      smb/client: validate new EOF for insert range
      smb/client: validate new EOF for zero range
      smb/client: mark file sparse before emulating insert range
      smb/client: fix data corruption in emulated insert range
      smb/client: fix integer truncation in collapse range
      smb/client: fix stale page cache in insert/collapse range
      smb/client: invalidate fscache for fallocate range operations

Paulo Alcantara (2):
      smb: client: fix multiuser mount with krb5
      smb: client: fix data corruption with concurrent writes and O_TRUNC

Yunpeng Tian (1):
      smb: client: reject SetEA requests that do not fit the request buffer

 fs/smb/client/cifssmb.c   |  24 +++++-
 fs/smb/client/connect.c   |  21 +++--
 fs/smb/client/file.c      |  36 +++++++--
 fs/smb/client/smb2ops.c   | 195 +++++++++++++++++++++++++++++++++++++-----=
----
 fs/smb/client/transport.c |  11 ++-
 5 files changed, 231 insertions(+), 56 deletions(-)
