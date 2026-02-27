Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F353321D4
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 05:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772171667; cv=none; b=F3Dhq4vr8Obw8bazyeJTtRcUjUfWRs8Wo4Wq+xHGymrMxRqxO0iFnXDYlemvpffFWnWqg0gKSAwNe90A7Ch3WmAgw6UZHrMp1zE2EVUOIFDHq1DMHNxCFO1Rovw8n+lCvS8YOaOVY3RpSvEKdKwhQRMtuuYbKz3+nV1wP2Wzg1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772171667; c=relaxed/simple;
	bh=AkWz5k+2wIbunIL0p9X6aQXFpOqWdjrXbCIk8aWyUdU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZrkweCWDPn6n+YRNi9Uhkkj3iqoZooIRoBhXCBLMzzn2X/PfKiXZ8TUKBAKZiS5Np4Cr4Avi20e5c5MA7hrEmSTpZbFjy0z78ZNGG8AZmQI4SNxA97ldihvXen0YhMaN4eAviOcB0P0PYxb6Cqz4x+sz/ijiVKNyVGxIEl5j0W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LkYbAUTQ; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LkYbAUTQ"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8274a3db5e3so427019b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 21:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772171664; x=1772776464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=QosvNuXboU32D9oyRT8fsiY7HceoagCHchzg2894r1Y=;
        b=LkYbAUTQVFzYYLGsf90B+Sq0hovBM2zb4ghKOQ7aSWUW43cuRWulvnkeBsklv1Fys+
         kc7yxX290UjvDtnn66EB3UU4lTgKa5fe1Sc2WOOcghG9sMNp1tmz6ehsCvWEDm0enxIe
         o+fgEKb6Zyb0LKMjxxkreBQUgajptIzgMFvbpWheJLgGNPBAPh/yKBdzlJNsUJsYVYtS
         BWmAZjdDhDzo/3gjAGzVapsmi0iYN1hHs2yIS89wGqWNKncPOJ12LCdMwEWLr7JVU4Qf
         Aeu9tF4GnolKuNeirNWBAtFebTRO2VBtE/qyE3x8hkepJJHL3I6svzY6DePqm3UgQp5C
         GejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772171664; x=1772776464;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QosvNuXboU32D9oyRT8fsiY7HceoagCHchzg2894r1Y=;
        b=U+djMd4LUWJFgC25vNmt5UqvnqA6fOJoT/LQ8kOe1txYle9YHtKOMD4k8bxfN3anty
         /l0pzjQyg1r/YkfG2oGWoAqkQKcQ/OqEghcJBkQJAKIjln/xx8eeWCQ+grBQ7hokYhDC
         myaiaZffoFXGHJIjPwOi+L27TYMBE3Hr7G5+uIzocqzyI8GzydfzIkxUVp7HTOqHPUBy
         X65x3cDGkTw7tCX5qsfQQkPg9223rMGR3yxMWgQ3KhC3KFr1YA8G9visv6EQfMpg9sqZ
         2cIEO9XoUkywbkrqhYk79vg9Ftt04sw8o6g2pSP0JQrkBOQVQMroR2dshHp5ekcCZ6B4
         owjA==
X-Forwarded-Encrypted: i=1; AJvYcCXAKQ5TDHIXwO6vqki/977QgrjIIkrcdVuq4VtSDEfKTVZmDLr9GlmgTnYq3/2eba7TXcZH1dtXSWaj@vger.kernel.org
X-Gm-Message-State: AOJu0YwiW3ec8AJLCTEjUH5y4YnSnZc6KKSormZ7czB5UBXY6+tN7K8Q
	IJ/iQnhCiu/uzOAzQL1maDt0WSRsGly48GqpctIP+864PwO3wqpDAk2A
X-Gm-Gg: ATEYQzzgmHEu3IGxv/GNTpVRjEKIBpbii2E71cRELtUnJxBvh1FdPyoKgxvpU4E5La/
	ETvGTDrIngG84SjO9CzxAFE8qEptNiunlt/pGN8ulYuY6cA9dC4GHRP20Avfs3wYOGyW/Cot+ug
	61mrSHFgtwx8FPOALa7jx9Dt6oiomW8vsgAsT7W59X6q1Ust/4rWs4ye0Au43pJYVNt6aRxwN9V
	haeq3uUH7QuFZlLVrTJxX+1Y7qSTeIIFZNtg3tRh3CMYrS7OpxOnuJdf4TV9/vk7+X1xQA2XIHd
	ut677/OWHu3tbU2EMo3yjTlZMU3Y4ojAsb1FlDLkWndO59JSWVqdcRtSUiRdhwqQM1ifB1xTlY+
	ceckkpezlc0qq/yKUMyNQhS26KPFr9E5lGrycHBXfW5MWlYOX5BsxFNPv1JLYCSHNtQdFlD57QL
	w43oHSCUL4lfIVrH/lEHFRsNwJmyJlsbHPhiY8
X-Received: by 2002:a05:6a21:44c8:b0:395:7fb:9365 with SMTP id adf61e73a8af0-395c39df01dmr1569566637.8.1772171664134;
        Thu, 26 Feb 2026 21:54:24 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa5ef857sm3316593a12.7.2026.02.26.21.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 21:54:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH] smb/server: Fix another refcount leak in smb2_open()
Date: Thu, 26 Feb 2026 21:54:21 -0800
Message-ID: <20260227055421.1777793-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If ksmbd_override_fsids() fails, we jump to err_out2. At that point, fp is
NULL because it hasn't been assigned dh_info.fp yet, so ksmbd_fd_put(work,
fp) will not be called. However, dh_info.fp was already inserted into the
session file table by ksmbd_reopen_durable_fd(), so it will leak in the
session file table until the session is closed.

Move fp = dh_info.fp; ahead of the ksmbd_override_fsids() check to fix the
problem.

Found by an experimental AI code review agent at Google.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Fixes: c8efcc786146a ("ksmbd: add support for durable handles v1/v2")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 95901a78951c..8b680c96ee44 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3011,13 +3011,14 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out2;
 			}
 
+			fp = dh_info.fp;
+
 			if (ksmbd_override_fsids(work)) {
 				rc = -ENOMEM;
 				ksmbd_put_durable_fd(dh_info.fp);
 				goto err_out2;
 			}
 
-			fp = dh_info.fp;
 			file_info = FILE_OPENED;
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
-- 
2.45.2

