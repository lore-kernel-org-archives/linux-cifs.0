Return-Path: <SRS0=Xphx=UF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBCDC28CC5
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jun 2019 00:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4AF620866
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jun 2019 00:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFFAlv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jun 2019 20:41:51 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:58263 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfFFAlv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jun 2019 20:41:51 -0400
Received: from [192.168.1.110] ([77.2.1.21]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M7auL-1hTULY2kpR-0084pb; Thu, 06 Jun 2019 02:41:41 +0200
Subject: Re: [PATCH] fs: cifs: drop unneeded likely() call around IS_ERR()
To:     Steve French <smfrench@gmail.com>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
References: <1559769249-22011-1-git-send-email-info@metux.net>
 <CAH2r5mvzEPj2NXMJW5fOfq0+bbh-pZFnJnL1jEnyFYDt1HJi1A@mail.gmail.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Organization: metux IT consult
Message-ID: <d76ceded-c2fc-beae-d60d-2b4a98623bf0@metux.net>
Date:   Thu, 6 Jun 2019 00:41:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvzEPj2NXMJW5fOfq0+bbh-pZFnJnL1jEnyFYDt1HJi1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:9gPXvsujPwWsw652B9AYMdsfz8vfg0YZSoLHXf/ypYnkEMqbhAb
 hzmgNOt3mulkvoYXmU/887n8jXZe5/9bHwXIS1rPcuI1MTVwdFzZWtHdvUoXu5lHt7yyWOn
 n0ABv9uao1hD6HnigyderpzrjEJZOIx97Isx/4T+KbxIq/XBZvTp8JvxaVpnw289fLx1pZ8
 aVc4uChgLugRybPClY0cg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ndy1MvyuMos=:12CNblfygcej00zMQsPu7k
 UgI5zW0YCLR0hCLyFpsSHq90/J/bHUHTJrYR+1KM6lKp/QMmVrfCXWIvw6GSTRgvOnI4TLcYQ
 ARi4P7qx6ixlUqKos6AMCR32oIK+HWyfVkBIVt/1yg7qm7iesT2F0nh5qjXAUPHGdWrU3SZ++
 ix8OOWCHyQ+lZDadBEGVDFmDF8H5ODatpAsAtSXUfVNE7jFDJXLxK5FOgE/duMULUnk+nCkQj
 YIRlxgBHAfSfFpnuA5vJFK7s7PD5oyh3pyHnOibwkJgM0j/NBsOfPTDYRRhA/eq6K49PoL9fI
 QT2dgnpi+Ipdh5YYY7gf0vKXpoDoqBBIF0LXUhoWs9hT2TVuCozXFJmOyIxv5bHNDzPEqEKKb
 l4Eau7ZdCKljrcJ5630SQcRM3RSt5rs1ZLLmNnAcud2LTZogC8L5moBP6C0a+Q0vBgwTxVufA
 1oD08gJzCAvgW0yhF/j/HWn2IulnsYle77Kt3NEyvEu7YRi72B5rTjktqNTe9DimGPo21lJzr
 aYSFuyxyTZzu5/HpgNaP+IyWKNjVeDS0z1qZqcmv/WP11Dtg2I45lzYQ5q0o1R/SpLmcLpm7E
 N9EiByxq0bpGaBupGeOmdB+zfvWSLfXjtbOx3DMcm7i9LqK57K99811wdkriSsHl1edux+O1D
 21EMrwAU546USpOI6Ai9dHlTjQKwBNIh5PpONH03WAZlDMZFTdr1x77rXdacIz3+C7+1kszQn
 7OgAFo0/qkv9Gt52SUJ1E/1tDdwEfDZxOXBuYasxDSAuOPs98Lkve5FHibk=
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 05.06.19 21:52, Steve French wrote:
> This duplicates a patch submitted earlier by Kefeng Wang
> <wangkefeng.wang@huawei.com> which I plan to merge later today into
> cifs-2.6.git for-next

Great :)
Just ignore my patch.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
