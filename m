Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71B12C376B
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442647; cv=none; b=ulsXKZoteYVcIT+NpiII/Isb4X8ORh9BS15fC7QyX96+9IwWidqdfjWDKKvGxhSxUQ0CZU7aBSb6y+qoYeDvtuJjXFcv1lcIKtasWBek/JVH/QPx2Yin4AZH8UTQHypTH9VxdQ+c5EKu+ZmTqreNwq/hgCGnwpoJT4p9Phv7Jc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442647; c=relaxed/simple;
	bh=GEW8UNXH/+SGZBm+olf2ClaesFk7/505yPF7zUjAmqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNOhs3nJpXv3R9KL8RQmsGq2u/UE4DLW+GUwISUC0X8IsGE2+o9XegKpz+88sENKr4HKy1JiJx9QjwW+pPgqOHg+m4f0W5OVhteztpOYFYLeC5KOa1yBgp9/EO2+hJwkPuMiDMMta74aI4emQyioNrNebIupkRd8+ZawQBrsOCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DRZvrHXV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DRZvrHXV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HRzOBgCeTPcnB2c5yjn+3wmloEcas7RGcPS4QOIKVCQ=;
	b=DRZvrHXVsWj85sYz6B5slbF26i4NtAm1AZTXOR7ML0TPlmnoh2QTucqNcop97QTv8f1h5A
	m28De5UE5DJu7ZbLnZaAmRtS1lrbef1WQ5638jEiFKpSYo4ISMKJrfu6NFtXA2RqTO48Mx
	JGT9Lnh2bJVi0AgNzeQk0gpuc7Hdkzc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-LruwOPwNMVCt7vdGjJj5QA-1; Mon,
 22 Dec 2025 17:30:41 -0500
X-MC-Unique: LruwOPwNMVCt7vdGjJj5QA-1
X-Mimecast-MFC-AGG-ID: LruwOPwNMVCt7vdGjJj5QA_1766442640
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57AF4195608E;
	Mon, 22 Dec 2025 22:30:40 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99C9F19560AB;
	Mon, 22 Dec 2025 22:30:38 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/37] cifs: Scripted clean up fs/smb/client/cifsglob.h
Date: Mon, 22 Dec 2025 22:29:34 +0000
Message-ID: <20251222223006.1075635-10-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/cifsglob.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 251399a2c56d..b0fefdd4f624 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1327,8 +1327,8 @@ struct tcon_link {
 	struct cifs_tcon	*tl_tcon;
 };
 
-extern struct tcon_link *cifs_sb_tlink(struct cifs_sb_info *cifs_sb);
-extern void smb3_free_compound_rqst(int num_rqst, struct smb_rqst *rqst);
+struct tcon_link *cifs_sb_tlink(struct cifs_sb_info *cifs_sb);
+void smb3_free_compound_rqst(int num_rqst, struct smb_rqst *rqst);
 
 static inline struct cifs_tcon *
 tlink_tcon(struct tcon_link *tlink)
@@ -1342,7 +1342,7 @@ cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
 	return cifs_sb->master_tlink;
 }
 
-extern void cifs_put_tlink(struct tcon_link *tlink);
+void cifs_put_tlink(struct tcon_link *tlink);
 
 static inline struct tcon_link *
 cifs_get_tlink(struct tcon_link *tlink)
@@ -1353,7 +1353,7 @@ cifs_get_tlink(struct tcon_link *tlink)
 }
 
 /* This function is always expected to succeed */
-extern struct cifs_tcon *cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb);
+struct cifs_tcon *cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb);
 
 #define CIFS_OPLOCK_NO_CHANGE 0xfe
 
@@ -1526,8 +1526,8 @@ cifsFileInfo_get_locked(struct cifsFileInfo *cifs_file)
 }
 
 struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
-void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_hdlr,
-		       bool offload);
+void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
+		       bool wait_oplock_handler, bool offload);
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 int cifs_file_flush(const unsigned int xid, struct inode *inode,
 		    struct cifsFileInfo *cfile);

