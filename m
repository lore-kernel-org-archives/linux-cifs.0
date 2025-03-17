Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DBF221558
	for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 10:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742207307; cv=none; b=g84d0jl83PfV8lR83IglRiRs1zUtuHsvtjzretWErUgGSYODoCEUfVmOGgA7qxZnARhpCbxmyRRjNCXz3H6NXBTv0JmGOTpl98nY/mceKO68kOdCejiy0+e1hm7A0aYuANdcfdyVaAmaJ3vLzB0wjgdV6D/ueEZZUgDOULtYzg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742207307; c=relaxed/simple;
	bh=5tQorah1bZetOU4OzdKCRbF00BfGQ1JP7Ey3lXryNCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0KeP0SFvW2XgnkOruMnlNrw7rhwCuAN6xSFm5SDMtC8xqAymDi/gkPkkyvQVB+vXHEo+7FZseOk/oUEAonEW1p4KTOzO3+gWwTpgBPxpeSgRqvIOBG1J41m7l9G8oJ2Zztc1KHy8jAKwjeTq/9RQrj2M/fZJCzSa5zKJeMZfjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kqnJvhMW; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kqnJvhMW"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2fecba90cc3so4164123a91.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 03:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742207305; x=1742812105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/mRydKfbUvIsMpF7WoACoY6ufihfwIRFP8PTW9XM5Y=;
        b=kqnJvhMW3l9e8ZLo5dkbVjnvPwo196lL29QDnkKCto/73fJzf0rgtvCTEwXkkzeqA2
         mn/F1SnJUQnpkkUtAUolnr5uLUIJFxqu+my0v2Oa4Ro78CnZhTsUhEjfm8S0BXlegGFG
         DQBGqW3eQDhrZVdW3lvZgNArpwK1OCWXX4pxftISsl07lCTnOuT7bHqGtCB51d+9o3Ad
         Mbx66DFfJY+OAOLucgfREc8YF896n4RxIj8/AJ1dEb/KY6JRi4rYTEcB+uphGKEI+f9Q
         iyvednRSNNvClGsC3SKVGn6HngXjdrU0VSH8ifmMeawbhotiVfXxccwXdwZezJzb0Mnw
         F5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742207305; x=1742812105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4/mRydKfbUvIsMpF7WoACoY6ufihfwIRFP8PTW9XM5Y=;
        b=jx2KFxLm7XIRnc3xhVafrMF8LHg2JkK/B74HIJfnPnP58iw/f/diJa26SOjLQ9/YAn
         gvWoRsrIqjSUH8a7wlez90A+/McgR6/m0nrP/Nj5AeQvreqN3aMgZfW56YE8LrELzrMK
         tYsbGK0iOWH5VhZ2csq+JkG9Tp+kaD0giR9OkAg8hE/rI1Dbwe+zdcVV6ZwiO/h59VZ5
         ujFFEevky2S6DddbfQNArKEfuaSdPXNd63qwDRWXpP9gOo1BGYoUF2aHc9c25MWdItKM
         Ex7i0Y6cbDtxIoCIimKRWwr0z/CAe4RE6KwjIidPcyB8LoQR81Dvuop4OlyY8PPOJj6L
         RwqQ==
X-Gm-Message-State: AOJu0YzEouevFZMXSNvtHdwv6o7bGIFLX1nIuQrVkPzc45ikIwjCcKwS
	2bJK7EBYbGGbUD9/jDqgVUILLmutg9lT86dZ0ungDwzrs9cPkmbW0JJx1feY
X-Gm-Gg: ASbGncsrDLaiyHPZ62gpcp+6Ksw/xFMPnOnwjS3XIP04h4BidfT23ITDSlWtU7F5+Nn
	piN/y0h/N5am72B2allyJgPcVYSiACJLxo59MF2DG+TLfsF0f9j7x1yecHxvhk8RzmkY6QnhHAu
	OlNRzTQQHCaoDqe6DYpzTDyY1p7k8lcjHanO243lqLewknmfMV6i9bUj3fWYcHi7HpaxqihtSzW
	ubUHgoEk5xcPyKuz5h93G6pMmEVyX+Gt/sz+sWW1Ee1RPJCJ7jlGG2Kk03tbVfLrPc20O95pH9W
	PJP0Qsk4HQbFEPCy67wREaPCQmxplnSeuu4o8YN55fSHjsvZkg/ycnIabYVYqDpb+SJrjw==
X-Google-Smtp-Source: AGHT+IHjab6X+dG6QiPdEALqTQFguxgH4ebzhIukB7NrHmf22QA320jvlRcF7X1qDtbiPNcEEkIFEA==
X-Received: by 2002:a17:90b:520e:b0:2ff:6a5f:9b39 with SMTP id 98e67ed59e1d1-30151ca8599mr16162749a91.18.1742207304807;
        Mon, 17 Mar 2025 03:28:24 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.189])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-301539ed069sm5738238a91.17.2025.03.17.03.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:28:24 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	pc@manguebit.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 2/3] smb: mark the new channel addition log as informational log with cifs_info
Date: Mon, 17 Mar 2025 15:57:26 +0530
Message-ID: <20250317102727.176918-2-bharathsm@microsoft.com>
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

For multichannel mounts, when a new channel is successfully opened
we currently log 'successfully opened new channel on iface: <>' as
cifs_dbg(VFS..)  which is eventually translated into a pr_err log.
Marking these informational logs as error logs may lead to confusion
for users so they will now be logged as info logs instead.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index faa80e7d54a6..b45b46b1b792 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -242,7 +242,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 
 			iface->num_channels++;
 			iface->weight_fulfilled++;
-			cifs_dbg(VFS, "successfully opened new channel on iface:%pIS\n",
+			cifs_info("successfully opened new channel on iface:%pIS\n",
 				 &iface->sockaddr);
 			break;
 		}
-- 
2.43.0

