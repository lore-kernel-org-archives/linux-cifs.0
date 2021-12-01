Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913F5C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Dec 2021 16:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351143AbhLARA7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Dec 2021 12:00:59 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:51830 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbhLARAw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Dec 2021 12:00:52 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E3672212C0;
        Wed,  1 Dec 2021 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638377850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ymluOGecTiavMSeVQ9ERm6KR1+C6xRixSKMhXGdT8dk=;
        b=z+UbGj7R5+hRrBaXAlCZmrJiDiOHmNRTDLV9OSZUzLGis4u7oI/q30o4+JZSPWIoA+cWUN
        OlKuqucBFEyaemEMfnaP6R4R51e5/Ue74kAz7ti4aJVx8v0DxfzdQ/mtKn93RXYr6/0iBg
        IPzuN+AUwEkmGzZqeD7jxFofeKjs74g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638377850;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ymluOGecTiavMSeVQ9ERm6KR1+C6xRixSKMhXGdT8dk=;
        b=uBeiTdYn1hWMR60DRJKllhJNbp7E5eQ4duIZXLg5Y+6JUP0o+haJb2XoGA2xd8FBBDsX2J
        kqMoxT1S4Wz6+UBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 63D8613D90;
        Wed,  1 Dec 2021 16:57:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uRsuC3qpp2GHKQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 01 Dec 2021 16:57:30 +0000
Date:   Wed, 1 Dec 2021 13:57:28 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
Message-ID: <20211201165728.r3jvaan2hw5icfvp@cyberdelia>
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia>
 <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
 <CA+_sParqF63m24NjL4o42agyk3mU_Cq1A-kpKFBpZaGmhdWYqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+_sParqF63m24NjL4o42agyk3mU_Cq1A-kpKFBpZaGmhdWYqg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 12/01, Sergey Senozhatsky wrote:
>On Wed, Dec 1, 2021 at 11:17 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> > I've been working on the unification of all ksmbd-tools programs into a
>> > single 'ksmbdctl' binary, and I would like to invite everyone to test
>> > and/or provide me feedback on the implementation.
>
>Why?

Hi Sergey. The reasoning was in the commit message included in the
email, but I'll quote it here and elaborate:

> ...
> The intention is to make it more like other modern tools (e.g. git,
> nvme, virsh, etc) which have more clear user interface, readable
> commands, and also makes it easier to script.
> 
> Example commands:
>   # ksmbdctl share add myshare -o "guest ok=yes, writable=yes, path=/mnt/data"
>   # ksmbdctl user add myuser
>   # ksmbdctl user add -i $HOME/mysmb.conf anotheruser
>   # ksmbdctl daemon start
> 
> Besides adding a new "share list" command, any previously working
> functionality shouldn't be affected.

- clearer user interface: having a single binary looks much clearer than
   having several separate programs when, e.g. the user is looking which
   program does what.

- more readable commands: continuing from topic above, the situation is
   improved especially when you see that, e.g., the ksmbd.addshare program
   also updates and deletes shares. With this unification, it is way more
   intuitive to use:

---- snip ----
% ./ksmbdctl share
Usage: ksmbdctl share <subcommand> <args> [options]
Share management.

List of available subcommands:
   add               Add a share
   delete            Delete a share
   update            Update a share
   list              List the names of all shares available
---- snip ----

- easier to script: having a defined structure for the commands makes it
   easier for users to automate ksmbd deployments. This is more of a
   consequence of the topics above, but should count as an advantage IMO.

As I also said in the commit message, the idea is to have an abstract
implementation so we can add/manage/remove commands without having to
rely on each command specifics. Of course, this shouldn't have much/any
effect for users, but will have great benefit for developers.

And, again, I ask you to consider the applications I used as inspiration
for such change, such as git, nvme-cli, virsh, which are tools that many
of us use every day and, e.g. "git help -a | grep "^   " | wc -l" says
there are about 144 git commands, but I sure don't have 144 git binaries
spread over my system.

I hope to have made myself clearer now, but please let me know
otherwise.


Cheers,

Enzo
