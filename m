Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFDA448396
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518043; cv=none; b=Hmmp6n+QYMrRSyeHS1otWlE3qsfwCuSu7dZiXmrPtOyywtz5zA0CodWyKDJsaQLcmRkypeom3TdG0SvGGm2e3L+n4WFmC+AqDEXo+pz2dllap1/f3V42YmACpq6iFGWf500qs0eGi8+NBP73KzbUaVWmlV8rNTTNsRMy+YcKuQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518043; c=relaxed/simple;
	bh=yCiJM9M7OSxRZ2pR6LXvazE152Qlgq079HQBiwdxZsA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPSijgM6Q/mxPAWULYdyoSSlvLo7hBzmKaNMwu6+Mr7vYqNXSVIgpKSwCZlNhxXFdyHpibh7QasWuBTuHO8goV69cTYdYsVACt3DbFvCtL+5TGDSl6kuy4k9ecnawOlIQEi21NsAhtiMmCyY518eblRv5gWbN+MZGPqZdogcIQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EPP6CuX3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D+jnfqwm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EPP6CuX3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D+jnfqwm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785518040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ec2YztIOmCfQ6RjUNNYXDrx+f1Ba6t2+VTVM8hBlTs4=;
	b=EPP6CuX3+BocCEGIifeBzfZwJL9BXi0j/JRjE2bv8HwqjyjXoN8nUABxAhV0rs7zZEMdp8
	DGYdxnzwMt3nryxgLt0rH1ZxxRecTVssQQFqp0p6nfgVCocIbVY5GtPaun/UyR2yBAr4dG
	2fJX4u2VrVGaW3Q/Q2QIvdZUEopA+iU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-m069Vlq3M4yuVHmJyQ7qLQ-1; Fri, 31 Jul 2026 13:13:59 -0400
X-MC-Unique: m069Vlq3M4yuVHmJyQ7qLQ-1
X-Mimecast-MFC-AGG-ID: m069Vlq3M4yuVHmJyQ7qLQ_1785518039
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51bec738909so9131641cf.1
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 10:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785518039; x=1786122839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ec2YztIOmCfQ6RjUNNYXDrx+f1Ba6t2+VTVM8hBlTs4=;
        b=D+jnfqwmOyL8/elH4ux4zrJOEmgnCZ7kXhZExjNLK3ThSz7UAOmysyK6PHPXkJjUGD
         RJncEQ33sF1YSeUZV77dyOub3T+9Hjt5+Oqw3BxNk4CtqgriE1rdC7qt4XQkOAr7/Iku
         2Z2ErcUqn77D01+7M8tT8SYQds+xDydeuQ1lT/F1WVWB6H6n6yqTOXZ0XOF+ghU1Z6pV
         L4kX536IJy8iJVgd5x6tUD5XxLtHzdgK080dKE7nZjWsX7AAN70nvbVxCAfQv9+tjX9z
         vN7dNlDmuTonMN18P3vanBYcrKdmbZCSOrfTx6MvMR1pOmcphQGH7xnITdQmG8riue1+
         nSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785518039; x=1786122839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ec2YztIOmCfQ6RjUNNYXDrx+f1Ba6t2+VTVM8hBlTs4=;
        b=nQEEt0YySOa6JHzrL6MP2EEk8Du7JA0O2wLYcxBfGmCfKEqfoHUxmOPwMTXwTZKUTN
         kHA/Gzo54XA6IYoiW7wxDI3fjbOzt5CRMLnaPWEdpWZcyc2tiXCWrwr/vpQyfJu5oNAq
         KpNpYXGhJO7v9Mm2fq12g7YLzt3/DyxZLOF/hrWWJJm011D9k2JWrdbQc3IjgQvGLHst
         0ZYk3SKXhrwQIsaOg73kGy2s6lZsxJoXXJbMXlJmRleskDcnUBOXoBQqr3d13zSaOqdZ
         hZ5nqbf7x0x7RE3QcI3IiY6fr/9huFNmbkmmodqZA+vUAEkJGSFL4repVwPUBCHaLq28
         hsrA==
