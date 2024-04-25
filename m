Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FB32135A
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 19:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714073025; cv=none; b=gXcZIehtASQrSbgUVbQznK1W3c7FR2HThp6/5F8TencTD7jyWSAli1DSClQCIfyQzZKZ2wF2lCV/a53KAuTPBZMJgEwngdvYw1AJPuZtpdpxVh53nFb+vehXuhMaLo4dwVH3J2o7jU3xOkJ+YoLyzHYh3rbx+6CpgtaErMPRYrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714073025; c=relaxed/simple;
	bh=qcLLS7MtEbDxdB6XJkTXGmgEGB7GTCg2+XThjUJS0gI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a5u9VJeZbNQwjy+XscQrvRoxAIdAAPzmPnDR3B3xSwlDDSa8lkKQ4STNEsPONDpfl3lzfSJswzrfUjuf5TGV5iFSr6WEdot9JKbAgjMNoh7dg9faH5mM0egq8HIQXo3fIbzLgA3i9Rxr95bP2Ll9rqeWSZuWCbBdcTuVwni5W8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AlpTsP0A; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AlpTsP0A"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-571ba432477so1428507a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 12:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714073022; x=1714677822; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Hrzg94l+b7iS9EDh3KlUi7r/m43so1FdRl9RA1FeHls=;
        b=AlpTsP0AINU1zD//kjTi6Q07d+pdPU2MPSVj1SD/ygB62XI8RQUObaOldmMCPBjQcw
         6pBR448sykT7c19jc4ZLLhynuo44UwXAqnVe7ReTHrWa9/FZee/ovpSAhLAfl/dwrPVh
         wfLfsDKg+s4T8AU2NrGkCeg75vw56zF/8cB9FYhKFTsrqKuVfzVHU9S/73AZLNivKo05
         qTHSDH11XLs7x1Aa8gpQSe5SIVEPYWHCh5nKgFXB+P74riuHJKaIlSqCBTwsiuC2yxBy
         WAfS78iYLPOmX9ogP69/1tXrxNqe/5Ua6WVdyneZ6NfYdwhEAzMwUrJsZJzG192kKHQf
         yHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714073022; x=1714677822;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hrzg94l+b7iS9EDh3KlUi7r/m43so1FdRl9RA1FeHls=;
        b=iwrLdhEWCONHd5Y1Z100c68nDgOvICXMEzYl99bGoi2X9UVdNbX1cYZaGNn+H9726Z
         NZQoFLVi5HbaNQGQMiRjY682fyH42gtz/KpPz1KWnuJ5Yhamz1ICfxYO11RgbfyzpWYl
         /d9nReyoarma4tOvX1GpdHSflBJY3hr5X69agK5HLeRQ4vVNaISFAMaCKvpoeeC5GCSn
         WYcn2hGfA4X57pX6J9X18k30MrYHzNfI9I40jk9Mhb6V4V37u6dFaHW9dhNi+Tm1k65Z
         Q8aI+P0x/agPmpWkNosbnuwYcpmu2LFG5Iexf50bYsSW2Gw08hxxLNNBu9TeZoWoOiIQ
         iqxA==
X-Gm-Message-State: AOJu0Yy9q4XDe+UEk5iEnH5le2xOlSA8U59yNFhkbJ6kO9ugWiEHfPTE
	aV1bu1sxitGlAqsy4AAAFXbhbkDD8lZEHNpJJQx2C9sG6J/g9a8UmYweIvWmyRxPvKa6nn9xHWO
	V
X-Google-Smtp-Source: AGHT+IGRvQvMvah8hPRNkxVEt0sXy1QEVWPWNH45REbZjZHQlCH51wQid85V1eK3SDzzdBaHBdNkbQ==
X-Received: by 2002:a17:906:e17:b0:a52:6bbd:595d with SMTP id l23-20020a1709060e1700b00a526bbd595dmr479314eji.7.1714073021277;
        Thu, 25 Apr 2024 12:23:41 -0700 (PDT)
Received: from [172.16.1.175] ([80.95.105.245])
        by smtp.gmail.com with ESMTPSA id f15-20020a170906c08f00b00a553574ae71sm9802454ejz.7.2024.04.25.12.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Apr 2024 12:23:40 -0700 (PDT)
Message-ID: <f15d2f5f-2e17-42d1-a376-3272b4460e37@suse.com>
Date: Thu, 25 Apr 2024 13:23:41 -0600
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 128 bit uid/gid (UUID) possible?
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org
References: <fdb2c85a-3692-4e99-a25b-4b17759071ba@suse.com>
 <54d8dccd-f224-4ad6-875c-774c45f9ba9b@suse.com>
 <CAHk-=wiaWr2fsvMx3EWdXRegQ9Fo5VzhRFn7cmLDErh1jhos9g@mail.gmail.com>
Content-Language: en-US
From: David Mulder <dmulder@suse.com>
Organization: SUSE
In-Reply-To: <CAHk-=wiaWr2fsvMx3EWdXRegQ9Fo5VzhRFn7cmLDErh1jhos9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/25/24 1:21 PM, Linus Torvalds wrote:
> On Thu, 25 Apr 2024 at 12:17, David Mulder <dmulder@suse.com> wrote:
>> What is the possibility of increasing the uid/gid size in the kernel from 32bits to 128bits?
> Nope.
>
> We don't have user-space interfaces for it (st_uid is 32-bit), and the
> pain is not worth any theoretical gain.
>
>                  Linus
Ok, thanks. I'll move forward with id mapping.

-- 
David Mulder
Labs Software Engineer, Samba
SUSE
1221 S Valley Grove Way, Suite 500
Pleasant Grove, UT 84062
(P)+1 385.208.2989
dmulder@suse.com
http://www.suse.com

