Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2D2C433E6
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Jan 2021 16:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1125E64DF5
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Jan 2021 16:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhA3QZ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Jan 2021 11:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhA3Ogx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Jan 2021 09:36:53 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534E7C061573
        for <linux-cifs@vger.kernel.org>; Sat, 30 Jan 2021 06:24:23 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id q201so8402289ybg.8
        for <linux-cifs@vger.kernel.org>; Sat, 30 Jan 2021 06:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YVGj1atcQ2lFmm0G3SW2PxiRNTg/LPhkrSx0fsR5u/A=;
        b=tb282TAQcw85mpoH6RY/HTdoDXJ3BfIY15xtRD+qam90nuEWsVIXucJY4CIAbhvCvw
         lkFZJi1EseQQavyEjVaw7irz85SVkEK90LfisoqBVvB0lIZkQ3FnxprQVtsuJrJ/lXlO
         RcU8OwdU3h8vZO8ioavV8cpEuzllKhiEB9qTiKRMAaEnEXfCyzSjjxnVG7b522Fjb4D9
         Qys2/MWowtkPLJNHnnPkQt4oPHLAJEialag1kmjz5IDhUbCxJgAuwCrZsDhOXKcDfkdV
         6kuMdEfcaYykBtF8PdbgjOQIYWf50feKob1LN6JtKD+Q3qpimtjdM7M/wKVPoyinr7Fy
         o2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YVGj1atcQ2lFmm0G3SW2PxiRNTg/LPhkrSx0fsR5u/A=;
        b=c7uxPzh2/7MLrnolyZGvoxTC3n029RnVzbfFmw/W664RQ5uBYSV5J5FuwIO6ae533T
         5kzmUW0oBWGyeekGvSpcH0X8ZnA1V6wj09JLbpZh6I4S4jISTXDg0/aLzZ7/oahqEDIu
         zpmBkyazZXgneog+tjvwpPKadPGwP88O0fb/4r2xnyCQwhO6GGwNk0C7H+c9ysYM7GVp
         tixOx0J8tVkf9wX7qa2ztBKKfQAdF1lvNgkeXp/uG5/JOhii7Hf04tG2thsRPw6Xq+na
         ug/+3KUzZkLqYinafiNnbohvC/osEdhfl6VlccTlBkVxPxu1NbV49RxowHbYgVEsVx9X
         MFGw==
X-Gm-Message-State: AOAM5331BV9BaD/GHUk3gGFItB5ErEE+n/9TiHL73PwSV2JDYglxG2sM
        nkHfb7XrzW6EG1OOE66BfdojnChIJ6PktRRycUw=
X-Google-Smtp-Source: ABdhPJxXNO1ZKaFIBb6QCgP+nRzeEl2iS3CO5NLftAKPJHoAXtA87/GndD2dnhHo/fvctSpRRkONG1JSsA0djO/lw4M=
X-Received: by 2002:a25:4091:: with SMTP id n139mr9970251yba.331.1612016662196;
 Sat, 30 Jan 2021 06:24:22 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
 <87pn7t4kr9.fsf@suse.com> <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
 <87eeo54q0i.fsf@suse.com> <CANT5p=rxp3iQMgxaM_mn3RE3B+zezWr3o8zpkFyWUR27CpeVCA@mail.gmail.com>
 <CANT5p=qMHxq_L5RpXAixzrQztjMr8-P_aO4aPg5uqfPSLNUiTA@mail.gmail.com>
 <874ko7vy0z.fsf@suse.com> <CANT5p=o07RqmMkcFoLeUVTeQHhzh5MmFYpfAdv0755iiGbp1ZA@mail.gmail.com>
 <87mu1yc6gw.fsf@suse.com> <CANT5p=r0Jix9EuuF8gJzQBGHLp0Y-Oogxzju7_2cJog_jF2fjg@mail.gmail.com>
 <874knolhpw.fsf@suse.com> <CANT5p=oTTErJk240GKc+k6Cihqks+9Nnurh=MdrvgC7gqKu1ww@mail.gmail.com>
 <CAKywueTr9GHbzg65s12BRKNB_L881wFLmHcb5boFxGX2AoN40g@mail.gmail.com>
 <CANT5p=rECwTZgskdXUr3VAHWA-PkYHEXX=qwO8PpVZRc0=pOKA@mail.gmail.com>
 <CAKywueTuGuqT8QN-8Jn1QNHT+HPKysLDhdp1gPsm6+Q0tQnbGA@mail.gmail.com>
 <CANT5p=pUVucG6NhzfziAjsjDnimHCWDUiJP46DYoRqjpXHegsA@mail.gmail.com>
 <0b80c61e-3953-e627-9818-8a8c6c50499e@samba.org> <CANT5p=rYiY0xE-35swsFKVitZD2yTchRiReyA0wVvY+mU_qKEw@mail.gmail.com>
