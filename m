Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACBDC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 10:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B19F61371
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 10:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhJDKrt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Oct 2021 06:47:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16890 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhJDKrs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Oct 2021 06:47:48 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1949eC12009321;
        Mon, 4 Oct 2021 10:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=/5l8KNFKE7e80woJgB/ROOBNb98tXoEpVtUGpKlxMeE=;
 b=toYIKxEixAvW57+7uuZcgikS3/XU9XmZdmcZNSa5zAhYOZgqA25EEMk3IQelrwGRAUYk
 9n+3PqRlBT+SHl7Bfhy8TtLfAsgAqARPokAdXcnIWl/PkT76Zmq+c2cinPUTTAWVRxTz
 9PIDA7u7zO7xrSZmbfmQhM9YQykof302YVmTk2VNe1rChDAXpfOSqZ2hTRLV3GFG8dwP
 TxIz4ttCqcoZy2vWHTXGDXJHIbGz1RvhBmHR6btubbCjbo4F9tL5iWdqwxBJY9x5goTz
 69xHtpxrsfNqAquwVEyf36C/uLpnu0O8SgzILw9/6FTP7Sx9YlwAhAh+4fwFtNW+4OD9 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bfbatu59h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Oct 2021 10:45:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 194Aibae146373;
        Mon, 4 Oct 2021 10:45:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3020.oracle.com with ESMTP id 3bf16r7h9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Oct 2021 10:45:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXTGhPsaVxeZLchEKXwQTMdesnlTzmzhVR7jwYCDgOrjKirO+yk4NMV1ijeUB+O88eP0heB7DDYHRt7kzYBQbBEGduTLgNPqnQaBfvcD2v3rdIcz/oOtdnaCt1z53dR5EQX6NeWIUqDZBZ1iOfuLUG5bD2IFqptG/KYJiGTQl6CMvt/PycflKDxB++EdIY+Tv2LXicQaE51UszE/SSYGL8yb/BseJAdZOYowol3bNXYrp7jOtvmDR9MX4l/Ha+fWwNLJTEZeaJPcqEJiwr4E4FsIFnAYdo78cw/LIfZbjNUTWE0szgs05nD76v54li2preLSn7KRs7wgV2V26BTi3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5l8KNFKE7e80woJgB/ROOBNb98tXoEpVtUGpKlxMeE=;
 b=Sb2gpjdz95cnkGFgo0RGyrMP4sUXCIcptZKXHO18Pyxb6KnLO7rN/t+NqqQHPGHkMkHmK8Dbe8pX1uCRw0Xtv93Jw+j5/NuWT+ObNhyMIxJRGsyx0MNMJdRAahttm95VU+3zh1cerKwURN8IbKHtloVys9nuuuLSPgnvhdJzfdMeYIIdT7a//sAGE6WgrluNXFmBiBMfRN0803sjZm0QgVMUthlhKasXF9DBD7ROsdEBbrdB6kynAEDRFyjLH4O+TRy+u0VdSi6BC9uNZ+99TL3xFVqb6MgH5CncxIqYl7xqB2HKo/ZvIv0b18Oy0ElMWW/JU2iVLYBTewN34qSPpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5l8KNFKE7e80woJgB/ROOBNb98tXoEpVtUGpKlxMeE=;
 b=icnYWe07l4AsfT9UO+F9TBtYSSxVLldPJFyInM68Gj1TIYebAKNu4Z5TFDU+CYib8NNNSWJp16cF2aRSeSW3hYdXJTK8kWt0uJkGgzqdhdsdXaiGIOa7MxkWWCLhAePfBlFQqDQvpQ6Pv+82NugjZWharX07HtYawv+HH8wBsQw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1567.namprd10.prod.outlook.com
 (2603:10b6:300:25::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Mon, 4 Oct
 2021 10:45:54 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 10:45:54 +0000
Date:   Mon, 4 Oct 2021 13:45:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     linkinjeon@kernel.org
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] ksmbd: add validation in smb2 negotiate
Message-ID: <20211004104544.GA25640@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19 via Frontend Transport; Mon, 4 Oct 2021 10:45:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9668d724-1456-4521-5613-08d98724241d
X-MS-TrafficTypeDiagnostic: MWHPR10MB1567:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1567EBA1AF9E8BC795CA366F8EAE9@MWHPR10MB1567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: id+t5MzWkL5W/g+08nZBN3vwNeKmb2nSlZX1B/4O1u3Oh3ZtFg4RHvtXgORsjzhsy+M1SiyamQnu41EbWtdwPOIF+ARmc2T59LurUuuThW2OE9qgTjZt0U0WsgW1RxQBtaPtqmRI15jawevBqy+Gl1RumxRsTXGzD/f01h9FbUnlQuOIdTtf3UwuraqtHJTVoldWQcGqNkQWkVkCRxjsylUEcGfFlLNcSQ4fhNG0aMHn3kJCEVgHb520QrFSsZOkCjS4YlY2TPwdKi0TGHLHScijAIYF9SXsmhxhgPJyGvqBguiqG6FXgcNSE9GM1zbN9wnNM6sFkePQdrN1O8DsUgU1x+ivfBskPDZRQskVll6pe1TBhSf/3R1yycCm9ZMJSFsz7XYO/gv46dezeIIFEE7djIrJES87qeVeMXo3NWVs7Y7ZvH+nvX+EEjPqjJck3kyzM9eIOFYRwM/UVE+6NlriE1JdqXHLUaIHgewcnxcg5REjV3VHZ2vMgbyJLPrs8h/CyAoom17jjIaY8gkR9gaMs/ET1kY3Kw5n0I+RSeW1T03ydgEWD/r6a+D9FZuTl8eAp3dbAo/Daupv6fmX/5SC2eN66kHRDjAWsRVNZtQQ3OvKkLW93PPWxar+Wre3TeDST+Z2hr+p6a23+ofJ7hx5gfuOIBw1PsDgFPBoDELdi6ry9uWpnUPqwXQAXHeSKjrpmbkhzTs2mrNFp+qaTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(33716001)(38350700002)(38100700002)(1076003)(186003)(26005)(83380400001)(956004)(6666004)(2906002)(8676002)(316002)(52116002)(9576002)(66946007)(66476007)(4326008)(33656002)(6916009)(9686003)(55016002)(508600001)(6496006)(8936002)(5660300002)(66556008)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rc4V9s9H5wTJ9aTdsi8pq9ugFnQtoBEM7KJnQX9YrTm9N/QW2Ie1VXVr2vrq?=
 =?us-ascii?Q?6v9SZUjig3VvaZimrgHbrgZMGgorI7nPLaVTA3pYuTi/ymCjWCM2NivXZPU6?=
 =?us-ascii?Q?O4XM3TstUgEMj7tdqIj85UIRiB0W6j55oIuxQS5+DW1HjZ5kNXhsCgZMAaA8?=
 =?us-ascii?Q?OMwUIiIQBrbocWOeDF7RrCFx6ED2sEZDW9mDkJ6haIm8g343CpFDMc6GdQM2?=
 =?us-ascii?Q?dyPrQkIE6kV05YLOGrg9jzu2N5dMUHJ6GIQC8A8yPJ6ySvwLw6pXQR2WBd+i?=
 =?us-ascii?Q?KL28MNzQJ9lBAf9wN/prsfrTMqeaXUOX5p2Ox2cPmpr3vN3tRzv22ozYMbLg?=
 =?us-ascii?Q?M5jI/PttDyS6RCiN7z4L3NfL4OEWz7C9UBt+xw2me4eU+HttPFRk6BN1Kc6f?=
 =?us-ascii?Q?grPoZY9AFIB6K8jSKImLyckVrjgs0YixhYQQw3Xi2TtPd5Tu7/YDcBzraekV?=
 =?us-ascii?Q?dSZX3MCr85fRVKurYwOqh2pLzzUTOQWnDCXUJf4ktZu7zL7fwTydcJlN7zDN?=
 =?us-ascii?Q?D1fBQFn9Dg1M+4W+I285b2BTxdzatMr8okJd5lonyz1jYimgvKhpNdlPxwVF?=
 =?us-ascii?Q?CGXlscDPTm4p4H7pAAPcjJFpTkEbqiV7jQaRkqeFq58qEMC9cAN+mSDt25FP?=
 =?us-ascii?Q?z6S4fE24ZqhTLtpcFtVRPblMdljq5SC+hYfqMMk6liuUp3mL+uRGxx2QPUuk?=
 =?us-ascii?Q?XdyZTyW3j0ZXrRdbyciYlalt4sajsYWSkU2InHs6kxBYEqxbaEiXm+K9TN1m?=
 =?us-ascii?Q?qGogWS6dMnb11d8CGa0EJiYd3TEWbNIBIiAkQDAu51k+ytQWbEOIGI5+kJnz?=
 =?us-ascii?Q?OaNUhMCgWSnvfdH5bGyz5ebJKJ8KFYCG/kFBOjCJMeoysuVu3zL1KIwlXKVU?=
 =?us-ascii?Q?qyEe3xnAvlNOcrSWKpulkiJVHCQ5k3kvRJxw8E7LXYXWD2Xu6ua/JDar5uye?=
 =?us-ascii?Q?Cb+ObLNN40PsQr0QU+Gdnnsv2abnWIZvOJbqttkHaSRtawkC/YzMUHAXAZK4?=
 =?us-ascii?Q?3dRZJ+/OPOFaHWxLGLnsgerBkaU7Y1na7gYfD8Cwv0lmCVPmQwHHg0KDtrYT?=
 =?us-ascii?Q?KTjATkzNGQTLx895Q4PvYxVNDnGyIlO2bMSD6AEVN1rs7AE8YB9LentTNbbT?=
 =?us-ascii?Q?NlEXn5XIaCkkeOk1tMV/AAbY9bkk0n4BfVb6R7shcGu9jHPK5p7C/y8ra26i?=
 =?us-ascii?Q?Kz01J+fiRWe5v3hrhKFqUQVvj8pxCJH+FhYUr4qQ0c9AQ3F413v7Akaz/sVc?=
 =?us-ascii?Q?NBWKlyw9AGrR8WofVxAjd2VZdursD7xVY3upIKnK5L79V+H7W+dSTSdIXIYr?=
 =?us-ascii?Q?LYFNqXAP9HiQzO+afT8lFlGI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9668d724-1456-4521-5613-08d98724241d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 10:45:54.6888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmsxCjsis+iz81Ysrp6wRS5aHfE9jz+jMo+Aj2KIp4367y6oxNxNrFnum0tGI8apjybQWc0J22yi1p7CjzXQ5boezKzxXHt1te4J1XC4yc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1567
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10126 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=601 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110040074
X-Proofpoint-ORIG-GUID: NdGzPUhY_HKXSrbnqNybXczVSGFUN2nW
X-Proofpoint-GUID: NdGzPUhY_HKXSrbnqNybXczVSGFUN2nW
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

