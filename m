Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE622FD665
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 08:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769848420; cv=none; b=bbEAcPkM14lXYnHtViWpr7teq4v0I7Q5ZJIaT1z72F2eOwiiL8XQyeDsws4vnW3HTzG8kT6xS+uuM5ViSUnlC1TqcpO9Fdd6sTil7EUfuJY2FWiHp3Uf3dh3PQlvjGpeAIG3HHq/uX8OYOJl/6VCjqVw7iE4mc92qDrQjk5sO1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769848420; c=relaxed/simple;
	bh=oqlPZIT4MLQXSa1ieiGX5oAiYqXDOPrN/FOZrakOBXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0VfpJt6DSG2568cRZO/L0bm1np/mAer8YyyKrlSO2VvRWt6fIJiUABGTNtjZHuq3rznjucrW42ofjNg4HyWXdeNEMOH1PrtrIRsUks6uXMKPz+XtEUg30JDhXs6RYk4jSiv9EKZ5EfC0NvXWT1yWQ5sG561dEe//c5KgJENrZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ts4T4+rT; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ts4T4+rT"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8230f2140beso2139478b3a.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 00:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769848418; x=1770453218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMmmP8vI0QxvxuThbE7B2eYmpWupPqzyj24reB8xSus=;
        b=Ts4T4+rTGkQ9ySJ/VLbw4wp/DRIWIX2ZII9nCsCqDcAoVgcwgQYt9GFB1LlNwhrbcU
         kKpTN8PaobH0ra9CycXQzBt3rwD8r3IV9ZS8PZiier6iCwH0kK35Ejd3Txd78wH+vH2K
         2DgyXCTKwutGR/rtDAO7Rbe84uq6w3aBQ62LT8e12pqV3hHx7qabj+jAsOuZ3awbk0Iz
         nfhBASaeH9iOi+3Iqkpwfby/JPG/snxwm7sX4JBFdn+d1PqdYzVlHjhCMeKjw8l4sOkZ
         pHwEo4Ig2Qbf/CA98Bwi4XpdM9reOSpgQuNuhElVhYVZSq6ZwfMEcFm4y8xBYaXHVdrJ
         yxrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769848418; x=1770453218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oMmmP8vI0QxvxuThbE7B2eYmpWupPqzyj24reB8xSus=;
        b=BvC1gVzUisNv/1LAJ3QtLenmJvxhskILVDqzMLojJPbMh9ztpvflRLQhlG+JojBMJ9
         lICkqbUv7IavLHhU8MfCPG38YywCyZE4lzTwFKpbUS88KBK6oPYSeNJrBBcZuvXlpJqC
         cm58eiM844fHWcLqJpqq1qpa5o9RV3j5Vs0z51D+JjkgSmc+qHo1GVoIRH+WzEAPxaMS
         kIOahuFOp2eXD2autwHOc2UwA+o2UXK860zQttgBeLwDOMbwhmGkWyEO2mLsi28Qz7jh
         ICNqu9CPTYcDZfS5kYCViUFNmsn/V+Lq2Y+gITZvgcUfSZKMUNoj7MRtj292jLN7CcYw
         AIIQ==
X-Gm-Message-State: AOJu0YxbQGGM5EZLEWgKPjRQBrPBGGp7tey463cbPtGmQA2XDmzm+c4P
	9NIdULXvmukxW7mAhxvaqdHWAYYmFEv7olCS0z1HM39Hm0aYqMtUuq34cIINjC+Q
X-Gm-Gg: AZuq6aLc6yJcHZvbH6zqrXLEMMn607IAiBBQ/pUFM19LalpxzKuEAA3atnMFgB0TqSc
	cotfyF8drsotrH3uFBLrNkpYoQZbJxcMolDXVRhHecnOhzrsrOcsuUgU6Raw+QwSoYkckFqrUYZ
	Hs6BTIecE7EhSYiLxX1ubigTTavFl51VwBL0ag9MoGl2RghD73TCo5m3y79kKv8I9d819P4v1Pm
	44knN+I3jhf9z+/ncAT2oOln+HZ/A/AHiJHXuV8MO2IbowkZ2OdvTVH1sCa/YALwIPktJw+zupD
	2KU7UFsyFjMB5uzeoI0FgwAFt5WKhJJvppcz0LdczZTeINJEuQMHK8f7BlKjdWgekhJI4kgonWT
	73dbOtR3LfgAGeu1S93Sy7XWXd6PYwJm7IoYF5HLVHBKNGl/RceAJrfaXPgLlmMPQmY/lA9uTHA
	+6v293RLI1iJbffIEucGbqbOUQExoKxv3aQGHJoSp94tXy6gNtUw==
X-Received: by 2002:a05:6a21:6182:b0:35e:5055:1ec with SMTP id adf61e73a8af0-392dfb1ba92mr5637838637.17.1769848418248;
        Sat, 31 Jan 2026 00:33:38 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-353f610266esm13479121a91.4.2026.01.31.00.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 00:33:37 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v4 3/4] netfs: avoid double increment of retry_count in subreq
Date: Sat, 31 Jan 2026 14:03:05 +0530
Message-ID: <20260131083325.945635-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260131083325.945635-1-sprasad@microsoft.com>
References: <20260131083325.945635-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

This change fixes the instance of double incrementing of
retry_count. The increment of this count already happens
when netfs_reissue_write gets called. Incrementing this
value before is not necessary.

Fixes: 4acb665cf4f3 ("netfs: Work around recursion by abandoning retry if nothing read")
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/netfs/write_retry.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/netfs/write_retry.c b/fs/netfs/write_retry.c
index fc9c3e0d34d81..29489a23a2209 100644
--- a/fs/netfs/write_retry.c
+++ b/fs/netfs/write_retry.c
@@ -98,7 +98,6 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 			subreq->start	= start;
 			subreq->len	= len;
 			__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
-			subreq->retry_count++;
 			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
 
 			/* Renegotiate max_len (wsize) */
-- 
2.43.0

