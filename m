Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E3F25F780;
	Mon, 22 Sep 2025 19:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570415; cv=none; b=i1ZhTSnuorDu7V/ErB0+utJtDx7jnHoFOhdefz/Hqs+c/xtEKjeGO9bqYsYbF/zdjTmLXEC0JwI0VnwlLd38rJVnkhmbnLR8RPyX8Fv0SStYVLIRilY9UYpSB2PRZ+1w8FBtNt7Xm07rGO18DjTfE0mANghcS0w6kdwTJSe+tn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570415; c=relaxed/simple;
	bh=0KenQrYPmmryt0pNHVKt8X31HvyXAajZjoCwHI7Bd/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAqiPnxQwXelYYuYPdtPu9AFU0+NLQcPpH5FeIPJIfUKx794/2u3azFqqsmbQIGEXSZNhktMJMRVBagm2k8Pbzo5h/K5rgMvc8J8b6lJinK6/mnUINRw+MjVC2nRf9MRUqfK0zqWGoeiYW+ns2rIP3wR22VL8LAxFKcorU7rdHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elGjU1T1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elGjU1T1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F24C4CEF0;
	Mon, 22 Sep 2025 19:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570414;
	bh=0KenQrYPmmryt0pNHVKt8X31HvyXAajZjoCwHI7Bd/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elGjU1T1MpZ8j2Ldd1zkRQ/EYioNLmJX7MWopQePiGq2A3Xpi6lmJeI9k1bD4GaB7
	 IiTRfSbEBK14pmJhgVHHY9BhWOwmdv3Hqk5RtxzlZGoOVLsXhQo2pNtJ+jkTHvH9wB
	 I5Iu4QTtgx+J/zjpXkPvPpPo5Gwf9M5H/MMhWzoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 128/149] smb: smbdirect: introduce struct smbdirect_recv_io
Date: Mon, 22 Sep 2025 21:30:28 +0200
Message-ID: <20250922192416.103274654@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 60812d20da82606f0620904c281579a9af0ab452 ]

This will be used in client and server soon
in order to replace smbd_response/smb_direct_recvmsg.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: f57e53ea2523 ("smb: client: let recv_done verify data_offset, data_length and remaining_data_length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 5db7815b614f8..a7ad31c471a7b 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -54,4 +54,19 @@ struct smbdirect_socket {
 	} recv_io;
 };
 
+struct smbdirect_recv_io {
+	struct smbdirect_socket *socket;
+	struct ib_cqe cqe;
+	struct ib_sge sge;
+
+	/* Link to free or reassembly list */
+	struct list_head list;
+
+	/* Indicate if this is the 1st packet of a payload */
+	bool first_segment;
+
+	/* SMBD packet header and payload follows this structure */
+	u8 packet[];
+};
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.51.0



