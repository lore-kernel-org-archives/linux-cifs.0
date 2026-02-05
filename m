Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDB13382EB
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308086; cv=none; b=hWll+veDhnV+tSz47EEK33EIm1Hjob9ePin6g9paH3gJTlCa3qjpePD4Ehh3ZHu0Hwe6uByiXXzMxG25NFocl+xxx5cJOMib2ouZvlTw6Qbg4QHam4xETjaLBn8l0+Tuqm74swcBWHuIwutuddn9v2f0hzgmEr9G0yt9Nq4QfA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308086; c=relaxed/simple;
	bh=5Ukti1CHHQnhjgoi0nlOFhgd7UTFUSVTdovRRnzTIlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLlvrXYDhhJ72bhnwbYEn1W5zmvEllfJYqKDG75IHBiwSPL+fFmjLxhhJaJkv8eRnW/7S5Q/r9TJgsJSzPPwqW1QZqWmVX5M55E+EZJNngUVnnwGYK2RgYbO8ocVVZp/mEZlW7vVuwPwKpkhy75OgDlW2zkVNfiA80MbcAJRP/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=FFHIKfpm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="FFHIKfpm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=HFyPUsnVp5nXDBbRXdZHM8xbzqV9wtA+QGFBOyMliRk=; b=FFHIKfpmomTdBV0GnvF8m4EIPJ
	a/DqhjJu39lpGNo+zOVNw4/pAnn4Mq7Slzcmq9YGXKySRMo0k2lrzAemw+53GDy7jsuE0nw9Us/cA
	up2K0pq5ITdZbGa5pd445Rp6Xlan4jtwus8QHjtLYMNUhykyaschHIrbgWPwZFSrE3Ue51u9tDdm1
	sx7ciIdau8Ppg44s/8Nc2cpxoKc5pMkDfeQL/rgWRVeFP/uR2vnELzFa9cfLyO4nQuHCluFebqsBR
	V9cadCs9r/aY8s0L4TEeo8yOqgLmCkepx6AzzaF0dwJmRjrE8iwINRopVgfFVRZJsE1HH9yy3kTIX
	8iJYaM4NQ4DsBybrdMdI9Ihld7TxaC8qNS8k67LFoRVkJ/B9TGSS9yclAeSPDj1hS3R+EuVH//OhW
	D8vezG7d3vdWkvXmniSLfwQVGkyrvr0HbYIH6rOW2iu1QDBADT1Fb/mfjrPRJAmoHXj8bl12LKiDp
	+hTyaoFFIgIpRWhIfkeFWEzf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vo20B-00000004THc-1aBQ;
	Thu, 05 Feb 2026 16:14:43 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] smb: client: correct value for smbd_max_fragmented_recv_size
Date: Thu,  5 Feb 2026 17:14:14 +0100
Message-ID: <d3a65bfa54d86ebaf9e912d0f0b32d7916dc6012.1770307237.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1770307237.git.metze@samba.org>
References: <cover.1770307237.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we download a file without rdma offload or get
a large directly enumeration from the server,
the server might want to send up to smbd_max_fragmented_recv_size
bytes, but if it is too large all our recv buffers
might already be moved to the recv_io.reassembly.list
and we're no longer able to grant recv credits.

The maximum fragmented upper-layer payload receive size supported

Assume max_payload_per_credit is
smbd_max_receive_size - 24 = 1340

The maximum number would be
smbd_receive_credit_max * max_payload_per_credit

                      1340 * 255 = 341700 (0x536C4)

The minimum value from the spec is 131072 (0x20000)

For now we use the logic we used in ksmbd before:
                (1364 * 255) / 2 = 173910 (0x2A756)

Fixes: 03bee01d6215 ("CIFS: SMBD: Add SMB Direct protocol initial values and constants")
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index bb236f80b3c7..d44847c9d8fc 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -101,8 +101,23 @@ int smbd_send_credit_target = 255;
 /* The maximum single message size can be sent to remote peer */
 int smbd_max_send_size = 1364;
 
-/*  The maximum fragmented upper-layer payload receive size supported */
-int smbd_max_fragmented_recv_size = 1024 * 1024;
+/*
+ * The maximum fragmented upper-layer payload receive size supported
+ *
+ * Assume max_payload_per_credit is
+ * smbd_max_receive_size - 24 = 1340
+ *
+ * The maximum number would be
+ * smbd_receive_credit_max * max_payload_per_credit
+ *
+ *                       1340 * 255 = 341700 (0x536C4)
+ *
+ * The minimum value from the spec is 131072 (0x20000)
+ *
+ * For now we use the logic we used in ksmbd before:
+ *                 (1364 * 255) / 2 = 173910 (0x2A756)
+ */
+int smbd_max_fragmented_recv_size = (1364 * 255) / 2;
 
 /*  The maximum single-message size which can be received */
 int smbd_max_receive_size = 1364;
-- 
2.43.0

