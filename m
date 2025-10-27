Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A1331A811;
	Mon, 27 Oct 2025 19:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593141; cv=none; b=gXbxXr2ZK2tw8HHlI/EaGCxDqfncXEqfVwuiz6eZ+w3cHiTtptZKEIFm/CngjGcCZxOSFyoKtea6hiNkNzNA8adDx/FBeN0fGrtA5O1F5b9U5P66dx/a1M2/4be+F7cNDW3XvcSwDrEX3WhEyrhg8tZ//b42BFzeCHNru8VnJzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593141; c=relaxed/simple;
	bh=/jPUWmxo0VsjT6h2b9u+FNLBt4K07fC4ilAGpmT9MB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoSZfSwv1fglPJYSywVxxTUfMo4fp0egFNEpOZP46yyzoCgScg7xmFKU8YTV99XtMzXUCN7wIuC0BSmM6wP35uihS+Vq3RPjzFag/1NfJDHH0riS973u5gt45Lxl/XisP3ty1PSMgNbWj+GHSwfHwWTFRW4dXTvkTOBUJpMMtSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5RCG0MR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5RCG0MR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B17AC4CEF1;
	Mon, 27 Oct 2025 19:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593140;
	bh=/jPUWmxo0VsjT6h2b9u+FNLBt4K07fC4ilAGpmT9MB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5RCG0MR5xC6ymAzwwRYoD6SIOGLPmNZYdja62T+dNF/B3zM9es+o3A0BUPhOgNjt
	 LHHuTrbejizKKHDKXy5f/ana0S2ubpiLVfyVAxhv47Al2jeOPxffmaCZbWfjuqBpcS
	 x0gVRa368yy0iDEbg0CrbndvvIP+ZW8gVnWj5pTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 028/184] smb: client: queue post_recv_credits_work also if the peer raises the credit target
Date: Mon, 27 Oct 2025 19:35:10 +0100
Message-ID: <20251027183515.683750637@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 02548c477a90481c1fd0d6e7c84b4504ec2fcc12 ]

This is already handled in the server, but currently it done
in a very complex way there. So we do it much simpler.

Note that put_receive_buffer() will take care of it
in case data_length is 0.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 6480945c24592..b3e04b410afe6 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -537,6 +537,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbd_connection *info =
 		container_of(sc, struct smbd_connection, socket);
+	int old_recv_credit_target;
 	u32 data_offset = 0;
 	u32 data_length = 0;
 	u32 remaining_data_length = 0;
@@ -599,6 +600,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 
 		atomic_dec(&info->receive_credits);
+		old_recv_credit_target = info->receive_credit_target;
 		info->receive_credit_target =
 			le16_to_cpu(data_transfer->credits_requested);
 		if (le16_to_cpu(data_transfer->credits_granted)) {
@@ -629,6 +631,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		 * reassembly queue and wake up the reading thread
 		 */
 		if (data_length) {
+			if (info->receive_credit_target > old_recv_credit_target)
+				queue_work(info->workqueue, &info->post_send_credits_work);
+
 			enqueue_reassembly(info, response, data_length);
 			wake_up_interruptible(&sc->recv_io.reassembly.wait_queue);
 		} else
-- 
2.51.0



