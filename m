Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE62C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Apr 2022 04:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238583AbiD3ENi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Apr 2022 00:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236492AbiD3ENg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Apr 2022 00:13:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F53221B3
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 21:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2DCF6091E
        for <linux-cifs@vger.kernel.org>; Sat, 30 Apr 2022 04:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167D7C385AF
        for <linux-cifs@vger.kernel.org>; Sat, 30 Apr 2022 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651291814;
        bh=tmU+UkJgq+PGewUBszunTvDD4JS1GBPKGvAwi0rCQQ0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=sO4vtnXK8H9sl9bvURnIjXYAFnNgGr0ffnDsPtgXi77zdC167lzIao83TDu4iQxo6
         c5KUWtqVdjuTcrp1vITOrH3y32ouVgIhgNKeAbB3TM8g9Nw0V7e4shTjsn+lGo6sTv
         vNFxZYibE3zQ4+aPgtL75/rDq3T5Sy/zMMZHpnsH/LeKzIEPefiivy9S3+fCIG6N/7
         WibyMmhX35jBW+tjNpvKAf+F0lT/HTDnuepMsrV98vYoISxFJd6H/s6HuD8KMvVrY2
         zLBC+k18bVCRVMxIeCrj6MMiOnYd5LRGO3OFzr2BNAolEbC3v1W4tMdlMB1MZr94FB
         AK6/RKRSYP32w==
Received: by mail-wr1-f48.google.com with SMTP id i5so13003306wrc.13
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 21:10:13 -0700 (PDT)
X-Gm-Message-State: AOAM533EPxetagbDQ+0IG4quBWFbaKo1WAyoCjzCN/zAonyPhJ4cWJnW
        eEaH3VrtpsCZKBuwaWK5+4lDHs5in0OJX5N4py4=
X-Google-Smtp-Source: ABdhPJw+00wjS4S5JXD1VPdbnEURAyCFn5n6V/r+dkaXpuVQfvKnBPcqgPaUsQ6lJTKFmZBR7LuCyZlxEMSMrAVNgTU=
X-Received: by 2002:adf:fe84:0:b0:20a:dc0b:4f2d with SMTP id
 l4-20020adffe84000000b0020adc0b4f2dmr1603194wrr.229.1651291812310; Fri, 29
 Apr 2022 21:10:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64e7:0:0:0:0:0 with HTTP; Fri, 29 Apr 2022 21:10:11
 -0700 (PDT)
In-Reply-To: <20220429233029.42741-1-hyc.lee@gmail.com>
References: <20220429233029.42741-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 30 Apr 2022 13:10:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_arubUPepoGUKqhgC3DsbQchV33shoiTgUL6b5nr8H+Q@mail.gmail.com>
Message-ID: <CAKYAXd_arubUPepoGUKqhgC3DsbQchV33shoiTgUL6b5nr8H+Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] ksmbd: smbd: change prototypes of RDMA read/write
 related functions
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-04-30 8:30 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Change the prototypes of RDMA read/write
> operations to accept a pointer and length
> of buffer descriptors.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
