Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794815360;
	b=q2rgapJzjcLzFn4CmCgl5wGKGy3vMjjsM9lBegU8++7Qv16dOhrTyvyGC4ybkg2R1vNv
	 vqu82+jRHIU07WcTilTQsYG+bhlGTtc9YCbM1ChmtUmKuXBpzHadzwKznHrkaCgXh5Ioj
	 dBI+Le/9EKXyXfKqNmiCGnnekucNbL1di/h0NYREhYCxw2AzoQielwW1ibzudb2579pKr
	 e922xV/X7llmnt1MZaWU6s1ehLMqfygczD4flKp9vW9mdI3/+TCetuUFJmDzaqohP9XVM
	 JEhETZf5IVYwPse7XLA0J/PgEiGgBINWyr7zXQ1r3aBVPG3e0NVGivoI6ZDwE1DtXYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794815360;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=qfEwEGdsfpaSsQ0CV8iU4w1B9JOv1XHHo5P0ONr0dGk=;
	b=f4MIH7aKg1lb36BrtLssBRoj+lRHpfSGAbmtmBOn0wMHako2JPuptmD5yaY3ITg/4m5v
	 hrCNDbX2PKkzhxE+mumE1Mlddd7ZvYZbiZAwO8+jJlulbKzXhpFrbm1AmmUfDIX98j604
	 lUh4Dc7uFRw26GYJYXgYKxHvQIJSkbsuRQN3/MtQtESHSzS9swncsoweOnatOtnqPmA83
	 +/b9svIxRLI9iCyMyovPwAfQvj8fMrTPnsv9VJ4PLGOZuSl+pDDYArxWrsQ9VZqL+Z1Mq
	 guM8yBIB3+ispOyz9VkZ6GNwjf49g59joSv6c3OF1VmvsHh6sr77WWDELmumAp1G7Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UslJmPZB;
	arc=none smtp.remote-ip=209.85.160.226