In-Reply-To: <CANT5p=rYiY0xE-35swsFKVitZD2yTchRiReyA0wVvY+mU_qKEw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 30 Jan 2021 06:24:11 -0800
Message-ID: <CANT5p=rV-KhHtahaF-9YcM5X8jDMLbCx-szwLiZvACRt1oCyow@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        samba-technical <samba-technical@lists.samba.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It just occurred to me that integrating with mount.cifs will not
suffice for a multiuser scenario.
It sounds like we need to modify cifscreds command to have a switch
for cifscreds command; if used in krb5 context, instead of dealing
with kernel keyring, we authenticate with PAM (for add) and call PAM
logoff (for clear).
If users are then missing krb5 tickets (logged in to ssh using private
keys), they can call cifscreds to get the tickets.

@Pavel Shilovsky @Aur=C3=A9lien Aptel Please let me know what you think
about this approach.
If you agree, I'll start working on the patch.

Regards,
Shyam

On Wed, Dec 16, 2020 at 5:05 PM Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
>
> Hi Stefan,
>
> Thanks for the review. My replies inline...
>
> On Mon, 14 Dec, 2020, 23:33 Stefan Metzmacher, <metze@samba.org> wrote:
>>
>> Hi Shyam,
>>
>> in what way is this specific to kerberos?
>
> Cifs.ko expects Kerberos TGT to be present in cred cache before the user =
mounts the share. If winbind or sssd is configured, this would happen on mo=
st types of user login, by authentication against PAM, except for ssh priva=
te key auth (which is quite common). Hence trying to provide the user an op=
tion to authenticate during the mount.
>
> Do you see use cases outside of krb5, which can make use of this?
>
>> Would it make sense to call the configure option just --enable-pam?
>> And also remove the 'krb5' from other variables?
>
> There's already enable-pam which applies to ntlm multiuser scenario. Let =
me recheck if I can integrate with it somehow.
>>
>>
>> PAM_CIFS_SERVICE "cifs" seems to be unspecific,
>> "mount.cifs" or "cifs.mount". Maybe even "mount.smb3"?
>
> There could be cases where we need to do PAM auth even in cifs.upcall. Fo=
r example, when another user tries to access a multiuser mount. I haven't c=
oded it here though. So kept the name generic.
>>
>>
>> Can you fix the indentation of the patch? There seems to be
>> a strange mix of leading tabs and whitespaces, which make it hard to
>> read the patch.
>
> Will fix this in my follow up patch.
>>
>>
>> With force_pam I would not expect a failure to be ignored.
>
> Initially, I was thinking this could be a fallback option, in case mount =
fails with ENOKEY. But later changed it to a seperate option. Will fix this=
 in my next patch.
>>
>>
>> Why can this only be used with sec=3Dkrb5? Wouldn't it be possible
>> to fetch the password from the pam stack in order to pass it to
>> the kernel?
>
> I don't know of any PAM API to do that. You could use a password without =
prompting the user, which I'm doing for cases where password has been passe=
d as a mount option.
>>
>>
>> metze
>>
>> Am 27.11.20 um 11:43 schrieb Shyam Prasad N via samba-technical:
>> > Discussed this with Aurelien today.
>> >
>> > With the patch last sent, users are authenticated using the PAM stack.
>> > However, there's no call to cleanup the PAM credentials. Which could
>> > leave the kerberos tickets around, even after the umount.
>> >
>> > To complete this fix, we need a mechanism to tell the umount helper
>> > umount.cifs (a new executable to be created) that PAM authentication
>> > was used for the mount.
>> >
>> > There are two possible approaches which I could think of:
>> > 1. Add a new mount option in cifs.ko. Inside cifs.ko, this option
>> > would be non-functional. But will be used by umount.cifs to call PAM
>> > for cleanup.
>> > 2. In mount.cifs, keep this info in a temporary file (maybe
>> > /var/run/cifs/). umount.cifs will read this and call PAM for cleanup.
>> >
>> > I feel approach 1 is a cleaner approach to take. Aurelien seems to
>> > favour option 1 as well.
>> > Please feel free to comment if you feel otherwise.
>> > Once we agree on the right approach, I'll send a patch for the changes=
.
>> >
>> > Regards,
>> > Shyam
>> >
>> > On Wed, Nov 11, 2020 at 12:53 AM Pavel Shilovsky <piastryyy@gmail.com>=
 wrote:
