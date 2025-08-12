Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A113F9D2;
	Tue, 12 Aug 2025 18:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023055; cv=none; b=Afaorm68SHRQ96QFS/ArqU/ua5P0haOoTFPEKg49qjwZMCyHgS8Yl9LPLZ+rfWisk24CpWeixY8AwmvAUo/lgsMMazXduHdVMNGLEUAQtkmeT4p8brwD5eh4HsVmvNn3oVW7fHt2ZueEuX45C3U0mR8y+khaBT5/G1ULFrDRgFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023055; c=relaxed/simple;
	bh=bmLUoJo3qUmcFz7gcTTZhPs7xfjk+ZFwHGTc1/+bozQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBf7QlKCE0i3bG/poDVdchmStJ/brtoYMup+kORvfw54GbaOqMbXROauS5T3UMQm7Zm4Ff0fi8xiY6fyPDkReHgo9q3yAtM8gkT4+n2adSi2a7jhUIIgvfwvyJ1mnGb7K6kSb1jG0Wfe1hYA6yb7okYcQzr3TfRk1r1F6HPpUc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3WyPeAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3WyPeAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374AFC4CEF0;
	Tue, 12 Aug 2025 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023055;
	bh=bmLUoJo3qUmcFz7gcTTZhPs7xfjk+ZFwHGTc1/+bozQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3WyPeAARqQs4q3lr8PAKXCurTN47e342KrrbH7CDZjTHeFQSA3d+gyWVvRlLr2eJ
	 5M27xMGCcTsYa/DEvkOynebApbMOQ4YDWIkJRuWaKPhbKsHGoWemE2c4pX28y7DmSp
	 y6NqzAbxgVrCDFIWGmVOYs5H5Uoe9fh7eGRWTY2U=
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
Subject: [PATCH 6.12 319/369] smb: client: let recv_done() avoid touching data_transfer after cleanup/move
Date: Tue, 12 Aug 2025 19:30:16 +0200
Message-ID: <20250812173028.721934716@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



