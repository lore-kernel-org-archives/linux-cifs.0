Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D44331219
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 19:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025093; cv=none; b=goAThY8kg1KT56GoRT2ld+CmZVCSTZYinUGMMWGw4BJaWIEk6To4t0jKRRLkLcEGbZOHl/TzXQtzDneN8ISPDDOTJzjHX8XfIOttRiiaZroUJHzgw+x5iz2vdxyiT6474WoTUn12fUILW3Lum1T0p07rX/p7GC7z6pUW5Uc2Jrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025093; c=relaxed/simple;
	bh=cn43tldcayDrHeaEiVqY3frCb7CXinqy4odIR3qvMQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1Rao2RMZWz91nx9PLV/9pY2TjROhIAvw01mVnYhTuwQT4LvUMy4Zzw7WiILh8zFr84unmC10a7ADudLG4B6/ZqyQ3wCw81Rm6cP6Lt2FJNQO4Ha1GevjxWjlKzhJfF08QK+WpWEXqhXBOnedraxanHoGT445ArP4pccP4/o7rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dsk79J8G; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dsk79J8G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=LkNV+fwn2+mpfN9JGqtmycp7cmtK8WUq69/EqDLvDQo=; b=dsk79J8G/6GDrOt6R0gR8boU5X
	ZFrHqhrQRwG4EmxezCiOJlsrVadVqgUaXFsT/w4hGfJYyCqC0PmgdWQz4I/n8Kbypy30mlbXQkyU1
	sG53m5Ip5U/Mo1s5sJYNQmq6UKJN3yTUxyE4GiMj9YQStsWVJ/8gpdCIUdNk5CUKPGqPkdjvMUGhU
	h8Ep/+3Q/u0GXdvDkYWqJFYOfc2P7eNDSV3lqnjXISkyFa3em+EhMKHqKXVHguYUQgmes+6Is8GTz
	QOVYm5RmGsjzH07xCMjhbv0IBFzW5KnoObeEWEgdKyF/xdK5f2+dTvPnOKl7gjQwID8nU0FJeswS4
	6yErvxAbtY36bYhZ9s3LMCs2xTizpVieGb56DvcoqEhS5G5CZVuwm14mGDJUwulyqBhk1bqvWcoSk
	Z/zyu7YwJ/lUU3Md04827cJejgCY21qOlF8IeBdc9P6f59Rjb6reADxu1f/m5KKjl9wXjVrpl7RqR
	oHNtLZi40Ogrt3S+AMl201zP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieEh-00000001e08-3ZMS;
	Wed, 21 Jan 2026 19:51:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 07/19] smb: server: let send_done handle a completion without IB_SEND_SIGNALED
Date: Wed, 21 Jan 2026 20:50:17 +0100
Message-ID: <62cddd343ea2a283c1a6983cdfaaff25d13a5538.1769024269.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769024269.git.metze@samba.org>
References: <cover.1769024269.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With smbdirect_send_batch processing we likely have requests without
IB_SEND_SIGNALED, which will be destroyed in the final request
that has IB_SEND_SIGNALED set.

If the connection is broken all requests are signaled
even without explicit IB_SEND_SIGNALED.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 6c063c05a6ed..541e51a7c0ce 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1059,6 +1059,31 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		    ib_wc_status_msg(wc->status), wc->status,
 		    wc->opcode);
 
+	if (unlikely(!(sendmsg->wr.send_flags & IB_SEND_SIGNALED))) {
+		/*
+		 * This happens when smbdirect_send_io is a sibling
+		 * before the final message, it is signaled on
+		 * error anyway, so we need to skip
+		 * smbdirect_connection_free_send_io here,
+		 * otherwise is will destroy the memory
+		 * of the siblings too, which will cause
+		 * use after free problems for the others
+		 * triggered from ib_drain_qp().
+		 */
+		if (wc->status != IB_WC_SUCCESS)
+			goto skip_free;
+
+		/*
+		 * This should not happen!
+		 * But we better just close the
+		 * connection...
+		 */
+		pr_err("unexpected send completion wc->status=%s (%d) wc->opcode=%d\n",
+		       ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+		smb_direct_disconnect_rdma_connection(sc);
+		return;
+	}
+
 	/*
 	 * Free possible siblings and then the main send_io
 	 */
@@ -1072,6 +1097,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
+skip_free:
 		pr_err("Send error. status='%s (%d)', opcode=%d\n",
 		       ib_wc_status_msg(wc->status), wc->status,
 		       wc->opcode);
-- 
2.43.0

