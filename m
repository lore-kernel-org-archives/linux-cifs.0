Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFE3C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 16:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0824661050
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 16:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhIWQRN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 12:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242077AbhIWQRK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 12:17:10 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2590C061757
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 09:15:38 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id b19so279643ljf.10
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 09:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x+e+A4X9WtanBIvZ8mnVyzwXU1fbRJCI2XNSzYLlWEc=;
        b=mFH5hP3/yP1Lhdn6LtbBWlLg3gtbMv0cB5ivrzADATlxYDnItXWOixOpfpISJScMJf
         rL5sih1CdRYB4Co/o3KJBwVLKUpvMGXfEQddSsXhlFhYYKEcCGJeewxYk+pMu79m9xhQ
         JMB7bnfhG3MzrdRZ0BOErGJhEDKdJRMnG9xu9COpX3FCMI+TovsWkVq4dqxe98B6csxf
         dbtvchkLf3dpX4HUugMNBO2IgTCQ7grg3Zo1eGg6hEf+REs316mzWI1QaZBLa8nFsQUc
         /mjk1BvxEGEb4pWWALusiKEaOi0glKMYA1uW0r6CI+LiRyFanAIEeM1Z3tQo86nPquZ/
         ixzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x+e+A4X9WtanBIvZ8mnVyzwXU1fbRJCI2XNSzYLlWEc=;
        b=EBYiiEhQBg+mXnX7btIHwf4qjwDh7G4klPNAhnBpqQeZB166KiRytG+ctaa3TxECdw
         kIp7N3YxbY/CUNMQTeVJpvhFYvcfBmojIxGIt/cXGpaFpSYSYU36/hvfyqkdPtghAM/o
         089JhlfalVwOafDBiTmxJgK1y/5JCfHBClyo5+r9qfiYv/lmme3b3aLHzsxnLK8Ev3CA
         pbStHHB5Sa0Z3QfHl+JJaLQ0Yz6MheSFyM1YBVBmd1pxs208hk2Ex6aXKbJCV2QmBGkt
         0aBZn/4txBimm21+NoP43c4Q0h0AyNRwblGJWLnqAhoSsfr6QEl/++qkqTEO7DZj9ILx
         rF0A==
X-Gm-Message-State: AOAM530cppvxgKv9ttmytDMK5nwTndf7dwVgJB0zVkL0FEoOxCvNeZXf
        eKhwqoDrSJ+l6PBXF0yn/yBYighPESu7Og98NSIIem6P
X-Google-Smtp-Source: ABdhPJxH1G4N+pdTbjeL2M5NytyOaD+bLiaA3eD2801dl5K8disa/P1yCjkIatKrnlIPY4Mf92xPZHtRevq+/RsFSik=
X-Received: by 2002:a2e:bc16:: with SMTP id b22mr6240475ljf.500.1632413737167;
 Thu, 23 Sep 2021 09:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210923155510.GA2171@wolff.to>
In-Reply-To: <20210923155510.GA2171@wolff.to>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Sep 2021 11:15:26 -0500
Message-ID: <CAH2r5msCBzGM3Rc1JofLpCQEbkfRbJ5kgY+eSJrMX5Zx3xr6hw@mail.gmail.com>
Subject: Re: setcifsacl: Shouldn't 0x0 be a valid mask?
To:     Bruno Wolff III <bruno@wolff.to>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do you have an example of doing the same thing via

"smbcacls" (from Linux) or "icacls" (or cacls.exe) from Windows?

On Thu, Sep 23, 2021 at 11:14 AM Bruno Wolff III <bruno@wolff.to> wrote:
>
> I was looking at using S-1-2-3-4 to take away rights via ownership and
> granting no access (but not denying it either) makes sense as access
> is granted via group membership. Microsofts documentation seems to
> suggest the a 0x0 mask is valid.
> Quote from
> https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/dd125370(v=ws.10)?redirectedfrom=MSDN
> "When you add the Owner Rights security principal to objects, you can
> specify what permissions are given to the owner of an object. For example
> you can specify in the access control entry (ACE) of an object that the
> owner of a particular object is given Read permissions or you can specify
> NULL permissions to an object, which grants the owner of the object no
> permissions."
>
> Here is example output:
> # setcifsacl -a "ACL:S-1-2-3-4:0x0/0x0/0x0" bruno-test
> verify_ace_mask: Invalid mask 0x0 (value 0x0)
>
> Besides the owner rights case, I think this might also make sense in an ACL
> to break inheritence, though in that case there might be other ways to
> do that.
>
> Unless having a 0x0 mask actually breaks things, it doesn't seem that
> it is a good idea to prohibit it.



-- 
Thanks,

Steve
