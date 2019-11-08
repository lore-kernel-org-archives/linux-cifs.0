Return-Path: <SRS0=ZZqS=ZA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB5EC5DF60
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Nov 2019 05:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4CB121D7B
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Nov 2019 05:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SNrhUXeW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbfKHFUJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Nov 2019 00:20:09 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfKHFUH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Nov 2019 00:20:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA85J28H159828;
        Fri, 8 Nov 2019 05:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=xng1kA5RowooNZUlS/xwzdU4/L5MsFBsvmVRR1QM22s=;
 b=SNrhUXeWI8nZCcsZde2J96CzGIXtpeSA5BLwyFwwE53lucJmc38ABepGG8Q/LWLrQlzb
 J32XALnWecTccTe5Zj14pA46HHa6IydBh7A1irDaUbt00XuBNTBIQKp1bkNlJhQG0do4
 Gj/Edf+ulJ6jlGS4XTVTNYDwd/2FIUsnlyPqnuUs3AuZl3g7J25sjSizOXeabIT/XAeB
 RxLW1A4uwRO8mNw3OB+UDBfFwWcLOyGDeYXccul8AoyWINXGis7Iq5xOOU121ToiBBkG
 3Hm77wgwo1gMl+Raqzvy9botAdX+nAyzGTpTVt663HpXact25f6Ft5sp9X/mHyl8EndI pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w12xx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 05:20:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA85EidK025745;
        Fri, 8 Nov 2019 05:20:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w41wbqqyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 05:20:02 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA85K1Im020386;
        Fri, 8 Nov 2019 05:20:01 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 21:20:01 -0800
Date:   Fri, 8 Nov 2019 08:19:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     stfrench@microsoft.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] smb3: remove confusing dmesg when mounting with
 encryption ("seal")
Message-ID: <20191108051954.GA27432@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=817
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=898 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080052
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Steve French,

This is a semi-automatic email about new static checker warnings.

The patch 6a364520b30e: "smb3: remove confusing dmesg when mounting
with encryption ("seal")" from Nov 5, 2019, leads to the following
Smatch complaint:

    fs/cifs/connect.c:1091 cifs_handle_standard()
    warn: variable dereferenced before check 'mid' (see line 1075)

fs/cifs/connect.c
  1074		length = server->ops->check_message(buf, server->total_read, server,
  1075						    mid->decrypted);
                                                    ^^^^^^^^^^^^^^
New unchecked dereference.

  1076		if (length != 0)
  1077			cifs_dump_mem("Bad SMB: ", buf,
  1078				min_t(unsigned int, server->total_read, 48));
  1079	
  1080		if (server->ops->is_session_expired &&
  1081		    server->ops->is_session_expired(buf)) {
  1082			cifs_reconnect(server);
  1083			wake_up(&server->response_q);
  1084			return -1;
  1085		}
  1086	
  1087		if (server->ops->is_status_pending &&
  1088		    server->ops->is_status_pending(buf, server))
  1089			return -1;
  1090	
  1091		if (!mid)
                    ^^^^
The old code assumed it could be NULL.

  1092			return length;
  1093	

regards,
dan carpenter
