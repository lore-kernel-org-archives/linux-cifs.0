Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6897DC32793
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 20:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjARUwI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Jan 2023 15:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjARUvz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Jan 2023 15:51:55 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E44B63E25
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 12:51:08 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id p25so31790103ljn.12
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 12:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AQuF1V58l8Zpcydwul0JifjH7G5Ph/qiDaWVDa9YQJc=;
        b=cI+wAzwcoi/bAyoQjGupOvoLbNukDpuaTTcEF73p+eJNdK96paHs/ZKUyaetZ+Ywy3
         fyiifnM6cAKb295JhwGZgYdjcPTmieQem1Q6Ql1BEo+SPHjLI2iA+YmpdN9DLW8Qt7k+
         t3clFdpVyfc9tEX52y0RCwai8LEwXmbOi+ysENkpmyVGlBYYabNRlMz4twPjsm4H+ToK
         MBK599Aus+2LdiV0zw+44RC2Lm9z9a9AcCKveF1ncD54HpsCGMt8XsJsdoTBFpCs5fho
         M/lS9tiwTRpBqZCag8Nkb1saj90SqI4iirOiFy5LEC+8slkVh7Hcs0HnQWC2aU0O2A4S
         HUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AQuF1V58l8Zpcydwul0JifjH7G5Ph/qiDaWVDa9YQJc=;
        b=iLoXQ640SvTM8uqhn44r22OG6qFL02m4KzESKIXzaAsIsjpjnLL1TDvxmFuhBO0KUO
         xK9KIsRpM9CAtwt8aCOVHOn45C/TCe78+zVA7DfJoyKv4RXM1qCIorGkER636rnJTD05
         ai5KNDPJbcUpF/+B8O98g5akIaIAvOxhrsFiXizQ76Oq5o5X7bB/zcTuPUXY/PppW18b
         /TQZIBZCX9n+kOUp1CVTZKoUihVSsOGvPL3r8Leiv71UinrX5DPzVbqWSyRl2hOWrLx5
         1wxi4tDRjtRVMg6GQfmz5IXUZlm5nzETM+DBTwV0u52E6gX8nc0XCSFVCL0uK2mhBRTU
         buZw==
X-Gm-Message-State: AFqh2kqAFlTNx4Ex2crV1DBAhuLzlTiFjR0wHB1Hxqjp5SucUMga1bzJ
        HMh1KU2PkA+mNQ53kWMevqsFavwN4jHH5LnTSNGO3rIf
X-Google-Smtp-Source: AMrXdXs8cPuIxgW78V1nPO9cR5t8gtF87gCr8y933VaA6218dfnOOFI9x5D46NOSKVfCHpQCX1afucIpLRSahKEVsVs=
X-Received: by 2002:a2e:96c6:0:b0:28b:7925:3d2 with SMTP id
 d6-20020a2e96c6000000b0028b792503d2mr458265ljj.229.1674075063647; Wed, 18 Jan
 2023 12:51:03 -0800 (PST)
MIME-Version: 1.0
References: <20230118170657.17585-1-ematsumiya@suse.de> <871qnrvc7z.fsf@cjr.nz>
In-Reply-To: <871qnrvc7z.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 18 Jan 2023 14:50:52 -0600
Message-ID: <CAH2r5mvrTcFk_Xha4rdmXA0+61WprZ7LPS5U3H_atK2oJAFM6g@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not include page data when checking signature
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending additional testing

On Wed, Jan 18, 2023 at 2:07 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Enzo Matsumiya <ematsumiya@suse.de> writes:
>
> > On async reads, page data is allocated before sending.  When the
> > response is received but it has no data to fill (e.g.
> > STATUS_END_OF_FILE), __calc_signature() will still include the pages in
> > its computation, leading to an invalid signature check.
> >
> > This patch fixes this by not setting the async read smb_rqst page data
> > (zeroed by default) if its got_bytes is 0.
> >
> > This can be reproduced/verified with xfstests generic/465.
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > ---
> >  fs/cifs/smb2pdu.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
