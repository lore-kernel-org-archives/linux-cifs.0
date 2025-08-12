Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9306929BDB7;
	Tue, 12 Aug 2025 19:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026748; cv=none; b=jgqDfHtT421VhZ07UOUlnEQHMZSXRmwcQWnX1As2BGlb5ENvKGYpfYvB0namTRd3muammYnVu3BTdzm6Df2jUDswcFYtWUCWikh4oG3SwnTC/eJNTrAddz47cQHMBlBMBThQ0zq22cRH14QLleiG0IbevsaFeKKFreBlSHUhTy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026748; c=relaxed/simple;
	bh=yxUB9jdwSDDBwlvr/jkTmH/Q898/P5wVqEpz92hqQhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Puv553TPwTet3aTiZ0dT2xUXIfYcyd4uS/cOFNwxY+iENALjf0EfpPCa7wuTsRuTTrQLfmItVFh8Ye/oS91KQZzCcNRF4QV7Bwu2uEMBOW0uT5w8sryEudUqFpImFRgL41knL9FqYZhzwGh4wAM0ZMIaMFXMKRCr6I6RZDr3KUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0CKa38j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0CKa38j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EB1C4CEF0;
	Tue, 12 Aug 2025 19:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026748;
	bh=yxUB9jdwSDDBwlvr/jkTmH/Q898/P5wVqEpz92hqQhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0CKa38j86mkyLzmcrUHaxEdntuSuJREKkGSvp+UT8Jg/p8EBzGeqHvFPdOg5j2rW
	 fh5d2cs2PhP/RULRhYwLAo7NdVNSJeRDETAjQgawygOxS+iZXB/026AnMMSG/pnZh7
	 YUIXRw52surQtHKV3CkGTPSHtHH9yi25VkvHFivo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 428/480] smb: client: let recv_done() avoid touching data_transfer after cleanup/move
Date: Tue, 12 Aug 2025 19:50:36 +0200
Message-ID: <20250812174415.057746026@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 24eff17887cb45c25a427e662dda352973c5c171 ]

Calling enqueue_reassembly() and wake_up_interruptible(&info->wait_reassembly_queue)
or put_receive_buffer() means the response/data_transfer pointer might
get re-used by another thread, which means these should be
the last operations before calling return.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d26b8cef82d6..47f2a6cc1c0c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -479,10 +479,6 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		data_transfer = smbd_response_payload(response);
 		data_length = le32_to_cpu(data_transfer->data_length);
 
-		/*
-		 * If this is a packet with data playload place the data in
-		 * reassembly queue and wake up the reading thread
-		 */
 		if (data_length) {
 			if (info->full_packet_received)
 				response->first_segment = true;
@@ -491,16 +487,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 				info->full_packet_received = false;
 			else
 				info->full_packet_received = true;
-
-			enqueue_reassembly(
-				info,
-				response,
-				data_length);
-		} else
-			put_receive_buffer(info, response);
-
-		if (data_length)
-			wake_up_interruptible(&info->wait_reassembly_queue);
+		}
 
 		atomic_dec(&info->receive_credits);
 		info->receive_credit_target =
@@ -528,6 +515,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			info->keep_alive_requested = KEEP_ALIVE_PENDING;
 		}
 
+		/*
+		 * If this is a packet with data playload place the data in
+		 * reassembly queue and wake up the reading thread
+		 */
+		if (data_length) {
+			enqueue_reassembly(info, response, data_length);
+			wake_up_interruptible(&info->wait_reassembly_queue);
+		} else
+			put_receive_buffer(info, response);
+
 		return;
 	}
 
-- 
2.39.5



