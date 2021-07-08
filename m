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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F55C07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 04:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 043AB6195E
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 04:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhGHEaH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 00:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhGHEaF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 00:30:05 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32198C061574
        for <linux-cifs@vger.kernel.org>; Wed,  7 Jul 2021 21:27:24 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id q18so10980567lfc.7
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jul 2021 21:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7wtlRVAqe/8txmwM775om9MyiSMpGWwnJbBcmAI7Tec=;
        b=i24OHgZzfpYMBgP5PBpl1PB/utwF/GUrT1q74ZtXYMMbYlwoe0gXrcZZs2Utnzq5cu
         BVd4R7vhnRkDd9Q9TMTFXGhzslb5VzO/3HO//X/smQbYCXlPOtFtV9oywoa5ZmodU+/5
         6x9fHtBVdSNPNJodX+8Ve57OOruhIECgMI2l8brUrmPeL3ga/i6fX5o9LtaC8ZAyyggI
         KLOGNr+nfKU31XlfKndiKTlPC4xAJxM7FsrYWuaUrOd3xlpHaLhzg3DY/SXi+OiQWMlb
         kk8Fk4SufGlXGYgoHtNqTATHfl1cb+OBGZVduDjcslHkmFPn/QvhWrMvkSEJ0oXIqJlZ
         /nPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wtlRVAqe/8txmwM775om9MyiSMpGWwnJbBcmAI7Tec=;
        b=CELr4cCZapkdFWGRtVocerumCSxgDA1uJKZsh7SzYLoCwRTmdXz7xISgFmSCgaSsOY
         IEpWgviec8Ds2xLAFoxPfTOyZjktmozazvuw4wr277yba00otzPWNHdbEF+4VroftMwp
         nQzdFNn0Dgn9noo0FAp5xhyfaonCepb+76FodPIMInQ5a6g9Fv9Dqm7fah/5SZ0U7HWi
         jlNQmNsqwJ4Y+qEQpMwiYIJHjwukJ8pZeNF6eGuWV909RMs/VJqzvRuADkzDxLDku2tk
         RmZX/rrHxoHaxbMeqna3mDh5gNmW9mWGIasvF6XVsY/oFzL/Y3ID9njYy0+/bWr4g+Yz
         Vu7w==
X-Gm-Message-State: AOAM530tN/oe43/WyLA4aFVqtSKBuZvjTfaaV9ckksCAh/au+ovzW6/S
        uZ2rq2uIc0V0tw7Wc1xOBnzqc86Dmhr8PMIj31ZsHKCG
X-Google-Smtp-Source: ABdhPJw8Ispd40c869oJ6y00+FahF6TuNKL5ctDO4N725/jDcEcyzXNt4AESKfym6ikIJb84lQKoBTTMLP3Bg9myTtY=
X-Received: by 2002:a05:651c:a07:: with SMTP id k7mr22913069ljq.477.1625718442151;
 Wed, 07 Jul 2021 21:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvS6aHG8dXBre0RuGPzUb0g1hh-OPnhEup9PrX5z0zv5g@mail.gmail.com>
In-Reply-To: <CAH2r5mvS6aHG8dXBre0RuGPzUb0g1hh-OPnhEup9PrX5z0zv5g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 7 Jul 2021 23:27:08 -0500
Message-ID: <CAH2r5mu_fVutwr+XY8i-EpWO9gTw+dvHoy1oFk_wxHeMuVgxqA@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] add ability to send signing negotiate context
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000003feb0205c6951244"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003feb0205c6951244
Content-Type: text/plain; charset="UTF-8"

v3 of patch.  Updated with additional feedback from Ronnie (to make it
more context len and datalength clearer)


