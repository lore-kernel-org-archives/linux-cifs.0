Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16314C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 13:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8F7D20830
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 13:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xvj2kb9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfB1NfH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 08:35:07 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59518 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfB1NfH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Feb 2019 08:35:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1SDYDLU056468;
        Thu, 28 Feb 2019 13:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=1pP7t58NrD90T62fapgaIecxNWULNfqkhOUsuPCTdl4=;
 b=xvj2kb9dfV4REQqzhTviZGHWDisfpstRSmugJqA1rAtVkLTfFwYp4APOXRDpFkgTEK2d
 15SV3a7GWU+y7gFVkW7Scuq7bjk0FyDqryUGGdcBDOyNMTLhX0/bvRhjjStv7CaSUETW
 a9eJAU30HQx5eeBLlZNRbJZ3v3TlEJ7IPHScGRw/x62aURFm7dyRnoJQ9rbMra7ApFTA
 eJqmwZ0dbtPkqit1zHkBDDvR1uYyK37gVtqzmo/EBxvh+Oom/nsnZFUhYVMiAOUqCKDy
 VRiT4SN3VxZiYOGUyQvpb7L50dosjo/yTzp6F8toNEKMEh32ubvJnUhD3Zf0hnYXtnor cA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qtupeh698-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 13:34:48 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1SDYlSq025910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 13:34:47 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1SDYiKe006883;
        Thu, 28 Feb 2019 13:34:45 GMT
Received: from kadam (/197.157.0.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 05:34:44 -0800
Date:   Thu, 28 Feb 2019 16:34:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH] cifs: Clean up an error code in cifs_root_iget()
Message-ID: <20190228133435.GB9806@kadam>
References: <20190228052659.GA3253@kadam>
 <CAH2r5ms1+5Kj_qmWx3oww7Af_rfiCSBbkGos_gqieqH7jW98BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5ms1+5Kj_qmWx3oww7Af_rfiCSBbkGos_gqieqH7jW98BQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9180 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=879 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902280094
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 27, 2019 at 11:44:14PM -0600, Steve French wrote:
> Won't that change behavior and cause the success case (server returned
> 0, and does support POSIX and &inode pointer is ok) to now return
> -EINVAL.
> 

You're right.  I'm really sorry.  I don't know why I misread the code...

Also looking at it now, this was a false positive in Smatch.  I have
been working on that code in the past couple days and I don't have the
warning in my latest build.

regards,
dan carpenter

