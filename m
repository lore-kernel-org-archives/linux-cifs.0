Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8698ECAAA3
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Aug 2022 17:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiHZRKe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Aug 2022 13:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344452AbiHZRKb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Aug 2022 13:10:31 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C82386FF3
        for <linux-cifs@vger.kernel.org>; Fri, 26 Aug 2022 10:10:29 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 701248026A;
        Fri, 26 Aug 2022 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1661533828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1EvCv8yYylZ1MEgnr9abVG9LpgvMTyVXSykOjjjqk1s=;
        b=PFfSC5PmQb8o/OT53+xNXAmsWH6ta+xL4SXc4NSh4RJq26W32AJUMyYeHqwl4WgbPBUBZY
        s8VDgF6/lqPn78BZ2sB01DaLEPp/HBAn0Ak6Y61j0Wy/SMnoiXpOv5m9VovaxUQkdB/oAz
        gwe91X/3lsY2IjyF7vMLloHze3ujsVpmA6Z8DZVY88Q0yXObHgxIwyzrqFgDtE2MON9Usb
        bBpDcpkBKzymt10oWHTAYI1oZtNS0iq4mWIbb7PNFTAW9JLf7NXeKMI8LVE21Qek1OAfhm
        SHxQ5c5MYGC+EUib9NR1c2BulIbG8vhQGkyrcmZtXBt0tMXokKgiSiYFGoFqIA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org
Subject: Re: SMB client testing wiki
In-Reply-To: <165e9b10-2f3e-dc88-029a-c8157a98f095@talpey.com>
References: <8bcbba74-d6ce-3c40-4655-e67bf75f3b3f@talpey.com>
 <878rnb3vkw.fsf@cjr.nz> <93e55661-ea4e-7205-d310-59105bc767ed@talpey.com>
 <8735dj3sem.fsf@cjr.nz> <165e9b10-2f3e-dc88-029a-c8157a98f095@talpey.com>
Date:   Fri, 26 Aug 2022 14:10:46 -0300
Message-ID: <87zgfr2and.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom Talpey <tom@talpey.com> writes:

>
> On 8/26/2022 12:01 PM, Paulo Alcantara wrote:
>> Tom Talpey <tom@talpey.com> writes:
>> 
>>> Easy enough! How do I know if it "passes" though? My understanding
>>> is that a bunch of tests are expected to fail, or at least warn.
>>> Do I need to test a clean client, then compare results? Or am I
>>> misunderstanding, and FSTYP=cifs is taking care of it?
>> 
>> That's a really good question.  We have a pre-defined list of tests that
>> get run by a specfic SMB version, server, if multichannel, etc.
>
> Yeah, there are a few exclusion files on the wiki, but they look
> really old. Also, I cannot believe that "vers=3.0" is the proper
> default, as linked there!!!

Yeah :-(  We should definitely update it.

>> Steve might send you the list of pre-defined tests that get run on our
>> buildbot so you can try it out.  He usually keeps those lists
>> up-to-date.
>
> The buildbot doesn't do RDMA, or I'd consider that. But it's a lot
> more convenient to have a local harness either way.

It currently doesn't, unfortunately.  You could at least get the same
set of tests that run over 3.1.1 against samba and/or ksmbd and then
change mount options to get RDMA enabled.  And of course, let us know
when you get it working and let's add it to our buildbot as well ;-)
