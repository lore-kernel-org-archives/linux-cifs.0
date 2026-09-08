Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4C4568550
	for <linux-cifs@vger.kernel.org>; Tue,  8 Sep 2026 15:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788882330; cv=none; b=jfuCeODE4xDkY6hbhuezFxqJEgHZZUSrJ331g1sdqnapFNRsAlww9A58EPjbqFhebfv15h0cYrAxtSQRIXo9EIM3OIp/Wvk36JmjAg5juM4bMIw6fT2hCMfKAfAbLL2RAOz3q8VrT5lWV1gJvdEqrifCg4xcsajwOSAGFSuvAvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788882330; c=relaxed/simple;
	bh=dFKB6M5FKojpRsZt+gYTvbAvCaAVxlex6m2PzwZrubI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6nBfd0yl1BmVLJnwYM/lLCBltIg5QV/aekLwUX0hIceFR9wTZ3EKEU5U9UR/mxqYqJcF5bKnsG/DEg7Ub9kFFQVjGvvry4Wyv8LVu3AuI5vNMZwkEFnzco6DGnsx2ixTjA1BYeVXoB1F9fhc/IxwLC4ug1M5bMqSSDGw5Z/8wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2xelVBp; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2xelVBp"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-90ccbed6edcso72769166d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 08 Sep 2026 08:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788882327; x=1789487127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J2h+q2CPO6RUOr1bTBHq2Gab7Sy0CjwyXjSNQkF67CI=;
        b=U2xelVBpPfi+FR92iBF3ElR1ZsNVeRFFgFWo1aOfKXbt0F8xE34wDo1yih0tOF5/25
         8munbgqTHw38BTWjhYu8S3kjEJ8gkFZ/x9ARycZLwygXx1H9rUYawxaYMuijLjuWhap+
         VdwvZE2VCvoCAH1VJ7e81R7w2owF27YO58s1pzalWxc76qOPAA2FWPUrvzE4x+dBdKtl
         m6IXrx29mgpgfmtSbawijFdfjwfrz9HFBC2uExiDrLj7hk3SliZhP12JngjIG2v6rOfC
         hgtViL/1wauXBHDxVx5ukxGWdOQy1lzOGPMnzBZpFysGFL76arx3NjtX2tPr5V74WMaW
         Z5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788882327; x=1789487127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J2h+q2CPO6RUOr1bTBHq2Gab7Sy0CjwyXjSNQkF67CI=;
        b=kwkERH1ce6gRAEbK9g8rVPDjeER49f8S84NUl8BrpzdhiJWERRJ36pWgPEnBdT9VBu
         rcRHApsvqZzp/qHalkZKQ5nTCsGf89XtYN3j82JwvWJmwCINW7wKYzEN0ictuCqvMSWF
         QqawVNxliyrgTRShJ6y/R747qkjVtsLj1mGDAj9tNyFkqM2HFHDuct6vPoIZeRPgkyff
         aCmV40SCyoXlBTCW1odpuxbOBV/dFYSiHJeywrsefDN95wKfW7L75Vi5hzixSyWMpVDz
         GA6PLybCML2lW4G49a+S16hGKgHPpKPUddsIWvFt7Rp7WkZTPSCGf7RPWROFLZodZvjz
         3Hvw==
X-Forwarded-Encrypted: i=1; AKwUvBxvsdGcmgEpkeW6QioT36acE62yfxsrPAzdIa2++z7Z+nEqxNf2VbX7Nem4lMQ0HKYku0Y8VaU5Rojs@vger.kernel.org
X-Gm-Message-State: AFuF++m9km1Nr94MhR8P12y0Ce2TIIcPPqKR4QasndnuwREv32NdfqYX
	Io1TwZbJs/Kpa2VxcU/envABEsphTmdmkxwiEC+W7Msk5zScZusQOY6BtyLL87RIUis=
X-Gm-Gg: AYBFou3AU3PG8LZDeG3xkLA7ioxaOfaeD0fbV2wGN+01LR66vMohdtn0+piiwj0sZic
	pB9efi/tXV4oYMEIdNlfm/40SdiTKiZdnasmnLTmErLAru4WiF31z7Wo7fn77yhw/uzv4ov9EFY
	/BXfrfUMkXOUSfo1wsFZJxyxS4788yyOgnr9DBcOh+Z4hYW7N8epc7a/XB4v+BI7LYQPX1lXTXQ
	Y512rOdpZY+QuKpSKbuNoSPkT+2WzXQRkEBcmzYzry25uvgt6hfz2DtIBkk2Cq2xOqgwFdkJRUV
	hWxbI2fZ98+Zw06ZrLKvr9UBk8KEUfeJkhsuoVu/9mnZ0BrNn3h5l328AgEVe5ZT7dwvnyEBG+h
	6komHwnzqYqPgqrFHM3AF7fVTD986DETj9lNHQXGxAnXuD5YjvTXSvh5J0fvlbn3MT+WGsZ4/ZH
	e7OhAp9Osa2r6fuQvx2NMxLADrH29JX9PLWQ4VK6sATmQ0PJH9+5Dv6rHmgPZBr3FeEdp4xovKW
	FtWCnfOUrV1auIJklMdeCVrDgZ0i6xFbF5Bs0g/CQLa6mN6Ui6fwJW0yTh51p8=