On Wed, Jul 7, 2021 at 9:44 PM Steve French <smfrench@gmail.com> wrote:
>
> Support for faster packet signing (using GMAC instead of CMAC) can
> now be negotiated to some newer servers, including Windows.
> See MS-SMB2 section 2.2.3.17.
>
> This patch adds support for sending the new negotiate context
> with the first of three supported signing algorithms (AES-CMAC)
> and decoding the response.  A followon patch will add support
> for sending the other two (including AES-GMAC, which is fastest)
> and changing the signing algorithm used based on what was
> negotiated.
>
> To allow the client to request GMAC signing set module parameter
> "enable_negotiate_signing" to 1.
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifsfs.c   |  4 +++
>  fs/cifs/cifsglob.h |  3 ++
>  fs/cifs/smb2pdu.c  | 83 ++++++++++++++++++++++++++++++++++++++++------
>  fs/cifs/smb2pdu.h  |  5 ++-
>  4 files changed, 84 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 9fb874dd8d24..476b07213fcd 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -65,6 +65,7 @@ bool lookupCacheEnabled = true;
>  bool disable_legacy_dialects; /* false by default */
>  bool enable_gcm_256 = true;
>  bool require_gcm_256; /* false by default */
> +bool enable_negotiate_signing; /* false by default */
>  unsigned int global_secflags = CIFSSEC_DEF;
>  /* unsigned int ntlmv2_support = 0; */
>  unsigned int sign_CIFS_PDUs = 1;
> @@ -104,6 +105,9 @@ MODULE_PARM_DESC(enable_gcm_256, "Enable
> requesting strongest (256 bit) GCM encr
>  module_param(require_gcm_256, bool, 0644);
>  MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM
> encryption. Default: n/N/0");
>
> +module_param(enable_negotiate_signing, bool, 0644);
> +MODULE_PARM_DESC(enable_GMAC_signing, "Enable requesting faster
> (GMAC) packet signing. Default: n/N/0");
> +
>  module_param(disable_legacy_dialects, bool, 0644);
>  MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
>     "helpful to restrict the ability to "
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 921680fb7931..3c2e117bb926 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -667,9 +667,11 @@ struct TCP_Server_Info {
>   unsigned int max_write;
>   unsigned int min_offload;
>   __le16 compress_algorithm;
> + __u16 signing_algorithm;
>   __le16 cipher_type;
>   /* save initital negprot hash */
>   __u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
> + bool signing_negotiated; /* true if valid signing context rcvd from server */
>   bool posix_ext_supported;
>   struct delayed_work reconnect; /* reconnect workqueue job */
>   struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
> @@ -1869,6 +1871,7 @@ extern unsigned int global_secflags; /* if on,
> session setup sent
>  extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
>  extern bool enable_gcm_256; /* allow optional negotiate of strongest
> signing (aes-gcm-256) */
>  extern bool require_gcm_256; /* require use of strongest signing
> (aes-gcm-256) */
> +extern bool enable_negotiate_signing; /* request use of faster (GMAC)
> signing if available */
>  extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
>  extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
>  extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 962826dc3316..757f145e70e5 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -433,6 +433,23 @@ build_compression_ctxt(struct
> smb2_compression_capabilities_context *pneg_ctxt)
>   pneg_ctxt->CompressionAlgorithms[2] = SMB3_COMPRESS_LZNT1;
>  }
>
> +static void
> +build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
> +{
> + pneg_ctxt->ContextType = SMB2_SIGNING_CAPABILITIES;
> + /*
> + * Data length must be increased here if more than 3 signing algorithms
> + * sent but currently only 3 are defined. And context Data length must
> + * be rounded to multiple of 8 for some servers.
> + */
> + pneg_ctxt->DataLength =
> + cpu_to_le16(DIV_ROUND_UP(sizeof(struct smb2_signing_capabilities) -
> + sizeof(struct smb2_neg_context), 8) * 8);
> + pneg_ctxt->SigningAlgorithmCount = cpu_to_le16(1);
> + pneg_ctxt->SigningAlgorithms[0] = cpu_to_le16(SIGNING_ALG_AES_CMAC);
> + /* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA256 */
> +}
> +
>  static void
>  build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
>  {
> @@ -498,7 +515,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
>         struct TCP_Server_Info *server, unsigned int *total_len)
>  {
>   char *pneg_ctxt;
> - unsigned int ctxt_len;
> + unsigned int ctxt_len, neg_context_count;
>
>   if (*total_len > 200) {
>   /* In case length corrupted don't want to overrun smb buffer */
> @@ -525,6 +542,17 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
>   *total_len += ctxt_len;
>   pneg_ctxt += ctxt_len;
>
> + ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
> + server->hostname);
> + *total_len += ctxt_len;
> + pneg_ctxt += ctxt_len;
> +
> + build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
> + *total_len += sizeof(struct smb2_posix_neg_context);
> + pneg_ctxt += sizeof(struct smb2_posix_neg_context);
> +
> + neg_context_count = 4;
> +
>   if (server->compress_algorithm) {
>   build_compression_ctxt((struct smb2_compression_capabilities_context *)
>   pneg_ctxt);
> @@ -533,17 +561,24 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
>   8) * 8;
>   *total_len += ctxt_len;
>   pneg_ctxt += ctxt_len;
> - req->NegotiateContextCount = cpu_to_le16(5);
> - } else
> - req->NegotiateContextCount = cpu_to_le16(4);
> + neg_context_count++;
> + }
>
> - ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
> - server->hostname);
> - *total_len += ctxt_len;
> - pneg_ctxt += ctxt_len;
> + if (enable_negotiate_signing) {
> + pr_warn_once("requesting GMAC signing is experimental\n");
> + build_signing_ctxt((struct smb2_signing_capabilities *)
> + pneg_ctxt);
> + ctxt_len = DIV_ROUND_UP(
> + sizeof(struct smb2_signing_capabilities),
> + 8) * 8;
> + *total_len += ctxt_len;
> + pneg_ctxt += ctxt_len;
> + neg_context_count++;
> + }
> +
> + /* check for and add transport_capabilities and signing capabilities */
> + req->NegotiateContextCount = cpu_to_le16(neg_context_count);
>
> - build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
> - *total_len += sizeof(struct smb2_posix_neg_context);
>  }
>
>  static void decode_preauth_context(struct smb2_preauth_neg_context *ctxt)
> @@ -632,6 +667,31 @@ static int decode_encrypt_ctx(struct
> TCP_Server_Info *server,
>   return 0;
>  }
>
> +static void decode_signing_ctx(struct TCP_Server_Info *server,
> +        struct smb2_signing_capabilities *pctxt)
> +{
> + unsigned int len = le16_to_cpu(pctxt->DataLength);
> +
> + if ((len < 4) || (len > 16)) {
> + pr_warn_once("server sent bad signing negcontext\n");
> + return;
> + }
> + if (le16_to_cpu(pctxt->SigningAlgorithmCount) != 1) {
> + pr_warn_once("Invalid signing algorithm count\n");
> + return;
> + }
> + if (le16_to_cpu(pctxt->SigningAlgorithms[0]) > 2) {
> + pr_warn_once("unknown signing algorithm\n");
> + return;
> + }
> +
> + server->signing_negotiated = true;
> + server->signing_algorithm = le16_to_cpu(pctxt->SigningAlgorithms[0]);
> + cifs_dbg(FYI, "signing algorithm %d chosen\n",
> +      server->signing_algorithm);
> +}
> +
> +
>  static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
>        struct TCP_Server_Info *server,
>        unsigned int len_of_smb)
> @@ -675,6 +735,9 @@ static int smb311_decode_neg_context(struct
> smb2_negotiate_rsp *rsp,
>   (struct smb2_compression_capabilities_context *)pctx);
>   else if (pctx->ContextType == SMB2_POSIX_EXTENSIONS_AVAILABLE)
>   server->posix_ext_supported = true;
> + else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES)
> + decode_signing_ctx(server,
> + (struct smb2_signing_capabilities *)pctx);
>   else
>   cifs_server_dbg(VFS, "unknown negcontext of type %d ignored\n",
>   le16_to_cpu(pctx->ContextType));
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index ba75e65924ac..4b27cb9105fd 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -329,7 +329,7 @@ struct smb2_neg_context {
>   __le16 ContextType;
>   __le16 DataLength;
>   __le32 Reserved;
> - /* Followed by array of data */
> + /* Followed by array of data. NOTE: some servers require padding to
> 8 byte boundary */
>  } __packed;
>
>  #define SMB311_LINUX_CLIENT_SALT_SIZE 32
> @@ -394,6 +394,7 @@ struct smb2_compression_capabilities_context {
>   __u16 Padding;
>   __u32 Flags;
>   __le16 CompressionAlgorithms[3];
> + /* Check if pad needed */
>  } __packed;
>
>  /*
> @@ -420,6 +421,7 @@ struct smb2_transport_capabilities_context {
>   __le16  DataLength;
>   __u32 Reserved;
>   __le32 Flags;
> + __u32 Pad;
>  } __packed;
>
>  /*
> @@ -458,6 +460,7 @@ struct smb2_signing_capabilities {
>   __u32 Reserved;
>   __le16 SigningAlgorithmCount;
>   __le16 SigningAlgorithms[];
> + /*  Followed by padding to 8 byte boundary (required by some servers) */
>  } __packed;
>
>  #define POSIX_CTXT_DATA_LEN 16
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000003feb0205c6951244
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-Add-support-for-negotiating-signing-algorit.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-Add-support-for-negotiating-signing-algorit.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kquergbj0>
X-Attachment-Id: f_kquergbj0

