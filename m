Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB6DC07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 04:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA70461CD7
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 04:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhGHEyf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 00:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhGHEye (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 00:54:34 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84413C061574
        for <linux-cifs@vger.kernel.org>; Wed,  7 Jul 2021 21:51:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id nd37so7257383ejc.3
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jul 2021 21:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B0+rjOzu9j7vOoALXkbX5S8kLUdxNDH1rbdegLjMmOg=;
        b=L9hj99tXUDRDMi/G8UrVGLNf5JvkByq6CCZ5Leu406eTpwC7tWZj7nfkgegqKUgqZO
         krbrX5ndV7w2fivUO8lVRFpd7hzk2YMrCYrvrv6WEnTGVh5KgkONA4JN5cpU0+9pMklL
         /JlHRy2LasJsvcqm2DY9z2/N0P5Nt42wIPZeYd6rnZAp4A7YINEPl+SIE7yeGoY9b6XQ
         Tzh2cOTCyl2luYDvcJki7yf2PEA5IN2Zfl/0MRWnADLzyrVsTHC9zAJ6fjQNpcqgFjpx
         HJCejCbh/HgdYHvZYWrn25xsFrFhxAr6s+e/0EH5ZFHs5RSCmVFkQ1cbVWssDEloZgNo
         HocA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B0+rjOzu9j7vOoALXkbX5S8kLUdxNDH1rbdegLjMmOg=;
        b=Dcp003JPWw8c95vmVd/tPN1sF9pr93VhlRAUPeWEkBM98i0Hd/Mc4bUFDe70hT2yoj
         3CWGLNtlCJWeumBQNh/YXAShURHMpWWv9Z55r3CsIieEdhSm/+xmJCy08FPix8I5xO8y
         PnEqsHoYX3iuotzClup8e0ZTEJu026U9RpDeDoGge9Tjk4LTlMJM4Ejy7qNFob1knEFm
         e+8ah5xWnM6ff33yncHcV9tAhuL6GbA0/jC/VfTOZwCRxyMqx4S9MudsKeJ68tQnrZxh
         lavHGwH2lB0nNxvWmR8HUWjIS6lLRZR5kpTB4sXY5o5h4CK3A36TvrxirTMxSjHMmxx6
         TV4A==
X-Gm-Message-State: AOAM5310opjimLHLBFVgKskWgp1B1p+mnX9Hu2dPsc1sl8FiHfogE0Xi
        S17Uu0wD0/971U2Xn26I9i6pUygrnstkrffOgRY=
X-Google-Smtp-Source: ABdhPJwpQJKckQ7+KgrIzT4FKVTMCdSI0QRTOO0QCY9xItREE0mdYZzYAr70Rmt5MetKZHA6NfGnMj5j4Gn9Fy/BXM0=
X-Received: by 2002:a17:906:2da1:: with SMTP id g1mr28007814eji.47.1625719912004;
 Wed, 07 Jul 2021 21:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvS6aHG8dXBre0RuGPzUb0g1hh-OPnhEup9PrX5z0zv5g@mail.gmail.com>
 <CAH2r5mu_fVutwr+XY8i-EpWO9gTw+dvHoy1oFk_wxHeMuVgxqA@mail.gmail.com> <CAH2r5mstq3L33-RBDrJ+0Z1K2PAP0z=5bm=wQ8XHdx4th_caFw@mail.gmail.com>
In-Reply-To: <CAH2r5mstq3L33-RBDrJ+0Z1K2PAP0z=5bm=wQ8XHdx4th_caFw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 8 Jul 2021 14:51:40 +1000
Message-ID: <CAN05THSBo74HOMYV+mHejb1s4tAb_uv=8cmcO1UDRScFw-WUQg@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] add ability to send signing negotiate context
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

lgtm

