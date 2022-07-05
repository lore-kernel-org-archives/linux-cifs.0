Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA81C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jul 2022 05:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiGEF21 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jul 2022 01:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiGEF20 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jul 2022 01:28:26 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFC3DEDB
        for <linux-cifs@vger.kernel.org>; Mon,  4 Jul 2022 22:28:25 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id g14so12292466qto.9
        for <linux-cifs@vger.kernel.org>; Mon, 04 Jul 2022 22:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yQJpSLpnKlENHIjwBSwuF5hRiZf7GSRFXxr1bA8C5Ho=;
        b=qVSbyCcmsxIEIa4Mm4xCq3jBT/SYI5j2LxKqjOdWlbm+qd6+kpZvjgfQmOQq9lJRYo
         Gn9tRET9E9kdJIilBCDfFl927z0Ob2JkveXWwip13DZkoUMdp7FKkDm1DW6UkUIiM7b6
         2MTM1QL9PMyvkU6uHIO9FzVASmOsZ5+sRXIpiona5DV5WMZG6hVBEdOQtIunAiupeu+f
         wUa4a7K8F8Q7xHFMsRF0frsAezjuY8qzJRR8MekZa71eOIIjZhXdREp74tEwWcYOtgd7
         Y4+eN1ppjUVWmWH+xkcWd5Ch8xoDlKaLwa2tgRJaXpRootw0JeLxFR/YL6KwlzSFYGTP
         iIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yQJpSLpnKlENHIjwBSwuF5hRiZf7GSRFXxr1bA8C5Ho=;
        b=tikcYYRmZ1L5f6YhbLolKQwPh3qAcPFgHfREVWhKt3gB+VzWwRN0GR6DjeS8u1+UOo
         QbmgXp9NxQBr69xQCsdykRJxTI10/zaHfRcY5VzsP20dX/mowkUrdsgOOnDYGSfNceru
         eqkzRbNZMHE8VASxTtmVqIstlozhr75owwZ2ROUIjjdukslbTBgyVHaz8XwmHm4swYIm
         NG831AnG+me3uwiDLufkVPZ9bdJeK+K2ldEFNmMtDlAnhWnGxN+JftO92dUtWdtciCuY
         hIrlGFWT+W7VhGaBLz9a6sV6+OfrxRJTCNU9yOAxhgNYqwJfAXsYU/5sBdGVYthMw70V
         VLrA==
X-Gm-Message-State: AJIora/kTDOLAhNMMeuDngPnXQsqlXZbmhUBfj7c/H/Dy6ohN6vcRs6s
        dBNz8KufHPOss86f+dZoLcfdu3Ph6wRN8OlrbKg=
X-Google-Smtp-Source: AGRyM1sbhLM0wbd87BqqqZRjYz+cW3yKLSQr8yFw1KJghE1CrBEqrpT0yV51zfm3dAuv73aRgQiNEpRpLGvX8/RHKCY=
X-Received: by 2002:ac8:7dd1:0:b0:31d:5646:f1a1 with SMTP id
 c17-20020ac87dd1000000b0031d5646f1a1mr7042576qte.568.1656998903875; Mon, 04
 Jul 2022 22:28:23 -0700 (PDT)
MIME-Version: 1.0
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
 <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com> <87h7423ukh.fsf@cjr.nz>
 <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com> <87edz63t11.fsf@cjr.nz>
 <4c28c2f8-cda6-d9b4-d80f-1ffa3a3be14c@gmail.com> <20220630203207.ewmdgnzzjauofgru@cyberdelia>
 <CAH2r5mtVwZggJ9Fi0zsK5hCci4uxee-kOSC3brb56xpb0_xn7w@mail.gmail.com>
 <56afe80b-bf6a-2508-063a-7b091cdbbe0f@gmail.com> <CAH2r5mvoyhZGjf_wgvjgmkCz=+2iDxCSpbyJ79NMtpE1Ecjdnw@mail.gmail.com>
 <fccdb4af-697e-b7fc-6421-f16e9b35bb8e@samba.org> <11b3feeb-7ddb-1297-5080-7c2fc986475a@gmail.com>
In-Reply-To: <11b3feeb-7ddb-1297-5080-7c2fc986475a@gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 5 Jul 2022 10:58:13 +0530
Message-ID: <CANT5p=oG9je_uY+6O6qdm_4HPKpZs0ZNZFrNFvSkeL+W4Gb67Q@mail.gmail.com>
Subject: Re: kernel-5.18.8 breaks cifs mounts
To:     Julian Sikorski <belegdol@gmail.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        Jeremy Allison <jra@samba.org>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jul 4, 2022 at 10:03 PM Julian Sikorski <belegdol@gmail.com> wrote:
>
>
>
> Am 03.07.22 um 19:51 schrieb Stefan Metzmacher:
> > Am 03.07.22 um 07:01 schrieb Steve French:
> >> I lean toward thinking that this is a Samba bug (although I don't see
> >> it on my local system - it works to samba for me, although I was
> >> trying against a slightly different version, Samba 4.15.5-Ubuntu).
> >>
> >> Looking at the traces in more detail they look the same (failing vs.
> >> working) other than the order of the negotiate context, which fails
> >> with POSIX as the 3rd context, and netname as the 4th, but works with
> >> the order reversed (although same contexts, and same overall length)
> >> ie with POSIX context as the fourth one and netname context as the
> >> third one.
> >>
> >> The failing server code in Samba is in
> >> smbd_smb2_request_process_negprot but I don't see changes to it
> >> recently around this error.
> >>
> >> Does this fail to anyone else's Samba version?
> >>
> >> This is probably a Samba server bug but ... seems odd since it doesn't
> >> fail to Samba for me.
> >>
> >> Jeremy/Metze,
> >> Does this look familiar?
> >
> > Maybe this one:
> >
> > https://git.samba.org/?p=samba.git;a=commitdiff;h=147dd9d58a429695a3b6c6e45c8b0eaafc67908a
> >
> >
> > that went only into 4.15 and higher.
> >
> > metze
>
> Nice catch, I can confirm that adding this patch to debian samba
> 2:4.13.13+dfsg-1~deb11u3 package makes the mounts work again. How do we
> get this patch into debian?
>
> Best regards,
> Julian

Hi Metze,
I went through the above patch, and it looks like an issue with
parsing garbage at the end of the buffer, rather than negotiate count.
I'm not sure how the netname negotiate context patches above are being
affected by this samba server patch. The only difference from the
client side for single channel is that the netname context appears as
the 4th element in the list of 4, rather than the 3rd element in the
list of 4. Do you have a possible explanation?

Julian,
Thanks for the repro attempt. So I assume that with the latest samba
server, things work as expected without reverting any changes in
5.18.8 kernel, correct?

-- 
Regards,
Shyam
