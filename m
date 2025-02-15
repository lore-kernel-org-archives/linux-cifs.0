Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA7C1519B3;
	Sat, 15 Feb 2025 02:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739585466; cv=none; b=N/eox9Icc71+DJBi4uNOTtKqO4x54b3Br95bt5PgftmqDFiEMugQJD+syFoMDAfD+hLv6FIyeEkaipIwfdE551SJE4S+GaayJy3ZuGFUOK3wN6+i9kn6mAbTbQapz10J5DDLQukTGA+xTz1N3oZv8k4J+Pl5bLI1X5dLjdQQwp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739585466; c=relaxed/simple;
	bh=fqLoR7qE0tAgf3AjuChE3y2lIyPhwPqfV7bvGF7BsX0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VXuA1xyhtBnCIhru/lAwWcYlNBYMFdlUKFWUyF128y3WaZ2jQHfXnaWT2iLmX5zYd5F8S7AuFz9RQ1xJCkVzNGYkgxpYTjrjZ2bc48RzOFU6lHa45nqnVfES73zCwNIwbC3X0i3isri7CUSC3oppdulnAAu6i1h/9gA4Sbinw4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-220e6028214so40221775ad.0;
        Fri, 14 Feb 2025 18:11:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739585464; x=1740190264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T0ReVf0qnhyKXGO+hX092mbyMrSSQcjdxP9zd0LJNJs=;
        b=LlvmKYAabk8n3/GUZfM6KKHyDeWLNiULXO/HNi7CRbRM1IVL+qsLebpJWCwdL18iK7
         y+Xvs+YPE9oBTqR6LALgeVByCbuHRTKlNNhnWZ7d39Ws/RcRwb4cUc1uazR1bQneur5H
         kP4zGu0oUupz4vxwJ/CLttU5AkfLZcWb4mLBXAerk7N5WENMZ8WLWVPRHLbZO472jfnC
         Qd+DcHB93HHfY1AHJ5p+0ulhWW3lG0BlUwOZpZYAylQYYO1MGj1oiCpi4VmsY1Mkg/pX
         /KcFQ5NvEPPIerPzJ3CLws8ilnfcCp7jI6gWa+O4Ru3d1B7pf4adE6/BPNfJ2QbwzlzH
         YGaA==
X-Forwarded-Encrypted: i=1; AJvYcCWjH12EslKCeIGS+bVTkf2n4PcNShGkPVLngtGTBN8ZfVkGEKvWwdFx45MY9zkoKNjxRXH+ry/XgdK9@vger.kernel.org
X-Gm-Message-State: AOJu0YwLO+SfldmETeGzizx1BjKJSmEHdC8oAecT0BOywc1qtHOhOJ/V
	pOZhmvZwTmmgXMzvMxUzDK5DrsTZns1UiGlsertLLwyOmljG2BGa3ibpTw==
X-Gm-Gg: ASbGncvqLEudyYvjI3bTCx6N76oIkVHftXslQ48+LPjpiU2k08cogBEje8+4ARMY5mv
	2qxw4VWXQzRCdDEaYjAi7wxkD9YVDHwgBEFCqjMemmgNNa/MdXCYVHuW6J+IivPLNnaHlBRUtcN
	ZwmB9XGpU2rdDNHrtRjukxuddshFX+IlEh4JfUkVp/jmiCUMtfO9uAIlfZ0D3AdMFlqjniZgjXu
	jlOUJUALmOAIGlucKpK//56AQW3qR/Z+7h/vQYRwmMl39P7qtiZSOIB3jPAIOWlJeiVv/eh2u+u
	aIiAIpOUNL7Sy4mtJIvplZjeC6QVzg==
X-Google-Smtp-Source: AGHT+IFJN9v/I7Ko0ifLBRg5AN+d+73Bqjt6lyhi8HeDMsR8RSrDt0wPSUKsN6fU79yW8y3UZ/QMFA==
X-Received: by 2002:a17:902:dac4:b0:219:e4b0:4286 with SMTP id d9443c01a7336-2210405f22amr18672335ad.29.1739585463989;
        Fri, 14 Feb 2025 18:11:03 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d545d663sm34727725ad.120.2025.02.14.18.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 18:11:03 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH] MAINTAINERS: update email address in cifs and ksmbd entry
Date: Sat, 15 Feb 2025 11:10:06 +0900
Message-Id: <20250215021006.6210-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Steve mainly checks his email through his gmail address.
I also check issues through another email address.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 25c86f47353d..c4a56ced9633 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5782,6 +5782,7 @@ X:	drivers/clk/clkdev.c
 
 COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)
 M:	Steve French <sfrench@samba.org>
+M:	Steve French <smfrench@gmail.com>
 R:	Paulo Alcantara <pc@manguebit.com> (DFS, global name space)
 R:	Ronnie Sahlberg <ronniesahlberg@gmail.com> (directory leases, sparse files)
 R:	Shyam Prasad N <sprasad@microsoft.com> (multichannel)
@@ -12653,7 +12654,9 @@ F:	tools/testing/selftests/
 
 KERNEL SMB3 SERVER (KSMBD)
 M:	Namjae Jeon <linkinjeon@kernel.org>
+M:	Namjae Jeon <linkinjeon@samba.org>
 M:	Steve French <sfrench@samba.org>
+M:	Steve French <smfrench@gmail.com>
 R:	Sergey Senozhatsky <senozhatsky@chromium.org>
 R:	Tom Talpey <tom@talpey.com>
 L:	linux-cifs@vger.kernel.org
-- 
2.25.1

