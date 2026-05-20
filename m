Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E115C3246FE
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779304468; cv=none; b=mJva1hP3qajE2FRkhPEcVNMR6fbY7IOXSXwkKy9sdEes9phmpbciYAx8wMcaQLzvyPKB33Q1/Y/YF80Lv6qMi937QRpVeolYbhPg0kIgCpHGZHGeJM8aSyUqsxcJ0YkuPQVcVP+LVxMHg7bP+CQkAFI1+jG2AZ7UkF7u21o+VNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779304468; c=relaxed/simple;
	bh=BGJElSJGkDvUzVTG85o9+MJ7BSPFFSyzOxPjsRZyg9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gFkEA/iNp+FLjYef3CkpMokgeZ+CEeWj8sIw4Ttfeto/fnwUKGosS7iXb6FnwONITAZHYj7Wd/h6Ex1PKmVqP6CAlvnC9CZLfZDaDYkKyfZTAHdbB7y36nr4MqIAW/mFQVq4hiwE/uFyWybX0tQzseiDFt2vnlABzcsjhcMO+VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=A8c0RTcp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="A8c0RTcp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:To:Date:Message-ID:CC;
	bh=mwEPPItzK6NdHiaiaeEeG+QpGlVy8iOfZ8AmC/hRr8c=; b=A8c0RTcpZz782If2a1utV9uGpc
	GjlvHYadvM4fcg1jsYvMY8lrKFPkrhy5uDzi4ekfW46NLSFuxZUFyMsxRYMZ4rtpa2Jxr/RnUqHR+
	Wibh6FVcD7F3/AnzDF/Wc83A5PTJ+EhdwEGM6VZv9CsJMo20a+YCqQ5u7x3c6jgkFQWB4ta+UL0y/
	cFftYIINMrYqasTnt9cA03d1V08Do9uXbfnJ9AhovnzKyKY0PzrC3AgWMJUaXQKe4pGrnBXCl9JQu
	Mx0kwemcsCUNP2hyXrCWHxfEfeTL6pNkCXRf0kcGMRj69DPjCe7cnee+BOkp4BArO0r52CzCkJeOZ
	1TDTEE0DUbJUcniiXStlsRWk+fKXFb06wm4QHnapbKi+y8QylCrnXAXq8m0VuWsgmmVnCD7CDJwpJ
	xpJ6GVe4lSdCPHGoSQ7QGOW5/wZxW7eZEqGTVuSMiQt/08Q3WNj7edn3pXPnokHZwiilvb9kUTKW8
	bOGpHaP1BqnuJIXiaMEklmra;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wPmN6-0000000ATa7-2WoR;
	Wed, 20 May 2026 19:14:24 +0000
Message-ID: <091cf341-537d-48c8-8938-4f51a76aee3e@samba.org>
Date: Wed, 20 May 2026 21:14:23 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: smbdirect: divide, not multiply, milliseconds by
 1000
To: "Alexander A. Klimov" <grandmaster@al2klimov.de>,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org
References: <20260520180401.539215-1-grandmaster@al2klimov.de>
 <20260520180401.539215-2-grandmaster@al2klimov.de>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260520180401.539215-2-grandmaster@al2klimov.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 20.05.26 um 20:03 schrieb Alexander A. Klimov:
> Unless smbdirect_connection_legacy_debug_proc_show()
> wants to debug-log keep_alive_interval as microseconds,
> a magnitude higher precision than available by the way,
> keepalive_interval_msec should not be multiplied by 1000.
> 
> Fixes: a93b68d46e14 ("smb: smbdirect: introduce smbdirect_connection_legacy_debug_proc_show()")

We should also add
Fixes: cc55f65dd352 ("smb: client: make use of common smbdirect_socket_parameters")
as that introduced the change.

With that Reviewed-by: Stefan Metzmacher <metze@samba.org>

Thanks!
metze

> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>   fs/smb/smbdirect/debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/smbdirect/debug.c b/fs/smb/smbdirect/debug.c
> index 05ba7c8d165e..3445843445bf 100644
> --- a/fs/smb/smbdirect/debug.c
> +++ b/fs/smb/smbdirect/debug.c
> @@ -40,7 +40,7 @@ void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
>   
>   	seq_puts(m, "\n");
>   	seq_printf(m, "Conn keep_alive_interval: %u ",
> -		   sp->keepalive_interval_msec * 1000);
> +		   sp->keepalive_interval_msec / 1000);
>   	seq_printf(m, "max_readwrite_size: %u rdma_readwrite_threshold: %u",
>   		   sp->max_read_write_size,
>   		   rdma_readwrite_threshold);

