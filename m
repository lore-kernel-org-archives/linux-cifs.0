Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806C9C00140
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Aug 2022 02:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbiHCCg7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 22:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiHCCg6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 22:36:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30F3BC83
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 19:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50A5961059
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 02:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9975FC433D7
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 02:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659494216;
        bh=+GL9aGH/d6TMgQQhw2XctptOqw52uVBcpBMZNAPgfmo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=LhQda6LBsG0nx+pjrOIPgAsXuBUXl/ngAhUVX+c5okXQrxSTVi5EOJVC26jyDPp0C
         kBn37gUaVNXvH23C+CvLLnsgaj+9gwbqvTiapj2yI/hBCUDCVYm5EfeYIBeMUPyEdR
         U1jH0NWkZXV4ebdqGzjZGBtYmubZZ6od2fZY/h332dfl8TestcFWbr1rz0kbVhWWkJ
         Z9nwzRRtp7y03VxDIUlC+xZwkIARaKuOsw8mlizhlcURRvvojwHitEQhFjn4czkZJ9
         gJ63fR+CloDgcLOPO5J6L3S5ZeBdBMjGfVJP7p1sIXFiMCU3+0JHrpZhBoszKcDyyH
         k5bVAuba9ACjA==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-10bd4812c29so19351552fac.11
        for <linux-cifs@vger.kernel.org>; Tue, 02 Aug 2022 19:36:56 -0700 (PDT)
X-Gm-Message-State: ACgBeo1bSarGEjRUG44CFg01oUwrsQ8NI7BmpctzJYMDEmMxKWal8JHY
        6iVAbkrie1MFUSWCKdx6mP9HrO1lmIIp1f99yjM=
X-Google-Smtp-Source: AA6agR7G7eiIdrAZ85q658bKXZ0O0x//1pwK4EfzHRCwsNa4Sf/egLkdz4b0ZqliDlD8B7ha6D6xA8u0qfzbBPeoNrg=
X-Received: by 2002:a05:6870:f69d:b0:10d:81ea:3540 with SMTP id
 el29-20020a056870f69d00b0010d81ea3540mr1039548oab.257.1659494215703; Tue, 02
 Aug 2022 19:36:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6839:41a4:0:0:0:0 with HTTP; Tue, 2 Aug 2022 19:36:55
 -0700 (PDT)
In-Reply-To: <CAKYAXd-sWDpGKZpns=yW-TcOytbVZXdFK9h2BGdmP4g0+p6v-g@mail.gmail.com>
References: <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <1922487.1653470999@warthog.procyon.org.uk>
 <3343812.1659453040@warthog.procyon.org.uk> <CAKYAXd-sWDpGKZpns=yW-TcOytbVZXdFK9h2BGdmP4g0+p6v-g@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 3 Aug 2022 11:36:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-X6w-Vt0-p2X7zQd6bC+QkaViUsXXWkyWVkoGciAx6NA@mail.gmail.com>
Message-ID: <CAKYAXd-X6w-Vt0-p2X7zQd6bC+QkaViUsXXWkyWVkoGciAx6NA@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     David Howells <dhowells@redhat.com>, Long Li <longli@microsoft.com>
Cc:     Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-03 9:55 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> 2022-08-03 0:10 GMT+09:00, David Howells <dhowells@redhat.com>:
>> David Howells <dhowells@redhat.com> wrote:
>>
>>> With that, iWarp works for me.  You can add:
>>>
>>> Tested-by: David Howells <dhowells@redhat.com>
>>
>> Would it be possible to get this pushed upstream as a stopgap fix?  iWarp
>> still doesn't work in 5.19 with cifs.
> I will try this.
I have updated the patch, so I don't add your tested-by tag for
previous test patch.
Long said to change that value to 8. But max_sge in cifs need to be
set to 6 for sw-iWARP . I wonder if there is a problem with values
lower than 8...

Thanks.
>
> Thanks.
>>
>> David
>>
>>
>
