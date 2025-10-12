Received: from smtp.smtpout.orange.fr (smtp-82.smtpout.orange.fr [80.12.242.82])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD7319CCFC;
	Sun, 12 Oct 2025 20:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760301410; cv=none; b=tIrBcNqg039dnUGPH0wZrbAVeU5VRQev/ce7xThMGjHYJAqAZzxmYUl1laqjCD9dC5+/cMeVRmpiMaPt13iug3tX2CwrCj1unkicztGR6RHFh/7nSo4FQxdR+bZqwZ1hJ+pO/VqwdFFy1l1dVgUuNQSS63OmLSaMqqByS7P/UwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760301410; c=relaxed/simple;
	bh=3VEMiJN+f8AXiW5vvqX1vWzwUHbrPRFw5t07fiqVhWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BTd6pMxaQXbBevz+3ZvgdvTCiXnK6SSsxSwK5s2R1eKJm8vyjcd71zugsqO1gEdJENc64Igiql+A1jFSt0V9sFxpt02vTdqxdk0w9IVQoJ7LQBhWNfESpi4VUaUFBdu13XBjJXqVEzovvmZLB9PqYhnuvsZDOg1KDGDrAAwQRFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=rIecwSds; arc=none smtp.client-ip=80.12.242.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="rIecwSds"
Received: from [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
 ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPA
	id 82nvv5XdMA5xR82nwvnlT0; Sun, 12 Oct 2025 22:36:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1760301398;
	bh=4D8Uhhp5TYXB9cD1KefCal6Y2TqrBc7OXDaDGeAMLII=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=rIecwSds61SpEeCCHleqGVkotONOD999cdZtSdKuQ42mAXwsAFYBRPCdCtPjfF1XM
	 PqEUA/9iY4x7OVmt8URR9i6/g3oAKngj+2BvgOzzBq1uhRzL45dTsOqhlE2B/eOAwq
	 QTySE8jLOPkhzWHJBc/WiRX3W6MGQ0/JhiUE41KXTe4dnsaQgoQGP5qY/0WnfWA2Hd
	 6TvGmbf743sdDzSreLnDwliDvx3BEHvHpcMjWgB7gvj8PS90NXzA6MG0X+TdapemAh
	 Io1G4e0ftSCYpaFF5XVHeIuyvNVZ30oI8Tts8QU5GhOxyEVF6IEn9g4tRHi0pmikIN
	 g0mIfpAr1Kanw==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Sun, 12 Oct 2025 22:36:38 +0200
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
Message-ID: <bd7b1078-4e58-4403-97e3-ac3a4765c51a@wanadoo.fr>
Date: Sun, 12 Oct 2025 22:36:30 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/22] smb: move SMB1_PROTO_NUMBER to common/cifsglob.h
To: chenxiaosong@chenxiaosong.com, stfrench@microsoft.com, metze@samba.org,
 pali@kernel.org, linkinjeon@kernel.org, smfrench@gmail.com,
 sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 bharathsm@microsoft.com, zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
 <66942D4891D3E571+20251012161749.2994033-7-chenxiaosong@chenxiaosong.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Language: en-US, fr-FR
In-Reply-To: <66942D4891D3E571+20251012161749.2994033-7-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 12/10/2025 à 18:17, chenxiaosong@chenxiaosong.com a écrit :
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
> 
> Replace the constant of client with SMB1_PROTO_NUMBER, then move the
> macro definition from server/smb_common.h to common/cifsglob.h.
> 
> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Reviewed-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Hi,

even if I reviewed and commented on this patch, I never gave an explicit 
R-b.

And as I'm cited in this v2, being in To: or Cc: of this updated version 
would have been appreciated.

No hard-feeling.

CJ

> ---
>   fs/smb/client/misc.c       | 2 +-
>   fs/smb/common/cifsglob.h   | 2 ++
>   fs/smb/server/smb_common.h | 1 -
>   3 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index dda6dece802a..68607b7a68ca 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -318,7 +318,7 @@ static int
>   check_smb_hdr(struct smb_hdr *smb)
>   {
>   	/* does it have the right SMB "signature" ? */
> -	if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
> +	if (*(__le32 *) smb->Protocol != SMB1_PROTO_NUMBER) {
>   		cifs_dbg(VFS, "Bad protocol string signature header 0x%x\n",
>   			 *(unsigned int *)smb->Protocol);
>   		return 1;
> diff --git a/fs/smb/common/cifsglob.h b/fs/smb/common/cifsglob.h
> index 371160fec1cd..5928d35c7f30 100644
> --- a/fs/smb/common/cifsglob.h
> +++ b/fs/smb/common/cifsglob.h
> @@ -9,6 +9,8 @@
>   #ifndef _COMMON_CIFS_GLOB_H
>   #define _COMMON_CIFS_GLOB_H
>   
> +#define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
> +
>   struct smb_version_values {
>   	char		*version_string;
>   	__u16		protocol_id;
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index 9c0db206624b..6d427dbed5fd 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -151,7 +151,6 @@
>   		FILE_EXECUTE | FILE_DELETE_CHILD | \
>   		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
>   
> -#define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
>   #define SMB_COM_NEGOTIATE		0x72
>   #define SMB1_CLIENT_GUID_SIZE		(16)
>   

