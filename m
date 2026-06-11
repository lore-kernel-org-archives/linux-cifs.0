Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321F23BAD9C
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 08:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168388; cv=none; b=arCLuH1duyPWkaA4NsL9rokLqb93Fnv/+cKacSkoZhY4PYP5Hv4i5Ph1Qsjagpcki/wLE+yF7BTCQQZzil1D3HiDXa1TlPmIhViY97TuAmjInY3E5U2f7cXfSWUrcB8lxz7WuYKUsaLPOctBrWh0tSLU/Xxg3VXnbfFdoeAr4s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168388; c=relaxed/simple;
	bh=dcJ3PXExx3tLRItSKrdzU5Pex5Yi6Pv27mfuxht5MF0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=V6huNiqNMIHJRuojtsoG+PofGEaQWmCRlFLgiho8fO94nWggZn1kIbH9a6Vo/YqvN0PyZkrVrxI8U75z/JZac+MaS8w/D35HzeIsrFvdK7rbsMHHPnIMNyBIghJ9PQFK5Xl9cRwCfYWVjfn2XSXpDjZMXPYH5RGdmcnbMFqTvaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NYE55Qki; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NYE55Qki"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8d18de80b29so9483936d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 01:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781168386; x=1781773186; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HEF1tsyp6Y8hUnEjMhRhxS04+FM5QLYCbrwdZPmmq1U=;
        b=NYE55QkiClyMscHxeJZdojnSldFhuK+Zuwfh4CxQF7psAA9JXTzvofEvE4Le5QsiqE
         MRVW+joXpwG53Y+cfCfRkwXkEfd7+9PEDMKjGy6qM0oGGQMyyeXU2d9E61S8H/M51ocj
         m4cKEtlOemIa06FL0npIJZxI65jPpcntDckiheFE8JlfJVlaW9nBjUiqEyDG352MvQmS
         HziPT9kmFkVtszWLHxeorvZmLdcOzG/AyCtAXnzviShr4nttmo+RZ5UJWvPTYYUY3isS
         laeFMur8mEcUmY2YxStCBC/CBDbvGgZ7AVuBHhapBJ/eM18xkAGVBzu4cKjbxzOTLy2W
         y4Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781168386; x=1781773186;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HEF1tsyp6Y8hUnEjMhRhxS04+FM5QLYCbrwdZPmmq1U=;
        b=eYlV7mFSYLSq67eoV1M5Dqw/uqna/+QiwMPfHQIvAbWklr53fupIOckYB/folDll7U
         5R8V1wDxe86BcJA8MTvimqNoVJhcIwYGc+TWcn+X+TqCBU7NdvYNL2wRHUZkYjpCLuDX
         CqXDQmIa6rc8gSzgY8V9wlOhObhof27zNyEW4GS0EWrmY4cf7zF6BK76h8LyOHgugDXq
         JgY7sW6Y4PSRzHK805yszhJoHxJRrmuob2vlLC1IxZ2Pq3TlyofBKEFhIHEflsJY+VrH
         S52dTom1s1g3ewSg9IApPAJ3JiCGJqB7r7gkDV6C5dLeHc/cCpzwuAD/oeAgmhKZw0lT
         Dxtw==
X-Forwarded-Encrypted: i=1; AFNElJ9OHuphbVfhI/9xAi1wARP1/bkFjeHFA9TtDucVLzrIWtUcLgwvTaG6WCWwtn8EBsuo/7dfc5FOxswz@vger.kernel.org
X-Gm-Message-State: AOJu0YwF2H2VXuP00IeUz8Qq5i/l3L8dr7bdgblKR+VMjbjHZ8pZxIbL
	XyRj4ZVtIKLWW2rQf/9TyW6EuGm+kq143FV74pTx0z/LOtwEbMmA2w/s
X-Gm-Gg: Acq92OE4B3OQhVzsGAJIjp6g1wh0PzZpCSXnwnthx0bQx05YhXoxAV1Pyx6sm9BP4av
	m6r8zZGY2hwdpQrNBVY7VYx3Jdl6ShXjOLcOjq4rpfARKWlF3SNxsPh/l8PjCyMYQfKsVMy+uxf
	kfPMVEZw4MgqBtqgymNvawSIRBh4/ACgO1uy/YmbQ/becgqZrtjUWrSvMAWR+/zeASpNy7H/0u4
	cReTVU6P3JzmqUynMgiFf1eGejA4NDKOenFl/gY+jvf/VrRHDUDTZSYV37ITfZ+3MeXsXvNu8qk
	uIx+fPGxjOR2BJIs2zvLvMPJojPjpa/vQ4ByE2h29AZ57u4RRx8Fje50DYvM0+xkkoq4RYRxe+3
	7+1Shfi3oK5f++7+biIp2jQIWYb11nV3aa9MXCayK2BuikpLtwBPqq/fIYoDIpTyS7iObJogAkr
	RXI68nkipWLjJAg4Mpt0NA6JPfXHM=
X-Received: by 2002:a05:6214:5c06:b0:8bd:3440:c024 with SMTP id 6a1803df08f44-8d1e23e6148mr21562146d6.15.1781168386189;
        Thu, 11 Jun 2026 01:59:46 -0700 (PDT)
Received: from localhost ([149.40.50.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d1eada9cb3sm12049786d6.33.2026.06.11.01.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 01:59:45 -0700 (PDT)
Date: Thu, 11 Jun 2026 10:34:51 +0300
From: Dan Carpenter <error27@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] smb/client: clean up a type issue in cifs_xattr_get()
Message-ID: <aiplG8fGQOYmXS5g@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The cifs_xattr_get() function returns type int, not ssize_t so
declare "rc" as int as well.  This has no effect on runtime.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 fs/smb/client/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 23227f2f9428..5091f6c0d7fe 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -272,7 +272,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 			  struct dentry *dentry, struct inode *inode,
 			  const char *name, void *value, size_t size)
 {
-	ssize_t rc = -EOPNOTSUPP;
+	int rc = -EOPNOTSUPP;
 	unsigned int xid;
 	struct super_block *sb = dentry->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -354,7 +354,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 				inode, full_path, &acllen, extra_info);
 		if (IS_ERR(pacl)) {
 			rc = PTR_ERR(pacl);
-			cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
+			cifs_dbg(VFS, "%s: error %d getting sec desc\n",
 				 __func__, rc);
 		} else {
 			if (value) {
-- 
2.53.0

