Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2538C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jan 2022 04:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbiAJEDy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Jan 2022 23:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiAJEDy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Jan 2022 23:03:54 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16553C06173F
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 20:03:53 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id d189so7373456vkg.3
        for <linux-cifs@vger.kernel.org>; Sun, 09 Jan 2022 20:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J2jwyz5AOvsGcw0bfpRLOPpj1VzuPTYD92etKvAZVo8=;
        b=KVebSpy1pZCpWSjoPJGkCJVOuuYbin0JOpHxlG/o5W6SyvWND4zInpPCaIIlqleYO5
         RMs98BmsPHQAjlMhpzXwgyK1Udyy+Xk70Y87hthDFTtnoxt5jNmHs4f+lJi1ZRvSUnyd
         bHLGfssZTZPeZlunO0sic56q9/Q5e2PFr4UjUYcB+Kn9NdmpTu/HNcMD0oZc00yhBP9f
         qcDDWFH/dWuFdlamXgKx0/oTBYw6adLzFaImncL4/ZPOoWHGYr8R4CI09Ke+cDgBrvXy
         Uv7a6zf49gZD+5PcW4UnTspPPI9YI2Vw/h1AcfdOuDRPh3raw4dYu2AhPtnZOXNaAiU+
         MrPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J2jwyz5AOvsGcw0bfpRLOPpj1VzuPTYD92etKvAZVo8=;
        b=tT5axuNRPnz3DcXyVqwpHU8V/+0g0D8NBWsetvj+e910zVkv0PioYOZRA7nCu7cDl8
         cdkyIjInvCXbcrJfhpQOzCFKYTV3tAwiSJtEDY27tgM52mguubdX5pCuGxvwgu8r18NC
         A5Ks8jSxFCURWBZuWMmGXkJ7BukEUh5LCxfAUHKaeihhPd9tyCaD/gp9BzWZ5Yrk0Ux/
         LJ1dXzu1Yx2sO6X1a9yXXSecLwnwSL5K4h/kqjqjemYfxgIQMjVgaKb9hLTcLT3+WgBz
         B5Vrj/VgaKrxR/VjL+90z3cNLokoy/Mz5F1GMaouueSKToILPdlrigU2TWG5X/en4gh/
         lraw==
X-Gm-Message-State: AOAM5324cF7VoPlnx0QR5Wt58WVPFMIkHArS+DrV0Z05RnmYmkywi1LI
        OiOdyUlSuc9bcOgMQFxYMA4uqv+9Hxe8FlHShGU=
X-Google-Smtp-Source: ABdhPJzaOTLIc6MC/Am/hCfe6KsuxfGWS2BzjvlTLlsT1rR+bgMAeaED0xWneSwhUiRPugXZwuiQNNzzfB1YyrlKoeo=
X-Received: by 2002:a1f:2a47:: with SMTP id q68mr14565339vkq.9.1641787433030;
 Sun, 09 Jan 2022 20:03:53 -0800 (PST)
MIME-Version: 1.0
References: <20220107054531.619487-1-hyc.lee@gmail.com> <20220107054531.619487-2-hyc.lee@gmail.com>
 <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com>
 <CAH2r5mtTs5bxF9+_M0-3a7YkZB4zqBCm4_kL_QpHAPhEVAG-WA@mail.gmail.com>
 <CAKYAXd9ndasXA3q2F05f9JMXHPT6cQRf0M8owP-dwdv_LWggwQ@mail.gmail.com>
 <CANFS6baREfEidN+FqZROiF+6QtOQ6FXae6f0L9EVKaUFK2L3hg@mail.gmail.com> <CAH2r5msGLvF4-9h2TXxCrYXsEXvLtVoRyY77PXxzE3MeP_vKHQ@mail.gmail.com>
In-Reply-To: <CAH2r5msGLvF4-9h2TXxCrYXsEXvLtVoRyY77PXxzE3MeP_vKHQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 10 Jan 2022 13:03:42 +0900
Message-ID: <CANFS6bbVm6So4DrVK-nr2EV9dK2byANZ_f1A5orQFwhQiswOTQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: change the default maximum read/write,
 receive size
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 1=EC=9B=94 10=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 10:43, =
Steve French <smfrench@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> I was concerned because I saw significant improvements in large i/o
> (file copy to or from the server) to Windows and Azure going to 1MB
> (negotiated max read/write size), then slightly better to 2MB and
> slightly better still to 4MB (was hard to show gain with 8MB in my
> earlier tests though)
>

This patch limits the size only when the SMB Direct protocol is used.
If handling multiple buffer descriptors is implemented, we can increase
the size.

> On Sun, Jan 9, 2022 at 7:37 PM Hyunchul Lee <hyc.lee@gmail.com> wrote:
> >
> > 2022=EB=85=84 1=EC=9B=94 9=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 9:56=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> > >
> > > 2022-01-09 15:44 GMT+09:00, Steve French <smfrench@gmail.com>:
> > > > Do you have more detail on what the negotiated readsize/writesize
> > > > would be for Windows clients with this size? for Linux clients?
> > > Hyunchul, Please answer.
> > >
> >
> > For a Linux client, if connected using smb-direct,
> > the size will be 1048512. But connected with multichannel,
> > the size will be 4MB instead of 1048512. And this causes
> > problems because the read/write size is bigger than 1048512.
> > It looks like a bug. I have to limit the ksmbd's SMB2 maximum
> > read/write size for a test.
> >
> > For Windows clients, the actual read/write size is less than
> > 1048512.
> >
> > > >
> > > > It looked like it would still be 4MB at first glance (although in
> > > > theory some Windows could do 8MB) ... I may have missed something
> > > I understood that multiple-buffer descriptor support was required to
> > > set a read/write size of 1MB or more. As I know, Hyunchul is currentl=
y
> > > working on it.
> > > It seems to be set to the smaller of max read/write size in smb-direc=
t
> > > negotiate and max read/write size in smb2 negotiate.
> > >
> > > Hyunchul, I have one question more, How did you get 1048512 setting v=
alue ?
> > > >
> >
> > I remember when the size was 1MB, Windows clients requested read/write =
with
> > 1048512 and 64.
> >
> > > > On Sat, Jan 8, 2022 at 8:43 PM Namjae Jeon <linkinjeon@kernel.org> =
wrote:
> > > >>
> > > >> 2022-01-07 14:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > > >> > Due to restriction that cannot handle multiple
> > > >> > buffer descriptor structures, decrease the maximum
> > > >> > read/write size for Windows clients.
> > > >> >
> > > >> > And set the maximum fragmented receive size
> > > >> > in consideration of the receive queue size.
> > > >> >
> > > >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > > >> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > > >
> >
> >
> >
> > --
> > Thanks,
> > Hyunchul
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,
Hyunchul
