Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F97C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jan 2022 01:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbiAJBha (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Jan 2022 20:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237853AbiAJBha (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Jan 2022 20:37:30 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7162AC06173F
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 17:37:29 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id i5so20809307uaq.10
        for <linux-cifs@vger.kernel.org>; Sun, 09 Jan 2022 17:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DdH5Jl/JF3RbYbOKGoTmW1vfPEemFE0sOCwMifN6nws=;
        b=PSAbqpMCTFVypHe6qu5S6kF0SjtwkOn4ZIT428iZpaZWX7+t4Hn1lyK/DHp0/6rdjd
         DKABV4mM6ccdSAvfFHO2VsF89rV7Aw9bMaESJ65Rvi8B1+EVzErh1PdDh2r9LNfMJ7Vi
         nb4K/q/dwnql8Q7P7fOdRZg808+gvBsC5oCUYg1FT1A2R5xhj/027W1LMel5VahTt2Jj
         Cfix03gQGS1JdVxhMSp+N7mdTxGR/ksp+X8/qWXfwQ2QsKgEunZUl8hr7eu2vkwgHIyf
         ckL8iugQKzRvF/Q+GXn+oo/zn0S72J40Uq6hDA/vuMBlzBM1xvoSQi6VY1br+i1eneOa
         AjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DdH5Jl/JF3RbYbOKGoTmW1vfPEemFE0sOCwMifN6nws=;
        b=lIjK5K3phaQbR+aXpDDtTFrl0Tncrb3w5H5F1GuCoXd06xCSCpd3aBx4axK/JijS/k
         BcGK9p7HRBl1P7i6S+jObk6JxWxONONTq3vRGHdk5KbL48XIOvEb0OGEDQwonrSbRnO1
         694hG93hVFR25HiXrISADgg9u3eUIWl6DLt7wZ001O9Gs45FmvjUEfr65s4DUjPZMXDW
         4oPie4P/z4F6TyreeAzBSpiqmUTlXr/ucj1up7Zp37aJk/b+zI9OE4NwIoSAy6V2b9lA
         iScEqcL/yCprnzA1X1iZp096Dss3fcFxHCXEDLTUbLwoU6580WEb1MLHlwb5c8nWUsbM
         R/uw==
X-Gm-Message-State: AOAM532sQp80/a2moYhjaaRRmfe+EaDwAXfuif/XTqYrRYdGliTS6yZI
        Yzb8OGpRWfMj12f/LwSXS6BzItAoJR8Sg/1dtkw=
X-Google-Smtp-Source: ABdhPJzbRt7kqn94wJ0DRoQ4qSBkvD7W4sADChseXylRB3b3WBlhXqatgSPWv1yy/z5YQiJaNw3j+9v2DAXeSRU3SNU=
X-Received: by 2002:a67:2f58:: with SMTP id v85mr2153390vsv.13.1641778648530;
 Sun, 09 Jan 2022 17:37:28 -0800 (PST)
MIME-Version: 1.0
References: <20220107054531.619487-1-hyc.lee@gmail.com> <20220107054531.619487-2-hyc.lee@gmail.com>
 <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com>
 <CAH2r5mtTs5bxF9+_M0-3a7YkZB4zqBCm4_kL_QpHAPhEVAG-WA@mail.gmail.com> <CAKYAXd9ndasXA3q2F05f9JMXHPT6cQRf0M8owP-dwdv_LWggwQ@mail.gmail.com>
In-Reply-To: <CAKYAXd9ndasXA3q2F05f9JMXHPT6cQRf0M8owP-dwdv_LWggwQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 10 Jan 2022 10:37:17 +0900
Message-ID: <CANFS6baREfEidN+FqZROiF+6QtOQ6FXae6f0L9EVKaUFK2L3hg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: change the default maximum read/write,
 receive size
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 1=EC=9B=94 9=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 9:56, Na=
mjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-01-09 15:44 GMT+09:00, Steve French <smfrench@gmail.com>:
> > Do you have more detail on what the negotiated readsize/writesize
> > would be for Windows clients with this size? for Linux clients?
> Hyunchul, Please answer.
>

For a Linux client, if connected using smb-direct,
the size will be 1048512. But connected with multichannel,
the size will be 4MB instead of 1048512. And this causes
problems because the read/write size is bigger than 1048512.
It looks like a bug. I have to limit the ksmbd's SMB2 maximum
read/write size for a test.

For Windows clients, the actual read/write size is less than
1048512.

> >
> > It looked like it would still be 4MB at first glance (although in
> > theory some Windows could do 8MB) ... I may have missed something
> I understood that multiple-buffer descriptor support was required to
> set a read/write size of 1MB or more. As I know, Hyunchul is currently
> working on it.
> It seems to be set to the smaller of max read/write size in smb-direct
> negotiate and max read/write size in smb2 negotiate.
>
> Hyunchul, I have one question more, How did you get 1048512 setting value=
 ?
> >

I remember when the size was 1MB, Windows clients requested read/write with
1048512 and 64.

> > On Sat, Jan 8, 2022 at 8:43 PM Namjae Jeon <linkinjeon@kernel.org> wrot=
e:
> >>
> >> 2022-01-07 14:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> > Due to restriction that cannot handle multiple
> >> > buffer descriptor structures, decrease the maximum
> >> > read/write size for Windows clients.
> >> >
> >> > And set the maximum fragmented receive size
> >> > in consideration of the receive queue size.
> >> >
> >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> >> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >



--
Thanks,
Hyunchul
