Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792506979;
	b=2gUTkRWwYq07oeNZ6PpBR/Gf/hsnu6HCU26u8ubBqrqgu6JO57t8alV37f9qR5ZNGvag
	 F/p42kd8HmoLP9pR1CFG/G9HWIf0rBhXLaxuSugjx9WVMkMzXaNATI8CNCHP5nuUvHKyH
	 Jc1BpZfngubyJu4Vhm3llzBo/HrVQR6VXXmOHgWlQJoymRsN95TWshUG1eq0SQwVM2UIO
	 qklXsDKETV0Ikk6YDR8moAe8EYiCJtMJ/j+Jcz9TvMwtHG7kLL8nyV7eh7nIWpJ1pfFru
	 S4kQlxIdR1r85XBsipX0bmkEKWcaThZR8f1lFSN1c5NBhQpspWOAHX40GZ3dKaV8daw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792506979;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=isMBoyoms6oniA6nTm27JViI+bHA1PNz+BY0qs8OtxU=;
	b=FdQbBJ22Q9J3m0xq3fNilI+ydSqCSW9UxkHU/fGgUNF8KzihHNcnJyW2gMB/SY0bEk4F
	 PjKtzuAYM1YmkocuV2AZJxRk12DlnxFKD2aITFQojYTeKMq05mrTP6pKdOISkF7YphekN
	 H/LXJ9ml9DStokQUMR/xJjRhcNWE1p8V7P2aLylh118bKMlaYGok4r4o149j2HQ9Cui++
	 wa+/XoedDxQpie8+bk9zf69i1XFsiYTAwlBbPa/hnmbqWJ5WuW+OQac5PbewgEbzRxrbp
	 qGlWdC64lP46gYMpoVeD4VA593OPGlcNbOOL3wXsPk7+sTN5YjqFdg6kY9Y1ZuOCsxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=L7TzAnWW;
	arc=none smtp.remote-ip=209.85.208.177
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE92606A32E
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 14:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CE92606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=L7TzAnWW
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3a350e51559so5133481fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 07:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792506971; x=1793111771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=isMBoyoms6oniA6nTm27JViI+bHA1PNz+BY0qs8OtxU=;
        b=L7TzAnWWfgZfeCuY67XuabYOGr/Tqzy3AsLlOu5dVp2PlR46kCZ0Y0McOQ8heR4pPC
         D4aUrowk+C/P47dvv62Qpyhqo58IOZjY7xXFKy7dfjAlUPGgmE2ZgZDnqCZAd7WlDmxF
         YWIK3V9PgvAuF9gt2+Z3CgGfyLxs5yyX8sdOcwbBxriLu7KAl5e/p4KMMODfSGzB2TkR
         zUuaQSpRYgInQFNB6Pzd8X40avH+YyTDl7drnflQuO/zgeVvlRUnQD00uXWYemo0MYqV
         yiBxd7QKARBDoPV6ch1MhrkiG66w6/EmLA0JLhpXlYoBfiierKpgssViG5onUHv8Z7vW
         aDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792506971; x=1793111771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=isMBoyoms6oniA6nTm27JViI+bHA1PNz+BY0qs8OtxU=;
        b=MF7OXqbTdJZEkS6S+OsGdEB4OcITQX9dcSUsm1oSD4lBWsARUXv7Yzz86Uq2lrBM8h
         SX7bBTKtvBeufGLU3R0IlpJeioE/wgSeGpPrq+tDo7r/JEHlG+YXcLtiOCLid8PaD8ws
         DfXkekcAKtORRgpDW38LGk8wcOj9FmuweHlvDGkT6Kf41xqdGXg2ElsZv8oz8gn5h9QT
         E2X6liHJaA3omyBY2rX+KB+KxrIaMxXNsnqI0V23PJZdzpdsSV7YmPjQ6fOsIhB3gohn
         /yqEEVlyO2321qg0NRdS2e7/dAqh1rUP8EX7+/9oatZdoDLriSkG82qai4QBTSMgDCL3
         D98Q==
X-Forwarded-Encrypted: i=1; AKwUvBzKrvdwTqfDjnynWwB0fXxNrD9SlT/3CsmNh+SIEp+RTQkWcKwa8iWTi17EGCUrZAS6p3T3E7ivCOny@vger.kernel.org
X-Gm-Message-State: AFq9FYLz+8w/VqIcledg1ViMujI/yVeipcU1bG8PxTd25pO4G1YCNKhC
	cM+r9ol4jF9tXb0Rt+0ozu+J7Ei7ranwpShwgz1Ghfn5aE3EzfqnshXW
