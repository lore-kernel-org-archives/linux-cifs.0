Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795824557;
	b=gdz80PbL89WxEn7O+CefpT0SEscqAyylknRsNYvj6fI7MOqecfLJNAQPJUHuQlTWiMVp
	 /5qNQedGQycoeQlK0PIQ0NoKmQ0MDAVaMCxnCyu60Oi42BXV6LQB+AhBW9krYD+7UeaCl
	 vhOL/ay54d1zeVUEQzz1w+PbqnlgxW5Q1ZKv1rtqpQ7zKUJ6czLzb7dixwTSU9/ufwah/
	 hO0mjAYF4Vtss1guPwbx2KXiCKOcpfw9lshFwwPVAiYOe3S5H6E0GKEclUGG2sTspn3yh
	 BAldNI5Q3EkvQ2A0LtQ+web7eTY86dVKweWW3oKVX/Us+K4B2eaAmad0f8TI4Sszj4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795824557;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Sa8dy2gzyUZnZppsvzVqeOCYAx4nZ2Xu/h/+7vp+Af8=;
	b=wianPRTNrpPWD6bNX/0sP5/PDfby4yspLDqW+MgvZqA0OliN/En3ClDVR3I2P9phe30Z
	 jSJZoN7qKX1rOdpZjs9+P6bjR2NTnim9jGOK05ayXIAq6aJfuZfFI9XSNZ3FV8bDF+Pjn
	 Apx6v7nD/l8ClpOiClkzT6grYwSiykYk0F4f+8Gr7qOYRBEWDyCe/Sfb4mVH6Y0J9kjSb
	 6D72Nj/CMNIUzgPNfn8oanaztlAyn85Opsto2oJhFIVm7Y6Z+Z7jjkwKebhOET8R8haUf
	 CmwiE5pa4btD+/jqFEaF3rTchyQhVhaSpnWnTKXjHs7RcHm1M6r6fI5AOEdokeITwNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=T1A6FV5B;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=KsPPcN4F;
	arc=none smtp.remote-ip=202.12.124.158
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516C2606A31E
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 00:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 516C2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=T1A6FV5B;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=KsPPcN4F
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8EA227A048E
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 19:09:15 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 27 Nov 2026 19:09:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795824554; x=1795910954; bh=Sa8dy2gzyUZnZppsvzVqe
	OCYAx4nZ2Xu/h/+7vp+Af8=; b=T1A6FV5B9ZAmuOF4r4uY0pi7oKYPnWUS6tOMK
	ZoaHBLtWHKjqztaeijKJALQwo00kEdnFotcBMvaS+iGDamPAYcLvIvhbvRJeO9UG
	BkaLNd0y7NT9mCkStagbE+W199IvIc2E5Tv1NEug7tv0uHJxQ/ZE4kLZYVtRz1Ke
	ph2Hcet6GvwE1iRjij7FH4/AjXT78ShXCLUQypKg6esp/D3Yor0VCzlWu9xxZjZp
	5XU33NSV2FP4+DeE+jJu/mEjzMhbUo6kYateOvRutelHlVklDWewyRsk0jyRJqFi
	5s2PnIil8StrQcoPr+pUiJLxrDY7tH9jGDfG6FrgPmjsexEIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795824554; x=1795910954; bh=Sa8dy2gzyUZnZppsvzVqeOCYAx4nZ2Xu/h/
	+7vp+Af8=; b=KsPPcN4Ftu177Wdlyh3eC13g/rINfz3wxf/IEmHscMb2yANlBur
	Hq7mDUBmsYpeoquV0r/Hbn1BBdkDrFXKZO6hu+linSEQbundPhkIQzScZwmZjIOm
	DoC6vAiaFRWPV3+Yw2LwrrUo9U9U7IRkAM8Ne9pnLJn7QvjrazT18IxgiXbMYRCq
	7JfJnfCzp8+OOHR0cpoYkewKKrT9hGZzdDvQzMehocittTFCxKMqmJ9Jcx/qgQYu
	RLBsvJP7IAQ33oH6WHST2WW+NASt40agxnvILmW6e7Yu6ROXpT3L25/xkq4RRg8i
	fhz0MHiU9Iwf42Coofi5MjvlDf1ZhcOnlHQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795824554; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:u6PGYG2o1Uw4mYS1VGeAXFME2Xy8GmToC1r4nGRl1Tq0LOs
	9IzAbDlFQDGnC1vLCkJmEBVkLRZLUrpVgWO0H5xisJ4RlHKdOlGAOVN910wiqsTZ
	+7V38RcdJu/37cltqteS1If0NYgC6//FBUE40ohb7aylzUT1DXlcaM6DJmOvSnwd
	FC4HNw49uvyKHVxWbEv5dS1pO4lbHDr4g4XjCSHxThrhPePyLFly91Nps2lCr7+j
	V8ZGq6OL1XDxNTSwJjOG4FUqeM4zxy+M7WVBq4DrtwNPsj80AmL63oezXaaiKO70
	xIN1b3bVXZCPv8PHlxLvOad8hJ1kC57IzG1DSaw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:lNaQgS6PKRWq5XvjYVXhUvc0+WTrpRPDbe7BAWW76iI=:g1eBuwrI6oQrhEZUM8JEaFdGfWjWgiARQ1oL20oR+0A=;
X-ME-Sender: <xms:qhsKa2uaMsM71cxKI30vOCYsvHX2IJqY4Jg_fZE7dh_Ho0ezxVNHyw>
    <xme:qhsKa3ffo5icje0kBrEQT_C8zM1vBnVAssc0nH2V9WI-UFal7fXqQ4dClFltCs1SN
    CIO623VnIohm6F8uzZV0Y0ENg2zUm6WPhQClw0UBQE4Ix6bQYaA-PGg>
