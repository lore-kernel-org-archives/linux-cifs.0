Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B463B1008
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 11:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783510044; cv=none; b=oQ0mniGXcjLphEhQfO0GzrB1yRDkL5Xe7h7YUlG/GRsIFEmMqd0jUxvf9hQm7Nvuz6neYlimI18n/a45Eg2yetkbJwmzepeTWricHKIWNXRWIn6NDEH+LfnHLJT4vNkeS2oaIrnGvvulUP3gqCgZpzMRw0io9T0C6/WzspFjoS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783510044; c=relaxed/simple;
	bh=AxPPwN90iP4l+b27JWSMmWlcNQW2IIDOnihx1QGleN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LpsqVW1YRnHlyJ7UHKhawzSbLnrROacVQhCGrHfPtLWGG5eZ6XVKn31cb7fhgTQQ3nN2fDQqFbCfve0E+Gf3jPGfZAmVL1J29jxadYEk4ztp6v3CTgXZga1ybFaY5Nb2D1j+kD2Zfmf6wHm/mHwBp1NEeUEIclgqr1Cjax1ME18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IksYdI9K; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IksYdI9K"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3804e42ad5fso555209a91.2
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 04:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783510042; x=1784114842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T6LLPYPxF/rwL0UhQNWTO3hdR4wnXs81/2/TPdtR2qo=;
        b=IksYdI9KZs0ZOWuEd+VVLTfd+uIx6X4Mfo+q/aJ2Nqji8n5O7S1X3EZ/47VV2icque
         uk2Hq6egwduAhtn5hoI0zhxaviVQsLIXXUKcDee0oZZuePvksa/jzoIUaWHf6HIA1b3y
         cH/5w9IvOvu/qMU5dw9VBsYIzVwexXjJq6SHz9wq1Ybp4WV3Usn5KAuhG4283KxHrwKL
         WyLu6bRIglzcNZJAtYCgIhHdZ3oHL8dm3giW8QF8xnkEZNTFxIniyHIbgE60tpNosMLN
         NyfHrHnvrvcmCemjgBWPBRPzFuybnWmyhOmeMP0FG5pgGHsiZCqBwvXRnIiE8Pqs36WJ
         aQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783510042; x=1784114842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T6LLPYPxF/rwL0UhQNWTO3hdR4wnXs81/2/TPdtR2qo=;
        b=jDbhs7MVW2n/YC7SXrd7Z7k9ziy9WzxR2cThKEYUoDGvtewrY96w0c8Cbi94zUn19Y
         tB8IgyiIIy0xT5sRErBR66v5bbZ3el74DI84vBretOYggmAZU4nzTGGYaRbJRcLdPoRZ
         nKEJRhzGFEaLecGsMZgqHPcnsUprrx0/RYax8aHIip9uAkSmq/0OFVCLxIsNJNa5v9vF
         KQCOyn1lpbtW32DJdMYaPSNR3OXmcMTPWU0dD4xI27FpXgdlQHu+g03HRgLldGYkIif6
         4imG6PvUKKDfmRF51Kf5Zkm2hvZeacJVvoaRHyDNcVkaTy6iTDTnaPITqCrDf1OZfSTG
         8zRA==
X-Forwarded-Encrypted: i=1; AHgh+Rru3cmN4K/hPXXVZJhdHnsEsiVYPw4FwAQQSE/otT41RAFwfMGwP2TO4NQolbM1ee/8VLRzNFxheRfE@vger.kernel.org
X-Gm-Message-State: AOJu0YxlIhR8PztfD8Y40A/k/3tIwTLBkkkwG1DXuYCwqQB7hkA6pSAY
	cbOBSCOWZD6/TDmFqyzaD70e7/sZKeBvWfS/k/n3jI1gkInloTK1uomq
X-Gm-Gg: AfdE7cl7HQx17gheKEefsNzDM0ukQgh0bd01NbUHjuaEkvENJyH65pInBkuhLHzvftq
	aQWJGBQewHai6YMbouywy+B4je3Jk+eA/1TL8Xa1oCRSrK+JQ5uxkEBPufc8rJku6Hb2ZVXkPky
	FzOfgkiNxXFbKYjK6kFNiTK3TSv+97k/h9wRCBn8EZc1Jp7TMPdGATWj1fWzlcY/5zSIkiSlBfn
	yMRlFq11axGasZuYHZ5LG+rdkxqfZ7AwoPUIWd+RTkvGLCzUfs08N0aZiJTSZzPsXcbCXFB72ps
	BJE2JiYRJta9L2peEmrParOaMtW18hGO7HPXzIY0seUYFk/LkWiPkbRtca1/3Ugs9AaO1JRVzlS
	l6LIDWGLXfph6m8sZ4J/+uaf3E3Ada7f4nCsmeOkmFDX9xVwxNummG0k6Q1vJU/KhYd0UpX+CYQ
	dn9VXWe5CddOzK
X-Received: by 2002:a17:90a:da8b:b0:381:e74f:8a6a with SMTP id 98e67ed59e1d1-3894053d0b1mr2145294a91.16.1783510042402;
        Wed, 08 Jul 2026 04:27:22 -0700 (PDT)
Received: from lgs.. ([118.193.39.55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d3d57bsm26334255ad.59.2026.07.08.04.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:27:21 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Aurelien Aptel <aaptel@suse.com>,
	Pavel Shilovsky <pshilov@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] cifs: validate DFS referral string offsets
Date: Wed,  8 Jul 2026 19:27:10 +0800
Message-ID: <20260708112710.752136-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_dfs_referrals() validates that the response header and referral
array fit in the received buffer, but each referral also contains string
offsets supplied by the server.

Those offsets are used to compute the DfsPath and NetworkAddress string
pointers without checking whether they still point inside the response
buffer. A malformed referral can therefore make the computed pointer
exceed the end of the buffer. The resulting negative max_len is then
passed to cifs_strndup_from_utf16(), and the non-Unicode path forwards it
to kstrndup() as a size_t, allowing strnlen() to read out of bounds.

Validate each string offset before deriving the string pointer.

Fixes: 4ecce920e13a ("CIFS: move DFS response parsing out of SMB1 code")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/smb/client/misc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 0c54b9b79a2c..ee1728eec8aa 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -752,6 +752,10 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
 
 		/* copy DfsPath */
+		if (le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+			rc = -EINVAL;
+			goto parse_DFS_referrals_exit;
+		}
 		temp = (char *)ref + le16_to_cpu(ref->DfsPathOffset);
 		max_len = data_end - temp;
 		node->path_name = cifs_strndup_from_utf16(temp, max_len,
@@ -762,6 +766,10 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		}
 
 		/* copy link target UNC */
+		if (le16_to_cpu(ref->NetworkAddressOffset) > data_end - (char *)ref) {
+			rc = -EINVAL;
+			goto parse_DFS_referrals_exit;
+		}
 		temp = (char *)ref + le16_to_cpu(ref->NetworkAddressOffset);
 		max_len = data_end - temp;
 		node->node_name = cifs_strndup_from_utf16(temp, max_len,
-- 
2.43.0

