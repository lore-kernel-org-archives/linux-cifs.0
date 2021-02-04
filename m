Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864C3C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 07:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A4E64F4D
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 07:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhBDHqe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 02:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbhBDHqc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 02:46:32 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84090C0613D6
        for <linux-cifs@vger.kernel.org>; Wed,  3 Feb 2021 23:45:52 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id r2so2235388ybk.11
        for <linux-cifs@vger.kernel.org>; Wed, 03 Feb 2021 23:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iLcUJdrs52W/hZid9oz/FacsNne9vdbJbV42t64F0Aw=;
        b=YIy6eSaQCKRABjGAJmjLjMeT2noEKBrBc+GiGgbLQfZ+2b2CxW0S2ye78WrQBUBwU1
         8Dvtx+kWU9bokvCpjI2U/rBRjmbW8yK34ls0EOYn5pr0L4ORQR43Q2CXnFKu92gtxRzu
         x/5C/Qcn+XAvwZPMnBT6fH/rhNDoHfsBHPDVNHZHyNsYu8LhZGAt2Oe8d8dQg1XMmajJ
         GSoZtCihHei5jN+CE+wk69q0aG3QVlH9Kx/LfPGHzT5JONxkbyjTPDki/gzagQ/AYwTe
         B8UsI2zNWSs41OV+xnlLw4XyyFH+7tG4naxk1Qtz4FalDLr/ajG7K3vPjMCbBcssoOVY
         YLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iLcUJdrs52W/hZid9oz/FacsNne9vdbJbV42t64F0Aw=;
        b=dF6XG0JVJcCgonOeL1G0CZVI1NaP9DlmvJVddbQRiFYO5CE4wZhpPnl5YrFjAlG7vy
         12eYI3ksWMmSyFxXD0rymg8ydBX74vt6nA+KzH/kDU+8xiZZvAwQZCPlNtosAVd2ipMC
         MMr4qjOvo46fQy4+LB6jbKg2ZF0Cnfjp4NUyt0qKwL4yV8V+OZLIcsJi03VIm6Au9mCD
         XWYJ7L7Lv4jfak44Cw5rYpbgiYl/bXMuaJs7Ckv+IfarwgPWIjmSEg6iHPkmn9b+L3JK
         Lqx/J6qzODEOECD97Exy1U65Mgfad6pqjNvq91iOZ6hTk/n0RPOV+Verg45OadLwg0WE
         zpbQ==
X-Gm-Message-State: AOAM531AGsKymIm17tAhixaW0u8VE7QPerPeSYg9YL2S5gzl6oG9+Sgx
        Ie8CPZb2Dn+zlbO2zd/8VGbVld/WCh12KIBFJfA=
X-Google-Smtp-Source: ABdhPJwOeTLKN8YpKLnkJZFUhvyxQRI5+GP/+JuEibEXrNFCRF/07ZnFA1LGGAOAt6nw20b8HTyb/tfbUw237JShgFc=
X-Received: by 2002:a25:380e:: with SMTP id f14mr10238494yba.185.1612424751804;
 Wed, 03 Feb 2021 23:45:51 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=p60ahfnrxU=sazMszPaxWWp4YLKiDWkZs0mf8iie-TbQ@mail.gmail.com>
 <874kiw9ih7.fsf@suse.com>
In-Reply-To: <874kiw9ih7.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 3 Feb 2021 23:45:40 -0800
Message-ID: <CANT5p=p4OsxafPLiOfpY6JWVr1-sSB+nFgmY33fhybjtihW_HQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Changes made to crediting code to make debugging easier.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        sribhat.msa@outlook.com,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Aur=C3=A9lien. Will test it out with 3.1.1.

Steve asked me to resend this as separate patches, so that it becomes
easier for the reviewer.
Will send out the updated set of patches soon.

Regards,
Shyam

On Mon, Feb 1, 2021 at 2:43 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > Specifically, I keen on your views on the following:
> > @@ -1159,7 +1181,9 @@ compound_send_recv(const unsigned int xid,
> > struct cifs_ses *ses,
> >         /*
> >          * Compounding is never used during session establish.
> >          */
> > -       if ((ses->status =3D=3D CifsNew) || (optype & CIFS_NEG_OP))
> > +       if ((ses->status =3D=3D CifsNew) ||
> > +                       (optype & CIFS_NEG_OP) ||
> > +                       (optype & CIFS_SESS_OP))
> >                 smb311_update_preauth_hash(ses, rqst[0].rq_iov,
> >                                            rqst[0].rq_nvec);
> >
> > @@ -1224,7 +1248,9 @@ compound_send_recv(const unsigned int xid,
> > struct cifs_ses *ses,
> >         /*
> >          * Compounding is never used during session establish.
> >          */
> > -       if ((ses->status =3D=3D CifsNew) || (optype & CIFS_NEG_OP)) {
> > +       if ((ses->status =3D=3D CifsNew) ||
> > +                       (optype & CIFS_NEG_OP) ||
> > +                       (optype & CIFS_SESS_OP)) {
> >                 struct kvec iov =3D {
> >                         .iov_base =3D resp_iov[0].iov_base,
> >                         .iov_len =3D resp_iov[0].iov_len
>
> preauth should be updated for both negprot and sess_setup (except last
> response from server) so that looks correct. But ses->status will be
> CifsNew until its fully established (covering the SESS scenario) so this
> shouldn't change anything. You can test this code path by mounting with
> vers=3D3.1.1 with and without multichannel.
>
> Also there are no 80 columns limit anymore, I think it's more readable
> as 1 line.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Regards,
Shyam
