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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0947AC07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 04:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8A4161CB9
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 04:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhGHEw0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 00:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhGHEw0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 00:52:26 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823D8C061574
        for <linux-cifs@vger.kernel.org>; Wed,  7 Jul 2021 21:49:44 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id y42so11168723lfa.3
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jul 2021 21:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHDfpQJF6a+ffu5KtoKgJ8MGFInsgv4JBw8yrl+r7cA=;
        b=Wc6/RGynWnjbQSVDud4feJbJPkkZgNpgkT+7ZN0FbDWjl9yUYCQXJDIqophe5moaxx
         S3x68K+xCk41DkiE/sfZt5u9mZBxwiYVCSB0VvWhridWv+4be0KejxX3rWTHkJtvORsQ
         zaGzT6dblya+mrgadyBZ9rQwzEQAm+8429CY+o3dpOrQEJ3kAdjBMIybY9QOytPh/nen
         yQhoqK+28Wb+O4Gpsq4ouNLgwfUOqNbymxzV3lLJTdLEw8bLg4+qHd4Lz8UHztm6zDqz
         +5QH35+yL7MnbBas6iKM7O7ueFqufIG2RopNm5qpF4iwjHrCYqdwfIb176ItkPp42fDP
         1lfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHDfpQJF6a+ffu5KtoKgJ8MGFInsgv4JBw8yrl+r7cA=;
        b=Wp8cmma2sPWjKyQS3UbdKNm6Lz8cM59fmNkp4rQ9MDGJM9Si62Vn+qvwfZ2w7792Fe
         CPhoXyDpoPcmROZ+y/bUhLPp9A8ytibzAoE1nH/42aj6qxIyXWnW5JSG7w9C4hRAr7h+
         Jj3T4ZjkTqjo9AT9D00s+s80E2B7Iw4Ca6YgqU7czmhtRd4/P+zKEKQJPAGWnU4Recih
         HDdyADvTmzGPIqWBY/UCzjLgPY6rzn2qooA27PfkvhILGW6GgF9PmG0im8iihqviEhvs
         fld5GwPk3PwbgoFX7sEZ38vbEWc07fYD0n5q1SYZQ0fXmVpWxqM9fhFZ9By+ovseXGc5
         hWmg==
X-Gm-Message-State: AOAM530P8oJwj4gOA959LwvzZ1tW86xhEPFzz7miyBPY+/+zGXGabS5d
        JYmojKaSMcCKxs7wzT6cVoutN4Mkep5aa2uGb1+XBiRU
X-Google-Smtp-Source: ABdhPJzCxr6yQxPRs+TdK7C0hJnwhRuwy1T/yvrjmPJTQfNrlOY1mZembxnQD0UOvUk96qWyPV5jwa576gkg8YcJQpo=
X-Received: by 2002:ac2:4475:: with SMTP id y21mr20346306lfl.133.1625719782376;
 Wed, 07 Jul 2021 21:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvS6aHG8dXBre0RuGPzUb0g1hh-OPnhEup9PrX5z0zv5g@mail.gmail.com>
 <CAH2r5mu_fVutwr+XY8i-EpWO9gTw+dvHoy1oFk_wxHeMuVgxqA@mail.gmail.com>
In-Reply-To: <CAH2r5mu_fVutwr+XY8i-EpWO9gTw+dvHoy1oFk_wxHeMuVgxqA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 7 Jul 2021 23:49:28 -0500
Message-ID: <CAH2r5mstq3L33-RBDrJ+0Z1K2PAP0z=5bm=wQ8XHdx4th_caFw@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] add ability to send signing negotiate context
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000222ba605c6956292"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000222ba605c6956292
Content-Type: text/plain; charset="UTF-8"

v4 of patch (includes minor change to set local variable "num_algs"
once to number of algorithms and use that throughout
build_signing_context to make code a little clearer)


