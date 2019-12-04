Return-Path: <SRS0=LMmx=Z2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2A7C2BD09
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 17:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F7C2081B
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 17:55:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQws22hs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfLDRzr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:55:47 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:42068 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRzq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Dec 2019 12:55:46 -0500
Received: by mail-il1-f196.google.com with SMTP id f6so333109ilh.9
        for <linux-cifs@vger.kernel.org>; Wed, 04 Dec 2019 09:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E2vd5wSBW0nAgTggsYZ8713uvaBpUW9qsLOMdFoWKEc=;
        b=mQws22hsRdoZ4ZBOhrMYvSCGFwiltDrIi40ILl8lL79f0MAPuAFg/E+x7uDHDTOgs4
         tiwJM/7B9WXqppgCWRox2orgebP8yIB8QRxEDyFQ8oP8l58YEZKWU4Zpe1KCKHnpsNje
         rYACiSzl4aSJC9haHVsjmFdEFgR6NVOv47zR7yDGfktvlynU7vpLJ1poEazw40EtW1i/
         HfSDeqbdt0QUB6HnlUDySh2v1w4y2Jxq+jHPrHSbxpreHvlmBQtiOpVRIwA8UfEQ8M9e
         0k8rtG73BqmJmOy8HG1wUaWEMYQk0A5f4T/PPeA9n8Poqvz/JDiJRD0eEsJbwWBxK76f
         voIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E2vd5wSBW0nAgTggsYZ8713uvaBpUW9qsLOMdFoWKEc=;
        b=KqHoJ45j7+6efiam6BjwNScAq+XWFgoAY8OYbzIzYdO/5ciGrOqhSeQY7A6PMgBbg/
         Zr5G8YKlEaxi6gJi8f50NL/9qLq+JPA7H18gzNtRA6emSZ0S68gX9oV/tFxfqvdym6cJ
         VsaM1lYMZ5C1PhR67y3y5lMucr6/InlMzOkv9HC+NcLVkFYBOlrAB54Nx0gClqm+CmWX
         U87KUGKiKCH0rAwAzkU2yjkCcG/9SVO+5cpr5wKXRVUifj9yfh0y5sv/JlLhxh4JnlC6
         4USKjSWKSFA01xq16idvIxzFuDFAe2ViG+hvc3ap5PglZ67WCRai87FOrgJx773PREgp
         YhFA==
X-Gm-Message-State: APjAAAVQi6FUn5cWapwb3w8U94jk08mdXnlHjEvmdSl+L/P4W/jT8nAV
        9g50W6RSSaTnNhxsGRHA5V3y7hwvT6BKR2wIw/0=
X-Google-Smtp-Source: APXvYqzjN3I1oJGqC5vGaEXcKvq/MsgtdlYiZFZZ+GRvSCg+bsblAMjxQhhm2HlMRRKAKB/MJ5HSxP4bp4HPeUO7KkY=
X-Received: by 2002:a92:3dd0:: with SMTP id k77mr4644588ilf.3.1575482145830;
 Wed, 04 Dec 2019 09:55:45 -0800 (PST)
MIME-Version: 1.0
References: <20191204142506.12545-1-pc@cjr.nz>
In-Reply-To: <20191204142506.12545-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Dec 2019 11:55:34 -0600
Message-ID: <CAH2r5muFbpxg16pVE0LqeAo7t1Xc7vK6Ef68O+Gec9+hOgQVdw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix lookup of SMB connections on multichannel
To:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Aurelien Aptel <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged to cifs-2.6.git for-next and buildbot github tree
pending more testing

On Wed, Dec 4, 2019 at 8:25 AM Paulo Alcantara (SUSE) <pc@cjr.nz> wrote:
>
> With the addition of SMB session channels, we introduced new TCP
> server pointers that have no sessions or tcons associated with them.
>
> In this case, when we started looking for TCP connections, we might
> end up picking session channel rather than the master connection,
> hence failing to get either a session or a tcon.
>
> In order to fix that, this patch introduces a new "is_channel" field
> to TCP_Server_Info structure so we can skip session channels during
> lookup of connections.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/cifsglob.h | 1 +
>  fs/cifs/connect.c  | 6 +++++-
>  fs/cifs/sess.c     | 3 +++
>  3 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 5b976e01dd6b..fd0262ce5ad5 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -777,6 +777,7 @@ struct TCP_Server_Info {
>          */
>         int nr_targets;
>         bool noblockcnt; /* use non-blocking connect() */
> +       bool is_channel; /* if a session channel */
>  };
>
>  struct cifs_credits {
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 86d1baedf21c..05ea0e2b7e0e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2712,7 +2712,11 @@ cifs_find_tcp_session(struct smb_vol *vol)
>
>         spin_lock(&cifs_tcp_ses_lock);
>         list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
> -               if (!match_server(server, vol))
> +               /*
> +                * Skip ses channels since they're only handled in lower layers
> +                * (e.g. cifs_send_recv).
> +                */
> +               if (server->is_channel || !match_server(server, vol))
>                         continue;
>
>                 ++server->srv_count;
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index fb3bdc44775c..d95137304224 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -213,6 +213,9 @@ cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
>                 chan->server = NULL;
>                 goto out;
>         }
> +       spin_lock(&cifs_tcp_ses_lock);
> +       chan->server->is_channel = true;
> +       spin_unlock(&cifs_tcp_ses_lock);
>
>         /*
>          * We need to allocate the server crypto now as we will need
> --
> 2.24.0
>


-- 
Thanks,

Steve
