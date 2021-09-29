Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313A6C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 23:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 166626152A
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 23:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhI2Xy2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 19:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233892AbhI2Xy1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 29 Sep 2021 19:54:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07B196138E
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 23:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632959566;
        bh=DGsWN3ooaVYQkr5UutYUn3sBEDxPJk7Q39ZdhWXS/Co=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=etqUk6CcLgDKtIh3SLfcN9W/488+51llrL1/WhrCJCPaeG9xhYCcTALsUAzIxSmoK
         TIIlILJ7lE+FWq+UWVoSN5Xfd6srfgXxEPP01RhfKM3T2Ow6193wzykA50Gg0hBWAT
         Hz30v4UHafOfcsJFsAajRgobBZxGt7wFFGgbNsj6Hhuv6T0l8uVAKmEYv0sdiQmlV0
         Uo49NZzgIL/jSX5tzOxnPYpyE6WYHtslLAlSIh0Elomu6FrSGp9xEqhS1HexQuy0Gz
         aCrpl7+lnagEPYdCxzarURWELrDK6adF1ovCc2cUlECykOku/zMywF4N1et1qmhVb6
         zg2Lto0m3EBWw==
Received: by mail-oo1-f44.google.com with SMTP id l8-20020a4ae2c8000000b002b5ec765d9fso1273632oot.13
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 16:52:45 -0700 (PDT)
X-Gm-Message-State: AOAM533Xs2L6v9KYOASr0Th5CtK9b3ol2jUv4dhbNYkj3MH2oZxx5gas
        wL5m1kiu0W0w+vi57qTBWAVIKCSq4S/qFFt2Uuk=
X-Google-Smtp-Source: ABdhPJxMMEq4iiw3GMxcTt+tNOXiwOTl8TWxgY//xzxyy68AZaXbZxqCyJq3G5SE8VBkh1fDEYmirMkaRfliVR4jNvA=
X-Received: by 2002:a05:6820:1018:: with SMTP id v24mr2248646oor.27.1632959565369;
 Wed, 29 Sep 2021 16:52:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Wed, 29 Sep 2021 16:52:44
 -0700 (PDT)
In-Reply-To: <3ea034dc-971f-4ea1-b65a-2ff06c8a1c81@talpey.com>
References: <20210924150616.926503-1-hyc.lee@gmail.com> <7f120930-27d1-831c-4697-2d41769da14d@talpey.com>
 <CAKYAXd-aC9Zfc-tsN_VSABELFdhFfE7y28gX3_B-yoTzyqCviw@mail.gmail.com> <3ea034dc-971f-4ea1-b65a-2ff06c8a1c81@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 30 Sep 2021 08:52:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ZYTw7NdTB1nspMWuygM8qMpbtNbHyNFB6h60QUm-Z9w@mail.gmail.com>
Message-ID: <CAKYAXd-ZYTw7NdTB1nspMWuygM8qMpbtNbHyNFB6h60QUm-Z9w@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: use LOOKUP_BENEATH to prevent the out of share access
To:     Tom Talpey <tom@talpey.com>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-30 0:01 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/29/2021 8:40 AM, Namjae Jeon wrote:
>> 2021-09-29 0:18 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 9/24/2021 11:06 AM, Hyunchul Lee wrote:
>>>> instead of removing '..' in a given path, call
>>>> kern_path with LOOKUP_BENEATH flag to prevent
>>>> the out of share access.
>>>> <snip> <snip> <snip>
>>>> -char *convert_to_nt_pathname(char *filename, char *sharepath)
>>>> +char *convert_to_nt_pathname(char *filename)
>>>>    {
>>>>    	char *ab_pathname;
>>>> -	int len, name_len;
>>>>
>>>> -	name_len = strlen(filename);
>>>> -	ab_pathname = kmalloc(name_len, GFP_KERNEL);
>>>> -	if (!ab_pathname)
>>>> -		return NULL;
>>>> -
>>>> -	ab_pathname[0] = '\\';
>>>> -	ab_pathname[1] = '\0';
>>>> +	if (strlen(filename) == 0) {
>>>> +		ab_pathname = kmalloc(2, GFP_KERNEL);
>>>> +		ab_pathname[0] = '\\';
>>>> +		ab_pathname[1] = '\0';
>>>
>>> This converts the empty filename to "\" - the volume root!?
>> "\" is relative to the share. i.e. the share root.
>
> Is that the right thing to do? Does the Samba server do this?
>
> I believe the Windows server will fail such a path, but I can't
> check right now.
I am trying to check whether windows fail, but windows doesn't send
FILE_ALL_INFORMATION to ksmbd...
And smbtorture of samba have passed regardless of "/". So I didn't
probably notice such issue. I will fix it on another patch.

Thanks for your review!

>
> Tom.
>
