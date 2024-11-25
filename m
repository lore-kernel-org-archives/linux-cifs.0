Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2420183098
	for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 20:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732565777; cv=none; b=Xj1lbozfOV0NhUCLw6g5pXu8iRcsZ+4IRPLO5Gnqc03/G/bUq9ypDGjW1QrsnOlocXYOv/6UFMa7inM3gq53/mSEqY6f5XZ/V/PKlR3XzCQOCkiH3g0oq+mOrT+L0NGJ7YyTHyO2ZtusVsCARVf06YSgFZPM8kT1O/sw+gaKGI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732565777; c=relaxed/simple;
	bh=usvdf8gO605Til4Jv/gZXoZWiCTlrXTQkTMRECFWCeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ecyxaXIwXF5unuIBW6OZBfyx2OTVaMMUZEPkTtgNAK5Upq9B7MOWgI0vxbyyFJhpmpD+3vA7p++4xwFurET1Z5U+cKt7+w21NyGiQiqse0TylPAsU23ORBaDFH8V+ZaV7J4YywBm1o+Q5EzT0giCPQerqJnjnZaKtACZGQlXEZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=liqn4Nsm; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="liqn4Nsm"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38242abf421so3257698f8f.2
        for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 12:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732565774; x=1733170574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RF2Wyl0h9H4sJGr/uTFseyM2/wkJcLHEDBvS5Ijq3s8=;
        b=liqn4NsmQJe89/9zQWo+M0tWhVlwGqa3ytkFfqWZW4Zhk10nUroDkZ9iY5jQhO8++x
         5A93xe288VRi0FADvXVc+BIMFZEhqdaYMvXuHVFB4z/j35RP0PBj/qwpaG3EgNs8BvOD
         ijuXoFCff3dGY4DbqyGGXULYfgx2ttSsFmInEwSKny4duUH3cI2oJPIY6De+q5bfADq3
         BqM2BjT1QKB7viyt2vHg6acn2cP/q1wq3jWdqBqOGz8rO7T4dPDt/KcXTWqEgrnZuxyS
         3aRRXeRL+gwShfpjoaJI69Rx/XaC8qsNqxm+2eOYdmaTaFt9gD3lziagOWbh16SHwBRO
         pNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732565774; x=1733170574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RF2Wyl0h9H4sJGr/uTFseyM2/wkJcLHEDBvS5Ijq3s8=;
        b=cBHAbuhkpf94J7CCDKK2WPugr8WkBKlcvaTq0SmbyAN+Y6WjBl+ekYXr3+40ln+DLv
         Xn6b/5v1jSiFV8+Zh3kMdIYuN3K01VsMNKcVdQoCSdZnV3DleyvK6OTExMlpGvNV+ITL
         Ro2D8GBL/yt0k44nWRsXvSido6NXiVD0lG4TCQlUYS83AXKCiAJ0J99DatR2rgTGGAzD
         /1lG6H+kCNpWPbc5+FiurVvaWKgvAoCxOcbXw2sq8Ue8BpQKSEDlPe4NoMz5oUT+J9xF
         4NeLPb5M+SBzcksoJkM7z//NAxvgpWRiXmhzL19tayAsEs1BD/Am2rF7rBrx04tHPsr/
         tqbA==
X-Forwarded-Encrypted: i=1; AJvYcCVKNMxpMHXJCqNLjr8D9zIZpnvON82ppPEGZiHp84MGuC0+9+qTlvA35ShbO8pribwTgFW7ofDlPjay@vger.kernel.org
X-Gm-Message-State: AOJu0YyUv1BqZfzZ327PgN9dik8Mc7waQ9YTLcSrNVS87YvLiUeUTkB6
	KLQSJLaqyxZR+NTpli+xlcXrCEIPf6PsmJUW7NIpbK8i0zGhW3SC
X-Gm-Gg: ASbGncuyYAleu6+hInxnwKbO+JKd1/VQ78b0mfx3z0pH7Sk//hFzdfbTdLyRbDxQWoI
	4kUi0JiZndBY75wEATKET7jRZmXvRZ7JZP45G+W5SJ/+XkHgTqbakvr3xe6+beX29QDaOBfM5H1
	JBzU58snUc6lIhxz8SHxbqReimEykCQnbZ2vomiEhtvx0pX/EaFdNgoptLaqa72GxDs3a8QhoaM
	GSlrKID64UlNVdmusawShLNsWq+d1fqJD7ZJIbViVEXBrQBi/wqmX9GmEWz
X-Google-Smtp-Source: AGHT+IFBs60532ZS+0fRrOsDLb5MgiERVrTCZNFJFjjKAdGkRnMnL6h9VV0daVEXzLLZtuSW/EFleA==
X-Received: by 2002:a05:6000:18ae:b0:374:c847:852 with SMTP id ffacd0b85a97d-38260b806f8mr12895106f8f.29.1732565774085;
        Mon, 25 Nov 2024 12:16:14 -0800 (PST)
Received: from azathoth.suse.cz ([45.250.247.14])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4349e117bf5sm60758785e9.18.2024.11.25.12.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 12:16:13 -0800 (PST)
From: Brahmajit Das <brahmajit.xyz@gmail.com>
To: linkinjeon@kernel.org
Cc: ematsumiya@suse.de,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: server: Fix building with GCC 15
Date: Tue, 26 Nov 2024 01:45:51 +0530
Message-ID: <20241125201551.2538182-1-brahmajit.xyz@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GCC 15 introduces -Werror=unterminated-string-initialization by default,
this results in the following build error

fs/smb/server/smb_common.c:21:35: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-ini
tialization]
   21 | static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

To this we are replacing char basechars[43] with a character pointer
and then using strlen to get the length.

Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
---
 fs/smb/server/smb_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 75b4eb856d32..85a34aeacfe8 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -18,8 +18,9 @@
 #include "mgmt/share_config.h"
 
 /*for shortname implementation */
-static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
-#define MANGLE_BASE (sizeof(basechars) / sizeof(char) - 1)
+static const char *basechars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
+#define BASE_LEN (strlen(basechars))
+#define MANGLE_BASE (BASE_LEN - 1)
 #define MAGIC_CHAR '~'
 #define PERIOD '.'
 #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
-- 
2.47.0

