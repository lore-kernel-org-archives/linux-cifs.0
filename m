Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A72C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  5 May 2022 10:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355752AbiEEKfy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 May 2022 06:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351650AbiEEKfx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 May 2022 06:35:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4095940A1A
        for <linux-cifs@vger.kernel.org>; Thu,  5 May 2022 03:32:14 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24590n8B027785;
        Thu, 5 May 2022 10:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=WjtLIUgv4ro/sRDdzkXXr8Na0VcVlLYdKKDm1o0b3ig=;
 b=jxo6Qn1Smo8UMgLKXFPQOptdcom7ED8FZocjTQrkieEU6kGb1+NIgBZG1tGvysaUnTxS
 KTa2DZvW0Vj+ckvG7n5zSdpmSWkyCc0gToWn0gA8kJoHlngH5M3p6h54eivV/hOIH/Rp
 RsxcNWP+RICrFqm3B50i6ZTwRX2YGTCq0NL7Fdpeaablm4V1TB4/k3EmeVZLFl02wSCn
 Ls6EM+dLrZB4uNebF87KC+kdvQq+ro6cvXA9B/yjD+qPC46vN0N41No1Dtaeo49dDg93
 LxHpyXdQH89kalwp4n7jnCzYlMdaHzxMv4wNY7aXV/r0+2W6yrlCPhw+es91O/+l+NZn JQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2jx59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 10:32:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245APQus025949;
        Thu, 5 May 2022 10:32:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a6sm0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 10:32:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRa6XKT4pZPDlbxaAI4Am8dalLOdVvSltJAZRpsNEzakWoItctz26Z0WhOquGr1tPYE6dw7/fWoZasn/NnF7u81hz0dTgTLpPiNgHTaKwTrr59vEte5ESsf6vhSoIaAsfuLOPTdBg1hXZg5d4L+SlatHJhbR4Ya3oSsZCsBZzntF6Wq/YRyyWpEUR9xAe5izRlehONSBFbrRxW92Yol12HkKb/xiZXj4WdrfN+d84TPitWNXoZRaB4xDMK2qnmEx/GORjba6reEZtD7jssg7hsnOZ/nsP5DgyyO3TfuJ3lEbG675NLlP58mCOLLA4ScYsxcGbTdYoQXatPbaaNek1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjtLIUgv4ro/sRDdzkXXr8Na0VcVlLYdKKDm1o0b3ig=;
 b=PQ9CDwa7FjQ3RPsBzan3oJ3ry2XbeeXMOyCpuLkFZf8Lrl7IQVhvDOlO77konuZZ8iD9NndqmokQg7I67AoOD6pFmMdI7i3j9zrl6lG68w/BrKMcnhC7Q9o+0Dt07NjAlIcKxquAXyCauknyDmrwwYFuKJmh6LO5NsXYYf24OkHnYdBAjlQV16kcbb+kjZ4N/opzdCvzyo++ITQhWYTJxQUzj+slZSLOXpiMvGhIxPQQDA8hRIZWYNlVh0hGmieupzsGFnA7Tsblmm6wo9wmN8V9ITZfPbRTz4lQatv0MMDQLrRkdz47iqyAx3NBkUiktIQNHvPQw+4ARIxL1iT/Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjtLIUgv4ro/sRDdzkXXr8Na0VcVlLYdKKDm1o0b3ig=;
 b=p/+HivIPdzRrSH69jagYaCHUtoYEq8GpVmWfMd5rTH+DWGdnVj7Vxcg34TrdWdlmlFyGz1r2vN/irQKdMH5OCzE03EupKL79wsvc6yGlR8hg4F1uNaqCJ3tzEmQICxa9O7hgoPV5wiPqP88l5W9Faz8+xDQTKkiiWJ1R/ooCI44=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR10MB1541.namprd10.prod.outlook.com
 (2603:10b6:903:26::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 10:32:09 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e929:b74c:f47c:4b6e]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e929:b74c:f47c:4b6e%4]) with mapi id 15.20.5206.024; Thu, 5 May 2022
 10:32:09 +0000
