Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5B9148830
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843689; cv=none; b=kvtXiCGgA4NeY8kExQk3gPCfWD5vqiCFq7jeiww/gNYBjy2GAB1ww8xE1g20EJ/VkZdMNOsCPSkHlZYmN/z8fcDmMbqdqFcHm/FUK1RwUHoVWglM8TVhq1cb9WJ52bCdvwPbXt8fiKBw+EZ6c7U0mOtOXM+Y9Wgvve7pSzQrygQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843689; c=relaxed/simple;
	bh=x2O7K4uhp2pZr4VXdJXl0ZixtSvvbc4MrdtQw2EsCKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MrWnwnSOSUsi2bRSLZGS2qLe8xfU2nz5gqyjCuYi10sQ7HTGfgtp9GxvL0xlO90uLEQ3ibTVXF11gbHlX5TPZ+Q+RhDDVTOW7Pmpu09xoltwCRxTbegoUOwjOYa9/AMNY7LKti5BRKBYMwlhp2fguGIH+NSQLljKN0rU6RgZEHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sf80oiUp; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sf80oiUp"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b6cfffbb1e3so1027729a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 10:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761843683; x=1762448483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YIJepu/J/kJQh3IWQ6vqOFf63Y+N6hvUdgleeQZ1GBc=;
        b=Sf80oiUpXLdCtIM0yL7RZbIORsbkwajyaBw3GJSFaybyNVgVyTH6laXry1TRUWYmCf
         EfNe4p2fchw0qeyOL0zSfmYuU4XRBSllgUcTpsHiOoO6Ajupu+0WPSO3vE9grsknCu76
         5wleiK2MbAqRFpPb7ZpcUxt8WeMq1yWC4ZrglOxciSE1vqBOhZfDRAcv3b/xKLCiJ4w+
         o0iE87Z8T6k5651PeDXmVAjsfhpVFmrPIjKpcWN8iMtpGlQTuuXmrvO+AKBW0mWtsk2V
         urvx9FymlSvt4yoTcbNBfF509sc179qpNUgKbYRanCkjg6rO4tA2CwRCOKOnDz9psBPw
         VHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843683; x=1762448483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YIJepu/J/kJQh3IWQ6vqOFf63Y+N6hvUdgleeQZ1GBc=;
        b=kBx8VIx7O34yYalJ4kT3ZQmJ6/xsLVGPj2PtxIeyp1Cpoo/7xpua8Ow028pi6lpwZG
         4EFtkyQmOi6SG/8ombyyxP9llsZ8dF+eJJ+DYcYMby2ZpKtbFemJ9JVI8G8kiXIOy3gC
         Rn+4bNccztmCTiGxTryAxBE1YcPTh6NbUf0FYia3K7R4Axy33+/5tnt0RcRe2Y1cHEbK
         yrT+/BHupI8upD+C2//7X0UI68A0A79ke3HiX6znp6XkYL8OgUWgz4SmFUXM0+LB+dKS
         iJxzOuJ2gkUCH6vCgJrWF9Mj7eIfp6SR1OGYSxIN3AYyd+ueHLL7LS4vZcWUtQoswBtI
         qVRA==
X-Gm-Message-State: AOJu0YxsT+1Ul2xrmFiVDseO9ex8CWK9uYZoyqsjW2YKNFMoUj+LEuk3
	OEtNTmwcsWjSXvpsxw84zJ1A4W52jwC6sg5yNjpz4VKvU28for403Gwz/5xdfqro
X-Gm-Gg: ASbGnct7lO3sCBsZZIg4uHaqYNjY7QI4W6odRoII9dR/fsXGm/zsV7YmN+Z06bi5621
	orFQNC1EkO/+M5TlMuSiCdo3mxGny+Q2RXSsy24PQ0B178or3CEu6OOvBnyywPTpWXrGB3QQVrr
	fxj/a78DL2slvReigxON6CRqv7BiCVtnzu7zTbVVRSab1XjSoKV0IAoIa4nmDitjz3YTxkKW/IN
	oBeWBzMUtxTPxHHE5fHCmfyLLeuh4IDZFwUHR+Q84dVq3nGJRsvAprTdzLYhXxBHkbYatXENMTC
	24LVs6CSO8HR0p74jOjgBm3bkewydSNRSdjA5wWRWjjzjn8bY3skC98Il0v0NkQwcqROi4Ipq+7
	EipTQFL9g/Zv89bdmgUuG74pQ/TLe8agwdxFxXqd9oDnef3eahh0TtjP9dPaSQJOXf1X1YIKK6Z
	hHlKrhXg4WUczvqQW5WMMpkDP6pleT2oirRDkFHA==
X-Google-Smtp-Source: AGHT+IGLVHjRl8mOnxxjViKKVvquFHR0KPFTYFOdUrz2UdRoQsw3AUx0acPVVOTh1OvWGSyMC5lBtQ==
X-Received: by 2002:a17:903:2a8d:b0:269:4759:904b with SMTP id d9443c01a7336-2951a4df00cmr5393785ad.58.1761843683263;
        Thu, 30 Oct 2025 10:01:23 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.160.85])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29498e41697sm191788485ad.98.2025.10.30.10.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 10:01:22 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	sprasad@microsoft.com,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 1/3] smb: client: show smb lease key in open_files output
Date: Thu, 30 Oct 2025 22:31:14 +0530
Message-ID: <20251030170116.31239-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the SMB lease key in /proc/fs/cifs/open_files for
debugging purposes.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 1fb71d2d31b5..1383caa5a034 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -249,9 +249,9 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 	seq_puts(m, "# Format:\n");
 	seq_puts(m, "# <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>");
 #ifdef CONFIG_CIFS_DEBUG2
-	seq_puts(m, " <filename> <lease> <mid>\n");
+	seq_puts(m, " <filename> <lease> <lease-key> <mid>\n");
 #else
-	seq_puts(m, " <filename> <lease>\n");
+	seq_puts(m, " <filename> <lease> <lease-key>\n");
 #endif /* CIFS_DEBUG2 */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
@@ -274,6 +274,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 
 					/* Append lease/oplock caching state as RHW letters */
 					inode = d_inode(cfile->dentry);
+					cinode = NULL;
 					n = 0;
 					if (inode) {
 						cinode = CIFS_I(inode);
@@ -291,6 +292,12 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 					else
 						seq_puts(m, "NONE");
 
+					seq_puts(m, " ");
+					if (cinode && cinode->lease_granted)
+						seq_printf(m, "%pUl", cinode->lease_key);
+					else
+						seq_puts(m, "-");
+
 #ifdef CONFIG_CIFS_DEBUG2
 					seq_printf(m, " %llu", cfile->fid.mid);
 #endif /* CONFIG_CIFS_DEBUG2 */
-- 
2.48.1

