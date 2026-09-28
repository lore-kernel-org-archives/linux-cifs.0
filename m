Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBE14EF13A;
	Mon, 28 Sep 2026 20:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626193; cv=none; b=SpRdn36FFR8049QTt/flu8thXjikETrXT45O7VGN4h9kAYIhKJwcp6pAaQtfBhuPBd8pAm4eVQzFuTex5pA7gyAP708YR/QZNLjQXgi072OP38oH2c8extJuDGoVCkCWvs5r1CXONaYQ7eTi9PFy078yijD7Pc+Msp9QlSpp0fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626193; c=relaxed/simple;
	bh=fJZMKSxNA2oXIcbZyVKhb5AEtBBnA+d723BxjOyZCyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czZJVqDE1vADopl8uxUr2M0xfI7wTCHq46FeUuYiSlJRrZJ8MPkSVCPprtb8xXwn3p9zOMsrC6FarfLAPt+dLqiuxug3w6KjVoremBAFIxigZlCZ/rLQ9wVxUdRf0nzpLpsBxjsDVo1D4JPa/jsPolKzZDWKfg2TnP/LKAmG6hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=tLbqOeHu; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="tLbqOeHu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=SDk3J1DaxNcENwffWRehCP4eZpgbd/1ZHYIvMPOEvXQ=; b=tLbqOeHuJlrXY2mgKVuEjEL1o1
	js8YVF3zWZfCDYwaeqr/esbMi8vwcdqMAQLhVcc3AkdY9bWnbviKVLVECS4Z5YVqScA0vdbNu2YVb
	5xugsrsCJ9vRBMybyEy8ymJWOsrfvYfxBhje7Qp+eDPgVuOAfH0rkn0puOkAA0+bRdzXoMQjqghch
	Xe7BEGCpregvOVOaaPArz7FFMpp3C05P99DcFP5W1bjW4esPQaOsfviv60xga/gTGv6oX/GuL522a
	YxhYxWV4aSyGdnt01wo9mzIah9y8d0OMLZw+JcXFmM60Ib7ZmoGTRG+3E2K0AA8eqzyKxboa9ilvt
	iwLqNITA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfP-00000002ULb-1dif;
	Mon, 28 Sep 2026 17:09:39 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 14/15] smb: client: distinguish real EOF from a stale remote_i_size on read
Date: Mon, 28 Sep 2026 17:09:33 -0300
Message-ID: <20260928200934.1040189-15-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928200934.1040189-1-pc@manguebit.org>
References: <20260928200934.1040189-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_readv_callback() sets NETFS_SREQ_HIT_EOF whenever a short read
lines up with netfs_read_remote_i_size(inode), the server's EOF as the
client currently believes it. That belief can be stale: after a lease
downgrade and handle reopen, the tracked remote_i_size can sit below
the client's own i_size while an extending write hasn't reached the
server yet. A read in that gap comes back short for a reason that has
nothing to do with the file's real size, but was still marked HIT_EOF,
and netfs reports a short read for it as-is.

Only treat it as real EOF when the position is also at or past the
client's own i_size; otherwise mark it NETFS_SREQ_CLEAR_TAIL instead,
which tells netfs the shortfall is safe to zero-fill rather than
report as a short read.

This is what fsx (generic/363) sees as "short read: 0x0 bytes instead
of 0x<n>" against a Windows server.

Fixes: 1da29f2c39b6 ("netfs, cifs: Fix handling of short DIO read")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 3d7ead36d1a0..cfe3c4b4abe7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4796,14 +4796,20 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 				     rdata->got_bytes);
 
 	if (rdata->result == -ENODATA) {
-		__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 		rdata->result = 0;
+		if (rdata->subreq.start + rdata->subreq.transferred >= i_size_read(inode))
+			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
+		else
+			__set_bit(NETFS_SREQ_CLEAR_TAIL, &rdata->subreq.flags);
 	} else {
 		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
 		if (trans < rdata->subreq.len &&
 		    rdata->subreq.start + trans >= netfs_read_remote_i_size(inode)) {
-			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 			rdata->result = 0;
+			if (rdata->subreq.start + trans >= i_size_read(inode))
+				__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
+			else
+				__set_bit(NETFS_SREQ_CLEAR_TAIL, &rdata->subreq.flags);
 		}
 		if (rdata->got_bytes)
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &rdata->subreq.flags);
-- 
2.55.0

