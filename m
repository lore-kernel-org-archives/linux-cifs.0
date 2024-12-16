Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D6A205E11
	for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734374384; cv=none; b=eZc1l2xQ+BdSDpQGd0FZnrfapvtB8PDuf9G1BWGdol/DiGH/xISVtOBjHohx7TP8puiv/dTJNHxi7bwlfV81RpCRLu3CcSbbSzo3hMWGSUa9dj9Snaeg6oCM2WJJ74RWUkgkbJbcGQpiJbo/puli2xAV35a/YVy7bOseildCDWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734374384; c=relaxed/simple;
	bh=HSDv8AfxENgzx3hW8lLaxyvzoJSPVB/RSXOSDeo4VzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bnDVmgskZEItc8kLuvoqPynpAsuTJDFVnnC82zZ9j30rAkp4lrOx++d6Y1llRmKP3bcGhAFbYY0enJzaA0VGqJjnaVw35NVrmdFrgp+0MUpSwWCQhFjWJe7zJvXOxXRJABU6yK6rhi5U8PTVCdGFf4ZrgOM/o1aM6XJSb7E9jJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WDvjGMOH; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WDvjGMOH"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-728f1525565so5249842b3a.1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 10:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734374382; x=1734979182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d2JxBIy/SdbuVdLBxjAt4u5QZzewyRApvLppW1zI/Ak=;
        b=WDvjGMOHm870345YrK4SxCu72PEg5fzOzohi8fMiqrVyK/dOwqD25xb6jJfp8khx4N
         2cUjM7/0Og0IaqQzK8xTF7lqrwavm5z6GkR+jk9UA8b4+oi9e9nsGV71AWcWqvb1woxS
         t0Y/r3ptZ8ngDsHKosXBe0vgweu7iaraIlDaHAylPTzcC6Jk3XfaQbzxMSgntS3qPqoE
         UYjznO6RGtCB8eLk+h8dAfRlHyrh0fKFQK3iK3mc984Jd1BFlA+rUkNT8H9SM8IioNN9
         aYg/GUUcPHznHItbCRZKzpqm5Gk14DtrZ3KuKfJdUUMQxV031Yw5sjVII9Kpp9tiT56Z
         ANwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734374382; x=1734979182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d2JxBIy/SdbuVdLBxjAt4u5QZzewyRApvLppW1zI/Ak=;
        b=Yad8LOzgoW14Lua3lKvjtDdCmEyyR9fVmQTF53gCXCvcyy9vtgi+AB3KG3Et9IGXI+
         0m0JAyfnHXzQZcJQ/UIREwJ7bEMCjLIea7IRyu3DgyeyUJbrP+URZybeK343p5KrZjQS
         hBXrvgYRoJgqcSOTVglm700C+LpErXaNuZ+/uGyikwgccBv92FjI3wrr0hAOSd9c1H5c
         FOUcmbk3db37NJ9FSDT98UPDBvcXMD6fmueHenB1/4nTW3O9vUqNbTy+jDrrJ7ynr7vp
         SrRd3Hzsud0l1PYBH5GLpgbhDu322l3Ik6p1P5ju6c2OozS3ji6DFazcmf4Yl4vG9dzZ
         vd0w==
X-Gm-Message-State: AOJu0YwArkiteod3jBuwwzw+r1zdHXv10ZRomcy+SuczJPg9y4cHTeSG
	RW/vLjyR0yxt1NeCDyPA2btESLg+FCMVprSUuHFfbxpJ7OzKaqEf9Wvtrs3m
X-Gm-Gg: ASbGnctkHmYdQWUOb9mBv/reY0WH4pXKWl2xg82pG3wzi7Z3Y07afpS+zGvxXHwHMn2
	SkFK05bqKIwS5+c2al4pgJOQipa3qAotVDKWsprkWg5gvrkYn6v8c3HZ3L1/Gik7JZMqzI2LPHe
	rMcp4GCaZDCbajRCgAK3m8ppES1YKJTO8krcuLvn06pWZlcjF/0YdxAYzmIf1RTofzc6UDZu+to
	gW8N6iCU+OtoGm2ywBD5kSstSla9JsfU0q3m1StFlzeBgEZu9b4gKwGIRIo/n/rzc31hkCWK+pp
	pgAF9Q==
X-Google-Smtp-Source: AGHT+IEZUXf+WJ69YrLX0nQLWTcrTjkITcpGfvlVQuhiFgUcrRUG6SKHvi3H5WGYA28l6b73N4XxPQ==
X-Received: by 2002:a05:6a21:339f:b0:1e1:ae4a:1d4b with SMTP id adf61e73a8af0-1e1dfde6b91mr18363931637.34.1734374381726;
        Mon, 16 Dec 2024 10:39:41 -0800 (PST)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.189])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-801d5c380a4sm4436024a12.73.2024.12.16.10.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2024 10:39:41 -0800 (PST)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	sfrench@samba.org,
	pc@manguebit.com,
	sprasad@microsoft.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] smb: use macros instead of constants for leasekey size and default cifsattrs value
Date: Tue, 17 Dec 2024 00:09:36 +0530
Message-ID: <20241216183936.5245-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace default hardcoded value for cifsAttrs with ATTR_ARCHIVE macro
Use SMB2_LEASE_KEY_SIZE macro for leasekey size in smb2_lease_break

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifsfs.c  | 2 +-
 fs/smb/client/smb2pdu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index c9f9b6e97964..722be656f5dc 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -398,7 +398,7 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode = alloc_inode_sb(sb, cifs_inode_cachep, GFP_KERNEL);
 	if (!cifs_inode)
 		return NULL;
-	cifs_inode->cifsAttrs = 0x20;	/* default */
+	cifs_inode->cifsAttrs = ATTR_ARCHIVE;	/* default */
 	cifs_inode->time = 0;
 	/*
 	 * Until the file is open and we have gotten oplock info back from the
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 010eae9d6c47..c945b94318f8 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -6204,7 +6204,7 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->StructureSize = cpu_to_le16(36);
 	total_len += 12;
 
-	memcpy(req->LeaseKey, lease_key, 16);
+	memcpy(req->LeaseKey, lease_key, SMB2_LEASE_KEY_SIZE);
 	req->LeaseState = lease_state;
 
 	flags |= CIFS_NO_RSP_BUF;
-- 
2.43.0

