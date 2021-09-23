Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28AAC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 21:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B418061211
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 21:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhIWVCO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 17:02:14 -0400
Received: from wolff.to ([98.103.208.27]:33622 "HELO wolff.to"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S229609AbhIWVCN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 17:02:13 -0400
Received: (qmail 12263 invoked by uid 500); 23 Sep 2021 20:48:35 -0000
Date:   Thu, 23 Sep 2021 15:48:35 -0500
From:   Bruno Wolff III <bruno@wolff.to>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: setcifsacl: Shouldn't 0x0 be a valid mask?
Message-ID: <20210923204835.GC5478@wolff.to>
References: <20210923155510.GA2171@wolff.to>
 <CAH2r5msCBzGM3Rc1JofLpCQEbkfRbJ5kgY+eSJrMX5Zx3xr6hw@mail.gmail.com>
 <20210923193805.GA5478@wolff.to>
 <CAH2r5msf525KHBUTgiTMFwzm=Wk_0vGeHuWFia1ijBETSvG4Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msf525KHBUTgiTMFwzm=Wk_0vGeHuWFia1ijBETSvG4Ew@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I changed a file in a place I could mount remotely and getcifsacl is 
showing a permision mask of 0. So it does look like it is possible 
to get them in NTFS.
# getcifsacl test-bruno
# filename: test-bruno
REVISION:0x1
CONTROL:0x8404
OWNER:S-1-5-21-1229272821-630328440-682003330-2408
GROUP:S-1-5-21-1229272821-630328440-682003330-513
DACL:
ACL:S-1-3-4:ALLOWED/0x0/
ACL:S-1-5-18:ALLOWED/I/FULL
ACL:S-1-5-32-544:ALLOWED/I/FULL
No SACL


