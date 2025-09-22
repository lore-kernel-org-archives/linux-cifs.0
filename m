Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D306817A2EA;
	Mon, 22 Sep 2025 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569541; cv=none; b=r6A7vNzKQ/DyiVGe75bmdwWDw6njrGaiC276rwoWwttBtPI9dC/t9mj2XlOzRakSZcszeVnm/zKmtmS1OBnw10OBtQG0sNQmz+d13ig1t/mv2uRD9CbwgJ46zOESPZA8KLD7sG9G3cb0td9YRjcKkvpeQrv19Vf0Az7IbivzAyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569541; c=relaxed/simple;
	bh=HU/LkVE4xK7U6YYazTC/lhk+ASfRqyKfhcWbdecCmLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0/Tcbz2VZAmqdtelRJ0tW9UytR/aqVCdqiTiKxMI0K4bPWQ9/4K0e/tlKrTYgBiaxl4MjvNSF5IIMSGlWs1AGtcNJV/pSJZqdB1j5+tAHyx3j7ULRiVnPvKlOQ8YqxAlZW4NaSEJKY8hA4qNaDXPlIKwFP3R1gJvDo8a9Zqo/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7EdgjeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7EdgjeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288FEC4CEF0;
	Mon, 22 Sep 2025 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569541;
	bh=HU/LkVE4xK7U6YYazTC/lhk+ASfRqyKfhcWbdecCmLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7EdgjeHmTSdUpHOemZlldwEImHZN/ZAZ6jelnQZV9ksOQK18HOL4b9d61NOU06Dg
	 D6BhG6AnS/SyTdOfl4f6kPErdO44DKHSz7Yrki1ZKsO1kYIZDKPekXqDUOR3V37u3B
	 +JsD99p7e60xiHKK1AMhPu+HB0M+fateJrWgADrk=
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
Subject: [PATCH 6.1 21/61] ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_recv_size
Date: Mon, 22 Sep 2025 21:29:14 +0200
Message-ID: <20250922192404.133503441@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -548,7 +548,7 @@ static void recv_done(struct ib_cq *cq,
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
-		unsigned int data_offset, data_length;
+		u32 remaining_data_length, data_offset, data_length;
 		int avail_recvmsg_count, receive_credits;
 
 		if (wc->byte_len <
@@ -558,6 +558,7 @@ static void recv_done(struct ib_cq *cq,
 			return;
 		}
 
+		remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
 		data_length = le32_to_cpu(data_transfer->data_length);
 		data_offset = le32_to_cpu(data_transfer->data_offset);
 		if (wc->byte_len < data_offset ||
@@ -565,6 +566,14 @@ static void recv_done(struct ib_cq *cq,
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


