Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792506972;
	b=dt3FBootlGBnfbJ7l9zQ9uqPVCX4J0xVrkIsXXGgF1qOj3y6rd5jd1O+JnmGgloV1Dwd
	 P47cvZdnvTCSUbocjDXEA10CdiZC8IDyQ83r21cdLF0GBLisa66qNpk0BF6261ASHRfdS
	 EP0xrsrIhOBA0pWWvaxaFOnTNFxyIV/g5AcvfYiT3bxMv7208ayDogK3w2HujimemnaAW
	 KfloGGAZlCF8IoA6vwCDmH2tGzfjG7NszhcL0hm6i1ORPof3U021UqiXfY/ojkSkySdvD
	 GCw9v7LUUD5NjCiLygCHkUUza5C1aWWy3iCk58S7Dmht1T+YvZZcpGlLyE22ZA53lzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792506972;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+2iu3aIJF32cGS02KODg//wkIy9/0jNAnx60DBj5Tuc=;
	b=ZKbO1QaSKC7WkijyyToyxJhJZQnttFYcI7ggt8vRHM056c3TREke7ekXE/Nl3O2SerLZ
	 LoA6JXUhXSwIirXIowF7AWUBpUJE9YBCUroRs+c8lwTAV8tNvW5ppZElCLb51DFCi/bvQ
	 DV6AQhNyD0SWlXymTlZGBgJAkrhO7vNEKp2bpfKPwgZDQDIs1aAkr3pipmZBX90QoHZY9
	 RFAfiZhDd/DV2ssS+cVfgDAqZS/ZDlqzbB0PuMHkBLfeofZFY7d6tktTd1+BwEO3qy8RN
	 d7h1/tjh7vwvJFojALMaq/OzEjqXgM67odu4TCBjaatykm5WHdPhUVEeJdnZqTGHLtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fTmicZM5;
	arc=none smtp.remote-ip=209.85.208.169
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE33D606A31A
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 14:36:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE33D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fTmicZM5
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3ab3cb83f54so2109811fa.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 07:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792506970; x=1793111770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+2iu3aIJF32cGS02KODg//wkIy9/0jNAnx60DBj5Tuc=;
        b=fTmicZM5odu+gs3ANXnT8HxcmR3UtJLbn5fjVooKO0eaT9jpt9b5Z/Io5arniaXgMK
         RmQFTESEQZR/dp4VsF8C4ifL/wgaQs+gs5e8rp5IvOMamrps72D3+CLVfRu+ZuVYPiJa
         rTn9VA/TGd0+AYKuAJqRDkQ9eU7+MXaAbWrorrq3FSopnL9OOAL82RlUv/Rp6YWvUGgH
         twEIsEbX7yq91cEau0L+2aJcl4vOSIdxizPqlLtwKzj7G3MrVi63Tc6JqEAlvs9zBsqo
         msI5VzNIObJ0gWmYwBtsUeTyeYWPzYQZYYhFQc1LDY+VUqTtbIgijUr4kdYrRq5db4rB
         vAGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792506970; x=1793111770;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+2iu3aIJF32cGS02KODg//wkIy9/0jNAnx60DBj5Tuc=;
        b=H7s+p9clXFUF+VJCNhForeFXnbBpA6U28Htake8zIwljlfsnS0ILdF7Q2wgxQyT+6i
         1nB2BGlHx0BEj8qRyGhWSbIpnNvEYXibMw+9YijttD2YLclyU8ZsYXxOIesyMaRpL0NI
         +VifPvHzLXaukiXZ75u3BcNDGkXdZIuw+MPrREdR9BS0QY67W6RJLz74YCgLZBVDtFys
         JA5bOsvonB1TvzdVmgePGmzFmGADfe25e/GeD9VbMfK7oSs0ICTkwK1AZtQZf5JFPZlG
         9my4VKikIOY1j4Ktl/9PTC8jRzphnRsC3MruWh6x73isUYsDSnR8jqySMQtKv2un24+W
         2LVw==
X-Forwarded-Encrypted: i=1; AKwUvByG2y2kMkjTAJDBFKhYKrxq1ahLymsMzgO1xbUU1Co0y/hGrQsGeZwjoKuZfodYV2Ec5OuDtaNckwH0@vger.kernel.org
X-Gm-Message-State: AFq9FYKCB3x7pGiD309LPI4LhcWbwohgbYGelKNsg+MHUqDLHlNqyQdB
	006KLH6JlhFPYl/B4GYyooHbWm5pA2n/NU/3pTgardYqUMRpwfay3hBQ
