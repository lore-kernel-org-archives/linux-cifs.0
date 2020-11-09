Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBDCC2D0A3
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 23:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C06206BE
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 23:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WdiyoSxO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgKIXmv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Nov 2020 18:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKIXmv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Nov 2020 18:42:51 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7404C0613CF
        for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2020 15:42:50 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id cw8so14837523ejb.8
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2020 15:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AZSH0b3VBG0xAK3qXoidDcxWuYUkrREmytOX8I5+u5w=;
        b=WdiyoSxOKjp2NzTHHiYoFB7N1Ui/YhIehPXz8M6eij3C2NgT8yKlA9mErTFTE0ppw2
         8Eu0jqUaCk3NTlasiYosUH4/uejFjQzHKn1O5V3IvVo08XARtKRoE2W/YBuJ3yJ9RJhv
         QGyYsHSkDzkWbnu0xKOWrAyMheiX1puewiT0FOrYAVmKJRVlEbPFJ+2ZwjPPIkVFo946
         dKxaDFfuYAzeJL13mfDFx3EqrbDvc+eT0Ku0KlDcCdD+SAQ/tHXnTgtjkmX5k2qzRbCB
         Z0OwJCnKt3181VWTfY5ocMZTFuaCB5Sy5SBu0JKPxl+d6x3Ys4x9WbZukmof7Oov4qm4
         DSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AZSH0b3VBG0xAK3qXoidDcxWuYUkrREmytOX8I5+u5w=;
        b=TNsfCEL7GcrprSQKoclAmZJITd5NxikP05rQFVpn96vOzzEWp4XZYJRS5qYCM4CYc+
         qfUBxskSPqhdZE9YNpBNhPQoKPfLGfFilBXOW/zqFxZHdyKV0oYJwxRTYvEAkJGaVgSx
         +oaPlGmt2/D0Nw4vCh3MhTbe4qJpmOQgPeGIQkA0vOeJsfEkiWXRgfh8Wg0wvQHKi7lA
         TzWiftGb1mFJIEnFSLHVLOzDczpLU2BzXLIDurmWiuPFybi64SgY7fRfj+3pkJ/fUCKH
         EJxZHBBq5x9lbjm5xWTYYWhJEEJW2BrYrXl6yOfkZ3WEf1tPGZKawnbKLyV+6wFPwNEo
         dyew==
X-Gm-Message-State: AOAM531Qs1iEKerMhQSCl+8/iyICZidoOTT18VH8fqFrMo4flvOJ57Ph
        ibQ5VJEgEqbgN76TLLkDD6OHAwb5UT89pMz9/w==
X-Google-Smtp-Source: ABdhPJwfNuwzGtXRT3USWWNJ6GNX3Rjv+B8DZ1U3lQunJ9UZQbFTa02bS0OKOkFtRIn5IumoikndL/v7Deb3MlwTBSY=
X-Received: by 2002:a17:906:4d93:: with SMTP id s19mr17942092eju.271.1604965369227;
 Mon, 09 Nov 2020 15:42:49 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
 <87pn7t4kr9.fsf@suse.com> <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
 <87eeo54q0i.fsf@suse.com> <CANT5p=rxp3iQMgxaM_mn3RE3B+zezWr3o8zpkFyWUR27CpeVCA@mail.gmail.com>
 <CANT5p=qMHxq_L5RpXAixzrQztjMr8-P_aO4aPg5uqfPSLNUiTA@mail.gmail.com>
 <874ko7vy0z.fsf@suse.com> <CANT5p=o07RqmMkcFoLeUVTeQHhzh5MmFYpfAdv0755iiGbp1ZA@mail.gmail.com>
 <87mu1yc6gw.fsf@suse.com> <CANT5p=r0Jix9EuuF8gJzQBGHLp0Y-Oogxzju7_2cJog_jF2fjg@mail.gmail.com>
 <874knolhpw.fsf@suse.com> <CANT5p=oTTErJk240GKc+k6Cihqks+9Nnurh=MdrvgC7gqKu1ww@mail.gmail.com>
