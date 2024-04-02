Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECDA15B980
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086493; cv=pass; b=P6TxNO6qYqMJVO9vhBbn3N5ttUrabuWMRRNSyttaolJ4cGMzrQh1D7/Vqj+8JunoXMPEIEs16dNOxbb94l3xbLR76cf2CqOxpG7U489CFdYVgZ07G/krQ354z9+qiRRYtNjdpGdc6l0eLDIssLQ89bpINxK/6a2RXpE1Qk2j2vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086493; c=relaxed/simple;
	bh=bsexZhLh36P53usXEgBd0D5KVHp6dednDiELDI6aFE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2gyfJhSHW/B6PSQYLoK6qckTwM0rJANnH8l2DxkSSGGs2/fLj/apwhqhOopnQGLU6OVsiwguO9JgHm3+XgEV5XUSB3E+AWXlmYp2vuO8kweHAprxbC5tbV8e4VWUucauztOWwe+52gFL2pz+AbYFr7IokLJebA4Bl2TyprVaOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=MFoegp4h; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="MFoegp4h"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxrVSGLnER8djAA3HPvU0TK6Ikil/P4mX4QLWrJ1n38=;
	b=MFoegp4hZUSedCY6NWEW+B+nVlEQpQkcX3Hhl8hT6cy/Baq2GWMFGgfyljE9RpvEWjeBHS
	ycMRYDW+uVnfUYA669C1fbpUfPdQcOG5UGK5DIO9jV9qI1srugIT1HDrj98NZ2WQoY0JtY
	MRrUDY+WXMrjjxqOcvHZcvMiOApL6FrewTJFZbfgWjo5VO1idoyqN3DuegTf2/JGFk8Pn0
	Y/bOA2Idg8LctaokHbDB7qjjUa8BR3hs4RAC575fe14sGNHj6uWui6tBl31Wq7ELEZ4Msx
	ZwzmQZkA4XTG+szSEr9662JF3J8UTLzAdfeEykyEDKIikqopFGEtoZg4iNdFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086490; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxrVSGLnER8djAA3HPvU0TK6Ikil/P4mX4QLWrJ1n38=;
	b=AGVcFrhYK4GhHhHWjxOZHpKxHOEWhauMmSWIPA0WXZOLHkHA0pX1fN7cnqOFzggX5yg/w5
	9+K0fikFuS7xzHXUHEurowdQyAkGO7uXut+vD37rWFMnhlR2nyhcRs5BOmPaLveHtzrn7x
	NQMx8hImUW142Lq0Ltwptpubm84GLQ9QS3mvNh9K3fNROQX/yWZyRMkF8hYJwiYgUuhXLV
	aruOLDIpXUwfrDJ8HqBvpw+dHxRTh+fON7zNVoAOX/jp0PdY2MH3qPDMU8hbWzyRFShF40
	uwCuFdYLNvhBOnERIpxm+IglMkZ+BCbtamn2mQlJbDGa/9P3vUrmTdCcA8CfZw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086490; a=rsa-sha256;
	cv=none;
	b=TyFLrCwIHlCxG+VcptuPPOHaCBAJonbI8EjNSEJTwl0EDFcSqF4Y3D2o19tbaP00ohIIUo
	u7cCXn6tBG7qBpw4b0xwEVRTynaRYZIrdxAA23JNVx53zRbEplVT6V6rjFynpwUeXFxiRg
	cOhTJQ7hltKwVCIixaAsAJPdWp82RJPb+SSnpwETWvuo/bTFCpLr27Q6sD+GPv1FvzwJPD
	hUMHrfXfJF1AEAOqtjqaBZHWVkweV7xGaYrCjsDYppBwNwm9L0yWTbD8riFrytIxji5cGS
	BWHyiyEXUqDpNRP5En3Xj9EDx3qGEo5vf8uY+PlnrGu5JkmysjcZ077VDN8RNQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 07/12] smb: client: fix potential UAF in smb2_is_valid_oplock_break()
Date: Tue,  2 Apr 2024 16:33:59 -0300
Message-ID: <20240402193404.236159-7-pc@manguebit.com>
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
 fs/smb/client/smb2misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 4abbf6545c9c..29b5ae881d48 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -700,6 +700,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 
 			spin_lock(&tcon->open_file_lock);
-- 
2.44.0

