Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB7E271475
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154663; cv=none; b=k2F9zMUUvC2QrcV24aVqR1ElYVKStjq8Y37nJxMge0Fa+Uugv8d3x1Q2m8DTqvtd8VdUIHhy3vT54WWSeCQYowh7wMbe0CzpNPMSoycFxPKFN7swByh2sto1ALEzq2ATNKUQFzvcfAQALZDP7UN8/D5KvXtvP/FkKaw6O/WSu5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154663; c=relaxed/simple;
	bh=pcdgANM/JmfpXHjurPbSU+EWi5BscWvgGlL3YjCfonY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUYckljs7S1etGje11mPvbhYAzLnmS+rkIV6Mjzaq4wdZLLogr+ovXBfHagwSakqrMGWy89WI1MohbEI2R8ndWiv6Fs0g5p+DWV0aHclN9n87Kr7Q5HGv7V+XNuVVIkCvR/QbaKrjsAtWvp9uCMJb5tgRLcyihY35d/5D1d06Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PMM0GtAo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PMM0GtAo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=D245HkVB6YKsiXq7EM6IE/uFcsoP0ia5JlprlPOigmI=; b=PMM0GtAofowaRpZCUz3UWgjH9B
	R97F06fSCjhYTtnUwck0HmDLUS2NBO107Jij+cmqbmmq78QbnG8Q0jVVmbVjotRAaPrZAk1zuWcej
	5bRmwJH2K2mUR5/MXjmvSq3h4GKoXI5zkwj4kylnK6ulbyTwdYr984tY2Uu4tMDO91wpFIdW+djH/
	NdyuCq3Z3IIFo9O85ajJU3trC1d9LjgZBkfEdqvehqslxwtH2X7ulGuki+lOQnUIU4RzYZZGOsk5z
	UUnC2vgbLzWuqtigunXK8f60ajmgyKSShjqx6PWzhuCmA7McAEZIQDPp33ktum+fV1/gKA6bFKIZS
	m9msz4sJ7hfB6Q88iLGbeKy2/h64oxjGBMV3JsgmJYqfheqBaaaX8NjuI/cMILqx4kisz9fA46mBq
	kohfm7ZegTkVcYCT+BZK3xlplUfnMk2CFpqLeafF3VxiO8+NOAlPGR6m8MRHKdPIZSz+0RM3qKDIz
	sYxX1DD5kPS1XGWqrkqvg0ws;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe2w-000jbq-1F;
	Mon, 25 Aug 2025 20:44:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 013/142] smb: smbdirect: introduce smbdirect_socket.idle.{keepalive,immediate_work,timer_work}
Date: Mon, 25 Aug 2025 22:39:34 +0200
Message-ID: <a0bf68cc3a37e128fe4d98f0fae19fc2fbff1f2f.1756139607.git.metze@samba.org>
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

This will allow client and server to use the common structures in order
to share common functions later.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 11f43a501c33..fade09dfc63d 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -18,6 +18,12 @@ enum smbdirect_socket_status {
 	SMBDIRECT_SOCKET_DESTROYED
 };
 
+enum smbdirect_keepalive_status {
+	SMBDIRECT_KEEPALIVE_NONE,
+	SMBDIRECT_KEEPALIVE_PENDING,
+	SMBDIRECT_KEEPALIVE_SENT
+};
+
 struct smbdirect_socket {
 	enum smbdirect_socket_status status;
 	wait_queue_head_t status_wait;
@@ -48,6 +54,15 @@ struct smbdirect_socket {
 
 	struct smbdirect_socket_parameters parameters;
 
+	/*
+	 * The state for keepalive and timeout handling
+	 */
+	struct {
+		enum smbdirect_keepalive_status keepalive;
+		struct work_struct immediate_work;
+		struct delayed_work timer_work;
+	} idle;
+
 	/*
 	 * The state for posted send buffers
 	 */
-- 
2.43.0

