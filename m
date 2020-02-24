Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB50C11D2F
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2409220828
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="HHSwluTE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgBXNPv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:15:51 -0500
Received: from hr2.samba.org ([144.76.82.148]:41900 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNPv (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:15:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=XnecTLNXjN6OYPF/A7fcS45I3hzAOlXTKVwQEuIMlTs=; b=HHSwluTExFq/lV2NbX4KY7fyIs
        DCgmzcxO4X9RAN0Q7NUXfTsvh7X+JfwZiCjiHOEU4W2VLBA87wnZVGpTjnFFHEM8K1gGaV9xvhYeV
        8O4G5ubQBqQLHVaaXTVJ7J//S7CuOej4oDXSOesZLN/x373ihA0put2Rk3X2MleOUESdpRltxqGOV
        jjQ6GqJkVqRY9utIiGdpOnWPiPd55/KHMEBNZ+iqBmaTAsLHeyw4NTVFGnQ0gv+CYX5ODQfaGRE17
        aQNI9NT8f1z2+5g33t7QvPH2NTmuZjIN5nylF9Flh5ryt2ko1Y+VqkpZrvifkxnv11i65b5B4NM50
        VcUg0p0N/IyxrHiGR5dzwcfpCkGvVakm1kK2MTbVffu4eQITpCaMer6vXt1xA21C3flZz8trKZzP8
        6wmSv00Tf7XDohmoi4XDZmz5yaaCfiHzt/ALgXajLSr46VGh+vpIbEddbpGlmUqTxfkts8R68fTUi
        2qkuQOGUgp7zeCAddQlAD6DN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaP-00061e-Gx; Mon, 24 Feb 2020 13:15:49 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 01/13] cifs: call wake_up(&server->response_q) inside of cifs_reconnect()
Date:   Mon, 24 Feb 2020 14:14:58 +0100
Message-Id: <20200224131510.20608-2-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This means it's consistently called and the callers don't need to
care about it.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/cifssmb.c | 1 -
 fs/cifs/connect.c | 7 ++-----
 fs/cifs/smb2ops.c | 3 ---
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 3c89569e7210..01206e12975a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1590,7 +1590,6 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	if (server->ops->is_session_expired &&
 	    server->ops->is_session_expired(buf)) {
 		cifs_reconnect(server);
-		wake_up(&server->response_q);
 		return -1;
 	}
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4804d1df8c1c..25df928b3ca0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -537,6 +537,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		dfs_cache_free_tgts(&tgt_list);
 		put_tcp_super(sb);
 #endif
+		wake_up(&server->response_q);
 		return rc;
 	} else
 		server->tcpStatus = CifsNeedReconnect;
@@ -671,6 +672,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 
+	wake_up(&server->response_q);
 	return rc;
 }
 
@@ -765,7 +767,6 @@ server_unresponsive(struct TCP_Server_Info *server)
 		cifs_server_dbg(VFS, "has not responded in %lu seconds. Reconnecting...\n",
 			 (3 * server->echo_interval) / HZ);
 		cifs_reconnect(server);
-		wake_up(&server->response_q);
 		return true;
 	}
 
@@ -898,7 +899,6 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 		 */
 		cifs_set_port((struct sockaddr *)&server->dstaddr, CIFS_PORT);
 		cifs_reconnect(server);
-		wake_up(&server->response_q);
 		break;
 	default:
 		cifs_server_dbg(VFS, "RFC 1002 unknown response type 0x%x\n", type);
@@ -1070,7 +1070,6 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		server->vals->header_preamble_size) {
 		cifs_server_dbg(VFS, "SMB response too long (%u bytes)\n", pdu_length);
 		cifs_reconnect(server);
-		wake_up(&server->response_q);
 		return -ECONNABORTED;
 	}
 
@@ -1118,7 +1117,6 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	if (server->ops->is_session_expired &&
 	    server->ops->is_session_expired(buf)) {
 		cifs_reconnect(server);
-		wake_up(&server->response_q);
 		return -1;
 	}
 
@@ -1212,7 +1210,6 @@ cifs_demultiplex_thread(void *p)
 			cifs_server_dbg(VFS, "SMB response too short (%u bytes)\n",
 				 server->pdu_size);
 			cifs_reconnect(server);
-			wake_up(&server->response_q);
 			continue;
 		}
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e47190cae163..bb2227561f5d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4148,7 +4148,6 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	if (server->ops->is_session_expired &&
 	    server->ops->is_session_expired(buf)) {
 		cifs_reconnect(server);
-		wake_up(&server->response_q);
 		return -1;
 	}
 
@@ -4512,14 +4511,12 @@ smb3_receive_transform(struct TCP_Server_Info *server,
 		cifs_server_dbg(VFS, "Transform message is too small (%u)\n",
 			 pdu_length);
 		cifs_reconnect(server);
-		wake_up(&server->response_q);
 		return -ECONNABORTED;
 	}
 
 	if (pdu_length < orig_len + sizeof(struct smb2_transform_hdr)) {
 		cifs_server_dbg(VFS, "Transform message is broken\n");
 		cifs_reconnect(server);
-		wake_up(&server->response_q);
 		return -ECONNABORTED;
 	}
 
-- 
2.17.1

