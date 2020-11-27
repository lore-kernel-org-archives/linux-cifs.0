Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E74C2D0E4
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Nov 2020 10:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CE0620795
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Nov 2020 10:44:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uHkwhIxc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgK0KoB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Nov 2020 05:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbgK0KoB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Nov 2020 05:44:01 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59C5C0613D1
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2020 02:43:59 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 10so4122163ybx.9
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2020 02:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J4Bkv4WZ9ru+zqAfdV7nspd8GGQPILjudzNXOa3DB8o=;
        b=uHkwhIxcxtwL/TqQCZGRAysX4WqqAa1WJShnfLic5PEEk9a8PqfAYzaJdgR/v2AG98
         TSPZibdNjK57AONITbAPybZODVsJZ1pmb0pI2wWl0b5/ZL+SgwUVERyJk15rA1loviuE
         6U0VRorSETamL7hLVtKNRDDJHE9W5h/LDqUnduV7OEHwju0d8oKrhgw65dKWkqaDl+bm
         VYAXbKi8t/3fRkYb3f+Ziaz3XcJrOZi0eKW4m8eJ7D2IAeqS9YknnhNOqmTsCINMfGD8
         OBGdufXSSBockC0RHZPXZQn0x5mQAWKV+LeBuOd5oFo3kVEbRRaKHju6GMJU9Qkn2XbN
         H89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J4Bkv4WZ9ru+zqAfdV7nspd8GGQPILjudzNXOa3DB8o=;
        b=TW3whuGxwtj7bFnyYaSH0mNy7TUk8esXbsOxNT+xh1XHkuWBavnEwe6AAJ7O4/9d1i
         NqIiEWzm3OtmXP8/RUXN/8jcdJErPIyqh1N3kq84B6ENk3ywjeZGiIQ3y60k3U1tG2Qw
         3PBnmPSHCpv2wJJ8a7/8mpeveUBYWQ0feKo84TfgQBaTbWyrI4WWLvn39ehHxhUGyytu
         x9SiXmkJ/MhvyP0a5fj3ttAhUTR/S5wMIw/taB274uHazFwaHBgYOCYKDKS5Cg+WLjKv
         n5C685x2+jES9u+Q5Czu//BRbpGvoG2JmChNqOvgK4Wu1xHc5qV1z2wpvPBdXL8rFh/m
         KG4Q==
X-Gm-Message-State: AOAM533todRaYeStbeIFkOCY0c7qYgpEZZWFSUus7c+SOUVD96qYB9rx
        mAsNDMHyme9JkJpFDVWeEpWfsYYYHXkSxOnF3Og=
X-Google-Smtp-Source: ABdhPJyXSdVNNkV1foPlxmmSN89/2IiYbxUo1g4ILGywAWuWYZ4+uEtlmpZGJh4eVjQnbX4sf/Rg5GeDfk4uunFQ7eg=
X-Received: by 2002:a25:cad2:: with SMTP id a201mr9583480ybg.327.1606473839028;
 Fri, 27 Nov 2020 02:43:59 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
 <87pn7t4kr9.fsf@suse.com> <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
 <87eeo54q0i.fsf@suse.com> <CANT5p=rxp3iQMgxaM_mn3RE3B+zezWr3o8zpkFyWUR27CpeVCA@mail.gmail.com>
 <CANT5p=qMHxq_L5RpXAixzrQztjMr8-P_aO4aPg5uqfPSLNUiTA@mail.gmail.com>
 <874ko7vy0z.fsf@suse.com> <CANT5p=o07RqmMkcFoLeUVTeQHhzh5MmFYpfAdv0755iiGbp1ZA@mail.gmail.com>
 <87mu1yc6gw.fsf@suse.com> <CANT5p=r0Jix9EuuF8gJzQBGHLp0Y-Oogxzju7_2cJog_jF2fjg@mail.gmail.com>
 <874knolhpw.fsf@suse.com> <CANT5p=oTTErJk240GKc+k6Cihqks+9Nnurh=MdrvgC7gqKu1ww@mail.gmail.com>
 <CAKywueTr9GHbzg65s12BRKNB_L881wFLmHcb5boFxGX2AoN40g@mail.gmail.com>
 <CANT5p=rECwTZgskdXUr3VAHWA-PkYHEXX=qwO8PpVZRc0=pOKA@mail.gmail.com> <CAKywueTuGuqT8QN-8Jn1QNHT+HPKysLDhdp1gPsm6+Q0tQnbGA@mail.gmail.com>
