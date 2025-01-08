Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868FC1F0E33;
	Wed,  8 Jan 2025 10:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736331099; cv=none; b=NFvqjFU03e7lh6Uln/YzkOoERgUMpcJkboQiOZR93BQjANRV3I8uii1LLq+4vLQizhgEJnx7yKqBQJ8cVrJWAFx/ltdTz8l7EKO4PbaBqOwGy8dAWuv+Gj5/rhCsp/9O7Xman0MvoGBuLzVqdpDRg8cHe5tYmQHia/WaUMYMdvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736331099; c=relaxed/simple;
	bh=R7t5O55X4yl15kykPj+ZYEW38mU7TphA2vE41KyoBEw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DMYjbkjaYOQIjWZ+LL1TbcOyBgpQv5QMCrrF78Z6mK52LmTVTauwHXV/XYR1AVURzh7LdprFgEv+2S3Zf0IOoH4aiU5nvXPyl/yOY4WmwF7EzNrueIknL5MSRfejuBKfeEyfORjuB5iRl3KWdTYc9QnsY0BdXJJWidd/ODyu6oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PZD+47ro; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZD+47ro"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-216728b1836so224711905ad.0;
        Wed, 08 Jan 2025 02:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736331098; x=1736935898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bsSd7sq+62MuFijb4LkBRxPxk/B2VEgm6g61r3AG+Ak=;
        b=PZD+47rovY7+28jew6PqJAMRqXikZvMWqwqy/8Ey3diwfIvnpPWg7L8TksQURR/I7w
         O78JeUtkpZb4Y/b8wKySJ2CCtuVXBjEN7diwHsWeRTkNHfIy1Ed9laFFflJXKDA6jYMu
         Zpgl4ruFaT7hCH7u1WdunTFHifsYWKK5unCRYyeUm4lrz8LcW6RI8QEx6COOObR1JGEh
         eLjxd3HAVYuKmbSvDP24cst/t/NpFdxU5vTUlB0vLCiDd7ETIvtNttJ+hD2hQbn68ov1
         SEcIywZI+ZdTKAyNO1y7gdJilDUMU4X48IZxV6P28/hKt8+WrBdsaH83B+IdP2+D/Rjt
         xUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736331098; x=1736935898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bsSd7sq+62MuFijb4LkBRxPxk/B2VEgm6g61r3AG+Ak=;
        b=f9kY4rp4BoGNistlnFnDRgzvKDzk5djnfTag89Sl8X6BanPjPs9/ltmryefNr3rgka
         vv412Vz8eMFHSMNJeoUlq0/qG0/73xEzmAPbqAkHPJ7zPDUlbAD6ciNN1J1c0W2Tt2h2
         W4YzjsG/ILy14CZx5ncqobCq2nJtThohnN0AqCyKvJo1i2Rl63WA8vuN5GOulyVkx4CM
         kGxyGF1LAZbW881jw/JTk0DCtGOpj2Q6tRHjN25uKeHwON7+S/jA/gUczHmA45230CqA
         eXBUnzi8QIMnGVpF6dk5APLeMhs3Fez750DD9xpuA2Y7J54YHj+TxDlBdgY/9AznOIks
         YXag==
X-Forwarded-Encrypted: i=1; AJvYcCWs9nyH2mj1WOc2WAkArkpjy59LvjdIou/FkdEUszo4jUfBYQjAbEiPi4i2HZRlhty+PeJKmLfKnfkmjPfQ@vger.kernel.org, AJvYcCWtztMVRvk3Z2GlmeONDqH6MWJyZI5U4jt9fECibWHhwcheETNoLRJ5XfKmEohkIvuvRZSKaZej2UEI@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbxw1EN4MRkyOyOgJiL6bMLgT3BF3ZMGdCMJtdoamxna5WCZ/i
	0XTDrHQ6ozJT0/ep93OwgOyjrSKlBfpulmQjXkiSyWL8caCrSN9v+zOLjg==
X-Gm-Gg: ASbGncv/I1o5Hr9Bc93oPQpooPQv1IHsdAvrOoMH3CjyZ9COBYwK9XQFfEuatOOb/KY
	hWhgE6rXhsnjLCE73LnPGiJZiRY6oXoQ1lgdBTB2tDkxsTEFPO7bNjADIAYNeJrYTHrFaAYD6+P
	WUrnhrQMsEuC367cTuuY4EN1mqZsiT7fx8DiyM2egB8oYY8GxiPs7bkWyUXT83ciIe7PFi8/hRM
	0YiV6SL5w6EwlFk0mTjs4AZAbqGGsiODjDd5cln5DA/55Ff1Vu8ndonKE4NjjRfR+lFwS7H3g5m
	11hfvw==
X-Google-Smtp-Source: AGHT+IHi+X+9AuE4ynAF6NGC400C9/PhkFnVHhureO6+exsYW4q5yZJ2VgRyOSjcLdGw6UeIusGWcA==
X-Received: by 2002:a17:902:ce8a:b0:21a:5501:9d5 with SMTP id d9443c01a7336-21a83fde4femr31849205ad.44.1736331097714;
        Wed, 08 Jan 2025 02:11:37 -0800 (PST)
Received: from met-Virtual-Machine.. ([131.107.174.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f734bsm316777555ad.206.2025.01.08.02.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 02:11:36 -0800 (PST)
From: meetakshisetiyaoss@gmail.com
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	nspmangalore@gmail.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org,
	bharathsm.hsk@gmail.com,
	bharathsm@microsoft.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH] smb: client: sync the root session and superblock context passwords before automounting
Date: Wed,  8 Jan 2025 05:10:34 -0500
Message-ID: <20250108101130.28717-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.46.0.46.g406f326d27
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

In some cases, when password2 becomes the working password, the
client swaps the two password fields in the root session struct, but
not in the smb3_fs_context struct in cifs_sb. DFS automounts inherit
fs context from their parent mounts. Therefore, they might end up
getting the passwords in the stale order.
The automount should succeed, because the mount function will end up
retrying with the actual password anyway. But to reduce these
unnecessary session setup retries for automounts, we can sync the
parent context's passwords with the root session's passwords before
duplicating it to the child's fs context.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/namespace.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
index 0f788031b740..e3f9213131c4 100644
--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -196,11 +196,28 @@ static struct vfsmount *cifs_do_automount(struct path *path)
 	struct smb3_fs_context tmp;
 	char *full_path;
 	struct vfsmount *mnt;
+	struct cifs_sb_info *mntpt_sb;
+	struct cifs_ses *ses;
 
 	if (IS_ROOT(mntpt))
 		return ERR_PTR(-ESTALE);
 
-	cur_ctx = CIFS_SB(mntpt->d_sb)->ctx;
+	mntpt_sb = CIFS_SB(mntpt->d_sb);
+	ses = cifs_sb_master_tcon(mntpt_sb)->ses;
+	cur_ctx = mntpt_sb->ctx;
+
+	/*
+	 * At this point, the root session should be in the mntpt sb. We should
+	 * bring the sb context passwords in sync with the root session's
+	 * passwords. This would help prevent unnecessary retries and password
+	 * swaps for automounts.
+	 */
+	mutex_lock(&ses->session_mutex);
+	rc = smb3_sync_session_ctx_passwords(mntpt_sb, ses);
+	mutex_unlock(&ses->session_mutex);
+
+	if (rc)
+		return ERR_PTR(rc);
 
 	fc = fs_context_for_submount(path->mnt->mnt_sb->s_type, mntpt);
 	if (IS_ERR(fc))
-- 
2.46.0.46.g406f326d27