>> >>
>> >> Sure. Removed the patch and updated the next branch.
>> >> --
>> >> Best regards,
>> >> Pavel Shilovsky
>> >>
>> >> =D0=B2=D1=82, 10 =D0=BD=D0=BE=D1=8F=D0=B1. 2020 =D0=B3. =D0=B2 05:20,=
 Shyam Prasad N <nspmangalore@gmail.com>:
>> >>>
>> >>> Hi Pavel,
>> >>>
>> >>> There is more that needs to be done on this item. Otherwise, this wi=
ll
>> >>> depend on user behaviour to cleanup unused krb5 tickets.
>> >>> The pending items on this is to propagate this mount option to cifs.=
ko
>> >>> and write an umount.cifs utility to read that mount option to do PAM
>> >>> logoff.
>> >>> So please rollback this patch for now.
>> >>>
>> >>> Regards,
>> >>> Shyam
>> >>>
>> >>> On Tue, Nov 10, 2020 at 5:12 AM Pavel Shilovsky <piastryyy@gmail.com=
> wrote:
>> >>>>
>> >>>> Merged into next. Please let me know if something needs to be fixed=
. Thanks!
>> >>>> --
>> >>>> Best regards,
>> >>>> Pavel Shilovsky
>> >>>>
>> >>>> =D1=87=D1=82, 24 =D1=81=D0=B5=D0=BD=D1=82. 2020 =D0=B3. =D0=B2 03:3=
9, Shyam Prasad N <nspmangalore@gmail.com>:
>> >>>>>
>> >>>>> Hi Aur=C3=A9lien,
>> >>>>>
>> >>>>> I've implemented most of your review comments. Also fixed the issu=
e.
>> >>>>>
>> >>>>> On Wed, Sep 23, 2020 at 7:26 PM Aur=C3=A9lien Aptel <aaptel@suse.c=
om> wrote:
>> >>>>>>
>> >>>>>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>> >>>>>>> Also, I'll test this out with DFS once I figure out how to set i=
t up. :)
>> >>>>>>> Re-attaching the patch with some minor changes with just the
>> >>>>>>> "force_pam" mount option.
>> >>>>>>
>> >>>>>> You will need 2 Windows VM. DFS is basically symlinks across
>> >>>>>> servers. The DFS root VM will host the links (standalone namespac=
e) and
>> >>>>>> you have to make them point to shares on the 2nd VM. You don't ne=
ed to
>> >>>>>> setup replication to test.
>> >>>>>>
>> >>>>>> When you mount the root in cifs.ko and access a link, the server =
will
>> >>>>>> reply that the file is remote. cifs.ko then does an FSCTL on the =
link to
>> >>>>>> resolve the target it points to and then connects to the target a=
nd
>> >>>>>> mounts it under the link seemlessly.
>> >>>>>>
>> >>>>>>
>> >>>>>> Regarding the patch:
>> >>>>>>
>> >>>>>> * need to update the man page with option and explanation
>> >>>>>>
>> >>>>>> I have some comments with the style, I know it's annoying.. but i=
t
>> >>>>>> would be best to keep the same across the code.
>> >>>>>>
>> >>>>>> * use the existing indent style (tabs) and avoid adding trailing =
whitespaces.
>> >>>>>> * no () for return statements
>> >>>>>> * no casting for memory allocation
>> >>>>>> * if (X) free(X)  =3D> free(X)
>> >>>>>>
>> >>>>>> Below some comments about pam_auth_krb5_conv():
>> >>>>>>
>> >>>>>>> @@ -1809,6 +1824,119 @@ get_password(const char *prompt, char *i=
nput, int capacity)
>> >>>>>>>       return input;
>> >>>>>>>  }
>> >>>>>>>
>> >>>>>>> +#ifdef HAVE_KRB5PAM
>> >>>>>>> +#define PAM_CIFS_SERVICE "cifs"
>> >>>>>>> +
>> >>>>>>> +static int
>> >>>>>>> +pam_auth_krb5_conv(int n, const struct pam_message **msg,
>> >>>>>>> +    struct pam_response **resp, void *data)
>> >>>>>>> +{
>> >>>>>>> +    struct parsed_mount_info *parsed_info;
>> >>>>>>> +     struct pam_response *reply;
>> >>>>>>> +     int i;
>> >>>>>>> +
>> >>>>>>> +     *resp =3D NULL;
>> >>>>>>> +
>> >>>>>>> +    parsed_info =3D data;
>> >>>>>>> +    if (parsed_info =3D=3D NULL)
>> >>>>>>> +             return (PAM_CONV_ERR);
>> >>>>>>> +     if (n <=3D 0 || n > PAM_MAX_NUM_MSG)
>> >>>>>>> +             return (PAM_CONV_ERR);
>> >>>>>>> +
>> >>>>>>> +     if ((reply =3D calloc(n, sizeof(*reply))) =3D=3D NULL)
>> >>>>>>> +             return (PAM_CONV_ERR);
>> >>>>>>> +
>> >>>>>>> +     for (i =3D 0; i < n; ++i) {
>> >>>>>>> +             switch (msg[i]->msg_style) {
>> >>>>>>> +             case PAM_PROMPT_ECHO_OFF:
>> >>>>>>> +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSWD=
_SIZE + 1)) =3D=3D NULL)
>> >>>>>>> +                goto fail;
>> >>>>>>> +
>> >>>>>>> +            if (parsed_info->got_password && parsed_info->passw=
ord !=3D NULL) {
>> >>>>>>> +                strncpy(reply[i].resp, parsed_info->password, M=
OUNT_PASSWD_SIZE + 1);
>> >>>>>>> +            } else if (get_password(msg[i]->msg, reply[i].resp,=
 MOUNT_PASSWD_SIZE + 1) =3D=3D NULL) {
>> >>>>>>> +                goto fail;
>> >>>>>>> +            }
>> >>>>>>> +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
>> >>>>>>> +
>> >>>>>>> +                     reply[i].resp_retcode =3D PAM_SUCCESS;
>> >>>>>>> +                     break;
>> >>>>>>> +             case PAM_PROMPT_ECHO_ON:
>> >>>>>>> +                     fprintf(stderr, "%s: ", msg[i]->msg);
>> >>>>>>> +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSWD=
_SIZE + 1)) =3D=3D NULL)
>> >>>>>>> +                goto fail;
>> >>>>>>> +
>> >>>>>>> +                     if (fgets(reply[i].resp, MOUNT_PASSWD_SIZE=
 + 1, stdin) =3D=3D NULL)
