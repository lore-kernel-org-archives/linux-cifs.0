Return-Path: <SRS0=8LXX=Y5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A47CA9ED0
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 08:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41B0B20818
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 08:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KbF9POlI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbfKEISb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Nov 2019 03:18:31 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:44700 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387575AbfKEISb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Nov 2019 03:18:31 -0500
Received: by mail-il1-f172.google.com with SMTP id w1so8576263ilq.11
        for <linux-cifs@vger.kernel.org>; Tue, 05 Nov 2019 00:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=62ao0VNz+RNZw+pchrX4LbkC4R6KqCAadePUCgVJxSI=;
        b=KbF9POlIPcbp4FBEmJQ9rLKgSLK6ZquGBEuDh2q3Zd9sUVavbFOFQTTnO+bQfVJQ0K
         s9PqnPllaQp/ZyAZX9uunF6DixKFku3ebmvNPt6DG4mzRaD490rbkxVDTTLVMKv7bbHF
         X/HtNFBsUvLZN04VpVXD3mIVxPSPNDvBV0keWzKjmvP+5EDiwkd8OX+11kSCz1AzDOZM
         a4zItTFhpnH28u5HmMrlLDN3tF02g6jLnH//PRh0Gino0UleQICrdDWWa8PTINhTvJTn
         L497K5XusL5P29QR5RKJs0M6ly3zmEpGX0/RZG6zZMMMB2PQlvZIgZV2YaT9ex1Xd2nD
         lm2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=62ao0VNz+RNZw+pchrX4LbkC4R6KqCAadePUCgVJxSI=;
        b=ZpKIymXwlyRyZBSNBhNB1wlyfeZweIMMTH0sYxL4PJHE27eHdo/sQhEdAuBcalhsgV
         a9I8a39+jKlQW0/zqs756H2PyYEwMWvXz0I+rcrTPViupurmb+EoPJzsC8bdZzczOEWx
         Ns312jWgsAK1DiOd2LWxBB3CcOoZK51jc/K81GFNEvVEsC4FW0Wc6o3ouvWuJkUpRfRo
         mQNGv7G7qR3/w6PFbMKrOV35kYMPb472r7YWaVEzCUsRgAeUfuRJloXZISBc5QAmMXNd
         xcFZQrsM7nqRwgeKvsfcSNMT0s/QDTl2XLVFsndxz5FBNu9W2MVh+qiYNksfDnh+KHmo
         9KFQ==
X-Gm-Message-State: APjAAAVpA5C2qYESQw+joHm8s1WePgNH9ETMzb6ZPCCOaZNoUzj1NkPl
        MhBhJqts4HLmqNz1uUlVamrqr8bExZvYjNdDhTg=
X-Google-Smtp-Source: APXvYqyxZ7YJsUZHtlf1AtYosjOjj7KhM5s3e/TU3ewvj5HAZdxZH07k3OQuxKS664HOiPU+2ZjGqwj4219DpbjednY=
X-Received: by 2002:a92:48d8:: with SMTP id j85mr32227645ilg.272.1572941910660;
 Tue, 05 Nov 2019 00:18:30 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muy7TezWnfq-yfpDg5uDaEV9beKtpXRdwBjtphMGgg3BQ@mail.gmail.com>
In-Reply-To: <CAH2r5muy7TezWnfq-yfpDg5uDaEV9beKtpXRdwBjtphMGgg3BQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Nov 2019 02:18:18 -0600
Message-ID: <CAH2r5mvVdBa358HtNb2nt9vQ=20khyXm=0XkTg-SHdEzYo-r2A@mail.gmail.com>
Subject: Re: checking encrypted messages in smb2_check_message
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I mean I don't see it called ...

On Tue, Nov 5, 2019 at 2:17 AM Steve French <smfrench@gmail.com> wrote:
>
> I don't hit this statement in smb2_check_message in smb2misc.c is it dead code?
>
>         if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
