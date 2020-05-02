Return-Path: <SRS0=2HAQ=6Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FC1C3A5A9
	for <linux-cifs@archiver.kernel.org>; Sat,  2 May 2020 13:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B74152192A
	for <linux-cifs@archiver.kernel.org>; Sat,  2 May 2020 13:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xxgq17iV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgEBNbu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 May 2020 09:31:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50504 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgEBNbu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 May 2020 09:31:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 042DOEaN083172;
        Sat, 2 May 2020 13:31:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=oJ21pikg6sWLXpLwXNqHwEUgFVAoqj1IbfmwHeKlvCQ=;
 b=Xxgq17iVyM3KavHUjdglZ3wXtN/FXa6s4EbllQswaPKtpCwFH2RmSwwa9F9G9yZ/nFoh
 p69qteX+yywx05FlQIgIf4CENh/QylcKpNzEtV1M3nSp/S4qROj82ZR9qpG9LrTDrlsW
 H0krsysiTbLjxQn7rqxMiOdieZeoDdhV2fH9ACGblwH4L47k3EYblb+wrMc/h/thrrFZ
 fqEwR4r0uaK+I1ZE1nCJcghvRm0rcSR1kuwohW/xD/y84yv4TGy3wiVLZffXNLXoD4RL
 GSzDBuLJveZkl7YYUa+jPX3oZy+NBtaxgZVrJ0naCdZWMlTnigpM8WOFgCL2pW6VFUnT BA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30s09qs64m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 May 2020 13:31:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 042DMWQB045942;
        Sat, 2 May 2020 13:31:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30rxw9c3ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 May 2020 13:31:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 042DVi8I005773;
        Sat, 2 May 2020 13:31:44 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 02 May 2020 06:29:40 -0700
Date:   Sat, 2 May 2020 16:29:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     aaptel@suse.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: multichannel: move channel selection above
 transport layer
Message-ID: <20200502132935.GA41736@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=3 adultscore=0
 phishscore=0 mlxlogscore=806 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005020120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1011 suspectscore=3
 priorityscore=1501 malwarescore=0 mlxlogscore=846 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020120
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Aurelien Aptel,

The patch feeaec621c09: "cifs: multichannel: move channel selection
above transport layer" from Apr 24, 2020, leads to the following
static checker warning:

	fs/cifs/smb2pdu.c:149 smb2_hdr_assemble()
	error: we previously assumed 'tcon->ses' could be null (see line 133)

fs/cifs/smb2pdu.c
   120          shdr->ProcessId = cpu_to_le32((__u16)current->tgid);
   121  
   122          if (!tcon)
   123                  goto out;
   124  
   125          /* GLOBAL_CAP_LARGE_MTU will only be set if dialect > SMB2.02 */
   126          /* See sections 2.2.4 and 3.2.4.1.5 of MS-SMB2 */
   127          if (server && (server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
   128                  shdr->CreditCharge = cpu_to_le16(1);
   129          /* else CreditCharge MBZ */
   130  
   131          shdr->TreeId = tcon->tid;
   132          /* Uid is not converted */
   133          if (tcon->ses)
                    ^^^^^^^^^
Check for NULL.

   134                  shdr->SessionId = tcon->ses->Suid;
   135  
   136          /*
   137           * If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also would have
   138           * to pass the path on the Open SMB prefixed by \\server\share.
   139           * Not sure when we would need to do the augmented path (if ever) and
   140           * setting this flag breaks the SMB2 open operation since it is
   141           * illegal to send an empty path name (without \\server\share prefix)
   142           * when the DFS flag is set in the SMB open header. We could
   143           * consider setting the flag on all operations other than open
   144           * but it is safer to net set it for now.
   145           */
   146  /*      if (tcon->share_flags & SHI1005_FLAGS_DFS)
   147                  shdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
   148  
   149          if (server && server->sign && !smb3_encryption_required(tcon))
                                                                        ^^^^
Unchecked dereference inside the function.  There used to be a bunch
of checks for NULL "tcon->ses" but some of them were replaces with a
check for "server" instead.

   150                  shdr->Flags |= SMB2_FLAGS_SIGNED;
   151  out:
   152          return;
   153  }

regards,
dan carpenter
