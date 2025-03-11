Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D5D5258
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 01:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741656902; cv=none; b=a93gDVzNeUGSXx0tQ9RAP61Lgmq75x3H1TVVu9LKjqnCf6Ej0glOpapvvA9rlQpTnuaMspOh88BYqpI0YDOZYMhNwTY+lF7ppSoGpanme+/9hXNAx8AHzc/KDUg3UHI0e23YSAok/cG39PJakbNlmrSWMd+thgREDzLJiJCYJL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741656902; c=relaxed/simple;
	bh=9NG6sSlG9zcIySDzvqJtBDm6franDwaQMVRcEZ6Toik=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rbWatfQJ7CBOMuHaYs5PQwgZwmeknGIgzIdhpCDrbIfYaWajNPN2BjVzNRCNS+iH/vhlDFC+Vsb3dz5YubwuzVq2hCr7bS8iFLjazE+ruOsuI3/O46yLKlcNXr90nXSsu/4d3v2OFuqp9lIVXKkGyAtJBaFtwuei0vBb7PPqKi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VVDb4zay; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VVDb4zay"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3912c09be7dso2637198f8f.1
        for <linux-cifs@vger.kernel.org>; Mon, 10 Mar 2025 18:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741656899; x=1742261699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=81PDtWfELchO2ZlbhdltFaMKDiqBscW242cuI/pVepg=;
        b=VVDb4zay3i8pAufhwvDGJGChK93qL+Y/rPebdV6is/jIQmbvngbA53OnQHZ6SWKAkf
         1LIqJkl2moLiZL0PxkPSse2Z3Mmk1FiNJonyMnhYrB5eoBXS3y6TlsarJWXS4O12/J4S
         k7KAF/8g/y2sp2rivRNPcx2/QY/mnVest4cSlFTsxmGt2x9Ik4gRSSsqnVutVWMHCYOu
         aqakoR1JbBrzCxT3oOjPkPypZZ86abcGLHCiK4iChnT8p7xYq6PRHiwtByjVVIcxJN4E
         7yVvsy4PM6UzZtiS51i6hGXLxv1UhJjEFz6N3lQfl/DBIh8OrPXeerN/2CTztOJ1FgTQ
         nqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741656899; x=1742261699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=81PDtWfELchO2ZlbhdltFaMKDiqBscW242cuI/pVepg=;
        b=sCahZmeLEBzvZ6ySd1dUIppitTASWpariflBrJZ10HEfdYfMVm7qmADTLynCxHZpVp
         AUTTf3JU+IZeMGSGNa4CmUTuyfLIHKLFAfJWzMrpYfgpZehfbmSiK3ZsLxFbdhBTgeiT
         tJxMOHQORJTDb0cs+EMn0V0ZXeGXrJt6+6vgU57jXa8cJRok6JZbfQi4HL0g4NIioVS2
         b1sYItwzlN7MtelANmpqEidZx67mbmvEUPqI1l52TDmaYwe7fgaQGjHLZArnCGbHEQ77
         CVDHyOCD5KMyKit7SeX6wSLWVCUYqYiU88ghWAdAVZg6FXpWpNOiyf9rnK0nSmMsc+kI
         4h5w==
X-Gm-Message-State: AOJu0YyshBro45rOdYqAXmfYW6oPHO3zKJjHbAuB/NNvU0ePN2PeYggi
	XKyOqH/XaGW8o8y6vpT/YrEPYSZ3S/7fpNtyWmDlXhcRz32qbRZWFGMdBldRndA=
X-Gm-Gg: ASbGncu9U0Z1nxuVJNYYw/pP5UgP8tK3gaBahMws0Sjy9AnfL2RoKgcnbvRBUY8YxUc
	ydnGSO3jR2acSi7pixn6uDA25Wsv111sv8wuNmlsinuJFZdPgkB0s8KP/ukv6x2PvrjYfhHW74o
	H+GZ2D8Ct6HhmglKfrsnJpHwZ5m9hj1pjx4RdEOLw2jf1O+z+i6RyyQXr3e8ZQXTXUjMIAwt188
	d8St1O5SzQhCC3cV7x/lCu8kbFGCFzlKtQwwOVy4nRTUSz+ODRg8ZNfubVyuAkSQSW/gZuwiRVX
	EjNC9OBmxc+PB7QbpbF6Xik95FMw/ZvBvcYcHyFQVKVpPqzq2C0ZXVLPnFLhgAZQKC6b2Q==
X-Google-Smtp-Source: AGHT+IHYjsmNoYDJGLJCEd/S5GP4fyTCc51q5d7pqtrO5X5q2SSkbh112cI4jD13n2/wBSXzBibveg==
X-Received: by 2002:a05:6000:1f8f:b0:391:304f:34e7 with SMTP id ffacd0b85a97d-39132d985f6mr13202184f8f.44.1741656899017;
        Mon, 10 Mar 2025 18:34:59 -0700 (PDT)
Received: from localhost.localdomain ([2804:7f0:bc02:64aa:5728:8c10:f0b3:bda8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736c78389d7sm4530673b3a.4.2025.03.10.18.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 18:34:58 -0700 (PDT)
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
Subject: [PATCH] smb: client: Fix match_session bug causing duplicate session creation
Date: Mon, 10 Mar 2025 22:32:31 -0300
Message-ID: <20250311013231.2684868-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a bug in match_session() that can result in duplicate sessions being
created even when the session data is identical.

match_session() compares ctx->sectype against ses->sectype only. This is
flawed because ses->sectype could be Unspecified while ctx->sectype
could be the same selected security type for the compared session. This
causes the function to mismatch the potential same session, resulting in
two of the same sessions.

Reproduction steps:

mount.cifs //server/share /mnt/a -o credentials=creds
mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
cat /proc/fs/cifs/DebugData | grep SessionId | wc -l  # output is 1

mount.cifs //server/share /mnt/b -o credentials=creds,sec=ntlmssp
mount.cifs //server/share /mnt/a -o credentials=creds
cat /proc/fs/cifs/DebugData | grep SessionId | wc -l  # output is 2

Fixes: 3f618223dc0bd ("move sectype to the cifs_ses instead of
TCP_Server_Info")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/connect.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f917de020dd5..0c8c523d52be 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1825,8 +1825,11 @@ static int match_session(struct cifs_ses *ses,
 			 struct smb3_fs_context *ctx,
 			 bool match_super)
 {
+	struct TCP_Server_Info *server = ses->server;
+	enum securityEnum selected_sectype = server->ops->select_sectype(ses->server, ctx->sectype);
+
 	if (ctx->sectype != Unspecified &&
-	    ctx->sectype != ses->sectype)
+	    ctx->sectype != selected_sectype)
 		return 0;
 
 	if (!match_super && ctx->dfs_root_ses != ses->dfs_root_ses)
-- 
2.47.0

