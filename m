Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F933009E7
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154539; cv=none; b=Uyo1lbx4chgcjTammUKHVtzu2vtmbg7vqcpdYqRqb0ZfydbYOSpoZTDMNnvrN28CEW4VQdCaE3+R5yGEbAEgI1oD9JQ/VF/w/W8dzb9y/3otsAfsx1Hr50E/Dl1bktgTaJCtuw3EGiSsGRl5Bvw4z9tda4boRaJ3lcQVXfUcv6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154539; c=relaxed/simple;
	bh=sebBmGt/kZSdl7M53fls7i0xCSltQBWZDA7yb0VBwpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8QRdNAXgZYrGSh96fKYdOni0hDpewh9YUlVF7kX8jcFjrbEf9g8F4afYlzrDGJFSulNlOc0q9k2lrqmhwEOf0PftiIt/O5fe9IyPaFy6I/8BT2oeBT0WKoakpHWuvnYU+sC966YCH5PUpSz26fJfIM2xPhf7Gh77Zk+/pRADtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JiGb6H5P; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JiGb6H5P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=UBWxRjqbP1NxfDDkYBaBDDKVCkFotsBNHjyJFppPmTg=; b=JiGb6H5PJf6UudmPgXUHTCq6e9
	iJjx7dfwgJALWR9Q0/7/ELJlkPxkH+jsM1e8KfNvDUmtW5sXHnnPFeAsQftaWA/IuICvyl6pVMxs9
	hAZ6rhnA1wt5Iqbm2epzy9se2AHWtsP8q6c6P33cV9bayb8SoqGPmuvO0N1RjlHcqvKRXkJi4VrEt
	JlE6w5X7LVgr1uQLiousc09JpKn38gln8yGzX8+oPsRkaFhwx3uSLAwGilhHdhP6zZEh0m2nFsVcm
	ODCCfHIJVa01PSElJxwwiNeXETpFUeFb+Lx7SyyiEN5cVSelLkKIatKpfk73YxY6ZsVRvNAgttycy
	T4PSJdl3Bc0YKbldvsG9YrDWMkH8eLWjZ5UsjONbX0GXIHNPoGjTALMFseJ5V5dZ1vwXuDx0bjnn/
	xTlM/7bwxEiIhlyWdzjkuys/T/ZiMQeJw8qTnCkXEQBGjuvULp7iK3PSBM/E6V/9VzMvocWhLhBGA
	pAcrXUGhGB4v04XLMbOcqZ5M;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe17-000jJ8-2n;
	Mon, 25 Aug 2025 20:42:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 001/142] smb: smbdirect: introduce smbdirect_socket.status_wait
Date: Mon, 25 Aug 2025 22:39:22 +0200
Message-ID: <14aab245261c699cd5ac2057738b1659a5028113.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
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
index 3c4a8d627aa3..80c3b712804c 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -18,6 +18,7 @@ enum smbdirect_socket_status {
 
 struct smbdirect_socket {
 	enum smbdirect_socket_status status;
+	wait_queue_head_t status_wait;
 
 	/* RDMA related */
 	struct {
-- 
2.43.0

