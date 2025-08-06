Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D88029CB5A
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501802; cv=none; b=GRjVrnNXtL0jrgkCyjdXnYk1e7OnoenWbwqb8xsw23UUS6Z+dQA5x0hDhECBQSGMEzVj7Ie/f6NZ7V0bG66kqFP3WmA2O0kPkOYCxaW9cupaCYeA7r4RvPF0qmNEJuhOn2Bb8+tbQD1Hh3yxMvMqwlDku3vGTny05SuMp8GVIG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501802; c=relaxed/simple;
	bh=kidG9lOt6cXeEUmRT9x3OWZYnSHrnckM3KQis1Ytx+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/eddI2mBARHA9f1LgLZUlaHPdFJkZHYBK2KlXI45qpa0SvZIfSgmhLatwc/ijQicyzdOsAo/yy5LHK6DMF9aMd8erlmYq5KS9LivX7G9C3HiaaUgGfS8Rk4XUh71DBB1aOQD4d9JICRUgXm65zxz52wG5skMi7Cmq5x+yBtOl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=sJddu1gL; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="sJddu1gL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=UfzmhPhhjoSMyij4Eq8vv0QdU6nxViE8ga8RFg9nzd4=; b=sJddu1gLIHsCoyGVK4Uj8XdSVN
	20OV5H4w/2UXwSMhfbnbMB+Ck3CHwODD15iiUdc5KAhNFfrovnOolkuchuICCColsba4o9s4X61Nd
	didgeT74iEd6TK6L+g5ls6UARQpHaaRiHvbX1SgrXZ5uP5EPnJPh6nodmqiCIsqUumoc6NWoHg7pQ
	6DT3zmjWr/HIdIy1Q9dfz6IUkpeOKhLR/+pKYZlq7wlTvewToRMdU6AFicvQSD7w4ZhTGORonI5oJ
	BaqWp/M4Fyge4zF7eDTHLuXosROzVzzP33w/xiJj6a+AWCEk/WMeV/QmX2EyLdFFcTFOM5fKOc5fQ
	Baj5cGVPVkym2qa5cI7w33O1ZTw099yDRp/T1RibDg9fabB2IJoV+x6iui3DeNySOFEJETLK/feSZ
	DVULpVWrx4n9r56aDz8hn3awjYzWarbm/tfwZ3clevJUEvh925n1KTK6Diz4TTS4I1CVNY2rJhSb/
	ZFCDaAIRCs/jWpc0qgIhfRjB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji44-001OXT-2Y;
	Wed, 06 Aug 2025 17:36:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 03/18] smb: client: make use of SMBDIRECT_RECV_IO_MAX_SGE
Date: Wed,  6 Aug 2025 19:35:49 +0200
Message-ID: <8373b8b0d69e7256b5d34cf7c1451e0dc54dfae6.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754501401.git.metze@samba.org>
References: <cover.1754501401.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 4 ++--
 fs/smb/client/smbdirect.h | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 5217a8122a94..5d1fa83583f6 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1563,7 +1563,7 @@ static struct smbd_connection *_smbd_get_connection(
 	sp->keepalive_interval_msec = smbd_keep_alive_interval * 1000;
 
 	if (sc->ib.dev->attrs.max_send_sge < SMBDIRECT_MAX_SEND_SGE ||
-	    sc->ib.dev->attrs.max_recv_sge < SMBDIRECT_MAX_RECV_SGE) {
+	    sc->ib.dev->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
 		log_rdma_event(ERR,
 			"device %.*s max_send_sge/max_recv_sge = %d/%d too small\n",
 			IB_DEVICE_NAME_MAX,
@@ -1595,7 +1595,7 @@ static struct smbd_connection *_smbd_get_connection(
 	qp_attr.cap.max_send_wr = sp->send_credit_target;
 	qp_attr.cap.max_recv_wr = sp->recv_credit_max;
 	qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SEND_SGE;
-	qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_RECV_SGE;
+	qp_attr.cap.max_recv_sge = SMBDIRECT_RECV_IO_MAX_SGE;
 	qp_attr.cap.max_inline_data = 0;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_attr.qp_type = IB_QPT_RC;
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 0463fde1bf26..81b55c0de552 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -139,9 +139,6 @@ struct smbd_request {
 	u8 packet[];
 };
 
-/* Maximum number of SGEs used by smbdirect.c in any receive work request */
-#define SMBDIRECT_MAX_RECV_SGE	1
-
 /* Create a SMBDirect session */
 struct smbd_connection *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
-- 
2.43.0

