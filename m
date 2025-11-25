Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CFE3314DD
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095575; cv=none; b=aRG6mIOfAMedF6PefzLVEC/9b2RqTEGFfcy1kMMUvVbEcpY4MN0RePGQLJ0EzrDkvuaKjB/k/7vgBBtiC+zfjXzSOdF0ZVFcLitJLdERpAdzAZDGim2SRHIBm+MY3RXmTauJbHINAvZwcX/Q/IW+0y20HzjIfpYxQchU2t6PWV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095575; c=relaxed/simple;
	bh=koiTwUmChf1DmaLc6NPfM6JMZMJwv/4mBYXovjS4EX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLntDogKeQS7L14VxXiJM6xMSLrVhvFCnHqqIzFDs0hBej47f5IFkSDSSkRjQpaw15P1gsTbY+QaXxZtrk/0jJDCNt1DQ4gMrclQPnWjmQWF/iVTxF0yDtPj+/F+BgkNbHQ8XCZUp05EVyP1eJV4II2O9Wadpx0yilVU78JI32o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NKQfFWVg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NKQfFWVg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=6ZBdmK/hb72nWzfTX+xpVwDxdtCuyybkMHjYK9w6vSg=; b=NKQfFWVg2e26+fuyxgPQOSVPF/
	EXlf72BFVDDBmJbpjrSfb/Fwiy9Xlo9l8kBOFZMuY2sQA17ghs/lsoRj8lPaU/pd0djQ+22t2kD47
	GTIPQcTpargtnfbGCxkRoHxT0ECTqYkLT7M4MoG5j1V5VlKTRhbAlNC1FQgPZTl+VyTpTAyPBLJ97
	0qN55RiDCSCHDX2uy7b2MCGr3UccINWgFfDunuLtZ6Ea/ti8DCUM2Oa45QW6e800ayeOwxIIG+OvN
	uehxyyTUEPQapUsCv7Q126zZfqAQyFVGiblvvsE3yYdyvAwQzUkJ6XOU6l7FlG0t0Py6sHJzue+Ix
	12VUy1k+BizZR8i+JDcA6Lr3U5h+x7pE6xfkNXF63xG1JPQlVkgaRisLmaOoflGVteZdFl5A5bbKe
	JNP9bRah3zoHmawUm9KSJlmdZO8aLIwYwZ56EUueMTlOcIh3vBlDGDpdWEBoxj/SaMkVJmn1J6ABY
	/3rKDzJmQs5eV6dKpZfoPPMw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxmu-00Ffwd-0y;
	Tue, 25 Nov 2025 18:29:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 138/145] smb: client: no longer use smbdirect_socket_set_custom_workqueue()
Date: Tue, 25 Nov 2025 18:56:24 +0100
Message-ID: <cabe70c090b544443f56512146270fa58dcc5578.1764091285.git.metze@samba.org>
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

smbdirect.ko has global workqueues now, so we should use these
default once.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 12 ------------
 fs/smb/client/smbdirect.h |  1 -
 2 files changed, 13 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 0c3a4b6aa03f..4b9ae71c323b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -196,7 +196,6 @@ void smbd_destroy(struct TCP_Server_Info *server)
 
 	smbdirect_socket_release(info->socket);
 
-	destroy_workqueue(info->workqueue);
 	kfree(info);
 	server->smbd_conn = NULL;
 }
@@ -245,7 +244,6 @@ static struct smbd_connection *_smbd_get_connection(
 	struct smbdirect_socket_parameters init_params = {};
 	struct smbdirect_socket_parameters *sp;
 	__be16 *sport;
-	char wq_name[80];
 	int ret;
 
 	/*
@@ -270,10 +268,6 @@ static struct smbd_connection *_smbd_get_connection(
 	info = kzalloc(sizeof(struct smbd_connection), GFP_KERNEL);
 	if (!info)
 		return NULL;
-	scnprintf(wq_name, ARRAY_SIZE(wq_name), "smbd_%p", info);
-	info->workqueue = create_workqueue(wq_name);
-	if (!info->workqueue)
-		goto create_wq_failed;
 	ret = smbdirect_socket_create_kern(net, &sc);
 	if (ret)
 		goto socket_init_failed;
@@ -284,9 +278,6 @@ static struct smbd_connection *_smbd_get_connection(
 	ret = smbdirect_socket_set_kernel_settings(sc, IB_POLL_SOFTIRQ, GFP_KERNEL);
 	if (ret)
 		goto set_settings_failed;
-	ret = smbdirect_socket_set_custom_workqueue(sc, info->workqueue);
-	if (ret)
-		goto set_workqueue_failed;
 
 	if (dstaddr->sa_family == AF_INET6)
 		sport = &((struct sockaddr_in6 *)dstaddr)->sin6_port;
@@ -306,13 +297,10 @@ static struct smbd_connection *_smbd_get_connection(
 	return info;
 
 connect_failed:
-set_workqueue_failed:
 set_settings_failed:
 set_params_failed:
 	smbdirect_socket_release(sc);
 socket_init_failed:
-	destroy_workqueue(info->workqueue);
-create_wq_failed:
 	kfree(info);
 	return NULL;
 }
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index bd03ae72e9c8..0017d5b2de44 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -25,7 +25,6 @@ extern int smbd_receive_credit_max;
 
 struct smbd_connection {
 	struct smbdirect_socket *socket;
-	struct workqueue_struct *workqueue;
 };
 
 /* Create a SMBDirect session */
-- 
2.43.0

