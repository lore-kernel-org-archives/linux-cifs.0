Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA3AC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jan 2022 01:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbiAJBnn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Jan 2022 20:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiAJBnn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Jan 2022 20:43:43 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15FDC06173F
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 17:43:42 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id k21so39057025lfu.0
        for <linux-cifs@vger.kernel.org>; Sun, 09 Jan 2022 17:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C8oVNslWhDL+oitHnkQiY/WY7C1zlF86Mdm/7hzHKYU=;
        b=poSYqxSFWKLgQ7Z0ReYpkQqE1FSRPvco3nFFQn875koKPkXepeQoZCEnEnpV0WFNB/
         HSC9Zo2mcGG7gcydvkS7wH5wpXk+HVvqdN2ZZJjihuFgf1zNc6T8AHyes1pcuMaLi9S4
         bJ/+/IMf4anhbtfzyyrHfdGERl+WZ/BExxkkOT6vJWQH33+7+9C+O4G6jfveStyl1Qa3
         08mkMwCxY8+fEsYTLC3+S01HJSLl99HWhyLi5MRdnkXazQPcDzf39ttGhl3+esfMj8EF
         eQG8BcGHraBzcN5J04D2FXycNt7vBCpztYnyuL59dk8xe5kjlUVn5EW53vCRiKtOpaSV
         p5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C8oVNslWhDL+oitHnkQiY/WY7C1zlF86Mdm/7hzHKYU=;
        b=lsdj6Nh7GQbqCsBgEetwL4AKvh6QhkTjiovSGUoqaNP03TS/AUiSrDvysoOjPGErdE
         K7bfAgftujzOua/9swpXTKlmEe2VjNVGH4NojX1JmEnHL0S+OnSA7Dau/7TEHafTdjWg
         dRMM9vgFeyiB7qHH6HH+0boxSTwT2Kz+K8SyfPPQ4O90mm9Q7EzrBV73jHvoGbVflQFw
         3zLpLw/lpwIUzys45udIFj+pp2PlOrqpXkNzmbQ+47VsYRcQVsJwofz3TVjA6GDfhRE3
         voKuRMeGpla4DimO70vDXRE/KYYMh4OrohrIHeTPSKW+/1tTkuR2xyvys9WwzgPBTCcm
         r1Xw==
X-Gm-Message-State: AOAM533eLCZHWF1bMwocV9wNjFbmw7QAdm/qdyYjcKD4/0C0wTnlqqUC
        tgMkCQTytQYtZP/HTNN3xWmB53+bcQeorAfV2p8=
X-Google-Smtp-Source: ABdhPJxM014G7oag+xtrx+cD2Fp+ddYwJg/RaKJAAhqn0lcnqNjo+9kjySF1IsvQ/5assdTnQIMnQJ/esRV4AvLhmfA=
X-Received: by 2002:a2e:aa9b:: with SMTP id bj27mr51172410ljb.23.1641779020893;
 Sun, 09 Jan 2022 17:43:40 -0800 (PST)
MIME-Version: 1.0
References: <20220107054531.619487-1-hyc.lee@gmail.com> <20220107054531.619487-2-hyc.lee@gmail.com>
 <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com>
 <CAH2r5mtTs5bxF9+_M0-3a7YkZB4zqBCm4_kL_QpHAPhEVAG-WA@mail.gmail.com>
 <CAKYAXd9ndasXA3q2F05f9JMXHPT6cQRf0M8owP-dwdv_LWggwQ@mail.gmail.com> <CANFS6baREfEidN+FqZROiF+6QtOQ6FXae6f0L9EVKaUFK2L3hg@mail.gmail.com>
In-Reply-To: <CANFS6baREfEidN+FqZROiF+6QtOQ6FXae6f0L9EVKaUFK2L3hg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 9 Jan 2022 19:43:30 -0600
Message-ID: <CAH2r5msGLvF4-9h2TXxCrYXsEXvLtVoRyY77PXxzE3MeP_vKHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: change the default maximum read/write,
 receive size
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was concerned because I saw significant improvements in large i/o
(file copy to or from the server) to Windows and Azure going to 1MB
(negotiated max read/write size), then slightly better to 2MB and
slightly better still to 4MB (was hard to show gain with 8MB in my
earlier tests though)

On Sun, Jan 9, 2022 at 7:37 PM Hyunchul Lee <hyc.lee@gmail.com> wrote:
>
> 2022=EB=85=84 1=EC=9B=94 9=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 9:56, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >
> > 2022-01-09 15:44 GMT+09:00, Steve French <smfrench@gmail.com>:
> > > Do you have more detail on what the negotiated readsize/writesize
> > > would be for Windows clients with this size? for Linux clients?
> > Hyunchul, Please answer.
> >
>
> For a Linux client, if connected using smb-direct,
> the size will be 1048512. But connected with multichannel,
> the size will be 4MB instead of 1048512. And this causes
> problems because the read/write size is bigger than 1048512.
> It looks like a bug. I have to limit the ksmbd's SMB2 maximum
> read/write size for a test.
>
> For Windows clients, the actual read/write size is less than
> 1048512.
>
> > >
> > > It looked like it would still be 4MB at first glance (although in
> > > theory some Windows could do 8MB) ... I may have missed something
> > I understood that multiple-buffer descriptor support was required to
> > set a read/write size of 1MB or more. As I know, Hyunchul is currently
> > working on it.
> > It seems to be set to the smaller of max read/write size in smb-direct
> > negotiate and max read/write size in smb2 negotiate.
> >
> > Hyunchul, I have one question more, How did you get 1048512 setting val=
ue ?
> > >
>
> I remember when the size was 1MB, Windows clients requested read/write wi=
th
> 1048512 and 64.
>
> > > On Sat, Jan 8, 2022 at 8:43 PM Namjae Jeon <linkinjeon@kernel.org> wr=
ote:
> > >>
> > >> 2022-01-07 14:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > >> > Due to restriction that cannot handle multiple
> > >> > buffer descriptor structures, decrease the maximum
> > >> > read/write size for Windows clients.
> > >> >
> > >> > And set the maximum fragmented receive size
> > >> > in consideration of the receive queue size.
> > >> >
> > >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > >> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> > >
>
>
>
> --
> Thanks,
> Hyunchul



--=20
Thanks,

Steve
