Return-Path: <SRS0=yfaw=UN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8169C31E4E
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 20:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C5A32084D
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 20:33:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XxjrXFsL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfFNUdx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jun 2019 16:33:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39159 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbfFNUdx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jun 2019 16:33:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id 196so2158669pgc.6
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jun 2019 13:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p8X0xPKbQb6/i/UWmpAu+IKPE7kkDKnH3CxMom1pT7o=;
        b=XxjrXFsL7LiFBcf+Tdn0kX/cHRrw6nnITks0+d8MUG4Fp6IcLdm5e5HxYVCEkrRTIx
         OajfEijAUmerlSHDyEQbXETYdZ7aa5u137b9lsj9vfiPBzhS9RDUwyr+HRaNxEzRPJ2D
         OVUHintFw9xINR193kNECHkymFd2GDfE5sGfUuKdfypPSRo+8oRYPNEFTHyx8KoqJVn0
         pN5TgjYq49dr7tRCua0C5d8QbsLuu30NGRhUAlITlO9cUyrnjjL0cQsPdHWklB24lTj9
         QbMW2LqG0NuEu/SyUkQfhjvUagrSkJr7GDTbrIB9hy92Ivg/YJBuGOveNlsQ/clQ6RQ8
         vSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8X0xPKbQb6/i/UWmpAu+IKPE7kkDKnH3CxMom1pT7o=;
        b=H6lf1jIw9rgx8vZROlTcKRacQ7Gg/6mtoteqsV5J5hco20VdEy8Rgnq9GsxVL3mUqM
         VcvI6/fIOeozD/SQBdgnMs6/biGlPxNaGXt+SbOBLl7jTlb/4cL2OITAIe9ZU0ohlAOQ
         tw452MHGsX734Zip+E9AIYGAyN06O8HceavKEtRWgFBa4hdEJfDJsnbg1XVW6PFFoYkN
         wUsjWmKQYdWVhiXEp2BEBefsBotECyH9+wzdKNNToAI9WZ1Ke46Ot4etotCY0L8pslbL
         I5kiIFZlVrNrdO/vGtXZzw99MAXJplXBLDUPRbIygQ0KMyLBkt0De51Y7lI1GAnCwCa3
         a/tQ==
X-Gm-Message-State: APjAAAXS3mAM9MaEaflwWGNRNEquFG6v8JhABu9nHBqRQrDwDRXF0lwN
        uqaMbdIjui3uDAeIbrSyenWPkjzr/t7Wavfap9C6EA==
X-Google-Smtp-Source: APXvYqz4ddkSYsh0muEl0o+cps+91EyY7NsVx6+HzIgrCBZc40iNheAVzKIWx3PKS9/RtncYfsRbfHB/bzy2Jq2EhB8=
X-Received: by 2002:a62:f20b:: with SMTP id m11mr48574595pfh.125.1560544432158;
 Fri, 14 Jun 2019 13:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190614194635.21264-1-aaptel@suse.com> <CAH2r5mvVis7-5Fy=9Jsiy6XpAGz5g9XpqXyCq69jnQwjdZD0jQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvVis7-5Fy=9Jsiy6XpAGz5g9XpqXyCq69jnQwjdZD0jQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Jun 2019 15:33:40 -0500
Message-ID: <CAH2r5msmGEp0v=nL0mMt=JWs=mCEnq-w0EMZ1CnamuPJ=K2QUA@mail.gmail.com>
Subject: Re: [PATCH] cifs: add missing GCM module dependency
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 14, 2019 at 2:48 PM Steve French <smfrench@gmail.com> wrote:
>
> Thx. Will merge. Didn't we have any crypto dependency to update?

Yep - the other Kconfig dependency was taken care of in Ard's patch


> On Fri, Jun 14, 2019, 14:46 Aurelien Aptel <aaptel@suse.com> wrote:
>>
>> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
>> ---
>>  fs/cifs/Kconfig  | 1 +
>>  fs/cifs/cifsfs.c | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index aae2b8b2adf5..62ad5ed26de7 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -13,6 +13,7 @@ config CIFS
>>         select CRYPTO_ARC4
>>         select CRYPTO_AEAD2
>>         select CRYPTO_CCM
>> +       select CRYPTO_GCM
>>         select CRYPTO_ECB
>>         select CRYPTO_AES
>>         select CRYPTO_DES
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 65d9771e49f9..d06edebf3a73 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -1604,5 +1604,6 @@ MODULE_SOFTDEP("pre: sha256");
>>  MODULE_SOFTDEP("pre: sha512");
>>  MODULE_SOFTDEP("pre: aead2");
>>  MODULE_SOFTDEP("pre: ccm");
>> +MODULE_SOFTDEP("pre: gcm");
>>  module_init(init_cifs)
>>  module_exit(exit_cifs)
>> --
>> 2.16.4
>>


-- 
Thanks,

Steve
