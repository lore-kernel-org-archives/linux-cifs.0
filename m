Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376B534889A
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442707; cv=none; b=Bs00dKq9Lr+NRoDSKhJs391ktVC2kp5vflQFvxXmrLvAFtADr/k7s7ybDxe1vdKvcDQzfv8VpWvvKPjUEtX0bPEWul++SLjD7tqJ+yP4vTM2sQaReN9OISBpiys+hbesivW39GQrSfoatxv6+W5a1ukpACwzQE+81lUDdorXZmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442707; c=relaxed/simple;
	bh=2sR/YZV9xRGQBSW3/OQs43dUq9X155/YhudPg15JweU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcLKDW8n33Z6l0nOmIfMl34vxFkC1r6gPItb2sOD+7MpztMDVfIMHiYTYWf0lpnnV7oOea3i4MV+tg/PXfAeF+MWusPghIhIzqfgZzFsZ8pSAODcR9PZfKzijR+dg8UBfOQR3t02xBIw0lmx31myDcS30p7+Bbqs+VWQsJUTpNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dZotTrJc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dZotTrJc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6j1nlWncibRlIK3hvFG1ZxtFPkTh0J4hnd7HKuh+Yc=;
	b=dZotTrJce3b4SNlSEvWcLqMwdtCHaI+WfZZSDJJAPnPvxT0cScWCVCY5LXWqoFYxr6jFHm
	3Sk9mKMf6/HDYEuk0LOIudHgLXjzPFpVEQdMtsSy/6FTTGWWoxLh2CQvK1yj29K9Pv/1zu
	yx1/mI/rgwCMWXMv9MJxJfBEEvG+IbU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-J6vSlpVJP7utK65jHmwmuA-1; Mon,
 22 Dec 2025 17:31:40 -0500
X-MC-Unique: J6vSlpVJP7utK65jHmwmuA-1
X-Mimecast-MFC-AGG-ID: J6vSlpVJP7utK65jHmwmuA_1766442699
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 908E71956088;
	Mon, 22 Dec 2025 22:31:39 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D00A419560B4;
	Mon, 22 Dec 2025 22:31:37 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 28/37] cifs: SMB1 split: Don't return smb_hdr from cifs_{,small_}buf_get()
Date: Mon, 22 Dec 2025 22:29:53 +0000
Message-ID: <20251222223006.1075635-29-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Return void* rather than struct smb_hdr* from from cifs_buf_get() and
cifs_small_buf_get() as SMB2/3 shouldn't be accessing smb_hdr.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/cifsproto.h | 4 ++--
 fs/smb/client/misc.c      | 9 ++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 53d23958b9da..6cf084aeb30e 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -26,9 +26,9 @@ struct smb3_fs_context;
  *****************************************************************
  */
 
-struct smb_hdr *cifs_buf_get(void);
+void *cifs_buf_get(void);
 void cifs_buf_release(void *buf_to_free);
-struct smb_hdr *cifs_small_buf_get(void);
+void *cifs_small_buf_get(void);
 void cifs_small_buf_release(void *buf_to_free);
 void free_rsp_buf(int resp_buftype, void *rsp);
 int smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index dab2d594f024..273c54d39857 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -178,10 +178,10 @@ tconInfoFree(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 	kfree(tcon);
 }
 
-struct smb_hdr *
+void *
 cifs_buf_get(void)
 {
-	struct smb_hdr *ret_buf = NULL;
+	void *ret_buf = NULL;
 	/*
 	 * SMB2 header is bigger than CIFS one - no problems to clean some
 	 * more bytes for CIFS.
@@ -220,10 +220,10 @@ cifs_buf_release(void *buf_to_free)
 	return;
 }
 
-struct smb_hdr *
+void *
 cifs_small_buf_get(void)
 {
-	struct smb_hdr *ret_buf = NULL;
+	void *ret_buf = NULL;
 
 /* We could use negotiated size instead of max_msgsize -
    but it may be more efficient to always alloc same size
@@ -231,7 +231,6 @@ cifs_small_buf_get(void)
    defaults to this and can not be bigger */
 	ret_buf = mempool_alloc(cifs_sm_req_poolp, GFP_NOFS);
 	/* No need to clear memory here, cleared in header assemble */
-	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
 	atomic_inc(&small_buf_alloc_count);
 #ifdef CONFIG_CIFS_STATS2
 	atomic_inc(&total_small_buf_alloc_count);

