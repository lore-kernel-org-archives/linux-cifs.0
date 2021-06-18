Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92991C48BDF
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 05:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66EEA61245
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 05:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhFRFRK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Jun 2021 01:17:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23116 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231680AbhFRFQ6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 18 Jun 2021 01:16:58 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I5C3DK030965;
        Fri, 18 Jun 2021 05:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9sr54Rwz+Mm9VrPf1rcpI4QaZjI69pkEBSAeWrtgZfQ=;
 b=gncBJugVhgyqODvf6NWX1lBiYBXEH9XwvGXYiXRqCW8E50jC4XdRbzpELSXP1/mIVu6I
 qHXZmzAGxBRAx3OE5KimZYrIpVnlnO3Ny+Y7+1vSyCrFOf7gn8gs34dMAiZHiPhLHfdb
 sX8Db+yydtw5gT0vmpXNu7asqR8cHSjoJknGx3oHwjV7jyPhXAW48D5cy0uO+Vw10TKp
 8bs1A78yoLf2CIyg4dMKJ4d6pETGKNfVY+23i3B4W/4V9jttbpxF0cEX7CmxktQAmd37
 YcTW9fnUohrOTvmwJatK3z9ILZqZhB5up4Ys6dEdZ0GgW5hGaGTFB4fOx8iPu4FRYnei TQ== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39893qs2hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 05:14:14 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15I5EESe174175;
        Fri, 18 Jun 2021 05:14:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 396wax6w5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 05:14:14 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15I5ED4p174154;
        Fri, 18 Jun 2021 05:14:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 396wax6w5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 05:14:13 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15I5ECF4002415;
        Fri, 18 Jun 2021 05:14:12 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Jun 2021 05:14:11 +0000
Date:   Fri, 18 Jun 2021 08:14:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "libaokun (A)" <libaokun1@huawei.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] cifsd: fix WARNING: convert list_for_each to entry
 variant in smb2pdu.c
Message-ID: <20210618051400.GG1861@kadam>
References: <20210617064653.3193618-1-libaokun1@huawei.com>
 <20210617092639.GD1861@kadam>
 <fa589904-ac16-fb97-bb7a-df081954d363@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa589904-ac16-fb97-bb7a-df081954d363@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: 3fPTESHAVSZeK0-qEf6Ci4P0PmlFSQfQ
X-Proofpoint-GUID: 3fPTESHAVSZeK0-qEf6Ci4P0PmlFSQfQ
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 18, 2021 at 09:44:37AM +0800, libaokun (A) wrote:
> I don't know what the difference is between
> 
> list_for_each_entry() and list_for_each() for 'struct channel *chann',
> 
> but I don't think there's any difference here.

Correct.  There is no difference, but Coccinelle is smart enough to
parse list_for_each_entry() and it's not smart enough to parse
list_for_each().

> 
> Would you give me more detial about this, please?

There is a Coccinelle script scripts/coccinelle/iterators/itnull.cocci
which will complain about the NULL check in the new code so this patch
will introduce a new warning.  We may as well remove the unnecessary
NULL check and avoid the warning.

regards,
dan carpenter

