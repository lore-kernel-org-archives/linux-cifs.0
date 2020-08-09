Return-Path: <SRS0=fjk5=BT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1D8C433E1
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Aug 2020 17:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86FE206C0
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Aug 2020 17:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgHIRPu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Aug 2020 13:15:50 -0400
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:50462 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726210AbgHIRPu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Aug 2020 13:15:50 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 88D8B18009FF0
        for <linux-cifs@vger.kernel.org>; Sun,  9 Aug 2020 17:07:10 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 5E97B182CED2A;
        Sun,  9 Aug 2020 17:07:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: crate03_55148a926fd3
X-Filterd-Recvd-Size: 1638
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Sun,  9 Aug 2020 17:07:08 +0000 (UTC)
Message-ID: <5788fcd4bc9d055fa40302ecb6728265c7618772.camel@perches.com>
Subject: Re: [PATCH] cifs: Convert to use the fallthrough macro
From:   Joe Perches <joe@perches.com>
To:     Steve French <smfrench@gmail.com>, linmiaohe <linmiaohe@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Sun, 09 Aug 2020 10:07:07 -0700
In-Reply-To: <CAH2r5mvHLXtCAam9Wcw6PJUGg3bY8PvjYG8ijFh0km-CKNEUnA@mail.gmail.com>
References: <1596875797-22710-1-git-send-email-linmiaohe@huawei.com>
         <CAH2r5mvHLXtCAam9Wcw6PJUGg3bY8PvjYG8ijFh0km-CKNEUnA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, 2020-08-09 at 11:46 -0500, Steve French wrote:
> Is this conversion from "/* Fallthrough */"   to the preferred (?)
> "fallthrough;" documented anywhere?

Documentation/process/deprecated.rst

As there have been a long list of flaws `due to missing "break" statements
<https://cwe.mitre.org/data/definitions/484.html>`_, we no longer allow
implicit fall-through. In order to identify intentional fall-through
cases, we have adopted a pseudo-keyword macro "fallthrough" which
expands to gcc's extension `__attribute__((__fallthrough__))
<https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html>`_.



