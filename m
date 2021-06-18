Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719DFC48BDF
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 04:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5100061351
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 04:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhFRELZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Jun 2021 00:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhFRELX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Jun 2021 00:11:23 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA34C061574
        for <linux-cifs@vger.kernel.org>; Thu, 17 Jun 2021 21:09:13 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id a1so13928118lfr.12
        for <linux-cifs@vger.kernel.org>; Thu, 17 Jun 2021 21:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jq4B3avybY4XSJGB+m+7/MptGTh/l5uH9dNGzWIr4yg=;
        b=jcWa7DBTrJ0TdVGBWFgGBZYAbXYh0sUIYIcRYFtab3oEWf65kyQ5XamN058Jb6UTvb
         igcQaSB+lSA5rZxMYN81aERwk5gZebZgsBGJdEUiX6qEXiXV6HMxROEPZzGP3HdhGdei
         rLuNhkPF9/xOZPGWOnnmFNf2lsVuKXfmJsB3XLWn7XlRsYzVkLQq+QufiTwiwnA0KLl8
         3AQe+f6AzsNOQKAqd/wmils9VZkN4cxA0Zq53t5Z9cJGR/HaQGqvDMTsEULhSQU878Q4
         DZ8WAAY4lJ+k5F+6EZ2cSqBVCc1R06iXJUAANpHFLxUdaUQvGPmwO1vs4CDiYTZoEjYH
         moKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jq4B3avybY4XSJGB+m+7/MptGTh/l5uH9dNGzWIr4yg=;
        b=VqIdYpghb0YX67tinGPmwvrrr+7yTXx2oYnx3bFgKEc85HvXSJ0H23cNik2lKigRkY
         /8GnEsHZVg6d85rlIWcIqffwds3sxyZS9045QSqaZueU1f3SR9bkdcXAZ4tfyrYzDOiT
         trUg/crC8oWx76kAsw0IMAjP1DWxOUtFcpvts0/YtL7lrFJwYGLUHgGt01l86YIlcrgD
         H/P7UmfwQ9tu42/Oxfnl2BFDsRw0AIFOVsUgQiyApDhsmVKbFhLt465cDRUIRj26Umhq
         /Qm8+lzQtfDCaaYdLDo20JXxGiafzrp+v+SQclppp5JuE5W6By4Tecy9h8ViTE5PUDh/
         xtqQ==
X-Gm-Message-State: AOAM530qirf5vqJc3oeUQdcoo7+2g6xIop4JaDcN1YXtoteUWwHJ/SnL
        tan7FcYzf7zqV4N4nfUmZ+za9t+tmBRyqdWwQRqW+vlO9yc=
X-Google-Smtp-Source: ABdhPJzIYbjU2ZRtbsX5ujNBEyUXQ0Ck1xktimwEcny8DIPMY2pIK1R5BDce2j9uPnOScdrs3iHcsy6eUFXqc2ScL60=
X-Received: by 2002:a19:ae16:: with SMTP id f22mr1436889lfc.313.1623989351335;
 Thu, 17 Jun 2021 21:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210617084122.1117-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210617084122.1117-1-thunder.leizhen@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 17 Jun 2021 23:09:00 -0500
Message-ID: <CAH2r5msQ4NKah88JOo4yX9jZtogLnfscULRtvbn21+aP=0x=jQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] cifs: remove unnecessary oom message
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I am curious the motivation for these - I agree that removing the
debug messages saves (albeit trivial amount of) memory but curious
about how other areas of the kernel handle logging low memory/out of
memory issues?

On Thu, Jun 17, 2021 at 3:42 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>
> Fixes scripts/checkpatch.pl warning:
> WARNING: Possible unnecessary 'out of memory' message
>
> Remove it can help us save a bit of memory.
>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  fs/cifs/cifsencrypt.c | 4 +---
>  fs/cifs/connect.c     | 6 +-----
>  fs/cifs/sess.c        | 6 +-----
>  fs/cifs/smb2pdu.c     | 2 --
>  4 files changed, 3 insertions(+), 15 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index b8f1ff9a83f3..74f16730e502 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -787,10 +787,8 @@ calc_seckey(struct cifs_ses *ses)
>         get_random_bytes(sec_key, CIFS_SESS_KEY_SIZE);
>
>         ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
> -       if (!ctx_arc4) {
> -               cifs_dbg(VFS, "Could not allocate arc4 context\n");
> +       if (!ctx_arc4)
>                 return -ENOMEM;
> -       }
>
>         arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
>         arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 05f5c84a63a4..b52bb6dc6ecb 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -97,10 +97,8 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
>         len = strlen(server->hostname) + 3;
>
>         unc = kmalloc(len, GFP_KERNEL);
> -       if (!unc) {
> -               cifs_dbg(FYI, "%s: failed to create UNC path\n", __func__);
> +       if (!unc)
>                 return -ENOMEM;
> -       }
>         scnprintf(unc, len, "\\\\%s", server->hostname);
>
>         rc = dns_resolve_server_name_to_ip(unc, &ipaddr);
> @@ -1758,8 +1756,6 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
>         if (is_domain && ses->domainName) {
>                 ctx->domainname = kstrdup(ses->domainName, GFP_KERNEL);
>                 if (!ctx->domainname) {
> -                       cifs_dbg(FYI, "Unable to allocate %zd bytes for domain\n",
> -                                len);
>                         rc = -ENOMEM;
>                         kfree(ctx->username);
>                         ctx->username = NULL;
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index cd19aa11f27e..cc97b2981c3d 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -602,10 +602,8 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>         if (tilen) {
>                 ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
>                                                  GFP_KERNEL);
> -               if (!ses->auth_key.response) {
> -                       cifs_dbg(VFS, "Challenge target info alloc failure\n");
> +               if (!ses->auth_key.response)
>                         return -ENOMEM;
> -               }
>                 ses->auth_key.len = tilen;
>         }
>
> @@ -1338,8 +1336,6 @@ sess_auth_kerberos(struct sess_data *sess_data)
>         ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
>                                          GFP_KERNEL);
>         if (!ses->auth_key.response) {
> -               cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory\n",
> -                        msg->sesskey_len);
>                 rc = -ENOMEM;
>                 goto out_put_spnego_key;
>         }
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index c205f93e0a10..2b978564e188 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1355,8 +1355,6 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
>                 ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
>                                                  GFP_KERNEL);
>                 if (!ses->auth_key.response) {
> -                       cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory\n",
> -                                msg->sesskey_len);
>                         rc = -ENOMEM;
>                         goto out_put_spnego_key;
>                 }
> --
> 2.25.1
>
>


-- 
Thanks,

Steve
