Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACDD353EF2
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708275; cv=none; b=BtIDTtnDhXQr2JzLhRjVqyB29T5r/W7b6Bn3tV6QYmCYy+fh8PbHq3ryRKdL246I+dRxKfpKzKoxJgnNx1wuzNpSbhUbcqbRmVKko1j3zOZkGlFBj6OzJNGBiApP+iOQNFODz4xMee0Iq3Xb/McGN9MFjW0uwJi2hngKNvelKWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708275; c=relaxed/simple;
	bh=epHar85QZNn2jQiJ+e6NQdZiflb3Xgov2Bv+VbUgWAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEm5Ta3lpP+fTVT258NnUJxUVb93Eo2G4uXLEnPCWqPOmYK907wN7OJAyWJzrAOmMJdXk9kDxruXJgK+2g4figViTYgxyVfl0t0g82+A4+AAarxe2BdYnDXJBlPt6smITq5WFvWS5up4ttZmQ0ZQVuILs26bGoXNyeFYXkryZes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mfzG8DdD; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mfzG8DdD"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8230c839409so1145444b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 09:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769708273; x=1770313073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELonzz1IwIu+oEcsmAQI2aawMls9vRcbI3ozJBlZuuQ=;
        b=mfzG8DdDbYxb209bl0Yd8s1kjC3bzfUpEmS13tSvt35YjSIHyuenlXKfGMqP26Ffer
         Ly3eL64c96sT9wt5+Bir/pqus+BWxmG+vt1dpXiALAtOou3WNOE7vKAP69stydL/VOpy
         9SyAYzz2prhuqXzRJE1qiaJ7FQEJ7gek7ZvJUIYmEiLmLQkWXWwYRYdqKPhtsyEsosNw
         OMabfyGXrG9cZ7h1TYqbK+PKJuKV+98QcmnSSVO93zE80sHaccV7uAm8WsQk2jlVMv0r
         1246rDdyvynNntmcN0rjTjet98jZB25gmlNhsTG2wemKKyH9wXSF/nuNIBdMpHs904Mc
         s+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708273; x=1770313073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ELonzz1IwIu+oEcsmAQI2aawMls9vRcbI3ozJBlZuuQ=;
        b=mu9wQbdjzKq7CIUf8q2jBi/lFYrjwPI3offl1RTvt+OYcplqp2alDTBsPclzffeXVq
         QIidLUu44iHTlx91rdQM1pvPcfEOchTFz8rAiKCeM08hoTgR+0c14B4xNrbtZI0k/JIF
         xbboO5aZpoiMZMVvNFx8tzU/ALCVXQ92cpic1Xzatykxmops5azFsAiwz4JOrpUf05/l
         TFZQ1hUfaKz6VuzGITm7p09b2sL/apzLoYr+1lsm4M3+YNtUsxB6UzDLJQydpG96KEFS
         ySx8or5stGfjk9tNclG2B1xWdhU6jAPCvc7wfPhLfpydfEQVnhNLxzZnHZlyach02nMa
         AXLw==
X-Gm-Message-State: AOJu0Yynzq9cGgNsES8LywG7hZfpIvSFK+oJErqKyYvO57DcvmCaYbjj
	Tjv/Pd5h7LpATgbRhB5K6IZeyZ2V5fdmY4/hwSzRhlkO2zShJBx6E5Is5EdOwg==
X-Gm-Gg: AZuq6aLn7wS1oHyeZ+lpEh0MhadmTryOnZwVtemWR34kNPI9oOANLkPaABVaSBzTanb
	UAkOc1+eiufkCoz3UPNlMqEo/2MTgaZ4+NiswP4gIZnrSAJhl7zKCxnDV3smreCmg6MRGWC7Ex1
	hoG0idB2XMrxSp9lxvbq89Vl6uhb2Ih2e0HHDMNTSLmqiol1rim+cVnIy17njjTw/Ujpjco5vyO
	mA1dNvLKfcRA/Dzm2wakFEa4Mis4PnWMpjFWClVXUU1nbEQi/WNCQ+T9rOzWwjrE2XqxqC/ivZL
	L9LCzvr8tXkKtk2QjsoYz6/CuikeFjP5Ps0J/9qXJ4ksFjPxGp67dAYjHjYy7yn/4EScf78+0yz
	71Ya6DxLAhkjNgU7wN/H6tIHX/c2iU/fGaVSeQ0wIqHPRkeWWtt2LCtL+1RjPZVWmotBewmh3+K
	yaD3nmTDkw8wcaq1WgY8bTQQCm2IXpN2e3pKxKXuxj
X-Received: by 2002:a05:6a00:349b:b0:81e:af19:34bc with SMTP id d2e1a72fcca58-823692b1434mr8395908b3a.36.1769708273521;
        Thu, 29 Jan 2026 09:37:53 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.200])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b6a5desm5512659b3a.28.2026.01.29.09.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:37:53 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v3 3/4] netfs: avoid double increment of retry_count in subreq
Date: Thu, 29 Jan 2026 23:07:10 +0530
Message-ID: <20260129173725.887651-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260129173725.887651-1-sprasad@microsoft.com>
References: <20260129173725.887651-1-sprasad@microsoft.com>
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
Cc: David Howells <dhowells@redhat.com>
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

