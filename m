Return-Path: <SRS0=Yxz/=TB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1587DC43219
	for <linux-cifs@archiver.kernel.org>; Wed,  1 May 2019 15:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D989D208C3
	for <linux-cifs@archiver.kernel.org>; Wed,  1 May 2019 15:36:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LP9NRNoA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfEAPgJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 May 2019 11:36:09 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:32981 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfEAPgJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 May 2019 11:36:09 -0400
Received: by mail-pl1-f181.google.com with SMTP id y3so7499621plp.0
        for <linux-cifs@vger.kernel.org>; Wed, 01 May 2019 08:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=swugMe8TeMhTfpmnJWAJYHeG1IlveAd0mG2zpm5gwAc=;
        b=LP9NRNoAwV9o/wOGUluwaFXEkB9k0nhVwJlOQfDw2m+V6AstxJdMn0sDE2RsMm7tis
         MyIs9TtE4REHRLp/qNkIKu6NEBlJzVoGDk0TX1B8T4NxiK6E5//kC8KlfGJFHHg0kXjz
         u9Iggoy0wijsLP5ByI9Yyl/C0y07QBfCwu5S/GNrdWeifqb+sRv90khV1d5Ni9lFEjXL
         ZUsnsyCKVOtJCyY6tw+DS92ySmBQihO79QL/HyKrixqzH+54ZixZonjuz/lMYBfiRvcz
         Yfvnic5XfJIiQj7Ge3DQzsRRO+GrybBiMZkGMFgqYycF/bvn925A9y7v6T7HUdlDtsw4
         0xlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=swugMe8TeMhTfpmnJWAJYHeG1IlveAd0mG2zpm5gwAc=;
        b=c0WcCOveAmHThhAT9FWShSCMth6CNEGHnskTD6FZzz+vKVqtoy1cAHc7KjkRQZgO0e
         s8y423a5Flth3JjwNyGgz29XpZoKRxJoR9XM/52AK/GREcuwBrgtfvEjQQlS0na3MDbG
         q6ZpK436LQ5Kb5cfz9vbN0JaY0R0fVJzZpuXEHFeKf+L7VD8wArmTZABZgrZk2uvY6+E
         UGZOAhGYbh4D3CCQAFC9T5EmGDywMgcwLg2JcDnbe8x02lvngej9FTsuB4GeDIV+KiDn
         MfCMkbL7m5tU1NKSL6Kqk1up7f+ibWmjMfDFYyau8MdW6ZCpCNtU8uBQCsCF3557vvGx
         BYVw==
X-Gm-Message-State: APjAAAWjWCBXj02zEWg5qL40Fcf0WHevuJj8Ff05idbC5NbZsIeWBq95
        SMrXMBPpOQ93VKeU1MjDFuRIE3UUK/arhP8cg8QYHfAh
X-Google-Smtp-Source: APXvYqyO6IHkXo9FJCnvezNoBeS4P6MmQOQ9leW9aiNzauHyBHZ6ZYca7+NRguMP5qq6DaNsVEhLbTighGs1QHy8HWQ=
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr10715537plo.32.1556724968277;
 Wed, 01 May 2019 08:36:08 -0700 (PDT)
MIME-Version: 1.0
References: <1666985748.6396792.1556614132673.JavaMail.zimbra@redhat.com> <151404631.6398428.1556614866154.JavaMail.zimbra@redhat.com>
In-Reply-To: <151404631.6398428.1556614866154.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 1 May 2019 10:35:54 -0500
Message-ID: <CAH2r5mt-2bzR38t5VyNDsjV2YxOpTkNBhTKsVwP5QFqD9OjGjQ@mail.gmail.com>
Subject: Re: Memory alignment requirement for Direct/IO
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I would expect direct i/o to work with unaligned reads over SMB3 mounts.

Let me know if you see different behavior to any servers.

On Tue, Apr 30, 2019 at 4:01 AM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Hello,
>
> I setup samba server in upstream  and mount it in local with cache=3Dnone=
,vers=3D3.11. Then test
> the Direct/IO function like this:
>
> fd=3Dopen(fname, O_DIRECT | O_RDWR | O_CREAT, 0666))
> lseek(fd, 0, SEEK_SET);
> read(fd, buf, 1);
>
> For local filesystem such as XFS, "read" will be failed because XFS has 5=
12Byte memory aligment
> for Direct/IO. But it's success for cifs. I don't know if it's expected. =
Could anybody tell me
> more about Direct/IO for cifs?
>
> Thanks.
>
> --
> Best regards!
> XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
>
> Red Hat Software (Beijing) Co.,Ltd
> filesystem-qe Team
> IRC:xifeng=EF=BC=8C#channel: fs-qe
> Tel:+86-10-8388112
> 9/F, Raycom



--=20
Thanks,

Steve
