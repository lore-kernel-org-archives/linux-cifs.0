Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235A038A709
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 22:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776207287; cv=none; b=JYN7SbBXDxF+IgxV2JaTlolJK4QG4x5LUHb4PysPuPeuc4X12gfrhECRB0t7VViAY8wVCfWKdkzY8+RC4Or6TR8ZM8Jb6zTAOj18aHyfnQ8Gszjd8ZjQV71ubWX8mnit1hoRwPL0BVN69t212PMaa6z9UPFr0HT+bSFZzLHnxco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776207287; c=relaxed/simple;
	bh=ho6A2HcxcWcGu1Rs/FicjzU6aBukuBzdo9A82COYqT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wf0k/mu7YuW/nXgxZVL6Uc+SE5tB1XC6NCmGEd6K2vyzedq4voOyqAuIX1mIILlyvg2iPkeIQlM+Wl01x++3nPMoo4NqQSjqfqoct+vJuQO7KHIkgmTYRDpOx9PwujYRtFN9p+mpcZB53Ga3qhpjBwYmKYDUifkw5EyT2ac1g3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n0kBa/tN; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n0kBa/tN"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899d6b7b073so62559116d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 15:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776207285; x=1776812085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NaXGnHrbdCiIDMKHtNSSlUWGn4HDHfRgUpLhX60Y0kQ=;
        b=n0kBa/tNgYA7MjP0BOt5GCqSEI+gzP29KqZZ5YLKRqdgPAj7zDBq500Jt5ARiItXc8
         56ykvObPRKDuCKn0bZl73DGw+5/uKFBS45kTK3zLArp2iJ5qPfBzHeCdXCckCLIWJYd0
         6t9ioGjnPsri1G30PoOUWGiZRkcFvCVyxHdjwXt7eR42yshiaubcT1b9zjviPPqpxD20
         hLjwMvkMdJZYitU3EZvNcX9E1FaaNfWWjG0s3KnJNfkTF2xYEQPjEWtdlsNepGs1c+8k
         xYmedJVWrYc6WZLxrVCSOegQX+sXE1laCwlEWrnIfSNUOXiC71oTt3jJEcW/wWZwjRKa
         ucwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776207285; x=1776812085;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NaXGnHrbdCiIDMKHtNSSlUWGn4HDHfRgUpLhX60Y0kQ=;
        b=DstfmpNrkgpXP/o8AgZWwwG00BuU+ORYToDpJKv5TWniUUty8LJmfPmXERsX8/iRC7
         0V4675bozUao9sb2ZU0orAyYzozjieAJrYnlIIY+RU3RCjQnE6ZJRDDedMcS+ZCa1TQM
         /P04KDaFaAnqmKcTpDt+gmaIeDBz9zhJJnSLqZ8MxmmARRj/StE1YW5xt8DeKjnIHEV+
         Kd3ZCA5vWHQsH9IksMd/cFcYyVEIpgxLyY3++Y0B0aGRNxQp+Zh//KerGWhIKNYw4SS5
         QLQlPL2WSFL6aqsAUJkMJZDnpACi/ffDGLyhGWpEhKdIVgsfBvZACwLUj4igPFUTiHdv
         5Dzw==
X-Gm-Message-State: AOJu0YwZvot8v20L42ioDZpr+q5AFdJGf7stlR9MkgF79yePSc1rB7hC
	z1ZPm2FtbaH7wT2AdJuaG/wXznwhHNuF/cpUbud2sJoVR3j8yYCpddITtP6iEg==
X-Gm-Gg: AeBDieuu2/n6d0NbqdKZPohVEP+7KSjemtKn8+OEZ9YCicO/UPJO5D4eaK/avRqh4O3
	fFIzCZ+OrEppoGksHJmIrJ116fdzNGekANaUWst+dtxaqlmkw1Ua2PYaXJZvM9yAUEkpCDb16Hx
	UsgxZEg1/L6uokLp2fcIRRP224/OXEaX0ME0HfN24d0XYAeOveKJKZKSMU6A0OkgeXbvIpQzN9G
	vZNftBiXi2AovVIi7auXucWaSnV8ZnP8biD/2dWLK13s/0mQ1Udk92ZAChh6Lnt8XznFnIqvDa5
	W7arKdwmKM7N5t2LxA3W+1aDBxz1LT0c3FVGAGYjtrz+0bn71jt7g7so+5hKRDqWh4hUjZZreH4
	NbOzv6EspkOs/XzUQcWcG11XhKj6YYhhZNXkxdtlnFMffOeiWJM19S98o/VOPuJK2Y//Px2cIce
	kg2obiC1glVTo7o4gcz/HOCtphmHi6PmICPiZTus0v/mHR//A1hTw/gHX97S/L5lzB3Bw/V4JKn
	u2qk8lrucRtd2BX2u1OOz6BaHSKNJw=
X-Received: by 2002:a05:6214:808a:b0:89c:bcbd:c26e with SMTP id 6a1803df08f44-8ac862e0e88mr291184596d6.25.1776207284790;
        Tue, 14 Apr 2026 15:54:44 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca9f7e0b0sm70648316d6.11.2026.04.14.15.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 15:54:44 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: server: fix active_num_conn leak on transport allocation failure
Date: Tue, 14 Apr 2026 18:54:38 -0400
Message-ID: <20260414225438.2210243-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 77ffbcac4e56 ("smb: server: fix leak of active_num_conn in
ksmbd_tcp_new_connection()") addressed the kthread_run() failure
path.  The earlier alloc_transport() == NULL path in the same
function has the same leak, is reachable pre-authentication via any
TCP connect to port 445, and was empirically reproduced on UML
(ARCH=um, v7.0-rc7): a small number of forced allocation failures
were sufficient to put ksmbd into a state where every subsequent
connection attempt was rejected for the remainder of the boot.

ksmbd_kthread_fn() increments active_num_conn before calling
ksmbd_tcp_new_connection() and discards the return value, so when
alloc_transport() returns NULL the socket is released and -ENOMEM
returned without decrementing the counter.  Each such failure
permanently consumes one slot from the max_connections pool; once
cumulative failures reach the cap, atomic_inc_return() hits the
threshold on every subsequent accept and every new connection is
rejected.  The counter is only reset by module reload.

An unauthenticated remote attacker can drive the server toward the
memory pressure that makes alloc_transport() fail by holding open
connections with large RFC1002 lengths up to MAX_STREAM_PROT_LEN
(0x00FFFFFF); natural transient allocation failures on a loaded
host produce the same drift more slowly.

Mirror the existing rollback pattern in ksmbd_kthread_fn(): on the
alloc_transport() failure path, decrement active_num_conn gated on
server_conf.max_connections.

Repro details: with the patch reverted, forced alloc_transport()
NULL returns leaked counter slots and subsequent connection
attempts -- including legitimate connects issued after the
forced-fail window had closed -- were all rejected with "Limit the
maximum number of connections".  With this patch applied, the same
connect sequence produces no rejections and the counter cycles
cleanly between zero and one on every accept.

Fixes: 0d0d4680db22 ("ksmbd: add max connections parameter")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/smb/server/transport_tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 7e29b06820e2..8d7fe71f525c 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -183,6 +183,8 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
 	t = alloc_transport(client_sk);
 	if (!t) {
 		sock_release(client_sk);
+		if (server_conf.max_connections)
+			atomic_dec(&active_num_conn);
 		return -ENOMEM;
 	}
 
-- 
2.53.0

