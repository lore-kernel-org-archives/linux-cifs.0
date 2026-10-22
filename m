Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.214
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661160;
	b=IUjQGukC6u5ePJU0glBacMKXLja+03aiwfKbtLaCv+Hv2Ohlh+jUwUgVKwUOIKp+C2dE
	 0y8ISARHofTf788AK2/l/p6ZvyIBSGVHgxqOb0yxlv1lum2E0ql/xPmvIJ0ek3AcUuXjK
	 V8sODwU2RjbRfOLr+pZ8S0NdMKRBTA4i7jzTvSr4E62Dbv682JtS1Lx7Jnyi9KhDqCweG
	 UqtpcW8q8rxIAGVFRT5l6+6h43SVlK4c8xoJncImlktmx2ejrt+qKEJqeh8fKPZ9rZsIv
	 LPOk6HBPe/Vq0DGGvGkQxEnhAkrCl4DRwfpG1xTE7NYeSIhkdjs7RhiPjYIIyy8UePA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661160;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=e65khfUaHCP6/D9wIaXcR6LUeZfk9iEAEPWmjZIWemQ=;
	b=e5+yx1YdbKlG3g+9yRU9pazbCvDpSXSMZLtKlaXs3jJqcRAZQMFumRZHRVlxltQrEqJa
	 YpfV1+x97UrBMCKDkjJKyvoLAPUot1QrXYts1VgNf58NjwH46zHUFk2DRVi2KY6Hd3k8o
	 DvsOf4iiM7+cMe0lvSDveFqP9ZiPGURiKcypQiIWTU8phJXZvcE0C0q+ahi3ldrD/335k
	 QssGHLQCSDjls6dhqhrlNdLSRzqXzSz7MkFbodY25QruVNKWi6KukB8fbbtqJkmrSbczm
	 KOHBNiZ5vgOD3kHvqPF8BduD+gVwOFmlDqpIoE2ng2SeX1vMV24avyjrrzgrhCS7iVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aQzGcYSJ;
	arc=none smtp.remote-ip=95.215.58.214
Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05344606A328
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 09:25:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05344606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aQzGcYSJ
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yKky5zwjDEiXYOuxlzTb2hAkObSonZWJnKevDcbqw5s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792661158; v=1; x=1793265958;
 b=aQzGcYSJY4Y44abIM2pUyVx7mdnm21f3196qilXwtaaFr7XQmDX5FRrAPzpaI+fHvnsPLwQX
 vMrvsPXXJCsGZgLuntbfvbbEjAAPVY+otp5ntzlHFES+44N1BzKLb7ObzTabzZP6kAX1tZT2d24
 z3R7N9NZYxdtId4PyUOCqi00=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6c22803f8b49d8a0;
	Thu, 22 Oct 2026 09:25:58 +0000
X-Mizu-Trace-ID: 6c22803f8b49d8a0
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	tj@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/4] workqueue: export attribute and sysfs setup helpers
Date: Thu, 22 Oct 2026 17:25:11 +0800
Message-ID: <20261022092514.2590010-2-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022092514.2590010-1-huiwen.he@linux.dev>
References: <20261022092514.2590010-1-huiwen.he@linux.dev>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

The workqueue attribute helpers are not available to modules.

Export the allocation, application and release helpers for GPL modules.
Also export workqueue_sysfs_register() so a module can apply attributes
before exposing its queue in sysfs.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 kernel/workqueue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1ae3732a2c51..ec4709395594 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4822,6 +4822,7 @@ void free_workqueue_attrs(struct workqueue_attrs *attrs)
 		kfree(attrs);
 	}
 }
+EXPORT_SYMBOL_GPL(free_workqueue_attrs);
 
 /**
  * alloc_workqueue_attrs - allocate a workqueue_attrs
@@ -4850,6 +4851,7 @@ struct workqueue_attrs *alloc_workqueue_attrs_noprof(void)
 	free_workqueue_attrs(attrs);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(alloc_workqueue_attrs_noprof);
 
 static void copy_workqueue_attrs(struct workqueue_attrs *to,
 				 const struct workqueue_attrs *from)
@@ -5618,6 +5620,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(apply_workqueue_attrs);
 
 /**
  * unbound_wq_update_pwq - update a pwq slot for CPU hot[un]plug
@@ -7746,6 +7749,7 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(workqueue_sysfs_register);
 
 /**
  * workqueue_sysfs_unregister - undo workqueue_sysfs_register()
-- 
2.43.0

