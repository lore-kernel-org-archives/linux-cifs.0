Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CC745FFB0;
	Mon, 31 Aug 2026 13:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183916; cv=none; b=ZGw9TmC8QhH779ZvWYDIob4lsN4GylTWO/YvBMDtxF4e1J7aCQkj4jrDgvjNtXUdb/gTv2tnX/dBNFbCR31zI3s9k8tIf7Ke/svsuGc/xRjnYkUtenCjzaZXZoAUM8lAV3Y5pHGpvxfHuRuSBkLiAotpp8L5b0sXAQI9EIgoS34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183916; c=relaxed/simple;
	bh=exTccWhy7Zs9B4qVf6FHGfPjsrGQs4MNK0Vp0XT0H4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qQ+CNVnltlVQAmdCYxgOQn0lU2808OiGTe/8QQQZEx732Qoy1fyj4PDNSO3tCg7GluqBcC+eVrvAzfK0pfL65+NEGNx0KNTuptdtrMnHWzkZ2dRX3nFxApJk43VwPCAYgaJx9wkT8H+mlWQFyFODBWtnDp7Ve5qSS81l7VpjK3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SsHCMx8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SsHCMx8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E021F00A3F;
	Mon, 31 Aug 2026 13:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183914;
	bh=MrXdTamUip+Cdbw8rfhT9r8EY0j5OomJCdLolw91FGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SsHCMx8dgi9EyZsg9FtMP/23wySt0mkNL0wLjbwzKoteCSDsV6Zw2B76rNQGHUyjZ
	 HH/DOnZuKFgndhF+AWGTT1qv6HA/YcJ2edIf00Uieq10HJW+kNEyf7rmtib9ueKlCh
	 6KGiMW/H0K5G/dxVh9nIuXCyqTmdStOPStPHbSv4r2S+CQ+NsT8FUCbNYZL0Q2sOG2
	 ysRzj4NW2DxBVIiiX0DybGv5BMTzZOLJqhCQWFC2xNjtsN8EQqtS7oZeMwiKSvRsGl
	 KWBJnb7gNQkJjq0g1l99fsB+Aia5AYlWmFeUltmLpVNatFAtYhXpEpzYUbQyg/GahV
	 fIystmbCssrMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: fix credit charge calculation for SMB2 QUERY_INFO
Date: Mon, 31 Aug 2026 09:26:46 -0400
Message-ID: <20260831133314.4125787-378-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 284dc80ff529a0b454f11b6c2fea0d5daf6f315f ]

smb2_validate_credit_charge() computes the credit charge a request is
allowed to consume from the payload size:

  CreditCharge = (max(SendPayloadSize, ResponsePayloadSize) - 1)/65536 + 1

For SMB2 QUERY_INFO, the server must validate CreditCharge based on the
*maximum* of InputBufferLength and OutputBufferLength. ksmbd instead
summed the two lengths, which overestimates the required charge.

As a result a single-credit QUERY_INFO whose InputBufferLength and
OutputBufferLength each fit in 64KB but whose sum exceeds 64KB is
rejected with STATUS_INVALID_PARAMETER, even though it is a valid
request. IOCTL already uses max() of the request and response sizes;
make QUERY_INFO consistent by feeding InputBufferLength as the request
length and OutputBufferLength as the expected response length so that
smb2_validate_credit_charge() takes their maximum.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The `git log -S "smb2_query_info_resp_len"` search finished with no
results — that helper from the fix commit isn’t in this tree’s history,
which confirms the patch hasn’t landed on this branch yet. That’s
consistent with the earlier **YES** backport recommendation for 6.18.44.

 fs/smb/server/smb2misc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index d8913d2008748..efbbf7ea48094 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -262,8 +262,12 @@ static int smb2_calc_size(void *buf, unsigned int *len)
 
 static inline int smb2_query_info_req_len(struct smb2_query_info_req *h)
 {
-	return le32_to_cpu(h->InputBufferLength) +
-		le32_to_cpu(h->OutputBufferLength);
+	return le32_to_cpu(h->InputBufferLength);
+}
+
+static inline int smb2_query_info_resp_len(struct smb2_query_info_req *h)
+{
+	return le32_to_cpu(h->OutputBufferLength);
 }
 
 static inline int smb2_set_info_req_len(struct smb2_set_info_req *h)
@@ -310,6 +314,7 @@ static int smb2_validate_credit_charge(struct ksmbd_work *work,
 	switch (hdr->Command) {
 	case SMB2_QUERY_INFO:
 		req_len = smb2_query_info_req_len(__hdr);
+		expect_resp_len = smb2_query_info_resp_len(__hdr);
 		break;
 	case SMB2_SET_INFO:
 		req_len = smb2_set_info_req_len(__hdr);
-- 
2.53.0

