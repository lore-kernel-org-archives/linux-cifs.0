Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357572EACF2;
	Sun,  2 Aug 2026 14:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785682432; cv=none; b=oniYftxxWUOqXhA7vdOP6WfS8CVg9/RnsICv5mOMTqxtpX0Ncaz4kpBduPGw/tz6IGWMl+5x6SxcnNFa1/YdyWoNRztk5h8pADi1loGmZHR1jAPlPIDSPMexQlHytY/M08V8UOV198Xxa4l84iQ2JAO9T28Bx+IQxNUauMKV+nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785682432; c=relaxed/simple;
	bh=LLAzRn4a9t4oBmB3W2+OT9K/zMeSRYK1KSy7LRr1xDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VTrMzSjRNJsHFnd45LAFVfaqpUyhFp+nyX5kidI+v+AdwLMIVMgUlQsjySgmBRzNe0vSeBfIGzcBfxvSFDeQfgAbSDLMBgYtG0CowcgjQUycLbHlG8SvqyxrxIKnXbftYFp6YyspkKWqm8mLGJFnN2ymYax3bar/Aq1CjhMz9fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f2d528b68e8111f1aa26b74ffac11d73-20260802
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:03155c6a-c569-4f71-809e-3feaae1f0382,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:03155c6a-c569-4f71-809e-3feaae1f0382,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:713f0967646e648f13a2e527c7c80a01,BulkI
	D:260802225342ZK4K35E5,BulkQuantity:0,Recheck:0,SF:10|38|64|66|78|80|81|82
	|83|101|102|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File
	:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DK
	R:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f2d528b68e8111f1aa26b74ffac11d73-20260802
X-User: hehuiwen@kylinos.cn
Received: from [192.168.0.11] [(220.202.211.78)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 763641056; Sun, 02 Aug 2026 22:53:40 +0800
Message-ID: <c28720bc-a39b-4d99-aa78-6138104bb0a2@kylinos.cn>
Date: Sun, 2 Aug 2026 22:53:37 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] cifs: add cifs_resize_file_locked() to guard
 fscache_resize_cookie() under i_rwsem
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org,
 pc@manguebit.org, stfrench@microsoft.com
Cc: stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.com>
References: <20260731153500.660569-1-sorenson@redhat.com>
 <20260731153500.660569-3-sorenson@redhat.com>
Content-Language: en-US
From: Huiwen He <hehuiwen@kylinos.cn>
In-Reply-To: <20260731153500.660569-3-sorenson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

LGTM

Huiwen

在 2026/7/31 23:34, Frank Sorenson 写道:
> cifs_setsize() calls fscache_resize_cookie() without holding i_rwsem.
> When the fscache cookie is active (FSCACHE_COOKIE_IS_CACHING is set),
> fscache_resize_cookie() performs a real resize that requires i_rwsem
> held exclusively.  If another file descriptor has the same inode open,
> fscache_use_cookie() was already called from that cifs_open(), making
> the cookie active.  In that case, calling cifs_setsize() from
> cifs_do_truncate() (invoked from cifs_open() without i_rwsem) races
> against concurrent fscache I/O.
> 
> Strip fscache_resize_cookie() from cifs_setsize(), making it a pure
> size/page-cache helper.  Add cifs_resize_file_locked() for callers
> that already hold i_rwsem: it calls netfs_resize_file() and
> cifs_setsize(), then temporarily activates the cookie with
> fscache_use_cookie() to perform the resize under the lock, then
> deactivates it with cifs_fscache_unuse_inode_cookie().  Using
> fscache_use_cookie() before the resize ensures correctness whether or
> not another fd already holds the cookie active.
> 
> Switch cifs_file_set_size(), smb2_duplicate_extents(), and both size-
> extension branches of smb3_simple_falloc() to the new wrapper; those
> paths already hold i_rwsem via VFS setattr, lock_two_nondirectories(),
> or cifs_fallocate() respectively.  cifs_do_truncate() continues to
> call cifs_setsize() followed by cifs_invalidate_cache(), since it runs
> without i_rwsem.
> 
> Fixes: fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()")
> Cc: stable@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Cc: Paulo Alcantara <pc@manguebit.com>
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> ---
>   fs/smb/client/cifsfs.h  |  1 +
>   fs/smb/client/inode.c   | 24 +++++++++++++++++++++---
>   fs/smb/client/smb2ops.c |  9 +++------
>   3 files changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index 854e672a4e37..651670c19c2b 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -147,6 +147,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid, struct file *src_file,
>   
>   long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg);
>   void cifs_setsize(struct inode *inode, loff_t offset);
> +void cifs_resize_file_locked(struct inode *inode, loff_t offset);
>   
>   struct fs_context;
>   struct smb3_fs_context;
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 0afff761aab9..eaf27a9cf4f5 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -3059,7 +3059,26 @@ void cifs_setsize(struct inode *inode, loff_t offset)
>   	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>   	truncate_pagecache(inode, offset);
>   	netfs_wait_for_outstanding_io(inode);
> -	fscache_resize_cookie(cifs_inode_cookie(inode), offset);
> +}
> +
> +void cifs_resize_file_locked(struct inode *inode, loff_t offset)
> +{
> +	struct fscache_cookie *cookie = cifs_inode_cookie(inode);
> +
> +	lockdep_assert_held_write(&inode->i_rwsem);
> +
> +	netfs_resize_file(netfs_inode(inode), offset, true);
> +	cifs_setsize(inode, offset);
> +
> +	if (!cookie)
> +		return;
> +
> +	fscache_use_cookie(cookie, true);
> +	fscache_resize_cookie(cookie, offset);
> +	cifs_fscache_unuse_inode_cookie(inode, true);
>   }
>   
>   int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
> @@ -3125,10 +3144,8 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
>   	cifs_put_tlink(tlink);
>   
>   set_size_out:
> -	if (rc == 0) {
> -		netfs_resize_file(&cifsInode->netfs, size, true);
> -		cifs_setsize(inode, size);
> -	}
> +	if (rc == 0)
> +		cifs_resize_file_locked(inode, size);
>   
>   	return rc;
>   }
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 192649fec25d..0e872d58fae7 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2222,8 +2222,7 @@ smb2_duplicate_extents(const unsigned int xid,
>   		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
>   		if (rc)
>   			goto duplicate_extents_out;
> -		netfs_resize_file(netfs_inode(inode), dest_off + len, true);
> -		cifs_setsize(inode, dest_off + len);
> +		cifs_resize_file_locked(inode, dest_off + len);
>   	}
>   	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>   			trgtfile->fid.volatile_fid,
> @@ -3776,8 +3775,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>   			}
>   
>   			new_eof = off + len;
> -			netfs_resize_file(&cifsi->netfs, new_eof, true);
> -			cifs_setsize(inode, new_eof);
> +			cifs_resize_file_locked(inode, new_eof);
>   
>   			qrc = SMB2_query_info(xid, tcon,
>   					      cfile->fid.persistent_fid,
> @@ -3825,8 +3823,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>   		if (rc)
>   			goto out;
>   
> -		netfs_resize_file(&cifsi->netfs, new_eof, true);
> -		cifs_setsize(inode, new_eof);
> +		cifs_resize_file_locked(inode, new_eof);
>   
>   		qrc = SMB2_query_info(xid, tcon,
>   				      cfile->fid.persistent_fid,

