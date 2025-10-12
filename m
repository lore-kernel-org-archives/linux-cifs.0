Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A357A2EAB89;
	Sun, 12 Oct 2025 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282554; cv=none; b=Pa2dONwwnzI1bLf+sNdx36oDtopRU9grcIaCYvBEDI6uhGVd/DUp2r1WbzHUJUj1XOx8rqC50dL+PqLP+tLlYZmVSI+JQvLoif/SxmuG0g9yU4uEqhnjktkdXYW/3jnGOIfGN9hHmw6gPnCDIS38OblvpV+fTXJt5TEbrK4HZXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282554; c=relaxed/simple;
	bh=voksv3xS9cC10qHQisa35sISpwJAUFIrohI9c28FaKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ue0XIN0HRrtrBECesY//O1xtFznacsgFCkPDWe00bK6Wr7eKOD+0SDy+rvt4aV+tPfrJIKYLMqqbQOlgYAF4GJsOBwGnddYaaC4jXKxZiJ03pu3woBHq3DGYokAY7KAok7T/g42WF/s0fRwAn/+jXgmVaP2TKB16b48pKRjagVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=eSSTVyWZ; arc=none smtp.client-ip=80.12.242.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="eSSTVyWZ"
Received: from [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
 ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPA
	id 7xskvbzKdtqv07xskv6kz4; Sun, 12 Oct 2025 17:21:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1760282475;
	bh=gWox/geFsIe4RTFbehyzmuN0+a+GcfkLr4VeZjCh/Lg=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=eSSTVyWZdyuq2YkVQk3tpZrlRbIdvZoC/U2B5jpKsHc1/NSTokDAcwg/qMIH3piNE
	 dUc24coC/C5cbom1UPQV+uNwOkUwfmsiA0WY0McJaL0BZrI3KjhnCdw9ywRmUB+2c1
	 1Yw7AdbC7aBDizS9BTb/AuQfANDDrfU31ie3nVfrFxzL/ePCpqmsY/LcPkedSGkBoH
	 oUnLEhM9IKHAU/VIRUaP13OPUhhpBq6s2D3e6Fr642JueN0ewQS54wcKunVG+Aq1kJ
	 zUEk4RKGnHpiFT3rCUx8AdeeAIzuwgXe6oaIfemaKsoKcN+i6ThBJvM76nYBfGnoHm
	 gvZxXr0KfQzVQ==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Sun, 12 Oct 2025 17:21:15 +0200
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
Message-ID: <d03c64d2-46c0-42d8-8f88-28669e921c95@wanadoo.fr>
Date: Sun, 12 Oct 2025 17:21:08 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/22] smb: move SMB1_PROTO_NUMBER to common/cifsglob.h
To: chenxiaosong@chenxiaosong.com, stfrench@microsoft.com, metze@samba.org,
 pali@kernel.org, linkinjeon@kernel.org, smfrench@gmail.com,
 sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 bharathsm@microsoft.com, zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
 <2AC3F0FD2E1F3D39+20251012150915.2992220-7-chenxiaosong@chenxiaosong.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Language: en-US, fr-FR
In-Reply-To: <2AC3F0FD2E1F3D39+20251012150915.2992220-7-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 12/10/2025 à 17:08, chenxiaosong@chenxiaosong.com a écrit :
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
> 
> Replace the constant of client with SMB1_PROTO_NUMBER, then move the
> macro definition from server/smb_common.h to common/cifsglob.h, maybe
> the server will use this macro definition in the future.
> 
> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> ---
>   fs/smb/client/misc.c       | 2 +-
>   fs/smb/common/cifsglob.h   | 2 ++
>   fs/smb/server/smb_common.h | 1 -
>   3 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index dda6dece802a..15be9d8738ab 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -318,7 +318,7 @@ static int
>   check_smb_hdr(struct smb_hdr *smb)
>   {
>   	/* does it have the right SMB "signature" ? */
> -	if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
> +	if (*(__le32 *) smb->Protocol != cpu_to_le32(SMB1_PROTO_NUMBER)) {

Should this be SMB1_PROTO_NUMBER?
(without cpu_to_le32())

CJ

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

