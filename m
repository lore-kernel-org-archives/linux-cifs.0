Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534A310E3;
	Thu, 16 Oct 2025 02:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760583256; cv=pass; b=u8bQefrfJcLfT2VLjOHItNEcAfetHRK09JMNFKx75y1HRzHdsM/JGAI1GNZ6O/J5wCvIWpk86+fQhOvdTzsjmrAPLbYEP6NgWQPGR9RGGRW99DMjSqEIpqCt1M6CCjQxlUy42pnkbu3YRUUr4upjGUAF5zskZxn2iJHlNWv49tE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760583256; c=relaxed/simple;
	bh=FkjFj6b1nvk0IHKq6m+s/GHmeDF/bZUErZPOtzN3ABQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nJT6l6DxSVghtBd7Xw+dRvEAgMxm4NcLb/KfPPDHQCKwGlRlSHdIdXnbKjxqFiPrn0woeXrB7o+KFjezWfyC6+TuzzDVoy+9xJI26HlFnmLEAnDxgFfWDnp63hnsKTLAOryyvO9bOeg3QI0uZwenLts/xvjYgKIMkgPPRC2GmDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=g/7zUmDE; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="g/7zUmDE"
Received: from chcpu18 (191host009.mobilenet.cse.ust.hk [143.89.191.9])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 59G2r0cl3717538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Oct 2025 10:53:06 +0800
ARC-Seal: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse; t=1760583188; cv=none;
	b=h0VLV2A5I6dqgYw81ZxEl308eE3hpRg/JGKAumbPpbHuVPjpCWVOXlWSpXBKFz8WG20og22U2acBgVGbhiSGlJYcmaGp2WHMD88DTL8isEem3OCTEJlibagygeyil15faDT7HJsVE24wypoFUfvCXJA5zoZHVtYgZtefEvtak/0=
ARC-Message-Signature: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse;
	t=1760583188; c=relaxed/relaxed;
	bh=8jitBnmayCbSbZ2XGbeU7NW7NJsLcoQ7l2DTmEsolMk=;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=mXjKybGFT0W+B6bttStbbvw/FFa9EevsLsnNbTGcp3RBayBMB7ToU5S7Zn+lfzIME/YLeBlqsGa4nijkevf7axJ0+ufPhk9zMMN4WUa3LeBFN5LYkyUeMTXK2pMBdJoHXG4VQSMZUl4KfKYBdFdadu9aMunBTrVFh85hDhbsGeE=
ARC-Authentication-Results: i=1; cse.ust.hk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1760583188;
	bh=8jitBnmayCbSbZ2XGbeU7NW7NJsLcoQ7l2DTmEsolMk=;
	h=Date:From:To:Cc:Subject:From;
	b=g/7zUmDEzsasrwly39SGFF/hLGV0hYRk8m8u3Hk5qOpzwmAiog61hhCCyiEoTMOGD
	 wds5fGpqWV8banYxQ65ZZSXt9QdqbEeCjYDEh+EOHaEeoGwdnThvKK5kfwdfJ/29V2
	 U2ZgzVb6P/jKSbGayZjbT0Dz9ZG2kEMJJiVHxPmE=
Date: Thu, 16 Oct 2025 02:52:55 +0000
From: Shuhao Fu <sfual@cse.ust.hk>
To: Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>
Cc: Markus Elfring <Markus.Elfring@web.de>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>,
        Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] smb: client: Fix refcount leak for cifs_sb_tlink
Message-ID: <aPBeBxTQLeyFl4mx@chcpu18>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Env-From: sfual

Fix three refcount inconsistency issues related to `cifs_sb_tlink`. 

Comments for `cifs_sb_tlink` state that `cifs_put_tlink()` needs to be 
called after successful calls to `cifs_sb_tlink()`. Three calls fail to
update refcount accordingly, leading to possible resource leaks.

Fixes: 8ceb98437946 ("CIFS: Move rename to ops struct")
Fixes: 2f1afe25997f ("cifs: Use smb 2 - 3 and cifsacl mount options getacl functions")
Fixes: 366ed846df60 ("cifs: Use smb 2 - 3 and cifsacl mount options setacl function")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
---
Change in v2:
1. improved patch wording
2. nicer goto label naming

Link to v1: https://lore.kernel.org/linux-cifs/aOzRF9JB9VkBKapw@osx.local/
---
 fs/smb/client/inode.c   | 6 ++++--
 fs/smb/client/smb2ops.c | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 239dd84a3..098a79b7a 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2431,8 +2431,10 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
-	if (!server->ops->rename)
-		return -ENOSYS;
+	if (!server->ops->rename) {
+		rc = -ENOSYS;
+		goto do_rename_exit;
+	}
 
 	/* try path-based rename first */
 	rc = server->ops->rename(xid, tcon, from_dentry,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7c392cf59..00b3f769e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3212,8 +3212,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return ERR_PTR(rc);
+		goto put_tlink;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3245,6 +3244,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 
@@ -3285,8 +3285,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return rc;
+		goto put_tlink;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3307,6 +3306,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+put_tlink:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 	return rc;
-- 
2.39.5 (Apple Git-154)


