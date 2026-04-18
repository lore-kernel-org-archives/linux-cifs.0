Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B2F329E49
	for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 17:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776533333; cv=none; b=sCxI4wnsrBACuy2FoOEjVH5EfuKPpvI0ApEDBOqVqLav/RGYbEY46iAy6jcTJSTPTtPpuO5H5Tdwf8cfg4vgLhDz6OATcFWp0MMHoaVzGKZ8CnBb8hZGrKCH6QuH1zWMuBfd7hRGP1fBT2ujAQMTdXvc7/AP07wbfpbLRJWR/a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776533333; c=relaxed/simple;
	bh=oodzrY0vvZIZe8xiTS/m05LLTN+vBoFyUaBlwdynK+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cRPqS6W2bZmvQT1SvLkoPJ8gUPHOq2t/QLwlrBCYhB67/zZB5rkC6ObaqI9n/r81UY8jTFKsB1Qnd0Z8BUyI9Ti78QkUlkgUkh9DgwFQKPopGW46RrJ4ff88WmCeNYh5zKfyPOTfaEfUdrSnTcYk+tvgp4Vv8rS1qgvHUkUpsOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VEfXjr5D; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VEfXjr5D"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a9633ef0d6so1547955ad.0
        for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 10:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776533330; x=1777138130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UKnYTxLMq3it/33zgMBz+MbkLOEWdzF/N2ceulBhKMs=;
        b=VEfXjr5DAq8PV7JdtFABrctkWQfBW7dDQJQv5sKcht44MjxFJoJOfw1CZPtePDYTvn
         msJ8yAkoNBpdnyvAKnJz86PbmhrNzLsLLQzi17x6lWVUWMPWYpSMaleA/1ucO2OKMw87
         2dtvA13sOv2IrCm5OXx0hM2JBU5JXT05fi7r4LQLWmtmozLSLQrXVuCRU3YCvo8FXjuN
         ao1cbQnjCEgTFX46jzvZEYRUS8d2ITLEwPX6sw2E7iJFcfFwDm3Rcwllw6bzcGs+ydAz
         NVZ0SAB62I9kfyjoDSqwHAgBcQvs1nfEmMrB61qecAFu9sUqs8gwMPWVOwpAxofK7vCD
         CssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776533330; x=1777138130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UKnYTxLMq3it/33zgMBz+MbkLOEWdzF/N2ceulBhKMs=;
        b=lbMi5122JODZilwxvZvvNvts0jCT7L9asFSWo7gJk7fLqEi+oGSBi+ggtT/f1DV6/O
         FqwF3ekS41ze3lvbbHPyG4scONiBpCtOZ9qrSQH2N14TvQJXFUoUu4587cYGh5Ix1ZQd
         Z08OiJds9PuTPawWsuuM26IUg3uhO0xqg5SsNCmbRcHgfJ29VXcbXHI+FnG+SlvU9i/t
         talJKOLKphzS9nJLDdfg5eW6UEAOarqz2/Tgm+df+UX3Cd6CSUyCQ3e2e+Z950UmN1A+
         tdTfa57rLWeKHCRDoVzUkZtf0xCJLPa0sNTgfUmJc4CdAgxFT50v87DhlzXPdzD+UFMm
         wLSA==
X-Forwarded-Encrypted: i=1; AFNElJ90CQTnm8mafFCfNFQwhMA3rvXLLkZ053O8bCpjLfdxv7Gfhugvd/lfdAEzB/15HYinnLq2uao3wUVH@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz8Mk5eMPpfWCLiONwsjT3cY6yP8J+wW43/wxhBj2ptMjS/nHG
	5vBOMBmyRF4xC4RH0ih4wfkB0NY2jL0MVrH7wlQIbhoqfR7P9Aeb2roe
X-Gm-Gg: AeBDievVp/MuA3q7FY9PlUrOYVR00UJ8JgI/ROZqI4++GWFfSsbExsWa4JJ8dzFMpdt
	xC9FMQxKBO67XZnEoBOPTCSkhwvK7viryiPk3Ai5eMhEm5LX3FhH2AqRRjPySC8ZELl6pV/ALg7
	VkYvk0JCmUZkeoEX54rCFaW/Iv+Qsf6qjxblRUOBuDtqLIyqBUpzzteiTwgsvHONRgCikMYCTCY
	EpypBSHBZOO12QaEDRL9iONergX+sm4LJIg/EIq1yYDpGG0Cmoa+2C6zKaLxQ5xU8PdJzXVukda
	e8Ak8fKOiiVQD/QMWghw6mMJK7liUl5zOSFlZ9d/f1paMp1m+zhiWl8/OOhXqQDRrdwVkZMojQu
	3HraHVYvfeQWTisKorruX1gr0dJduMmbLabVC4+nzUbu4clpDfwA1uaosp722IUNN9hZdaZqDRQ
	A3SnJIyv3mdumgCwRmaCBYBbfY4o8=
X-Received: by 2002:a17:903:110c:b0:2b2:4194:952a with SMTP id d9443c01a7336-2b5f9f816femr39399565ad.6.1776533329786;
        Sat, 18 Apr 2026 10:28:49 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff3bfsm69694965ad.7.2026.04.18.10.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 10:28:49 -0700 (PDT)
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
Subject: [PATCH 0/2] ksmbd: connection accounting and session teardown fixes
Date: Sun, 19 Apr 2026 02:28:42 +0900
Message-ID: <20260418172844.1333378-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two independent correctness fixes in the ksmbd server.

 1/2 ksmbd_tcp_new_connection() does not decrement active_num_conn on
     the alloc_transport() failure path, so repeated allocation
     failures monotonically inflate the counter until max_connections
     is reached and new clients are refused indefinitely.  This is
     the remaining half of the same family of accounting bugs
     addressed by 77ffbcac4e56 ("smb: server: fix leak of
     active_num_conn in ksmbd_tcp_new_connection()"), which only
     closed the kthread_run() failure path.  Reproduced under a debug
     build that forces alloc_transport() to return NULL for a bounded
     number of calls; details in the commit log.

 2/2 ksmbd_conn_wait_idle_sess_id() stores its per-connection
     threshold (rcount) in cross-iteration state, so whether a given
     sibling connection is compared against the loose (< 2) or the
     strict (< 1) threshold is decided by hash iteration order
     relative to curr_conn.  Connections visited after curr_conn can
     slip through the idle check while still processing requests
     against the same session, reopening the teardown race
     destroy_previous_session() was meant to close.  This is a
     code-inspection fix; the iteration-order dependency makes a
     targeted reproducer impractical.

The two patches are independent; the series order is not significant.

DaeMyung Kang (2):
  ksmbd: fix active_num_conn leak when alloc_transport() fails
  ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()

 fs/smb/server/connection.c    | 5 ++---
 fs/smb/server/transport_tcp.c | 2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

--
2.43.0