Received: from mail-qt1-f226.google.com (mail-qt1-f226.google.com [209.85.160.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343F5606A329
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 07:49:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 343F5606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UslJmPZB
Received: by mail-qt1-f226.google.com with SMTP id d75a77b69052e-55d03bfd477so17542591cf.1
        for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 23:49:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794815359; x=1795420159;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qfEwEGdsfpaSsQ0CV8iU4w1B9JOv1XHHo5P0ONr0dGk=;
        b=e3wD0MYNkV5ldO5tPglz6QtiKqZB4uN2uiy60TMsHSbx0rKrN+Kz9LtnI1AXHt5fmH
         eWIR5HcCKDzgD7ZDHhefOkwAFD0JO3lYO4C2zI5MtQUSInBXP4/rJqgDJTI9c/waNh7M
         ZOMsZAEiZkjf+N7ZXTnEWDny2I1uT0/cM1d+8P6bnAAX3juJVEmDK+ViLsHkzZwJ5QAX
         OsEE5ntxhzcn/HHd+8v+bA/t2Fd6OoDWQZFnJ978QvAS3wPlkKpMLBFzLlQ9YTsfcI/t
         HX6A88NhwvFz9P0XcBu11V4u6yEIu7jGpBnCcTpQrUTENtVUwuvzNUpXy2Q4jkG2g6TM
         bhmw==
X-Forwarded-Encrypted: i=1; AL+hErGqDgVGMb70N0ys6ZvAhC1cNDcahN20HqgFsL+HUxQWWXL3oGy933IQ8w4dMMJKV8qw6PPizEEJ8rhH@vger.kernel.org
X-Gm-Message-State: APuU4Z+U+rVW1B6hnpP4Muj8A2GwHyyTj111BGQdh373Sgu0nXvxpCpH
	FJKQsBXFx77iCURNBSMeyrPL7gPetnluhepedrq2i0vHXaHlgS87AAWgRzEocswpf0QeM8vMPZv
	dKw2/nJGYRVATgTCA6c5AjTnQ5Xar7yqRisTC+PI4ExWVEFOOZonRfZv4pAVNsMccU40B9CGfkv
	iKhCGovo5hBJLHlOPp+O1D9RtNUDLhVEMYN28oG/4P+7j+1Tq73hfHtL+pmiasarnt5+iuPbZec
	NdwAOfL63HXBFgtL+wPkA==
X-Gm-Gg: AYBFou3ZZYkm004Tmcz4aAR1xW9hU30c2KUKwFfg1RsltAziX9gs0+jbyYiVGLg1k6X
	80ehi6Lld0SX29e3/B6NpiwyAs0pBToWORal/QJzuXjC4zUtezWwSkOXVQuXxPJ5GEdNCTcGvMZ
	rpoNqnW51i92DrqhRo8DuQ5QUhKBZeb/Vc1qh6JGPKGoP0U9GEzNme8P2QqyFIfQpHDTqkcfAk2
	SWVkcGLoA7xvr9oAGGra7kW3B/eNVQM3glaFCZqNj54Q+z0Wm/6m2J7lvB8hLotwNvwjJ5L1tjL
	2qm4crx6v7QQhtEPabYnD3cvRvBK+zbJ5sbiPVx74rk0uOVDqGMNxo3v9e7/p/FGd7CVp+3bKEg
	tLWGJ5w9k4ZOLoX1v4gYcIK6cJ7KErLlO4TODoMiXFc0wtx1tyhHekJsjWiTFPLkzeNbJ4S35Uw
	NoJecaNHcShStX6XhRrV1ojvnVGtDIRZCkd9HNYA==
X-Received: by 2002:ac8:5754:0:b0:54b:f7a6:5354 with SMTP id d75a77b69052e-55ac755e421mr159092551cf.26.1794815358762;
        Sun, 15 Nov 2026 23:49:18 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-55d39fa46fasm160381cf.22.2026.11.15.23.49.18
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Nov 2026 23:49:18 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91eb05c8241so57145286d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 23:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794815358; x=1795420158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qfEwEGdsfpaSsQ0CV8iU4w1B9JOv1XHHo5P0ONr0dGk=;
        b=UslJmPZBBMWxXiIGaZ+wfVp2KPNXzFws9P0FePRAxwQZGpES3oH8a8jKyUUTE1fnm4
         rbYJ6AAVmTsjKY0F+DYCGYOB13q+Ww1bf1uA8nQ7RJG5DPLZ7LLj5YvrKmWnYkJrses5
         sqOjGIX7dGOPOe0Pf91azz3xovi59t/wuqcFM=
X-Forwarded-Encrypted: i=1; AL+hErHCFJMX9yNzYewLs3wbFg19M1WjvwA1LTTZdF0c5FKfgHRBqMnm0UGruans2W5AUYYfmGNcjnujeQTP@vger.kernel.org
X-Received: by 2002:a05:6214:4b10:b0:91e:f04a:b237 with SMTP id 6a1803df08f44-91f242135efmr158105586d6.39.1794815358064;
        Sun, 15 Nov 2026 23:49:18 -0800 (PST)
X-Received: by 2002:a05:6214:4b10:b0:91e:f04a:b237 with SMTP id 6a1803df08f44-91f242135efmr158105406d6.39.1794815357480;
        Sun, 15 Nov 2026 23:49:17 -0800 (PST)
Received: from bld-ams-bvg-44.ams.broadcom.net ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f8319d44bsm36603646d6.4.2026.11.15.23.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 23:49:16 -0800 (PST)
From: Stefan Chulski <stefan.chulski@broadcom.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stefan Chulski <stefan.chulski@broadcom.com>,
	Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: [PATCH RFC v1] ksmbd: add use_unbound_wq module parameter for the ksmbd-io workqueue
Date: Mon, 16 Nov 2026 08:48:49 +0100
Message-ID: <20261116074849.475815-1-stefan.chulski@broadcom.com>
X-Mailer: git-send-email 2.54.0
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The "ksmbd-io" workqueue has always been per-CPU. Commit 69635d7f4b34
("fs: WQ_PERCPU added to alloc_workqueue users") only made that
default explicit as part of the treewide transition to unbound-by-default;
it was not a ksmbd-specific decision.

Per-CPU work keeps request processing on the CPU that queued it, which
is good for cache locality, but it also runs work on CPUs that were
isolated from workqueue noise (isolcpus=, nohz_full=) and prevents the
scheduler from placing blocked or long-running workers elsewhere.
Which behaviour is better depends on the workload and platform.

Add a boolean use_unbound_wq module parameter. It defaults to false, so
behaviour is unchanged unless it is set; when true, "ksmbd-io" is
allocated with WQ_UNBOUND instead of WQ_PERCPU. The "ksmbd-break"
workqueue is already WQ_UNBOUND and is not affected.

Document the parameter in ksmbd.rst.

Signed-off-by: Stefan Chulski <stefan.chulski@broadcom.com>
---
 Documentation/filesystems/smb/ksmbd.rst | 6 ++++++
 fs/smb/server/ksmbd_work.c              | 9 ++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/smb/ksmbd.rst b/Documentation/filesystems/smb/ksmbd.rst
index 728cfca13205..a045ed6db9b3 100644
--- a/Documentation/filesystems/smb/ksmbd.rst
+++ b/Documentation/filesystems/smb/ksmbd.rst
@@ -158,6 +158,12 @@ How to run
 
 	$ sudo modprobe ksmbd.ko
 
+   - Optional module parameter ``use_unbound_wq`` (default ``0``) makes ksmbd
+     use an unbound workqueue instead of a per-CPU one for request
+     processing, e.g. when CPUs are isolated (``isolcpus=``, ``nohz_full=``).
+
+	$ sudo modprobe ksmbd use_unbound_wq=1
+
 5. Start ksmbd user space daemon
 
 	$ sudo ksmbd.mountd
diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index 6e5122e2d6fc..0447b2da84d5 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/moduleparam.h>
 
 #include "server.h"
 #include "connection.h"
@@ -18,6 +19,11 @@ static struct kmem_cache *work_cache;
 static struct workqueue_struct *ksmbd_wq;
 static struct workqueue_struct *ksmbd_break_wq;
 
+static bool use_unbound_wq;
+module_param(use_unbound_wq, bool, 0444);
+MODULE_PARM_DESC(use_unbound_wq,
+		 "Use an unbound workqueue for request processing (default: false, per-CPU)");
+
 static int ksmbd_reserve_iov(struct ksmbd_work *work, int need_iov_cnt)
 {
 	struct kvec *new;
@@ -108,7 +114,8 @@ int ksmbd_work_pool_init(void)
 
 int ksmbd_workqueue_init(void)
 {
-	ksmbd_wq = alloc_workqueue("ksmbd-io", WQ_PERCPU, 0);
+	ksmbd_wq = alloc_workqueue("ksmbd-io",
+				   use_unbound_wq ? WQ_UNBOUND : WQ_PERCPU, 0);
 	if (!ksmbd_wq)
 		return -ENOMEM;
 	ksmbd_break_wq = alloc_workqueue("ksmbd-break", WQ_UNBOUND, 0);
-- 
2.54.0

