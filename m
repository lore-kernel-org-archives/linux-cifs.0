Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76DA35675B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246049; cv=none; b=Q0veEbt/cAOA6AxkNq/thD7HMhcfHb+CZPP16uEQ1LXPENt0QkS7oQKZXxJAMQLUT6vRe6xnPVLnI+Tg7LGZpX4Gv+nIV1JHcasysrREMNhrGZmoRmEu/zljW8pGlPZ7+RTgNXGY8E7+9L+ZuvUT2+VO8ET7pGk0aCmGNWJ/vgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246049; c=relaxed/simple;
	bh=VWNc5+14VU2D9Vj9MfCSNT0yZ7DYY7vyXhrfFzO24gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udUFmJp8YkqiEqubyB6g+Ku+8e03ZB3pWX/ZZNp0ULspOC37tgeYvMv9ofnUNOp6JjMI4WYeuy2bn1KfwG/F+c2b5iNgGTSoy4N2hGZo691Ht3qLG8e86xJlEMuTBSOoPZguO5XBX4un1HVbzJYPnCQz7ycQdUmJqK6LovvMBg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PXpk5eUk; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXpk5eUk"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-69eb8b6bea8so147230eaf.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246047; x=1782850847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/9abLoew62BkxuMqQlA0p92Vmdpphdh3EvvyOkD1qg=;
        b=PXpk5eUkALSQaTQjhWXhxJx0F6eFx/RaPtuEBuC2Q05iVgNO2koItMPekQ0jePNdsH
         Ndal+IZ9jszZ67eZwgfdGhiFPYdWrNpAFNyzvnwI3G+XyWI5pL1gBdFIwuM9QivbJW6g
         t/imsGAXfOKYhbpn0qI/SckCXsbiR3r/lBKX2/W23bSn0idQKsL19y405v6lD3zyV5c2
         JMQCqJoX5onmpiLKvQeqvjjuebMQQ1/FrpdMoVHBAXhDsprxQ1DGPerjoU2FbUBkBDF/
         OF9JCAE0A+Wt3LZnGH1odtQrdLTnXJLs8aakC+uGm41N6dBwVznRjDX3jC4jY6VDkrrw
         iUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246047; x=1782850847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g/9abLoew62BkxuMqQlA0p92Vmdpphdh3EvvyOkD1qg=;
        b=AaHXBfwUFP0eARtw87fgOraFQn2+cvu+ptz9k4fq1/z4TDgSjeo21IhnyAKDmD+K0x
         aCjZs+qNqC3Fc7sBgoq1E7nYvScoptvRZCn7SeW9HZn3qo7FOpX64uRn09TBHMdAdNsW
         srUrZN1kVQ4d9DVMuK9mutmdJ250NAZJzH5EuvV0DwBerbY4XmfVDA3JVS3WA8ictcT8
         CEESltMpR1okY5SJCREdb6XL0lY+Z8IcjScqN1mXLvDBd2no7DSTNxUYqw/r48f7Ng77
         F2kwzXw/247HyTM4GTNWegjLvXeSmeRXWrcH6SnpZQ4mKkxLSKb+3roC1KtzbMo/tbnC
         PsTg==
X-Gm-Message-State: AOJu0Yx6qudXj7KPfaWAT5zjx/z8oJUrYm7wKKizVXBN4ogOH6Qk9/p8
	vIkkZyW/0pdxkWVPrRWaPusggWhlGR0UUrQl59r044SpKxKCiAdqFx10hoEQJPQR
X-Gm-Gg: AfdE7ckfHYb3Fd7tsQrqS9NOJdauTsHKC+G1jaufWWSBJTVaE7BtMGDoDIKSvwStppQ
	foizpt9Zb1r8D4Y7h/BCU08GxxVE5b4YlOK3wUMsA/clsylzOlRygDStof58L+0FYEeGvje9lVk
	ad9IGc36eDAfAP4/Zp3p7Ao0oB/2zXrRItgZy8IsLs1eGRyDXASAvz+arXbmBok7XzjQd9iD65d
	Lv8gme5HsxUfGr7ZP7ZSm5uCgFrDDWLEHtfGcDx1dLGniZkDekH/Ph0CHxXg5c3tmialgRBRJQN
	hBhtZdkhruEKHuSptPr0gIG0pcd2rqqkaAOHhxrZZRIY1cKu+/3tJpNGtkAphew65nySeiZIXiV
	NXCX2F6vQWn0QYyJidR4Pztg5oMaQvunOlP8nZmzeIj/CPbwRCXSRp+w3P5WzqCrTPRdJej1rBM
	6sBJ4GZfKVZXkVhisSQk25AlB7YZiOkgr249vjrQ1nezCLzZZDfvYwBk8j/DaMTdz+s9CZwcd55
	m9UKh9zbFT9GiMNi8M+QdN/Vm8rcvJyFOQraQQ3NGpWPUaBkOUyOsIIY8VfUI4YmE3DFMcvxvYc
	6icsN5lCDUJGDCs8lmmc1aLzuBI=
X-Received: by 2002:a05:6820:1c94:b0:6a0:dd5b:b3a6 with SMTP id 006d021491bc7-6a1230614a8mr187542eaf.39.1782246046887;
        Tue, 23 Jun 2026 13:20:46 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:46 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 14/16] cifs: discard functions to ensure that mid callbacks get called
Date: Tue, 23 Jun 2026 15:13:41 -0500
Message-ID: <20260623201344.2043841-14-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623201344.2043841-1-stfrench@microsoft.com>
References: <20260623201344.2043841-1-stfrench@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

If discard functions for readv and query_dir return error, the
callback functions can be skipped. This can end up with hung
syscalls due to the completion functions not getting called.

This change ensures that both these discard functions call
the callback function when discard from socket returned error.
This ensures that at least after the mid for the response is found,
the callback doesn't get skipped, and we do not leave syscalls
waiting.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 99cb189dd567..b30e2388a1c5 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1143,6 +1143,11 @@ __cifs_discard_and_dequeue(struct TCP_Server_Info *server, struct mid_q_entry *m
 	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
+
+	/* Once the mid is dequeued, the callback must run to terminate the subreq */
+	if (length < 0)
+		mid_execute_callback(server, mid);
+
 	return length;
 }
 
-- 
2.53.0