X-Gm-Gg: AYBFou1RSkkMEge3+JDNmmOgNsn7CpektzANCKt9fDV7tcO1YSckk6QdFo63pZAmOqM
	xKqmXZsgidN/pqeqw3Z4Go5lGA89aewhSMzrWyUEU0saEJj4DGmAiPkg6GZB5MmMFHY2FTdu29W
	w97T3sRbKt2SzKqmueciPDpfhYiWObP0wNuvp2AwRndVeFvMt3A+akSP0M6bnDG+cfF2io1iFki
	JFdv55JbZrCqjFuC3GFeM2J+UTsEN4iexWqgr/0M1Baev61Jx4z9FeZPeuZhMyLz/0F5BoM7BLD
	H1R5ygvJzdcqxuyQv+KJ3nnLaEksllQlZJjClgX3JW9pod3imVVp6YNMF+Do3kR9IOwQ3f+l8a3
	hbV2MDgVuhaorVE87F0WKwSaNp/li1EA4ytfi8sX/s3u8dXE+awOS3GlC5OYX1TSGCvrm7kc1sJ
	PUKc0nLBtUVw+t7Gfwye1G0E1qto+gbtNmhI6YEwOTtEcHzh/ue7g4tfFxvKMv4h/v/Ip0Th1tQ
	MUb3pmbcqAL
X-Received: by 2002:a2e:bcc4:0:b0:3a9:825c:7785 with SMTP id 38308e7fff4ca-3ab290eab89mr27892321fa.1.1792506971246;
        Tue, 20 Oct 2026 07:36:11 -0700 (PDT)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ab16d7ddd0sm33890831fa.4.2026.10.20.07.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:36:10 -0700 (PDT)
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
Subject: [PATCH 2/3] ksmbd: fix uninitialized xarrays in __session_create() error path
Date: Tue, 20 Oct 2026 17:35:52 +0300
Message-ID: <20261020143553.105014-2-dokunevdmitriy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261020143553.105014-1-dokunevdmitriy@gmail.com>
References: <20261020143553.105014-1-dokunevdmitriy@gmail.com>
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

In __session_create(), the tree_conns, ksmbd_chann_list and
rpc_handle_list xarrays are initialized with xa_init() after the
ksmbd_init_file_table() call. If ksmbd_init_file_table() fails, the
error path calls ksmbd_session_destroy(), which in turn calls
ksmbd_tree_conn_session_logoff().  That function runs
xa_destroy(&sess->tree_conns), which tries to take the xarray's
internal spinlock - uninitialized because xa_init() has not run yet:

  INFO: trying to register non-static key.
  ...
  _raw_spin_lock_irqsave+0x3a/0x60
  xa_destroy+0xbe/0x360
  ksmbd_tree_conn_session_logoff+0x174/0x1f0
  ksmbd_session_destroy+0xaf/0x390
  ksmbd_smb2_session_create+0x131/0x160
  smb2_sess_setup+0xde4/0x6fd0
  ...

Move the three xa_init() calls above ksmbd_init_file_table(), the same
way the rwsem initialization was moved, so that all xarrays are
valid on every error path.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 02b68b2065c9 ("cifsd: use xarray instead of linked list for tree connect list")
Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
---
 fs/smb/server/mgmt/user_session.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index fc28088772ac..386c8629e134 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -844,6 +844,9 @@ static struct ksmbd_session *__session_create(int protocol)
 
 	ida_init(&sess->tree_conn_ida);
 
+	xa_init(&sess->tree_conns);
+	xa_init(&sess->ksmbd_chann_list);
+	xa_init(&sess->rpc_handle_list);
 	init_rwsem(&sess->tree_conns_lock);
 	init_rwsem(&sess->rpc_lock);
 	init_rwsem(&sess->chann_lock);
@@ -854,9 +857,6 @@ static struct ksmbd_session *__session_create(int protocol)
 	sess->last_active = jiffies;
 	sess->state = SMB2_SESSION_IN_PROGRESS;
 	set_session_flag(sess, protocol);
-	xa_init(&sess->tree_conns);
-	xa_init(&sess->ksmbd_chann_list);
-	xa_init(&sess->rpc_handle_list);
 	sess->sequence_number = 1;
 	atomic_set(&sess->refcnt, 2);
 
-- 
2.53.0

