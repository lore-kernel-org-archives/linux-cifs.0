Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DFF3C141F;
	Thu, 16 Jul 2026 10:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784197103; cv=none; b=H82v76Gaa1O6wdU/O0kDZ8UL+MiaGe4t9Gs69NOtG0I4p63RRH34yihWN9LHOPlUZy3UKH+K21226JaU/BA6NFX0eYy4KCwNYdsflFVpyG9UrrqKCESn4WE4bclqp/8hPvDSMfwF7EGICRunAqNXLR5vzADDP96cVIoTY5A4ijA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784197103; c=relaxed/simple;
	bh=hrmbAf5ipFq1QTRmjSX3m52e4bw1SNwfa+kC3oC2Cn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lfsn8tWBOpx4GdYEa5vKCK/npYLX7Zzo3MoyG7uRZv8u+9TauCXdYpiItEQxZGEGg5hq1SYI3mvkYSn2qHZJ5KyTW+GrhrycgCvP7fj8BtZFnAjcZh+kt+GIBSiYcA1e8Vw0fh2jaFIQcQP7RzG0Dn4zeFFnN8VlfTczYhUXHAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i52mAPYR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i52mAPYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE4C1F000E9;
	Thu, 16 Jul 2026 10:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784197102;
	bh=fREf/cKl+vA5Yi0Mt2+ZFpMAHJekOqY2fILSGJRnTY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i52mAPYRMvQEZM0/dNMQxXWaEdtz98JOMl1LK0mj0RfUffvzPxt8Rbzxsxr3rfQW/
	 0WDZut8JalAW/SE5sqLn/fVhqah9/dSAvPVbsrIESN9e8HN+ZfiISK7eqouA/sPNEU
	 yqr/Ade8KpfR5X1XAwv1lvRtsbowDxmrCOG1zPerwAF+W2tVYx1dK4OGBA9vVYVYPP
	 odDc4Mi9UdCvKBglbM0idl971+/mfS8SzMGdhNLj3zfU/nr9Ab6pIhBZThN0/CBbeZ
	 rcKcFtNELl8EIliDeL7bCScinwze8IyfzsKyGWfUGkIpLlJe9XI7nDVtGk3UJclvIr
	 Cye5vCFsgPKig==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 1/3] cifs: SMB1 split: Rename cifstransport.c
Date: Thu, 16 Jul 2026 06:18:17 -0400
Message-ID: <20260716101819.1461638-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026071403-ferris-hydroxide-5531@gregkh>
References: <2026071403-ferris-hydroxide-5531@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit b09eab52b307df58a36f34d047378053a2e13e13 ]

Rename cifstransport.c to smb1transport.c in order to give consistent names
SMB1-specific files.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: c6394bcaf254 ("ksmbd: use opener credentials for FSCTL mutations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/Makefile                             | 5 ++++-
 fs/smb/client/{cifstransport.c => smb1transport.c} | 0
 2 files changed, 4 insertions(+), 1 deletion(-)
 rename fs/smb/client/{cifstransport.c => smb1transport.c} (100%)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 4c97b31a25c280..9754b4776df845 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -32,6 +32,9 @@ cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
 
 cifs-$(CONFIG_CIFS_ROOT) += cifsroot.o
 
-cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o cifssmb.o cifstransport.o
+cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += \
+	cifssmb.o \
+	smb1ops.o \
+	smb1transport.o
 
 cifs-$(CONFIG_CIFS_COMPRESSION) += compress.o compress/lz77.o
diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/smb1transport.c
similarity index 100%
rename from fs/smb/client/cifstransport.c
rename to fs/smb/client/smb1transport.c
-- 
2.53.0

