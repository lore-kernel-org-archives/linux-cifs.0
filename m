Return-Path: <SRS0=yfaw=UN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.1 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9155EC31E4B
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 13:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FFBE21473
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 13:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfFNNW4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:22:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:48204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727686AbfFNNW4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 14 Jun 2019 09:22:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4A25AF7B;
        Fri, 14 Jun 2019 13:22:54 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Ben Raven <benr@datapad.co>,
        "linux-cifs\@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: uninterruptible I/O wait on CIFS mounts on Amazon Linux 2 running latest kernel
In-Reply-To: <MN2PR14MB3150D6916DA2C3E399AD57F2A6EE0@MN2PR14MB3150.namprd14.prod.outlook.com>
References: <MN2PR14MB3150D6916DA2C3E399AD57F2A6EE0@MN2PR14MB3150.namprd14.prod.outlook.com>
Date:   Fri, 14 Jun 2019 15:22:53 +0200
Message-ID: <87zhmk47yq.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ben,

Any chance we can get a verbose kernel log and network trace?
See https://wiki.samba.org/index.php/Bug_Reporting#cifs.ko
for instructions.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
