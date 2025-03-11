Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557B8225760
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741717528; cv=none; b=sUU4wMdGy62jTY09wjC8NWNNWY0iuxtBq55jTLyOWoK1718cIrUtVnyyTMncWoUqhgEtu7nnSB8VsKBhYWcz9Z7NSuEWeVgJqZUD0SXoyXLwUwH+tw23qGrvzLS4W2fnBwzMOXMovwKo33ifuV7jKSkfHcR96FsihPXV4McjqRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741717528; c=relaxed/simple;
	bh=uaJP4cNx4CGfMfLBJIR1VhR2UcVBR9ZdRpQs2y5ZVx0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u79LWJ7FJsVEHwlv9OFv+meD5s+Co5iKO8f9IsueRVT/+MrzvGB5ibjwZX5w3wHQ58/Vyj549mGsHjZ/vPWZzrIIYAU/zTbFKAFFovE9HU8G6wQS+Z3eQ5MPdZa/J4UzlGOKUCoYqVlA/bH95a/TBTH1olOgH/XSYYev/bt1WW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eA7sw2+B; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eA7sw2+B"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-390e3b3d3f4so2887611f8f.2
        for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 11:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741717524; x=1742322324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NCulxlrR+WJW9UPHN39R6mamn7cCdloMmRI3f962vaU=;
        b=eA7sw2+B+ZIQGDzAmYQL9sjU75Up7gn6qEGPja0Gz6YuuW0YSakrDO1ewEQ7Sw+B63
         oT0/k5oXe904fSONf+3SWHKJe7UAfOsjx2WG0AIRYVCgB4ehrB9h8KK/cq6b17m/30v0
         e8WU82yCwr5ZwZrSQPjM2S2JdxRBolZzCowEsW4pIprv/2CcUkbU++wr9+O7yN3Nvof5
         ERANltD35BA3e9e+GGVZ3zTPV1EnOAXK0BIQmLx/QurovVoHCS9kv7tZ0lll5/yZApmy
         XsYFiQN5gICOSRyAZ8iBdmg4yVV7AaZdyEX0yeyXmzyzlQXqYl/JXE7AKxB5veZuP7VR
         LjqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741717524; x=1742322324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NCulxlrR+WJW9UPHN39R6mamn7cCdloMmRI3f962vaU=;
        b=uaws+ynu3OXsuLZq/MEEzkYWXuNCQgEfJPaep30d//RyEKhvL/086EZi77lQxuBIE9
         ZYD+VyaNrFJ4f22myfkBIu/qKl4CYkbA6Bxq6m0oChzmGPazfMZu4S3iS8xi4ngKwqH9
         Kzm4J9A++ARzY0katQgGEk0jT9tDQQW8t+VaW1xeZrJgtGVwCzFjO5XCJxndsZkd1QUj
         TFF5Gt/9QJn5aup7Sz9urv2/ALSM4ZXfM0m5vvLWjm10JXIvOunEW0V1kQe60ZMbCMQ/
         wEVe6Trky54zmf15j+LbkmjcA67E0xx/JsPNQYu7L6HGn5z4OMGS7tj6x3hvs+yeVBxI
         0PiQ==
X-Gm-Message-State: AOJu0YyGJQzxkPC5PW5KRQL9p/oWrtyUQIpJN0Vg9KKtKYXLo9HTiV+8
	JhMe58Yg+bMzxJw+MZov256jDcMfAy8Rf/frkB83sYoHnoQssYDGKhEzac7OTAE=
X-Gm-Gg: ASbGncvQYfzauzxhsWVI7l27JuNlIQuljrP70aB9Lk5dGXQl7HALpaPc2lNS+naBiqE
	xiNbbZfNrLgTAzWp1uGdaEBWXAO2+0/eoHJuDSGP8/643I0FVplNeukKjTZuoX4CCZKnIPdWAKn
	R1PYKFuw9Ebi0BHZBm6vFOvw+t/NZ/OoChlr7uw4TGQ/ATeJijB1CW7DgMnu1zTosiaYW2566Ci
	SSiKKLVs9Wa9juDrFP6ugYbzT9L38AjfThKBnQfFjATIHe5oDTgT2riw/yQezwUGDZBd0I5ijEV
	qgnF9Hmyp2sHyJvLdj+yYW0/yq/A6lbyveSszk/B0XI71BqKkhJ7xYHikJMjgDapK2Da/w==
X-Google-Smtp-Source: AGHT+IGZalWJRMlR04wv98HrZ6NJJcqx/B5d/vY2zjvzvEJw8JFokKeTdPRvNGbvgZrbkIiLd31zGw==
X-Received: by 2002:a5d:588f:0:b0:391:1806:e23d with SMTP id ffacd0b85a97d-39132d7a3b6mr12905739f8f.6.1741717524519;
        Tue, 11 Mar 2025 11:25:24 -0700 (PDT)
Received: from localhost.localdomain ([2804:7f0:bc02:64aa:5728:8c10:f0b3:bda8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ab812cb0sm9052361b3a.164.2025.03.11.11.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 11:25:24 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: ematsumiya@suse.de,
	sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2] smb: client: Fix match_session bug preventing session reuse
Date: Tue, 11 Mar 2025 15:23:59 -0300
Message-ID: <20250311182359.3012730-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a bug in match_session() that can causes the session to not be
reused in some cases.

Reproduction steps:

mount.cifs //server/share /mnt/a -o credentials=creds
mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
cat /proc/fs/cifs/DebugData | grep SessionId | wc -l

mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
mount.cifs //server/share /mnt/a -o credentials=creds
cat /proc/fs/cifs/DebugData | grep SessionId | wc -l

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V1 -> V2: fix git message, fix krb5 case pointed by Enzo, add IAKerb to
switch

 fs/smb/client/connect.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f917de020dd5..73f93a35eedd 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1825,9 +1825,8 @@ static int match_session(struct cifs_ses *ses,
 			 struct smb3_fs_context *ctx,
 			 bool match_super)
 {
-	if (ctx->sectype != Unspecified &&
-	    ctx->sectype != ses->sectype)
-		return 0;
+	struct TCP_Server_Info *server = ses->server;
+	enum securityEnum ctx_sec, ses_sec;
 
 	if (!match_super && ctx->dfs_root_ses != ses->dfs_root_ses)
 		return 0;
@@ -1839,11 +1838,20 @@ static int match_session(struct cifs_ses *ses,
 	if (ses->chan_max < ctx->max_channels)
 		return 0;
 
-	switch (ses->sectype) {
+	ctx_sec = server->ops->select_sectype(server, ctx->sectype);
+	ses_sec = server->ops->select_sectype(server, ses->sectype);
+
+	if (ctx_sec != ses_sec)
+		return 0;
+
+	switch (ctx_sec) {
+	case IAKerb:
 	case Kerberos:
 		if (!uid_eq(ctx->cred_uid, ses->cred_uid))
 			return 0;
 		break;
+	case NTLMv2:
+	case RawNTLMSSP:
 	default:
 		/* NULL username means anonymous session */
 		if (ses->user_name == NULL) {
-- 
2.47.0

