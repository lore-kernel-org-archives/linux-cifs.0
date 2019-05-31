Return-Path: <SRS0=zOxz=T7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E980C04AB6
	for <linux-cifs@archiver.kernel.org>; Fri, 31 May 2019 23:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67AF9207E0
	for <linux-cifs@archiver.kernel.org>; Fri, 31 May 2019 23:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aP1mz5zH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfEaXyl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 31 May 2019 19:54:41 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:46266 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfEaXyl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 31 May 2019 19:54:41 -0400
Received: by mail-pl1-f178.google.com with SMTP id e5so2861290pls.13
        for <linux-cifs@vger.kernel.org>; Fri, 31 May 2019 16:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=5omtgLxpDlsvQtYocQ91OjUMb4kvBlwgc0ia03Bk3TA=;
        b=aP1mz5zHKNifcTzAm03krhiQtbW98UGzIIwk0gZ14OBOw2Wy++r1pH4qjLLbo0917M
         CR7P3f51M+vLBpNP8d5sWQncRuATcn/cRZLXl4gjGdOVHUsFb5W53rE0cr5D67pblP1e
         0gV2Xt7dK0grw9Ozh6eHf8l30rl95tUsgpBODnoJ4piT4t7QpINskPIVPeylrJmP/teE
         eoyhbQRecJ0wSs4Rt0Fv5+3SFcyj6AL0lMvZQG6oMhxMmfG5tTKVP8ukvqBaxglJc8FP
         ZPN0DOTg4t2bqLavquMhJZiaSsxU5LeLeATBm5TT/e1iUi6xFpAa/XEVA3osQ0LMr5+C
         xmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=5omtgLxpDlsvQtYocQ91OjUMb4kvBlwgc0ia03Bk3TA=;
        b=daqUuJTOVl0umvkdHxNsEX5VrZi92vdZLme2LdXJ+3AXOVE0qCmGsY5ScuIVyhY+pk
         dKXnGaroa7MsFg2Nc4GynjsYKRaUK3UOQbaWjcH7bdpdYJg/mlMAO537ZxPqvhEN9xyi
         ldoQiQrYev6eZ5Boq1owUI0/cjTge+M3klV/hd6M/+axsUn5B7eE0kt/3ySSJzopHil4
         NkT9Om1HLsG4cD7jglE9pxkzUHJg3lDsJM0eZGe56R81hJTNKgZetT7Kb81axiWDJ5I6
         8AXPTuCyAWt1SusadpQdWx+F5P3MJVaH1neXi5BoRa257LUGxqLDQ3LttA6N6nPShbOn
         nhBA==
X-Gm-Message-State: APjAAAUsrqMTmROAKl2mHaLvQIusJ8kPWb5XJLDBljqXv1urRVveiVb0
        Hf+kiXOyRxHhNNHx5AFlkY6mdcmfV4Mm8Xi/zowu3/bP
X-Google-Smtp-Source: APXvYqxKxVdvmeGsZgUjivYxpoUTqtFY+Azk0hoBeugtmniEww0MUNBoU07KdqN9kTSdxyYuldk/dF0RzMh2fIvwisY=
X-Received: by 2002:a17:902:7618:: with SMTP id k24mr12996748pll.78.1559346880011;
 Fri, 31 May 2019 16:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv_xgWmFfSanMxo4LUmEBRuQZtKGRvFqFD285DkyD2PZg@mail.gmail.com>
In-Reply-To: <CAH2r5mv_xgWmFfSanMxo4LUmEBRuQZtKGRvFqFD285DkyD2PZg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 31 May 2019 18:54:28 -0500
Message-ID: <CAH2r5mvKPCcO1V_JSTvR4oNWmH4wigOZmwteDpMfWULtMHoerA@mail.gmail.com>
Subject: Re: Added test 091, and updated github tree with current 5.2-rc
 mainline, rerunning buildbot
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

091 didn't work to Azure so retrying with Windows target - running
updated cifs-testing group:

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/220

On Fri, May 31, 2019 at 4:20 PM Steve French <smfrench@gmail.com> wrote:
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/169
>
> Buildbot run with updated kernel (5.2-rc) and added test 091
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