RnJvbSAzODdjODU2YmY4YjgwOThjMmQ4NzUwMzc2ZGNkZTI4OWY1OTUyZWU3IE1vbiBTZXAgMTcg
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
KysKIGZzL2NpZnMvc21iMnBkdS5jICB8IDg1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0KIGZzL2NpZnMvc21iMnBkdS5oICB8ICA1ICsrLQogNCBmaWxlcyBj
aGFuZ2VkLCA4NiBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9m
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
CmluZGV4IDk2MjgyNmRjMzMxNi4uMjI1OGZmNDEzMjA0IDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nt
YjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtNDMzLDYgKzQzMywyOCBAQCBidWls
ZF9jb21wcmVzc2lvbl9jdHh0KHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19j
b250ZXh0ICpwbmVnX2N0eHQpCiAJcG5lZ19jdHh0LT5Db21wcmVzc2lvbkFsZ29yaXRobXNbMl0g
PSBTTUIzX0NPTVBSRVNTX0xaTlQxOwogfQogCitzdGF0aWMgdW5zaWduZWQgaW50CitidWlsZF9z
aWduaW5nX2N0eHQoc3RydWN0IHNtYjJfc2lnbmluZ19jYXBhYmlsaXRpZXMgKnBuZWdfY3R4dCkK
K3sKKwl1bnNpZ25lZCBpbnQgY3R4dF9sZW4gPSBzaXplb2Yoc3RydWN0IHNtYjJfc2lnbmluZ19j
YXBhYmlsaXRpZXMpOworCisJcG5lZ19jdHh0LT5Db250ZXh0VHlwZSA9IFNNQjJfU0lHTklOR19D
QVBBQklMSVRJRVM7CisJLyoKKwkgKiBDb250ZXh0IERhdGEgbGVuZ3RoIG11c3QgYmUgcm91bmRl
ZCB0byBtdWx0aXBsZSBvZiA4IGZvciBzb21lIHNlcnZlcnMKKwkgKi8KKwlwbmVnX2N0eHQtPkRh
dGFMZW5ndGggPSBjcHVfdG9fbGUxNihESVZfUk9VTkRfVVAoCisJCQkJc2l6ZW9mKHN0cnVjdCBz
bWIyX3NpZ25pbmdfY2FwYWJpbGl0aWVzKSAtCisJCQkJc2l6ZW9mKHN0cnVjdCBzbWIyX25lZ19j
b250ZXh0KSArCisJCQkJKDIgLyogc2l6ZW9mIHUxNiAqLyAqIDEgLyogU2lnbmluZ0FsZ29yaXRo
bUNvdW50ICovKSwgOCkgKiA4KTsKKwlwbmVnX2N0eHQtPlNpZ25pbmdBbGdvcml0aG1Db3VudCA9
IGNwdV90b19sZTE2KDEpOworCXBuZWdfY3R4dC0+U2lnbmluZ0FsZ29yaXRobXNbMF0gPSBjcHVf
dG9fbGUxNihTSUdOSU5HX0FMR19BRVNfQ01BQyk7CisKKwljdHh0X2xlbiArPSAyIC8qIHNpemVv
ZiB1MTYgKi8gKiAxIC8qIFNpZ25pbmdBbGdvcml0aG1Db3VudCAqLzsKKwljdHh0X2xlbiA9IERJ
Vl9ST1VORF9VUChjdHh0X2xlbiwgOCkgKiA4OworCXJldHVybiBjdHh0X2xlbjsKKwkvKiBUQkQg
YWRkIFNJR05JTkdfQUxHX0FFU19HTUFDIGFuZC9vciBTSUdOSU5HX0FMR19ITUFDX1NIQTI1NiAq
LworfQorCiBzdGF0aWMgdm9pZAogYnVpbGRfZW5jcnlwdF9jdHh0KHN0cnVjdCBzbWIyX2VuY3J5
cHRpb25fbmVnX2NvbnRleHQgKnBuZWdfY3R4dCkKIHsKQEAgLTQ5OCw3ICs1MjAsNyBAQCBhc3Nl
bWJsZV9uZWdfY29udGV4dHMoc3RydWN0IHNtYjJfbmVnb3RpYXRlX3JlcSAqcmVxLAogCQkgICAg
ICBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHVuc2lnbmVkIGludCAqdG90YWxfbGVu
KQogewogCWNoYXIgKnBuZWdfY3R4dDsKLQl1bnNpZ25lZCBpbnQgY3R4dF9sZW47CisJdW5zaWdu
ZWQgaW50IGN0eHRfbGVuLCBuZWdfY29udGV4dF9jb3VudDsKIAogCWlmICgqdG90YWxfbGVuID4g
MjAwKSB7CiAJCS8qIEluIGNhc2UgbGVuZ3RoIGNvcnJ1cHRlZCBkb24ndCB3YW50IHRvIG92ZXJy
dW4gc21iIGJ1ZmZlciAqLwpAQCAtNTI1LDYgKzU0NywxNyBAQCBhc3NlbWJsZV9uZWdfY29udGV4
dHMoc3RydWN0IHNtYjJfbmVnb3RpYXRlX3JlcSAqcmVxLAogCSp0b3RhbF9sZW4gKz0gY3R4dF9s
ZW47CiAJcG5lZ19jdHh0ICs9IGN0eHRfbGVuOwogCisJY3R4dF9sZW4gPSBidWlsZF9uZXRuYW1l
X2N0eHQoKHN0cnVjdCBzbWIyX25ldG5hbWVfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQsCisJCQkJ
CXNlcnZlci0+aG9zdG5hbWUpOworCSp0b3RhbF9sZW4gKz0gY3R4dF9sZW47CisJcG5lZ19jdHh0
ICs9IGN0eHRfbGVuOworCisJYnVpbGRfcG9zaXhfY3R4dCgoc3RydWN0IHNtYjJfcG9zaXhfbmVn
X2NvbnRleHQgKilwbmVnX2N0eHQpOworCSp0b3RhbF9sZW4gKz0gc2l6ZW9mKHN0cnVjdCBzbWIy
X3Bvc2l4X25lZ19jb250ZXh0KTsKKwlwbmVnX2N0eHQgKz0gc2l6ZW9mKHN0cnVjdCBzbWIyX3Bv
c2l4X25lZ19jb250ZXh0KTsKKworCW5lZ19jb250ZXh0X2NvdW50ID0gNDsKKwogCWlmIChzZXJ2
ZXItPmNvbXByZXNzX2FsZ29yaXRobSkgewogCQlidWlsZF9jb21wcmVzc2lvbl9jdHh0KChzdHJ1
Y3Qgc21iMl9jb21wcmVzc2lvbl9jYXBhYmlsaXRpZXNfY29udGV4dCAqKQogCQkJCXBuZWdfY3R4
dCk7CkBAIC01MzMsMTcgKzU2NiwyMSBAQCBhc3NlbWJsZV9uZWdfY29udGV4dHMoc3RydWN0IHNt
YjJfbmVnb3RpYXRlX3JlcSAqcmVxLAogCQkJCTgpICogODsKIAkJKnRvdGFsX2xlbiArPSBjdHh0
X2xlbjsKIAkJcG5lZ19jdHh0ICs9IGN0eHRfbGVuOwotCQlyZXEtPk5lZ290aWF0ZUNvbnRleHRD
b3VudCA9IGNwdV90b19sZTE2KDUpOwotCX0gZWxzZQotCQlyZXEtPk5lZ290aWF0ZUNvbnRleHRD
b3VudCA9IGNwdV90b19sZTE2KDQpOworCQluZWdfY29udGV4dF9jb3VudCsrOworCX0KIAotCWN0
eHRfbGVuID0gYnVpbGRfbmV0bmFtZV9jdHh0KChzdHJ1Y3Qgc21iMl9uZXRuYW1lX25lZ19jb250
ZXh0ICopcG5lZ19jdHh0LAotCQkJCQlzZXJ2ZXItPmhvc3RuYW1lKTsKLQkqdG90YWxfbGVuICs9
IGN0eHRfbGVuOwotCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKKwlpZiAoZW5hYmxlX25lZ290aWF0
ZV9zaWduaW5nKSB7CisJCXByX3dhcm5fb25jZSgicmVxdWVzdGluZyBHTUFDIHNpZ25pbmcgaXMg
ZXhwZXJpbWVudGFsXG4iKTsKKwkJY3R4dF9sZW4gPSBidWlsZF9zaWduaW5nX2N0eHQoKHN0cnVj
dCBzbWIyX3NpZ25pbmdfY2FwYWJpbGl0aWVzICopCisJCQkJcG5lZ19jdHh0KTsKKwkJKnRvdGFs
X2xlbiArPSBjdHh0X2xlbjsKKwkJcG5lZ19jdHh0ICs9IGN0eHRfbGVuOworCQluZWdfY29udGV4
dF9jb3VudCsrOworCX0KKworCS8qIGNoZWNrIGZvciBhbmQgYWRkIHRyYW5zcG9ydF9jYXBhYmls
aXRpZXMgYW5kIHNpZ25pbmcgY2FwYWJpbGl0aWVzICovCisJcmVxLT5OZWdvdGlhdGVDb250ZXh0
Q291bnQgPSBjcHVfdG9fbGUxNihuZWdfY29udGV4dF9jb3VudCk7CiAKLQlidWlsZF9wb3NpeF9j
dHh0KChzdHJ1Y3Qgc21iMl9wb3NpeF9uZWdfY29udGV4dCAqKXBuZWdfY3R4dCk7Ci0JKnRvdGFs
X2xlbiArPSBzaXplb2Yoc3RydWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQpOwogfQogCiBzdGF0
aWMgdm9pZCBkZWNvZGVfcHJlYXV0aF9jb250ZXh0KHN0cnVjdCBzbWIyX3ByZWF1dGhfbmVnX2Nv
bnRleHQgKmN0eHQpCkBAIC02MzIsNiArNjY5LDMxIEBAIHN0YXRpYyBpbnQgZGVjb2RlX2VuY3J5
cHRfY3R4KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAlyZXR1cm4gMDsKIH0KIAor
c3RhdGljIHZvaWQgZGVjb2RlX3NpZ25pbmdfY3R4KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNl
cnZlciwKKwkJCSAgICAgICBzdHJ1Y3Qgc21iMl9zaWduaW5nX2NhcGFiaWxpdGllcyAqcGN0eHQp
Cit7CisJdW5zaWduZWQgaW50IGxlbiA9IGxlMTZfdG9fY3B1KHBjdHh0LT5EYXRhTGVuZ3RoKTsK
KworCWlmICgobGVuIDwgNCkgfHwgKGxlbiA+IDE2KSkgeworCQlwcl93YXJuX29uY2UoInNlcnZl
ciBzZW50IGJhZCBzaWduaW5nIG5lZ2NvbnRleHRcbiIpOworCQlyZXR1cm47CisJfQorCWlmIChs
ZTE2X3RvX2NwdShwY3R4dC0+U2lnbmluZ0FsZ29yaXRobUNvdW50KSAhPSAxKSB7CisJCXByX3dh
cm5fb25jZSgiSW52YWxpZCBzaWduaW5nIGFsZ29yaXRobSBjb3VudFxuIik7CisJCXJldHVybjsK
Kwl9CisJaWYgKGxlMTZfdG9fY3B1KHBjdHh0LT5TaWduaW5nQWxnb3JpdGhtc1swXSkgPiAyKSB7
CisJCXByX3dhcm5fb25jZSgidW5rbm93biBzaWduaW5nIGFsZ29yaXRobVxuIik7CisJCXJldHVy
bjsKKwl9CisKKwlzZXJ2ZXItPnNpZ25pbmdfbmVnb3RpYXRlZCA9IHRydWU7CisJc2VydmVyLT5z
aWduaW5nX2FsZ29yaXRobSA9IGxlMTZfdG9fY3B1KHBjdHh0LT5TaWduaW5nQWxnb3JpdGhtc1sw
XSk7CisJY2lmc19kYmcoRllJLCAic2lnbmluZyBhbGdvcml0aG0gJWQgY2hvc2VuXG4iLAorCQkg
ICAgIHNlcnZlci0+c2lnbmluZ19hbGdvcml0aG0pOworfQorCisKIHN0YXRpYyBpbnQgc21iMzEx
X2RlY29kZV9uZWdfY29udGV4dChzdHJ1Y3Qgc21iMl9uZWdvdGlhdGVfcnNwICpyc3AsCiAJCQkJ
ICAgICBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQkJICAgICB1bnNpZ25lZCBp
bnQgbGVuX29mX3NtYikKQEAgLTY3NSw2ICs3MzcsOSBAQCBzdGF0aWMgaW50IHNtYjMxMV9kZWNv
ZGVfbmVnX2NvbnRleHQoc3RydWN0IHNtYjJfbmVnb3RpYXRlX3JzcCAqcnNwLAogCQkJCShzdHJ1
Y3Qgc21iMl9jb21wcmVzc2lvbl9jYXBhYmlsaXRpZXNfY29udGV4dCAqKXBjdHgpOwogCQllbHNl
IGlmIChwY3R4LT5Db250ZXh0VHlwZSA9PSBTTUIyX1BPU0lYX0VYVEVOU0lPTlNfQVZBSUxBQkxF
KQogCQkJc2VydmVyLT5wb3NpeF9leHRfc3VwcG9ydGVkID0gdHJ1ZTsKKwkJZWxzZSBpZiAocGN0
eC0+Q29udGV4dFR5cGUgPT0gU01CMl9TSUdOSU5HX0NBUEFCSUxJVElFUykKKwkJCWRlY29kZV9z
aWduaW5nX2N0eChzZXJ2ZXIsCisJCQkJKHN0cnVjdCBzbWIyX3NpZ25pbmdfY2FwYWJpbGl0aWVz
ICopcGN0eCk7CiAJCWVsc2UKIAkJCWNpZnNfc2VydmVyX2RiZyhWRlMsICJ1bmtub3duIG5lZ2Nv
bnRleHQgb2YgdHlwZSAlZCBpZ25vcmVkXG4iLAogCQkJCWxlMTZfdG9fY3B1KHBjdHgtPkNvbnRl
eHRUeXBlKSk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBk
dS5oCmluZGV4IGJhNzVlNjU5MjRhYy4uNGIyN2NiOTEwNWZkIDEwMDY0NAotLS0gYS9mcy9jaWZz
L3NtYjJwZHUuaAorKysgYi9mcy9jaWZzL3NtYjJwZHUuaApAQCAtMzI5LDcgKzMyOSw3IEBAIHN0
cnVjdCBzbWIyX25lZ19jb250ZXh0IHsKIAlfX2xlMTYJQ29udGV4dFR5cGU7CiAJX19sZTE2CURh
dGFMZW5ndGg7CiAJX19sZTMyCVJlc2VydmVkOwotCS8qIEZvbGxvd2VkIGJ5IGFycmF5IG9mIGRh
dGEgKi8KKwkvKiBGb2xsb3dlZCBieSBhcnJheSBvZiBkYXRhLiBOT1RFOiBzb21lIHNlcnZlcnMg
cmVxdWlyZSBwYWRkaW5nIHRvIDggYnl0ZSBib3VuZGFyeSAqLwogfSBfX3BhY2tlZDsKIAogI2Rl
ZmluZSBTTUIzMTFfTElOVVhfQ0xJRU5UX1NBTFRfU0laRQkJCTMyCkBAIC0zOTQsNiArMzk0LDcg
QEAgc3RydWN0IHNtYjJfY29tcHJlc3Npb25fY2FwYWJpbGl0aWVzX2NvbnRleHQgewogCV9fdTE2
CVBhZGRpbmc7CiAJX191MzIJRmxhZ3M7CiAJX19sZTE2CUNvbXByZXNzaW9uQWxnb3JpdGhtc1sz
XTsKKwkvKiBDaGVjayBpZiBwYWQgbmVlZGVkICovCiB9IF9fcGFja2VkOwogCiAvKgpAQCAtNDIw
LDYgKzQyMSw3IEBAIHN0cnVjdCBzbWIyX3RyYW5zcG9ydF9jYXBhYmlsaXRpZXNfY29udGV4dCB7
CiAJX19sZTE2ICBEYXRhTGVuZ3RoOwogCV9fdTMyCVJlc2VydmVkOwogCV9fbGUzMglGbGFnczsK
KwlfX3UzMglQYWQ7CiB9IF9fcGFja2VkOwogCiAvKgpAQCAtNDU4LDYgKzQ2MCw3IEBAIHN0cnVj
dCBzbWIyX3NpZ25pbmdfY2FwYWJpbGl0aWVzIHsKIAlfX3UzMglSZXNlcnZlZDsKIAlfX2xlMTYJ
U2lnbmluZ0FsZ29yaXRobUNvdW50OwogCV9fbGUxNglTaWduaW5nQWxnb3JpdGhtc1tdOworCS8q
ICBGb2xsb3dlZCBieSBwYWRkaW5nIHRvIDggYnl0ZSBib3VuZGFyeSAocmVxdWlyZWQgYnkgc29t
ZSBzZXJ2ZXJzKSAqLwogfSBfX3BhY2tlZDsKIAogI2RlZmluZSBQT1NJWF9DVFhUX0RBVEFfTEVO
CTE2Ci0tIAoyLjMwLjIKCg==
--0000000000003feb0205c6951244--
