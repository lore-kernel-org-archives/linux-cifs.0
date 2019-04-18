Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C07C10F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 18:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 771F220643
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 18:28:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="Pi+d5jcD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390463AbfDRS2S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 14:28:18 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38302 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390932AbfDRSD3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Apr 2019 14:03:29 -0400
Received: by mail-ot1-f66.google.com with SMTP id e80so2453979ote.5
        for <linux-cifs@vger.kernel.org>; Thu, 18 Apr 2019 11:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mE/aKnKM07J0Pu0N2LzFy/Q/VzfI3mw7PzAs98ACEDg=;
        b=Pi+d5jcDSHcAWLBXnKRmKYoO1iabyeSTCoyHSoTOFhkKyRX8hG7BC/wJxV3ZiaaTHg
         gqUwMreZZXfYu6yxSY7fNS7+AsxCZBLdai0E/tgX6dakt1Vg7YlSVn+Kd4PHdtbWvxpF
         TSE8bBAh2jy9I7OZP0MbdtJ8NCo7BAmZBkwOAOr+qoYXbL1jhwkEAvy/iZ54jbMkgpV4
         rBamBDXT4Dgdgo3L1ust6B79WCBZ4JuMx34GdC915WYRLYth1m5lgCn2Db3Xc95wXzsu
         UUa6wvLnoXjP1x2Yymhffr1xJqHpgJqMCmXfQUe0Pi5RFu42SttM5KWp/xKnctdKTUYZ
         OPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mE/aKnKM07J0Pu0N2LzFy/Q/VzfI3mw7PzAs98ACEDg=;
        b=RJInC3vhMG0b+5JKcK3SuaO1sJb5dQwuwUVPiwBkkXVONq1saSpC/fVWgonw6xa44q
         guFoSAF6CgEkZzHAxBBrT2bNJzevhkxc0Bxmdua9GCN7cwjG4S7TvEV/gTuBsBzE9DKQ
         LP9UNkNXgjLIqvmf60OdHTxkvATbEMjLyZNK8XJDb8wHw0Yk1cEhANqYuCznzIrAGD9j
         3hAAqFy/z1pOMzgQWD8TLzw5DcWzulKKQmbR1PvI/f0R3//cUFJXlWXmLkTi+3EQDlFV
         nSFKNaqzYLIM3b6kD9xwH0mcF6PExz6GtZk+Xl0dQax+2NEEpuCJOr+VLt3JRFEmP61B
         7Gwg==
X-Gm-Message-State: APjAAAUcR14W2CobqSk1w07g63RBW8O9S9U7rvMbEKG2qh4aEU/RY73m
        BgUWPC74o5op7l2lYSclVmkL29jLu+7HCJHHYIQrCA==
X-Google-Smtp-Source: APXvYqx4tO5lZ9wTPWxuvQfWFmrPptbNCa+xEdfDv7AiLwjobEZcCsrg/NKC/qicGh9+cjnVUqPevHsybbd7Ng30nHg=
X-Received: by 2002:a9d:27e3:: with SMTP id c90mr60419177otb.214.1555610608522;
 Thu, 18 Apr 2019 11:03:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190411210834.4105-1-jglisse@redhat.com> <2c124cc4-b97e-ee28-2926-305bc6bc74bd@plexistor.com>
 <20190416185922.GA12818@kmo-pixel> <CAPcyv4jLrQ6evLAJzsASh=H6Tzx8E1oiF+YR3L2fOpbZYNUWGg@mail.gmail.com>
 <20190416194936.GD21526@redhat.com> <CAPcyv4i-YHH+dH8za1i1aMcHzQXfovVSrRFp_nfa-KYN-XhAvw@mail.gmail.com>
 <20190417222858.GA4146@redhat.com> <20190418104205.GA28541@quack2.suse.cz>
In-Reply-To: <20190418104205.GA28541@quack2.suse.cz>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 18 Apr 2019 11:03:16 -0700
Message-ID: <CAPcyv4iSyM2r5fv=p4B=h=1sR8Zok3gxb1BVsQOy6FHmQtjGCg@mail.gmail.com>
Subject: Re: [PATCH v1 00/15] Keep track of GUPed pages in fs and block
To:     Jan Kara <jack@suse.cz>
Cc:     Jerome Glisse <jglisse@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Matthew Wilcox <willy@infradead.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, Yan Zheng <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        devel@lists.orangefs.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        v9fs-developer@lists.sourceforge.net, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org,
        =?UTF-8?Q?Ernesto_A=2E_Fern=C3=A1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Apr 18, 2019 at 3:42 AM Jan Kara <jack@suse.cz> wrote:
> > Except that this solution (biasing everyone in bio) would _more complex_
> > it is only conceptualy appealing. The changes are on the other hand much
> > deeper and much riskier but you decided to ignore that and focus on some-
> > thing i was just giving as an example.
>
> Yeah, after going and reading several places like fs/iomap.c, fs/mpage.c,
> drivers/md/dm-io.c I agree with you. The places that are not doing direct
> IO usually just don't hold any page reference that could be directly
> attributed to the bio (and they don't drop it when bio finishes). They
> rather use other means (like PageLocked, PageWriteback) to make sure the
> page stays alive so mandating gup-pin reference for all pages attached to a
> bio would require a lot of reworking of places that are not related to our
> problem and currently work just fine. So I withdraw my suggestion. Nice in
> theory, too much work in practice ;).

Is it though? We already have BIO_NO_PAGE_REF, so it seems it would be
a useful cleanup to have all locations that don't participate in page
references use that existing flag and then teach all other locations
to use gup-pinned pages.
