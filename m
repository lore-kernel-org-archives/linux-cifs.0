Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A773C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Mar 2022 04:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiC0EMa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Mar 2022 00:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiC0EMa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 27 Mar 2022 00:12:30 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B2D2BE3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 21:10:51 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id e16so19542697lfc.13
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 21:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OyZsIMr8V6MWnOMz98mrlmvqahGIaTXNIKOxDMyakZA=;
        b=ThLEAfimN7zrslpxKlmrZow3ApBU17C2aCLvQpU7sZq2AIlBKukOf/Dy/K4Z53J5Pm
         VvQp4+XTJAih6P0vXnbrJTCXFZv/LZQf/uVGw/wAtRDzmGX7M+SVLXDXG698NJhym2Y0
         Lp/g/UtWaeCAa92MKZs7tDhtJooaGBuWV7EA0gSBTTsMveS3nFpQSslrC+rsdIJv0Foq
         ZL8z6t6au0S03vQrJckOTRygbIYGlQccMpvyXAVm/HkOIVefOJ+9SrqmJ8iKm3aZEAXx
         irTkBq0rRvLmszlGeuH6qQ3vHigxO1+47ZWRT6LHflLOHAnB2DALpWsc4+0Qhm0zhefd
         yegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OyZsIMr8V6MWnOMz98mrlmvqahGIaTXNIKOxDMyakZA=;
        b=xb9VlfHzzNWrJnLvx270l7OFMq/DZa7iSOHrRu6U5wmFizAYwCoaTn6C5OWhx3laAj
         Tcqe5mv/ENi3HOX3cIip+0stJuiShRlNegWFn9saE/8c6lV8KQHwM6i4HxMbsSa9uRD2
         i+OdUJxqpbJIvEXIYAxNMzyJwvXkuVI9R3o9SPoanmPXpz1UZ+cqyH+hUjRv+k9Q9Byb
         AgW3k3tMKrkCYEETntsqbH352aOWG6H1AB82QbiaseDQwuPFSApKoTGCzJ8HfdaL4p8P
         4Ldk2rLsKUpG02ldRuUc3rD34Tp3NaGy7mDeHnBN8PTK5qOn5k7SeJPFH9iIEHSpRrW9
         bJbg==
X-Gm-Message-State: AOAM530XBvlCPaNrDahb3+klM2IKy0MEKk3MiTvxus/o471PQrq+g/h2
        +mO9O7QkcNkadNa1VceTwaISoOO4+84UynZc/ipFtywD
X-Google-Smtp-Source: ABdhPJx3mmxTqTvL92gIfa/EHow6Rk9QY7Jym5ONfAdNmwunH25SjpPiT1dVvPSvelgMNQ2eYYjy9FuuQQT0UfhWgQ4=
X-Received: by 2002:a05:6512:33c3:b0:44a:8067:7ec4 with SMTP id
 d3-20020a05651233c300b0044a80677ec4mr5113028lfg.601.1648354249847; Sat, 26
 Mar 2022 21:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muFUWGfK8LTrZA6wFD+XbG51RRM3dNyqEvA4B3mLiAkmA@mail.gmail.com>
 <CAH2r5mt0ZHuFoUcFKEgX6tejJ+xT9Y4zpYSEwYKSdGiROT6pZA@mail.gmail.com>
 <CAKYAXd_PEF7-_pf+AjoA-igO5e9nPaGgOepdeDTNHLsnz6413w@mail.gmail.com>
 <CAH2r5mtZxxnDYTZfoQ1Y+hwn77-zJuFytBxzVAyMKZBQwN+rEw@mail.gmail.com> <CAKYAXd9HjSeybk+vvE6YyoUaVs6XsYyx+7voZDEmuN2fLnNQug@mail.gmail.com>
In-Reply-To: <CAKYAXd9HjSeybk+vvE6YyoUaVs6XsYyx+7voZDEmuN2fLnNQug@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 26 Mar 2022 23:10:38 -0500
Message-ID: <CAH2r5mtYLW-YhqDBwrGPaSuh4_HdRdAUoDJ+daKuLi1kFhaSLg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] move more protocol header definitions to fs/smbfs_common
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ok - fixed it (removed 2nd blank line) in the following patch (patch 2)

On Sat, Mar 26, 2022 at 10:30 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2022-03-27 11:29 GMT+09:00, Steve French <smfrench@gmail.com>:
> > I think this was removed in the next patch (I don't see the warning,
> > but presumably it is the blank line before the #endif at the end of
> > the file?)
>
> The change below is adding 2 blank lines.
>
> +struct smb2_ioctl_rsp {
> +       struct smb2_hdr hdr;
> +       __le16 StructureSize; /* Must be 49 */
> +       __le16 Reserved;
> +       __le32 CtlCode;
> +       __u64  PersistentFileId;
> +       __u64  VolatileFileId;
> +       __le32 InputOffset; /* Reserved MBZ */
> +       __le32 InputCount;
> +       __le32 OutputOffset;
> +       __le32 OutputCount;
> +       __le32 Flags;
> +       __le32 Reserved2;
> +       __u8   Buffer[];
> +} __packed;
> +
> +
>  /* Possible InfoType values */
>
> Thanks!
>
> >
> > On Sat, Mar 26, 2022 at 7:52 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
> >>
> >> 2022-03-27 2:59 GMT+09:00, Steve French <smfrench@gmail.com>:
> >> > Updated the patch slightly to replace define that had Buffer[0] with
> >> > Buffer[]
> >> Minor nit, We can remove multiple blank lines in the patch.
> >>
> >> CHECK: Please don't use multiple blank lines
> >> #390: FILE: fs/smbfs_common/smb2pdu.h:1124:
> >> +
> >> +
> >>
> >> Otherwise, Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
> >>
> >> Thanks!
> >> >
> >> > On Sat, Mar 26, 2022 at 12:55 PM Steve French <smfrench@gmail.com>
> >> > wrote:
> >> >>
> >> >> Move defines for ioctl protocol header and various size to
> >> >> smbfs_common
> >> >>
> >> >> The definitions for the ioctl SMB3 request and response as well
> >> >> as length of various fields defined in the protocol documentation
> >> >> were duplicated in fs/ksmbd and fs/cifs.  Move these to the common
> >> >> code in fs/smbfs_common/smb2pdu.h
> >> >>
> >> >> See attached
> >> >>
> >> >>
> >> >> --
> >> >> Thanks,
> >> >>
> >> >> Steve
> >> >
> >> >
> >> >
> >> > --
> >> > Thanks,
> >> >
> >> > Steve
> >> >
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

Steve
