Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18B3C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Feb 2022 14:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiB1OYW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Feb 2022 09:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiB1OYW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Feb 2022 09:24:22 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC12193E7
        for <linux-cifs@vger.kernel.org>; Mon, 28 Feb 2022 06:23:42 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id y26so13101851vsq.8
        for <linux-cifs@vger.kernel.org>; Mon, 28 Feb 2022 06:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5nVXvC2nHbZHmN0RlyE35i5oxN5wsrAV/DM06yoOt6o=;
        b=Dq8BYL3m1kfYI+jzcRgK2nghUdbIlfRQ+FnOgRiCAiKFb+98rBr2y8EfmqYE1FniGy
         DIYw804pUY1GR8IWaaq5zhBTOmziFXA8ZaemOLnDwqIeYng4PyTwRv8kHvU423/f0j6+
         xyiB23icf6UDMEjK54s9kbaIc11qE/P5W/Tv2pw56QX1uWgTvVfF7FBxa01Zt/SuLh8f
         0wyCaI7n633R0Pllu8vct74wSRycMvtow/J7CktRlp0bLmf0I5p8uyjrieYz8N46SNWr
         Efmj1ghdEBe/KM19Mi9KWmROBvtaoU1BHR/5gDO2ClY3tgKk+2eIE0PVZ5DnPfXKueRn
         Plng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5nVXvC2nHbZHmN0RlyE35i5oxN5wsrAV/DM06yoOt6o=;
        b=wx3HZsoRyIvSiih7YNoR4gg1xW/vivLY8RnG6Xt31FrvlnEFeJcUibr30sjV6R+NG5
         4hfBkW34HfFFeT+DOPY12iWsDY+vj+kPHBNriFyeqDgvsL6dmV+lX+W50yHVS18VyrpR
         L6BH6koCm/6Mof2aLJl/cD8PM9lDY+E9ZTj2ogq9jSkDRpOj2LrBdxk3MTwcZoZu7nr3
         caOLnxo515hTpO51QQbcQ2oUpJ8CE/Oy6LUngQ1PC1ieLeCj4E0BLwMosq+oRFFbtlqo
         KDbmZ9Y+JyqU9LYbsbkRRidw8MJ7mR5i5DZC/Cetg1dZzAA3Ry1ujtJ8gTcQ0wVX/pcN
         ed1A==
X-Gm-Message-State: AOAM532VMk9eTXx/U8YT+frasP0MpiVOuii4TbHWsvC5qTNvfyqRsD2g
        kJW9pTtNVMYUisyRVKzxespFB4VDzXTXloEx1Vo=
X-Google-Smtp-Source: ABdhPJyIvScS8gl5mnIHa9dmbTH424Pbq4tlXRJ5kA7QJBXKIU/JZQVuduBnwsGAc7lZ+/WaUZcFUJs862mJXp0HwlU=
X-Received: by 2002:a67:d618:0:b0:31b:734f:b36 with SMTP id
 n24-20020a67d618000000b0031b734f0b36mr8078038vsj.13.1646058221124; Mon, 28
 Feb 2022 06:23:41 -0800 (PST)
MIME-Version: 1.0
References: <CACdtm0Z4crPr868DRGCYNd=euVXzm+T+rPHT4PdqK66TV7iioQ@mail.gmail.com>
 <914621.1645046759@warthog.procyon.org.uk>
In-Reply-To: <914621.1645046759@warthog.procyon.org.uk>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Mon, 28 Feb 2022 19:53:30 +0530
Message-ID: <CACdtm0ZteTve1EbSgDX_jochhHT7Ufm3gJg7j28BOjmRSg8dTQ@mail.gmail.com>
Subject: Re: [PATCH] [CIFS]: Add clamp_length support
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

Do you mean the clamp handler in netfs should return the size of data
to be allocated instead of allocating itself ?

Regards,
Rohith

On Thu, Feb 17, 2022 at 2:56 AM David Howells <dhowells@redhat.com> wrote:
>
> Rohith Surabattula <rohiths.msft@gmail.com> wrote:
>
> > +     credits = kmalloc(sizeof(struct cifs_credits), GFP_KERNEL);
> > ...
> > +     subreq->subreq_priv = credits;
>
> Would it be better if I made it so that the netfs could specify the size of
> the netfs_read_subrequest struct to be allocated, thereby allowing it to tag
> extra data on the end?
>
> David
>