Date:   Thu, 5 May 2022 13:32:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     lsahlber@redhat.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: cache dirent names for cached directories
Message-ID: <YnOnoLCxPkwERh4c@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0153.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::20) To CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9048fb8e-8a93-4010-594f-08da2e8281c4
X-MS-TrafficTypeDiagnostic: CY4PR10MB1541:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB15416D1C0ADED84FACC92CE38EC29@CY4PR10MB1541.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OO0IeC0bR6doPmMDEwoGW7I0f6KU051rf3wRYV2i0XaK+VVMzT0rezjwvcWGsinFYeTDxrd/xeto27eEbEZVgH5sAxYpz6RHfOtWM5g5CWXsKdfjmEQ4HfM/wPx40iToHksbi/WnOG4yUwj3Vn2xxTgpoTV1fUpK2hHuEzB1LqQ4ttXFLO+KS7+nyLZPW2aMx/xXqnTrcrIbc/YQ4n0m4QfUHG3MAeGf9m4EdfLIetn2xnooHMLd7xsKX63QyIGky+zYJZOhchXNpGrIFAxV+2a43leAQPvOHxJCiiUb/wuxBze33q+k0Lryub5II8epLUD6O7K+L77+RB36zJYMeRzYnee1uWhJWuxJuInmEEYHTT1LSU0zUru59hCru74TIAIXmrw9wW2Cw7sY7lWmveK9EDOL61X24DRoP+WkXpEGS0jO1toCGig2GCBnkcHPCWbjYb36jFRQciMU55f5RSKFS7XKduEoqSM1UvcVtyVosbb2gG0oZZdsmJwYClzHQiQ1JPEuVtD8ifpmRnetj6wMyMm1qCMUumLl9fb75mNMOHoKGV66Rj7aYAbnN3RB/cnERWOEUJ+YnV2EjJfuBs4tkORHDGS8n/tscV6jrojKd/f8RHGmU6WOYfU00QiudNXS8lFAdeMq4KzD6x5stj8S9w1qpNFuPFg3cdYKiCpLt/Wj+3B0j9CS5w/KVm1w4DQYyLP2tkpcVPi+wTmizQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(6916009)(5660300002)(6486002)(44832011)(8936002)(316002)(6512007)(26005)(9686003)(186003)(83380400001)(6506007)(86362001)(38100700002)(38350700002)(33716001)(66476007)(4326008)(2906002)(6666004)(66556008)(8676002)(52116002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ifzzGuYs3XtbdUZfaEE8+51PwZBXvDh9Xe/MlXOe65OtUPIXCbYnEWHWscmj?=
 =?us-ascii?Q?17qaIx0MJ6OLTRkvkYi9vXJUblSGNRf3hatn9YpaSjTGSvEW6qOX7awpmc3E?=
 =?us-ascii?Q?ccy9fj6/rs7lEib8veqdMPOL38esVK8s5kkBFktyVeyJYpQubAgIU6KU7EyZ?=
 =?us-ascii?Q?5dBzpI2/KMCaBs3wrQphfnE1QGfIYN8x+OAEirvWZ5bacepiCmNPSv9kJjUV?=
 =?us-ascii?Q?e+TueRIKvZ6SoNgcP0Df0lttOeX5j1P8CH0ANjMCPz8GBEFea8sv81kRu7a1?=
 =?us-ascii?Q?GZjvHIRpeiYbctVck3b84dcfKS5uFMrbTDTg8MCdj8jYFl1Con4nUKmoPWsK?=
 =?us-ascii?Q?WTxyQ8dQVmkVqA3eJuKTNk3ERKeFT9GVDBJWBoQHKaaZ6XE6I0PnN+FlJ46Z?=
 =?us-ascii?Q?Kkk5cv/xRzdZXiE10nedRpg2tuighGYEIHKI2JL7FKFADdJGv2WbjewRgHXc?=
 =?us-ascii?Q?uHFW64LqyLZ6SoWJH4+9jCYS93HkGp9/k+/iPDL3Pghdbzix76JufE7Czj8W?=
 =?us-ascii?Q?yEIAYetDjjRX80Ou4JA0H9lF7aDsnTlap/Ob81gpGRsa0OgQqrIlInE2kWKE?=
 =?us-ascii?Q?oEhYfHPOh8Pa3DBul00K1qIsgDC0dqT7RbnHcR5Hzb76ixmK+Q9S3UyeLHfF?=
 =?us-ascii?Q?tnGJvWHj7+UHG5LwvyTVGAsKLdU8yPqrgdfpwg5PJ+A5d5ObBZvmKSbpsMT+?=
 =?us-ascii?Q?xPryFLZrhYyNSZtypU5UXxXFSQYZXdiGUfUJLPEao2em56cxvGawx0nJ/8Bt?=
 =?us-ascii?Q?KXIFgp5+gCPTfE/1K2ESoPZZebPfkQz8LQeU7giY/+LwNPmqhDCg3lka0VJ6?=
 =?us-ascii?Q?lpjMBSbRTuCOXyLz7oA79ED0hcyrvvw1KretNTwW4T+JoUj4IIOVLqVKrdSI?=
 =?us-ascii?Q?CqqeURKVf1+wTEqveUeoIENZ1c48wLhkuZG1m93OC/sOeqV4iL/DdEUyjhke?=
 =?us-ascii?Q?g7mVG1jN24RdqodosHf62XQFkoA7V4v0GaCw6YiGf/C83faIGtkuJrHkGlho?=
 =?us-ascii?Q?IlnF1LeGbZssiNrJmRVN4iqb5VvqUGgM4OGH7QUEehLy9xDsLsT7TRbagDC/?=
 =?us-ascii?Q?OdVOqAjQEd9mHBSp/rJOWp/UWUVfml8Yso3DxX7hmoDQnBd8DAUpvZCqgw6M?=
 =?us-ascii?Q?5c4lzqNETpWTTP+V8IL1u1QWpAobOT/g6Nd61RzlmgzXmhFfmAw1X5ShDu4C?=
 =?us-ascii?Q?IF59YTvkwxkh39ShW5kLKmAQMH3KC1MkPLo3Q5ezdGwOVEUHIOen4Tk2/6Nj?=
 =?us-ascii?Q?T7cRMNOBVxIgi4ZK1Kh5J7D3xh9/A3DgrjaKCPxQTmNvVECTiKLvDPrk6vzV?=
 =?us-ascii?Q?+kGaa1gFiS4UGpkh8NAopP94atmfvyiK3J7zdOHxYPIigtXrj+J01Pnhkvik?=
 =?us-ascii?Q?yiwzIbYGv6e9AJr+OyjOH7vqUhVYtzgCQLG8YWz3INE/kXM/UdSDDALgMYYM?=
 =?us-ascii?Q?ti1OVnh9bcr76T8xwRruYSe1F17njRj4e3DnYPHnb6LS/U+ZKvJlgTSimnNK?=
 =?us-ascii?Q?yBNA6+N7I0fG4sWnJixP6rPq7gDzsOlNomQTRGgbCgM6AH5PPPDA9Ex5ghmH?=
 =?us-ascii?Q?vuSOsf/+PDBClsbrwClwt6sm6eOJhZ9iFInoFveV/9egQrpTpmuK0Hkfe39w?=
 =?us-ascii?Q?VvZy0LtLDOJzfS9s253ia/CxIvtc3tIDqitmGEH3NC36K9jnMzVvKURU6weq?=
 =?us-ascii?Q?tdB74YjzDlP/yW4Xrnvt8xo0dUjVifR4uUlKR1BdxsCl8yCV59m+hAiQYjGi?=
 =?us-ascii?Q?shVQg7AqwndOcFiGYmhO5k0tcXyVe3s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9048fb8e-8a93-4010-594f-08da2e8281c4
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 10:32:09.5350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyvJlWMk+NcKK6md/hsHjAolPOTeX2NQO/EJqJBmNXviiLVDwp2FkJCiSQwBp3Yia7J8SqhbTif/e6Uky9RziLl9JVyhHvr5/vZxZzj9qBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1541
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_04:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=700 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050074
X-Proofpoint-GUID: DVYSJUmVhPzRm67_tIN8EOrR31TOsjto
X-Proofpoint-ORIG-GUID: DVYSJUmVhPzRm67_tIN8EOrR31TOsjto
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie Sahlberg,

This is a semi-automatic email about new static checker warnings.

The patch 4cfa6d6563b6: "cifs: cache dirent names for cached
directories" from May 3, 2022, leads to the following Smatch
complaint:

    fs/cifs/smb2ops.c:796 open_cached_dir()
    warn: variable dereferenced before check 'tcon' (see line 780)

fs/cifs/smb2ops.c
   779	{
   780		struct cifs_ses *ses = tcon->ses;
                                       ^^^^^^^^^
Dereference

   781		struct TCP_Server_Info *server = ses->server;
   782		struct cifs_open_parms oparms;
   783		struct smb2_create_rsp *o_rsp = NULL;
   784		struct smb2_query_info_rsp *qi_rsp = NULL;
   785		int resp_buftype[2];
   786		struct smb_rqst rqst[2];
   787		struct kvec rsp_iov[2];
   788		struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
   789		struct kvec qi_iov[1];
   790		int rc, flags = 0;
   791		__le16 utf16_path = 0; /* Null - since an open of top of share */
   792		u8 oplock = SMB2_OPLOCK_LEVEL_II;
   793		struct cifs_fid *pfid;
   794		struct dentry *dentry;
   795	
   796		if (tcon == NULL || tcon->nohandlecache ||
                    ^^^^^^^^^^^^
The patch adds a new NULL check, but too late.

   797		    is_smb1_server(tcon->ses->server))
   798			return -ENOTSUPP;

regards,
dan carpenter
