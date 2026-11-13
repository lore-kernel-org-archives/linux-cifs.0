Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794543113;
	b=HXJbOjC/cwgE9AHVKOjFRy8aAcJISMdZ+BBuTE2L+4mxLQjkgeKVFR6l+OChX9b7fBSy
	 MqefMwFISmZMgP8iwVc8vQ4qhD3VPNRcwAmAkYoadjSgUWgJAvsI+FhhiWNJ+6s9F/C4v
	 OGHQ9mmh31b6N2ACLy8Q+H6L8tevzTdEKFDamuFtYW6/VxnjJxEZqiPHOxtk4lsMHvbgE
	 +cxVBDXnKzG6Na66PAicQDvC8BQtDY13oxeC96MgaB19rwtw8mhVoRLlrYPmguWD/heBH
	 TloUNwhVpM7Y9aaoLADhdoruXK/gt5a9xynNT44ykWjZuY8lwx5PNYpfEM/GL1Sjsbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794543113;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 X-Mailer;
	bh=+QcHvWhel5/dPmS42dqpgmO5CbR6S61U7RfxaWp2X7E=;
	b=cWewH3sX6Vbc1mVhVRkYzH83hCnI+h3BYVqiBP2v6PZG2U8C1gWRQvvmBupLFinc+iFk
	 JMXmctyeBqGcJEMfO6RyuivU3sD+4LHpv71k/McZ48gNNBzDCYt7bCdhf+Rs361yQq12/
	 h33Xuj9PiP2sDY1Zj7dMF6yA7nspz/wx5jYHYJwmNe4zFpe14yNrizU2Zn/gS6SC2ogMp
	 yAqO7MqZ69IAcKc+Gjk99eEkwbKCdNjAIdI8btxetifqeDbijmVZ32ZZmYkPWbEkelUXT
	 qnaU39b5SiH9eIZ7MQuiHgtj8rNCeorKzK1mrfQpcEufJW8tMAAKWI750B0KUtYeD3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=in9WGua3;
	arc=none smtp.remote-ip=74.125.227.136
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E61F606A32D
	for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 04:11:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E61F606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=in9WGua3
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-3ac749e0719so94107a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 20:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794543112; x=1795147912; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+QcHvWhel5/dPmS42dqpgmO5CbR6S61U7RfxaWp2X7E=;
        b=in9WGua39L0omvpYDDCOMC0CXHVNrjEIloyuYM1bOBGeJWgekUruiZ6camBTSkri7l
         +PqEU4f4Uxw5r5KYBAMkOhKxO6viFjGz9oWcb6ccrvBrRFXCdpnEmdwY+N8Xb5yeeMEZ
         ACfEDqG+SrcwRnQR/B5iIBFcMpgTCCGNgsOCr1HIpTbba89ULhhaG4IheqsXa6d5zE6v
         ZVZQe5g+A4KIs0XEfmH6RkhoAwRqzjBKkUzBmYLwYfeNB/+hrEuJ7jGxmUAz3JegFnXx
         U8p0m4Eygzey4YaXUcwQCxLa5WuWYIZU3jQPcVBQ7fpTB4+yQbNQ0fY67Ch4v9xVbPpZ
         OsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794543112; x=1795147912;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+QcHvWhel5/dPmS42dqpgmO5CbR6S61U7RfxaWp2X7E=;
        b=hy7wequ/QgK0Y2CQ3c+aDHT1A5d+pfhOOXl7Vib2P7j+rhLV9xin2kdAQamIQXkDBQ
         TriTwuF/1ByFQ8aJvit+Otd2xAtXzyzcw+OEb6dQ4jTMlMR3VY1lZ4kacag+0k6Iruwh
         LIHjnoYS89hFlRgmLHv4nScR8ftK5dmkbfA+quSa797SBvtBm+SC3EFvtOfqQET3Doy+
         ucri3hOv3nIzormiRYecPb1XSSoIAEZj3HegbhC/gE6D809iDKx/VanI3OPas1nyhJ+0
         B4kjSaQ9Z4MnXOQxTwDRwSNTWKmhFi8B+Z8O3TjZNK53RS7dAe6pB19ASYzvYZ/H4rXi
         Dcfw==
X-Gm-Message-State: APuU4Z9XCjB9HtbsQy0oRYHHl44xULxYH4arJfeg9dx5fSoPVYeu5QI9
	YS8aSvbstY3J8V4AVj/FQrtGzyhTwXPR6OAe+4d5TYzV2yikvae1IFIE
