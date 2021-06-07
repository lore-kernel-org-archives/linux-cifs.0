Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A9CC47095
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 13:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3152061153
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 13:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFGOAS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Jun 2021 10:00:18 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:33787 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhFGOAR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Jun 2021 10:00:17 -0400
Received: by mail-qt1-f171.google.com with SMTP id e3so1011518qte.0
        for <linux-cifs@vger.kernel.org>; Mon, 07 Jun 2021 06:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LSEQWZP6ltUZh8/1tscfee4ykF012TZGRkAClyEpoYs=;
        b=D2IeGpHxONNWeCdCum02Fz+NLcoOzub2uAe+9n56I90P6i77vasNDBK0swy+5pB+Yn
         Y/jtjCBWlkZCvYyrLEcWhiuUGtnrW2uqQ1IJHaN79ZWM2NQin/eF/J/JvOjkNmtMwAvN
         b1OaIPnvHJM8i2nziUi9CxRTP/dTtmxuR7Y6V9bXcczTxAZ+A0OMWh3+wz8LuinryXgd
         nBJR1AHZI8yQZQZm0Y0mZoPK9iui9cKCOtTSXb8lCwjdoLPRTDnhRx1A/x85d8WlusPC
         gF/5m73peaQ/9CN31aYFLpcDcmvsd1QqHFAGOxMMm/UhtB732cfLWIWC2ybzRW2qBi5v
         mJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LSEQWZP6ltUZh8/1tscfee4ykF012TZGRkAClyEpoYs=;
        b=PNd797GckZNRehb4i2vZ2tYDBwNf1cccrjbkIV0PRYke9knO7xuJsDIeuhHIvSMZ5M
         nJUM+CouYNPUgabFQAfrYarNvo6AaUn15Wmt0yuWkNeZFO9kJFix3MhgxB1MdN0ecUK0
         SEAnliD9O30Ozq/Z1AV1uEP14Ga2bH5gTQ800A7lXfFXTnz3e6ySCy6wakqWBu5jQPF/
         Bpx9javrCF4SvsvYbW4+sxberupdh1M9mqrRaCJ/OTHXQPI9SQHfxYWcxVN0kldCXagZ
         hNvz/lo8m2DMnxGcdNLCyaxIs3TxbvoNm0zCy8jqxnM0gymYSPSBp8Lwx2wTAgmokD35
         QfSw==
X-Gm-Message-State: AOAM533AjOVhKnQk3G2s6LrWRtC+ejveQMGL/VmPsyavL9+nIK6xfK0O
        kx03RpcNxcAENDqHdk3HHTQ=
X-Google-Smtp-Source: ABdhPJy+Q8J7xjhS47epzbN6hK2I68OFRU17edQ8jpfokHnuSaTCHOEvZPMAaM5pDbmxS134QExxCg==
X-Received: by 2002:ac8:734f:: with SMTP id q15mr7765595qtp.146.1623074229239;
        Mon, 07 Jun 2021 06:57:09 -0700 (PDT)
Received: from nyarly.rlyeh.local ([179.233.244.167])
        by smtp.gmail.com with ESMTPSA id b189sm9723695qkc.91.2021.06.07.06.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 06:57:08 -0700 (PDT)
Date:   Mon, 7 Jun 2021 10:57:04 -0300
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org,
        samba-technical@lists.samba.org, tbecker@redhat.com,
        jshivers@redhat.com
Subject: Re: [RFC PATCH] cifs: retry lookup and readdir when EAGAIN is
 returned.
Message-ID: <YL4lsBT8Amy4Nh87@nyarly.rlyeh.local>
References: <YLplrk3FQiUtVoWi@nyarly.rlyeh.local>
 <87v96qrpdt.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87v96qrpdt.fsf@suse.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 07, 2021 at 11:32:46AM +0200, Aurélien Aptel wrote:
> If the user session is deleted trying again will always fail. Are you
> sure this is the reason you get this issue?

It is. We can explicitly delete the user sesssion on windows prior to one
of these calls, which will be replyed with STATUS_USER_SESSION_DELETED.


  470 0.0 client → server SMB2 198 Create Request File:
  471 0.n server → client SMB2 143 Create Response, Error: STATUS_USER_SESSION_DELETED

Which is converted to EAGAIN with the expectation that someone will
handle it down the stack while the user session is restablished. This
doesn't happen currently, and EAGAIN is leaking to userspace.

For getdents, EAGAIN is unexpected, and most applications don't bother
handling it, including coreutils (ls and stat were used to test this
patch). And for several syscalls that rely on lookup, returning EAGAIN is
unexpected, so we shouldn't leak it.

In our testing, sending the call again handles the problem with no userspace disrruption.

Best,
Thiago
