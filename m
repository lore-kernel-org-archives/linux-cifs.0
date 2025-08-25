Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C05822FF37
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155722; cv=none; b=r9+Q7eP21xeiQmvSIb+P5Ve/ZXuQeFWYYAnGM/wGjyiUV7rwSm9dXp+L1U/ZXgmhRQgByRjxCmJkjR/gCzEundFjiDLKmtem9anQzo45uC2fiiDYpFt5fI0q+nl3YowrMasx9J/9Q0gSsWmZvA9mq5tMztf1CuFxGrQ8qxsQwxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155722; c=relaxed/simple;
	bh=/Mgz6ERCKHlrlEkC3+gkJ0PF8glHudAj8Ly0tcG5zG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWThr5mVKM79v5+ueNMgLTUEWImr0hwh+hmqinPGt8ZRI4vMULHaBQMdqWMePPCfXfPLLMv8VTTINB+jEFs43foFnfWjWhUBaFDHoRbrTfb/wzbaw053TPw/GwFSnBnRvgAWIyBD5HFLEXv2PsodtiNkJHbkeF33jEHwll+DCfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OVMcrZXZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OVMcrZXZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nt/U48rlsaj4yyafVC5yjaXpCNOQtL6TgIFDba0GTSI=; b=OVMcrZXZC6KppjROETnbJBdwIi
	lMV71Udk7hh7mkwn1kBxpWzPPh4X8fK/4rzU4Go14HUhXULEa04ExbiiCERhYLZ/oJ7jyOu1bi/6v
	m/3PtLTg1uNpo7d+HJy+2WvrULmNl22N/V4B01PVJBPq3o77b9s4zWAtPl9/lOSCmVfDQ/NjxQnnz
	iQrKJTA26QDYcetJcUG19DmVYQiTXbiWM1Yz4uVpHMR7365IcmM0nLo6vcz26Kc0c0/V8pIgA9bQL
	Zo1x2DvHHEtJO92O484Z0cdvGaQTQ5tAXyH88c2yTV88j8D1twZjcd9S1P7EDDqn380q7ecdH3NW9
	P6YmSd6LeC2HJZtmesryzEhXh9mzSUTaspfvgAAIFO2qm+sbeR6IcSzLjPiaAougfAWDJqAlVDzM5
	Ovp5vFHPoeabw+B3XwWEX/YYJJw7E9dASLUn86JOt9hLRw4eHmjgeBicVcIuU6wLotyam3Kb5ORvt
	4/ZHucxHeZgCxoy16b3cBHYa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeKD-000nFj-0f;
	Mon, 25 Aug 2025 21:01:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 121/142] smb: server: pass struct smbdirect_socket to smb_direct_cm_handler()
Date: Mon, 25 Aug 2025 22:41:22 +0200
Message-ID: <1cd160391263cc4760faa4350202666b62dfc37c.1756139607.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 8b6de0a6bf9d..bcfe0e62714c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -333,7 +333,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	sp->keepalive_timeout_msec = SMB_DIRECT_KEEPALIVE_RECV_TIMEOUT * 1000;
 
 	sc->rdma.cm_id = cm_id;
-	cm_id->context = t;
+	cm_id->context = sc;
 
 	sc->ib.dev = sc->rdma.cm_id->device;
 
@@ -1537,8 +1537,7 @@ static void smb_direct_shutdown(struct ksmbd_transport *t)
 static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 				 struct rdma_cm_event *event)
 {
-	struct smb_direct_transport *t = cm_id->context;
-	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket *sc = cm_id->context;
 
 	ksmbd_debug(RDMA, "RDMA CM event. cm_id=%p event=%s (%d)\n",
 		    cm_id, rdma_event_msg(event->event), event->event);
-- 
2.43.0

