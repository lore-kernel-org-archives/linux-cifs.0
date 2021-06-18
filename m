Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A150FC49361
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 08:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A28060BBB
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 08:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhFRIV6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Jun 2021 04:21:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64254 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232409AbhFRIV6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 18 Jun 2021 04:21:58 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I8HOc2028683;
        Fri, 18 Jun 2021 08:19:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=fv4pfXaAByNncMHfBjHvaP9PumDCscygQU7MAcT/KyY=;
 b=Yv61xQJKtlOoQRYXBXhA43KKAp2AcEmYO35ytdherM6W4fHZj0NUDYXNteE1FbOvNIRl
 V24y71vva6U+aIRFZTOzgXcneOvZXI/6W4NpW3M1no0TdgGdb7XGY5wOCikomG+K2Zju
 lC7M2B1qk9q7daQfUjPdEPAP6Ph6gNv2Uvf2jmBPsiidGPzRIiGD5gE7WuaMCXSck0Lw
 Ng5crRNpBzO5I9Sf7Z01RjVCswYPnmmCLeN8o1wP24Lu2pHtadldXRAFfu2Aq+ddjEiy
 NBM6CPOL2s0g8dJsYJV6ACknwR16UbdKs8pO+Zo4tnvWakGqjMgi91jovMkVDUvzODG9 TA== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 397w1y2pt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 08:19:14 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15I8JD82001646;
        Fri, 18 Jun 2021 08:19:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 396wawh25h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 08:19:13 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15I8JDQ8001552;
        Fri, 18 Jun 2021 08:19:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 396wawh24r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 08:19:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15I8J8ul009470;
        Fri, 18 Jun 2021 08:19:08 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Jun 2021 01:19:08 -0700
Date:   Fri, 18 Jun 2021 11:19:00 +0300
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
Message-ID: <20210618081900.GR1901@kadam>
References: <20210617064653.3193618-1-libaokun1@huawei.com>
 <20210617092639.GD1861@kadam>
 <fa589904-ac16-fb97-bb7a-df081954d363@huawei.com>
 <20210618051400.GG1861@kadam>
 <4adc3507-6b34-1f23-36cb-21336d5e8e91@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4adc3507-6b34-1f23-36cb-21336d5e8e91@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: FfdhD8auGzzzxW_fIvfq1GYeF08m_AbP
X-Proofpoint-GUID: FfdhD8auGzzzxW_fIvfq1GYeF08m_AbP
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 18, 2021 at 03:47:12PM +0800, libaokun (A) wrote:
> 在 2021/6/18 13:14, Dan Carpenter 写道:
> > On Fri, Jun 18, 2021 at 09:44:37AM +0800, libaokun (A) wrote:
> > > I don't know what the difference is between
> > > 
> > > list_for_each_entry() and list_for_each() for 'struct channel *chann',
> > > 
> > > but I don't think there's any difference here.
> > Correct.  There is no difference, but Coccinelle is smart enough to
> > parse list_for_each_entry() and it's not smart enough to parse
> > list_for_each().
> > 
> > > Would you give me more detial about this, please?
> > There is a Coccinelle script scripts/coccinelle/iterators/itnull.cocci
> > which will complain about the NULL check in the new code so this patch
> > will introduce a new warning.  We may as well remove the unnecessary
> > NULL check and avoid the warning.
> > 
> > regards,
> > dan carpenter
> > 
> > .
> 
> I get your point, but this bug has nothing to do with my patch.
> 
> It's  from e2f34481b24d(cifsd: add server-side procedures for SMB3).
> 

Fine, but when Hulk Robot reports the new warning and someone fixes it,
I'm going to insist that the Fixes tag points to your patch.  ;)

regards,
dan carpenter

