Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA2D3BFE3B
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 10:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728825; cv=none; b=M4KvAMga+Ivep0uR4zOU6fj/aQ0J1XEf9zVZZTTKLb/fISMNf7qE60K27bwDM6jENzRTT+2N6zFSW3zLc8m+HY8CxFO0LSg0Ai0LWmS+z5xGfn0/fr0KBbJ3XuwcLSY2Zu02GaoHbmisWsZqWcuaILGOzRe4OvzbmZ4cU1iDjlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728825; c=relaxed/simple;
	bh=6TPnAyyGNUFwf3UwgLYzDntqqy8ykGYMqTD8B/RAEEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnWSSBiatjgzrVVhqCEqGeQXh9XSyCDwpXA2l+qumaHMHXQdnE8/jxamZiO+DPIKSarI59RWYDxYYKwZ+3LUEWrWZIRDRsob29lMG3LrtnO6aKuP0hVZVXhcSC7Xfk14A4GKd+3VWJ1+kG7LfbGWnMBzMBuSJpGYes0t6ypF+7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XBpknkqL; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBpknkqL"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82418b0178cso346213b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 03:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728821; x=1776333621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQbqX/BJZ3dj3vxFVKk5Uqao5a39anh0K88Gy4Lmf+s=;
        b=XBpknkqL1EMz8B0ARBUGb7ZhVyr8FjluEGMEGoRj8bHAwg0NqsekAdo2JwU9In5d63
         jIlVJH5FdkXuInk1yO7pVoW2xj+OtBsLg0PV3JRaeZBij+yXqmIXmSq6mWhX6qhofgdK
         BR+sLGl3NkkZ4i6AFtMu8lP+eF74IAIgbkGsJ7f5d5UKKMh2IAXrmIvv6Pbox3qwIice
         7EAyDlgUvhq4JNFKCu4/iDK7PVbVUIHV2Gp/P9/DjtEN2xYUCWfIkg9EPM7MXY3MGPVn
         jvPdX7OuHK+0gaOmzIDnH3P62AinL1dVhytjik6bzEK9sgQq7Xetq6/xa6c2UXxXwr7x
         MWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728821; x=1776333621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hQbqX/BJZ3dj3vxFVKk5Uqao5a39anh0K88Gy4Lmf+s=;
        b=Dw4wSxg/niFLHH5d0hAKm13dwBviqdEjkdF/bhjd19RBK+EXGrjBFnbyZTrQOCGQbM
         sOoccDvW4LungA/2Z+t/G1wj9TwNImqgIPmnztmyBM8a6r1J29O3Lux67XALGAxoprZM
         oTdcqzRYKpNKF7MHeBdhUelzddQSDOCti6deCcUOcJd3HU7ue8Z9+NM7jFFhPMw8iEvK
         PT7CN+MhA9z/Dl4woCvDiVD1mwJiP3IoOiDK2lm7BrhotuRSWVBEY8OMlDNjy+oLGf/e
         dfMkmXgH9vuljNmf+S6B6kk/m32vYXUxO+PPmr0bMk7t8e8/2Bx95sDH6wmys7N0O75u
         D3Iw==
X-Forwarded-Encrypted: i=1; AJvYcCVsY5qo1lwb4XyvpJZXjc6w4D1GK+D/+puDa0uIX0/acwpoilen8FtPySou+x9D6xc598XphRYfdH3e@vger.kernel.org
X-Gm-Message-State: AOJu0Yz96HXV137/YD6vTyh9Ux+7WL0fuWIyJ4BJ9Bdjue8Shwbzblb9
	iCKnf8Xg0pq0z65FAXe/aiGwRzkNs+16euDa4k8GF3N9mmfd9RtcPb3s
X-Gm-Gg: AeBDiesx4kk+aEZrOoojPB/yx6kQ2h9nZNZdX3XInMyqcdnkMNxty6b/3mHIHt1l1EU
	IXDlr4lB3J74w9a/kNns3scwolbI9fKFFdsb465douxha0IIqw8Bi8/RI18ZJxwphiMzXmq0YEz
	PPZx1C6sX5bejfltoivMOsX1riMyX0tM/hGmCOLNzGaoxQpsEfd9UMF9LqeTTWXUwmVOcNow9tp
	WDFKWa4HLhS0ILXd2Jm2tFqANeKJ/f0lJOqWXDnv7fKAw7RahmJtD5Nz2JlISg2mPvUiKrbfhSZ
	EK8HZLxKOUe0+0I84MxTgX+0a987A6dZAVgo4AfDAz+LMXPrZC4kL1fXiwNCvlf2ZQHhNA3W3ED
	9bLhFxINFaVmhOoBbzBXUvct5e3AaeTThmhpjZcOfnDRr/f0afIRwaHb8QEgcRW/jTfMMpfiEh5
	Xavnn5ZVVPMoknti9sc0v3t4fOrXm1NPbBFzyCWSvYTxDTu8DYVNVMjhstmgO0Cx9ASORiLFyk9
	y27tKw4zRFTGelppQqps/A=
X-Received: by 2002:a05:6a00:1ac9:b0:82d:24f:2516 with SMTP id d2e1a72fcca58-82d0da2b115mr22230169b3a.11.1775728816262;
        Thu, 09 Apr 2026 03:00:16 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm29113671b3a.42.2026.04.09.03.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:00:15 -0700 (PDT)
From: rajasimandalos@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	metze@samba.org,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 8/9] smb: client: fix domainauto remount by syncing domainname from session
Date: Thu,  9 Apr 2026 09:59:25 +0000
Message-ID: <20260409095926.905020-8-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-1-rajasimandalos@gmail.com>
References: <20260409095926.905020-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

When domainauto is used at mount time, ctx->domainname stays NULL
while the server negotiates the actual domain into ses->domainName.
cifs_show_options() reads ses->domainName and outputs domain=X in
/proc/mounts.  On remount, libmount re-feeds domain=X, but the
verify check compares against old ctx->domainname (NULL) and rejects
the remount with "can not change domainname during remount".

Steps to reproduce:

  1. Mount with domainauto (no explicit domain= option):
       mount -t cifs //server/share /mnt \
         -o username=u,password=p,domainauto
     At this point ctx->domainname is NULL, but the server populates
     ses->domainName (e.g. "CORP") during session setup.

  2. Bare remount (or any remount):
       mount -o remount /mnt
     libmount reads /proc/mounts, sees domain=CORP (output by
     cifs_show_options() from ses->domainName), and feeds it back
     to the kernel.  The kernel parses domain=CORP into
     new_ctx->domainname="CORP", but old ctx->domainname is still
     NULL.  smb3_verify_reconfigure_ctx() sees the mismatch and
     rejects the remount.

This affects any server that populates ses->domainName during session
setup (Active Directory domain controllers, Azure Files) when the
admin uses domainauto instead of an explicit domain= option.

Fix this by syncing ctx->domainname from ses->domainName in
smb3_sync_ctx_from_negotiated() before the verify check runs.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2be72733ef2e..d804e5da578e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1232,6 +1232,9 @@ static void smb3_sync_ctx_from_negotiated(struct cifs_sb_info *cifs_sb)
 	 */
 	ctx->ops = server->ops;
 	ctx->vals = server->vals;
+	/* /proc/mounts shows domain= from ses->domainName */
+	if (tcon->ses->domainName && !ctx->domainname)
+		ctx->domainname = kstrdup(tcon->ses->domainName, GFP_KERNEL);
 }
 
 /*
-- 
2.43.0

