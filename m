Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E9F261B8C;
	Tue,  4 Nov 2025 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762269469; cv=pass; b=GLjmPT/qbdVNO4Wiih78sjaWO8hPDhjjFu1zHfO6WCtCzIhWmYxIhZCi3QRjwJArK8Xpu47vN0PBNuOZT3cHizSu846iZ64b6eXWVTF40W1k3/ZcKuRrIURogGZwu6bhtrMU/KufVkVz4jhJN+JCRBgoTpVHOhF/x46p1undFK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762269469; c=relaxed/simple;
	bh=Qz2PX35Zkh7VXOW3KElQ1Gz2lDQT1VW6y1i2m1eWtH4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pje24QifFZ3W607pkj16bSM2UoJpSQqLwTxwc3U++WP7HFSkYK/o0LCqJ6CqLtfgNhe5QQci/T7VrZTXGCngrnPtg1i31YXtkhQNhqsSxrtnaLRl0unV7EtF8NeLzrlu1FPa3sFPJu64d/QFRMC4X/scPK4jA0tTD0Yvn7mzDAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=42/tkrrk; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="42/tkrrk"
Received: from osx.local (static.reserve.wtt.net.hk [218.253.70.186] (may be forged))
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 5A4FDHAc318260
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 4 Nov 2025 23:13:23 +0800
ARC-Seal: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse; t=1762269204; cv=none;
	b=u+8DBLJtP6MYz/h+Lxn3RxLZc2X6ZX1LnmuFUJHKzI5WkB9eEcEnGnaZMouwJWZkFCnd1dQzXV6vR6BWRiAlj2rP+5Tnl1SiwDnQaX9i1y4IxaqdGNLkEIeyt7AqKS2CdZE2rMZJf834fJWChlNvlrn0K0ou6zS4LuMT0v5Savk=
ARC-Message-Signature: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse;
	t=1762269204; c=relaxed/relaxed;
	bh=/AUv+2G4iiP3XEGAo9Kngu9KIaAFndteX2L7MRgck/w=;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=XVhidYWSiPCEHxUXOdYEmJ7EJS2WzYeP2p5WG2ckctVTnJ9G7bPEIPClxo/MHHZmQTqwdPYZKNDokOBq2WCuPRrjw0WINLZwbgXJvw8IbcHOo0dq9ou3HjB8/6nDry5ofYPtssAwjEUigPUTWV0dy5OiSqYkqEQ/EBRohQncf9s=
ARC-Authentication-Results: i=1; cse.ust.hk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1762269204;
	bh=/AUv+2G4iiP3XEGAo9Kngu9KIaAFndteX2L7MRgck/w=;
	h=Date:From:To:Cc:Subject:From;
	b=42/tkrrkLewD7gCnoSNYeyrRSe7c0bqmTi82iGoYcUlWKqXaevFzZC/qG4zD+228V
	 vt5ljYaC88KLzPTJ1km0UDfVPGNKT+MLn6Ow7w3cK6JsbyhvsZbyXQfGSLVklWaIsb
	 EGvCBcANPtsIrNUk1bG6y1kht0grzKt9IgD8CzP8=
Date: Tue, 4 Nov 2025 23:13:15 +0800
From: Shuhao Fu <sfual@cse.ust.hk>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: fix refcount leak in smb2_set_path_attr
Message-ID: <aQoYCxKqMHwH4sOK@osx.local>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Env-From: sfual

Fix refcount leak in `smb2_set_path_attr` when path conversion fails.

Function `cifs_get_writable_path` returns `cfile` with its reference
counter `cfile->count` increased on success. Function `smb2_compound_op`
would decrease the reference counter for `cfile`, as stated in its 
comment. By calling `smb2_rename_path`, the reference counter of `cfile`
would leak if `cifs_convert_path_to_utf16` fails in `smb2_set_path_attr`.

Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
---
 fs/smb/client/smb2inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 09e3fc81d..69cb81fa0 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1294,6 +1294,8 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_to_name = cifs_convert_path_to_utf16(to_name, cifs_sb);
 	if (smb2_to_name == NULL) {
 		rc = -ENOMEM;
+		if (cfile)
+			cifsFileInfo_put(cfile);
 		goto smb2_rename_path;
 	}
 	in_iov.iov_base = smb2_to_name;
-- 
2.39.5 (Apple Git-154)

