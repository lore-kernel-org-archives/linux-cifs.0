Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF960CDB47E
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Oct 2023 23:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjJMXw0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Oct 2023 19:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbjJMXwZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Oct 2023 19:52:25 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF928AD
        for <linux-cifs@vger.kernel.org>; Fri, 13 Oct 2023 16:52:22 -0700 (PDT)
Date:   Fri, 13 Oct 2023 20:52:11 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1697241140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5bsDw6yHHct7yDhePGgvyRyMqwFfVNp3FGbg+Dajzw0=;
        b=osPC+RLVzn4ub/0Wy0HXidTzTCaiamTKskPsHwgDS1dqDLy4cVJDxxmlgEQVpRvCX/+MWF
        G/B4gMOg/Otx7VTt6wH1f+oM793bHoZ7vxOTv3I/pxyrrxN8SJNRv/PPyzL1wSh1i2WrB2
        +Yhb5+OroSxPUIykL2Nr1i3U1H1NBRwSgJWQsj0CnP9cHjqtDuIh+9sg/Y/TLZU/3WAnW3
        dIjw+XEGF7ADXonAhUIBmF4GNXesHZVBzC5hiFzyulKdRiIuvA4sN3p2nSML+BEFfuajgS
        Gyn7jG8I/PRL+XU69q6hZjKsSa+7XoBW0cVnqGYGGg9bVw0i75f6Tbz/mij0eQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1697241140; a=rsa-sha256;
        cv=none;
        b=Ewo+65jKz8/FLnZh8lOE5/KEHvEZndFBHCFzEwnUHv+QWH7xtnVEF2sGT/7GF4CYKC7ulZ
        Nn5VcSKLawgTH/CRGrMe7P52dYv0mEGSRHAYOdIEm198azmq9CZgyt7Um+AB+wYazbf4in
        GG7lHdG0bA26DgwbZDy3D+qv8EGgE56wVig7p236flGgDd+g7xke09hN4jTSKX1awOivdV
        2AXmtJOGxLHsQvW84mV9MFclfiExdOjeOcL4hr2zc8w6tDpKcsjByIOfxbtojzW1GQVNVu
        Q8bYOyhtHfJ8H1OkGtxz2ucf5RTRrYkrboCEjF8nA1Uo3r0KqwqW0vykjjxNgg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1697241140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5bsDw6yHHct7yDhePGgvyRyMqwFfVNp3FGbg+Dajzw0=;
        b=s55wGhOQnNGZLioGpGqp8uX9GsKVa/ZMbXV36rUJkUkDch/3dFoMkUyLZega8ivqCy+2y/
        mf/5ZF3orU99tW73oRdtfwMr1Lug3uGc3zAoutA+kL8rI84BxPaVt+jhV7cY6icn+4rd6P
        Jz7M2U8qmfGjfRe51zLCAgt2JkCvoDBReu3Q5nssYJtmQbeT+Msa071GXRMiNzj+yszCLV
        AbFgeTnMvoNmyfP22zvu05uSfRuxa6ObUvHEEiV2bzSq/IFaudqicrwcnBoh/oUHXYoSyh
        fi058u0dQ90IP2iyJDsdDunW4m7Lzm+y9+bBAhE5aUsnE+yR5KukoTJbuPZP6g==
From:   Paulo Alcantara <pc@manguebit.com>
To:     matoro <matoro_mailinglist_kernel@matoro.tk>,
        "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>
CC:     tom@talpey.com, smfrench@gmail.com, paul@darkrain42.org,
        linux-cifs@vger.kernel.org, bagasdotme@gmail.com,
        regressions@lists.linux.dev, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, brian.pardy@gmail.com,
        bharathsm@microsoft.com, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_Possible_bug_report=3A_kern?= =?US-ASCII?Q?el_6=2E5=2E0/6=2E5=2E1_high_load_when?= =?US-ASCII?Q?_CIFS_share_is_mounted_=28cifsd?= =?US-ASCII?Q?-cfid-laundromat_in=22D=22_state=29?=
