Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B11AC00140
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jul 2022 02:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiG2Crg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jul 2022 22:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiG2Crf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jul 2022 22:47:35 -0400
Received: from smtp.polymtl.ca (smtp.polymtl.ca [132.207.4.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E77561723
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 19:47:34 -0700 (PDT)
Received: from comms3.kousu.ca (comms3.kousu.ca [46.23.90.174])
        by smtp.polymtl.ca (8.14.7/8.14.7) with ESMTP id 26T2lPTW021275
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 22:47:30 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.polymtl.ca 26T2lPTW021275
Received: from comms.kousu.ca (localhost [127.0.0.1])
        by comms3.kousu.ca (OpenSMTPD) with ESMTP id e29833f1
        for <linux-cifs@vger.kernel.org>;
        Fri, 29 Jul 2022 04:47:24 +0200 (CEST)
MIME-Version: 1.0
Date:   Fri, 29 Jul 2022 02:47:24 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.16.0
From:   "Nick Guenther" <nick.guenther@polymtl.ca>
Message-ID: <0371d16e831be9cd9595c443d142e5fc@polymtl.ca>
Subject: Re: pam_cifscreds, tmux and session keyrings
To:     linux-cifs@vger.kernel.org
In-Reply-To: <705265ea-37a3-6029-362a-572bbaab6639@gmail.com>
References: <705265ea-37a3-6029-362a-572bbaab6639@gmail.com>
 <774233f766bf26976c0d923cc1dc53c7@polymtl.ca>
X-Poly-FromMTA: (comms3.kousu.ca [46.23.90.174]) at Fri, 29 Jul 2022 02:47:25 +0000
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

July 22, 2022 2:38 PM, "Mantas Mikulėnas" <grawity@gmail.com> wrote:

> On 2022-07-21 23:45, Nick Guenther wrote:
> 
>> [...]
>> I see in this old thread https://www.spinics.net/lists/linux-cifs/msg18249.html that you actually
>> want to go the _other_ direction, and isolate your sessions even more:
>> multiuser SMB connections should also be initiated per session, same like the
>> keyring. Currently the cifs SMB connections are accessible also from other all
>> sessions.
>>> That needs to be implemented indeed.
>> 
>> but that doesn't sound like it would make my users happy. In their perspective, tmux should be the
>> same environment as ssh or as the GUI, just more persistent. And I tend to agree.
>> Anyway, I hope this isn't too intricate or confusing for you. I would really appreciate a second
>> opinion, and maybe a consideration of that patch, if that patch is actually the right answer.
> 
> As another user, I'd expect the keyring search to be done recursively -- start from the session
> keyring as now, but follow the link into the user keyring, which is usually present (and isn't that
> its whole purpose?)
> 
> Then pam_cifscreds could be told which one to insert keys to, allowing it to be used both ways
> depending on needs -- just like how Kerberos or AFS can also have either isolated credentials or
> user-wide ones.



I've figured out a workaround, but I'm unsure about it and I could really use some advice from people with more insight.


I said before that my servers (and yours too) have

# cat /etc/pam.d/sshd | grep keyinit
session    optional     pam_keyinit.so revoke force

And the problem shows up when I detach tmux, **log out**, log back in and reattach tmux; then I see


p115628@davis:~$ keyctl list @s
keyctl_read_alloc: Key has been revoked

The word 'revoked' was the obvious clue I: just to remove the 'revoke' option and the problem goes away:

# cat /etc/pam.d/sshd | grep keyinit
session    optional     pam_keyinit.so force


This keeps the session-keyring(7) working even after reattaching. Because it's the **log out** that is disabling the keyring; per pam_keyinit(8) [1]:

>   revoke
>           Causes the session keyring of the invoking process to be revoked when the invoking
>           process exits if the session keyring was created for this process in the first place.


This change seems to have solved the immediate complaints from my users. But I don't like overriding the default like this; I assume there's a series of good reasons for using 'revoke' that I don't understand.

Would there be interest in switching to KEY_SPEC_USER_KEYRING? Would it be a good idea? Can I assume the kernel CIFS code would need a matching change?


[1] https://manpages.ubuntu.com/manpages/focal/man8/pam_keyinit.8.html