X-ME-Received: <xmr:qhsKaz9gAu-ZYgz8wNCvOxRY9zhD4GSh_5i68FvGohYHUKd-dpJUcaBkLlWyHAmo>
X-ME-Proxy-Cause: dmFkZTFrh38SLvK3uQebmd7Gos4B4RHRqfcOE0APprEz5Fhl2rY5GR+9NC3Rh/mg72Y7v1
    xvn6UOimGhtPeBv995mtrFKXFZrl84I6m7Wr2YYiUrRTrj6L6fI0Dhdqp0t6UGoBuTPB0j
    1bbNdyHSdthr3L5IWMAruGT7vHPoHbUuLPJcXkIoWvjSKTYsVpKljPV5XcrA7ydZKGXb8K
    rnpYIvI2dD4tg+8XzEiF6uTLOPwKAB4dnYsqw2rEc5dZ5OlRfA41whLxPPIAFsfAX2Nl2Z
    2eK2JPIVtz4pcwHND3u21b/nfY56WB6lCOZhcjWHH4CFYvYvRVgjmC4K9RCJhani7Y/IJx
    CozCeSvP9frNjeAuHkY7gLiOtJab6dTzKx6Fp/3QZUcT19HnIMbBp9lFuie5fGyw+FVqWA
    NRfPNfxaf9aCG8/C1RciADhmJQIfOmYi2GMVEgmjVlR3LmtjBaT7wP4agydGAzLw38j6W4
    Bo4uykpP0DmIh+QEd/FnA95nrMpRQx3Yo8joXfD3jC4ryW2+ApBmmTEejvdGIR94MxmiK/
    N81lcg/FZXO8e9mLOspIjCsrD2njWxAB5lpYBGq+qyk75B1/XDSnP/5MTjSGZJghkUZjy7
    HjfiXmrz7C1SwRoEXXI/tGk5JGYbk7Ud1s4CM48o90/67HWrF3bL/5kR0Oqw
X-ME-Proxy: <xmx:qhsKayR1Q3Ves7iurqehfycGvdFLKYzyRVHf1RwpceMzWrDkbEMntQ>
    <xmx:qhsKa0oNRUX_K3jiXB_re-W2f1p4Lcrh-ScYwn9yw4RKlBR1ZYbY1w>
    <xmx:qhsKa_nZGwL4uwAqVeXkqOa5-DsDpQwZS0X8OrNjVoS7Gk2ACWkipQ>
    <xmx:qhsKa9e0vUzmOi7AsUwF2qo3OWvFq04gH54cnQnRRlVbTuUfXnWdlA>
    <xmx:qhsKa32uhsrUpooiHN2dWPc_pKETo_UYHxetT0riRbUpnuoYFBLYuX6x>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Nov 2026 19:09:13 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: don't take an existing file's attributes from an open request
Date: Fri, 27 Nov 2026 18:09:06 -0600
Message-ID: <20261128000906.1677969-1-icb@fastmail.org>
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

When smb2_open() opens an existing file that has no other open handle,
it sets the cached attributes of the file from the FileAttributes field
of the request. MS-FSA uses that field only when a file is created or
overwritten. Any other open of an existing file ignores it.

The cached attributes are shared by all handles to the file. So the
client that first opens an existing file decides the attributes that
the other clients see while its handle is open. Stored DOS attributes
replace them only on a share that stores DOS attributes and only if
the file has them. If the DOS attributes are written while the handle
is open, the attributes from the request are stored and stay after the
last close. ksmbd also bases its own checks on the cached attributes.

Take the attributes from the request only for a new file. An open of an
existing file starts from the attributes that the inode implies, and
the stored DOS attributes are read as before. An overwrite still takes
the attributes from the request.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
Tested on ksmbd-for-next 3dcffd93d4da with KASAN, on a share that
stores DOS attributes. One user opened a file that had no stored DOS
attributes, with FILE_READ_ATTRIBUTES access and FileAttributes set to
FILE_ATTRIBUTE_READONLY, and kept the handle. On the base a second user
saw the attribute and could not set delete pending. A creation time set
by the second user stored the attribute, and the file was still
read-only after the last close. With the patch the attribute does not
appear. Stored attributes, the attributes of a new file, and attributes
set by an overwrite are reported as on the base. smbtorture gives the
same results as on the base.

This patch was developed with LLM assistance.

 fs/smb/server/smb2pdu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 28fb77bcd3dc..c375d5c71231 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5484,9 +5484,15 @@ int smb2_open(struct ksmbd_work *work)
 	fp->change_time = ksmbd_UnixTimeToNT(stat.ctime);
 	fp->allocation_size = S_ISDIR(stat.mode) ? 0 :
 		(alloc_size ?: stat.blocks << 9);
-	if (created || fp->f_ci->m_fattr == 0)
+	/*
+	 * The requested attributes are for a new file. An open of an existing
+	 * file does not change its attributes, except for an overwrite below.
+	 */
+	if (created)
 		fp->f_ci->m_fattr =
 			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
+	else if (fp->f_ci->m_fattr == 0)
+		fp->f_ci->m_fattr = cpu_to_le32(smb2_get_dos_mode(&stat, 0));
 
 	if (!created)
 		smb2_update_xattrs(tcon, &path, fp);

base-commit: 3dcffd93d4da3b3231cbb845993194342fdd2150
-- 
2.47.3

