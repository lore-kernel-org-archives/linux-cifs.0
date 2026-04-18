Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC66A18C2C
	for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776533437; cv=none; b=egH43Og8EJ+GCkftw1qS9xKvNNyVr9Cd7TUABFvBiMFITPmNhO/syQ8VfxynWWXREneCSi1oKnwd5OCE65zkKBKfaKpjXfamINJoIUYl0FZYzy91UyZnGZMTpF5iz//fzPwv0031gRrtG9hYxkHPPE6YP3oxmAK5vle1NwVia3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776533437; c=relaxed/simple;
	bh=vv+uXWXTBOrZTKIXNUPiy6z/3X6izwegkuK8RtLwUfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxwaqCM2m9Zn9fyZaXJgks0hQtCiTYp2HoG4BgaLSNEreoTpbnDB+WVfDRKM8WlOobjoaV9lDb9VLfGPuZFhUFN3LuktOn/vBnKqtq+zFtQdCO5KB+jNUQW/i4Irtx8u0Pv0RLdYlTY1Vb9OsZHO3BzoGWJG2pvIPN7vNKj2Y8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S4a7aoy3; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S4a7aoy3"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ab08e6c553so2429575ad.3
        for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 10:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776533436; x=1777138236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lo0L+uxbWuB7MGwK8DGzVQOOZjXqL0ZQUgEg2W2lmI=;
        b=S4a7aoy3tUvTUTXw+BOjDg7X0HRrz6kWXCg9C2Yv65Nm5h5NuBjeZTpQDaly1AHg5K
         Qoiv1j2J1X6LgZs09hW/VRPoyqTM3mQFxAG5f03Au6iBd/LXz7jXsuujJYpc21DWUjKP
         j+eJ7imew6hzPXzC9jHoBfXL1GE4tHznPb+TTM/A5TiQW64X1qmu9oWsuOCabYOjKtrU
         04ijDFJpdOeOY0sFhxLG7es7YDROQGMMlUgR8Qw6MUsCTKcsJ8RxDV3hgxUBesppvVI/
         yCXYeySgBFHVmqHFeUbO/7+yFr8JU7ktyVwUTcJwb+roC7SEHPJ4bNWm1rWa3SHcjbqL
         TVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776533436; x=1777138236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3lo0L+uxbWuB7MGwK8DGzVQOOZjXqL0ZQUgEg2W2lmI=;
        b=RNAzMetUKxZ/Qo/rA+MlYEP1XZQNQdakM4yg8cUFHCDV/i93cOKbTS/AO+eEqmUop6
         uW2sxVhyvSCAgzpp+zbonOO/jLlEsJCQ5ofyal2ajaYNclecUXiBLxwjv1ymcwm/ibIU
         /mqu49yEvhGaI+flQcqflHxOsCgd+fRr9WcjzKHp5O845KQ6mlsduzFpzKLt8jGONF9+
         R6BJ9twCNk1y4uKZNQ665CICp+bBDTaVWmPa7k9DuHHK1r70JTYjFFanQZKogZwLxxLS
         CxyLBokuLhSc4Fy2h72RJZdhGc1TzU5aKU7ZK4VYyYfZ0YT8V98TNtNTIbE6zQULm+Gf
         wH5Q==
X-Forwarded-Encrypted: i=1; AFNElJ8NnzLFr5Rrq8fIjjdfTQypG+itRuTUzmoDTOw/A1p1q0gYA+x0T3/G+uPo23mjbsJtN3M0+NSvSw+s@vger.kernel.org
X-Gm-Message-State: AOJu0YzG7N84jiO6SFEGSZBw8bVgfjWXiCrJkmSOLSyZpJ5y4UkwuzGb
	1PzIA4JeU554epNCLJTCIRNxksc4Vn2ObwHCD1uB9dSWlx+7rapZS9iC
X-Gm-Gg: AeBDies05QdzXC5v8RbMJobaYJYZ7bBp/D539iI3Uw2qSbkTaCylFqSLFiTVAy6/V1H
	9p2Sg0gX46s4SqKJbYfEl7v8PNDjiJ7dciJdOkSQ+qASgu9TRFnPHKQx05Kg69lFvfZF8UoPlG8
	Dzl1wTPM7X/z7IKC4M3pvQpS7vFSOw/iDsnHhUcBpXRGqzMga1e8ed9g+v7xfgyyhu7kog7Dl8V
	6lOklXqjvQDiGMSJwEy7NTsNznib1dofDHGj9hicQqs6ssZdJG/poHvjiz2wCfvz4KT0CsYkQWG
	camxV0jRdXCX5f9bJbEcHKNWrsjcQgRB5uBftQmzSGSZdXs7bC+mpUt8QgFMu+opASgf+FESgFE
	oSGk71V7+FVwxnZp5xZh3YSUqB5+Gt7GMPrQzwgMr+2mD+el7NPUKfvBwVZ6bUpMMuv/+NGOGbe
	WGgWusfn2pPW0WPBPwZ5bQw8uNXnU=
X-Received: by 2002:a17:902:d505:b0:2ae:3f3f:67c4 with SMTP id d9443c01a7336-2b5f9d67131mr40408135ad.0.1776533436099;
        Sat, 18 Apr 2026 10:30:36 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff3bfsm69694965ad.7.2026.04.18.10.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 10:30:35 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 1/2] ksmbd: fix active_num_conn leak when alloc_transport() fails
Date: Sun, 19 Apr 2026 02:28:43 +0900
Message-ID: <20260418172844.1333378-2-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418172844.1333378-1-charsyam@gmail.com>
References: <20260418172844.1333378-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_kthread_fn() increments active_num_conn right after accept(),
before calling ksmbd_tcp_new_connection().  The decrement normally
happens in ksmbd_tcp_disconnect() at the end of the connection's
lifetime.

If alloc_transport() fails in ksmbd_tcp_new_connection(), the function
releases the socket and returns -ENOMEM without going through
ksmbd_tcp_disconnect(), so active_num_conn never gets decremented.
Under memory pressure, repeated failures monotonically inflate the
counter until max_connections is reached and new clients are refused
indefinitely.

Decrement active_num_conn on this error path, matching the accounting
rule used by ksmbd_kthread_fn() and ksmbd_tcp_disconnect().

Commit 77ffbcac4e56 ("smb: server: fix leak of active_num_conn in
ksmbd_tcp_new_connection()") fixed the sibling leak on the kthread_run()
failure path; this patch closes the remaining one.

Reproduced with a debug build that adds a temporary module parameter
guarding an early return at the top of alloc_transport(), forcing
the first N accept-time transport allocations to fail:

  * Configure ksmbd with "max connections = 3".
  * Force 5 successive alloc_transport() failures at the accept path.
  * Without the fix: active_num_conn drifts up to max_connections and
    subsequent legitimate mount.cifs attempts are refused with
    "ksmbd: Limit the maximum number of connections(3)" in dmesg.
  * With the fix: the counter is correctly decremented on each
    failure and legitimate mounts continue to succeed.

Tested by injecting 5 alloc_transport() failures with
max_connections=3 and verifying that subsequent mount.cifs attempts
still succeed on the patched kernel while the unpatched kernel
refuses them.

Fixes: 0d0d4680db22 ("ksmbd: add max connections parameter")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/transport_tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 7e29b06820e2..400412444838 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -182,6 +182,8 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
 
 	t = alloc_transport(client_sk);
 	if (!t) {
+		if (server_conf.max_connections)
+			atomic_dec(&active_num_conn);
 		sock_release(client_sk);
 		return -ENOMEM;
 	}
-- 
2.43.0

