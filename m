Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923FDC4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Dec 2022 03:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiL3DeC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 22:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiL3DeB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 22:34:01 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFEF1868D
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 19:33:58 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id bf43so30175684lfb.6
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 19:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9qefYZ5qnloMz3eYPSn49OcdoGxY6Ybcu7tQzavkZ0w=;
        b=Ns3S9DE61itn9rxWjPoxs8uLzHF83/HEowLdvLqg75eVi4I76Q84m0w99nvbjMzI4I
         X+012Gi/shW/ZPgff+Z8Z5gk9yDq6IaWPUvAnVSCFknzRByPKpAtrZY0Z5kTHBei3czd
         2vclQmX0o+dee23VZzdY8rjJUP0Vmuq2HGw58NXAAHo8MDg22uKm6iTTdZltSDQcOmBz
         dad2SM9j2uwY4n6KGf9aHK1Z8WieUfnrRq8RzCuAzYaUGpfHc7Vk4AR46vDa1jOrg2YK
         cXgkiHucODSouoMQ+PPJnvJiKizqETZzAqtFlIzWApG2alhWiFeMOi4mgKEhPQlNAYzI
         Gu/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9qefYZ5qnloMz3eYPSn49OcdoGxY6Ybcu7tQzavkZ0w=;
        b=f/ZFHWE4FEVQQ+CMYvxSopj75wYpyjxGaEg/criuhGBjjun8LHUrrDruVZmqUSSyYM
         hlygEJJqz2qTKA4ZDJ8K6xLM3cJzMEkESIc6jSSMUUwGu5nKUVN5KxNjOrtqIJr4lPLs
         ZkjPO0mvhffHTxhJnoo9xgDueHNrrQC25sOIhgwMJsYLQVgpq86u8i2ZEQsHRxcgK9U6
         WVzrx6iGkMEhhZuebdcl9xTY9p0ZHvs2OZpR88OgI0iFVYV2gyXNfWN/T+bNZzZ4zcLl
         BNrs7rxDEgunG2+JUaz22bFh+aSdoe7m6/nc1+1KBhjaTGzkyLuwdDAZiMOezs8owH72
         ljhA==
X-Gm-Message-State: AFqh2kpvm3ghsP3/yaJdSgtahEqmwluaMthxf30edJ/UAivRatUwlsXs
        f7qfTNxhhD0GasCtmVh9G1vSXYjfDxC2+7cJkjM=
X-Google-Smtp-Source: AMrXdXswQypeo26RU2sQ7kTfwc+aY92KpS+w2N1u+1sMsRpoS2my2fOXXw9TbB6OjgDvf8BRerHV2uAWujrSe4tWlg4=
X-Received: by 2002:a05:6512:552:b0:4b5:9233:6e9b with SMTP id
 h18-20020a056512055200b004b592336e9bmr2863348lfl.394.1672371236172; Thu, 29
 Dec 2022 19:33:56 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qEwppcgZvbdLaABb6M-pRxyDQ05oHOb523n34tYyDqcw@mail.gmail.com>
 <87a6364d6x.fsf@cjr.nz>
In-Reply-To: <87a6364d6x.fsf@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 30 Dec 2022 09:03:44 +0530
Message-ID: <CANT5p=o9y+w885o2kW0fiyXKUjrzc++8T6-7eqPH=EeYL1Q_Ew@mail.gmail.com>
Subject: Re: Deadlock in Ubuntu 5.4 kernel
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Dec 29, 2022 at 5:47 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > A customer reported this deadlock in a Kubernetes setup running on Ubuntu-18.04.
> > This must be a 5.4 kernel, running this code:
> > https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-azure/+git/bionic
> >
> > Based on the stack, it appears to be a hang in DFS reconnect codepath,
> > trying to access the DFS cache lock in dfs_cache_update_vol.
> >
> > Can you tell if this is a known issue that has been fixed since?
>
> Looks like this has been fixed by
>
>         06d57378bcc9 ("cifs: Fix potential deadlock when updating vol in cifs_reconnect()")
>

Thanks for this.

> > And if Ubuntu should backport any fix to 5.4?
>
> I would say so.  It would probably also require others dfs related
> patches to be backported in addition to the above.

If you could point me to a list of other patches that could be
backported to a 5.4 kernel, that would be great.

>
> > I could not find the function in the mainline codebase.
>
> Yes, it has changed alot.

-- 
Regards,
Shyam
