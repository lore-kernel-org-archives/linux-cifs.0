Return-Path: <SRS0=jMYF=Q2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75912C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Feb 2019 06:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44AE7217D7
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Feb 2019 06:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbfBSGQb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Feb 2019 01:16:31 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:53868 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfBSGQb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Feb 2019 01:16:31 -0500
X-Greylist: delayed 1473 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2019 01:16:31 EST
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id x1J5ptcT022313
        for <linux-cifs@vger.kernel.org>; Mon, 18 Feb 2019 21:51:58 -0800
Message-ID: <5C6B997B.8050203@tlinx.org>
Date:   Mon, 18 Feb 2019 21:51:55 -0800
From:   L A Walsh <cifs@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: regressions & flakiness make for ugly symlink links
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


In my Windows root directory I have several links.  This is how
they look on the Windows machine's "root".  Several months ago I
sent an email to this list complimenting you on how they looked.
(without user+group)

> ll |grep -- '->'
lrwxrwxrwx   1           17 Jun 13  2016 Documents -> //Bliss/Documents/
lrwxrwxrwx   1            6 Jul 13  2009 Documents and Settings -> /Users/
lrwxrwxrwx   1           16 Jun  5  2015 FolderChanger -> /m/FolderChanger/
lrwxrwxrwx   1            5 May 13  2017 Home -> Users/
lrwxrwxrwx   1           20 Nov  6  2014 Prog -> /Program Files (x86)/
lrwxrwxrwx   1           13 Apr 21  2013 Prog64 -> Program Files/
lrwxrwxrwx   1           12 Aug  9  2015 ProgD -> /ProgramData/
lrwxrwxrwx   1            2 Apr 17  2017 Share -> /s/
lrwxrwxrwx   1           22 Aug 22 16:08 Symbols -> //Bliss/Share/Symbols//
lrwxrwxrwx   1            7 Mar  1  2018 WINNT -> Windows/
lrwxrwxrwx   1            3 May 13  2017 lib64 -> lib/
lrwxrwxrwx   1            3 Jan 12  2014 temp -> tmp/

Now, I'm getting flakiresults -- with them not resolving 1 time,
then resolving,  then not again...etc.  By flakey I mean
output like random can't access messages, followed by question
marks in all fields of links.

# ll|more
ls: cannot access 'D': Operation not supported
ls: cannot access 'Documents': Operation not supported
ls: cannot access 'FolderChanger': Operation not supported
ls: cannot access 'Home': Operation not supported
ls: cannot access 'lib64': Operation not supported
ls: cannot access 'M': Operation not supported
ls: cannot access 'P': Operation not supported
ls: cannot access 'pagefile.sys': Device or resource busy
ls: cannot access 'Prog64': Operation not supported
ls: cannot access 'Share': Operation not supported
ls: cannot access 'temp': Operation not supported
ls: cannot access 'WINNT': Operation not supported
d????????? ?       ?            ? D/
d????????? ?       ?            ? Documents/
d????????? ?       ?            ? FolderChanger/
d????????? ?       ?            ? Home/
d????????? ?       ?            ? M/
d????????? ?       ?            ? P/
d????????? ?       ?            ? Prog64/
d????????? ?       ?            ? Share/
d????????? ?       ?            ? WINNT/
d????????? ?       ?            ? lib64/
d????????? ?       ?            ? temp/

Depending on timing, Sometimes I will get most or all of
them appearing the same as they would on windows.

If I can't resolve them more quickly, is there a know
or two to increase cache size and item lifetime?

Thanks



