Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B9815ECDF;
	Tue, 17 Dec 2024 09:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734427518; cv=none; b=FH7QnoMWavCk5/S9C18rFWFUgh3OjqThQhuAzU+9eLHwqLbJ7RQoElQEGCuto99EVUGZcEd/uKvHZrqAJEQc/ZZ98maAYm+tm0KzOLGXFAbAsupjSwKwxlwWVx01/FS6SrKXoojO7xVmx9vgMUk0YssvVvLr6gVyWNXhC4gNrrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734427518; c=relaxed/simple;
	bh=JKdJ5dmaFB3F6npgAqAUUWCeqcocQgGL9m9i0qGapc8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=klE6elwU/zkyHDeb78m8HKVcW5wfEmdBrq9UjCKGfci8f5BhyXbcK40OlkbtaWS+hRA7FfQbfXkeieD0K9dL4WA/2oBhLOzxzN+WTOkMTVDMUL0OOfNvTzrm1IRXYWpRpMywmSCLsSkmGJP5MuXtEsXFQ9NFjSqAwXQyY9B0/e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=ipHSIxRS; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="ipHSIxRS"
From: Dragan Simic <dsimic@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1734427514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wF1RgkRIWrwjCwlsuHu/hqgivP6T6cSmHUli1KdNo0c=;
	b=ipHSIxRS94+iugc9d3DXfVY/o4Eas+q/gg0XO2zvYrxQ/unmQPSvBRq6CDdfuNUi4PKCRI
	0v1WS8AD46GmwHAijYSplXUWmsJf2SlaN40dr/Hws2OHsrHBkvpY1tro5rrjiOkQ2rm0Pd
	P5LigHcPlhsVlSDMOZ88DJR2keAGQxhtHIXK7fuaWqKumBd39dG9QkFjpSsovC5JSYA0LZ
	POTH1E59RUF21dfXfP7ymU2hYt6+6kIM53j32gUc4QHPR4fnxHrDHXq5XkmE5MU3gunMJd
	droq2cUW6DSl2u2iwkU4VfPFdSt3zwCBK0TSv5Wry3J33YxSBaBEwtBrChfBXg==
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	dsimic@manjaro.org
Subject: [PATCH] smb: client: Deduplicate "select NETFS_SUPPORT" in Kconfig
Date: Tue, 17 Dec 2024 10:25:10 +0100
Message-Id: <011da8e5ae7537ad188cc49cee6f96e09eb1b8db.1734427173.git.dsimic@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Repeating automatically selected options in Kconfig files is redundant, so
let's delete repeated "select NETFS_SUPPORT" that was added accidentally.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
---
 fs/smb/client/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 2aff6d1395ce..9f05f94e265a 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -2,7 +2,6 @@
 config CIFS
 	tristate "SMB3 and CIFS support (advanced network filesystem)"
 	depends on INET
-	select NETFS_SUPPORT
 	select NLS
 	select NLS_UCS2_UTILS
 	select CRYPTO
