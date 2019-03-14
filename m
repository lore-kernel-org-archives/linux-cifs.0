Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFA4C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 06:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B226217F5
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 06:54:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NHTFgzWj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfCNGyY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 02:54:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35029 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfCNGyX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 02:54:23 -0400
Received: by mail-pg1-f195.google.com with SMTP id e17so3351494pgd.2;
        Wed, 13 Mar 2019 23:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ap51BtWn6bdlLtLzRqfSE70yrjcdBk5pPPZkV94rG90=;
        b=NHTFgzWj1e71LngjF0LIoZQYabx7ExZz6Ou7Q2b4s28ZdNm+pXFYwWJMkwCUFiWriI
         OKUZh9TRrxUBwecihjUnyfPOl2LYLuEQvq03hiC3/vuAw79CGzJu7HVSbFuNNCcj2PAM
         QK4zc2gOcO/TVLlkhXNPaSSwhXy0Sy45nuBFA17R/+Yb1QTmNZA5kVQLgCQTkTXfVPzd
         yNhDet8WBAgid9c8VKiAHiPO7B2M8xvG/bwHKBsPbgdfnZXbFffRwd633GzqcwKGVgvh
         JcT+ps3Inpi2XGUBClSuRN8Rgijihh3iJtrPtSncZiBKCNp2rF7qobsxq0Zq1SqN3VCq
         bQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ap51BtWn6bdlLtLzRqfSE70yrjcdBk5pPPZkV94rG90=;
        b=p3csvaDB647zJ0WziFv9iJYzmsy5MUxRGcvap3NK2EerPX1NrhjhWNHYJvInt244XZ
         HcORLPcvFuzrDzGERN/THnAubdavrItHJ2LDufQHlWoOq0B1/YITsemoHwLoTeHXTnqP
         LAppUsEsBeUk4VWoqdEMCOmmr47RFYrEoqyO94DZtIaHmwe3NMFZ4gx/YEvduTwtHiqS
         PMk4vQDs0sylUvpDjwAmfc+kSXmH47Ghq3I0bwB0Sle17GnSIxVjwOfqyjbJoPN8IBKZ
         YuzmIzBhVZCc+navv3zqbz5/Vhci+6d2EwDOqwlSFjV5oSXE9mp1Z13qltRODIFPZcHh
         FpBw==
X-Gm-Message-State: APjAAAVD1p2AOAu6Vse0sRF21odzz07af+S911ODQt8fdzuY2l8IGMOW
        HIndPlbxFwqkhewf5c+pccYzPe2i+0N4aI35als=
X-Google-Smtp-Source: APXvYqzDTs3ky91yTcAya6E8xS240HTBbKGcePUJYhW+VLnWF3jisJU1fuJXo0sEw2oCnCWhorohtrUT4tquBROivKk=
X-Received: by 2002:a63:2c50:: with SMTP id s77mr26815910pgs.440.1552546462465;
 Wed, 13 Mar 2019 23:54:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
In-Reply-To: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Mar 2019 01:54:11 -0500
Message-ID: <CAH2r5msYG4H19GK1Fmnqb1dNCcp2qahULc_t4v9qdJ=OOZmGXg@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: remove unused status severity defines
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Since this file (smb2status.h) is intended to track the official
protocol documentation (albeit smb2status.h probably needs to be
updated), in this case the protocol document MS-ERREF.  I would prefer
to keep it closer to MS-ERREF and leave definitions in even if unused
(if nothing else it helps some of us when debugging to recognize what
these errors on the wire mean).  There is a real danger that we have
run into in the past that in removing some protocol definitions
(flags, etc.) from the code or forgetting to update our headers to
match newer versions of the protocol specifications, that  with future
code changes we can forget to handle flags (for example) or misparse
responses due to not realizing that there are additional flags that
need to be parsed.

On Thu, Mar 14, 2019 at 1:17 AM Sergey Senozhatsky
<sergey.senozhatsky.work@gmail.com> wrote:
>
> STATUS_SEVERITY_* do not appear to be used by anyone, so
> drop them. Besides, the name of __constant_cpu_to_le32()
> is misspelled there: __constanst_cpu_to_le32().
>
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  fs/cifs/smb2status.h | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/fs/cifs/smb2status.h b/fs/cifs/smb2status.h
> index 3d5f62150de4..e9da9c6da277 100644
> --- a/fs/cifs/smb2status.h
> +++ b/fs/cifs/smb2status.h
> @@ -29,11 +29,6 @@
>   *  C is set if "customer defined" error, N bit is reserved and MBZ
>   */
>
> -#define STATUS_SEVERITY_SUCCESS __constant_cpu_to_le32(0x0000)
> -#define STATUS_SEVERITY_INFORMATIONAL __constanst_cpu_to_le32(0x0001)
> -#define STATUS_SEVERITY_WARNING __constanst_cpu_to_le32(0x0002)
> -#define STATUS_SEVERITY_ERROR __constanst_cpu_to_le32(0x0003)
> -
>  struct ntstatus {
>         /* Facility is the high 12 bits of the following field */
>         __le32 Facility; /* low 2 bits Severity, next is Customer, then rsrvd */
> --
> 2.21.0
>


-- 
Thanks,

Steve
