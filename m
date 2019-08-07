Return-Path: <SRS0=Za1z=WD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E53C433FF
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Aug 2019 21:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367472186A
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Aug 2019 21:34:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6R5qsBY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbfHGVe1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Aug 2019 17:34:27 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40190 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbfHGVe1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Aug 2019 17:34:27 -0400
Received: by mail-lj1-f196.google.com with SMTP id m8so53262611lji.7
        for <linux-cifs@vger.kernel.org>; Wed, 07 Aug 2019 14:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u6It/wJHcfmvPEjcfmIsEmaQ0HIA7TwfsYPse4FC2KM=;
        b=e6R5qsBY7Ygj867MP4t6lybp+oHO8d2blyhGDTQNcXcgFRr9f62CWNa1rzFgGFzxHR
         kZdaJlZNQhegO6nc/X75867ZVdnbHoDLdsiVEj4wxLfwvu8kz3+qbljiPZ4Rak7F+dc0
         wrF38qk4AOsB5l+2G0YbHJoO7PAHZ+Qgl8isuoy5KN/2ZF0otwk14JNsJWTWoneXmkF7
         vE9V4X3s4g3JdzJnpizQQ8LQmvbUnYzsqc11A8cYX2u2oz58KlLM9poap7BawSVwx+tf
         kdztJOpJNDrdsQEki0EL63AhvBmjb4KmTiMwF4M0XzYQsu0Fv+1dmTI87jkXYTIwJSTU
         aDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u6It/wJHcfmvPEjcfmIsEmaQ0HIA7TwfsYPse4FC2KM=;
        b=Zr1DVs63Kbv8DCnyzSqrKUg+yBygeRXz8TEgI4qkOPKgSVjc8Mv2kdTqshsnK3UH75
         b9fzhRvYxojbzMQElq5NrT3OtFi5ZRbCl1CcD5MFtTTF+Rnl9/gtcJZ/doXDFnp3mIwU
         YYOE4wcYfTNosgBb3LORZwVFu+Rh4hCmiXwNug+ixgKFnEzLtygYkdIlvZZXPtpzMRoB
         15CTSwyP14MKL6dcgh0Sqn9HVZEGka1srehG1JQh+MaICVtM1RQgwQMqIxTgEwUZ3pNl
         orSMHOzWqkc5V/SrjTs3I1tsk8QqPsDRmZUI5Lc60GyuIFkif6TzLbp1w+WpZB4bkGm9
         rjXA==
X-Gm-Message-State: APjAAAV3FwYqDYIscJ/s6ZCeC6JgYoVm2b0AmhcqEL4eVk9O2lcUhOyT
        qbZbhzri8bX5ROz78fIqE86J/JrGmh9GfuWRvOcE
X-Google-Smtp-Source: APXvYqxXW1F51Soah5JzpPbWimJzthiprChySnms36WxE939tiD6FZmhrEkiaFO9ZhT7+sr3eIq9DPk2yjglFYS0JbQ=
X-Received: by 2002:a2e:730d:: with SMTP id o13mr3631643ljc.81.1565213665828;
 Wed, 07 Aug 2019 14:34:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAGn-TgiGah++0ibn3vjM+bvBkJa3XttxA12k+Qa4PGME89CTOQ@mail.gmail.com>
In-Reply-To: <CAGn-TgiGah++0ibn3vjM+bvBkJa3XttxA12k+Qa4PGME89CTOQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 7 Aug 2019 14:34:14 -0700
Message-ID: <CAKywueQEA0gNJ9Xyc7mA7VEHUctWW-CuKS4ei7GHuBb_u6xjkA@mail.gmail.com>
Subject: Re: [PATCH] cifs-utils: smbinfo.c: probably harmless wrong memset
 sizes + printf format correction
To:     Adam Richter <adamrichter4@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Adam,

Sorry it took me a while to look at this. The patch itself looks good
to me. Could you please add an appropriate description, create a patch
with "git format-patch" command and re-send it to the list? This would
allow me to merge it quickly. Submitting a PR on github against the
"next" branch is another good option.

--
Best regards,
Pavel Shilovsky

=D1=81=D0=B1, 25 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 15:36, Adam Richter=
 <adamrichter4@gmail.com>:
>
> The attached patch is my attempt at fixing two possibly harmless
> complaints from "cppcheck --enable=3Dwarning" from the cifs-utils git
> master branch version of smbinfo.c.
>
> 1. A printf format should have been "%u" instead of "%d" in print_quota.
>
> 2. An incorrect size was being passed to memset in thirteen nearly
> identical places, each using "sizeof(qi)" when "sizeof(*qi)".  I am
> not sure but I think these mistakes were probably harmless because the
> memset calls might all be unnecessary and the sizes passed to each
> memset call might never have been larger than it was supposed to be.
>
> Because each of the effected memset calls was immediately preceded by
> the malloc which allocated the data structure and because they each
> ignored the possibility that malloc could fail, I made a function,
> xmalloc0 to combine allocating the memory, zeroing it and exiting with
> a non-zero exit value and a failure message on allocation failure
> (which appears to be a fine way to handle the error in this program).
> The function uses calloc, which could introduce an unnecessary
> multiply, in the hopes that some calloc implementations may avoid the
> memset in the case of freshly allocated memory from mmap, which would
> probably be the case in this program, although I do not know if any
> calloc implementations make this optimization.  Anyhow, at least this
> way, the size of the data structure is only computed once in the
> source code.
>
> I realize that these memory allocations may all be for small data
> structures that should be allocated on the stack and also may not need
> to be cleared to all zeroes, but I did not want to delve into coding
> style conventions for stack allocation in the CIFS source tree, and I
> was not 100% certain that clearing the allocated memory was
> unnecessary, although I do see other lines that explicitly initialize
> some field in that that allocated memory to zero.  So, please feel
> free to replace my changes with something better or one that involves
> less code churn.
>
> I should also warn that my only testing of these changes was to make
> sure that "cppcheck --enable=3Dwarning" no longer complains, that the
> file compiled without complaint (with cifs-utils standard "-Wall
> -Wextra" arguments) and that "./smbinfo quote /dev/null" got past the
> memory allocation to the (correct) ioctl error for /dev/null.
>
> Also, I am not a CIFS developer and this may be the first time I have
> submitted a patch, certainly the first time I remember, so please
> forgive me and feel free to instruct me if I should be following some
> different process to submit this patch.
>
> Thanks in advance for considering this patch submission.
>
> Adam
