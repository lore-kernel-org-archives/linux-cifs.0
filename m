Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B45ECAAD3
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 18:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiIASar (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 14:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiIASaq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 14:30:46 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0D141D01
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 11:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=Ot+DcGk1k8GLHGKxL3ZEGdkK/1To+BqKruwJ4qodLB4=; b=I/j9xMtMaJMC5gmR1JAnnXM2z1
        av9YjW0btL8cDUI+t1IVdGgQpFUsOKKaOyIRduOj7uWbvdR5TQ+jJWUeF26+GuCdpxZbWEP2+eYfe
        AJR+MTvsJDEgiWLla6B+MoJ0R0KxMW/ymhpSyHCEd3KxUNjM8SzXPpILag+Clq3U3rVvIykKzU7ee
        NyrDmfrMDwZHLCYOrk6roQR7cHChjP1Vjgz07ziJvFUEhYiDssEZ0pJqotepQKo20uBMdarXKpdW2
        kNgxCKdaY7Ni5bDXGgr5Bl+KXy5R42tUeRTWjFIEffabLCjhacs+p007WvWr0NyQb2gwNB0nQP/Lr
        playv7u35ZrZ4fQDcROOar0VvgGQuLvkOCT0DHJXCwHCOzyCnTSz6VxtcVUJM8TJZDHBLiUvqqoag
        7cGPwC5+hhyOMFFfCA7j8jjTB6TSQfy5ZHt0NEGl/cHeFj8N6Sot5DTcBavqvawR92ZmP4CNt+XdZ
        TcF7wTsqw7Wwq1FYw3SAXAGr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oToxZ-002gXi-RA; Thu, 01 Sep 2022 18:30:38 +0000
Date:   Thu, 1 Sep 2022 11:30:32 -0700
From:   Jeremy Allison <jra@samba.org>
To:     atheik <atteh.mailbox@gmail.com>
Cc:     hyc.lee@gmail.com, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        smfrench@gmail.com, tom@talpey.com
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Message-ID: <YxD6SEN9/3rEWaNR@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <YxDaZxljVqC/4Riu@jeremy-acer>
 <20220901174108.24621-1-atteh.mailbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220901174108.24621-1-atteh.mailbox@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 01, 2022 at 08:41:08PM +0300, atheik wrote:
>On Thu, 1 Sep 2022 09:14:31 -0700, Jeremy Allison wrote:
>>On Thu, Sep 01, 2022 at 09:06:07AM -0400, Tom Talpey wrote:
>>>
>>>Ok, two things. What I found strange is the "man smb.conf.5ksmbd", and
>>>as you say that should be man 5k smb.conf. Sounds ok to me.
>>>
>>>But the second thing I'm concerned about is the reuse of the smb.conf
>>>filename. It's perfectly possible to install both Samba and ksmbd on
>>>a system, they can be configured to use different ports, listen on
>>>different interfaces, or any number of other deployment approaches.
>>>
>>>And, Samba provides MUCH more than an SMB server, and configures many
>>>other services in smb.conf. So I feel ksmbd should avoid such filename
>>>conflicts. To me, calling it "ksmbd.conf" is much more logical.
>>
>>+1 from me. Having 2 conflicting file contents both wanting
>>to be called smb.conf is a disaster waiting to happen.
>
>ksmbd-tools clearly has a goal of being compatible with smb.conf(5) of
>Samba when it comes to the common subset of functionality they share.
>ksmbd-tools has 7 global parameters that Samba does not have, but other
>than, share parameters and global parameters of ksmbd-tools are subset
>of those in Samba. Samba and ksmbd-tools do not have any conflicting
>file locations. The smb.conf(5ksmbd) man page of ksmbd-tools does not
>collide with and never overshadows smb.conf(5) of Samba. Please, help
>me understand what sort of disaster this could lead to.

Samba adds and or changes functionality in smb.conf all
the time, without coordination with ksmbd. If you call
your config file smb.conf then we would have to coordinate
with you before any changes.

Over time, the meaning/use/names of parameters will drift
apart leading to possible conflicts.

Plus it leads to massive user confusion (am I running
smbd or ksmbd ? How do I tell ? etc.).

It is simple hygene to keep these names separate.

Please do so.
