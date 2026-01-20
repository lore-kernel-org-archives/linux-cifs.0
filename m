Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE691155389
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768890131; cv=none; b=o0Ddg5kruygnRgMI7BSwWZ1zxpX8TMASzhp9RYeM9mtXjLWbjkGWIRLLxgSdqaqOBl7GjNUU1t2etqYqop2LCNeikX4dUzhJLg0AR74lsk+ppjdzQK1oxFPsKTOSl+m+Z4cwh0aE21EnPHTKniMImUkdlhATuIthg40fpAoiEIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768890131; c=relaxed/simple;
	bh=EQIDBdej8gAOAgnYltWx3u0qXhBCCE6o3HHvVWpTwuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2teYzjIuUluV6Cc6AN7coTOSAfNEcQ3qXnbxvRO75lLIoRb+20rYuBqViC0II7JGOx3XpsCkJ90LP/8tFKGH+HnGDrf+n6zsWc+1JhDk2t8liFxZS+iz1jlnvwA2h/+RYhJs9vCNtBJshYrevKx5XtTmdZwOnOR0P7SvAIyZhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lxegLSMx; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lxegLSMx"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso31278625ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 22:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768890129; x=1769494929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QE670D9mNJ1A3NOHdJRodKpp+UQmT7FeQl+lVas6lQk=;
        b=lxegLSMxuqj587OKZdozzsWSgzNP7AIy+l3BiB1voajeAD9P8mYWm63pmk5AwRlb3a
         Z/U48xDcztv3FGN88Mb17aTcaa6u9arpGFaEvaftmT7kbDyaQ5oQpJzk1z/QNMII3d//
         qSix1n1htsJ1tPML1Xqx88JxHXEciOx5OJzyLqki8McPQfBLJYQoRz5fRl7W5Br+1WkB
         kNBCVgN7dI3GtFA2P+09psGJ6gMMhIFfwbPHPf0jRBNLF87PELWrGeh4YclAIzpqFEx+
         fQkbk1mqDp7o6TQGKqlCshGXVQA5U3DrgTohKgJSi9WzcveEmjh7UrjAsLo9BI5lmjmu
         nX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768890129; x=1769494929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QE670D9mNJ1A3NOHdJRodKpp+UQmT7FeQl+lVas6lQk=;
        b=Z90NE9NmMSnrhMbDizEZCB7aIhiUUuIH6+zmHdz+6Migr3wt07D7oxl0chFQg6dHRB
         7zE0bVlTIhlXxwlvpgSe/hPKB7mZvoOlBp8/I2sp4O2s+GvIJEimt/vDS/DZQawHjhUQ
         X1C5tcc0M//JHWlyibKFgRORNKMt0sjev+kMZVohsZ6rPI4sQ6lmG8Dg/avJh3EJ/8Il
         DKlfzxBXek7Pxq+y3P1ig9IudOEZ+HvZnVH0EGvqxVpv1KQQMmlLrQUV6+0VrxdHBH6h
         sejoRuRao5x36XOGpzlBKGSRF305a3TNfirGe7d65iwTRUBZgWWwghU3NqNDye1yQ4jo
         8XGg==
X-Gm-Message-State: AOJu0Yx0JVxVVGGrpxXoujYEdO9yn3exz0DHBgfO5ZpwzyJ7GJdTAoKv
	r5v1sqavDfztvSQFQpRwv9YyavNMLUsUFW6TH27rNL9ILtNUFkONZZt9S7NkNQ==
X-Gm-Gg: AZuq6aIRWQ0DmDg5BQnZ4/cNAe3QuZeU7AzM6IJ8T9H/F85qgHsAyd6cHknl66h/oKj
	7u5io2s4QA/kLvF6pP6wyhKaunK4RNac9oR9NHHfSQseXgPk4ORGp0omzpbTUsPMOnwGP17gcHs
	/aXzBytqgkAAwuHB4xk4BahWnuBA4oKk+CxUxxY+ys7ZOwT8Zo7EE3zuaCtvHVU5gI40zVz/zst
	TeyTbwhJl7yz4W56xmoODuo8ydP8NDkWBC/Zug1So+cZn4arvH1XwLiFJkK3sz1UPooleufoQfq
	Q9ZO+nluJjoJi0S+Ngt+u3FucL/zUWnKKECdn51ftD4xYwL1FvbCNQyDK2/atmmpijVzLmVvuL4
	gduQpfZtL4nVXHeW1HZa9rJSIF4CxZ6+JtgxngHhV4/Cvfh839DicOmBg4cO8IXoJ0EtKNRS/tc
	dcgcAifwr84qG9XTbgcJiMr5BKA87zrC6uQnidN1vX
X-Received: by 2002:a17:903:13ce:b0:297:c048:fb60 with SMTP id d9443c01a7336-2a76a389391mr9107705ad.25.1768890128714;
        Mon, 19 Jan 2026 22:22:08 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.152])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dd523sm112497855ad.62.2026.01.19.22.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 22:22:08 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/4] netfs: avoid double increment of retry_count in subreq
Date: Tue, 20 Jan 2026 11:51:35 +0530
Message-ID: <20260120062152.628822-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260120062152.628822-1-sprasad@microsoft.com>
References: <20260120062152.628822-1-sprasad@microsoft.com>
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

Cc: David Howells <dhowells@redhat.com>
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

