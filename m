Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F613DA7DD
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418482; cv=none; b=SBQSL6uR1elwKKeyqy0aNhIlLtZJ0csHMHlR8itClaXesB+fELCWRzGrHsnDNwbWbQnnKNQW9ggddqP5TDtzB/FtJCXYMOAsw+UJfKhd4VWjvo7fdIRSVe4Bcu4OsjUazLobM7hutXMa9GAOlG9qGuow+5bvWvXl0hmGIaIDhQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418482; c=relaxed/simple;
	bh=tcp5fgS4AQ6LzcXR0gOUvutvr85mWxkNvX76pZRSybg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djqqQTLohuvCnC/STsEEWms0ehhmaAl8jtlvw2kFzm3WEiB98qfx2hhFReLeujCLWiSNlbeNWUZ2Bq2SHpMN6I7iYMvO0ihxKkKo0eywygDdp4CbJBpV6a54yLiZAlSQ36IXnaGu/r2a7WVfQK8p2SGVmkLb5WlJB/n7E9KhUeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hLRkuOee; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLRkuOee"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493c486f012so16699085e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418479; x=1784023279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nDdP6S4++kdpcrgalB7iTyXs0mjCCYnDbJcnHOHAD68=;
        b=hLRkuOeeDSgwlQJ5hRvd9m7McUFzEwY7kLjV1iDnfNwuvtFHZhg4ItD7WZfSECm0XZ
         kSUZ8YPRgU9o2gg+mWXdOXA3mKv0rn6i+8wuRk2Y+rNDaUbl+Tb6TbcsLjJsSI8p/ZBx
         TmN3szmBxYAameoQhUrzwxvyHEBel5cOQqBjkQZ3hHbh/qXrFDwyiL0j7ck1/GKY+dOv
         8tbiKZVPqK11xPf4RnWTlZ0H/cC37Fko+7bfVNhX3EeMfWGOYFQwKBgK1tiZ0UgcYuyT
         yZoutUEbszeBhn2gf9KKzZEUGPTnBAOSqqXtBaEfB5hcz4XdGdwR+BdvdpNMisdoiwSN
         gMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418479; x=1784023279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nDdP6S4++kdpcrgalB7iTyXs0mjCCYnDbJcnHOHAD68=;
        b=Vh5xBXCRhd2M+UvLv0/cq9NyXEXGLPVYg+ivmpachU9Sf8pMv9q1S2j2GfMmqu+t5O
         QliRwW8CSy2lSftJlBvYjS1AhWYJFYmOe4v+onzp0RO/mUP7zmZLlYeYwnj1A3wdTQo1
         TbfRJngXIroT8len+yGG57Mkiuu6yZNHpGfaNTH8LXcdzD9AdqYoJmvOLq0Ne7Y1iUjK
         8wfi5EBZFFKpQdNGUxHCJBfE1BlE9mlawo8zUlzQGuhXQ0+18UuMFZ7PGs4bM/exk3Pe
         +jFLv3WHN5AVjjTpSHVYMnyEFpByVFQRZA0YI1uq8Cs9f0t1XALbOaD0UQ+gF2v6mHfs
         iblg==
X-Forwarded-Encrypted: i=1; AHgh+Rr0ANRZxgqOBlIfKZaWm4foHMtut5TLCYmDusZJ/wLhLtoZA4UuX4QCjPVykN9/bhLb60Y5Hz7E2Qwj@vger.kernel.org
X-Gm-Message-State: AOJu0YyA9QIRcMTPm1tyE+GO8wQSzGyxmXcGh8ZQbERM2s35vL5xAAO8
	b1dgYCZB3wK87tz5NpMg9vdQdKAYERWLMVMCCz6pGzAqor8xZ2np9HOq
X-Gm-Gg: AfdE7cm8wY4Ngmf6Aitkf6t9aWaPAueAIFRC0fMh2ewqXwgSIcI0nLJVLZIjm8SQIAV
	jB8TVJ8kHso76nJ8gVslnmUyqX8y4IcHin7dFUk28njpXuiEvbc2qloa8HXMpuXz2R7gTVIaYxI
	S7lIue3LC+Ko9lz8CDD1wzhYA5rzt0cxf0ttHZdy8mS3Flz3FcXGa+GnXqWAD01CeNMG/b3sgNL
	lRdi3BTN7B7EB8db5ls3UQeqmOUsA4IiU0n0XgVTLR2v+Lw6f+LF+uk2eCEkgRO7VkUEOPpE+8g
	iGhtGbKYjQwzEAMoIsYsyRU0L7wBDpK1npf9BqeW/Vl/MLSNX4mFsbeqEdlFDpBhYlXv2mDzSAm
	g+Q9R6tfRzRmJhjPMx4IcYRdBY1ccD/dSb5CNNAkkXn+WtQTtmTDa7//KyMi5+dxbkHhQloFByQ
	7u2JeVrVZKJim6t3uLcHZJqh6Ad8xEcPRYGjk=
X-Received: by 2002:a05:600c:5288:b0:490:b2c9:e284 with SMTP id 5b1f17b1804b1-493df09608emr49031435e9.30.1783418479360;
        Tue, 07 Jul 2026 03:01:19 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm33908295f8f.26.2026.07.07.03.01.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:18 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 5/7] ksmbd: quiet mdssvc RPC log spam
Date: Tue,  7 Jul 2026 11:55:05 +0200
Message-ID: <20260707100033.47512-6-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260707100033.47512-1-g.blivet@me.com>
References: <20260707100033.47512-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

macOS routinely probes the mdssvc RPC pipe to check for Spotlight
search support. __rpc_method() already falls through to returning 0
(unsupported) for it via the default case, but that path also logs
"Unsupported RPC: mdssvc" via pr_err on every single probe -- which
happens often enough during normal macOS browsing/backup activity to
spam the kernel log. Add an explicit case that returns the same value
without the log line; behavior is unchanged, this only removes noise
for an expected, routine client behavior.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/mgmt/user_session.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index d6331184e..e2338521e 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -308,6 +308,9 @@ static int __rpc_method(char *rpc_name)
 	if (!strcmp(rpc_name, "\\lsarpc") || !strcmp(rpc_name, "lsarpc"))
 		return KSMBD_RPC_LSARPC_METHOD_INVOKE;
 
+	if (!strcmp(rpc_name, "\\mdssvc") || !strcmp(rpc_name, "mdssvc"))
+		return 0; /* mdssvc unsupported: quiet, expected macOS probe */
+
 	pr_err("Unsupported RPC: %s\n", rpc_name);
 	return 0;
 }
-- 
2.43.0

