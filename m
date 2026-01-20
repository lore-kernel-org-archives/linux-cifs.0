Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C9D36C0BE
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768890132; cv=none; b=hmHFO6+f+udqD/+qN/ebvyBwYHuXe+LNCamCS5CIE2XZQGtIxq8YhaRjoRhxy2r961dDBgvmBVuTrNkiKP8nA4rsHqsqesDMYJJ2yUnb1KZaLpavAOBoP3BkHDMScoHo3iEETlfPWpD2RXe7YzDuixZMHlxwGbnH1TvTGHvdiKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768890132; c=relaxed/simple;
	bh=uCJdiBR7lhjwUup1LB58KW/Nxbais9kELs1jm57Vloc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQI9bM6IXpYxRif+PG9sxMmGWggj09G8kE4PGCM0LPaRpqKKPfQcDVxaJGWflnM1dHpVSMPxxWEgBpDLNc/OzSueAiF1xseHlnCR7g4Uaq0caa6kLpJ9IpCBZz7D/7xnDaABJaNvpoz7m+3r2I1UHhGTajOXVGGdjxG0yMEMkJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DbhPTLP7; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DbhPTLP7"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a102494058so29245585ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 22:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768890130; x=1769494930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w3Vsmi04miLszLRw8JJr0A3HfiaUwl+316yVAFSDyMc=;
        b=DbhPTLP7HzPA42IDgHtKvmnabUyhuzHloosC6c/YDEXIqnDrewvB+GJ7Q+AHr0Y1Qx
         dgw65MYDkojdfHx2OUylA0LzhI0ftQLMjjOWNy8ls4ofQ8P6LNQIlfTEJMV+W508SDxO
         uGK9BeaV+1N7T/Lk3KvA0xeTZ29dAaPFwC37ElyZyXrZyVuVWfO2Rq5vfdBENYbNjWxm
         muYOv6QGiCc51qSbd+uNbJcGb/vTmYy36dx6nsLhAj8/LMo5X5qcMRf2R50bHNLYJR5h
         wAse//qtPJXVFNwt88nzuFc1c+3dmS+lb1+7aUvd5N4FD/S+EtNWCmapTxP3YGsfMsGq
         6VEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768890130; x=1769494930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w3Vsmi04miLszLRw8JJr0A3HfiaUwl+316yVAFSDyMc=;
        b=wCYl6ZQSy9I3ECiH0nWJQkWTS2sPlAjKtVqVrxqoYw+aiPK9qouvkBvIX7njlACdyA
         4Q8+xF+qttmsQbLqmAMaGmH5k8X0dgExiiuNG0Epi/vK1fep2rNLYVEOywnosUXCujqJ
         hKRUygYV8BAOOGDbRmdE3+UFQzwF5a2hrRDL7wglSLfHDR64zEuG5IRBpyG3Zp3YdNGn
         npJ+9ZL2e7AkGLThAHHmn7riXWc08CZBzwu3JobBDTyipczfbCx5JkK5j/p0BFGgJ+rY
         w3qr+Wv43K6xBTym7/opsQTEs10EDzWuXH9xGXKKrLXvExPXmT2/h2UWax7TUeq54P50
         hcLw==
X-Gm-Message-State: AOJu0Yx5TPq5R8btuqWfd7jpC6PBcblrIaB+QBxF6ADOljT6VfkCLkgb
	tM+CYPG1649+n0pN7SKkSgJbVIk75/EOaMPBQ/HS7iujIurkg3s0cxGFgg5daw==
X-Gm-Gg: AZuq6aI74sfVzLM0iHusSCJ/vEY/JjBJn1DujOojtstFTkcrLWi/aFmRwqUDV3fvhzf
	OoPA2Ry8NGdgoiSNwkrQKDmK3M/uMhYWb2A5orzMcnK7FgAGb7p8MYd7kA/kz19cFLl25dOc6s+
	qZr7R0i/HBIxVLWi9LIx+XIfJi6k8Di0wKDs+Ar00ZkZF3pGxYbbdmvx6uNhSyEp8kTlATrR3Za
	krfGu96DcimZIfDAyDMRgp3se/cU9cG1htPupwx95usaJJK1+uTMVwRF/sbI+s/prrVwYpb9o8x
	XI//KiP+trjO96TFufjtvgJH0tpYTejKl1/ohqiAfuICxzeqrUpLcOI9R4FNPJfynn0bJHv/w2+
	Sh6DhyWg/Q2Piz8fdffue+h3OEIvs7caHXipII+Pb2Gz3Vbo8YyGPAPs1TjJoV9mOmrT0taXgJZ
	I4m8K38R0izoPs7ZlKaLfzT9RvUqQJUzrBJpqJ6BSw
X-Received: by 2002:a17:902:db09:b0:299:bda7:ae45 with SMTP id d9443c01a7336-2a700a4ab2fmr148395945ad.25.1768890129664;
        Mon, 19 Jan 2026 22:22:09 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.152])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dd523sm112497855ad.62.2026.01.19.22.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 22:22:09 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 3/4] cifs: Initialize cur_sleep value if not already done
Date: Tue, 20 Jan 2026 11:51:36 +0530
Message-ID: <20260120062152.628822-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260120062152.628822-1-sprasad@microsoft.com>
References: <20260120062152.628822-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

A value of 0 for cur_sleep is not a valid one. By checking for
a zero value and explicitly setting it to 1, we avoid the added
dependency on the callers.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a16ded46b5a26..a7e06d175f899 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2774,6 +2774,8 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
 		return false;
 
 	if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
+		if (!(*pcur_sleep))
+			(*pcur_sleep) = 1;
 		msleep(*pcur_sleep);
 		(*pcur_sleep) = ((*pcur_sleep) << 1);
 		if ((*pcur_sleep) > CIFS_MAX_SLEEP)
-- 
2.43.0

