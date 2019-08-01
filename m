Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F015C433FF
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 08:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F14C320838
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 08:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hoOY+r66"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfHAIER (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 04:04:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbfHAIEQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Aug 2019 04:04:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x717wwaS173578;
        Thu, 1 Aug 2019 08:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=uqjHMdgaF7LuDAF9oZsHnLrTeE15VIi9x0+twPBjRhg=;
 b=hoOY+r66LbPdS7EdDSgz2aQO1m3ADA6xCt8ord1HLpK++3iX5/LwIjypy+f8KCoHL3RR
 m4lRyOaCOq1XGMGDvgs3S6MPO0JbuL3Vyyhrw30VXWsliZQ1sarPvD1KqR+2TeX9wPiw
 ZFcm/CJzNV/85TnFTm4KBpMzNkN3l8LiAeygwVQ2f6amFXc2fUrUrYNttqk2HEOzKYK9
 knPVV/wV+Jxe66J3bC7ebeYFX/TPbV6I+7tIx3tkagPzBFHvpg/W22AYqJpTzylLGp2V
 N2ajCzDN6rrN9dIH8Xh9JnGy4jcvp01v1v07DDpnScUayvZmHY6m01J3IqHsE1aWf0yy jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u0e1u28de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 08:03:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71831bA179061;
        Thu, 1 Aug 2019 08:03:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u3mbtw5ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 08:03:56 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7183qwu000621;
        Thu, 1 Aug 2019 08:03:52 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Aug 2019 01:03:51 -0700
Date:   Thu, 1 Aug 2019 11:03:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     Colin King <colin.king@canonical.com>,
        samba-technical@lists.samba.org, Steve French <sfrench@samba.org>,
        kernel-janitors@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: remove redundant assignment to variable rc
Message-ID: <20190801080343.GA1935@kadam>
References: <20190731090526.27245-1-colin.king@canonical.com>
 <87r266seg4.fsf@suse.com>
 <20190731122841.GA1974@kadam>
 <87lfwerze8.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfwerze8.fsf@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010082
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010081
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 31, 2019 at 05:34:39PM +0200, Aurélien Aptel wrote:
> "Dan Carpenter" <dan.carpenter@oracle.com> writes:
> > You're just turning off GCC's static analysis (and introducing false
> > positives) when you do that.  We have seen bugs caused by this and never
> > seen any bugs prevented by this style.
> 
> You've never seen bugs prevented by initializing uninitialized
> variables? Code can change overtime and I don't think coverity is
> checked as often as it could be, meaning the var could end up being used
> while uninitialized in the future.

Of course, we wouldn't see bugs that were prevented so that wasn't
entirely fair.

There is a several year old bug in GCC where it sometimes initializes
these to zero and doesn't warn about the uninitialized variable so it
is actually possible to prevent a bug by initializing it to an error
code.

Smatch also warns about uninitialized variables.  I normally run Smatch
on linux-next every day but I have been out of office for the past
month and my config doesn't cover everything.

We haven't been able to enable this "redundant assignment" warning
because of all the false positives like this.  It mostly finds dead code
but it also does find some bugs where we forget to check the error code
or we use the wrong variable.

regards,
dan carpenter

