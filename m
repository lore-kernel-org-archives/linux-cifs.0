Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0FC238C08
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744257; cv=none; b=eClNO/J9Y9vZjaXhIxu/WDQgu2tpcmCtoUzJ9wRlbPze+bOW1X9EoArKg+QIXxCagyPlrd8liq62a9XDrqI0++R1M1ifA4jnlnE1IHt44Xf0ROwoUrUC7cLUAIML53p+HUovLDTKmypmAl0tKzs9hzX+sZUS54LJ0wElmjBkMCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744257; c=relaxed/simple;
	bh=lgW5St5tGv+rAUDED1cDtRQDKpwgG0/9N0B2JGaiWmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWF5ICOwFqZ/wctr6Gz0j2N9Y+jbTLt6PWLQZorssN0xzmahsUqUC8VW3452yaGrBUWgQDTPC50U8OnnrShAwWzORrw2+SVepwRmB7Z8VMBrQ4dWdqwc84B1h+K3E1fh9sDm6Ou6STrfM4/Tj6oNHfqUsJzuBeZ64INr06hg9jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=q3MPkuyj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="q3MPkuyj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=raVU44fq84Z1bOescz1ZncJMleud/FRovMPWrjhHHFQ=; b=q3MPkuyjJiwm0b8I6aT3Ps+2iC
	w+Kjyy5H90pxm9doAZNJlh/aIh9fbPGtWIdOk1hyPY1J2dKMuXeW4FPmUiBFj7Xfk6XJ+XiKG59hZ
	+lXYJP8ihJI4b5nOLgvz7Qisbue4hBzegFuDoMVMZMHzfc3NRDh0FkgQLYcGH9ZVQoDCan+HsMgz/
	POp0JtE4L0ugqmjFKnDltvJFAaOT0eqReo8vcNzVHNWO1wOHKNJQ6NgasvG4ah4Q3VN8ZoHMpOwXZ
	HeAtixCmmYEEp7PX6CgF4CmQIayl5m8JjFFKqqlmuFUeKZtcdOOVJXWUywyDP58/EOMCgxah3Xb2u
	zpQ+dUqACw6o2zAAQ0kA6lnplVf3yBYOzl/OiETglFHWhns9xDSNiq64mfMR8h9VfQu9BAkK9QANn
	ohjyBkCIGbBX38qmvJbwggBwC95/P4yw6dHwqNRiefoKjEU3EoN7IozqeCt4H+xwoP4VJaYTKVZ8r
	b+MwCXPlfqvc3dW3Zgm6o0Qq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE69s-00BbSE-1Z;
	Wed, 29 Oct 2025 13:24:12 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 017/127] smb: smbdirect: introduce smbdirect_frwr_is_supported()
Date: Wed, 29 Oct 2025 14:19:55 +0100
Message-ID: <43ac610b77dfac6b8244dd65a293d382ff069cd9.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
 fs/smb/common/smbdirect/smbdirect_connection.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 8d00a456c513..e90aa3b72b44 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -11,6 +11,22 @@ static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc
 static void smbdirect_connection_disconnect_work(struct work_struct *work);
 static void smbdirect_connection_idle_timer_work(struct work_struct *work);
 
+__maybe_unused /* this is temporary while this file is included in orders */
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
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 					    const struct smbdirect_socket_parameters *sp,
-- 
2.43.0

