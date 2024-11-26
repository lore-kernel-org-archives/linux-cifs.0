Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512288F54
	for <linux-cifs@vger.kernel.org>; Tue, 26 Nov 2024 06:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732601527; cv=none; b=AaKMJwk0vm6W/AS4uXz/7ICxSjfD7OqIQ3nJxbTK3y2Qvns459YmzA3XH1oAccF0dBeF0Aj0I+ZevpYUR8wAFOhKuM+vt3b/Ma0sfOcFX6fkPqmZsIv0PvkvK+zcrTgvNpzWg6CLcGI5FNHtDhjLZjH/9Zi41bhq0WKBD2B4tYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732601527; c=relaxed/simple;
	bh=G8IDoxjpw9w7QMMvmX8zZSewkZW0bvbcv0wDpVO+y7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHLk523awDoWtwidUuK4/USh0CjDbCwdllw1ABuCBNqf9PesJ38xv3u/zVaZinqM+sbp7JmCgwdOkG0UMrunGpkqdQx38NwmHswqlji3sYFmls+CfQOATcC94UZFafoTl8RinEPP+ioQn+HGz6Wqh1RhsAVhJn48cnNcnGGMHuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNPPmoy7; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNPPmoy7"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38246333e12so5220771f8f.1
        for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 22:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732601524; x=1733206324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ShZ5CVYRw8VHCG0KyxbarF6vtOAF9YYbvwBWyFBOcMQ=;
        b=nNPPmoy7viByGA3ejw+Mz3E/YeAijwKdMhYRP0zLKmma67mghMacAUaV/TM/Adao0m
         yNHQ669KdI6DIP8cyAdFARlZ6hE/1e1zZNAvcvj7xRU4km+KckIqth+ix8XuqZTQlKyA
         z6VBDj6P+mL37ROod/Z9s4SfMkbl5/t9zm9jJt9KrJ+VyRw1291MRfIsAGesRnUjaHUC
         Zg6+S0wRN2SgWm/ovnfO6AfMK64Mnmx0JsY8VJzV5w2mpDoFkCaoYidRluETzB9lpuWj
         BXkjQxE/vlnkmvcE4eejEBj1ZVtxA+3J5hHUQe0ibxW9eCGS7bzx/8vODEFmfzNutdki
         RkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732601524; x=1733206324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ShZ5CVYRw8VHCG0KyxbarF6vtOAF9YYbvwBWyFBOcMQ=;
        b=cByhqwP0gyq3dA+vLAiIOATWiTDs7CEGh8j23gG1I51TrLFtPXoDzLGxWZ5+2Qc4KI
         73L2RJCZXgywXfRXiFj/+01UoSH2jYrSKZrE2QLXg1V+cTLoH/aiiOoboxmNpJuaRWh2
         ccdlZOFu8a67QP38j23kxRaivcwsdsydE5/L7yAUvO8YgTctvbxlPRcZzu17FjDzRqzp
         arvDIgWryGCJ5jKRh3PX8y29+si9sNpEiQOiCcMwbytdljZmPcYKHgEDUpUIPZ8nWI2K
         72zdp3RYBM/pgvWB6Jq7AT8GDuLRUtwsVz/bCxNmj1f8K757ROYqblv+vgG5cmGu818x
         qyfA==
X-Forwarded-Encrypted: i=1; AJvYcCV+eKhcCFVzgwH6HN+qTorHdVgKJTZJmpotU6je5TfJ5NcMMDIVd/tPAlR/I7v0XCTjN6Db5kGUZoyA@vger.kernel.org
X-Gm-Message-State: AOJu0YzuPCYAGlJzsVgvRVcp6AzYHsHcT72iSCSDaQZCyl/l4lFVG5s6
	wUAq1RDyDXPit8hrY4uqW86mc99AxWai8tuk+qEt7xIcNPJvZr6n
X-Gm-Gg: ASbGncvMuZ3w+9jhSLNqgmLK24ueAt2S0DgvUxpJaqxMOHUV7u6E43tO98rtfJRCnJP
	r2KudpNXhR4Y7nJuQP0c5HiT+DKYJYmbOuZEM61LH9phOH1cU7DJTbJA4dDQHhYEJ/d8vr6ZCKP
	lQO82VtgYePhzpNzirR4t/py7p0r7CKSfQpR3GpAexTGxMPKLojY8i50KJsWXTbewuJ/rqDXR0J
	/LdG8Lyx/JVSDG9mfztQJgrvaNjC3FPMIxTWqw2UzhuAH8LNEtU9vl2pbCW
X-Google-Smtp-Source: AGHT+IFwrIvt02kf1JfHwrdM0PL9/P7IcZ8NYaUpTF81eUgQxXcun89f//FlmUdrf00jdeycMPMHeA==
X-Received: by 2002:a05:6000:18ac:b0:382:3afd:1258 with SMTP id ffacd0b85a97d-38260b3ccbemr15944999f8f.8.1732601523406;
        Mon, 25 Nov 2024 22:12:03 -0800 (PST)
Received: from azathoth.suse.cz ([45.250.247.14])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3825fb30590sm12374477f8f.57.2024.11.25.22.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 22:12:03 -0800 (PST)
From: Brahmajit Das <brahmajit.xyz@gmail.com>
To: linkinjeon@kernel.org
Cc: brahmajit.xyz@gmail.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	sfrench@samba.org
Subject: [PATCH v2] smb: server: Fix building with GCC 15
Date: Tue, 26 Nov 2024 11:41:35 +0530
Message-ID: <20241126061135.2762074-1-brahmajit.xyz@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAKYAXd_aZ1RT4yxC4fasmYk+M6vWrpwrjrJgxvf2hNzra7VJPw@mail.gmail.com>
References: <CAKYAXd_aZ1RT4yxC4fasmYk+M6vWrpwrjrJgxvf2hNzra7VJPw@mail.gmail.com>
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
 fs/smb/server/smb_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 75b4eb856d32..af8e24163bf2 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -18,8 +18,8 @@
 #include "mgmt/share_config.h"
 
 /*for shortname implementation */
-static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
-#define MANGLE_BASE (sizeof(basechars) / sizeof(char) - 1)
+static const char *basechars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
+#define MANGLE_BASE (strlen(basechars) - 1)
 #define MAGIC_CHAR '~'
 #define PERIOD '.'
 #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
-- 
2.47.0

