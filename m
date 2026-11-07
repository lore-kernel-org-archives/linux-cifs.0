Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071591;
	b=gl8w9gimrrGkInzJharlscaoiXjFGUR2KuwSrLGlKc/6gYRaJv0E5FFzBgFNr4eBmE4I
	 kK31wFrJuqdpFVJFhYA8+6envyST8L04oriKOw9x3cePhgFAiaN8CIhRlmFFJsmUcruAd
	 7sEeyWRc9YRReOi7khDicp+NXw5HbUuakfD5yxH3tp94N+i33iSa2szdcq0vO4gd+wvoz
	 T0Ue7G4qQQVC+9+oZWtyhd2EGIRKxQxRFCmbC6PBUSV5ER74OrGQDZ8WX2zgqgd+pg6t5
	 XBBOUnHGht1+D9oClD8iOz/c5pcflaFf0pOWtm0CBwA/ws490ob1DNQ+JEAl+XiFMCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071591;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/kHN44ZQ7spcitdWxiKL3R8VBCf+tiohYYozD2JcOnc=;
	b=U3lTSaJto7bWu6EvRFCJh5JlV+4x2DLdw+RuEaQagkgzdrZeBXBjjGmYObGddWf89enI
	 dmrh+KYLQn58LOvMrjiOeK9QS9KNHHfD2UHDL37WQCzrEucSOsKBqeSxRxq1iG5P39E3I
	 /PY5KD3wsHLpA3qixcP6rHMjBT6NxRSwzfGHOkQBk0ejmBwSHqnaDttqO7B/EiZbgz4Eh
	 tA43Uv+/M3SwU+zuWz7stBeSS4vuiu7PYMKh06NTlzLwP9CDRor1xO2Y8xQUuI0Qto9zp
	 hlWzPq3vvq70qInD3uuq8GjhfyzMd1G1dnuc5uWIgQC+n2Ox+8S8hpBZjUPuhLMollw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zdKx2Tta;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C366A606A333;
	Sat,  7 Nov 2026 17:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C366A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zdKx2Tta
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=/kHN44ZQ7spcitdWxiKL3R8VBCf+tiohYYozD2JcOnc=; b=zdKx2TtaOchosyAufjZQwDUO8B
	xpLCrF3TI52PbfeZr/4SpfE7u60i0E1AYGCiyBgyQW+0G7VIi2UYSgrlApzDZPRxfQksNr7NkRJRF
	JwvBQNBy5sshsYOk2HNqk1oOhbG10/b39ZUvohEX6ee7hcwG5SQrljL3mHaPqHaALoghsbVAkfzw8
	tzBYh7sW52MqpzX0BfZm8iUL/KRAvzR/AOiMuTSnh3Dp/PiUl5tNGfmQT+co1g54pcNSrb1UM6mXE
	G7/m3INgJ6Y2QA4x/0iPnGFs/9XkyeUcoDmssgLka2ZwHM92AQEuP5S0QiRPFldWbvZ7PPeOL5ErO
	MEod9Irg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyT-000000017fF-3oYO;
	Sat, 07 Nov 2026 14:13:07 -0300
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
Subject: [PATCH v9 04/19] netfs: don't hang a read whose retry is abandoned
Date: Sat,  7 Nov 2026 14:12:50 -0300
Message-ID: <20261107171305.2847361-5-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107171305.2847361-1-pc@manguebit.org>
References: <20261107171305.2847361-1-pc@manguebit.org>
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

