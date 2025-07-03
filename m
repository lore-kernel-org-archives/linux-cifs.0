Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF10518B47C
	for <linux-cifs@vger.kernel.org>; Thu,  3 Jul 2025 06:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751524516; cv=none; b=Y5gHtftrDHPn4Ir2NMCLFkePuV7nqwo7mx+AEk3vgYbQHPk2c1lw9dpsZQkv9xKjSRWLKtxU8LM8zpRFhsS9LehKn6XRPReT11yg5CnNk/Z59oiVC70OUz7IdkJHdWBffKhgNQEKUEvjV93WODon6MBUyBRhUGRZ3i/5wquLUXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751524516; c=relaxed/simple;
	bh=sr43B1hY2HBr6PJ6dKyYY5hPxd9nuHEFNMqKp1qfnYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t1UPjF0vR8ng6JZv2WTnp79X2497ULkm5NE62hv8PF4nqZE9MLD3VZiJKThsl8TiN5K3gGQEkqkGo2hIQOJOYXJZ0W1LcQf9plRnAV6sYltJArHdxS4vJafoCPP6qQQaySuSdR1PR/Xxi1eFFD5DR05VBplgyGk+G+CRpAHUwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=vTIoMv/R; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vTIoMv/R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ewbmWAdIpr6vvTSyMnprWuKq7HBEIW3dcqWaDwbC3Ak=; b=vTIoMv/RZPILZJueZfwPCm5b3U
	6K60u8RkMPTvbEWuOF8/s4Fbp6Mu45sydx/LkyQqoEj1ePLoYdOqk/ziS9yc7R6RlZLp0pwg0qzvD
	6w1hJh39aAowMg+Y2+jxb9KsMhyjph2jkpI/AIRjvO5ThP+kHIwlwBxSV4vi9qxOtkaJfY4FudimI
	oiuYKTxmJBydfVGfABD/2G27UqnTZzUrPz8PRVj8AeTaWYanQMEOzaLlrd2xDBn2NJhSabpveqXoM
	L6oLi529C4E1VMctSlfIH0JcThgiWxzhIDksuqO2/i5DUtrrA/et0hX6oD24oTYv14YcTynUk2BGb
	ak29xYsuiLWLwXJDhIGfY5vwgldG45BVbKI18SILFUwiKNblE77C1Ic2rZ7mVsQJj7idpQM8As0PG
	k/SYJB37Qf/Th2iuBZljml87u2jLlNv+CQ3lJxLleDK/B8AVX/JsmVYzLO/qYhcul6o0kw7/Rqoif
	ySzIu/CnBkk2ou6YYcO/XOrY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uXDXK-00DeOD-2S;
	Thu, 03 Jul 2025 06:35:11 +0000
Message-ID: <d0117c2f-490f-4fc4-9bff-254e13b4a5cd@samba.org>
Date: Thu, 3 Jul 2025 08:35:10 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix native SMB symlink traversal
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org, Pierguido Lambri <plambri@redhat.com>,
 David Howells <dhowells@redhat.com>
References: <20250702174001.911761-1-pc@manguebit.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20250702174001.911761-1-pc@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 02.07.25 um 19:40 schrieb Paulo Alcantara:
> We've seen customers having shares mounted in paths like /??/C:/ or
> /??/UNC/foo.example.com/share in order to get their native SMB
> symlinks successfully followed from different mounts.
> 
> After commit 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style symlinks"),
> the client would then convert absolute paths from /??/C:/ to "/mnt/c/"
> by default.  The absolute paths would vary depending on the value of
> symlink= mount option.
> 
> Fix this by restoring old behavior of not trying to convert absolute
> paths by default.  Only do this if symlinkroot= was _explicitly_ set.
> 
> Before patch:
> 
>    $ mount.cifs //w22-fs0/test2 /mnt/1 -o vers=3.1.1,username=xxx,password=yyy
>    $ ls -l /mnt/1/symlink2
>    lrwxr-xr-x 1 root root 15 Jun 20 14:22 /mnt/1/symlink2 -> /mnt/c/testfile
>    $ mkdir -p /??/C:; echo foo > //??/C:/testfile
>    $ cat /mnt/1/symlink2
>    cat: /mnt/1/symlink2: No such file or directory
> 
> After patch:
> 
>    $ mount.cifs //w22-fs0/test2 /mnt/1 -o vers=3.1.1,username=xxx,password=yyy
>    $ ls -l /mnt/1/symlink2
>    lrwxr-xr-x 1 root root 15 Jun 20 14:22 /mnt/1/symlink2 -> '/??/C:/testfile'
>    $ mkdir -p /??/C:; echo foo > //??/C:/testfile
>    $ cat /mnt/1/symlink2
>    foo
> 
> Cc: linux-cifs@vger.kernel.org
> Cc: Pierguido Lambri <plambri@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Fixes: 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style symlinks")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> ---
>   fs/smb/client/fs_context.c | 13 ++++---------
>   fs/smb/client/reparse.c    | 22 +++++++++++++---------
>   2 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index a634a34d4086..d8d2d4a739e8 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1825,9 +1825,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>   			goto cifs_parse_mount_err;
>   		}
>   		kfree(ctx->symlinkroot);
> -		ctx->symlinkroot = kstrdup(param->string, GFP_KERNEL);
> -		if (!ctx->symlinkroot)
> +		ctx->symlinkroot = kstrndup(param->string, PATH_MAX, GFP_KERNEL);

Should we really truncate the string instead of generating an error?
I really don't know, maybe it is a good thing, but we should have a comment
that explains it why we truncate.

Thanks!
metze
