Return-Path: <SRS0=oOOd=W6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=BIGNUM_EMAILS,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CE6C3A5A2
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 09:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28A6822D6D
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 09:26:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ny9Miw6u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfICJ0X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 05:26:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47878 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfICJ0X (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Sep 2019 05:26:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x839ODbw039291;
        Tue, 3 Sep 2019 09:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=g09VURui8MAYvzd0z4uLeehvrdr6LJoGWUY3SPzyH/k=;
 b=Ny9Miw6u+Ojtk6KNCjcj/+XIE99W1Fagk9BOAu+omT9OUOXk4r7iJm5fbE8zuII3rc6V
 6f2nSmfpirAWkXmwEso3/8rtWPAfxYIx8HORF74UXP/nzvayDunqwcOLWJB69zMoubgy
 9Uxw3GvYCv4AzzOfC9k8pUNh4Kirb0Bmb64R5gAYthe6jrMNP7KB8NViniLUPfAlv6ww
 EvP9rPIlqfFnDTkJnmnDh5x1BX7YHmVGbnJYcT0gzPkpDV/AFzbxmGBsrb+6HZHjjHHt
 ulqpkloijjcV3RscrI790AXKzoRiCqRfs+/VoCLY1qCfmrc4rMJCyf9xpMmdaRdP2gXq Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2usnfgg10h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 09:26:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x839NkN2143574;
        Tue, 3 Sep 2019 09:26:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2us5pgnhkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 09:26:12 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x839QAtw019988;
        Tue, 3 Sep 2019 09:26:11 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 02:26:10 -0700
Date:   Tue, 3 Sep 2019 12:26:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     lsahlber@redhat.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: add new debugging macro cifs_server_dbg
Message-ID: <20190903092604.GA26395@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=768
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=851 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030098
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie Sahlberg,

This is a semi-automatic email about new static checker warnings.

The patch 2808c6639104: "cifs: add new debugging macro 
cifs_server_dbg" from Aug 28, 2019, leads to the following Smatch 
complaint:

    fs/cifs/smb2pdu.c:3067 query_info()
    warn: variable dereferenced before check 'ses' (see line 3061)

fs/cifs/smb2pdu.c
  3060		struct cifs_ses *ses = tcon->ses;
  3061		struct TCP_Server_Info *server = ses->server;
                                                 ^^^^^^^^^^^
New dereference.

  3062		int flags = 0;
  3063		bool allocated = false;
  3064
  3065		cifs_dbg(FYI, "Query Info\n");
  3066
  3067		if (!ses || !(server))
                    ^^^^
The old code checked for NULL.

  3068			return -EIO;
  3069

regards,
dan carpenter
