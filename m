Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662AB27874F
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782233466; cv=none; b=NzRqEfyY++C0gkIPtYEZ8xJe8r1xiXnVfUQEtVojYELRjyaN/40/pL94nKJVmeWTnojEEGOLXL9Yl7l6RJd4ZRAAJ4m2Uj5gNszOqz0JMy56UfGDfQzKWEDIz7yH0CCl74VkGzOJwaYGDb8eWTxmNnkeSSnwlHHVbI4ef9NTudw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782233466; c=relaxed/simple;
	bh=pJbxYyu4+U/b6cQf0gwVOwKMn72YhWqgg6B7GQNSBsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DQtF+TMU325ohFSJs8jaOYr6kFMwM88roIwtSV/xLOprpAn+Bdfks9F4cIZucWVsQk++cZPgVb8yqKnJBXQuYV/4vShwHmmAG3LDL6FiA3/QHn4ZyE2BFo+My/10m5B9QV0bP9mwqySbNmPKPQyArufb5K2HM0lVAq9+FxXx+Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Skg89LMm; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Skg89LMm"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e94b0aeaa1so65661a34.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782233464; x=1782838264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lBu8lFpf6iB0v3hxnQFJ2vpjvXdB7u4F4wNPr4u0Z3o=;
        b=Skg89LMmzS/fua+sgRyxd+NAEyC1PlCZj65PcwOuc+O9gOF8/pyQQ1Jwh7ilRIBJz/
         S8EwVVpjq4f9VTy18QCHfvhFJ+PBEYr5viUqxXwYEOUfe520AITL2y5ibnjUq5Qmw6xl
         AhGTmAOkzs2vAN9YSPuZhgTl6k+045hHbf8gzaS0dTDoiIfCAUYEKFmqGOKnTbiWAr+7
         cZXKTeZuDzrKGFM8Lh5tK/talT7xUBHjasxd/SQlZ8X4wHPmfzFuWRFhuRtv35ggb63S
         69q9+BlLu9BGyIs10n0AAsPs/f3Zo/KiValnpusAeZyDitEsLQ0ajrFcTMn1uGZ35M05
         1Q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782233464; x=1782838264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBu8lFpf6iB0v3hxnQFJ2vpjvXdB7u4F4wNPr4u0Z3o=;
        b=fqPxWVNwOnBHjmyT9+pJc0FATp6osB4AFM5TkxXneZfmeRK+gXGFth6P/0h5tSWW1x
         gZRct7ir81PtRlUTxad76ZFrusnrfHHx9hYEMwtlgxmm+rLpzhXV5HN8MK0PK3koewxU
         4CByrCmZzqHqOX8ADGdJy81++55V4pyixtTLG1LGBZzeMWiDGVi8uxadXI4/DWb7WgXM
         /obwPbcrVVFXb4L4i5r4IHWQmSrz9z+NGS8Ol/xJN8XTGff2kYmgrGj7YBtp0F0XQkBM
         TNd5W4Kbdu/GcBS1h2sTD4yRMkYLV1Ld90DwAKuotpN1QNeN1TNU1xogbChECPlNpOL9
         Ez2w==
X-Forwarded-Encrypted: i=1; AFNElJ8rsxeFDTjLd4AkxSOUo99o7NaUY/4bXtvXpc/R+dz8n/g2fqCGlOLNRJXj2jj6abejZ15fLW54HQaC@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu6rVjAobma75EzcQN5BelBKuJ+LLy/+MQGQDODpLYr4+gU2v1
	lCAv36ME7cQHH7mv8u37orAO/pCOjjuigphXRsX23OzOMb8FY1A9ndcB
X-Gm-Gg: AfdE7clbmQgXdA/4FQjwmUuNva/lN/Nu2qXMzwC6W4aZteOYP9COh3aSq3KveHWj+Sn
	KTOpL8UEU0EaCC36hvdhCGhTxHtwg95dSQsR0twviYddZObi90llItg4+hZDPbCGhpXMaqHa8f1
	Dgn3zEhbDwYswlFbSUNzTTvbXzFi0D7wLJCV38bnsYF3K0/BQj6vd29mN2RrIwIlrNoGMzyQK3U
	ftIkHiQZcKxq1s9spWkc12BXgIb3DqpCe6Es06s/4tKR/3Fl87YSym2dSOw4mfCHUMCp8ddrJLY
	OwFQWdfLe6HWFFlCKUeG1Vz3e3GmZO/PkfKquzwUqnghiAAxhzqwSCT2zG+GTFHcg0VLxOmLHkk
	DuqHxKEfYH0STzKromV+i8Xc/UwTKqINP01zvsJpYyluUPFLNgtUClW1u0cYhxJ3xOtj8oA8vVJ
	6+W1FipjPW
X-Received: by 2002:a05:6830:7199:b0:7e9:1649:fb9c with SMTP id 46e09a7af769-7e9798afc63mr2427489a34.11.1782233464399;
        Tue, 23 Jun 2026 09:51:04 -0700 (PDT)
Received: from FredPC ([2600:382:3129:c34:71e3:cb3:9bb5:8639])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e944005ae8sm9948067a34.3.2026.06.23.09.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:51:04 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
X-Google-Original-From: Fredric Cover <FredTheDude@proton.me>
To: sfrench@samba.org
Cc: ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH] smb/client: use %pe to print error pointer
Date: Tue, 23 Jun 2026 09:49:15 -0700
Message-ID: <20260623164915.42518-1-FredTheDude@proton.me>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

Currently, __reconnect_target_locked() prints the error pointer
'hostname' using PTR_ERR() and %ld, printing only the error code.

Fix this by using by using %pe to print the error symbolic code instead,
and remove PTR_ERR().

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>

---
Found via coccicheck. Tested to compile with CONFIG_CIFS_DFS_UPCALL
to ensure that __reconnect_target_locked is actually compiled.
---
 fs/smb/client/connect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 74197766471c..85aec302c89e 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -457,8 +457,8 @@ static int __reconnect_target_locked(struct TCP_Server_Info *server,
 				server->hostname = hostname;
 				spin_unlock(&server->srv_lock);
 			} else {
-				cifs_dbg(FYI, "%s: couldn't extract hostname or address from dfs target: %ld\n",
-					 __func__, PTR_ERR(hostname));
+				cifs_dbg(FYI, "%s: couldn't extract hostname or address from dfs target: %pe\n",
+					 __func__, hostname);
 				cifs_dbg(FYI, "%s: default to last target server: %s\n", __func__,
 					 server->hostname);
 			}
-- 
2.53.0

