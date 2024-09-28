Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B22618734F;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727560848; cv=none; b=iA1buqDIWkHbRjR+t9eK3gk7U2B5Ak3FxTX4LdEbdt7YObZ/G5Rh1tYsSaF3X7AkCP3cTg1uXTJWU9rCH4DIao/L+QHvaJn19rphXX/jkOEXHPiXb+cC82/rsB+06LMJdxyLXZ/ZL4yAHc5l0NHz0JH2xPdPa+rosBHlSuiTZWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727560848; c=relaxed/simple;
	bh=CzIXaOQ1+8uUZLsrIfoiPMK2AQjdBSqSjgcG93qH1FY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPVQdE0MCAqj4ekPTZuTdKRdaDlJ1Rvs1KM/z1E/9/A2j1VlgDpvK7ODX08NAhBBSrC9BhbUbSNG5zndUhaY4HuavawxL7+9xkU8RbBJBkmOvJGiP122Nj35fJzKjB4Rn4vELYkT7ot5bNKRkcHcqHtZqUu5cIFjfeTVCuTGrD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/a4gQ0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/a4gQ0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F544C4AF09;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727560847;
	bh=CzIXaOQ1+8uUZLsrIfoiPMK2AQjdBSqSjgcG93qH1FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/a4gQ0pdnp4dwFv61YWJszsVVZdGy00Q94RFCwO7i5HE/gmOzM8e138zYPXskt9g
	 C0VsdQW1WnNKcJix8IVGijtjc+D1Fonmy+e65ZmdK9mwCM9BQvQFBZHXzTM3KRsX5w
	 y/EhumfhyTUNQd6/sA0fmc84Lr9kWhIoOnfw4XAg4EdtiedyWcF+ct6lVWEjubHcxu
	 mkieL8a6e2zeOxjZM26dXJixlDizjH8ctODbN3FiSROVSRZWj5bnzf+Kf6z2TgU5kT
	 wy9ovN5m4vkVW+Ji+NxGt59sZBjaoBNTCsBFGWU+eGZO9D8X9Avt5m3lS76l0tHXgP
	 9GQy7SeQLQ3CA==
Received: by pali.im (Postfix)
	id C6287A7F; Sun, 29 Sep 2024 00:00:40 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] cifs: Fix parsing NFS-style char/block devices
Date: Sat, 28 Sep 2024 23:59:43 +0200
Message-Id: <20240928215948.4494-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240928215948.4494-1-pali@kernel.org>
References: <20240928215948.4494-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Linux SMB client currently parses NFS-style char and block devices
incorrectly. It reads major number from location of minor and major from
location of minor.

Per MS-FSCC 2.1.2.6 NFS_SPECFILE_CHR and NFS_SPECFILE_BLK DataBuffer's
field contains two 32-bit integers that represent major and minor device
numbers.

So the first one 32-bit integer in DataBuffer is major number and second
one in DataBuffer is minor number. Microsoft Windows NFS server reads them
in this order too.

This issue was introduced in commit 45e724022e27 ("smb: client: set correct
file type from NFS reparse points") and probably because in commit message
was test of char and block devices with same major and minor numbers. So
swapped major and minor numbers were not spotted.

Fix this problem in Linux SMB client by reading major and minor numbers
from correct position of DataBuffer.

This change fixes interoperability of char and block devices on Windows
share which is exported over both SMB and NFS protocols.

Fixes: 45e724022e27 ("smb: client: set correct file type from NFS reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 2c0644bc4e65..790360f8a53b 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -20,9 +20,12 @@
 
 static inline dev_t reparse_nfs_mkdev(struct reparse_posix_data *buf)
 {
-	u64 v = le64_to_cpu(*(__le64 *)buf->DataBuffer);
+	u32 major, minor;
 
-	return MKDEV(v >> 32, v & 0xffffffff);
+	major = le32_to_cpu(((__le32 *)buf->DataBuffer)[0]);
+	minor = le32_to_cpu(((__le32 *)buf->DataBuffer)[1]);
+
+	return MKDEV(major, minor);
 }
 
 static inline dev_t wsl_mkdev(void *ptr)
-- 
2.20.1

