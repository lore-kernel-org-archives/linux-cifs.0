From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 31/37] [CIFS] Add SMBD transport to SMB session context
Date: Wed,  2 Aug 2017 13:10:42 -0700
Message-ID: <1501704648-20159-32-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

With the SMBD transport implemented, now add to the SMB session context. Now the upper layer can use SMBD transport in a SMB session.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsglob.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 20af553..413b011 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -581,6 +581,7 @@ inc_rfc1001_len(void *buf, int count)
 }
 
 struct TCP_Server_Info {
+	struct cifs_rdma_info *rdma_ses;
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
 	int srv_count; /* reference counter */
-- 
2.7.4
