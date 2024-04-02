Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E629315A4BF
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086500; cv=pass; b=kkm6dB2SqvmetN/UMOjlv3rWcYPeSrvmogaVG2y7//4mDBdWKOuQlTNf13VytgMejiP5O2BEjm/IwC4s7sJk9Os4RFPrz+FF/lqCnRqY8xT30D41UfpVJ4YQDkdCncj5+nVCP6427yVLdVna0fUb6pP6m/sUn7wBfcgKZ82qZlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086500; c=relaxed/simple;
	bh=1gy08Vrf6EE+PH8rnpU4qGUbg8jxhQKmmpDOVGs2zi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEkSiF1JQEr0YELFBQZ3+DbXaewmiZ2ZJaVrzYTtpJr0gEVQlesxyIfqWxLSQskThmDM2xO/d5UoOTsI4wFryKsq8x4Ys1hnCejJpj67T2XapXko9ooQ84IIxeDYJJcLn/S2E1y14FEBf2iurTm+Epa9O7X3wUlVyamXR4tKsVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=EfSgFXLc; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="EfSgFXLc"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJpi1mg1vi287B88sjiK4HGxb3ihbX58FEeF/3XIjKs=;
	b=EfSgFXLcYSwoqFO2R4DB0ZMCUdMZShdynTLiT90NVQJ9PsIyA//OMKr1NahmuJNTkZJ6AY
	6VHBAVD5jzlcLhNu8pfwo7OE8s+BOphH2pAYoIuAiKSLhQ5eYgVgbuMZKyaWJsU/eCYaPB
	M7EdJSLd5OpkCvF2uRTGsIHwrX8qZYwJH5cmme3Efz9sk5MAPRPip7qWZ5AciEmz/dlJUX
	kolXHc2C3+FbOQiT3HNmDu6HPykfBBDwGm1AUe4/+nNolDnd8B0gE5e8N0Yvd/5BqK5Oyo
	EzGSU9zzK1UvAliMTVOQYQ5n6EHU4PYblc9jzq9tvt45P91cIKHfIirNxB6RLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086497; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJpi1mg1vi287B88sjiK4HGxb3ihbX58FEeF/3XIjKs=;
	b=WdwEq/M3rQhZsGhYGYVlFEC3bjb2jhprVduHc6Auh4TOe1xXb+Ge7/ETGxnamBTA6HTdkt
	Nh8U1KZyIPUFsRlf/WYZUNplag2Hgc+zVNWEuxq9LZaw9McEXJ0EoyizTkw4FXKBebJPmY
	jGvdQ8OMUSa8/hHDbvCol8RLoTqpl8XtnARwP7AtnBc/i+XO6UpPFUplZSavQjAJmF95cA
	PoM357+OzLtwiM2MKYf8m9HhpvCZFkRr+HDuhvU4piAZMLRkhuPn3AEL1vrZtnjwW8/A7l
	ZXheSgZWsBDdBTwaevph5/8VFOeparaSLPJFFU4Y9FPTm2kXdhRFgGSDdZMSxQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086497; a=rsa-sha256;
	cv=none;
	b=BCutS2foT6jqC2wC1AtQfIK59C/kl/F+s9N5m/nFbTDkUHIrGSPIbBuH63uPT1EMrr5KS4
	PNaDhNMPTc6cJv5Y6S1AH5Nb/8rRVyD2xNBAnpr062tR42DflsQKQPbuVhSOE+C5Y1icB1
	Zaf7QHrL9nmeWOH3jcc+0qP4jV/aasO/Hbu4kTdAjiZ1S9D0m1xq3h7GB6Pte3MxKu3F5A
	rw49uyP9M1ObP9LmoT2JaafbhjHjNrqSJ/5pF821GcHcRBlpO2VuSZzOgLNqlPkRGR5Ai4
	CF/q8AxWBqeuN2MRE+vBwpnnAD5L99bo4KoPrO3T+QUZhqsfLRB+QYWq2IyaRw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 11/12] smb: client: fix potential UAF in smb2_get_enc_key()
Date: Tue,  2 Apr 2024 16:34:03 -0300
Message-ID: <20240402193404.236159-11-pc@manguebit.com>
In-Reply-To: <20240402193404.236159-1-pc@manguebit.com>
References: <20240402193404.236159-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1506a0eb10ba..4fd2ffa2ebba 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4188,8 +4188,8 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
-		if (ses->Suid == ses_id) {
-			spin_lock(&ses->ses_lock);
+		spin_lock(&ses->ses_lock);
+		if (ses->ses_status != SES_EXITING && ses->Suid == ses_id) {
 			ses_enc_key = enc ? ses->smb3encryptionkey :
 				ses->smb3decryptionkey;
 			memcpy(key, ses_enc_key, SMB3_ENC_DEC_KEY_SIZE);
@@ -4197,6 +4197,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
 			spin_unlock(&cifs_tcp_ses_lock);
 			return 0;
 		}
+		spin_unlock(&ses->ses_lock);
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
-- 
2.44.0

