Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314FC52B1D9
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572596; cv=none; b=JDKfL2Jri2Q5Y7f0T2Q4N/559FXi80wd48mY8vNMGf3mnNQLUV2wG2bXeXXgPFHyZyoNBGD/Jh0Opb8jBuqCMPZ7waKjkPUDvnPTK4JzyPzIxixZfkMD1gM3vZOo3jFBOD5HybumrEhqFlVKRTMcnf9sIwyqPALSA0Dc36nD4UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572596; c=relaxed/simple;
	bh=I9O7wOHqdv0DpuA/FsaA4+6Z8EbI0eP7fNeYKNeFr4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgwYuAezEjaSX+r0UHnS/arydxjotFyIwr9hW5Q9e8TynE9nXQUjcGQFeDxBlI1gjT6uPuVMbczsVUE7R2zMSa8CktksgwI+BMys4bj9w6G4TIEi5sPq1KzNVx7ADqJw+BL104yGBurpmYjvqMfB8du3fZwe7T+g9IdEgJcW2Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=gF8AkeUd; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="gF8AkeUd"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-398c066106cso845271a91.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789572590; x=1790177390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/JRJwUqCEcMZ/u6HkNzv6C/SQMcabKTuR7QxROLR/Ao=;
        b=gF8AkeUdUhJGwq/9PSfP1Um0oS+Nm/sFpXGzlVsYGt5lOeJsTifqIq+pK3SL6wLsuU
         iQyiHcHyeQHJyLG2BVOibLKPA18yAuv7y6palUdn0Z/hzg0tbSvLzu6cBYMy7/exSDDg
         z40zoZZr0oQSFgXKtD4jNephLq/FwRw1xr6oFSAqYLaKrHfqGgDW0UYztVLMpdB5jwnx
         M8Dpeo+15PJWa6FlS9crQXBQD8jqlD1JXO/WY1SMtHq8dfgk9sqlERruC+3TsX6mp1gA
         3fLRruIWJJor18+EdB4DUT9yI5pIQaVHtDMs/GqezLiKoGugaQgIpXo1kAbxwE8PumbZ
         urvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789572590; x=1790177390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/JRJwUqCEcMZ/u6HkNzv6C/SQMcabKTuR7QxROLR/Ao=;
        b=Gbo+nhVAkviIuJtGaNBSWvurmujTPNLprowHSiKJIJ2fpuDJVau19WDyC9+wPJ5tik
         Z+NXitK57OAnx0gUcnWhvOKsdP8oPqCuIr8mfFcK5W9JDWYbYHddRKEqjSKVURdhYtJO
         6ZjRa4gl7ohZWR4l2ROLl2iJFWD29MUUl1In6RCLp4rAn/KpDPgrLS+EF0ZatS1slQyD
         2iHayzQzJt9EMRQwh0GmZG4aSVo/eqRQVl6SeDK4w7MAd+x43DUX3GUKRCRUu0qOSPEk
         zjIF1wEVu0jJulftG+0Y5nCe6Qm9CWlfsNaPUZP00G+xkqkP4ENT+JXlEdpVhBGTe2qT
         3gMA==
X-Forwarded-Encrypted: i=1; AKwUvBw+Fk8kHTxAO+4fwAeWLjDqO4P6MOeMt0e6nmmyDVGVvoO4Cmk77VgFgdivSLE4hdcAaw6arZ/X8fqY@vger.kernel.org
X-Gm-Message-State: AFuF++kweTrHqkZh9z+tHpzVqGyUzqCpprMM3cxrpBH9t17E2D6uE82T
	5Y5fGoTy3DfgaJpxBi/iHa5DN8FedKO0p9PD5Ok5E0sDRI1PHSDPxIeZ2FQNGZCBmKk8
X-Gm-Gg: AYBFou2uEWTSJNP6/0vtEMD+4t6Q62C1eSIXkx/MZ4XK4rVhkano3STsrBzQ5jcb9AI
	X4b5pdoXy47YMb377+YMSbuC1hkXiHKlgNwygPVMOIXqG915vznk1c/PbBZ+hyTrrqx6lYCz2js
	PR4SWx+3YcyqEYM0m8VUE5WHSsrIq4VMh4vtpCusVkAN0vioTYk3zMsu3B/PamL+KwY6cqtZntB
	ZHOVD/lGC6ZSnlNUM9bVNt3ugkglZvDCa+pTuJXBjWlugPid4D52burnp87Gkz0SUU/t6qT8f9p
	2oBU/ItMiNH0eUPa3PYgswJuwI1uoQAxRAt3R3YMZfKMFHOCW5Jf/NVG/U1OQwtT7z7ODGnCOYf
	McrLYswNJHI2XhWmK1/WXPCsPbUTW51tv3ggj0UfCcKP22qqA2dLB0twWCQ+uwqOOugWABxmd58
	CVorTw/c4HPfK1dqcfc9d88RGUDpToD5dx/XQ0zt9b9m82EPfeNWOogJD15+owQvd0h3nLSZp0c
	+/NDh1mchGc+hugzEeA2B1GQAjvHg==
X-Received: by 2002:a17:90b:544e:b0:39e:35e4:d31b with SMTP id 98e67ed59e1d1-39e35e4d992mr25501a91.5.1789572589543;
        Wed, 16 Sep 2026 08:29:49 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35dab2e9sm28214a91.1.2026.09.16.08.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:29:48 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: pc@manguebit.org
Cc: linkinjeon@kernel.org,
	zihanx@nebusec.ai,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v4 2/6] smb: client: validate POSIX create context length
Date: Wed, 16 Sep 2026 15:29:25 +0000
Message-ID: <a1976857e250e714de562d67364e4b1ab6b5f2f4.1789478666.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789478666.git.zihanx@nebusec.ai>
References: <cover.1789478666.git.zihanx@nebusec.ai>
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

