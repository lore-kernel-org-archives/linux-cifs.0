Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088FCC433E9
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C9F64E28
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhCRNMe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 09:12:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40342 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhCRNMa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Mar 2021 09:12:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12IDCRiG072578;
        Thu, 18 Mar 2021 13:12:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=o+rvX6FldRoJ2WzUHY0YZiC1o0dfXgmcWWY1Ssg1ql8=;
 b=jO/VZk7sspS2jUqhAicodcp5ok6PcavBFrtBC+OuTNEnl8uXwY7SUvylQr24L49fBcrv
 JSN161HVlNcOEWAAlNdZ6xlVrriLF52wHChLWnd0l9isCB0+XlVwe5jBqqYgvJeKgmka
 cSQsS0tiSz5og6IACLjTX7JcpFo0E9sC/2l8is90RYi7swOeyxIeMDNJc0VoS5Bm2f2d
 3k2ChsbSpCO4NxzxfLfmjE6mAsvjvN+Pptp9iDliYC8dTuZFtSsLk8QYfHDL/kJpLQhJ
 ZlXTlkxk/BOtfF4hHle0ZvMW+cePX+u/679TNgSIn2vZ6uGECzjEUXqCaknTmXxigeGp EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37a4ekvc3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:12:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ID5xuN103158;
        Thu, 18 Mar 2021 13:12:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3797a3xj29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:12:25 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12IDCNaU001142;
        Thu, 18 Mar 2021 13:12:23 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Mar 2021 06:12:23 -0700
Date:   Thu, 18 Mar 2021 16:12:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     namjae.jeon@samsung.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifsd: introduce SMB3 kernel server
Message-ID: <YFNRsYSWw77UMxw1@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180097
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=986 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180097
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[ The fs/cifsd/ directory needs to be added to the MAINTAINERS file
  so this stuff goes through linux-cifs@vger.kernel.org ]

Hello Namjae Jeon,

The patch cabcebc31de4: "cifsd: introduce SMB3 kernel server" from
May 14, 2020, leads to the following static checker warning:

	fs/cifsd/transport_rdma.c:1168 smb_direct_post_send_data()
	warn: missing error code 'ret'

fs/cifsd/transport_rdma.c
  1150  
  1151          ret = smb_direct_create_header(t, data_length, remaining_data_length,
  1152                                         &msg);
  1153          if (ret) {
  1154                  atomic_inc(&t->send_credits);
  1155                  return ret;
  1156          }

"ret" is zero.

  1157  
  1158          for (i = 0; i < niov; i++) {
  1159                  struct ib_sge *sge;
  1160                  int sg_cnt;
  1161  
  1162                  sg_init_table(sg, SMB_DIRECT_MAX_SEND_SGES-1);
  1163                  sg_cnt = get_mapped_sg_list(t->cm_id->device,
  1164                                  iov[i].iov_base, iov[i].iov_len,
  1165                                  sg, SMB_DIRECT_MAX_SEND_SGES-1, DMA_TO_DEVICE);
  1166                  if (sg_cnt <= 0) {
  1167                          ksmbd_err("failed to map buffer\n");
  1168                          goto err;

Should ret = -ENOMEM on this path?

  1169                  } else if (sg_cnt + msg->num_sge > SMB_DIRECT_MAX_SEND_SGES-1) {
  1170                          ksmbd_err("buffer not fitted into sges\n");
  1171                          ret = -E2BIG;
  1172                          ib_dma_unmap_sg(t->cm_id->device, sg, sg_cnt,
  1173                                          DMA_TO_DEVICE);
  1174                          goto err;
  1175                  }
  1176  
  1177                  for (j = 0; j < sg_cnt; j++) {
  1178                          sge = &msg->sge[msg->num_sge];
  1179                          sge->addr = sg_dma_address(&sg[j]);
  1180                          sge->length = sg_dma_len(&sg[j]);
  1181                          sge->lkey  = t->pd->local_dma_lkey;
  1182                          msg->num_sge++;
  1183                  }
  1184          }
  1185  
  1186          ret = post_sendmsg(t, send_ctx, msg);
  1187          if (ret)
  1188                  goto err;
  1189          return 0;
  1190  err:
  1191          smb_direct_free_sendmsg(t, msg);
  1192          atomic_inc(&t->send_credits);
  1193          return ret;
  1194  }

regards,
dan carpenter
