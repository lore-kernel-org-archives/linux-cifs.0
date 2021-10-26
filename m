Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90469C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Oct 2021 15:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C77460E74
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Oct 2021 15:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhJZPIO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Oct 2021 11:08:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231461AbhJZPIO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Oct 2021 11:08:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635260749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C57aUYPw2W0iySBHYc6KrbHvL+oOXQ6q2utMK7+bN8o=;
        b=cpoMB9G/uBAfJzKRhdY2BpnXCoL/yxChLK0KZKzmnXmk+oHPnacomidbxMN2IZvw9HyL+h
        0U3ugW+r9gKiV1JNFquydHeUPEp8y0vHvvzVQrEUSgrLZvdJzVwljPg7Lwmsb/ujUa2yO1
        4IEaqrrqDtmaTLZrkpFt1knJWumwmr4=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-jYaj9Y_ZPOm9MEIKXzZTwQ-1; Tue, 26 Oct 2021 11:05:48 -0400
X-MC-Unique: jYaj9Y_ZPOm9MEIKXzZTwQ-1
Received: by mail-pl1-f200.google.com with SMTP id y13-20020a1709029b8d00b0013dc7c668e2so5078288plp.16
        for <linux-cifs@vger.kernel.org>; Tue, 26 Oct 2021 08:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C57aUYPw2W0iySBHYc6KrbHvL+oOXQ6q2utMK7+bN8o=;
        b=K1RDQQuwnULPk+V6zn7O1h7b/HXX50ac2+kd/WB5QITZlLnGhzyiiLA/oVSCtnFKgQ
         1cN4LJUeDVS8qPmun4+yctrAlzBbGNzHHHK6xTZOoLf5GWrKUpki9kBoGNhbxRWIuh0U
         EWESb51yqiDk4cRvdhwFU4F8bppmI7dKTum6Lw7KGXJj9+aXEXXozPqsNCTgjqswZcNY
         7ZOuLggGWy0Fcakmly7Ksir4kHJ6lZ44sQ5fZ+VEkEOMCJ0kEoVC9OlrxnpcIJihTGsD
         tsaF6LMiGyT4QTiEFSozpNdByEzwusUb5xpfsVJLj+W8XhAh62vm5m2qdB4C2k+QM4Ez
         2+Cw==
X-Gm-Message-State: AOAM531WRc16aQaLeREHKGQ3uDyaFs5bkM5D7paFqqil52/QDFXXIpHJ
        ihvfDLLgEHVJs+xHuMF5xP61zwGOqOXwoJdZjPkytRP2raNzXT9/cVDUFdQDLwGLrrgZo15m1WU
        wefHr/OTB35YlViNArR+ZZquKbfbFmX0Cda3phw==
X-Received: by 2002:a17:902:7c94:b0:13b:8d10:cc4f with SMTP id y20-20020a1709027c9400b0013b8d10cc4fmr22861521pll.54.1635260746688;
        Tue, 26 Oct 2021 08:05:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxgz2On6psk/Fvp5jn5xI9FzMu/d/b8pTClTscPeM+3ehv7k8ADquOcwmKxzDcLbok9rNg+Rn9bLwMgq9YfuI=
X-Received: by 2002:a17:902:7c94:b0:13b:8d10:cc4f with SMTP id
 y20-20020a1709027c9400b0013b8d10cc4fmr22861446pll.54.1635260746095; Tue, 26
 Oct 2021 08:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <2e241ceaece6485289b1cddb84ec77ca@atos.net> <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
 <CAH2r5mt9r6nWop_ekbe1CsinztUiGhP2-bxWFkRqHXOP=MXcVQ@mail.gmail.com>
 <c49c0a18c228e6aa43dbb2cbab7e0a266d1c0371.camel@redhat.com>
 <CANT5p=p_G+jMMVMkYDL=fXZi_OO7eY2Foz8VkyQuT+1h5Xgifw@mail.gmail.com>
 <facbd0542074a5b8ef2f6f3d5649010503d8d84d.camel@redhat.com>
 <CALe0_75RLR=gcwitnxvACh1mt3jnOGHFx7baO0YRhwEfKwFoGg@mail.gmail.com>
 <CAKywueTUqhathrJmPc7eyNojv1F=199mNcFCENzoQjntK+CAzw@mail.gmail.com>
 <10598d01fe09433ea57a38142b7fb854@atos.net> <CALe0_74J8h5F4k2aH2Vh5RvtEtfBZ0nrvE614uM87AuVnWZ+gw@mail.gmail.com>
 <CAKywueSC6azd68E7MHQKtebGL7B=v4Z4O+5tGU3vf3WJbSZgnw@mail.gmail.com>
 <CAGvGhF5rVU1WzLk=aE36n47P357UBOPbsjXE=B8J+feO3bVSSQ@mail.gmail.com>
 <CALe0_77Bv_+v9cdNd_AL5DgA2+EaXMtF_0+rUw6y46fhHq0M4A@mail.gmail.com> <CAKywueQU8P-XQsiy4x6B=0YjuwUmTzPVg--SY0sWzGuq6Oy_-w@mail.gmail.com>
In-Reply-To: <CAKywueQU8P-XQsiy4x6B=0YjuwUmTzPVg--SY0sWzGuq6Oy_-w@mail.gmail.com>
From:   Jacob Shivers <jshivers@redhat.com>
Date:   Tue, 26 Oct 2021 11:05:09 -0400
Message-ID: <CALe0_749xeFb6+2XJGuM8=brq_rbqB5LheKbZj17a9bNyn00RQ@mail.gmail.com>
Subject: Re: [gssproxy] cifs-utils, Linux cifs kernel client and gssproxy
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Leif Sahlberg <lsahlber@redhat.com>,
        "Weiser, Michael" <michael.weiser@atos.net>,
        Simo Sorce <simo@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        The GSS-Proxy developers and users mailing list 
        <gss-proxy@lists.fedorahosted.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Pavel,

Brief addition to man 8 cifs.upcall

Author: Jacob Shivers <jshivers@redhat.com>
Date:   Tue Oct 26 10:57:41 2021 -0400

    man-pages: Update cifs.upcall to mention GSS_USE_PROXY

    Add ENVIRONMENT VARIABLES section with the usage of gssproxy as a crede=
