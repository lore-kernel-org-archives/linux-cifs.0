Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9981B4231;
	Wed, 25 Jun 2025 08:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750839203; cv=none; b=f7FH+zBWLE1rPRTnFxbY+mC6SCqr1+8mE0F7owrv5phw9zcjp7VyLi15ex2uEelzzEGmffOgt23K5wr6uXdd5dYAJWhFUd5Wi31po/TZMw7jywX8gwF/Bm4ZTeLOJli/3MAdSkuPI8pKMrazFwYVt4fpGJZmH/R1+8orzeDJrrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750839203; c=relaxed/simple;
	bh=RW4PL4umCD6KYtttmW5IU5lZITStaS1ZPpg6/k3gWxU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m19U7on1fw6FW/wjMLhn3lHD7sWtMekx/Q26EzG47ygnqhKhIfOKZpzPYXJIeSkU2CSVeffsiPQsIn3z9VSJ6H1jXGawdHA0UKJ/jebmhyq5UL2PxJm33cbqsoZ8+nmKxu3c3d6xIFmWT+HE20NR2DD4bMOFR8ODuKM26uOV+KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tz1JFH2x; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tz1JFH2x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=CBZb5cDGLg5Cpz5eR4nb4ApAgqbN2A3G1lLtKu1Ecio=; b=tz1JFH2x5/xHuvBFVTe1GgoD12
	s7qAKYSNBhchEXF+k9ePAs+HPZZk9/y8zRWchw2dIQ6KYKp8+IR1krCtRiGJJYHxOcemVdgAWXFyo
	2/CvpWCBAxtyi7SpP9egHI/i/5VuQ7V1nTVMYosyf5TBDLO8JWeb6PCqAM4JQwqSMzS9yrJfFFrnx
	OGnwejB9ceQkx0v5H7yVuGV/Fgy20JfpacEcYyIqQYm4XnO5iuyaEmzAfUXlQ7YhW8XPzth787U0j
	0t16IKe/dMbWvWEpyD+qWgJiR5l8IaaqOG9UFeepxVFowTp3d9a6BnZyQ5Ne7qo7T/QoUxtkr8rpl
	mYGAekvT8BUBeoNajRNowjDtoB/Rd9pwo3FnfpT8D0bp46t3y+Gk9A6Tf6eu/1+5AweBpgx+Z6EOC
	idpFdt8OdfOLcgVAnAMSwlqvSojW5eNjpAR0J1B1i/8QnCHrKJfXpWsaPm2M5IUXo7KB7XOE9YdJi
	nsxVUt9RhyhztGh4nEpcGlTI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uULFu-00CNwO-1b;
	Wed, 25 Jun 2025 08:13:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: remove \t from TP_printk statements
Date: Wed, 25 Jun 2025 10:13:04 +0200
Message-Id: <20250625081304.943870-1-metze@samba.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The generate '[FAILED TO PARSE]' strings in trace-cmd report output like this:

  rm-5298  [001]  6084.533748493: smb3_exit_err:        [FAILED TO PARSE] xid=972 func_name=cifs_rmdir rc=-39
  rm-5298  [001]  6084.533959234: smb3_enter:           [FAILED TO PARSE] xid=973 func_name=cifs_closedir
  rm-5298  [001]  6084.533967630: smb3_close_enter:     [FAILED TO PARSE] xid=973 fid=94489281833 tid=1 sesid=96758029877361
  rm-5298  [001]  6084.534004008: smb3_cmd_enter:       [FAILED TO PARSE] tid=1 sesid=96758029877361 cmd=6 mid=566
  rm-5298  [001]  6084.552248232: smb3_cmd_done:        [FAILED TO PARSE] tid=1 sesid=96758029877361 cmd=6 mid=566
  rm-5298  [001]  6084.552280542: smb3_close_done:      [FAILED TO PARSE] xid=973 fid=94489281833 tid=1 sesid=96758029877361
  rm-5298  [001]  6084.552316034: smb3_exit_done:       [FAILED TO PARSE] xid=973 func_name=cifs_closedir

Cc: stable@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/trace.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 52bcb55d9952..93e5b2bb9f28 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -140,7 +140,7 @@ DECLARE_EVENT_CLASS(smb3_rw_err_class,
 		__entry->len = len;
 		__entry->rc = rc;
 	),
-	TP_printk("\tR=%08x[%x] xid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
+	TP_printk("R=%08x[%x] xid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
 		  __entry->rreq_debug_id, __entry->rreq_debug_index,
 		  __entry->xid, __entry->sesid, __entry->tid, __entry->fid,
 		  __entry->offset, __entry->len, __entry->rc)
@@ -190,7 +190,7 @@ DECLARE_EVENT_CLASS(smb3_other_err_class,
 		__entry->len = len;
 		__entry->rc = rc;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%x rc=%d",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid,
 		__entry->offset, __entry->len, __entry->rc)
 )