X-Received: by 2002:a05:6214:202b:b0:910:345b:4dea with SMTP id 6a1803df08f44-9103f086aa0mr381765736d6.36.1788882325436;
        Tue, 08 Sep 2026 08:45:25 -0700 (PDT)
Received: from Ammar-PC-Fedora.tail72f32.ts.net ([2600:1702:7bd1:29f:8000::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104049d30asm120779386d6.0.2026.09.08.08.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:45:24 -0700 (PDT)
From: Ammar Ratnani <ammrat13@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: Ammar Ratnani <ammrat13@gmail.com>,
	Ammar Ratnani <aratnani@nvidia.com>,
	Kechen Lu <kechenl@nvidia.com>,
	Mithun Maragiri <mmaragiri@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Stefan Metzmacher <metze@samba.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH 1/2] infiniband: force disconnect if DREP and DREQ fail
Date: Tue,  8 Sep 2026 08:44:26 -0700
Message-ID: <20260908154454.10966-2-ammrat13@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908154454.10966-1-ammrat13@gmail.com>
References: <20260908154454.10966-1-ammrat13@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we call `rdma_disconnect`, it's possible that we fail to send both
a DREQ and a DREP. In that case, we currently either do nothing or move
into the `IB_CM_TIMEWAIT` state. Either way, we remain in the
`RDMA_CM_CONNECT` state. Anyone waiting for us to disconnect hangs.

Instead, while we're connected, when we call `rdma_disconnect`, and fail
to send both a DREQ and a DREP, mark the connection as disconnected.
Call the upper layer's handler for the disconnect, and destroy the
connection if instructed.

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ammar Ratnani <ammrat13@gmail.com>
---
 drivers/infiniband/core/cma.c | 39 +++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 73170b15fc3d..1f1a8b4e160a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4823,6 +4823,34 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 }
 EXPORT_SYMBOL(rdma_reject);
 
+/*
+ * Called from rdma_disconnect() when we know we're not receiving a callback.
+ * Emulate what that callback (in cma_ib_handler()) would have done.
+ *
+ * NOTE: Despite the name, this function will only actually disconnect when
+ * we're in the RDMA_CM_CONNECT state. Else, it does nothing.
+ */
+static int cma_force_disconnect(struct rdma_id_private *id_priv)
+{
+	struct cma_work *work;
+
+	work = kzalloc_obj(*work);
+	if (!work)
+		return -ENOMEM;
+
+	INIT_WORK(&work->work, cma_work_handler);
+	work->old_state = RDMA_CM_CONNECT;
+	work->new_state = RDMA_CM_DISCONNECT;
+	work->event.event = RDMA_CM_EVENT_DISCONNECTED;
+	work->event.status = -ECONNABORTED;
+
+	cma_id_get(id_priv);
+	work->id = id_priv;
+
+	queue_work(cma_wq, &work->work);
+	return 0;
+}
+
 int rdma_disconnect(struct rdma_cm_id *id)
 {
 	struct rdma_id_private *id_priv;
@@ -4838,12 +4866,15 @@ int rdma_disconnect(struct rdma_cm_id *id)
 			goto out;
 		/* Initiate or respond to a disconnect. */
 		trace_cm_disconnect(id_priv);
-		if (ib_send_cm_dreq(id_priv->cm_id.ib, NULL, 0)) {
-			if (!ib_send_cm_drep(id_priv->cm_id.ib, NULL, 0))
-				trace_cm_sent_drep(id_priv);
-		} else {
+		if (!ib_send_cm_dreq(id_priv->cm_id.ib, NULL, 0)) {
 			trace_cm_sent_dreq(id_priv);
+			goto out;
+		}
+		if (!ib_send_cm_drep(id_priv->cm_id.ib, NULL, 0)) {
+			trace_cm_sent_drep(id_priv);
+			goto out;
 		}
+		ret = cma_force_disconnect(id_priv);
 	} else if (rdma_cap_iw_cm(id->device, id->port_num)) {
 		ret = iw_cm_disconnect(id_priv->cm_id.iw, 0);
 	} else
-- 
2.55.0

