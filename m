Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B32DC07E9D
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 05:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbiI2FWe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 01:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbiI2FWd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 01:22:33 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECD27A53C
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 22:22:32 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id g27so126338vkl.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 22:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3aWMy+Yar80JBG9pm8+ChL7zyiLBGBSsM/Z537d2kk8=;
        b=alTBmjkNpVCtpCYX9OfQgmyFRUnZju7gPWTnsGU/+jWbPWz8zEe/Oi7H3qexBWgPtb
         Sk6LQPrBWwc59JLJIc4/pJ/BBw4w2uX27LzPq4H4a6nsNjTwSddpnDcCcblSiwZfy8O3
         fcNhtlO4V9nkp9Wr/YFCyOTbrZhQurfAsbjEeDbu+FIrU+pP6eaESVgf8gw4jjmEn8yD
         CFMx7h0RU5Ex6HtdnxYomGHyDmv1bATrKt9Nbgc9IBCwA0a46BqlCUumRCZgPgOXErNV
         1e+6RcoI78yB7MC0NLoahAV8bnlsq9wQmDrODGYQCzlxWUQSLaEzaXiYilxyrAIWgu9t
         OHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3aWMy+Yar80JBG9pm8+ChL7zyiLBGBSsM/Z537d2kk8=;
        b=Cg/xOxvkJSFQLdaNHZsRqs5tUeFXeYW4EchAm03jqnahliZXnHyppOjahqDCGIAgd9
         Mh2Iv2+fObMGCbgDC0V/yuDG23gf2cN/KdquQcnguDuqZeJhAsA7kJEXC0Qy/xBTl+j7
         gxHBF2rkMLjdplQkQk2Zs0jF4fnpT2mAKXg0IgSHGH68mRE3/lSX1VkOlpyS61GJii62
         hk8GAUeuQ9Q62nJYXU4Tw2tSH0bUhyE6/A1GN9Syah0RpZNqp3KhhZlTH3AAA+ImFUe/
         Y7SuQOsALlI59m77orJkKLNcLTaXFf4DxH2uFFaSN4C4+Lhc6XkRbodqlKxRz/waUYpJ
         SvLA==
X-Gm-Message-State: ACrzQf3j0ieNmWNQMkHTN3Xz1b8ZvF2PaLt35Tn8jS8xFhTPxb4YzeLi
        igU3f81/dm0C6D8rzbGDAebFayV+7BiDHDEiTMg=
X-Google-Smtp-Source: AMsMyM4MwfxWDJudqS+Qkvw8yoqoZpj62nXJg0V4P2w57NbOHgQWkwe5/BgrIWvsyC32aZnI+Y+fAewmlj0y9qiU3wQ=
X-Received: by 2002:a1f:a788:0:b0:3a1:e690:a2a3 with SMTP id
 q130-20020a1fa788000000b003a1e690a2a3mr569638vke.4.1664428951463; Wed, 28 Sep
 2022 22:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220929015637.14400-1-ematsumiya@suse.de> <20220929015637.14400-7-ematsumiya@suse.de>
In-Reply-To: <20220929015637.14400-7-ematsumiya@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Sep 2022 00:22:20 -0500
Message-ID: <CAH2r5muptvyCo0MYZMv58V+g9DMfSbcWLSKPFSUGd22Lkg458A@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] cifs: deprecate 'enable_negotiate_signing' module param
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

could you fix these minor checkpatch warnings?

ERROR: code indent should use tabs where possible
#74: FILE: fs/cifs/cifsglob.h:2035:
+^I^I^I^I         XXX: deprecated, remove it at some point */$

WARNING: Block comments use * on subsequent lines
#74: FILE: fs/cifs/cifsglob.h:2035:
+extern bool enable_negotiate_signing; /* request use of faster (GMAC)
signing if available
+          XXX: deprecated, remove it at some point */

WARNING: Block comments use a trailing */ on a separate line
#74: FILE: fs/cifs/cifsglob.h:2035:
+          XXX: deprecated, remove it at some point */

total: 1 errors, 5 warnings, 58 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

0006-cifs-deprecate-enable_negotiate_signing-module-param.patch has
style problems, please review.

