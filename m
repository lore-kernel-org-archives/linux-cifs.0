Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793402803;
	b=TUKD0ABalskbRImHqXUiV2fS8Y0ND3ZddIB7QHuBjSKGDnaqXLuq39nWGR8OZUQXqTHY
	 12aq0JcXDc6PIi6VN4gAzs3OTYoSVNbU+6liSIHQk9gR2IC7joNIbS/UW0sl4Od/5lx2h
	 wSZHjJ2SBsdgpoDjeHH4P+hgImJLltlGP8WAQfsUlXpwpEUSskRYXVw4cKU83mnBfcIBM
	 5QxCd7TjKkreI0cuRUpBQByHOTWVpaJiLLmNxRuZhJtEQ7vB5qfcoK6CRyASgaHdVznnF
	 4lskX8/noIusJYwNIVKkG9tGjp0r+5A/LD2O7uiLB+IOLo6dOzwmn3jXEwVruGydV7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793402803;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 Date:MIME-Version:Content-Type;
	bh=uH3MMXivwVlKAbM0AnFGxPhpvswthgfKBenxQr90AVg=;
	b=3rDhq+cqvz0A1ndDL/XEbSYuRC+jpILsv7Fe/0DDx7RAERINJSNsBzpmY9K8e0azqYcD
	 0gQYibGtaU+FxNC3ZIrvgIxt/Js8cP/j8229cA/ROTot5CcTWXNkLYOKgxCEMJvJKZUVk
	 NVRT1ht4TninxPSTEkFreRhKGsK1EgY4thGUoi0uNXDZeAP6q3Yf1VNeSMqOKCkN8glkX
	 dWMm09xe08Fz/okbYeBBW20zPaheFQBQGtCaJeCAhslrVFVpTebLLX3pNi8rrwKhbaODk
	 zDXBMtSnecxjBeHKCItxl5VK30FTBaXwiX+Aaxv4W/BjbgEpZFYPZZ1mQ99UU2dsKIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="ebM/LpWH";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF77606A31A;
	Fri, 30 Oct 2026 23:26:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FF77606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=ebM/LpWH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:Subject:Cc:To:From:
	Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=uH3MMXivwVlKAbM0AnFGxPhpvswthgfKBenxQr90AVg=; b=ebM/LpWHynyGey3WTvFGDhLbfv
	FpoX0hAuqYfC208/MCIeHWwTfFgCQfJEctyBsfdbR/WBKiRZgo8YmEajpxNLXqbzfvYE8ahTnDjAE
	LXi8PdhI5FzB9ftu2t0oMa+2D1g5nF1a8MPT9ghyDUTin7LXJjQK0BSksO5YiDXmyhCNXPs9ISPCg
	CezIOyORpMaqQg8/xNvUDDdNRhJZuFkvAEGXE2KiCf0UAyP32WAzphZa9YkW4jUUp/+CQduFOaY4a
	RZpFCxDmKGGTNqD2XQ7p9WtIFDw38+LFk692kWyiOICbXtl8yD/tVIrfcZgNZui29KavmhSgN/yMV
	80hOHwtA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xMvzU-00000000QV2-2tNE;
	Fri, 30 Oct 2026 20:26:33 -0300
Message-ID: <d18e86791a96cef6259f9f23c9714576@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: [GIT PULL] smb client fixes for 7.4-rc1
Date: Fri, 30 Oct 2026 20:26:33 -0300
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

Please consider pulling these smb client fixes for v7.4-rc1.  All of
them are for stable.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit 2c455ddca7827ad8fa3a64fdbf5a60efb928b46a:

  smb client: fix mis-merge with fileattr_set taking a const idmap (2026-10-20 18:27:33 -1000)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-fixes-7.4-rc1

for you to fetch changes up to ddc7a7e1eeb116ccaf010a6f1fb6ab927f3f888d:

  smb: client: validate SMB1 EA list bounds before parsing (2026-10-27 11:01:20 -0300)

----------------------------------------------------------------
 - Validate the offsets and lengths a server puts in its responses before
   using them, so that a malicious or broken server can no longer make the
   client read past the received data: POSIX lock data (which leaked
   kernel bytes through F_GETLK), NT transaction responses and SMB1 EA
   lists (both wrapping their pointer checks on 32-bit), short
   SESSION_SETUP responses (which sent stale buffer content back to the
   server in the NTLMv2 AUTHENTICATE message), SMB2 READ data areas and
   empty truncated fiemap responses

 - Fix a heap overflow in SMB2_tcon() with UNC paths longer than
   MAX_SHARENAME_LENGTH

 - Fix a slab-out-of-bounds write when chmod() rewrites a security
   descriptor that needs more room than was reserved

 - Fix a use-after-free of the server info between the cifsd thread and
   the release of the last session reference (reported by syzbot)

 - Fix a use-after-free in the demultiplex thread when a receive error
   reconnects and frees the read request still being processed

 - Fix a double teardown of a tcon that the cached directory laundromat
   took a reference on while it was being freed

 - Fix a NULL pointer dereference when /proc/fs/cifs/DebugData is read
   while the module is still initializing

----------------------------------------------------------------
Abdifatah Suruur (3):
      smb: client: reject short SESSION_SETUP responses
      smb: client: validate the data area in SMB2_read()
      smb: client: fix fiemap wild read on empty truncated response

Dominik Maier (1):
      smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()

Eduard Zateev (1):
      smb: client: hold server info until cifsd exits

Fredric Cover (1):
      smb: client: fix early procfs exposure race

Luxiao Xu (1):
      smb: client: fix buffer overflow in SMB2_tcon()

Paulo Alcantara (1):
      smb: client: don't resurrect an exiting tcon from cached dir workers

Ratnaker Gautam (3):
      smb: client: bound POSIX lock data area by response length
      smb: client: validate NT transaction response layout and offsets
      smb: client: validate SMB1 EA list bounds before parsing

Weiming Shi (1):
      smb: client: stop processing a read response after a receive error

 fs/smb/client/cached_dir.c | 30 ++++++++++++++-------
 fs/smb/client/cifsacl.c    |  9 ++++---
 fs/smb/client/cifsfs.c     | 20 +++++++-------
 fs/smb/client/cifsglob.h   |  2 ++
 fs/smb/client/cifssmb.c    | 66 ++++++++++++++++++++++++++++++++--------------
 fs/smb/client/connect.c    | 33 ++++++++++++++---------
 fs/smb/client/smb2misc.c   | 16 +++++++++++
 fs/smb/client/smb2ops.c    | 30 ++++++++++++++++++---
 fs/smb/client/smb2pdu.c    | 46 +++++++++++++++++++++++++++-----
 fs/smb/client/trace.h      |  1 +
 fs/smb/client/transport.c  |  2 ++
 11 files changed, 191 insertions(+), 64 deletions(-)
