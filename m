Return-Path: <SRS0=C86/=DB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB72FC4363D
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Sep 2020 10:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B0E123772
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Sep 2020 10:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khsm8/X3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgIXKjh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Sep 2020 06:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgIXKjh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Sep 2020 06:39:37 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CB2C0613CE
        for <linux-cifs@vger.kernel.org>; Thu, 24 Sep 2020 03:39:36 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id k18so1983276ybh.1
        for <linux-cifs@vger.kernel.org>; Thu, 24 Sep 2020 03:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LwOwxoEBOYJzRooQROQxUK43BDUaeMvR/ic7oTzdW0g=;
        b=khsm8/X35B3U9taPU84Xr34rjIq4/wXDDgyrJYcN8prKr/n/BrQVKkGNSGXvWPpjxy
         Xanx4rYPuPvc+t4oDYW/+NnMnwqrsC6QXW4XM/h/Fdal54IG5EI6rB3UN1aguyRXYsKR
         8iI78keY1skVt+i7PgRDcrTmfg4BvsLXNq6AvorkwkhMmp/Ha1JTm4hbV/XdvsGnx3k+
         pVN/XwSsFEgi/ygHCbyERdg8pNs1lWtW8OoA2m/IrD9s1tV7DRDtyWtp34c30mRD82up
         NDYXWdR9vMB6V+GB62hG5BwSKc9xTNNCjekDMxAUKWCWXNXGauQ5lIYTBTdY4y1Ov+/s
         SucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LwOwxoEBOYJzRooQROQxUK43BDUaeMvR/ic7oTzdW0g=;
        b=IA7+HtHvCTVsiaF5pIRe80q7hIjS0W8PVz6s3xmBMQTsIZaWFYqk+T/A0KoC8AH6xc
         BpDKtgppaM7XGAOsx9+wx+13AiRAqIWUu+aFoFXMcX4YVSIvsthwtllKp5cIc5q9C0ZE
         Jg5EQJo4qqNadkcjuT+vjNgYW28ulkZf8wxkYdjuQrUTUMoNtc+e7KjRkQPSfu+ZXBJa
         C6cxfD/6OVhNB8GhfajRTKVcsNu4G7F0g5jUOSERwzVPv/IedAIEMZ5Q1BUjeNKEVwSq
         bc+3vk4ueBtikHfdH7GCr2LbpR6S8kMiLO5fKZtgWs2CqnZJsSqHkhoxHrPypMOC59xj
         54rQ==
X-Gm-Message-State: AOAM530ZxJTBW6h4yhg4Sl1aRrtth+5CBcynsk/HonFshhXevI7pMMM2
        fDUTGalNCuqLyHzVuSnRFo/p2NxwlGcabAvg8UM=
X-Google-Smtp-Source: ABdhPJxbatW6D14v9Ip4PfmCNDHL5mswpXPieFlehRq+dFruVnBPKlJfRUQR272cxlZE1eOhCPsg1Z9+qfRSH/K+Zbo=
X-Received: by 2002:a25:cbd1:: with SMTP id b200mr6484202ybg.293.1600943975713;
 Thu, 24 Sep 2020 03:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
 <87pn7t4kr9.fsf@suse.com> <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
 <87eeo54q0i.fsf@suse.com> <CANT5p=rxp3iQMgxaM_mn3RE3B+zezWr3o8zpkFyWUR27CpeVCA@mail.gmail.com>
 <CANT5p=qMHxq_L5RpXAixzrQztjMr8-P_aO4aPg5uqfPSLNUiTA@mail.gmail.com>
 <874ko7vy0z.fsf@suse.com> <CANT5p=o07RqmMkcFoLeUVTeQHhzh5MmFYpfAdv0755iiGbp1ZA@mail.gmail.com>
 <87mu1yc6gw.fsf@suse.com> <CANT5p=r0Jix9EuuF8gJzQBGHLp0Y-Oogxzju7_2cJog_jF2fjg@mail.gmail.com>
 <874knolhpw.fsf@suse.com>
In-Reply-To: <874knolhpw.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 24 Sep 2020 16:09:25 +0530
Message-ID: <CANT5p=oTTErJk240GKc+k6Cihqks+9Nnurh=MdrvgC7gqKu1ww@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, samba-technical@lists.samba.org,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>, sribhat.msa@outlook.com
Content-Type: multipart/mixed; boundary="000000000000fa672805b00cd061"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000fa672805b00cd061
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Aur=C3=A9lien,

I've implemented most of your review comments. Also fixed the issue.

