Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FB3450FE
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 01:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770253227; cv=none; b=p7v7YYjjBYAKL3KzjDB/UhXpNGP08PkpGPJqYVJFAMcrA3cOwem1PV1txVN9stF8KMzahpve1SF6iC/0DAz8jRm48Y1ghy4wMvTMEXYqamlngXcvj+0TB/YLaiQWxRaWSnxxrPSwGsbZf+8yfPSRALiyuFeD0qLgcXes2oSMBwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770253227; c=relaxed/simple;
	bh=AafpgT0PSxpukQJB+x6eKlSVgw4Nu+RnQRSkV8mPNjc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G4t64XD5ILvsyIEIicLIIe3EGnXRVMZL1Hir6QsBMoMD+4+G0W95yeG2QLCS2SOTlSLQ0pDygkont34tujp7oce4WfUd1H3eXvZ1eDflgjQHaOx+8PmeCn0BIN6tzVJHR9y3pY852kke4z661z1i13dCgDWoPqnBgDeRis72dFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZIfSoVTp; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZIfSoVTp"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-81f38d974e0so28048b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 04 Feb 2026 17:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770253226; x=1770858026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AjjDUkU/HTlLa2ldCnHFGgqxMQtzMeMnD4QQi2azxx0=;
        b=ZIfSoVTpvOF49eLJ0h5WeTT4Wi+z956XSLXza8l9PRPylwJHrTMq5WrwiVDozTt/0q
         347oiz6L8YcifVUmjHzeKaIOzrefe4ek10uRvyydkeTuHFmAJFM4VukgLo+iU/VL+VPZ
         gmnKCq1Fcd5AVTqsY1krgSFF8wYBgvjPGJQMY8wDe0iMhv/pey6eamDHLaf5Lotq/cA7
         sCm8wEQ/Umk44rNYGSY9uPoar0anLgbRS2AMVsg74M3xMOejuRBGpiPN51Hu/Mk2O62y
         3RM8Gn+HmUztDKjgF/bITITTnM5F+2rOcqgxms0HXxmS0R5D8a42+P4TM9kHWKz/+szB
         nPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770253226; x=1770858026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AjjDUkU/HTlLa2ldCnHFGgqxMQtzMeMnD4QQi2azxx0=;
        b=OI9X87npYKIff0Qp4oo161rZl/Tr26iULfsnZ0SHnNB3G0VTDRMJhmMF1tOQdjLiSW
         C2MVAMvJkv72xUU9enKKxPuPmNHRlx+DAqBWw2bhCDhMMcltUS+Y4Bd6eZCSFGGQ97/3
         WCatfxwBO7plEjdcz+QIMJaIjRtEWVVqYZIu3o39aXLhXzugdiPtD1WO1T1paHhvYlxx
         FBIVvHjiR5OC8HXRoGHSdMp5BBMj6yYx/J3oYCeOUl3+NM0o07YqJ3aBvcFku9R3zogO
         TdMzSuAPrkn5EHkZjN6rfF/QBwIH5NlL1LUcsg2/sKRQ0/9zgHfQxsqCHJRP2JvzXvS6
         OXWA==
X-Gm-Message-State: AOJu0YzmJteoaKX1kgbCFeTP0jyG7AwQG/5IMTfh6ZlO/LWBjuaCjIa/
	PYQc5ei8cQ+iFVt1zw3ZwTELqgdRNzZD5Nr3ryu0hfZkLBPH4VA1GitD
X-Gm-Gg: AZuq6aLiLET0H+YqeIctqJ5CsS71Rt9077HZl8gzdSHVoCu3K1567hMDXFVqnDs/tUf
	VFGcbsYuVLX/C217KKcReCGo1s0bpn7kEXMQoBJVXdWRt+A0VorgP4igIXVJuMiI0WDRm0ueIeZ
	/VZ+tfMIUoEsG1DydqdrfUfLHjsITQCG55JIhqrhpHaTL8AHh3OAhAs7SPZ8v7YBr7C5r4KUEel
	Ky72+g1d9KvQDNnm++OzNx86fBG21MFfM6teQf34/ERuJVj649uiEK6hJVkmLCLTPzPoaf3P2kc
	j/KMCy3p8Oybtp0/+z7zjbmGUGmvJX7wzLtUVGFPbrE6GgUdl1nlRIYP1cIbag3XOvd0KsDXxXA
	Ui4gecMgVKg47mgx6gNBrOmS54ibHn9KAVy5XFQDQreYnAi3tDyOgtDxnsLeEKFFwI2bAvj3Tke
	rDu0I3NmvdNmPwbAAYk/sOog==
X-Received: by 2002:a05:6a00:1a90:b0:81e:86d7:b57a with SMTP id d2e1a72fcca58-8241c17bbb7mr3323051b3a.1.1770253226317;
        Wed, 04 Feb 2026 17:00:26 -0800 (PST)
Received: from morax ([49.36.183.137])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8241d434ed5sm4143861b3a.39.2026.02.04.17.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 17:00:25 -0800 (PST)
From: Aaditya Kansal <aadityakansal390@gmail.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	Aaditya Kansal <aadityakansal390@gmail.com>
Subject: [PATCH v2] smb: client: terminate session upon failed client required signing
Date: Thu,  5 Feb 2026 06:30:12 +0530
Message-ID: <20260205010012.2011764-1-aadityakansal390@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when smb signature verification fails, the behaviour is to log
the failure without any action to terminate the session.

Call cifs_reconnect() when client required signature verification fails.
Otherwise, log the error without reconnecting.

Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
---
Changes in v2:
- reconnect only triggered when client required signature verification fails
---
 fs/smb/client/cifstransport.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
index 28d1cee90625..6c1fbf0bef6d 100644
--- a/fs/smb/client/cifstransport.c
+++ b/fs/smb/client/cifstransport.c
@@ -169,12 +169,18 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 
 		iov[0].iov_base = mid->resp_buf;
 		iov[0].iov_len = len;
-		/* FIXME: add code to kill session */
+
 		rc = cifs_verify_signature(&rqst, server,
 					   mid->sequence_number);
-		if (rc)
+		if (rc) {
 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
 				 rc);
+
+			if (!(server->sec_mode & SECMODE_SIGN_REQUIRED)) {
+				cifs_reconnect(server, true);
+				return rc;
+			}
+		}
 	}
 
 	/* BB special case reconnect tid and uid here? */
-- 
2.52.0

