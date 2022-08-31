Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC25BECAAD4
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 01:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiHaBFO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiHaBFN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 21:05:13 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4220481CE
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 18:05:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id p16so22336652ejb.9
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 18:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=sCJX59KTHfIF6qIdYJLavrAvNmN5wTE27Lc7+hZojOw=;
        b=lUzWRaz7ibjbcIqCHeIhBKpZnUgIMNax7MHOV6arOHSgwMJCIeQSh7oyISuP3kfnII
         YrHZols1wtNkZOMjhljK1YzTINkXURr/tDoWmA6GhUqlCkjP9QPZsTAHQj8teH1pSxyd
         z4KDDOmIab3JvInfE2v8/tO7rSmys96VA2HIdbCp823EfEnJI+lIFcSw+VYZqwM1QKuO
         421l1wlIE50P2uLonkm3V5GTCfPd7IDNyK8J74YeHl+DrqsH7Nyl1P0czj1pvwYuXSWi
         M3Q3NQ1Aw8NVqCGrpE0dFiY88zBV0Dl3hDESOVcPKeExNtZXg8HCFQvK+FFuMBcihwtW
         /PDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=sCJX59KTHfIF6qIdYJLavrAvNmN5wTE27Lc7+hZojOw=;
        b=xy1LIt/I3N2gfvvrdvggKMSR5bsUNLNaDPP8IBpaRlc2iDQK40SpLM3rUMFP3ufJMl
         IOA4SvQ02i562Ajs0GGHnoHcM1sN1IFjFvZHFwsJNP++VakTUhwe3ExcD+Spx48pqM2l
         HSH+prkgU5ZLckWtZIVhsSOZDaihSV7b0WCcWm/LCPP3ttlpyMpV4yP0JfTE5FIJM6Q7
         OUrK2Uk+NlHUcAqmaKqok4xRHKNjLAjIn3t07JrfyB+O/XdADfAf2rYjxxprGdD3FFP5
         uk1tlcfQcuPT7BEacV3nPlqZNo2uzf4S13flupTKg6pysNQz8bTbfXKD8y/30vdS4Bty
         V4kw==
X-Gm-Message-State: ACgBeo34YBHezQdnp29RUch1gM11m603k3H3VEef4eSwmzHljRr8SkTo
        QYcig9sTSKTQhrnIm+dtgUFjbrfvX1Pl/ohW7tM=
X-Google-Smtp-Source: AA6agR6Vtthez3e0pCH36lNOAc6g6Eed2BpSqn0lMzMWHLLTJST4DQOaK6jU3GxEzk7W0xJGH94i5KaGFzjdO+C2PdI=
X-Received: by 2002:a17:906:4758:b0:73d:d3b9:b268 with SMTP id
 j24-20020a170906475800b0073dd3b9b268mr18215284ejs.720.1661907910323; Tue, 30
 Aug 2022 18:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220830225151.26201-1-ematsumiya@suse.de>
In-Reply-To: <20220830225151.26201-1-ematsumiya@suse.de>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 31 Aug 2022 11:04:58 +1000
Message-ID: <CAN05THThEdPdn4UVici+vM13m9FRbTaSCmxdC2SMUxaENqfqmw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix small mempool leak in SMB2_negotiate()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

LGTM
reviewed-by me

On Wed, 31 Aug 2022 at 08:51, Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> In some cases of failure (dialect mismatches) in SMB2_negotiate(), after
> the request is sent, the checks would return -EIO when they should be
> rather setting rc = -EIO and jumping to neg_exit to free the response
> buffer from mempool.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/smb2pdu.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 128e44e57528..6352ab32c7e7 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -965,16 +965,17 @@ SMB2_negotiate(const unsigned int xid,
>         } else if (rc != 0)
>                 goto neg_exit;
>
> +       rc = -EIO;
>         if (strcmp(server->vals->version_string,
>                    SMB3ANY_VERSION_STRING) == 0) {
>                 if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
>                         cifs_server_dbg(VFS,
>                                 "SMB2 dialect returned but not requested\n");
> -                       return -EIO;
> +                       goto neg_exit;
>                 } else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
>                         cifs_server_dbg(VFS,
>                                 "SMB2.1 dialect returned but not requested\n");
> -                       return -EIO;
> +                       goto neg_exit;
>                 } else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
>                         /* ops set to 3.0 by default for default so update */
>                         server->ops = &smb311_operations;
> @@ -985,7 +986,7 @@ SMB2_negotiate(const unsigned int xid,
>                 if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
>                         cifs_server_dbg(VFS,
>                                 "SMB2 dialect returned but not requested\n");
> -                       return -EIO;
> +                       goto neg_exit;
>                 } else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
>                         /* ops set to 3.0 by default for default so update */
>                         server->ops = &smb21_operations;
> @@ -999,7 +1000,7 @@ SMB2_negotiate(const unsigned int xid,
>                 /* if requested single dialect ensure returned dialect matched */
>                 cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
>                                 le16_to_cpu(rsp->DialectRevision));
> -               return -EIO;
> +               goto neg_exit;
>         }
>
>         cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
> @@ -1017,9 +1018,10 @@ SMB2_negotiate(const unsigned int xid,
>         else {
>                 cifs_server_dbg(VFS, "Invalid dialect returned by server 0x%x\n",
>                                 le16_to_cpu(rsp->DialectRevision));
> -               rc = -EIO;
>                 goto neg_exit;
>         }
> +
> +       rc = 0;
>         server->dialect = le16_to_cpu(rsp->DialectRevision);
>
>         /*
> --
> 2.35.3
>
