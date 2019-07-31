Return-Path: <SRS0=3qap=V4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29472C32751
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 12:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E484E20693
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 12:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UNwu0c4w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387606AbfGaM3c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Jul 2019 08:29:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49476 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387594AbfGaM3c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Jul 2019 08:29:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6VCSffp017250;
        Wed, 31 Jul 2019 12:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=QinEdhda0QF80hZU/Agg8fmLabZy/oSbGrNclrokDBw=;
 b=UNwu0c4wPTcK+P1xidV4FT1LKRMkQxaz1cUkvPP0Ee+M+UU7Gz6OFj/z0zrdjsIBiIq4
 RR8DcnO5BwNTbkOvMba9ntx0ugykK37yx2s+Jx6DIgjqa48IZxcBXUaErA1PKGdhWr8G
 S8WWUkZgU4BlTabEqJIoeeOVWQGWLj0dAYvOkqC0FbbM0/OAXdFd2cjaI2oHoDA481B2
 +wEqkrBjyxFUHotQBrap0c7q5fg3j/fm9XhJXH2VLylTe5PSkrLLX5CH1ijL6LQ1clmv
 z5rKCBCAVw8gaAgmgUgsyHemIMKZ2yOeJ8PUZZ2MFFIg2K8J4ASWSTjwi0sYZWoA5hKV vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u0e1tw392-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 12:29:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6VCRT7A074339;
        Wed, 31 Jul 2019 12:29:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u2exbjc4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 12:29:03 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6VCSwSp004011;
        Wed, 31 Jul 2019 12:28:58 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Jul 2019 12:28:57 +0000
Date:   Wed, 31 Jul 2019 15:28:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     Colin King <colin.king@canonical.com>,
        samba-technical@lists.samba.org, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: remove redundant assignment to variable rc
Message-ID: <20190731122841.GA1974@kadam>
References: <20190731090526.27245-1-colin.king@canonical.com>
 <87r266seg4.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r266seg4.fsf@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907310127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907310127
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 31, 2019 at 12:09:31PM +0200, Aurélien Aptel wrote:
> Colin King <colin.king@canonical.com> writes:
> > Variable rc is being initialized with a value that is never read
> > and rc is being re-assigned a little later on. The assignment is
> > redundant and hence can be removed.
> 
> I think I would actually rather have rc set to an error by default than
> uninitialized. Just my personal opinion.

You're just turning off GCC's static analysis (and introducing false
positives) when you do that.  We have seen bugs caused by this and never
seen any bugs prevented by this style.

regards,
dan carpenter