>> >>>>>>
>> >>>>>> Do we need to remove the trailing \n from the buffer?
>> >>>>>>
>> >>>>>>> +                goto fail;
>> >>>>>>> +
>> >>>>>>> +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
>> >>>>>>> +
>> >>>>>>> +                     reply[i].resp_retcode =3D PAM_SUCCESS;
>> >>>>>>> +                     break;
>> >>>>>>> +             case PAM_ERROR_MSG:
>> >>>>>>
>> >>>>>> Shouldn't this PAM_ERROR_MSG case goto fail?
>> >>>>>>
>> >>>>>>> +             case PAM_TEXT_INFO:
>> >>>>>>> +                     fprintf(stderr, "%s: ", msg[i]->msg);
>> >>>>>>> +
>> >>>>>>> +                     reply[i].resp_retcode =3D PAM_SUCCESS;
>> >>>>>>> +                     break;
>> >>>>>>> +             default:
>> >>>>>>> +                     goto fail;
>> >>>>>>> +             }
>> >>>>>>> +     }
>> >>>>>>> +     *resp =3D reply;
>> >>>>>>> +     return (PAM_SUCCESS);
>> >>>>>>> +
>> >>>>>>> + fail:
>> >>>>>>> +     for(i =3D 0; i < n; i++) {
>> >>>>>>> +        if (reply[i].resp)
>> >>>>>>> +            free(reply[i].resp);
>> >>>>>>
>> >>>>>> free(NULL) is a no-op, remove the checks.
>> >>>>>>
>> >>>>>>> +     }
>> >>>>>>> +     free(reply);
>> >>>>>>> +     return (PAM_CONV_ERR);
>> >>>>>>> +}
>> >>>>>>
>> >>>>>> I gave this a try with a properly configured system joined to AD =
from
>> >>>>>> local root account:
>> >>>>>>
>> >>>>>> aaptel$ ./configure
>> >>>>>> ...
>> >>>>>> checking krb5.h usability... yes
>> >>>>>> checking krb5.h presence... yes
>> >>>>>> checking for krb5.h... yes
>> >>>>>> checking krb5/krb5.h usability... yes
>> >>>>>> checking krb5/krb5.h presence... yes
>> >>>>>> checking for krb5/krb5.h... yes
>> >>>>>> checking for keyvalue in krb5_keyblock... no
>> >>>>>> ...
>> >>>>>> checking keyutils.h usability... yes
>> >>>>>> checking keyutils.h presence... yes
>> >>>>>> checking for keyutils.h... yes
>> >>>>>> checking for krb5_init_context in -lkrb5... yes
>> >>>>>> ...
>> >>>>>> checking for WBCLIENT... yes
>> >>>>>> checking for wbcSidsToUnixIds in -lwbclient... yes
>> >>>>>> ...
>> >>>>>> checking for keyutils.h... (cached) yes
>> >>>>>> checking security/pam_appl.h usability... yes
>> >>>>>> checking security/pam_appl.h presence... yes
>> >>>>>> checking for security/pam_appl.h... yes
>> >>>>>> checking for pam_start in -lpam... yes
>> >>>>>> checking for security/pam_appl.h... (cached) yes
>> >>>>>> checking for krb5_auth_con_getsendsubkey... yes
>> >>>>>> checking for krb5_principal_get_realm... no
>> >>>>>> checking for krb5_free_unparsed_name... yes
>> >>>>>> checking for krb5_auth_con_setaddrs... yes
>> >>>>>> checking for krb5_auth_con_set_req_cksumtype... yes
>> >>>>>> ...
>> >>>>>> aaptel$ make
>> >>>>>> ....(ok)
>> >>>>>>
>> >>>>>> Without force_pam:
>> >>>>>>
>> >>>>>> root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,user=
name=3Dadministrator,domain=3DNUC
>> >>>>>> mount.cifs kernel mount options: ip=3D192.168.2.111,unc=3D\\adnuc=
.nuc.test\data,sec=3Dkrb5,user=3Dadministrator,domain=3DNUC
>> >>>>>> mount error(2): No such file or directory
>> >>>>>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and =
kernel log messages (dmesg)
>> >>>>>>
>> >>>>>> With force_pam:
>> >>>>>>
>> >>>>>> root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,user=
name=3Dadministrator,domain=3DNUC,force_pam
>> >>>>>> Authenticating as user: administrator
>> >>>>>> Error in authenticating user with PAM: Authentication failure
>> >>>>>> Attempt to authenticate user with PAM unsuccessful. Still, procee=
ding with mount.
>> >>>>>>
>> >>>>>> =3D> no further message but mount failed and no msg in dmesg, it =
didn't
>> >>>>>>    reach the mount() call
>> >>>>>>
>> >>>>>> Not sure what is going on. Does the domain need to be passed to P=
AM?
>> >>>>>>
>> >>>>>> Cheers,
>> >>>>>> --
>> >>>>>> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
>> >>>>>> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>> >>>>>> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=
=BCrnberg, DE
>> >>>>>> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (=
AG M=C3=BCnchen)
>> >>>>>
>> >>>>>
>> >>>>>
>> >>>>> --
>> >>>>> -Shyam
>> >>>
>> >>>
>> >>>
>> >>> --
>> >>> -Shyam
>> >
>> >
>> >
>>
>>


--=20
Regards,
Shyam
