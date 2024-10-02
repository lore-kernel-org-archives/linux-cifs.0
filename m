Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9BC1CFEA3
	for <linux-cifs@vger.kernel.org>; Wed,  2 Oct 2024 15:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727881808; cv=none; b=GR7V7Uyf+wTXec6sPvG8TXcm0cqOsjgF22KgRdKOL6Z9NL9yqiRjRYHzEPiAeeh/1GsncLlllQYeJFkghuqxYaTVQnnWKiyKzcaIrvl+d9blaqtO2beYttqDwueAEVo6PTQ154w8LVe9EOJ4yA1RXC7dr5IueeKrQj7hZ4BsQQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727881808; c=relaxed/simple;
	bh=Hk5OYaxaWRuhR5nw+kRE68G7TNvk4dA7wA88RZTUSmU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u8HsygAbnuqXgdEK5dSJorKtpa4ruVgh6RXdDk3bZpJP3Rekk/Yz9UKRyAXGPA+RmGn9uahOqxl4EeN//f5uRwm3wcQOuX2vtfYUZKnoqwSLmxDqLBDLDag9vEGQYE5LWmRnmYgsjS44uKr23bItOkmRDgKWin5ElnZzT+A/nEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AO1JD8il; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AO1JD8il"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c8a2579d94so2912849a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 02 Oct 2024 08:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727881805; x=1728486605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=azwKkhgvzCiAQTAqS/hXT3XksVObLdREOz6kK45ko1I=;
        b=AO1JD8ilCF1MrQB9gtZDnCLK4BPXjJd2qeiaa09GKiu7JiX0ZCeAJj8QKGsWNQeghI
         6jBxxPq+cxs17HBl9xggw93+WvDR7on+wlrYdt1JEKy27zsK+h/XdApHsViL0wotvNQv
         w+Hb/85/wT9ceDkfgVW+G6IYGTbb5fsJ8o9fGyPLDTIRNzBRO1ugYxZ5MNdbuvW9hPeV
         igg3lfDZRsZ0gAOIuUytCip5T+by0dtLChHGMRYd+A0i8f3NiZbswoHf2me/rArAmgdP
         /Tllid7uvOaNY+ds1QL5sZbGaV1K60e+WTqdB/vtcrYLLW229WXSGcoxOk7Efd3FnxrF
         YoIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727881805; x=1728486605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=azwKkhgvzCiAQTAqS/hXT3XksVObLdREOz6kK45ko1I=;
        b=SQxYNyxlx4OqPItSb43H3xz617C3jLkfDDlnmGBxhv6lIDrsHwNC11bh4OUzDnkz53
         Y/lU79IHWOctg3iUcq0omLz9/RCb03ZjD6vxUmBRlXrsBGhFdP5hVH/XeIbzHAywT+3T
         VNb3lnJQZz2xip8akLRy7s4OeRuCCsABFm7WvHZDBNuzrnWidRVIk/FR+//+rlb2NbI7
         pkUJpIMJlgtWFwCfNDL2mxax8Rtd+1R0A3GtnQGmYbpHsqWx2gx1pDUczWTd5AaS+1I0
         LCIjetDOFmIUyAEMUU0Tz2RWZcfVL4y4zZFnF8f4xdZ6V6tIJaLs5/8pGpyz2cTBvNnM
         B0Yg==
X-Forwarded-Encrypted: i=1; AJvYcCVM0Mc6xscn8mo3OkGsPLbZSJGtWDgg69HbHXysEuIS0KI28xDImfJMEF7SVwXOGCt5Lrd89aDK6kYc@vger.kernel.org
X-Gm-Message-State: AOJu0YyQtpqob5+iKW5giVvVPVelpblwN1DQzhOGSZPUaIEu8TyZIBxI
	helnTJjRCqPls09s+h74pjebXPK/7jefpodn7XxPMmfxrS68zSZe
X-Google-Smtp-Source: AGHT+IFYZNtII4Chdcg+PrrwFFfXzZ+rUTW9M2KRyLebnWgrEUov3BXNdi9oEtGqmFzsvNbryvk0ag==
X-Received: by 2002:a05:6402:5113:b0:5c8:79fa:2e35 with SMTP id 4fb4d7f45d1cf-5c8b1b8b359mr2408783a12.32.1727881805233;
        Wed, 02 Oct 2024 08:10:05 -0700 (PDT)
Received: from azathoth.prg2.suse.org ([45.250.247.85])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5c88245e737sm7709533a12.56.2024.10.02.08.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 08:10:05 -0700 (PDT)
From: Brahmajit Das <brahmajit.xyz@gmail.com>
To: linkinjeon@kernel.org
Cc: ematsumiya@suse.de,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/1] fs: smb: server: Fix building with GCC 15
Date: Wed,  2 Oct 2024 20:39:39 +0530
Message-ID: <20241002150939.1425455-1-brahmajit.xyz@gmail.com>
X-Mailer: git-send-email 2.46.2
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
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/server/smb_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 5b8d75e78ffb..2b512f65df0c 100644
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
2.46.2

