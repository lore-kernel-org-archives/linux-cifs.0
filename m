Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD98624338F;
	Mon, 18 Aug 2025 14:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755528008; cv=none; b=Z5I4OOUlr1J9J6TKNswDuxjT/34K1YIkAXHBEctIm4GgkV33GSKMLNa7nCmijS6BJAtXGHx4dYlG1F+r6ynhrnziZSq7MI43GZfY7ouXxQM72nISM3ZPse4v4Kg/ditO/3GN8LjvGQ965kyJOY4UE5v5CbrckY34+aR04PPcw5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755528008; c=relaxed/simple;
	bh=11O/TvrTRI175G+9lRTft0c8RV3U/VtLE5KJr9noW9w=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=bGtKg03v8hjBmpR6ggNhCo52veM2MmbP68TGEv3INTxENa15k28StBXtRdW57yWtIoCa2fKeUihy7TrMc9MIxINsEe3lJ1owL9itaauhuzvHcTniGLgaFmQx8i8lVHJt7IiKJKK2zMSE6pVnhFmyB6v79OiR/2+0bTrr+5NOBV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=1LRZ+INq; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="1LRZ+INq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=78+Iu2uSbmJaMmYelyttGEPPOR7pghAVUB7MS14cwzY=; b=1LRZ+INq2fVasxA8cdFDiQOsgL
	+zHlkQ0VsBIHNw9Ac4wuKcT2sr38vJ/VQrGt2o8pDb3TPP0yriB0RemEtGkn7b8twSUopvQtR3hqu
	YP5y3lZgnUloBDtkIQufRPeqC5E/bJHgoMghnOV0YBbKURK5nXMhFETgnGfhCig3g+NeECRXtTn5L
	eruiYfjc88OMVVEfbes+vRyZqdTAjEkjRBzDeNJfQT+hbVLjRDj7qHqtZLvwcKGbERbUgxgEm3c+N
	Xn6idu+sGNIcKNvXQlpEgHINfFBGKW/fLHIRI+7gY6vdNjJo+zMVd+WOKCNLnKBbeCCUJN4E6PJTJ
	nsZjIGog==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uo11h-00000000OKq-2tHI;
	Mon, 18 Aug 2025 11:39:57 -0300
Message-ID: <b3967fbbe442787c3f0d735d257f218a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>, sfrench@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, chengzhihao1@huawei.com,
 yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v4] smb: client: Fix mount deadlock by avoiding super
 block iteration in DFS reconnect
In-Reply-To: <20250815031618.3758759-1-wangzhaolong@huaweicloud.com>
References: <20250815031618.3758759-1-wangzhaolong@huaweicloud.com>
Date: Mon, 18 Aug 2025 11:39:52 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Wang Zhaolong <wangzhaolong@huaweicloud.com> writes:

> An AA deadlock occurs when network interruption during mount triggers
> DFS reconnection logic that calls iterate_supers_type().
>
> The detailed call process is as follows:
>
>       mount.cifs
> -------------------------
> path_mount
>   do_new_mount
>     vfs_get_tree
>       smb3_get_tree
>         cifs_smb3_do_mount
>           sget
>             alloc_super
>               down_write_nested(&s->s_umount, ..);  // Hold lock
>           cifs_root_iget
>             cifs_get_inode_info
>               smb2_query_path_info
>                 smb2_compound_op
>                   SMB2_open_init
>                     smb2_plain_req_init
>                       smb2_reconnect           // Trigger reconnection
>                         cifs_tree_connect
>                           cifs_get_dfs_tcon_super
>                             __cifs_get_super
>                               iterate_supers_type
>                                 down_read(&sb->s_umount); // Deadlock
>     do_new_mount_fc
>       up_write(&sb->s_umount);  // Release lock
>
> During mount phase, if reconnection is triggered, the foreground mount
> process may enter smb2_reconnect prior to the reconnect worker being
> scheduled, leading to a deadlock when subsequent DFS tree connect
> attempts reacquire the s_umount lock.
>
> The essential condition for triggering the issue is that the API
> iterate_supers_type() reacquires the s_umount lock. Therefore, one
> possible solution is to avoid using iterate_supers_type() and instead
> directly access the superblock through internal data structures.
>
> This patch fixes the problem by:
> - Add vfs_sb back-pointer to cifs_sb_info for direct access
> - Protect list traversal with existing tcon->sb_list_lock
> - Use atomic operations to safely manage super block references
> - Remove complex callback-based iteration in favor of simple loop
> - Rename cifs_put_tcp_super() to cifs_put_super() to avoid confusion
>
> Fixes: 3ae872de4107 ("smb: client: fix shared DFS root mounts with different prefixes")
> Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> ---
>
> V4:
>  - Perform a null pointer check on the return value of cifs_get_dfs_tcon_super()
>    to prevent NULL ptr dereference with DFS multiuser mount
>
> V3:
>  - Adjust the trace diagram for the super_lock_shared() section to align with
>    the latest mainline call flow. 
> V2:
>  - Adjust the trace diagram in the commit message to indicate when the lock
>    is released
>
>  fs/smb/client/cifs_fs_sb.h |  1 +
>  fs/smb/client/cifsfs.c     |  1 +
>  fs/smb/client/cifsproto.h  |  2 +-
>  fs/smb/client/dfs.c        |  4 +-
>  fs/smb/client/misc.c       | 84 ++++++++++++++------------------------
>  5 files changed, 35 insertions(+), 57 deletions(-)

Thanks for fixing the NULL ptr deref issue.

This patch still introduces a regression when reconnecting tcons
created in multiuser mounts by cifs_construct_tcon().  That is,
cifs_sb_info::prepath will not get updated in tree_connect_dfs_target()
because @cifs_sb will be NULL when calling cifs_get_dfs_tcon_super() on
non-master tcons.

Currently only master tcons will have a pointer to the superblock, which
is set in mount_setup_tlink().  You'd need to set superblock pointer to
all tcons in order to make this work.
