Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D366292B4B
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410385; cv=none; b=qU4b5uZ/OhOr5ikqgKX3gsfziFJ+ZrPJ5uxRvjiGCWryqYafqWiKMfq06l41vxm6AThjMVT2aSo9n/fsB/SuWENF44LhYdwAR6m7LqjMlt+fCgmTnajm6Q2JFhw8Cfrc4Lt10x3unv5aQc/eHeimSjS5xQyiqmIIp7DEityR0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410385; c=relaxed/simple;
	bh=ceaIyDRQd+oqzHRzbCN3+x/4FfF/PTAX6YYIW/CScY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJyNRTsMufE4bEysp4nCseNjEp0aBi0Kbo46dXzIHSCHgy+KdX56JVyEXTdBvu6MD1gnPiE8nymyYSrjDK7QEJSRhW3x+DIDORHg0/ecEg2SqeKp31PwxA4+HAedVZAsfdoFGC3BU0vTpRZFLMZ+yd6OAxPaCkEQAQYlSEFjv+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Gd3JfTSV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Gd3JfTSV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=eGMM7NR3iGTzMmcwJ12NL6WktXA2eMw8/ubnp3msImE=; b=Gd3JfTSVhik8dUZPUkhAiel4xz
	OMEAFvDBH7V0MoTzx4S5vL3d5WsYynAmFrE7GpsSCxKorUJ3gxXpRo/HuMiBBbXymxQLqoO50Xjt6
	Y1z122ISxz0pFM2+xd5WKcT4ulrsSTb53pgnyunxn/7MYwKXn1OoX9+PnzhPniOMP6R8PuMDTnp+p
	Ii+xk3/MLjc4/LQLOApF8y3p7JZ3daqG9rhT8t3Z6djgrLmg/az+8cqkA1e19W0my8nBacZDZsNYy
	ttfeKy4seD40Jos/qCXvL6U21OX4iNcVGhOCNJ2V565toF542pMzBdK+rW/LM6cQoj87+J0vjIjBR
	eq0qw0u5gFAuNvuKYLD5Ai8m2sREFeAAQ/Iip9nFtwNNJxJQ2gV1Ig5AYGNqv+VV7WCvR7ZnQra0K
	zY5T7/miFiKxJqwig5GyDauagcwCYtBLfHnx3t3DaKcw94n8VFXc3xd8woG3GM+OatwfFj0vRtfla
	wMTUgqq5rIgniWtozI84t9uu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKHc-0019k3-1H;
	Tue, 05 Aug 2025 16:13:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 08/17] smb: smbdirect: introduce smbdirect_socket.recv_io.reassembly.*
Date: Tue,  5 Aug 2025 18:11:36 +0200
Message-ID: <52db88c43dd011e6782ff8a3fbfa7cbde91e646c.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used in common between client and server soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 21a58e6078cb..3ae834ca3af1 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -60,6 +60,32 @@ struct smbdirect_socket {
 			struct list_head list;
 			spinlock_t lock;
 		} free;
+
+		/*
+		 * The list of arrived non-empty smbdirect_recv_io
+		 * structures
+		 *
+		 * This represents the reassembly queue.
+		 */
+		struct {
+			struct list_head list;
+			spinlock_t lock;
+			wait_queue_head_t wait_queue;
+			/* total data length of reassembly queue */
+			int data_length;
+			int queue_length;
+			/* the offset to first buffer in reassembly queue */
+			int first_entry_offset;
+			/*
+			 * Indicate if we have received a full packet on the
+			 * connection This is used to identify the first SMBD
+			 * packet of a assembled payload (SMB packet) in
+			 * reassembly queue so we can return a RFC1002 length to
+			 * upper layer to indicate the length of the SMB packet
+			 * received
+			 */
+			bool full_packet_received;
+		} reassembly;
 	} recv_io;
 };
 
-- 
2.43.0

