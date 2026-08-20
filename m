Received: from mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831B541D137
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 12:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787227698; cv=none; b=Sb7htTzRXLOOqf+GB5S1GhqRV+PR79kXuobgeewdudUC5jJqorCdgV95/Kg57pHL0NMkwdPyIbbFZWIUC9L2ntItSe+PQvvHpCrCvDNAoNBc0Ah/2HKLye8De0AzfFJSEtBrN6JiLiEf5vR0y6OFv6S3p8SY38o2ZhQ1Qifq9Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787227698; c=relaxed/simple;
	bh=vgny4D2aPLKQnBlfK5jVcAFyk20WUJumWNScihOshyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ntLQfrHGWrM5A0Cv4x3MYidxdiE6lCqAN/PyAbKD4lYMOFPzwD/kVRPiUmuewnM1OS4kghkcw02rJehM0tDa+zad6p+v1q3Ri+fh3pxEbnXa5FblvEERRnrEvvv6uAJrkoJNDwI2yyumFnvh1+ov5vt2KFJrHGDqbfC6bBC3dFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=OzwrMxF1; arc=none smtp.client-ip=91.218.175.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="OzwrMxF1"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vgny4D2aPLKQnBlfK5jVcAFyk20WUJumWNScihOshyk=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787227690; v=1; x=1787832490;
 b=OzwrMxF1wgv7HBSyfbPHzfdNPv1yd7dW6tXaYQC859rd7mfzFD5RAsCGd0Bbjc3a+PMHsufK
 G8Ixyxs7P9YkHAMjurKVY6dKUt1tujYP5PGzHmsYKGMvqhIyhiBAqg5iiNEN8V50p0rc3b4guea
 O34o73AMqjriT9QFNjDM4OM/uFg6XP1tIuJ2eKYvMMCvM1U7/FmMaLp7o33XFLBbLd4RTQww7B9
 xwVgyA0IuMJA0T7STxDJGnA/+YgjoedOZ2dYXr1Ej+OEBR1u809ypy4vvkOT6iMvntXAxHTNITn
 kyRlDioCjQzTZuyTR0h/hTVQ8Br1Qmzg4wyZMkDLLLn5A==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.3.216] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id bab8d4d1e5583619;
	Thu, 20 Aug 2026 12:08:00 +0000
X-Mizu-Trace-ID: bab8d4d1e5583619
X-Migadu-Flow: FLOW_OUT
Message-ID: <ce39a657-a941-4f57-be46-8208d7ec0e80@chenxiaosong.com>
Date: Thu, 20 Aug 2026 20:07:52 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: update ksmbd repository URL
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, Tom Talpey <tom@talpey.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260817134521.5505-1-linkinjeon@kernel.org>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260817134521.5505-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It seems that repository URL on ksmbd-for-next branch has not been 
updated yet:
https://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git/tree/MAINTAINERS?h=ksmbd-for-next#n14134

On 8/17/2026 9:45 PM, Namjae Jeon wrote:
> Update the ksmbd repository URL to the kernel.org
> ksmbd-for-next branch.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8014b9f8253e..438e3a714c4c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14140,7 +14140,7 @@ R:	Sergey Senozhatsky <senozhatsky@chromium.org>
>   R:	Tom Talpey <tom@talpey.com>
>   L:	linux-cifs@vger.kernel.org
>   S:	Maintained
> -T:	git https://git.samba.org/ksmbd.git ksmbd-for-next
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git ksmbd-for-next
>   F:	Documentation/filesystems/smb/ksmbd.rst
>   F:	fs/smb/common/
>   F:	fs/smb/server/

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

