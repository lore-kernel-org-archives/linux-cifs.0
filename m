Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7678A3C9EF3
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 05:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785906748; cv=none; b=L+bsuSjnOJpkYJcNl4QT/WGbdrbMjKYPifLZIumUqhMtFkv44B+4dAVuXIE8b1Pgh8u6re1uvldEWroOFUa1J6khvXGAf8Wb7untYudmlVkvESvzkuer2kodIeNOzeGlUxpcXw5Zc23WXIhEt6Irh5BqV4dJVY9xFJFjofGQcVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785906748; c=relaxed/simple;
	bh=6lA1KKdmMpf6QG6y9wOsuavK7S/k3X+dQICRf3Zy5Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hqMnv2z8F5oc1f6Tl1OuU0aLB1qTYyQUX5TnMvn2fE+y0pe3tOKkWROdXEmyVbfhFXe+csvWXXxud2s027PYzBN2WzjCFfS8Ptt/O6V/Gp6f0KGY0L9rtogjq/R42UjbdjxHfKM0mfFgubOeA/jAulicVKiIvh01DfUkQaMpBdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=GYE4nHUG; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="GYE4nHUG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785906739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ylc/sZTyUFE6+wHO373dfWiD7RzrmnBS5Pxs9UeREM4=;
	b=GYE4nHUGZpFfu7qxhKLdMQjqlt+X5CwM8gln1sMK7a5KlnzRogbxTpIzl9VnGShIbzxpxT
	dshAwa2pEfs7u09vhGMDV1w7c1xkE94sGC0AKfjaMr0uhQlLoH7BRFyJRo9gtLGZFesLX7
	Go7VCnJJlUFZxSms718SAnPfnlj6P2xATVT7QAkTqvdulAIsxLe0HUc5ymowXWMAT8rwUc
	Xb1bILiOFYbdXQZZ74UkFB6M8zNjLvM0px5DDL3JdPQpAkztJvQy/CcLZ3vWVE5xxQwVC6
	Juo9+nhkMu8OyrVsbjSkycBkG+UD2XbOvgmYk92jz3kdXSlNfiq8u89OSeFRMQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 resend 0/3] smb: fix xfstests generic/035
Date: Wed,  5 Aug 2026 05:11:09 +0000
Message-ID: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Resending patchset due to mail server issue.

v2->v3:
  - Patch #02: iterate over `global_ft.idr`.

v2: https://lore.kernel.org/linux-cifs/20260804123301.285434-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (3):
  smb/server: rename to ksmbd_has_nonposix_open_child()
  smb/server: deny overwriting targets with non-POSIX opens
  smb/client: fix nlink of an overwritten open file

 fs/smb/client/inode.c     | 11 ++++++-----
 fs/smb/server/vfs.c       | 15 ++++++++++++++-
 fs/smb/server/vfs_cache.c | 29 ++++++++++++++++++++++++++++-
 fs/smb/server/vfs_cache.h |  3 ++-
 4 files changed, 50 insertions(+), 8 deletions(-)

-- 
2.54.0

