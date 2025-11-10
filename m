Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A461DFCB
	for <linux-cifs@vger.kernel.org>; Mon, 10 Nov 2025 03:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762743676; cv=none; b=RL5tbOagdb+/Ir/vQVf1s7cD3SLl9XshzdC6aeX7ChVsR6SPQCiJRCqvm7enBam9lN2mSBjrf6Vrlwjnz6tL5YalZaoTwdHhLD2REqVwJsDlnfSVubTGLwVayafTso0WsDZ3jo7bmpcB/CWFQaY7fzmLAO+Jig8pAdHR2RLNaLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762743676; c=relaxed/simple;
	bh=+84QnBsVVdsCuhps5C49iaar9LrBydi4qBmA2hVjiq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RuEX8t10m85V80WPfVCwUAWoZQFNFHHFvp/7NjOuoIhb6BVZK97HG3ifAHu3BdtBEwQMCCXE1crlPWPvUQMp7vK5epgwkpRqFCg4dge5ze8rHGcbVwwH5dRVafsUz5G6wQKhPUtpzntI/jyNsc45jpvEhJnXfJEo/hb81t5xxBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b=xKfEz9Ra; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b="xKfEz9Ra"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-340e525487eso1643224a91.3
        for <linux-cifs@vger.kernel.org>; Sun, 09 Nov 2025 19:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chenxiaosong-com.20230601.gappssmtp.com; s=20230601; t=1762743674; x=1763348474; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A+voFDrXrCM87+peuz8yiopLM44rOhYZ0LXpFder8Gk=;
        b=xKfEz9RaxIFkxBU5DKEpfZAOQkYY5BmuqTA9Fvkb/NTTaxqVsohG7a1OnuVInO2+xM
         rTNXK6ppZRGDGjZtlKHQ4c4cLyMTIlbc8q0juzl0StgtZWZP7rp6BuAqv1KzxY0gC/D8
         4Tjap8k3PgGca/mVpHT1hxFnI+O8Au81oLR8bp2U8q0WMMkTlUrFNfWYNUpULpowLqfQ
         Bdu9NOWyqOX4aoBgbvyU9JUoSXTxbQm5cx9oZEGaLw/ilbxVatvALCymWLxk8zncPf1I
         bfIdJTrHKvRhKmFVbeXV5cR2nTvl3s1BLNaHYGAs/3H5in22pD0Vj2rxZV7lsQ8aGs07
         ODzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762743674; x=1763348474;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A+voFDrXrCM87+peuz8yiopLM44rOhYZ0LXpFder8Gk=;
        b=bZGZTBr/X6k9xO+SwzZKyQuQ+bz5GVYF2UFj5ojUSVAqoYY3ZEBEdBLjlDbjuOddXb
         ba2BDOwKP5BYgFE5dNidZovBGPBWMe+Ik0k9NgY2UFkpAMC4a8uaHCvcsvJLJtMcqT3+
         ezF+IsvDfHTIEQTD7SaznLxDF7Wd4ws6OxS2TNsTXyMwjw1G/mvUUpBJUVMyE0a4Wy1u
         WYvnjefz9gL3qaHVFpXADUbXyuyXhY6atYs/6hC5uOtE+MiySs8Jio6kS8GyamcZSx8/
         T6KG0HCs9avLZk7pGuvZ8t3yOGY4DxCU9vx/Z1rHlX0N6y0EP7IRRfmVrpjhx/wJLR0l
         l2HQ==
X-Gm-Message-State: AOJu0YyRAnC/c4UzoOTT4dfzamHJbsjJLa+BAtljnzHmXxGijzZ60imV
	2Ruw1jk+gEbav+I5smy+HqskT2UKOIH8dAWijD/4sDGYPfXmn2Wdgc14UTnHar0emLU/
X-Gm-Gg: ASbGncu61uhF78E4ip1PRowRZjSZd82SKY7iiYMmNrU8bAPJZNHb5b/KDSBTndcMcfW
	TGyoIAZJ2JSWPgHJiHevX6d8q+7+0wSuWtyw4pzr/ptgFzWxBkqKyUbOdUw/WljD0tjr9JJWO+3
	s93ECflh1pskXRtVnVRWYu1aftE/9EEfdmrMviKOqpYXN3iRKW5X8rAU46djkYmadteQ6NKZ6iA
	44AjEhyNLNBqgR69W9aMhE6yqPcyZO+JU9QZHvnR3luzQnyXGz6kedei9Blgt7gSeE90kXlivu7
	JK76xYqXXebpllDTxFFoT1nhsrB6TGb1rncRxtjRiZGmhcpn6L3ryrFaSZsRXo5eP+0Y+O0To/5
	7bAs/NgKuy1M8y+C1Y34Fv6dk8tBWKg9iXaEt9NYVjove2kz1X8M5eexlVquhaqn2Zzm2d6j3Ok
	VAAH9W3+/aaFmUGtY=
X-Google-Smtp-Source: AGHT+IH3kU22cayYpB3uvxi+TsnfdKjrxOtEnU/6uCtN1MF+4C1tiS7NqTfSXvj5c//Jgp29cS8Big==
X-Received: by 2002:a17:90b:2f8b:b0:340:ad5e:c9 with SMTP id 98e67ed59e1d1-3436cb9f0a4mr10187817a91.16.1762743674141;
        Sun, 09 Nov 2025 19:01:14 -0800 (PST)
Received: from [192.168.3.223] ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3436b9fa1c2sm5926194a91.14.2025.11.09.19.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Nov 2025 19:01:13 -0800 (PST)
Message-ID: <0976729d-7c4c-4a15-9c01-bbd03e270d7e@chenxiaosong.com>
Date: Mon, 10 Nov 2025 11:01:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] smb/server: fix return values of
 smb2_0_server_cmds proc
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
 smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve and Namjae,

I have tested the following patches using xfstests and smbtorture, no 
additional failed test cases were observed in the test results.
   - [PATCH v2 0/6] smb/server: fix return values of smb2_0_server_cmds proc
   - Patches applied to the ksmbd-for-next-next branch
   - [PATCH v5 00/14] smb: move duplicate definitions to common header file

The detailed test results can be found in 
https://chenxiaosong.com/smb-test/20251109

Thanks,
ChenXiaoSong.

On 10/17/25 6:46 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> These functions should return error code when an error occurs,
> then __process_request() will print the error messages.
> 
> v1->v2: Update patch #01 #02 due to typos.
> 
> v1: https://lore.kernel.org/all/20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev/
> 
> ChenXiaoSong (6):
>    smb/server: fix return value of smb2_read()
>    smb/server: fix return value of smb2_notify()
>    smb/server: fix return value of smb2_query_dir()
>    smb/server: fix return value of smb2_ioctl()
>    smb/server: fix return value of smb2_oplock_break()
>    smb/server: update some misguided comment of smb2_0_server_cmds proc
> 
>   fs/smb/server/smb2pdu.c | 30 +++++++++++++++++-------------
>   1 file changed, 17 insertions(+), 13 deletions(-)
> 

