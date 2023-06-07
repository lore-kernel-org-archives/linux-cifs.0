Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB29C7EE43
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jun 2023 20:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjFGUVW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjFGUVQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jun 2023 16:21:16 -0400
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39D726BF;
        Wed,  7 Jun 2023 13:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686169251; x=1717705251;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=LR+ZpN+XlVuvL7Ovhnbf/G+Q1+/QPdwd50qySINBSrU=;
  b=vxXzi1S7i+6AXsMQH8se6gGGtg+VquqY59SNbtZNY4FW71jhjxX89Mou
   /CRDD1FPlx4pr+ILM8JKqHpFefYW7x9cCN88zMdIySzhB8jWYRJBfqkzQ
   2eOSw06WoznrjmIQsIdwezd0kgscHkZx4zn7WmgLFqpZKpLp8L2jGH/Fq
   Q=;
X-IronPort-AV: E=Sophos;i="6.00,225,1681171200"; 
   d="scan'208";a="589506602"
Subject: Re: [PATCH 5.4 0/2] Backport few dfs related fixes to cifs
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 20:20:27 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id A85F0C15D9;
        Wed,  7 Jun 2023 20:20:26 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 7 Jun 2023 20:20:25 +0000
Received: from [192.168.31.7] (10.187.170.39) by EX19D002UWC004.ant.amazon.com
 (10.13.138.186) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Wed, 7 Jun
 2023 20:20:25 +0000
Message-ID: <de36d593-5f1e-bb9b-6b70-8be0b783c5f4@amazon.com>
Date:   Wed, 7 Jun 2023 13:20:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.0
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <sfrench@samba.org>, <stable@vger.kernel.org>,
        <linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230607185313.11363-1-risbhat@amazon.com>
 <2023060750-unpledged-effective-bd95@gregkh>
Content-Language: en-US
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
In-Reply-To: <2023060750-unpledged-effective-bd95@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.187.170.39]
X-ClientProxiedBy: EX19D046UWB002.ant.amazon.com (10.13.139.181) To
 EX19D002UWC004.ant.amazon.com (10.13.138.186)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 6/7/23 12:07 PM, Greg KH wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> On Wed, Jun 07, 2023 at 06:53:11PM +0000, Rishabh Bhatnagar wrote:
>> Recently we have been seeing kernel panic in cifs_reconnect function
>> while accessing tgt_list. Looks like tgt_list is not initialized
>> correctly. There are fixes already present in 5.10 and later trees.
>> Backporting them to 5.4
>>
>>   CIFS VFS: \\172.30.1.14 cifs_reconnect: no target servers for DFS
>>   failover
>>   BUG: unable to handle page fault for address: fffffffffffffff8
>>   #PF: supervisor read access in kernel mode
>>   #PF: error_code(0x0000) - not-present page
>>   PGD 260e067 P4D 260e067 PUD 2610067 PMD 0
>>   Oops: 0000 [#1] SMP PTI
>>   RIP: 0010:cifs_reconnect+0x51d/0xef0 [cifs]
>>   RSP: 0018:ffffc90000693da0 EFLAGS: 00010282
>>   RAX: fffffffffffffff8 RBX: ffff8887fa63b800 RCX: fffffffffffffff8
>>   Call Trace:
>>   cifs_handle_standard+0x18d/0x1b0 [cifs]
>>   cifs_demultiplex_thread+0xa5c/0xc90 [cifs]
>>   kthread+0x113/0x130
>>
>> *** BLURB HERE ***
> No blurb?
>
> And this says 5.4, yet your patches say 5.10?
>
> Totally confused...
>
> greg k-h

These patches are applicable for 5.4. Will send another version with 
that fixed.
Apologies for the mess.