In-Reply-To: <CAKywueTuGuqT8QN-8Jn1QNHT+HPKysLDhdp1gPsm6+Q0tQnbGA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 27 Nov 2020 16:13:50 +0530
Message-ID: <CANT5p=pUVucG6NhzfziAjsjDnimHCWDUiJP46DYoRqjpXHegsA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Steve French <smfrench@gmail.com>, sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Discussed this with Aurelien today.

With the patch last sent, users are authenticated using the PAM stack.
However, there's no call to cleanup the PAM credentials. Which could
leave the kerberos tickets around, even after the umount.

To complete this fix, we need a mechanism to tell the umount helper
umount.cifs (a new executable to be created) that PAM authentication
was used for the mount.

There are two possible approaches which I could think of:
1. Add a new mount option in cifs.ko. Inside cifs.ko, this option
would be non-functional. But will be used by umount.cifs to call PAM
for cleanup.
2. In mount.cifs, keep this info in a temporary file (maybe
/var/run/cifs/). umount.cifs will read this and call PAM for cleanup.

I feel approach 1 is a cleaner approach to take. Aurelien seems to
favour option 1 as well.
Please feel free to comment if you feel otherwise.
Once we agree on the right approach, I'll send a patch for the changes.

Regards,
Shyam

On Wed, Nov 11, 2020 at 12:53 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> Sure. Removed the patch and updated the next branch.
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=B2=D1=82, 10 =D0=BD=D0=BE=D1=8F=D0=B1. 2020 =D0=B3. =D0=B2 05:20, Shy=
am Prasad N <nspmangalore@gmail.com>:
> >
> > Hi Pavel,
> >
> > There is more that needs to be done on this item. Otherwise, this will
> > depend on user behaviour to cleanup unused krb5 tickets.
> > The pending items on this is to propagate this mount option to cifs.ko
> > and write an umount.cifs utility to read that mount option to do PAM
> > logoff.
> > So please rollback this patch for now.
> >
> > Regards,
> > Shyam
> >
> > On Tue, Nov 10, 2020 at 5:12 AM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > Merged into next. Please let me know if something needs to be fixed. =
Thanks!
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D1=87=D1=82, 24 =D1=81=D0=B5=D0=BD=D1=82. 2020 =D0=B3. =D0=B2 03:39,=
 Shyam Prasad N <nspmangalore@gmail.com>:
