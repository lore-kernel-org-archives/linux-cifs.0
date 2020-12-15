Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA6EC4361B
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 17:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF3422475
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 17:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgLORze (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Dec 2020 12:55:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730138AbgLORz0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Dec 2020 12:55:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFHeFKH011160;
        Tue, 15 Dec 2020 17:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZjhwudxNl6QM2DkBGQ9bhzkYvF8C+limb75EV+aB6gg=;
 b=DvESBX/8TlWX6J7nE5JdnukY4fqyC1DORLf+knuuYWI9qG1/AmfSP7Yx8afe33qKTSbB
 L8KRZE14boyAzhciqQLZVWhGJpvf3JLHgqpj/9E8iYO7Li9TKiyAjbPQoZe+1SbEwqGi
 yv2DFI0qPoF1nNu+R3UqvvFHV2kew3KltdgJkxmKu6EY37cNkq96Qx8CYto2I7g5qmql
 GWaxm8Z82y2RrK5pOvSKoHecdCHVXT2SuDLit2WLymBhAzfmG9pqOqVkRdAXwSutMjmw
 ugM+lyGjXleGSa3entkHwmx34tJnkgDmr+XEDC+t4GQCKvXp8rs06vycHPM/GtF6hHfe aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35cn9rc05e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Dec 2020 17:54:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFHfAVV024118;
        Tue, 15 Dec 2020 17:54:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35e6jrgewf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 17:54:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BFHsevt014115;
        Tue, 15 Dec 2020 17:54:40 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Dec 2020 09:54:39 -0800
Date:   Tue, 15 Dec 2020 20:54:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix some error pointers handling detected by
 static checker
Message-ID: <20201215175433.GD2831@kadam>
References: <20201215164656.28788-1-scabrero@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215164656.28788-1-scabrero@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150119
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Dec 15, 2020 at 05:46:56PM +0100, Samuel Cabrero wrote:
> * extract_hostname() and extract_sharename() never return NULL, so
>   use IS_ERR() instead of IS_ERR_OR_NULL() in cifs_find_swn_reg(). If
>   any of these functions return an error, then return an error pointer
>   instead of NULL.
> * Change cifs_find_swn_reg() function to always return a valid pointer
>   or an error pointer, instead of returning NULL if the registration
>   is not found.
> * Finally update cifs_find_swn_reg() callers to check for -EEXIST
>   instead of NULL.
> * In cifs_get_swn_reg() the swnreg idr mutex was not unlocked in the
>   error path of cifs_find_swn_reg() call.
> 
> Reported-By: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>

Fantastic!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

