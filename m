Return-Path: <SRS0=w1sk=7L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545C8C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 29 May 2020 08:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A27320897
	for <linux-cifs@archiver.kernel.org>; Fri, 29 May 2020 08:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgE2ISR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 May 2020 04:18:17 -0400
Received: from smtpi.meduniwien.ac.at ([149.148.51.14]:47606 "EHLO
        smtpi.meduniwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgE2ISR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 May 2020 04:18:17 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2020 04:18:16 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtpi.meduniwien.ac.at (Postfix) with ESMTP id 0EEC76002F;
        Fri, 29 May 2020 10:08:43 +0200 (CEST)
X-Virus-Scanned: amavisd-new at meduniwien.ac.at
Received: from smtpi.meduniwien.ac.at ([127.0.0.1])
        by localhost (mailsip.meduniwien.ac.at [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zoUgJCvHBDAY; Fri, 29 May 2020 10:08:42 +0200 (CEST)
Received: from [149.148.52.63] (itsc063.cc.meduniwien.ac.at [149.148.52.63])
        by smtpi.meduniwien.ac.at (Postfix) with ESMTPS id 057F760081;
        Fri, 29 May 2020 10:08:41 +0200 (CEST)
Subject: Re: almost no CIFS stats?
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <c9a53d2c-98ab-84a3-b395-aff537b9c882@meduniwien.ac.at>
 <CAH2r5msOOQ3BY+4L4MNDEJU1Lrer1gt0ZwdjE2K0zdurabthsQ@mail.gmail.com>
From:   Matthias Leopold <matthias.leopold@meduniwien.ac.at>
Message-ID: <ad562231-c263-aebf-e1bb-a055c3aea211@meduniwien.ac.at>
Date:   Fri, 29 May 2020 10:08:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5msOOQ3BY+4L4MNDEJU1Lrer1gt0ZwdjE2K0zdurabthsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-AT
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

CentOS 7 has kernel 3.10 (modified by Red Hat)

Am 28.05.20 um 23:31 schrieb Steve French:
> Stats should show counters for most rows.   See example below:
> 
> # cat /proc/fs/cifs/Stats
> Resources in use
> CIFS Session: 1
> Share (unique mount targets): 2
> SMB Request/Response Buffer: 1 Pool size: 5
> SMB Small Req/Resp Buffer: 1 Pool size: 30
> Operations (MIDs): 0
> 
> 0 session 0 share reconnects
> Total vfs operations: 36 maximum at one time: 2
> 
> Max requests in flight: 3
> 1) \\localhost\test
> SMBs: 67
> Bytes read: 90177536  Bytes written: 2
> Open files: 0 total (local), 0 open on server
> TreeConnects: 1 total 0 failed
> TreeDisconnects: 0 total 0 failed
> Creates: 12 total 0 failed
> Closes: 13 total 1 failed
> Flushes: 1 total 0 failed
> Reads: 22 total 0 failed
> Writes: 1 total 0 failed
> Locks: 0 total 0 failed
> IOCTLs: 1 total 1 failed
> QueryDirectories: 2 total 0 failed
> ChangeNotifies: 0 total 0 failed
> QueryInfos: 12 total 0 failed
> SetInfos: 2 total 0 failed
> OplockBreaks: 0 sent 0 failed
> 
> 
> Are you running an old kernel (pre-5.0 e.g.)?
> 
> On Thu, May 28, 2020 at 3:39 PM Matthias Leopold
> <matthias.leopold@meduniwien.ac.at> wrote:
>>
>> Hi,
>>
>> I'm trying to debug the performance of rsync reading from a Windows 2012
>> R2 share mounted readonly in CentOS 7. I tried to use cifsiostat, which
>> doesn't print any stats. I looked into /proc/fs/cifs/Stats and saw that
>> it contains mostly "0" for counters (I would expect to see some numbers
>> for eg "Reads"). What am I doing wrong?
>>
>> options from /proc/mounts are
>> ro,relatime,vers=3.0,cache=strict,username=foo,domain=xxx,uid=1706,forceuid,gid=1676,forcegid,addr=10.110.81.122,file_mode=0660,dir_mode=0770,soft,nounix,serverino,mapposix,rsize=61440,wsize=1048576,echo_interval=60,actimeo=1
>>
>> thx
>> Matthias
> 
> 
> 

-- 
Matthias Leopold
IT Systems & Communications
Medizinische Universität Wien
Spitalgasse 23 / BT 88 /Ebene 00
A-1090 Wien
Tel: +43 1 40160-21241
Fax: +43 1 40160-921200
