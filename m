Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AFD60EF9
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713194908; cv=none; b=MRSjoS/u+QJX27+Swz3kyjPOyJ49Q/GZ5VO0WDE2iJhpDd0GjEyRdMqDxyHV6+l2/5xCuvKQwt6+IVnSu2VMJsEzaw2AbPtf1uTSLyDnJ2weJeJ2wvXTrrx5NwNW7nzGjaTME9M7xNYQdF4iwFs/hkPLIVrkAWzEFJHrabcaOEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713194908; c=relaxed/simple;
	bh=c5e4e1nOVssGHsQkIPAJwVLWUaWI6IWYzp92JCq8Vdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ls6lcQyKHiTdjoMdpWlOWl8NR83CSToLWaEjoTl9J1RW70suwETQR7Sq/ZuGTiMheNvnm3OSjeyEOw+Bf1VO+fGGulZ5IhtXQNKHDCllFW604bIuptoArv8dqeHr1H4y/xEP1mk0/U6NRdksg8IeugrshTpJJyigCFTDdrpkzrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=draigBrady.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bMecOI0Z; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=draigBrady.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMecOI0Z"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4187991d01bso4124025e9.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 08:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713194904; x=1713799704; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ONdC2GQJW6N/G7wsYw1wp1reVXg0D6tTQEqmN9QLb4s=;
        b=bMecOI0Z2RZoZibcFkTCpOF1d3whZ9Y/BLoZDyDek+t+Xosnyq+kytyGCaPvhpYZXv
         0J9zYA9ukyNivH89due7x5PsF/LL7yjWxVrzy/xJSU5YGw4xAhux0pFUYdyJt9mHfA2f
         tqJde25auJHlyoBJaB0QjnlQLyHQllRRFzaN45mjHfXkyIqRT8z7ZxuruGQ/3ZJ8hzPi
         SAAAHqnCUAyXhDnFLS4nqaNzwbmHlmyv3Fi2VH1rdYuPVW3bUfD/9qF6h/GXlED0MsOj
         7Wzh14jFSWsyC//UxWKCWerdJJZuX0oowKNh40WNc+nhAVbiAnOsINPaH/2IUeRgYmHW
         BeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713194904; x=1713799704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONdC2GQJW6N/G7wsYw1wp1reVXg0D6tTQEqmN9QLb4s=;
        b=iUM7Oo9aDetE8bSp0VlZLLKY3qQGLv2bIeHO4HV07w3lkybWCGaOqhHiOZNmZ3tsHF
         oYB3oG+9xfyC04pWRT4PIU5BqX2Lj+qgggiekvksEopX18/xiffBYxPZaK6zMCifsyAf
         LQYYWL40sSzBpWiMdYHjarScxUyf8sbxa27PHHUZNPOfcIwpasIP6IXEkj+viSveJHCr
         QNNQBHtWOvbejDjj3D+Az45Jgds3dpFCUSjdAJ9BYWmR2ay+JoBV4LwDvGdnmK1czYLk
         E5cEp9lg0aHqWmkzeEZ8Sfpj9zExFBsKBVMcFpykH1nVwP0r00HV0HyTgoexrJ79DpY/
         3EEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGWuOiulZQVurklId2UcVbNMtm6WbPiBAbbsomIY8fF+fo/MQBvbLj3maR6Zxjuf+idVaxoovio9y7veHBF18XhgxXRdXUHIf7BQ==
X-Gm-Message-State: AOJu0YzldQngM3EAiNy23iJBVLSceoH4Q5g3faav57EZZDh9aIpqVh8V
	qqQA/FwpLrKkNr9dcMiJCfrJE3QzIB8bwl06LNNug5xXad7QYJYpf9AAiw==
X-Google-Smtp-Source: AGHT+IEutBxnvyhprwPJFoueaXmjxICXARbGjMc2AXJaHAFpfvrLtSbkm2BgdR4W66wTKOPdwUr/3w==
X-Received: by 2002:a05:600c:4fc7:b0:417:eb5d:281b with SMTP id o7-20020a05600c4fc700b00417eb5d281bmr9294834wmq.17.1713194904348;
        Mon, 15 Apr 2024 08:28:24 -0700 (PDT)
Received: from [192.168.1.53] (86-44-211-146-dynamic.agg2.lod.rsl-rtd.eircom.net. [86.44.211.146])
        by smtp.googlemail.com with ESMTPSA id w16-20020a05600c475000b00417e36953a0sm15315902wmo.20.2024.04.15.08.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 08:28:24 -0700 (PDT)
