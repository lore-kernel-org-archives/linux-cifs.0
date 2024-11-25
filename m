Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E6514AD2D;
	Mon, 25 Nov 2024 07:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732521235; cv=none; b=hkpeLYUkUmzRftA/+h1IRnOFoFe6agyj5OE9mLtx5fIs6w2fhkEBGvFnaVLDfVMTSFOR9SLj4PSESPWlQnq/y4QL36pCr/y9vw7oUPIbyin8h+fdNhoDYtqHaijagRsns6WtdBGSH31lTeHbd435pxQ5E0WAKPn+wcvHOkbBrfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732521235; c=relaxed/simple;
	bh=MTOg65FPbtEHzj6ceXeU2wiwD4YbqciYNRjbouWBU7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cNTx7V+PYl00OfQboKjW7YWlfD+Z5L/WInNAYYhkJ3fEPcreL6LGv18JLDdKGrb2nu5UtOLiJg0GmzRnSVNsUlTC5PAUQ9476w3zbZsyanxQ3vmkIYkFudXgnYZZc4Tiv52MTTBtw3N6/xvVWR/DtXJIn04hpWaDnPpqd7Ya1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XdqDE4eT; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XdqDE4eT"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-724e1d0a52dso95485b3a.2;
        Sun, 24 Nov 2024 23:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732521233; x=1733126033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b6jiE8fsXfsP4ikoV8qpavcElY9z/0rHh5JLKGf+AVY=;
        b=XdqDE4eTJnOXLkXSj/DRtrLaE86lL5iB2BLXiqrLE+s36MTJIuxFcybQ3ze85CXG8Q
         /hwfJm0QFOH7Hh4rDD0zmCEfTA5bZAtEf6cXJJ4I8X+zxzV1oUN1nfff5lVk6XluYBb9
         4lJTe6NCDVqepuiBI0l//1flFzz7FtrJ/dbY+p2hfZqsh8mjaiLNn2yY05MrfMCpAbve
         IuZsBa9y+wQYh9rnH/8prqRkjeIgNox1uqb9wnmFUQduDpYLVByZUvsVbTFq79rNZwbA
         vzBiB6T8UB2pAXhhk4l78qZOCe+uqtkh0SIxYFa4Q9UTUgn5Jdd/vDiQMH8MVhPNr7oE
         Rsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732521233; x=1733126033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b6jiE8fsXfsP4ikoV8qpavcElY9z/0rHh5JLKGf+AVY=;
        b=t0fatmKjdoVZVjj0NeE8X9Mn+ZSCa5eW+se5lGqzcwyAxBivbNONP0MTwgN28WLQ5N
         zpULbFy6xZCBWMdJrPWEz+ZApuHO7+Eh14hBYbsc7bh/YG9HQawzPTzHs+5kXU8ypouQ
         /Qk1YRX21ZpWuWILDUvYABMuXApNnudQOb/C/NdZHTEozeG+EjwEqYeOOww3UnhT0r6i
         nXzJmLQGniathQ5KVA0+v8oIVkIDFA1QYAtH6Bi12SgqZ/qnKUSiE25ndEWXmoYxUlFh
         C3tJ3zI/dnu0YJmBd27/swJvo9XEFZ47OqgoWGPJdGZ8Ew85vlhSjno67BheUTUJAKsy
         AUtg==
X-Forwarded-Encrypted: i=1; AJvYcCXU5PKTNhY9ZIuAgfGacZXh1glJgZCqPwXnKyH8M4QKXm4bfVBaMi6M1I4meq+2YOTSRC/YNxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB3EF/44BhKS7dtxOctdDRwsan4hD+BYEG9U0X1GN4nI4PEoo5
	MIMg/eO+Q+W4/U8FYhV2OAqk9YAJ7IHIq3DuuW4DlCQBSo1TjNmGbYW/3HmJ
X-Gm-Gg: ASbGncv1TMYhEVP7hwqq9lzZjZIIV5KKZryA3OvatMgdxrx0oNLTsFsGxMUpO1XOIYE
	PyVYYzjfSuIpKJHSiY0O9OlFEgA6Tq05aiN1p7TUY4WCk/rW9Oa/bRornS1q4KjJotJ/kxuhKdq
	xm6dJKopbfn3uTyhIs42TJeV4849Jl3PWMpdne6u91CxgvrV5iD9wd62/OwGiyQuIRHO3VaWRYa
	UKKK/owbCKTXUqRjS0suQB1eGUuS0b0vd1/PMXDFMmULfVgcKbslAQQz5fDrWbFijKC
X-Google-Smtp-Source: AGHT+IFNuAayu5EdvZepTbzrWMZnA6GqzPGU7jW9+JoQ1R9AXY0IBG2nXCYhRIDpb9rIQW4j8RRnpQ==
X-Received: by 2002:a05:6a00:9297:b0:71e:596a:a392 with SMTP id d2e1a72fcca58-724df5d0c2bmr6744333b3a.2.1732521233132;
        Sun, 24 Nov 2024 23:53:53 -0800 (PST)
Received: from localhost.localdomain ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724de456488sm5780804b3a.9.2024.11.24.23.53.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 24 Nov 2024 23:53:52 -0800 (PST)
From: Yunseong Kim <yskelg@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org,
	syzkaller@googlegroups.com,
	Austin Kim <austindh.kim@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix use-after-free in SMB request handling
Date: Mon, 25 Nov 2024 16:45:55 +0900
Message-ID: <20241125074552.51888-4-yskelg@gmail.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A race condition exists between SMB request handling in
`ksmbd_conn_handler_loop()` and the freeing of `ksmbd_conn` in the
workqueue handler `handle_ksmbd_work()`. This leads to a UAF.
- KASAN: slab-use-after-free Read in handle_ksmbd_work
- KASAN: slab-use-after-free in rtlock_slowlock_locked

This race condition arises as follows:
- `ksmbd_conn_handler_loop()` waits for `conn->r_count` to reach zero:
  `wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);`
- Meanwhile, `handle_ksmbd_work()` decrements `conn->r_count` using
  `atomic_dec_return(&conn->r_count)`, and if it reaches zero, calls
  `ksmbd_conn_free()`, which frees `conn`.
- However, after `handle_ksmbd_work()` decrements `conn->r_count`,
  it may still access `conn->r_count_q` in the following line:
  `waitqueue_active(&conn->r_count_q)` or `wake_up(&conn->r_count_q)`
  This results in a UAF, as `conn` has already been freed.

The discovery of this UAF can be referenced in the following PR for
syzkaller's support for SMB requests.  
Link: https://github.com/google/syzkaller/pull/5524

Fixes: ee426bfb9d09 ("ksmbd: add refcnt to ksmbd_conn struct")
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org # v6.6.55+, v6.10.14+, v6.11.3+
Cc: syzkaller@googlegroups.com
Signed-off-by: Yunseong Kim <yskelg@gmail.com>
---
 fs/smb/server/server.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index e6cfedba9992..c8cc6fa6fc3e 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -276,8 +276,12 @@ static void handle_ksmbd_work(struct work_struct *wk)
 	 * disconnection. waitqueue_active is safe because it
 	 * uses atomic operation for condition.
 	 */
+	atomic_inc(&conn->refcnt);
 	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
 		wake_up(&conn->r_count_q);
+
+	if (atomic_dec_and_test(&conn->refcnt))
+		kfree(conn);
 }
 
 /**
-- 
2.43.0

