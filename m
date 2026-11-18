Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023301;
	b=KtfyqPd9YU69SRvCfgTAfyuz0/W7+G4KmIA4ZE7IesbLQRFK/xMZBE0re2mhLH2XWibf
	 XZ2pW50SgQZC8cSVlwH9Pdkp7VOnK1JAOz08nenXGl2LRPzNnFYwiIovIig5CZdFY9ZJN
	 kutxlyKuKhtO3BuCVzGTm1Gn7fdRfggh/Q234tFJY4jmcSHKDDKhm6klfYMLeQjUC9/rc
	 xhlo6q8MVFJbVrKR4bXp8k4njAr3MDBPZc9ClmDwuS0lBM40i35Vit1wvZ91kKIBfqOVD
	 iDjQacqPqfV7XZY5B4CuDrwkJlD8+usVZb9Ne3qeQ7f16r9C20Q0VbcLK5S/3VqGIxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023301;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8fZ/Kxw5ysHvm1gRaGTc8BKvj3+nNehSTXXJUGYzQeA=;
	b=b+k7qQBa69E5/tZnc/TLRVuOs6wjWCDw6U4/wYY4Ggw1hjKYsnpo5J0So77kggxq3agB
	 r78uTU8Zyf1ZQaLn9W3RW5X9y8K4vNT6nOC+oQo2lFxSJN27EW0Mb3k3/d7YUOJmnggZL
	 CL8jruvdIPdoahwn1Jf0RRUM8UmEel/s8lhJmIemGjkedKyCHoKqOeihHnQm/bLj1nEJ0
	 5n0kNXC3fOr45rTZ/XEMeWX/1g4EpldtLFfP7oxnUFlCkFKQp8Vw7oGoX1Dy1/GEoh/Nt
	 /1+9KUpvaQHkvd2X8NElmO0cK2MFjoFcfgcfb6/7ILspwC15l9G7d7YvQ1LJRU2Zsag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b="s/xXDjYl";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=f4Rx2On9;
	arc=none smtp.remote-ip=103.168.172.152
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED0A606A325
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 17:35:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ED0A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=s/xXDjYl;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=f4Rx2On9
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 72DF0140017A
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 12:34:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Wed, 18 Nov 2026 12:34:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795023299; x=1795109699; bh=8fZ/Kxw5ysHvm1gRaGTc8
	BKvj3+nNehSTXXJUGYzQeA=; b=s/xXDjYlX6j6oLIXXm/RXaGxPhJBT942EhSVa
	6WlFozTgMZnTnaDdqDpfsOD4SdwCCxarC6vCcpqXp4r2zHmy/8P5WbmC5sakf2LB
	lSWpmWlpCaVtedWz4DM51gSOT3cyxJUeg4tSPSbY3pgflnrX3GH0ZPPYbQH/t/7R
	uZOPbiiLyr+QdrMKaXJ9wfAN5llYXzAECQpcuhKUIeWZBn3Bfh6DHetsvgS/x/iQ
	jOwAYrUSDgnDwvw5mkeyDr25tbTzbRVrxjJRKKn4OcTZsfcMcbQbJeX6NWt9RmL4
	8KHyX/XS80ruJXWf7WpZFdREcOTZBGrCN0lLTdPLp636PFBDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795023299; x=1795109699; bh=8fZ/Kxw5ysHvm1gRaGTc8BKvj3+nNehSTXX
	JUGYzQeA=; b=f4Rx2On9nMnBWwQElfC7PUzLSsx1wjfzAhVOFeWpBm7g/TIcW7U
	VahVs3Q53dhARhph+57xZVuh9Rttzk1M361qgcwgA3BlDOpclh6DU3+45Wf9T8fO
	aou5tUeujNktENbv7XlrvDZZL7jbKip1T5jfHHSu4a1w4/4nQcTZHXK+4NB9JgNB
	N4sVbsrFpenWZizgsQ0MCEQldkVVaS+8MWuTEa8m4t7kULpGjHF2tLrINoDHK2s9
	bgVyvlXFf8DgOIfU6m7Q1BXe8p/H5ooTV/YRt+1Nf4Zk5qKDdISYbP84tczHCwN5
	euwGJ3HnM4y668G42aCRyhwz/30OxzyGRCQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795023299; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:QOD7szqttB47J0X9f8kCu6An3niROxjnyfNh/tgmR5I6LeT
	rvL4P7ZSQKwVSmwiv6eyQQ1+xhc5bmGAMmv7403mkfzOKLRs48JQP8va/Lpc1Z2J
	LQ5jLmV3HVMp/QwMSN5/P3HsTLb+PvYcp3Nqa1CoJC7tkSuXenk6eCjdF1TB6uc8
	NzjuoTYFkcWCHdy9rdBrN2AGu7vlr8BE0j3msQgPmo7YUBBsFt1WXwOSURiSJRW7
	+m5tnU9O1tO5xS/as7GdR4NtFVpyyir7c2xs0p8NZ20OcERdesDBKEFqwxH0y4i7
	JNMxsuZ/g0uzc3t9wkEVlHmkZI1qm58j0rxGfTw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:Oq7lNfgZIZStWBBZNqx43UlZdX234f4ouEubo9qk+tk=:tAjl/4ejSE5QxYJY++DFPh+rZ+7sOuvFDDtilHFBdd8=;
