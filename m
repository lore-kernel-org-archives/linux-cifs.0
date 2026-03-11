Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBD3175A81
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 05:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773206358; cv=none; b=oqqcEze1pfNr6qKWEeZv4f/D0SD8WQwNiEdK13cBIRE2Mk60ydY6o+SrIIk6S+IZghOkj7VPGcOfJmEPVq94DJVYnpkmqCMd+C5+fUc+b2uDQQ68uqurBOxfYDf1as/CRbz0nchhsQKlDCf+uE43fwj3BIKNPqVp/bcdNRmJhdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773206358; c=relaxed/simple;
	bh=/otAp9NdejqBs41+FT2LB5tb9QwuRBvG6lARjkW9TE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c1r8tCFOElm/fHOSblxAs0PSpPG5xOU9epWt/kqpZJLufJGtRw2AQ+AyvKVD6OGSd7Y7+Kr83VJ0ist2V3P7tyOeaPS9WQxCfEW55wcvufnHfv+z+cF1O8Yx3pcOXhGRYUU2YXi4E7k/ziDbDLYOO4BWfVZgaWlzix7PwPIxiy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gBL9mSe9; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBL9mSe9"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82985f42664so3524273b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 22:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773206356; x=1773811156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D/V5vIb9B8E4ZT9kdnjcFWofNvOiBc6LRtGKSykRz08=;
        b=gBL9mSe9+FHYM76ySINw2WdyTPXVbx4Raylo9b/2GUZOWyzxHZppyKE/hSm/BUwZgv
         2oQnAWfT2bvjD918ajnanPkY4MHd0OrH1UYm/rDs4kUZD9FNLMU5WTGNvEC335TcOELH
         TByS81ZH4Kvm94HYM9fcast6EUnXkDY3h+IM9ExxM9QcM6cirKpuMLA2U2sjLXgf/viS
         uGKS1fb1XsgAujAsEUHWsniKCzDnp4vwCQFdlJzPu/Vi5YXUWkUI310S9ukmR4b4tTFf
         34MjY+SjhE2bXasWB9Rs9RJQ5r4MOrQ5u+qKK+wA3NWlBm/CBDhSAjTOSgnl1qkvqEQU
         qeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773206356; x=1773811156;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/V5vIb9B8E4ZT9kdnjcFWofNvOiBc6LRtGKSykRz08=;
        b=JLS2dcrKJgthXCzGEfARSkX4Z8XBozIGpKEnzvrIp2ssG8Q328GQmC+HptPrvOwEp3
         J+iiBjcoQtYwlE/JvJ24rL+efQnWJ2CW7NOjWsXxwNJIw7dquEp04T7UDbMH/Il2Xyqp
         MEOyqMsMCSnkTF/NvmfIZEvDfTM+VcZbmYVFinbqY6iCcSDlpSRsESM4B7FBXKz3F7nt
         JSuW/KQJrdEsLjE2GXXoSMROohJEQFD4tZpOpRwGHAdqTXgY6eZYv701vVNsn6JoBx4O
         1fw93cI0/OjSUimRVuL0Fzn8DhIxAHa7602VJyJ8BFOjI0cwYJ4wwH1eNKcBNmAPRDC3
         mysA==
X-Gm-Message-State: AOJu0Yyy7BdL8KsXQMCewtFmXu0Yk3mmvl/ht2U8x5GBGkDRUXpkAnJP
	s8ahIpXA6FMRDB5jfK8Vgcbbjrv+ofC7fY1pQgo0JzNKUNv+4TNwPgiZCBEaiw==
X-Gm-Gg: ATEYQzzlUPW7IdawxGwX22UUigjqL7+/FFy3wDZatmO6hFNuIUvdnadQ9u6dhFjEnUZ
	Zr1hasqys6VwoIiGXKW38mwsVttrxeK0ChGHTgUzbAsXvccs/IARDFSd9/7w+oIGzfIqj9og3up
	nxludJmWOkiKduko7Fc31O0eyNaoJHvts4JXyGlJ8mOypAp8sr225hWDllbUPZ8LmACKONAG+gO
	dvqV/HyFTowJPHZ5qechULHIfi8TfauF5pVpDdKnq+cPyFRZE2MwqNqEsqCrwbVCNgq1J8EbMHt
	1I0dDdsPOxaljfP7o2uJx4DgWsQsuhKwGLERv961j1D7TpuzHns8GvQdri3HNmaS2QZhqo/aRNW
	7D++Hs1SVB7nvPAZ3o/Gl1yLuPOf3XG0TGI+HoPB62x3SjDsgzEdHJ8G5hSZj8A8C2R7I1CzGmY
	MUS/ujjwcf4EIvihp5BnBo4Z+TRryHuPzF6LUFLTcH+F8f07WF/KA=
X-Received: by 2002:a05:6a00:950c:b0:7f7:2f82:9904 with SMTP id d2e1a72fcca58-829f6ee86d6mr1225830b3a.5.1773206356392;
        Tue, 10 Mar 2026 22:19:16 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6c2fdcbsm988821b3a.0.2026.03.10.22.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 22:19:15 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] cifs: make default value of retrans as zero
Date: Wed, 11 Mar 2026 10:48:54 +0530
Message-ID: <20260311051854.2584907-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When retrans mount option was introduced, the default value was set
as 1. However, in the light of some bugs that this has exposed recently
we should change it to 0 and retain the old behaviour before this option
was introduced.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 54090739535fb..a4a7c7eee038c 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1997,7 +1997,7 @@ int smb3_init_fs_context(struct fs_context *fc)
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
-	ctx->retrans = 1;
+	ctx->retrans = 0;
 	ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 	ctx->symlink_type = CIFS_SYMLINK_TYPE_DEFAULT;
 	ctx->nonativesocket = 0;
-- 
2.43.0