On Wed, Jul 7, 2021 at 11:27 PM Steve French <smfrench@gmail.com> wrote:
>
> v3 of patch.  Updated with additional feedback from Ronnie (to make it
> more context len and datalength clearer)
>
>
> On Wed, Jul 7, 2021 at 9:44 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Support for faster packet signing (using GMAC instead of CMAC) can
> > now be negotiated to some newer servers, including Windows.
> > See MS-SMB2 section 2.2.3.17.
> >
> > This patch adds support for sending the new negotiate context
> > with the first of three supported signing algorithms (AES-CMAC)
> > and decoding the response.  A followon patch will add support
> > for sending the other two (including AES-GMAC, which is fastest)
> > and changing the signing algorithm used based on what was
> > negotiated.
> >
> > To allow the client to request GMAC signing set module parameter
> > "enable_negotiate_signing" to 1.
> >
> > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/cifs/cifsfs.c   |  4 +++
> >  fs/cifs/cifsglob.h |  3 ++
> >  fs/cifs/smb2pdu.c  | 83 ++++++++++++++++++++++++++++++++++++++++------
> >  fs/cifs/smb2pdu.h  |  5 ++-
> >  4 files changed, 84 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 9fb874dd8d24..476b07213fcd 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -65,6 +65,7 @@ bool lookupCacheEnabled = true;
> >  bool disable_legacy_dialects; /* false by default */
> >  bool enable_gcm_256 = true;
> >  bool require_gcm_256; /* false by default */
> > +bool enable_negotiate_signing; /* false by default */
> >  unsigned int global_secflags = CIFSSEC_DEF;
> >  /* unsigned int ntlmv2_support = 0; */
> >  unsigned int sign_CIFS_PDUs = 1;
> > @@ -104,6 +105,9 @@ MODULE_PARM_DESC(enable_gcm_256, "Enable
> > requesting strongest (256 bit) GCM encr
> >  module_param(require_gcm_256, bool, 0644);
> >  MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM
> > encryption. Default: n/N/0");
> >
> > +module_param(enable_negotiate_signing, bool, 0644);
> > +MODULE_PARM_DESC(enable_GMAC_signing, "Enable requesting faster
> > (GMAC) packet signing. Default: n/N/0");
> > +
> >  module_param(disable_legacy_dialects, bool, 0644);
> >  MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
> >     "helpful to restrict the ability to "
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 921680fb7931..3c2e117bb926 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -667,9 +667,11 @@ struct TCP_Server_Info {
> >   unsigned int max_write;
> >   unsigned int min_offload;
> >   __le16 compress_algorithm;
> > + __u16 signing_algorithm;
> >   __le16 cipher_type;
> >   /* save initital negprot hash */
> >   __u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
> > + bool signing_negotiated; /* true if valid signing context rcvd from server */
> >   bool posix_ext_supported;
> >   struct delayed_work reconnect; /* reconnect workqueue job */
> >   struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
> > @@ -1869,6 +1871,7 @@ extern unsigned int global_secflags; /* if on,
> > session setup sent
> >  extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
> >  extern bool enable_gcm_256; /* allow optional negotiate of strongest
> > signing (aes-gcm-256) */
> >  extern bool require_gcm_256; /* require use of strongest signing
> > (aes-gcm-256) */
> > +extern bool enable_negotiate_signing; /* request use of faster (GMAC)
> > signing if available */
> >  extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
> >  extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
> >  extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 962826dc3316..757f145e70e5 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -433,6 +433,23 @@ build_compression_ctxt(struct
> > smb2_compression_capabilities_context *pneg_ctxt)
> >   pneg_ctxt->CompressionAlgorithms[2] = SMB3_COMPRESS_LZNT1;
> >  }
> >
> > +static void
> > +build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
> > +{
> > + pneg_ctxt->ContextType = SMB2_SIGNING_CAPABILITIES;
> > + /*
> > + * Data length must be increased here if more than 3 signing algorithms
> > + * sent but currently only 3 are defined. And context Data length must
> > + * be rounded to multiple of 8 for some servers.
> > + */
> > + pneg_ctxt->DataLength =
> > + cpu_to_le16(DIV_ROUND_UP(sizeof(struct smb2_signing_capabilities) -
> > + sizeof(struct smb2_neg_context), 8) * 8);
> > + pneg_ctxt->SigningAlgorithmCount = cpu_to_le16(1);
> > + pneg_ctxt->SigningAlgorithms[0] = cpu_to_le16(SIGNING_ALG_AES_CMAC);
> > + /* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA256 */
> > +}
> > +
> >  static void
> >  build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
> >  {
> > @@ -498,7 +515,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> >         struct TCP_Server_Info *server, unsigned int *total_len)
> >  {
> >   char *pneg_ctxt;
> > - unsigned int ctxt_len;
> > + unsigned int ctxt_len, neg_context_count;
> >
> >   if (*total_len > 200) {
> >   /* In case length corrupted don't want to overrun smb buffer */
> > @@ -525,6 +542,17 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> >   *total_len += ctxt_len;
> >   pneg_ctxt += ctxt_len;
> >
> > + ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
> > + server->hostname);
> > + *total_len += ctxt_len;
> > + pneg_ctxt += ctxt_len;
> > +
> > + build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
> > + *total_len += sizeof(struct smb2_posix_neg_context);
> > + pneg_ctxt += sizeof(struct smb2_posix_neg_context);
> > +
> > + neg_context_count = 4;
> > +
> >   if (server->compress_algorithm) {
> >   build_compression_ctxt((struct smb2_compression_capabilities_context *)
> >   pneg_ctxt);
> > @@ -533,17 +561,24 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> >   8) * 8;
> >   *total_len += ctxt_len;
> >   pneg_ctxt += ctxt_len;
> > - req->NegotiateContextCount = cpu_to_le16(5);
> > - } else
> > - req->NegotiateContextCount = cpu_to_le16(4);
> > + neg_context_count++;
> > + }
> >
> > - ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
> > - server->hostname);
> > - *total_len += ctxt_len;
> > - pneg_ctxt += ctxt_len;
> > + if (enable_negotiate_signing) {
> > + pr_warn_once("requesting GMAC signing is experimental\n");
> > + build_signing_ctxt((struct smb2_signing_capabilities *)
> > + pneg_ctxt);
> > + ctxt_len = DIV_ROUND_UP(
> > + sizeof(struct smb2_signing_capabilities),
> > + 8) * 8;
> > + *total_len += ctxt_len;
> > + pneg_ctxt += ctxt_len;
> > + neg_context_count++;
> > + }
> > +
> > + /* check for and add transport_capabilities and signing capabilities */
> > + req->NegotiateContextCount = cpu_to_le16(neg_context_count);
> >
> > - build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
> > - *total_len += sizeof(struct smb2_posix_neg_context);
> >  }
> >
> >  static void decode_preauth_context(struct smb2_preauth_neg_context *ctxt)
> > @@ -632,6 +667,31 @@ static int decode_encrypt_ctx(struct
> > TCP_Server_Info *server,
> >   return 0;
> >  }
> >
> > +static void decode_signing_ctx(struct TCP_Server_Info *server,
> > +        struct smb2_signing_capabilities *pctxt)
> > +{
> > + unsigned int len = le16_to_cpu(pctxt->DataLength);
> > +
> > + if ((len < 4) || (len > 16)) {
> > + pr_warn_once("server sent bad signing negcontext\n");
> > + return;
> > + }
> > + if (le16_to_cpu(pctxt->SigningAlgorithmCount) != 1) {
> > + pr_warn_once("Invalid signing algorithm count\n");
> > + return;
> > + }
> > + if (le16_to_cpu(pctxt->SigningAlgorithms[0]) > 2) {
> > + pr_warn_once("unknown signing algorithm\n");
> > + return;
> > + }
> > +
> > + server->signing_negotiated = true;
> > + server->signing_algorithm = le16_to_cpu(pctxt->SigningAlgorithms[0]);
> > + cifs_dbg(FYI, "signing algorithm %d chosen\n",
> > +      server->signing_algorithm);
> > +}
> > +
> > +
> >  static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
> >        struct TCP_Server_Info *server,
> >        unsigned int len_of_smb)
> > @@ -675,6 +735,9 @@ static int smb311_decode_neg_context(struct
> > smb2_negotiate_rsp *rsp,
> >   (struct smb2_compression_capabilities_context *)pctx);
> >   else if (pctx->ContextType == SMB2_POSIX_EXTENSIONS_AVAILABLE)
> >   server->posix_ext_supported = true;
> > + else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES)
> > + decode_signing_ctx(server,
> > + (struct smb2_signing_capabilities *)pctx);
> >   else
> >   cifs_server_dbg(VFS, "unknown negcontext of type %d ignored\n",
> >   le16_to_cpu(pctx->ContextType));
> > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > index ba75e65924ac..4b27cb9105fd 100644
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -329,7 +329,7 @@ struct smb2_neg_context {
> >   __le16 ContextType;
> >   __le16 DataLength;
> >   __le32 Reserved;
> > - /* Followed by array of data */
> > + /* Followed by array of data. NOTE: some servers require padding to
> > 8 byte boundary */
> >  } __packed;
> >
> >  #define SMB311_LINUX_CLIENT_SALT_SIZE 32
> > @@ -394,6 +394,7 @@ struct smb2_compression_capabilities_context {
> >   __u16 Padding;
> >   __u32 Flags;
> >   __le16 CompressionAlgorithms[3];
> > + /* Check if pad needed */
> >  } __packed;
> >
> >  /*
> > @@ -420,6 +421,7 @@ struct smb2_transport_capabilities_context {
> >   __le16  DataLength;
> >   __u32 Reserved;
> >   __le32 Flags;
> > + __u32 Pad;
> >  } __packed;
> >
> >  /*
> > @@ -458,6 +460,7 @@ struct smb2_signing_capabilities {
> >   __u32 Reserved;
> >   __le16 SigningAlgorithmCount;
> >   __le16 SigningAlgorithms[];
> > + /*  Followed by padding to 8 byte boundary (required by some servers) */
> >  } __packed;
> >
> >  #define POSIX_CTXT_DATA_LEN 16
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



