Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348711DF25C;
	Mon,  2 Jun 2025 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748884146; cv=none; b=dERUGgQ6RdcCz4rOeChen3bzExbZ0XX/obfiJ4jM/RsegmC+M7p+8ZG4U3H5NPOXBDW0T8NjLxfO95yu4BFnuEGvCr5vJYh9h/lc7DgRK0aCWdOMSj6X1F4eoO22EyWx1POCJbHDWfxGMtuDKxYwA6dTYYujSsmX/YEyQLyElGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748884146; c=relaxed/simple;
	bh=SeRLmnedyQVO1lFYSbJyRT/ZmZYp3vu259zrp7HWxbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9cwcwRq7qI5LCVkb1Y4Ay3EmPIjwG3e+oky+W6tTplSItkLxOby9zHD2URV+oNxbqT8tRGFPZw4Vc9MuiVsSUYyufPaykptzs+2j769OU6WJOxVa8H8RNQfqQAJ2j3NwB5Y3ThUAL3cfSH9MDYTkDpnNd0OIx3yFet/RoN2aoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nuyy82ja; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nuyy82ja"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23035b3edf1so41911945ad.3;
        Mon, 02 Jun 2025 10:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748884144; x=1749488944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1YmnswpBA3f69D6V64cHcVKokKeo5eAqEaEDmfkaqc=;
        b=Nuyy82ja4ohpHMjGa93D2D7hVELUDYN16AlWjebvYTkAAgaZm0ihX+ySIpxLchqiU5
         wKSWEEbO2mQOhjZSkcngcuFpb/NbPM1VCMS+Vr0k4gP728pz5BJiNo60NFxM4n7g3LqP
         M7n0KXcgCR+obdbtBwdb1Xso9M1rsnGecMjCZxmBt4JJ5DFIcAbIlTeFW36J6KdD5oNS
         cairevhMEabvOVq7/LndjkO0+Se2XyFB57bA5bhp0Db20A+PQT3vHUKP/HbeKooZGBlj
         iTW1+nv54MhYjV/MeNoXTKYdmr3JcdVubEIm8JqHI1UZJG7Bz0VVCo23m3dHvS1QkVR4
         aflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748884144; x=1749488944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1YmnswpBA3f69D6V64cHcVKokKeo5eAqEaEDmfkaqc=;
        b=A7rKSroxLaMqXWmZej1gFUh7NA/BQIP3fNMhfSMTJUL2DsAe0XYAEew2kvbctwx5id
         DwFyz/UjKEl0/dsO4zeidOke5TdunrYTHQ83YyMOx1CCEMHIVwjYy5XWHV2E6KYny2nj
         Tgwi3lYvGYS8o81vJvdrsgIBftX+BWnsLqkKoOYD17W/VXw9BflTri05rQ/saiNvPM63
         b0n9ToagCviGkxgsmoSIPOlx9helWK+nn+7mD+kr2kRL9sdK+cI5qrfhfDCBhK8NlOvG
         7n4kX3bFQgcMTufzAdNMrPeIfuVtEqrFKcN5o/Yz7Cgu+TRoHejG0DEZ77evkFBT50+D
         rS5w==
X-Forwarded-Encrypted: i=1; AJvYcCW7IHEaT0F2oH+MPBg8YmTKLUcwpp5b3tgJmfpoRiZ7N5LroehnEUbhbF+SComn7WgXFqofM2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMtqZBuVyPoFZ9BWoKt4XQnlY+0mEzk4s3pNK/1hOanAVGUp9c
	k+yoRKj48Sl6udmI2Llo68Akv0X23zU4WvjqJ2wKx2NbDRtin7IS5APmO3C49g==
X-Gm-Gg: ASbGncu+S0RovtpqwMLWn150h45FukUk0xrBMPEgRY7Y6Y8y+qxxRjMyOqdys4lpiU6
	p964gLU/CKEEpMDenqgM+dPJiCkrDwaVjS1+tVlLhtKo0LCOfnJLobXJ4mvFfsMyCejJB/ZJ7AB
	LJV8sRxXpMXiEotcLM/UCLtEtMtPWbH0Ah/F6CEukoz2/N+XTp3Nv4KG+otiNO0/YRha00YEGQ1
	u0NmsCavm1ZMjtDyu/AykocI8ZJOhW/glqJ0LN/gxlLKIlT410oaG0rjHad1k/+19opPN91hFO0
	f7IbFgq6M0aTOaeipCnxj358KM+S4cfVkmkvh+0shS6yNiFO2kH4BfM0TRO+NQ8gHNSU71Rr1+v
	MfR9KHw==
X-Google-Smtp-Source: AGHT+IElkDvLcFo4rTM9/jnbj8UakkD8XgGk9o8PJjZR7qCRtKzA2BLuaXR5ZogKh5modX+xI6bAHw==
X-Received: by 2002:a17:902:ea08:b0:234:a063:e2ac with SMTP id d9443c01a7336-23528fedd7bmr212808885ad.2.1748884143981;
        Mon, 02 Jun 2025 10:09:03 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2355c58ecd0sm40319625ad.25.2025.06.02.10.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 10:09:03 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/6] cifs: update dstaddr whenever channel iface is updated
Date: Mon,  2 Jun 2025 22:37:14 +0530
Message-ID: <20250602170842.809099-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250602170842.809099-1-sprasad@microsoft.com>
References: <20250602170842.809099-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When the server interface info changes (more common in clustered
servers like Azure Files), the per-channel iface gets updated.
However, this did not update the corresponding dstaddr. As a result
these channels will still connect (or try connecting) to older addresses.

Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/sess.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index b3fa9ee26912..8add3ba14e9f 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -445,6 +445,10 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	ses->chans[chan_index].iface = iface;
 	spin_unlock(&ses->chan_lock);
+
+	spin_lock(&server->srv_lock);
+	memcpy(&server->dstaddr, &iface->sockaddr, sizeof(server->dstaddr));
+	spin_unlock(&server->srv_lock);
 }
 
 static int
-- 
2.43.0