On Wed, Sep 28, 2022 at 8:57 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Deprecate enable_negotiate_signing module parameter as it's irrelevant
> since the requested dialect and server support will dictate which
> algorithm will actually be used.
>
> Send a negotiate signing context on every SMB 3.1.1 negotiation now.
> AES-CMAC will still be used instead, iff, SMB 3.0.x negotiated or
> SMB 3.1.1 negotiated, but server doesn't support AES-GMAC.
>
> Warn the user if, for whatever reason, the module was loaded with
> 'enable_negotiate_signing=0'.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/cifsfs.c   | 14 +++++++++++---
>  fs/cifs/cifsglob.h |  3 ++-
>  fs/cifs/smb2pdu.c  | 11 ++++-------
>  3 files changed, 17 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 8042d7280dec..c46dc9edf6ec 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -65,7 +65,7 @@ bool lookupCacheEnabled = true;
>  bool disable_legacy_dialects; /* false by default */
>  bool enable_gcm_256 = true;
>  bool require_gcm_256; /* false by default */
> -bool enable_negotiate_signing; /* false by default */
> +bool enable_negotiate_signing = true; /* deprecated -- always true now */
>  unsigned int global_secflags = CIFSSEC_DEF;
>  /* unsigned int ntlmv2_support = 0; */
>  unsigned int sign_CIFS_PDUs = 1;
> @@ -133,8 +133,12 @@ MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encr
>  module_param(require_gcm_256, bool, 0644);
>  MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");
>
> -module_param(enable_negotiate_signing, bool, 0644);
> -MODULE_PARM_DESC(enable_negotiate_signing, "Enable negotiating packet signing algorithm with server. Default: n/N/0");
> +/* XXX: remove this at some point */
> +module_param(enable_negotiate_signing, bool, 0);
> +MODULE_PARM_DESC(enable_negotiate_signing,
> +                "(deprecated) Enable negotiating packet signing algorithm with the server. "
> +                "This parameter is ignored as cifs.ko will always try to negotiate the signing "
> +                "algorithm on SMB 3.1.1 mounts.");
>
>  module_param(disable_legacy_dialects, bool, 0644);
>  MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
> @@ -1712,6 +1716,10 @@ init_cifs(void)
>                 goto out_init_cifs_idmap;
>         }
>
> +       if (!enable_negotiate_signing)
> +               pr_warn_once("ignoring deprecated module parameter 'enable_negotiate_signing=0', "
> +                            "will try to negotiate signing capabilities anyway...\n");
> +
>         return 0;
>
>  out_init_cifs_idmap:
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 81a8eff06467..cadde6c451e5 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -2031,7 +2031,8 @@ extern unsigned int global_secflags;      /* if on, session setup sent
>  extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
>  extern bool enable_gcm_256; /* allow optional negotiate of strongest signing (aes-gcm-256) */
>  extern bool require_gcm_256; /* require use of strongest signing (aes-gcm-256) */
> -extern bool enable_negotiate_signing; /* request use of faster (GMAC) signing if available */
> +extern bool enable_negotiate_signing; /* request use of faster (GMAC) signing if available
> +                                        XXX: deprecated, remove it at some point */
>  extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
>  extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
>  extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 2c2bf28382bc..6c1d58492b18 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -609,13 +609,10 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
>                 neg_context_count++;
>         }
>
> -       if (enable_negotiate_signing) {
> -               ctxt_len = build_signing_ctxt((struct smb2_signing_capabilities *)
> -                               pneg_ctxt);
> -               *total_len += ctxt_len;
> -               pneg_ctxt += ctxt_len;
> -               neg_context_count++;
> -       }
> +       ctxt_len = build_signing_ctxt((struct smb2_signing_capabilities *)pneg_ctxt);
> +       *total_len += ctxt_len;
> +       pneg_ctxt += ctxt_len;
> +       neg_context_count++;
>
>         /* check for and add transport_capabilities and signing capabilities */
>         req->NegotiateContextCount = cpu_to_le16(neg_context_count);
> --
> 2.35.3
>


-- 
Thanks,

Steve