-- 
Thanks,

Steve

--000000000000222ba605c6956292
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-Add-support-for-negotiating-signing-algorit.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-Add-support-for-negotiating-signing-algorit.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqufkhmy0>
X-Attachment-Id: f_kqufkhmy0

RnJvbSBkZTk2ODUzZGFjYzdjZDMxOWQ1ZmRkYWIzY2I1YWRhOGYxMDZjNTJjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgNSBKdWwgMjAyMSAxNTowNTozOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjMuMS4xOiBBZGQgc3VwcG9ydCBmb3IgbmVnb3RpYXRpbmcgc2lnbmluZyBhbGdvcml0aG0KClN1
cHBvcnQgZm9yIGZhc3RlciBwYWNrZXQgc2lnbmluZyAodXNpbmcgR01BQyBpbnN0ZWFkIG9mIENN
QUMpIGNhbgpub3cgYmUgbmVnb3RpYXRlZCB0byBzb21lIG5ld2VyIHNlcnZlcnMsIGluY2x1ZGlu
ZyBXaW5kb3dzLgpTZWUgTVMtU01CMiBzZWN0aW9uIDIuMi4zLjE3LgoKVGhpcyBwYXRjaCBhZGRz
IHN1cHBvcnQgZm9yIHNlbmRpbmcgdGhlIG5ldyBuZWdvdGlhdGUgY29udGV4dAp3aXRoIHRoZSBm
aXJzdCBvZiB0aHJlZSBzdXBwb3J0ZWQgc2lnbmluZyBhbGdvcml0aG1zIChBRVMtQ01BQykKYW5k
IGRlY29kaW5nIHRoZSByZXNwb25zZS4gIEEgZm9sbG93b24gcGF0Y2ggd2lsbCBhZGQgc3VwcG9y
dApmb3Igc2VuZGluZyB0aGUgb3RoZXIgdHdvIChpbmNsdWRpbmcgQUVTLUdNQUMsIHdoaWNoIGlz
IGZhc3Rlc3QpCmFuZCBjaGFuZ2luZyB0aGUgc2lnbmluZyBhbGdvcml0aG0gdXNlZCBiYXNlZCBv
biB3aGF0IHdhcwpuZWdvdGlhdGVkLgoKVG8gYWxsb3cgdGhlIGNsaWVudCB0byByZXF1ZXN0IEdN
QUMgc2lnbmluZyBzZXQgbW9kdWxlIHBhcmFtZXRlcgoiZW5hYmxlX25lZ290aWF0ZV9zaWduaW5n
IiB0byAxLgoKUmV2aWV3ZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNv
bT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgot
LS0KIGZzL2NpZnMvY2lmc2ZzLmMgICB8ICA0ICsrKwogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgIDMg
KysKIGZzL2NpZnMvc21iMnBkdS5jICB8IDg2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0KIGZzL2NpZnMvc21iMnBkdS5oICB8ICA1ICsrLQogNCBmaWxlcyBj
aGFuZ2VkLCA4NyBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9m
cy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMuYwppbmRleCA5ZmI4NzRkZDhkMjQuLjQ3
NmIwNzIxM2ZjZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2Np
ZnNmcy5jCkBAIC02NSw2ICs2NSw3IEBAIGJvb2wgbG9va3VwQ2FjaGVFbmFibGVkID0gdHJ1ZTsK
IGJvb2wgZGlzYWJsZV9sZWdhY3lfZGlhbGVjdHM7IC8qIGZhbHNlIGJ5IGRlZmF1bHQgKi8KIGJv
b2wgZW5hYmxlX2djbV8yNTYgPSB0cnVlOwogYm9vbCByZXF1aXJlX2djbV8yNTY7IC8qIGZhbHNl
IGJ5IGRlZmF1bHQgKi8KK2Jvb2wgZW5hYmxlX25lZ290aWF0ZV9zaWduaW5nOyAvKiBmYWxzZSBi
eSBkZWZhdWx0ICovCiB1bnNpZ25lZCBpbnQgZ2xvYmFsX3NlY2ZsYWdzID0gQ0lGU1NFQ19ERUY7
CiAvKiB1bnNpZ25lZCBpbnQgbnRsbXYyX3N1cHBvcnQgPSAwOyAqLwogdW5zaWduZWQgaW50IHNp
Z25fQ0lGU19QRFVzID0gMTsKQEAgLTEwNCw2ICsxMDUsOSBAQCBNT0RVTEVfUEFSTV9ERVNDKGVu
YWJsZV9nY21fMjU2LCAiRW5hYmxlIHJlcXVlc3Rpbmcgc3Ryb25nZXN0ICgyNTYgYml0KSBHQ00g
ZW5jcgogbW9kdWxlX3BhcmFtKHJlcXVpcmVfZ2NtXzI1NiwgYm9vbCwgMDY0NCk7CiBNT0RVTEVf
UEFSTV9ERVNDKHJlcXVpcmVfZ2NtXzI1NiwgIlJlcXVpcmUgc3Ryb25nZXN0ICgyNTYgYml0KSBH
Q00gZW5jcnlwdGlvbi4gRGVmYXVsdDogbi9OLzAiKTsKIAorbW9kdWxlX3BhcmFtKGVuYWJsZV9u
ZWdvdGlhdGVfc2lnbmluZywgYm9vbCwgMDY0NCk7CitNT0RVTEVfUEFSTV9ERVNDKGVuYWJsZV9H
TUFDX3NpZ25pbmcsICJFbmFibGUgcmVxdWVzdGluZyBmYXN0ZXIgKEdNQUMpIHBhY2tldCBzaWdu
aW5nLiBEZWZhdWx0OiBuL04vMCIpOworCiBtb2R1bGVfcGFyYW0oZGlzYWJsZV9sZWdhY3lfZGlh
bGVjdHMsIGJvb2wsIDA2NDQpOwogTU9EVUxFX1BBUk1fREVTQyhkaXNhYmxlX2xlZ2FjeV9kaWFs
ZWN0cywgIlRvIGltcHJvdmUgc2VjdXJpdHkgaXQgbWF5IGJlICIKIAkJCQkgICJoZWxwZnVsIHRv
IHJlc3RyaWN0IHRoZSBhYmlsaXR5IHRvICIKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2Iu
aCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCA5MjE2ODBmYjc5MzEuLjNjMmUxMTdiYjkyNiAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApA
QCAtNjY3LDkgKzY2NywxMSBAQCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvIHsKIAl1bnNpZ25lZCBp
bnQJbWF4X3dyaXRlOwogCXVuc2lnbmVkIGludAltaW5fb2ZmbG9hZDsKIAlfX2xlMTYJY29tcHJl
c3NfYWxnb3JpdGhtOworCV9fdTE2CXNpZ25pbmdfYWxnb3JpdGhtOwogCV9fbGUxNgljaXBoZXJf
dHlwZTsKIAkgLyogc2F2ZSBpbml0aXRhbCBuZWdwcm90IGhhc2ggKi8KIAlfX3U4CXByZWF1dGhf
c2hhX2hhc2hbU01CMl9QUkVBVVRIX0hBU0hfU0laRV07CisJYm9vbAlzaWduaW5nX25lZ290aWF0
ZWQ7IC8qIHRydWUgaWYgdmFsaWQgc2lnbmluZyBjb250ZXh0IHJjdmQgZnJvbSBzZXJ2ZXIgKi8K
IAlib29sCXBvc2l4X2V4dF9zdXBwb3J0ZWQ7CiAJc3RydWN0IGRlbGF5ZWRfd29yayByZWNvbm5l
Y3Q7IC8qIHJlY29ubmVjdCB3b3JrcXVldWUgam9iICovCiAJc3RydWN0IG11dGV4IHJlY29ubmVj
dF9tdXRleDsgLyogcHJldmVudCBzaW11bHRhbmVvdXMgcmVjb25uZWN0cyAqLwpAQCAtMTg2OSw2
ICsxODcxLDcgQEAgZXh0ZXJuIHVuc2lnbmVkIGludCBnbG9iYWxfc2VjZmxhZ3M7CS8qIGlmIG9u
LCBzZXNzaW9uIHNldHVwIHNlbnQKIGV4dGVybiB1bnNpZ25lZCBpbnQgc2lnbl9DSUZTX1BEVXM7
ICAvKiBlbmFibGUgc21iIHBhY2tldCBzaWduaW5nICovCiBleHRlcm4gYm9vbCBlbmFibGVfZ2Nt
XzI1NjsgLyogYWxsb3cgb3B0aW9uYWwgbmVnb3RpYXRlIG9mIHN0cm9uZ2VzdCBzaWduaW5nIChh
ZXMtZ2NtLTI1NikgKi8KIGV4dGVybiBib29sIHJlcXVpcmVfZ2NtXzI1NjsgLyogcmVxdWlyZSB1
c2Ugb2Ygc3Ryb25nZXN0IHNpZ25pbmcgKGFlcy1nY20tMjU2KSAqLworZXh0ZXJuIGJvb2wgZW5h
YmxlX25lZ290aWF0ZV9zaWduaW5nOyAvKiByZXF1ZXN0IHVzZSBvZiBmYXN0ZXIgKEdNQUMpIHNp
Z25pbmcgaWYgYXZhaWxhYmxlICovCiBleHRlcm4gYm9vbCBsaW51eEV4dEVuYWJsZWQ7LyplbmFi
bGUgTGludXgvVW5peCBDSUZTIGV4dGVuc2lvbnMqLwogZXh0ZXJuIHVuc2lnbmVkIGludCBDSUZT
TWF4QnVmU2l6ZTsgIC8qIG1heCBzaXplIG5vdCBpbmNsdWRpbmcgaGRyICovCiBleHRlcm4gdW5z
aWduZWQgaW50IGNpZnNfbWluX3JjdjsgICAgLyogbWluIHNpemUgb2YgYmlnIG50d3JrIGJ1ZiBw
b29sICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5j
CmluZGV4IDk2MjgyNmRjMzMxNi4uYzFlNzZlYjEyMTA5IDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nt
YjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtNDMzLDYgKzQzMywyOSBAQCBidWls
ZF9jb21wcmVzc2lvbl9jdHh0KHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19j
b250ZXh0ICpwbmVnX2N0eHQpCiAJcG5lZ19jdHh0LT5Db21wcmVzc2lvbkFsZ29yaXRobXNbMl0g
PSBTTUIzX0NPTVBSRVNTX0xaTlQxOwogfQogCitzdGF0aWMgdW5zaWduZWQgaW50CitidWlsZF9z
aWduaW5nX2N0eHQoc3RydWN0IHNtYjJfc2lnbmluZ19jYXBhYmlsaXRpZXMgKnBuZWdfY3R4dCkK
K3sKKwl1bnNpZ25lZCBpbnQgY3R4dF9sZW4gPSBzaXplb2Yoc3RydWN0IHNtYjJfc2lnbmluZ19j
YXBhYmlsaXRpZXMpOworCXVuc2lnbmVkIHNob3J0IG51bV9hbGdzID0gMTsgLyogbnVtYmVyIG9m
IHNpZ25pbmcgYWxnb3JpdGhtcyBzZW50ICovCisKKwlwbmVnX2N0eHQtPkNvbnRleHRUeXBlID0g
U01CMl9TSUdOSU5HX0NBUEFCSUxJVElFUzsKKwkvKgorCSAqIENvbnRleHQgRGF0YSBsZW5ndGgg
bXVzdCBiZSByb3VuZGVkIHRvIG11bHRpcGxlIG9mIDggZm9yIHNvbWUgc2VydmVycworCSAqLwor
CXBuZWdfY3R4dC0+RGF0YUxlbmd0aCA9IGNwdV90b19sZTE2KERJVl9ST1VORF9VUCgKKwkJCQlz
aXplb2Yoc3RydWN0IHNtYjJfc2lnbmluZ19jYXBhYmlsaXRpZXMpIC0KKwkJCQlzaXplb2Yoc3Ry
dWN0IHNtYjJfbmVnX2NvbnRleHQpICsKKwkJCQkobnVtX2FsZ3MgKiAyIC8qIHNpemVvZiB1MTYg
Ki8pLCA4KSAqIDgpOworCXBuZWdfY3R4dC0+U2lnbmluZ0FsZ29yaXRobUNvdW50ID0gY3B1X3Rv
X2xlMTYobnVtX2FsZ3MpOworCXBuZWdfY3R4dC0+U2lnbmluZ0FsZ29yaXRobXNbMF0gPSBjcHVf
dG9fbGUxNihTSUdOSU5HX0FMR19BRVNfQ01BQyk7CisKKwljdHh0X2xlbiArPSAyIC8qIHNpemVv
ZiBsZTE2ICovICogbnVtX2FsZ3M7CisJY3R4dF9sZW4gPSBESVZfUk9VTkRfVVAoY3R4dF9sZW4s
IDgpICogODsKKwlyZXR1cm4gY3R4dF9sZW47CisJLyogVEJEIGFkZCBTSUdOSU5HX0FMR19BRVNf
R01BQyBhbmQvb3IgU0lHTklOR19BTEdfSE1BQ19TSEEyNTYgKi8KK30KKwogc3RhdGljIHZvaWQK
IGJ1aWxkX2VuY3J5cHRfY3R4dChzdHJ1Y3Qgc21iMl9lbmNyeXB0aW9uX25lZ19jb250ZXh0ICpw
bmVnX2N0eHQpCiB7CkBAIC00OTgsNyArNTIxLDcgQEAgYXNzZW1ibGVfbmVnX2NvbnRleHRzKHN0
cnVjdCBzbWIyX25lZ290aWF0ZV9yZXEgKnJlcSwKIAkJICAgICAgc3RydWN0IFRDUF9TZXJ2ZXJf
SW5mbyAqc2VydmVyLCB1bnNpZ25lZCBpbnQgKnRvdGFsX2xlbikKIHsKIAljaGFyICpwbmVnX2N0
eHQ7Ci0JdW5zaWduZWQgaW50IGN0eHRfbGVuOworCXVuc2lnbmVkIGludCBjdHh0X2xlbiwgbmVn
X2NvbnRleHRfY291bnQ7CiAKIAlpZiAoKnRvdGFsX2xlbiA+IDIwMCkgewogCQkvKiBJbiBjYXNl
IGxlbmd0aCBjb3JydXB0ZWQgZG9uJ3Qgd2FudCB0byBvdmVycnVuIHNtYiBidWZmZXIgKi8KQEAg
LTUyNSw2ICs1NDgsMTcgQEAgYXNzZW1ibGVfbmVnX2NvbnRleHRzKHN0cnVjdCBzbWIyX25lZ290
aWF0ZV9yZXEgKnJlcSwKIAkqdG90YWxfbGVuICs9IGN0eHRfbGVuOwogCXBuZWdfY3R4dCArPSBj
dHh0X2xlbjsKIAorCWN0eHRfbGVuID0gYnVpbGRfbmV0bmFtZV9jdHh0KChzdHJ1Y3Qgc21iMl9u
ZXRuYW1lX25lZ19jb250ZXh0ICopcG5lZ19jdHh0LAorCQkJCQlzZXJ2ZXItPmhvc3RuYW1lKTsK
KwkqdG90YWxfbGVuICs9IGN0eHRfbGVuOworCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKKworCWJ1
aWxkX3Bvc2l4X2N0eHQoKHN0cnVjdCBzbWIyX3Bvc2l4X25lZ19jb250ZXh0ICopcG5lZ19jdHh0
KTsKKwkqdG90YWxfbGVuICs9IHNpemVvZihzdHJ1Y3Qgc21iMl9wb3NpeF9uZWdfY29udGV4dCk7
CisJcG5lZ19jdHh0ICs9IHNpemVvZihzdHJ1Y3Qgc21iMl9wb3NpeF9uZWdfY29udGV4dCk7CisK
KwluZWdfY29udGV4dF9jb3VudCA9IDQ7CisKIAlpZiAoc2VydmVyLT5jb21wcmVzc19hbGdvcml0
aG0pIHsKIAkJYnVpbGRfY29tcHJlc3Npb25fY3R4dCgoc3RydWN0IHNtYjJfY29tcHJlc3Npb25f
Y2FwYWJpbGl0aWVzX2NvbnRleHQgKikKIAkJCQlwbmVnX2N0eHQpOwpAQCAtNTMzLDE3ICs1Njcs
MjEgQEAgYXNzZW1ibGVfbmVnX2NvbnRleHRzKHN0cnVjdCBzbWIyX25lZ290aWF0ZV9yZXEgKnJl
cSwKIAkJCQk4KSAqIDg7CiAJCSp0b3RhbF9sZW4gKz0gY3R4dF9sZW47CiAJCXBuZWdfY3R4dCAr
PSBjdHh0X2xlbjsKLQkJcmVxLT5OZWdvdGlhdGVDb250ZXh0Q291bnQgPSBjcHVfdG9fbGUxNig1
KTsKLQl9IGVsc2UKLQkJcmVxLT5OZWdvdGlhdGVDb250ZXh0Q291bnQgPSBjcHVfdG9fbGUxNig0
KTsKKwkJbmVnX2NvbnRleHRfY291bnQrKzsKKwl9CiAKLQljdHh0X2xlbiA9IGJ1aWxkX25ldG5h
bWVfY3R4dCgoc3RydWN0IHNtYjJfbmV0bmFtZV9uZWdfY29udGV4dCAqKXBuZWdfY3R4dCwKLQkJ
CQkJc2VydmVyLT5ob3N0bmFtZSk7Ci0JKnRvdGFsX2xlbiArPSBjdHh0X2xlbjsKLQlwbmVnX2N0
eHQgKz0gY3R4dF9sZW47CisJaWYgKGVuYWJsZV9uZWdvdGlhdGVfc2lnbmluZykgeworCQlwcl93
YXJuX29uY2UoInJlcXVlc3RpbmcgR01BQyBzaWduaW5nIGlzIGV4cGVyaW1lbnRhbFxuIik7CisJ
CWN0eHRfbGVuID0gYnVpbGRfc2lnbmluZ19jdHh0KChzdHJ1Y3Qgc21iMl9zaWduaW5nX2NhcGFi
aWxpdGllcyAqKQorCQkJCXBuZWdfY3R4dCk7CisJCSp0b3RhbF9sZW4gKz0gY3R4dF9sZW47CisJ
CXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKKwkJbmVnX2NvbnRleHRfY291bnQrKzsKKwl9CisKKwkv
KiBjaGVjayBmb3IgYW5kIGFkZCB0cmFuc3BvcnRfY2FwYWJpbGl0aWVzIGFuZCBzaWduaW5nIGNh
cGFiaWxpdGllcyAqLworCXJlcS0+TmVnb3RpYXRlQ29udGV4dENvdW50ID0gY3B1X3RvX2xlMTYo
bmVnX2NvbnRleHRfY291bnQpOwogCi0JYnVpbGRfcG9zaXhfY3R4dCgoc3RydWN0IHNtYjJfcG9z
aXhfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQpOwotCSp0b3RhbF9sZW4gKz0gc2l6ZW9mKHN0cnVj
dCBzbWIyX3Bvc2l4X25lZ19jb250ZXh0KTsKIH0KIAogc3RhdGljIHZvaWQgZGVjb2RlX3ByZWF1
dGhfY29udGV4dChzdHJ1Y3Qgc21iMl9wcmVhdXRoX25lZ19jb250ZXh0ICpjdHh0KQpAQCAtNjMy
LDYgKzY3MCwzMSBAQCBzdGF0aWMgaW50IGRlY29kZV9lbmNyeXB0X2N0eChzdHJ1Y3QgVENQX1Nl
cnZlcl9JbmZvICpzZXJ2ZXIsCiAJcmV0dXJuIDA7CiB9CiAKK3N0YXRpYyB2b2lkIGRlY29kZV9z
aWduaW5nX2N0eChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCisJCQkgICAgICAgc3Ry
dWN0IHNtYjJfc2lnbmluZ19jYXBhYmlsaXRpZXMgKnBjdHh0KQoreworCXVuc2lnbmVkIGludCBs
ZW4gPSBsZTE2X3RvX2NwdShwY3R4dC0+RGF0YUxlbmd0aCk7CisKKwlpZiAoKGxlbiA8IDQpIHx8
IChsZW4gPiAxNikpIHsKKwkJcHJfd2Fybl9vbmNlKCJzZXJ2ZXIgc2VudCBiYWQgc2lnbmluZyBu
ZWdjb250ZXh0XG4iKTsKKwkJcmV0dXJuOworCX0KKwlpZiAobGUxNl90b19jcHUocGN0eHQtPlNp
Z25pbmdBbGdvcml0aG1Db3VudCkgIT0gMSkgeworCQlwcl93YXJuX29uY2UoIkludmFsaWQgc2ln
bmluZyBhbGdvcml0aG0gY291bnRcbiIpOworCQlyZXR1cm47CisJfQorCWlmIChsZTE2X3RvX2Nw
dShwY3R4dC0+U2lnbmluZ0FsZ29yaXRobXNbMF0pID4gMikgeworCQlwcl93YXJuX29uY2UoInVu
a25vd24gc2lnbmluZyBhbGdvcml0aG1cbiIpOworCQlyZXR1cm47CisJfQorCisJc2VydmVyLT5z
aWduaW5nX25lZ290aWF0ZWQgPSB0cnVlOworCXNlcnZlci0+c2lnbmluZ19hbGdvcml0aG0gPSBs
ZTE2X3RvX2NwdShwY3R4dC0+U2lnbmluZ0FsZ29yaXRobXNbMF0pOworCWNpZnNfZGJnKEZZSSwg
InNpZ25pbmcgYWxnb3JpdGhtICVkIGNob3NlblxuIiwKKwkJICAgICBzZXJ2ZXItPnNpZ25pbmdf
YWxnb3JpdGhtKTsKK30KKworCiBzdGF0aWMgaW50IHNtYjMxMV9kZWNvZGVfbmVnX2NvbnRleHQo
c3RydWN0IHNtYjJfbmVnb3RpYXRlX3JzcCAqcnNwLAogCQkJCSAgICAgc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyLAogCQkJCSAgICAgdW5zaWduZWQgaW50IGxlbl9vZl9zbWIpCkBAIC02
NzUsNiArNzM4LDkgQEAgc3RhdGljIGludCBzbWIzMTFfZGVjb2RlX25lZ19jb250ZXh0KHN0cnVj
dCBzbWIyX25lZ290aWF0ZV9yc3AgKnJzcCwKIAkJCQkoc3RydWN0IHNtYjJfY29tcHJlc3Npb25f
Y2FwYWJpbGl0aWVzX2NvbnRleHQgKilwY3R4KTsKIAkJZWxzZSBpZiAocGN0eC0+Q29udGV4dFR5
cGUgPT0gU01CMl9QT1NJWF9FWFRFTlNJT05TX0FWQUlMQUJMRSkKIAkJCXNlcnZlci0+cG9zaXhf
ZXh0X3N1cHBvcnRlZCA9IHRydWU7CisJCWVsc2UgaWYgKHBjdHgtPkNvbnRleHRUeXBlID09IFNN
QjJfU0lHTklOR19DQVBBQklMSVRJRVMpCisJCQlkZWNvZGVfc2lnbmluZ19jdHgoc2VydmVyLAor
CQkJCShzdHJ1Y3Qgc21iMl9zaWduaW5nX2NhcGFiaWxpdGllcyAqKXBjdHgpOwogCQllbHNlCiAJ
CQljaWZzX3NlcnZlcl9kYmcoVkZTLCAidW5rbm93biBuZWdjb250ZXh0IG9mIHR5cGUgJWQgaWdu
b3JlZFxuIiwKIAkJCQlsZTE2X3RvX2NwdShwY3R4LT5Db250ZXh0VHlwZSkpOwpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9zbWIycGR1LmggYi9mcy9jaWZzL3NtYjJwZHUuaAppbmRleCBiYTc1ZTY1OTI0
YWMuLjRiMjdjYjkxMDVmZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmgKKysrIGIvZnMv
Y2lmcy9zbWIycGR1LmgKQEAgLTMyOSw3ICszMjksNyBAQCBzdHJ1Y3Qgc21iMl9uZWdfY29udGV4
dCB7CiAJX19sZTE2CUNvbnRleHRUeXBlOwogCV9fbGUxNglEYXRhTGVuZ3RoOwogCV9fbGUzMglS
ZXNlcnZlZDsKLQkvKiBGb2xsb3dlZCBieSBhcnJheSBvZiBkYXRhICovCisJLyogRm9sbG93ZWQg
YnkgYXJyYXkgb2YgZGF0YS4gTk9URTogc29tZSBzZXJ2ZXJzIHJlcXVpcmUgcGFkZGluZyB0byA4
IGJ5dGUgYm91bmRhcnkgKi8KIH0gX19wYWNrZWQ7CiAKICNkZWZpbmUgU01CMzExX0xJTlVYX0NM
SUVOVF9TQUxUX1NJWkUJCQkzMgpAQCAtMzk0LDYgKzM5NCw3IEBAIHN0cnVjdCBzbWIyX2NvbXBy
ZXNzaW9uX2NhcGFiaWxpdGllc19jb250ZXh0IHsKIAlfX3UxNglQYWRkaW5nOwogCV9fdTMyCUZs
YWdzOwogCV9fbGUxNglDb21wcmVzc2lvbkFsZ29yaXRobXNbM107CisJLyogQ2hlY2sgaWYgcGFk
IG5lZWRlZCAqLwogfSBfX3BhY2tlZDsKIAogLyoKQEAgLTQyMCw2ICs0MjEsNyBAQCBzdHJ1Y3Qg
c21iMl90cmFuc3BvcnRfY2FwYWJpbGl0aWVzX2NvbnRleHQgewogCV9fbGUxNiAgRGF0YUxlbmd0
aDsKIAlfX3UzMglSZXNlcnZlZDsKIAlfX2xlMzIJRmxhZ3M7CisJX191MzIJUGFkOwogfSBfX3Bh
Y2tlZDsKIAogLyoKQEAgLTQ1OCw2ICs0NjAsNyBAQCBzdHJ1Y3Qgc21iMl9zaWduaW5nX2NhcGFi
aWxpdGllcyB7CiAJX191MzIJUmVzZXJ2ZWQ7CiAJX19sZTE2CVNpZ25pbmdBbGdvcml0aG1Db3Vu
dDsKIAlfX2xlMTYJU2lnbmluZ0FsZ29yaXRobXNbXTsKKwkvKiAgRm9sbG93ZWQgYnkgcGFkZGlu
ZyB0byA4IGJ5dGUgYm91bmRhcnkgKHJlcXVpcmVkIGJ5IHNvbWUgc2VydmVycykgKi8KIH0gX19w
YWNrZWQ7CiAKICNkZWZpbmUgUE9TSVhfQ1RYVF9EQVRBX0xFTgkxNgotLSAKMi4zMC4yCgo=
--000000000000222ba605c6956292--
