Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D538736E
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 03:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208458; cv=none; b=rQV/B5ZctqjJqpBWvxLdiE89y4Uw+TijVYWaUNh/cG3K0XLVq+FNxkjr0Y6SF7+tx1TYyM9qs2sT+SKFb8LfiX6+ut44eSKG7mPN9NhMqlX00i78sP7X6pvji8GAjVA3HophcqP0iIouRLFINQPvwwBJjKb4QZbP4qpAWj7jcG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208458; c=relaxed/simple;
	bh=N2nqS+VEn+OcEKXAy6ywZrjjCCKEsoNAXYazLkE0yyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgbnSsjM1hPvEB7IQc2ocRq57bSSRp45cb55veWUratOTn9W72clHbgN9QUGkRo6/SlDV+cd1b4II5jcNvKWO/Bfm6NmgOdVhzdsb3i33Iu7kbtJh0ZFFCNLr9EpgLH8zbTGbA8GkmJdEE6e93ctkzZYgQYVRLVTkcUkAyR9+Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pbz2nrvq; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pbz2nrvq"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2db3728f0c4so646685ad.0
        for <linux-cifs@vger.kernel.org>; Fri, 16 Oct 2026 20:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792208457; x=1792813257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+rXZh+xD9n/HNcvsUA42BBcSjkNxd2Q6tGapkKdwtVI=;
        b=Pbz2nrvqi5mfV4uyzI68xHum60vSNt8ShSNmX5T0rvyWyx8QKfeOFyOgkIzTERbKaD
         +314m6KGQ0uAqHfN52ZCaYse4QcHy+VtPiVfqQ0MWSKY6j26hRE3aGov6MX7ixCKvCv4
         sfLoGsqGIen3Bjckk5d2eLUaYfm72IejeC0t7qRl47SseVCTnCrzBx8bZGt1ZPbHv0J1
         jkOjlG5JapcULxaEPP2aVO5Y1MI4tWD6q9ILZLQ2Ju/uk01Wdjbg7GAqK4JCk3fzYqy6
         nLP6BLpDwAmUETng92hYj6cOs3sxg6Y0a6ur8627Vcrlj+p//u1MdfgsIpP3M+tF6DbI
         8qXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792208457; x=1792813257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+rXZh+xD9n/HNcvsUA42BBcSjkNxd2Q6tGapkKdwtVI=;
        b=A2+lyNYKUSE44auatLLH6cIYOtqTAL4gMnEF571l+3lW4SQfpG2JKKvNoTZhfagERQ
         ziRWjWmRvdD5Nc7H1uzrMapt9lPOli0xxXi+Jh/wHPS1G/nd7kwwb2ygrVcuI8PqENhy
         9wYLoly9vdBx9/V7gPT9UPT9vtj7ORBimThRjAmf2+eOFqvaraMXDJQSaW8z6ipJWKrJ
         rUZeHgpupOHpKrtb5OzI+SEVoJ7TNLZULxohEZwfmZp1tChH1Dtg9HJG+5GCKxQ4V1ok
         fUPkBOTxHybtp8QXrkvxOLsQGWEupr/jtze0+rLSBm5JdHejIsfsDI23Oavtp/4qGEVx
         m/MQ==
X-Forwarded-Encrypted: i=1; AKwUvBzGutgKsmSJSMcXMyEYtOxqls57DUn7ESh1mjm5oiv5QiDYSLr8gxjfKq15SfY9kabTAgft/ogZv2gi@vger.kernel.org
X-Gm-Message-State: AFq9FYKkCF24Jqh8tn8zS993TyUlRYwCKFhtLtqbipp0I4DdiHZHYrZj
	Qwl4AvfNO43PSlxQXvh2xlnuXzSAU6Xqfo3FbtrSM3+JQmUXR8XcDoq8
X-Gm-Gg: AYBFou2dLKqH8kCcw9f0KqeOgtHniMWAI9hwsxlywrUWs72MZSX3I76n/PRjZoohye6
	kx/OjbXB+3v71lcdB/v0y7OcCOGUM9ozAoDkIHE/ORSAcmOlrK4PfoRPj1wdR1dmy8Y9WeIHJsb
	u2ivQshhnUEHVPV9b6op5eUy9pUStmU28QrpkHexj0VUizWBtwO8NM9SXbg14jmFYygw/cPD0Gd
	x1GLBZGYZO2XnuxujIXiZ160/Qmeka8OJSjK6ftxL2dL9t4vh9q6EPga59vxjsTX8qAmfUxIzpZ
	JqkzYmAj13FtKkV04yfgf7bZfUK0FpdOTp/5ju1fmxPTCAsyxo4ZTSIWhnkL9py5DHtwuJpwl8R
	hjnAYCpv3Fu6XiS6nE7y+CcN2wDmtIveKdf+YOe7U9EEWmi1uy/83sr6pwXTZqx80FTe1IiFMx2
	WO4IHOiuiNAmTtu0lVFrc7aIhyzq34bRL2+3ftyx6g2blFSqYMpWjQXE3OF81D/1hj
X-Received: by 2002:a17:90b:1d4f:b0:3ab:be66:ddc5 with SMTP id 98e67ed59e1d1-3acef4fda1dmr2331888a91.6.1792208457028;
        Fri, 16 Oct 2026 20:40:57 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac945e7311sm11708667a91.4.2026.10.16.20.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 20:40:56 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 0/2] ksmbd: fix SetAllocation EOF and rounding
Date: Sat, 17 Oct 2026 12:40:49 +0900
Message-ID: <20261017034051.72932-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKYAXd_50E7cH51hxKi9xWfE3Hjyj0PhwccgsuGX416pEJVs8A@mail.gmail.com>
References: <CAKYAXd_50E7cH51hxKi9xWfE3Hjyj0PhwccgsuGX416pEJVs8A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In response to Namjae's review of my earlier SetAllocation patch, this
series separates two fixes. Patch 1/2 prevents the existing cleanup
branch from extending EOF on disk and then restoring only the in-memory
size. It carries Fixes and Cc: stable. Patch 2/2 rounds the request to
f_bsize, the allocation unit ksmbd advertises in FS_SIZE_INFORMATION,
instead of 512 bytes.

The other review point, reserving the requested range when shrinking,
remains open. I tried fallocate before truncate, but the decision to
shrink uses an EOF value read before vfs_truncate() takes inode_lock.
The existing block-count branch already has this race; extending
truncate to additional sparse-file cases would expose it more widely.
If another client truncates and writes in that interval, our truncate
can extend the file again with zeros. I reproduced this with an
injected delay in QEMU. Rechecking EOF after fallocate narrows the
window but does not close it.

A VFS operation that checks EOF and truncates under the same inode_lock
without extending the file may be needed. I plan to discuss the
reservation fix separately with linux-fsdevel and would welcome your
thoughts on that approach.

DaeMyung Kang (2):
  ksmbd: avoid restoring only in-memory EOF after allocation change
  ksmbd: round SetAllocation to the advertised allocation unit

 fs/smb/server/smb2pdu.c | 48 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 25 deletions(-)


base-commit: bf3465919b0337dfef8798da01469145887c4ef5
-- 
2.43.0
