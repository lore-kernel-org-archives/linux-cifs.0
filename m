Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CE3C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 15 Jan 2022 11:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiAOLtl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 15 Jan 2022 06:49:41 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17450 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229486AbiAOLtk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 15 Jan 2022 06:49:40 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20F1VZQv017361;
        Sat, 15 Jan 2022 11:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=kmrG1Y+4Q59+k/HFXdOBZUalwxgOK28julyJ2ZPnh+E=;
 b=lw865hi5ofxz0nwjvJ7hvHi84hIu1MfGa/JyBvzWl1WqFxkneVuThoJ6zZhrPTWQYBa8
 i/znOp8qI8LqSGHXlf4fTqVc28ZwknV8v1CLNvKjMeDyfq9OY5LEwz4Law3tIY9MFwaQ
 ulum6jyuwXODYBXK1R0iC0+2GnF0pnCxDooCt9VfLSznS8NgP+xNbr4rONdiIAnLk5NQ
 iPZCFRcP1LPRaVhlYCXnHLCL5FsGlOkGRI0b/nnFo7famfvH4+3qHms0Q0sNSsC3KVuy
 p1CNL/DqCWoanP+qdwTkGnRgoH3R6+Q3gUJui5Jvop/R+91xoaj7mOiMsw5G6Juo+Ai8 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dkmpcgj5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jan 2022 11:49:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20FBkiOk067631;
        Sat, 15 Jan 2022 11:49:16 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3030.oracle.com with ESMTP id 3dkma8w086-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jan 2022 11:49:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXWCLlh29/zx3pnF0sNLzCdP88+FbcxhDBpgcSlt3g9kYEvyyZejONi4jMyI24WpKDNC0UVsauGzHAuAtyZPMe0Okec1QoIndbMGhYTFOGxhah0B6U3SyzNTQznYIHDnrbDSkUymkzfBTXj0W4hcmuGTd3PWm0lk4i/BQ2W3G6FogJ01KBRv7nBD34vhMywvwADGN2tBEC9Rign9A3Oxk6RJoGLPiGuBZvD+NDxYlurfYd/OmhIzC8ckef2+dXs3d7tZpC6VHJZRKGeq7uDUiKxD1hgVS2UNAT8kdiA2ae7k1Wt89oJEXTE1CUZxkFpscQNT0PIjZxsps7fjluwD8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmrG1Y+4Q59+k/HFXdOBZUalwxgOK28julyJ2ZPnh+E=;
 b=HePoa8VWaaQ35WakzdW0Sr6s8fol6rS1dpnp5TzziT3KsM5MQVPTL7m2Ore4fbyxY2ivUYK6RXExDymt4fGZnOON4SWSA8LjaIUhfP5gXxTIg9AjeKg+tIKdGKNNqY2vWrNlQetuGb+c03EF0zmFgvHZS6iVZ9QaNqoDuEw5ZHTPgy2AdjA7d7j013O8wUYQRBpEaZcwZqSMfp3UhSj3F/XJMrgxFEoyB6WIZy0Lw+N9dkD9oZprW0dWXf6pLVsPOoeDxSbdsKmuvUPGsnYoqzWrvXYKdX5xzpoNjHwfIKvgQ15h54m2GA1m37hrkmVQ5KhEx13PBc/ytyFFQIxNvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmrG1Y+4Q59+k/HFXdOBZUalwxgOK28julyJ2ZPnh+E=;
 b=fUnnhbo49EYRF06FkrW1nIj+PO9VPFbbU/HmSo7DfwJvv/nm5/NUmJeGhrdbtxxfSAxxKolIa1NpU6i2GkwNyOG9FwlhRZaJBFoOlgR9f/hMC+5jb333gTH5974UsVcyo6OgcP3ApFVH6To0lSiplLiPhrmmYtFyJe0GQJijCdk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Sat, 15 Jan
 2022 11:49:14 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96%5]) with mapi id 15.20.4888.012; Sat, 15 Jan 2022
 11:49:14 +0000
