Return-Path: <SRS0=EeRJ=6F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D946BC54FD0
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 10:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B09472068F
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 10:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HIkIFZT8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgDUKsq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Apr 2020 06:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgDUKsp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Apr 2020 06:48:45 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D38C061A0F
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2020 03:48:45 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id n10so14498943iom.3
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2020 03:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ngf/QJNoLPkbr33G43erLtvjdepFX+w3/5/OAcrCc0k=;
        b=HIkIFZT8qT3vQ0g5wTef0guyS+9vkQoEDDzDSKvzxqc349UrB8FrMo17JrtUe1bQni
         tK15U6ufIgOpq4NvSnjyMAMKBKSWsZlPtfGwTx8CDW1qcXlp9KWSHhjFmVdCb6nRTqBf
         dcgDI/pmlQUqoNdjUtHxkpTX6oq6+5Xfv0hzUhhy7zbk0Q/bJKVDER4/NfnSvI7qd6J7
         O4V/XLno29/dulSI5TYMl0CInM5dv/c4PCsH6mwJR53KXZvYDlDwjXRzvpqm6l7ViSCJ
         uguWrv+AyKaWrr65Rs+aK81IFl6a6ouIzuEiS7cBZvfO67PRQqoGOcrkiFSlNx7SIexU
         nDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ngf/QJNoLPkbr33G43erLtvjdepFX+w3/5/OAcrCc0k=;
        b=nQESU+QTjqWap5Q8MOiocneGGWbx622IU5Ne9QRiB0eWbQShSHYr4/CN4WoGtyaotV
         NQZ6bxOOIz2Q3JV7ztW0DG7mmVEhD8OZAh0gUTEpiwvVHgmtFron124AqmCE1QdS196J
         g6wNSvUhQJSU67ieSD4j7yNmU1K3NNr/byA+qHVz59Hw87zjmO27+4xjT9i/1Ovrvkqh
         2Km+GIESc4ScnUBlvHmD9gaMuhr6czgIdCmatJzO1/wU+0kmjneSVSueKZbU4IjoS4bK
         5Ucje5vbETCbpRvezttGfF1zN0gExbPaWq/hmjHpN7jfMsoS3/vxPQ2r31poPNRRapbC
         2uYQ==
X-Gm-Message-State: AGi0PuaEkTfmp5txkhM8+ebdBml/KNqBzeZIGfMkGNGqaEwtZ50r4xt9
        wz5KUcaT328OV/BOWAwbiALhyEV8G9y1JjcKtCM=
X-Google-Smtp-Source: APiQypLQaqfAcQS/YqcLKdT4ZU5tBP1e1L7GgGmYhCTRc3/Jty+5caS/qwL+I+ImaS0QHoDyYQ/hM6XmrQw1T+La4TI=
X-Received: by 2002:a5d:940d:: with SMTP id v13mr20035780ion.1.1587466124914;
 Tue, 21 Apr 2020 03:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200421024424.3112-1-pc@cjr.nz>
In-Reply-To: <20200421024424.3112-1-pc@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 21 Apr 2020 20:48:33 +1000
Message-ID: <CAN05THQxSOa-YLmNODTXdcdOoEUkX2vMqcNyjP1bcf2=yb_9+g@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: do not share tcons with DFS
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Aurelien Aptel <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

series looks good after initial review

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>


On Tue, Apr 21, 2020 at 12:45 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> This disables tcon re-use for DFS shares.
>
> tcon->dfs_path stores the path that the tcon should connect to when
> doing failing over.
>
> If that tcon is used multiple times e.g. 2 mounts using it with
> different prefixpath, each will need a different dfs_path but there is
> only one tcon. The other solution would be to split the tcon in 2
> tcons during failover but that is much harder.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 95b3ab0ca8c0..ac6d286fe79f 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3373,7 +3373,7 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
>         spin_lock(&cifs_tcp_ses_lock);
>         list_for_each(tmp, &ses->tcon_list) {
>                 tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
> -               if (!match_tcon(tcon, volume_info))
> +               if (!match_tcon(tcon, volume_info) || tcon->dfs_path)
>                         continue;
>                 ++tcon->tc_count;
>                 spin_unlock(&cifs_tcp_ses_lock);
> --
> 2.26.0
>
