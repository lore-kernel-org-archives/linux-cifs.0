Return-Path: <SRS0=UtyP=X2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F2AC388F3
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Oct 2019 08:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18655215EA
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Oct 2019 08:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HYJJcIKI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfJAIfM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Oct 2019 04:35:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfJAIfM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Oct 2019 04:35:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x918XiMP145757;
        Tue, 1 Oct 2019 08:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=W21EHvLMRMOysmG7bOUl9k2HvSMq7Ct2gLdWhTKYez8=;
 b=HYJJcIKIIpYa6v6go+2iEcHCvvsFc3hximmByLzAr3MTmTHLhqwiIohGUwt0a7/c/OMk
 XpH+/pkN81WhzvOQgebDv8cKMhhHYassyCJwvQ1TuVeZR2IjJHJ9Xc4oMnsGSI52z5xy
 +17iG57yap7i+E25RPAiEYVLfVrGYEkasZTutDN9IgWfWs5/vE+f5o5L4r+nYH4WWFD+
 l8+LwVdwRh1eOuSm1mT4z6G57DN4RFSaLfUWT5iQ4zZMCAnGSwO9/HUtj5ZfHQt6TwU6
 0vBanedV5oAfX+DVUmPdZaDOtz72IHeYwgdY4JWHVUegPIYLR50ztN+YNnAR74IAP3t4 EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v9yfq45y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 08:35:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x918Y4Id015441;
        Tue, 1 Oct 2019 08:35:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vbnqcdw4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 08:35:08 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x918Z7uI030228;
        Tue, 1 Oct 2019 08:35:08 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 01:35:07 -0700
Date:   Tue, 1 Oct 2019 11:35:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     stfrench@microsoft.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] smb3: pass mode bits into create calls
Message-ID: <20191001083500.GA20393@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=814
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=898 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010083
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Steve French,

The patch c3ca78e21744: "smb3: pass mode bits into create calls" from
Sep 25, 2019, leads to the following static checker warning:

	fs/cifs/smb2pdu.c:2528 SMB2_open_init()
	warn: always true condition '(oparms->mode != -1) => (0-u16max != (-1))'

fs/cifs/smb2pdu.c
  2510          if (tcon->snapshot_time) {
  2511                  cifs_dbg(FYI, "adding snapshot context\n");
  2512                  if (n_iov > 2) {
  2513                          struct create_context *ccontext =
  2514                              (struct create_context *)iov[n_iov-1].iov_base;
  2515                          ccontext->Next =
  2516                                  cpu_to_le32(iov[n_iov-1].iov_len);
  2517                  }
  2518  
  2519                  rc = add_twarp_context(iov, &n_iov, tcon->snapshot_time);
  2520                  if (rc)
  2521                          return rc;
  2522          }
  2523  
  2524          /* TODO: add handling for the mode on create */
  2525          if (oparms->disposition == FILE_CREATE)
  2526                  cifs_dbg(VFS, "mode is 0x%x\n", oparms->mode); /* BB REMOVEME */
  2527  
  2528          if ((oparms->disposition == FILE_CREATE) && (oparms->mode != -1)) {
                                                             ^^^^^^^^^^^^^^^^^^
unsigned short can't equal -1.

  2529                  if (n_iov > 2) {
  2530                          struct create_context *ccontext =
  2531                              (struct create_context *)iov[n_iov-1].iov_base;
  2532                          ccontext->Next =
  2533                                  cpu_to_le32(iov[n_iov-1].iov_len);
  2534                  }
  2535  
  2536                  /* rc = add_sd_context(iov, &n_iov, oparms->mode); */
  2537                  if (rc)
  2538                          return rc;
  2539          }
  2540  
  2541          if (n_iov > 2) {
  2542                  struct create_context *ccontext =
  2543                          (struct create_context *)iov[n_iov-1].iov_base;
  2544                  ccontext->Next = cpu_to_le32(iov[n_iov-1].iov_len);
  2545          }

regards,
dan carpenter
