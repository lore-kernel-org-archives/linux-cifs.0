Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152061A2627;
	Thu, 12 Sep 2024 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142761; cv=none; b=tQkiAJgVPkwHYGJmg1f5RZI7EaKzdKVAgELQV0VYi6Zo+LU/hLuADBjhExmxaTlNkcpOjAZgaB3+ATMUkcoDIT/k7rIEGrV+uv1M19znCgLK8844LnxFQftB2vLsqcTq+IyWkdGRcyvT2VSqQjRXcGj0gtKnJXSEzmmf8PVoS6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142761; c=relaxed/simple;
	bh=/TUHrLYyzhdm8SLzeAOvb5kYuwHJb1PMCxxItPVMNko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qoBWaOK3aw3tWUgZm756PofafTTKOkb7z1+KJuhDeksAZZjYrPap5euytFwh5DfGM56mKGZYxzEQov8cjl37Vh1ETuPpyiPNKDvSqXaKsyFklAhQoXzP9AQnMGpcrZOQ3CsyNWAeJvEou0NSCdP5xwBtqnG7OQqT00VfTiXRkfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DyoX0HKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyoX0HKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7036AC4CEC4;
	Thu, 12 Sep 2024 12:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726142760;
	bh=/TUHrLYyzhdm8SLzeAOvb5kYuwHJb1PMCxxItPVMNko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyoX0HKGyKJpuG5CUnDs6SC2D4GP3e4iVMFmPn3G5+VE6mcdNiEpFrLZtpq7aghLc
	 iPIG8eupE0ZWhwb79GF1qxO+zR0UD7QSlwhzUycUBcB5HULhHwzKE/3ZM00G6sKE4y
	 dEa44IKLpqJAZziC8q//4LShEYAdcFpnkYKA5EgJdcKiWKs//ae+Cb/KeppWqC8Dhy
	 5Dfix8p9pzjBQj66Drkx/xrjflRDWKZPun2flZIDCS9sfkPXD0z2dxwoHt8Q6WVLv/
	 aNzevqazqkAaj+3uhX1IcULVkrbyb5gCqrbDQYnD15OopMnTjLHTJZ2HlUpgmMgO23
	 ELx7Sza/+E6qQ==
Received: by pali.im (Postfix)
	id F0338A11; Thu, 12 Sep 2024 14:05:54 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] cifs: Fix recognizing SFU symlinks
Date: Thu, 12 Sep 2024 14:05:42 +0200
Message-Id: <20240912120548.15877-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912120548.15877-1-pali@kernel.org>
References: <20240912120548.15877-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SFU symlinks have 8 byte prefix: "IntxLNK\1".
So check also the last 8th byte 0x01.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 73e2e6c230b7..7d424e769a56 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -612,7 +612,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 			cifs_dbg(FYI, "Socket\n");
 			fattr->cf_mode |= S_IFSOCK;
 			fattr->cf_dtype = DT_SOCK;
-		} else if (memcmp("IntxLNK", pbuf, 7) == 0) {
+		} else if (memcmp("IntxLNK\1", pbuf, 8) == 0) {
 			cifs_dbg(FYI, "Symlink\n");
 			fattr->cf_mode |= S_IFLNK;
 			fattr->cf_dtype = DT_LNK;
-- 
2.20.1

