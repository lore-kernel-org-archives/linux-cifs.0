Return-Path: <SRS0=skBP=VK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC06C71142
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jul 2019 17:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F6220850
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jul 2019 17:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uxu/Lm7+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfGMRKe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Jul 2019 13:10:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39129 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbfGMRKe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Jul 2019 13:10:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so5886676pgi.6
        for <linux-cifs@vger.kernel.org>; Sat, 13 Jul 2019 10:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kJE7bizIQ2gnF6OwfpjOODvP++2+HSd4uM9HA9JCgG0=;
        b=Uxu/Lm7+eOyAFxsXhOMg0iDbq5Efyo/SbdNVIj4FYhJieJKrHSINZufBYskXVKHFxK
         xCRAphdAak+TBozc9J5j34rpcAfE4iDCWnV3+AzvFdHN5FotKWsTew6Hri6E+BT+l7vL
         87BfJwaVHW96yaqvOm2cSnigPEQzeexhTgnOvxaiQ6KUtILVob4fUMuvOCFxVfzAZ4ym
         QnE2lh6vlFxfhkwS2Hp39hoNbhCZ/6w/e7WQu8m4j1IKMLz2HL0XF/oGuM5GmkzYj552
         zyvshs4bnNHba2MNQa6uNHvtegVznbCGDBzISiEgJ6JQct32g8E3AWPLZ9QPZzSjUZMS
         qblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kJE7bizIQ2gnF6OwfpjOODvP++2+HSd4uM9HA9JCgG0=;
        b=VmqAY9MqfRptBifNGueijmRmFRTAq3Rf1LMzLo+z6A75jFRwucZASFjbpsQrrdqCPV
         3ue45LDBqAnE+TOYBVktpAJtklo9b5F0XTDJyQ/mWfUUrBZBOQNl5Stw11BT7cD2pluc
         VY99ZNatoQ06WSrv/7yMTZifLCMlOs3cP/c5gjFQg2FH9WvObLAF+sUVIuBIY5PisGDW
         TOkTAfw87zkhU03WMWKtRWxJtAyVqpZGVVtZXfZQCnMrtlxGTGbnCTT23bnsGF1gW3xc
         SV2BNr6ZmYGVbd2HrIXhfK8UPjmmBcMav5EatbUSAWwJsNEuUUvah/UInrmF7VvUA8vd
         DqXA==
X-Gm-Message-State: APjAAAULDobeqGLlZOxE474LwMC51LzbxEc6U/rPJRfrUkBOgrKqH5MW
        c2AG4jZAtKMUpcpV1oRQ1I8fs47NMCB6OTEgo+s=
X-Google-Smtp-Source: APXvYqyIo6ES9XkrUcaQiWM/Tm3wFTlECsp5c1qZ7KAX2UZpI29o5KNwRyf4ADKTn8jn21O0aohH/06o2v1NTtfYWvQ=
X-Received: by 2002:a65:6454:: with SMTP id s20mr17762728pgv.15.1563037833694;
 Sat, 13 Jul 2019 10:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190711034658.21485-1-lsahlber@redhat.com> <87lfx34reu.fsf@suse.com>
In-Reply-To: <87lfx34reu.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 13 Jul 2019 12:10:22 -0500
Message-ID: <CAH2r5mupzWee6zhapCmrYOg6EwN4ia_=GpNgApfyRwfAJCeBpQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix crash in cifs_dfs_do_automount
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Paulo Alcantara <paulo@paulo.ac>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixed comment and pushed to cifs-2.6.git for-next

On Fri, Jul 12, 2019 at 2:56 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Hi Ronnie,
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
>
> > RHBZ: 1649907
> >
> > Fix a crash that happens while attempting to mount a DFS referral from =
the same server on the root of a filesystem.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/connect.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 8ad8bbe8003b..9b0f9f346c5b 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -4484,11 +4484,13 @@ cifs_are_all_path_components_accessible(struct =
TCP_Server_Info *server,
> >                                       unsigned int xid,
> >                                       struct cifs_tcon *tcon,
> >                                       struct cifs_sb_info *cifs_sb,
> > -                                     char *full_path)
> > +                                     char *full_path,
> > +                                     int added_treename)
> >  {
> >       int rc;
> >       char *s;
> >       char sep, tmp;
> > +     int skip =3D added_treename ? 1 : 0;
> >
> >       sep =3D CIFS_DIR_SEP(cifs_sb);
> >       s =3D full_path;
> > @@ -4503,7 +4505,13 @@ cifs_are_all_path_components_accessible(struct T=
CP_Server_Info *server,
> >               /* next separator */
> >               while (*s && *s !=3D sep)
> >                       s++;
> > -
> > +             /* if the treename is added, we then have to skip the fir=
st
> > +              * part within the separators
> > +              */
>
> Nitpicking (Steve can probably fix this when he applies) but comment
> style should be
>
> /*
>  * foo
>  */
>
>
> > +             if (skip) {
> > +                     skip =3D 0;
> > +                     continue;
> > +             }
> >               /*
> >                * temporarily null-terminate the path at the end of
> >                * the current component
> > @@ -4551,8 +4559,7 @@ static int is_path_remote(struct cifs_sb_info *ci=
fs_sb, struct smb_vol *vol,
> >
> >       if (rc !=3D -EREMOTE) {
> >               rc =3D cifs_are_all_path_components_accessible(server, xi=
d, tcon,
> > -                                                          cifs_sb,
> > -                                                          full_path);
> > +                     cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN=
_DFS);
>
> Just FYI this flag is just set in SMB1. Can we test this change in the bu=
ildbot?
>
> >               if (rc !=3D 0) {
> >                       cifs_dbg(VFS, "cannot query dirs between root and=
 final path, "
> >                                "enabling CIFS_MOUNT_USE_PREFIX_PATH\n")=
;
> > --
> > 2.13.6
> >
> >
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=
=BCrnberg)



--=20
Thanks,

Steve
