Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96526330328
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 11:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776596585; cv=none; b=ruIPLfs0g5rgExMLnW4U270efWO8G62gAz8GlFT0FrqCHYcdtDL27j5IlC53VnT/5q9x1TZHR1WY9y3Da1OcpbBj8qjKwEufUeZ/n9p1TzbecbYykixBGhEqnF9YI+G3ddooW100iOh6D3cKsu2rb/jnC/WOBjgwGGSQkenA4yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776596585; c=relaxed/simple;
	bh=3cxEUH0rl5qi1K4eVOi/flkQwufK+SdR0pp9z1HPhgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E944bA1vc/JLwV1En+afDCTPKx5cJa42wlEQfD7EpJqjgaTQqpWuv2+WDIX63kRD2joiuJexsfaSc5rB3LTvFRzj0/GZj3OSSQDdgSm9+ZmVgXh/SvKRJ1yTvcugI9TeXT7UVWBwCqvVd1vEZd2XegOKOaLxuS1qAW0+dIdyS54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l5NGDLQA; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l5NGDLQA"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3597822d6d8so404077a91.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 04:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776596584; x=1777201384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFPV09e5vgRJrLGBoxQYyojuTqO2sidsKfMnvaM2Sb4=;
        b=l5NGDLQAumdrevlt3zuKbyYE5PvxHQD7rS7KhtmNq2Fj9CZfz+wrdOuLfYG+yRDKJc
         VcSKRazKIrJ+LzxiYAOdCrSh71hd9ITkuhv8MT/drlqm1GUxcYqMIbCFXhb3W4HZiNII
         cSGF8ZORODHsFGOib28h9OrU4/UgyEs2Lg1mgVi0+i0W4FznXHMS1jh2/z2qrcqvG0/g
         UgoBAFLqRk2wQ7u42s6lEYvsJDOwusAAUNEyUos7fUZnaAw7GONRkFUkY4CgPYCnLXso
         rzCFfR3oLi1ZKHRq50reCZYxFyKTb7ZtXhpnMn2XQ+nIlsKTQHtQpLCmTH0P0+xsGWzF
         CTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776596584; x=1777201384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pFPV09e5vgRJrLGBoxQYyojuTqO2sidsKfMnvaM2Sb4=;
        b=o0FnQa1i4lcKtvvbx3r2r61OAfLNYeFwVcc5MXkMootkgUbiV6aPJHdcRLWPb6/ucI
         ezxbuEiWVAgEQmrj/5xnDroojjByR0go+5a5k73Ugcsv4iMlX8awkICuufPFqoMqPZhu
         XUd5OTO5Irk9Jh7V5nzfoyPAMdwg8AGMgHGf8j0Q1kUHxXbON4IozHfUAv55nOAMLFQJ
         K9MK//ol3iT9ajoJY3imsBrodN54ForRge/6tbDTfKqk9jFdpXjE6r0/wenHg/GIG/9/
         LSpLQ5w6t//50lfsO/dJ98hO4IpdBcNZrcfbRbY9K9wwuLSHvzQzPOAllKRxP3XTDvkj
         W0vw==
X-Forwarded-Encrypted: i=1; AFNElJ+M0CHG5Q90qkAYKLn3yU0SuVncZzB2eFsAAmwBFgYjoLXsFGxT40XyZcgw+tuJYs1p4Eyd/Yqxqcpz@vger.kernel.org
X-Gm-Message-State: AOJu0YwAxG+GaR0kzRME/1FvPyc9JPeCxFenC1eS4IYHCKiWOZg23d56
	O8D2O6Mb/gVn+x/+AzaMZCPh17DUw4KeowRYbGuEUtPNBGmBnQuWxuT3woCA06Jp
X-Gm-Gg: AeBDietngoEvRf2mBw9lLlpP8SYV4PMG7vDq1jDTxmfwvJ1/xeCePDUzVorHiYpLyR5
	keRMrnifd/RPhb5gF4H8k0zz9SPVGBocau8fKl8PcsSYL8hpfQfYaHRGOIoO/xmpmftsQjBUkjL
	WMetClf3SAVd9ELWt28spGcBKJuNqp8MPoeRLy66z5b6qWVt20RexTEveGGQl39H03eI8Spng8t
	LWZS+dVUgi4BSq9oW61d4LRCHbK9tszLOQ7eArXV3AnDyR8l3VkS6mGp8QAnYYeIimUwl1FXa3P
	NhskV/i/Gf7ITiwmHMK3zls/og3T2knMv6I+k0J6XGTJ+C0vz7x0y89c7zIvdLSUBQEZm49CVKA
	8GCpIeyX4aXGVeQAR4hGjrdGZBFRBJbW6GBaDBUtv2+mEucthYiCnNL+vaifrmzhGIks0RHLcpn
	nrVGVQR2TnEqOOehYKWf4jLL2dIO8=
X-Received: by 2002:a17:90a:d604:b0:35b:94db:fdaf with SMTP id 98e67ed59e1d1-3614044f697mr5319706a91.4.1776596583718;
        Sun, 19 Apr 2026 04:03:03 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797703059fsm5527972a12.24.2026.04.19.04.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 04:03:03 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 1/2] ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()
Date: Sun, 19 Apr 2026 20:02:54 +0900
Message-ID: <20260419110255.2477785-2-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260419110255.2477785-1-charsyam@gmail.com>
References: <20260419110255.2477785-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When per-session tree_conn_ida was converted from a dynamically
allocated ksmbd_ida to an embedded struct ida, ksmbd_ida_free() was
removed from ksmbd_session_destroy() but no matching ida_destroy()
was added.  The session is therefore freed with the IDA's backing
xarray still intact.

The kernel IDA API expects ida_init() and ida_destroy() to be paired
over an object's lifetime, so add the missing cleanup before the
enclosing session is freed.

Also move ida_init() to right after the session is allocated so that
it is always paired with the destroy call even on the early error
paths of __session_create() (ksmbd_init_file_table() or
__init_smb2_session() failures), both of which jump to the error
label and invoke ksmbd_session_destroy() on a partially initialised
session.

No leak has been observed in testing; this is a pairing fix to match
the IDA lifetime rules, not a response to a reproduced regression.

Fixes: d40012a83f87 ("cifsd: declare ida statically")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/mgmt/user_session.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index a86589408835..0dd9e6c976ac 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -391,6 +391,7 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	free_channel_list(sess);
 	kfree(sess->Preauth_HashValue);
 	ksmbd_release_id(&session_ida, sess->id);
+	ida_destroy(&sess->tree_conn_ida);
 	kfree(sess);
 }
 
@@ -665,6 +666,8 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (!sess)
 		return NULL;
 
+	ida_init(&sess->tree_conn_ida);
+
 	if (ksmbd_init_file_table(&sess->file_table))
 		goto error;
 
@@ -684,8 +687,6 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (ret)
 		goto error;
 
-	ida_init(&sess->tree_conn_ida);
-
 	down_write(&sessions_table_lock);
 	hash_add(sessions_table, &sess->hlist, sess->id);
 	up_write(&sessions_table_lock);
-- 
2.43.0

