Return-Path: <SRS0=DBI+=XB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D464C43331
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Sep 2019 08:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21F89206A1
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Sep 2019 08:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NzAtL3Vc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389348AbfIFIOC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 Sep 2019 04:14:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41344 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfIFIOC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 6 Sep 2019 04:14:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x868BYEv125773;
        Fri, 6 Sep 2019 08:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=h6Rc1Ds301Sgr28eazGq6E6RakDt6Goc6czUYrV8E0E=;
 b=NzAtL3Vc46uo8vqRs/908IF9cRmXvIuy2zdStdz/fZ4pJLfIgzUxJBrVvBb8UMRVNDNP
 iBe4hJAxjw+iG66amHvLX5bwHewbyEAVvyGJy2I3euq9RRQJX7I3SzQO1i48O9N076MG
 ph7IMtPqRrYAw8mhjlQ6F1FjPnno7MStmuEsyAMx3flNO3eNmT8caMCfm4eALmLdz4Cd
 0eEnNzsdEElUDKHIPKNu9TkbKvq+M6TKZKLJDun8S+W3vqKsL5vlW4m9dr/HiAJb9Vwt
 sTt0EboVt1b/VQ4OKYB3+P9e2AOW2Xp91kHvUvoxCz1ZnVEO1LKqxLBRVWFw6hqB2NfI qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uukqp809j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 08:13:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x868DNQC117535;
        Fri, 6 Sep 2019 08:13:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2utvr4vswg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 08:13:23 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x868DETf030586;
        Fri, 6 Sep 2019 08:13:14 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 01:13:13 -0700
Date:   Fri, 6 Sep 2019 11:13:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     kbuild-all@01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 15/15] fs/cifs/transport.c:1247 SendReceive() warn:
 variable dereferenced before check 'ses' (see line 1245)
Message-ID: <20190906075655.GH3093@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060085
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   2808c6639104c5aea1fccdf692deab0ccf00914f
commit: 2808c6639104c5aea1fccdf692deab0ccf00914f [15/15] cifs: add new debugging macro cifs_server_dbg

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
fs/cifs/transport.c:1247 SendReceive() warn: variable dereferenced before check 'ses' (see line 1245)
fs/cifs/transport.c:1342 SendReceive() warn: inconsistent returns 'mutex:&ses->server->srv_mutex'.
  Locked on:   line 1249
  Unlocked on: line 1284
fs/cifs/transport.c:1342 SendReceive() warn: inconsistent returns 'mutex:&server->srv_mutex'.
  Locked on:   line 1284
  Unlocked on: line 1249
fs/cifs/smb2pdu.c:2763 SMB2_ioctl() warn: variable dereferenced before check 'ses' (see line 2762)
fs/cifs/smb2pdu.c:3067 query_info() warn: variable dereferenced before check 'ses' (see line 3061)

git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
git remote update cifs
git checkout 2808c6639104c5aea1fccdf692deab0ccf00914f
vim +/ses +1247 fs/cifs/transport.c

