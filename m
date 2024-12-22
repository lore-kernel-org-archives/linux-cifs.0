Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B17639AEB;
	Sun, 22 Dec 2024 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734887737; cv=none; b=s3PP+HMbjXipYrOaLnvNxEwumSgVY48UjuewCwMdW1AwZSYyvtuRIGkit4rUVqicEfzXDYm01KVljqV+vl4WsTc7Cp+VPUDlCdzYwCpwtiVgM1kuHnJemIlQtYOfxWBivVf860skYNgtDcvGGGf6bhjOmybaTardgJLsN+zprR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734887737; c=relaxed/simple;
	bh=LontnbXA7/QnYtjbaLg/uQhkvXruDqTutlOKd8MlNFw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=q3XNXh6+NnnDVV63UUJFgjcK9/JRUGImexR5xES7UBRGaASOr1AakEdE3eEhVl+bBtBRCiQPyPxLUYHjV46MVhD1W35FD3hu0nB0kjEATxnkPdsEm7ICW3DYj+x84Zh60A/Jq8UNQY8u0sprPYKyjxC3Om84jwbZDEM4culPrmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJRmgx/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJRmgx/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F0FC4CECD;
	Sun, 22 Dec 2024 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734887736;
	bh=LontnbXA7/QnYtjbaLg/uQhkvXruDqTutlOKd8MlNFw=;
	h=From:To:Cc:Subject:Date:From;
	b=JJRmgx/tWKVjCK+2f/5vI+nngOZzf+b3x536KWBBXVVAfVh+bwvc3Ah6814DNOAqA
	 nu4jfoPoPQgb7FAPlEXRqUG5sIJT0NI5XQ9yj+eh6E/7TIulUelpiyB3XQwPfTxZAf
	 FAqpPZZgHOeHRn6BTEFqPeEoCetZnsm1O/bVi2E87IaqU+MVee80fO96ZNa3vqIW6u
	 GtjtBc3/n9TryhpSyR9ZL7obX0Js1rrjZhaaPj+sbgRQ2TfOA51DxNcseLFJHlSJGX
	 0WPzSHFSG/e46OEg5TugA1e/GUJu4jkURdKU3hDJ5ZhPQIiap1BE7cLo7DQiqxDRYk
	 QWKbhk6Fs7s8w==
Received: by pali.im (Postfix)
	id 509C37F2; Sun, 22 Dec 2024 18:15:27 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Implement is_network_name_deleted for SMB1
Date: Sun, 22 Dec 2024 18:14:31 +0100
Message-Id: <20241222171431.24657-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This change allows Linux SMB1 client to autoreconnect the share when it is
modified on server by admin operation which removes and re-adds it.

Implementation is reused from SMB2+ is_network_name_deleted callback. There
are just adjusted checks for error codes and access to struct smb_hdr.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 0533aca770fc..76e7353f2a72 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -14,6 +14,8 @@
 #include "cifspdu.h"
 #include "cifs_unicode.h"
 #include "fs_context.h"
+#include "nterr.h"
+#include "smberr.h"
 
 /*
  * An NT cancel request header looks just like the original request except:
@@ -1075,6 +1077,47 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 				  full_path, mode, dev);
 }
 
+static bool
+cifs_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
+{
+	struct smb_hdr *shdr = (struct smb_hdr *)buf;
+	struct TCP_Server_Info *pserver;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+
+	if (shdr->Flags2 & SMBFLG2_ERR_STATUS) {
+		if (shdr->Status.CifsError != cpu_to_le32(NT_STATUS_NETWORK_NAME_DELETED))
+			return false;
+	} else {
+		if (shdr->Status.DosError.ErrorClass != ERRSRV ||
+		    shdr->Status.DosError.Error != cpu_to_le16(ERRinvtid))
+			return false;
+	}
+
+	/* If server is a channel, select the primary channel */
+	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
+		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+			if (tcon->tid == le32_to_cpu(shdr->Tid)) {
+				spin_lock(&tcon->tc_lock);
+				tcon->need_reconnect = true;
+				spin_unlock(&tcon->tc_lock);
+				spin_unlock(&cifs_tcp_ses_lock);
+				pr_warn_once("Server share %s deleted.\n",
+					     tcon->tree_name);
+				return true;
+			}
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	return false;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -1159,6 +1202,7 @@ struct smb_version_operations smb1_operations = {
 	.get_acl_by_fid = get_cifs_acl_by_fid,
 	.set_acl = set_cifs_acl,
 	.make_node = cifs_make_node,
+	.is_network_name_deleted = cifs_is_network_name_deleted,
 };
 
 struct smb_version_values smb1_values = {
-- 
2.20.1

