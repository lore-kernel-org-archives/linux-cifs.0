Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B3F3B840B;
	Wed, 26 Aug 2026 15:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787756473; cv=none; b=Xm0ok/NY2F0I85pB1BOgedC9n/db4gHgL9YAU1oUhiel3LvtM+5/ugExK1rucf/mfM1yIXBkL1ElxGaT9ssG5mF+6yAhcHWTVYNl/CIesgYx8P67YVGfXbUgZfiqSAQW/YJEalBuA7PCnkOioorRf2RO+2qBglg80WR3I42L4KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787756473; c=relaxed/simple;
	bh=cV2qSYdJF/ZOBOBO5dF+4nccV307TLmTsdiJrzmgaJs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lCeinndhOjf0Aya9+v/PODmQwh6k6LF262lV0MDUK2XYlx0cV2b92lslYHBX05+2W5hkT6J4/epX2AzWZXDZXWdXRof682a17fqo3Ve9SRnctVyh2ZqTmrD35ZNrPLz05LotyeV4Wzg43wjVOB2RR9qRwqxBXkWunH7U/rMZWQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mx84xv5v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mx84xv5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC6D1F000E9;
	Wed, 26 Aug 2026 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787756472;
	bh=+xQjAp4U4KrRZEwL5Uc8As1266cRdVbIbaMquVUVV4g=;
	h=From:To:Cc:Subject:Date;
	b=mx84xv5vY0IOXvoIFjeMI7nyiNnKi/XikkpIA4aIvTQWx/66HunychLaCrwRxzFa7
	 kW1kV5jpoT+cZk4BHM5ssHyUDn4hH1T+CyUw7MjGKytOCw0GbYaWf/SvkOoYryeBN0
	 OQOL07jgp4VeoiGvgVW0u54jfdwuT8olzxCfWr2QJgmbCtiH+LrNu1Jw9UkYuOFppv
	 7WTpuiWguE6fd7y/o3JSYxavs1DdCX0cDuSzXnFEJyGgmPUDyatpwuHb+scLDAllev
	 fpBGoJOpMsUrI475C3z2G5aM/ECSYPN4gku1QE4s2q72uNWy1rWQQkUOnJezOyrEwa
	 gTq9QXsdnovGg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: metze@samba.org,
	tom@talpey.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH] MAINTAINERS: Add Paulo Alcantara as an SMBDIRECT co-maintainer
Date: Thu, 27 Aug 2026 00:01:06 +0900
Message-Id: <20260826150106.15352-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Steve French passed away recently. He was a long-time maintainer
of Linux's SMB support and will be greatly missed.

Add Paulo Alcantara as a co-maintainer of SMBDIRECT alongside
Namjae Jeon.

Acked-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e05570c393c5..7e1d14406619 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25105,10 +25105,9 @@ F:	Documentation/admin-guide/LSM/Smack.rst
 F:	security/smack/
 
 SMBDIRECT (RDMA Stream Transport with Read/Write-Offload, MS-SMBD)
-M:	Steve French <smfrench@gmail.com>
-M:	Steve French <sfrench@samba.org>
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Namjae Jeon <linkinjeon@samba.org>
+M:	Paulo Alcantara <pc@manguebit.org>
 R:	Stefan Metzmacher <metze@samba.org>
 R:	Tom Talpey <tom@talpey.com>
 L:	linux-cifs@vger.kernel.org
-- 
2.25.1

