Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795071420;
	b=pOCz/JvDyYHKHvQk3n5cDaH10Hp2VReznInyieZkxdSrjiaA9w8XVaw7i/0A3clNaMso
	 kXMh9PtORTvdx2PwQQsXGEcGpggRuN3csHw6NVp38yls+gQE9B4m+d1wOLBzGTtEvk43G
	 ngrcWDd7j0cOsrJoiKGZGG88mzprAKB4e/uD1AXolkKR5mlZO7d30YkwfrDQ/rDaZPyaf
	 8vFXG6JBcHAJd+t+/wmuy56LpA8IuwlyIMd5q4/jFK+trqr9F8srgIq5do47KEx8Qa2i+
	 KgZ+TAg5WL9cBfGpFDky6N8aDOnNRtzxtep1Rmx5zPIi8AqTTa3YW4hHBR47dNACXqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071420;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qej1/CHUhZwkwtfhOBDbH7m01T/a601vvQfVfLTMO0g=;
	b=eJ0UfljnOkgLMeclCQVNP2p04RZyuadLWkG95Iojh2zl5E9EA1sy1ix8EGVAJqFHyYKN
	 aSVAj8gtIyqMnIFH1HkJcGgvYbUBObNtHa84Azmj/soaQ0E0Hj3D5wZAXwopxns+jgWRP
	 q3FXP2byReN3+5KstzRwuYKrYxI7brruBvRv373zce1O9Vfz1x+nxJUcJ2jCaXvmzEPSx
	 CnzBRg6GCcT/N/tkPzi76M1gPDXZlGs0891RJiWMcSevm3+3Zad26q69aWygM/+hPuYdc
	 Hdsc4HuxxeDRytearjFqMKFdKxKi8g0RfvKWgzsResYiDOSX7IgU/LCBvILrfB8pkQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=C79bcwi8;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=tnhPTCHL;
	arc=none smtp.remote-ip=202.12.124.155
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D61606A324
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 06:56:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09D61606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=C79bcwi8;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=tnhPTCHL
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6B97A7A02EF
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 01:56:59 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 19 Nov 2026 01:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795071418; x=1795157818; bh=qej1/CHUhZwkwtfhOBDbH
	7m01T/a601vvQfVfLTMO0g=; b=C79bcwi8YyHKu2KZn0HOKWhhcT/RQ/q1z6xmj
	nkmOWL+msmKOW3FKDHIUs4bc8xTHzKQaDy60MxLiQx+PWNXpBf7tNdch9FJ3YM6/
	i44RtFWZkLD+roVys2a27yp15RqgRrRfbGqOw4RMupgbLCv/0FXV7zyd1ld1Wc8P
	3qed81cRjjCXFIDwGpPBCaltgRzup6fasLfQXJBVqDIPDjVu5JJnHNfl1G+LlYuc
	EKxfh2KyXUt1k9ygmfZbBKs5njzpvO9kamUpOuXB+CXFLN3gcuUejnkYpvr4igDk
	L2KyivFKVwrtgoLlthj/vdBbq9uFKm3+gV94GUPXIiC1nYF5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795071418; x=1795157818; bh=qej1/CHUhZwkwtfhOBDbH7m01T/a601vvQf
	VfLTMO0g=; b=tnhPTCHLihIRTnfnTwgEPTR17OwAl97jIKTfKFHWYElnqA1BkH8
	otbCPZOuXP8K+52+f4JptE8XIatqTiKx/9fsRNHWdNYSpvuov6K5G4XAKXtXyM88
	xp+8MccncIy8BueAVkG5Dk9Bp3czmuqP2HGt8d7dYpqFyMRq+TydK97ca+qWBpa9
	h8+ZBhTPIzfOzb+eYvlup34gLNibWqzXRNsw1orHrFHi2yTtBXYlqMo5O+7XIe2d
	Nwbpae048yilDRQZO2xiDdVJn0M8M5a5f6Rj/9UAS9QX7rHXHAwDsMVPpj5d3JHK
	U6hejJI0g8D8e3Gy0qtibp2vGh2+Y/o24XA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795071418; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:RSLTCPzN2EwypJYWrqFBuQZPOoeYPq1JCDF3yCnrfddisxv
	NItMBg3ahVr/Lg3uYLkEREAkejWep4A6qWb0A4T8AtApOYe1bS9SHSDDCqtT9VV0
	FtquPCcrbKLB1OLhLQTxocD0aoNz0Azwn7oqJ+QgHhYXy55lBm+RCfAnRCEAIIR8
	9DE/e+JBRvdXDoofI7TSRtNDFpYBvzR3LlY2nWTE79OM/+00Zs5PwPP9RvVL5B2p
	cOzS85mw161sEIsd6ceS41WoVAROV6vt8623nzwTbaiQo9iSBk3fn/zASvOFWuDT
	YCB+sw6qhqEyZX8yaweZPI9m6ST9KIaEwbKX2Rw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:9Type4bs5sGYnLrV2c+Fj4G4UrwAA394vJAyH+p3Fw4=:3GXWP1/asZ1BzgZfsPnspWQPC3190DlfNCgSqGNEjBQ=;
