Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211B7C54EBC
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 16:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjAJQpz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 11:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238748AbjAJQpk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 11:45:40 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5228CBC4
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 08:45:39 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 71A9B7FC04;
        Tue, 10 Jan 2023 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673369137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sx2kcXm0zSYVaJiak5hkt4phPF47PQk2BqxggpE3j0I=;
        b=VL5nf5aDV0yMyZxqhhgc1xYwRwGjzU9bj61ydQugEGxwMhkAswp6C4gCCmxVmjZyMjmagY
        GtSqIPH7xT1xhnTMYbBq2YERi0RK9yVx1H2geknopRy8GzLR7tfDAh0C02RYz0uOqeOaGs
        0kYMH/OYNV8bteYlsctF9jmb5P/+w2eDxMJMVuOf129aLmJ8yodsEI8/BFRElZDmFVd7bj
        t3Iidw3hbGISSE9HSbsSHKzYGzWkxmFuLQz33YhbJre0kUEYptXXpq1tXaFCynYGzo5Edg
        71H7LdMbDcUhB1MasdLxn63oTyfeEe4BKgReIImyc4kb4JFx9VGYzBaFu5/PSg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Tom Talpey <tom@talpey.com>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: do not query ifaces on smb1 mounts
In-Reply-To: <f1e10da3-d2b5-98ed-637b-7773d0fb9b0f@talpey.com>
References: <20230109164146.1910-1-pc@cjr.nz>
 <f1e10da3-d2b5-98ed-637b-7773d0fb9b0f@talpey.com>
Date:   Tue, 10 Jan 2023 13:45:32 -0300
Message-ID: <87k01uwd77.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom Talpey <tom@talpey.com> writes:

> On 1/9/2023 11:41 AM, Paulo Alcantara wrote:
>> Users have reported the following error on every 600 seconds
>> (SMB_INTERFACE_POLL_INTERVAL) when mounting SMB1 shares:
>> 
>> 	CIFS: VFS: \\srv\share error -5 on ioctl to get interface list
>> 
>> It's supported only by SMB2+, so do not query network interfaces on
>> SMB1 mounts.
>> 
>> Fixes: 6e1c1c08cdf3 ("cifs: periodically query network interfaces from server")
>> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>> ---
>>   fs/cifs/cifsglob.h |  1 +
>>   fs/cifs/connect.c  | 18 ++++++++++++------
>>   2 files changed, 13 insertions(+), 6 deletions(-)
>> 
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index cfdd5bf701a1..931e9d5b21f4 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -1240,6 +1240,7 @@ struct cifs_tcon {
>>   #ifdef CONFIG_CIFS_DFS_UPCALL
>>   	struct list_head ulist; /* cache update list */
>>   #endif
>> +	bool			iface_query_poll:1;
>
> Why add such a special-case flag, instead of simply checking the
> dialect, or (betyter) the server's multichannel capability attribute?
>
> It seems fragile and untestable to set a flag like this, especially
> in the tcon, which has nothing to do with supporting the multichannel
> fsctl.

Makes sense.  I'll fix it in v2.

Thanks.
