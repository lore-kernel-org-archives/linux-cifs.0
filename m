Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB0CC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 06:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E44BC61076
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 06:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhJGGkS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 02:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbhJGGkS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Oct 2021 02:40:18 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD635C061746
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 23:38:24 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id f2so5640816vsj.4
        for <linux-cifs@vger.kernel.org>; Wed, 06 Oct 2021 23:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SqBQfWezRjrJZkOgv/AejXQ+EyGA0VpP5165j49iwlY=;
        b=Sqph8/GH+u1ENUNicWzXDdMcDXn/bjJDLkRmPloha0eGW1AMpzr1CVG7SdUmhqW01j
         iT1KfbTo4jSdw0tqcLMXu724XtzCa5xoFJT4gAjfzWoovU8Gbc+6/tZeBYuSpDFxFrWr
         BD1RLJlTHb8h7DwBbOXRws1RfGJ1bUAbtTlE1FYTkmKHDr6yPbs6wixQQfSKdLm6Ga0W
         Z66+wwnBMqsMCS1yrmP9jpf/9rpZMh9O62mkom3cKB9jVMBW3usA6T8FfhZEBYu6KYmv
         lI8fM8S+OH7wiXUpZ+311eLQRWKwDaaP4W8EtwtVOOSqtVVTVXbjbVgKpKcaK1kTbdmj
         jqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SqBQfWezRjrJZkOgv/AejXQ+EyGA0VpP5165j49iwlY=;
        b=rYh40Dc9LA/aqMbvKK7IO49MZENHQERfQFsBqvcnRg9g6VYrq849IbLqGujyzosETB
         VCmeamw7VecbMWMqyTHPbOvrhmL5M0K/Z9E2gHbdlCAaLAZAQjWxDgicHATPDqhftuuX
         gXpTARWgD4vNU+DQq3OaZ/uAW/GJh82RvOug7C8XqnfEE7961dAYle5jKuJwE+tAtqNa
         raT6IaRXsRCmBHXpGmdpvdFBKAohRTq83zOhWYkfBIEnSmTFePuv6MWUBnqLnMjy19zn
         jnV1xu8vvmbpBHU69UEy3r6c1gKjerU1G4JJsCEnhYjb4zaYHx6fcnYVIc4absbkcTRE
         kONw==
X-Gm-Message-State: AOAM532t4Kpu6AL2ng1JZruv/eBV8K5hHZyHXkiCqI/EgmJRXNfmPkOu
        MMtgLjH+h5OjyCPRVhDhyHiiUMXWV9B7kjesa8BWY+L5lCNDPQ==
X-Google-Smtp-Source: ABdhPJwm0XlOZi0+tnBu7e1b+DdarjWEA5Xg31jhH8WEzbzqQE5tQlluLaCORhrqFrMkt59eojSo5mKcxbm5KuphU1U=
X-Received: by 2002:a67:c81a:: with SMTP id u26mr2346220vsk.27.1633588704025;
 Wed, 06 Oct 2021 23:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <20211005100026.250280-1-hyc.lee@gmail.com> <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
 <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com> <CAKYAXd8sxyq+wegtuVMfrahf43y1T+gRogR9r7EfitwA+30ccQ@mail.gmail.com>
In-Reply-To: <CAKYAXd8sxyq+wegtuVMfrahf43y1T+gRogR9r7EfitwA+30ccQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 7 Oct 2021 15:38:12 +0900
Message-ID: <CANFS6bZcWgF9hyc_Neck5eyGhhRvpUALUg8Mh6NxcrhY+Yx6Aw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: improve credits management
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Ralph Boehme <slow@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 10=EC=9B=94 7=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 10:11, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2021-10-06 17:43 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2021=EB=85=84 10=EC=9B=94 6=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 4:1=
5, Ralph Boehme <slow@samba.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >>
> >> Am 05.10.21 um 12:00 schrieb Hyunchul Lee:
> >> > * For an asynchronous operation, grant credits
> >> > for an interim response and 0 credit for the
> >> > final response.
> >>
> >> fwiw, Samba also does this but this can cause significant problems as =
it
> >> means the server looses control over the receive window size. We've se=
en
> >> aggressive client go nuts about this overwhelming the server with IO
> >> requests leading to disconnects (iirc). So this may need careful
> >> checking how Windows implements this server side.
> >>
> >
> > Okay, I will drop this in the patch. And could you elaborate
> > on the situation that clients cause the problem?
> >
> > Namjae, What do you think about Ralph's comment?
> Let's remove async codes in this patch. I would like to know how I
> verified this code.
> i.e. not xfstests, Client attack that runs out of credits of ksmbd...
> Should it be tested by change the credit management of the cifs client
> or libsmb2?

If we just check that ksmbd refuses requests when the number of granted cre=
dits
is 0, we can modify smb2-cat-sync and the library in libsmb2 temporarily.



>
> Thanks!
> >
> > Thank you for your comments!
> >
> >> Cheers!
> >> -slow
> >>
> >> --
> >> Ralph Boehme, Samba Team                 https://samba.org/
> >> SerNet Samba Team Lead      https://sernet.de/en/team-samba
> >
> >
> >
> > --
> > Thanks,
> > Hyunchul
> >



--
Thanks,
Hyunchul