X-ME-Sender: <xms:up3-al3FFXyZpq8yJMtVQ89EhLgu2dZWP9sz0KLreeMHrDntZiVCvQ>
    <xme:up3-aoGUCt3CFBbEIJ_i3t8zF50am88o3Ie9whsao7cko8iwEJ6dApOdcrFpH-HNg
    P3N3KB1XKy41kZRHFUEmomV3diXmKp0fdSt_yxpK7TIV-AYwvFWnHpJ>
X-ME-Received: <xmr:up3-aoFxnOY_u9g29t1PPdZJMKSIkJTm96WWszuGSTTQz-5wRkhs-Vix1SWqKDyj>
X-ME-Proxy-Cause: dmFkZTEUeSj65Ijj5tNpWOjFDh7KBEQCBr9G5I8Llv6XdNa+Rju/WdxqTfnOW/rSoNM961
    an+qTAX4G+2CZIeC+1LaBq45al8NiB4rnS/Yol7V2iOkUIcRMdvnr5JxT+vbUY3Mn6yzla
    OZHhkRJNI+yPYxUaBVPnSOJr9zF7Y88xOgHDWLaVYeDCjkPD02OBcPHlB/ScO8Ci/hohqV
    l3NB5jAtBnvKSBLhHAZHNRPwiEwG41CCXO4NYuSDMLUsP+BUvWncAEI4d2BzDee+hr92YL
    KAzigc7oxCuYk3w5Tnj+h0Gzhz5NBZ+gHgyzhPxT9OYgDTJZQckAQ678SEV30h2/qV5BDv
    W2fYnOtNPeCc5D+FjKeL56U/1AQuw+H4nwqAWXHfyOLDN3KQ2QAUB8IbTagNXHCUQHw59n
    s8RY0lc98DVt+MJRiOJ8dMklQE20EgayKeXm8+KIiQ3yj/aVn+o4n5w9hLPndWzPIwES+O
    9raeDEmxnyXi1P6ymIBjHe4EI8yMf2TATbjJkC5LWK5tMrGHAf+0S5hWyIOvAjiuqhb8fF
    zWdt6bQ9xD5r/fgQvyPyOtien2AUb5NwqpUDhHS92CN+NheXqemaifREReFZIocDqONf/X
    mzOTtfVktxcdp+gusvBV3TgjM2+UwdHEMLpyYxWOPgHlKLsB4gaTeJSc7gdw
X-ME-Proxy: <xmx:up3-aj4aNnIHmOWHi1Fja1rCcAEHvzi6HCkEz3zW4fms7NU3kQNdiw>
    <xmx:up3-aly14rhpS4lhcfVB-tNcJcsueQWBsPc54QOYZ2THxWIXQ-SJGw>
    <xmx:up3-aqOV1G2OtYjq0sZpXeZNqZEg2AmV8MnAB8he32DBOFSq_4TX4g>
    <xmx:up3-ajlYuI9GDQMFNBguI1dSE4yMEp8Ok0lcMc0SHXLlj3M61EoBKA>
    <xmx:up3-ar_jokRD4C53r6gimDJ_2UTFuJZT446mVA-RQoWl6yZPTii0hexE>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 01:56:56 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] ksmbd: omit the DACL flags when the query omits the DACL
Date: Thu, 19 Nov 2026 00:56:52 -0600
Message-ID: <20261119065652.116074-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A client can query a file's owner or group without requesting its
DACL. ksmbd leaves the DACL out of that reply but copies the control
flags from the stored security descriptor.

The reply then has DACL_PRESENT set with a zero DACL offset. That
combination describes a NULL DACL, rather than saying that the client
did not request DACL information. The reply can also claim that the
omitted DACL is protected or auto-inherited. These flags are wrong only
in the reply. The server still enforces the file's stored DACL.

When the query omits the DACL, clear DACL_PRESENT,
DACL_AUTO_INHERITED and DACL_PROTECTED from the copied flags. Preserve
the other control bits, including those describing the owner or group.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Since v1
- Also clear DACL_AUTO_INHERITED and DACL_PROTECTED, as requested by
  Namjae Jeon.

Tested on ksmbd-for-next 267029b35ad1 with KASAN. Queries for the owner,
the group or both now omit all three flags. Tested protected and
auto-inherited DACLs, separately and together, with descriptors stored
through SET_INFO or inheritance. Descriptors stored without
DACL_PRESENT also keep their unrelated flags. Other tested query
results and smbtorture results match the base.

This patch was developed with LLM assistance.

v1: https://lore.kernel.org/linux-cifs/20261118174000.76954-1-icb@fastmail.org/

 fs/smb/server/smbacl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index a87c22fa9a6e..1aa29966953a 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1077,8 +1077,14 @@ int build_sec_desc(const struct mnt_idmap *idmap,
 	pntsd->sacloffset = 0;
 	pntsd->revision = cpu_to_le16(1);
 	pntsd->type = cpu_to_le16(SELF_RELATIVE);
-	if (ppntsd)
+	if (ppntsd) {
 		pntsd->type |= ppntsd->type;
+		/* These DACL flags are returned only with the DACL */
+		if (!(addition_info & DACL_SECINFO))
+			pntsd->type &= ~cpu_to_le16(DACL_PRESENT |
+						    DACL_AUTO_INHERITED |
+						    DACL_PROTECTED);
+	}
 
 	if (addition_info & OWNER_SECINFO) {
 		pntsd->osidoffset = cpu_to_le32(offset);
-- 
2.47.3

