Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FBF487BE
	for <linux-cifs@vger.kernel.org>; Mon, 26 Jan 2026 01:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769389585; cv=none; b=bKsuDK8pO14sTvJgekUBg0T/Bm5ipZyJl38kLiIWJehBRiClNqKJxQUAkTbILUvOhlpTL6OR4cHNhReLAMyAkntWPAKlbGLRGG4Drgs40v/OdslM9IxoNxYUaTVFNdYk9FAE2Iz/8IICqQWq2BYKnawJTfpKoLkVW41Den6OEJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769389585; c=relaxed/simple;
	bh=/47TYBrga9IeIm0khcfVs19o8N+gdIMJ/AX5PYO/N28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JZVRwyKSPoPxo7yxz4ja6NNwN20wetOdd22Wa/x9BRJvh42J4GOcAySaJ2mKQegQBSKomdm7OzIOFyLC0f7rU3CEXTvbfP/luMLKSvE1IeHsWxeoapBKytMdovQpsdzrk+fGFsNx55zJRcSKVaxGNY6fgeFvDEHINmQqjBQmosg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YZpD2zV6; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YZpD2zV6"
Message-ID: <f063be7f-7d09-4f07-9a44-7c8f1484de25@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769389580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t/WgvXxTG03zzIYztM1YjVL8bEbGZbcXzqgLSgsGDKI=;
	b=YZpD2zV6Bx5oqGUtNwmPJSLo9U+hJujHQHUHc5frQE5trzH/HB31NOtCfM+izfMKVVqJRO
	Y6TlqgymyI3Mo1OyGlyIu5nqX/VY+mY8R2tqeY2VNRg4FNfijZhIgCBHLg+4KJqaWQkImK
	U+XoPAAwp1qXE+JFCfQTSi7H69x54D8=
Date: Mon, 26 Jan 2026 09:05:30 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Decimated subseconds in smbinfo filebasicinfo timestamp output
To: Sam Denison <dev@denisons.org>, Steve French <smfrench@gmail.com>,
 Steven French <Steven.French@microsoft.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
References: <n3ma17AT6PhgrI6OfkbdTz3n_ak9jHfcYoGaAOdyxsY63h-GVDNpzS98XsQlTPN6r2nYxdQ_ODsxNX7fPh8J0PpSJ7-Tvt_8uqjtpfQamGw=@denisons.org>
 <hrQNBHikNUU26Klip-roC5Vuq474cWlMtfx-yvROP7k6iAyEW66dCc8negCRm4xdOuRqAQDa346BJQKyFLl3HveGykv-jkKihJarU5MYpFQ=@denisons.org>
 <f147af48-6c01-47f4-ba51-71b77c1ea94a@linux.dev>
 <Sj-xdM9FhG-h2q9G9x6pAEQN2TZEyWvq3Vh66-KRyGXnoDxar4KfSmsStO9n2mWnJgez0zqgn7STXBXjedgRKRLs23ql190kfqKNrl1J48Y=@denisons.org>
 <LV9PR21MB4757D8624474C50468BEAE81E48EA@LV9PR21MB4757.namprd21.prod.outlook.com>
 <LV9PR21MB4757E63CE7D0DE2610AF2655E489A@LV9PR21MB4757.namprd21.prod.outlook.com>
 <50b282c2-6a06-42cc-b52e-b545fd8d9e01@linux.dev>
 <hAshiKr_dint37zHnaRbpo9UNdT9my5xllqfyLLXWYZR5jpRVn2lpTvzgWWng3w-INoptu8YHCUMVtda0JV-ekS3zNGePJgJMqL3wKw6HWQ=@denisons.org>
 <CAH2r5ms02k4feJEmfzenU-DgFMSDFDiCc1=o_JpyaiWcnOU1Tg@mail.gmail.com>
 <shU8wpo2oNyUu4RkVuN0VHmIES1SzKRN9in6AJDn4EKDDGwMkzl2ShJ8i-4AfFOSKDDnEhxZVGH_w8y9JxO683d_QQzMJOig7eOb0AmaFBs=@denisons.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <shU8wpo2oNyUu4RkVuN0VHmIES1SzKRN9in6AJDn4EKDDGwMkzl2ShJ8i-4AfFOSKDDnEhxZVGH_w8y9JxO683d_QQzMJOig7eOb0AmaFBs=@denisons.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Acked-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/26/26 03:26, Sam Denison wrote:
> From: Sam Denison <dev@denisons.org>
> Date: Sun, 25 Jan 2026 19:15:01 +0000
> Subject: [PATCH] smbinfo: fix decimated subseconds in smbinfo filebasicinfo
>  timestamp output
> 
> The output of `./smbinfo filebasicinfo /mnt/file` is as follows:
> 
>   Creation Time: 2026-01-25 19:15:01.070729
>   Last Access Time: 2026-01-25 19:15:01.070729
>   Last Write Time: 2026-01-25 19:15:01.070729
>   Last Change Time: 2026-01-25 19:15:01.070729
> 
> The output of `stat /mnt/file` is as follows:
> 
>   Access: 2026-01-25 19:15:01.707294600 +0000
>   Modify: 2026-01-25 19:15:01.707294600 +0000
>   Change: 2026-01-25 19:15:01.707294600 +0000
>    Birth: 2026-01-25 19:15:01.707294600 +0000
> 
> In `win_to_datetime()`, when converting `usec` to a value in seconds,
> one zero needs to be removed from the divisor.
> 
> Signed-off-by: Sam Denison <dev@denisons.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  smbinfo | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/smbinfo b/smbinfo
> index 57e8a0a..a168186 100755
> --- a/smbinfo
> +++ b/smbinfo
> @@ -428,7 +428,7 @@ def cmd_fileallinfo(args):
>  def win_to_datetime(smb2_time):
>      usec = (smb2_time / 10) % 1000000
>      sec  = (smb2_time - 116444736000000000) // 10000000
> -    return datetime.datetime.fromtimestamp(sec + usec/10000000)
> +    return datetime.datetime.fromtimestamp(sec + usec/1000000)
>  
>  def cmd_filebasicinfo(args):
>      qi = QueryInfoStruct(info_type=0x1, file_info_class=4, input_buffer_length=40)
> -- 
> 2.43.0

