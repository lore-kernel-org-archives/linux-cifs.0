Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794DF30E827
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 20:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781814937; cv=none; b=bAodDrx4y1EHmzYZ8Eae55CduJaqr0mfGxD/DA3GyyI0u54z3BWGlvh/732IReIM5WBA8quTIrBtGYlTEEhT2iz49Kk6xeDWmfABTzuV2FbDZq5TpIsUeW2+3c4H1H2hENKwbwbe/2ATBjsqMBy8HoIx6gdSUTq9+pF+q1uds9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781814937; c=relaxed/simple;
	bh=0IkNhknHyz4mHuG1nCg8NC8U/vDkU9MvLlYtFKktuSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8BI2Th6QUHMzbQ+Ycvd1kRszSmPinA6wIeLmiYplfTO6/o84C9i7/3YtdRskrCZ/RiL3ZYG4MlsdHsYfzt+faDvZSSCc1cD/mAGll+X/gIz2P6H+gK/QIYO9H/Sh0I1meJ+oU596i6Hm4ksMmCbjT9PTVEhGSMIaNDjHP8ICNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LOUSgmzZ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LOUSgmzZ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-491609cdd8fso8201725e9.2
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 13:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781814935; x=1782419735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+j+mSbuQFwug618Cnlh928hf/0zUiXE/zDnbLuqUE4=;
        b=LOUSgmzZKeNrXSmmqr95xc2Gi1wqU4XW+uL6pRDZ5PyUycB6lgoWtqcIBLm2XtnuX5
         fEz2kR3Bmn8HS9fl97KGevhju/vZ/73x4XYGaEYP8y5YKRLXCi1/Azni32ERdIoPnfb5
         qNK5o0oWvwTuJ+vZvnVPO1R1mVuc4CwMXcVIxZ29hms/PP/5qiSc9wN/BoQxOTsj5AEd
         uNGQW5ARR3PiDpvnR3tsLaCIdqSltOcfMOBz7GrLoT+MQbmdDXDAaO6nwc2IJDWKpB8P
         h7zKdJh+1mmDQIudUtzzM0L1RrnaDwRsrCPReUElF/1WfHyuUS8iyjsOh9E8sxNsj3Id
         RRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781814935; x=1782419735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m+j+mSbuQFwug618Cnlh928hf/0zUiXE/zDnbLuqUE4=;
        b=cdgvvRNCH95N5Dq2cPHkDAiBoJ367R3JocRyBR8NJDoVw2PE1shhmvtR/SCNGkLdip
         KhQfCPBiBMbs1hYR4VR4Eem7gNKy+OYsRAGSTMkXc8x2JouJLxyt+uMwuRxpGk6Ym537
         CTrjMbkCGvAyGgeSbo1WOkQ2Ej84Z6LEjaVSJkERc1lucZ6FR0Cz7In7PNt4kF3PqFCS
         8Vump5e0aS6Za5w6pDFsPDrUio+qqGbO//kCScmGx7jYizMI/VT+Kp5ys/XhKVpdcu1s
         jrH21GjXHFRdjhgpl6ot/2cOHvOvx65paiaPI7OYCGxbYW5rCg+TzCSvrNFVRf3E8Cmg
         PEpQ==
X-Forwarded-Encrypted: i=1; AFNElJ92/0Xayh03/2d+fK1u5oDt33dnaUBeV6jV3d445QK+8/8WCm8mLCJBdnZSl8nR0obObxN6aZZ76Q5I@vger.kernel.org
X-Gm-Message-State: AOJu0YzTbSrlRmrTIGlrmOW3dhvkZV+JHTg+2+ebxgE2qCpBzXv7ISFR
	Abgr6StHZlWnY11+JSefVYqGCPCdbxca4fS5jv632kHgZWyj8nII88Jc0hc9DN7LbWc=
X-Gm-Gg: AfdE7cmcTwWLWVBmrLIQX05qG1IBIio0n46b3zGJgAyHffaHVylgc73MHSt23uaAjZg
	AmCdootDiZ42JMKd7D6jzoMT7TZNjRHF1+SrPfhtE0p/dBcN3r4ns5iai1AkwTorYwIRTnwrKAO
	nMeJqpOdDOWJ80ICoMpTE7ebduIR1sH5fWn437pczy5oldtkO8mg5Opvh4Iz8OwbhZV+gwZs7ji
	IlcCsLrBAaR1LSxn+E26aY0l5siFeVc8qJrfR8iUBm3+C+F7ldYYwWrEWoIZxpKzznhugxL71jx
	5hdbDIy9FkN2Iz1DVc5lOCN4lbv/57GiuULTfS678DiSR32tnvFTH/2gxUlSxH0EuV/0XI0NkCR
	wyKFK2wDgSl/1wmdhiAbIKIXG883BfnyRfSxE+ZQBoSnetzKIfNrZBv7zeAc8hi70QVpZ7+anO0
	3i3SR76KgmGb7QElM85UhJ
X-Received: by 2002:a05:600c:628f:b0:490:bd66:e522 with SMTP id 5b1f17b1804b1-49240e72434mr7528595e9.29.1781814934792;
        Thu, 18 Jun 2026 13:35:34 -0700 (PDT)
Received: from precision ([2804:7f0:6401:b508:d1d9:f1f3:d91c:79af])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-966fc32849fsm439109241.5.2026.06.18.13.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 13:35:33 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 5/6] smb: client: fix change notify replay double-free
Date: Thu, 18 Jun 2026 17:34:37 -0300
Message-ID: <20260618203438.667881-5-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618203438.667881-1-henrique.carvalho@suse.com>
References: <20260618203438.667881-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_notify_init() fails before the next send, cleanup
retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 6e6aed87ab0a..7d4b37b776c5 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4116,6 +4116,8 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 
-- 
2.54.0

