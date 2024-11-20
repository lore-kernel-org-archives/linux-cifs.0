Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353CB145B16
	for <linux-cifs@vger.kernel.org>; Wed, 20 Nov 2024 17:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732123119; cv=none; b=MtgBBqTuDVHH9u3kXCJBcaxWPn5d5qT4L9JG3aarT8ia3YCF/FzB1G/g5cC7v7RB5mGywWWW49AYxQbpLRogmzHTdX91yjnQroSmmsJBMh7gKLljsR+GM66CTEoWeMoDnGjgrPtzeK/1IFpWLAB3C3kIMtDziJ/7q+SSLJGPBT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732123119; c=relaxed/simple;
	bh=i9lBSWFYP6iGVF9K57CJ12bcNiGVIPE6WKd4wy5FNvc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=h75EOL9RvyXMsHA0a5bIzUyr4poO/o8cCsRx1GWBLntCg9YwnScIrrwisv9HimXUi07UtBQ+rsVr0mn0AH5n83MGB7S+pR5hhWkuKzbf7KEHvXmc8F59pqb0IyAz8/lUyBoGr33y3SAoUCf/mRwn3/QTLjloWEtJcH7O2Omtx34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vWXQOpo2; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vWXQOpo2"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4315abed18aso41075705e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 20 Nov 2024 09:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732123115; x=1732727915; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BrN4jnx/DXfC0UwxYbDC3cvmXnvAO37Xv/dCbsQ/GeY=;
        b=vWXQOpo2XUhZ+fXAQO4rZCblnLrUgkrSQi+LH+wmkB6GOMr6c/dAgajyeCIK7RHgjR
         5kfYcPbICuVrYDurybC9AnirbdK+MVQ2CCu/1MMcGd5mJpNitYx3pYwgC3fHEQtLy3jI
         4rEy2UvFF0R55aTJjpjgoAA5jhhieKxrcn5A4ST/ZQQsck394oSVBP8XJ+TMWN2wOSUk
         bBPN34c3yXTh4pEailHi9d2Cdh+BbRSHBQTQPp0BaXg7k7DMEkVHGr/MsgJ6EgpHJDCu
         fGaXARzaigh1pL2CRLoFj3e05uMtiAZ8gafoxJXZm7iEkCmP8IUagn63om+rhdjDs/hZ
         cZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732123115; x=1732727915;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrN4jnx/DXfC0UwxYbDC3cvmXnvAO37Xv/dCbsQ/GeY=;
        b=qTF3K8t+F930qrTqXddZLRkKpkhD8qkN1s7oTEG/J3zJ0kvbbSt7uzUMXhP93dxQX1
         rCxxSO8d+Zey1BbltwKbtLpTmhAfemhE1O80NDJKYNzyp95ARiz7fiToya1+vg4Zwrpv
         r6cRSIe3RCZBpeOD9ouDQgAtPpxKPtEa51qTM0nTXn83/PFm+LpqUFCtuZmqycCAa3cb
         K3iH6zsk6zn/vS2Ia5pZ6xCSrQJZSvK3E5x8bBigVuVbE3p7cej/r0DmV9tPisZxlr9P
         9suESETZCYf/3f9GeJsZlyAuTsUiZKwn9Js25H5fG/2mjSCjTN80NbpO6XE98WPbI/nT
         cmlQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4kLVULRn5kOD26ridDakMwWY7dIPzuLbiaoIGPAPm88Zfv25LYb6Y2UuNICRVnAOO4JlAJWFG+ZWt@vger.kernel.org
X-Gm-Message-State: AOJu0YzwQrxqxpVlQ0mu4cexL7sugkeOsn6F9lKqwTd4zRGXPl7WbdMA
	85zL3yXKAnMPK+LdpmDYHncX3oAWuYtKSATX+ufPQgxzQfYJ1HTQeQtcrw/lTLU=
X-Google-Smtp-Source: AGHT+IEMl+Umzt9pfPJny9A4FApXoCusklewOWpxImV08bteT+GtUrMqokXLGrs0BQncUmJ0q6YgKA==
X-Received: by 2002:a05:6000:4029:b0:382:4978:2aaf with SMTP id ffacd0b85a97d-38254b259f0mr3136310f8f.57.1732123115553;
        Wed, 20 Nov 2024 09:18:35 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825493ee14sm2541451f8f.99.2024.11.20.09.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 09:18:34 -0800 (PST)
Date: Wed, 20 Nov 2024 20:18:31 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] smb/client: Prevent error pointer dereference
Message-ID: <e0addd3d-2687-4619-8f47-4d8ff13950a7@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The cifs_sb_tlink() function can return error pointers, but this code
dereferences it before checking for error pointers.  Re-order the code
to fix that.

Fixes: 0f9b6b045bb2 ("fs/smb/client: implement chmod() for SMB3 POSIX Extensions")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/smb/client/cifsacl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index c68ad526a4de..ba79aa2107cc 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1592,14 +1592,16 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	struct smb_ntsd *pntsd = NULL; /* acl obtained from server */
 	struct smb_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
+	struct tcon_link *tlink;
 	struct smb_version_operations *ops;
 	bool mode_from_sid, id_from_sid;
-	bool posix = tlink_tcon(tlink)->posix_extensions;
 	const u32 info = 0;
+	bool posix;
 
+	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
+	posix = tlink_tcon(tlink)->posix_extensions;
 
 	ops = tlink_tcon(tlink)->ses->server->ops;
 
-- 
2.45.2

