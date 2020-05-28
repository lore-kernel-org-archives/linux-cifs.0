Return-Path: <SRS0=wwpQ=7K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79811C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 28 May 2020 20:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F2BA2073B
	for <linux-cifs@archiver.kernel.org>; Thu, 28 May 2020 20:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407296AbgE1UhJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 May 2020 16:37:09 -0400
Received: from vie01a-dmta-pe06-2.mx.upcmail.net ([84.116.36.15]:37179 "EHLO
        vie01a-dmta-pe06-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407237AbgE1UhG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 May 2020 16:37:06 -0400
Received: from [172.31.216.235] (helo=vie01a-pemc-psmtp-pe12.mail.upcmail.net)
        by vie01a-dmta-pe06.mx.upcmail.net with esmtp (Exim 4.92)
        (envelope-from <matthias.leopold@meduniwien.ac.at>)
        id 1jePGy-0007j8-5C
        for linux-cifs@vger.kernel.org; Thu, 28 May 2020 22:37:04 +0200
Received: from [192.168.0.108] ([84.112.49.65])
        by vie01a-pemc-psmtp-pe12.mail.upcmail.net with ESMTP
        id ePGyjhtLN6Jy6ePGyjRs8b; Thu, 28 May 2020 22:37:04 +0200
X-Env-Mailfrom: matthias.leopold@meduniwien.ac.at
X-Env-Rcptto: linux-cifs@vger.kernel.org
X-SourceIP: 84.112.49.65
X-CNFS-Analysis: v=2.3 cv=GKl27dFK c=1 sm=1 tr=0
 a=o7KpDIDOooC/ihDeWO0+Dg==:117 a=o7KpDIDOooC/ihDeWO0+Dg==:17
 a=IkcTkHD0fZMA:10 a=x7bEGLp0ZPQA:10 a=5v8ooLmK-mOn7peKadwA:9
 a=QEXdDO2ut3YA:10 a=pHzHmUro8NiASowvMSCR:22 a=nt3jZW36AmriUCFCBwmW:22
To:     linux-cifs@vger.kernel.org
From:   Matthias Leopold <matthias.leopold@meduniwien.ac.at>
Subject: almost no CIFS stats?
Message-ID: <c9a53d2c-98ab-84a3-b395-aff537b9c882@meduniwien.ac.at>
Date:   Thu, 28 May 2020 22:37:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEwf2P3+B0z82VI8WNq86Cxp4ych1wL2n6K91wYjKwY9kPDTZCXSFVis4fhUjzXzsfSSNZF8hRcmVem3T/wkm9pl3rqtXR672BjJ3W29ymDErZc1R+IW
 ZF7xmSn5EShSC0KEcUHM2MfCvmXpKyRJba8fY1c30fjoaCyPGi+XsuOtr1efVG0AEwi7lMlUG1g4+I/egfn8XkXYQgA29I7VRlY=
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I'm trying to debug the performance of rsync reading from a Windows 2012 
R2 share mounted readonly in CentOS 7. I tried to use cifsiostat, which 
doesn't print any stats. I looked into /proc/fs/cifs/Stats and saw that 
it contains mostly "0" for counters (I would expect to see some numbers 
for eg "Reads"). What am I doing wrong?

options from /proc/mounts are
ro,relatime,vers=3.0,cache=strict,username=foo,domain=xxx,uid=1706,forceuid,gid=1676,forcegid,addr=10.110.81.122,file_mode=0660,dir_mode=0770,soft,nounix,serverino,mapposix,rsize=61440,wsize=1048576,echo_interval=60,actimeo=1

thx
Matthias
