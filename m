Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B3674429
	for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723820128; cv=none; b=OInUwY57l+LD/M+pmzhzd1FUQEV+Gq8drsmDTQ5EPGGQr8nlLhXijILvXzWcJVoT0IJTbFgqwfD+8iKwgQQYZk9Bjc5sf0XeodsXpUtH9Aa+jFDaJ7xBb7smILmrWg43Kyfa8eviwqdDpw1tSVoY3SLZzzaAT5uHJ0tMQfdfJlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723820128; c=relaxed/simple;
	bh=VoQiIJrIQusDqnHZySReppgWD7UaavkT1QhYYFY8ve4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W4TckxBqXojZk2Dm5QlF/wkLwRNFobgTRt2CBGcJrML2jvBj7i2rPwkbbdvrDLQro+dIs65nKVYhWNyFIGnIHPKr8C7gG3nRVazP2rJz3hpogVMWmYIzZgqOPrqB7GfBwBx1PythscdI/3heAc0G2Rp/7+TXGyn9kQ61GjP0WhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=N/C0FDWk; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="N/C0FDWk"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id ehZlsKJJ01zuHeyMKse53S; Fri, 16 Aug 2024 14:55:20 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id eyMIsSeSWV2iveyMJskhyB; Fri, 16 Aug 2024 14:55:19 +0000
X-Authority-Analysis: v=2.4 cv=OLns3jaB c=1 sm=1 tr=0 ts=66bf6857
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=NEAV23lmAAAA:8 a=ZI_cG6RJAAAA:8
 a=alU95Sm2MMlWhGzB8lQA:9 a=QEXdDO2ut3YA:10 a=CiASUvFRIoiJKylo2i9u:22
 a=Xt_RvD8W3m28Mn_h3AK8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/aO0IehE+7/fYXCfrfFzhvZT0xU9URY+btu8wctBFWk=; b=N/C0FDWk/VnWp6U20SwjZk9CZ+
	XWHHlWfWUgboEvQn9JIp/BJ1409HG88TCP7JbQ8ndJ+Eu96Gjm+sJGR9PfvrbX7SXBEiSuCX5Z6BM
	iWq3AI8z7HhuJoVtgSjXAoT3N9tz6uH6Sap9u33VScN7KJLAdCMlUnIG1ubaAnVB14bh367y5wNjy
	U8PgqwSRke9eM+ZFOpv4CN3hZ0BJpna0MynEGMIC6AlDZyKbBx534NVlm3rIIYFZfcmk0FfSVhq17
	FBnt1cTrw3VNhY/a75YgX8C3mFhtKtwqVlb2KHuDSE5pK8icictpNNKMRdG29Kn+kGnq7Z5CVkJ2/
	hKaXyNFA==;
Received: from [201.172.173.139] (port=34976 helo=[192.168.15.5])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1seyMI-000mkl-1A;
	Fri, 16 Aug 2024 09:55:18 -0500
Message-ID: <f94ee92b-90e5-4af8-81a7-998040dac7b1@embeddedor.com>
Date: Fri, 16 Aug 2024 08:55:06 -0600
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: Replace one-element arrays with flexible-array
 members
To: Thorsten Blum <thorsten.blum@toblux.com>, linkinjeon@kernel.org,
 sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20240816135823.87543-1-thorsten.blum@toblux.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240816135823.87543-1-thorsten.blum@toblux.com>
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
X-Exim-ID: 1seyMI-000mkl-1A
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.5]) [201.172.173.139]:34976
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBMin+AWpGs2W1WELU+taO8sg7+w1+nu7H8j2PKs9jyANw+5K+irtFishm+wjMvezZlZYy0N33bv8iNQBoMmw2gS9LipvQUablRkbPJdERaRk+jJRLQw
 PkOmr/Y/12m9nsUtygbVZzfv0mFCF+2xTsnjcCL4puoVQQMO56syr+iRKwgeh8lE3fu0PNUHAAHnKULzCKBb8YqSuEEJ9QOppJiwEPV7apUzQPrhNHWEr2Ub



On 16/08/24 07:58, Thorsten Blum wrote:
> Replace the deprecated one-element arrays with flexible-array members
> in the structs filesystem_attribute_info and filesystem_device_info.


Notice that this also affects the size of the involved structs.

I encourage you to study some of the patches that have previously
addressed similar issues.

Thanks
--
Gustavo

> 
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>   fs/smb/server/smb_common.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
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
