Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CE727B320;
	Mon, 22 Sep 2025 19:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569899; cv=none; b=IgJ2Zxonx3QwlPiMK5G2a3BIooRXH6jCHTrGKaqOrIVoVb1H3cDuVTku/oWa/DuGC2oKaI35aSq/6OWsnae8ESsbO7b+F3hXp9nrZHIXOtQnKxc8sOuAranfL9GqET8RTdrOb3m7kzWqtnQ9aUc4nH7TCgeck8SggFUxJirMSzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569899; c=relaxed/simple;
	bh=NmcV47SRVRnbJmVC1h3O9ORsWnN/wf/D6Qf8wq91Ex0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gx/zkjfs5wEq+NzTu65B819LDj/wU2KoOW6DrR58Pwsfxva532ymMRZr+2Nh9X6vnK/uc5dqGYus54i0bqbeilTerfnGJLEo21hqc5hO5AWoWI3I3Gib+cvK1joV2+EhPxbY/HQAQH7ldRgedVKDH42+NBP2uemLn9hWGA/0QR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVIp2P0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVIp2P0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8D7C4CEF0;
	Mon, 22 Sep 2025 19:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569899;
	bh=NmcV47SRVRnbJmVC1h3O9ORsWnN/wf/D6Qf8wq91Ex0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVIp2P0+v8jxBSnnKanefdOuAY2csjfWTom8slIAZ+ij9xPiAtCU+RKw9L0x1Vp2u
	 mhlioeP/Cs9WWieIplvCtVvLO4XNnaTuiRXI953vvMzZ59T3tJA45nzEdnKhtFuRH/
	 yu/M5srGkoL/Vrmtjs8hfjOp1/T/0FASYkax49/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 035/105] ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_recv_size
Date: Mon, 22 Sep 2025 21:29:18 +0200
Message-ID: <20250922192409.835051635@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

commit e1868ba37fd27c6a68e31565402b154beaa65df0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -553,7 +553,7 @@ static void recv_done(struct ib_cq *cq,
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
-		unsigned int data_offset, data_length;
+		u32 remaining_data_length, data_offset, data_length;
 		int avail_recvmsg_count, receive_credits;
 
 		if (wc->byte_len <
@@ -563,6 +563,7 @@ static void recv_done(struct ib_cq *cq,
 			return;
 		}
 
+		remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
 		data_length = le32_to_cpu(data_transfer->data_length);
 		data_offset = le32_to_cpu(data_transfer->data_offset);
 		if (wc->byte_len < data_offset ||
@@ -570,6 +571,14 @@ static void recv_done(struct ib_cq *cq,
 			put_recvmsg(t, recvmsg);
 			smb_direct_disconnect_rdma_connection(t);
 			return;
+		}
+		if (remaining_data_length > t->max_fragmented_recv_size ||
+		    data_length > t->max_fragmented_recv_size ||
+		    (u64)remaining_data_length + (u64)data_length >
+		    (u64)t->max_fragmented_recv_size) {
+			put_recvmsg(t, recvmsg);
+			smb_direct_disconnect_rdma_connection(t);
+			return;
 		}
 
 		if (data_length) {


