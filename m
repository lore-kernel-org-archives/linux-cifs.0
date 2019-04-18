Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD65BC10F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 17:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D588206B6
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 17:23:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samba.org header.i=@samba.org header.b="CVUuV0lQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388579AbfDRRX6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 13:23:58 -0400
Received: from hr2.samba.org ([144.76.82.148]:49210 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733067AbfDRRX6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 18 Apr 2019 13:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Cc:To:From:Date;
        bh=sRKklcxK2J6hIXO0tIVmMrzoZtImQy7WVT7R2P/oHA8=; b=CVUuV0lQCIl3aSZ4+5cBlRyuds
        a0g3wjD5UTbRqSWoR2IHsbeMlo9GaNvSCRE5gYQ2Dytbf9kCA9QaKK++Z7FKOHU7FbdC8iHYv2KvV
        aWHb8taIa4P8dFfZY7I02wq9c8VGDqbyZX2B75HUxqtoGPzLuQdo3qB/WxNQSQXTzNQY=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1hHAlQ-0008OB-0c; Thu, 18 Apr 2019 17:23:56 +0000
Date:   Thu, 18 Apr 2019 10:23:53 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH][SMB3] Add missing defines for new negotiate contexts
Message-ID: <20190418172353.GB236057@jra4>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mvEYMEUjz8BDRUumn0yGq__VntNKx-8AzWcZgCDOJQv-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mvEYMEUjz8BDRUumn0yGq__VntNKx-8AzWcZgCDOJQv-Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Apr 18, 2019 at 11:06:57AM -0500, Steve French via samba-technical wrote:
> See updated MS-SMB2 - two new negotiate contexts

Link to latest update ? Is this a draft update
or a full new version ?
