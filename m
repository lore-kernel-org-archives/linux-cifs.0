Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78523002DD
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770316922; cv=none; b=Qm8rnSUbkmTGEIf6FirauRj6vHzUJI8wLbsGi3XZBW3odastfwKk5AePKpy00hf57pZhkl86mPa22G48Kn0Q3mZrnHb/JHTN6KiFoQYcMqK9u9vKOO6akITxREAoI4hf3DlKrGyB4F1j6bsqASGR25uHSYEdoo3cQ47gRHumt2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770316922; c=relaxed/simple;
	bh=tyvjrvPnKaJmHcs9Owl8RTUCf25qaxoIYjjl0ejq1Q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uh0QDroXEAAAQqvKRsCi+CU0Eu1ZTg1Ab1+jc8haAXt2j3TOLdBcetpcfhVkpu0YPFOQeNKSB1GAeJrgddudZYuM5FVvgSmm3mxXU8dS4yXl4M9HzKH2PpzHSXjnpgVbbHBxc4bVLSwsq4bkI/DQPc2A9eseIXHVzIke24z+/0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GV3aVeSF; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GV3aVeSF"
Message-ID: <cbedb833-0cf9-467e-8751-e975b965c467@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770316919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zsJF6HqzdHV4rBI/t0PqXth8Zvtd1ZT8wIry7jhAFxg=;
	b=GV3aVeSFo82+oOmv9LY4j8ZnmN2AGzdD8dWClWCy/Jgzo+6K3t0Uz5W4KnrCUGWWuaWyRe
	bVsAmjt0OikUsa0KFfUT9VqRm/LtlFx2zWqHDcWYI0lPwVlEZEHlOBIxaKf4VM43/Y0iOj
	62GqksShad05HkYhikPVGHcNDAa8eCA=
Date: Fri, 6 Feb 2026 02:41:45 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb: client: fix potential UAF and double free it
 smb2_open_file()
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
References: <20260205161952.245146-1-pc@manguebit.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260205161952.245146-1-pc@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Looks good. Feel free to add:

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 2/6/26 12:19 AM, Paulo Alcantara wrote:
> Zero out @err_iov and @err_buftype before retrying SMB2_open() to
> prevent an UAF bug if @data != NULL, otherwise a double free.
> 
> Fixes: e3a43633023e ("smb/client: fix memory leak in smb2_open_file()")
> Reported-by: David Howells <dhowells@redhat.com>
> Closes: https://lore.kernel.org/r/2892312.1770306653@warthog.procyon.org.uk
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Cc: linux-cifs@vger.kernel.org
> ---
>   fs/smb/client/smb2file.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index 2dd08388ea87..1f7f284a7844 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -179,6 +179,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
>   		       &err_buftype);
>   	if (rc == -EACCES && retry_without_read_attributes) {
>   		free_rsp_buf(err_buftype, err_iov.iov_base);
> +		memset(&err_iov, 0, sizeof(err_iov));
> +		err_buftype = CIFS_NO_BUFFER;
>   		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
>   		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
>   			       &err_buftype);

