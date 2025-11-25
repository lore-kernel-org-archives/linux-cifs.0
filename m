Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED5832B9AF
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093525; cv=none; b=Fk01oYZ7TerAd6zw0gyUcZLRyYOceswK6tmc68YZAW/7jcljICAINpgbi+2vx1Ved6+zPlwhjy5bf9ut43GJ6zmU3Sn/O5DaPQythJlCZsawALRJGbzi5nNs68hbyJ7yX4ZkhOjLNIUDwRwYW4hbavahLnwZ6pAub12ermHZT5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093525; c=relaxed/simple;
	bh=czwyDNYzie7DjNKB0MqkSzU23ex1huz0mNmH1cd9XXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql2lYG+zM9cp3msTNgbuixpDO4AgrJLglos9Qt9nrsBBO/bDfYdLoFRq5+OJbSi57IPjJki7xD9N7ncQkBVNZv4tgJqDEfieiPJcuEEIyMjyUScYVU3JnO4qkyaJK7N4WdCpXV8cNjcJVi9so3UsZOOTO5tNPZLsSyq4twiYyps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=rl0Fn6UX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="rl0Fn6UX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/hBu2ti3SKIvUnNd5nMLk5GywAqbNJsZRr1OcWEr/7g=; b=rl0Fn6UX+b9VSV2B5Slva1nZU6
	qS9HaLcJix2wpCWsEciTZbPwKQdjyZjo7rWHxpV3bPo/Tf6SqM/9BE1qgeAQkHPYAMWm95Jmnkixj
	6EgtnQHnhAEzpopKAIuUidfSM0GJHNszpqA1zLBtDmsgx/LrobsZR3u2D8bWDadvevHlxr5wFAw1l
	eYOnbC+Byi+k8P5nDvoCVSFLrdzV6tMEjpQ6Zz/gB4rGi0P7SBKnIFGviieA6VG8OihwvyXcjK/f0
	3aQgYlxXCIBsRYCZfQcjcuPRYzWvvHisxn9yciPXNlw7mSQHGCLvl6dcFmL9jyb+3MbiQ8SChoYyp
	j74m6nMc7nY3fWeAN62o6oIIz1VT7yYzXgkWQoLlglQntZVoW0Ofqg7XS/ING5Tj33MDGwQ6QdeL7
	6a4sqKC3TSdWhTItefuCBKvJF3UrD/2Gq1lFrrJK1uf76hjWOjrHqkHNH/TAHkFEJZL5Ew+ecZ+Zg
	7XvUMHv9ZEsWE1gSwkKJEJsT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxJH-00Fcn2-1o;
	Tue, 25 Nov 2025 17:58:40 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 020/145] smb: smbdirect: introduce smbdirect_frwr_is_supported()
Date: Tue, 25 Nov 2025 18:54:26 +0100
Message-ID: <52ba53092030ce29c102e80b089c45d80bd6ee79.1764091285.git.metze@samba.org>
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

This will replace frwr_is_supported() on the client and
rdma_frwr_is_supported() on the server.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index cd7192584820..c064cbcb6b5c 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -6,6 +6,22 @@
 
 #include "smbdirect_internal.h"
 
+__maybe_unused /* this is temporary while this file is included in others */
+static bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
+{
+	/*
+	 * Test if FRWR (Fast Registration Work Requests) is supported on the
+	 * device This implementation requires FRWR on RDMA read/write return
+	 * value: true if it is supported
+	 */
+
+	if (!(attrs->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS))
+		return false;
+	if (attrs->max_fast_reg_page_list_len == 0)
+		return false;
+	return true;
+}
+
 static void smbdirect_socket_cleanup_work(struct work_struct *work);
 
 __maybe_unused /* this is temporary while this file is included in others */
-- 
2.43.0

