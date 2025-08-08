Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF56A186E2D
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 16:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754671767; cv=none; b=bksdQiEv1pT8PAnV2S88PDbHwXjsSmcJ+JBQznGA3368FTnzK0l4YJFBd3Vom97IHLU2aQdNCJgLCl5fMPBzjccI37TRAIsj/gGcCsH7VqHZTrpqHo+85eViJ4rU9Ct0/l6pzGBuybMYUphZie7oAWiD2ksTcV1qWseApGWiEzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754671767; c=relaxed/simple;
	bh=ql0nxxrWjlb/xU6qbkV32Zob4vxeeHokdzVDYAioBnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXmpOcywW4Q03zZ5rdUuhERm59UR+aqg+mfLaAvwjSBp3K0n0uWn83UbXyJZu+tHlPMOLupa3h5rcdS2ybllMe+DnY6LfOwXU3lnwji1/srQt4cGJG+0ilJUQ62JcE3SQz4421K9XScC9v/IgTh2JU+/EOKQxI3Dl6ectdtAjVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ivQVDG70; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ivQVDG70"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=F3hwMFbPa1YtwtrilJjOweE62A0mW4eEN+pLyw+biTU=; b=ivQVDG70ajdJIf8ktcwGvnN1TH
	h61HCT4Doamd04inMUB11zX26bDcCgJTbXsiqtWph8IZTfxt6CheaxXvnQJf8N4+Z/3AS7WVr93cl
	+/3xhaAoQWExsXqeF/Io9PSSXlgXTrljGjflcPCjXME3TH+SnmcTMLD/AIS1ws6Fuq3gHyag2TKeC
	/SGa6AgcxUaujhSTjk7CLBkr6BQrtrJmbAmJ30GSrmqtF18ENOO08kgICqiLD5mjFLJAqQLtVNr63
	LFZ9XeW7kSfmwrX64xsouwBp4HIf9EbcvWD5s+VCNtQCklrWRzMazO2X88sMerLewW2I7QxZ4fNog
	c1B3QR768sSgdrgAQ/5mOyPJU40R4bLOV+1nK8sCkAck4Wnkma0kYZij4NWkUiFaeHVx8kJNbqPb3
	wVWUK/7uJuSZwFv7JjIvGpbDLFWF8RKGsj+iRaEHZiUkLzl+kkqyPL/TaajZvUj7pHXlSqS/cttPe
	etYUgmJ8QUvfrYMFOtIErQXv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukQHS-001qV1-2n;
	Fri, 08 Aug 2025 16:49:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 8/9] smb: smbdirect: introduce smbdirect_socket.status_wait
Date: Fri,  8 Aug 2025 18:48:16 +0200
Message-ID: <0f1d3a0d282c9f053e8c0baf9f86d4ba13d3d02e.1754671444.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754671444.git.metze@samba.org>
References: <cover.1754671444.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by server and client soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index f43eabdd413d..aac4b040606b 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -28,6 +28,7 @@ enum smbdirect_socket_status {
 
 struct smbdirect_socket {
 	enum smbdirect_socket_status status;
+	wait_queue_head_t status_wait;
 
 	/* RDMA related */
 	struct {
-- 
2.43.0

