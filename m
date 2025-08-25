Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25142393DE3
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155396; cv=none; b=sXkBEdb0WsupTojSpELmZ+WRIlvYZ4z7y6rs7+2dIyiLyhhdEsxBRAOUSTC2ZJH6Mfo5JGYZ0Ur5qT5r0V11VMLUBuAFyaUZhuv7YHaU20RQjdYGpMOF+DFpbJvSGCVZv/SzQeL7wH5kDfPeiKaoCk6mHeaD3P7x3MGoKdOa+fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155396; c=relaxed/simple;
	bh=O4OkFxNAicOgblD/1566qlTuIEEKLBPMZ9hQUd6Nb4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqjBTMYQ+THrfgGimZ7EG8aPBphK/de/jvYvW6Ov20S46kBM6WCSMf26Ni6ssaRx20hgj9IgEqn734sdPbu7xpgu/82PJ/UPYTxVZbrWXgj3ZWkIBQQNPH5V5Q0jSLMZLr3tH1g7XnwR8vb03rzioU9uRCQfdz3JDNRhMbmmV9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Z7wYmaIR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Z7wYmaIR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=lKt3KVmiUE+Tvp18vwYnt2qRQq72X9JhqkJgkgUAfCg=; b=Z7wYmaIRtiCQiNhCo5JNrBh0VQ
	F/lwDPACtaqMJId7uJsOva8S/oaytRbqZSFWa40veId4qrMftQ69/L0pvc45sr60u9ZujuKx9+YIa
	j9MwV6T5Wrq9/n88CTMO/PtX3KpZf5WprttoJnkiMfi/PmghTMJSDqNOn8EqOhM/gZzKfIyy7Sb2Z
	JXOg/dNwDUu7ktvIbi+RF+5YAhNNjN/6kFFwgXaRaQ4egIGNzLtO0VuP+lAjhQI5SmPFeT+60K9pk
	ALx3vkaWNq98casGrRCbNmJ+ze+W6dVvCZbreHk2nx1JkOkCQVRYNS9/sLSQ2dxE2XHMc1RCcvcP9
	uDmdEaNt00vIgPSF1HRw2SwqKe14b5RZMiyA40/TYJ32eZ7y3q9QDy+g+3gMqKy9vKvF9ERXeVyD5
	aux7f9jJcW3tgEk8AdZvTVrrINXHnpKpbPurMUsElBlWAkYNph8lgl+Ub01Ov+EaANGbzOzRwRDvi
	OHtn2TyCleZg2at72XnkPnac;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeEx-000m9u-2P;
	Mon, 25 Aug 2025 20:56:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 088/142] smb: server: add a pr_info() when the server starts running
Date: Mon, 25 Aug 2025 22:40:49 +0200
Message-ID: <7fde1a95fc05ac48657dff125a0c3c9743a8556a.1756139607.git.metze@samba.org>
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

We already have a message like:
ksmbd: kill command received
when the server stops running.

This makes it easier for debugging in order to match any possible
warnings/errors in dmesg with restarted server.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/server.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 8c9c49c3a0a4..40420544cc25 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -365,6 +365,7 @@ static void server_ctrl_handle_init(struct server_ctrl_struct *ctrl)
 		return;
 	}
 
+	pr_info("running\n");
 	WRITE_ONCE(server_conf.state, SERVER_STATE_RUNNING);
 }
 
-- 
2.43.0

