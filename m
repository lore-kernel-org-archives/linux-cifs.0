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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06FDC07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 22:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B7D461606
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 22:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhGHWIs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 18:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhGHWIs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 18:08:48 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643F9C061574
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 15:06:04 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id l2so10771475edt.1
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jul 2021 15:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zjlUxCEXCla3s0h8/HKMWS7eXeaqk+ELl4tes981/VA=;
        b=ZKpEn/jBImj7uxgFbhi/VOytnG7u7Yx58XAzZgvVvGhVEG8YSn6wsBSRetFQ+Fr1GG
         Qvoo5JUlMg4AXFJPZV9jgrLHWKX6EB20xUI40Csq03XSQGYw8j5ISnhG/Jgq8ICXsqfB
         jR3aiYgoBEzwVYtjb8lE5neg85iIpc0L1QSkUW/usRMV/DnDJWhGsNVT2+6vLcOQgGbr
         TOlGBFW75ppR4Fg3y8tpQVO0aDQbmxXywBWLZ6fcomg/2eXnwmXf+5LcY6toFHNXxaIq
         RUliQgDOG1rWw6uygsqbU8IhK3OuY0WgDmLYgr2SATHifHYYZYGY7wjfjeZcmyX2EJeI
         Y7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zjlUxCEXCla3s0h8/HKMWS7eXeaqk+ELl4tes981/VA=;
        b=Zg3qRXvtnB9JD06KjxVVUF94I6aYAJDQ3QPefcTWQeXT/avg31NLTwXYpeeK+31Nrq
         PgRq/J6fVdwT5XvLM2+F10F6eic4L76lPOoGyT8wbtWf0P5iNuCQinP1Rn9ytOBWXjLj
         /aB7Qpa5VCIxUW7hnkiEM74+PNlWYT6HcmjXoJ+eSmx6eZaVo6Zygy7bABXGvgtylIBM
         ijgOcvHvt25Q27vuq9Jn30CpJp8RuSEIvIpQoyHdGCDjRKP9kzED9vGGDeghfu9e1bYO
         6kIvWSpqjDxDaIpsTP1/LU8iVcVUaU5p2gaHfsEDmh3rbb69GdfT9B3nJjG4jz0MNnfB
         gPQA==
X-Gm-Message-State: AOAM531v20SKEujLzuFBks8muwtDnOy6f2j3j+RDaRBVz+nZ2QcyIxHn
        H2agkVjxkZ2QClogAHgDoER4Qtq0VzpaEhEAZA==
X-Google-Smtp-Source: ABdhPJwR2fRY5o7dcgb85XSPTG/rz5MGO1j7dK/AP20ew4vmx2iOGeRhNv7UIywPokl/E71WiREzFlXtU5HlETAeldg=
X-Received: by 2002:a05:6402:3181:: with SMTP id di1mr41272739edb.211.1625781962730;
 Thu, 08 Jul 2021 15:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvS6aHG8dXBre0RuGPzUb0g1hh-OPnhEup9PrX5z0zv5g@mail.gmail.com>
 <CAH2r5mu_fVutwr+XY8i-EpWO9gTw+dvHoy1oFk_wxHeMuVgxqA@mail.gmail.com>
 <CAH2r5mstq3L33-RBDrJ+0Z1K2PAP0z=5bm=wQ8XHdx4th_caFw@mail.gmail.com> <CAN05THSBo74HOMYV+mHejb1s4tAb_uv=8cmcO1UDRScFw-WUQg@mail.gmail.com>
In-Reply-To: <CAN05THSBo74HOMYV+mHejb1s4tAb_uv=8cmcO1UDRScFw-WUQg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 8 Jul 2021 15:05:51 -0700
Message-ID: <CAKywueR0JE9-a8Gs-bxvDQgmDNzpm=sodpWc7rXaG58WR1EZiQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] add ability to send signing negotiate context
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