In-Reply-To: <CANT5p=oTTErJk240GKc+k6Cihqks+9Nnurh=MdrvgC7gqKu1ww@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 9 Nov 2020 15:42:37 -0800
Message-ID: <CAKywueTr9GHbzg65s12BRKNB_L881wFLmHcb5boFxGX2AoN40g@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Steve French <smfrench@gmail.com>, sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into next. Please let me know if something needs to be fixed. Thanks=
!
--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 24 =D1=81=D0=B5=D0=BD=D1=82. 2020 =D0=B3. =D0=B2 03:39, Shyam=
 Prasad N <nspmangalore@gmail.com>:
>
> Hi Aur=C3=A9lien,
>
> I've implemented most of your review comments. Also fixed the issue.
>
> On Wed, Sep 23, 2020 at 7:26 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > Also, I'll test this out with DFS once I figure out how to set it up.=
 :)
> > > Re-attaching the patch with some minor changes with just the
> > > "force_pam" mount option.
> >
> > You will need 2 Windows VM. DFS is basically symlinks across
> > servers. The DFS root VM will host the links (standalone namespace) and
> > you have to make them point to shares on the 2nd VM. You don't need to
> > setup replication to test.
> >
> > When you mount the root in cifs.ko and access a link, the server will
> > reply that the file is remote. cifs.ko then does an FSCTL on the link t=
o
> > resolve the target it points to and then connects to the target and
> > mounts it under the link seemlessly.
> >
> >
> > Regarding the patch:
> >
> > * need to update the man page with option and explanation
> >
> > I have some comments with the style, I know it's annoying.. but it
> > would be best to keep the same across the code.
> >
> > * use the existing indent style (tabs) and avoid adding trailing whites=
paces.
> > * no () for return statements
> > * no casting for memory allocation
> > * if (X) free(X)  =3D> free(X)
> >
> > Below some comments about pam_auth_krb5_conv():
> >
> > > @@ -1809,6 +1824,119 @@ get_password(const char *prompt, char *input,=
 int capacity)
> > >       return input;
> > >  }
> > >
> > > +#ifdef HAVE_KRB5PAM
> > > +#define PAM_CIFS_SERVICE "cifs"
> > > +
> > > +static int
> > > +pam_auth_krb5_conv(int n, const struct pam_message **msg,
> > > +    struct pam_response **resp, void *data)
> > > +{
> > > +    struct parsed_mount_info *parsed_info;
> > > +     struct pam_response *reply;
> > > +     int i;
> > > +
> > > +     *resp =3D NULL;
> > > +
> > > +    parsed_info =3D data;
> > > +    if (parsed_info =3D=3D NULL)
> > > +             return (PAM_CONV_ERR);
> > > +     if (n <=3D 0 || n > PAM_MAX_NUM_MSG)
> > > +             return (PAM_CONV_ERR);
> > > +
> > > +     if ((reply =3D calloc(n, sizeof(*reply))) =3D=3D NULL)
> > > +             return (PAM_CONV_ERR);
> > > +
> > > +     for (i =3D 0; i < n; ++i) {
> > > +             switch (msg[i]->msg_style) {
> > > +             case PAM_PROMPT_ECHO_OFF:
> > > +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSWD_SIZE=
 + 1)) =3D=3D NULL)
> > > +                goto fail;
> > > +
> > > +            if (parsed_info->got_password && parsed_info->password !=
=3D NULL) {
> > > +                strncpy(reply[i].resp, parsed_info->password, MOUNT_=
PASSWD_SIZE + 1);
> > > +            } else if (get_password(msg[i]->msg, reply[i].resp, MOUN=
T_PASSWD_SIZE + 1) =3D=3D NULL) {
> > > +                goto fail;
> > > +            }
> > > +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
> > > +
> > > +                     reply[i].resp_retcode =3D PAM_SUCCESS;
> > > +                     break;
> > > +             case PAM_PROMPT_ECHO_ON:
> > > +                     fprintf(stderr, "%s: ", msg[i]->msg);
> > > +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSWD_SIZE=
 + 1)) =3D=3D NULL)
