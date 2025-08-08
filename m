Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0081283144
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754666918; cv=none; b=g3B5lSzcLNdalP/XefiVvVT08+/ZNypIIrTx/EXvkfsHnYTDlbjqbijLBOfyTgAgUfr2H93Shp6a2wv08tf+xF5cHi1t9niIXpBBKy7JY9hP8U1ErwQlZ1hcPbd7VABbJxLgpewU82dqeiTTy0SFB/kitO89GdnT0v12rki0wv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754666918; c=relaxed/simple;
	bh=5LlpdUmnxk/uGUWUd/gnUpN4ZsJ7iM0QdPGEbbkkOlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlhnMdcQE49ntTg4DPVdhQsp+vZDoYoAzzGQcw9y0DxEzfFHYGSuZ3bstN1MxPL+ebx8Cq9Q54mO632w7XKC98KM1WbzttzxEjKkRzvnrzAA0bbvYODbwdK1R/+t1bt6KfEOw2MnLOjFZer1WshZ8qpm/znjIW8LCqgHYZsVJxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XRh8V5vC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XRh8V5vC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ajfeVZwkk1jxAUTyHLfKrwIbk+GwICQLIc8hekLdP/c=; b=XRh8V5vC5EBIrU/oAx9aOMQao8
	++3qhioNJ+l4Qhn5QkajiaywESWgyZoxvr9sto3PzJT6a0VxETpggJb0zaVtysf330L7pIbT/nTAr
	cPPmkBfNHz5ES2LVxTg1gaXh3IuX9dYl+HCQgSAnkGNer3e3lctotxjtcby+DvHlKckoDqP0DGynh
	/2cRpcyAG5nkL9boWGYv2grl1njG7XOK6Odn0bk7X40zrFOhaxAJQif/7Jz1Pn9FdejKckmeRkuDh
	8+hYFCKRAZzieTeaHocZIdaJUgjlVlsf+s5oiWvaYQ5pEVVAMjCNZz9xAw8ttYXqulGj1L2tjJR24
	s5h2cULyfyNLNQ6kPWn3f1VIoSTDFfQ2HEiVcCx8dIKeKQrm95h02FK2AUpKO2bxxxoAwzcQwS3+T
	S9K1r5LkuIDv0bg+QnI4sKPrby3+zfQsoirNWEAbyHW2E21+1TM3YH3xH8akn9JpP6GRQ8/6ubDco
	/ZslefODOeUqAb3Ym2aYs9nt;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukP1G-001pON-2E;
	Fri, 08 Aug 2025 15:28:34 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 3/9] smb: client: don't call init_waitqueue_head(&info->conn_wait) twice in _smbd_get_connection
Date: Fri,  8 Aug 2025 17:28:01 +0200
Message-ID: <7c750a8db281c6d44c6785b15c7172b2bf13c26d.1754666549.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754666549.git.metze@samba.org>
References: <cover.1754666549.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is already called long before we may hit this cleanup code path.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 8ed4ab6f1d3a..c819cc6dcc4f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1716,7 +1716,6 @@ static struct smbd_connection *_smbd_get_connection(
 	cancel_delayed_work_sync(&info->idle_timer_work);
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-	init_waitqueue_head(&info->conn_wait);
 	rdma_disconnect(sc->rdma.cm_id);
 	wait_event(info->conn_wait,
 		sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
-- 
2.43.0