X-Gm-Message-State: AOJu0Yw78S2gBhRHUsKtkucf6oWjbrOSxpeSB7qp3zCj/8JcAJGWiRAA
	s5HSf/q3xKOCtz6cuVD7mYfjhgLwworQjNtpFYtOqpKP66h/DkIRFE1KVe1WvTEKIy76W8AxqyJ
	WE2yL7X1P9JL2KuStpIsnPIPjHDqqmPRFG9ZdrUZsmN/njjHZIDHht/BGjCvg324bMLHaovIekS
	elg84V8nKtbC3Vu/zwJOLt+W5Q4TTD8XKe00R/iQIaZ7fnjgE=
X-Gm-Gg: AR+sD11nJFHwlav1Dgn8UH2SasSgE/FvFm8jTYGsqgyh3kWj1q/9qcnk6lJ4QZYU0fI
	pI5s0SDbpwuqz6sjZBB383A9cx4ke6t9UdN+Awh4c80oj0uvwgRlgaZnjCtRZxgoRjGdPAwwQdV
	kmQMGKfS3n2IKu245RgmB9woW7vq3Q7EO5IROnW8kGeDA3iiNSwpTzkDSFIOpJ4XnoBwk6sCMNx
	9GvHBl6q+u83UgL3OXQRbUW/2iwZhLubTNR2Iv/nj0dfBrxQ+5PRtxqAlAD9XU9ZeFH9Z0TnGrS
	VcRMwBIBK9TahVdvWWZ+9efdKq42PQz1HEfs/MiME0K//Eq4GsZvxlTDQAiA6HEsiYlM6kaJ7Q8
	3W4RJ4/I8m7dSQDdlar3NJYimXLx60Jy+xEXOJ8iKtRCWec+9DXIImudMR0wu
X-Received: by 2002:a05:622a:98f:b0:51c:167d:b346 with SMTP id d75a77b69052e-52b5674fab4mr20034281cf.23.1785518039133;
        Fri, 31 Jul 2026 10:13:59 -0700 (PDT)
X-Received: by 2002:a05:622a:98f:b0:51c:167d:b346 with SMTP id d75a77b69052e-52b5674fab4mr20033341cf.23.1785518038351;
        Fri, 31 Jul 2026 10:13:58 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908434a250csm14676316d6.13.2026.07.31.10.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 10:13:47 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com,
	hehuiwen@kylinos.cn
Subject: [PATCH v3 4/4] cifs: remove dead size-update blocks in cifs_setattr_unix/nounix
Date: Fri, 31 Jul 2026 12:12:31 -0500
Message-ID: <20260731171231.686427-5-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731171231.686427-1-sorenson@redhat.com>
References: <20260731171231.686427-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 110fee6b9bb5 ("smb: client: fix missing timestamp updates with
O_TRUNC") introduced cifs_file_set_size(), which calls netfs_resize_file()
and cifs_setsize() on success.  cifs_setsize() calls i_size_write(),
updating i_size to the new value.  The subsequent blocks in both
cifs_setattr_unix() and cifs_setattr_nounix():

    if ((attrs->ia_valid & ATTR_SIZE) &&
        attrs->ia_size != i_size_read(inode)) {
        truncate_setsize(inode, attrs->ia_size);
        netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
        fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
    }

are therefore unreachable on the success path: attrs->ia_size ==
i_size_read(inode) always holds after cifs_file_set_size() succeeds.
On the failure path, execution jumps to out/cifs_setattr_exit before
reaching these blocks.

truncate_setsize() and netfs_resize_file() are redundant with what
cifs_file_set_size() already did; fscache_resize_cookie() was moved there
by commit fa724e235cfd ("cifs: add fscache_resize_cookie() to
cifs_setsize()").  Remove both dead blocks.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/inode.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index eaf27a9cf4f5..10a3322e89aa 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3306,13 +3306,6 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	if (rc)
 		goto out;
 
-	if ((attrs->ia_valid & ATTR_SIZE) &&
-	    attrs->ia_size != i_size_read(inode)) {
-		truncate_setsize(inode, attrs->ia_size);
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
-	}
-
 	setattr_copy(&nop_mnt_idmap, inode, attrs);
 	mark_inode_dirty(inode);
 
@@ -3518,13 +3511,6 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (rc)
 		goto cifs_setattr_exit;
 
-	if ((attrs->ia_valid & ATTR_SIZE) &&
-	    attrs->ia_size != i_size_read(inode)) {
-		truncate_setsize(inode, attrs->ia_size);
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
-	}
-
 	setattr_copy(&nop_mnt_idmap, inode, attrs);
 	mark_inode_dirty(inode);
 
-- 
2.55.0

