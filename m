Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7AFC433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Mar 2021 00:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0479C619AA
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Mar 2021 00:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCWAGO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 20:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhCWAGA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Mar 2021 20:06:00 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2563FC061574
        for <linux-cifs@vger.kernel.org>; Mon, 22 Mar 2021 17:06:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so9119919pjb.4
        for <linux-cifs@vger.kernel.org>; Mon, 22 Mar 2021 17:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YrwTxM1JRhwCBImEEMiXrWUueuGP8y0gV5ZRW5L/A0w=;
        b=AJK6iy9YZIVcsFMyZdM9/n2Nq0jYRLcbLu0OgwUd6kWoGdYixeRnX91zceByThB+qg
         1O9QBmew16jSEs3tCZj/VvWo4XFFHqr29XVTBN8INs9MAV1j69hzmrerT3ouIxnYD54Z
         wl2MsvF3QF/MbjAbrMzOV+q/Tyj/tgJMdUMDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YrwTxM1JRhwCBImEEMiXrWUueuGP8y0gV5ZRW5L/A0w=;
        b=P2tqh+yB4KHKJfSPH2BC5BpKieqVi5AaCAz6ipQ+6YgaIHfsxzKxzZ6tObeNtKKH1H
         fkRQjZCuLILGIHUAh7Muzm4emUhK7Eb9hDT/YHxkTHpjwXA+ETh+J/OKrF/TPJyuVeCE
         rB9RznkK2shWXgQmv7fv3ctf3Dy15jYGnQpw7qBgL3Vuv5gEsFuxo90FSxoAV3GnRhds
         eRzxm47uUxRlQG7gfe/BOibylC2s6u0pzR+YEO6MdS0ekk0egc2Ydz/Opvzi13Kia1/5
         FpI+PiSpJce2GuZLEKRxsEV5LMDHtgUik9Fa/8HFY4cT6OsBBCo76KAYqjzMwXbBdNgD
         IZ8g==
X-Gm-Message-State: AOAM533oLZ9W/w8WWgiNVpktqVtilqmv1IZypw2JRoaXCgiyZiUmdK6M
        PrPiUareUMsKUqy1eVeHppasiw==
X-Google-Smtp-Source: ABdhPJzi4JptaWSjZ+IpPh95R3QM3rbCmXAkIDW3AERR+GPKvu25DYfOuw1jEE+qkDYTJZUnMG4TkA==
X-Received: by 2002:a17:90a:7c4b:: with SMTP id e11mr1510708pjl.151.1616457959673;
        Mon, 22 Mar 2021 17:05:59 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:bcf2:e05a:a993:9494])
        by smtp.gmail.com with ESMTPSA id t22sm493650pjw.54.2021.03.22.17.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:05:59 -0700 (PDT)
Date:   Tue, 23 Mar 2021 09:05:51 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net, smfrench@gmail.com,
        hyc.lee@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de,
        hch@infradead.org, ronniesahlberg@gmail.com,
        aurelien.aptel@gmail.com, aaptel@suse.com, sandeen@sandeen.net,
        dan.carpenter@oracle.com, colin.king@canonical.com,
        rdunlap@infradead.org, Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 3/5] cifsd: add file operations
Message-ID: <YFkw3yabfNCXuO05@google.com>
References: <20210322051344.1706-1-namjae.jeon@samsung.com>
 <CGME20210322052207epcas1p3f0a5bdfd2c994a849a67b465479d0721@epcas1p3.samsung.com>
 <20210322051344.1706-4-namjae.jeon@samsung.com>
 <20210322081512.GI1719932@casper.infradead.org>
 <YFhdWeedjQQgJdbi@google.com>
 <20210322170916.GS1719932@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322170916.GS1719932@casper.infradead.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/03/22 17:09), Matthew Wilcox wrote:
> On Mon, Mar 22, 2021 at 06:03:21PM +0900, Sergey Senozhatsky wrote:
> > On (21/03/22 08:15), Matthew Wilcox wrote:
> > > 
> > > What's the scenario for which your allocator performs better than slub
> > > 
> > 
> > IIRC request and reply buffers can be up to 4M in size. So this stuff
> > just allocates a number of fat buffers and keeps them around so that
> > it doesn't have to vmalloc(4M) for every request and every response.
> 
> Hang on a minute, this speaks to a deeper design problem.  If we're doing
> a 'request' or 'reply' that is that large, the I/O should be coming from
> or going to the page cache.  If it goes via a 4MB virtually contiguous
> buffer first, that's a memcpy that could/should be avoided.

But huge vmalloc buffers are still needed. For instance, `ls -la` in
a directory with a huge number of entries.

> But now i'm looking for how ksmbd_find_buffer() is used, and it isn't.
> So it looks like someone came to the same conclusion I did, but forgot
> to delete the wm code.

Yes, I think it's disabled by default and requires some smb.conf
configuration. So I guess that wm code can be removed. Especially given
that

> That said, there are plenty of opportunities to optimise the vmalloc code,
> and that's worth pursuing.

That would be really interesting to see!

> And here's the receive path which contains
> the memcpy that should be avoided (ok, it's actually the call to ->read;
> we shouldn't be reading in the entire 4MB but rather the header):

> +		conn->request_buf = ksmbd_alloc_request(size);
> +		if (!conn->request_buf)
> +			continue;
> +
> +		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
> +		if (!ksmbd_smb_request(conn))
> +			break;
> +
> +		/*
> +		 * We already read 4 bytes to find out PDU size, now
> +		 * read in PDU
> +		 */
> +		size = t->ops->read(t, conn->request_buf + 4, pdu_size);


// A side note, it seems that the maximum read/write/trans buffer size that
// windows supports is 8MB, not 4MB.
