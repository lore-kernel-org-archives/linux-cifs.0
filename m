Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795830003;
	b=EXc+B4jBwxI9K7lRvcD31920c2O71BPSRjhLZrEjMvM1EsFG9di7BZ0aeaXoIw7iRyHh
	 R9N8LY/Nv7uHJqAehp2d8yF/UjzXoB32klWgb/fWUxC9RDUp6ISSpFMG/VTGCZ63BOM5F
	 +M3cHD2v7Y0UxJtf8h5BiphFMCzJ2RoFlnm/BFhzscWfh4s+Qh30/Q3CMWasaRKvmxDr3
	 yAXt86HU8p2epbqp6L9m1cO5TN/yYZIS7J/L+M2QDVhIohm+2rWGaIN6GrrqpZ3XKcL4y
	 9M8KdFo031eCdyfvV/FX/Ktxd+RDhPAefP/ywwK2MbpfOElUDmPljQPvLvReCiFG2Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795830003;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n+kvE27be363NyxQQHbSrK8teWAh3Otp3BVkAILbX8M=;
	b=XyhgSL2gPbZM3S9oxaWZWqqSHhMz6S1gBgzO4/7KRPGO0Xq/tvECynpjjsU5JIYaHB7o
	 BmDLXFJ6ruKLAZlrCVRyMgNLF3kiEetcnmdJtPhDqNtR5bjhRJ9bRhjeWAvxQOichw5Rv
	 l4d02e+fTBzy3FMZT4EI1Z9LzAtNEHvIGcL/j3gXVxtLRqQNg8NsZryGvJRc8OBB5KXTb
	 Nf1+jIoI0aoT7HSagEpBi9/4MlrdyyvE8YRIY3JKALarYOdPojk5OR0UllKxoBnNpX6Eb
	 c1zXqsXqBzM/jwiRql+iABdQ7Jba52IpOGTLdPGtGAOdtQ16Iv2vipUX1SL/XfOZ/vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=PO7JyoAF;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=GJDwgd8O;
	arc=none smtp.remote-ip=202.12.124.158
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27B1606A321
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E27B1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=PO7JyoAF;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=GJDwgd8O
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 22E197A051B
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 20:40:01 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 27 Nov 2026 20:40:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1795830000; x=1795916400; bh=n+kvE27be363NyxQQHbSr
	K8teWAh3Otp3BVkAILbX8M=; b=PO7JyoAFO8ehW3MO8OL8nNgyz9TE053qXrnxN
	JBDdAaoEGTXX60EQQbv3uJaatP0ljh4a1NI5qlscizl29NFUtTjsnM69GuKZXAwC
	N4mCU3gdEcpAWcu1F5bOl4YGDRbYhEBtwlFQrT9Vpk+XRgpGA6D0xBNNk0NvbWr1
	kWRQ6oHlsK0QqxqTrNdt6KDdEmK1ouncO3hbOpo/Rz4N6ERHpaW5wRtaOBWCyX1K
	fKoriwPh/ImbC+GFFm9M7sgx5+Dh3jaE2SQhSOBJNWIm8lLaChY7EKI6fAxEtNA/
	RCB5WIH6+Y5wWcC4oL4P4HOQuLXqv/ej/dwLWHVoM4rg8IqCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795830000; x=1795916400; bh=n+kvE27be363NyxQQHbSrK8teWAh3Otp3BV
	kAILbX8M=; b=GJDwgd8Oe7uFCl70y6wJW6QTGIvNZSZHiFXpmfre7397NuFB/hk
	C1Yf+/fQQ5Fli3zMk5Zme68YKh1QeHtX/8fvMtUM9b1Tmr3JNjRFPbDC9B4ySiZh
	KDLqxq90mCpA82kVcVqbGyTsjYFRErsFsqFoZtCE2PsVgEVu9EMKURENnC5nm5ma
	N3miLqJJbon2Hh4DmgXjJwVZ0q5uKul3CtiyFB1z9jsdmU282eRPlj/xuKiHxWOd
	iEaGqWxpwrgjZKFgJrmwnlCFsOHjyALZlFCz19w+ojA0yuq2CogG12xpQ+RdUcON
	nKkKXl1mCsN8/nlwkiJji4kcJtMrpGJsCDQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795830000; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:Ben5PZrYiioUd+Z5rAT0YIz+2y86noLFZvtjIChJHQCSW6Y
	cOBdZzxqz0XIXzOcHy0/+Q78YBrbEsoqDuE859Ffr22kdOydZasEgqU/OOmXdwGI
	+0CL1xylOrhsSJIgz7UDjv1Ylgd3bRPEWj203Lw5bgtZJjs8O95KF4QbEcUJUtTE
	OKlF2gRIRiezKPFsexoHX9+y7pwXpoYz3zvhm/LOOJUUvgmTMNBDSqeseqbkdT/L
	VSHhg737UjOho2oC5seyKobMT/5C3lSRA6L/HoBmf264BYA0OL/uikkkY7b+Eybj
	mJHAP4sWBzjelCC4dAljZ4Nocf7zHFhnaNI5u1A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:aJMZ5WVaHzprxUhtUbXWb5dWepoEU+OdYw08M5fbNsQ=:mT/wbfLBkMxa3Yo+pafoy4G0U+kURieWsn7M7GeCnj8=;