> > > >
> > > > Hi Aur=C3=A9lien,
> > > >
> > > > I've implemented most of your review comments. Also fixed the issue=
.
> > > >
> > > > On Wed, Sep 23, 2020 at 7:26 PM Aur=C3=A9lien Aptel <aaptel@suse.co=
m> wrote:
> > > > >
> > > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > > > Also, I'll test this out with DFS once I figure out how to set =
it up. :)
> > > > > > Re-attaching the patch with some minor changes with just the
> > > > > > "force_pam" mount option.
> > > > >
> > > > > You will need 2 Windows VM. DFS is basically symlinks across
> > > > > servers. The DFS root VM will host the links (standalone namespac=
e) and
> > > > > you have to make them point to shares on the 2nd VM. You don't ne=
ed to
> > > > > setup replication to test.
> > > > >
> > > > > When you mount the root in cifs.ko and access a link, the server =
will
> > > > > reply that the file is remote. cifs.ko then does an FSCTL on the =
link to
> > > > > resolve the target it points to and then connects to the target a=
nd
> > > > > mounts it under the link seemlessly.
> > > > >
> > > > >
> > > > > Regarding the patch:
> > > > >
> > > > > * need to update the man page with option and explanation
> > > > >
> > > > > I have some comments with the style, I know it's annoying.. but i=
t
> > > > > would be best to keep the same across the code.
> > > > >
> > > > > * use the existing indent style (tabs) and avoid adding trailing =
whitespaces.
> > > > > * no () for return statements
> > > > > * no casting for memory allocation
> > > > > * if (X) free(X)  =3D> free(X)
> > > > >
> > > > > Below some comments about pam_auth_krb5_conv():
> > > > >
> > > > > > @@ -1809,6 +1824,119 @@ get_password(const char *prompt, char *=
input, int capacity)
> > > > > >       return input;
> > > > > >  }
> > > > > >
> > > > > > +#ifdef HAVE_KRB5PAM
> > > > > > +#define PAM_CIFS_SERVICE "cifs"
> > > > > > +
> > > > > > +static int
> > > > > > +pam_auth_krb5_conv(int n, const struct pam_message **msg,
> > > > > > +    struct pam_response **resp, void *data)
> > > > > > +{
> > > > > > +    struct parsed_mount_info *parsed_info;
> > > > > > +     struct pam_response *reply;
> > > > > > +     int i;
> > > > > > +
> > > > > > +     *resp =3D NULL;
> > > > > > +
> > > > > > +    parsed_info =3D data;
> > > > > > +    if (parsed_info =3D=3D NULL)
> > > > > > +             return (PAM_CONV_ERR);
> > > > > > +     if (n <=3D 0 || n > PAM_MAX_NUM_MSG)
> > > > > > +             return (PAM_CONV_ERR);
> > > > > > +
> > > > > > +     if ((reply =3D calloc(n, sizeof(*reply))) =3D=3D NULL)
> > > > > > +             return (PAM_CONV_ERR);
> > > > > > +
> > > > > > +     for (i =3D 0; i < n; ++i) {
> > > > > > +             switch (msg[i]->msg_style) {
> > > > > > +             case PAM_PROMPT_ECHO_OFF:
> > > > > > +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSW=
D_SIZE + 1)) =3D=3D NULL)
> > > > > > +                goto fail;
> > > > > > +
> > > > > > +            if (parsed_info->got_password && parsed_info->pass=
word !=3D NULL) {
> > > > > > +                strncpy(reply[i].resp, parsed_info->password, =
MOUNT_PASSWD_SIZE + 1);
> > > > > > +            } else if (get_password(msg[i]->msg, reply[i].resp=
, MOUNT_PASSWD_SIZE + 1) =3D=3D NULL) {
> > > > > > +                goto fail;
> > > > > > +            }
> > > > > > +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
> > > > > > +
> > > > > > +                     reply[i].resp_retcode =3D PAM_SUCCESS;
> > > > > > +                     break;
> > > > > > +             case PAM_PROMPT_ECHO_ON:
> > > > > > +                     fprintf(stderr, "%s: ", msg[i]->msg);
> > > > > > +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSW=
D_SIZE + 1)) =3D=3D NULL)
> > > > > > +                goto fail;
> > > > > > +
> > > > > > +                     if (fgets(reply[i].resp, MOUNT_PASSWD_SIZ=
E + 1, stdin) =3D=3D NULL)
> > > > >
> > > > > Do we need to remove the trailing \n from the buffer?
> > > > >
> > > > > > +                goto fail;
> > > > > > +
> > > > > > +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
> > > > > > +
> > > > > > +                     reply[i].resp_retcode =3D PAM_SUCCESS;
> > > > > > +                     break;
> > > > > > +             case PAM_ERROR_MSG:
> > > > >
> > > > > Shouldn't this PAM_ERROR_MSG case goto fail?
> > > > >
> > > > > > +             case PAM_TEXT_INFO:
> > > > > > +                     fprintf(stderr, "%s: ", msg[i]->msg);
> > > > > > +
> > > > > > +                     reply[i].resp_retcode =3D PAM_SUCCESS;
> > > > > > +                     break;
> > > > > > +             default:
> > > > > > +                     goto fail;
> > > > > > +             }
> > > > > > +     }
> > > > > > +     *resp =3D reply;
> > > > > > +     return (PAM_SUCCESS);
> > > > > > +
> > > > > > + fail:
> > > > > > +     for(i =3D 0; i < n; i++) {
> > > > > > +        if (reply[i].resp)
> > > > > > +            free(reply[i].resp);
> > > > >
> > > > > free(NULL) is a no-op, remove the checks.
> > > > >
> > > > > > +     }
> > > > > > +     free(reply);
> > > > > > +     return (PAM_CONV_ERR);
> > > > > > +}
> > > > >
> > > > > I gave this a try with a properly configured system joined to AD =
from
> > > > > local root account:
> > > > >
> > > > > aaptel$ ./configure
> > > > > ...
> > > > > checking krb5.h usability... yes
> > > > > checking krb5.h presence... yes
> > > > > checking for krb5.h... yes
> > > > > checking krb5/krb5.h usability... yes
> > > > > checking krb5/krb5.h presence... yes
> > > > > checking for krb5/krb5.h... yes
> > > > > checking for keyvalue in krb5_keyblock... no
> > > > > ...
> > > > > checking keyutils.h usability... yes
> > > > > checking keyutils.h presence... yes
> > > > > checking for keyutils.h... yes
> > > > > checking for krb5_init_context in -lkrb5... yes
> > > > > ...
> > > > > checking for WBCLIENT... yes
> > > > > checking for wbcSidsToUnixIds in -lwbclient... yes
> > > > > ...
> > > > > checking for keyutils.h... (cached) yes
> > > > > checking security/pam_appl.h usability... yes
> > > > > checking security/pam_appl.h presence... yes
> > > > > checking for security/pam_appl.h... yes
> > > > > checking for pam_start in -lpam... yes
> > > > > checking for security/pam_appl.h... (cached) yes
> > > > > checking for krb5_auth_con_getsendsubkey... yes
> > > > > checking for krb5_principal_get_realm... no
> > > > > checking for krb5_free_unparsed_name... yes
> > > > > checking for krb5_auth_con_setaddrs... yes
> > > > > checking for krb5_auth_con_set_req_cksumtype... yes
> > > > > ...
> > > > > aaptel$ make
> > > > > ....(ok)
> > > > >
> > > > > Without force_pam:
> > > > >
> > > > > root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,user=
name=3Dadministrator,domain=3DNUC
> > > > > mount.cifs kernel mount options: ip=3D192.168.2.111,unc=3D\\adnuc=
.nuc.test\data,sec=3Dkrb5,user=3Dadministrator,domain=3DNUC
> > > > > mount error(2): No such file or directory
> > > > > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and =
kernel log messages (dmesg)
> > > > >
> > > > > With force_pam:
> > > > >
> > > > > root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,user=
name=3Dadministrator,domain=3DNUC,force_pam
> > > > > Authenticating as user: administrator
> > > > > Error in authenticating user with PAM: Authentication failure
> > > > > Attempt to authenticate user with PAM unsuccessful. Still, procee=
ding with mount.
> > > > >
> > > > > =3D> no further message but mount failed and no msg in dmesg, it =
didn't
> > > > >    reach the mount() call
> > > > >
> > > > > Not sure what is going on. Does the domain need to be passed to P=
AM?
> > > > >
> > > > > Cheers,
> > > > > --
> > > > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=
=BCrnberg, DE
> > > > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (=
AG M=C3=BCnchen)
> > > >
> > > >
> > > >
> > > > --
> > > > -Shyam
> >
> >
> >
> > --
> > -Shyam



--=20
-Shyam
