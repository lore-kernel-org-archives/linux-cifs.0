Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FF21F4181
	for <linux-cifs@vger.kernel.org>; Sun,  2 Aug 2026 00:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785631715; cv=none; b=i/MXQcZSTXYJjRAoYLEtabyQHkk7um+7jIhpdCD9cf36s9hT8JhyhRvabir56gFHgXOw0mjHXHW002jANNPuHFWF6sSoqoFu2kQBOcRpdXcu/FUzd2+ZoqKnnDyidYyFNtL7KmHc794Z5MSVbxxD7jetI+JF1r59uyyuJxHLgYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785631715; c=relaxed/simple;
	bh=x49mLrLcbwjonBMEevtx+uckIENW2jagrGAFTjCOiGk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k0ZyLqcSg1My26N8sNZ7cYkO0oK1T+JYwq8M/QIRZxCbULRTRoa1mwHA6/R7+B3iUZVLLF6W5gIm3MPb94AjzimdcYXo4l3Vtqffl/BqryuwV5lAuMhcoBJH6HzZhZ2OtqhfibYVGY4iuPbmM4z/Guv+qj42KsBztIWeXSpgnH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7AG11IU; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7AG11IU"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8edda5d56a5so23082876d6.3
        for <linux-cifs@vger.kernel.org>; Sat, 01 Aug 2026 17:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785631712; x=1786236512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NB5pk2K65CtPzU2Dl5H9xSCf9VcViIIeQF2ExWS/gJ0=;
        b=T7AG11IUeei41LTv2ELF4gcYi9oH2PcnAmLcv6hV8xIU6aTPllpVEjqBaXfVplTwVF
         ShRkysCWEsCBhVNoGDV2cKwwdY2YT4QoN/tFMMXY9f58HeTTkBZuwLQEMkFfUDym2rzx
         fA7eQDiNOJst8EAVUqJyHXWvSNfvn4i+zuQYsbfc3M2iFrrGy264xIyBcLkCS4dP0b3j
         KtOBElibAqtuH0PCoihQATnIKb9DG43T4GxxYAvwbaPC/Wrv02EdbxNEW9EHAig72PID
         bzxt6aLhwzH8CEpvcNn7ut9oHwTAhsLRLwsL4tD2LK3LdWGofCLDAONyYu+bw93JybPF
         tgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785631712; x=1786236512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NB5pk2K65CtPzU2Dl5H9xSCf9VcViIIeQF2ExWS/gJ0=;
        b=MY5sjZzXYflhXKIeqZfCMR1bW0nxyXe+4Ap2yQruVgRAQ29WbGo4EG3SzycgvXZXfL
         NPyVVbCVFbuWRrC34qLGACZpUFtYgFUHq2m4Da1/7stE7wfhVQoOfmsJEh9oNXBvp0W7
         Qgh5LV0aCIQZvh4AkmecvnitCR64Q8giA/4rZ7CGLFFAVUPvzYUnv4QIl8i4wWBcyU5I
         BZxU4S3lxj1SR/yDnv1HabanXjGWFQUv4GqQm+gzwy5n/yPJUUFDTG62/yY7TVvC3Mnf
         mf3c3pVkFrjLHdUeiMxxtHnjzsNIUZ9JzsnAec8u0VbAyiQbqHyGRShAWwSmURIcc1WD
         D3cg==
X-Forwarded-Encrypted: i=1; AHgh+Rpa0hPVOGJzYkEAEsHts3kH/WuAdC7bNXPlUy/k5OLoNYzBWkRABupI0XjApwtv5auIztuq/RTmWO6Z@vger.kernel.org
X-Gm-Message-State: AOJu0Yym8VuG+1vuX2pyy5ArJhagk0Zx5Sbc30gj3ta9mGBWmZxKY6n+
	sqCAMy2ABryNbZXfpRFFwK8pRmfhwD+z8KFkzx6MSG7lRZDMhF6g6d9e
X-Gm-Gg: AR+sD13aQPaCF3W1N+SWfQCj5TuCfroZ9FkbMZK1vU5gDgXngWe2A7vycrNjPbrxacv
	yNYJXIJRytpl9nm/gnpecWRzorYbCEh+dUUDUe7yvH/F+/yyS4QMIpDagJ+Me40wMLWJ2eU3k5P
	VV/TF2VG7mQJnyOG7jU+Xh2sHn1gHsukfhxCUYzcYVKMYLltcnftbIwI04qBemrUBhwMRslR4Vl
	OqQyjaouthwdQ6ETIWHGFRUZTxMqoBrr9fN/KR8rGKfoyBp0nipJagFtCtG2Rwaoy612yY0cLHl
	+FmW04n7kg4zXkZcVviIqV1RqXgZVxJtAe2he0/TuWR5dEEUx+ULIj7JeI0nciaNd1jT8a0wksN
	izohC0S1V7ZdJT3gV/fNZ6dWrBZe2dSj5nDXJKw/MojIUb7Z6DUbItT7u8obYtJU26bd6FIleRW
	QhfeaWAnzd7lyeGwJqv/L/WujWN0Tmb2dp5KT0JvB1w2IEzb4I6GhwjXFlZSLZ/YdPWFyCdzOLT
	e/oRgdajRd4A1eObA==
X-Received: by 2002:a05:6214:53c8:b0:8ef:867c:b8be with SMTP id 6a1803df08f44-90849566facmr113811536d6.8.1785631712494;
        Sat, 01 Aug 2026 17:48:32 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435ed43esm44027136d6.40.2026.08.01.17.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 17:48:32 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: Fix use-after-free in cifs_try_adding_channels()
Date: Sat,  1 Aug 2026 20:48:09 -0400
Message-ID: <20260802004809.1301715-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_try_adding_channels() takes a temporary reference to an interface
before dropping iface_lock. If cifs_ses_add_channel() fails, it drops
that reference and then increments iface->weight_fulfilled.

A concurrent interface list refresh can remove the list reference while
channel creation is in progress. In that case, the failure-path
kref_put() releases the last reference and frees iface. Updating
weight_fulfilled afterward then accesses freed memory.

Increment weight_fulfilled before dropping the temporary reference,
keeping iface alive for the final access.

Fixes: 6aac002bcfd5 ("cifs: failure to add channel on iface should bump up weight")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 fs/smb/client/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index de2012cc9cf3..7cf7dd104f7c 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -233,9 +233,9 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 				cifs_dbg(VFS, "failed to open extra channel on iface:%pIS rc=%d\n",
 					 &iface->sockaddr,
 					 rc);
-				kref_put(&iface->refcount, release_iface);
 				/* failure to add chan should increase weight */
 				iface->weight_fulfilled++;
+				kref_put(&iface->refcount, release_iface);
 				continue;
 			}
 
-- 
2.43.0

