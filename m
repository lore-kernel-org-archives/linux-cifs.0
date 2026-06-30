Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FC03438B8
	for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 19:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782849342; cv=none; b=fT1ds+9Vl0tKAAwfsKE9vxcc0tDv95S1yPCk6vUlwkbNWICcVxnnP+fbp+z8/Su5hGzu8JHeckwmPotrZr34wpG47xD8q2GKqWw+g0CICzgUl/YnjQaeFU49kG5TcnY75AZNXnoxbAo9DmegUAVky/H8tXzpoiua4OOzegx0l7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782849342; c=relaxed/simple;
	bh=pYO0pLPYiwwcAeLVYMpdaEt5WProX1NeJoUDkDT/S5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AcoSEEw0y31YjunEAVMzaTteo1NS+7+ncKdsHdVsrdCE3DzZkzHMfGUfFE2VT/nPC9hO8CD4vEvxvUxQaRc5ORiT723stJIXdZHKEmzhjRJe8AQnp3W3wZMJCDTxVH43iR5q/kWkPZm5BZsl9Q9K0C4qES3KRFVUe1od0wPLJ0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gk9H8y/M; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gk9H8y/M"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493a7bd27c2so25040575e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 12:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782849340; x=1783454140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V3oUrNsWQdX1dJkDA5AProUby+IHxqLvHndx5r8JaHQ=;
        b=gk9H8y/MohSG+9pYI++6qMy3WZYvma8bB8lcJDOFExvt+vrsYpRvyrtt7UCvJ5U/R9
         gtL8e5WksMLy/97KzE9+c0NnlUocyCUXbHHbong64OVZ49rH07fWGYamAeJK/OED5Auf
         xD7dsvgU4v63F2y8DHwspriYi8dsWc6fmZOjNpu5g3bCD5nVVabcpPYx+7QB0r9L/jep
         5CWQvLd+31onj0BPFSwjpptPdOqIdbkjDxcrsmwIbM80s0gOdeEeXMlpFeffVzBCEP/q
         NAhjPAr3dD23L5GoGVIWv/aCct5rBBIrx85kD2DPjTtBps66kCD0LNAlCun/xBUXs7Ax
         91qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782849340; x=1783454140;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V3oUrNsWQdX1dJkDA5AProUby+IHxqLvHndx5r8JaHQ=;
        b=Pic9kWAXAszP+8tWyfxEawZQ5aMJxg/UxcZuNGNWVz6D3R8Eo1GjopSblym+bS+y02
         WFatJYpkVcM8VCcXzXwLvenkFGrSyFlGCQexlSUVFQLCQizgEvTN6Q/oKVTu7HxYswIv
         /JnKiuih61Bu1HZbNMF/bSlU/sgEbns7nRlo3Sxf6Z6Gu75Qeww598X0Yhv1/e3xcsca
         mYPCKHWdcKgW5IST4lvGdfqAp/WQ/SJm4ovYDFdtGzgD4/dd+szjNaMvrC3UJbYo/1MB
         ctOxBjnTmdj1+PIa9YQLie/EHp35V8pI1eqg/CC4prGg5y+Msy6qP+AcI5X9aQUWuPa0
         wA6g==
X-Gm-Message-State: AOJu0Ywe1Ht1lBXObipaS2wr+x6F7VFLumTkRG7XmSr2TZPgGyDGuJIa
	8Mj9iaFlZtUf1L7bkl80GNqltqGY4JTPmSlGDOkznMZm1kYbRZF+dcqU/f9+CSr7H+uU9//S1ui
	itUfwSKI=
X-Gm-Gg: AfdE7cmToxt6h5oBJyx9W8ccBK9AbR7rOQS5JYesKkGUqs/lfW9DxrsMN6AbnwyNLqT
	LEXGL0WruYt08bvsHMDQewRihl/tNFSsNShUcMA0ZrIGxWiqClIxlfFOxsFDGlo3R+QKyYm4Gp9
	zQS7UoS30outwrKX52dOSv4jKDL7YDAZgQgIhqM+HWfz9DNlESpz8s2aQ+Ux+sDcxl6wZTXK/LY
	WYp8sWstkcAWoGN6J/BnyeQF+YulZSuE0Smh7oMaMxJLKQSdYZXoW1R5LB298hphfKKUhzo4V4m
	ob2jTUO6v5DLKO/I473TeQXr+4Ejy5A35tysDdKxSsMltC+Ad+KXJWSfYMB/QE1FA8xrzc8dwmV
	evjk/2vxqcM53UycOkMOUzODpY9uw5S/oONAvagLAiS0R6bL8nqDm+P0NXk/DUMYV8TMI/vJTg3
	WkP1PVWofHm1GD79XRwjIx
X-Received: by 2002:a05:600c:4344:b0:493:bcba:3d5f with SMTP id 5b1f17b1804b1-493bcba3e08mr25612075e9.13.1782849339565;
        Tue, 30 Jun 2026 12:55:39 -0700 (PDT)
Received: from precision ([2804:7f0:6402:b560:c546:35a3:485c:e505])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b2aba8008sm8966934c88.11.2026.06.30.12.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 12:55:38 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org,
	pshilovsky@samba.org
Cc: linux-cifs@vger.kernel.org,
	"Bernhard M. Wiedemann" <bwiedemann+git@suse.de>
Subject: [PATCH] cifs.upcall: Avoid int overflow after year 2038
Date: Tue, 30 Jun 2026 16:55:21 -0300
Message-ID: <20260630195521.1188778-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

See https://en.wikipedia.org/wiki/Year_2038_problem

This patch was done while reviewing potential year-2038 issues in openSUSE.

https://web.mit.edu/kerberos/krb5-devel/doc/appdev/refs/types/krb5_timestamp.html

Signed-off-by: Bernhard M. Wiedemann <bwiedemann+git@suse.de>
---
 cifs.upcall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 01690df..1cc9767 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -247,7 +247,7 @@ static time_t get_tgt_time(krb5_ccache ccache)
 		    !strncasecmp(name + KRB5_TGS_NAME_SIZE + 1, realm,
 				 strlen(realm))
 		    && creds.times.endtime > time(NULL))
-			credtime = creds.times.endtime;
+			credtime = (unsigned)creds.times.endtime;
 		krb5_free_cred_contents(context, &creds);
 		krb5_free_unparsed_name(context, name);
 	}
-- 
2.54.0

