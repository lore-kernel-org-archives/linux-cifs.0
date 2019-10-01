Return-Path: <SRS0=UtyP=X2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6D2C352AA
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Oct 2019 08:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56D9821855
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Oct 2019 08:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jgcGB8EK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfJAIWD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Oct 2019 04:22:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37818 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfJAIWC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Oct 2019 04:22:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x918GTuE167955;
        Tue, 1 Oct 2019 08:21:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=g9gFZLaotXCOZxkhODCPnrx2etbAo+JMNiLcmt4AZns=;
 b=jgcGB8EKMpScaWn0wP/Rya+JpkeYb1tPiAidlqYnZCcEjyMOcqtjM0IeyVLuKfHAYw/r
 O+I0cg0uqKNiADgElfcFr6SwuiPQpGX70sT0fIqAW0iawDAaWQ65/+3ge8RxQB1ljK0K
 X54f6Gl109hWdZbIGFILghxGYSGAVp0EorobfSFm5zHMNx7EFzRzRR5H5oOV/eKDDa42
 Pof32fraa5dnx2rFjvD7WcZVm3lGd9XMF35lk5MZsq7EBiC2ck5jjpKLJu0IQJmfyJkI
 Z340KuB+7g1uZLrhgQodPxhuCriPHDsX3qjaEpn5yrLOfeUIaNPdCMbxMTfAMv1CP76i qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v9xxum4he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 08:21:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x918JDl6158367;
        Tue, 1 Oct 2019 08:21:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vbmpy27r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 08:21:59 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x918Lwq9003180;
        Tue, 1 Oct 2019 08:21:58 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 01:21:57 -0700
Date:   Tue, 1 Oct 2019 11:21:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     stfrench@microsoft.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] smb3: pass mode bits into create calls
Message-ID: <20191001082152.GA26699@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=635
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=715 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010080
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Steve French,

The patch c3ca78e21744: "smb3: pass mode bits into create calls" from
Sep 25, 2019, leads to the following static checker warning:

	fs/cifs/smb2pdu.c:754 add_posix_context()
	warn: impossible condition '(mode == -1) => (0-u16max == (-1))'

fs/cifs/smb2pdu.c
   747  static int
   748  add_posix_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode)
                                                                     ^^^^^^^
This is unsigned short.

   749  {
   750          struct smb2_create_req *req = iov[0].iov_base;
   751          unsigned int num = *num_iovec;
   752  
   753          iov[num].iov_base = create_posix_buf(mode);
   754          if (mode == -1)
                    ^^^^^^^^^^
So this debug code will never trigger.

   755                  cifs_dbg(VFS, "illegal mode\n"); /* BB REMOVEME */
   756          if (iov[num].iov_base == NULL)
   757                  return -ENOMEM;
   758          iov[num].iov_len = sizeof(struct create_posix);
   759          if (!req->CreateContextsOffset)
   760                  req->CreateContextsOffset = cpu_to_le32(
   761                                  sizeof(struct smb2_create_req) +
   762                                  iov[num - 1].iov_len);
   763          le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_posix));
   764          *num_iovec = num + 1;
   765          return 0;
   766  }

regards,
dan carpenter
