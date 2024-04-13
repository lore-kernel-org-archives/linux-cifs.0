Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FA51361
	for <linux-cifs@vger.kernel.org>; Sat, 13 Apr 2024 22:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713048226; cv=none; b=PC/E5Tu2Q1QktrOVSUiCOMh9AVyqQ4DSasgJTnqeIiiudUiDxzyfdwDhsp0Eb7WehAIEm9f72zeMEfoHFiYlk/ddGHRlnj4aJPxU53UefPJYphc2kjO3Guvm6vrQeCB7AaqHN/jubvpn0zTuGlqqfw6iAO5QR6ss8G0ncmLB1gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713048226; c=relaxed/simple;
	bh=lGyhwKwVOks7aJNiijsnznGZqs12r0EZr6YnZjfZrHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tArvkpUe3uzXJo1nmusS+fayGLiKFKOZeHTehFQIkCmjokdm7ogbdm5FVu7GryF0yfEeVm/+RphgZmlhgcVtACuWU/YDVbHirMBVJT3AaAoG7yb7StuqHii1Xyy6vkXkS737PrLDyJGzCwGyDhS86PsQn49FmqU9NedeEmuXueU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=draigBrady.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eADqrQll; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=draigBrady.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eADqrQll"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-41846b4d5bdso317745e9.1
        for <linux-cifs@vger.kernel.org>; Sat, 13 Apr 2024 15:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713048222; x=1713653022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZoQiUStW6G0bF6aaFwn0Fjwf/3EPN/NA5Nuh0iD9sU=;
        b=eADqrQllPIw/TdnIia1evOy2T3qBgyC57qfNTU9CeC72vBwNq+MLqOyNQX+aRLyrnb
         NkqJdhXABxQwdW0fjheeDen6NM3QRtwTuOnaRA3h2KXb9e0+HoLlT1o80nwNnc87e9gz
         WdJGCvwZC/CkzIJYA9QkwWtpHswGPfM7V4orjIEjoX1fvPUJI9d52yb4KOzfwCchykl0
         WImBgACaoKcRjONvdrJTLMyIL5vZf5vOFQ+m6WMYl1Aqxuv2DSk3je5m7y9WjAfL9JQ6
         hSGoh882nY0DrUMOTdHZZ/9d3qv0nyPlUsH9dMJaT/H1D21ZTMUgJSNjYsBT/miUCb+h
         OZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713048222; x=1713653022;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ZoQiUStW6G0bF6aaFwn0Fjwf/3EPN/NA5Nuh0iD9sU=;
        b=e1GHFb2zzBogJJHQeIq7YlPvi3F6KGmTR7koCwYXdYEqZ8GHzW3jnAlB+dDwXBxJl+
         xHAzSurypJyX+mInh70jtyRgdigjUWkrGHvCnAfwyGFg19mATrw5RG+bbgtMWf9U6Jz6
         I3ZBiU9epMK6smvWDYv/up/V+lXkJQb3QwiAVgWZhSHS7zblUMcsxfmLXU7QIRFNuuSj
         hVQiTjSabwuA6WxPBpd3if9qB280Xx0+uvdl+oYQSQroQs+Ep0ORdXqXL1iIPQu79mfX
         VxoOVsOTi5zeHz1vVcMWQh5TCurA40m7K5tg0nEudiIKnLTIiVlcKlPV7tiF46BBdi/C
         vkug==
X-Gm-Message-State: AOJu0Yzv9h4Qwki+XmlD/HFdTE3LD/mi3o4yQpA5cNeGPf8VRDv+WxEO
	cSn7aRhmjBoHzmFknTojaelts2uHun1QHatmpAC82K00qiZ22/n/
X-Google-Smtp-Source: AGHT+IG9NvRrwqPZNWf7eVBmcGTCHwiA6bo2sFV3OEZ6IRz/3nPJjFbgon3jxUq8aU9hFWwvC+IONg==
X-Received: by 2002:a05:600c:1552:b0:418:3719:61ea with SMTP id f18-20020a05600c155200b00418371961eamr867871wmg.41.1713048221641;
        Sat, 13 Apr 2024 15:43:41 -0700 (PDT)
