Received: from out-173.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317583E0092
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 06:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785912113; cv=none; b=GJozPTYGvHCDgtcSesdMR6D4dmH+Iwa7213TS7WFATK1Q6d5IunkUh+7kfYknH9Lb48mLQ2kLk17FYXPuh6k682FiTaO7edmgu9lAZEdyrt/QRIhNUKmHwwt3/gHiPMbIMeziMt00G6t/874IFQAHEewwhlxDLSMP8oAn+wH2uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785912113; c=relaxed/simple;
	bh=ZIn+meFlda1HXxad+HTF5Dy4MFmmWbiBWpl/d2p3zu4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Rw1qLt4boyhLbBtk5zehY13+R9sm0Tzj8Wn9CHL7z0dUkkeFADBRSOHoG+L0qz2r7v5dhPDLrS5tJIG1u+Qeu6nVPrCY96TrdX9mdW2qvSHJQEunQnCM07efvw3FF3mmusgaD1WVaON2eejZxbcLS8EEVSUYCNJYyzbHhOKnyCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=gBK8Lbb0; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="gBK8Lbb0"
Message-ID: <2ffe4d18-fcfe-4481-bb2a-08b879d42494@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785912105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Li3ncIrgZyWmfZn/IRiwkWEUelTmEeGrsdTpQWeCKg=;
	b=gBK8Lbb0XoQhTRVh5mjYIS8wFXlIObCivre5ofAQqtTn5K7IvRUb1kGmno+YgWN5Kl4ze1
	sc43064qOUUqBD9nNtPMzeOzdaybZkh6DjYeVHhF6L4pn08u9q/AzE5IguAbnMci4pZ0i6
	SVoIXREFmNhknLp9QpJCGV2AK5ECc4HmeRDfjN3JeKHjTcMYTn0GqhoV9QmSmhAgiPwllc
	ZG0g8EXj4WovGZOZ0H0GYvLw9Pd2DKqcS5/+NonQuzGrLGXOkj4qguyEP+2LXqSK5zYzPU
	z2qXj8Vzhkm+BqCTNQpu7cMvWmcfqL0T6b1WfK3NUZ/npjHCvpQTV111qEEJsg==
Date: Wed, 5 Aug 2026 14:40:52 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH v3 resend 2/3] smb/server: deny overwriting targets with
 non-POSIX opens
To: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 tom@talpey.com, senozhatsky@chromium.org, slow@samba.org
Cc: linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
 <20260805051112.305078-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260805051112.305078-3-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

The following are my test steps for the hardlink case mentioned by Namjae.

```
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1156,6 +1156,7 @@ bool ksmbd_has_other_nonposix_open(struct dentry 
*dentry)
                 if (fp->is_posix_ctxt)
                         continue;

+               printk("%s:%d\n", __func__, __LINE__);
                 ret = true;
                 break;
         }
```

1. Add the above debug log.
2. server: systemctl start ksmbd
3. client: mount without `posix` option:
            mount -t cifs //${server_ip}/export /mnt
4. client: touch /mnt/file1 /mnt/file2
5. client: ln /mnt/file2 /mnt/link1; sleep 3
6. client: tail -f /mnt/link1 # open link1
7. tcpdump -i any tcp port 445 -w test-open-hardlink.pcap
8. client: mv /mnt/file1 /mnt/file2
9. server log:
    [102256.516146] ksmbd_has_other_nonposix_open:1159
    [102256.518393] ksmbd_has_other_nonposix_open:1159
    [102256.520443] ksmbd_has_other_nonposix_open:1159
    [102256.522616] ksmbd_has_other_nonposix_open:1159
10. Packets captured by tcpdump:
     SetInfo Response, Error: STATUS_ACCESS_DENIED

