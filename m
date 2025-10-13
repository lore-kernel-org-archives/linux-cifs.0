Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E242FBE0D;
	Mon, 13 Oct 2025 10:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760350572; cv=pass; b=NVr3uUAGG9SAYX9/OAS9H1Zq/bagQXUSzJCJzgcHk09NScjacYEDWnnyZWudrcVVd2CYIzQo6UzqnH1vDRs5IvZ47OX/Jcpd/9PuSzC2cs4Vk9bgCl/36v1qN+LVczfnPsu0Hkbte91KkqcBm6Cg/wLRICLOyclqCDHk90G7JCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760350572; c=relaxed/simple;
	bh=KbGgbE2LAMKXZsdb4PTIRcj+uHmgvrLQq5UjeCSuZCA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HKZMlzokvj/5AHBRndnhyKoWQC3VXZ7/QdqkaWZDdNIKzcIFlEWKvhpEQLtfcO53MHdikcvVcA/VJUzxULwfutqQEXR1HEIoOZtNofx/nwB7HuzUBNdBVn2o7xuON9X+/pANIQwfbmlxHo3BPe8ydQp8Oo9Pr+2awYisZHoxIlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=l9Wzod7x; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="l9Wzod7x"
Received: from osx.local (ecs-119-8-240-30.compute.hwclouds-dns.com [119.8.240.30])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 59DAEqqO3147496
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Oct 2025 18:14:59 +0800
ARC-Seal: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse; t=1760350500; cv=none;
	b=m7u9SBlcxPv1jcQv8hFLob6a818/dI8br67FRkn+exKzz6dvM8v5IaSmBqcxTjsOZzsHeXSfdIaMPLnunqRhbB+9Ef7D2mEg6xWpKyBVdmVvaCeWcDao8IM8coVBjmC5/h384XIuyY8e3bJCUVT1D+noXvtMXuqI57DljvKAQds=
ARC-Message-Signature: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse;
	t=1760350500; c=relaxed/relaxed;
	bh=TA3dA+SpwDuqkRbHnSmlGjQUhZ1LSdHyaNvgSwhoDHM=;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=ba6/1Tyu973Tfm0GP64RGrfveAKjxL0D6LeMLK18dgza7L2BsYGcRkNRlAfSjPEjzVri+f+Orqib8jKFfgd5A7WrS7krgP7Dn4Ux7sL/dcDILMO6ciot7fJPfy0pqnWxwjcOUTFvaBP/bm7IDH7/2muMOw++DbEp535l7sya4YM=
ARC-Authentication-Results: i=1; cse.ust.hk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1760350500;
	bh=TA3dA+SpwDuqkRbHnSmlGjQUhZ1LSdHyaNvgSwhoDHM=;
	h=Date:From:To:Cc:Subject:From;
	b=l9Wzod7xxEoH156EOIiOJR3wvSrsmxZ8sT4VglJFr6nfnhSQQqiWSZAPZsSBToPFt
	 vydNamFwF7Azbm14yDnl7YeJhMKX+EKnC+DKYHQA/NfmTwWosXi38HqVARhsQQy097
	 zS9vxQwuO6i4E0sXUCAPI/lEvkrm97X/HxgSIaqI=
Date: Mon, 13 Oct 2025 18:14:47 +0800
From: Shuhao Fu <sfual@cse.ust.hk>
To: Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] smb: Fix refcount leak for cifs_sb_tlink
Message-ID: <aOzRF9JB9VkBKapw@osx.local>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Env-From: sfual

This patch fixes three refcount inconsistency issues related to
`cifs_sb_tlink`. Comments for `cifs_sb_tlink` state that
`cifs_put_tlink()` needs to be called after successful calls to
`cifs_sb_tlink`. Three callsites fail to update refcount accordingly,
leading to possible resource leaks.

Fixes: 8ceb98437946 ("CIFS: Move rename to ops struct")
Fixes: 2f1afe25997f ("cifs: Use smb 2 - 3 and cifsacl mount options getacl functions")
Fixes: 366ed846df60 ("cifs: Use smb 2 - 3 and cifsacl mount options setacl function")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
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
+		goto out;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3245,6 +3244,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+out:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 
@@ -3285,8 +3285,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
-		free_xid(xid);
-		return rc;
+		goto out;
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -3307,6 +3306,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	}
 
+out:
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 	return rc;
-- 
2.39.5 (Apple Git-154)

