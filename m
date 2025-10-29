Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54CC23B60A
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744195; cv=none; b=BO+T5u/RkAFEGfxg52G2627Ut2DkVVSIbixPWUfqkGp7kJrwLh8h4mcxMTHzC/gjm+1/+GxZcyeIz9Qm/5ubXNqrKh92q+PvfkXjj5IhmqR+yzqPOj9q/1PMf6+ThR0fbqoKDgIljGJ99Qbo1e2RVsoZEJjY5+goph1gG9o4Ddk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744195; c=relaxed/simple;
	bh=DP6hQ1dUDeJaMIzjTFXddDp7mlgZOvSEwIB0i+DdG8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7hMnvujIYRt4eW8DpP/kLk7/Lupn+UVIbz6ZchB2yu5tJaWZWhTqPT/kzfbvJJEpgn4juDBWiaSWLIdPE35KaxJWTIp1hYm7RTR4E6DU90p0aZFnjTdPqDtZqp2x/AEKPdtnfvgcm6T04OcQJ1F8/1ZYkkBOgwnodsrU9VDOOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tmyZbdmu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tmyZbdmu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=YA91a/EreQ8HCjH/Zu36rbx6hGX/lrVdAEFkJ+zAsBI=; b=tmyZbdmuUe4spyvq/q/i50GPI3
	Ta+G0noONSB8q1SyAr118mEgFD0zU1RdZsDoUWCEt6LDXp4RxJKqUdqT4H7ntXwuusWOHWxyJU/Ep
	lr0ibPouXeySF21+ETOO+pOIPRubfubT7+h6qhCAE/QjZ+o1j7evUfgCn4xsv1u4xTDWFmCFk4ZgB
	g9tVbHt4zYEw0c3RWdwP5QTXJogysBE1fqcC1VhKeRTA4aIzJB95xc5mUrWNNx3FBd7Ij76gA0VCc
	geCBq721txh/qte1xWLdFuR/lM14WgaDGL2vsX02lmEQpPvzKS1vb+F+WINxoJB9e3dL4Vibrcdtz
	itAWyeadrQsCuSTFObBQbr6ENTUs0pJE3XGSrcnXVJcFmmFLmXZbToau6NQTHyT8oBCSHj7fZTyHw
	eDT8wh1Q/12UIDj7tBs7UBfiGx4cjJkuoiN7D3aOQsg7eZHXJAUQc5+PhDzaDVKoo7k8v1nCkvkOz
	6IzXzyfUeAVGwzZyaNetgjx8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE68r-00BbFt-2V;
	Wed, 29 Oct 2025 13:23:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 006/127] smb: client: include smbdirect_all_c_files.c
Date: Wed, 29 Oct 2025 14:19:44 +0100
Message-ID: <d8e5fd7451711f27009f7830bfea723ec0b6a552.1761742839.git.metze@samba.org>
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

This is the first tiny step in order to use common functions in future.
Once we have all functions in common we'll move to an smbdirect.ko
that exports public functions instead of including the .c file.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 85a4c55b61b8..5ae22c8dea81 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -4,6 +4,9 @@
  *
  *   Author(s): Long Li <longli@microsoft.com>
  */
+
+#define SMBDIRECT_USE_INLINE_C_FILES 1
+
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/folio_queue.h>
@@ -142,6 +145,14 @@ module_param(smbd_logging_level, uint, 0644);
 MODULE_PARM_DESC(smbd_logging_level,
 	"Logging level for SMBD transport, 0 (default): error, 1: info");
 
+/*
+ * This is a temporary solution until all code
+ * is moved to smbdirect_all_c_files.c and we
+ * have an smbdirect.ko that exports the required
+ * functions.
+ */
+#include "../common/smbdirect/smbdirect_all_c_files.c"
+
 #define log_rdma(level, class, fmt, args...)				\
 do {									\
 	if (level <= smbd_logging_level || class & smbd_logging_class)	\
-- 
2.43.0

