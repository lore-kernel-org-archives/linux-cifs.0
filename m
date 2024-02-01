Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6BD4DA08
	for <linux-cifs@vger.kernel.org>; Thu,  1 Feb 2024 11:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706786154; cv=none; b=kozvI/bMoadqXddoL0TpqIj+08TY8puAuDAvsTkgTWYzwRqhJCGPITTxCr9/5ZR8uXE5tVJ0I0lgkj9cyfYc1zf4NceN+gBvZYXAvD3eXTEJ/YGGov5kdGlERwHqK+KTA1YRCVe7cAtKPp21ObIxnlyR/qGy1zOUnL3fWONCavk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706786154; c=relaxed/simple;
	bh=tlfDvHzUHCHT6uLD8Au5OByKgIy1zAVj6JDmY9/3Ly4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uzUraWyR7XNLAlv9VF03xAOKoJ/Nu4eYv7yvm9ZmTewLWFuFja2GqmhA0SK48rLdWAabbEAkMQkNvVpl/u8UgTv/S6S3xoh24MFTnsucZ2x0XH8oKGcyNIvTi85W2puccP8M1NY8SWwyRvD46Ul/NVMe1ZZ1El+X1+jRVDfmdcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=br3GanOw; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="br3GanOw"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d9607f2b3aso52285ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 01 Feb 2024 03:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706786151; x=1707390951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KU+Oocemi+2CLgtXajNMOvK0OABANDk7iYuBTSElxY8=;
        b=br3GanOwwdasAQDCpln0e16TCm2KK2wmRUtXM6Cs8KIQAbTjcsET8zc4wam+TtH6o5
         kUrsikuuKK3d25EWb6xSNn0ixhvEiRsPi/ICFIsz59L5Vqe13D5/VqQS7wRfhnpd8hKU
         65LBeQySDxkohgFdIbBepmLD3j35k5uTpVzghWzfyj9dygtx8E3wy8R9T8IUvzvBywTL
         S1bgRMPz/t6+X+3qby5Hgd6N6RBBsqmjTanku8RUKqEgE3gFVGbm72M1ONQ9EHyFhfOC
         xu7NV4+oc+T6FpBA8Lo7Jb4bHoHyU06aWMVfAbojQxS3HwaSFy+yq7d9qD7uUbYw8c+/
         HjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706786151; x=1707390951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KU+Oocemi+2CLgtXajNMOvK0OABANDk7iYuBTSElxY8=;
        b=EhEgEXY1kACP336C6NirLAUqdnxQ+QZz/Vf/OFdvXpMx/8EigWnmJNoyTuQZ3iUvAG
         si8k4ruMkbDb6KU7XZjTY9ETv1yU2+vUvKCv0x81IkLR1TgjkwRNmOTOYzuZpn5JSK0n
         guPlrqeCBGeWneCojutyz5VFlEFVSaZXXMhGeLQbFhrhmUlEZtMZRsNQSdT3elxahfgB
         Juh6PZDXnos+RRVL61ULbJwJGavg6G/4EHEcrYNNFEmefMwbpgmFF2uzX2W9OfAU/+m8
         1rM62dQrF0Xe23XPHu4Gx0F9G4BpXRZ14c8ctFE5u/Hh9JbA8s9g5o7JCBY1FggMo6Lt
         BsZA==
X-Gm-Message-State: AOJu0YyLJ6j8aY+J1j8laZxj788jAMEGVGpIKuVOVOBGbhZG1uNc4DOO
	yJ0UZbTYn6OLrhWbJFRhYCEraNehbssCzqS7YZ6Fzrcvq8WC5Vdig4+QsmAp
X-Google-Smtp-Source: AGHT+IGe/szvWT7MskuGPTmV6Zr+ezo0ceDjSt4GwiccVopmh1TR4hy09m1+YhI5NBO2haLMJQX2oQ==
X-Received: by 2002:a17:902:ac86:b0:1d8:ff72:eef8 with SMTP id h6-20020a170902ac8600b001d8ff72eef8mr8938697plr.18.1706786150966;
        Thu, 01 Feb 2024 03:15:50 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVqm6sHLGH61nsa5wDoQUgtLECqvqhU+JaUfG3yJyGP1zTFjxuIAv17FFle8/opR5ny874fmnt6fdAe/2R5rl0UGo1jVN9RBSQ9UjO4znJXb8yqzVE6IHL/kDWJyRjqyjaHYVHxsp/ETGk6jrQs
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902f69300b001d94c4938b3sm1129926plg.262.2024.02.01.03.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 03:15:50 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 5/5] cifs: enforce nosharesock when multichannel is used
Date: Thu,  1 Feb 2024 11:15:30 +0000
Message-Id: <20240201111530.17194-5-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240201111530.17194-1-sprasad@microsoft.com>
References: <20240201111530.17194-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

In the current architecture, multiple sessions can
share the primary channel, but secondary channels for
each session is not shared.

This can create two problems when primary channel is
shared among several sessions. For one, there could be
uneven utilization of channels due to this skew.

Another major issue is how a cifsd thread can get to
the channel for a secondary channel. The process is
already cumbersome. We also need to find the right
session for the server struct.

To avoid both the problems, this change marks even the
primary channel as nosharesock. Secondary channels are
marked as nosharesock anyway.

We can remove this when we fix the mchan architecture
to share all channels.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/fs_context.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 82eafe0815dc..e7543574ea9e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1043,6 +1043,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			ctx->max_channels = 1;
 		} else {
 			ctx->multichannel = true;
+			/* enforce nosharesock */
+			ctx->nosharesock = true;
 			/* if number of channels not specified, default to 2 */
 			if (ctx->max_channels < 2)
 				ctx->max_channels = 2;
-- 
2.34.1