On 8/5/26 10:17, Namjae Jeon wrote:
> The new check is limited to the target dentry's
> ksmbd_inode->m_fp_list. Therefore, it does not cover a struct
> ksmbd_file opened through another hardlink dentry, even though
> file_inode(fp->filp) == d_inode(dentry). For example, if file2.link is
> a hardlink to file2 and file2.link is opened with a non-POSIX context,
> an overwrite rename of another file to file2 can miss that open
> handle.
> This appears to be an existing limitation rather than a regression
> introduced by this patch. However, since this patch is intended to
> reject overwrites when the target has a non-POSIX ksmbd_file...


On 8/5/26 13:11, ChenXiaoSong wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Reproducer:
> 
>    1. server: systemctl start ksmbd
>    2. client: mount without `posix` option
>       mount -t cifs //${server_ip}/export /mnt
>    3. client: touch /mnt/file1 /mnt/file2
>    4. client: C program: int fd = open("/mnt/file2", O_RDONLY);
>    5. client: C program: rename("/mnt/file1", "/mnt/file2");
>    6. client: C program: struct stat stbuf; fstat(fd, &stbuf);
>                          stbuf.st_nlink is 1, should be 0
> 
> This patch fixes xfstests generic/035 when mounted without `posix` option.
> 
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   fs/smb/server/vfs.c       | 13 +++++++++++++
>   fs/smb/server/vfs_cache.c | 27 +++++++++++++++++++++++++++
>   fs/smb/server/vfs_cache.h |  1 +
>   3 files changed, 41 insertions(+)
> 
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 16ef8d051b18..9102ab47a3aa 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -726,6 +726,19 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, struct ksmbd_file *old_fp,
>   		goto out3;
>   	}
>   
> +	/*
> +	 * See MS-FSA 2.1.5.15.12.
> +	 * An overwrite rename must fail with STATUS_ACCESS_DENIED if the
> +	 * existing target still has a non-POSIX open.
> +	 */
> +	if (!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)) &&
> +	    d_inode(rd.new_dentry) &&
> +	    d_inode(rd.new_dentry) != d_inode(old_child) &&
> +	    ksmbd_has_other_nonposix_open(rd.new_dentry)) {
> +		err = -EACCES;
> +		goto out3;
> +	}
> +
>   	err = ksmbd_vfs_check_rename_share(work, old_path);
>   	if (err)
>   		goto out3;
> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> index 028bc1b0f652..90348a409162 100644
> --- a/fs/smb/server/vfs_cache.c
> +++ b/fs/smb/server/vfs_cache.c
> @@ -1137,6 +1137,33 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
>   	return NULL;
>   }
>   
> +bool ksmbd_has_other_nonposix_open(struct dentry *dentry)
> +{
> +	struct ksmbd_file *fp;
> +	struct inode *inode = d_inode(dentry);
> +	unsigned int id;
> +	bool ret = false;
> +
> +	if (!inode)
> +		return false;
> +
> +	read_lock(&global_ft.lock);
> +	idr_for_each_entry(global_ft.idr, fp, id) {
> +		if (READ_ONCE(fp->f_state) != FP_INITED)
> +			continue;
> +		if (inode != file_inode(fp->filp))
> +			continue;
> +		if (fp->is_posix_ctxt)
> +			continue;
> +
> +		ret = true;
> +		break;
> +	}
> +	read_unlock(&global_ft.lock);
> +
> +	return ret;
> +}
> +
>   bool ksmbd_has_nonposix_open_child(struct ksmbd_file *old_fp)
>   {
>   	struct dentry *dentry = old_fp->filp->f_path.dentry;
> diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
> index 9dca617bc429..5cac022b540b 100644
> --- a/fs/smb/server/vfs_cache.h
> +++ b/fs/smb/server/vfs_cache.h
> @@ -212,6 +212,7 @@ bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp);
>   int ksmbd_close_fd_app_instance_id(char *app_instance_id);
>   struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
>   struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
> +bool ksmbd_has_other_nonposix_open(struct dentry *dentry);
>   bool ksmbd_has_nonposix_open_child(struct ksmbd_file *old_fp);
>   unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
>   struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

