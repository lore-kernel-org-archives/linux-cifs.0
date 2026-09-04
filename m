Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596B44A4823
	for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2026 14:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530739; cv=none; b=pr3xdjURBN9wAMToNyWMtyCtQEGwJjjUehH3AGMSLcqmMaRQOWMQF7KzFq0F9k5avm+DmrC0dVCXXPLIAYkO3GieE9RZYHRPhfbgKPZN/B882AGA4wqXIma89kbHkr9p/hkXUbqzehbUET5DFd3fLrKkCCE6QV9FkXMWEl+oFNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530739; c=relaxed/simple;
	bh=74j3fwyacQITliuGsMZlTzpkrfqOUEWVeCXeNha+g+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwVC1Q8FP0li8q7sAETXrRW1gcGqiT4pl39qOuu+qKRakznQmd/1+P93EHBkMirc6j/vWD1TGGbPs7CzA4RmFb+OAMPA/Oit2p0sTpLWQtn7WRFzlKr9LmnJGRaqWFwLbI9w/CPJyHfkjWzYa7SStC7R3uv2O+CVw9klxmfEe5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=S/aOp+/K; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="S/aOp+/K"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8518b3ff3e9so934368b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 04 Sep 2026 07:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788530738; x=1789135538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Set7xBiEVWYLIBwmw99LbgzIL/a2lqsWrI9NiV/oNhw=;
        b=S/aOp+/KlipcPJE4avbEo+Qd8kMLK/sKuvTE8ai/yTh1MsPb9KKh9sSRaYkgyV7GKR
         EAevDulyr7dCvgeNZQWjfSIJUwO7bS4BW9U5Qy1YSq2fS8jf/15ylscPD4CELTldr3k0
         LUVeqx/lSyjZWxQk2ttPXXOcWa2k4FkefoebKqGbO7AVCFq9eFw4IkvqvFSFjS4LXJYO
         VRsy8EriuZZxgV8z1PcHMtA8YAKsUENxaFYv3pzy+GOmzgTgC1oFjlufkqeZMSmsm7v4
         PibPhvj5leqqxK+9wpOPfRFsCseP94Ff0ns54MByfWONlr9mSzOijVvhkyegVp1pNQ39
         e8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788530738; x=1789135538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Set7xBiEVWYLIBwmw99LbgzIL/a2lqsWrI9NiV/oNhw=;
        b=AV2gJMn4PAIi6waSFgUhHIieirAgqlaHRrh38wdEyXaHFMS1u7rQTp6ZcG0dTz5WuB
         Pj2Xv9i05j5q9le3QT1h5q+UOaDpOyQPa8RQ+9WArVdB1ozMRPxV9vn+vFWp264y2dHc
         /iX0O+gMCA/gefsQsni77v8AHc5rYkY/ic+Q+uwJLf8nOdsPToIJX/yeIBRRqtbV7VB1
         7SZGkUKwCey3Aa+nTfQN+9ADkxbjHFXc2cIEFtRWK77+QDS9+JLfKtQOeRa12rrXRp1m
         f1YMIpR08FoqTO3dC2HXw7eSogbZ7qGc4pPjbeDNTEjouytWgh9F4WLoAIqjKVE/Z0MI
         nX/g==
X-Forwarded-Encrypted: i=1; AKwUvBzvTheK3ZnVVy1wfb1AuMA49gz4hDXkZ7HprOpifoDfFQYTMlatrEGm5WBee0plS9n8Zq40ZG/bW6ki@vger.kernel.org
X-Gm-Message-State: AFuF++myGGtGyKHW4wuRKBR4LSEG9yQ2V5yBrx+USyRKOCjrfYRPwPXF
	aYdkxU0c7lHnTv1PHROrJd5mPxidvj7UzDF7+Dp7cQwtEorNwdfu49t9iWQZfB+HNCt2
X-Gm-Gg: AYBFou0WRT2PvjzpoZccx5+5MSHBHEM5S+dbXn+wsHsuIgc/nq/CTHAxIArhhTpSuFH
	s27gKFmVOd3i/6DX/eC7ff/my3nJPUmYE3Z1YeYTXC5/lo9G+8nP2g8gWmVnb/HJhrXmRFincL0
	tcBCQohRuXcvbSucofpKCd0dbxL0j1RJF3Ob8zCdj/OHRT7l8Pt7eplG8v6/rRMoQD/+e3coNZJ
	YEyFCa7PqXUJMKF03YvFF++9vDsDYKo6zEp5OpUTTMfQ9ksl4sEFqVrIMDHUGmWAXXb6AiKoxLp
	T/tOoqWxsDn1uft9j7VUq69bwGw7j6Dz2wUnHXCZWKQVJCFjHINsL9+j0ZchU+DUeuvQEGIeEyh
	5A2VsQn5ZMd07mnrFzXgbcw4NsobrBtdi/3RD9mCvO95iCC5DgCdWcJWwXNvwqtgjP7Rgs8WCuF
	nRkPGP6m7idVjFlvPVgPCcGT3pCjAW1UG49RGPynFXaUJZFY9FH9xBnmVlYKUzzlvTYcw/BUTlZ
	kU+nbiCacHOScmbm9M=
X-Received: by 2002:a05:6a00:f04:b0:851:ba04:ca02 with SMTP id d2e1a72fcca58-8616a36cc48mr9997364b3a.16.1788530736532;
        Fri, 04 Sep 2026 07:05:36 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86153e3ac30sm1165524b3a.56.2026.09.04.07.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:05:36 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Steve French <sfrench@samba.org>
Cc: Zihan Xi <zihanx@nebusec.ai>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Pavel Shilovsky <pshilovsky@samba.org>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] smb: client: validate POSIX create context length
Date: Fri,  4 Sep 2026 14:05:18 +0000
Message-ID: <20260904140527.62354-2-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1788516372.git.zihanx@nebusec.ai>
References: <cover.1788516372.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_posix_ctxt() reads the fixed nlink, reparse-tag, and mode fields
before checking that the POSIX create context contains them.  A short
context can pass the generic create-context checks and still make these
fixed-width reads run past the declared data.

The current in-tree smb2_open_file() path passes a NULL posix pointer,
so this handler is not reached on ordinary open.  Still require the
POSIX context data to cover the three fixed fields before reading them,
because the helper itself performs those unguarded reads.  Keep the
handler's existing soft-failure behavior for malformed metadata so a
bad optional context does not fail the open.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v3:
  - Resend after no response on v2; no functional code changes.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - Add a handler-level DataLength check before reading the three fixed POSIX fields.
  - Attribute the fixed-field read to the POSIX create-context introduction.
  - Preserve the existing soft-failure behavior for malformed optional metadata.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/
---
 fs/smb/client/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 95d862a1241be..e3973d331633d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2405,11 +2405,14 @@ parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
 		 struct create_posix_rsp *posix)
 {
 	int sid_len;
+	u32 dlen = le32_to_cpu(cc->DataLength);
 	u8 *beg = (u8 *)cc + le16_to_cpu(cc->DataOffset);
-	u8 *end = beg + le32_to_cpu(cc->DataLength);
+	u8 *end = beg + dlen;
 	u8 *sid;
 
 	memset(posix, 0, sizeof(*posix));
+	if (dlen < 3 * sizeof(__le32))
+		return;
 
 	posix->nlink = get_unaligned_le32(beg);
 	posix->reparse_tag = get_unaligned_le32(beg + 4);

-- 
2.43.0
