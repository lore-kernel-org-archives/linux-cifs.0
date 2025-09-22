Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EBF1FDA89;
	Mon, 22 Sep 2025 19:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569681; cv=none; b=ZIWb2IY63wDebG2EOqNLJQGOeiUl/rVVEGFelZ79FREgdWeuR3wWWtTC1fT+8l2jTnmx0aKG0muzCf+hDcATS4Zk6t4I7Bal2uelojURdp0J4X6fzH/ySQ23St5qtFZ92A/JDuhPiRbkyktsBBuXF8G73kJq6LLxP/SYbrtICgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569681; c=relaxed/simple;
	bh=dcjT9okpzy3BmcRq28rgo4MjdnV7GQkdXUYS/0z49dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZYqAgZwiz22T0bECSU104V3JSgUixZhFFFiq9u6Qq+YTMXzigt56lJdap6sJz+LwS52KTM8c0BB3Ycdg1U8eCbk6o9cbSHCbIm3k87wjhPbWOIK4QljvNV2QO1ngj03V95N3BZB0xqaFtcFa/TOdLWG9ENbT+mav3gI65V8jb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4j67MVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4j67MVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87F5C4CEF0;
	Mon, 22 Sep 2025 19:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569681;
	bh=dcjT9okpzy3BmcRq28rgo4MjdnV7GQkdXUYS/0z49dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4j67MVm4OKT/dsl/Fk/VN0sP8VZPzDhq8tY3a1Cd0S0fizfJ1KN/TI3j3ASahDOT
	 sTA9ye1Xylgu4fTdjcq3ZvTbHRgGuRKgsX21r1lYlVm+CTCd1aMZolk61S//uYc1kr
	 3HrXAGbErr2yxPvZF8XYwWh4S+OfHh/0rUeeQgao=
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
Subject: [PATCH 6.6 27/70] ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_recv_size
Date: Mon, 22 Sep 2025 21:29:27 +0200
Message-ID: <20250922192405.307453170@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