This is a semi-automatic email about new static checker warnings.

The patch 442ff9ebeb01: "ksmbd: add validation in smb2 negotiate" 
from Sep 29, 2021, leads to the following Smatch complaint:

    fs/ksmbd/smb2pdu.c:8330 smb3_preauth_hash_rsp()
    error: we previously assumed 'conn->preauth_info' could be null (see line 8310)

fs/ksmbd/smb2pdu.c
  8309		if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE &&
  8310		    conn->preauth_info)
                    ^^^^^^^^^^^^^^^^^^
The patch adds a new check for "conn->preauth_info"

  8311			ksmbd_gen_preauth_integrity_hash(conn, (char *)rsp,
  8312							 conn->preauth_info->Preauth_HashValue);
  8313	
  8314		if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE && sess) {
  8315			__u8 *hash_value;
  8316	
  8317			if (conn->binding) {
  8318				struct preauth_session *preauth_sess;
  8319	
  8320				preauth_sess = ksmbd_preauth_session_lookup(conn, sess->id);
  8321				if (!preauth_sess)
  8322					return;
  8323				hash_value = preauth_sess->Preauth_HashValue;
  8324			} else {
  8325				hash_value = sess->Preauth_HashValue;
  8326				if (!hash_value)
  8327					return;
  8328			}
  8329			ksmbd_gen_preauth_integrity_hash(conn, (char *)rsp,

But it's not checked inside the ksmbd_gen_preauth_integrity_hash()
function.

  8330							 hash_value);
  8331		}
  8332	}

regards,
dan carpenter
