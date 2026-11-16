Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794801985;
	b=fb23ImKO57RvJJLx1jS5GHVP1Z6PNLeXNqUjo13QJJf4M8u/Tvnm7ZeZatgN7IQE9wdb
	 0ii2nOdY6nZI6WUnRISU9njLwEpHTnKdUlc5Ap0IdzbcTdAqq6BW3wfmQPb5+d3qPzrxz
	 aVr1GkazeX5jXJPhWGJ3GBOrpknj3Be22DPyI0rTkJGUNNU8ZS7HdzZnQ9gkkdFs6NeoD
	 kbrWEJhnCdvaSfmL1q4FyzM4JZCZfwemX64jZ06S09fETCaWlJg38jKuGE7qATfdvxYtr
	 7TnKPiPKhvWZKTLZQVRq7/ewU+f32HhKhSo6FURhG81LMvGZMTyBwtBEuB8b41RFgjg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794801985;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=rmyD0s1XCBmV7mffRiNbjwFpifD69qzSzCmMfG5UvV8=;
	b=CV/BPhK7WOcyY8JzxrHphclfGG7PsNiOquoGLjM2nZQOW8OIFdfLn4u8LOFLGiC3Be9p
	 22nwkW9Vt2xoeXUwuKCulwFa9SOMG2ha0iwGsNs1O3NJyL+MMr2Nb7xXsVe1N9CEut3IL
	 BJWPjCtFzTxB/DrmxHb1j4+rf8cpQ9YzJ7i/Te9ioWHh0MH4fiaqDV7VzceOzhGVsdTW3
	 41aEgnRUEdPdM4oSf31HmTdKFBnHzpvu6uQaiScuIZJomTyP9Dc1t0kUeV5UZ6JVHd8Q3
	 Kg9WTgQMo5OeD18H0a8zNLJ0EnJ+vAmqQJOqVWwkij3UygYGfk3zBeJa2nwjeSNna/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XeNF6Qjg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC80606A31F;
	Mon, 16 Nov 2026 04:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XeNF6Qjg
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794801985;
	b=ZhSjgO1OBHrHHTFXJZdkiy/uXnjw51fJ/yZAyjFq3bceFLRvchRvI5rOQH3yIa8XBxv6
	 PZR3sFE68t6yhRbLFq8H6U9Z9Ibc65ShsYQ6KkFhAHQ/rxoBE5EqF8EqGzVSl7TXOM1nf
	 MT2eBYm7eRe/YkczAi295PxDsZe9ceGe49zDkIP1ecMGPo2oV02bobqC+65U0q0hsnyzm
	 Hk13DMvnbddTR1NBHVcgThiUMZS/s6A9YPvRwmqxF6rPjGnyEL4dNmxVUMiIRVivLOl/E
	 D7RCMdqcW9KiIPN4mNnk2a5sGv0RpiZuviKuWhQbaxfJWIS4GZXlr3NwYxYA2ILFgzw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794801985;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=rmyD0s1XCBmV7mffRiNbjwFpifD69qzSzCmMfG5UvV8=;
	b=B3IEIoAcjsEEknRgje0xz9h6yiypsbygBLOqi9RG3K2Q2xG71dG4SKMJCg7jjg9ZHJzI
	 onNSPiuPtLbmXSMgbdXD+XAclQX6ScpAqhkrv/b9mVIPo365zmURu3yrDlFIBGtY5fCTk
	 gjqWTjSN3BfYjE4AuyEXF9t9b3lJSfeDt/CKRG8qyknSZmstoMyrW4I70XWOGBFpZswqe
	 BkeSJZ4RJohGi2OMrssutjm/CobOn3VH68sHl/5rs0gxDf1SW1QJk632nsZ7A/U31TG8s
	 0u8StT+rYGVHsqFV6/lhX1mTyBJvXzBO7pSN3wr8DXeUeR1SNJ0AxEov9FreAAnTzOA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A42511F000C5;
	Mon, 16 Nov 2026 04:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794801985;
	bh=rmyD0s1XCBmV7mffRiNbjwFpifD69qzSzCmMfG5UvV8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XeNF6QjgmLyibtT1HG0zmTfRcgponvdDf3QZzaDwHLcirf90nHwcyUPwJbKUcaVY2
	 Xe2RbM3dW8G2V6mC4xJbI4Tj+F25v9O3sC6EW33DSVWZWgJQY0SX7ysqFXoWYHC+2u
	 57JNAvaXUaj8qN/O6zkIiup66oNEkA6hUmr6fvYEtmue2GygFlm0Y9JwC8/GGt8oE9
	 n3icqjzWhnCwi6A6pdjl3bdHLtnoEDsCbHf+mFJXpkrWmj8Rl/nRgEjvMxgoU728FP
	 V6gGwCjvamtXNNSvCKyb1FZ9yvppsJE+OKKt3SBCz9YFdUOimHEVId0+TnwglvT1Gj
	 r8cR/iiS+7rQg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1FE2A4A307;
	Mon, 16 Nov 2026 04:06:24 +0000 (UTC)
