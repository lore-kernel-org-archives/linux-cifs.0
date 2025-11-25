Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789AF32A3CC
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093429; cv=none; b=CAz4dIOaXRixD9nkrPFOKEdHfMida/PYNQy04/FG4qWGEZ1ctZVul8ot8PL0E3Y8WGhN/X2zcYPrV/M6OaZslvgjJ46Pm389OwoDXkq9PlXXbKeazCrNy5z/KBjcWGmYykz7gVEnwZHslmhOi403dEqY1YwDfSRQE3fjwxL6Fuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093429; c=relaxed/simple;
	bh=ty1EIASme5LyYrL20ubKqHmTdvfucgF8BOTyrkduGuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouZutBwfkZJXOBA7eisrewpD12Ih0ozIgDiJTny00LqYLavWYFK8eeOOT00iCiSl6IxNo6nRNyr4lzYYMn+2NFr9A8LkP7eUIfSUEENFm5hgEe+iGMhgtwkzRTpH8cIAvbXeUAggRLgoO/aKKPU62MjUQQo0FaC+gkQbezACb8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xhOHWsXB; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xhOHWsXB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Op+S5bVdjI3q0kJR9LDywlYCBGb1n34imLxkNJ2rr/k=; b=xhOHWsXB7erVFEh5F6u/3z2s8R
	YEJoJy3fq5dIsKuo0oAzNecQpi1h7lbOxrV5jwabNAGnHK9W+pKfqfEHwEQqRqDyAGop2XHTvZ+zz
	0s7W/nRZnLGOPpJ9fEN8UJJ+jpam+AWco9z7PN3p7Ndc9CBgpSEFi34UbzZhlBeqndYoxJUp9sbl1
	AAc4HpLZNzfIFTbvdESrDwV6UQ3tfMK4pPdlFFBIH7gKrmVdfbOlze+2SRoh1C0Rc1x+hB/4kQ2hC
	nfJqyaMS4GV8I0NjHzB2iYltgcTee5X+EJP1U9PWDCDZRvTRP6ZF1Cheqdxa19PpCAF18V7mem5GI
	IgA0JgYlec2Ja0G8BqXJlE6iosl09AGHgZuZX4OXoeQ7RDJvBBYqsx7pOZlWQ0CXJlxzff/dfzWuy
	nNN3MqeqNosRF1SKUN/Rl/+zhW0zfNa0HAXXayGzgl6j6Oc5rq0V/TDmnqM+Pnyn2sh0o1LcaxXyP
	6Mbq5gMipo2ToknGHiek8Tzn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxHj-00FcTw-00;
	Tue, 25 Nov 2025 17:57:03 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 004/145] smb: smbdirect: introduce smbdirect_recv_io.complex_work
Date: Tue, 25 Nov 2025 18:54:10 +0100
Message-ID: <a514dbaeac0c38c77f1107c90615e53e44f839f5.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by client and server in order to implement
async connect/accept logic.

The problems is that ib_post_recv() completions can run
in an interrupt context, where we are not allowed to
sleep.

During the negotiation phase we need to do complex things
e.g. allocate memory, which might sleep, so we'll offload
this to the workqueue instead.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index cf8a16d3d895..ea269f55935d 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -631,6 +631,14 @@ struct smbdirect_recv_io {
 #define SMBDIRECT_RECV_IO_MAX_SGE 1
 	struct ib_sge sge;
 
+	/*
+	 * We may need to handle complex
+	 * work that might sleep and are
+	 * not allowed to run in an interrupt
+	 * context.
+	 */
+	struct work_struct complex_work;
+
 	/* Link to free or reassembly list */
 	struct list_head list;
 
-- 
2.43.0

