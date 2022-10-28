Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D40DC38A02
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 09:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJ1JUK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 05:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiJ1JUF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 05:20:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E872F677
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 02:19:58 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id q9so11651955ejd.0
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 02:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uKo0W1uZ9G+4Y4Sl1FSCcV0Q9DlrGy7pIFAFPd4hyRw=;
        b=O534Rd5W5uX3cCidbfRFe63qyRQw1BvRHPgUtu1ea7eeN7T7RvkJgquIDAuHnRucoF
         Mgh/o6ibqyz86wHL9SBD1DXtGYKyNgLYoASoI+hBnrIO0kSFy8lmt7uSXs8dphciRSg2
         iRXGrYCQKjHIZqYskBxBCW11VdaE00Qr+6mty2ak3pE1RDUx0/PsK4VQgFWdicTktLpG
         U1MPbiBhr10CST9mtj22y3VeQ+Gf7orch22ahzFgPYKn4KZRs5HDeFlvAltXPWrfeps8
         Wh3osX/bkrUOv25+TAUUgDkAXS4UwyQrGaECkT46dFY9T+9A0MtJnjO5y8oUSsIP++DR
         klEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uKo0W1uZ9G+4Y4Sl1FSCcV0Q9DlrGy7pIFAFPd4hyRw=;
        b=X42MwB3SrgevXQytvBj7EA57RL5XFX+1urkDJN2dIZjBxyhN+1i5mFmsR5Ie0SnukI
         N1pYflkp90JPmVoleZp1IwpFB+/b1GQ0Ep3Jfzq+968gHokknNSBp/hL4jIo2/0DIAyM
         gFcglPpsgVWSHv5cbm2x836+oTPV+pMl8D4F/3QzgpzKPw4KueO07qiy8wxMopPJUhWp
         +UrgQ9cROICy/fMbvzH1ACeI7TcZkYksUw530+KYg1+6ZFpnkrmyrkDpT8HI9m6x/lNe
         LBcqMJrQEaGPrGHfPJW+BdOiVvMV09ocTjFg1XbYktkhQALKeW/FXO7VQqRqWaNc1zLM
         T8BA==
X-Gm-Message-State: ACrzQf0q9VmE1e2uCXiX+EAzTFdrbIXIn0zyrSbzKSaDqze5pFUw7ZF/
        oJNNPtTF2RPEDH1iutDb8MYQ93ftC1E2QP/0BZdzgurH
X-Google-Smtp-Source: AMsMyM4j+41vVClh1MvQ/fzXKcTgTT85qtdo/BWd9q9++4e6HuUN+Z3cVulwYuCBx7TT6VSJtzievSAZSPiFhIi8jg4=
X-Received: by 2002:a17:906:ef8c:b0:7a4:a4b4:9fcf with SMTP id
 ze12-20020a170906ef8c00b007a4a4b49fcfmr26143520ejb.727.1666948796728; Fri, 28
 Oct 2022 02:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
 <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com>
 <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com> <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com>
In-Reply-To: <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 28 Oct 2022 19:19:44 +1000
Message-ID: <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 28 Oct 2022 at 16:55, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Fri, 28 Oct 2022 at 16:53, Steve French <smfrench@gmail.com> wrote:
> >
> > I haven't tried a scenario to windows where we turn off leases and force server to use oplocks but with ksmbd that is the default.
> > Worth also investigating how primary vs secondary works for finding leases for windows case
>
> Yes. Until we know what/how windows does things and what ms-smb2.pdf
> says  we can not know if this is a cifs client bug or a ksmbd bug.

So lets wait with this patch until we know where the bug is.
I will review it later for locking correctness, but lets make sure it
is not a ksmbd bug first.


>
>
> >
> > On Fri, Oct 28, 2022, 01:48 ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> >>
> >> On Fri, 28 Oct 2022 at 16:25, Steve French <smfrench@gmail.com> wrote:
> >> >
> >> > If a mount to a server is using multichannel, an oplock break arriving
> >> > on a secondary channel won't find the open file (since it won't find the
> >> > tcon for it), and this will cause each oplock break on secondary channels
> >> > to time out, slowing performance drastically.
> >> >
> >> > Fix smb2_is_valid_oplock_break so that if it is a secondary channel and
> >> > an oplock break was not found, check for tcons (and the files hanging
> >> > off the tcons) on the primary channel.
> >>
> >> Does this also happen against windows or is is only against ksmbd this triggers?
> >> What does MS-SMB2.pdf say about channels and oplocks?
> >>
> >> >
> >> > Fixes xfstest generic/013 to ksmbd
> >> >
> >> > Cc: <stable@vger.kernel.org>
> >> >
> >> >
> >> > --
> >> > Thanks,
> >> >
> >> > Steve
