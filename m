Received: from lgeamrelo11.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AD51F4180
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 10:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907418; cv=none; b=moXyVbTx5iWOXeqWwDS4YwKGNgjczSSBziPqXZZrlTv3H5YWL/kLhGhyDG1zCW6bi9kwPHnzFXxHs1jlNDMA7egH5gsfb8eSH2UKofi5vosUGr70XapW/btuwmsWbjGJF9yxCT12IHW5FCPXWPv6HQktUSsmxyiF8CesTtMzA/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907418; c=relaxed/simple;
	bh=LSE9BMAlVcfDDCkIHpx1eHqXTO0CSRsabrkNnNPLaV4=;
	h=From:To:Cc:Subject:Date:Message-Id; b=KRyGgOBPWQx+43FGljcawZYdqlbGWZ8jYSH5GeVaaSA1K2lKZARQpE0p5QvMiZXyOP9b0DeN6gARAPnN4KodhygwL51l0WMktV2ffekzWhyGLiRCv03Y+VvWtqfNTl5AdsM5aY8I2/AMT2RouL1d8xIL0NaAptQIj5LviUUpch8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.53 with ESMTP; 11 Aug 2025 18:46:53 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: chanho.min@lge.com
Received: from unknown (HELO localhost.localdomain) (10.178.31.96)
	by 156.147.1.121 with ESMTP; 11 Aug 2025 18:46:53 +0900
X-Original-SENDERIP: 10.178.31.96
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	gunho.lee@lge.com,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	Chanho Min <chanho.min@lge.com>
Subject: [PATCH 0/4] smb: Backport UAF fixes for v5.4.y
Date: Mon, 11 Aug 2025 18:46:35 +0900
Message-Id: <20250811094639.37446-1-chanho.min@lge.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

This patch series backports four fixes from v5.10.y and later to the v5.4.y,
addressing potential UAF issues in the SMB client implementation.
The patches have been adapted to account for the directory rename from fs/smb/client/*
to fs/cifs/* in v5.4.y, ensuring compatibility with the target kernel.

Paulo Alcantara (4):
  smb: client: fix potential UAF in cifs_debug_files_proc_show()
  smb: client: fix potential UAF in is_valid_oplock_break()
  smb: client: fix potential UAF in smb2_is_valid_lease_break()
  smb: client: fix potential UAF in cifs_stats_proc_write()

 fs/cifs/cifs_debug.c | 4 ++++
 fs/cifs/cifsglob.h   | 8 ++++++++
 fs/cifs/misc.c       | 2 ++
 fs/cifs/smb2misc.c   | 3 ++-
 4 files changed, 16 insertions(+), 1 deletion(-)

