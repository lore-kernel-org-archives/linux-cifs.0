Return-Path: <SRS0=Ot+p=4V=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6D0C3F2CE
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 17:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6FA221775
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 17:16:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YZD6jmP1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgCDRQi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Mar 2020 12:16:38 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34091 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDRQi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Mar 2020 12:16:38 -0500
Received: by mail-yw1-f67.google.com with SMTP id o186so2737424ywc.1;
        Wed, 04 Mar 2020 09:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W/o003p8WXvnjiWGobVFEZFkKelwiiKhzUSVE4Qihp8=;
        b=YZD6jmP1mcXevlhVHAZGcZeMk47KHCDFNnzSmV0HKAPXBxo95ooTwwHUbUqtdNMn84
         uUN3AdohPaqDZ50XTvQG1xwH33nbFl41OIhukRBvb2vtj/g7taNuuJJ06n4IPVOjVPSA
         ivwPiji783YHt43uzNxHGQcK63tB+yH0r+RTWnSFRLgD3+WQUqQ04t4Zkp+9pwGiF0Uo
         Cz0ZOQey2vGJKm/Ps0MyJI62QXSVtmrsXRAVtxj25DqWxP/aBBL3xYa5B0wVyrZZmfHX
         U1HZYgh3pV6rhj5wbILN81H+UOdHLRwWMDaqxBWbaGzOAANy8j7DelhuC9XKAqw531JV
         nLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W/o003p8WXvnjiWGobVFEZFkKelwiiKhzUSVE4Qihp8=;
        b=lqXI9kcrHrix+Yi6K38qG7kq62PbqJIDmQXWStcjOlqBjmJ4bAmQagQ47THO9JyyE8
         ql9Ofo9nB6Nf/k/9q73GRzCVRZCYtlx5VvGLz5gUWY1ZhyteoBfRGqmnHibuu9Crf8bC
         7FXyEAo3dQbRinFRdYRhwejhCwfq7Zdfozn8vhnHdjkoOB0EUYWAutUYkKvuRp6hiKtO
         8PCB8ub6nu1Nfqej0ziBk7ICEunZyCC5qfBWyMY1oMWD8ZptmSvU6TS0HVw+oTiIypWL
         J+WvXBd3hjBfk9zFQjn/mPgAw8wNclYrvnWQb6+d78wInrHB0Z2ptndpRN51cGC0nJY7
         PS0Q==
X-Gm-Message-State: ANhLgQ0cPV2YBzs2kRlNiE7NbL44Ie5agSMoJ5ny+WfQGVjRkimlqjPQ
        90G72wBNiJu2M6tcoODOx84jgcaS3y9ncyrdBlmOf38V
X-Google-Smtp-Source: ADFU+vsDVFGBAkDsN5BwUeeh+RI+ZTpKyLpaIgm7R6QskwE95WhLHvyLnvFXBpeTefSdusSZePHUGQPcSjNa1P/X16k=
X-Received: by 2002:a81:f10a:: with SMTP id h10mr3734463ywm.109.1583342196085;
 Wed, 04 Mar 2020 09:16:36 -0800 (PST)
MIME-Version: 1.0
References: <1583307771-16365-1-git-send-email-hqjagain@gmail.com>
In-Reply-To: <1583307771-16365-1-git-send-email-hqjagain@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Mar 2020 11:16:25 -0600
Message-ID: <CAH2r5mshu2YmrUFcO2Swb2512fRV0V7wU=y27TJr2PEQBU5puw@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs: fix gcc warning in sid_to_id
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, Mar 4, 2020 at 1:42 AM Qiujun Huang <hqjagain@gmail.com> wrote:
>
> fix warning [-Wunused-but-set-variable] at variable 'rc',
> keeping the code readable.
>
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  fs/cifs/cifsacl.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 716574a..ae42163 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -342,7 +342,7 @@
>  sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>                 struct cifs_fattr *fattr, uint sidtype)
>  {
> -       int rc;
> +       int rc = 0;
>         struct key *sidkey;
>         char *sidstr;
>         const struct cred *saved_cred;
> @@ -450,11 +450,12 @@
>          * fails then we just fall back to using the mnt_uid/mnt_gid.
>          */
>  got_valid_id:
> +       rc = 0;
>         if (sidtype == SIDOWNER)
>                 fattr->cf_uid = fuid;
>         else
>                 fattr->cf_gid = fgid;
> -       return 0;
> +       return rc;
>  }
>
>  int
> --
> 1.8.3.1
>


-- 
Thanks,

Steve
