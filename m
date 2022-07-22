Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED12EC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 18:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiGVSia (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Jul 2022 14:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbiGVSi2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Jul 2022 14:38:28 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21EFA8746
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 11:38:27 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id m16so6821584edb.11
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 11:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=yM2uBtn0ynkcWh7BxOYMNJKDm7vWXgbdPbhBhGlI3co=;
        b=BFdgpDDtDyRg3TV6AnfCesnoH6VCdDs3dHDb8PcDNdA53Dm5xZz/2/sPam6CApC4U0
         TKbgmO2WqftwqFc9BgVkDIeLX8oIp1W9v4s5CcNp+pU9oqfVwBr+HFukA+rqrc7ag4lj
         1oF8DV7z91va+H8PNIhpQhMEbn5Yq6B/eP51DhCypGGNw5/rAzb8zraknOedcs03HkxZ
         /CK0vQC2qt9GFTuHIKUIKso1Y6X/tNZi0nEKkzi0h1aq9ilQC9UIKQJDbkBaWEtjWt7N
         ELbh5Ybwnn1DTWzxBoVJK4q8RQKkk/0BGmBzluLmeSrSjDpikJeCQpIFSuDcQuEu44/V
         Ujtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=yM2uBtn0ynkcWh7BxOYMNJKDm7vWXgbdPbhBhGlI3co=;
        b=I8hUKTmvKr0vlsXYpL+H+tBqLFcZPXKBl+IDFDEi+15ElFrZNt1D6WCDMKtf7uKdSk
         K48df1pmvKXxL5mgbNkEk6G6I5oTZMefZDzwUpx12B6MSBCFWd35ZxVwC+2aKGDgI6ir
         l5OkZNz9U193ILNWqZrl52I6E6wZPFGmF3Me2W6l55k/rSjZ9MpYwkTqbgfG/48Q9y56
         oL5DVkwBtqhgROlZFzcfFBbWBE9Zn/AbOwMCSnStrywTBAT4Ul9nRA42+H9c6QT4RsVO
         wVmlH2Z/7w22YalHRWnex2aBxGfXQqKDslOAX5T3PyQX7PdKEuDcbwdmafbcKESG1QFh
         Kn3w==
X-Gm-Message-State: AJIora/JLKs54gObz8X/Uu77LssBZoDiacPY9sqfBK6MJsW7LE063Xfe
        ANOqZ5luhiR+Xcu6+Rc/xKI=
X-Google-Smtp-Source: AGRyM1tEmzJ+oHj0VcMLtstuTWcmVot2lfzWqYaA+e5maZg2nONnKrkK57dOZ5H19kst7rhXvYJyeA==
X-Received: by 2002:a05:6402:d05:b0:425:b7ab:776e with SMTP id eb5-20020a0564020d0500b00425b7ab776emr1232510edb.142.1658515106025;
        Fri, 22 Jul 2022 11:38:26 -0700 (PDT)
Received: from [192.168.1.13] ([88.118.111.211])
        by smtp.gmail.com with ESMTPSA id bv4-20020a170906b1c400b00703671ebe65sm2255514ejb.198.2022.07.22.11.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 11:38:25 -0700 (PDT)
Message-ID: <705265ea-37a3-6029-362a-572bbaab6639@gmail.com>
Date:   Fri, 22 Jul 2022 21:38:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: pam_cifscreds, tmux and session keyrings
Content-Language: en-US
To:     Nick Guenther <nick.guenther@polymtl.ca>,
        linux-cifs@vger.kernel.org
References: <774233f766bf26976c0d923cc1dc53c7@polymtl.ca>
From:   =?UTF-8?Q?Mantas_Mikul=c4=97nas?= <grawity@gmail.com>
In-Reply-To: <774233f766bf26976c0d923cc1dc53c7@polymtl.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2022-07-21 23:45, Nick Guenther wrote:
> [...]
> I see in this old thread https://www.spinics.net/lists/linux-cifs/msg18249.html that you actually want to go the _other_ direction, and isolate your sessions even more:
> 
>>> multiuser SMB connections should also be initiated per session, same like the
>>> keyring. Currently the cifs SMB connections are accessible also from other all
>>> sessions.
>>
>> That needs to be implemented indeed.
> 
> but that doesn't sound like it would make my users happy. In their perspective, tmux should be the same environment as ssh or as the GUI, just more persistent. And I tend to agree.
> 
> Anyway, I hope this isn't too intricate or confusing for you. I would really appreciate a second opinion, and maybe a consideration of that patch, if that patch is actually the right answer.

As another user, I'd expect the keyring search to be done recursively -- 
start from the session keyring as now, but follow the link into the user 
keyring, which is usually present (and isn't that its whole purpose?)

Then pam_cifscreds could be told which one to insert keys to, allowing 
it to be used both ways depending on needs -- just like how Kerberos or 
AFS can also have either isolated credentials or user-wide ones.
