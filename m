Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB24C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 12:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0CC760F24
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 12:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhINM2C (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Sep 2021 08:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232507AbhINM2C (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 Sep 2021 08:28:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D4A560F9F
        for <linux-cifs@vger.kernel.org>; Tue, 14 Sep 2021 12:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631622405;
        bh=u+lt6FbASVnWwsy1G1daS3h0pYyhh7gKSHfWmqp8y/E=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=neYBjlk8nopa4vnzVuHa6C3OsfH9U6QvY8FmM9CfFgHJC9gQdOB3V/oBv+C7GHPvw
         E6WeQUG54rnG5lCPwwsmXMOMRAkJViO/v3bHS/7TU4ZlIuVVfsb6C1Tif24oKutVWP
         Mf/4hwzV97yWHfEyaRF8Xs3KfdrJWg8itPdwFWE9eJAnlZjqBynodBg8jqdNOnjQ7z
         AWycmAmNhpuFb1rUURJHJa6LBuHjEikrX1MQBSh9O+gjFAHHH5Eaw4XCZz8zgLMPnQ
         SEIt0s1IC7AtmnJ7bRNNfoSOzFTLspWkLokfX6tWASqB6bG3xKHjfwfG8E264mLfFo
         ZMVn+PMDhpPXQ==
Received: by mail-oo1-f42.google.com with SMTP id t2-20020a4ae9a2000000b0028c7144f106so4544856ood.6
        for <linux-cifs@vger.kernel.org>; Tue, 14 Sep 2021 05:26:45 -0700 (PDT)
X-Gm-Message-State: AOAM530wcp+3zWbIfqF+9safkM/Zexo/OOKtBtkAL07Dtq5c6xQc4hRu
        AOi1ucfEMtB1Ejqkx6AUL1cgbt5B/W802IJUdj4=
X-Google-Smtp-Source: ABdhPJxuSSMwpPexcM23sKCNrf+0/luv++aGoyPR/t1vU1dGbXH+MFdwLk4i1SDzG6Xoln1UH5swPsUAqh3B487hyC4=
X-Received: by 2002:a4a:db86:: with SMTP id s6mr14030834oou.58.1631622404750;
 Tue, 14 Sep 2021 05:26:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:74d:0:0:0:0:0 with HTTP; Tue, 14 Sep 2021 05:26:44 -0700 (PDT)
In-Reply-To: <CAKYAXd8jndu748oK92Q3xEASFT_5fjX4GuvJxCG5GgUpQANrzQ@mail.gmail.com>
References: <CAH2r5msfMxY5NSULfUr91j-QLJV7U0CD_BsyzvuNDRvBF7pcTA@mail.gmail.com>
 <CAKYAXd8jndu748oK92Q3xEASFT_5fjX4GuvJxCG5GgUpQANrzQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 14 Sep 2021 21:26:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-sfqxHv-vFAa91etk5zXubh1JaYkUbz-NGD0ZGFz7nMQ@mail.gmail.com>
Message-ID: <CAKYAXd-sfqxHv-vFAa91etk5zXubh1JaYkUbz-NGD0ZGFz7nMQ@mail.gmail.com>
Subject: Re: newly passing xfstests
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-13 17:17 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> 2021-09-13 14:54 GMT+09:00, Steve French <smfrench@gmail.com>:
>> Do you notice additional xfstests that we should be adding to the
>> ksmbd buildbot group?
> I am relying on the xfstests test list you shared. I haven't recently
> ever run the total tests. And some tests may have pass/fail
> differences depending on the local fs (i.e. reflink).
>>
>> e.g. I noticed xfstests generic/115 116 and 121 passing ... do you see
>> those passing in your test setups as well?
> Yep, You have shared these tests passed since ksmbd support
> FSCTL_DUPLICATE_EXTENTS_TO_FILE ioctl. i.e. Local filesystem need to
> support reflink.
> After a while, I'll re-run the total xfstest tests including them and
> share if there are any additional ones.

I can also see generic/115 116 and 121 passing on my setup. I am
running total xfstest tests now.

linkinjeon@linkinjeon-System-Product-Name:~/git/xfstests-cifsd$ sudo
./check generic/115
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 linkinjeon-System-Product-Name 5.14.0+
#1 SMP Sun Sep 5 10:40:54 JST 2021
MKFS_OPTIONS  -- //127.0.0.1/homes2
MOUNT_OPTIONS --
-ousername=linkinjeon,password=1234,noperm,vers=3.11,mfsymlinks
//127.0.0.1/homes2 /mnt/scratch

generic/115	 1s
Ran: generic/115
Passed all 1 tests

linkinjeon@linkinjeon-System-Product-Name:~/git/xfstests-cifsd$ sudo
./check generic/116
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 linkinjeon-System-Product-Name 5.14.0+
#1 SMP Sun Sep 5 10:40:54 JST 2021
MKFS_OPTIONS  -- //127.0.0.1/homes2
MOUNT_OPTIONS --
-ousername=linkinjeon,password=1234,noperm,vers=3.11,mfsymlinks
//127.0.0.1/homes2 /mnt/scratch

generic/116	 1s
Ran: generic/116
Passed all 1 tests

linkinjeon@linkinjeon-System-Product-Name:~/git/xfstests-cifsd$ sudo
./check generic/121
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 linkinjeon-System-Product-Name 5.14.0+
#1 SMP Sun Sep 5 10:40:54 JST 2021
MKFS_OPTIONS  -- //127.0.0.1/homes2
MOUNT_OPTIONS --
-ousername=linkinjeon,password=1234,noperm,vers=3.11,mfsymlinks
//127.0.0.1/homes2 /mnt/scratch

generic/121	 1s
Ran: generic/121
Passed all 1 tests

Thanks!
>
> Thanks!
>>
>> --
>> Thanks,
>>
>> Steve
>>
>
