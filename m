Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A213164A9;
	Wed, 29 Jul 2026 04:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298849; cv=none; b=bfXdqMMABrKcvvW5b9fPAPQzxrK9v2nG9iJtUCcNEOTFZUXN+xxjXMc2Zyxbiclt10/9sB2VwfAVyjx0gfkTpfsIAF4hgYtlERA81EcTPr9Jcv2oEt1F7ciVeiZ+/mgWvzSp5rYLVy6JbrNmL67IXW61CrF//vMJYdBkYoWNs+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298849; c=relaxed/simple;
	bh=KbFoWHORfbaDJP/h9zMacAEfKhRqjh6J0SinTK7R0Lw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DMYEyxDgri9c3MuBAI9NtPXp80QVOiWPo1hcjwwvQpBDaa/5PgM8QDhQL1YFMmvF7ix+UMxMdPMjEZoQQxHHGnD7uZiSKqaoduNBqqDDapRqIw/RVG0/bVecj4Cc3rkP3lXh647hhm4w2n3kKVSPWQYXHd8Ks0fpqYY0Z+Nyuzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d54463aa8b0411f1aa26b74ffac11d73-20260729
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:20b8fe6b-6472-406e-9b0b-e513db579a74,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:20b8fe6b-6472-406e-9b0b-e513db579a74,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:b2bed71282ffd320fb00993d90cff2af,BulkI
	D:260729122034ZA8ET0WW,BulkQuantity:0,Recheck:0,SF:10|38|64|66|78|80|81|82
	|83|101|102|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File
	:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DK
	R:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d54463aa8b0411f1aa26b74ffac11d73-20260729
X-User: hehuiwen@kylinos.cn
Received: from [192.168.3.165] [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1708535126; Wed, 29 Jul 2026 12:20:29 +0800
Message-ID: <b21c1885-a46c-44d5-9b20-2b0072a3b50d@kylinos.cn>
Date: Wed, 29 Jul 2026 12:20:04 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] cifs: use cifs_invalidate_cache() in
 cifs_do_truncate() for O_TRUNC
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org,
 pc@manguebit.org, stfrench@microsoft.com
Cc: stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.com>
References: <20260728211438.3859107-1-sorenson@redhat.com>
 <20260728211438.3859107-2-sorenson@redhat.com>
Content-Language: en-US
From: Huiwen He <hehuiwen@kylinos.cn>
In-Reply-To: <20260728211438.3859107-2-sorenson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Frank,

Patch 1 handles the quiescent-cookie case, but the cookie is not
guaranteed to be quiescent here: another open may already keep it
active. In that case, cifs_setsize() may still call
fscache_resize_cookie() without i_rwsem before the invalidation.

Maybe we could keep cifs_setsize() as the basic size/page-cache helper
and add a wrapper for the paths holding i_rwsem, for example:

   /* Caller must hold inode->i_rwsem for write. */
   void cifs_resize_file_locked(struct inode *inode, loff_t offset)
   {
   	struct fscache_cookie *cookie = cifs_inode_cookie(inode);

   	lockdep_assert_held_write(&inode->i_rwsem);

   	netfs_resize_file(netfs_inode(inode), offset, true);
   	cifs_setsize(inode, offset);

   	if (!cookie)
   		return;

   	fscache_use_cookie(cookie, true);
   	fscache_resize_cookie(cookie, offset);
   	cifs_fscache_unuse_inode_cookie(inode, true);
   }

cifs_file_set_size(), smb2_duplicate_extents(), and both
smb3_simple_falloc() branches could use this wrapper, since those paths 
already hold i_rwsem. O_TRUNC could continue to use cifs_setsize()
followed by cifs_invalidate_cache(), without attempting a resize.

Patches 2 and 3 look good to me.

Thanks,

Huiwen


在 2026/7/29 05:14, Frank Sorenson 写道:
> cifs_setsize() now calls fscache_resize_cookie() since commit
> fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()").
> However, cifs_do_truncate() is called from cifs_open() before
> fscache_use_cookie() activates the cookie, so the fscache cookie is
> still quiescent at this point.  fscache_begin_operation() requires
> FSCACHE_COOKIE_IS_CACHING to be set and returns failure for a quiescent
> cookie, making fscache_resize_cookie() a null operation in this path.
> 
> The correct fix for this path is cifs_invalidate_cache(), which calls
> fscache_invalidate().  Unlike fscache_resize_cookie(), fscache_invalidate()
> works on quiescent cookies: it unconditionally increments inval_counter
> and sets FSCACHE_COOKIE_NO_DATA_TO_READ, ensuring that stale cached data
> is not served once the cookie is later activated by fscache_use_cookie().
> 
> Truncation to zero leaves no valid cached data, making invalidation the
> correct semantic.  No inode lock is required for cifs_invalidate_cache().
> 
> Fixes: fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()")
> Cc: stable@vger.kernel.org
> Cc: Huiwen He <hehuiwen@kylinos.cn>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Paulo Alcantara <pc@manguebit.com>
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
>   fs/smb/client/file.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index ac89c1ba56b1..389083f9ce00 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -1016,6 +1016,7 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
>   		if (!rc) {
>   			netfs_resize_file(&cinode->netfs, 0, true);
>   			cifs_setsize(inode, 0);
> +			cifs_invalidate_cache(inode, 0);
>   		}
>   	}
>   	if (cfile)

