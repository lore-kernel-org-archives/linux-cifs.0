Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D53EC43334
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jun 2022 21:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbiFMVO0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jun 2022 17:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352094AbiFMVNI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Jun 2022 17:13:08 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9626396BA
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 13:52:41 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id k24so9207898oij.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 13:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ie2xrfdugqSnUY/lUmZJBYqEw/Jj5HQgDROYZDI7Ljg=;
        b=q8Sos2zHH2cqeJpqAWGopwq4BFpy5d162ZHvWsGBGzD8dXmnX4TsH4oGd9xtjxFj3k
         kkiT7ORHTaWO7TVdzrFrUtvSJwyodFHKf3kDLk5zfyB6+Q4t7bACoSZoThK4QulFXt66
         4eu47sTHknmVkiiSbjTEY+HxauLbTxzPeZ3t8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ie2xrfdugqSnUY/lUmZJBYqEw/Jj5HQgDROYZDI7Ljg=;
        b=LNEvCQWuVGR1A6XEMl7kVbT9iMi+8bfti1RoPGUCSNqEAAG070x01e0+WpD16Brnwk
         53S9r2f0yNXfmqHZdv3UUkwzrr60Wuyy+KmyVzg56oiVHy+Hts868Ho/PLyYOvqGJjnk
         385o6Mhr/XQb9IdcUNaq3zGmTWEPr8C3iAflICDc3TiU4Fb0l6mN7SWCx0JDl2wlyKji
         rwdQVN/mEYHY6P2qN9tIwwVUX5d2BuRFcZiL2E82QMdM+JFXzh/qUvhp3xY/J+TibtMo
         hPt0OglFyUejounBbcZNKjsA6NDsmtFFcYVeRy7I/ovUUKCf99G2aupG8dtVBnFA+wvZ
         AQDg==
X-Gm-Message-State: AOAM530zcM+wifKBwgYXqrjwTM2x+SCTKGaQypQ6/q9mBT6nj+5y0bEX
        Wn5an87iRY4N0GdWW2GIFEOiAA==
X-Google-Smtp-Source: ABdhPJxwqO943xteTGAgFieA/vZp5/Zn/6Qxyj5rF6Le0Sf8rKMQHGa/+OpWxWOapQGjDXa0MQVMLw==
X-Received: by 2002:a05:6808:2394:b0:326:d5d6:a4ba with SMTP id bp20-20020a056808239400b00326d5d6a4bamr321996oib.67.1655153561069;
        Mon, 13 Jun 2022 13:52:41 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id dv8-20020a056870d88800b000f5eb6b409bsm4444747oab.45.2022.06.13.13.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 13:52:40 -0700 (PDT)
Message-ID: <e1b62234-9b8a-e7c2-2946-5ef9f6f23a08@cloudflare.com>
Date:   Mon, 13 Jun 2022 15:52:38 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org,
        serge@hallyn.com, amir73il@gmail.com, kernel-team@cloudflare.com,
        Jeff Moyer <jmoyer@redhat.com>,
        Paul Moore <paul@paul-moore.com>
References: <20220608150942.776446-1-fred@cloudflare.com>
 <87tu8oze94.fsf@email.froward.int.ebiederm.org>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <87tu8oze94.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Eric,

On 6/13/22 12:04 PM, Eric W. Biederman wrote:
> Frederick Lawler <fred@cloudflare.com> writes:
> 
>> While experimenting with the security_prepare_creds() LSM hook, we
>> noticed that our EPERM error code was not propagated up the callstack.
>> Instead ENOMEM is always returned.  As a result, some tools may send a
>> confusing error message to the user:
>>
>> $ unshare -rU
>> unshare: unshare failed: Cannot allocate memory
>>
>> A user would think that the system didn't have enough memory, when
>> instead the action was denied.
>>
>> This problem occurs because prepare_creds() and prepare_kernel_cred()
>> return NULL when security_prepare_creds() returns an error code. Later,
>> functions calling prepare_creds() and prepare_kernel_cred() return
>> ENOMEM because they assume that a NULL meant there was no memory
>> allocated.
>>
>> Fix this by propagating an error code from security_prepare_creds() up
>> the callstack.
> 
> Why would it make sense for security_prepare_creds to return an error
> code other than ENOMEM?
>  > That seems a bit of a violation of what that function is supposed to do
>

The API allows LSM authors to decide what error code is returned from 
the cred_prepare hook. security_task_alloc() is a similar hook, and has 
its return code propagated.

I'm proposing we follow security_task_allocs() pattern, and add 
visibility for failure cases in prepare_creds().

> I have probably missed a very interesting discussion where that was
> mentioned but I don't see link to the discussion or anything explaining
> why we want to do that in this change.
> 

AFAIK, this is the start of the discussion.

> Eric
> 