Received: from [192.168.1.53] (86-44-211-146-dynamic.agg2.lod.rsl-rtd.eircom.net. [86.44.211.146])
        by smtp.googlemail.com with ESMTPSA id f19-20020a05600c4e9300b00417d624cffbsm9982565wmq.6.2024.04.13.15.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Apr 2024 15:43:41 -0700 (PDT)
Sender: =?UTF-8?Q?P=C3=A1draig_Brady?= <pixelbeat@gmail.com>
Message-ID: <c71f4bd1-b3b6-7862-d5e3-ee30ae174d45@draigBrady.com>
Date: Sat, 13 Apr 2024 23:43:40 +0100
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
To: Bruno Haible <bruno@clisp.org>, 70214@debbugs.gnu.org
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
References: <6127852.nNyiNAGI2d@nimes>
 <cdd87faf-a769-35c8-31ce-a1bf016cbe3e@draigBrady.com>
 <7050532.CnaeKSotiK@nimes>
From: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigBrady.com>
In-Reply-To: <7050532.CnaeKSotiK@nimes>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13/04/2024 20:29, Bruno Haible wrote:
> Hi Pádraig,
> 
> I wrote:
>>> 5) The same thing with 'cp -a' succeeds:
>>>
>>> $ build-sparc64/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo $?
>>> 0
>>> $ build-sparc64-no-acl/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo $?
>>> 0
> 
> You wrote:
>> The psuedo code that install(1) uses is:
>>
>> copy_reg()
>>     if (x->set_mode) /* install */
>>       set_acl(dest, x->mode /* 600 */)
>>         ctx->acl = acl_from_mode ( /* 600 */)
>>         acl_set_fd (ctx->acl) /* fails EACCES */
>>         if (! acls_set)
>>            must_chmod = true;
>>         if (must_chmod)
>>           saved_errno = EACCES;
>>           chmod (ctx->mode /* 600 */)
>>           if (save_errno)
>>             return -1;
> 
> And, for comparison, what is the pseudo-code that 'cp -a' uses?
> I would guess that there must be a relevant difference between both.

The cp pseudo code is:

copy_reg()
   if (preserve_xattr)
     copy_attr()
       ret = attr_copy_fd()
       if (ret == -1 && require_preserve_xattr /*false*/)
         return failure;
   if (preserve_mode)
     copy_acl()
       qcopy_acl()
         #if USE_XATTR /* true */
           fchmod() /* chmod before setting ACLs as doing after may reset */
           return attr_copy_fd() /* successful if no ACLs in source */
         #endif

If however you add ACLs in the source, you induce a similar failure:

$ setfacl -m u:nobody:r /var/tmp/foo3942
$ src/cp -a /var/tmp/foo3942 foo3942; echo $?
src/cp: preserving permissions for ‘foo3942’: Permission denied
1

The corresponding strace is:

fchmod(4, 0100640)                      = 0
flistxattr(3, NULL, 0)                  = 24
flistxattr(3, "system.posix_acl_access\0", 24) = 24
fgetxattr(3, "system.posix_acl_access", NULL, 0) = 44
fgetxattr(3, "system.posix_acl_access", "\2\0...\4", 44) = 44
fsetxattr(4, "system.posix_acl_access", "\2\0...\4", 44, 0) = -1 EACCES (Permission denied)

BTW I was wondering about the need for install(1) to set_acl() at all,
rather than just using chmod.
The following comment in lib/set-permissions.c may be pertinent:

/* If we can't set an acl which we expect to be able to set, try setting
    the permissions to ctx->mode. Due to possible inherited permissions,
    we cannot simply chmod */

BTW this is all under kernel version:

$ uname -r
6.8.5-gentoo-sparc64

With these cifs options:

$ mount | grep cifs
//syslog.matoro.tk/guest-pixelbeat on /media/guest-homedirs/pixelbeat type cifs
(rw,nosuid,relatime,vers=1.0,cache=strict,username=nobody,uid=30017,forceuid,
gid=30017,forcegid,addr=fd05:0000:0000:0000:0000:0000:0000:0001,
soft,unix,posixpaths,serverino,mapposix,acl,
rsize=1048576,wsize=65536,bsize=1048576,retrans=1,echo_interval=60,actimeo=1,closetimeo=1)

cheers,
Pádraig
