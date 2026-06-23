Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABA912C534
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182865; cv=none; b=EuDAnxAtqsD9fUlFqVOFzT1MLOP5neumuSa4eGZm/Uyn0Y8xlU5rUHFrXF9lKJCQnwMPaPtfZo0T+6QOyKtxyHlWf7+XhPpP6/3GkBS1bQdgmzL25A9KDIqnKruMTjtt3qDbnJ4Rfyh1Gs8S6exoJ2XczmUq1y8clN4YnY2tOSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182865; c=relaxed/simple;
	bh=HZEE6aOguD1oJUdi6Zg2Fcan/qUxnYO00qi+Ai1eK4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gNaec+Ol8334j+9fiHXZXFncNE+FSy2zdfr5HS7L219cZMkWtIe9xj2XpBJdnifxRP6KLRWxnkSMQ/dhSqbgm5CHGI7yEQlo1BTdaH4zqekPLvO6HACbPd+yvh+3Cwhe08JoLQfjlMiSkw7iX69e2QahvJj/JoYLLj6rCfI5/nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=T5iO6S+1; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="T5iO6S+1"
Message-ID: <eccbd78b-d400-4261-887f-6f21fdc51bd2@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782182851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zMipBRF/Wjd7ai2RMW2ciMR3f9cSZtBRLpfDDT00Fus=;
	b=T5iO6S+1rF5IA4e5apkRKdsNXUF0FK70ivF9qYXhpw71UJeLRf0+GZhQDPXB8Hwsv76Vwf
	w1tWyNqdQGmZ95e5Cw8loNkVSkpfDQ5cCIEg3+nPFUBDNLUN7n6ygIxTWGiwvZYMddZfN+
	eeUWUjps4RZvcujl0Jz9tjDBbkCoaW9AGRZxK9PV01IfKS1Pq8qKNbEJoeSSd2R9SDbInr
	TLzDIetTFYOdiFerx5Gf2rbL9CMKriHsp6G9gXUBo4L1nBNBcDsT7JAcXp4jesMRq8u7Pr
	zimmas9SMKo6PPg8Sf/2KcUlgLHpBpAbXCj3soOFftN2vehIvjPwQNeVRewCig==
Date: Tue, 23 Jun 2026 10:46:40 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] ksmbd: fix n.data memory leak in
 ksmbd_vfs_set_dos_attrib_xattr
To: liuqiangneo@163.com, linkinjeon@kernel.org, smfrench@gmail.com,
 senozhatsky@chromium.org, tom@talpey.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Qiang Liu <liuqiang@kylinos.cn>
References: <20260623021240.34722-1-liuqiangneo@163.com>
 <20260623021240.34722-4-liuqiangneo@163.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260623021240.34722-4-liuqiangneo@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

We can add a label and use `goto` to free n.data

On 6/23/26 10:12, liuqiangneo@163.com wrote:
> From: Qiang Liu <liuqiang@kylinos.cn>
> 
> Free ndr buffer data when ndr_encode_dos_attr() returns error
> to avoid memory leak.
> 
> Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
> ---
>   fs/smb/server/vfs.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 60b4210d5ab8..18d5412081de 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -1568,8 +1568,10 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
>   	int err;
>   
>   	err = ndr_encode_dos_attr(&n, da);
> -	if (err)
> +	if (err) {
> +		kfree(n.data);
>   		return err;
> +	}
>   
>   	err = ksmbd_vfs_setxattr(idmap, path, XATTR_NAME_DOS_ATTRIBUTE,
>   				 (void *)n.data, n.offset, 0, get_write);

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

