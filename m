Return-Path: <SRS0=e7DE=X5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AEDC10F14
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 00:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C625720862
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 00:22:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aGpfCVRc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbfJDAWk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 20:22:40 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39459 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730969AbfJDAWk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Oct 2019 20:22:40 -0400
Received: by mail-lj1-f193.google.com with SMTP id y3so4660819ljj.6
        for <linux-cifs@vger.kernel.org>; Thu, 03 Oct 2019 17:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VpPaB31YKwLTVOdlGQZYQGQcqgsQZ/YDZDxerxCqdVA=;
        b=aGpfCVRczGcytuV+hPB1KOD41nAkza4w8EYZuaN6bhEJZr5z7ERMokKxZR6UT6fdPq
         X3Aty9VKweZZUGZZwE+Y2R8yfOPWyDMVvUFFHBVgG1cKwTY5OVe34EJqEsS7HMnF0dDc
         Uf8a+KFyMa+UshtpGIkfX0A3tgRUvmF7c7UPRFuu56xEJhTBYewA0EsyZImO2pfT+W8s
         w1101gz0iBGlbeUoI+57q8xRdzeAwcb80mPS3ILQwKOcYmTSBzE/bOc/SfATjEH44Vzf
         kSNMlJP+W4ZZaF+Ru0Wk+9Mpt13eAK30WQNUG35OpeTxgrkiIEY4O6uiBR5xv36CtEY+
         OY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VpPaB31YKwLTVOdlGQZYQGQcqgsQZ/YDZDxerxCqdVA=;
        b=j7zCvHHQPueWz0dQ2uEubCHGSGvfkBJB+u/783loHe7moZveZPrR5tTs5u3ZnLpSgi
         Yodd2qKJQ+FXWO0k05odPo28eA2YrIvwZfh95tcVtuo9EWYqM++B2Ir8Er3bH0dklxCO
         blT0lYjWYffvOFzZjLe4q37rMMl3h1ifVsaJHYm+vI9NiHS5DLjcd4fvzl2avuXzg7iK
         vYm+fa65tTbdPohbTmECgDudHL9ZGDH0wP4RExoKp6OfpBYaluavHRxeFRKCtmEQZuH9
         +4S44JJHMPEOBr8jLfYdiH0Pidp0kHw3v3ubjkFxH4rut0T9N5KRZxbS99ezLucmhN5r
         1YZQ==
X-Gm-Message-State: APjAAAXC2t9+PDxzGE0FPh84IXOBGB855Bk8bhuMqk0chdoeHwtSQ3x4
        dzabMNqvGh2VmBNUIdbopuHwVQbUX2XZv8oT0qQDbIk=
X-Google-Smtp-Source: APXvYqwXpkAxgkYWyx0YKKn7INxIt/vdRxkuTxxyM6XSkMS2kH4K8tmSF3B5u4LE8jUkivseGWcDoi4PchwOj7CVDAA=
X-Received: by 2002:a2e:7d19:: with SMTP id y25mr7562122ljc.177.1570148558386;
 Thu, 03 Oct 2019 17:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190905184935.30694-1-paulo@paulo.ac> <87k1ahiqmd.fsf@suse.com>
In-Reply-To: <87k1ahiqmd.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 3 Oct 2019 17:22:27 -0700
Message-ID: <CAKywueQZSHj6autWPkyjhnfpEttFbr=81Y6a7_tWSQVnr-PmJw@mail.gmail.com>
Subject: Re: [PATCH] mount.cifs: Fix double-free issue when mounting with
 setuid root
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     "Paulo Alcantara (SUSE)" <paulo@paulo.ac>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 9 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 05:46, Aur=C3=
=A9lien Aptel <aaptel@suse.com>:
>
> " Paulo Alcantara (SUSE) " <paulo@paulo.ac> writes:
> > It can be easily reproduced with the following:
> >
> >   # chmod +s `which mount.cifs`
> >   # echo "//localhost/share /mnt cifs \
> >     users,username=3Dfoo,password=3DXXXX" >> /etc/fstab
> >   # su - foo
> >   $ mount /mnt
> >   free(): double free detected in tcache 2
> >   Child process terminated abnormally.
> >
> > The problem was that check_fstab() already freed orgoptions pointer
> > and then we freed it again in main() function.
> >
> > Fixes: bf7f48f4c7dc ("mount.cifs.c: fix memory leaks in main func")
> > Signed-off-by: Paulo Alcantara (SUSE) <paulo@paulo.ac>
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> I've compiled next branch with ASAN and can confirm the double-free and
> the fix works
>
> Compiling with ASAN
> -------------------
>
> $ CFLAGS=3D-fsanitize=3Daddress \
>   LDFLAGS=3D-fsanitize=3Daddress \
>   ac_cv_func_malloc_0_nonnull=3Dyes \
>   ./configure
> $ make clean && make -j4
>
> Next branch
> -----------
>
> $ mount /mnt; echo $?
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D29883=3D=3DERROR: AddressSanitizer: attempting double-free on 0x607=
000000020 in thread T0:
>     #0 0x7f69d480a1b8 in __interceptor_free (/usr/lib64/libasan.so.4+0xdc=
1b8)
>     #1 0x559381795f33 in main (/sbin/mount.cifs+0xef33)
>     #2 0x7f69d4394f89 in __libc_start_main (/lib64/libc.so.6+0x20f89)
>     #3 0x55938178e079 in _start (/sbin/mount.cifs+0x7079)
>
> 0x607000000020 is located 0 bytes inside of 68-byte region [0x60700000002=
0,0x607000000064)
> freed by thread T0 here:
>     #0 0x7f69d480a1b8 in __interceptor_free (/usr/lib64/libasan.so.4+0xdc=
1b8)
>     #1 0x55938178e372 in check_fstab (/sbin/mount.cifs+0x7372)
>     #2 0x559381794661 in assemble_mountinfo (/sbin/mount.cifs+0xd661)
>     #3 0x559381795eef in main (/sbin/mount.cifs+0xeeef)
>     #4 0x7f69d4394f89 in __libc_start_main (/lib64/libc.so.6+0x20f89)
>
> previously allocated by thread T0 here:
>     #0 0x7f69d480a510 in malloc (/usr/lib64/libasan.so.4+0xdc510)
>     #1 0x7f69d43fc2a9 in __GI___strndup (/lib64/libc.so.6+0x882a9)
>
> SUMMARY: AddressSanitizer: double-free (/usr/lib64/libasan.so.4+0xdc1b8) =
in __interceptor_free
> =3D=3D29883=3D=3DABORTING
> 1
>
> With fix
> --------
>
> $ mount /mnt; echo $?
> 0
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)

Merged, thanks.
--
Best regards,
Pavel Shilovsky
