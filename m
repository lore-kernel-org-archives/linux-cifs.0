Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983ADC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Jul 2022 04:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiGLEgp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Jul 2022 00:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGLEgo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Jul 2022 00:36:44 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBC06111E
        for <linux-cifs@vger.kernel.org>; Mon, 11 Jul 2022 21:36:43 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id l7so2598755ual.9
        for <linux-cifs@vger.kernel.org>; Mon, 11 Jul 2022 21:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S8AYsxfTcGcdenkm7zwg9J+JLVEb6TdOJ1Z+dqsWO9k=;
        b=IiGy+QDwsL1tuSe5qXy+9v9B2YMpAxkZ3st5RWpi6e49cnJPmKHD8QjXr9CslGOf08
         mlBq6ZQFO7FkdY6FY3k8iHxX5BEvWSWchtBcGpBK2RFd3M+ZIy4FJz5+N+gETkEoCt5n
         HqljT6GT/sWJVuhi69rmCcQHKU+XxEIYuiPYUIN16yY6qB7UK4RCrwZZTw5QsVi2ubQm
         A5411YfLkid3X8mm4ZylFXcqyKvcVBvTRdIC7VOuOCd6U07dn81Csa2wBWbA9Qu2ypEa
         IBq202fxDfxBK3wtdTM9DIs+ZqFzhNX9bi+soqF2nH+XfuQynvIumnUX0dswxNBhGmM8
         3lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8AYsxfTcGcdenkm7zwg9J+JLVEb6TdOJ1Z+dqsWO9k=;
        b=WB+hlmx1tox7MRp0ziKynZpmgGmB0GjfKZzPqdDkVXeiJHJ3VuI7kkLBn8Q1ZyRdnx
         s4G5muyPBICo2nskh3y+2qB/SHfdXyqsb1pSbmx6HMlgplcH301AE1WeSzKKLRiO3ATH
         07VY1bX0gs8x1z47ldpmPoBiCtXZfi7A15KJcEIdURvkn0TUqKLtXGZwiTTEWzztInTA
         1S9SqC/vIrPoDJsL4WUEVoyKfVUWy6pRhzVz8p5Tq3FPtYdIEp/1LBllqzDGcxPTbnLz
         kkGV8WevVXQgInVvQv/++hov9a5J+n6FnKSgDis4b44vMhumuzD/CGxWDZCIV/l37Slk
         YCdA==
X-Gm-Message-State: AJIora+vtHI4xcfFP8uls/uDX8DwHMdGiwQ5qyeFvPiFwpFAXrcwptp8
        Mp13YFYjRYB2d8Vgd7EoFXQffJAKYo1g50/sgdo=
X-Google-Smtp-Source: AGRyM1udYjPQxuT7IFR2MTrJMjelzZ5rkZ4gZyAj2pH+6IPNpwNmhFEYzd3D8aDWvg6gbDv0j5aKMdZRhtje7HW7q58=
X-Received: by 2002:a05:6130:10b:b0:37f:a52:99fd with SMTP id
 h11-20020a056130010b00b0037f0a5299fdmr7183834uag.96.1657600602556; Mon, 11
 Jul 2022 21:36:42 -0700 (PDT)
MIME-Version: 1.0
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
 <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com> <87h7423ukh.fsf@cjr.nz>
 <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com> <87edz63t11.fsf@cjr.nz>
 <4c28c2f8-cda6-d9b4-d80f-1ffa3a3be14c@gmail.com> <20220630203207.ewmdgnzzjauofgru@cyberdelia>
 <CAH2r5mtVwZggJ9Fi0zsK5hCci4uxee-kOSC3brb56xpb0_xn7w@mail.gmail.com>
 <56afe80b-bf6a-2508-063a-7b091cdbbe0f@gmail.com> <CAH2r5mvoyhZGjf_wgvjgmkCz=+2iDxCSpbyJ79NMtpE1Ecjdnw@mail.gmail.com>
 <fccdb4af-697e-b7fc-6421-f16e9b35bb8e@samba.org> <11b3feeb-7ddb-1297-5080-7c2fc986475a@gmail.com>
 <5936fdc6-3ab2-35d7-ff79-19a4a3768f19@gmail.com>
In-Reply-To: <5936fdc6-3ab2-35d7-ff79-19a4a3768f19@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 11 Jul 2022 23:36:31 -0500
Message-ID: <CAH2r5mv5bFG2tAEtbft-Zo+2jOqFfpr9B9TtWpgc5jhR-OiaZQ@mail.gmail.com>
Subject: Re: kernel-5.18.8 breaks cifs mounts
To:     Julian Sikorski <belegdol@gmail.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Jeremy Allison <jra@samba.org>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was able to reproduce it to older Samba server (4.12.5) and could
workaround the Samba server bug by using mount option "compress" on
the client (which won't do anything different since it is not
supported but  interestingly it avoids the problem by adding another
context at the end).

On Wed, Jul 6, 2022 at 6:18 AM Julian Sikorski <belegdol@gmail.com> wrote:
>
> Am 04.07.22 um 18:29 schrieb Julian Sikorski:
> >
> >
> > Am 03.07.22 um 19:51 schrieb Stefan Metzmacher:
> >> Am 03.07.22 um 07:01 schrieb Steve French:
> >>> I lean toward thinking that this is a Samba bug (although I don't see
> >>> it on my local system - it works to samba for me, although I was
> >>> trying against a slightly different version, Samba 4.15.5-Ubuntu).
> >>>
> >>> Looking at the traces in more detail they look the same (failing vs.
> >>> working) other than the order of the negotiate context, which fails
> >>> with POSIX as the 3rd context, and netname as the 4th, but works with
> >>> the order reversed (although same contexts, and same overall length)
> >>> ie with POSIX context as the fourth one and netname context as the
> >>> third one.
> >>>
> >>> The failing server code in Samba is in
> >>> smbd_smb2_request_process_negprot but I don't see changes to it
> >>> recently around this error.
> >>>
> >>> Does this fail to anyone else's Samba version?
> >>>
> >>> This is probably a Samba server bug but ... seems odd since it doesn't
> >>> fail to Samba for me.
> >>>
> >>> Jeremy/Metze,
> >>> Does this look familiar?
> >>
> >> Maybe this one:
> >>
> >> https://git.samba.org/?p=samba.git;a=commitdiff;h=147dd9d58a429695a3b6c6e45c8b0eaafc67908a
> >>
> >>
> >> that went only into 4.15 and higher.
> >>
> >> metze
> >
> > Nice catch, I can confirm that adding this patch to debian samba
> > 2:4.13.13+dfsg-1~deb11u3 package makes the mounts work again. How do we
> > get this patch into debian?
> >
> > Best regards,
> > Julian
> I have now filed a bug against debian samba package:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1014453
>
> Best regards,
> Julian



-- 
Thanks,

Steve
