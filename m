Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A84C07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DB47613AB
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhGHXhX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhGHXhX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 19:37:23 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F47C061574
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 16:34:40 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id e20so5040620ljn.8
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jul 2021 16:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zj2nbbt80sDLJHSYcvy9QY0eRFhyMBAJl7w7SngoOlM=;
        b=dGKcJenTDWV16VCeUEv6Beyyp8qufRIqD1VIt3yn6bGW4oBpAQMGqHwdJaOSN8fPoL
         iOjybojHvJw9MpOSMr5hL0y/FD5/ykajqRjxVzwI9vJFIpuDiNbyseFD8348SLNSlIDT
         0VKRBg54VEkpZRPg5yDqHdAjxOiVW1Jvd0T0hWQGLV+a3KU23CmaCrhNTggndmo3ZK+5
         wZRGQqQcSwEKiPU6Q+iciHo3qFRVqtKsJwRwJXBaaLzKLAew+HMh3NMu+n/R6JJBgiqa
         E9HAl/K08ThX4U8z9HucDGXf7OHveAxRt00svjPcLiDs34m/fCTvPXS9j3MjJkxd5rFg
         eWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zj2nbbt80sDLJHSYcvy9QY0eRFhyMBAJl7w7SngoOlM=;
        b=N/MmeAAfdjg/77gIx6x+47bnX7y7k5h3+ghoRers5EqA/0PRDEFX50MNx0CClhF5np
         tbKWT9kyaprlPKgl4l31I4Brgsm8LBfPf9BeO6m7zxJAntHp1kCsn84CMv4Z1KkUuBNT
         3LJcZJrE2d8wRX3hx+zx5ELHW18MuflFRreESsY6hV748FYROECMeZUvxE+LGbXbLToC
         mosWGODZ+dXZt1sTshTei3uoPCZQue+POhjmFewBOfmLFpD3ZYkmTCWwZbrgDFKg7Bq9
         4iz08uhVdOP2asxwPMgyLLwMrdvn8rtwDr70AQjNdTY/5EuAH8W+4TuRZ6isyK6u9wUI
         y8sQ==
X-Gm-Message-State: AOAM533ygZhXM3XhYHSKr83cmju6GBJgGpUZH1aZiYcN6smnrwcHZx9m
        mkeFo0dBHqgdfU3kAu2jFncoLXVK84cb6JpYxA0=
X-Google-Smtp-Source: ABdhPJyLrRNBcnxXMcUBYZpRY9kUeSUbKbAXPowKP9t1OR/hePMYaUN1lVr3WIfstW1FNaWO1R0nXB7q4YwEcKbihE0=
X-Received: by 2002:a05:651c:1033:: with SMTP id w19mr12014675ljm.218.1625787278356;
 Thu, 08 Jul 2021 16:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvS6aHG8dXBre0RuGPzUb0g1hh-OPnhEup9PrX5z0zv5g@mail.gmail.com>
 <CAH2r5mu_fVutwr+XY8i-EpWO9gTw+dvHoy1oFk_wxHeMuVgxqA@mail.gmail.com>
 <CAH2r5mstq3L33-RBDrJ+0Z1K2PAP0z=5bm=wQ8XHdx4th_caFw@mail.gmail.com>
 <CAN05THSBo74HOMYV+mHejb1s4tAb_uv=8cmcO1UDRScFw-WUQg@mail.gmail.com>
 <CAKywueR0JE9-a8Gs-bxvDQgmDNzpm=sodpWc7rXaG58WR1EZiQ@mail.gmail.com>
 <CAH2r5mtKzR731tZ-+_MJ+4paW3kTqP3BM07Bu3j6bRbgxiE9_Q@mail.gmail.com> <CAH2r5muVGTBavyVWzXMRcMqWnVe1-MJ12VWKnvEYfpNDqiOZ_g@mail.gmail.com>
In-Reply-To: <CAH2r5muVGTBavyVWzXMRcMqWnVe1-MJ12VWKnvEYfpNDqiOZ_g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Jul 2021 18:34:24 -0500
Message-ID: <CAH2r5muuH4Vqk4nf1_vU2hbtOSsO90Rn_X8yHv0vmgvw+or5zw@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] add ability to send signing negotiate context
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000350e1d05c6a5199c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000350e1d05c6a5199c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I also removed the line you noted:
          pr_warn_once("requesting GMAC signing is experimental\n");
No point to print that unless GMAC was actually negotiated (ie until
the followon patch which adds GMAC to the list ...)