On Wed, Sep 23, 2020 at 7:26 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > Also, I'll test this out with DFS once I figure out how to set it up. :=
)
> > Re-attaching the patch with some minor changes with just the
> > "force_pam" mount option.
>
> You will need 2 Windows VM. DFS is basically symlinks across
> servers. The DFS root VM will host the links (standalone namespace) and
> you have to make them point to shares on the 2nd VM. You don't need to
> setup replication to test.
>
> When you mount the root in cifs.ko and access a link, the server will
> reply that the file is remote. cifs.ko then does an FSCTL on the link to
> resolve the target it points to and then connects to the target and
> mounts it under the link seemlessly.
>
>
> Regarding the patch:
>
> * need to update the man page with option and explanation
>
> I have some comments with the style, I know it's annoying.. but it
> would be best to keep the same across the code.
>
> * use the existing indent style (tabs) and avoid adding trailing whitespa=
ces.
> * no () for return statements
> * no casting for memory allocation
> * if (X) free(X)  =3D> free(X)
>
> Below some comments about pam_auth_krb5_conv():
>
> > @@ -1809,6 +1824,119 @@ get_password(const char *prompt, char *input, i=
nt capacity)
> >       return input;
> >  }
> >
> > +#ifdef HAVE_KRB5PAM
> > +#define PAM_CIFS_SERVICE "cifs"
> > +
> > +static int
> > +pam_auth_krb5_conv(int n, const struct pam_message **msg,
> > +    struct pam_response **resp, void *data)
> > +{
> > +    struct parsed_mount_info *parsed_info;
> > +     struct pam_response *reply;
> > +     int i;
> > +
> > +     *resp =3D NULL;
> > +
> > +    parsed_info =3D data;
> > +    if (parsed_info =3D=3D NULL)
> > +             return (PAM_CONV_ERR);
> > +     if (n <=3D 0 || n > PAM_MAX_NUM_MSG)
> > +             return (PAM_CONV_ERR);
> > +
> > +     if ((reply =3D calloc(n, sizeof(*reply))) =3D=3D NULL)
> > +             return (PAM_CONV_ERR);
> > +
> > +     for (i =3D 0; i < n; ++i) {
> > +             switch (msg[i]->msg_style) {
> > +             case PAM_PROMPT_ECHO_OFF:
> > +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSWD_SIZE +=
 1)) =3D=3D NULL)
> > +                goto fail;
> > +
> > +            if (parsed_info->got_password && parsed_info->password !=
=3D NULL) {
> > +                strncpy(reply[i].resp, parsed_info->password, MOUNT_PA=
SSWD_SIZE + 1);
> > +            } else if (get_password(msg[i]->msg, reply[i].resp, MOUNT_=
PASSWD_SIZE + 1) =3D=3D NULL) {
> > +                goto fail;
> > +            }
> > +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
> > +
> > +                     reply[i].resp_retcode =3D PAM_SUCCESS;
> > +                     break;
> > +             case PAM_PROMPT_ECHO_ON:
> > +                     fprintf(stderr, "%s: ", msg[i]->msg);
> > +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSWD_SIZE +=
 1)) =3D=3D NULL)
> > +                goto fail;
> > +
> > +                     if (fgets(reply[i].resp, MOUNT_PASSWD_SIZE + 1, s=
tdin) =3D=3D NULL)
>
> Do we need to remove the trailing \n from the buffer?
>
> > +                goto fail;
> > +
> > +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
> > +
> > +                     reply[i].resp_retcode =3D PAM_SUCCESS;
> > +                     break;
> > +             case PAM_ERROR_MSG:
>
> Shouldn't this PAM_ERROR_MSG case goto fail?
>
> > +             case PAM_TEXT_INFO:
> > +                     fprintf(stderr, "%s: ", msg[i]->msg);
> > +
> > +                     reply[i].resp_retcode =3D PAM_SUCCESS;
> > +                     break;
> > +             default:
> > +                     goto fail;
> > +             }
> > +     }
> > +     *resp =3D reply;
> > +     return (PAM_SUCCESS);
> > +
> > + fail:
> > +     for(i =3D 0; i < n; i++) {
> > +        if (reply[i].resp)
> > +            free(reply[i].resp);
>
> free(NULL) is a no-op, remove the checks.
>
> > +     }
> > +     free(reply);
> > +     return (PAM_CONV_ERR);
> > +}
>
> I gave this a try with a properly configured system joined to AD from
> local root account:
>
> aaptel$ ./configure
> ...
> checking krb5.h usability... yes
> checking krb5.h presence... yes
> checking for krb5.h... yes
> checking krb5/krb5.h usability... yes
> checking krb5/krb5.h presence... yes
> checking for krb5/krb5.h... yes
> checking for keyvalue in krb5_keyblock... no
> ...
> checking keyutils.h usability... yes
> checking keyutils.h presence... yes
> checking for keyutils.h... yes
> checking for krb5_init_context in -lkrb5... yes
> ...
> checking for WBCLIENT... yes
> checking for wbcSidsToUnixIds in -lwbclient... yes
> ...
> checking for keyutils.h... (cached) yes
> checking security/pam_appl.h usability... yes
> checking security/pam_appl.h presence... yes
> checking for security/pam_appl.h... yes
> checking for pam_start in -lpam... yes
> checking for security/pam_appl.h... (cached) yes
> checking for krb5_auth_con_getsendsubkey... yes
> checking for krb5_principal_get_realm... no
> checking for krb5_free_unparsed_name... yes
> checking for krb5_auth_con_setaddrs... yes
> checking for krb5_auth_con_set_req_cksumtype... yes
> ...
> aaptel$ make
> ....(ok)
>
> Without force_pam:
>
> root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,username=3Da=
dministrator,domain=3DNUC
> mount.cifs kernel mount options: ip=3D192.168.2.111,unc=3D\\adnuc.nuc.tes=
t\data,sec=3Dkrb5,user=3Dadministrator,domain=3DNUC
> mount error(2): No such file or directory
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel l=
og messages (dmesg)
>
> With force_pam:
>
> root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,username=3Da=
dministrator,domain=3DNUC,force_pam
> Authenticating as user: administrator
> Error in authenticating user with PAM: Authentication failure
> Attempt to authenticate user with PAM unsuccessful. Still, proceeding wit=
h mount.
>
> =3D> no further message but mount failed and no msg in dmesg, it didn't
>    reach the mount() call
>
> Not sure what is going on. Does the domain need to be passed to PAM?
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
-Shyam

