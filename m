Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F30C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 08:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED7A64F1C
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 08:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbhCSIM3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 04:12:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbhCSIMH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 04:12:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J85L1x089246;
        Fri, 19 Mar 2021 08:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AedUhQRzREzZEC9XIvj2WsnLw7UGWi9pLMZgeRW2fRo=;
 b=EEXf7j2GKgsB2/6O64xm47rxILnfLbo1ITBm0eRKT73iukBzQ3ace6J83V+SKoxbIypn
 YzTJou8TKsSRCelnChZqhz4zMDZWZfyMna98bsvUuyPpyNf8oe3zzRrL5tPGMNiK32Sc
 tjOfhf7Eol2ZinaeQUxeNd6q4yL+CEusewwFTWxOLYl5+hAOZnnOSARXQiR7OTsQ+oTT
 haIW6Ir6NQjAi1Tv3jOcw3uiHOwhSNE09zXmsfaKHSsKXqQwFkwxnM5F+r4Mswk1p196
 3eoa3hukVxmytONNowmOXTY/3fefKxToyoVZcPar0OUXMjsaTDi4I5vALf+sf7bWHhDr Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 378nbmj53r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 08:12:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J8ADs3131651;
        Fri, 19 Mar 2021 08:12:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3797b3y95k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 08:12:01 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12J8C0TX032202;
        Fri, 19 Mar 2021 08:12:01 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Mar 2021 01:12:00 -0700
Date:   Fri, 19 Mar 2021 11:11:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [bug report] cifsd: introduce SMB3 kernel server
Message-ID: <20210319081153.GD21246@kadam>
References: <YFNRsYSWw77UMxw1@mwanda>
 <CAH2r5msOBAho=1W-eY0paj+4P1J+tuw-vFaRGg8oY50dXu6MHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msOBAho=1W-eY0paj+4P1J+tuw-vFaRGg8oY50dXu6MHQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190057
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190056
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 18, 2021 at 12:58:11PM -0500, Steve French wrote:
> Is the maintainers entry he added recently ok?
> 
> https://github.com/smfrench/smb3-kernel/blob/ff4a5c2c2732f7b7790a2424e8927f8602e467b5/MAINTAINERS#L4447 
> 

Ah good.  It hadn't hit linux-next when I wrote these.

regards,
dan carpenter

