Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E544132B103
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 01:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781055879; cv=none; b=U6aZ9upKoU55sijqCyJPnJzxNVsIP+LAVoVdbFwi1nfw4R0+iEmbq1OotDRXW0YyMgDvRMq0AANR4NObqgZlMksCkYUBGmUqr8Y8YcsD+C8uSvVmK7+STYx9CYAqx9fuoU8fArTGcXZ4MPDCgfVSYweLB0vuK3BgUrsHgBHKfFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781055879; c=relaxed/simple;
	bh=N+uVDUSqxfQzYT70zOjAL30sYFtpf6m2v/mesyCAWSI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kqQZHiHuYtkVVehBJbESbNJLIBQAGRCb+PLjagZwdAeefAkcjXAj5o9m1SJhcczggT8Vnhwf+mO4n3uC59rxvEnHWqwly0aBBFweHoG+XOSSV4BY6f/ki4Sfr5ssHidTWHfnCyxS30XnowKYnaS6bYNzcJ8XtkAUV1teOUX9Z7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LpZLzw6F; arc=none smtp.client-ip=74.125.82.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LpZLzw6F"
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-304f590dd91so6923534eec.0
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jun 2026 18:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781055872; x=1781660672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yn6aOazxKuhDqTua5W1fGR5pNk7u2gqieCtVGmDzSTU=;
        b=LpZLzw6F7MN9Eq2XOawxF+NVw3DDTom6ncg3SG5wD+kmuIa8HvhWGTbk78KvpgpKYP
         MuSM1UgyPZa9ZbGGB+UBPvJ4U6T34SXkWo44xUqpSFFgIZ7oENcw4iYBuwWLVyaNX3Io
         bi5kZ/oXpkibeBmVmkd1SirS7p26FY3Qyn8aCC0Xqv43eq0pkJgWwWlhKR/Kq8AIb2IZ
         ZATIJKoJl0Fwzuk+RQTcAKaA8H8viHpPD9p4AMOlTkczyejnJ4XO/HZyKTblD7vRGtaF
         LFoTgMXl+A5jbkBNPqMI8+l9wUHQ19UoVyYFER/4RelqbQz919xdakvZ72BcxlcNXFKj
         ohGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781055872; x=1781660672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yn6aOazxKuhDqTua5W1fGR5pNk7u2gqieCtVGmDzSTU=;
        b=AlB+qthMOypc78lsQBx+6+LbG7vCvJ5ajooBlYrX7qdrKlf1Xc6SRFGOEzDhRfKX3q
         v9RdOGissXDrn0BRI2y6XlTFlOEcYJBtOuk7/gAxlZaiO0Hy8meNwSVYChyuMnVRdJ/U
         GAogeoqoiQn364TBgvvZjtgEZIgsucDki2C9IyXD4YIofXjGkbLS/w+466/1YBbDzI/m
         SPABDiY7NrgVEebNzVzYwo2Ag0NlLLJzQo9oKzFdm0qlh6QIvTgMOjdPodiUIes7xLFz
         CuPXAfekcO1eP2MUKp+gdZh7qIKe6stdbVXRlSYGQa8CZgp0d3UmtRAzTGC/eRtfwfeO
         Ig5w==
X-Gm-Message-State: AOJu0Yx71v4jIlavCNVMngag2E3EVkX85oYLqY3fPppvNAZbAVER8WWy
	xyei3RRTp3lDOXbLCkysEzMWO8WYi1ngPKFrd0orAwy2s8kiRmecZT42O7NIfPLV
X-Gm-Gg: Acq92OEY6hCI7QK0tmbEJMoaevsvJAPHaEplvPIlmYzv+AT/DBQOBWJEqGwKa4b/54N
	3NYl0yT1LYLMo1eONUpLu+rR2/iiDxEa0/K1wgblIk0S34Biw1iGJwNqAR+51+pAt0I2J/B+70C
	OPyAuy7TRY9YKTeqDmCOiPXyvaHhb4YQwuev630Ig2Dvx/NicrUG3C1uSNurjHAmRn2dYCo72nq
	PL56xST6TNnZgnJcFmcKs3UjuIufKh8ujDDKQ/vuts3Og7oUW4gvR8mLwBfaD5FDkswlxkSC5DY
	6QQeXZQBxBOJMOfiZSgX5JEHqejZDiZnwzQMGuw1CI0SPgx5AWfvVpKLNkGlSRySZXUKtBNwBH2
	CnU7SZv/5ZRKGXX2Fg/gSnZQ6NcUXTDCYYCVHqeJhB1+5tgrKlXFi0QUCiSGn4fJDy24XhuQGCp
	RNFs+iSO4yV+89PrmsM9Jh9CmdgfhTeir3IzvzLolhlRcFE0GAMVqKeA5h15fLjjarxnChB/4xb
	H5guebYd2Hq7d1BsjwJnbHXzPZ5HUQ9dg0H9xHB1gv8AtBBmP2rLG0GZ2CQktUB45qYdd0qAwmU
	+407wEMy/RLp2Ts7LZHjZ/9iCEW6uGhimxhPhMM=
X-Received: by 2002:a05:7300:cd97:b0:304:997c:d4b6 with SMTP id 5a478bee46e88-3077b721517mr14100871eec.17.1781055871690;
        Tue, 09 Jun 2026 18:44:31 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db5610esm23549795eec.4.2026.06.09.18.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 18:44:31 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH] smb: server: remove code guarded by nonexistent config option
Date: Tue,  9 Jun 2026 18:44:27 -0700
Message-ID: <20260610014427.38708-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A small piece of code in fs/smb/server/smb_common.c depends on
CONFIG_SMB_INSECURE_SERVER, which has never been defined in the
mainline kernel, but was present in old out-of-tree versions of ksmbd.
Remove this dead code.

Discovered while searching for CONFIG_* symbols referenced in code but
not defined in any Kconfig file.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 fs/smb/server/smb_common.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 741aabdfcef5..82de4fdfe446 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -102,9 +102,6 @@ static const struct {
 	int version;
 	const char *string;
 } version_strings[] = {
-#ifdef CONFIG_SMB_INSECURE_SERVER
-	{SMB1_PROT, SMB1_VERSION_STRING},
-#endif
 	{SMB2_PROT, SMB20_VERSION_STRING},
 	{SMB21_PROT, SMB21_VERSION_STRING},
 	{SMB30_PROT, SMB30_VERSION_STRING},
-- 
2.43.0

