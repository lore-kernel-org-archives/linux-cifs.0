Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7326D271820
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 12:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739362591; cv=none; b=WNhtZfNENw+j3r9M/5izFKJnU0MB1uhf9asNcocHtBFJkUVRRIw7iRa9fUBzYfGfvF8ynWsnVDDUSSWXEz2ofS6eViHiomG6cEn8j5SXlPIMp7Tj1u/pX5pipO8b0pltVIy6T3n60knznzIiJjeBDOvs2jED1wkiVcf5H9czjUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739362591; c=relaxed/simple;
	bh=IN8Pt7VpLQIzvHLgaBpXpGJky2YGCtWwMLRj2mJiMwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z3oiY7p5wtv/w3MYnLeq4NNHZq6bV/fYh1ektge5i6px0ZElapVCI6SZjoO/XdW3Vnulvh9P7UNZolpaA5fj0lfyfRJtRmw8AiEvkIt8x39Fe7A0f8FUlrF3E7YaF9RaPsD2QLI8OB1hufDF/bx9ll20MfASVlyzeJK3dZmT0kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IOFGbOKP; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IOFGbOKP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739362577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w8v+W5qKG0FRQRTW2H8mBvyW6V4jA7wqbBco7O0n7Y4=;
	b=IOFGbOKPZsiMPsodyoVt34DWKU8aFpw9cXqo+zzYGqb2BdCaUwwso4qm1+CL71isMzFC8A
	P2Q0yK7oDK5PYMbSZDQ/BBHdEDwJCyQaBRuXw521t9o1jekLSBiuJOpnfk8zmMtSQXuicQ
	NuXiQJKNKGnQwYYHJhk0zG/FH+oeM6Y=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: Use str_read_write() and str_true_false() helpers
Date: Wed, 12 Feb 2025 13:15:16 +0100
Message-ID: <20250212121515.112430-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_read_write() and
str_true_false() helpers.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/server/transport_rdma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index c3785a5434f9..1b9f3aee8b4b 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -14,6 +14,7 @@
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <linux/scatterlist.h>
+#include <linux/string_choices.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
 #include <rdma/rw.h>
@@ -1396,7 +1397,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	}
 
 	ksmbd_debug(RDMA, "RDMA %s, len %#x, needed credits %#x\n",
-		    is_read ? "read" : "write", buf_len, credits_needed);
+		    str_read_write(is_read), buf_len, credits_needed);
 
 	ret = wait_for_rw_credits(t, credits_needed);
 	if (ret < 0)
@@ -2289,7 +2290,7 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 	}
 
 	ksmbd_debug(RDMA, "netdev(%s) rdma capable : %s\n",
-		    netdev->name, rdma_capable ? "true" : "false");
+		    netdev->name, str_true_false(rdma_capable));
 
 	return rdma_capable;
 }
-- 
2.48.1

