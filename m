Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B03311C3D
	for <linux-cifs@vger.kernel.org>; Fri, 20 Feb 2026 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771616130; cv=none; b=b+qqtACmXAZfsNtYCrg/NP5cfrXwA/Oy9Xdwgp9SG0adjKW05rJ288t5tpaHIAQQ04or4VzOLVTrX8KPEGXG8PSSfYKIQMtMV7E1A7tuARySEnUG6U46+a2l5mYP+rFjfi6fuXyHEBTEevsT+cNllF5oOLJ5Rgttsu4EH44Zdi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771616130; c=relaxed/simple;
	bh=LYZloxUJSzRdHctVm4Y6mMvZoA7OLACBbBSl/9SMfqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gMJMatoStWj8Kc9FTw0jkbawuEtNELuLBkWqlJ0zTGzH9On350wkpVLFMQ/obureOzyPMk/fi+IcFnnxmamsEN+qU1MZhkYJWhkK4hdEZjb6d+/dw2Fd4W9zZdEBkk8qiByrKkqqIr8eGBfXCyYO4QQhNSE+/gaoQYAM0hnN+LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PI2+27SB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PI2+27SB"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48069a48629so24154565e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 Feb 2026 11:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771616128; x=1772220928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AwRHp70gE2bWaz2xP2c3oHH9CidSSykG+nY7Zt3zE1Q=;
        b=PI2+27SBF2NwUELq3geAXrZM1DPPibP29GSKuoGpEo75zXRYLkhKWukheHNsNZFV7A
         KGa3vUL5PFRDLWOB0tJ1EVEUlXy5lio1q2sUCVght3Ma/CWJGszzaO08Oe32wcqbSiLb
         i39OGBvrEDcZIp+ozQ5cgR5zw8DjrnTQQMkq2s8GMpjBr0K/GjFv1OzAjoNqxHZ/0uiC
         wCP1o3l0X3KllSQ6R/t12lzLKVi0kB/8r1FvUumIXvKprXUHn4pxVm+xPpE+UsHt5AS5
         NP+qt8EFbSW5/pN0pwlRjknCABjwedgnuAQCQwVbwNYWs7bvWYUmCfh5+R4mqfScijFs
         BdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771616128; x=1772220928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AwRHp70gE2bWaz2xP2c3oHH9CidSSykG+nY7Zt3zE1Q=;
        b=Rvu3tLiqyb1UJDvLnZfACIeH2sh+elDOk/ALMW07QFWXpPEJLOdERMRwsNla8TWV5q
         GCMG9WdHLY/iPWnbiNXoCNnc1vstYoMJdAW8qCwiHk8P+/xYxr+ZIr5uaggBR+dNEJ0Q
         t/PYebfo80fNsyX5vAVwFmRsoAv9cKrIkGDmG23GxxqnRymJJt0sDHWGWiB2U9eka3TE
         ldi+rJDKQ8olJSfxuzCEtrFWZuCA+GhgTQ2LrxBb8LwHVBIOSGKvzNB33wYDmBmje4fq
         GKFEDfVgmvbIlvNy9LWcrX4Gc6vxvpzpuFDzFT5NQW4hMURR/uwN2mpYqDzi+/YMlJ8E
         HUNA==
X-Forwarded-Encrypted: i=1; AJvYcCXTBtNQx23XpjrfwGtsllAHkXJ1nGPOrkWDY/2+xFD9WO0dnWpCxxLJkf5b93mOUUSdAfdBQvRXc2TZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5/6Dmgx4x0FkjmqGnWYp8PHHCfJraIEvsRR9tEa6aRwFD9D81
	C09k53bE8blAYvlDmQwop5iXGdXylYzXZ6hmnzuG+K24ndK8vQ0mub1JWBiVWKgiD3g=
X-Gm-Gg: AZuq6aLmh7lXO+eeV4ahGCsfxDce4QwNkXT2eJm4rVB45ui629jzYYT4n+Vqp6vBqeY
	XW9gcyoSTA3zXRHf4d3gRwGCkqD6U//K6Ar0bnbUD14v5unTZDOVHVqP1iF+o2FAuDAHmPVhCBh
	apuci0JB3Yb9LTerFt5DLY9XtVU8lqYfKSz4GKsfBGV/opdFyruWwTxPfrtXF5uRbgPxhlg/FeU
	9G6JloPwMCKN9vsJcg7H7EcTNNxPilmJKJJ4lvu/oGmvpZpp/If3tKz94D6n69UXYlDvY39qEWo
	etKpSfPXy6bvwIuPDEUNSwHuA9IxjGV6pLFpj4dQCHU71WUYGc+HK7OOQEpKLoDOaSExLIok+CZ
	YTqtCg35JG+sBH8zP5SrNitmN2a4lQkFOG1YJuwYLo6GdsAV5NYQQsqwgiqk4L6WFKsbrL5zKtb
	lx2vS7PkM/rhF+RC6ylbBgTcRP47D7SQE8CZpIwdeG
X-Received: by 2002:a05:600c:8b02:b0:47d:5e02:14e5 with SMTP id 5b1f17b1804b1-483a95a86eamr11854985e9.5.1771616127398;
        Fri, 20 Feb 2026 11:35:27 -0800 (PST)
Received: from precision ([179.82.226.246])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-5feb6204a47sm245149137.2.2026.02.20.11.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 11:35:26 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Meetakshi Setiya <msetiya@microsoft.com>,
	stable@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2] smb: client: fix cifs_pick_channel when channels are equally loaded
Date: Fri, 20 Feb 2026 16:35:05 -0300
Message-ID: <20260220193505.553838-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_pick_channel uses (start % chan_count) when channels are equally
loaded, but that can return a channel that failed the eligibility
checks.

Drop the fallback and return the scan-selected channel instead. If none
is eligible, keep the existing behavior of using the primary channel.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Acked-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
---
v1 -> v2:
- Remove unneeded max_in_flight and associated code

 fs/smb/client/transport.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 75697f6d2566..05f8099047e1 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -807,16 +807,21 @@ cifs_cancelled_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 }
 
 /*
- * Return a channel (master if none) of @ses that can be used to send
- * regular requests.
+ * cifs_pick_channel - pick an eligible channel for network operations
  *
- * If we are currently binding a new channel (negprot/sess.setup),
- * return the new incomplete hannel.
+ * @ses: session reference
+ *
+ * Select an eligible channel (not terminating and not marked as needing
+ * reconnect), preferring the least loaded one. If no eligible channel is
+ * found, fall back to the primary channel (index 0).
+ *
+ * Return: TCP_Server_Info pointer for the chosen channel, or NULL if @ses is
+ * NULL.
  */
 struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 {
 	uint index = 0;
-	unsigned int min_in_flight = UINT_MAX, max_in_flight = 0;
+	unsigned int min_in_flight = UINT_MAX;
 	struct TCP_Server_Info *server = NULL;
 	int i, start, cur;
 
@@ -846,14 +851,8 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 			min_in_flight = server->in_flight;
 			index = cur;
 		}
-		if (server->in_flight > max_in_flight)
-			max_in_flight = server->in_flight;
 	}
 
-	/* if all channels are equally loaded, fall back to round-robin */
-	if (min_in_flight == max_in_flight)
-		index = (uint)start % ses->chan_count;
-
 	server = ses->chans[index].server;
 	spin_unlock(&ses->chan_lock);
 
-- 
2.52.0

