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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A50EC433FE
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 21:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4536622225
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 21:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgLCVXx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCVXx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Dec 2020 16:23:53 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3820FC061A4F
        for <linux-cifs@vger.kernel.org>; Thu,  3 Dec 2020 13:23:13 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id x15so3319962ilq.1
        for <linux-cifs@vger.kernel.org>; Thu, 03 Dec 2020 13:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PMA8poLOFvlfwlko9jFIAINDHfH2AoLwaaV/QWXD9WI=;
        b=dSCddgrenopuvI5FYAJrJy2/NDUbe493aOEVE+rlGZlQi/XJketzd1ga4HWvunPExX
         ZeWwlqtK9doeMda4QhCDjX9wm0gUWs94r4mOBvjDDtsKOITnNm4sWQ3uRhtb2cbn17Zd
         /wRrEnq93xbSweII2d0fwM8FEfWEHHu99fiVq2LhfAZ5fj3hjkTI1f1eKpaWwEHmVNC2
         ThCc7b+PdQU5Rhnx19thKxWtWQ8mtpoQRtn4kgpTKSvbP6zU/vPax5LDKK4fnliN0J4+
         LdtOETDBNt8DB+7Tyva+bDlkepo3gbQqQZAoTRzHSv8doEJ3a1GnlJUxSPqUfCrSLb1j
         LeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PMA8poLOFvlfwlko9jFIAINDHfH2AoLwaaV/QWXD9WI=;
        b=Jf30U9qmJMR+WYPDzjnN1taLQ1RTR3sjovkyd483W26dn1IWuoCLnGWIztVWiQcMn+
         noqaOAWOiHRCcQ8ys8cgl0+MPdc6kip71/1pSS42yql+I3kwlFoK4TSf/fsWJJmAnFyR
         Lq7bfkgTKOmtgTUtZUZPIWvGKm0BsNvbWJC8cJBfJJSpoBQxis09YqTzvUJNCYb9bfII
         JpVp3a9qCVLJfZ9ouVUSY9/jZrlqOoRJ0FBOv9bgjNu5ZUK8TRVPpziDnXo9gXOFiJao
         o4cxcFnGFc/TZZWUugL+AnAg1BxueLPTMCIdaJLq7+sYc67UeYNEf/Gd/HzgT/G4Lolb
         pwhA==
X-Gm-Message-State: AOAM533hlaOCkxwDmGy8l2fha+tRs4kEbXvDDM4bkkIbJgRVgo4UHxS/
        HekWeEgS6RDoFF0D5S6SCaXY4ujPuskUhPcDTuQWg0jx
X-Google-Smtp-Source: ABdhPJyJySdMiw4UVVyuHCDWJ+W8bLLaQGQ42xoicjdhEeHIzzB465LTspKY/Ns7o2GaVkC8OBm3qwg/tpU6nTsjNPw=
X-Received: by 2002:a05:6e02:1849:: with SMTP id b9mr1480912ilv.159.1607030592638;
 Thu, 03 Dec 2020 13:23:12 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201203033831epcas1p4c69684156cd4e393f048472a24238e6c@epcas1p4.samsung.com>
 <20201203033136.16375-1-namjae.jeon@samsung.com>
In-Reply-To: <20201203033136.16375-1-namjae.jeon@samsung.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 4 Dec 2020 07:23:01 +1000
Message-ID: <CAN05THQdg9XQH2kNh43G60WkhUNFpbGA7P=x++kHtTRVprM5DQ@mail.gmail.com>
Subject: Re: [PATCH] smb3: set COMPOUND_FID to FileID field of subsequent
 compound request
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me,
please add "Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>"

(How could this ever have worked?)


Can you add a line :
Fixes: 2e4564b31b645 ("smb3: add support ....

On Thu, Dec 3, 2020 at 1:38 PM Namjae Jeon <namjae.jeon@samsung.com> wrote:
>
> For an operation compounded with an SMB2 CREATE request, client must set
> COMPOUND_FID(0xFFFFFFFFFFFFFFFF) to FileID field of smb2 ioctl.
>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> ---
>  fs/cifs/smb2ops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 504766cb6c19..3ca632bb6be9 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3098,8 +3098,8 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
>         rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
>
>         rc = SMB2_ioctl_init(tcon, server,
> -                            &rqst[1], fid.persistent_fid,
> -                            fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
> +                            &rqst[1], COMPOUND_FID,
> +                            COMPOUND_FID, FSCTL_GET_REPARSE_POINT,
>                              true /* is_fctl */, NULL, 0,
>                              CIFSMaxBufSize -
>                              MAX_SMB2_CREATE_RESPONSE_SIZE -
> --
> 2.17.1
>
