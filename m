Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F72C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F5892087C
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IE828FMX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfCNHJB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 03:09:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39222 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfCNHJA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 03:09:00 -0400
Received: by mail-pf1-f195.google.com with SMTP id i20so3220053pfo.6;
        Thu, 14 Mar 2019 00:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KGpuam99NABsp1VKOu6ZC1oubHxF0HKwvxBpAYD4oq8=;
        b=IE828FMX4r9uAiRp6rgkeNcBES8jOIY1LpYtmhl5CR0AwDgaqsV5/VzRHazhgzbmrO
         0rGqG0gkGCTPEE1Vm7x3+4FNPFmAugljRIscxH4QRxzeRIR80YitC+1QMg2boCThQ1Sl
         4h/AeZduNtgMur8/afCPWTO/CvD/rCMcyjMQF0KKXA+YdmndnJh8WASDwluwFFpFDgll
         4Sdx22N1UZVh3KasHNj2cUkyOp/D3Lu2mdYvxsB7mwOwMZKFbbJRLKV8OH51Spt3G9Kz
         5D+WnHPQPBUfakJgkWNVVgY/Z+uVT9SKXlEcaM90mypxlKxefvtuBcJMKWLKSSGGr2dG
         TNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KGpuam99NABsp1VKOu6ZC1oubHxF0HKwvxBpAYD4oq8=;
        b=RxmxzLBSjznywQuU7sBwV3QEe/cyapNRcAfwAIL+j7UGHGlP/DzcyiN5wDKdwFU5Lz
         cOOZSFlRlJskBkjfzQLrkG2LJMEbPFhM+mVdS/MTgZqt6cakwEs90duJ39jazaPVBiW0
         duhvaiGb7dVGX7ebRP6CFnGvYHoHl2AbjkS972wrbschgbUmbJvKXIcI/iudRwUb2b0N
         lXV1Fnr9R1D1jDI8jwqsE+RSy6ECUwWVBUkTrFMFmiw+Mqt9X/AZU64uZ0+JJ5FILKbg
         zYoNoe8UCPVCfs9UWXoT5j7DgaKgmT1y0NJcO4Xoc6ubBrcwriiuVNbRTFMGvBoKzGeS
         j5fA==
X-Gm-Message-State: APjAAAUsbe4wiJ1tnV4+DOZGt+duMZ94mAPpaNrAfXHyRDGLKmwBayay
        C6C5uQmw3ZsqoF26zsGIXdhes5oW
X-Google-Smtp-Source: APXvYqxZ1OnzbNP62tf1FCtpg1LAn4+AdKYh4CP7Xk7OX81QcMCnVbpvrFdX6yJYv5ijpnGD1E86VA==
X-Received: by 2002:a65:6654:: with SMTP id z20mr42955705pgv.390.1552547339982;
        Thu, 14 Mar 2019 00:08:59 -0700 (PDT)
Received: from localhost ([175.223.23.218])
        by smtp.gmail.com with ESMTPSA id h13sm18707858pfn.114.2019.03.14.00.08.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 00:08:59 -0700 (PDT)
Date:   Thu, 14 Mar 2019 16:08:56 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 1/2] cifs: remove unused status severity defines
Message-ID: <20190314070856.GA1200@jagdpanzerIV>
References: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
 <CAH2r5msYG4H19GK1Fmnqb1dNCcp2qahULc_t4v9qdJ=OOZmGXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msYG4H19GK1Fmnqb1dNCcp2qahULc_t4v9qdJ=OOZmGXg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (03/14/19 01:54), Steve French wrote:
> Since this file (smb2status.h) is intended to track the official
> protocol documentation (albeit smb2status.h probably needs to be
> updated), in this case the protocol document MS-ERREF.  I would prefer
> to keep it closer to MS-ERREF and leave definitions in even if unused
> (if nothing else it helps some of us when debugging to recognize what
> these errors on the wire mean).  There is a real danger that we have
> run into in the past that in removing some protocol definitions
> (flags, etc.) from the code or forgetting to update our headers to
> match newer versions of the protocol specifications, that  with future
> code changes we can forget to handle flags (for example) or misparse
> responses due to not realizing that there are additional flags that
> need to be parsed.

OK, works for me.

	-ss