--000000000000fa672805b00cd061
Content-Type: application/octet-stream; 
	name="0001-mount.cifs-Have-an-option-to-authenticate-against-PA.patch"
Content-Disposition: attachment; 
	filename="0001-mount.cifs-Have-an-option-to-authenticate-against-PA.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kfgoou7u0>
X-Attachment-Id: f_kfgoou7u0

RnJvbSA2N2ZhNTkyODAwZDc0YTBkYzg1NzE3YzVlZGViMDZiYzI2YzZmNDc2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDEzIEF1ZyAyMDIwIDA4OjUzOjA4IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0g
bW91bnQuY2lmczogSGF2ZSBhbiBvcHRpb24gdG8gYXV0aGVudGljYXRlIGFnYWluc3QgUEFNLgoK
QXV0aGVudGljYXRpb24gYWdhaW5zdCBQQU0gaGFzIHR3byBiZW5lZml0czoKLSBUaGUgUEFNIG1v
ZHVsZSAod2luYmluZCBvciBzc3NkKSB3aWxsIHBlcmZvcm0gdGhlIGhvdXNlLWtlZXBpbmcgb2YK
dGhlIGtyYjUgdGlja2V0cyBhbmQgbWFrZSBzdXJlIHRoZXkgYXJlbid0IGV4cGlyZWQuCi0gVGhl
IG1vdW50LmNpZnMgdXRpbGl0eSBuZWVkIG5vdCByZWx5IG9uIHNzaGQgb3Igc3UgdG8gYXV0aGVu
dGljYXRlCmFnYWluc3QgUEFNIGFuZCBhcnJhbmdlIHRoZSBrcmI1IFRHVC4gSW4gY2FzZSBvZiBz
c2ggd2l0aCBwcml2YXRlIGtleXMsCnNzaCBkb2Vzbid0IGludm9sdmUgUEFNLiBTbyBrcmI1IFRH
VCBtYXkgYmUgbWlzc2luZy4KClRoaXMgaW50cm9kdWNlcyBhIG5ldyBQQU0gYXBwbGljYXRpb24g
bmFtZWQgImNpZnMiLgpUaGUgdXNlciBtYXkgdXNlIHRoaXMgdG8gY3VzdG9taXplIHRoZSBQQU0g
c3RhY2sgZm9yIGp1c3QgdGhpcyBhcHBsaWNhdGlvbi4KT3RoZXJ3aXNlLCB0aGUgZGVmYXVsdCBQ
QU0gY29uZmlndXJhdGlvbiBpcyB1c2VkLgpBbHNvLCB0byBkaXNhYmxlIHRoaXMgZmVhdHVyZSBh
dCB0aGUgdGltZSBvZiBidWlsZCwgb25lIGNhbiBydW4KY29uZmlndXJlIHdpdGggLS1lbmFibGUt
a3JiNXBhbT1uby4KLS0tCiBNYWtlZmlsZS5hbSAgfCAgIDIgKy0KIGNvbmZpZ3VyZS5hYyB8ICAy
NyArKysrKysrKysKIG1vdW50LmNpZnMuYyB8IDE1OCArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKy0KIDMgZmlsZXMgY2hhbmdlZCwgMTgzIGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUuYW0gYi9NYWtlZmls
ZS5hbQppbmRleCBmZTljZDM0Li41MWM1YzQ3IDEwMDY0NAotLS0gYS9NYWtlZmlsZS5hbQorKysg
Yi9NYWtlZmlsZS5hbQpAQCAtNCw3ICs0LDcgQEAgQUNMT0NBTF9BTUZMQUdTID0gLUkgYWNsb2Nh
bAogcm9vdF9zYmluZGlyID0gJChST09UU0JJTkRJUikKIHJvb3Rfc2Jpbl9QUk9HUkFNUyA9IG1v
dW50LmNpZnMKIG1vdW50X2NpZnNfU09VUkNFUyA9IG1vdW50LmNpZnMuYyBtdGFiLmMgcmVzb2x2
ZV9ob3N0LmMgdXRpbC5jCi1tb3VudF9jaWZzX0xEQUREID0gJChMSUJDQVApICQoQ0FQTkdfTERB
REQpICQoUlRfTERBREQpCittb3VudF9jaWZzX0xEQUREID0gJChMSUJDQVApICQoTElCUEFNKSAk
KENBUE5HX0xEQUREKSAkKFJUX0xEQUREKQogaW5jbHVkZV9IRUFERVJTID0gY2lmc2lkbWFwLmgK
IHJzdF9tYW5fcGFnZXMgPSBtb3VudC5jaWZzLjgKIApkaWZmIC0tZ2l0IGEvY29uZmlndXJlLmFj
IGIvY29uZmlndXJlLmFjCmluZGV4IDIyZTc4ZWYuLmZhOGFmMGYgMTAwNjQ0Ci0tLSBhL2NvbmZp
Z3VyZS5hYworKysgYi9jb25maWd1cmUuYWMKQEAgLTU1LDYgKzU1LDExIEBAIEFDX0FSR19FTkFC
TEUocGFtLAogCWVuYWJsZV9wYW09JGVuYWJsZXZhbCwKIAllbmFibGVfcGFtPSJtYXliZSIpCiAK
K0FDX0FSR19FTkFCTEUoa3JiNXBhbSwKKyAgICBbQVNfSEVMUF9TVFJJTkcoWy0tZW5hYmxlLWty
YjVwYW1dLFtBZGQgUEFNIGF1dGhlbnRpY2F0aW9uIHN1cHBvcnQgd2hlbiB1c2luZyBzZWM9a3Ji
NSBAPDpAZGVmYXVsdD15ZXNAXSldLCwKKyAgICBlbmFibGVfa3JiNXBhbT0kZW5hYmxldmFsCisg
ICAgZW5hYmxlX2tyYjVwYW09InllcyIpCisKIEFDX0FSR19FTkFCTEUoc3lzdGVtZCwKIAlbQVNf
SEVMUF9TVFJJTkcoWy0tZW5hYmxlLXN5c3RlbWRdLFtFbmFibGUgc3lzdGVtZCBzcGVjaWZpYyBi
ZWhhdmlvciBmb3IgbW91bnQuY2lmcyBAPDpAZGVmYXVsdD15ZXNAOj5AXSldLAogCWVuYWJsZV9z
eXN0ZW1kPSRlbmFibGV2YWwsCkBAIC0yNDEsNiArMjQ2LDI3IEBAIGlmIHRlc3QgJGVuYWJsZV9w
YW0gIT0gIm5vIjsgdGhlbgogCQkJXSkKIGZpCiAKK2lmIHRlc3QgIngkZW5hYmxlX2tyYjVwYW0i
ID0gInhubyI7IHRoZW4KKwllbmFibGVfa3JiNXBhbT0ibm8iCitlbHNlCisJQUNfQ0hFQ0tfTElC
KFtwYW1dLCBbcGFtX3N0YXJ0XSwgZW5hYmxlX2tyYjVwYW09InllcyIsIGVuYWJsZV9rcmI1cGFt
PSJubyIsICkKKwlBQ19DSEVDS19IRUFERVJTKFtzZWN1cml0eS9wYW1fYXBwbC5oXSwgLAorCQkJ
IFsKKwkJCQlpZiB0ZXN0ICRlbmFibGVfa3JiNXBhbSA9ICJ5ZXMiOyB0aGVuCisJCQkJCUFDX01T
R19FUlJPUihbc2VjdXJpdHkvcGFtX2FwcGwuaCBub3QgZm91bmQsIGNvbnNpZGVyIGluc3RhbGxp
bmcga2V5dXRpbHMtbGlicy1kZXZlbC5dKQorCQkJCWVsc2UKKwkJCQkJQUNfTVNHX1dBUk4oW3Nl
Y3VyaXR5L3BhbV9hcHBsLmggbm90IGZvdW5kLCBjb25zaWRlciBpbnN0YWxsaW5nIHBhbS1kZXZl
bC4gRGlzYWJsaW5nIGNpZnNjcmVkcyBQQU0gbW9kdWxlLl0pCisJCQkJCWVuYWJsZV9rcmI1cGFt
PSJubyIKKwkJCQlmaQorCQkJIF0pCitmaQorCitpZiB0ZXN0ICIkZW5hYmxlX2tyYjVwYW0iID0g
InllcyI7IHRoZW4KKwlBQ19ERUZJTkUoW0hBVkVfS1JCNVBBTV0sWzFdLCBbRGVmaW5lIGlmIFBB
TSBhdXRoIGlzIGVuYWJsZWQgZm9yIGtyYjVdKQorCUxJQlBBTT0tbHBhbQorCUFDX1NVQlNUKExJ
QlBBTSkKK2ZpCisKICMgdWdseSwgYnV0IEknbSBub3Qgc3VyZSBob3cgdG8gY2hlY2sgZm9yIGZ1
bmN0aW9ucyBpbiBhIGxpYnJhcnkgdGhhdCdzIG5vdCBpbiAkTElCUwogY3Vfc2F2ZWRfbGlicz0k
TElCUwogTElCUz0iJExJQlMgJEtSQjVfTERBREQiCkBAIC0yODgsNiArMzE0LDcgQEAgQU1fQ09O
RElUSU9OQUwoQ09ORklHX0NJRlNBQ0wsIFt0ZXN0ICIkZW5hYmxlX2NpZnNhY2wiICE9ICJubyJd
KQogQU1fQ09ORElUSU9OQUwoQ09ORklHX1NNQklORk8sIFt0ZXN0ICIkZW5hYmxlX3NtYmluZm8i
ICE9ICJubyJdKQogQU1fQ09ORElUSU9OQUwoQ09ORklHX1BZVEhPTl9UT09MUywgW3Rlc3QgIiRl
bmFibGVfcHl0aG9udG9vbHMiICE9ICJubyJdKQogQU1fQ09ORElUSU9OQUwoQ09ORklHX1BBTSwg
W3Rlc3QgIiRlbmFibGVfcGFtIiAhPSAibm8iXSkKK0FNX0NPTkRJVElPTkFMKENPTkZJR19LUkI1
UEFNLCBbdGVzdCAiJGVuYWJsZV9rcmI1cGFtIiAhPSAibm8iXSkKIEFNX0NPTkRJVElPTkFMKENP
TkZJR19QTFVHSU4sIFt0ZXN0ICIkZW5hYmxlX2NpZnNpZG1hcCIgIT0gIm5vIiAtbyAiJGVuYWJs
ZV9jaWZzYWNsIiAhPSAibm8iXSkKIAogTElCQ0FQX05HX1BBVEgKZGlmZiAtLWdpdCBhL21vdW50
LmNpZnMuYyBiL21vdW50LmNpZnMuYwppbmRleCA0ZmViMzk3Li4yNzE5NjZiIDEwMDY0NAotLS0g
YS9tb3VudC5jaWZzLmMKKysrIGIvbW91bnQuY2lmcy5jCkBAIC00Niw2ICs0Niw5IEBACiAjaW5j
bHVkZSA8dGltZS5oPgogI2luY2x1ZGUgPHN5cy9tbWFuLmg+CiAjaW5jbHVkZSA8c3lzL3dhaXQu
aD4KKyNpZmRlZiBIQVZFX0tSQjVQQU0KKyNpbmNsdWRlIDxzZWN1cml0eS9wYW1fYXBwbC5oPgor
I2VuZGlmIC8qIEhBVkVfS1JCNVBBTSAqLwogI2lmZGVmIEhBVkVfU1lTX0ZTVUlEX0gKICNpbmNs
dWRlIDxzeXMvZnN1aWQuaD4KICNlbmRpZiAvKiBIQVZFX1NZU19GU1VJRF9IICovCkBAIC0xNjMs
NiArMTY2LDcgQEAKICNkZWZpbmUgT1BUX0JLVVBHSUQgICAgMzEKICNkZWZpbmUgT1BUX05PRkFJ
TCAgICAgMzIKICNkZWZpbmUgT1BUX1NOQVBTSE9UICAgMzMKKyNkZWZpbmUgT1BUX0ZPUkNFX1BB
TSAgMzQKIAogI2RlZmluZSBNTlRfVE1QX0ZJTEUgIi8ubXRhYi5jaWZzLlhYWFhYWCIKIApAQCAt
MTg5LDYgKzE5Myw4IEBAIHN0cnVjdCBwYXJzZWRfbW91bnRfaW5mbyB7CiAJdW5zaWduZWQgaW50
IHZlcmJvc2VmbGFnOjE7CiAJdW5zaWduZWQgaW50IG5vZmFpbDoxOwogCXVuc2lnbmVkIGludCBn
b3RfZG9tYWluOjE7CisJdW5zaWduZWQgaW50IGlzX2tyYjU6MTsKKwl1bnNpZ25lZCBpbnQgZm9y
Y2VfcGFtOjE7CiB9OwogCiBzdGF0aWMgY29uc3QgY2hhciAqdGhpc3Byb2dyYW07CkBAIC03MTMs
NiArNzE5LDggQEAgc3RhdGljIGludCBwYXJzZV9vcHRfdG9rZW4oY29uc3QgY2hhciAqdG9rZW4p
CiAJCXJldHVybiBPUFRfUEFTUzsKIAlpZiAoc3RyY21wKHRva2VuLCAic2VjIikgPT0gMCkKIAkJ
cmV0dXJuIE9QVF9TRUM7CisJaWYgKHN0cmNtcCh0b2tlbiwgImZvcmNlX3BhbSIpID09IDApCisJ
CXJldHVybiBPUFRfRk9SQ0VfUEFNOwogCWlmIChzdHJjbXAodG9rZW4sICJpcCIpID09IDAgfHwK
IAkJc3RyY21wKHRva2VuLCAiYWRkciIpID09IDApCiAJCXJldHVybiBPUFRfSVA7CkBAIC04OTEs
MTIgKzg5OSwxOSBAQCBwYXJzZV9vcHRpb25zKGNvbnN0IGNoYXIgKmRhdGEsIHN0cnVjdCBwYXJz
ZWRfbW91bnRfaW5mbyAqcGFyc2VkX2luZm8pCiAKIAkJY2FzZSBPUFRfU0VDOgogCQkJaWYgKHZh
bHVlKSB7Ci0JCQkJaWYgKCFzdHJuY21wKHZhbHVlLCAibm9uZSIsIDQpIHx8Ci0JCQkJICAgICFz
dHJuY21wKHZhbHVlLCAia3JiNSIsIDQpKQorCQkJCWlmICghc3RybmNtcCh2YWx1ZSwgIm5vbmUi
LCA0KSkKIAkJCQkJcGFyc2VkX2luZm8tPmdvdF9wYXNzd29yZCA9IDE7CisJCQkJaWYgKCFzdHJu
Y21wKHZhbHVlLCAia3JiNSIsIDQpKQorCQkJCQlwYXJzZWRfaW5mby0+aXNfa3JiNSA9IDE7CiAJ
CQl9CiAJCQlicmVhazsKIAorI2lmZGVmIEhBVkVfS1JCNVBBTQorCQljYXNlIE9QVF9GT1JDRV9Q
QU06CisJCQlwYXJzZWRfaW5mby0+Zm9yY2VfcGFtID0gMTsKKwkJCWdvdG8gbm9jb3B5OworI2Vu
ZGlmIC8qIEhBVkVfS1JCNVBBTSAqLworCQkJCiAJCWNhc2UgT1BUX0lQOgogCQkJaWYgKCF2YWx1
ZSB8fCAhKnZhbHVlKSB7CiAJCQkJZnByaW50ZihzdGRlcnIsCkBAIC0xODA5LDYgKzE4MjQsMTE5
IEBAIGdldF9wYXNzd29yZChjb25zdCBjaGFyICpwcm9tcHQsIGNoYXIgKmlucHV0LCBpbnQgY2Fw
YWNpdHkpCiAJcmV0dXJuIGlucHV0OwogfQogCisjaWZkZWYgSEFWRV9LUkI1UEFNCisjZGVmaW5l
IFBBTV9DSUZTX1NFUlZJQ0UgImNpZnMiCisKK3N0YXRpYyBpbnQKK3BhbV9hdXRoX2tyYjVfY29u
dihpbnQgbiwgY29uc3Qgc3RydWN0IHBhbV9tZXNzYWdlICoqbXNnLAorCQlzdHJ1Y3QgcGFtX3Jl
c3BvbnNlICoqcmVzcCwgdm9pZCAqZGF0YSkKK3sKKwlzdHJ1Y3QgcGFyc2VkX21vdW50X2luZm8g
KnBhcnNlZF9pbmZvOworCXN0cnVjdCBwYW1fcmVzcG9uc2UgKnJlcGx5OworCWludCBpOworCisJ
KnJlc3AgPSBOVUxMOworCisJcGFyc2VkX2luZm8gPSBkYXRhOworCWlmIChwYXJzZWRfaW5mbyA9
PSBOVUxMKQorCQlyZXR1cm4gUEFNX0NPTlZfRVJSOworCisJaWYgKG4gPD0gMCB8fCBuID4gUEFN
X01BWF9OVU1fTVNHKQorCQlyZXR1cm4gUEFNX0NPTlZfRVJSOworCisJaWYgKChyZXBseSA9IGNh
bGxvYyhuLCBzaXplb2YoKnJlcGx5KSkpID09IE5VTEwpCisJCXJldHVybiBQQU1fQ09OVl9FUlI7
CisKKwlmb3IgKGkgPSAwOyBpIDwgbjsgKytpKSB7CisJCXN3aXRjaCAobXNnW2ldLT5tc2dfc3R5
bGUpIHsKKwkJY2FzZSBQQU1fUFJPTVBUX0VDSE9fT0ZGOgorCQkJaWYgKChyZXBseVtpXS5yZXNw
ID0gKGNoYXIgKikgbWFsbG9jKE1PVU5UX1BBU1NXRF9TSVpFICsgMSkpID09IE5VTEwpCisJCQkJ
Z290byBmYWlsOworCisJCQlpZiAocGFyc2VkX2luZm8tPmdvdF9wYXNzd29yZCAmJiBwYXJzZWRf
aW5mby0+cGFzc3dvcmQgIT0gTlVMTCkgeworCQkJCXN0cm5jcHkocmVwbHlbaV0ucmVzcCwgcGFy
c2VkX2luZm8tPnBhc3N3b3JkLCBNT1VOVF9QQVNTV0RfU0laRSArIDEpOworCQkJfSBlbHNlIGlm
IChnZXRfcGFzc3dvcmQobXNnW2ldLT5tc2csIHJlcGx5W2ldLnJlc3AsIE1PVU5UX1BBU1NXRF9T
SVpFICsgMSkgPT0gTlVMTCkgeworCQkJCWdvdG8gZmFpbDsKKwkJCX0KKwkJCXJlcGx5W2ldLnJl
c3BbTU9VTlRfUEFTU1dEX1NJWkVdID0gJ1wwJzsKKworCQkJcmVwbHlbaV0ucmVzcF9yZXRjb2Rl
ID0gUEFNX1NVQ0NFU1M7CisJCQlicmVhazsKKwkJY2FzZSBQQU1fUFJPTVBUX0VDSE9fT046CisJ
CQlmcHJpbnRmKHN0ZGVyciwgIiVzOiAiLCBtc2dbaV0tPm1zZyk7CisJCQlpZiAoKHJlcGx5W2ld
LnJlc3AgPSAoY2hhciAqKSBtYWxsb2MoTU9VTlRfUEFTU1dEX1NJWkUgKyAxKSkgPT0gTlVMTCkK
KwkJCQlnb3RvIGZhaWw7CisKKwkJCWlmIChmZ2V0cyhyZXBseVtpXS5yZXNwLCBNT1VOVF9QQVNT
V0RfU0laRSArIDEsIHN0ZGluKSA9PSBOVUxMKQorCQkJCWdvdG8gZmFpbDsKKworCQkJcmVwbHlb
aV0ucmVzcFtNT1VOVF9QQVNTV0RfU0laRV0gPSAnXDAnOworCQkJbnVsbF90ZXJtaW5hdGVfZW5k
bChyZXBseVtpXS5yZXNwKTsKKworCQkJcmVwbHlbaV0ucmVzcF9yZXRjb2RlID0gUEFNX1NVQ0NF
U1M7CisJCQlicmVhazsKKwkJY2FzZSBQQU1fRVJST1JfTVNHOgorCQljYXNlIFBBTV9URVhUX0lO
Rk86CisJCQlmcHJpbnRmKHN0ZGVyciwgIiVzOiAiLCBtc2dbaV0tPm1zZyk7CisKKwkJCXJlcGx5
W2ldLnJlc3BfcmV0Y29kZSA9IFBBTV9TVUNDRVNTOworCQkJYnJlYWs7CisJCWRlZmF1bHQ6CisJ
CQlnb3RvIGZhaWw7CisJCX0KKwl9CisJKnJlc3AgPSByZXBseTsKKwlyZXR1cm4gUEFNX1NVQ0NF
U1M7CisKK2ZhaWw6CisJZm9yKGkgPSAwOyBpIDwgbjsgaSsrKSB7CisJCWZyZWUocmVwbHlbaV0u
cmVzcCk7CisJfQorCWZyZWUocmVwbHkpOworCXJldHVybiBQQU1fQ09OVl9FUlI7Cit9CisKKwlz
dGF0aWMgaW50CitwYW1fYXV0aF9rcmI1X3VzZXIoc3RydWN0IHBhcnNlZF9tb3VudF9pbmZvICpw
YXJzZWRfaW5mbykKK3sKKwlpbnQgcmMgPSAtMTsKKwlwYW1faGFuZGxlX3QgKnBhbWggPSBOVUxM
OworCXN0cnVjdCBwYW1fY29udiBwYW1fY29udiA9IHsKKwkJLmNvbnYgPSBwYW1fYXV0aF9rcmI1
X2NvbnYsCisJCS5hcHBkYXRhX3B0ciA9ICh2b2lkICopIHBhcnNlZF9pbmZvCisJfTsKKworCWZw
cmludGYoc3Rkb3V0LCAiQXV0aGVudGljYXRpbmcgYXMgdXNlcjogJXNcbiIsIHBhcnNlZF9pbmZv
LT51c2VybmFtZSk7CisJcmMgPSBwYW1fc3RhcnQoUEFNX0NJRlNfU0VSVklDRSwgcGFyc2VkX2lu
Zm8tPnVzZXJuYW1lLCAmcGFtX2NvbnYsICZwYW1oKTsKKwlpZiAocmMgIT0gUEFNX1NVQ0NFU1Mp
IHsKKwkJZnByaW50ZihzdGRlcnIsICJFcnJvciBzdGFydGluZyBQQU0gdHJhbnNhY3Rpb246ICVz
XG4iLCBwYW1fc3RyZXJyb3IocGFtaCwgcmMpKTsKKwkJcmV0dXJuIHJjOworCX0KKworCXJjID0g
cGFtX2F1dGhlbnRpY2F0ZShwYW1oLCAwKTsKKwlpZiAocmMgIT0gUEFNX1NVQ0NFU1MpIHsKKwkJ
ZnByaW50ZihzdGRlcnIsICJFcnJvciBpbiBhdXRoZW50aWNhdGluZyB1c2VyIHdpdGggUEFNOiAl
c1xuIiwgcGFtX3N0cmVycm9yKHBhbWgsIHJjKSk7CisJCWdvdG8gZW5kOworCX0KKworCXJjID0g
cGFtX2FjY3RfbWdtdChwYW1oLCAwKTsKKwlpZiAocmMgIT0gUEFNX1NVQ0NFU1MpIHsKKwkJZnBy
aW50ZihzdGRlcnIsICJVc2VyIGFjY291bnQgaW52YWxpZDogJXNcbiIsIHBhbV9zdHJlcnJvcihw
YW1oLCByYykpOworCQlnb3RvIGVuZDsKKwl9CisKKwlyYyA9IHBhbV9zZXRjcmVkKHBhbWgsIFBB
TV9FU1RBQkxJU0hfQ1JFRCk7CisJaWYgKHJjICE9IFBBTV9TVUNDRVNTKSB7CisJCWZwcmludGYo
c3RkZXJyLCAiRXJyb3IgaW4gc2V0dGluZyBQQU0gY3JlZGVudGlhbHM6ICVzXG4iLCBwYW1fc3Ry
ZXJyb3IocGFtaCwgcmMpKTsKKwkJZ290byBlbmQ7CisJfQorCitlbmQ6CisJcGFtX2VuZChwYW1o
LCByYyk7CisJcmV0dXJuIHJjOworfQorI2VuZGlmIC8qIEhBVkVfS1JCNVBBTSAqLworCiBzdGF0
aWMgaW50CiBhc3NlbWJsZV9tb3VudGluZm8oc3RydWN0IHBhcnNlZF9tb3VudF9pbmZvICpwYXJz
ZWRfaW5mbywKIAkJICAgY29uc3QgY2hhciAqdGhpc3Byb2dyYW0sIGNvbnN0IGNoYXIgKm1vdW50
cG9pbnQsCkBAIC0xODkxLDcgKzIwMTksMzEgQEAgYXNzZW1ibGVfbW91bnRpbmZvKHN0cnVjdCBw
YXJzZWRfbW91bnRfaW5mbyAqcGFyc2VkX2luZm8sCiAJCXBhcnNlZF9pbmZvLT5nb3RfdXNlciA9
IDE7CiAJfQogCi0JaWYgKCFwYXJzZWRfaW5mby0+Z290X3Bhc3N3b3JkKSB7CisjaWZkZWYgSEFW
RV9LUkI1UEFNCisJaWYgKHBhcnNlZF9pbmZvLT5pc19rcmI1ICYmIHBhcnNlZF9pbmZvLT5mb3Jj
ZV9wYW0pIHsKKwkJLyoKKwkJICogQXR0ZW1wdCB0byBhdXRoZW50aWNhdGUgd2l0aCBQQU0uCisJ
CSAqIElmIFBBTSBpcyBjb25maWd1cmVkIHByb3Blcmx5LCBsZXQgaXQgZ2V0IHRoZSBrcmI1IHRp
Y2tldHMgbmVjZXNzYXJ5IGZvciB0aGUgbW91bnQuCisJCSAqIEV2ZW4gaWYgdGhpcyBmYWlscywg
aXQgY291bGQgYmUgdGhlIGNhc2Ugb2YgUEFNIG5vdCBjb25maWd1cmVkIHByb3Blcmx5LgorCQkg
KiBJbiB0aGF0IGNhc2UsIHJldGFpbiB0aGUgY3VycmVudCBiZWhhdmlvci4gU28gdGhpcyBpcyBq
dXN0IGEgYmVzdC1lZmZvcnQuCisJCSAqLworCQlyYyA9IHBhbV9hdXRoX2tyYjVfdXNlcihwYXJz
ZWRfaW5mbyk7CisJCWlmIChyYykgeworCQkJZnByaW50ZihzdGRlcnIsICJBdHRlbXB0IHRvIGF1
dGhlbnRpY2F0ZSB1c2VyIHdpdGggIiBcCisJCQkJCSJQQU0gdW5zdWNjZXNzZnVsLiBTdGlsbCwg
cHJvY2VlZGluZyB3aXRoIG1vdW50LlxuIik7CisJCQkvKgorCQkJICogRXZlbiBpZiB0aGlzIGlz
IGEgZmFpbHVyZSwgZmFsbHRocm91Z2ggYW5kIHNlZSBpZiBjaWZzLmtvIGNhbiBzdGlsbAorCQkJ
ICogYXV0aGVudGljYXRlIHRoZSB1c2VyLgorCQkJICovCisJCQlyYyA9IDA7CisJCX0KKworCQlw
YXJzZWRfaW5mby0+Z290X3Bhc3N3b3JkID0gMTsKKwl9CisjZW5kaWYgLyogSEFWRV9LUkI1UEFN
ICovCisKKwkvKiBJZiBzZWM9a3JiNSwgdGhlbiBwYXNzd29yZCBpcyBjb2xsZWN0ZWQgYnkgb3Ro
ZXIgbWVhbnMgKi8KKwlpZiAoIXBhcnNlZF9pbmZvLT5pc19rcmI1ICYmICFwYXJzZWRfaW5mby0+
Z290X3Bhc3N3b3JkKSB7CiAJCWNoYXIgdG1wX3Bhc3NbTU9VTlRfUEFTU1dEX1NJWkUgKyAxXTsK
IAkJY2hhciAqcHJvbXB0ID0gTlVMTDsKIAotLSAKMi4yNS4xCgo=
--000000000000fa672805b00cd061--
