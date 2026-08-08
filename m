Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7615628C037
	for <linux-cifs@vger.kernel.org>; Sat,  8 Aug 2026 11:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786189751; cv=none; b=ir2qL7DLFV2fOE61NcNS9Gg5UhCz/OwCWqBVsD3DajjtIRynikhdxxRDrgyWeXwiXP69yV/8P7RZPTGNoIu2XUeSkFWtNr9vN/UEFoREVdM0Qg2hnts66bJVapHJlEHw/+R2/93uTF8M/1K8TYax7TTumOr8sEQ1KwKp0+ZVLCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786189751; c=relaxed/simple;
	bh=Ut4Zg0s7pL0EMuEXaePg0FhucyOGTC7i50A3hr4v67U=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=TyxgBU3VWFxIOK5qC8AwFlTBpFZLYvyv/t6+gKawOGCyWDLvW2YK4pYEkD2HXVXGLz22xaFwDEGZy3n8g0uEgCv/IAtY59boDOJA/3fY0l4xHSuQ+JAw6PdxEW2uxJf/TGA3qwJP0pXHFJzxPDSuO0L9gxRqwNZgwymHcUX7qZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=dcslgbrA; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="dcslgbrA"
Message-ID: <fff5c001-6349-40ef-8d8c-5375b03177da@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786189745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4K+uHR2GKZTm9nWcAL6KggFwYlUBJ6h6IgtoVLK89Ug=;
	b=dcslgbrA4skk8Qf786YsKvCmbmdqu/sGc3PON8oYqF2NpuJ7WbtpRxsOSNf4cnHbkHweps
	joVXVdprr3ABKVx9k1WY5iaeoIjV1o+WXBJa75Tvo9Y3ew59l4sAQi1Oq/FDTBfnnp3w22
	sI+ex0AvO+BIKAE7xSdjvzGU3LpwUH6NFMzuAvuLqXcLV2dudMRTASgSR1sRqmM6CbM1NK
	nmvvL0PuzP0ryiIj2/r86WGoB7zfikbCSZZ9PhnJaEbLNodH7ADaYP6ZlO3jHYPvYylHQp
	yfTRHIIDwECJHfff4bNxjo+i+gwLsMcyL88K2JNDossHBHDRznDj6zWnFaPA/Q==
Date: Sat, 8 Aug 2026 19:48:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: Fwd: ksmbd NTLM challenge blob heap buffer overflow (pre-auth)
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: vova tokarev <vladimirelitokarev@gmail.com>,
 Steve French <smfrench@gmail.com>, tom@talpey.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org
References: <CAGBKPgMzL+67L=wrKoCoOq-OQWW1enRLYUtUTHwcPSZ1vt0T8w@mail.gmail.com>
 <CAGBKPgOX-cc8FkeUfBZvUFEABH6dMmKj28jv1w+xatn4+dvYQg@mail.gmail.com>
 <8231ce4e-2a6f-4177-a7e3-5c210ae9a44a@chenxiaosong.com>
 <CAGBKPgOi8DS7qjgP_MD7_3zUEyikFBK-8mEVwoJS8rDjYznWRw@mail.gmail.com>
 <a5776b98-7b5d-4c30-bd2a-f690b7ce7323@chenxiaosong.com>
 <CAGBKPgPm7X4=5Mi_AZOE12vGCZxQR0s_ax5Cmnibqvtc_6V4nA@mail.gmail.com>
In-Reply-To: <CAGBKPgPm7X4=5Mi_AZOE12vGCZxQR0s_ax5Cmnibqvtc_6V4nA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

We have confirmed that this issue does not exist.

On 8/8/26 17:34, vova tokarev wrote:
> Hi ChenXiaoSong,
> 
> You are right. I missed that ksmbd_startup_request.netbios_name is
> char[16], and ksmbd-tools strncpy's to 15 chars max. The kernel code
> is missing a bounds check, but the name can never be long enough to
> trigger the overflow through normal operation.
> 
> I apologize for wasting your time on this. Thank you for the thorough
> debugging.
> 
> Best,
> Vova
> 
> On Sat, Aug 8, 2026 at 12:42 AM ChenXiaoSong 
> <chenxiaosong@chenxiaosong.com <mailto:chenxiaosong@chenxiaosong.com>> 
> wrote:
> 
>     Hi vova,
> 
>     I am using the same `ksmbd.conf` as you, the length of the netbios name
>     is 202.
> 
>     After debugging, I found that the maximum value of
>     `strlen(ksmbd_netbios_name())` is 15.
> 
>     ```
>     struct ksmbd_startup_request {
>              __s8    netbios_name[16];
>     }
>     ```
> 
>     I also checked the ksmbd-tools source code (Link[1]), and it copies at
>     most 15 characters:
>     ```
>     // ksmbd-tools.git
>     // mountd/ipc.c
>     static int ipc_ksmbd_starting_up(void)
>     {
>     ...
>              if (global_conf.netbios_name) {
>                      strncpy(ev->netbios_name,
>                              global_conf.netbios_name,
>                              sizeof(ev->netbios_name) - 1);
>              }
>     ...
>     }
> 
>     Link[1]:
>     https://github.com/cifsd-team/ksmbd-tools/blob/c0ce0753144adab006552ed42e6862758ed6929d/mountd/ipc.c#L162

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