@@ -247,7 +247,7 @@ DECLARE_EVENT_CLASS(smb3_copy_range_err_class,
 		__entry->len = len;
 		__entry->rc = rc;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x source fid=0x%llx source offset=0x%llx target fid=0x%llx target offset=0x%llx len=0x%x rc=%d",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x source fid=0x%llx source offset=0x%llx target fid=0x%llx target offset=0x%llx len=0x%x rc=%d",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->target_fid,
 		__entry->src_offset, __entry->target_fid, __entry->target_offset, __entry->len, __entry->rc)
 )
@@ -298,7 +298,7 @@ DECLARE_EVENT_CLASS(smb3_copy_range_done_class,
 		__entry->target_offset = target_offset;
 		__entry->len = len;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x source fid=0x%llx source offset=0x%llx target fid=0x%llx target offset=0x%llx len=0x%x",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x source fid=0x%llx source offset=0x%llx target fid=0x%llx target offset=0x%llx len=0x%x",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->target_fid,
 		__entry->src_offset, __entry->target_fid, __entry->target_offset, __entry->len)
 )
@@ -482,7 +482,7 @@ DECLARE_EVENT_CLASS(smb3_fd_class,
 		__entry->tid = tid;
 		__entry->sesid = sesid;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x fid=0x%llx",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid)
 )
 
@@ -521,7 +521,7 @@ DECLARE_EVENT_CLASS(smb3_fd_err_class,
 		__entry->sesid = sesid;
 		__entry->rc = rc;
 	),
-	TP_printk("\txid=%u sid=0x%llx tid=0x%x fid=0x%llx rc=%d",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx rc=%d",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid,
 		__entry->rc)
 )
@@ -794,7 +794,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_err_class,
 		__entry->status = status;
 		__entry->rc = rc;
 	),
-	TP_printk("\tsid=0x%llx tid=0x%x cmd=%u mid=%llu status=0x%x rc=%d",
+	TP_printk("sid=0x%llx tid=0x%x cmd=%u mid=%llu status=0x%x rc=%d",
 		__entry->sesid, __entry->tid, __entry->cmd, __entry->mid,
 		__entry->status, __entry->rc)
 )
@@ -829,7 +829,7 @@ DECLARE_EVENT_CLASS(smb3_cmd_done_class,
 		__entry->cmd = cmd;
 		__entry->mid = mid;
 	),
-	TP_printk("\tsid=0x%llx tid=0x%x cmd=%u mid=%llu",
+	TP_printk("sid=0x%llx tid=0x%x cmd=%u mid=%llu",
 		__entry->sesid, __entry->tid,
 		__entry->cmd, __entry->mid)
 )
@@ -867,7 +867,7 @@ DECLARE_EVENT_CLASS(smb3_mid_class,
 		__entry->when_sent = when_sent;
 		__entry->when_received = when_received;
 	),
-	TP_printk("\tcmd=%u mid=%llu pid=%u, when_sent=%lu when_rcv=%lu",
+	TP_printk("cmd=%u mid=%llu pid=%u, when_sent=%lu when_rcv=%lu",
 		__entry->cmd, __entry->mid, __entry->pid, __entry->when_sent,
 		__entry->when_received)
 )
@@ -898,7 +898,7 @@ DECLARE_EVENT_CLASS(smb3_exit_err_class,
 		__assign_str(func_name);
 		__entry->rc = rc;
 	),
-	TP_printk("\t%s: xid=%u rc=%d",
+	TP_printk("%s: xid=%u rc=%d",
 		__get_str(func_name), __entry->xid, __entry->rc)
 )
 
@@ -924,7 +924,7 @@ DECLARE_EVENT_CLASS(smb3_sync_err_class,
 		__entry->ino = ino;
 		__entry->rc = rc;
 	),
-	TP_printk("\tino=%lu rc=%d",
+	TP_printk("ino=%lu rc=%d",
 		__entry->ino, __entry->rc)
 )
 
@@ -950,7 +950,7 @@ DECLARE_EVENT_CLASS(smb3_enter_exit_class,
 		__entry->xid = xid;
 		__assign_str(func_name);
 	),
-	TP_printk("\t%s: xid=%u",
+	TP_printk("%s: xid=%u",
 		__get_str(func_name), __entry->xid)
 )
 
-- 
2.34.1

