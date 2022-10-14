Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A766AC433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Oct 2022 09:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJNJh6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Oct 2022 05:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiJNJhz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Oct 2022 05:37:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B301C19EA
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 02:37:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29E9U21S009393;
        Fri, 14 Oct 2022 09:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=rCf/peHR0ChGb4dznYdel6ntmiDIPbsVmGJvScrSzvA=;
 b=hfX2jJW+2lzn9T5YSCSIsiCDsc+m5dry6tdWK6Et1AnMqfg7pikuQFM4xwX48l24ZcGO
 Ccp8R8DaubN0nC9+VIZMfWtTA82gooQGLzUSYOrv+7TecaBgQmcPaQP6IhaJNTIBIN3J
 hzW0fDMvAi7AtMRbGimqQl0bLuh7yrgOkOceSuelwYlpZre7fopcsKbET3ANpboQE85m
 Z9d+fdiDBOZCu1Rry3gMIgTOWFiEqEYSutc7OlSEKnAdbORPn5Ed+WVqUdbmnpRWinnN
 HW1syJM7SyC7z2W/3gcZLD69QH5rr66NJRRWhYs4Loz3Y2YYisk40ZhiUfKga7QiLBY5 Pw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k6mswj9ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 09:37:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29E6nRJl018260;
        Fri, 14 Oct 2022 09:37:47 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn71rcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 09:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAgK0P4xwvfiRaJXmXFRfSjmPaC8QddXrCSg9dvn0sfKrZknNia/fhG+ywbiSahieOnv1dLLWKpvfVP5WDlSaD3w4NkkSVSCL8IujwauiZhNoecfX6KJjGPYdHrIr/2VYsHCXwq3b/VoNUIaDSEsohxbpQf9X6WxTYneEOhyRdKXrL3xgfHohSnMGMsF/8BZ+FLN8ojzhZNUgbD4UOsLeWkpuJcCKaMiB3UFaaiMfqgPLuSriXbrrvwSJcWJMV2chw6/WKt0PtXg7KI1+/ZJvCDJjSmJPvJswl+EQ1M/K0a4dSuKBJYW+cnWRjyjp+8NJ/0lW6OzgXQLLbtB0x+B6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCf/peHR0ChGb4dznYdel6ntmiDIPbsVmGJvScrSzvA=;
 b=atgh2acBUsT9kBIlxvpDjboU5k8AZv9UZjWUpGR6S6qbu7Fq7C0Wd/WkzbwhHbxeZ6EqRccYl1+Nmwu3WFnsQrS/y9ZKs8MLQPBflU1gl8hg/hdXtRjagMeYxwc/FpwBqpNOk6eYKwPavBuQWo0KoxHa+5e5Ff+v+XBOVmml8F6MyLPt6rldd7MskjJRCekwNRvGpB40Ag1OR5aWNYBLJ8P+d5F2PbWJz2hp4n5WOBpi89lxEcUr8TTI++iQeAyQMwHucS5kSDkgZ4pO3dK73Dh0gN0x6H0tGFx562OgXWQFZMNejUoiei82i6Du/JXSe2HX5dE0oB58rCz++OR88w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCf/peHR0ChGb4dznYdel6ntmiDIPbsVmGJvScrSzvA=;
 b=evIYJvIYoa2IhllhaIG81IgeJ/0gx6Gb5359kDI+cOkjNvMpHlIR0BcTphAL4WOQObt4vL2xapuMBaoHGJmVK2U8xLlIzzJXpNhEshdzYJ0lza1KIOw0cmVHeaK9pqV0dtXYoWSyc2EUlTGVL+szIModHf+niASH8g3EldcMJgc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4531.namprd10.prod.outlook.com
 (2603:10b6:303:6c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Fri, 14 Oct
 2022 09:37:45 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Fri, 14 Oct 2022
 09:37:45 +0000
Date:   Fri, 14 Oct 2022 12:37:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pc@cjr.nz
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: improve symlink handling for smb2+
Message-ID: <Y0kt42j2tdpYakRu@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0060.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::11) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CO1PR10MB4531:EE_
X-MS-Office365-Filtering-Correlation-Id: 665a429b-a1c7-4155-f1ee-08daadc7bff5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SFoHbqbws2pjMzU+dmyW4CWkYCCnt6SginJeZjia5jn/E/nAFFrHrqaSTAL5wohFx7UTHbdwGURaILlfWB24zPMgIeswzUN1E7DAu0kOiu4sfFNoeJn4JlKBhtklyPr06oqkj/+ptY+/U6PFyy7W5Asm7M99q3Y1OlNLZhlnAv0Gu6aOgsM83Rlqk/SAYXRvUhR2IvaMpVYHr70Hg8VjwsLtvQxJz5EhWk2e1itY8LWKxcn94MFyLdaaRts/F8/uooCr42nTKxJEaSPROgGDQzN594e3nl8k8f8e301A5vojvsOqd0kdOeZEiJtD4ZAf4VUXTAe+aHCmY0lQXyA9AaX40zn+P65+SKMnXxdTY/7a34WUOZas9cvLL+qZk3M1B09lYsXDtF4H+bbikgO7oJlyxWqa52kJK5Qbxx6YwVZUrgn2MQHevuHZtMlHd7XEUFNeXOtujqKM/YR6AInajMpi983k47kEERLrYOTEQaioJCJWs6QPa6qeOUSscnCHdFqh86+wGCKHnqm30a1MFNPzMPDSl3xaTEVzHVbMwgbjK0tUUYq8a/WFSKN/DbJbPNmhYyMEgC0uMImC7QZsbOKgMSCH/IeaCyYzPiS+rhSBm4ERzM6k5P5GChUyIvk8VU8GpnhGn/FxaCmrw28JGHgUEwo3I7Gd1ZZQFjYJJ1ImlFlyAqmHTPOA0lRiOjQINHQucjalP6cktLcokGDcFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199015)(86362001)(2906002)(38100700002)(5660300002)(186003)(9686003)(478600001)(66476007)(66946007)(33716001)(66556008)(316002)(26005)(6666004)(8676002)(8936002)(44832011)(6916009)(6512007)(41300700001)(4326008)(6486002)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jIOoXywUc+xDyLcG6f0sdAlZbMQ1A3JduHP4nvDp9m4JBmUpzW9Sny5GYMrl?=
 =?us-ascii?Q?nLZGfk3dRke9QVzaFm6wM8n8K/X6pqboK33PTW3IKlco/CWWCDwX4dXA+gcx?=
 =?us-ascii?Q?pvSrc+D8Ah1bSnBi6d9/oLruwuh4OsrgXZ3LVQ6gif0FQr25Jh27CLyOA2DT?=
 =?us-ascii?Q?ZIAlQ8SuRxB/aNaUHXPVKrFnksyS28I35V6VrHX93iSabLIZ0lihSVmCE5d6?=
 =?us-ascii?Q?a1YzyX6vbj0rjN7BqGfVSlDm9NbT3AGYn6hZOztKMX7jKBF+HDY/ZLFetTwg?=
 =?us-ascii?Q?gBeZUX7YJ97rMF4g3IZKnkDeDCc2CiPgw0UAdyfAru18smzpcjqizNqXrhFl?=
 =?us-ascii?Q?d2P6PryCUIpeXOG/oc8Nub0IgMP8ejf2ULijMhbbfL/XG0mlXMHZkgnmVPs0?=
 =?us-ascii?Q?pm3q5hbBv0FwGzarIqXbGPLwuUabirmJkT4ABkwGOK3XA4GLacRfZM7uT7Qe?=
 =?us-ascii?Q?XEzWzlQJ8nouAd0Z1uj1qpSUBOquWfK1vqHNs4HHxuednYQT7fenyEH5IzBS?=
 =?us-ascii?Q?ng122MoLKOfZExPu+nlBdieazGeK1QxOIdXyDjKmjlSCHDdNLQvqiSu2mUzS?=
 =?us-ascii?Q?lWv7wDbbKIyC0fVzN0fxcqVYTRWghxBUMrN4sZ3ELWycGPaEu0oE8Ok3XGoM?=
 =?us-ascii?Q?rxPCJAcbiAU6FhJeT3kccBOssqxOnUHlXpvuICYE96Nog/yiI92baZc9hlCb?=
 =?us-ascii?Q?qHAI/W//sG7pWz3q7N3Sv5BnDER/YLCSHENao8BR3dnGlS9+F++GbCEwSpuc?=
 =?us-ascii?Q?LqIhxB1ovGihrKa6eeRza5aRv52WwdJwYvRRJ+6B8WJxAmtNCJTnxlgxM0qv?=
 =?us-ascii?Q?6rUe6VadbXeQB3yUq/Ki4H++ZPm4dBaIDD40+wWna8JoeCXXt4wJY33Yagla?=
 =?us-ascii?Q?VXs4w4/E+wC/57ynt1IcSXSptU4ApblRorvByoxVsLmd0z5fBMFinYrSySwL?=
 =?us-ascii?Q?qh7pQ56p+eUrxnRbmFiHM8RlhKdIQ11hTeDB6Lql514S7vdbl3cuPBVpx0wI?=
 =?us-ascii?Q?btemVpyc2g8LIHXIGvuRo3ffOw6z3Gu1Yowm+OEifioZZeCjq6IpRg2zQ3tn?=
 =?us-ascii?Q?oZCHe5cMf43Guqon01E+cFWtJJ8c8wu8amtJ+SwfxArUjp2a4r02V5m8fn0j?=
 =?us-ascii?Q?EIN5NaO2ptQXlwsus2AhCjrdvHzgfrRN7WPVohrwztLX5ZXF24sO7eCqCl4l?=
 =?us-ascii?Q?HNENXQXAiguB0OVlnODxyS2M9WXpvJ08E1wf8vheMNqs4GpvLWw8bonhkOrR?=
 =?us-ascii?Q?/WgUvlONhjdCkwpomFHjaDFX2n3Jri/j7p7zqCjSdl3LZw6kMoNekydCuhiq?=
 =?us-ascii?Q?B+/biq5/U0ZpH8mtE8szfqAGmSK+cU0huOdv9EMhgXA2mel8ShfPWwyRWGen?=
 =?us-ascii?Q?APGxjpM5weur/og2CkbsOMSYXKYpF4Fveax5Ma506sEx0uQjIpR1LrKE7SuX?=
 =?us-ascii?Q?f0K4tk6+4s49K/XeK7pz90uNOWNR0tTmsWQkhh95Q8qkFo2h4UJmsPkMUYqg?=
 =?us-ascii?Q?v8oaOwlk2nsCXOeIlnZnDGOVbFcNO4y258WvcKS+2MkFyXAuWn5wTzCqDtxs?=
 =?us-ascii?Q?FjIbZ+o6ffoz/UMAFo6RZxYVbX+DqTjRTCXNXyjSdayeRw9E1aYuS7yy7v7N?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665a429b-a1c7-4155-f1ee-08daadc7bff5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 09:37:45.8416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3QDIBcZM94VQS9O8YJfmotqnMvfxd9iu09NEUjqjVMKM9fycWOYioDaZ5YUE0PFJi9hzXmB2FKBrOMjNunhhV5vnAYAoOoeTeTZZ2xPdzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4531
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_05,2022-10-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=589 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210140054
X-Proofpoint-ORIG-GUID: TY7ZYNxnJ37_RDCeO2HYFtKpsI40pyJr
X-Proofpoint-GUID: TY7ZYNxnJ37_RDCeO2HYFtKpsI40pyJr
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Paulo Alcantara,

