Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2070C432C1
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 19:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E8C0214DA
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 19:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394495AbfIXTdD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Sep 2019 15:33:03 -0400
Received: from rigel.uberspace.de ([95.143.172.238]:55000 "EHLO
        rigel.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388207AbfIXTdD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Sep 2019 15:33:03 -0400
Received: (qmail 25545 invoked from network); 24 Sep 2019 19:33:00 -0000
Received: from localhost (HELO webmail.rigel.uberspace.de) (127.0.0.1)
  by ::1 with SMTP; 24 Sep 2019 19:33:00 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 24 Sep 2019 21:33:00 +0200
From:   Moritz M <mailinglist@moritzmueller.ee>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
In-Reply-To: <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
 <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee>
 <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
Message-ID: <00568300f4dcc0bc9295bc4adf5791c9@moritzmueller.ee>
X-Sender: mailinglist@moritzmueller.ee
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



Am 2019-09-24 20:11, schrieb ronnie sahlberg:
> That pcap shows a problem with the lease break.
> 
> I just tried your python reproducer with the current cifs upstream
> kernel and the problem does not manifest.
> There were oplock related fixes in the cifs.ko module a while ago that
> might have fixed the problem you see.
> 
> Which kernel version are you using ?

5.1.21-1-MANJARO with mount.cifs version: 6.8

Samba on the server side is version 4.4.16

> 
> 
> On Tue, Sep 24, 2019 at 10:53 AM Moritz M 
> <mailinglist@moritzmueller.ee> wrote:
>> 
>> Hi Pavel,
>> >
>> >
>> > Could you please enable debugging logging
>> > (https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging),
>> > reproduce the problem and send us the kernel logs? A network capture
>> > of a repro could also be useful
>> > (https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Captures).
>> 
>> see the debug output and the pcap file attached.
>> 
>> Best regards
>> Moritz
>> 
