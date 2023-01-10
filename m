Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBF9C54EBC
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 23:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjAJX6F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbjAJX54 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 18:57:56 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5137F58D3C
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 15:57:44 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id y25so20958888lfa.9
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 15:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j79+3LtPDJNj+KR8aBbyvP6x1doiPfwU9WK9ewglJoo=;
        b=AOY5MX7HvBX1dmCI5UbIUgrgRqpH1CqaghTtdO12Klz2hHOlnjQbH8nst7fNQ6z09n
         In8ZgjSio+in+NSdFBZH9BQCrLMGSCmDv/yl+Ug7kLIPfi4N4RXfVTXdwSU39o5QJypo
         Vl55t2jrzumXvQjYv20ajxee3MT4oV9fHpMZhGv7XQ6ZJFdt5QUac+xTTvQlEI0PAugD
         PzUVTUHhCOdhhmFQGXs7VZEmyj2H3vOFT+xisalOdciVPyPUedhcb0d31EVmQY+DiD9P
         PSnpHdVfT46JLdae5yWpX3tlgTXH9xEpll2n2VKu6BlrP9FjuIZrLPIaRSNqJGMAGqLX
         VwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j79+3LtPDJNj+KR8aBbyvP6x1doiPfwU9WK9ewglJoo=;
        b=4HO9asdpDH1Ksnmmeu3Rhr80tQsAtkJdo6NxgtLwvM/CHQn8c9r5E58LogvWhm0rim
         pr8WeDnLcurqD2hudQ5yhrs/IpzkQV+jK8/9OA98QS4Xgc3RD6SPcbe7ZLNo7moAU37c
         mFIg8Lf8m7kmc3HEZNYlsBPgPkMs/OViDulh2Fcm42voVUwTZgb2St9VIZ4CVPybSURM
         PFzPZXGNEV6nnUiEIAqhqfgtBwpxVV5hXd7mypd3gzHfxwqaW3ATiQHRjrY8ZUMpJ/t7
         sngpSOgDqpdoICi8tz69kvjI3Fm6POK9JdrAzqvhd38P99d5a1aWOeXt737Ko7XEWBo1
         CPfA==
X-Gm-Message-State: AFqh2kpJMV67DfDoDuKUl0PV8wd1RNzwigqbkM3/sQ//0zmBn8YIzKTx
        QRBRaiQA3BSYWxCfevKHmLCQpmsVjTxd6ufiuJg8Qf3y
X-Google-Smtp-Source: AMrXdXtm90+eRliTXv5ajfg+hF+Z1f2BS0Ao3MrAWCccra2n5/tyd8vFFozBxST2xx0ejsr2ZZChBHuyLOxQnseC47Q=
X-Received: by 2002:ac2:5bc2:0:b0:4b5:a2a9:9385 with SMTP id
 u2-20020ac25bc2000000b004b5a2a99385mr6554148lfn.536.1673395063545; Tue, 10
 Jan 2023 15:57:43 -0800 (PST)
MIME-Version: 1.0
References: <20230110233546.22910-1-pc@cjr.nz>
In-Reply-To: <20230110233546.22910-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 10 Jan 2023 17:57:32 -0600
Message-ID: <CAH2r5muVA57yOCt7kv2ERgcXJ2AfffDkciKtJRaD_POhds7BBA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix potential memory leaks in session setup
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending any additional review/testing

On Tue, Jan 10, 2023 at 5:35 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Make sure to free cifs_ses::auth_key.response before allocating it as
> we might end up leaking memory in reconnect or mounting.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsencrypt.c | 1 +
>  fs/cifs/sess.c        | 2 ++
>  fs/cifs/smb2pdu.c     | 1 +
>  3 files changed, 4 insertions(+)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 5db73c0f792a..cbc18b4a9cb2 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -278,6 +278,7 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
>          * ( for NTLMSSP_AV_NB_DOMAIN_NAME followed by NTLMSSP_AV_EOL ) +
>          * unicode length of a netbios domain name
>          */
> +       kfree_sensitive(ses->auth_key.response);
>         ses->auth_key.len = size + 2 * dlen;
>         ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
>         if (!ses->auth_key.response) {
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 0b842a07e157..c47b254f0d1e 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -815,6 +815,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>                 return -EINVAL;
>         }
>         if (tilen) {
> +               kfree_sensitive(ses->auth_key.response);
>                 ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
>                                                  GFP_KERNEL);
>                 if (!ses->auth_key.response) {
> @@ -1428,6 +1429,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
>                 goto out_put_spnego_key;
>         }
>
> +       kfree_sensitive(ses->auth_key.response);
>         ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
>                                          GFP_KERNEL);
>         if (!ses->auth_key.response) {
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 727f16b426be..4b71f4a92f76 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1453,6 +1453,7 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
>
>         /* keep session key if binding */
>         if (!is_binding) {
> +               kfree_sensitive(ses->auth_key.response);
>                 ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
>                                                  GFP_KERNEL);
>                 if (!ses->auth_key.response) {
> --
> 2.39.0
>


-- 
Thanks,

Steve
