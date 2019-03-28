Return-Path: <SRS0=iY7O=R7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95D8C4360F
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 10:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94D3A206C0
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 10:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Roifjbuk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfC1KYl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Mar 2019 06:24:41 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]:39827 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfC1KYl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Mar 2019 06:24:41 -0400
Received: by mail-qk1-f177.google.com with SMTP id c189so11756672qke.6;
        Thu, 28 Mar 2019 03:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9pTet7p47TT13cU5QJpZBptfAkGOE3/MmPK1UPLd55Y=;
        b=RoifjbukwEZJCs2NqBCNczPpt2+IHgFl4f0WyEn2ThFgDq3zAzLCgLzk08AHng0GMf
         TvBr3cIJ5mqZWH22EhEYtVmx1xuZr/JRlKq1XdSVSMdyrqDwxQ22QP7jY6v4nzlpMG5c
         2TXt8+rsSR6luqENeeMjZY0xACbrF3pYQ/KbobOCLw/iJrYy6zkTgT4M0YYwQoszMRHZ
         Brb5Dp7z9m/AyOXx0SI/UBvgzhQaKjexG0H+ONbWaL6DeypT268zkO8eQ5ANdlgdfUqo
         7ob7nl3BS+Yut7svOC6y6QcUZxoiQ6IH+I4Mj9oKeSKMfMT25I8yEbbvSyx1nlpSg9HV
         ZRDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9pTet7p47TT13cU5QJpZBptfAkGOE3/MmPK1UPLd55Y=;
        b=QKopi5QtP4JU9Ruqj9RfB0kHimMacgBCEiRhGfWgTGnBtiCsjUxA8MPEfgoJevxaaC
         t9xwleuVsLsHONhM+494rBb61a8SvTtOaCvE1hHpF3YcjdfA6nx/xF/vggdNHmy1cPiD
         NnqJcoi/pUQbPrVVzXmIx09/xBK+QjYY6NNGzaJ8zF4OLIZgdWPUSvGRRGckTR5AGXaj
         fL0DsfD6WOmA6ml3GIQbibvW3Xt4wut7Js3D+t+tPyDtgRf7k0V2Lhwd/TKTeNRAUVTI
         PryJ2qRl+wUYmMYij1ju7yQz2R+X6nQV8e3jUtNBCyoS6mYhW4bErxlZt1vv7pXJ7ghQ
         j/FA==
X-Gm-Message-State: APjAAAWlpePvnRt5FDPLQ4pAiascXr1m4FuamZKeB1PHgUCMhwzzk4J/
        wN1Z39dJyfZPRRrLxI7+VzIw4H5HjLc/cI7B3Pk=
X-Google-Smtp-Source: APXvYqwMIrfMDxcmHSHK9XjWeCWzkQ6TKlNfS2XG3kOBVlgQqgNgeBam58H5eTAQu6i3zIkaChMUSaBDK6Hl0e744XQ=
X-Received: by 2002:a37:e203:: with SMTP id g3mr4623154qki.345.1553768679836;
 Thu, 28 Mar 2019 03:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvQ+KmoBgoxT51SRMpCXZ4OFwg+B1x_SD3DFkcrUcdZQQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvQ+KmoBgoxT51SRMpCXZ4OFwg+B1x_SD3DFkcrUcdZQQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 28 Mar 2019 20:24:28 +1000
Message-ID: <CAN05THRDc=GUigqEjzQ6quqJS53jia44c2RisnGJ+8DJZa-t0A@mail.gmail.com>
Subject: Re: [PATCH][smbinfo cifsutils]
To:     Steve French <smfrench@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rewieved-by me.

As this is a pretty useful addition we can add an update to the
manpage as a followup.

On Thu, Mar 28, 2019 at 8:05 PM Steve French <smfrench@gmail.com> wrote:
>
> Patch to smbinfo tool (in cifs-utils) to allow listing previous
> versions (snapshots) of an SMB3 mounted share.  Note that cifs.ko has
> a mount option "snapshot=" which can be used to mount the previous
> version of a share.
>
> Sample output:
>
> $ ./smbinfo list-snapshots /mnt/file
> Number of snapshots: 5 Number of snapshots returned: 5
> Snapshot list:
> 1) @GMT-2019.03.27-20.52.19
> 2) @GMT-2019.03.27-20.50.20
> 3) @GMT-2019.03.16-22.25.54
> 4) @GMT-2019.03.16-22.22.28
> 5) @GMT-2018.10.12-08.30.11
>
>
> --
> Thanks,
>
> Steve
