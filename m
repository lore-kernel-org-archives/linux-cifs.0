Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632030;
	b=kx75WcsZg45JTCqSyiDBukef0NR4KBKjnKiQ0t9C6VQy6TmiTPuAFSfk7O5T7bn4zspg
	 gOrn546GcRFFW/cUqNygzyCAUPkajxtqBjJROXoCPtSJC/SSqM5r6NC+IZ+yZZV8fF9TK
	 2PkDRUesT3Yu897uBIgFM/U6GKSRqt+kDVuF6lz21nTwqrAgouL9TR9v6rA+I+reiDAWq
	 lo1FMEyAliSffc3Ad7Kcr+u/g/rxpx0O3ZUw/Vb6uVjj/beY0l9R0zbhoRW/5drnmaBoI
	 IIxQyCWLtOA74UU45xdbLn9zwYOk/30YxhLGAT3VrJHx1nZdDvnUYlWrn2zF4uP32VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=halThLpFR9MA/xSJWhg2nbRX5BJT0ocg9O7I/oZTep8=;
	b=WcnT6uxd3nXgmtMO9rOaQg27lljC1HGUU2OMuxK3qkfpmKhGJ2Av5pYTHym3MBwHVwsF
	 7IEEkoG3hRQh8ORe7iUvlICKQ3oBLaByNAzlevpN5D4kVwgBu+WznZ846mu4ru+uO7vW+
	 3ODAefXxp+acaa4BTdPBH9mXXz+0FwRKrUvXf4lJ4MOmfFWOeYqTtN17xb5mTOwwhX4LL
	 jl18Y1FH5edywQ8nSD/FdTp6WYxRUlyIkEa98WFnGVwz+eM1fh1wRD38LO3PPl5fxoW94
	 3XSKc69Vcp46p/g6mi3hE0GoYvAm4oYlLUUS//h2zLpZWDNaZzBc5Ln5pbmfnHxwrqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YLxbPHVa;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A9C608A341
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 15:07:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02A9C608A341
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YLxbPHVa
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49d05d51553so19991175e9.2
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 07:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793632028; x=1794236828; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=halThLpFR9MA/xSJWhg2nbRX5BJT0ocg9O7I/oZTep8=;
        b=YLxbPHVa5cOZpsGQyxC0GLuZjjMWkOCxx6h3WvnFgwj4gBVyLxZy5IA1n5ICpcucBl
         rN3i7ER33XzYmzC5v8SeQrvP/BvKSTSvXM8PeCfNmX3RzziIOZcQF+3k4NbX2I++BUya
         eaG5FlrldV01wdEfdtXMOHzfmhZ13T3wIpCT9+aEAQOxMdgKpt9pJ4d8VesuG/UH6tSt
         5bjjSAQBvcMK70FM8wXFv59tARo8qmj2tjTBP/9fgN/G68c+ONeOoOVEHHAxKIKLe6NH
         GNFEvjMWXcmjWU58twTKOtoqK1X66eBUJweHSNBmYXxPMdJN1IYviiAhkMOb4K0hvasb
         PPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793632028; x=1794236828;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=halThLpFR9MA/xSJWhg2nbRX5BJT0ocg9O7I/oZTep8=;
        b=obMCRJN5DTEXLMF2kqQ10N9I+/I2qJqQ0jUCgswrDcGtKfu51eKVEMu7fnNjaNnqTe
         JQheme54o5xHBIZ18GuoMQHEgrZQMnGGRtx0vBRV8rpSmpptATKKahfl1VsyEgwswQux
         znOcZVXNfR2nR50JNF8wTakVszt2PiP0f88M45URFa9qaziRWWaEMLXD9IzsZ3U12m4q
         IT4tGUbbevOK9PYhaycRb2/41ZB8pBKhF0BAUUGnGqXuonRXCJ9AV9FKjKBgPht3lEbw
         qwN0Owfpi7+rJPmD/iPOZ9cDTtJxOgMT7zDomEx2BxkB2m8M/Pc2wF5cJeKEIiBuDfZ+
         e7KA==
X-Forwarded-Encrypted: i=1; AKwUvByNvAQdN1sAah/8K7FsKyqKGfYcfG9dsub8jqHlT5ZPRYkRLYGp7t0JPPJj/0WdU/Ove/UBWzvrt5hs@vger.kernel.org
X-Gm-Message-State: AFq9FYJxh9lbWS5BPwTA1t10mrZbwrzamtdsHFPGdEl7iUyAjL34jUdv
	G3q9g3nsRfMqC0Vpu+52hUvxHYzxu9cpWCGM/KroJ08ym5klHCkA0BQB
X-Gm-Gg: AYBFou0wAwseU4nVKolB1Zw96hUWQJiPbFgHtC8CpeNoQaGcM7pLwrxUJjeAJbc5u+K
	8xptGj5LPQS+wdVwncJital0UPf4dsiBCmJu0NtorRpQ2f8NDV903FZXPYbRRF4VQbtGMnRC054
	a+wC4sidbz1iLOL+RAYBZKNO3HknihT/ToIiwgSSqSVRC9kRAFQd3VMc3fFDJNYnOCpzqrryVMl
	5l5PsuUzKvrbQtRDxQatiCcHBjS5aWNry7kSJq19rSpUwGBqDEd2tUniOCNIqYh7QuXEwNk7TdX
	vIBL8TwzK8LehgDqMlCH/rCHFypxA/RJsATKMm50iXzmiBaprYDY3nWjyWtY/nJyPbGG1mMUgrk
	Eb3jNCjADVo+mwI7wnsAC0HacOVRbKlqTaoeJcnxP8XcDD3gQTQD+qiUP9VGO7aFoQQzuT8yrDu
	7sovGQKqeFNl1KTWjVvD+2BhM15GZmYF+zBbiPDmFQPGzMVDUxx1GZRA1debBDlSw3fI5C9STbO
	GJV/uwxEb+fHhDc9SufAyfgtRFnqMfOzR+tP3d/MMICZMvo0nnqEINpo06sZReyR7QLDa5jM82Z
	mJRVobk5NvIPQK1Tm4NbfLwW32sTWqhUFMHmSiSobO2/
X-Received: by 2002:a05:600c:8b55:b0:4a2:1655:87e2 with SMTP id 5b1f17b1804b1-4ac17b2b023mr254051745e9.19.1793632028227;
        Mon, 02 Nov 2026 07:07:08 -0800 (PST)
Received: from localhost.localdomain ([2800:810:84a:dc6d:d32b:1515:b2a9:c74e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm395629535e9.11.2026.11.02.07.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 07:07:07 -0800 (PST)
From: =?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH netfs v2 1/2] netfs: preserve prepare_write errno on reissue
Date: Mon,  2 Nov 2026 12:06:54 -0300
Message-ID: <20261102150656.207612-2-ivanrwcm25@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102150656.207612-1-ivanrwcm25@gmail.com>
References: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
 <20261102150656.207612-1-ivanrwcm25@gmail.com>
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