On Thu, Jul 8, 2021 at 6:29 PM Steve French <smfrench@gmail.com> wrote:
>
> Tentatively I made the change to clarify:
>
> +MODULE_PARM_DESC(enable_GMAC_signing, "Enable requesting faster
> (GMAC) packet signing. Default: n/N/0");
>
> to
>
> +MODULE_PARM_DESC(enable_negotiate_signing, "Enable negotiating packet
> signing algorithm with server. Default: n/N/0");
>
> I think it is ok to leave the GMAC comment to minimize the change in
> the next patch (enabling GMAC) ...
>
> On Thu, Jul 8, 2021 at 6:19 PM Steve French <smfrench@gmail.com> wrote:
> >
> > It is a little tricky to figure out good wording here.
> >
> > "enable_negotiate_signing" (eventually) could end up requesting all 3
> > ... which means that the server could choose SHA256 over GMAC over
> > CMAC.  Maybe I should avoid all mention of GMAC.
> >
> > My reason for noting "GMAC is experimental" is that if GMAC is
> > negotiated it is less tested than the other two (since fewer servers
> > currently support it compared to the other two which are broadly
> > supported and thus already tested with cifs.ko) - but the effect of
> > the patch is to let the server choose which algorithm it prefers ...
> > so perhaps I should avoid mentioning GMAC here.
> >
> > On Thu, Jul 8, 2021 at 5:06 PM Pavel Shilovsky <piastryyy@gmail.com> wr=
ote:
> > >
> > > @@ -104,6 +105,9 @@ MODULE_PARM_DESC(enable_gcm_256, "Enable
> > > requesting strongest (256 bit) GCM encr
> > >  module_param(require_gcm_256, bool, 0644);
> > >  MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM
> > > encryption. Default: n/N/0");
> > >
> > > +module_param(enable_negotiate_signing, bool, 0644);
> > > +MODULE_PARM_DESC(enable_GMAC_signing, "Enable requesting faster
> > > (GMAC) packet signing. Default: n/N/0");
> > > +
> > >
> > > s/enable_GMAC_signing/enable_negotiate_signing/ ?
> > >
> > > Also the description here is misleading: this param enables sending
> > > the signing context not requesting GMAC which is not supported yet.
> > >
> > >
> > > +    if (enable_negotiate_signing) {
> > > +        pr_warn_once("requesting GMAC signing is experimental\n");
> > >
> > > Here as well - we are not requesting GMAC here, we are sending the
> > > signing context with CMAC. I don't think this should be marked as
> > > experimental.
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D1=81=D1=80, 7 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 21:52, ronnie=
 sahlberg <ronniesahlberg@gmail.com>:
> > > >
> > > > lgtm
> > > >
> > > > On Thu, Jul 8, 2021 at 2:49 PM Steve French <smfrench@gmail.com> wr=
ote:
> > > > >
> > > > > v4 of patch (includes minor change to set local variable "num_alg=
s"
> > > > > once to number of algorithms and use that throughout
> > > > > build_signing_context to make code a little clearer)
> > > > >
> > > > >
> > > > > On Wed, Jul 7, 2021 at 11:27 PM Steve French <smfrench@gmail.com>=
 wrote:
> > > > > >
> > > > > > v3 of patch.  Updated with additional feedback from Ronnie (to =
make it
> > > > > > more context len and datalength clearer)
> > > > > >
> > > > > >
> > > > > > On Wed, Jul 7, 2021 at 9:44 PM Steve French <smfrench@gmail.com=
> wrote:
> > > > > > >
> > > > > > > Support for faster packet signing (using GMAC instead of CMAC=
) can
> > > > > > > now be negotiated to some newer servers, including Windows.
> > > > > > > See MS-SMB2 section 2.2.3.17.
> > > > > > >
> > > > > > > This patch adds support for sending the new negotiate context
> > > > > > > with the first of three supported signing algorithms (AES-CMA=
C)
> > > > > > > and decoding the response.  A followon patch will add support
> > > > > > > for sending the other two (including AES-GMAC, which is faste=
st)
> > > > > > > and changing the signing algorithm used based on what was
> > > > > > > negotiated.
> > > > > > >
> > > > > > > To allow the client to request GMAC signing set module parame=
ter
> > > > > > > "enable_negotiate_signing" to 1.
> > > > > > >
> > > > > > > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > > > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > > > > > ---
> > > > > > >  fs/cifs/cifsfs.c   |  4 +++
> > > > > > >  fs/cifs/cifsglob.h |  3 ++
> > > > > > >  fs/cifs/smb2pdu.c  | 83 ++++++++++++++++++++++++++++++++++++=
++++------
> > > > > > >  fs/cifs/smb2pdu.h  |  5 ++-
> > > > > > >  4 files changed, 84 insertions(+), 11 deletions(-)
> > > > > > >
> > > > > > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > > > > > index 9fb874dd8d24..476b07213fcd 100644
> > > > > > > --- a/fs/cifs/cifsfs.c
> > > > > > > +++ b/fs/cifs/cifsfs.c
> > > > > > > @@ -65,6 +65,7 @@ bool lookupCacheEnabled =3D true;
> > > > > > >  bool disable_legacy_dialects; /* false by default */
> > > > > > >  bool enable_gcm_256 =3D true;
> > > > > > >  bool require_gcm_256; /* false by default */
> > > > > > > +bool enable_negotiate_signing; /* false by default */
> > > > > > >  unsigned int global_secflags =3D CIFSSEC_DEF;
> > > > > > >  /* unsigned int ntlmv2_support =3D 0; */
> > > > > > >  unsigned int sign_CIFS_PDUs =3D 1;
> > > > > > > @@ -104,6 +105,9 @@ MODULE_PARM_DESC(enable_gcm_256, "Enable
> > > > > > > requesting strongest (256 bit) GCM encr
> > > > > > >  module_param(require_gcm_256, bool, 0644);
> > > > > > >  MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bi=
t) GCM
> > > > > > > encryption. Default: n/N/0");
> > > > > > >
> > > > > > > +module_param(enable_negotiate_signing, bool, 0644);
> > > > > > > +MODULE_PARM_DESC(enable_GMAC_signing, "Enable requesting fas=
ter
> > > > > > > (GMAC) packet signing. Default: n/N/0");
> > > > > > > +
> > > > > > >  module_param(disable_legacy_dialects, bool, 0644);
> > > > > > >  MODULE_PARM_DESC(disable_legacy_dialects, "To improve securi=
ty it may be "
> > > > > > >     "helpful to restrict the ability to "
> > > > > > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > > > > > index 921680fb7931..3c2e117bb926 100644
> > > > > > > --- a/fs/cifs/cifsglob.h
> > > > > > > +++ b/fs/cifs/cifsglob.h
> > > > > > > @@ -667,9 +667,11 @@ struct TCP_Server_Info {
> > > > > > >   unsigned int max_write;
> > > > > > >   unsigned int min_offload;
> > > > > > >   __le16 compress_algorithm;
> > > > > > > + __u16 signing_algorithm;
> > > > > > >   __le16 cipher_type;
> > > > > > >   /* save initital negprot hash */
> > > > > > >   __u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
> > > > > > > + bool signing_negotiated; /* true if valid signing context r=
cvd from server */
> > > > > > >   bool posix_ext_supported;
> > > > > > >   struct delayed_work reconnect; /* reconnect workqueue job *=
/
> > > > > > >   struct mutex reconnect_mutex; /* prevent simultaneous recon=
nects */
> > > > > > > @@ -1869,6 +1871,7 @@ extern unsigned int global_secflags; /*=
 if on,
> > > > > > > session setup sent
> > > > > > >  extern unsigned int sign_CIFS_PDUs;  /* enable smb packet si=
gning */
> > > > > > >  extern bool enable_gcm_256; /* allow optional negotiate of s=
trongest
> > > > > > > signing (aes-gcm-256) */
> > > > > > >  extern bool require_gcm_256; /* require use of strongest sig=
ning
> > > > > > > (aes-gcm-256) */
> > > > > > > +extern bool enable_negotiate_signing; /* request use of fast=
er (GMAC)
> > > > > > > signing if available */
> > > > > > >  extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensi=
ons*/
> > > > > > >  extern unsigned int CIFSMaxBufSize;  /* max size not includi=
ng hdr */
> > > > > > >  extern unsigned int cifs_min_rcv;    /* min size of big ntwr=
k buf pool */
> > > > > > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > > > > > > index 962826dc3316..757f145e70e5 100644
> > > > > > > --- a/fs/cifs/smb2pdu.c
> > > > > > > +++ b/fs/cifs/smb2pdu.c
> > > > > > > @@ -433,6 +433,23 @@ build_compression_ctxt(struct
> > > > > > > smb2_compression_capabilities_context *pneg_ctxt)
> > > > > > >   pneg_ctxt->CompressionAlgorithms[2] =3D SMB3_COMPRESS_LZNT1=
;
> > > > > > >  }
> > > > > > >
> > > > > > > +static void
> > > > > > > +build_signing_ctxt(struct smb2_signing_capabilities *pneg_ct=
xt)
> > > > > > > +{
> > > > > > > + pneg_ctxt->ContextType =3D SMB2_SIGNING_CAPABILITIES;
> > > > > > > + /*
> > > > > > > + * Data length must be increased here if more than 3 signing=
 algorithms
> > > > > > > + * sent but currently only 3 are defined. And context Data l=
ength must
> > > > > > > + * be rounded to multiple of 8 for some servers.
> > > > > > > + */
> > > > > > > + pneg_ctxt->DataLength =3D
> > > > > > > + cpu_to_le16(DIV_ROUND_UP(sizeof(struct smb2_signing_capabil=
ities) -
> > > > > > > + sizeof(struct smb2_neg_context), 8) * 8);
> > > > > > > + pneg_ctxt->SigningAlgorithmCount =3D cpu_to_le16(1);
> > > > > > > + pneg_ctxt->SigningAlgorithms[0] =3D cpu_to_le16(SIGNING_ALG=
_AES_CMAC);
> > > > > > > + /* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA=
256 */
> > > > > > > +}
> > > > > > > +
> > > > > > >  static void
> > > > > > >  build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_=
ctxt)
> > > > > > >  {
> > > > > > > @@ -498,7 +515,7 @@ assemble_neg_contexts(struct smb2_negotia=
te_req *req,
> > > > > > >         struct TCP_Server_Info *server, unsigned int *total_l=
en)
> > > > > > >  {
> > > > > > >   char *pneg_ctxt;
> > > > > > > - unsigned int ctxt_len;
> > > > > > > + unsigned int ctxt_len, neg_context_count;
> > > > > > >
> > > > > > >   if (*total_len > 200) {
> > > > > > >   /* In case length corrupted don't want to overrun smb buffe=
r */
> > > > > > > @@ -525,6 +542,17 @@ assemble_neg_contexts(struct smb2_negoti=
ate_req *req,
> > > > > > >   *total_len +=3D ctxt_len;
> > > > > > >   pneg_ctxt +=3D ctxt_len;
> > > > > > >
> > > > > > > + ctxt_len =3D build_netname_ctxt((struct smb2_netname_neg_co=
ntext *)pneg_ctxt,
> > > > > > > + server->hostname);
> > > > > > > + *total_len +=3D ctxt_len;
> > > > > > > + pneg_ctxt +=3D ctxt_len;
> > > > > > > +
> > > > > > > + build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt=
);
> > > > > > > + *total_len +=3D sizeof(struct smb2_posix_neg_context);
> > > > > > > + pneg_ctxt +=3D sizeof(struct smb2_posix_neg_context);
> > > > > > > +
> > > > > > > + neg_context_count =3D 4;
> > > > > > > +
> > > > > > >   if (server->compress_algorithm) {
> > > > > > >   build_compression_ctxt((struct smb2_compression_capabilitie=
s_context *)
> > > > > > >   pneg_ctxt);
> > > > > > > @@ -533,17 +561,24 @@ assemble_neg_contexts(struct smb2_negot=
iate_req *req,
> > > > > > >   8) * 8;
> > > > > > >   *total_len +=3D ctxt_len;
> > > > > > >   pneg_ctxt +=3D ctxt_len;
> > > > > > > - req->NegotiateContextCount =3D cpu_to_le16(5);
> > > > > > > - } else
> > > > > > > - req->NegotiateContextCount =3D cpu_to_le16(4);
> > > > > > > + neg_context_count++;
> > > > > > > + }
> > > > > > >
> > > > > > > - ctxt_len =3D build_netname_ctxt((struct smb2_netname_neg_co=
ntext *)pneg_ctxt,
> > > > > > > - server->hostname);
> > > > > > > - *total_len +=3D ctxt_len;
> > > > > > > - pneg_ctxt +=3D ctxt_len;
> > > > > > > + if (enable_negotiate_signing) {
> > > > > > > + pr_warn_once("requesting GMAC signing is experimental\n");
> > > > > > > + build_signing_ctxt((struct smb2_signing_capabilities *)
> > > > > > > + pneg_ctxt);
> > > > > > > + ctxt_len =3D DIV_ROUND_UP(
> > > > > > > + sizeof(struct smb2_signing_capabilities),
> > > > > > > + 8) * 8;
> > > > > > > + *total_len +=3D ctxt_len;
> > > > > > > + pneg_ctxt +=3D ctxt_len;
> > > > > > > + neg_context_count++;
> > > > > > > + }
> > > > > > > +
> > > > > > > + /* check for and add transport_capabilities and signing cap=
abilities */
> > > > > > > + req->NegotiateContextCount =3D cpu_to_le16(neg_context_coun=
t);
> > > > > > >
> > > > > > > - build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt=
);
> > > > > > > - *total_len +=3D sizeof(struct smb2_posix_neg_context);
> > > > > > >  }
> > > > > > >
> > > > > > >  static void decode_preauth_context(struct smb2_preauth_neg_c=
ontext *ctxt)
> > > > > > > @@ -632,6 +667,31 @@ static int decode_encrypt_ctx(struct
> > > > > > > TCP_Server_Info *server,
> > > > > > >   return 0;
> > > > > > >  }
> > > > > > >
> > > > > > > +static void decode_signing_ctx(struct TCP_Server_Info *serve=
r,
> > > > > > > +        struct smb2_signing_capabilities *pctxt)
> > > > > > > +{
> > > > > > > + unsigned int len =3D le16_to_cpu(pctxt->DataLength);
> > > > > > > +
> > > > > > > + if ((len < 4) || (len > 16)) {
> > > > > > > + pr_warn_once("server sent bad signing negcontext\n");
> > > > > > > + return;
> > > > > > > + }
> > > > > > > + if (le16_to_cpu(pctxt->SigningAlgorithmCount) !=3D 1) {
> > > > > > > + pr_warn_once("Invalid signing algorithm count\n");
> > > > > > > + return;
> > > > > > > + }
> > > > > > > + if (le16_to_cpu(pctxt->SigningAlgorithms[0]) > 2) {
> > > > > > > + pr_warn_once("unknown signing algorithm\n");
> > > > > > > + return;
> > > > > > > + }
> > > > > > > +
> > > > > > > + server->signing_negotiated =3D true;
> > > > > > > + server->signing_algorithm =3D le16_to_cpu(pctxt->SigningAlg=
orithms[0]);
> > > > > > > + cifs_dbg(FYI, "signing algorithm %d chosen\n",
> > > > > > > +      server->signing_algorithm);
> > > > > > > +}
> > > > > > > +
> > > > > > > +
> > > > > > >  static int smb311_decode_neg_context(struct smb2_negotiate_r=
sp *rsp,
> > > > > > >        struct TCP_Server_Info *server,
> > > > > > >        unsigned int len_of_smb)
> > > > > > > @@ -675,6 +735,9 @@ static int smb311_decode_neg_context(stru=
ct
> > > > > > > smb2_negotiate_rsp *rsp,
> > > > > > >   (struct smb2_compression_capabilities_context *)pctx);
> > > > > > >   else if (pctx->ContextType =3D=3D SMB2_POSIX_EXTENSIONS_AVA=
ILABLE)
> > > > > > >   server->posix_ext_supported =3D true;
> > > > > > > + else if (pctx->ContextType =3D=3D SMB2_SIGNING_CAPABILITIES=
)
> > > > > > > + decode_signing_ctx(server,
> > > > > > > + (struct smb2_signing_capabilities *)pctx);
> > > > > > >   else
> > > > > > >   cifs_server_dbg(VFS, "unknown negcontext of type %d ignored=
\n",
> > > > > > >   le16_to_cpu(pctx->ContextType));
> > > > > > > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > > > > > > index ba75e65924ac..4b27cb9105fd 100644
> > > > > > > --- a/fs/cifs/smb2pdu.h
> > > > > > > +++ b/fs/cifs/smb2pdu.h
> > > > > > > @@ -329,7 +329,7 @@ struct smb2_neg_context {
> > > > > > >   __le16 ContextType;
> > > > > > >   __le16 DataLength;
> > > > > > >   __le32 Reserved;
> > > > > > > - /* Followed by array of data */
> > > > > > > + /* Followed by array of data. NOTE: some servers require pa=
dding to
> > > > > > > 8 byte boundary */
> > > > > > >  } __packed;
> > > > > > >
> > > > > > >  #define SMB311_LINUX_CLIENT_SALT_SIZE 32
> > > > > > > @@ -394,6 +394,7 @@ struct smb2_compression_capabilities_cont=
ext {
> > > > > > >   __u16 Padding;
> > > > > > >   __u32 Flags;
> > > > > > >   __le16 CompressionAlgorithms[3];
> > > > > > > + /* Check if pad needed */
> > > > > > >  } __packed;
> > > > > > >
> > > > > > >  /*
> > > > > > > @@ -420,6 +421,7 @@ struct smb2_transport_capabilities_contex=
t {
> > > > > > >   __le16  DataLength;
> > > > > > >   __u32 Reserved;
> > > > > > >   __le32 Flags;
> > > > > > > + __u32 Pad;
> > > > > > >  } __packed;
> > > > > > >
> > > > > > >  /*
> > > > > > > @@ -458,6 +460,7 @@ struct smb2_signing_capabilities {
> > > > > > >   __u32 Reserved;
> > > > > > >   __le16 SigningAlgorithmCount;
> > > > > > >   __le16 SigningAlgorithms[];
> > > > > > > + /*  Followed by padding to 8 byte boundary (required by som=
e servers) */
> > > > > > >  } __packed;
> > > > > > >
> > > > > > >  #define POSIX_CTXT_DATA_LEN 16
> > > > > > >
> > > > > > > --
> > > > > > > Thanks,
> > > > > > >
> > > > > > > Steve
> > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000350e1d05c6a5199c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-SMB3.1.1-Add-support-for-negotiating-signing-algorit.patch"
Content-Disposition: attachment; 
	filename="0002-SMB3.1.1-Add-support-for-negotiating-signing-algorit.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqvjrd6r0>
X-Attachment-Id: f_kqvjrd6r0

RnJvbSBkZTk2ODUzZGFjYzdjZDMxOWQ1ZmRkYWIzY2I1YWRhOGYxMDZjNTJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgNSBKdWwgMjAyMSAxNTowNTozOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBTTUIzLjEuMTogQWRkIHN1cHBvcnQgZm9yIG5lZ290aWF0aW5nIHNpZ25pbmcgYWxnb3JpdGht
CgpTdXBwb3J0IGZvciBmYXN0ZXIgcGFja2V0IHNpZ25pbmcgKHVzaW5nIEdNQUMgaW5zdGVhZCBv
ZiBDTUFDKSBjYW4Kbm93IGJlIG5lZ290aWF0ZWQgdG8gc29tZSBuZXdlciBzZXJ2ZXJzLCBpbmNs
dWRpbmcgV2luZG93cy4KU2VlIE1TLVNNQjIgc2VjdGlvbiAyLjIuMy4xNy4KClRoaXMgcGF0Y2gg
YWRkcyBzdXBwb3J0IGZvciBzZW5kaW5nIHRoZSBuZXcgbmVnb3RpYXRlIGNvbnRleHQKd2l0aCB0
aGUgZmlyc3Qgb2YgdGhyZWUgc3VwcG9ydGVkIHNpZ25pbmcgYWxnb3JpdGhtcyAoQUVTLUNNQUMp
CmFuZCBkZWNvZGluZyB0aGUgcmVzcG9uc2UuICBBIGZvbGxvd29uIHBhdGNoIHdpbGwgYWRkIHN1
cHBvcnQKZm9yIHNlbmRpbmcgdGhlIG90aGVyIHR3byAoaW5jbHVkaW5nIEFFUy1HTUFDLCB3aGlj
aCBpcyBmYXN0ZXN0KQphbmQgY2hhbmdpbmcgdGhlIHNpZ25pbmcgYWxnb3JpdGhtIHVzZWQgYmFz
ZWQgb24gd2hhdCB3YXMKbmVnb3RpYXRlZC4KClRvIGFsbG93IHRoZSBjbGllbnQgdG8gcmVxdWVz
dCBHTUFDIHNpZ25pbmcgc2V0IG1vZHVsZSBwYXJhbWV0ZXIKImVuYWJsZV9uZWdvdGlhdGVfc2ln
bmluZyIgdG8gMS4KClJldmlld2VkLWJ5OiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhh
dC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNv
bT4KLS0tCiBmcy9jaWZzL2NpZnNmcy5jICAgfCAgNCArKysKIGZzL2NpZnMvY2lmc2dsb2IuaCB8
ICAzICsrCiBmcy9jaWZzL3NtYjJwZHUuYyAgfCA4NiArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tCiBmcy9jaWZzL3NtYjJwZHUuaCAgfCAgNSArKy0KIDQgZmls
ZXMgY2hhbmdlZCwgODcgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXggOWZiODc0ZGQ4ZDI0
Li40NzZiMDcyMTNmY2QgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lm
cy9jaWZzZnMuYwpAQCAtNjUsNiArNjUsNyBAQCBib29sIGxvb2t1cENhY2hlRW5hYmxlZCA9IHRy
dWU7CiBib29sIGRpc2FibGVfbGVnYWN5X2RpYWxlY3RzOyAvKiBmYWxzZSBieSBkZWZhdWx0ICov
CiBib29sIGVuYWJsZV9nY21fMjU2ID0gdHJ1ZTsKIGJvb2wgcmVxdWlyZV9nY21fMjU2OyAvKiBm
YWxzZSBieSBkZWZhdWx0ICovCitib29sIGVuYWJsZV9uZWdvdGlhdGVfc2lnbmluZzsgLyogZmFs
c2UgYnkgZGVmYXVsdCAqLwogdW5zaWduZWQgaW50IGdsb2JhbF9zZWNmbGFncyA9IENJRlNTRUNf
REVGOwogLyogdW5zaWduZWQgaW50IG50bG12Ml9zdXBwb3J0ID0gMDsgKi8KIHVuc2lnbmVkIGlu
dCBzaWduX0NJRlNfUERVcyA9IDE7CkBAIC0xMDQsNiArMTA1LDkgQEAgTU9EVUxFX1BBUk1fREVT
QyhlbmFibGVfZ2NtXzI1NiwgIkVuYWJsZSByZXF1ZXN0aW5nIHN0cm9uZ2VzdCAoMjU2IGJpdCkg
R0NNIGVuY3IKIG1vZHVsZV9wYXJhbShyZXF1aXJlX2djbV8yNTYsIGJvb2wsIDA2NDQpOwogTU9E
VUxFX1BBUk1fREVTQyhyZXF1aXJlX2djbV8yNTYsICJSZXF1aXJlIHN0cm9uZ2VzdCAoMjU2IGJp
dCkgR0NNIGVuY3J5cHRpb24uIERlZmF1bHQ6IG4vTi8wIik7CiAKK21vZHVsZV9wYXJhbShlbmFi
bGVfbmVnb3RpYXRlX3NpZ25pbmcsIGJvb2wsIDA2NDQpOworTU9EVUxFX1BBUk1fREVTQyhlbmFi
bGVfbmVnb3RpYXRlX3NpZ25pbmcsICJFbmFibGUgbmVnb3RpYXRpbmcgcGFja2V0IHNpZ25pbmcg
YWxnb3JpdGhtIHdpdGggc2VydmVyLiBEZWZhdWx0OiBuL04vMCIpOworCiBtb2R1bGVfcGFyYW0o
ZGlzYWJsZV9sZWdhY3lfZGlhbGVjdHMsIGJvb2wsIDA2NDQpOwogTU9EVUxFX1BBUk1fREVTQyhk
aXNhYmxlX2xlZ2FjeV9kaWFsZWN0cywgIlRvIGltcHJvdmUgc2VjdXJpdHkgaXQgbWF5IGJlICIK
IAkJCQkgICJoZWxwZnVsIHRvIHJlc3RyaWN0IHRoZSBhYmlsaXR5IHRvICIKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCA5MjE2ODBmYjc5
MzEuLjNjMmUxMTdiYjkyNiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2Zz
L2NpZnMvY2lmc2dsb2IuaApAQCAtNjY3LDkgKzY2NywxMSBAQCBzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvIHsKIAl1bnNpZ25lZCBpbnQJbWF4X3dyaXRlOwogCXVuc2lnbmVkIGludAltaW5fb2ZmbG9h
ZDsKIAlfX2xlMTYJY29tcHJlc3NfYWxnb3JpdGhtOworCV9fdTE2CXNpZ25pbmdfYWxnb3JpdGht
OwogCV9fbGUxNgljaXBoZXJfdHlwZTsKIAkgLyogc2F2ZSBpbml0aXRhbCBuZWdwcm90IGhhc2gg
Ki8KIAlfX3U4CXByZWF1dGhfc2hhX2hhc2hbU01CMl9QUkVBVVRIX0hBU0hfU0laRV07CisJYm9v
bAlzaWduaW5nX25lZ290aWF0ZWQ7IC8qIHRydWUgaWYgdmFsaWQgc2lnbmluZyBjb250ZXh0IHJj
dmQgZnJvbSBzZXJ2ZXIgKi8KIAlib29sCXBvc2l4X2V4dF9zdXBwb3J0ZWQ7CiAJc3RydWN0IGRl
bGF5ZWRfd29yayByZWNvbm5lY3Q7IC8qIHJlY29ubmVjdCB3b3JrcXVldWUgam9iICovCiAJc3Ry
dWN0IG11dGV4IHJlY29ubmVjdF9tdXRleDsgLyogcHJldmVudCBzaW11bHRhbmVvdXMgcmVjb25u
ZWN0cyAqLwpAQCAtMTg2OSw2ICsxODcxLDcgQEAgZXh0ZXJuIHVuc2lnbmVkIGludCBnbG9iYWxf
c2VjZmxhZ3M7CS8qIGlmIG9uLCBzZXNzaW9uIHNldHVwIHNlbnQKIGV4dGVybiB1bnNpZ25lZCBp
bnQgc2lnbl9DSUZTX1BEVXM7ICAvKiBlbmFibGUgc21iIHBhY2tldCBzaWduaW5nICovCiBleHRl
cm4gYm9vbCBlbmFibGVfZ2NtXzI1NjsgLyogYWxsb3cgb3B0aW9uYWwgbmVnb3RpYXRlIG9mIHN0
cm9uZ2VzdCBzaWduaW5nIChhZXMtZ2NtLTI1NikgKi8KIGV4dGVybiBib29sIHJlcXVpcmVfZ2Nt
XzI1NjsgLyogcmVxdWlyZSB1c2Ugb2Ygc3Ryb25nZXN0IHNpZ25pbmcgKGFlcy1nY20tMjU2KSAq
LworZXh0ZXJuIGJvb2wgZW5hYmxlX25lZ290aWF0ZV9zaWduaW5nOyAvKiByZXF1ZXN0IHVzZSBv
ZiBmYXN0ZXIgKEdNQUMpIHNpZ25pbmcgaWYgYXZhaWxhYmxlICovCiBleHRlcm4gYm9vbCBsaW51
eEV4dEVuYWJsZWQ7LyplbmFibGUgTGludXgvVW5peCBDSUZTIGV4dGVuc2lvbnMqLwogZXh0ZXJu
IHVuc2lnbmVkIGludCBDSUZTTWF4QnVmU2l6ZTsgIC8qIG1heCBzaXplIG5vdCBpbmNsdWRpbmcg
aGRyICovCiBleHRlcm4gdW5zaWduZWQgaW50IGNpZnNfbWluX3JjdjsgICAgLyogbWluIHNpemUg
b2YgYmlnIG50d3JrIGJ1ZiBwb29sICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBi
L2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDk2MjgyNmRjMzMxNi4uYzFlNzZlYjEyMTA5IDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtNDMz
LDYgKzQzMywyOSBAQCBidWlsZF9jb21wcmVzc2lvbl9jdHh0KHN0cnVjdCBzbWIyX2NvbXByZXNz
aW9uX2NhcGFiaWxpdGllc19jb250ZXh0ICpwbmVnX2N0eHQpCiAJcG5lZ19jdHh0LT5Db21wcmVz
c2lvbkFsZ29yaXRobXNbMl0gPSBTTUIzX0NPTVBSRVNTX0xaTlQxOwogfQogCitzdGF0aWMgdW5z
aWduZWQgaW50CitidWlsZF9zaWduaW5nX2N0eHQoc3RydWN0IHNtYjJfc2lnbmluZ19jYXBhYmls
aXRpZXMgKnBuZWdfY3R4dCkKK3sKKwl1bnNpZ25lZCBpbnQgY3R4dF9sZW4gPSBzaXplb2Yoc3Ry
dWN0IHNtYjJfc2lnbmluZ19jYXBhYmlsaXRpZXMpOworCXVuc2lnbmVkIHNob3J0IG51bV9hbGdz
ID0gMTsgLyogbnVtYmVyIG9mIHNpZ25pbmcgYWxnb3JpdGhtcyBzZW50ICovCisKKwlwbmVnX2N0
eHQtPkNvbnRleHRUeXBlID0gU01CMl9TSUdOSU5HX0NBUEFCSUxJVElFUzsKKwkvKgorCSAqIENv
bnRleHQgRGF0YSBsZW5ndGggbXVzdCBiZSByb3VuZGVkIHRvIG11bHRpcGxlIG9mIDggZm9yIHNv
bWUgc2VydmVycworCSAqLworCXBuZWdfY3R4dC0+RGF0YUxlbmd0aCA9IGNwdV90b19sZTE2KERJ
Vl9ST1VORF9VUCgKKwkJCQlzaXplb2Yoc3RydWN0IHNtYjJfc2lnbmluZ19jYXBhYmlsaXRpZXMp
IC0KKwkJCQlzaXplb2Yoc3RydWN0IHNtYjJfbmVnX2NvbnRleHQpICsKKwkJCQkobnVtX2FsZ3Mg
KiAyIC8qIHNpemVvZiB1MTYgKi8pLCA4KSAqIDgpOworCXBuZWdfY3R4dC0+U2lnbmluZ0FsZ29y
aXRobUNvdW50ID0gY3B1X3RvX2xlMTYobnVtX2FsZ3MpOworCXBuZWdfY3R4dC0+U2lnbmluZ0Fs
Z29yaXRobXNbMF0gPSBjcHVfdG9fbGUxNihTSUdOSU5HX0FMR19BRVNfQ01BQyk7CisKKwljdHh0
X2xlbiArPSAyIC8qIHNpemVvZiBsZTE2ICovICogbnVtX2FsZ3M7CisJY3R4dF9sZW4gPSBESVZf
Uk9VTkRfVVAoY3R4dF9sZW4sIDgpICogODsKKwlyZXR1cm4gY3R4dF9sZW47CisJLyogVEJEIGFk
ZCBTSUdOSU5HX0FMR19BRVNfR01BQyBhbmQvb3IgU0lHTklOR19BTEdfSE1BQ19TSEEyNTYgKi8K
K30KKwogc3RhdGljIHZvaWQKIGJ1aWxkX2VuY3J5cHRfY3R4dChzdHJ1Y3Qgc21iMl9lbmNyeXB0
aW9uX25lZ19jb250ZXh0ICpwbmVnX2N0eHQpCiB7CkBAIC00OTgsNyArNTIxLDcgQEAgYXNzZW1i
bGVfbmVnX2NvbnRleHRzKHN0cnVjdCBzbWIyX25lZ290aWF0ZV9yZXEgKnJlcSwKIAkJICAgICAg
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCB1bnNpZ25lZCBpbnQgKnRvdGFsX2xlbikK
IHsKIAljaGFyICpwbmVnX2N0eHQ7Ci0JdW5zaWduZWQgaW50IGN0eHRfbGVuOworCXVuc2lnbmVk
IGludCBjdHh0X2xlbiwgbmVnX2NvbnRleHRfY291bnQ7CiAKIAlpZiAoKnRvdGFsX2xlbiA+IDIw
MCkgewogCQkvKiBJbiBjYXNlIGxlbmd0aCBjb3JydXB0ZWQgZG9uJ3Qgd2FudCB0byBvdmVycnVu
IHNtYiBidWZmZXIgKi8KQEAgLTUyNSw2ICs1NDgsMTcgQEAgYXNzZW1ibGVfbmVnX2NvbnRleHRz
KHN0cnVjdCBzbWIyX25lZ290aWF0ZV9yZXEgKnJlcSwKIAkqdG90YWxfbGVuICs9IGN0eHRfbGVu
OwogCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKIAorCWN0eHRfbGVuID0gYnVpbGRfbmV0bmFtZV9j
dHh0KChzdHJ1Y3Qgc21iMl9uZXRuYW1lX25lZ19jb250ZXh0ICopcG5lZ19jdHh0LAorCQkJCQlz
ZXJ2ZXItPmhvc3RuYW1lKTsKKwkqdG90YWxfbGVuICs9IGN0eHRfbGVuOworCXBuZWdfY3R4dCAr
PSBjdHh0X2xlbjsKKworCWJ1aWxkX3Bvc2l4X2N0eHQoKHN0cnVjdCBzbWIyX3Bvc2l4X25lZ19j
b250ZXh0ICopcG5lZ19jdHh0KTsKKwkqdG90YWxfbGVuICs9IHNpemVvZihzdHJ1Y3Qgc21iMl9w
b3NpeF9uZWdfY29udGV4dCk7CisJcG5lZ19jdHh0ICs9IHNpemVvZihzdHJ1Y3Qgc21iMl9wb3Np
eF9uZWdfY29udGV4dCk7CisKKwluZWdfY29udGV4dF9jb3VudCA9IDQ7CisKIAlpZiAoc2VydmVy
LT5jb21wcmVzc19hbGdvcml0aG0pIHsKIAkJYnVpbGRfY29tcHJlc3Npb25fY3R4dCgoc3RydWN0
IHNtYjJfY29tcHJlc3Npb25fY2FwYWJpbGl0aWVzX2NvbnRleHQgKikKIAkJCQlwbmVnX2N0eHQp
OwpAQCAtNTMzLDE3ICs1NjcsMjEgQEAgYXNzZW1ibGVfbmVnX2NvbnRleHRzKHN0cnVjdCBzbWIy
X25lZ290aWF0ZV9yZXEgKnJlcSwKIAkJCQk4KSAqIDg7CiAJCSp0b3RhbF9sZW4gKz0gY3R4dF9s
ZW47CiAJCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKLQkJcmVxLT5OZWdvdGlhdGVDb250ZXh0Q291
bnQgPSBjcHVfdG9fbGUxNig1KTsKLQl9IGVsc2UKLQkJcmVxLT5OZWdvdGlhdGVDb250ZXh0Q291
bnQgPSBjcHVfdG9fbGUxNig0KTsKKwkJbmVnX2NvbnRleHRfY291bnQrKzsKKwl9CiAKLQljdHh0
X2xlbiA9IGJ1aWxkX25ldG5hbWVfY3R4dCgoc3RydWN0IHNtYjJfbmV0bmFtZV9uZWdfY29udGV4
dCAqKXBuZWdfY3R4dCwKLQkJCQkJc2VydmVyLT5ob3N0bmFtZSk7Ci0JKnRvdGFsX2xlbiArPSBj
dHh0X2xlbjsKLQlwbmVnX2N0eHQgKz0gY3R4dF9sZW47CisJaWYgKGVuYWJsZV9uZWdvdGlhdGVf
c2lnbmluZykgeworCQlwcl93YXJuX29uY2UoInJlcXVlc3RpbmcgR01BQyBzaWduaW5nIGlzIGV4
cGVyaW1lbnRhbFxuIik7CisJCWN0eHRfbGVuID0gYnVpbGRfc2lnbmluZ19jdHh0KChzdHJ1Y3Qg
c21iMl9zaWduaW5nX2NhcGFiaWxpdGllcyAqKQorCQkJCXBuZWdfY3R4dCk7CisJCSp0b3RhbF9s
ZW4gKz0gY3R4dF9sZW47CisJCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKKwkJbmVnX2NvbnRleHRf
Y291bnQrKzsKKwl9CisKKwkvKiBjaGVjayBmb3IgYW5kIGFkZCB0cmFuc3BvcnRfY2FwYWJpbGl0
aWVzIGFuZCBzaWduaW5nIGNhcGFiaWxpdGllcyAqLworCXJlcS0+TmVnb3RpYXRlQ29udGV4dENv
dW50ID0gY3B1X3RvX2xlMTYobmVnX2NvbnRleHRfY291bnQpOwogCi0JYnVpbGRfcG9zaXhfY3R4
dCgoc3RydWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQpOwotCSp0b3RhbF9s
ZW4gKz0gc2l6ZW9mKHN0cnVjdCBzbWIyX3Bvc2l4X25lZ19jb250ZXh0KTsKIH0KIAogc3RhdGlj
IHZvaWQgZGVjb2RlX3ByZWF1dGhfY29udGV4dChzdHJ1Y3Qgc21iMl9wcmVhdXRoX25lZ19jb250
ZXh0ICpjdHh0KQpAQCAtNjMyLDYgKzY3MCwzMSBAQCBzdGF0aWMgaW50IGRlY29kZV9lbmNyeXB0
X2N0eChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJcmV0dXJuIDA7CiB9CiAKK3N0
YXRpYyB2b2lkIGRlY29kZV9zaWduaW5nX2N0eChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2
ZXIsCisJCQkgICAgICAgc3RydWN0IHNtYjJfc2lnbmluZ19jYXBhYmlsaXRpZXMgKnBjdHh0KQor
eworCXVuc2lnbmVkIGludCBsZW4gPSBsZTE2X3RvX2NwdShwY3R4dC0+RGF0YUxlbmd0aCk7CisK
KwlpZiAoKGxlbiA8IDQpIHx8IChsZW4gPiAxNikpIHsKKwkJcHJfd2Fybl9vbmNlKCJzZXJ2ZXIg
c2VudCBiYWQgc2lnbmluZyBuZWdjb250ZXh0XG4iKTsKKwkJcmV0dXJuOworCX0KKwlpZiAobGUx
Nl90b19jcHUocGN0eHQtPlNpZ25pbmdBbGdvcml0aG1Db3VudCkgIT0gMSkgeworCQlwcl93YXJu
X29uY2UoIkludmFsaWQgc2lnbmluZyBhbGdvcml0aG0gY291bnRcbiIpOworCQlyZXR1cm47CisJ
fQorCWlmIChsZTE2X3RvX2NwdShwY3R4dC0+U2lnbmluZ0FsZ29yaXRobXNbMF0pID4gMikgewor
CQlwcl93YXJuX29uY2UoInVua25vd24gc2lnbmluZyBhbGdvcml0aG1cbiIpOworCQlyZXR1cm47
CisJfQorCisJc2VydmVyLT5zaWduaW5nX25lZ290aWF0ZWQgPSB0cnVlOworCXNlcnZlci0+c2ln
bmluZ19hbGdvcml0aG0gPSBsZTE2X3RvX2NwdShwY3R4dC0+U2lnbmluZ0FsZ29yaXRobXNbMF0p
OworCWNpZnNfZGJnKEZZSSwgInNpZ25pbmcgYWxnb3JpdGhtICVkIGNob3NlblxuIiwKKwkJICAg
ICBzZXJ2ZXItPnNpZ25pbmdfYWxnb3JpdGhtKTsKK30KKworCiBzdGF0aWMgaW50IHNtYjMxMV9k
ZWNvZGVfbmVnX2NvbnRleHQoc3RydWN0IHNtYjJfbmVnb3RpYXRlX3JzcCAqcnNwLAogCQkJCSAg
ICAgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAogCQkJCSAgICAgdW5zaWduZWQgaW50
IGxlbl9vZl9zbWIpCkBAIC02NzUsNiArNzM4LDkgQEAgc3RhdGljIGludCBzbWIzMTFfZGVjb2Rl
X25lZ19jb250ZXh0KHN0cnVjdCBzbWIyX25lZ290aWF0ZV9yc3AgKnJzcCwKIAkJCQkoc3RydWN0
IHNtYjJfY29tcHJlc3Npb25fY2FwYWJpbGl0aWVzX2NvbnRleHQgKilwY3R4KTsKIAkJZWxzZSBp
ZiAocGN0eC0+Q29udGV4dFR5cGUgPT0gU01CMl9QT1NJWF9FWFRFTlNJT05TX0FWQUlMQUJMRSkK
IAkJCXNlcnZlci0+cG9zaXhfZXh0X3N1cHBvcnRlZCA9IHRydWU7CisJCWVsc2UgaWYgKHBjdHgt
PkNvbnRleHRUeXBlID09IFNNQjJfU0lHTklOR19DQVBBQklMSVRJRVMpCisJCQlkZWNvZGVfc2ln
bmluZ19jdHgoc2VydmVyLAorCQkJCShzdHJ1Y3Qgc21iMl9zaWduaW5nX2NhcGFiaWxpdGllcyAq
KXBjdHgpOwogCQllbHNlCiAJCQljaWZzX3NlcnZlcl9kYmcoVkZTLCAidW5rbm93biBuZWdjb250
ZXh0IG9mIHR5cGUgJWQgaWdub3JlZFxuIiwKIAkJCQlsZTE2X3RvX2NwdShwY3R4LT5Db250ZXh0
VHlwZSkpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmggYi9mcy9jaWZzL3NtYjJwZHUu
aAppbmRleCBiYTc1ZTY1OTI0YWMuLjRiMjdjYjkxMDVmZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9z
bWIycGR1LmgKKysrIGIvZnMvY2lmcy9zbWIycGR1LmgKQEAgLTMyOSw3ICszMjksNyBAQCBzdHJ1
Y3Qgc21iMl9uZWdfY29udGV4dCB7CiAJX19sZTE2CUNvbnRleHRUeXBlOwogCV9fbGUxNglEYXRh
TGVuZ3RoOwogCV9fbGUzMglSZXNlcnZlZDsKLQkvKiBGb2xsb3dlZCBieSBhcnJheSBvZiBkYXRh
ICovCisJLyogRm9sbG93ZWQgYnkgYXJyYXkgb2YgZGF0YS4gTk9URTogc29tZSBzZXJ2ZXJzIHJl
cXVpcmUgcGFkZGluZyB0byA4IGJ5dGUgYm91bmRhcnkgKi8KIH0gX19wYWNrZWQ7CiAKICNkZWZp
bmUgU01CMzExX0xJTlVYX0NMSUVOVF9TQUxUX1NJWkUJCQkzMgpAQCAtMzk0LDYgKzM5NCw3IEBA
IHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19jb250ZXh0IHsKIAlfX3UxNglQ
YWRkaW5nOwogCV9fdTMyCUZsYWdzOwogCV9fbGUxNglDb21wcmVzc2lvbkFsZ29yaXRobXNbM107
CisJLyogQ2hlY2sgaWYgcGFkIG5lZWRlZCAqLwogfSBfX3BhY2tlZDsKIAogLyoKQEAgLTQyMCw2
ICs0MjEsNyBAQCBzdHJ1Y3Qgc21iMl90cmFuc3BvcnRfY2FwYWJpbGl0aWVzX2NvbnRleHQgewog
CV9fbGUxNiAgRGF0YUxlbmd0aDsKIAlfX3UzMglSZXNlcnZlZDsKIAlfX2xlMzIJRmxhZ3M7CisJ
X191MzIJUGFkOwogfSBfX3BhY2tlZDsKIAogLyoKQEAgLTQ1OCw2ICs0NjAsNyBAQCBzdHJ1Y3Qg
c21iMl9zaWduaW5nX2NhcGFiaWxpdGllcyB7CiAJX191MzIJUmVzZXJ2ZWQ7CiAJX19sZTE2CVNp
Z25pbmdBbGdvcml0aG1Db3VudDsKIAlfX2xlMTYJU2lnbmluZ0FsZ29yaXRobXNbXTsKKwkvKiAg
Rm9sbG93ZWQgYnkgcGFkZGluZyB0byA4IGJ5dGUgYm91bmRhcnkgKHJlcXVpcmVkIGJ5IHNvbWUg
c2VydmVycykgKi8KIH0gX19wYWNrZWQ7CiAKICNkZWZpbmUgUE9TSVhfQ1RYVF9EQVRBX0xFTgkx
NgotLSAKMi4zMC4yCgo=
--000000000000350e1d05c6a5199c--
