Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53519373C04
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 21:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776374265; cv=none; b=eTxg5KiCSZdDUtNLgQQ3qmqMs9yq6o9j1zalwGaA0AAgNMm4M/xJxg0Rq8Ei/1qcEdxSepTAWBbKcNjtlSWJdDQwj8hAHm105QVgWfMFtyME56hGbDgvf1W0VIJmzDy2nouwEG7/wuf5uFIVIjcFPYEuUJM+0nVCePmGqsgqtZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776374265; c=relaxed/simple;
	bh=ygvlKmBj9cpYvhipO2GVwDfNG6msc7IzLgEFKCeFaeI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PfiQTW1pvOn2V2bt7jMlMO0+MLnYxwzZEE/7EHgva5tz0OEO1YNuq7u9dNTT0nISrRyuCHbQUEpRrRz/9dVnop0Y8ixdeVe7vWvCeAN0ntgKuSPHdLfYUAUoH8VAvcH8dygTjs47VgPdGRbo/cMotFb1DIkOzCiTJzoR4oFBuZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q70FK54Y; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q70FK54Y"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8296e257735so4622b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 14:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776374264; x=1776979064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ird1RbhcLmo1n1pSfDlmYxFmBRF3j4BNyuXGOX68NCU=;
        b=q70FK54YViXIXpJuaikoZYxg2xKb2W0PEU3gTf7E9f4UcF2I+nBTCHkJVIwmznLZvz
         k9qKpgYN2rfZMb/eowl0luvVUNeFc3c2wv/YGpFx/IGPEH93MTo/gRgklJUZ4RWuiMEG
         OT4I1BufWDpQEX/kT7CA9+i3sjHtoHtI61YOFgtdWuDkgni4JM+pOhY3ntAqCop2uoSA
         Hp9FIie8sVxBWE6ACoXxeBIL5H/5CTypV4ULIfKdTWtbooKcRxidYxZuGE0B0O6+mcpG
         I2ze6Pa4Ckpvx+b8FY9il9Z+Cd6xOdmLAd1oPguVwwaXJD0+PJM3kdV36ShlPxDkY7Jv
         mHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776374264; x=1776979064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ird1RbhcLmo1n1pSfDlmYxFmBRF3j4BNyuXGOX68NCU=;
        b=SxGRSViOLIHQIT1tM85kl7HARVyTcgbz+L8tOlgO+qr7uwK7gLMxp8GwYhQZN2Dsct
         QuZWwJyWYmyy5HqQ94giDUGrXy1FdFgIwEJZiHCCia9W+ffXRa8Q8//2icbXZllthlap
         kIvlR/b2gHfFvYzl8O7bveFKAsMZagHAZ0x6Ze3wyEksPJ4AGhJthVpSZQKHj9TUAJF6
         Eijh/MvBTzW5yk3vLQzGfCpl4F0aQfnM4JER8s6Nw4qF4guhg9TbqdmVzXm3x43D/LIh
         XP9aCwnz+8mS+K9ZHiqH4BLme2+ItJMjc76wDIg1f6LnTjkgSPkQUFPI0vz2rn1Xl6zM
         UBoA==
X-Forwarded-Encrypted: i=1; AFNElJ9BqUSD65Q7lawF6IwH8B/zrTnOK9E9MGzv3UJg8LhL7Y7+3apYV1ks6Dr4loSIV67XXWuf0/isONJH@vger.kernel.org
X-Gm-Message-State: AOJu0Yzcef0byuVQW3JbrMPdYzwpvl2KDLKMEdoTTBkd1cHX6+V0ABFC
	G5HKvldYtSyK342Vmjj2Y8Swws2qUONpLMt21QQER1e31iUqHkzCIhui
X-Gm-Gg: AeBDievMXs616/Jf5yRIEzoJNULh0YO1WlEt+bRaRg32J091og2frTAT+UvTcl9gAA5
	7KxcZDVTTydt/RfhM8WGVDpWqueEb5rZQ4Zkq+VjY+kbZcvg27+lMsmGqa5huJSSq/E5RGYx6AN
	ZBm9sDJ2nDoc+D5TuVrKQGJf4Gvcu9U4CZF/Cb4eSG+uyTQbEmcbKfRYQsfiMv0lC31n+kRuo/f
	x/5Y1KenQwKA9vWVVSaCFPXQswuXoNl6up2CSt9F+QqTs2v0D87WctTVTZr4zI2ruI48jXip54I
	LbCp+VvUsVoW57G4bMcqna2oTwzCZFv2OLbt1WvG7cA9hkssb+MCdUC7pljBL1i6LYC9ULW54yy
	OzFo3dFh7+hspy2fN32rBfEsQHoHbSnFddO9E4jMFs5+ANAC2JjanrPTcEXIAo5+5P1NVAQnJGD
	otxyAz2Zafatmnvn4xBrkXbN2eD9o=
X-Received: by 2002:a05:6a00:1994:b0:82c:24a9:d5e5 with SMTP id d2e1a72fcca58-82f88563412mr472762b3a.2.1776374263639;
        Thu, 16 Apr 2026 14:17:43 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f674140d3sm6134414b3a.44.2026.04.16.14.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 14:17:43 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH] smb: server: fix max_connections off-by-one in tcp accept path
Date: Fri, 17 Apr 2026 06:17:35 +0900
Message-ID: <20260416211735.3558718-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The global max_connections check in ksmbd's TCP accept path counts
the newly accepted connection with atomic_inc_return(), but then
rejects the connection when the result is greater than or equal to
server_conf.max_connections.

That makes the effective limit one smaller than configured. For
example:

- max_connections=1 rejects the first connection
- max_connections=2 allows only one connection

The per-IP limit in the same function uses <= correctly because it
counts only pre-existing connections. The global limit instead checks
the post-increment total, so it should reject only when that total
exceeds the configured maximum.

Fix this by changing the comparison from >= to >, so exactly
max_connections simultaneous connections are allowed and the next one
is rejected. This matches the documented meaning of max_connections
in fs/smb/server/ksmbd_netlink.h as the "Number of maximum simultaneous
connections".

Fixes: 0d0d4680db22 ("ksmbd: add max connections parameter")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/transport_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 7e29b06820e2..5e85341698c7 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -279,7 +279,7 @@ static int ksmbd_kthread_fn(void *p)
 
 skip_max_ip_conns_limit:
 		if (server_conf.max_connections &&
-		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
+		    atomic_inc_return(&active_num_conn) > server_conf.max_connections) {
 			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",
 					    atomic_read(&active_num_conn));
 			atomic_dec(&active_num_conn);
-- 
2.43.0
