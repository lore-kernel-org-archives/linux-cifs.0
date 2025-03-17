Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B38823496F
	for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 10:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742207314; cv=none; b=gKtfckPllJjn4c5UEQ/hTESOEZzA7Ir28yZjobAxD9OFzzSCovlcv72hA7T0bo8JuBbj+iw6pbfApgFxJU/wRm2A2ZK3fLESnDCZRlcxMaPHWxSVptxVRZP1zwxIMy3kb/PeSjfr6mjPz6W40OasmqMq56imUSBWIYm0FpC971w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742207314; c=relaxed/simple;
	bh=oOR7y8/Uzgm9Nii989X69pYFZDHK3+S1uw6RWMhMgps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4vq7RvhdqwqMIRvZE+qi+iByCOkYGslqwrXoZIuMPaNAiRjNJQfLJCwi9/UWPHaq1FARjUJSh6hU6CUH/O5JwGPQY394W1xzrzuv3KI6Dz58TdXXCpK8zH8eCOt8PVLS10ctvUWwsI2wlWPT3RtPnzFXywX88GwHMxV1iqV+Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvkabXKu; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvkabXKu"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3018e2d042bso741921a91.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 03:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742207310; x=1742812110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSSv2FJT3eg7+0pK21SUTeg+hNLf5nMrrWUyhSxCCqc=;
        b=GvkabXKuQnimx5qFaK7MrmDc77MePgQikgPjhcOYIeKXKXesrbeubx6Ybdz77uNdT+
         AsvoDxMgDFL1XV3F4v6KmJpGmzzS0+ph4YuqifBuxcKibZ569/mhoe045zRk4lxARR26
         Gk4eiUCfOMbpsV9voQ1vpQ3tRnisKCMSsR/BAqPRc5PNlV8LNX4UTRoZmuBDrlnQv+NM
         FCNRESh7JAiwkJcHi1g87v5cWaYiNXsbaplagoOjZbWDlEEXJ+XO5xqRfYND/al4NDQW
         O2z74KD33IfCAfAYMlotwuLwVm5aW454Uo5eDJp7wDo6Hrh2g4Zc3icoQuxf7BOP5F7n
         1mSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742207310; x=1742812110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hSSv2FJT3eg7+0pK21SUTeg+hNLf5nMrrWUyhSxCCqc=;
        b=lr1J7Ut3HjJ/vemGwNBYYW+0prEyWr6NLlIpwB11en9CsuYpWLhUSg2cm1jkMXwMy5
         n34mfQdv1RKqWg6/d5lyA1Dny7sFRmVlwiMAgLJMxkYVl0fGnhQSD/kQrJxXbfcwafhD
         7gCi5xkzXiUFl4O+49OCXM/pA73ideC6I+80Wp20JNfGyPQAqvsUJA/NUZZauqaWm4Y6
         7ZBt0vHxXvvVd4z+v64+2Hn8IuTX/8/de/b8V2Su7ZiBicpGmKxiHIK0mrgK3Ks8Rluu
         jh71X9HuSVzdrgqoFRtoAIHLXLSeozQ219gHaZ76vGKNJvVBJL+HTLaq+CkZBKHKseGj
         5zQA==
X-Gm-Message-State: AOJu0YzohnNIgbr5DxbMYJiNkw8ckV20gC19SZXoB/JixNZaz0IN9eU3
	as19twfOV1UN2/f+73I99paGJbT9cygb73R3nX1MCES+GBdwPV4HyLOS0AQR
X-Gm-Gg: ASbGncsTP+tlqCg1hAGAmdaJw3eHlvkELZLpSrkwqjoXM6OCxNLy9J9qNhYyJ306toc
	d3C8KyzbVmA2Ko8SSoT5eRBnZnjXNdaKTw+zNpo5FkITZ9LXiCtTrQ+91o6q10ogUHGQsaomK20
	popfSF6WFR9/kvW29vu9pCXCbnZUBWryiqsSEu3zF41sb6UaJKpsdDEuIRdJAhzKigTcShoqwAs
	d7YqcztR3CiuOSZCLiipGc5s7U6eWeNQsU3pNd/mqvpK7aYI4RrcnLzsTc8BY7LsRL5HqkxrEht
	SjZORCZKmbtIeG6mfVzhnnsPNZ/urdD34AvM3VHVGM+9JmqOlMTh2yTQ0ZuBhdqBpsB1hg==
X-Google-Smtp-Source: AGHT+IH4HSGCwVo6FvnQgN3z62IoMYqQ08omofIxdqH7BTnYmYVYEZXlT0p1SYa1nGOzNfr7xMNBdA==
X-Received: by 2002:a17:90b:51c3:b0:2ff:6ac2:c5a6 with SMTP id 98e67ed59e1d1-30151dc757dmr13474777a91.31.1742207310489;
        Mon, 17 Mar 2025 03:28:30 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.189])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-301539ed069sm5738238a91.17.2025.03.17.03.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:28:30 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	pc@manguebit.com
Cc: Bharath SM <bharathsm@microsoft.com>,
	xfuren <xfuren@gmail.com>
Subject: [PATCH 3/3] smb: fix secondary channel creation issue with kerberos by populating hostname when adding channels
Date: Mon, 17 Mar 2025 15:57:27 +0530
Message-ID: <20250317102727.176918-3-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250317102727.176918-1-bharathsm@microsoft.com>
References: <20250317102727.176918-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting a share with kerberos authentication with multichannel
support, share mounts correctly, but fails to create secondary
channels. This occurs because the hostname is not populated when
adding the channels. The hostname is necessary for the userspace
cifs.upcall program to retrieve the required credentials and pass
it back to kernel, without hostname secondary channels fails
establish.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reported-by: xfuren <xfuren@gmail.com>
Link: https://bugzilla.samba.org/show_bug.cgi?id=15824
---
 fs/smb/client/sess.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index b45b46b1b792..f2ab8513c3ed 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -494,8 +494,7 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	ctx->domainauto = ses->domainAuto;
 	ctx->domainname = ses->domainName;
 
-	/* no hostname for extra channels */
-	ctx->server_hostname = "";
+	ctx->server_hostname = ses->server->hostname;
 
 	ctx->username = ses->user_name;
 	ctx->password = ses->password;
-- 
2.43.0