This is a semi-automatic email about new static checker warnings.

The patch d87ee26fa912: "cifs: improve symlink handling for smb2+"
from Oct 3, 2022, leads to the following Smatch complaint:

    fs/cifs/smb2file.c:126 smb2_open_file()
    warn: variable dereferenced before check 'oparms->cifs_sb' (see line 112)

fs/cifs/smb2file.c
   111	
   112		smb2_path = cifs_convert_path_to_utf16(oparms->path, oparms->cifs_sb);
                                                                     ^^^^^^^^^^^^^^^
The existing code dereferences "oparms->cifs_sb" without checking for
NULL

   113		if (smb2_path == NULL)
   114			return -ENOMEM;
   115	
   116		oparms->desired_access |= FILE_READ_ATTRIBUTES;
   117		smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
   118	
   119		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
   120			       &err_buftype);
   121		if (rc && data) {
   122			struct smb2_hdr *hdr = err_iov.iov_base;
   123	
   124			if (unlikely(!err_iov.iov_base || err_buftype == CIFS_NO_BUFFER))
   125				rc = -ENOMEM;
   126			else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK && oparms->cifs_sb) {
                                                                             ^^^^^^^^^^^^^^^
so presumably this new NULL check can be deleted as well.

   127				rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
   128								 &data->symlink_target);

regards,
dan carpenter
