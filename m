Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5BAC11F68
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 16:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A015361410
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 16:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhGBQly (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Jul 2021 12:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhGBQly (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Jul 2021 12:41:54 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926A1C061762
        for <linux-cifs@vger.kernel.org>; Fri,  2 Jul 2021 09:39:21 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id w11so14186323ljh.0
        for <linux-cifs@vger.kernel.org>; Fri, 02 Jul 2021 09:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vbA5ri1OhcKUQXmsFKdLwVh1TVT/T8qmVINhBqXt7Uo=;
        b=O9VLix5V8oWuZ10lk5VorP5ei+H84VSMVsqefPiyRzeEpYkrArf3wabCJywR63vgEC
         vRob58YiAkJWz45Kp2PrggdZBRnt7gajiUy8CJ7h+w+78KVMxKS7UQBVLjtjCKEs+/ma
         wxMLxPBpSrHUVDqTldqAiwWLm9ST8XIf23rX+3/Us0tvoOhRaMtuLSLND/VeBju5H/3C
         T0Xf2CsatZnlI45Oe+MS+sDB1VIlHRzstXVwwCgucn/rCo6f1oH9js32Sx/0GRSJSRX4
         pgdL/mep+TJOWQFM1NoJ/Cd6dhPrvtsdY2GhIon9xcYkl8uHT0b327hCNRkfotkJkdHB
         djvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vbA5ri1OhcKUQXmsFKdLwVh1TVT/T8qmVINhBqXt7Uo=;
        b=HX293YfXWH2BItGN/bwzkAHjf88iNq20Ah6RCPX7dFTZJNodoa9ZCvvsrqyeNAHhhW
         LxSse8Zl/sI2N6r2uqbZUaK37QXsCeRlHyChbxTrrYKPw2GtTYqzWu6ueBSpyL64RG1Q
         cSEhwRyHWYwR+ZbaGjL18hWLhXagdfDeDSsBywrQDhMQxpCKnI2Y5crjcdrKaZdU0EkE
         TckoTLYdqoyRutqPi3GRN0iRrCglEAl3DwWTZq6B0uF+38Phds1unUt7Sm0OjzZzbxaF
         Zzqz0qA81NGecGeP/ofK/kx0j/g3+XWLcIhHjv/lyEW2xuaP79yJSCR/3wPljhOBNhfG
         mUhQ==
X-Gm-Message-State: AOAM5318HZbonjRjCcb0tBhkDa17PqdkcPd1/vOIl9Te2niWh+HkvRoK
        SzntprgyJmFrU8hYoV+yxUpRc4NXgRWm48uVsNY=
X-Google-Smtp-Source: ABdhPJw4JsE4WIZcugHlcw6fvr1pJpCnm4f2SaakbDHdN7diJxNxmmxaxeoJQsB29uFhNZjl7QZqxkXUUpGK2/mj5uo=
X-Received: by 2002:a2e:9853:: with SMTP id e19mr290150ljj.256.1625243959836;
 Fri, 02 Jul 2021 09:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muOpGHkvPyxJy_Qbp7gLC4ssL4eBOcY59U9+7KAjFHzcQ@mail.gmail.com>
 <87o8blou30.fsf@suse.com>
In-Reply-To: <87o8blou30.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 2 Jul 2021 11:39:08 -0500
Message-ID: <CAH2r5muiCHsa1bXZZPcP825phsS=djYWqBmpKPBYHF0JVNhCxQ@mail.gmail.com>
Subject: Re: [PATCH][CIFS] make locking consistent around the server session status
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I removed the chunk you noted - whether it is worth updating the other
50+ where we check, not sure it is worth doing that if Coverity
doesn't complain and it isn't an issue in practice why change the
other 50 (if on the other hand there is much risk then it would be
worth making the bigger change)?

Many of the checks are like:

if (tcon->ses->server->tcpStatus !=3D CifsExiting)
or
if (server->tcpStatus =3D=3D CifsNeedReconnect)
or
if ((server->tcpStatus =3D=3D CifsGood)...

so they are unlikely to be a problem if we end up with an unknown
value briefly while a read overlaps an update to tcpStatus

If you are in favor of the bigger change I am ok with it - but my goal
in this was more to "remove distracting coverity messages" so we can
spot the dangerous ones more quickly (it has spotted a few serious
problems this year so it is worth checking - but the old warnings were
distracting)


> @@ -1358,7 +1358,9 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
>   * to the struct since the kernel thread not created yet
>   * no need to spinlock this init of tcpStatus or srv_count
>   */
> + spin_lock(&GlobalMid_Lock);
>   tcp_ses->tcpStatus =3D CifsNew;
> + spin_unlock(&GlobalMid_Lock);
>   ++tcp_ses->srv_count;

On Fri, Jul 2, 2021 at 6:04 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Steve French <smfrench@gmail.com> writes:
> > There were three places where we were not taking the spinlock
> > around updates to server->tcpStatus when it was being modified.
> > To be consistent (also removes Coverity warning) and to remove
> > possibility of race best to lock all places where it is updated.
>
> If we lock for writing we also need to lock for reading otherwise the
> locking isn't protecting anything.
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -1358,7 +1358,9 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
> >   * to the struct since the kernel thread not created yet
> >   * no need to spinlock this init of tcpStatus or srv_count
>
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> There is comment just on top saying no need to spinlock.
>
> >   */
> > + spin_lock(&GlobalMid_Lock);
> >   tcp_ses->tcpStatus =3D CifsNew;
> > + spin_unlock(&GlobalMid_Lock);
> >   ++tcp_ses->srv_count;
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
Thanks,

Steve
