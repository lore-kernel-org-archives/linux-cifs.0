Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211160;
	b=16fkz8YR5EvDzHMuIGjudrTxAYStUuRJOwPhOaAkrJmHnkMtKiukVzvpKwpvLbwFaM0O
	 m5qKmbnUbLH0U4oKL57/C6l6F/OPhYcONyTLVhl9/6yrVpiJgf0+8OdzAAvSLsyqaO9mq
	 jzeu9BpRlKw9aXNTR+EMFwRqOisKKv987ERNF7jU7dm68+AeHyhXyE3yvdvAZByx7lcVp
	 tm8hZw8xggnQ2nuVdovNjQB4apSWnODFkFVfSAnmz6YxoHEwY26TJF2KsHf/3HFLJBo7Y
	 gRD8NuIEhyMXSSBnAhHRryHwYc8zQyfP8A+1eWr682UQazT3ojXwl9y/OFuG/gYQSyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211160;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=halThLpFR9MA/xSJWhg2nbRX5BJT0ocg9O7I/oZTep8=;
	b=F+eeTW1E29Z26+LiCcwzf6cFqeEQ8I2G2JBhVZf2DnqWVHfpokk9kA8rsBCm6i4v/x9T
	 oSIVlEbhpN6rZwxiAIE+qxpmEMe8vDM87TUS24sUN1OQBSZzxpSbE42LOM7sYSWDVbJBA
	 1Lhle2U/jWg8Fd5A5yo2G8zzBTJJ4qRJ9UHOHkKm82XY8zeMLjmMP9j2nNoWprcPsdg7B
	 2DBWf/n8v32rjSEmpXNlpR99d7X5ON62W/qbJb9dDn7CgFiEQbmRjyZJ5GD8i0ypsexn5
	 db9u42lnnkYGOrMG+iaQy9qTj1K2EVIUskj7FiW3ZESCLP8Rr/DUlFfSrfM6+qCGlKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cjZzAV+O;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57A460A3807
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 18:12:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A57A460A3807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cjZzAV+O
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3535bf8b3e0so1810147eec.0
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 11:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793211159; x=1793815959; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=halThLpFR9MA/xSJWhg2nbRX5BJT0ocg9O7I/oZTep8=;
        b=cjZzAV+O0Vwxp04eP7Q+6VVIoWd328QqSN8vm0N+SXrH7QFIDfkdAwNHn06soKWe86
         f/KBcsaIL0wobkehF1Sg31pBXx3YL75y5MN8BcIL3xeJCp4IMV0ruirfbGVtHtfN4Jdo
         THDFokqyCIpZZQDTpeQBVtEs5H9Ifgfh5+cNdW2O65MV0AVHxKFDaPFBrmttLEnE4Wvx
         TU5y3MCosHXqGr81EhroYVxVW7MQNqZTvgB9Pzd17FThOpm1MHRjRTMA2ZCniESTabkP
         FjhRhEbPgpZ4STMCPG8gxT8SvqlPeVMM4o5zm9SXR19t97+PswsyCrTBUmV6rSIAh/ZK
         1N4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793211159; x=1793815959;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=halThLpFR9MA/xSJWhg2nbRX5BJT0ocg9O7I/oZTep8=;
        b=ZKp7evx8W3WrAPSEtssJD+MixZW5/FpTVdOQpv0KzQT6Q4cepx/LpIbxrlcgPAHFgf
         0xgwKzVbOCJWbgcgI8zNZi3GwnQMA30LtUvDbWu4bY6IRbsSIUphWLVrkX9xrFmlj5tz
         /qoTU1thxEFPMtEsLta1sjoF2R4/pT5qC1EJCY8rVrs45B8OzhgIJUnP8R0aj2PY1ugk
         orniB8E2wN0sI6dU66lRaDP7wmK8GZIZ6wQ/Rcs4xrTtL3Qze66H0HiB+B4lPeGrOU4V
         O/rbQgr8qs8gYCaoKD44Yzm3ZGG3lYre3+DJ5fAy7+zasT/JZje3LkhfUm7s/NrIW+5R
         fOXw==
