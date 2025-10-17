Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABDC3176EF
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760698037; cv=none; b=K95wECWQiSwtbb3uVD7I0Ja3JSXX8t47nvF5sKUlmIrKThrmbZQX0F8I4By3IQ3MRDCzAusFGfiX3RS/mhr9VN3NzvBiZE1EmCu+SPRyRv8B5KET6smv5nAJY6zrTSlBtmaZjgLFbgrkwtzs46yqr+MhN6gPpAR2axhRXQ4t0wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760698037; c=relaxed/simple;
	bh=tcIlwaOGiNZtpJGtvN/32z9akCHze0ufgBSqOsGlyNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/GiXv4vrLK4unBXkpqPMG2Du7tBwijWv4BtrM6tZi3gkPECMvZ2nx37qa9Tgy7LQ9OG6ZGVvpT/F6USNGmmVICWdhKCCIk9nxzJL70igU3z9lf/4svZ+S11UgoZIMptCZwe39Kjyku26pcu5HB5NojUhE1PUjvQhcYUlCiP8qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=he+zXtp8; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="he+zXtp8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760698033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swp3WkGBp1peL2t9zaCuTnxbSeRuSFHx09RPC0A1m2Y=;
	b=he+zXtp89BkoXlXIn1zzrwryf7POQ+WWRDzNQXuwePyaELTh939bOJNNU1K5qG3vPP7eBc
	Bc3XoHDMTmb5Ac4kVunNXNFAaYpf43ZEAHOXBvNn6kbTg7fDyBzH5S0IRGpPMm1vliUEJB
	WFq7+Vr2pl1ZGKWIDk7hBZMSLb6B7+s=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 1/6] smb/server: fix return value of smb2_read()
Date: Fri, 17 Oct 2025 18:46:07 +0800
Message-ID: <20251017104613.3094031-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

STATUS_END_OF_FILE maps to the linux error -ENODATA. Perhaps in the future
we can move client/smb2maperror.c into common/ and then call
map_smb2_to_linux_error() to get the linux error.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f901ae18e68a..f80a3dbb2d4e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6842,7 +6842,7 @@ int smb2_read(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_END_OF_FILE;
 		smb2_set_err_rsp(work);
 		ksmbd_fd_put(work, fp);
-		return 0;
+		return -ENODATA;
 	}
 
 	ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
-- 
2.43.0

