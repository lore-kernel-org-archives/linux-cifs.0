Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AACB30C62E
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 16:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766593427; cv=none; b=ihDPErVZEPLLSG/FqS/AUFiWzRSGldXZ8MeUJnkqk825a6UjyyVRe0X85+nW4/lkJtmackdCd/RGC2qDy82JXg1GhE59dZ5jUYuqp7UOwXCvsdrLTlK58dexWky/LXY6lZ/yCtI4T/7O3gUyzd5HuSXplTDul6PkXBVisAvpC4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766593427; c=relaxed/simple;
	bh=40rm2Uf4N9nAJx6nCLyOt97jUyaf1uPHPjYNP05d9xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Prlt0DaNFDSei7pl8JN6t+hKW7PN3hkbFfkL2KYtpnbC37BnIQYvOSxIE04Ll7DXTiOSXevc5O1jvi0sV7y6HTq5CQlSmHifqQDAFc78ZBQw4Q4TZyIJgsT6Sbi5AvlFj6UJ3iooBPdw9QtZcoFmArlQtSemcKL0GesJ9OJTcHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pql3UZ9g; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pql3UZ9g"
Message-ID: <39ca2ff6-c363-47d7-9d4f-fd6f137afc09@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766593418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DPnvnXkrCvgg42/CMlGi7s56UOKFkvD/J4T5uPYVQjo=;
	b=Pql3UZ9gahJ9EyTye/66g9fktj8EjiZnzoT0LGmsk43CCl4YbUVp9jKfGnQoERHwU/SjIV
	EGfZ5NVTJDbs9hm+DrK8uef60eIVoGpceWnXUijjW0WX/b0VgKtCjqnb8VA1afNrsWqPpN
	UqX5CQ3JG3vU9Ek4rrNB7ua3YMEtpIg=
Date: Thu, 25 Dec 2025 00:23:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] cifs: Fix memory and information leak in
 smb3_reconfigure()
To: Zilin Guan <zilin@seu.edu.cn>, sfrench@samba.org,
 Steve French <smfrench@gmail.com>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 jianhao.xu@seu.edu.cn
References: <20251224152142.289149-1-zilin@seu.edu.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251224152142.289149-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Good catch. Looks good to me.

Thanks,
ChenXiaoSong.

On 12/24/25 11:21 PM, Zilin Guan wrote:
> In smb3_reconfigure(), if smb3_sync_session_ctx_passwords() fails, the
> function returns immediately without freeing and erasing the newly
> allocated new_password and new_password2. This causes both a memory leak
> and a potential information leak.
> 
> Fix this by calling kfree_sensitive() on both password buffers before
> returning in this error case.
> 
> Fixes: 0f0e357902957 ("cifs: during remount, make sure passwords are in sync")
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
>   fs/smb/client/fs_context.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index c2de97e4ad59..d4291d3a9a48 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1139,6 +1139,8 @@ static int smb3_reconfigure(struct fs_context *fc)
>   	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
>   	if (rc) {
>   		mutex_unlock(&ses->session_mutex);
> +		kfree_sensitive(new_password);
> +		kfree_sensitive(new_password2);
>   		return rc;
>   	}
>   

