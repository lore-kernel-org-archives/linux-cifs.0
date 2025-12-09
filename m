Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A192367CE;
	Tue,  9 Dec 2025 00:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239445; cv=none; b=acDKcJ4KOVtkGaSbRsgaLm8yhokxKinpLAYiIjobYb182tx+qacAAQsYhpxApLsQmNTfNg9U40hlj9uQnyk+h7W8enTscMFY5sZcnb9N22Y3jOuLrF2pZaIY9z3EDocMaguqzOsuycta+WonzFQtZtiSrK3I5LpsBCtZZ/xRLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239445; c=relaxed/simple;
	bh=2kioe1iLcrJ0bZwBfz7LBtD+yA6vX3AuhEnFDvpzjFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ArLSb9Jv+ozkipHFz8vinypoA28W+P9FVHSwHqIzD22DWcssU4atnpapOEHhj06qtBXCsW6tFGLtmHlRtfIsBMGoUpU72hTl4yWu/zrAGvysCEzwcQv0nAQqiEGoPC+p/sRRk+j53QQe/E+fvGZboXKwQG+I8yhY579zpKBcWTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 6a62cfa8d49411f0a38c85956e01ac42-20251209
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_7B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_LANG
	HR_MAILER_MTBG, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS
	HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED
	IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED
	SA_LOWREP, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:f107c090-ed9f-4872-b3e3-0e3ddc3d7fa5,IP:10,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:6
X-CID-INFO: VERSION:1.3.6,REQID:f107c090-ed9f-4872-b3e3-0e3ddc3d7fa5,IP:10,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:6
X-CID-META: VersionHash:a9d874c,CLOUDID:f1905d3260c0dbc3092b470ca5d85a49,BulkI
	D:251209081716TZZ7JI8T,BulkQuantity:0,Recheck:0,SF:19|38|64|66|72|78|80|81
	|82|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,
	RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6a62cfa8d49411f0a38c85956e01ac42-20251209
X-User: chenxiaosong@kylinos.cn
Received: from [192.168.43.10] [(116.162.231.116)] by mailgw.kylinos.cn
	(envelope-from <chenxiaosong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 858923963; Tue, 09 Dec 2025 08:17:15 +0800
Message-ID: <93da5441-e942-427c-aa7f-138d7e750ca5@kylinos.cn>
Date: Tue, 9 Dec 2025 08:17:07 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/30] smb/client: fix NT_STATUS_NO_DATA_DETECTED value
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
 smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251208062100.3268777-2-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@kylinos.cn>
In-Reply-To: <20251208062100.3268777-2-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve and Namjae,

Some of these macro values seem to differ from the documentation 
(possibly due to typos or updates in the docs). Should we, like Samba, 
use a script to automatically regenerate these macro definitions on a 
regular basis?

Thanks,
ChenXiaoSong.

On 12/8/25 2:20 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> This was reported by the KUnit tests in the later patches.
> 
> See MS-ERREF 2.3.1 STATUS_NO_DATA_DETECTED. Keep it consistent with the
> value in the documentation.
> 
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   fs/smb/client/nterr.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
> index 180602c22355..4fd79a82c817 100644
> --- a/fs/smb/client/nterr.h
> +++ b/fs/smb/client/nterr.h
> @@ -41,7 +41,7 @@ extern const struct nt_err_code_struct nt_errs[];
>   #define NT_STATUS_MEDIA_CHANGED    0x8000001c
>   #define NT_STATUS_END_OF_MEDIA     0x8000001e
>   #define NT_STATUS_MEDIA_CHECK      0x80000020
> -#define NT_STATUS_NO_DATA_DETECTED 0x8000001c
> +#define NT_STATUS_NO_DATA_DETECTED 0x80000022
>   #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
>   #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
>   #define NT_STATUS_DEVICE_DOOR_OPEN 0x80000288

