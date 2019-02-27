Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA71C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 08:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C846A218D0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 08:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfB0IzY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 03:55:24 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:52750 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfB0IzY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 03:55:24 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id x1R8tJlp040871;
        Wed, 27 Feb 2019 00:55:21 -0800
Message-ID: <5C76504F.1020608@tlinx.org>
Date:   Wed, 27 Feb 2019 00:54:39 -0800
From:   L A Walsh <cifs@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To:     Steve French <smfrench@gmail.com>
CC:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: upcalls seem to have problems with symlinks, junctions et al.
References: <5C6B997B.8050203@tlinx.org> <CAKywueSgMhDzKOx04_C8X3HEhn_0w6cwM43c3=FXdjCsZ3x9UA@mail.gmail.com> <5C6DAEFC.2060909@tlinx.org> <5C6F3167.7090402@tlinx.org> <CAH2r5mskDv3ZB8gUpRDN6iPzaZaGeXuN-uHikGvj+5K4epN2Xg@mail.gmail.com>
In-Reply-To: <CAH2r5mskDv3ZB8gUpRDN6iPzaZaGeXuN-uHikGvj+5K4epN2Xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/21/2019 8:30 PM, Steve French wrote:
> I have wanted to change this code and improve it for a while - one
> thing which is tricky is showing mode bits when no permissions to read
> permissions though, and we also need to clean up and simplify some of
> this code.   Let's follow up on this in a few days, if you are
> flexible and can install some test patches
>   
FWIW, it seems to be symlinks that are unreadable when perms on
the mount are set to 'multi-user'.
Using the following two examples from my system,

in cmd.exe they look like:
04/17/2017  08:45 AM    <SYMLINKD>     Share [S:\]
08/22/2018  03:08 PM    <JUNCTION>     Symbols [\\Bliss\Share\Symbols\]*
*

in Cygwin, they look like: (domain+user+groups are shortened to fit)
       (domain name, B (Bliss), username 'l' and group 'lg')
lrwxrwxrwx   1 B\l  B\lg  2 Apr 17  2017 Share -> /s
lrwxrwxrwx   1 B\l  B\lg 22 Aug 22  2018 Symbols -> //Bliss/Share/Symbols/

So both are links owned by me, one pointing to a locally mounted drive
and the other a remotely mounted Share on the Domain server.

On linux with single user mounting, I see:

l--------- 1 law Administrators            0 Apr 17  2017 Share -> /??/S://
drwxr-xr-x 2 law Administrators            0 Dec 17 19:14 Symbols/

Amusingly, I can read directory Symbols which results in a read
from the same server I'm doing the 'ls' from -- sorta the long way
around.

Oddly, I can't read the permissions on the symlink even though they
are usable (created directory named '??' and pointers and directories
underneath it as appropriate).

If I mount the cifs share "multiuser", I lose the capacity to see or
follow the symlinks as well as getting "Operation not supported" errors,
but the junctions still work fine:

ls: cannot access 'Share': Operation not supported
d????????? ? ?    ?                    ?            ? Share/
drwxrwxr-x 2 root Domain Admins        0 Dec 17 19:14 Symbols/

1) the Operation not supported message is dubious, since
I can read the link in single-user mount, even though the link
shows no access.

2) If the permissions on the links really are unreadable, the
'l-----' format is certainly easier on the eyes than
'd?????'.


I'd like to see the multi-user mount give at least as much information
as the single-user mount.  That would make sense, wouldn't it?
Can your patch/cleanup at least solve at problem?










**
