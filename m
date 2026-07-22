Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EBD2BD58A
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 00:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784681232; cv=none; b=tadSfjsanmqI+LKLtDxqKx5gspZ4gMiXJHhgzuMAxcIBvcxPgP5VeI6BHTSggBcI8z3TTxJ/Ez3TtvVXvr+jM96UoqBbeBnLh3U51CT6tWzNKg2/YA74lprI7kvWx1nuge1kMQdL6kR2lWJWE6NVUtHbxt3IjyWqNaH2ZN1n9pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784681232; c=relaxed/simple;
	bh=hSwC6swKbkFW1RjXs4kP6fj6bTVuYOz2n5/pw3kkreE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=F7dskzFd8V4+CuLO/vVNGvvylWAa9Z/NWWdTqLFBAx2NtiRn6nIoejpfacOn32kiELYAqFZ+61+Y5WuD+/M+gFtoNSWZF3YigPlOfvXaUH2kFlYUAjHd9XfiJfXNhi8j2TPyAnqj3zGcb9/deCHCIxAGUasNRcNltCkIzeJKKpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Bn2QaN4W; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Bn2QaN4W"
Message-ID: <1de1e19c-bd57-403c-b91f-70b2d3b51fe7@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784681223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sKgrLlUzUQ5oP/GSe2pnEm6K710xfRwztY1wMkv5cQ4=;
	b=Bn2QaN4WdIew3rXqQGtp4VxdB2FOqGylZGUVViVbWnJ2TnrgG2P+QSD0ao9Y0xQ2MRAckE
	8VEnTMBOpG5EgaeDrMUpWEIcxoWUb7RKoFN7jNAwFXwr6eK7THLr1wkbuZaMPN6+8mxf9t
	OKobU/tWsAx9tp/wtjqU3GHvGEsobLI/XVMsxEYeODxkAaWdnqkIb0bA5+4T9qEfEwsGvB
	KTEqQwSKZEp9yIHJ2oYkusNMA0DCqy+gCyOkTWRBL3axNT5aN+WMEUPohBFFlYks+AZeNS
	zx6RBHXSGsphyRnw1+YD+3DrmLSKwt0cF46qvCUL814FPc5KPGHvuK3tzarAbA==
Date: Wed, 22 Jul 2026 08:47:23 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [BUG] null-ptr-deref on ksmbd-for-next-next branch
To: linkinjeon@kernel.org
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

While testing ksmbd-for-next-next branch with a Windows client, I hit 
the following kernel panic:

[  118.738007] BUG: kernel NULL pointer dereference, address: 
0000000000000000
...
[  118.751396] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
...
[  118.775059] Call Trace:
[  118.775761]  <TASK>
[  118.776419]  handle_ksmbd_work+0x269/0x550 [ksmbd]
[  118.777795]  process_scheduled_works+0x206/0x450
[  118.779164]  worker_thread+0x20a/0x2f0
[  118.780253]  ? _raw_spin_unlock_irqrestore+0x12/0x40
[  118.781652]  ? __kthread_parkme+0x49/0xb0
[  118.782885]  kthread+0x104/0x130
[  118.783880]  ? __pfx_worker_thread+0x10/0x10
[  118.785204]  ? __pfx_kthread+0x10/0x10
[  118.786540]  ret_from_fork+0xb0/0x220
[  118.787858]  ? __pfx_kthread+0x10/0x10
[  118.789260]  ret_from_fork_asm+0x1a/0x30
[  118.790721]  </TASK>
[  118.791593] Modules linked in: ksmbd smb_compress smbdirect rdma_cm 
ib_cm iw_cm ib_core libarc4 nls_ucs2_utils
[  118.794721] CR2: 0000000000000000
[  118.795529] ---[ end trace 0000000000000000 ]---


After debugging, I found that patch ("ksmbd: enforce signing required by 
the session") introduced the issue:
https://git.samba.org/?p=ksmbd.git;a=commitdiff;h=7e5a34a4c91621c5315a725531c8d00336b09227;hp=5b1cf1316f83dd2e4c8908addc69877d444bd77b

It also needs the following additional changes:

```
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -140,7 +140,8 @@ static int __process_request(struct ksmbd_work 
*work, struct ksmbd_conn *conn,
                 return SERVER_HANDLER_ABORT;
         }

-       signed_req = conn->ops->is_sign_req(work, command);
+       signed_req = work->sess &&
+                    conn->ops->is_sign_req(work, command);
         if (work->sess && work->sess->sign && !work->encrypted &&
             !signed_req) {
                 conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
```

If you want, you can add:

Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

