Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC0BEB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 04:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjFWESM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 00:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjFWERk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 00:17:40 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896651A4
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 21:16:55 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f871c93a5fso127837e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 21:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687493814; x=1690085814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UC84+xkHTpx7E1xjWooXUeFcv4yVCDke7vmpF8/LtSw=;
        b=BA6z/+/HPpcE4b8HaPxvgMyYzHxVgOgOr4HsoZY8vy3HrVrwoZQj53hKhkzdpVmmGT
         Ho/wleFuTaiPUmexL0sO6UbYKsEvKg5Q16F8wIOe+obNSB2GUGtbTgpelD+FDFx5kuU0
         3QkmLSTj/THyLZMxz9i3f0XPOmLS7ndhbd7JgIrkCMygxSsdo8t+hrZoJJiGrx9LegsC
         tyMPyhVOYZzC3MlA6vFyUp9Qu0ARdrETnIShi/qh1kPccXu4VwsvkVHLqRRb1rVFVA1H
         mX+nRXRmijL+FsshyoRZ7seJDIxVHKKkDXhOlEbho+VviyrYBD4ijPglHeU6w6wW4kXa
         vBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687493814; x=1690085814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UC84+xkHTpx7E1xjWooXUeFcv4yVCDke7vmpF8/LtSw=;
        b=EVnDLkfmlhqLu/DefqxAPGNpMaJAoa654aar3NPHto15gEWWiszFo+g+3fbDtiVbFd
         32/Owbi17TIlNeDh/BxORxDTrix0jsa17DCEDclJi/Hi105Zu9MVlcDgwd9HV3dABFT+
         wazd1Pp24jy3Blb6YI9XIUJ3eUoDqJbGWVRfekv0danFk7Vz22TP3mwuP4rBHG5pJKuL
         4uSmbx37sk7290rH15Zg0G0FFaGnwxeKiZJXGNiS6Sdfm0FwttEiZHLEOGXc9FixOnML
         +fFwzqR1sJO+a9rCK6cC6hMY059VYVHPChZWg6VA2Um9Z2nMpEpcZCl7O48mpilzkQfk
         rQLQ==
X-Gm-Message-State: AC+VfDwxXcSFvRtFr891iLxsa1KxH9qpb9Zz8e1NonslyEUhkXr0aG4F
        5xdOMFU/Flxp6yoJQkkfFms+yPwcZLVyddxad2o=
X-Google-Smtp-Source: ACHHUZ5BeUJbfIa9L/c8qVALyL2/JZ//xn725MtGcx9PUF0lwKe1cCreqKF6BQvxUrwyI31R8TLd0yGy8UpviexNSLk=
X-Received: by 2002:a19:da0a:0:b0:4f8:72b6:eae with SMTP id
 r10-20020a19da0a000000b004f872b60eaemr2656100lfg.40.1687493813361; Thu, 22
 Jun 2023 21:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230622181604.4788-1-sprasad@microsoft.com> <e2e6207f531cee699b0bd9b261fb6232.pc@manguebit.com>
In-Reply-To: <e2e6207f531cee699b0bd9b261fb6232.pc@manguebit.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 23 Jun 2023 09:46:41 +0530
Message-ID: <CANT5p=puLpCEGFXtF2p9hH79iUe6ygkcf6S3==_kvg5_YNZ_+A@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: log session id when a matching ses is not found
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ematsumiya@suse.de, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 23, 2023 at 12:15=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > We do not log the session id in crypt_setup when a matching
> > session is not found. Printing the session id helps debugging
> > here. This change does just that.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/smb2ops.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index a8bb9d00d33a..8e4900f6cd53 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -4439,8 +4439,8 @@ crypt_message(struct TCP_Server_Info *server, int=
 num_rqst,
> >
> >       rc =3D smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), e=
nc, key);
> >       if (rc) {
> > -             cifs_server_dbg(VFS, "%s: Could not get %scryption key\n"=
, __func__,
> > -                      enc ? "en" : "de");
> > +             cifs_server_dbg(VFS, "%s: Could not get %scryption key. s=
id: 0x%llx\n", __func__,
> > +                      enc ? "en" : "de", le64_to_cpu(tr_hdr->SessionId=
));
>
> I think this should be FYI rather than VFS as it is usually fine to fail
> on smb2_get_enc_key() while the session was reconnected, since the I/O
> would be retried later and the current value of @tr_hdr->SessionId would
> no longer match any existing session ids.  I have seen such messages
> while running reconnect tests with 'seal' mount option.
>
> Other than that, looks good.

Ack Paulo.
I'll send an updated patch after reducing this to FYI log.

--=20
Regards,
Shyam
