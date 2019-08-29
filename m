Return-Path: <SRS0=gUrR=WZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895A7C3A59F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 04:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5522823405
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 04:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XSb6pIY/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfH2EAK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Aug 2019 00:00:10 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:37031 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfH2EAJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Aug 2019 00:00:09 -0400
Received: by mail-io1-f53.google.com with SMTP id q12so4116749iog.4;
        Wed, 28 Aug 2019 21:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NWVOfHDaPa1JXjahrXr3gtA9w996ssiG4UTUIisw4iM=;
        b=XSb6pIY/kPb5cGGMWENjAA1EtiWDclpcTZ85OE17tION/EyvWZoEs2hgBvSOP9Zknu
         XTvJf+YfQjrKB8MxGCzom2HDIgAmbkLK7o2uTtQIjZOw1O8TiG080WXFA4U4i8Q2lI2s
         nAIQ6wkwPQJGo+4D2JeEos/IKqel6DVy+To05kc5At+UmWm6AtnFs1Ycr0xF6+7O/I9i
         sPedDi2fvM+Yo/C3QeLuKlvEBpOKNAcNe9R4Sml9Bb9Y1eFUFLYeQyeAsKSyDmCyMV2U
         3uQ6RGst2vs4/IKmiVamTZ49T7xEsaMYAOdAucqmukmLWoJJLoD5dz6IVRwFzws+nFD6
         ECcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWVOfHDaPa1JXjahrXr3gtA9w996ssiG4UTUIisw4iM=;
        b=GnBA0Qpb8o7XxJ2PP/qiPkeYC9RjRJuq7CS9Y1U+/Iw42yPK+g/PvfoCrTaDh2M8xS
         pfTsyI2TN0pamz9yBnEQr9nECBY2Kjtf8vPna9n7vt/qBb9g4aYF4yC9zanfwOrnZ0Xp
         bLIzIUkQY2GDKgZxwgwFxyC5ZQSCtDfdyMpEUXjC/KIwytpzV8vZvzQ1QxK+tNAh+A7l
         YBdG4CXSV802CHsr6uDJIfnr9JbgI34fL6XSSPeJnm12N0iz7k1ZwGL/GXQotmd8JP0K
         KomP8n0l2w74ulOi2tmDbXbIez0PpIKpv1K9ms4i2yaZpdxocW48vgNNGeq8OO6O4HG+
         MK/g==
X-Gm-Message-State: APjAAAWCwypQv1pMKZdcF3SrZQGx1FMY9Ccvg2ap+asod0yiqDSyMNIs
        mp6r9XXF5knohf/t5gpmBzofN4dnqIRmXK66ytk=
X-Google-Smtp-Source: APXvYqx4PCsxUhe81DE2v6/NTP2dSpI/V5FBpW5yhwLopIpzKy0MMytemfSlADC62e3LkF2ZrfAYFBfAZWLbhcKRdCg=
X-Received: by 2002:a02:390c:: with SMTP id l12mr8164554jaa.76.1567051208512;
 Wed, 28 Aug 2019 21:00:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190829000006.24187-1-colin.king@canonical.com>
In-Reply-To: <20190829000006.24187-1-colin.king@canonical.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Aug 2019 22:59:57 -0500
Message-ID: <CAH2r5mtSSwS7_E2WkS3Lsk02BEf_UwZ4H9oCEFTSf94U=4Cm9Q@mail.gmail.com>
Subject: Re: [PATCH][cifs-next] cifs: ensure variable rc is initialized at the
 after_open label
To:     Colin King <colin.king@canonical.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next

Ronnie,
You ok with merging this as a distinct patch?

On Wed, Aug 28, 2019 at 7:02 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> A previous fix added a jump to after_open which now leaves variable
> rc in a uninitialized state. A couple of the cases in the following
> switch statement do not set variable rc, hence the error check on rc
> at the end of the switch statement is reading a garbage value in rc
> for those specific cases. Fix this by initializing rc to zero before
> the switch statement.
>
> Fixes: 955a9c5b39379 ("cifs: create a helper to find a writeable handle by path name")
> Addresses-Coverity: ("Uninitialized scalar variable")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/smb2inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 70342bcd89b4..939fc7b2234c 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -116,6 +116,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>         smb2_set_next_command(tcon, &rqst[num_rqst]);
>   after_open:
>         num_rqst++;
> +       rc = 0;
>
>         /* Operation */
>         switch (command) {
> --
> 2.20.1
>


-- 
Thanks,

Steve
