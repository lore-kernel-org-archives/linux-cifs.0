Return-Path: <SRS0=po33=YY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F76CA9EC3
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 09:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67DD20862
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 09:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfJaJUc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Oct 2019 05:20:32 -0400
Received: from rigel.uberspace.de ([95.143.172.238]:49982 "EHLO
        rigel.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfJaJUc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Oct 2019 05:20:32 -0400
Received: (qmail 9749 invoked from network); 31 Oct 2019 09:20:30 -0000
Received: from localhost (HELO webmail.rigel.uberspace.de) (127.0.0.1)
  by ::1 with SMTP; 31 Oct 2019 09:20:30 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 31 Oct 2019 10:20:28 +0100
From:   Moritz M <mailinglist@moritzmueller.ee>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
In-Reply-To: <CAKywueSWxDA5veCWjf+vGM96TSKrJbiddt93dv=arXyizJCbmw@mail.gmail.com>
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
 <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee>
 <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
 <CAKywueTOjoP-Jh7WWCi5XJhfzgK+KZs3kvHKuVG_HW0fnYYY7A@mail.gmail.com>
 <CAKywueQUuwRK7hbbJhdquVVPre2+8GBCvnrG76L-KodoMm9m6g@mail.gmail.com>
 <b7b7a790feac88d59fe00c9ca2f5960d@moritzmueller.ee>
 <CAKywueQ7g9VYe=d7WU4AzL2Hv+pPznUgQBD7-RVi0ygBkhtGRw@mail.gmail.com>
 <bdf21b8770373c9ea4c37c27a12344d8@moritzmueller.ee>
 <CAKywueQ8woeupNRqspAuOqL8rG1hNpWN_hwLCjFUpkk4mXeCvQ@mail.gmail.com>
 <6492326ef9d8d1a9401fac243160646f@moritzmueller.ee>
 <CAKywueSWxDA5veCWjf+vGM96TSKrJbiddt93dv=arXyizJCbmw@mail.gmail.com>
Message-ID: <6a49aa3e2cf17975efc5259f94c01ce7@moritzmueller.ee>
X-Sender: mailinglist@moritzmueller.ee
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Pavel,

Am 2019-10-30 22:51, schrieb Pavel Shilovsky:
> I think there is a difference in your setup between v5.2.21 and v5.3.7
> kernels. I found the issue in oplock break processing that can happen
> if you have several shares from the same server mounted on the client.

I think you are right. Usually I mount multiple shares from one server.
It could had happened that I tested it with just one share mounted when 
using the
v5.2 Kernel.


> Could you test the patch to see if it works for your environment?

I did and it worked ;)

Thanks.