X-ME-Sender: <xms:7zAKa5_Oncp9Qpi63MPW0qUBXtLVmtlfqzsQ16-CpLy9ZrEXnWtlGQ>
    <xme:7zAKa-ZBF_gQDVv83bIOr4kJ4YJcLITL7EM6Ejn22N9AlPoI81OjDP-HfVbvrvzUh
    DMvTB2jVZbLT4mZyywvlTYey9h7jm8sWaP0gJoCxaJOggMjiasudQ>
X-ME-Received: <xmr:7zAKa1OH2AK_ceI-rDVGhyHPdZhAcn8eIcKaHTY-ZrIGucFDHF0SBEl37cg0_aTH>
X-ME-Proxy-Cause: dmFkZTFBcALkEyB+Y09OQP87bxuTguYHmOTlWsEL/K6L4WhU/r4VziyS5xZ7Y9xwTF3IQV
    U+VzEQa5vtc/R1zlvtsolYtOqHFoLSTxNTFzcEGAz9GwQFcmsUwWgr2krXjC5x1GSSPVMB
    xtOCK7La9hTgSS6RRW4KEEcQGEafHhf1ZSAxiZjBBtWuCDNbWjdIg7xxZHy81h9Vzkd2BP
    nHhdhPlYPApyhrmlAJBXnrsLCArzXGeA93H2lc/wbUeXfkCd2PvGa0DWjjzV+z4H8JqSWQ
    EV3Pqmwxd9LfzFkiGVC+/7mBvh2JMGQSxJ9TicHQZ8gUah3ycNREeNsSCLwwilzEAHS8Dt
    6PZCNn2W6jMWQgMijr/qeDggDmVjLIMnhSX/FoPBul0SqmjMgu+sWw6z4Wo8vSooaafUil
    hM9H8u9KSj9Ny2yTGzogX9agydKtMaUFM5IQT68AdmUpv2AdO+KL3uEWOskHMOm6Eo8S++
    687ZnV6ImlvxX44h+yoLjerKWAgZFbjrnte2Lal3n/zkDJbA/kJVMrAqr437mVuVv8cMuD
    LOobk4/CAOu76qBDpPl8eTn+TBRiEqRCyWMlhBDQspZJWSTXfRMQJMvMZjC/amFSaBBHrm
    2XV2+VPlwFECrHwVlRMxEIy2Oq+u2+p7nDW30pSe/kDYDnk0TAl4qz2dLOcQ
X-ME-Proxy: <xmx:7zAKayCQl8yo6joDDaDIuid7uCo54Mwv5jFGh7SBhCoHG9h8Q2q_2w>
    <xmx:7zAKa0J5X1nCmNv-RJPt2ZY6YPlz1JVV_M-AeqBYOV3ShMfkqUYX6A>
    <xmx:7zAKazPo2GdxOizvLe813TB826ULPRvJUjwNipAYFjD9-oYnVq9Gsw>
    <xmx:7zAKa65tifTqINelpTWXKaeWGL_HFFINGXR1pxdhdm0_eFPM1Upymw>
    <xmx:8DAKa4TvJwXds8IFPaQ0YouenDl-Scz0Z3JXCVqKY9Ws8HwRd7sF61ED>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Nov 2026 20:39:59 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH] ksmbd: return the cause of a failed link
Date: Fri, 27 Nov 2026 19:39:52 -0600
Message-ID: <20261128013952.1691873-1-icb@fastmail.org>
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

smb2_create_link() turns every error of the link, and of the removal of
a target that the link replaces, into -EINVAL. A link that fails
because the caller cannot write the directory therefore returns
STATUS_INVALID_PARAMETER. Return the errors as they are, as
smb2_rename() does, so that smb2_set_info() maps them in the same way
as the errors of a rename.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---
Tested on ksmbd-for-next 4543a3349127 with KASAN. A link into a
directory that the caller cannot write now fails with
STATUS_ACCESS_DENIED instead of STATUS_INVALID_PARAMETER. On a Linux
cifs mount, ln into such a directory now reports "Permission denied".
Before, it reported "Operation not supported". A link into a writable
directory still succeeds. smbtorture gives the same results as on the
base.

This patch was developed with LLM assistance.

 fs/smb/server/smb2pdu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 38326db8da40..9504c2e35819 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8953,11 +8953,9 @@ static int smb2_create_link(struct ksmbd_work *work,
 	} else {
 		if (file_info->ReplaceIfExists) {
 			rc = ksmbd_vfs_remove_file(work, &path);
-			if (rc) {
-				rc = -EINVAL;
+			if (rc)
 				ksmbd_debug(SMB, "cannot delete %s\n",
 					    link_name);
-			}
 		} else {
 			rc = -EEXIST;
 			ksmbd_debug(SMB, "link already exists\n");
@@ -8967,8 +8965,6 @@ static int smb2_create_link(struct ksmbd_work *work,
 			goto out;
 	}
 	rc = ksmbd_vfs_link(work, target_name, link_name);
-	if (rc)
-		rc = -EINVAL;
 out:
 
 	if (!IS_ERR(link_name))

base-commit: 4543a3349127baa8395397b7f4aa930d9a4f8dd5
-- 
2.47.3

