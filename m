Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11AA149C49
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714053485; cv=none; b=ReZRat5zNBZpVqn0OG4JdQwZZ5ErvmExRpbGLxe/IeGS459RssEVsmA5kT3kT/oB8/9xC5pgdKxV/Ndkg38q2+t5EUAAhqAo8NWa6vF62yhRaIWNbZVAfcyy+G2xA85A/5Ih6zI2zCLsKeHFNXQGO7r7eAznGIdtfaKOlbVYVPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714053485; c=relaxed/simple;
	bh=26S1ot2mHsyBQtSum4/zWw9JL8aGDS/1+4CquJRJTTo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jNYipvU0mc36BAl/WI0UPrEj2169/7751GiZwM8wzg3RamkoygesNWUSCJeMfJceOWH52wWbDhGIfzaJaoQ4opkCi7LrKBR6794BPahDd1t/UDFJ19oVQIfvW2NQaSm9rOq56+WiQ06i9Zb+ADLeWMPTsExMOC9h6K5gNizjUKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6eff9dc1821so1019343b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 06:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714053483; x=1714658283;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JvhIho2Mb1vagtDSj2Jegz3P+XVs5p6z3U6990SO0JA=;
        b=PfoG12JrSDqNYMx71YxRQRPcJv/9DYlykjQBt9lFv8hbtyqgJzn0UrSh3iwUs9NhWr
         uW/8k7W72lDpMzwcfkWsiNxXNHWdLUbun1UIjVupzeAJcj3ivozXDU1ibiovpXrfHxN4
         a5/sBRD9pP2pMXEv0LVOeHR1BXlXajFjBvBzKe5+xE+BeKn5LbtBgHGomgUEJn0j+ZWm
         wNrDKLECKp8ASJWIHmHWCoFsAWdgHt5DfqUtMY0mbCf/zfSRGKzMCuDuOX5T6nnTayp1
         3vNH3v6ARyJyjhlU0J1UHJiE+4ugKVZl0ac+fcA2t+kJwYcEzPCxy8TQ6JOiu5fZgbhd
         YCVw==
X-Gm-Message-State: AOJu0Yzm/ZdtqDQak8UH943LQNqIJN670nHV28pV4oUhCoadrcXA9c/g
	QQ5ktc+7vXTPT5Me9JoMUwtECIAWEq4Qum8T34UKFe4i6YN9UmjYUAmd3g==
X-Google-Smtp-Source: AGHT+IHN7LPgI29PGXe9TFk4tT+w2rsnpyPdCBrXJbyIuxH18MpErUv6uEaErFMjPd6I71gWDxLeSw==
X-Received: by 2002:a05:6a20:9792:b0:1a7:73ed:7f8d with SMTP id hx18-20020a056a20979200b001a773ed7f8dmr5900124pzc.38.1714053482692;
        Thu, 25 Apr 2024 06:58:02 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b006ecfe1c9630sm13559031pfi.92.2024.04.25.06.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 06:58:02 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] ksmbd: fix uninitialized symbol 'share' in smb2_tree_connect()
Date: Thu, 25 Apr 2024 22:57:50 +0900
Message-Id: <20240425135750.3503-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix uninitialized symbol 'share' in smb2_tree_connect().

Fixes: e9d8c2f95ab8 ("ksmbd: add continuous availability share parameter")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 355824151c2d..30229161b346 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1926,7 +1926,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
-	struct ksmbd_share_config *share;
+	struct ksmbd_share_config *share = NULL;
 	int rc = -EINVAL;
 
 	WORK_BUFFERS(work, req, rsp);
@@ -1988,7 +1988,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	write_unlock(&sess->tree_conns_lock);
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE &&
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE && share &&
 	    test_share_config_flag(share,
 				   KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY))
 		rsp->Capabilities = SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY;
-- 
2.25.1

