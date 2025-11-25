Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C67732ED44
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094190; cv=none; b=mypMyUcme0MiDChx6IFRrcRPz0zU94IkHqOZGZaIn0Zg9iepADEgFJjjqk3e1CSf+KufVyXHu77avkuKtoyeHSqScVKJ57N/1BA8EJloT7qcCjMkrljpYFaqK0ZFjFdsh77UPuk4SM10OPgAMPkSQpQMYkG4uBiK/3Pwc32IU8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094190; c=relaxed/simple;
	bh=qHiCweJoRdotnfRGhW2awSVwKHPlxP+4+rsZQ3W/kEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUyd9L5isz9s9hXBh61LNQlhGY2uqCIq647c07tmSh5tzUFVDiIX2tSJAyld4gXPYdW9aC13mZ0PHmFs/LlBQy6nDlxjNPyjmx8IDZVGztyLd3Y/xGGZJn/Zu698n7I96PwkgtOY+Dpyzeyehch6erF53039T8S3u8Gz/JHkHwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=T30kIqTS; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="T30kIqTS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4ySx//XRW96up5XGMXWNXYU6ttMCmnLsJOJR7Tbrnn8=; b=T30kIqTSDACU9vT7NpwSQUK2d9
	sXR5SPpCOhWzIw6Q7FiQvgEJipa1Mj9sSMpcHtsk50Uf1OrJq5wf3ros87zuW1oWgfOoTFuHlMk9M
	PG0BokGyj91KFoFfyX6cPWLGtBUGK5Hi1zmFoPo1CGTV9lyKVAiGa4rZOzWmDvCYXwJwSnNy8JXp/
	O94OGi0vzdPj2fnrep8irEE+E/58apMFEB64FgP2Q/6BvM8V706I8E+lwEOnTkBm7G9951wqQ+7Ho
	Hk7/6kL+zyXracCNf6DeMBiBdKfzXiGLtQKxO0ADPT/DwHKzrQRZqP3V/F7rnvFqsGjpa/S5AL/4c
	IdOVFbz4WnjYniGqlAiYyiuQLolX51vlweq7W+hOfZC/OMwtC/+dEPUjtF7YphZgMogLekVIq+Rnj
	u10z3E0p4QMO+IsMCcckLREty7KF3VtBdHIdIs48qk0w7MqQwfUHwERQF38LdyojMWy4ziVcDq2ku
	3iSG012oih1PyUKfMF49CeQ1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxQy-00Fdmd-1d;
	Tue, 25 Nov 2025 18:06:37 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 078/145] smb: client: initialize recv_io->cqe.done = recv_done just once
Date: Tue, 25 Nov 2025 18:55:24 +0100
Message-ID: <f7cd803cb8e93c86582bd97529942765b911e04f.1764091285.git.metze@samba.org>
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

smbdirect_recv_io structures are pre-allocated so we can set the
callback function just once.

This will make it easy to move smbd_post_recv() to common code
soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 04ab25899ab8..9e3557476b4c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1080,8 +1080,6 @@ static int smbd_post_recv(
 	response->sge.length = sp->max_recv_size;
 	response->sge.lkey = sc->ib.pd->local_dma_lkey;
 
-	response->cqe.done = recv_done;
-
 	recv_wr.wr_cqe = &response->cqe;
 	recv_wr.next = NULL;
 	recv_wr.sg_list = &response->sge;
@@ -1289,6 +1287,7 @@ static struct smbd_connection *_smbd_get_connection(
 	__be32 ird_ord_hdr[2];
 	char wq_name[80];
 	struct workqueue_struct *workqueue;
+	struct smbdirect_recv_io *recv_io;
 
 	/*
 	 * Create the initial parameters
@@ -1393,6 +1392,9 @@ static struct smbd_connection *_smbd_get_connection(
 		goto allocate_cache_failed;
 	}
 
+	list_for_each_entry(recv_io, &sc->recv_io.free.list, list)
+		recv_io->cqe.done = recv_done;
+
 	INIT_WORK(&sc->idle.immediate_work, send_immediate_empty_message);
 	/*
 	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
-- 
2.43.0

