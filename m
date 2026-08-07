Received: from out-182.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED63377EC3
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 10:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786098537; cv=none; b=NXe6hH0+1a/tOm8PbEUcC0llNusAwKfAZvHPDJmXrWF9V1Ok431+qRftNxGSTbjz/FaSIRUs6f8ZbHuwHGsHggROTwmPcT2fAM0Af00WnhMl9T+8ZyojsMKWbugu1tVqg4SmpGBmQRobAzuyGdwhAy+4RdQT+ncWsnIweZBHeEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786098537; c=relaxed/simple;
	bh=9JUugPsARtC0yI78qKn+gHZT3tGgRVR8XbeXteLnehI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=j9rfEJdjNjBhDzez6Hg+cwWOV1Zdgm8PesWm88O5MyfXruGRWG1QD/H02sIuzUPaND9DllE73z1Re/3NtsiHG2nYe3CPDkzkG1dezPS5xFLQodIeXAtTIrp1uCkjcBA/zVj5GMPJ9GJ3cl+AZO7Il5g0ZGvgy/Kyp0I3zchHbfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BkuQErWj; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BkuQErWj"
Message-ID: <db018269-4591-4d37-8e6d-93a4942fde46@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786098532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o2YANFts15eLSZuHyOUj11JNrPtaIOfwvg6g+XGC0Ow=;
	b=BkuQErWjFvAqlH/UWSSoXCaIq+Vx9KrUuGedbghLo/visC5IHbinBS3+0JYceLBm5rFNmt
	4n1EnB5DtBesLg4rx1xQsurOpqDSW4lXXK21J4LFxNF0IF1rjJL75JOmTAkSUmR8szCPXM
	0KyMlYrhkkf3J6VAwvU/VIC8ugx9pNE=
Date: Fri, 7 Aug 2026 18:27:50 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
Subject: Re: [PATCH v3 resend 3/3] smb/client: fix nlink of an overwritten
 open file
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org, slow@samba.org
Cc: linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
 <20260805051112.305078-4-chenxiaosong@chenxiaosong.com>
Content-Language: en-US
In-Reply-To: <20260805051112.305078-4-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The AI review of the overwrite rename patch raised two possible races.

1. A handle opened through a surviving hard link may be marked deleted:

   target_fh -- target --+
                         +--> inode X (nlink = 2)
   alias_fh  -- alias  --+

   CPU A                                   CPU B
   -----                                   -----
   rename(source, target)
     server nlink: 2 -> 1

                                           statx(alias,
                                                 AT_STATX_FORCE_SYNC)
                                             cached i_nlink: 2 -> 1

   cifs_mark_open_handles_for_deleted_file()
     sees i_nlink == 1
     marks every handle:
       target_fh: deleted                   correct
       alias_fh:  deleted                   wrong

2. A concurrently refreshed link count may be decremented again:

   CPU A                                   CPU B
   -----                                   -----
   rename(source, target)
     server nlink: 2 -> 1

                                           statx(alias,
                                                 AT_STATX_FORCE_SYNC)
                                             cached i_nlink: 2 -> 1

   cifs_drop_nlink()
     actual:   cached i_nlink: 1 -> 0       wrong
     expected: cached i_nlink remains 1

I tried addressing these problems by taking an i_nlink snapshot before
the unlink/rename request, using it to decide which handles to mark,
and decrementing the cached link count only if it still matched the
snapshot.

Unfortunately, an nlink snapshot does not show whether revalidation
happened before or after unlink/rename. Therefore, it cannot fully
address these races or reject stale attribute responses that arrive late.

NFS addresses these issues with per-dentry silly rename, attribute
generation counters, and cache invalidation. A similar CIFS solution
may be challenging, as it must coordinate namespace operations,
open-handle state, and asynchronous attribute updates.

Do you have any ideas?

Thanks,
Huiwen



在 2026/8/5 13:11, ChenXiaoSong 写道:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Reproducer:
> 
>    1. server: systemctl start ksmbd
>    2. client: mount with `posix` option
>       mount -t cifs -o posix //${server_ip}/export /mnt
>    3. client: touch /mnt/file1 /mnt/file2
>    4. client: C program: int fd = open("/mnt/file2", O_RDONLY);
>    5. client: C program: rename("/mnt/file1", "/mnt/file2");
>    6. client: C program: struct stat stbuf; fstat(fd, &stbuf);
>                          stbuf.st_nlink is 1, should be 0
> 
> This patch fixes xfstests generic/035 when mounted with `posix` option.
> 
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   fs/smb/client/inode.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 0afff761aab9..0b6273ce01a8 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2648,11 +2648,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>   	if (d_really_is_positive(target_dentry)) {
>   		if (!rc) {
>   			struct inode *inode = d_inode(target_dentry);
> -			/*
> -			 * Samba and ksmbd servers allow renaming a target
> -			 * directory that is open, so make sure to update
> -			 * ->i_nlink and then mark it as delete pending.
> -			 */
> +
> +			/* Update the target link count after rename. */
>   			if (S_ISDIR(inode->i_mode)) {
>   				drop_cached_dir_by_name(xid, tcon, to_name, cifs_sb);
>   				spin_lock(&inode->i_lock);
> @@ -2663,6 +2660,10 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>   				CIFS_I(inode)->time = 0; /* force reval */
>   				inode_set_ctime_current(inode);
>   				inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +			} else {
> +				cifs_mark_open_handles_for_deleted_file(inode, to_name);
> +				cifs_drop_nlink(inode);
> +				inode_set_ctime_current(inode);
>   			}
>   		} else if (rc == -EACCES || rc == -EEXIST) {
>   			/*

