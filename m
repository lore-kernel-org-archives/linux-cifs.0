Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A22ECE8F;
	Fri, 21 Nov 2025 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763729405; cv=none; b=OMXkigLDFqwSz/pVMq9rhrObtHBx2r9yGAjbW8DKKeObO6mtegB3jP+yGUyHMH/TzH2LdFWqp2IbCjjxrFYLqjpf6+hN/I196ULjvb1gpT4r1pRaVvKOHisC7zF7hBOdCWQlX5WOaM16+w6a5iSWJFxkWbE0CQkh1TdyaP0HrBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763729405; c=relaxed/simple;
	bh=E6J50PYKhkW1y37m5TtjJdG0IBlfGFAvGeMbYMpo3Jk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=MoDeAMLAzGnqtNfQIfHk5w01QkelFCBS74+uqF29ks/BW81os5VuPvG18lBkeXj0qt6NXjPLKHzty6ix6EWbXwhQo+1S7n9ny96GlEFVTfQbWQHa4E5+ucIIKNN35YIVJVM9ttbn8Ij43rRhQ+p4eL8/8uTwYmd+H/7DEfEwS9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=N0ZIV6as; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="N0ZIV6as"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pf0Y7V6zXMOhec+D1eTtFZtRtloGjE6Q6JzbMbbBUjw=; b=N0ZIV6asN74sdUF9RvJ8i20y87
	EhgFaZHtLYX0u2GXi2qngXseJhIc9k+VFSnh8nwG2y5Hg0OUKnHK/iWf8xYLdWJlTu1ejJLxHF68s
	DDD7JEkGWlm6z7VF5yXA9paZ1pBCWRQRop91Y9lmVJeDZ0F4yQdEiSwIjxN84as/cD4N4XlhujlcD
	33ZEPMR2fUGzAvrrkOSklMRqjKOaIPcLiVrSozdLd5/TeIURkrqofijocSDxOGqTnyeJgdPO0Q/Bz
	lbHNjc5i8zgv8Gc8cPFv3K50vEuvkFNoovFq4zNAC2uBO5fHtHUHJgbwXCG4Hfh//SuJ2JLil8x2r
	FC9Zrk+Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vMQQ2-00000000H6l-0U5Z;
	Fri, 21 Nov 2025 09:39:19 -0300
Message-ID: <33405621d347fe99dd3a26dc5b67d417@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ssrane_b23@ee.vjti.ac.in, sfrench@samba.org
Cc: ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev,
 david.hunter.linux@gmail.com, khalid@kernel.org, Shaurya Rane
 <ssrane_b23@ee.vjti.ac.in>,
 syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Subject: Re: [PATCH] cifs: fix memory leak in smb3_fs_context_parse_param
 error path
In-Reply-To: <20251118150257.35455-1-ssranevjti@gmail.com>
References: <20251118150257.35455-1-ssranevjti@gmail.com>
Date: Fri, 21 Nov 2025 09:39:18 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

ssrane_b23@ee.vjti.ac.in writes:

> From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
>
> Add proper cleanup of ctx->source and fc->source to the
> cifs_parse_mount_err error handler. This ensures that memory allocated
> for the source strings is correctly freed on all error paths, matching
> the cleanup already performed in the success path by
> smb3_cleanup_fs_context_contents().
> Pointers are also set to NULL after freeing to prevent potential
> double-free issues.
>
> This change fixes a memory leak originally detected by syzbot. The
> leak occurred when processing Opt_source mount options if an error
> happened after ctx->source and fc->source were successfully
> allocated but before the function completed.
>
> The specific leak sequence was:
> 1. ctx->source = smb3_fs_context_fullpath(ctx, '/') allocates memory
> 2. fc->source = kstrdup(ctx->source, GFP_KERNEL) allocates more memory
> 3. A subsequent error jumps to cifs_parse_mount_err
> 4. The old error handler freed passwords but not the source strings,
> causing the memory to leak.
>
> This issue was not addressed by commit e8c73eb7db0a ("cifs: client:
> fix memory leak in smb3_fs_context_parse_param"), which only fixed
> leaks from repeated fsconfig() calls but not this error path.
>
> Reported-by: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=87be6809ed9bf6d718e3
> Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
> ---
>  fs/smb/client/fs_context.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 0f894d09157b..975f1fa153fd 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1834,6 +1834,12 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>  	ctx->password = NULL;
>  	kfree_sensitive(ctx->password2);
>  	ctx->password2 = NULL;
> +	kfree(ctx->source);
> +	ctx->source = NULL;
> +	if (fc) {
> +		kfree(fc->source);
> +		fc->source = NULL;
> +	}

The non-NULL check of @fc makes no sense.

Otherwise looks good:

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
