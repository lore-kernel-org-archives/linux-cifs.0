Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727B415C144
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 01:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732324539; cv=none; b=sVWMIwhazjeoHKa6+Tj0uwIWWbXjGQdkOtQIapudjz4ggavEHJL9Cc2t7cs8HWf2ralQSDr1EQrOmv3vS3T4KwltEwtoOvfqR8Y2FwkDJNQmzCOkm6Z+0G+uCWmYvu/EItWsL2rQu3ryj7v9Ds1mRa5Pc+Sw2cH9HWChTIi1vDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732324539; c=relaxed/simple;
	bh=xc3f/+WMRuftca7H/fbNXJP180/9fQjadJNguZQKfk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW96/+W8vQn+8bRki7yv5tXpHsw2TVpnr5cDVvQS98V3Q+4Ofv+hAgdCVDCpwueRDsumiIClzjeN3atTUA51jJ50gZm7zdA5C0419tvtmfAYv4LWuVQ1r4it1RTt66+JTaGT6OXH/54DPPRtl6OMyfMEDDV7ruExNIFUvCz5WVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F2+R3F8E; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F2+R3F8E"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-382456c6597so1948414f8f.2
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 17:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732324535; x=1732929335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkjfLSciC1FZ4S0ADfaOv6fCir9oXRhjff/U8YYLuz0=;
        b=F2+R3F8EEmByZfusHmrG87SQqDbd3+w3IxrG4drZQSEqKMcGZD3DPCxYhatQ7n2ZdM
         g6n/b6aKELsPij+BENgRQ4AEcENtISVBN6SRkXPMnIaksfYOFKup5g1bRW3KmVV+Ig0/
         UooWy8WZKPxZGppclKgSWfSUqSBwVefAjaLJTqOHkTK4qCx2qwYhfFZjDhCZ51IEeKJl
         Ve3PiOLCfGFKSZ623hRPiIwjZHDPk3yS9OPxrh+ehYIVOL7owCu2Ae+2E9flDEgWjsO0
         tL6tVm5olZgj8CWowbr1Zy69rE/0XyATROVYAANXYG7dHaaFbNN2eLjoxHRuHtNa2tMi
         4N6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732324535; x=1732929335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkjfLSciC1FZ4S0ADfaOv6fCir9oXRhjff/U8YYLuz0=;
        b=nba86jlAqohNZd1X0n52p2oWk6LsLHBRdT9aK7L2VEqQQg8tg102nV7XSab+yfLVdo
         b1c3J+iivWpFYDTpvbjoE8B64DQ4HxpTkImOGe2D8RQ1l9axzkvNdwKh/jNyXj+bXnYj
         3uVtyTDJ+CSq2/TXsgReCYSOozMJZYfPSSIpltOKLu08c5Ed/ClESkEmh9v0MoWTf7ef
         tIKB3CYw7F7OJJ8Qag6nTDPDVjJSmS+niCdaTGmIdvcBU51LBBTzvcGlhjzxCC0VW8ls
         9gGmtxsDDQEgCVkRiMucjxL5BfSwMSJNl9nIWVrzJOTpvRXb5ftewxutNTuojzqqY9VB
         i9kA==
X-Forwarded-Encrypted: i=1; AJvYcCUUQ7zjlUP6+aybP9d0326n0NxIuc7kWKK8vE/jdZH7r7HdbTFzfoMuRqA7Fhk3FfwVJ7USG7c2p1Dy@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9EMlKfauXgGrLQRTGHS8/x72Ffj5+jVsmynPha3QJZcRDdrY0
	JCsa1rPaxT9XyIjOi4m9n3tLn4m2BxDqpSmedCYwXIFnLnz/lZyrWSpnX1j/lGM=
X-Gm-Gg: ASbGncuwMbO6iZGB9d5q1wUiJSCPusaL0AZ+zyXs/mdd3RJhq6mhU2gx+K1oMYqhQcf
	ycxUDkEXc4Dqz1YxK5R2Eqt4Pn5HqXoh3eT3m3/e7atHXU0r9V8ikRISlzY6sUpoLgWH5Q/+wuH
	PfmsAVsiEIIsCFXjssz6Tpr57F1QSiq/AtCIfj4nfs1xujxxc5Th2YGemLpADJkffwqrzwdqqgM
	+3Aym1KamyydzvgAVOsFmjkW2vkp4HExBv9S1qcGmGVALuTub6Gk9xDTLuorU+MyRnjtg==
X-Google-Smtp-Source: AGHT+IH1kTXtvYl2g+VDvKR7AulQZOfHzMSdnCu73MuC3VdcIHMZ0HPQqRozbab2/r6cX2vyLU9w8g==
X-Received: by 2002:a05:6000:178b:b0:382:4b2f:f755 with SMTP id ffacd0b85a97d-38260be3c7dmr3971790f8f.54.1732324534766;
        Fri, 22 Nov 2024 17:15:34 -0800 (PST)
Received: from localhost.localdomain ([2800:810:5e9:f3c:e019:b39:5a90:cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2eaca70371dsm4043040a91.1.2024.11.22.17.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 17:15:34 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: ematsumiya@suse.de,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 2/3] smb: client: remove unnecessary checks in open_cached_dir()
Date: Fri, 22 Nov 2024 22:14:36 -0300
Message-ID: <20241123011437.375637-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241123011437.375637-1-henrique.carvalho@suse.com>
References: <20241123011437.375637-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Checks inside open_cached_dir() can be removed because if dir caching is
disabled then tcon->cfids is necessarily NULL. Therefore, all other checks
are redundant.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V1 -> V2: Split patch and addressed review comments

 fs/smb/client/cached_dir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 8b510c858f4ff..85a8cc04e2c81 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -162,15 +162,17 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	const char *npath;
 	int retries = 0, cur_sleep = 1;
 
-	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
-	    is_smb1_server(tcon->ses->server) || (dir_cache_timeout == 0))
+	if (cifs_sb->root == NULL)
+		return -ENOENT;
+
+	if (tcon == NULL)
 		return -EOPNOTSUPP;
 
 	ses = tcon->ses;
 	cfids = tcon->cfids;
 
-	if (cifs_sb->root == NULL)
-		return -ENOENT;
+	if (cfids == NULL)
+		return -EOPNOTSUPP;
 
 replay_again:
 	/* reinitialize for possible replay */
-- 
2.46.0

