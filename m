Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D131281530
	for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 10:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789815486; cv=none; b=p03cpXZ7lTLNJImryzIuPelp7O8wWBNbCvwYl7ERrZ/YtsvFcf6IYoyf8hZORV4NWoS0MQIZumef0tsvuUMTML/GUg0s2jY1GK+ObVcgFJyF0XBXCzjIjF22/RM/fGPdAsOY6MtXyF5bHEg6g/XQ6ZsMUiy+B8kq/FU8hm0yLNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789815486; c=relaxed/simple;
	bh=ZDmz1ciF8gjUH2neEdwENHdnfpeP6eI6ELZpEKaijzM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A2gHnNsPdDPmjIvCLRIkCpW1xa7/NrkxAtf2ZIGwDnTLwHC8N9DQmGUeOGLHgFraVAlTYoNV6yEIHFhgSYpI8eC9+dLV/aunDpUBYKP7N49GHCkobBDtfBcc4t5k3F9OH0ZsL4YRPDiZ/4rmiWyVXMXzRM6TkRCxKlZxFwHl9V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LPJtyBR6; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPJtyBR6"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccd5cf03so1626536a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 03:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789815484; x=1790420284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T7/TbC35mvVX9Tsj/V9b/0eBQFX1WnM70lzVe7sM0Pc=;
        b=LPJtyBR665M3imMBXWzW7gwNMxKJyS8wte1xpsCPVo713dGQ2JqqDdBR9YNyWPnNUt
         p4lLzgE0cRd6zrAXRMcqtBpfJGzevtE4D5cJwR9chlphEJu3d8M1UcY5Ts9IbtIVxJMF
         QfHTApsStkUpmO2f+19q5U9EdbVXBm71//2QNY3ELuwIqr0zm1qVVXyvWNJ9YqNV8iG2
         WTpmC+KX+JtTGOVXa2VaORM7CtyUrJrKVwl5v3s7CB4VszEo3Z4Vb9PKCeu+RH5mpGBk
         CQtA+7LecALRhZjpl39rCz53y7c/rBotg9NIf8LGD3mTQ0iN/l3qF+nnEsJu8U6nMJR/
         Y6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789815484; x=1790420284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T7/TbC35mvVX9Tsj/V9b/0eBQFX1WnM70lzVe7sM0Pc=;
        b=pPwQqU99V+6sZQEnKG8xE9C/b1+vXxhrLWEJ8MOiUzTNZib2WC8ngzoGv6AxhWFFDQ
         h4D+Omglm7XLVxoi4SggVEaVyPk1nX+v6GN4QpOlQm6WmXCxfkVsCcoTqWjptJUz3Osz
         V46qyEOcgfj/dCAEjSq+xi9qIxYgSNsWax9w4BkN150A1Lo1q3B4R3GO9qDh9l27YBNo
         7bLSTxrC7tYGIXezOLTLUHtauoqHdwoityw+cZxSzeWqNZFzchc5ydPBwdwQxCBpFzQv
         88HMDMLfk9a9ou8q858cw0b9O5vv/RykGpY3GynPytp09NKx4ACHn0rxEU0DD8jFwmAH
         Jl1g==
X-Gm-Message-State: AFuF++nkdy68g9ghPOwxfywz7V3mJ0CGTgpuHYLGftztf1jr2acJhmR4
	0wQmToUaWnO/d68F8kdQazjMoP4QyIgVbCGvO5bEC47hFM33F1XxBTSDNRnsucB+
X-Gm-Gg: AYBFou2tdzWEfXOQ8dzJjUiGmiD45brj8si9ZYtBQ6Scnl3KhHoBU9kwmPKUy2Si4BA
	hknu3gooedjdAbKkFcTqWj//ZrVOvPTj3duOREWE1dBY+khr/3WCinqBRubXoF9pfaU39HE6aQk
	OtGnJ/kCoofZZZhKEPW3kEjSDKJPxNIUYncdQSNnxdUlsfZ8pQkGKCyVyNLyTTislWDT5ZuRMJJ
	6G+mHjfB5AJ08Q/xJmbAaYFmf3W9TLPJ49MPcMuK/20gVteE1+GaThKM5z5pVw6hDwgxREOb81D
	32D7FC3hWNzTRj4angcxwu9x26HXsxXrV77MWQMNcHHJiHNVNb3QN2yr55hTK1GrOHApyE1cyDR
	2wpaF3yYxjs1H1FxK2vRdQabg7wxz13Hg8WBiBBjSqI1rwRXSWekFhfOGCpzydkOSyQEgOUHWh1
	rWzSt/GlHVWiMaQfc3/i8ArTzRMQxxrj9bBHcNQoA7srAw4gYsLdSUZGvACHSAMF/n19eM0dzdb
	50=
X-Received: by 2002:a17:90b:280c:b0:39e:6c69:f480 with SMTP id 98e67ed59e1d1-39e6c69f575mr3186557a91.63.1789815484305;
        Sat, 19 Sep 2026 03:58:04 -0700 (PDT)
Received: from archlinux ([2402:e280:411b:ec:aa93:b1ec:5a6b:5fce])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a02738654csm2057152a91.3.2026.09.19.03.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 03:58:03 -0700 (PDT)
From: Adarsh Das <adarshdas950@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Adarsh Das <adarshdas950@gmail.com>,
	syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Subject: [PATCH] smb: client: delete compound mids on send failure before unlock
Date: Sat, 19 Sep 2026 16:27:32 +0530
Message-ID: <20260919105732.3041-1-adarshdas950@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When sending a compound request fails, smb_send_rqst() kicks off a
reconnect. compound_send_recv() still has those mids on pending_mid_q,
but it unlocks the server without removing them first.

During reconnect, cifs_abort_connection() walks pending_mid_q and runs
each mid callback. With no response yet, those callbacks return credits
and drop in_flight. Then compound_send_recv()'s send-error path returns
the same credits again. in_flight ends up decremented twice and
smb2_add_credits() WARNs.

syzbot hits this during SMB2_negotiate when the socket send fails.

cifs_call_async() already calls delete_mid() before unlock on send
failure. Do the same for compound chains and set cancelled_mid[] so the
out: path does not delete them again.

Reported-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6a727d22.40259c87.584f4.04ce.GAE@google.com
Tested-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Assisted-by: LLM
Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
---
 fs/smb/client/transport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index e266859818a4..7df5b3447aea 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -965,6 +965,10 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	if (rc < 0) {
 		revert_current_mid(server, num_rqst);
 		server->sequence_number -= 2;
+		for (i = 0; i < num_rqst; i++) {
+			delete_mid(server, mid[i]);
+			cancelled_mid[i] = true;
+		}
 	}
 
 	cifs_server_unlock(server);
