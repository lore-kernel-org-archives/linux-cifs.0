Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,BIGNUM_EMAILS,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D77C4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 12:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D77206D5
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 12:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgLQMWk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 07:22:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50618 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727647AbgLQMWk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Dec 2020 07:22:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHCEkDJ050327;
        Thu, 17 Dec 2020 12:21:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=os7HSh3TrqMQhL4Kqdceu+f1OMhxMalIlzlxIlQ+z/I=;
 b=lasrow5vPFMzvpoZ3Do7G5ctpC2xQ+Go0epII02FukAso0pboa2p1kXN/93UFnlspblC
 YXw4fTKl/Ep5cG03Rf+gRXUH5oWSjNUjw1bDQad4FHAmWG4vC8D5b4yNMj5p7vOehPVK
 KR4HgTgg3VcnoiVP6P2JhG1WD5WerQiEOIBs8/YlGXVCZ0DxlH+rNhJr9h+2YTqqA686
 e9KxfU9sHGzjSU6aq0Ke0nu3hfOuBA1L+aDAM6v5yFGCUwTZtsfSyTTjD+XekREsRIb+
 oMGpS+wArZTD/6SIu8xir8sOaF4lT4Mfq/1WA8uG7/06H1drtG2GavzfdPz95wEaKI2V Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35cn9rn45w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 12:21:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHCAHiX001523;
        Thu, 17 Dec 2020 12:21:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35d7t095df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 12:21:56 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BHCLrIx007803;
        Thu, 17 Dec 2020 12:21:55 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 04:21:53 -0800
Date:   Thu, 17 Dec 2020 15:21:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     scabrero@suse.de
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: Simplify reconnect code when dfs upcall is enabled
Message-ID: <X9tNXBJunTCYCoSw@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170089
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Samuel Cabrero,

The patch 7d6535b72042: "cifs: Simplify reconnect code when dfs
upcall is enabled" from Nov 30, 2020, leads to the following static
checker warning:

	fs/cifs/connect.c:160 reconn_set_next_dfs_target()
	error: 'server->hostname' dereferencing possible ERR_PTR()

fs/cifs/connect.c
   128  static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
   129                                         struct cifs_sb_info *cifs_sb,
   130                                         struct dfs_cache_tgt_list *tgt_list,
   131                                         struct dfs_cache_tgt_iterator **tgt_it)
   132  {
   133          const char *name;
   134          int rc;
   135  
   136          if (!cifs_sb || !cifs_sb->origin_fullpath)
   137                  return;
   138  
   139          if (!*tgt_it) {
   140                  *tgt_it = dfs_cache_get_tgt_iterator(tgt_list);
   141          } else {
   142                  *tgt_it = dfs_cache_get_next_tgt(tgt_list, *tgt_it);
   143                  if (!*tgt_it)
   144                          *tgt_it = dfs_cache_get_tgt_iterator(tgt_list);
   145          }
   146  
   147          cifs_dbg(FYI, "%s: UNC: %s\n", __func__, cifs_sb->origin_fullpath);
   148  
   149          name = dfs_cache_get_tgt_name(*tgt_it);
   150  
   151          kfree(server->hostname);
   152  
   153          server->hostname = extract_hostname(name);
   154          if (IS_ERR(server->hostname)) {
                           ^^^^^^^^^^^^^^^^

   155                  cifs_dbg(FYI,
   156                           "%s: failed to extract hostname from target: %ld\n",
   157                           __func__, PTR_ERR(server->hostname));

This should probably just return here.  I don't totally understand why
this is a void function...

   158          }
   159  
   160          rc = reconn_set_ipaddr_from_hostname(server);
                                                     ^^^^^^
"server->hostname" is dereferenced inside the function.

   161          if (rc) {
   162                  cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
   163                           __func__, rc);
   164          }
   165  }

regards,
dan carpenter