> > > +                goto fail;
> > > +
> > > +                     if (fgets(reply[i].resp, MOUNT_PASSWD_SIZE + 1,=
 stdin) =3D=3D NULL)
> >
> > Do we need to remove the trailing \n from the buffer?
> >
> > > +                goto fail;
> > > +
> > > +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
> > > +
> > > +                     reply[i].resp_retcode =3D PAM_SUCCESS;
> > > +                     break;
> > > +             case PAM_ERROR_MSG:
> >
> > Shouldn't this PAM_ERROR_MSG case goto fail?
> >
> > > +             case PAM_TEXT_INFO:
> > > +                     fprintf(stderr, "%s: ", msg[i]->msg);
> > > +
> > > +                     reply[i].resp_retcode =3D PAM_SUCCESS;
> > > +                     break;
> > > +             default:
> > > +                     goto fail;
> > > +             }
> > > +     }
> > > +     *resp =3D reply;
> > > +     return (PAM_SUCCESS);
> > > +
> > > + fail:
> > > +     for(i =3D 0; i < n; i++) {
> > > +        if (reply[i].resp)
> > > +            free(reply[i].resp);
> >
> > free(NULL) is a no-op, remove the checks.
> >
> > > +     }
> > > +     free(reply);
> > > +     return (PAM_CONV_ERR);
> > > +}
> >
> > I gave this a try with a properly configured system joined to AD from
> > local root account:
> >
> > aaptel$ ./configure
> > ...
> > checking krb5.h usability... yes
> > checking krb5.h presence... yes
> > checking for krb5.h... yes
> > checking krb5/krb5.h usability... yes
> > checking krb5/krb5.h presence... yes
> > checking for krb5/krb5.h... yes
> > checking for keyvalue in krb5_keyblock... no
> > ...
> > checking keyutils.h usability... yes
> > checking keyutils.h presence... yes
> > checking for keyutils.h... yes
> > checking for krb5_init_context in -lkrb5... yes
> > ...
> > checking for WBCLIENT... yes
> > checking for wbcSidsToUnixIds in -lwbclient... yes
> > ...
> > checking for keyutils.h... (cached) yes
> > checking security/pam_appl.h usability... yes
> > checking security/pam_appl.h presence... yes
> > checking for security/pam_appl.h... yes
> > checking for pam_start in -lpam... yes
> > checking for security/pam_appl.h... (cached) yes
> > checking for krb5_auth_con_getsendsubkey... yes
> > checking for krb5_principal_get_realm... no
> > checking for krb5_free_unparsed_name... yes
> > checking for krb5_auth_con_setaddrs... yes
> > checking for krb5_auth_con_set_req_cksumtype... yes
> > ...
> > aaptel$ make
> > ....(ok)
> >
> > Without force_pam:
> >
> > root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,username=
=3Dadministrator,domain=3DNUC
> > mount.cifs kernel mount options: ip=3D192.168.2.111,unc=3D\\adnuc.nuc.t=
est\data,sec=3Dkrb5,user=3Dadministrator,domain=3DNUC
> > mount error(2): No such file or directory
> > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel=
 log messages (dmesg)
> >
> > With force_pam:
> >
> > root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,username=
=3Dadministrator,domain=3DNUC,force_pam
> > Authenticating as user: administrator
> > Error in authenticating user with PAM: Authentication failure
> > Attempt to authenticate user with PAM unsuccessful. Still, proceeding w=
ith mount.
> >
> > =3D> no further message but mount failed and no msg in dmesg, it didn't
> >    reach the mount() call
> >
> > Not sure what is going on. Does the domain need to be passed to PAM?
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
>
>
>
> --
> -Shyam
