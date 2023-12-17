Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0633344390
	for <linux-cifs@vger.kernel.org>; Sun, 17 Dec 2023 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GDvgBO0l"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-67f30d74b68so7895106d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 17 Dec 2023 05:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702820512; x=1703425312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lT/N2yWk0uciQdD8+2+nrCyk969qPWQDTRjpLgD0XPE=;
        b=GDvgBO0lx3ENXf4lvjs9SwlY4CfcX5BuoyHBElO8w0NVPn8rezkmV/ZyW2qZnaZa0c
         jcaBOIlS5mE3glocSp2QYs/W27V3uzI91tsyp0MMDcP93iemFcECiWADotpacHgPzEo1
         /yPCsZtKAFiT9Hgvy1BMmgaQpwgyDPfW/kJRgYbRqy9xFeGnGZSzjYxPsArz1TlaK7x0
         iQbWodpuItudN45PX1fYLtcunhvyCY9vJO4SGR4gAp/dHJi4yxyY/n1FYJiOTnxf/1a6
         CbSQj7Y54xHegC0HdZXNOOXo4/zMrSo/TOZRYRrJLwcprbwplGQ/Uvz2LMaCBGNrTPpp
         GXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702820512; x=1703425312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lT/N2yWk0uciQdD8+2+nrCyk969qPWQDTRjpLgD0XPE=;
        b=woaXQy3Rkvg2Ezx6FDWkfMuzi+bmrasq0+gIAVH7dl8QrzGt73JNMYGvk1LNjoCNvp
         JdcLfS2X7RgQ55e5gvCRotmLAKu5Fj5dmh+4tSHig+8+cm4EGvaWhkEcn+iamSkKi0xz
         zTE092y0dGQZtLSHqA6opCx1hmIhNH7jCDSK8btNftnIZMPxAuCwn/RPDLemwUwWJXrl
         OJUU+4sYmLaURxmxKDAuST/9SPgqTYVk+MwVi6ntO52tFOk3Qo7I0WlDSkJEgT+ctygz
         /pUA2UingYr2N3mu/GmChDqt4YuTLL/P7qiTIU0B7bm5WEgs+VG0K1h6ALZRKLJgw5lp
         iq5g==
X-Gm-Message-State: AOJu0YyUMnD/xmrJw9TIvo7F9tVn9BCx4nlzmngbi00JO9bjD9rSONwP
	nDgliDtSNYT3pz1vLiNx6nk=
X-Google-Smtp-Source: AGHT+IGPMnLDhm8pTgx6mesWYxGFXuuJa/bjOYOb+JdVaTJ0/ZPZJ9+vqz5aluQS7ArsXsW3vZi+QA==
X-Received: by 2002:a0c:ee2a:0:b0:67a:caa5:66d1 with SMTP id l10-20020a0cee2a000000b0067acaa566d1mr14945295qvs.4.1702820511683;
        Sun, 17 Dec 2023 05:41:51 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id ev6-20020a0562140a8600b0067f370c7b04sm625488qvb.68.2023.12.17.05.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Dec 2023 05:41:51 -0800 (PST)
From: Kevin Hao <haokexin@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] ksmbd: Add missing set_freezable() for freezable kthread
Date: Sun, 17 Dec 2023 21:41:37 +0800
Message-Id: <20231217134137.3111553-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel thread function ksmbd_conn_handler_loop() invokes
the try_to_freeze() in its loop. But all the kernel threads are
non-freezable by default. So if we want to make a kernel thread to be
freezable, we have to invoke set_freezable() explicitly.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 fs/smb/server/connection.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index b6fa1e285c40..d311c2ee10bd 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -284,6 +284,7 @@ int ksmbd_conn_handler_loop(void *p)
 		goto out;
 
 	conn->last_active = jiffies;
+	set_freezable();
 	while (ksmbd_conn_alive(conn)) {
 		if (try_to_freeze())
 			continue;
-- 
2.39.2

