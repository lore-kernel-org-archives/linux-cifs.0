Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE3721D3CD
	for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768845403; cv=none; b=Y4ML2XbX7+4+bayynINVpwXYYtSBdP94V9kPWfb2Rv1YkYPwIATOYkoXed8gh1Znsr75PXWO6q8HVX1OPsb3CmOawBbL7jpflKtb1qj6L5y0JgBelkf2f2bc0U28cKbqeB+I+eyk1tlJVeXQQ6GtZsG4BqgS9jiBvdD2uNogr4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768845403; c=relaxed/simple;
	bh=Qf6wTW4J+BRAqH5uv/JqKQ/dS/OWGGTvusrmMpGj/k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcaTEFVrFBgoWnumcfx5vXK+Zo7WfZo88rFMkpv8cE2vYPtOr052WEFzdv1sT/k3/uzb/qNvS5g2a4oKRColxvLNV6GU0/NChu+cIiOCsuWjRSkwvuvKklYBDMobRXQxIQ4wAsIbGOclquRSxHMYqghOIaeYm0oov3aNTyVp16I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dzfYaSBB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dzfYaSBB"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47ee974e230so37132145e9.2
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 09:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768845400; x=1769450200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9/yXWGsBWrq7AGaJoq/M0iwLaFW0LKWnsUUK1fAOgEY=;
        b=dzfYaSBBLsK1cUYc/K5LNMJTAukzm1GolbZ5LErw1+Tsc6LLjm2/WSF7CvISS0Gz2P
         qUnzr94nPPVp32EHgCYh4z/D9nyRvn+G/Kn0hsXyaAg/8Bb6T7OZOaXlKXF6jyhk7w/z
         UmifZxSAC54WQCjMxaiQAYMFmIya+MRDto0c7bZ6L0eZknncu3TNMxu9AH14a6yT0x/F
         gmeQiAro1e1mCxQzBWGpw+UWLoq527kaI3hNb1L2dOGF4+vTsyFUlZlU+hoQdsvPKyKP
         Vpth5lk52BjAszzbQsbyN1Ss2eNj08xP0w89pMP0eDOnzIVwmkSyoN6CcNanXwV7Uqnh
         KOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768845400; x=1769450200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9/yXWGsBWrq7AGaJoq/M0iwLaFW0LKWnsUUK1fAOgEY=;
        b=aJV3LpVrHqdVFbVP35aZTOeDc3bQb1SlCo6gmstlQiYBrKcxotaHaZrUq6M5NQsKXG
         jxcfeSGNla+lm5/8Y0l8mDpANPjoGtH/HTwwuUYfEtZF/bdZD8yhdFxKvj20+inipGme
         swcwDyh/twM6Os415oLSeo4Yd8Jk3O/O6BOCS6IxNFGmHz+aenwg2X8rX1mi8aY9McxL
         PN6KCJJDtwKKvgHp/5GLztdq5Hd4q13+O0Cnze6+Xv9nHwBvw9g23wan2G2obn6xLWcN
         VAZPcH8HchK56oZ0REZ+h4d3qv9QlaD6iKNy07w8cFC8caNyOayuMdonuWaE42AFTc1b
         TxJg==
X-Forwarded-Encrypted: i=1; AJvYcCUPUZbxW+DHve8ol9y1kC4vCKEXYgLQOYxLEehoVx2S1glROpRceGRKwpwgGqV5z+XsXY3AO/q9Lhdg@vger.kernel.org
X-Gm-Message-State: AOJu0YxOoEdhcX7bl/vCGXcr9Vsl5dR0W7vzcn+lHXJcvbcA/TtqKgx7
	pbOHVDtAbRn7jzki2nbvMILU/drFqblNtjP2D9bgnA2skjebmYF2APnrUn1GK4X13Gc=
X-Gm-Gg: AY/fxX4feIas5/UVIHsy8uljEQ56rbz8SF+DC2aR8ECnFXXX+CTa+ZN/mQdJiEFoZXU
	DgJpp9vD0CmCEDgEa9AWXiE5WbOX8SUdlAx6qV98clDvj8Pf0ybQiC224jcD0LaulNuxVBfNCVp
	36+sMGrpmZgiZhTFagQgJH+CmxArkA5AGfy+7AM0/aKSbTaQNZaXwXdPSPk5z73cl7n+IG2Tn1D
	igZDZp6gCSDtC1nTGjV4Zt6lAOa9H9Sd7lYgLx1MOOx3fZNB0BzcHPYl5DDj3cdoSAhhaB91M+O
	xUymkrRWJ870ASoCRVq94S0SxmN2yvl8P8dPq+11yvljSjR0bYdOcYdPi6qPFykFsNbO9O627OJ
	PIL5gDQZsk5A2N8cctniJTCLq0K/Q9zvfxvNwG53imaZq6GcWVMmXqttEmlSn12TiJZj70AH8Kx
	JwTBcwemscPRs34LSa
X-Received: by 2002:a05:600c:3552:b0:47e:e20e:bbbf with SMTP id 5b1f17b1804b1-4801e33c1c0mr179959475e9.24.1768845400156;
        Mon, 19 Jan 2026 09:56:40 -0800 (PST)
Received: from precision ([177.115.55.201])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b333ccc5sm15045595eec.0.2026.01.19.09.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 09:56:39 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH 2/2] smb: client: add proper locking around ses->iface_last_update
Date: Mon, 19 Jan 2026 14:54:45 -0300
Message-ID: <20260119175445.800228-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260119175445.800228-1-henrique.carvalho@suse.com>
References: <20260119175445.800228-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a missing ses->iface_lock in cifs_setup_session,
around ses->iface_last_update.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 4e71d5e0fbc4..7cf26181ee3d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4335,7 +4335,9 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		ses->ses_status = SES_IN_SETUP;
 
 		/* force iface_list refresh */
+		spin_lock(&ses->iface_lock);
 		ses->iface_last_update = 0;
+		spin_unlock(&ses->iface_lock);
 	}
 	spin_unlock(&ses->ses_lock);
 
-- 
2.50.1

