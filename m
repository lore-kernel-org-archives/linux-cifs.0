Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979443;
	b=rp7wo+OFIQP3R2KudrZSXGoXA/5X5jgHEAseiXC8WEdlkK7k8ru0c3h1lAFGiiiynB3O
	 dBhrtW50qy7P9bI5LYQnDFR1G+0P1I+e3UPmJ/1a3VCHikKaZRgyoFb4+Z4QtgMvw+gCf
	 Qc7JB7XeHGL3Ix+ga67ZFfuT+VXUV1TByu9XO9p3Z/EPPRTs7rkgHaPixMQeqreAkTg/h
	 LR6yrFx1Tfx7VONm9g6MP7+yTlh8aWIqQrYWJnwxCRrGuQeJ/NWVFRKGAYYUflACZ7elR
	 W9P3bL1ukNiwKVraqjpc3U5f2vRMBql0H+ZIGjrnCBcfvmRPqZ24lkz9FKAKOjgNnEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979443;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/kHN44ZQ7spcitdWxiKL3R8VBCf+tiohYYozD2JcOnc=;
	b=n+JYdIxszk78pFOoSRYwwIlEi/qftXL//0yJLnxP8mRjxp+061Wxu43T39YS42IImTti
	 UaxuecaCdEmaJAjo8outgfq6KHDq2UCToKTVaRMypGZL+fHNwPGV9jM7hZCMuRHyNXGyx
	 3nzoX8ITmO1z7w7J3nmAScQZASfi+16P8lzsOJZ6Li3/cOm+xzA2KmDyRMgVegGTnbYmE
	 MfOSCDvogqOveNv0a/8805lZ8PSB+DAb21xwnuf5Gc6/NlR+2OydPhxtBDDOWGK1vK/H3
	 8bldtBhBuJEBeDfriIuQ2CK0DsO1+3BxQSp5lAPnUJd0Y/VkfSenGkcj7Zg1sEi1w1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=40nQeKB6;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07E8606A337;
	Fri,  6 Nov 2026 15:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C07E8606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=40nQeKB6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=/kHN44ZQ7spcitdWxiKL3R8VBCf+tiohYYozD2JcOnc=; b=40nQeKB646I4gqEce14kwbX776
	RNV0epTny4SyHasXYGO4PEc5g520EsArhy7GOJ4jb9k+qpBkXIdr0JaZVP1g9pRT2h4llqL9vKYl7
	2oDCR+brdTNUO0SJJ3u7fhaf4YH5y+i3svuKwC62KA0y4hp5QcHZT+GnlVwGGZeo9YHnUDjs0NvP0
	FgI6BJzODufZ4SaHynj7mKFDXXWcWUu9c8gh8HIb28cWwJ8tLWi+dIOu7dcA5IVkLl+g6KtCuzmzZ
	X4gy0T63UXP9D6Ug6qX+7768Np9Zmpjd6sZRD1LLzoYz21bkpUW9tEU+q/3ZkmKXXcxwa6FEFRrJO
	51+4DdNA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPM07-000000012YU-338L;
	Fri, 06 Nov 2026 12:37:12 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 04/18] netfs: don't hang a read whose retry is abandoned
Date: Fri,  6 Nov 2026 12:36:56 -0300
Message-ID: <20261106153710.2498773-5-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106153710.2498773-1-pc@manguebit.org>
References: <20261106153710.2498773-1-pc@manguebit.org>
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

When ->prepare_read() fails while retrying a read, or a subrequest can't
be allocated, netfs_retry_read_subrequests() marks the remaining
subrequests failed without reissuing them.  If none was reissued in that
pass, nothing is in progress any more to wake the collector, which
returned after the retry, so an offloaded read (readahead, async direct
I/O) never completes and its folios stay locked.

Wake the collector after abandoning, so it collects the failed
subrequests and completes the request.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/netfs/read_retry.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index 8a722995fa9d..bfaaebea12df 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -269,6 +269,7 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 	}
+	netfs_wake_collector(rreq);
 }
 
 /*
-- 
2.56.0