From: Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
Date: Mon, 16 Nov 2026 04:06:23 +0000
Subject: [PATCH v2 1/2] smb: client: fail SMB2 responses with a bad
 signature
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-smb2-sign-v2-1-a823a90d0db4@gmail.com>
References: <20261116-smb2-sign-v2-0-a823a90d0db4@gmail.com>
In-Reply-To: <20261116-smb2-sign-v2-0-a823a90d0db4@gmail.com>
To: linkinjeon@kernel.org, pc@manguebit.org
Cc: ematsumiya@suse.de, sprasad@microsoft.com, linux-cifs@vger.kernel.org, 
 bharathsm@microsoft.com, ronniesahlberg@gmail.com, 
 samba-technical@lists.samba.org, daniel.birtwhistle@gehealthcare.com, 
 linux-kernel@vger.kernel.org, smfrench@gmail.com, dhowells@redhat.com, 
 tom@talpey.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794801982; l=3644;
 i=shyckless@gmail.com; s=default; h=from:subject:message-id;
 bh=GRCAyhw8W4Nd3CFnmrKZixyJSJ4lqFc04PFF7+v+L/I=;
 b=MmJB7lHaglzwEjt9lIs/pV7Bud2fJyqwEim3ZJ0TWgrDiXI2Ly9exeTqFAu/svt32Td9mENzz
 nhsNQguQY/ECgvt1qXcauyCaIHcwZjmPnCfl2SiOH+YOS5juziyqM/6
X-Developer-Key: i=shyckless@gmail.com; a=ed25519;
 pk=pMtccVGiWES3bV+7YBFuBclkvq2n2HBHQ5azaBrK2lY=
X-Endpoint-Received: by B4 Relay for shyckless@gmail.com/default with
 auth_id=1498
X-Original-From: Suyuan Wang <shyckless@gmail.com>
Reply-To: shyckless@gmail.com

From: Suyuan Wang <stevewong@hust.edu.cn>

smb2_check_receive() checks the response signature when signing is on,
but a failed check is only logged:

    rc = smb2_verify_signature(&rqst, server);
    if (rc)
            cifs_server_dbg(VFS, "SMB signature verification returned ...",
                            rc);
    ...
    return map_smb2_to_linux_error(mid->resp_buf, log_error);

The status from the response is returned as usual, and the caller goes
on to use a response whose signature is wrong. This is the path for
synchronous and compound requests and for smb2_writev_callback(). On a
signed but unencrypted connection, anyone who can modify the traffic
can change e.g. a directory listing or file attributes, and the client
accepts it.

Return the verification error instead. That alone is not enough for
compound_send_recv(), which still hands the response buffer to the
caller after check_receive() fails. smb2_compound_op() then maps the
status from that buffer again and copies the payload out, and other
callers look at the buffer on error too, e.g. smb2_open_file() parses
a symlink target out of a STATUS_STOPPED_ON_SYMLINK response. So also
mark the mid MID_RESPONSE_MALFORMED, and have compound_send_recv() handle
it like a mid in a bad state: mark the earlier mids cancelled, so that a
CREATE which did succeed gets its handle closed, and don't pass any
response on.

Unlike the SMB1 fix in commit dc96f01d54cc ("smb: client: terminate
session upon failed client required signing"), don't reconnect: this
runs in the thread that sent the request, and only cifsd should call
cifs_reconnect(). And fail the request whichever side required signing,
since a response with a bad signature can't be trusted either way.

Found with a static analysis tool and checked by hand.

Reported-by: Daniel Birtwhistle <daniel.birtwhistle@gehealthcare.com>
Closes: https://lore.kernel.org/linux-cifs/SN4PR22MB28883DAF57E0B4D4BFB1C22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com/
Fixes: 3c1bf7e48e9e ("CIFS: Enable signing in SMB2")
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
---
 fs/smb/client/smb2transport.c | 6 +++++-
 fs/smb/client/transport.c     | 6 ++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 080864b24a0c..5d6871553ee9 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -711,9 +711,13 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		int rc;
 
 		rc = smb2_verify_signature(&rqst, server);
-		if (rc)
+		if (rc) {
 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
 				 rc);
+			/* compound_send_recv() must not pass this response on */
+			mid->mid_state = MID_RESPONSE_MALFORMED;
+			return rc;
+		}
 	}
 
 	return map_smb2_to_linux_error(mid->resp_buf, log_error);
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index d0d0159c1061..f1ba9701b545 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1110,6 +1110,12 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 		rc = server->ops->check_receive(mid[i], server,
 						flags & CIFS_LOG_ERROR);
+		if (mid[i]->mid_state != MID_RESPONSE_READY) {
+			/* Bad signature, don't let the caller parse any response */
+			cifs_mark_compound_mids_cancelled(mid, i);
+			num_processed = 0;
+			goto out;
+		}
 		num_processed = i + 1;
 	}
 

-- 
2.34.1


