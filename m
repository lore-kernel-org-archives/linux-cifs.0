Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9F31D90DD;
	Wed,  1 Oct 2025 19:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759346738; cv=none; b=bIUJ+vz+uul4LMw0dywCyvhIyAjBEc+fxeWKy/zLsLk4oicuO6OIg+oKfveJa9Dj+3yv9ndI4bcmqQO10Il+Ba898Tw+JybuFpyFZYfg+yHn6n6ekdRkI/nvIRXcwH9Dau4fqXgD85bK3HxWmDRiX1sa0dQLH4G15n1o2qwq4WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759346738; c=relaxed/simple;
	bh=E7cTOOalQ1Hgy8lDpdpI+zGR+MuYVo6NmJ1DkBcBmnk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=nlG+RaIUmxnqEHu9D3+9UOOPoQn0V7bdUZV4RwwuZvkSCb2BArS7WNSDNXpqpWjKfGupLms90Ivy6yVmem4FwD24NhVjyETD/mbcNfpyOipw/9JiZu3QNos2LkH/Fnyy4dtWlyPH34AcJPW7G1ZKcUSRvhtllYJtgbqckRlA9gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=BFbXjmx3; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="BFbXjmx3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759346716; x=1759951516; i=markus.elfring@web.de;
	bh=L6RoqV/E5xic5YvrRScLm9fOIIwxmYczXxQqYHqd28k=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=BFbXjmx3qq90uBZ1rH2MmUanW3kdtSBZI8C/+Vn2k7B2AgbUtDTcFD52TAPVnong
	 dyyUglp65xadP9oxxSu75C2Gx+7O1At5k/eDJtR5qIk6QIkTZg1LHn8ohmKakMTGi
	 8NV3WMtwmmZIEZ80+a4UXokPSvK8xgDx47nISbSaZt+UKOes31IUCf/QsAtcsAD2e
	 uyvQxQ+DnGstwG0W28CcqkD8j3Jc8gf+B1Age8YWvueyamuWiYy+7J7QatYYIhZcU
	 KYImD9ES8P7tMqfEnC+NHOnW1bAq6w/QCtE/PcN8lmgEy6WZj4EJqnTaJKK1ng0lV
	 9iZdbGQ5QH6yXwj3Bw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.174]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MIya8-1ukryA3Cby-00XFW2; Wed, 01
 Oct 2025 21:25:16 +0200
Message-ID: <7f956b3b-853b-4150-b2e0-ccd430adf9ac@web.de>
Date: Wed, 1 Oct 2025 21:25:15 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Stefan Metzmacher <metze@samba.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: server: Use common error handling code in
 smb_direct_rdma_xmit()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:aQQsLX+Zz2WGBpgQ2OjdkzkoxweEph4qNgycVEu5Z4dmOX96Q6H
 k/UalmGDGE6UzFJhqEf8qCXJ7VIauM4bYSwfEdAhx5PxHU/zR75USTDC2SA6GeMmL4kXwsp
 WYrO2P/ht+DKJP3yvQ8xvuYLlvG/DNlJQa05ShhPfzNGIBW9amNobXgGGkTbCVV6C8bv78R
 lr6Wc9RqJj3D2qU/ObaLg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tQ7U+SI3I+k=;8QVdrK815MWxGr7mo9E+OkIxS8A
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 1 Oct 2025 21:09:00 +0200

Add two jump targets so that a bit of exception handling can be better
reused at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/server/transport_rdma.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma=
.c
index b3077766d6ec..a201c5871a77 100644
=2D-- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1574,18 +1574,14 @@ static int smb_direct_rdma_xmit(struct smb_direct_=
transport *t,
 					     get_buf_page_count(desc_buf, desc_buf_len),
 					     msg->sg_list, SG_CHUNK_SIZE);
 		if (ret) {
-			kfree(msg);
 			ret =3D -ENOMEM;
-			goto out;
+			goto free_msg;
 		}
=20
 		ret =3D get_sg_list(desc_buf, desc_buf_len,
 				  msg->sgt.sgl, msg->sgt.orig_nents);
-		if (ret < 0) {
-			sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
-			kfree(msg);
-			goto out;
-		}
+		if (ret < 0)
+			goto free_table;
=20
 		ret =3D rdma_rw_ctx_init(&msg->rdma_ctx, sc->ib.qp, sc->ib.qp->port,
 				       msg->sgt.sgl,
@@ -1596,9 +1592,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_tr=
ansport *t,
 				       is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
 		if (ret < 0) {
 			pr_err("failed to init rdma_rw_ctx: %d\n", ret);
-			sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
-			kfree(msg);
-			goto out;
+			goto free_table;
 		}
=20
 		list_add_tail(&msg->list, &msg_list);
@@ -1630,6 +1624,12 @@ static int smb_direct_rdma_xmit(struct smb_direct_t=
ransport *t,
 	atomic_add(credits_needed, &sc->rw_io.credits.count);
 	wake_up(&sc->rw_io.credits.wait_queue);
 	return ret;
+
+free_table:
+	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+free_msg:
+	kfree(msg);
+	goto out;
 }
=20
 static int smb_direct_rdma_write(struct ksmbd_transport *t,
=2D-=20
2.51.0

