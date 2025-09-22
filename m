Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9DA15855E;
	Mon, 22 Sep 2025 02:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758507557; cv=none; b=EJlsjyNGa1TQq36kzeyti1AB/FjdeO6YgtVMeKn1lQdVrcWyPDPAsaPxXlLXbT081O0v381ssbH1cCWt0Gcod3d5RKmwco2kCyzG0kHq0jJNY52u+Vv5il7hpNoyayQ9XekFS1E2BhzsAgPDGaK7xkyYDOPoaPaoBRh3eznVeDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758507557; c=relaxed/simple;
	bh=/8/3wh8ghIq+NEYS38vos0EhKZoXmD895oOEHwHz8fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8LY88m+ZaQ7STUl/4z9J33bKb7YqajQASWaxxwgjn6ifEDaK2fXnCewNzctEPSTuqIWa1dg9fcesr/ufxTZWZJ8vEsu8c6CShCgd20432TTcipTwSQHLbmEO4ywiLmtjW29pRgnzN9dBdSKAqYzr6Z9EhKitOTk30IkXwW8Jcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4w9eYjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4w9eYjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576DCC4CEE7;
	Mon, 22 Sep 2025 02:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758507554;
	bh=/8/3wh8ghIq+NEYS38vos0EhKZoXmD895oOEHwHz8fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4w9eYjX1aPQ8M8xJIaZloA66xbRBENymiYBQqJmDaP9Oxzy+tEDbae0iTenmxeM6
	 lIMFY8MtVvZ2poohTfe3wY8zJIRWDD5Zo/2fnquYuUDnccNV4DBheycKNywIbNhUYJ
	 8tIZkglZ0lzXaW2Y/jPc98Lqs4a1lRTrwB6MUX60BFcpyO/pmRqWFn2z5Nh/Io3Fau
	 tN4LXPZewRHlPIyL31cW1C6Ha0CRR/dTNhAub3rl4qAfbS5IpCtkoW2CcRmCypvKAB
	 tpLOr1RGl77jpbLLIw8DX3bfCIMpGYO41obHgiS933/j9/oM8Nly2acVgCE7RKAXA3
	 HX/1xKW6rBLpg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Stefan Metzmacher <metze@samba.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15.y] ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_recv_size
Date: Sun, 21 Sep 2025 22:19:08 -0400
Message-ID: <20250922021908.3142096-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2025092135-estate-gander-564d@gregkh>
References: <2025092135-estate-gander-564d@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit e1868ba37fd27c6a68e31565402b154beaa65df0 ]

This is inspired by the check for data_offset + data_length.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: stable@vger.kernel.org
Fixes: 2ea086e35c3d ("ksmbd: add buffer validation for smb direct")
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ No data_offset ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 2f02632905842..53e543129fe12 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -548,7 +548,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
-		unsigned int data_length;
+		u32 remaining_data_length, data_length;
 		int avail_recvmsg_count, receive_credits;
 
 		if (wc->byte_len <
@@ -558,7 +558,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			return;
 		}
 
+		remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
 		data_length = le32_to_cpu(data_transfer->data_length);
+		if (remaining_data_length > t->max_fragmented_recv_size ||
+		    data_length > t->max_fragmented_recv_size ||
+		    (u64)remaining_data_length + (u64)data_length >
+		    (u64)t->max_fragmented_recv_size) {
+			put_recvmsg(t, recvmsg);
+			smb_direct_disconnect_rdma_connection(t);
+			return;
+		}
 		if (data_length) {
 			if (wc->byte_len < sizeof(struct smb_direct_data_transfer) +
 			    (u64)data_length) {
-- 
2.51.0