X-Forwarded-Encrypted: i=1; AKwUvByaiG+c1Q13AHeXdWFZlXp/Wglx/LE3XUC3Q+ONiCyvRx/BrKAj754SeNGrIL2ORB1Y/lKwZ3403NIy@vger.kernel.org
X-Gm-Message-State: AFq9FYJjpHGa51MwSoc1k49uIx/089sPJDrWZGxzw1Sb2CxUZkLr7p2M
	Wc8pJt+5MuE2cw8qbcC1Ks/XfuE2OjmK2spLzcK1tkd/4W37X34HP95xzPsTq5MOmOfc9A==
X-Gm-Gg: AYBFou1bwHfGnTInjAy/EzYGsP2UlU5NWfF0GcC4CmipEmULXn8tEcmI2nv9akaoCy/
	mvJ7SROou12WnYUrHtE/TcxnlJwEvjiBP/jhNPSwhGk38tb2Jm4HcgfrfeMiBaOSv/rL11LJASr
	GeVFih3ORJGCIBP5UE2QgXWZ6MlIjXZtr3YbtSuVLSBb6JX6B3Rqe0RhQdflyNZeM8bjv8vRxUi
	vQWDkGtp3O7dHBUUxMKq54e+pQm87LEtTsWFiOTZIAsFtVB3Xi7WZXgvUGEoUQZCzeT0rbt4S/e
	DRGJ1iYCbS/k2bUA16cyU4ZbzhBN3eLKVKAqOkz87vX5Sv92vP2bPkuC8mktDHhqVAO+oC6KuuK
	PiZbqMyTmYGB/ChqHs78VTe50TgWpjC9gCml8Hy4SevemZs1ihcZj73bgrVC/Jn5HvZwHAydH3O
	I8E0ra4P77l1Srp/WGfo3QBrzA5bVhTqs2E7iVorjp5AGVZC/mqxtqd4XZyPERDhXA9TcRu1lq6
	Ad3T0R+uva919b+vKYp8sWxolGMRqYaq9DDfsqVsL4ivjGExhCwp6+RAULXEnrEus8bNx4Tb9+U
	Q03mMHdfqiPj6gdqxliCGOw=
X-Received: by 2002:a05:7300:d706:b0:35c:6ffd:e91b with SMTP id 5a478bee46e88-36a2013bd0dmr5935780eec.40.1793211158462;
        Wed, 28 Oct 2026 11:12:38 -0700 (PDT)
Received: from unix.. ([181.229.23.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a238da675sm8309394eec.5.2026.10.28.11.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 11:12:38 -0700 (PDT)
From: =?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH netfs v1 1/2] netfs: preserve prepare_write errno on reissue
Date: Wed, 28 Oct 2026 15:12:28 -0300
Message-ID: <20261028181229.1408342-2-ivanrwcm25@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
References: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

prepare_write() may call netfs_prepare_write_failed() (FAILED + errno)
before write_retry calls netfs_reissue_write().  Clearing subreq->error
to 0 for a clean I/O reissue (82e8885bd763) then makes
netfs_do_issue_write() terminate with 0.  The collector copies
front->error into stream->error and mapping_set_error(), which ignores
0, so writeback failure is silent.

Skip clearing error when NETFS_SREQ_FAILED is already set;
do_issue_write() already terminates FAILED subrequests.

Fixes: 82e8885bd763 ("netfs: when subreq is marked for retry, do not check if it faced an error")
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Steve French <stfrench@microsoft.com>
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
---
 fs/netfs/write_issue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index b8237e1314d8..f23364116421 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -268,7 +268,9 @@ void netfs_reissue_write(struct netfs_io_stream *stream,
 	iov_iter_truncate(&subreq->io_iter, size);
 
 	subreq->retry_count++;
-	subreq->error = 0;
+	/* Keep prepare_write() errno; do_issue_write() terminates FAILED. */
+	if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags))
+		subreq->error = 0;
 	__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 	netfs_stat(&netfs_n_wh_retry_write_subreq);
-- 
2.43.0