@@ -104,6 +105,9 @@ MODULE_PARM_DESC(enable_gcm_256, "Enable
requesting strongest (256 bit) GCM encr
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM
encryption. Default: n/N/0");

+module_param(enable_negotiate_signing, bool, 0644);
+MODULE_PARM_DESC(enable_GMAC_signing, "Enable requesting faster
(GMAC) packet signing. Default: n/N/0");
+

s/enable_GMAC_signing/enable_negotiate_signing/ ?

Also the description here is misleading: this param enables sending
the signing context not requesting GMAC which is not supported yet.


+    if (enable_negotiate_signing) {
+        pr_warn_once("requesting GMAC signing is experimental\n");

Here as well - we are not requesting GMAC here, we are sending the
signing context with CMAC. I don't think this should be marked as
experimental.

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 7 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 21:52, ronnie sahlb=
erg <ronniesahlberg@gmail.com>:
>
> lgtm
>
> On Thu, Jul 8, 2021 at 2:49 PM Steve French <smfrench@gmail.com> wrote:
> >
> > v4 of patch (includes minor change to set local variable "num_algs"
> > once to number of algorithms and use that throughout
> > build_signing_context to make code a little clearer)
> >
> >
> > On Wed, Jul 7, 2021 at 11:27 PM Steve French <smfrench@gmail.com> wrote=
:
> > >
> > > v3 of patch.  Updated with additional feedback from Ronnie (to make i=
t
> > > more context len and datalength clearer)
> > >
> > >
> > > On Wed, Jul 7, 2021 at 9:44 PM Steve French <smfrench@gmail.com> wrot=
e:
> > > >
> > > > Support for faster packet signing (using GMAC instead of CMAC) can
> > > > now be negotiated to some newer servers, including Windows.
> > > > See MS-SMB2 section 2.2.3.17.
> > > >
> > > > This patch adds support for sending the new negotiate context
> > > > with the first of three supported signing algorithms (AES-CMAC)
> > > > and decoding the response.  A followon patch will add support
> > > > for sending the other two (including AES-GMAC, which is fastest)
> > > > and changing the signing algorithm used based on what was
> > > > negotiated.
> > > >
> > > > To allow the client to request GMAC signing set module parameter
> > > > "enable_negotiate_signing" to 1.
> > > >
> > > > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > > ---
> > > >  fs/cifs/cifsfs.c   |  4 +++
> > > >  fs/cifs/cifsglob.h |  3 ++
> > > >  fs/cifs/smb2pdu.c  | 83 ++++++++++++++++++++++++++++++++++++++++--=
----
> > > >  fs/cifs/smb2pdu.h  |  5 ++-
> > > >  4 files changed, 84 insertions(+), 11 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > > index 9fb874dd8d24..476b07213fcd 100644
> > > > --- a/fs/cifs/cifsfs.c
> > > > +++ b/fs/cifs/cifsfs.c
> > > > @@ -65,6 +65,7 @@ bool lookupCacheEnabled =3D true;
> > > >  bool disable_legacy_dialects; /* false by default */
> > > >  bool enable_gcm_256 =3D true;
> > > >  bool require_gcm_256; /* false by default */
> > > > +bool enable_negotiate_signing; /* false by default */
> > > >  unsigned int global_secflags =3D CIFSSEC_DEF;
> > > >  /* unsigned int ntlmv2_support =3D 0; */
> > > >  unsigned int sign_CIFS_PDUs =3D 1;
> > > > @@ -104,6 +105,9 @@ MODULE_PARM_DESC(enable_gcm_256, "Enable
> > > > requesting strongest (256 bit) GCM encr
> > > >  module_param(require_gcm_256, bool, 0644);
> > > >  MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM
> > > > encryption. Default: n/N/0");
> > > >
> > > > +module_param(enable_negotiate_signing, bool, 0644);
> > > > +MODULE_PARM_DESC(enable_GMAC_signing, "Enable requesting faster
> > > > (GMAC) packet signing. Default: n/N/0");
> > > > +
> > > >  module_param(disable_legacy_dialects, bool, 0644);
> > > >  MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it =
may be "
> > > >     "helpful to restrict the ability to "
> > > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > > index 921680fb7931..3c2e117bb926 100644
> > > > --- a/fs/cifs/cifsglob.h
> > > > +++ b/fs/cifs/cifsglob.h
> > > > @@ -667,9 +667,11 @@ struct TCP_Server_Info {
> > > >   unsigned int max_write;
> > > >   unsigned int min_offload;
> > > >   __le16 compress_algorithm;
> > > > + __u16 signing_algorithm;
> > > >   __le16 cipher_type;
> > > >   /* save initital negprot hash */
> > > >   __u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
> > > > + bool signing_negotiated; /* true if valid signing context rcvd fr=
om server */
> > > >   bool posix_ext_supported;
> > > >   struct delayed_work reconnect; /* reconnect workqueue job */
> > > >   struct mutex reconnect_mutex; /* prevent simultaneous reconnects =
*/
> > > > @@ -1869,6 +1871,7 @@ extern unsigned int global_secflags; /* if on=
,
> > > > session setup sent
> > > >  extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing =
*/
> > > >  extern bool enable_gcm_256; /* allow optional negotiate of stronge=
st
> > > > signing (aes-gcm-256) */
> > > >  extern bool require_gcm_256; /* require use of strongest signing
> > > > (aes-gcm-256) */
> > > > +extern bool enable_negotiate_signing; /* request use of faster (GM=
AC)
> > > > signing if available */
> > > >  extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
> > > >  extern unsigned int CIFSMaxBufSize;  /* max size not including hdr=
 */
> > > >  extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf =
pool */
> > > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > > > index 962826dc3316..757f145e70e5 100644
> > > > --- a/fs/cifs/smb2pdu.c
> > > > +++ b/fs/cifs/smb2pdu.c
> > > > @@ -433,6 +433,23 @@ build_compression_ctxt(struct
> > > > smb2_compression_capabilities_context *pneg_ctxt)
> > > >   pneg_ctxt->CompressionAlgorithms[2] =3D SMB3_COMPRESS_LZNT1;
> > > >  }
> > > >
> > > > +static void
> > > > +build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
> > > > +{
> > > > + pneg_ctxt->ContextType =3D SMB2_SIGNING_CAPABILITIES;
> > > > + /*
> > > > + * Data length must be increased here if more than 3 signing algor=
ithms
> > > > + * sent but currently only 3 are defined. And context Data length =
must
> > > > + * be rounded to multiple of 8 for some servers.
> > > > + */
> > > > + pneg_ctxt->DataLength =3D
> > > > + cpu_to_le16(DIV_ROUND_UP(sizeof(struct smb2_signing_capabilities)=
 -
> > > > + sizeof(struct smb2_neg_context), 8) * 8);
> > > > + pneg_ctxt->SigningAlgorithmCount =3D cpu_to_le16(1);
> > > > + pneg_ctxt->SigningAlgorithms[0] =3D cpu_to_le16(SIGNING_ALG_AES_C=
MAC);
> > > > + /* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA256 */
> > > > +}
> > > > +
> > > >  static void
> > > >  build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
> > > >  {
> > > > @@ -498,7 +515,7 @@ assemble_neg_contexts(struct smb2_negotiate_req=
 *req,
> > > >         struct TCP_Server_Info *server, unsigned int *total_len)
> > > >  {
> > > >   char *pneg_ctxt;
> > > > - unsigned int ctxt_len;
> > > > + unsigned int ctxt_len, neg_context_count;
> > > >
> > > >   if (*total_len > 200) {
> > > >   /* In case length corrupted don't want to overrun smb buffer */
> > > > @@ -525,6 +542,17 @@ assemble_neg_contexts(struct smb2_negotiate_re=
q *req,
> > > >   *total_len +=3D ctxt_len;
> > > >   pneg_ctxt +=3D ctxt_len;
> > > >
> > > > + ctxt_len =3D build_netname_ctxt((struct smb2_netname_neg_context =
*)pneg_ctxt,
> > > > + server->hostname);
> > > > + *total_len +=3D ctxt_len;
> > > > + pneg_ctxt +=3D ctxt_len;
> > > > +
> > > > + build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
> > > > + *total_len +=3D sizeof(struct smb2_posix_neg_context);
> > > > + pneg_ctxt +=3D sizeof(struct smb2_posix_neg_context);
> > > > +
> > > > + neg_context_count =3D 4;
> > > > +
> > > >   if (server->compress_algorithm) {
> > > >   build_compression_ctxt((struct smb2_compression_capabilities_cont=
ext *)
> > > >   pneg_ctxt);
> > > > @@ -533,17 +561,24 @@ assemble_neg_contexts(struct smb2_negotiate_r=
eq *req,
> > > >   8) * 8;
> > > >   *total_len +=3D ctxt_len;
> > > >   pneg_ctxt +=3D ctxt_len;
> > > > - req->NegotiateContextCount =3D cpu_to_le16(5);
> > > > - } else
> > > > - req->NegotiateContextCount =3D cpu_to_le16(4);
> > > > + neg_context_count++;
> > > > + }
> > > >
> > > > - ctxt_len =3D build_netname_ctxt((struct smb2_netname_neg_context =
*)pneg_ctxt,
> > > > - server->hostname);
> > > > - *total_len +=3D ctxt_len;
> > > > - pneg_ctxt +=3D ctxt_len;
> > > > + if (enable_negotiate_signing) {
> > > > + pr_warn_once("requesting GMAC signing is experimental\n");
> > > > + build_signing_ctxt((struct smb2_signing_capabilities *)
> > > > + pneg_ctxt);
> > > > + ctxt_len =3D DIV_ROUND_UP(
> > > > + sizeof(struct smb2_signing_capabilities),
> > > > + 8) * 8;
> > > > + *total_len +=3D ctxt_len;
> > > > + pneg_ctxt +=3D ctxt_len;
> > > > + neg_context_count++;
> > > > + }
> > > > +
> > > > + /* check for and add transport_capabilities and signing capabilit=
ies */
> > > > + req->NegotiateContextCount =3D cpu_to_le16(neg_context_count);
> > > >
> > > > - build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
> > > > - *total_len +=3D sizeof(struct smb2_posix_neg_context);
> > > >  }
> > > >
> > > >  static void decode_preauth_context(struct smb2_preauth_neg_context=
 *ctxt)
> > > > @@ -632,6 +667,31 @@ static int decode_encrypt_ctx(struct
> > > > TCP_Server_Info *server,
> > > >   return 0;
> > > >  }
> > > >
> > > > +static void decode_signing_ctx(struct TCP_Server_Info *server,
> > > > +        struct smb2_signing_capabilities *pctxt)
> > > > +{
> > > > + unsigned int len =3D le16_to_cpu(pctxt->DataLength);
> > > > +
> > > > + if ((len < 4) || (len > 16)) {
> > > > + pr_warn_once("server sent bad signing negcontext\n");
> > > > + return;
> > > > + }
> > > > + if (le16_to_cpu(pctxt->SigningAlgorithmCount) !=3D 1) {
> > > > + pr_warn_once("Invalid signing algorithm count\n");
> > > > + return;
> > > > + }
> > > > + if (le16_to_cpu(pctxt->SigningAlgorithms[0]) > 2) {
> > > > + pr_warn_once("unknown signing algorithm\n");
> > > > + return;
> > > > + }
> > > > +
> > > > + server->signing_negotiated =3D true;
> > > > + server->signing_algorithm =3D le16_to_cpu(pctxt->SigningAlgorithm=
s[0]);
> > > > + cifs_dbg(FYI, "signing algorithm %d chosen\n",
> > > > +      server->signing_algorithm);
> > > > +}
> > > > +
> > > > +
> > > >  static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rs=
p,
> > > >        struct TCP_Server_Info *server,
> > > >        unsigned int len_of_smb)
> > > > @@ -675,6 +735,9 @@ static int smb311_decode_neg_context(struct
> > > > smb2_negotiate_rsp *rsp,
> > > >   (struct smb2_compression_capabilities_context *)pctx);
> > > >   else if (pctx->ContextType =3D=3D SMB2_POSIX_EXTENSIONS_AVAILABLE=
)
> > > >   server->posix_ext_supported =3D true;
> > > > + else if (pctx->ContextType =3D=3D SMB2_SIGNING_CAPABILITIES)
> > > > + decode_signing_ctx(server,
> > > > + (struct smb2_signing_capabilities *)pctx);
> > > >   else
> > > >   cifs_server_dbg(VFS, "unknown negcontext of type %d ignored\n",
> > > >   le16_to_cpu(pctx->ContextType));
> > > > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > > > index ba75e65924ac..4b27cb9105fd 100644
> > > > --- a/fs/cifs/smb2pdu.h
> > > > +++ b/fs/cifs/smb2pdu.h
> > > > @@ -329,7 +329,7 @@ struct smb2_neg_context {
> > > >   __le16 ContextType;
> > > >   __le16 DataLength;
> > > >   __le32 Reserved;
> > > > - /* Followed by array of data */
> > > > + /* Followed by array of data. NOTE: some servers require padding =
to
> > > > 8 byte boundary */
> > > >  } __packed;
> > > >
> > > >  #define SMB311_LINUX_CLIENT_SALT_SIZE 32
> > > > @@ -394,6 +394,7 @@ struct smb2_compression_capabilities_context {
> > > >   __u16 Padding;
> > > >   __u32 Flags;
> > > >   __le16 CompressionAlgorithms[3];
> > > > + /* Check if pad needed */
> > > >  } __packed;
> > > >
> > > >  /*
> > > > @@ -420,6 +421,7 @@ struct smb2_transport_capabilities_context {
> > > >   __le16  DataLength;
> > > >   __u32 Reserved;
> > > >   __le32 Flags;
> > > > + __u32 Pad;
> > > >  } __packed;
> > > >
> > > >  /*
> > > > @@ -458,6 +460,7 @@ struct smb2_signing_capabilities {
> > > >   __u32 Reserved;
> > > >   __le16 SigningAlgorithmCount;
> > > >   __le16 SigningAlgorithms[];
> > > > + /*  Followed by padding to 8 byte boundary (required by some serv=
ers) */
> > > >  } __packed;
> > > >
> > > >  #define POSIX_CTXT_DATA_LEN 16
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
