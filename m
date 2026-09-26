Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7623939B1
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 13:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790428942; cv=none; b=JcX0G5KoDcyCyHvdYCFiYgzVVmTdiMMmK+SBzZ1Y+RMCwdbdl0eutwsWEo0xloE2WkfUcCWnrIUSlv47+i9QMTbS7SGd5DpFB8xDO+E5/9sjgoPLysic+pc+o5eDYTsAZFZKHkOAU0qhPB9EgFXOT9QYzgCfos4iyxgO6LTqjDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790428942; c=relaxed/simple;
	bh=8rgTvvwDFSaspEHo+kCgQNZbcI/BJZf21gNZIv2AIRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hdYb1f3o2AO+RkVakwAkoP4f5AjmLWahC2URKfg7GEkPYQOMM86THcLV3zPsmXUJc2jYbXMSuBlbkTYiUY1tg/uJ5BeqTjP2dU52P1mQZ329cK5ruHEwdfxuuR/Ganb137sPTFXkZ5gI5DxUWW0ItEbZ0AltxlY3FRG5igms4YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=IoYrGoTi; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="IoYrGoTi"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so907992a91.3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 06:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790428940; x=1791033740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WY6jVhJ1QtI7aO10MKO0OcssEc831y4vQM9w+i0byGU=;
        b=IoYrGoTi6aru4z9/uiV1wb5/qC7Q0A21ix7UNXoBu9FYgU2RBHjFmFtcNtKLUkGV1w
         S2VijHZiEk8TefWyF0w3KWsdYCoslzg37jalrDrUyGXX0+oZhuacBQk9M3bM6OSH/Lxp
         3+M6xb3nObn4mxHxJzy48yyFtCvIVDM6RU3y0QkB6iQQ3LctdabJcs0qF7L9rAqeLy88
         Df4TB4oZSoSxlJuoTg+VGzoXXqk0FNrqb14shOWd8e+5P60wAAZ83Ng/DaC+MGOY2Xxx
         +l40q48wcJ21E6Aazf1Dr0xGYGQMgURJDnQ4wKDMHnwfq6tEXNTEqOQrPCpgi9PokdUM
         Ldtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790428940; x=1791033740;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WY6jVhJ1QtI7aO10MKO0OcssEc831y4vQM9w+i0byGU=;
        b=QNZY4AXieAKYocw6BTL/42cFcYSuzn2kMXY9Tu3rq9WlA7XnAvJShhruhkqgdyNZfM
         5evY/i6tI1YXpacbUui4G8HFtcSP+DBLUB7eEBrsE59kAn8u8WThKUrtEaa8zCiGkWRU
         m8fmBNYOgZ2XjH+CF5PYCMNWpwojebjFzBXuBM+Wdcll03hJz36vDamg5Gx/OBrhM0Vk
         oJthHKtjzvjB0CiGRiJPdTE7IeTyJN6KrvEMojCU39x4boIdvXLBin8T3TiIMzSFli4X
         bPYzNoLSIH0x2n+W4dQvrQBbtDaYgh60zGTS9bMxfgXgFtBSsGUXlyL6ao+SchjU9JXH
         Llcg==
X-Forwarded-Encrypted: i=1; AKwUvBwJ0UUVuXNzfDWAEVPZT6OG0CXgyxvu5csXaqc0kbhWPFKIXl/mJbAMWhaxeuFsdFkqlx2qnrTWjokm@vger.kernel.org
X-Gm-Message-State: AFq9FYL3QX3Gq2r7WMsgKhV0xrNKkhXH8ngk8ZCUDHotIHvcJlb/mNWR
	7JdwQOSu3ntlNdonOkj+yjlpdC1JtxtLcc9M7srhys5f3eURvBOruYXnJ2PQXYAKTuv4
X-Gm-Gg: AYBFou2f8X9y6Qbpw3D2uO20OD7PZm/jTrmkLVW1R0ZWvFq0SgaquvuGttVhCmLvMMY
	djfNBtMwhLHIYZs/urt0u7O0KSdltuarZcDuqDiy2GYGzYOvpTLn5SkDPiHWY1Pm8H2bkPrhokG
	5fBy/aA3EHWBBNTlXMSEk0d3PA1EFjqpGvsYOVPVLseu0r2V3XSh7zG1uvPVz9lbVfW29IVt5Nn
	cy1LdPSq/nMb7Xza34xvGRFr2IFM0AHs/Os7nT4oLYKANnxBzF5FhMg5cQ13xte5PiAE67zAadT
	+UWfcdNtfPrYfbzB7jFzuWSWNyaIBQA5vB2JVCQlPXY6mGVG3thpOYTwrDqlFkUKFF1WyU0y69V
	PE+atHsvJLkJ7mj0Pq5QL+wsqSZfT9L+27BA0ftNhhAmMnEG1lKXRAQciGQ83hdAPWTWft8n6r7
	C7vwM4jwNvboFMy/OZ6IU0FwgSo6M9T2SbnAXtOqK3eOkdWBD0AmfEFLwc/HDm4cBYNV5xhsd1A
	4MKND49YjtSxi6ps60A1Sx+yTdfKw==
X-Received: by 2002:a17:90b:3dc3:b0:3a0:ce5f:e292 with SMTP id 98e67ed59e1d1-3a0ce5fe752mr2448333a91.65.1790428940028;
        Sat, 26 Sep 2026 06:22:20 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm10619253a91.1.2026.09.26.06.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 06:22:19 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: pc@manguebit.org,
	linkinjeon@kernel.org
Cc: zihanx@nebusec.ai,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	stfrench@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Luxing Yin <root@tr0jan.top>
Subject: [PATCH] smb: client: avoid NULL resp_iov dereference
Date: Sat, 26 Sep 2026 13:22:08 +0000
Message-ID: <20260926132208.23360-1-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

compound_send_recv() only populates response vectors when resp_iov is
non-NULL. The final pre-authentication hash update nevertheless
dereferences resp_iov[0] whenever all compound requests complete.

Guard the update with resp_iov to match the response-buffer handling and
avoid a NULL pointer dereference on callers that do not request response
vectors.

Fixes: 62432a3f5145 ("cifs: Clean up some places where an extra kvec[] was required for rfc1002")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/202609241449.HlHmnZFZ-lkp@intel.com/
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
 fs/smb/client/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 6e21b5f8754a1..307bd82128781 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1111,7 +1111,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	if (num_processed == num_rqst) {
+	if (num_processed == num_rqst && resp_iov) {
 		spin_lock(&ses->ses_lock);
 		if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
 			struct kvec iov = {
-- 
2.43.0

