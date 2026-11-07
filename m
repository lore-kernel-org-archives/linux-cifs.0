Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071590;
	b=xblGq+UbI/rqv6qSYCX+hSuHegvKW6P2Nbwg3ieSs5MWYHbSjNu60Dft189mElwP9zyk
	 RfeJlyswVvLLjTdTF7Rb0VrpbSoD+9p6B3Gy9NU3KAXvXvRpMQxQUpzThu4ziP/ERcriW
	 Oy+w+0C5tV7qxLqESi3rVThxzCDAHmPAvIuekZ7eEiJzD1WhtnvARX8BjvS8WEPhqdfyf
	 8ctL3j9RVFHsbzCD/N91ixTy85cP+atYZ7ml8JK6eT7S9A6dcXusNFVEjQYFjwG/EJM27
	 xYQWw+ZPoa9oEZIVJNDjJZjfsXAeeXESaZG+R7LVC8FFI/bvMB+qNibUCpczZYXSr5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071590;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=H1v0v6jdWWrkOMKSVVNAV2dkkY9NVRj9DV/y56uqM2Y=;
	b=hEoyLptHlYkk6SCTXp+74URSHR+e+znMD3cCJzsRYFMNAJQe2thDhs4xzdGVVAM9TEsV
	 HRNmRFRIh2N6joCY5o/L65gIAaO0lkbmTnMPZvQ0sXl3cNFV43OoY9L5aMemra4okp02B
	 IzQpZtRXUr73OgFtssUPEq1BXXL4xeMs3+vBPHQ9dXFUdNg2FNog9gB/FOo9sehdVYp2v
	 2BOAZ4X7o3zvjqxu4Czd/sfYiN65LIyl9kCsd2jg9S/F2ZsFJ1dvoHukjmYRUSjLY/ihI
	 f19CsW93vbz3gEqEIc0cXCiNpwDwSrG2DY8W+8af9Z3UaDQYt4+UK8WhRH7a7I9O1aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=qv2KX0h8;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF52606A337;
	Sat,  7 Nov 2026 17:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFF52606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=qv2KX0h8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=H1v0v6jdWWrkOMKSVVNAV2dkkY9NVRj9DV/y56uqM2Y=; b=qv2KX0h8sKNIWTJIgI/FZBqK8T
	XOROJSNwrsPKr6Ahl2yC/hEiIK3lCEkEU9QUZkSsY1ARpkXTEq16Vh31x+TmqRT880bb0ZtgFH2St
	gooYTqvOvTknP5DeFxU9a1N5nDVM+Fv74QVZwDdih2x1uLQ+VBluyTajut7AKC5oztDSPaB8VToKG
	I+kNl2iUG+nVY9MSW5blXI2dzinEoE46OByjhKwHfBXxDbwDKzIOALMSLCExL10SJW+yHMmqZ+RDl
	yZqQalwHHursa+WtXQKKCHjVkjvciOgtMe7hY33ov95B2pnEvO96GrL8mrRkFM0rPRf9D44hy8HR6
	Bsuc8ZDg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyV-000000017gL-15KE;
	Sat, 07 Nov 2026 14:13:08 -0300
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
Subject: [PATCH v9 08/19] smb: client: don't spend read retries on reads cut short by a reconnect
Date: Sat,  7 Nov 2026 14:12:54 -0300
Message-ID: <20261107171305.2847361-9-pc@manguebit.org>
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

smb2_readv_callback() always retries a read cut short by a reconnect,
but still asks cifs_io_should_replay() whether to mark it as a replay.
On a soft mount that spends one of the mount's retransmissions and grows
the backoff, so a later replayable error on the reissued read can fail
it early.

Mark such reads as replays without consulting the mount's retries, as
already done for writes.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 736c5c693c79..be003200efa8 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4695,6 +4695,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[0], .rq_nvec = 1 };
 	unsigned int rreq_debug_id = rdata->rreq->debug_id;
 	unsigned int subreq_debug_index = rdata->subreq.debug_index;
+	bool cut_short = false;
 
 	if (rdata->got_bytes) {
 		rqst.rq_iter	  = rdata->subreq.io_iter;
@@ -4743,6 +4744,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);
 do_retry:
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
+		cut_short = true;
 		rdata->result = -EAGAIN;
 		if (server->sign && rdata->got_bytes)
 			/* reset bytes number since we can not check a sign */
@@ -4815,7 +4817,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* see if we need to retry */
 	if (is_replayable_error(rdata->result) &&
-	    cifs_io_should_replay(rdata))
+	    (cut_short || cifs_io_should_replay(rdata)))
 		rdata->replay = true;
 
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, rdata->credits.value,
-- 
2.56.0