X-Gm-Gg: AYBFou10eEXiKhzrLiHU3d/GMjvmJn4J9NiD626Yma/fGs+ib7XnC1z60qA5t2AW9wV
	hLKkdou5/qB8zMdut+KdgXJnUmJU6LZMrMadiIWXx8FCFbPwlQFVXs0inPSs3UPMcIv4Ibnnxtu
	C43uidqmQnIINmZhtbknCCUtyDYC0o+gd7Q8DXtww8FS+XwYSrBNJ8T8/+u9dWgVRdqqYfymLFU
	ehmPBS/6Jkz271J0lGCMKqOoH2KmAp2toCp+5R57WhfLWZoVkqYUvO9c8uUxeiaVlurBTKZNkpo
	XttuvrlrYq7JwwPSwz0ey6yS1b7+9bNH0UkTjWmuqBpYYPmGYVJ8xorQ68YjgBcNHVT4MLnuZWN
	trxklE659/j9N/Ek6XtkxSB3B1MvKwnQdlLC0ON7yf1u/QsaQIRWeM+yD4O/NGSexUVStVif/ZJ
	7rqOq+792bpG9dbwuAuk3cSO6mLGnLXq40PGH0qS+0+ijlUVNlKUQ+g6TqMd2w3p/2I1gg8s4Jq
	bL0xZuCrc87MtCzOhNNckmmFVAAMtaEziJc68UZ8VmzdSQw1n70pEa1Y6ntm9RJP+ZqFZ/sqrqI
	biv9SPM1nbXQZoMSg6L+
X-Received: by 2002:a17:90b:1d03:b0:3ab:c80:9365 with SMTP id 98e67ed59e1d1-3b1b0b4cdf7mr951865a91.42.1794543111941;
        Thu, 12 Nov 2026 20:11:51 -0800 (PST)
Received: from hhost ([120.231.212.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3d279d8sm536744a91.2.2026.11.12.20.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 20:11:51 -0800 (PST)
Date: Fri, 13 Nov 2026 12:11:41 +0800
From: Xingyuan Mo <hdthky0@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: "open list:KERNEL SMB3 SERVER (KSMBD)" <linux-cifs@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH] ksmbd: fix use-after-free of parent dentry in lease break
 notification
Message-ID: <20261113041112.3736417-1-hdthky0@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.43.0

smb_send_parent_lease_break_noti() and smb_lazy_parent_lease_break_close()
pass the raw fp->filp->f_path.dentry->d_parent to
ksmbd_inode_lookup_lock() without holding a reference on the parent
dentry.  If the file is renamed out of its parent directory and the now
empty directory is removed concurrently, the parent dentry can be freed
before __ksmbd_inode_lookup() dereferences it, leading to a
use-after-free read of its d_inode field:

  BUG: KASAN: slab-use-after-free in __ksmbd_inode_lookup+0x21/0x100
  Read of size 8 at addr ffff88801aea06e8 by task kworker/0:7/332
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   __asan_load8+0x82/0xb0
   __ksmbd_inode_lookup+0x21/0x100
   ksmbd_inode_lookup_lock+0x25/0x50
   smb_send_parent_lease_break_noti+0x119/0x3a0
   smb2_open+0x5298/0x5df0
   handle_ksmbd_work+0x4f3/0xd30
  Allocated by task 11:
   __d_alloc+0x3a/0x410
   __d_alloc_parallel+0xd9/0xc00
   lookup_slow+0x49/0x70
  Freed by task 66:
   kmem_cache_free+0x22d/0x530
   __d_free+0x26/0x30
   dentry_free+0x8d/0x130
   dentry_kill+0x2e8/0x5a0
   dput+0x17/0x30
  The buggy address belongs to the object at ffff88801aea0680
  The buggy address is located 104 bytes inside of freed 352-byte region

The read at +104 is exactly the d_inode member of the parent dentry,
which was freed through dput() -> dentry_kill() -> dentry_free() after
the file had been renamed out of the directory and the directory was
removed.

Pin the parent with dget_parent() around the lookup in both functions so
that it stays alive until the lookup completes.

Fixes: d47d9886aeef7 ("ksmbd: send v2 lease break notification for directory")
Fixes: c2a721eead712 ("ksmbd: lazy v2 lease break on smb2_write()")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
---
 fs/smb/server/oplock.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index d479508c06c5f..c933d1e5f5458 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1760,13 +1760,16 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				      struct lease_ctx_info *lctx)
 {
 	struct oplock_info *opinfo;
+	struct dentry *parent;
 	struct ksmbd_inode *p_ci = NULL;
 	LIST_HEAD(brk_list);
 
 	if (lctx && lctx->version != 2)
 		return;
 
-	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
+	parent = dget_parent(fp->filp->f_path.dentry);
+	p_ci = ksmbd_inode_lookup_lock(parent);
+	dput(parent);
 	if (!p_ci)
 		return;
 
@@ -1797,6 +1800,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 {
 	struct oplock_info *opinfo;
+	struct dentry *parent;
 	struct ksmbd_inode *p_ci = NULL;
 	LIST_HEAD(brk_list);
 
@@ -1809,7 +1813,9 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 	}
 	rcu_read_unlock();
 
-	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
+	parent = dget_parent(fp->filp->f_path.dentry);
+	p_ci = ksmbd_inode_lookup_lock(parent);
+	dput(parent);
 	if (!p_ci)
 		return;
 
-- 
2.43.0

