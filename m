Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794007120;
	b=z93GgzKEd9KpJGU/Np1GjEhQ/jsbCW1Qx7/aN37+2KQRdx3GhCezZOvUwSF9DyJnz44C
	 LOna7LFSr5lxXbNb23lsQrMcNGuBkju6BLuJVF/7I+S4evAdu52tKiKiPE4amzqe/099f
	 7uQRAMBeCb/I2a9la4/fCJ3792RR6g+v1PPHs3hPZPmfTn71xTEZrlQEUB2stH5/wFDre
	 AFEPh6+dUvJeLULIIHQlCNcVYmFsuj6sHGJT6hHxCuMN3gjpQA3ipXCSUZsyl1RN3oAAP
	 4TXUplIWU06F1Z80/He1iTa/ybb1vALlfEJzEIsXIPBwiBxC1NzCupt/OYjxnAxnkYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794007120;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/kHN44ZQ7spcitdWxiKL3R8VBCf+tiohYYozD2JcOnc=;
	b=AgGtpUNMPrGmhx5LZuLhTStOMqhYHwRIgFydllTBfCpvKpHtjLAp1DILturhqHesSaV2
	 2HaCIkcpjWhF5m0cDuZFQ05mv0vhDcsUFCaxtEjozho7hUi6Bpv9fMh4onJOBYzCNG1Be
	 nOgDhdphwz/uG36NsqxywjGC9q3a7+fC2soAry8Id3ukLJDx8XLUyBQuWdAj0mKixNCc0
	 fSF/yrVt3GRtYrFd8PN+DGSW5IFnS81oL1SavimQCArbRTtm/iW3jVcnPartODQ2eSn0a
	 OjbPrU16f4XkkajABxvb5071s86KfxPnDKqegpcJ0lC1h1Nm19rgNhutroXqrF0/qiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=TC7xLfbJ;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64942606A32E;
	Fri,  6 Nov 2026 23:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64942606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=TC7xLfbJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=/kHN44ZQ7spcitdWxiKL3R8VBCf+tiohYYozD2JcOnc=; b=TC7xLfbJ09j6XdSiFpU7IFhXWC
	6aWHeGqT9PKfzMjdRhl9MvucnaarcwCb1/sDspvmvXvOx2a68qOGXROAE81PlIcxU6qAN47wUSErT
	iCqwEphLt3+msO0wOUz94gRL6/Wv3DomZso9l1/p7nGZ9ferAbq7Wu/pHBSSKqfY/rt5mHQ4rCRJI
	RwtiTUfLN96T+3eCw1GFkPYdbUMX8RCy7YBui0TC8jvnpBdss7gflJ7UDFG/eMjlvA79981w/lKiP
	ZIERLNEbHNOHTsWv3/fSxPQxBh0aRTwrcX2zS1YWEEbftj2R1U+CFvGPaYA6rTa555y6kaJ54DzzX
	A7XYHF9w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPTCW-000000014Dt-13gj;
	Fri, 06 Nov 2026 20:18:29 -0300
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
Subject: [PATCH v7 04/19] netfs: don't hang a read whose retry is abandoned
Date: Fri,  6 Nov 2026 20:18:12 -0300
Message-ID: <20261106231827.2604956-5-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106231827.2604956-1-pc@manguebit.org>
References: <20261106231827.2604956-1-pc@manguebit.org>
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