ntial
    retrieval method.

    Signed-off-by: Jacob Shivers <jshivers@redhat.com>

diff --git a/cifs.upcall.rst.in b/cifs.upcall.rst.in
index 08ce324..09d0503 100644
--- a/cifs.upcall.rst.in
+++ b/cifs.upcall.rst.in
@@ -91,6 +91,15 @@ OPTIONS
 --version|-v
   Print version number and exit.

+*********************
+ENVIRONMENT VARIABLES
+*********************
+
+GSS_USE_PROXY=3D"yes"
+  Enable usage of gssproxy for credential retrieval. This includes keytab
+  based client initiation as well as (Resource Based) Constrained Delegati=
on.
+  See gssproxy-mech(8).
+
 ************************
 CONFIGURATION FOR KEYCTL
 ************************

On Mon, Oct 25, 2021 at 5:32 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Ronnie,
> Thanks for the patch to silent compile warning. Let me try it.
>
> Jacob,
> Sounds good. I haven't updated the cifs.upcall man page yet. Feel free
> to provide the patch.
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D1=82, 22 =D0=BE=D0=BA=D1=82. 2021 =D0=B3. =D0=B2 19:16, Jacob Shi=
vers <jshivers@redhat.com>:
> >
> > Everything looks good.
> >
> > I sent a PR for gssproxy adding a drop file for cifs-client. I think
> > the only thing outstanding will be an update to man 8 cifs.upcall that
> > mentions the requirement to add GSS_USE_PROXY in
> > /etc/request-key.d/cifs.spnego. I don't have a particular stance on a
> > short-hand flag for GSS_USE_PROXY=3Dyes as there is not already an
> > existing configuration file for client side cifs.ko. Should one ever
> > be created then it would be pertinent to include it there.
> >
> > If you don't have anything written for man 8 cifs.upcall, I can take
> > care of that.
> >
> > Thanks again.
> >
> > On Thu, Oct 21, 2021 at 7:46 PM Leif Sahlberg <lsahlber@redhat.com> wro=
te:
> > >
> > >
> > >
> > >
> > > On Fri, Oct 22, 2021 at 9:23 AM Pavel Shilovsky <piastryyy@gmail.com>=
 wrote:
> > >>
> > >> Hello Michael, Jacob,
> > >>
> > >> The cifs.upcall patch is applied with some minor adjustments (code
> > >> style and a patch description) on top of the next branch on github:
> > >>
> > >> https://github.com/piastry/cifs-utils/commit/3d681bb5c140376ccc19e48=
711231aeef1e87aa9
> > >>
> > >> Please let me know if it looks good and/or if you have other suggest=
ions.
> > >>
> > >> The only concern that I have is the compile warning below. Would
> > >> appreciate it if you provide a fix for that.
> > >>
> > >> gcc -DHAVE_CONFIG_H -I.    -Wall -Wextra -D_FORTIFY_SOURCE=3D2 -fpie
> > >> -pie -Wl,-z,relro,-z,now -g -O2 -MT cifs.upcall.o -MD -MP -MF
> > >> .deps/cifs.upcall.Tpo -c -o cifs.upcall.o cifs.upcall.c
> > >> cifs.upcall.c: In function =E2=80=98cifs_gss_get_req=E2=80=99:
> > >> cifs.upcall.c:808:4: warning: passing argument 5 of
> > >> =E2=80=98gss_init_sec_context=E2=80=99 discards =E2=80=98const=E2=80=
=99 qualifier from pointer target
> > >> type [-Wdiscarded-qualifiers]
> > >>     gss_mech_krb5, /* force krb5 */
> > >>     ^
> > >> In file included from /usr/include/gssapi/gssapi_generic.h:31:0,
> > >>                  from cifs.upcall.c:40:
> > >> /usr/include/gssapi/gssapi.h:437:1: note: expected =E2=80=98gss_OID =
{aka
> > >> struct gss_OID_desc_struct *}=E2=80=99 but argument is of type =E2=
=80=98const
> > >> gss_OID_desc * const {aka const struct gss_OID_desc_struct * const}=
=E2=80=99
> > >>  gss_init_sec_context(
> > >>  ^
> > >
> > >
> > > I do not get that warning on my system, but this patch should fix it?
> > >
> > > Author: Ronnie Sahlberg <lsahlber@redhat.com>
> > > Date:   Fri Oct 22 09:41:24 2021 +1000
> > >
> > >     cifs.upcall.c: fix compiler warning
> > >
> > >     Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > >
> > > diff --git a/cifs.upcall.c b/cifs.upcall.c
> > > index e9c7f5f..5e7c0a1 100644
> > > --- a/cifs.upcall.c
> > > +++ b/cifs.upcall.c
> > > @@ -69,6 +69,10 @@
> > >  #include <cap-ng.h>
> > >  #endif
> > >
> > > +#ifndef discard_const
> > > +#define discard_const(ptr) ((void *)((intptr_t)(ptr)))
> > > +#endif
> > > +
> > >  static krb5_context    context;
> > >  static const char      *prog =3D "cifs.upcall";
> > >
> > > @@ -805,7 +809,7 @@ cifs_gss_get_req(const char *host, DATA_BLOB *mec=
htoken, DATA_BLOB *sess_key)
> > >                         GSS_C_NO_CREDENTIAL, /* claimant_cred_handle =
*/
> > >                         &ctx,
> > >                         target_name,
> > > -                       gss_mech_krb5, /* force krb5 */
> > > +                       discard_const(gss_mech_krb5), /* force krb5 *=
/
> > >                         0, /* flags */
> > >                         0, /* time_req */
> > >                         GSS_C_NO_CHANNEL_BINDINGS, /* input_chan_bind=
ings */
> > >
> > >
> > >
> > >>
> > >> mv -f .deps/cifs.upcall.Tpo .deps/cifs.upcall.Po
> > >> gcc -Wall -Wextra -D_FORTIFY_SOURCE=3D2 -fpie -pie -Wl,-z,relro,-z,n=
ow
> > >> -g -O2   -o cifs.upcall cifs.upcall.o data_blob.o asn1.o spnego.o
> > >> -ltalloc -lkeyutils -lgssapi_krb5 -lkrb5
> > >>
> > >>
> > >> --
> > >> Best regards,
> > >> Pavel Shilovsky
> > >>
> > >> =D1=87=D1=82, 30 =D1=81=D0=B5=D0=BD=D1=82. 2021 =D0=B3. =D0=B2 16:18=
, Jacob Shivers <jshivers@redhat.com>:
> > >>
> > >> >
> > >> > Hello Pavel/Michael,
> > >> >
> > >> > The only other addition would be to modify
> > >> > /etc/gssproxy/99-nfs-client.conf to also use the 'program' directi=
ve,
> > >> > i.e. 'program =3D /usr/sbin/rpc.gssd' so that both rpc.gssd and
> > >> > cifs.upcall can make use of the default gssproxy socket
> > >> > '/var/lib/gssproxy/default.sock'
> > >> >
> > >> > If the 'program' directive is not included in the respective drop
> > >> > files, then gssproxy can not differentiate which service is to be =
used
> > >> > and will fail to start.
> > >> >
> > >> > In total, a gssproxy drop file for cifs.upcall, modifying the gssp=
roxy
> > >> > drop file for rpc.gssd, and an inclusion of a parameter that sets =
an
> > >> > environmental variable for cifs.upcall to use gssproxy should be a=
ll
> > >> > that is needed. I had not submitted a pull request for gssproxy ye=
t as
> > >> > the extended cifs.upcall functionality had not received any furthe=
r
> > >> > feedback. I can submit something if you are ready to include the p=
atch
> > >> > to cifs.upcall
> > >> >
> > >> > Thanks,
> > >> >
> > >> > Jacob Shivers
> > >> >
> > >> > On Mon, Sep 27, 2021 at 3:20 AM Weiser, Michael <michael.weiser@at=
os.net> wrote:
> > >> > >
> > >> > > Hello Pavel,
> > >> > >
> > >> > > > Do we have any more-up-to-date version of the cifs-utils patch=
 other
> > >> > > > than the one attached to the email thread? I would like to mer=
ge the
> > >> > > > patch into the "next" branch so it makes the next release of
> > >> > > > cifs-utils.
> > >> > >
> > >> > > I'm also not aware of a newer version. As one of the initiators =
of the discussion, who's highly interested in seeing this merged, I'm stand=
ing by to help out with background context, testing or improving the code. =
(The patch was meant as a PoC which is why I skipped some reindenting and n=
iceties to keep its approach and impact easy to gauge.)
> > >> > >
> > >> > > > Also there is a potential helper script mentioned above that i=
s needed
> > >> > > > to set up gssproxy properly?
> > >> > >
> > >> > > I'm not aware of a helper script. gssproxy just needs to be told=
 about cifs-utils and how it should be treated using a single config drop f=
ile. Also in the meantime, Jacob and I have streamlined the configuration s=
o a separate UNIX domain socket and tweaking its permissions using a system=
d service drop-in file is no longer needed. Instead, gssproxy can distingui=
sh multiple clients on the same socket using the calling binary derived fro=
m getsockopt/SO_PEERCRED.
> > >> > >
> > >> > > Finally, environment variable GSS_USE_PROXY needs to be set for =
cifs.upcall to enable the gssproxy proxy mech. (Instead of using the env co=
mmand, cifs.upcall could have a command line option similar to rpc.gssd[1] =
which ends up doing the same thing.)
> > >> > >
> > >> > > Here's the config summary:
> > >> > >
> > >> > > # cat /etc/request-key.d/cifs.spnego.conf
> > >> > > create  cifs.spnego    * *  /usr/bin/env GSS_USE_PROXY=3Dyes /us=
r/sbin/cifs.upcall %k
> > >> > >
> > >> > > # cat /etc/gssproxy/99-cifs.conf
> > >> > > [service/cifs]
> > >> > >   mechs =3D krb5
> > >> > > # not needed when program option is used
> > >> > > #  socket =3D /var/lib/gssproxy/cifs.sock
> > >> > >   program =3D /usr/sbin/cifs.upcall
> > >> > >   cred_store =3D keytab:/etc/krb5.keytab
> > >> > >   cred_store =3D ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U
> > >> > >   cred_store =3D client_keytab:/var/lib/gssproxy/clients/%U.keyt=
ab
> > >> > >   cred_usage =3D initiate
> > >> > > # allow process with any euid to use the service and receive imp=
ersonated
> > >> > > # tickets for services
> > >> > >   allow_any_uid =3D yes
> > >> > > # allow euid access to keytab
> > >> > >   trusted =3D yes
> > >> > > # allow impersonation
> > >> > >   impersonate =3D yes
> > >> > > # allow process with euid 0 to use the keytab
> > >> > >   euid =3D 0
> > >> > >
> > >> > > The actual mount can be done using system credentials from the k=
eytab. Small proof session showcasing that gssproxy is involved and working=
:
> > >> > >
> > >> > > # systemctl stop gssproxy
> > >> > > # mount -o sec=3Dkrb5,multiuser,user=3DFEDORA33\$ //dc/share /mn=
t
> > >> > > # su - adsuser -c "touch /mnt/test"
> > >> > > touch: cannot touch '/mnt/test': Permission denied
> > >> > > # systemctl start gssproxy
> > >> > > # su - adsuser -c "touch /mnt/test"
> > >> > > #
> > >> > >
> > >> > > [1] http://git.linux-nfs.org/?p=3Dsteved/nfs-utils.git;a=3Dblob;=
f=3Dutils/gssd/gssd.c;h=3D833d8e0110a9737df8ef6ddeb439ba1a37ee9931;hb=3DHEA=
D#l1128
> > >> > >
> > >> > > Thanks,
> > >> > > Michael
> > >> > >
> > >> > > ________________________________________
> > >> > > From: Pavel Shilovsky <piastryyy@gmail.com>
> > >> > > Sent: 24 September 2021 19:09:47
> > >> > > To: Jacob Shivers
> > >> > > Cc: Simo Sorce; Shyam Prasad N; Steve French; The GSS-Proxy deve=
lopers and users mailing list; linux-cifs@vger.kernel.org; samba-technical@=
lists.samba.org
> > >> > > Subject: Re: [gssproxy] cifs-utils, Linux cifs kernel client and=
 gssproxy
> > >> > >
> > >> > > Caution! External email. Do not open attachments or click links,=
 unless this email comes from a known sender and you know the content is sa=
fe.
> > >> > >
> > >> > > Catching up on the email thread. For some reason I missed it ori=
ginally somehow.
> > >> > >
> > >> > > Do we have any more-up-to-date version of the cifs-utils patch o=
ther
> > >> > > than the one attached to the email thread? I would like to merge=
 the
> > >> > > patch into the "next" branch so it makes the next release of
> > >> > > cifs-utils.
> > >> > >
> > >> > > Also there is a potential helper script mentioned above that is =
needed
> > >> > > to set up gssproxy properly?
> > >> > >
> > >> > > --
> > >> > > Best regards,
> > >> > > Pavel Shilovsky
> > >> > >
> > >> > > =D0=B2=D1=82, 23 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 0=
9:43, Jacob Shivers <jshivers@redhat.com>:
> > >> > > >
> > >> > > > I have tested the patches for cifs.upcall and can say that wit=
h some
> > >> > > > additional modifications to gssproxy the end setup brings a de=
gree of
> > >> > > > feature parity to SMB clients that had been previously exclusi=
ve to
> > >> > > > NFS clients.
> > >> > > > Deployment does require some additional configuration, includi=
ng the
> > >> > > > creation of a drop-in file for gssproxy under /etc/gssproxy an=
d for
> > >> > > > the gssproxy service managed by systemd
> > >> > > >
> > >> > > >
> > >> > > > ### KDC configuration
> > >> > > >
> > >> > > >  *** delegation ***
> > >> > > >
> > >> > > > Constrained Delegation (CD) for the SMB host to the Kerberized=
 SMB server
> > >> > > > Resource Based Constrained Delegation (RBCD) on the Kerberized=
 SMB
> > >> > > > server to determine which SMB clients can delegate
> > >> > > >
> > >> > > >
> > >> > > > ### SMB client configuration
> > >> > > >
> > >> > > >  *** sssd ***
> > >> > > >
> > >> > > >  Configuration file modification.
> > >> > > >
> > >> > > > Disable using fully qualified domain names as impersonation do=
es not
> > >> > > > correctly handle fully qualified names at time of ticket acqui=
sition.
> > >> > > >
> > >> > > > use_fully_qualified_names =3D False
> > >> > > >
> > >> > > >  *** gssproxy ***
> > >> > > >
> > >> > > >  Drop file creation
> > >> > > >
> > >> > > > Add a drop file for gssproxy to create the necessary socket an=
d
> > >> > > > corresponding settings.
> > >> > > >
> > >> > > > # cat /etc/gssproxy/99-cifs-client.conf with contents
> > >> > > > [service/cifs]
> > >> > > > mechs =3D krb5
> > >> > > > socket =3D /var/lib/gssproxy/cifs.sock
> > >> > > > cred_store =3D keytab:/etc/krb5.keytab
> > >> > > > cred_usage =3D initiate
> > >> > > > euid =3D 0
> > >> > > > impersonate =3D yes
> > >> > > > allow_any_uid =3D yes
> > >> > > >
> > >> > > >  Service drop-in file.
> > >> > > >
> > >> > > > Create a drop-in file to limit socket access for an unattended=
 user, if desired.
> > >> > > >
> > >> > > > # cat /etc/systemd/system/gssproxy.service.d/90-cifs.conf
> > >> > > > [Service]
> > >> > > > # Limit cifs.sock socket file accessiblility to just the unatt=
ended user.
> > >> > > > ExecStartPost=3D/bin/bash -c 'chmod 660 /var/lib/gssproxy/cifs=
.sock &&
> > >> > > > setfacl -m u:chang:rw /var/lib/gssproxy/cifs.sock'
> > >> > > >
> > >> > > >
> > >> > > >  *** cifs.upcall ***
> > >> > > >
> > >> > > >  cifs.spnego.conf modification
> > >> > > >
> > >> > > > Allow for gssprxy to be used and specify socket file
> > >> > > >
> > >> > > > # cat /etc/request-key.d/cifs.spnego.conf
> > >> > > > create  cifs.spnego    * *  /usr/bin/env GSS_USE_PROXY=3Dyes
> > >> > > > GSSPROXY_SOCKET=3D/var/lib/gssproxy/cifs.sock /usr/sbin/cifs.u=
pcall %k
> > >> > > >
> > >> > > >    include the '-t' flag to allow for accessing a Kerberized D=
FS
> > >> > > > namespace using a domain based mount, i.e //example.net/dfs/sh=
are
> > >> > > >
> > >> > > > create  cifs.spnego    * *  /usr/bin/env GSS_USE_PROXY=3Dyes
> > >> > > > GSSPROXY_SOCKET=3D/var/lib/gssproxy/cifs.sock /usr/sbin/cifs.u=
pcall -t
> > >> > > > %k
> > >> > > >
> > >> > > >
> > >> > > > The above does allow for unattended users to access a Kerberiz=
ed SMB
> > >> > > > share while limiting access to only a specific user:
> > >> > > >
> > >> > > > # mount //win2k16-dfs1.example.net/greendale/ /mnt -o
> > >> > > > sec=3Dkrb5,username=3D'TEST-BOX$@EXAMPLE.NET',multiuser
> > >> > > >
> > >> > > > # su - jeff
> > >> > > > Last login: Fri Feb  5 12:14:42 EST 2021 on pts/0
> > >> > > > [jeff@test-box ~]$ ll /mnt
> > >> > > > ls: cannot access '/mnt': Permission denied
> > >> > > > [jeff@test-box ~]$ logout
> > >> > > >
> > >> > > > # su - chang
> > >> > > > Last login: Fri Feb  5 12:14:46 EST 2021 on pts/0
> > >> > > > [chang@test-box ~]$ klist
> > >> > > > klist: No credentials cache found (filename: /tmp/krb5cc_60200=
1123)
> > >> > > > [chang@test-box ~]$ ls -l /mnt
> > >> > > > total 143
> > >> > > >
> > >> > > > drwxr-xr-x. 2 chang domain users      0 Oct  4  2018  DfsrPriv=
ate
> > >> > > > -rwxr-xr-x. 1 chang domain users      0 Sep 22 10:07  test_fil=
e
> > >> > > > -rwxr-xr-x. 1 chang domain users      0 Dec 14 15:22  whoami
> > >> > > > drwxr-xr-x. 2 chang domain users      0 Dec  7 12:54  winhome
> > >> > > >
> > >> > > > [chang@test-box ~]$ klist
> > >> > > > klist: No credentials cache found (filename: /tmp/krb5cc_60200=
1123)
> > >> > > >
> > >> > > >
> > >> > > > Feb 23 12:22:44.857956 test-box.example.net su[1672]: (to jeff=
) root on pts/1
> > >> > > > Feb 23 12:22:44.866263 test-box.example.net su[1672]:
> > >> > > > pam_systemd(su-l:session): Cannot create session: Already runn=
ing in a
> > >> > > > session or user slice
> > >> > > > Feb 23 12:22:44.867158 test-box.example.net su[1672]:
> > >> > > > pam_unix(su-l:session): session opened for user jeff by root(u=
id=3D0)
> > >> > > > Feb 23 12:22:46.253310 test-box.example.net cifs.upcall[1700]:=
 key
> > >> > > > description: cifs.spnego;0;0;39010000;ver=3D0x2;host=3Dwin2k16=
-dfs1.example.net;ip4=3D192.168.124.132;sec=3Dkrb5;uid=3D0x23e1cedc;creduid=
=3D0x23e1cedc;pid=3D0x6a3
> > >> > > > Feb 23 12:22:46.253335 test-box.example.net cifs.upcall[1700]:=
 ver=3D2
> > >> > > > Feb 23 12:22:46.253338 test-box.example.net cifs.upcall[1700]:
> > >> > > > host=3Dwin2k16-dfs1.example.net
> > >> > > > Feb 23 12:22:46.253342 test-box.example.net cifs.upcall[1700]:
> > >> > > > ip=3D192.168.124.132
> > >> > > > Feb 23 12:22:46.253344 test-box.example.net cifs.upcall[1700]:=
 sec=3D1
> > >> > > > Feb 23 12:22:46.253348 test-box.example.net cifs.upcall[1700]:=
 uid=3D602001116
> > >> > > > Feb 23 12:22:46.253352 test-box.example.net cifs.upcall[1700]:=
 creduid=3D602001116
> > >> > > > Feb 23 12:22:46.253365 test-box.example.net cifs.upcall[1700]:=
 pid=3D1699
> > >> > > > Feb 23 12:22:46.253978 test-box.example.net cifs.upcall[1700]:
> > >> > > > get_cachename_from_process_env: pathname=3D/proc/1699/environ
> > >> > > > Feb 23 12:22:46.254995 test-box.example.net cifs.upcall[1700]:
> > >> > > > get_existing_cc: default ccache is FILE:/tmp/krb5cc_602001116
> > >> > > > Feb 23 12:22:46.255015 test-box.example.net cifs.upcall[1700]:
> > >> > > > get_tgt_time: unable to get principal
> > >> > > > Feb 23 12:22:46.255021 test-box.example.net cifs.upcall[1700]:
> > >> > > > handle_krb5_mech: getting service ticket for win2k16-dfs1.exam=
ple.net
> > >> > > > Feb 23 12:22:46.255024 test-box.example.net cifs.upcall[1700]:
> > >> > > > handle_krb5_mech: using GSS-API
> > >> > > > Feb 23 12:22:46.259295 test-box.example.net cifs.upcall[1700]:=
 GSS-API
> > >> > > > error init_sec_context: Unspecified GSS failure.  Minor code m=
ay
> > >> > > > provide more information
> > >> > > > Feb 23 12:22:46.259306 test-box.example.net cifs.upcall[1700]:=
 GSS-API
> > >> > > > error init_sec_context: No Kerberos credentials available (def=
ault
> > >> > > > cache: FILE:/tmp/krb5cc_602001116)
> > >> > > > Feb 23 12:22:46.259311 test-box.example.net cifs.upcall[1700]:
> > >> > > > handle_krb5_mech: failed to obtain service ticket via GSS (851=
968)
> > >> > > > Feb 23 12:22:46.259314 test-box.example.net cifs.upcall[1700]:=
 Unable
> > >> > > > to obtain service ticket
> > >> > > > Feb 23 12:22:46.259323 test-box.example.net cifs.upcall[1700]:=
 Exit
> > >> > > > status 851968
> > >> > > > Feb 23 12:22:46.262827 test-box.example.net kernel: CIFS VFS:
> > >> > > > \\win2k16-dfs1.example.net Send error in SessSetup =3D -126
> > >> > > > Feb 23 12:22:47.398266 test-box.example.net su[1672]:
> > >> > > > pam_unix(su-l:session): session closed for user jeff
> > >> > > > Feb 23 12:22:49.159640 test-box.example.net su[1702]: (to chan=
g) root on pts/1
> > >> > > > Feb 23 12:22:49.173264 test-box.example.net su[1702]:
> > >> > > > pam_systemd(su-l:session): Cannot create session: Already runn=
ing in a
> > >> > > > session or user slice
> > >> > > > Feb 23 12:22:49.173967 test-box.example.net su[1702]:
> > >> > > > pam_unix(su-l:session): session opened for user chang by root(=
uid=3D0)
> > >> > > > Feb 23 12:22:51.878743 test-box.example.net cifs.upcall[1729]:=
 key
> > >> > > > description: cifs.spnego;0;0;39010000;ver=3D0x2;host=3Dwin2k16=
-dfs1.example.net;ip4=3D192.168.124.132;sec=3Dkrb5;uid=3D0x23e1cee3;creduid=
=3D0x23e1cee3;pid=3D0x6c0
> > >> > > > Feb 23 12:22:51.878765 test-box.example.net cifs.upcall[1729]:=
 ver=3D2
> > >> > > > Feb 23 12:22:51.878769 test-box.example.net cifs.upcall[1729]:
> > >> > > > host=3Dwin2k16-dfs1.example.net
> > >> > > > Feb 23 12:22:51.878773 test-box.example.net cifs.upcall[1729]:
> > >> > > > ip=3D192.168.124.132
> > >> > > > Feb 23 12:22:51.878776 test-box.example.net cifs.upcall[1729]:=
 sec=3D1
> > >> > > > Feb 23 12:22:51.878780 test-box.example.net cifs.upcall[1729]:=
 uid=3D602001123
> > >> > > > Feb 23 12:22:51.878783 test-box.example.net cifs.upcall[1729]:=
 creduid=3D602001123
> > >> > > > Feb 23 12:22:51.878786 test-box.example.net cifs.upcall[1729]:=
 pid=3D1728
> > >> > > > Feb 23 12:22:51.879060 test-box.example.net cifs.upcall[1729]:
> > >> > > > get_cachename_from_process_env: pathname=3D/proc/1728/environ
> > >> > > > Feb 23 12:22:51.879799 test-box.example.net cifs.upcall[1729]:
> > >> > > > get_existing_cc: default ccache is FILE:/tmp/krb5cc_602001123
> > >> > > > Feb 23 12:22:51.879819 test-box.example.net cifs.upcall[1729]:
> > >> > > > get_tgt_time: unable to get principal
> > >> > > > Feb 23 12:22:51.879824 test-box.example.net cifs.upcall[1729]:
> > >> > > > handle_krb5_mech: getting service ticket for win2k16-dfs1.exam=
ple.net
> > >> > > > Feb 23 12:22:51.879827 test-box.example.net cifs.upcall[1729]:
> > >> > > > handle_krb5_mech: using GSS-API
> > >> > > > Feb 23 12:22:51.886573 test-box.example.net gssproxy[1000]:
> > >> > > > [2021/02/23 17:22:51]: Client [2021/02/23 17:22:51]:
> > >> > > > (/usr/sbin/cifs.upcall) [2021/02/23 17:22:51]:  connected (fd =
=3D
> > >> > > > 14)[2021/02/23 17:22:51]:  (pid =3D 1729) (uid =3D 602001123) =
(gid =3D
> > >> > > > 602000513)[2021/02/23 17:22:51]:  (context =3D
> > >> > > > system_u:system_r:kernel_t:s0)[>
> > >> > > > Feb 23 12:22:51.886573 test-box.example.net gssproxy[1000]: [C=
ID
> > >> > > > 14][2021/02/23 17:22:51]: Connection matched service cifs
> > >> > > > Feb 23 12:22:51.886573 test-box.example.net gssproxy[1000]: [C=
ID
> > >> > > > 14][2021/02/23 17:22:51]: gp_rpc_execute: executing 6
> > >> > > > (GSSX_ACQUIRE_CRED) for service "cifs", euid: 602001123,socket=
:
> > >> > > > /var/lib/gssproxy/cifs.sock
> > >> > > > Feb 23 12:22:51.886573 test-box.example.net gssproxy[1000]:
> > >> > > > GSSX_ARG_ACQUIRE_CRED( call_ctx: { "" [  ] } input_cred_handle=
: <Null>
> > >> > > > add_cred: 0 desired_name: <Null> time_req: 0 desired_mechs: { =
}
> > >> > > > cred_usage: INITIATE initiator_time_req: 0 acceptor_time_req: =
0 )
> > >> > > > Feb 23 12:22:52.346639 test-box.example.net gssproxy[1000]:
> > >> > > > GSSX_RES_ACQUIRE_CRED( status: { 0 { 1 2 840 113554 1 2 2 } 0 =
"" "" [
> > >> > > > ] } output_cred_handle: { "chang@EXAMPLE.NET" [ { "chang@EXAMP=
LE.NET"
> > >> > > > { 1 2 840 113554 1 2 2 } INITIATE 36000 0 } ] [ K.....T.....pJ=
v.... ]
> > >> > > > 0 } )
> > >> > > > Feb 23 12:22:52.348086 test-box.example.net gssproxy[1000]: [C=
ID
> > >> > > > 14][2021/02/23 17:22:52]: Connection matched service cifs
> > >> > > > Feb 23 12:22:52.348086 test-box.example.net gssproxy[1000]: [C=
ID
> > >> > > > 14][2021/02/23 17:22:52]: gp_rpc_execute: executing 8
> > >> > > > (GSSX_INIT_SEC_CONTEXT) for service "cifs", euid: 602001123,so=
cket:
> > >> > > > /var/lib/gssproxy/cifs.sock
> > >> > > > Feb 23 12:22:52.348086 test-box.example.net gssproxy[1000]:
> > >> > > > GSSX_ARG_INIT_SEC_CONTEXT( call_ctx: { "" [  ] } context_handl=
e:
> > >> > > > <Null> cred_handle: { "chang@EXAMPLE.NET" [ { "chang@EXAMPLE.N=
ET" { 1
> > >> > > > 2 840 113554 1 2 2 } INITIATE 36000 0 } ] [ K.....T.....pJv...=
. ] 0 }
> > >> > > > target_name: "cifs@win2k16-dfs1.example.net" mech>
> > >> > > > Feb 23 12:22:52.348086 test-box.example.net gssproxy[1000]: [C=
ID
> > >> > > > 14][2021/02/23 17:22:52]: Credentials allowed by configuration
> > >> > > > Feb 23 12:22:52.357103 test-box.example.net gssproxy[1000]:
> > >> > > > GSSX_RES_INIT_SEC_CONTEXT( status: { 0 { 1 2 840 113554 1 2 2 =
} 0 ""
> > >> > > > "" [  ] } context_handle: { [ ......H............ ] [  ] 0 { 1=
 2 840
> > >> > > > 113554 1 2 2 } "chang@EXAMPLE.NET"
> > >> > > > "cifs/win2k16-dfs1.example.net@EXAMPLE.NET" 36000 432 1 1 }
> > >> > > > output_token: [ .....>
> > >> > > > Feb 23 12:22:52.357419 test-box.example.net cifs.upcall[1729]:=
 Exit status 0
> > >> > > >
> > >> > > >
> > >> > > > Ultimately a helper-script packaged with cifs-utils or a separ=
ate
> > >> > > > package entirely could be responsible for adding the file unde=
r
> > >> > > > /etc/gssproxy and the drop-in file for systemd. The helper scr=
ipt
> > >> > > > could take a series of users/groups as arguments that would li=
mit
> > >> > > > access to the socket file or there could be a separate config =
file
> > >> > > > that is read from to determine if access to the cifs.sock sock=
et
> > >> > > > should be limited.
> > >> > > >
> > >> > > >
> > >> > > > On Fri, Feb 19, 2021 at 12:38 PM Simo Sorce <simo@redhat.com> =
wrote:
> > >> > > > >
> > >> > > > > On Fri, 2021-02-19 at 03:30 -0800, Shyam Prasad N wrote:
> > >> > > > > > Hi Simo,
> > >> > > > > >
> > >> > > > > > > Finally the GSS-Proxy mechanism is namespace compatible,=
 so you also
> > >> > > > > > > get the ability to define different auth daemons per dif=
ferent
> > >> > > > > > > containers, no need to invent new mechanisms for that or=
 change yet
> > >> > > > > > > again protocols/userspace to obtain container capabiliti=
es.
> > >> > > > > >
> > >> > > > > > Could you please point me to the documentation for doing t=
his?
> > >> > > > >
> > >> > > > > I do not know if the kernel documents this, but the way gssp=
roxy works
> > >> > > > > is that when you start the daemon it pokes at the kernel to =
let it know
> > >> > > > > the socket is available. So then the kernel opens the socket=
 in the
> > >> > > > > namespace the proxy is running into (detected from the pokin=
g
> > >> > > > > operation, which is a write in a proc file).
> > >> > > > >
> > >> > > > > HTH,
> > >> > > > > Simo.
> > >> > > > >
> > >> > > > > >
> > >> > > > > > Regards,
> > >> > > > > > Shyam
> > >> > > > > >
> > >> > > > > > On Thu, Dec 17, 2020 at 5:41 AM Simo Sorce <simo@redhat.co=
m> wrote:
> > >> > > > > > > Hi Steve,
> > >> > > > > > >
> > >> > > > > > > GSSAPI and krb5 as implemented in system krb5 libraries =
exists from
> > >> > > > > > > longer than Samba has implemented those capabilities, I =
do not think it
> > >> > > > > > > make sense to reason along those lines.
> > >> > > > > > >
> > >> > > > > > > GSS-Proxy has been built with a protocol to talk from th=
e kernel that
> > >> > > > > > > resolved a number of issues for knfsd (eg big packet siz=
es when a MS-
> > >> > > > > > > PAC is present).
> > >> > > > > > >
> > >> > > > > > > And Samba uses internally exactly the same krb5 mechanis=
m as it defers
> > >> > > > > > > to the kerberos libraries as well.
> > >> > > > > > >
> > >> > > > > > > Additionally GSS-Proxy can be very easily extended to al=
so do NTLMSSP
> > >> > > > > > > using the same interface as I have built the gssntlmssp =
long ago from
> > >> > > > > > > the MS spec, and is probably the most correct NTLMSSP im=
plementation
> > >> > > > > > > you can find around.
> > >> > > > > > >
> > >> > > > > > > Gssntlmssp also has a Winbind backend so you get automat=
icaly access to
> > >> > > > > > > whatever cached credentials Winbindd has for users as a =
bonus (although
> > >> > > > > > > the integration can be improved there), yet you *can* us=
e it w/o
> > >> > > > > > > Winbindd just fine providing a credential file (smbpassw=
d format
> > >> > > > > > > compatible).
> > >> > > > > > >
> > >> > > > > > > GSS-Proxy is already integrated in distributions because=
 it is used by
> > >> > > > > > > knfsd, and can be as easily used by cifsd, and you *shou=
ld* really use
> > >> > > > > > > it there, so we can have a single, consistent, maintaine=
d, mechanism
> > >> > > > > > > for server side GSS authentication, and not have to repe=
at and reinvent
> > >> > > > > > > kernel to userspace mechanisms.
> > >> > > > > > >
> > >> > > > > > > And if you add it for cifsd you have yet another reason =
to do it for
> > >> > > > > > > cifs.ko as well.
> > >> > > > > > >
> > >> > > > > > > Finally the GSS-Proxy mechanism is namespace compatible,=
 so you also
> > >> > > > > > > get the ability to define different auth daemons per dif=
ferent
> > >> > > > > > > containers, no need to invent new mechanisms for that or=
 change yet
> > >> > > > > > > again protocols/userspace to obtain container capabiliti=
es.
> > >> > > > > > >
> > >> > > > > > > For the client we'll need to add some XDR parsing functi=
ons in kernel,
> > >> > > > > > > they were omitted from my original patches because there=
 was no client
> > >> > > > > > > side kernel consumer back then, but it i an easy, mechan=
ical change.
> > >> > > > > > >
> > >> > > > > > > HTH,
> > >> > > > > > > Simo.
> > >> > > > > > >
> > >> > > > > > > On Wed, 2020-12-16 at 16:43 -0600, Steve French wrote:
> > >> > > > > > > > generally I would feel more comfortable using somethin=
g (library or
> > >> > > > > > > > utility) in Samba (if needed) for additional SPNEGO su=
pport if
> > >> > > > > > > > something is missing (in what the kernel drivers are d=
oing to
> > >> > > > > > > > encapsulate Active Directory or Samba AD krb5 tickets =
in SPNEGO) as
> > >> > > > > > > > Samba is better maintained/tested etc. than most compo=
nents.  Is there
> > >> > > > > > > > something in Samba that could be used here instead of =
having a
> > >> > > > > > > > dependency on another project - Samba has been doing K=
erberos/SPNEGO
> > >> > > > > > > > longer than most ...?   There are probably others (jra=
, Metze etc.)
> > >> > > > > > > > that have would know more about gssproxy vs. Samba equ=
ivalents though
> > >> > > > > > > > and would defer to them ...
> > >> > > > > > > >
> > >> > > > > > > > On Wed, Dec 16, 2020 at 8:33 AM Simo Sorce <simo@redha=
t.com> wrote:
> > >> > > > > > > > > Hi Michael,
> > >> > > > > > > > > as you say the best course of action would be for ci=
fs.ko to move to
> > >> > > > > > > > > use the RPC interface we defined for knfsd (with any=
 extensions that
> > >> > > > > > > > > may  be needed), and we had discussions in the past =
with cifs upstream
> > >> > > > > > > > > developers about it. But nothing really materialized=
.
> > >> > > > > > > > >
> > >> > > > > > > > > If something is needed in the short term, I thjink t=
he quickest course
> > >> > > > > > > > > of action is indeed to change the userspace helper t=
o use gssapi
> > >> > > > > > > > > function calls, so that they can be intercepted like=
 we do for rpc.gssd
> > >> > > > > > > > > (nfs client's userspace helper).
> > >> > > > > > > > >
> > >> > > > > > > > > Unfortunately I do not have the cycles to work on th=
at myself at this
> > >> > > > > > > > > time :-(
> > >> > > > > > > > >
> > >> > > > > > > > > HTH,
> > >> > > > > > > > > Simo.
> > >> > > > > > > > >
> > >> > > > > > > > > On Wed, 2020-12-16 at 10:01 +0000, Weiser, Michael w=
rote:
> > >> > > > > > > > > > Hello,
> > >> > > > > > > > > >
> > >> > > > > > > > > > I have a use-case for authentication of Linux cifs=
 client mounts without the user being present (e.g. from batch jobs) using =
gssproxy's impersonation feature with Kerberos Constrained Delegation simil=
ar to how it can be done for NFS[1].
> > >> > > > > > > > > >
> > >> > > > > > > > > > My understanding is that currently neither the Lin=
ux cifs kernel client nor cifs-utils userland tools support acquiring crede=
ntials using gssproxy. The former uses a custom upcall interface to talk to=
 cifs.spnego from cifs-utils. The latter then goes looking for Kerberos tic=
ket caches using libkrb5 functions, not GSSAPI, which prevents gssproxy fro=
m interacting with it.[2]
> > >> > > > > > > > > >
> > >> > > > > > > > > > From what I understand, the preferred method would=
 be to switch the Linux kernel client upcall to the RPC protocol defined by=
 gssproxy[3] (as has been done for the Linux kernel NFS server already repl=
acing rpc.svcgssd[4]). The kernel could then, at least optionally, talk to =
gssproxy directly to try and obtain credentials.
> > >> > > > > > > > > >
> > >> > > > > > > > > > Failing that, cifs-utils' cifs.spnego could be swi=
tched to GSSAPI so that gssproxy's interposer plugin could intercept GSSAPI=
 calls and provide them with the required credentials (similar to the NFS c=
lient rpc.gssd[5]).
> > >> > > > > > > > > >
> > >> > > > > > > > > > Assuming my understanding is correct so far:
> > >> > > > > > > > > >
> > >> > > > > > > > > > Is anyone doing any work on this and could use som=
e help (testing, coding)?
> > >> > > > > > > > > > What would be expected complexity and possible roa=
dblocks when trying to make a start at implementing this?
> > >> > > > > > > > > > Or is the idea moot due to some constraint or rece=
nt development I'm not aware of?
> > >> > > > > > > > > >
> > >> > > > > > > > > > I have found a recent discussion of the topic on l=
inux-cifs[6] which provided no definite answer though.
> > >> > > > > > > > > >
> > >> > > > > > > > > > As a crude attempt at an explicit userspace workar=
ound I tried but failed to trick smbclient into initialising a ticket cache=
 using gssproxy for cifs.spnego to find later on.
> > >> > > > > > > > > > Is this something that could be implemented withou=
t too much redundant effort (or should already work, perhaps using a differ=
ent tool)?
> > >> > > > > > > > > >
> > >> > > > > > > > > > [1] https://github.com/gssapi/gssproxy/blob/main/d=
ocs/NFS.md#user-impersonation-via-constrained-delegation
> > >> > > > > > > > > > [2] https://pagure.io/gssproxy/issue/56
> > >> > > > > > > > > > [3] https://github.com/gssapi/gssproxy/blob/main/d=
ocs/ProtocolDocumentation.md
> > >> > > > > > > > > > [4] https://github.com/gssapi/gssproxy/blob/main/d=
ocs/NFS.md#nfs-server
> > >> > > > > > > > > > [5] https://github.com/gssapi/gssproxy/blob/main/d=
ocs/NFS.md#nfs-client
> > >> > > > > > > > > > [6] https://www.spinics.net/lists/linux-cifs/msg20=
182.html
> > >> > > > > > > > > > --
> > >> > > > > > > > > > Thanks,
> > >> > > > > > > > > > Michael
> > >> > > > > > > > > > _______________________________________________
> > >> > > > > > > > > > gss-proxy mailing list -- gss-proxy@lists.fedoraho=
sted.org
> > >> > > > > > > > > > To unsubscribe send an email to gss-proxy-leave@li=
sts.fedorahosted.org
> > >> > > > > > > > > > Fedora Code of Conduct: https://docs.fedoraproject=
.org/en-US/project/code-of-conduct/
> > >> > > > > > > > > > List Guidelines: https://fedoraproject.org/wiki/Ma=
iling_list_guidelines
> > >> > > > > > > > > > List Archives: https://lists.fedorahosted.org/arch=
ives/list/gss-proxy@lists.fedorahosted.org
> > >> > > > > > > > >
> > >> > > > > > > > > --
> > >> > > > > > > > > Simo Sorce
> > >> > > > > > > > > RHEL Crypto Team
> > >> > > > > > > > > Red Hat, Inc
> > >> > > > > > > > >
> > >> > > > > > > > >
> > >> > > > > > > > >
> > >> > > > > > > > >
> > >> > > > > > >
> > >> > > > > > > --
> > >> > > > > > > Simo Sorce
> > >> > > > > > > RHEL Crypto Team
> > >> > > > > > > Red Hat, Inc
> > >> > > > > > >
> > >> > > > > > >
> > >> > > > > > >
> > >> > > > > > >
> > >> > > > > >
> > >> > > > > >
> > >> > > > >
> > >> > > > > --
> > >> > > > > Simo Sorce
> > >> > > > > RHEL Crypto Team
> > >> > > > > Red Hat, Inc
> > >> > > > >
> > >> > > > >
> > >> > > > >
> > >> > > > >
> > >> > > >
> > >> > >
> > >> >
> > >>
> >
>

