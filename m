Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3CCECAAD8
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 01:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiISBhv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 18 Sep 2022 21:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiISBhu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 18 Sep 2022 21:37:50 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69207186CC
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 18:37:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id m3so19376351eda.12
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 18:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=zdhG+gU+tfwk0TzORK7cIyaBok425mWzfX9sh//VqNE=;
        b=j+0ub9iPC3r0L1zPpKa6n+RdxbMQhSnfx+S22/VeZN0JMdi7EtRcY3zcEhn0ahmBw2
         EhGIaB7r6f52G7dhvnpduCXBRKeGhL2YSaQSt8b/b5CizUL+SckNKxvEtE+pKkta/R0I
         RmTVWcM35GQ1k+tH7pygVvYQqi2nARiuj02WFJoBX7EkVE1wX7Dp2s1crmCponU36vW9
         tpszp2GU6S8RVFEtikxeR6MWhQKJDh53qks3IGrC2Kwb8kMiVv15XYUyxTFUqDUV/7lI
         sFoBsan5K6wBBV1YcUnJhlwYqVSFE1mtIfGsPivfaSQ+Zbyf3ohRPiGbD2tlDoJWAm/y
         i07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=zdhG+gU+tfwk0TzORK7cIyaBok425mWzfX9sh//VqNE=;
        b=F5zbqVcD9RLKARdzDlpujnOB4tC5BjiGhIIeE0NvVlRuWQ8z0Hi0rWPlnaBLXdQ3aN
         FSQLT1wSoeTEsy73Pl9Bn5A+HecxynvsqVt3FQVFFzDejcTfSgcym3qmu/7W2SqFUDgJ
         y6WCH1mW5nwb3aE5jVZA/voXLH/1dYvWSsjOANqHhyolikbLIcUBPtceGiAAmpT7eSDQ
         2ypHpGvdh2CjAAyycdcLRe2WudAqKrL72xdCB6wZu63EzrcI7HBSBwPo4A3VCDGWtnHQ
         OH4xg9TIFrbtnLBEE1K5Q1k8WgvKt8WHyeCL44uNcgdQBgbw0GZwUn7EiYHflBfUayFa
         v5Rw==
X-Gm-Message-State: ACrzQf2BeMEYRkQojMMSQEN+Qg8yIJ75/9d+E9nECLTQaVcJ6tplrkiC
        3WGuxLf0o116rfJjyUsXpYiumsYZL3iK0NpvUgA=
X-Google-Smtp-Source: AMsMyM6svhdWHwsVSok7nd/DYfx/AvWce3fgqc1gk/UdXIiXhPbpT7LuwRvCH3HcAN+d4qNwS6LGenLwkYIVLrIWUbE=
X-Received: by 2002:a05:6402:450c:b0:443:6279:774f with SMTP id
 ez12-20020a056402450c00b004436279774fmr13995932edb.11.1663551467859; Sun, 18
 Sep 2022 18:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220918235442.2981-1-ematsumiya@suse.de>
In-Reply-To: <20220918235442.2981-1-ematsumiya@suse.de>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 19 Sep 2022 11:37:35 +1000
Message-ID: <CAN05THRj6zPX6kf_rQCm5pA6Cfpb7z20_j9cEquW_b2ipUT4aQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: check if mid was deleted in async read callback
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

LGTM
reviewed-by me.

Good catch about the race!

On Mon, 19 Sept 2022 at 09:54, Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> There's a race when cifs_readv_receive() might dequeue the mid,
> and mid->callback(), called from demultiplex thread, will try to
> access it to verify the signature before the mid is actually
> released/deleted.
>
> Currently the signature verification fails, but the verification
> shouldn't have happened at all because the mid was deleted because
> of an error, and hence not really supposed to be passed to
> ->callback(). There are no further errors because the mid is
> effectivelly gone by the end of the callback.
>
> This patch checks if the mid doesn't have the MID_DELETED flag set (by
> dequeue_mid()) right before trying to verify the signature. According to
> my tests, trying to check it earlier, e.g. after the ->receive() call in
> cifs_demultiplex_thread, will fail most of the time as dequeue_mid()
> might not have been called yet.
>
> This behaviour can be seen in xfstests generic/465, for example, where
> mids with STATUS_END_OF_FILE (-ENODATA) are dequeued and supposed to be
> discarded, but instead have their signature computed, but mismatched.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/cifssmb.c | 2 +-
>  fs/cifs/smb2pdu.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index addf3fc62aef..116f6afe33c6 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1308,7 +1308,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
>         switch (mid->mid_state) {
>         case MID_RESPONSE_RECEIVED:
>                 /* result already set, check signature */
> -               if (server->sign) {
> +               if (server->sign && !(mid->mid_flags & MID_DELETED)) {
>                         int rc = 0;
>
>                         rc = cifs_verify_signature(&rqst, server,
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 5da0b596c8a0..394996c4f729 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -4136,7 +4136,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
>                 credits.value = le16_to_cpu(shdr->CreditRequest);
>                 credits.instance = server->reconnect_instance;
>                 /* result already set, check signature */
> -               if (server->sign && !mid->decrypted) {
> +               if (server->sign && !mid->decrypted && !(mid->mid_flags & MID_DELETED)) {
>                         int rc;
>
>                         rc = smb2_verify_signature(&rqst, server);
> --
> 2.35.3
>