96daf2b09178d8 Steve French    2011-05-27  1235  SendReceive(const unsigned int xid, struct cifs_ses *ses,
^1da177e4c3f41 Linus Torvalds  2005-04-16  1236  	    struct smb_hdr *in_buf, struct smb_hdr *out_buf,
480b1cb9dad894 Ronnie Sahlberg 2019-03-08  1237  	    int *pbytes_returned, const int flags)
^1da177e4c3f41 Linus Torvalds  2005-04-16  1238  {
^1da177e4c3f41 Linus Torvalds  2005-04-16  1239  	int rc = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1240  	struct mid_q_entry *midQ;
fb2036d817584d Pavel Shilovsky 2016-11-23  1241  	unsigned int len = be32_to_cpu(in_buf->smb_buf_length);
fb2036d817584d Pavel Shilovsky 2016-11-23  1242  	struct kvec iov = { .iov_base = in_buf, .iov_len = len };
fb2036d817584d Pavel Shilovsky 2016-11-23  1243  	struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
34f4deb7c56c6f Pavel Shilovsky 2019-01-16  1244  	struct cifs_credits credits = { .value = 1, .instance = 0 };
2808c6639104c5 Ronnie Sahlberg 2019-08-28 @1245  	struct TCP_Server_Info *server = ses->server;
                                                                                         ^^^^^^^^^^^
Dereference

^1da177e4c3f41 Linus Torvalds  2005-04-16  1246  
^1da177e4c3f41 Linus Torvalds  2005-04-16 @1247  	if (ses == NULL) {
                                                            ^^^^^^^^^^^
Check

f96637be081141 Joe Perches     2013-05-04  1248  		cifs_dbg(VFS, "Null smb session\n");
^1da177e4c3f41 Linus Torvalds  2005-04-16  1249  		return -EIO;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1250  	}
2808c6639104c5 Ronnie Sahlberg 2019-08-28  1251  	if (server == NULL) {
f96637be081141 Joe Perches     2013-05-04  1252  		cifs_dbg(VFS, "Null tcp session\n");
^1da177e4c3f41 Linus Torvalds  2005-04-16  1253  		return -EIO;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1254  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16  1255  
2808c6639104c5 Ronnie Sahlberg 2019-08-28  1256  	if (server->tcpStatus == CifsExiting)
31ca3bc3c569f9 Steve French    2005-04-28  1257  		return -ENOENT;
31ca3bc3c569f9 Steve French    2005-04-28  1258  
^1da177e4c3f41 Linus Torvalds  2005-04-16  1259  	/* Ensure that we do not send more than 50 overlapping requests
^1da177e4c3f41 Linus Torvalds  2005-04-16  1260  	   to the same server. We may make this configurable later or
^1da177e4c3f41 Linus Torvalds  2005-04-16  1261  	   use ses->maxReq */
^1da177e4c3f41 Linus Torvalds  2005-04-16  1262  
fb2036d817584d Pavel Shilovsky 2016-11-23  1263  	if (len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
2808c6639104c5 Ronnie Sahlberg 2019-08-28  1264  		cifs_server_dbg(VFS, "Illegal length, greater than maximum frame, %d\n",
fb2036d817584d Pavel Shilovsky 2016-11-23  1265  			 len);
6d9c6d543165d1 Volker Lendecke 2008-12-08  1266  		return -EIO;
6d9c6d543165d1 Volker Lendecke 2008-12-08  1267  	}
6d9c6d543165d1 Volker Lendecke 2008-12-08  1268  
2808c6639104c5 Ronnie Sahlberg 2019-08-28  1269  	rc = wait_for_free_request(server, flags, &credits.instance);
7ee1af765dfa31 Jeremy Allison  2006-08-02  1270  	if (rc)
7ee1af765dfa31 Jeremy Allison  2006-08-02  1271  		return rc;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1272  
^1da177e4c3f41 Linus Torvalds  2005-04-16  1273  	/* make sure that we sign in the same order that we send on this socket
^1da177e4c3f41 Linus Torvalds  2005-04-16  1274  	   and avoid races inside tcp sendmsg code that could cause corruption
^1da177e4c3f41 Linus Torvalds  2005-04-16  1275  	   of smb data */
^1da177e4c3f41 Linus Torvalds  2005-04-16  1276  
2808c6639104c5 Ronnie Sahlberg 2019-08-28  1277  	mutex_lock(&server->srv_mutex);
^1da177e4c3f41 Linus Torvalds  2005-04-16  1278  
7ee1af765dfa31 Jeremy Allison  2006-08-02  1279  	rc = allocate_mid(ses, in_buf, &midQ);
7ee1af765dfa31 Jeremy Allison  2006-08-02  1280  	if (rc) {
72ca545b2d83ac Jeff Layton     2008-12-01  1281  		mutex_unlock(&ses->server->srv_mutex);
                                                                              ^^^^^^^^^^^^^^^^^^^^^^
This isn't a bug, but Smatch wants you to use "&server->srv_mutex"
instead of &ses->server->srv_mutex.  They are equivalent.

7ee1af765dfa31 Jeremy Allison  2006-08-02  1282  		/* Update # of requests on wire to server */
2808c6639104c5 Ronnie Sahlberg 2019-08-28  1283  		add_credits(server, &credits, 0);
7ee1af765dfa31 Jeremy Allison  2006-08-02  1284  		return rc;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1285  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16  1286  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