X-Gm-Gg: AYBFou05xs29oDdNhA7SIl7y4Un73klcprfbPBbmv+Kcl/Fxp1mPplWtDxIwFMjT9VS
	VUgchLK3QkX+3jO0VwuQJQu8Rgn1rou8RF1rQ0kRz8bSzYFlZT27tvSeUh67VPPWR5rRrK+EUgf
	EQgPHNLkMOX2MeA59FRA+0aPOgP2w0kYYO0PYuQbN36GT9z1fQJYSthwDlb4hdn8JcmV0neVcwD
	RAmqLCHLgOoy8Opo8PmL2usw43/nFmXNjT/2wZY/3WaUAAf37lnEXlpD444AIMG/5PkHgiXIInp
	3O+WdKfa/yl+MIfFITLREORASRS9f0TEcLpvjlPK9moOTsZzfkW+gt+9IayMrtJpnB/F6TFtK9y
	Xc5Fwi5hI2XtyWOnSuA/+36CxpZJPvCEA/MwySWYB6B/afQ3kfZZVDFg0tIdBPBPuvPYXlphIgr
	d7eKLX599mSXp59aZV0lBRDkMTxrtZapPXpuS+iG+OmXgTwvs91wZAMlnmnOK56RI3MUEMOaL3S
	FyvxXimaYa/
X-Received: by 2002:a2e:bcc4:0:b0:3ab:618:fc81 with SMTP id 38308e7fff4ca-3ab29118d90mr28181761fa.1.1792506969799;
        Tue, 20 Oct 2026 07:36:09 -0700 (PDT)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ab16d7ddd0sm33890831fa.4.2026.10.20.07.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:36:08 -0700 (PDT)
From: Dmitriy Okunev <dokunevdmitriy@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: lvc-project@linuxtesting.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Steve French <stfrench@microsoft.com>,
	Ze Tan <tanze@kylinos.cn>,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/3] ksmbd: fix uninitialized locks in __session_create() error path
Date: Tue, 20 Oct 2026 17:35:51 +0300
Message-ID: <20261020143553.105014-1-dokunevdmitriy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In __session_create(), the ksmbd_init_file_table() call is
made before the tree_conns_lock, rpc_lock and chann_lock rw_semaphores
are initialized with init_rwsem().  If ksmbd_init_file_table() fails
(which can happen on -ENOMEM), the error path calls
ksmbd_session_destroy(), which in turn calls
ksmbd_tree_conn_session_logoff(), ksmbd_session_rpc_clear_list() and
free_channel_list(). All three functions call down_write() with
uninitialized rw_semaphore.

INFO: trying to register non-static key.
  ...
  down_write+0x7d/0x1c0
  ksmbd_tree_conn_session_logoff+0xa2/0x1f0
  ksmbd_session_destroy+0xaf/0x380
  ksmbd_smb2_session_create+0xdb/0x110
  ...

Fix it by moving the three init_rwsem() calls above
ksmbd_init_file_table(), so that all locks are valid on every error
path.

Found by Linux Verification Center (linuxtesting.org).

Fixes: a1f46c99d9ea ("ksmbd: fix use-after-free in ksmbd_session_rpc_open")
Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
---
 fs/smb/server/mgmt/user_session.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 44dc3f800cd4..fc28088772ac 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -844,6 +844,10 @@ static struct ksmbd_session *__session_create(int protocol)
 
 	ida_init(&sess->tree_conn_ida);
 
+	init_rwsem(&sess->tree_conns_lock);
+	init_rwsem(&sess->rpc_lock);
+	init_rwsem(&sess->chann_lock);
+
 	if (ksmbd_init_file_table(&sess->file_table))
 		goto error;
 
@@ -855,9 +859,6 @@ static struct ksmbd_session *__session_create(int protocol)
 	xa_init(&sess->rpc_handle_list);
 	sess->sequence_number = 1;
 	atomic_set(&sess->refcnt, 2);
-	init_rwsem(&sess->tree_conns_lock);
-	init_rwsem(&sess->rpc_lock);
-	init_rwsem(&sess->chann_lock);
 
 	ret = __init_smb2_session(sess);
 	if (ret)
-- 
2.53.0

