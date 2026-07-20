Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5B728641E
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 15:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784560891; cv=none; b=aeV5AaJQ0xk6DmwfzWjSztkCTXig+dEjc+btvMgkJaKNkQH05hi34ZPTwG9Mqud3zacXe27TsDRCvsfvF7YYlUL7gcrwdbxLeER0fvNDwXvua9+TuNic9xg9CLOpii4Sz3SO0lBfM6KCR6GnTQKspC+w/eh0FiPEafd/wheWTsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784560891; c=relaxed/simple;
	bh=msNzJ0dNoP1BnNCl1QiOlbMVlrYw6OoIbmpWkxm6Mdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e0qaexw+/wow7K3qxrm4mu4/+iOD8L28jmAL0Su2BPoZ3aTWWsEvECDWBcov3e652JYTPb0gqK2eu5wgP152OooscyAfnqjibvZbztURJghpyKCVG63QHp611/wObfCVh2xr0hW8k33Tm+n/ljC4kyBv/F2Vo5MJ/w8jD4Ilb3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pXvS1F0r; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pXvS1F0r"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6a1160a2c42so6935156eaf.0
        for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 08:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784560889; x=1785165689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QaExHYBMbO4BVV9bYsc1HQwQVCvBojAwVc9mYoydE2Y=;
        b=pXvS1F0rw6X2PjC2Ed3/wClGhe+Xa84qgcEOl/sFl4QqnUGWMVSH5t9sXJh9H8faf/
         vJBprPaoxOYf+LIFq2Wx3XwVOrsyHqSNQCTK0TCjq1ZiMWjpEY30oZ0ibXiuLAlrdC3n
         2NC70bUPSd2qEBJbDXPUAtDR12MiNcL+tOxOj+BRSeeo4L4frcFKWpmul9YNtmEch/eX
         dcZw9gI64FggHzpE9xmGS5csTfuD/xyD1bs9z1duZxnlQXtpW9N0dnEcoT+GSnKi300p
         FFmIa/C288xiCslN1AOsq3zaVYGNfs+bFZyX8eNpKG1v4FgjU8PsKSkLkNswlWfscUD8
         0M7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784560889; x=1785165689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QaExHYBMbO4BVV9bYsc1HQwQVCvBojAwVc9mYoydE2Y=;
        b=Znl5vPTzrv9a6W/VhsJgNaIPTOVoW1rjzPmYIgo10BWh4Sn9IsBidrDRzrvdp9AfMI
         /dgbacD9rm2lXk1UNKCfXxmj0rybOSo58ohbe5fE6htCHjLr8Vbt1/FXCGN3LFNUze7E
         aBjQM6/x0ehkjXy7JSYPEcGhl4RyYeDr3tHfDrfQbP+UIUBJST1bZUtq4ezniQp9Puk6
         oupnM9SbO8IEfAIrKDpQpNaXlViUWh96F77LlDlHhmWm31y891jVkRqrBCT/W2UL26il
         Czd8Os6j6Q/U/FosVv3SwNfdE//YSAQYc3cPn/EtbAB3LDIGUcQTBPGnG11dCqLsK2jv
         0yTw==
X-Gm-Message-State: AOJu0Yy3l8RmOx6iv6hoABJnzRFMMyBULxdN10j6mcQSdS/NfMuiyLu+
	LMr+hOqJ10M8qE9vV8w3GtaAifgU6svcDiO8ywdiXbqV5BO84kac3LgW3UQnHfHV
X-Gm-Gg: AfdE7ck3hN22kjYYwc2KNKXi6NK8ZPI7rAIJtj9yLOrMWuvSpiWjZmF4lk9G1/LjhKf
	1oY7hEha9LNTkINDQPko2xsFX3q3todz2kXubmObnI/69kGN8BMtFn5JdREPMWaLaQTWHBljrXy
	EqWMBHWSmhwLM6554BDyhdo57w4brqBWEzA6C940DvZFxyhBgguRZdZWssaT3j8AvWhOom5bHp3
	g86B+A+FyuExcbl62Xlv5kbMUi1UqbgUeGzk3KWeQg724Fgozeai4O1Q56NrB9HD88deNPEMYtS
	0qIlldZazWDvXRZUBDeyZwQRPzhg2Yz2hVkg1032fcu6Q9wMti4fGu/rmhOlAqmHL8hxQevOWor
	HoXwZuytk780j/a+8pQ6mUyEUGApT/logE8unWGg6Mamhu/ctR1d60kMEnb+lX0cJA54imJauSh
	WuypbfyLP8Cg46dSXfaEOd+DrlUgav42wybL1VEd6AcUDc9eXELEKRq5PqEkKZ6nH2J2eTbyLe3
	GXRfRihhK86RxpWulk7Ih8CmAfNe1iFSqOeSy9KiqOQMiq5vM3xp7hnqG3/rHxqkY2TEmoNnUbH
	cNNiBVkxZyOc/dbb
X-Received: by 2002:a05:6820:1386:b0:6a1:7fa0:114e with SMTP id 006d021491bc7-6a53689359amr7479358eaf.64.1784560888775;
        Mon, 20 Jul 2026 08:21:28 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:5acc:d14a:12e3:afd2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4568e6a91eesm9104774fac.13.2026.07.20.08.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 08:21:27 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Steve French <stfrench@microsoft.com>
Subject: [PATCH] Add missing git branch info for cifs and ksmbd to MAINTAINERS file
Date: Mon, 20 Jul 2026 10:20:51 -0500
Message-ID: <20260720152051.1966581-1-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs client and ksmbd server were missing the git branch info in the
MAINTAINERS file. They just were showing the git tree.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a674e36529f7..276abc0ad458 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6478,7 +6478,7 @@ L:	linux-cifs@vger.kernel.org
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 S:	Supported
 W:	https://wiki.samba.org/index.php/LinuxCIFS
-T:	git https://git.samba.org/sfrench/cifs-2.6.git
+T:	git https://git.samba.org/sfrench/cifs-2.6.git for-next
 F:	Documentation/admin-guide/cifs/
 F:	fs/smb/client/
 F:	fs/smb/common/
@@ -14142,7 +14142,7 @@ R:	Sergey Senozhatsky <senozhatsky@chromium.org>
 R:	Tom Talpey <tom@talpey.com>
 L:	linux-cifs@vger.kernel.org
 S:	Maintained
-T:	git https://git.samba.org/ksmbd.git
+T:	git https://git.samba.org/ksmbd.git ksmbd-for-next
 F:	Documentation/filesystems/smb/ksmbd.rst
 F:	fs/smb/common/
 F:	fs/smb/server/
-- 
2.53.0

