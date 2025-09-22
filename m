Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4F18C2C;
	Mon, 22 Sep 2025 19:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570410; cv=none; b=LW6bpnpMZv6Ol5Qyw3LRdaYsG/fyBRnyfUGyvHCFqY+gIav7YXd4E5lAvkNJcIv2Ka+SZee1vkPyBnDfuTmzYP6m4FOzDRrTORPoKpKvmEg4cMkCEq9BTrv52v6oelhmreKRhpZnqgkLIkoDcZAq1BDS9y1lywd4S1D2/1Tdy5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570410; c=relaxed/simple;
	bh=S9n1ipRO+evAVgQoCgh7Nokb1mEeQdjHvdMSAWi2sZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gF+RlegusCKfz/8V4NeVJXCqnpHaRrCRwjpJrWy+W4PFq33A++o9qkYBgtXfZ2uexspvm0Lj1Q1WVPQPe91hBWVF60TME9fQeiJy1ysu/GAnw4fD0loBpLK67IMgErRK717IH31UpXT0Gzy6eYonXLA8gB1pZ1pxTaz3IkuOe7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGXtrSrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGXtrSrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C74C4CEF0;
	Mon, 22 Sep 2025 19:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570409;
	bh=S9n1ipRO+evAVgQoCgh7Nokb1mEeQdjHvdMSAWi2sZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGXtrSrA2Se1Bf4LL9+jlerSDRqZkq17KaUd4xZZG+pqrQbdKVV+ak8/RDON+8Oes
	 1ILaj8X8FBvJxlqB1WdGIGYmYs1OcxigXyR55gG8pRd6g9Z/f/yxVfEglo8T3DXKHV
	 FJACSfh05fEim+F5XDpXiRm81e+5+6kiNvXzUZCE=
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
Subject: [PATCH 6.16 126/149] smb: smbdirect: introduce smbdirect_socket.recv_io.expected
Date: Mon, 22 Sep 2025 21:30:26 +0200
Message-ID: <20250922192416.052241839@linuxfoundation.org>
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

[ Upstream commit 33dd53a90e3419ea260e9ff2b4aa107385cdf7fa ]

The expected message type can be global as they never change
during the after negotiation process.

This will replace smbd_response->type and smb_direct_recvmsg->type
in future.

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
 fs/smb/common/smbdirect/smbdirect_socket.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index e5b15cc44a7ba..5db7815b614f8 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -38,6 +38,20 @@ struct smbdirect_socket {
 	} ib;
 
 	struct smbdirect_socket_parameters parameters;
+
+	/*
+	 * The state for posted receive buffers
+	 */
+	struct {
+		/*
+		 * The type of PDU we are expecting
+		 */
+		enum {
+			SMBDIRECT_EXPECT_NEGOTIATE_REQ = 1,
+			SMBDIRECT_EXPECT_NEGOTIATE_REP = 2,
+			SMBDIRECT_EXPECT_DATA_TRANSFER = 3,
+		} expected;
+	} recv_io;
 };
 
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.51.0