In-Reply-To: <83d00d50bc628a85db71adb440d8afb5@matoro.tk>
References: <CAO+kfxTwOvaxYV0ZRESxZB-4LHsF9b_VBjAKahhwUm5a1_c4ug@mail.gmail.com> <ZPfPfyIoVxw5L6El@debian.me> <CAO+kfxQgXOsx6u+xLKGJe0KDiFsRAGstSpnrwxjQF6udgz5HFQ@mail.gmail.com> <CAO+kfxTvA6N=i+jGf0XbSyqf85i=q+vR6R9d_42OWfM2sWWXaA@mail.gmail.com> <CAH2r5mtUedfLSv81Z-Yb3_=AbD_QpT3tVbU1PRzMTituaw7bgA@mail.gmail.com> <CAH2r5mt6YzapEKDo=hQ64yvBn7=jwMmY1c85NOABKcMPKPp3KA@mail.gmail.com> <CAO+kfxQtOKoKdb+LtMeFxgu8VXa73nbmTPSfscbdwjUXM7ME_A@mail.gmail.com> <CAH2r5msNf9WDHrBZSi5FhHDSewSNxMAuXTetMJDnoNh3CF_oMA@mail.gmail.com> <a895f860-11fa-e6d9-d042-a32bd08f9e9d@talpey.com> <CAH2r5mszCxPtdURenMVgeVDX5zc8knumH=ASXyUufPa7SxbJBw@mail.gmail.com> <ZRN9MtBqYnT6oX60@vaarsuvius> <85d538fec5a086acf62d5a803056586a6c00e4bd.camel@uniklinik-freiburg.de> <83d00d50bc628a85db71adb440d8afb5@matoro.tk>
Message-ID: <E1F307C7-9B1E-40F6-860B-6050856E8395@manguebit.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Could you please try two commits[1][2] from for-next?

[1] https://git=2Esamba=2Eorg/?p=3Dsfrench/cifs-2=2E6=2Egit;a=3Dcommit;h=
=3De95f3f74465072c2545d8e65a3c3a96e37129cf8
[2] https://git=2Esamba=2Eorg/?p=3Dsfrench/cifs-2=2E6=2Egit;a=3Dcommit;h=
=3D81ba10959970d15c388bf29866b01b62f387e6a3

On 13 October 2023 20:19:37 GMT-03:00, matoro <matoro_mailinglist_kernel@m=
atoro=2Etk> wrote:
>On 2023-10-05 05:55, Dr=2E Bernd Feige wrote:
>> Am Dienstag, dem 26=2E09=2E2023 um 17:54 -0700 schrieb Paul Aurich:
>>> Perhaps the laundromat thread should be using msleep_interruptible()?
>>>=20
>>> Using an interruptible sleep appears to prevent the thread from
>>> contributing
>>> to the load average, and has the happy side-effect of removing the
>>> up-to-1s delay
>>> when tearing down the tcon (since a7c01fa93ae, kthread_stop() will
>>> return
>>> early triggered by kthread_stop)=2E
>>=20
>> Sorry for chiming in so late - I'm also on gentoo (kernel 6=2E5=2E5-
>> gentoo), but as a client of Windows AD=2E
>>=20
>> Just want to emphasize that using uninterruptible sleep has not just
>> unhappy but devastating side-effects=2E
>>=20
>> I have 8 processors and 16 cifsd-cfid-laundromat processes, so
>> /proc/loadavg reports a load average of 16 on a totally idle system=2E
>>=20
>> This means that load-balancing software will never start additional
>> tasks on this system - "make -l" but also any other load-dependent
>> system=2E Just reducing the number of cifsd-cfid-laundromat processes
>> does not fix this - even a single one makes loadavg report a wrong
>> result for load balancing=2E
>>=20
>> So, if cifsd-cfid-laundromat must really be uninterruptible, the only
>> solution would be to change the way loadavg is computed by the kernel
>> to exclude uninterruptible but sleeping processes=2E But must it be
>> uninterruptible?
>>=20
>> Thanks and best regards,
>> Bernd
>
>This is a huge problem here as well, as a client to Samba using SMB1 (for=
 Unix extensions)=2E
>
>For others encountering this problem, I was able to work around it with t=
he following snippet:
>
>diff --git a/fs/smb/client/cached_dir=2Ec b/fs/smb/client/cached_dir=2Ec
>index 2d5e9a9d5b8b=2E=2Efc2caccb597a 100644
>--- a/fs/smb/client/cached_dir=2Ec
>+++ b/fs/smb/client/cached_dir=2Ec
>@@ -576,7 +576,7 @@ cifs_cfids_laundromat_thread(void *p)
>        struct list_head entry;
>
>        while (!kthread_should_stop()) {
>-               ssleep(1);
>+               msleep_interruptible(1000);
>                INIT_LIST_HEAD(&entry);
>                if (kthread_should_stop())
>                        return 0;
