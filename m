Return-Path: <SRS0=jMYF=Q2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865ACC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Feb 2019 04:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 506862173C
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Feb 2019 04:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GhlZ7+15"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbfBSElA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Feb 2019 23:41:00 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35762 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfBSEk7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Feb 2019 23:40:59 -0500
Received: by mail-pl1-f196.google.com with SMTP id p8so9775415plo.2
        for <linux-cifs@vger.kernel.org>; Mon, 18 Feb 2019 20:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3OiiSyO8dAkED1G4YVAMS8OKJdtXmabZ1HLflDP1mI=;
        b=GhlZ7+15HxXj0ah92nxzLNriZKYUI8eRpfFg85CvQhQxI/sziJYP801Mb3QcvUOAG3
         sd46PLk1dztCQJPBV/ld9s8pk3PgJyyrtF6AQYqFVgCPWU08EMQAvNrjZ4FXEU8tqir8
         TvoaGsX0MqBRY/eRwgL8DIjUD5vcp1SLtVtrwHhhOW9WTrD1E2a87Bptwt3RnCks4kDW
         y4U2UxZoLLQwYG5EB5ieaac31UW9Eu4rkV7k1bLcl8/HJGpViV/9xgRU3tWis1P4nXCQ
         HfPzYKuFTWoihXN3u/N+MfuHTpMjGzC4R4gDmodCX8Puim4lxCnTHbvwesQtZftrKBmZ
         ICHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3OiiSyO8dAkED1G4YVAMS8OKJdtXmabZ1HLflDP1mI=;
        b=a+j6t8AXpOwX9w3yiXoj0OjxYlQS9t75uoKrvkw22goZOqi+2WE1klqvW4jezItC2f
         yuUbGWl+LyizdkuDILx/RrLn06dRSQEQflndAUDmLPhHAtYZctYHNdCnvkxeCeVhh/qn
         jnzL8mkTWrgUYkGizi23Flu5Ly1ijKCiW8b/U9IkYOSRGV100Bas1p2WGY6uPynft6Ad
         nM2W0kik1N93M6UwRVTX0DIRqcRhQvNF4BJN07RotG3yuejIBaeDsSSFbigtIibzOv3D
         w5X3+S0DOwYQIf+skhQ/zUrDdmrxScC2IfNOqKZ2PxtrMAOtRMrUxBH4KVkZglISLYxB
         zwuw==
X-Gm-Message-State: AHQUAublL9qCNlCDLqRaf750RfPPpTChrvC+BD01gLK5aBB2WXsJDhyi
        zOpkaGfmU9fqeXKZ36j5ojjz14Ou1TLufIJtHYs=
X-Google-Smtp-Source: AHgI3IbvZ2HCtQSTuS8vPSktJZwP+Oa7EKtSnBQ3yv6BeNs4QZskeA0xzxcXxAOFf7e/zLkh9RZ5WnZ+yqtlhRLkYqk=
X-Received: by 2002:a17:902:822:: with SMTP id 31mr27081849plk.290.1550551259156;
 Mon, 18 Feb 2019 20:40:59 -0800 (PST)
MIME-Version: 1.0
References: <20190219014343.29526-1-kdsouza@redhat.com>
In-Reply-To: <20190219014343.29526-1-kdsouza@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 18 Feb 2019 22:40:47 -0600
Message-ID: <CAH2r5musFyuqHofaeEtjd5ecK95x-60ByZ=Zi=fAXVLMXG=Y9Q@mail.gmail.com>
Subject: Re: [PATCH] getcifsacl: Do not go to parse_sec_desc if getxattr fails.
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Steve French <stfrench@microsoft.com>

On Mon, Feb 18, 2019 at 7:43 PM Kenneth D'souza <kdsouza@redhat.com> wrote:
>
> Add more to the error message by printing the filename and error.
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> ---
>  getcifsacl.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/getcifsacl.c b/getcifsacl.c
> index f08cdea..7f6e673 100644
> --- a/getcifsacl.c
> +++ b/getcifsacl.c
> @@ -399,7 +399,12 @@ cifsacl:
>                         bufsize += BUFSIZE;
>                         goto cifsacl;
>                 } else
> -                       printf("getxattr error: %d\n", errno);
> +               {
> +                       fprintf(stderr, "getxattr failed on %s: %s\n", filename, strerror(errno) );
> +                       free(attrval);
> +                       ret = -1;
> +                       goto out;
> +               }
>         }
>
>         parse_sec_desc((struct cifs_ntsd *)attrval, attrlen, raw);
> --
> 2.20.1
>


-- 
Thanks,

Steve
