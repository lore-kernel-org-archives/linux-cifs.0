Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1239052F62
	for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 19:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723836067; cv=none; b=Yxu6xMUAU9L+7FJ8o+bFupIiE5GVwdppeueUpQDvdSSabGIvoijtn9izk8QFl826R5+zX0LO4bbzmV1CIiDId63qUr7Bh9Z/SQliHaiWSN/HugEEZe+6chT6gfCLKFVh73GEybN0C3YMmUMYA6sVvB7x0aQa+I+HyWN9QVMiZco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723836067; c=relaxed/simple;
	bh=Q9DpMv+if1CmKf2ixK4q2lvGb4jtNSOrHPK87jbMl8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vEbe3vAol5sIInE8Be2ldoCgCp1QT8jvb2wT7wDSIektHHAOrHKTxGEYG72qBhVy0VTBrLUMb0mI2AbyKwJnONVz475ed0mkjazkp5tv9t8yf+fI+uo9Qk8sSRwS3+Q8SKmJFcBmznSbiwj8txaBrWmPRrBtrEP6q8i1TNzanAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=pVqpwAi5; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="pVqpwAi5"
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTPS
	id f2MRsV1aSvH7lf2VNse8to; Fri, 16 Aug 2024 19:20:57 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id f2VMsJTNyX56wf2VMssOIC; Fri, 16 Aug 2024 19:20:56 +0000
X-Authority-Analysis: v=2.4 cv=MY6nuI/f c=1 sm=1 tr=0 ts=66bfa698
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=NEAV23lmAAAA:8 a=ZI_cG6RJAAAA:8
 a=VwQbUJbxAAAA:8 a=ZFko2LWrkM6SFP1H4WMA:9 a=QEXdDO2ut3YA:10
 a=CiASUvFRIoiJKylo2i9u:22 a=AjGcO6oz07-iQ99wixmX:22 a=Xt_RvD8W3m28Mn_h3AK8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=y71hsJuD1WvZjKeA1zp1KFv5H3E6TbghnCUkerfbnQY=; b=pVqpwAi5Tp1jSNMbjUaPbdJ7V7
	4R5HZnDypRsQJEY6ltkcbub/GFIfy3Fdk108WCYLuOhwJteE0TIrbBR2f8TFmye5sexvbWbHpOtN5
	Ixw88FuTqiE/Otl06YQE4pfGTYqNCNCpO6zbmfEILBtNnqyFlh0ID+hg2BSZ+guDMitI73l+Cjztv
	iO3w+TEIeFt7T+CXck/9yWDFyM0DV8TJW+9jdgqn7vjN90Xc4EZ53QnPQ4FbBc5dcS99LDKzaSQrr
	i6iO/MSOC1mCMDgkTdHLcbHel2IdyhSx+dNZ6pRRV/VmE4AQS8d3UnTWllVZIACvZlv6EWJIDZiLJ
	XhgQZeQg==;
Received: from [201.172.173.139] (port=50158 helo=[192.168.15.5])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sf2VL-000d2Z-2p;
	Fri, 16 Aug 2024 14:20:55 -0500
Message-ID: <a5663c6f-8061-4682-ab89-e4dec40ce9a3@embeddedor.com>
Date: Fri, 16 Aug 2024 13:20:53 -0600
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: Replace one-element arrays with flexible-array
 members
To: Thorsten Blum <thorsten.blum@toblux.com>, linkinjeon@kernel.org,
 sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20240816173338.151113-2-thorsten.blum@toblux.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240816173338.151113-2-thorsten.blum@toblux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.172.173.139
X-Source-L: No
X-Exim-ID: 1sf2VL-000d2Z-2p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.5]) [201.172.173.139]:50158
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLyZ+P7I5AEeYnxAFT/YJgEgpWEf/EmFCpWKZqwFAdSzTxzL580YEGYz/PHMz0ajeXpJbtwXq9sye2lh1c3q2ksfqbAaffY8SLIqGGYOOgvgqtU8VH+A
 65/T6QmfsLzjCe2V914VtFi+cVxN1Dckn7r/D9oLeeMyK+MjrDINiUFytp6E2eTfMtGG8Fa+MeDHwppKEzyp0hN2flj6YqsihjGZUqCJzr2NUHvfOSX73IzO



On 16/08/24 11:33, Thorsten Blum wrote:
> Replace the deprecated one-element arrays with flexible-array members
> in the structs filesystem_attribute_info and filesystem_device_info.
> 
> There are no binary differences after this conversion.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>

Looks good.

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-Gustavo

> ---
> Changes in v2:
> - Take struct size changes into account and do not subtract 2 additional
>    bytes after feedback from Gustavo A. R. Silva
> - Compare the binaries before and after the conversion and add a note
>    that there are no differences
> - Link to v1: https://lore.kernel.org/linux-kernel/20240816135823.87543-1-thorsten.blum@toblux.com/
> ---
>   fs/smb/server/smb2pdu.c    | 4 ++--
>   fs/smb/server/smb_common.h | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 2df1354288e6..1ce747b4636b 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -5357,7 +5357,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
>   					"NTFS", PATH_MAX, conn->local_nls, 0);
>   		len = len * 2;
>   		info->FileSystemNameLen = cpu_to_le32(len);
> -		sz = sizeof(struct filesystem_attribute_info) - 2 + len;
> +		sz = sizeof(struct filesystem_attribute_info) + len;
>   		rsp->OutputBufferLength = cpu_to_le32(sz);
>   		break;
>   	}
> @@ -5383,7 +5383,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
>   		len = len * 2;
>   		info->VolumeLabelSize = cpu_to_le32(len);
>   		info->Reserved = 0;
> -		sz = sizeof(struct filesystem_vol_info) - 2 + len;
> +		sz = sizeof(struct filesystem_vol_info) + len;
>   		rsp->OutputBufferLength = cpu_to_le32(sz);
>   		break;
>   	}
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index 4a3148b0167f..cc1d6dfe29d5 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -213,7 +213,7 @@ struct filesystem_attribute_info {
>   	__le32 Attributes;
>   	__le32 MaxPathNameComponentLength;
>   	__le32 FileSystemNameLen;
> -	__le16 FileSystemName[1]; /* do not have to save this - get subset? */
> +	__le16 FileSystemName[]; /* do not have to save this - get subset? */
>   } __packed;
>   
>   struct filesystem_device_info {
> @@ -226,7 +226,7 @@ struct filesystem_vol_info {
>   	__le32 SerialNumber;
>   	__le32 VolumeLabelSize;
>   	__le16 Reserved;
> -	__le16 VolumeLabel[1];
> +	__le16 VolumeLabel[];
>   } __packed;
>   
>   struct filesystem_info {
