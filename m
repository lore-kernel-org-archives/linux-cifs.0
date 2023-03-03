Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CD9C678D4
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Mar 2023 02:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCCCC6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCCC5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Mar 2023 21:02:57 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840667698
        for <linux-cifs@vger.kernel.org>; Thu,  2 Mar 2023 18:02:56 -0800 (PST)
Received: from kwepemm600015.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PSWT85BR8zKmSs;
        Fri,  3 Mar 2023 10:02:52 +0800 (CST)
Received: from [10.174.176.52] (10.174.176.52) by
 kwepemm600015.china.huawei.com (7.193.23.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 10:02:53 +0800
Message-ID: <c6a6e4a0-a66b-e86c-8c67-fdd24fbfcce2@huawei.com>
Date:   Fri, 3 Mar 2023 10:02:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v2 0/2] Fix some bug in cifs
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        <linux-cifs@vger.kernel.org>, <sfrench@samba.org>,
        <smfrench@gmail.com>, <pc@cjr.nz>
References: <20221116031136.3967579-1-zhangxiaoxu5@huawei.com>
CC:     <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
From:   ChenXiaoSong <chenxiaosong2@huawei.com>
In-Reply-To: <20221116031136.3967579-1-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.52]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600015.china.huawei.com (7.193.23.52)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve and Paulo:

Do you have any suggestions for this patchset ?

xfstests generic/011 always report this bug, our mount option is: -o 
mfsymlinks,vers=3.0

在 2022/11/16 11:11, Zhang Xiaoxu 写道:
> v2:
>    - remove the 1st patch since steve already merged it into repo.
>    - fix cifs 1.0 hung since not set READY flag when wakeup task
>      on 2nd patch.
> 
> Zhang Xiaoxu (2):
>    cifs: Fix UAF in cifs_demultiplex_thread()
>    cifs: Move the in_send statistic to __smb_send_rqst()
> 
>   fs/cifs/cifsglob.h  |  1 +
>   fs/cifs/transport.c | 55 ++++++++++++++++++++++++++-------------------
>   2 files changed, 33 insertions(+), 23 deletions(-)
> 
