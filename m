Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF75C32D439
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095365; cv=none; b=GDOpD8Ty9GE4exH2ni+E7VRmnpRsFsp8tejIc/4RntK17xRwaun18X5AeQd1X9cUkwEzLHDs45xMhdTsfbQbwKVIKRYEP+60h2WiMLrE5HZBHlWYWyYbQ70c+mxqRLZQBzunzt5NlrN1O3l0OI4PYstIhsqeQMJ3dzFfN5BU68I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095365; c=relaxed/simple;
	bh=VSxBH75+mEz/hRMdcs/sQRO5hzh2GgIKlpCzSY+xpSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeESuWsBrPpMrBeHc1ma/v0uBpNoQPexSZdaGePiAYMlAPh60QBkEmT/fgBaDxJTmQ9bb2ON1hwFZDzEFfdBTcHs1Cad0Oj3iPf2DbmVa2/P/yhV3tBAvzFn79WGTuAtY4mFl69VI+oVusPA9lCzaDkfS1DOA+nCRE1t4+mUD0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=j8u/Wxa2; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="j8u/Wxa2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=b9yHqoqKTCHAN8u0FwBxpC+ttSlTRj9+OdVegGgmRjw=; b=j8u/Wxa2vrlJsSFsfzaFn5oEyt
	X7sTAE95+GBblWel1JeFaGWGwyk+VgjYQ7aVT2+VCBzDO0U5H0gHbJ6d/MGyFQM+t/xLcix9wrGay
	J+555ChBwC0pfHS90nTGORG5N+8u1yOliaqM8wf8KiDz6Xacx+A1uwVCx2bNcNAvo720whY9y2Si1
	5qz89g3RvG9kvkixqlLSmCJGxX6/fLFQJYLJGwfHb/n4EZiXgkC6gYkaqX+GDhY+9Lto+e7JXBB0k
	yTb35aoKNQGtBCe5bEqo9CxIVOPzwJW30dwHrIdBbQOLAwto1rUXCotuDls6xZ4jM8VEVFkbwgQeM
	SXnzW2j50Qu+dIHTEr4SH/1Q/3IN96JQ5c3ss2ICM4Hx85EhzafSQ9uqP+anhhHY31QD+qA54+A/i
	8ui9Ak/CFhpWVImUSUJJYi0Zalp/vSe3zLrJMRxdV3LuAhdHWq2abKCkLyyjLu/UQPHtXARCZI7fB
	T8bgs5kDvGyQ5NmWmJRCqep1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxhG-00Ffiz-2d;
	Tue, 25 Nov 2025 18:23:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 128/145] smb: server: let smb_direct_post_send_data() return data_length
Date: Tue, 25 Nov 2025 18:56:14 +0100
Message-ID: <28dc497b8bb277da6ae603e858969f9bd36959b4.1764091285.git.metze@samba.org>
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

This make it easier moving to common code shared with the client.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index f9913321389b..0a352e56ccf7 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -761,7 +761,7 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	ret = post_sendmsg(sc, send_ctx, msg);
 	if (ret)
 		goto err;
-	return 0;
+	return data_length;
 err:
 	smbdirect_connection_free_send_io(msg);
 alloc_failed:
@@ -813,7 +813,7 @@ static int smb_direct_send_iter(struct smbdirect_socket *sc,
 						&send_ctx,
 						iter,
 						iov_iter_count(iter));
-		if (unlikely(ret)) {
+		if (unlikely(ret < 0)) {
 			error = ret;
 			break;
 		}
-- 
2.43.0