X-ME-Sender: <xms:wuH9aolR_7aMHtktEStEcwIk7BrrcVpaDPbJzj2QlOy-gSNgZ3LNzw>
    <xme:wuH9aoSD5Fc9udPGhRXtoVrI8Zr_LYDeo3SAjH-BkarPGOlgYwPy2vozUN6FNhuX4
    eivmTXB-UgUgb74FMtSITholn4xh2Ie-30xZ0TknyAjktN-u9EXQUU_>
X-ME-Received: <xmr:wuH9anWTKzkT8-BEorbhSzlUXhwG2RFs2DjI-dAWsUdC9ZHH7R4AJYMZ4s2IGzzn>
X-ME-Proxy-Cause: dmFkZTE665ki3z6U4P9eZMFvamr17VPbNJ9oJwqirtbKiFZZVsgSXWFv+TLQIfjnq98VFs
    own32DuLKLA4btFG9+1UZ+G68Orv8JzrQh8vOuczU971+hKpxbY99Unn11GT48RP+G4t+c
    WQr4KOkrPQZEjVp0HRQqP+wagVLdA9vcV2653tZT3jhv5SIWfKIQ2dk1LumpTElDPYH5P+
    rqXyJ3tjgo8NV8hoJmEy6iEvwXjp+kAAiaB7XrTSTw6FEOQL76rCHZD3J68l4UaBsSWaih
    Vq45vGG7NHubxa6D3beAzL/JMpixr+FqCx3HlZrZZqqQNtw+iGamQ8vGg55rw63Q6wwdck
    Sxju3lHkTorTlCjLH7ZNuMi6B6/qnu0q1Me+70qQIroFhtFWYE1A2zWZTI+2EshUunPPoy
    4bmPSUFslPuqkkPSvizFySEBtgNWj19kCgkbUqdiEet+HXDPxkU9K3rJ6r7SFPmJDFuCbD
    Hfw8W+Ziwp0XmyVvfJG25VS7v9tnjwjlS0SrEN+VUnocLcsPnHyhSCBPoUy2fk5pcA9517
    JrmAxZqGsmmmUMeOL5qlZI4M41AjYr2OEKhYHrO8BXcnmMawGsENzjymhxRo2I/jJ7eyTe
    ABCf/uTODmn7y8JOG9NHbNy3o7NHao5wHjyNKX2L5CV6/MEr0xPEk0qlVyrg
X-ME-Proxy: <xmx:wuH9asLNsFtW-BkdVKpJtwN_ecZhjuQAqI4ONzxBBi-S8C78CAa_pg>
    <xmx:wuH9an0gokHtNZOD6uA-vBuQw-DmWyWGgM8NKLXPvDwGhwJecdActg>
    <xmx:wuH9apIk6ST-7xXkYTaY2PAEiWlqvzPqvDJ4iaUtknmGelcIPWy20w>
    <xmx:wuH9aiiW1dyHiXElb51ucnj2E200HfQVgWs1l8f9uWF--NAgC7wX0A>
    <xmx:w-H9al0OgwIQW3rVCngcfyBHGtZGIER3lzTSk0A_eOd6Z3L4ZOZ9o5mP>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Nov 2026 12:34:57 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	manizada@pm.me,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: allocate the security descriptor reply at its padded size
Date: Wed, 18 Nov 2026 11:34:54 -0600
Message-ID: <20261118173454.76416-1-icb@fastmail.org>
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

smb2_get_info_sec() allocates the security descriptor reply with the
size that smb_acl_sec_desc_scratch_len() estimates. A compound response
pads the reply to 8 bytes inside that buffer, so after build_sec_desc()
the query fails with -EFBIG when the padded length does not fit. The
estimate is not padded, so a descriptor that fits the estimate can
still fail. A query with AdditionalInformation 0 always fails with
-EFBIG. Its reply is the 20-byte header, the estimate is 20 bytes, and
the padded length is 24. The client gets an error instead of the
header.

Round the allocation up to 8 bytes, as READ does for its data buffer.

Fixes: fda9522ed6af ("ksmbd: fix OOB write in QUERY_INFO for compound requests")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

The size check after build_sec_desc() is kept. It still makes sure the
descriptor and its padding fit in the buffer.

Tested on ksmbd-for-next 267029b35ad1 with KASAN. A query with
AdditionalInformation 0 now returns the 20-byte header, both alone and
in the middle of a compound. Replies for the other tested
AdditionalInformation values are unchanged. smbtorture results match
the base.

This patch was developed with LLM assistance.

 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 29750970f8da..84f840f51297 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8510,11 +8510,13 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
 	scratch_len = smb_acl_sec_desc_scratch_len(&fattr, ppntsd,
 			ppntsd_size, addition_info);
-	if (!scratch_len || scratch_len == SIZE_MAX) {
+	if (!scratch_len || scratch_len > SIZE_MAX - 7) {
 		rc = -EFBIG;
 		goto release_acl;
 	}
 
+	/* A compound response pads the descriptor to 8 bytes in this buffer */
+	scratch_len = ALIGN(scratch_len, 8);
 	pntsd = kvzalloc(scratch_len, KSMBD_DEFAULT_GFP);
 	if (!pntsd) {
 		rc = -ENOMEM;
-- 
2.47.3