On Thu, Jul 8, 2021 at 2:49 PM Steve French <smfrench@gmail.com> wrote:
>
> v4 of patch (includes minor change to set local variable "num_algs"
> once to number of algorithms and use that throughout
> build_signing_context to make code a little clearer)
>
>
> On Wed, Jul 7, 2021 at 11:27 PM Steve French <smfrench@gmail.com> wrote:
> >
> > v3 of patch.  Updated with additional feedback from Ronnie (to make it
> > more context len and datalength clearer)
> >
> >
> > On Wed, Jul 7, 2021 at 9:44 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Support for faster packet signing (using GMAC instead of CMAC) can
> > > now be negotiated to some newer servers, including Windows.
> > > See MS-SMB2 section 2.2.3.17.
> > >
> > > This patch adds support for sending the new negotiate context
> > > with the first of three supported signing algorithms (AES-CMAC)
> > > and decoding the response.  A followon patch will add support
> > > for sending the other two (including AES-GMAC, which is fastest)
> > > and changing the signing algorithm used based on what was
> > > negotiated.
> > >
> > > To allow the client to request GMAC signing set module parameter
> > > "enable_negotiate_signing" to 1.
> > >
> > > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > ---
> > >  fs/cifs/cifsfs.c   |  4 +++
> > >  fs/cifs/cifsglob.h |  3 ++
> > >  fs/cifs/smb2pdu.c  | 83 ++++++++++++++++++++++++++++++++++++++++------
> > >  fs/cifs/smb2pdu.h  |  5 ++-
> > >  4 files changed, 84 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > index 9fb874dd8d24..476b07213fcd 100644
> > > --- a/fs/cifs/cifsfs.c
> > > +++ b/fs/cifs/cifsfs.c
> > > @@ -65,6 +65,7 @@ bool lookupCacheEnabled = true;
> > >  bool disable_legacy_dialects; /* false by default */
> > >  bool enable_gcm_256 = true;
> > >  bool require_gcm_256; /* false by default */
> > > +bool enable_negotiate_signing; /* false by default */
> > >  unsigned int global_secflags = CIFSSEC_DEF;
> > >  /* unsigned int ntlmv2_support = 0; */
> > >  unsigned int sign_CIFS_PDUs = 1;
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
> > >  module_param(disable_legacy_dialects, bool, 0644);
> > >  MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
> > >     "helpful to restrict the ability to "
> > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > index 921680fb7931..3c2e117bb926 100644
> > > --- a/fs/cifs/cifsglob.h
> > > +++ b/fs/cifs/cifsglob.h
> > > @@ -667,9 +667,11 @@ struct TCP_Server_Info {
> > >   unsigned int max_write;
> > >   unsigned int min_offload;
> > >   __le16 compress_algorithm;
> > > + __u16 signing_algorithm;
> > >   __le16 cipher_type;
> > >   /* save initital negprot hash */
> > >   __u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
> > > + bool signing_negotiated; /* true if valid signing context rcvd from server */
> > >   bool posix_ext_supported;
> > >   struct delayed_work reconnect; /* reconnect workqueue job */
> > >   struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
> > > @@ -1869,6 +1871,7 @@ extern unsigned int global_secflags; /* if on,
> > > session setup sent
> > >  extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
> > >  extern bool enable_gcm_256; /* allow optional negotiate of strongest
> > > signing (aes-gcm-256) */
> > >  extern bool require_gcm_256; /* require use of strongest signing
> > > (aes-gcm-256) */
> > > +extern bool enable_negotiate_signing; /* request use of faster (GMAC)
> > > signing if available */
> > >  extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
> > >  extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
> > >  extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
> > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > > index 962826dc3316..757f145e70e5 100644
> > > --- a/fs/cifs/smb2pdu.c
> > > +++ b/fs/cifs/smb2pdu.c
> > > @@ -433,6 +433,23 @@ build_compression_ctxt(struct
> > > smb2_compression_capabilities_context *pneg_ctxt)
> > >   pneg_ctxt->CompressionAlgorithms[2] = SMB3_COMPRESS_LZNT1;
> > >  }
> > >
> > > +static void
> > > +build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
> > > +{
> > > + pneg_ctxt->ContextType = SMB2_SIGNING_CAPABILITIES;
> > > + /*
> > > + * Data length must be increased here if more than 3 signing algorithms
> > > + * sent but currently only 3 are defined. And context Data length must
> > > + * be rounded to multiple of 8 for some servers.
> > > + */
> > > + pneg_ctxt->DataLength =
> > > + cpu_to_le16(DIV_ROUND_UP(sizeof(struct smb2_signing_capabilities) -
> > > + sizeof(struct smb2_neg_context), 8) * 8);
> > > + pneg_ctxt->SigningAlgorithmCount = cpu_to_le16(1);
> > > + pneg_ctxt->SigningAlgorithms[0] = cpu_to_le16(SIGNING_ALG_AES_CMAC);
> > > + /* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA256 */
> > > +}
> > > +
> > >  static void
> > >  build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
> > >  {
> > > @@ -498,7 +515,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> > >         struct TCP_Server_Info *server, unsigned int *total_len)
> > >  {
> > >   char *pneg_ctxt;
> > > - unsigned int ctxt_len;
> > > + unsigned int ctxt_len, neg_context_count;
> > >
> > >   if (*total_len > 200) {
> > >   /* In case length corrupted don't want to overrun smb buffer */
> > > @@ -525,6 +542,17 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> > >   *total_len += ctxt_len;
> > >   pneg_ctxt += ctxt_len;
> > >
> > > + ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
> > > + server->hostname);
> > > + *total_len += ctxt_len;
> > > + pneg_ctxt += ctxt_len;
> > > +
> > > + build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
> > > + *total_len += sizeof(struct smb2_posix_neg_context);
> > > + pneg_ctxt += sizeof(struct smb2_posix_neg_context);
> > > +
> > > + neg_context_count = 4;
> > > +
> > >   if (server->compress_algorithm) {
> > >   build_compression_ctxt((struct smb2_compression_capabilities_context *)
> > >   pneg_ctxt);
> > > @@ -533,17 +561,24 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> > >   8) * 8;
> > >   *total_len += ctxt_len;
> > >   pneg_ctxt += ctxt_len;
> > > - req->NegotiateContextCount = cpu_to_le16(5);
> > > - } else
> > > - req->NegotiateContextCount = cpu_to_le16(4);
> > > + neg_context_count++;
> > > + }
> > >
> > > - ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
> > > - server->hostname);
> > > - *total_len += ctxt_len;
> > > - pneg_ctxt += ctxt_len;
> > > + if (enable_negotiate_signing) {
> > > + pr_warn_once("requesting GMAC signing is experimental\n");
> > > + build_signing_ctxt((struct smb2_signing_capabilities *)
> > > + pneg_ctxt);
> > > + ctxt_len = DIV_ROUND_UP(
> > > + sizeof(struct smb2_signing_capabilities),
> > > + 8) * 8;
> > > + *total_len += ctxt_len;
> > > + pneg_ctxt += ctxt_len;
> > > + neg_context_count++;
> > > + }
> > > +
> > > + /* check for and add transport_capabilities and signing capabilities */
> > > + req->NegotiateContextCount = cpu_to_le16(neg_context_count);
> > >
> > > - build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
> > > - *total_len += sizeof(struct smb2_posix_neg_context);
> > >  }
> > >
> > >  static void decode_preauth_context(struct smb2_preauth_neg_context *ctxt)
> > > @@ -632,6 +667,31 @@ static int decode_encrypt_ctx(struct
> > > TCP_Server_Info *server,
> > >   return 0;
> > >  }
> > >
> > > +static void decode_signing_ctx(struct TCP_Server_Info *server,
> > > +        struct smb2_signing_capabilities *pctxt)
> > > +{
> > > + unsigned int len = le16_to_cpu(pctxt->DataLength);
> > > +
> > > + if ((len < 4) || (len > 16)) {
> > > + pr_warn_once("server sent bad signing negcontext\n");
> > > + return;
> > > + }
> > > + if (le16_to_cpu(pctxt->SigningAlgorithmCount) != 1) {
> > > + pr_warn_once("Invalid signing algorithm count\n");
> > > + return;
> > > + }
> > > + if (le16_to_cpu(pctxt->SigningAlgorithms[0]) > 2) {
> > > + pr_warn_once("unknown signing algorithm\n");
> > > + return;
> > > + }
> > > +
> > > + server->signing_negotiated = true;
> > > + server->signing_algorithm = le16_to_cpu(pctxt->SigningAlgorithms[0]);
> > > + cifs_dbg(FYI, "signing algorithm %d chosen\n",
> > > +      server->signing_algorithm);
> > > +}
> > > +
> > > +
> > >  static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
> > >        struct TCP_Server_Info *server,
> > >        unsigned int len_of_smb)
> > > @@ -675,6 +735,9 @@ static int smb311_decode_neg_context(struct
> > > smb2_negotiate_rsp *rsp,
> > >   (struct smb2_compression_capabilities_context *)pctx);
> > >   else if (pctx->ContextType == SMB2_POSIX_EXTENSIONS_AVAILABLE)
> > >   server->posix_ext_supported = true;
> > > + else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES)
> > > + decode_signing_ctx(server,
> > > + (struct smb2_signing_capabilities *)pctx);
> > >   else
> > >   cifs_server_dbg(VFS, "unknown negcontext of type %d ignored\n",
> > >   le16_to_cpu(pctx->ContextType));
> > > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > > index ba75e65924ac..4b27cb9105fd 100644
> > > --- a/fs/cifs/smb2pdu.h
> > > +++ b/fs/cifs/smb2pdu.h
> > > @@ -329,7 +329,7 @@ struct smb2_neg_context {
> > >   __le16 ContextType;
> > >   __le16 DataLength;
> > >   __le32 Reserved;
> > > - /* Followed by array of data */
> > > + /* Followed by array of data. NOTE: some servers require padding to
> > > 8 byte boundary */
> > >  } __packed;
> > >
> > >  #define SMB311_LINUX_CLIENT_SALT_SIZE 32
> > > @@ -394,6 +394,7 @@ struct smb2_compression_capabilities_context {
> > >   __u16 Padding;
> > >   __u32 Flags;
> > >   __le16 CompressionAlgorithms[3];
> > > + /* Check if pad needed */
> > >  } __packed;
> > >
> > >  /*
> > > @@ -420,6 +421,7 @@ struct smb2_transport_capabilities_context {
> > >   __le16  DataLength;
> > >   __u32 Reserved;
> > >   __le32 Flags;
> > > + __u32 Pad;
> > >  } __packed;
> > >
> > >  /*
> > > @@ -458,6 +460,7 @@ struct smb2_signing_capabilities {
> > >   __u32 Reserved;
> > >   __le16 SigningAlgorithmCount;
> > >   __le16 SigningAlgorithms[];
> > > + /*  Followed by padding to 8 byte boundary (required by some servers) */
> > >  } __packed;
> > >
> > >  #define POSIX_CTXT_DATA_LEN 16
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
>
>
>
> --
> Thanks,
>
> Steve
