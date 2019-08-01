Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8427DC19759
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 14:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 615E220665
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 14:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbfHAOpc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:45:32 -0400
Received: from whm03.asteroidpc.com ([204.191.218.21]:44836 "EHLO
        nathanshearer.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfHAOpb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Aug 2019 10:45:31 -0400
Received: from [204.191.243.35] (port=41538 helo=[172.16.1.42])
        by whm03.asteroidpc.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <mail@nathanshearer.ca>)
        id 1htCKe-0000BA-Tf; Thu, 01 Aug 2019 08:45:28 -0600
Subject: Re: Forced to authenticate with "pre-Windows 2000" logon names
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <e33b9809-b3e2-6ace-6213-f63d8792e6ca@nathanshearer.ca>
 <CAH2r5msB+OY42b8yqERpzsjeJpnKYpMHeQdu3RPaGPbJBJs-1w@mail.gmail.com>
From:   Nathan Shearer <mail@nathanshearer.ca>
Message-ID: <edb2974c-e985-6f76-b711-801812bf8072@nathanshearer.ca>
Date:   Thu, 1 Aug 2019 08:45:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAH2r5msB+OY42b8yqERpzsjeJpnKYpMHeQdu3RPaGPbJBJs-1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - whm03.asteroidpc.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - nathanshearer.ca
X-Get-Message-Sender-Via: whm03.asteroidpc.com: authenticated_id: mail@nathanshearer.ca
X-Authenticated-Sender: whm03.asteroidpc.com: mail@nathanshearer.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve, thanks for looking into this.

The file server(s) I tried are members of a domain. One is a plain file 
server only, and the other is a domain controller, both are updated 
Windows Server 2012 installs. My linux system is not a member of the 
domain, and is an updated Gentoo install:

# cat /proc/fs/cifs/DebugData | grep Version
CIFS Version 2.20

# cat /proc/version
Linux version 5.2.2 (root@varws03) (gcc version 8.3.0 (Gentoo 8.3.0-r1 
p1.1)) #1 SMP PREEMPT Thu Jul 25 09:08:17 MDT 2019

The actual command I am using right now to mount the share only works 
with the pre-windows 2000 logon name (18 characters):

# mount -v -t cifs -o 
username=xx-xxxx-xxxxxxxxxx,password=xxxxxxxxxxxxxxxxxxxxxxxx,domain=xxxxxxxx-xxx,vers=3.0 
'//192.168.100.10/Test Share' /mnt/temp0

If I use the regular logon name (23 characters) I get these errors:

# mount -v -t cifs -o 
username=xx-xxxx-xxxxxxxxxxyyyyy,password=xxxxxxxxxxxxxxxxxxxxxxxx,domain=xxxxxxxx-xxx,vers=3.0 
'//192.168.100.10/Test Share' /mnt/temp0
mount.cifs kernel mount options: 
ip=192.168.100.10,unc=\\192.168.100.10\Test 
Share,vers=3.0,user=xx-xxxx-xxxxxxxxxxyyyyy,domain=xxxxxxxx-xxx,pass=********
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

/var/log/messeges
Aug  1 08:43:06 testclient01 kernel: CIFS: Attempting to mount 
//192.168.100.10/Test Share
Aug  1 08:43:07 testclient01 kernel: Status code returned 0xc000006d 
STATUS_LOGON_FAILURE
Aug  1 08:43:07 testclient01 kernel: CIFS VFS: Send error in SessSetup = -13
Aug  1 08:43:07 testclient01 kernel: CIFS VFS: cifs_mount failed 
w/return code = -13

Is the domain considered part of the 32 character username character 
limit? My domain is 12 characters, full logon name with the domain would 
be 35 characters (including the \ separator), while the pre-windows 2000 
name would be 31 characters with the \ separator.

On 8/1/19 1:50 AM, Steve French wrote:
> I tried some experiments today with longer usernames (e.g. 32
> characters, which is the maximum allowed on the Linux distros I
> tried).   mounting with 32 character usernames worked fine (at least
> to Samba).  I wouldn't expect anything different to Windows.
>
> I don't remember any recent change to add this support so as long as
> you are running a kernel from the last three or four years, hard to
> guess what is the issue (if you have evidence like a wireshark trace
> or debugging information showing the username getting
> remapped/corrupted when passed down that might be helpful)
>
> Can you see the module version (modinfo cifs or "cat
> /proc/fs/cifs/DebugData | grep Version") and the kernel version
> ("uname -a")?
>
>
> On Wed, Jul 31, 2019 at 2:39 PM Nathan Shearer <mail@nathanshearer.ca> wrote:
>> I spent the last two days trying to mount a windows share, and it turns
>> out it was not a problem with:
>>
>>    * share permissions
>>    * filesystem permissions
>>    * incorrect password
>>    * firewalls
>>    * antivirus software
>>    * smb version
>>
>> But was in fact an issue with the username. The username I had was 23
>> characters, which is longer than the "pre-Windows 2000" logon name which
>> is what cifs was using, even with smb vers=3.0. The error was always
>> status code 0xc000006d STATUS_LOGON_FAILURE which this time was actually
>> an authentication problem since the client was using the wrong username.
>>
>> Is there any plan to support windows usernames in samba/cifs that are
>> *post* windows 2000 era?
>>
>> # mount.cifs -V
>> mount.cifs version: 6.9
>>
>
