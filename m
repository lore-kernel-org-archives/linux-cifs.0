Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EAA3C433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Jan 2022 06:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbiAIGoU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Jan 2022 01:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbiAIGoU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Jan 2022 01:44:20 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC74C06173F
        for <linux-cifs@vger.kernel.org>; Sat,  8 Jan 2022 22:44:20 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id i31so32448578lfv.10
        for <linux-cifs@vger.kernel.org>; Sat, 08 Jan 2022 22:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UFjxeeuWfEYtg6FQoWhdNrKulRdN32s6/SXbejflktE=;
        b=M14eA23y+G9xz39UMIwu54wHP/jA7bQi4jjiT6JK+ZzhnDxcDEEVmvtbXDebMf8BuD
         gs1JW7IH3TIodpZSC3umkc7DACuXkSjzwFhVodMH1WofKoWzuSCVAKaSDZOSnuxHpS7E
         IZBCTlibq1QHR8RiBTfDO270qP6bNG6mj0dC1APcbhPiQYxyYfON37RLjpKxbMVD7Ju2
         StuCX+HWpmUiVTkid02Rvq3RhqMucPEc6OBEmnhhUMoKFyK2D90BCL8w9PHyO3LLDeJj
         c187Tee39ElZei8AWCn10ZrnVnP4fNzZBE64qyH8yYw1LiHFC3NzmBGdFcKQWzLfRpBp
         fXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UFjxeeuWfEYtg6FQoWhdNrKulRdN32s6/SXbejflktE=;
        b=n7GfPh5wH74BzlhMeuuSGNOavdnrhvUz7UeJAzsMcklUEGlOJS7nVTaCFwj3JXVat+
         iTVe8UuIGcJphKZLDtMVnlR4BL79fDRcVnN6GrT/slxS3+qjP0ssQHsM3xXSd34zKFpc
         CjIpoMQE4i/IjQsqaITEx2v5r+N8g0F+zS79LkcenKwonf74Ln2ci7oazMODqu9n830f
         XniKjkTWvRz6mwcGX8U3+fzwNboo67H1cEZnJKFgLGst7t4fSkE7ow8MNEn4/yiiWtON
         TGmDUKgf9X+kNsCdvu90/a5sEA6bBOlSZiSMpnLdpLE0F6WUCgskBHJALFwbSzTcBtRk
         VhMg==
X-Gm-Message-State: AOAM532gsLdr4VHLPsurx8Jy97MPWEAL3P5cGZytUl8vYSq2m6enZbKJ
        R3DMiBy4PdrxDeR5RbUFH3PDtNxxdPEoW3vq6LgXhvDZ
X-Google-Smtp-Source: ABdhPJyEt2QmYkaYBcd01qi3YJDwyUxYJdQ/f9Me9zPZB/fd0iZBTIDW7Cv4f4IeAZvtR/gfumx/GmxMoSkrWrcE+vw=
X-Received: by 2002:a05:6512:3b24:: with SMTP id f36mr62467314lfv.545.1641710658184;
 Sat, 08 Jan 2022 22:44:18 -0800 (PST)
MIME-Version: 1.0
References: <20220107054531.619487-1-hyc.lee@gmail.com> <20220107054531.619487-2-hyc.lee@gmail.com>
 <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com>
In-Reply-To: <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 9 Jan 2022 00:44:07 -0600
Message-ID: <CAH2r5mtTs5bxF9+_M0-3a7YkZB4zqBCm4_kL_QpHAPhEVAG-WA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: change the default maximum read/write,
 receive size
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do you have more detail on what the negotiated readsize/writesize
would be for Windows clients with this size? for Linux clients?

It looked like it would still be 4MB at first glance (although in
theory some Windows could do 8MB) ... I may have missed something

On Sat, Jan 8, 2022 at 8:43 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2022-01-07 14:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > Due to restriction that cannot handle multiple
> > buffer descriptor structures, decrease the maximum
> > read/write size for Windows clients.
> >
> > And set the maximum fragmented receive size
> > in consideration of the receive queue size.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>



-- 
Thanks,

Steve
