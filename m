Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084B9C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 17:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiJQRaV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 13:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiJQRaN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 13:30:13 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970424D262
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 10:29:56 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id 126so12188857vsi.10
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 10:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jla+n2ATOOc9lah6jrDKSj5BHw3ODBu60109CcrsVcA=;
        b=Mg6k1Oz/es6TJ/sUJ85hUgJOIzdK6+WE382yLDA0FLziySE9XTwtZ4xIvZUE16WuVI
         uuKa9e5hTcsJdmBEJ0zNWmLS/jh5RRHm2C71VxNVIEuchgL39znrdjegEz0sNIOmN50q
         C73tGGfBwfeDDHeoYsQwUy5dSoknCoax6QpaKRSsSTrWfVta3rjjTH2DPj0bHVh2qDyC
         EpCaFKf80J+MNCdY9Q1Niw8iJSgBuKhzZBsVYceWFGA143KMImFKvIVzrz3KEmnVgNjN
         VxknDWweUSsdPtsKen2bdMxHVv3Sr1kq5kC9y28oZk8rSvHl4Mqs+wQk42Rleduw/WzZ
         ebCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jla+n2ATOOc9lah6jrDKSj5BHw3ODBu60109CcrsVcA=;
        b=ta59McSwp4uPaprY0vpV4ObafDaaOKN/UBI8ii5SPBmznS33ePYRHFfV4EjMwtOXQN
         GkWVIfwGpPfqmafyjXYW25w2fa1LDh35PwGwmeVj5dWKOctTPPz7aTkWyAFmIADSyY++
         bvRTkTnJm7sxAXpcXv91WAC/9yTWkFsMb5TDwR2jjFlZ968i00lPUAwbM2sUj8eqE/Uf
         kPljyfOsiLGPKxE+kzBh5B46xse9R0B4xVhBKdO8rFA8DqFhI74LhZomnTYZMWJFpSIW
         ms7CSSKhMRxD9Shm5NXPmkyN6no6jjnd6mk/2aOzqEUsPGRE9y4fWNR2fhnZm0Q7/2fK
         CvnQ==
X-Gm-Message-State: ACrzQf0jmooKrW5USL+8rSYeOYDNK8BNrYyWptbdjR8XsHTadhrESZf9
        gtOONuc1zn1o7eYZHk5CiiqWLaa4rWUgNVcTeRk=
X-Google-Smtp-Source: AMsMyM6X5wkFEb4e0I9OmjoZ/7sNe1v1QHUR/xCS4Rp+12DcRkzyZj5RBc3BGVTubAUvLrEESNXO//vJDabSzWQU8xI=
X-Received: by 2002:a67:f603:0:b0:3a6:ff45:997e with SMTP id
 k3-20020a67f603000000b003a6ff45997emr4409962vso.6.1666027723238; Mon, 17 Oct
 2022 10:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221017144525.414313-1-zhangxiaoxu5@huawei.com> <20221017144525.414313-5-zhangxiaoxu5@huawei.com>
In-Reply-To: <20221017144525.414313-5-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Oct 2022 12:28:31 -0500
Message-ID: <CAH2r5mt-ssT692P4FHeeuiK-Rgvkt0juNAc8UD_aJE2iMNPjCQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] cifs: Fix xid leak in cifs_ses_add_channel()
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        aaptel@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Your approach is probably better, but it would also possible to remove
the get_xid and pass 0 in to negotiate in this path

On Mon, Oct 17, 2022 at 8:42 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> Before return, should free the xid, otherwise, the
> xid will be leaked.
>
> Fixes: d70e9fa55884 ("cifs: try opening channels after mounting")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/sess.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 0435d1dfa9e1..92e4278ec35d 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -496,6 +496,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
>                 cifs_put_tcp_session(chan->server, 0);
>         }
>
> +       free_xid(xid);
>         return rc;
>  }
>
> --
> 2.31.1
>


-- 
Thanks,

Steve