Sender: =?UTF-8?Q?P=C3=A1draig_Brady?= <pixelbeat@gmail.com>
Message-ID: <f6561a40-f0db-ea62-6cc6-1147f7fe8bf7@draigBrady.com>
Date: Mon, 15 Apr 2024 16:28:23 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bug#70214: 'install' fails to copy regular file to autofs/cifs,
 due to ACL or xattr handling
Content-Language: en-US
To: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Cc: Bruno Haible <bruno@clisp.org>, 70214@debbugs.gnu.org,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
References: <6127852.nNyiNAGI2d@nimes>
 <cdd87faf-a769-35c8-31ce-a1bf016cbe3e@draigBrady.com>
 <7050532.CnaeKSotiK@nimes>
 <c71f4bd1-b3b6-7862-d5e3-ee30ae174d45@draigBrady.com>
 <CAHpGcMJL6rngGunfAfCet9S4eqQ8TE6xgHPwhWx9KA=Ef0aW2w@mail.gmail.com>
From: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigBrady.com>
In-Reply-To: <CAHpGcMJL6rngGunfAfCet9S4eqQ8TE6xgHPwhWx9KA=Ef0aW2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/04/2024 15:37, Andreas Grünbacher wrote:
> Hello,
> 
> Am So., 14. Apr. 2024 um 00:43 Uhr schrieb Pádraig Brady <P@draigbrady.com>:
>> On 13/04/2024 20:29, Bruno Haible wrote:
>>> Hi Pádraig,
>>>
>>> I wrote:
>>>>> 5) The same thing with 'cp -a' succeeds:
>>>>>
>>>>> $ build-sparc64/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo $?
>>>>> 0
>>>>> $ build-sparc64-no-acl/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo $?
>>>>> 0
>>>
>>> You wrote:
>>>> The psuedo code that install(1) uses is:
>>>>
>>>> copy_reg()
>>>>      if (x->set_mode) /* install */
>>>>        set_acl(dest, x->mode /* 600 */)
>>>>          ctx->acl = acl_from_mode ( /* 600 */)
>>>>          acl_set_fd (ctx->acl) /* fails EACCES */
>>>>          if (! acls_set)
>>>>             must_chmod = true;
>>>>          if (must_chmod)
>>>>            saved_errno = EACCES;
>>>>            chmod (ctx->mode /* 600 */)
>>>>            if (save_errno)
>>>>              return -1;
>>>
>>> And, for comparison, what is the pseudo-code that 'cp -a' uses?
>>> I would guess that there must be a relevant difference between both.
>>
>> The cp pseudo code is:
>>
>> copy_reg()
>>     if (preserve_xattr)
>>       copy_attr()
>>         ret = attr_copy_fd()
>>         if (ret == -1 && require_preserve_xattr /*false*/)
>>           return failure;
>>     if (preserve_mode)
>>       copy_acl()
>>         qcopy_acl()
>>           #if USE_XATTR /* true */
>>             fchmod() /* chmod before setting ACLs as doing after may reset */
>>             return attr_copy_fd() /* successful if no ACLs in source */
>>           #endif
>>
>> If however you add ACLs in the source, you induce a similar failure:
>>
>> $ setfacl -m u:nobody:r /var/tmp/foo3942
>> $ src/cp -a /var/tmp/foo3942 foo3942; echo $?
>> src/cp: preserving permissions for ‘foo3942’: Permission denied
>> 1
>>
>> The corresponding strace is:
>>
>> fchmod(4, 0100640)                      = 0
>> flistxattr(3, NULL, 0)                  = 24
>> flistxattr(3, "system.posix_acl_access\0", 24) = 24
>> fgetxattr(3, "system.posix_acl_access", NULL, 0) = 44
>> fgetxattr(3, "system.posix_acl_access", "\2\0...\4", 44) = 44
>> fsetxattr(4, "system.posix_acl_access", "\2\0...\4", 44, 0) = -1 EACCES (Permission denied)
> 
> Why does CIFS think EACCES is an appropriate error to return here? The
> fchmod() succeeds, so changing the file permissions via fsetxattr()
> should really succeed as well.

Right, it seems like a CIFS bug (already CC'd)
Even if it returned ENOTSUP (like getxattr(...posix...) does) it would be ok as we handle that.
It would be good to avoid it though.

You confirmed privately to me that the set_acl() is to clear any default ACLs
that may have been added to the newly created file, so the posted solution in
https://bugs.gnu.org/70214#11 that only does the set_acl() iff file_has_acl()
should avoid the CIFS issue.  It would be a bit less efficient if there were
ACLs, but a bit more efficient in the common case where there weren't ACLs.

cheers,
Pádraig