Date:   Sat, 15 Jan 2022 14:49:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: uninitialized variable in create_socket()
Message-ID: <20220115114900.GB7552@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0094.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acb5c70d-dc1e-4c52-26b5-08d9d81d0d74
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2365261E45D059523415A61F8E559@MWHPR1001MB2365.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:172;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B8qL/WjT+BEFZHaAWUGqJZX6r5UyNrNzYc8QMKburSY+THVK+ftVjOKgdLN6KTMYlSRMDu9rXEAV2KhEXSevKw67V6sNplQ/ogFhy4d2ZFPEPiQfpbuPSm7Onm42ZrSRJsUuhdlyD8sKBsIS/yDRKyll7WLo1RZqIXbAC9Fo4Nvnlb+7UqMdtbrGWFgDy5G81Bgz2yerCeKOzJylcf8PBY1WsrGDsHZZewBJQfS0EVebCl287KxJFhZTboi6B9ofkRotLl8EjzqJLCfv+bFrdIqMb7FWkNx4FyVHPrhqTYDJvKtnmQc4dz2eqEEQrQYAEfo8vacequ8TpeyeCC6FD5Q0rNKtE0bS6sMwQW8Udq5s5XceVwl+4J9HtBZy1KXmcJTQQOuOetzwCHDz9bJJUuLRPQns5SnW4nwbrmVHkg2kd3/i9dkBhXu4Ghptp9JF5kUlFrjTh6yQ6/TKBP1eslrnWYyInz42/Epo7nN1fg2G6HrgTKNO6bvAwvpie3qdc86PZ/j3nhFeGWenrTmbfaMLk8ulo3JxTjLF/pc/xFgz/1QCjzuDj+Er64TgyI/P8IlET4wrOpl+ZI86h2PyUd0pohmy977PbBJ9OVqibnwUPkxmAN3/fO26C2uJzk+huEDwIfwbFSGaLYxM44beG7378pobm4m3dQP7/LQtSC1AsrMW4mhQzjFOZwLaMl3M9bHccA7fCJztu9uOySwtSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(6486002)(5660300002)(6666004)(316002)(508600001)(66946007)(4326008)(83380400001)(33656002)(52116002)(86362001)(9686003)(4744005)(6506007)(33716001)(6512007)(1076003)(26005)(38100700002)(38350700002)(8936002)(54906003)(6916009)(44832011)(2906002)(66556008)(8676002)(186003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TTzCGvH6vIIUtnDO0oYS/baq9GukXQh4v4FRV1sKbZRWE4HpRWE9iwDhF9Q9?=
 =?us-ascii?Q?ruXgNl+3+9H8rbvOX8MOAE1lr5JOfsutE/opZGmzZZtNHyAhXwaI6IW0EifM?=
 =?us-ascii?Q?lNzv0bbVN9SvwadIgZGusxCe+KUa1cGk08HRwigvpMtvQ56Rmuw4uI88xzdo?=
 =?us-ascii?Q?PudGhTr1M7SU5obnS3I3ftbsjLCu7p7TTDiboW4sY6bMjaafAVRSW0fxvVXZ?=
 =?us-ascii?Q?t5cF5NuqqT1zWpSqBaZaD2kI9KJiNy/2068ZbBnYsw5TakQUpILVlVkxq+3K?=
 =?us-ascii?Q?adOEDHWKOIN02Z05SV/FvqWec/326JC2Kh67EfiVqTpQ0eNS5f9pUJRy7Jg7?=
 =?us-ascii?Q?HL/IDDV3WcmVWmWYLZmlI+kE2gziRgAr6ARyU2/x1+f/M1+wdAWMFW/dUEVl?=
 =?us-ascii?Q?rTH1iZCV2BJViHCFc2s7uDNXonHoVFm32az/dpqrzOu1rMtM7Gk5A7wBddmz?=
 =?us-ascii?Q?JDaCZ4bbLMocuEqCc1Tuzz3sJPyrrA5oz8jwOstXtDPD29HuJ4jDrzEmyWW/?=
 =?us-ascii?Q?WL1uLRDyu1oOhzkZrND9cTNn4r7OMYeo9hksS0+T6IfTPN96rbS4IbXdejhD?=
 =?us-ascii?Q?ePnUq284ryvfnYdosiHrqmnqXdwW8mFSjKymrNMGAzEKJzhN53U/uTDk1G1N?=
 =?us-ascii?Q?axchbGOEoyAr4+W7lWAxTYOejp8FMCjtVLQDETub6+Vi69DQlACEVHw0CsI1?=
 =?us-ascii?Q?uGIVwF2mWHTwdl5859oLstsXaXqbvaUyEeh5vUlOYDotlNJ+GUJ3wyTDSlj8?=
 =?us-ascii?Q?0N2R9+RRsmAyPAptJeGMu3c8HVpMJYMTjvDj86doPDhK5h4i9O6J8+Y7CgPq?=
 =?us-ascii?Q?v/IT7bwohXwPa0InRAtNuAhc9RYNxJsuvWTsPcMeuEDatv5Khcq5uNeTbjDI?=
 =?us-ascii?Q?k5VnJGSkQrq+fPFfgwf90SaFNN9Cj0RMv36ZIKDFPjf2crlc/kMbrfUyikug?=
 =?us-ascii?Q?pxanzZ2jf8EsbLorwMfpuEetMsdaXhYnJ5Mh6vSu2lxok/PdYxtmEDg+ZkhW?=
 =?us-ascii?Q?h/0ePlVEtq7x+kohtSnSH3pxcKmhcwejGVbG5Y0td2D53GSCMcoyzQYehxOR?=
 =?us-ascii?Q?X+9WSkXIm+9w+2Kwr2+4R5zYxFIfLbcAFmvfNI2HT3v4XQ9R86szq3kyjl/F?=
 =?us-ascii?Q?tS0/Vk53d6VoHvhmq5F41INBOWJ/Z0W40d7clE2wmEYgQzsccbEPO2coN8I9?=
 =?us-ascii?Q?dxqjfsJWmccleYKS+rxtw23IrXIhSHO7/WFq/6ifSO8n0CvPpT+f5SOPIMac?=
 =?us-ascii?Q?PLysK2mzPxVpBL5vm547bw2FOcL458g5llavV2P4LUjRqkLgsbcYuQMxK/WX?=
 =?us-ascii?Q?vyOf3tXGq7vs1wREzqUIKe62hObgzXLaO2lAzF/P2AaZOSAOq4+7rlLxcSLe?=
 =?us-ascii?Q?oR9vzQXEHNY7HjaAJ2KgF6CD+H2PFEaSfK4xA+GeIP3vQ6qphnQvMv4m6ZYt?=
 =?us-ascii?Q?1GYr5GeU3qRvAcAR4r6qNkmcbYsJvvZwHH1V+mKUbZz4B6i/Q1vOZuDeaZOc?=
 =?us-ascii?Q?ANJq7ASpWQqbhOoXNN1TWRHWcYmqZac/aDRf6V+n6Lo7+pJD1QNxS2rNSZX0?=
 =?us-ascii?Q?YnKziWwhqpA2RHRlHc3r3AVbYxJEdhCucyfFIzndJXarRzc0x3qGtyW69tt1?=
 =?us-ascii?Q?Xq9ET6IY029mWr8UQqOu1n29gqtT2HrWAwDoIQXSZT5Cj3UfFZ59cWb0WP6z?=
 =?us-ascii?Q?Uj7kXIpvpBdiz3XvirUqsCUZmaE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb5c70d-dc1e-4c52-26b5-08d9d81d0d74
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2022 11:49:14.2409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B6ekmSM93Ga2yZChNzSB2Ml6b6BHCvpZWFSTEI8MDM3jy8VUQk6TjV1LG6W//o2Oh0YwWb2ig7RAHUDHJxGjTjhDAP6KgI6rX8vWK5d79Ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2365
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10227 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201150072
X-Proofpoint-GUID: hylCZRf_OVYDllB2e7ZYkQH9u5bna_7P
X-Proofpoint-ORIG-GUID: hylCZRf_OVYDllB2e7ZYkQH9u5bna_7P
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The "ksmbd_socket" variable is not initialized on this error path.

Cc: stable@vger.kernel.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ksmbd/transport_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index c14320e03b69..82a1429bbe12 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -404,7 +404,7 @@ static int create_socket(struct interface *iface)
 				  &ksmbd_socket);
 		if (ret) {
 			pr_err("Can't create socket for ipv4: %d\n", ret);
-			goto out_error;
+			goto out_clear;
 		}
 
 		sin.sin_family = PF_INET;
@@ -462,6 +462,7 @@ static int create_socket(struct interface *iface)
 
 out_error:
 	tcp_destroy_socket(ksmbd_socket);
+out_clear:
 	iface->ksmbd_socket = NULL;
 	return ret;
 }
-- 
2.20.1

