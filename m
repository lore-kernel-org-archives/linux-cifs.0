Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5683B363C59
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 06:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790405429; cv=none; b=maWt8grENV0zhKlnU9FDQuEKoLtILCuntJraYh02+dgvTNdkvyDqlnjAaNH6ifMrwrL08mMUQoz1HzoPnu2WsZxLseMOpL0i6oKruMeb/n9rt2mvLhmZXz9XsSPq+8bK4rFpkmL0HcmgJTZ0ksaQx1vGdqYHzmEFZ0dMTILwVcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790405429; c=relaxed/simple;
	bh=rTGUtv+wPxJk5mSmM4Tl3xXZ3LO/rYIRQAR1R4Hrk/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYgGfhaL4/tX7HbWKOUMCcG4J/FOav/hozziCHYyCPq7t7PWGHu1RZ9pHw7mqvoYRfsoSqvnFfNJn0hOemvkzr1zSbuPJUw1Uprmfpk+5Dxl1o6cr5ep3ajj0wQCrz1HsDSNrVytGAHFnPy5/JXcnaA2U2YFcQkp+7nZH+3BUJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=hpLG9uZU; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="hpLG9uZU"
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc7979d1dedso350039a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 23:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790405428; x=1791010228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qaSz2GdVx8A7Ex+8pGM2lnZM5Ln+swsfQUfhuKBlALc=;
        b=hpLG9uZU96Qg3rkcWdkfKnGm+i7V5Wf6ritlkyqDjD3CX8HzWCeeFVv3188EnXspUj
         mZIbG5z/uTBPFCi2UIZgZVM0u0AZ8ew1+XT/X3WgcU3zKOqd0S1022/BfhTeu7yMZfDV
         I//JIxg+e5/nbuW5EXKhldO/O+fN2dEizs0DSY0+b1gS6m/1BjtG5Q/MsZ11ZGaaXO1b
         iLr9M+gyOdsDLHQu29oXvSH3oqU1O6YtLgwvjras+krA4zHqZpVhg+2tKTcrtePlCZJV
         z3M9B/lR/71m/KCWeqGSWW+r408XcxKmMOJKLixVow9zYYTTadBgEltyvxqt1L7qZmWA
         SYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790405428; x=1791010228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qaSz2GdVx8A7Ex+8pGM2lnZM5Ln+swsfQUfhuKBlALc=;
        b=AA4gIaSrECQ48Sk4O++TdzmL7nTRrx2/UKNi9zWuHMXlBXr0p9ks2lwJDhIUNI8kzC
         ccP8687yz6DDXSzyRWdcR4nq8Y4C7r3Fo5IsE3vDeDMEIoALpclEmuxZAvONBS0AxO4s
         glNa1AAbVSIv+jTJjLdZ9+r2Qu77wsWVKXptMMPwyUKivAPi2V+mBQxtgeQDNCc3axFV
         xA3I2mnhjgxvkhN4PuMJ6FMDVe0PyDFpoOqVzilwnEMFI0QCLiTYks0+8X7UIlFu2nfT
         jtIJyBI8sYG6pIfKmU1va9kko3h9MNdOm4lugnNuvUcs61WAy2Ax3ao95Fm9npXxjAdX
         ZWZg==
X-Forwarded-Encrypted: i=1; AKwUvBx/GBOXkKL6EIWlufhN4Z+Mt7Q7b/0ckYT6JIununcb/zt+ipv7j5WnBrbj0QpV9sSRxYVa0AqR69Ht@vger.kernel.org
X-Gm-Message-State: AFq9FYJ4xtUIbowomd5G2E2OO3uNb3rjdVtApKQJZRANAnEXpligWd/v
	wrwOWHmSVdVXEQSMG73ZQ3MuqyMAuZ91Idoc/K/PJUKRNzIZchaZhjUF8JhRLrhz0ckG
