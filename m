Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99E63659FB
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046175; cv=none; b=CWBvWZ7tZgiBk/MzsWUnnci3N8U84wDLQoWjxRaybHF8Yi69TCxGDl/V6u8s3iY0+BJ9Zne7q9ydxi805+akxZRb8Zf/hG/KbbIGRoND9Xjp/+Ja7VNHfykl09QnMkzPDfxnVTCdi8JitCl1PKmVM/GzuM7cmHWyADY4zvVVlAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046175; c=relaxed/simple;
	bh=xnr/nrFfuZnNxGMo/nLBrcxyl5mD7ITkEUu7vEh+kfQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lesk97SDnpjq18Yo7DWJF6Tm8EtiPjZRT5jPmjwdPUmWWyfjfIIyXKqPvu08URGMgKWKz9AHz5XWqWR5MXbC9WnLJVdBHpjqHQeXp5pmNRcnTQ6K0Zj9YleRogaz9TZ44YwBOwnwp0N1SNad7gd8mgErjFZE6HI20eJIw5BIqoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zc5XcJ36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zc5XcJ36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2631F000E9;
	Sun, 21 Jun 2026 12:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046174;
	bh=Y92IgeP0m+SCDzBV34g1niSWHElzC5B1FJDlGlRdmsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zc5XcJ36X2QCbbTmiEC2OcbV9npj/ofRWqr4Bdd/fZEELu/qxA3bvmu3XCUylTvBc
	 PymeXOvY9zTvbO3ZQyIUDZd5DZaeGhl+N7JTL0mCGUvZWvrMxrn3R8D74sGKpRzl6j
	 0hcPcl457FrkkOLixitwhqEGzOJOdfOIzAChXH7697XF/DySa0827yQh9RqI4a8JOW
	 HwzALCjKyBknfdtfMQVpBJpSTyn/7NBRgQgrM5IG8ZJeKV7fXn1Kg8A33wVQkt4TVK
	 cNPsyBwNkpITkhrVK+2b9CpNcQY9dyfVFx1OjfPQbR6+AzYZMTfKv4CFHyeuI+bQo8
	 eUh9rTO7oEojQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 22/29] ksmbd: normalize ungrantable lease states
Date: Sun, 21 Jun 2026 21:48:37 +0900
Message-Id: <20260621124844.6235-22-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2.lease.request verifies which SMB2 lease state combinations are granted
by the server.  Requests for H-only, W-only, and HW leases are valid lease
state bitmasks, but they are not grantable combinations and should be
returned as lease state none.

ksmbd only checked that the requested bits were inside the SMB2 lease state
mask.  As a result it could grant H-only, W-only, or HW requests and return
non-zero lease states where the client expects no lease.

Keep the bitmask validation, but normalize ungrantable combinations to zero
before allocating or looking up the lease.  The grantable combinations
remain unchanged: R, RH, RW, and RHW.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 23e97bddf28d..ff9a72236b4d 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -29,6 +29,17 @@ static bool lease_state_valid(__le32 state)
 	return !(state & ~SMB2_LEASE_STATE_MASK_LE);
 }
 
+static __le32 lease_state_grantable(__le32 state)
+{
+	if (state == SMB2_LEASE_READ_CACHING_LE ||
+	    state == (SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE) ||
+	    state == (SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_WRITE_CACHING_LE) ||
+	    state == SMB2_LEASE_STATE_MASK_LE)
+		return state;
+
+	return 0;
+}
+
 static bool lease_v2_flags_valid(__le32 flags)
 {
 	return !(flags & ~SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE);
@@ -1758,6 +1769,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		if (!lease_state_valid(lreq->req_state) ||
 		    !lease_v2_flags_valid(lreq->flags))
 			goto err_out;
+		lreq->req_state = lease_state_grantable(lreq->req_state);
 		if (lreq->flags == SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE)
 			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
 			       SMB2_LEASE_KEY_SIZE);
@@ -1775,6 +1787,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		lreq->duration = lc->lcontext.LeaseDuration;
 		if (!lease_state_valid(lreq->req_state))
 			goto err_out;
+		lreq->req_state = lease_state_grantable(lreq->req_state);
 		lreq->version = 1;
 	} else
 		goto err_out;
-- 
2.25.1