X-Gm-Gg: AYBFou0lpP2dadPNRPC0F3ZpLC4rbw1QiMqhssQoDjudwJGHKtHVB7YbinSuvR/dm6r
	gVgbAcaMAQK2Zv1kVCvDcr6fl7DOtCUEkarT/bRseMykdzalAPlK1myaA4j8mtZJeWoxv1ePCIQ
	pMwR099rc+9OlC9rQXQ+MligfGDZJH1LJID3oQhJx+UfHceC7Ne++gCe1212TtAXrNNbQlqviA1
	Qjkgusy/6vQIG0FMKCx/oKB5qrs2Edk11Hn32IVq0XUCZSJKfVrYcUKoskd1/uiAf5g0M9tsaye
	iKZXjO3+RQY59ETKVqilBCbm3mNAyr2LxkLM0dzC2nWQJG9bjqT4bUqI+OwDiEW48HOwpDkGePg
	ruLOumidl49KnzbL4FE1WACc6DOFpmL5eG7vVYLT19UGpilUKzb/BrKevHl2gVPS9p5KRNAC1qJ
	Rb1QiKv7QgzkduQwAQN1S5BQXF9gmVET6FKATQ77fOmEnGbK+XweREi0t6tMaIFS8/hUBkdPmng
	Xs+2QL4Q9LGkduAaWDnSW1e8Bza+Q==
X-Received: by 2002:a17:90b:314e:b0:39e:5ade:f9de with SMTP id 98e67ed59e1d1-3a098b431dbmr6905351a91.26.1790405427689;
        Fri, 25 Sep 2026 23:50:27 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b498fb12sm3447327a91.0.2026.09.25.23.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 23:50:27 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: sfrench@samba.org
Cc: zihanx@nebusec.ai,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	pshilovsky@samba.org,
	aaptel@suse.com,
	pali@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v5 2/6] smb: client: validate POSIX create context length
Date: Sat, 26 Sep 2026 06:49:22 +0000
Message-ID: <fb456ba211e83a7e17ed2da6867ec4f88af4ff00.1790398755.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1790398755.git.zihanx@nebusec.ai>
References: <cover.1790398755.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_posix_ctxt() reads the fixed nlink, reparse_tag, and mode fields
before checking that the POSIX create context contains them.  A short
context can pass the generic checks and still make these fixed-width
reads run past its declared data.

The current in-tree smb2_open_file() path passes a NULL posix pointer,
so this handler is not reached on the ordinary open path.  Still require
the POSIX data to cover all three fields before reading them because the
helper performs those unguarded reads.  Keep the existing soft-failure
behavior so malformed optional metadata does not fail the open.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v5:
  - Rerolled the series after fixing a NULL dereference reported by the
    kernel test robot Smatch analysis in patch 5:
    https://lore.kernel.org/r/202609241449.HlHmnZFZ-lkp@intel.com/
  - v4 Link: https://lore.kernel.org/all/cover.1789478666.git.zihanx@nebusec.ai/
changes in v4:
  - Keep the handler-level minimum check and preserve soft failure for
    malformed optional POSIX metadata.
  - v3 Link: https://lore.kernel.org/all/cover.1788516372.git.zihanx@nebusec.ai/
changes in v3:
  - Split the POSIX handler check into a separate patch and corrected the
    parser Fixes history.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - Add the POSIX handler check for the three fixed fields.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/

---
 fs/smb/client/smb2pdu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7a6627400ba30..1b2ca3b2c2f87 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2395,12 +2395,15 @@ static void
 parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
 		 struct create_posix_rsp *posix)
 {
-	int sid_len;
 	u8 *beg = (u8 *)cc + le16_to_cpu(cc->DataOffset);
-	u8 *end = beg + le32_to_cpu(cc->DataLength);
+	u32 dlen = le32_to_cpu(cc->DataLength);
+	u8 *end = beg + dlen;
+	int sid_len;
 	u8 *sid;
 
 	memset(posix, 0, sizeof(*posix));
+	if (dlen < 3 * sizeof(__le32))
+		return;
 
 	posix->nlink = get_unaligned_le32(beg);
 	posix->reparse_tag = get_unaligned_le32(beg + 4);
-- 
2.43.0

