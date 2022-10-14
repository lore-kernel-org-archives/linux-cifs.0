Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEF6C433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Oct 2022 14:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiJNOkt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Oct 2022 10:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiJNOkp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Oct 2022 10:40:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE989E197D
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 07:40:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29EE9knN002729;
        Fri, 14 Oct 2022 14:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=Taf0ZeKLxv0OiB63fzYUMDg+LpVvplEFUaP/Uc2GQM0=;
 b=Hy6omHQbGxZDllwVMy5NdZ2aBunOo9YOXxKLhAZXJSlKcDv/sj80CtpyytgFO9sasnBn
 xw2dRoaqhMuZ2wTyFlGJqIErW+6jpBo/Td3Uvaeo89IQny39FnOYNHvEhSkkeQTOvQci
 UvVBtzqnOBqHRrKvJh1qQmJ/fYraexcCzy7EhRMqP/TQIlrt1oHsjfhKs9nPuk01CNRE
 zy0OQ48yy4H8+jYgG+/N+0c0Y3/jvI3eufyigsiXiRRMZIMFHcxa5b7C4YPcUrURs41n
 nAOd0XHzdlPCvVG5mk1eV6k/o7XvY1C21kipRoO1fyNB4azeIY8fgHgluOoDBI4MAT5m fQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k799sg2y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 14:40:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29ECkPwP003064;
        Fri, 14 Oct 2022 14:40:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yndrp4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 14:40:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IC6L/ICyET3gVCztW/Q/ejrbWvO2hTAwbI8TAnWxVktsXORt+F7ioZ9rsZD+2opldarNIrY1HU4uA3ynKlAtoVjDyWgHRgVlOW7gARvl0EOZyyDoftacZ4mSU97OPncvjw1j8Ih6AdBd4YPHPkJw9AGDgel2GG0WLxgmIdMG7z6aEASu7QwVCuWJ+bQYITYaxVEmUa31beeUjynmJC5BbyV+Id28JcIk8yCb8e7/ICvEGZYJvCYFzKTlcUoFUg8aZ9QPjWrlXRv1+H/f+Cv5zMpXmhbpzHJ7H2xOn/eByu+ydOmUn17wjzFe5OO9NCYWiybx+57cRCUrkCO9A27k5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Taf0ZeKLxv0OiB63fzYUMDg+LpVvplEFUaP/Uc2GQM0=;
 b=ZpNe89CDyPp3iBTO+NKokvuZltiPdQIR5ZHXy2CP7+EIpOmIg6P4ll1lDoDvMyhiagyi3NwkLMS/6KIrIE+TXeDoBlvTCKEdDu8e3EHO4/3/Z5oTfS/nlxpO0pMY3JdUtmM2XYxDb+aWSd9VdDKvPEi/Q2XmU+9zEpCli54l3K5KS38jNInucNIvUtLZtfH/ajf71VKKDHeVNMateaYQG3jD+VSlGVqQFs2GIYlKB5nQXUQiT/Hrt8FBpS9YfJnbLlfKOI8fi2eSnK2CCf/sSTqK1UNcpWtZKq5mFmibheWVUmNmgY7aJsue+AALGe1eXuZJ/QChCF99e98px6DjzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Taf0ZeKLxv0OiB63fzYUMDg+LpVvplEFUaP/Uc2GQM0=;
 b=Tsqg9UKkuXxREbFGVjKdUEEb0pPLKV6iOmjoRgpedX1nruzB3U+7hFatCOD0mQx+N3xqATCJzIBJC8HdgyyGCiy4qmuJVbUjxhLSD/DipjNhUZDniPhdfmvPLIRLmX5Gz5kfjQ1Cq9xL1C9DbXp99I40ShA615b3Fg5hwpnTw0o=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5393.namprd10.prod.outlook.com
 (2603:10b6:5:35e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 14:40:22 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Fri, 14 Oct 2022
 14:40:22 +0000
Date:   Fri, 14 Oct 2022 17:40:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     lsahlber@redhat.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: find and use the dentry for cached non-root
 directories also
Message-ID: <Y0l0ylvXH1kLbL0F@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0093.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CO6PR10MB5393:EE_
X-MS-Office365-Filtering-Correlation-Id: e06f1af8-361a-4270-cd30-08daadf205e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 946hngJtI/OlmAFk8ARk64ycJ3DeExlEXdkH/NIj8UjNNQN3OGcdP8Mb+++vdxUPSGr+uo9eVYB9QbWFGBPXnhERXyC73xg5QYO6Ts676eSJvqqyvH9lQYoqRz7Kzkren55r7sNfLvxR1Tq2Z6WoPzRHTTZt+a0O9XBacgy8RLalcdwwU2fC+zvgxTwJy8eRMNQxFBJ8fJSMpgGTe03Q4fDJueQACyjOkguzakItyQfCPi3zstTGf5JuCSujtDHBeN2QQ07hc+Svk4B4xeLMWejGb7q8yHqlt0yX9uk0C98K+kiGAnsYWScSxXu5iqBGeF052I4GVrF7V+LjtY2JK5fnm0HHlHH8/h8yGFHRKl9tTDksD4WIC/lNjX1X6HE2cUFXY4Bde5rXkZWRHp8D+4pMCPDOOzX/3Mpctyb/bFI54wrSCI8WpnsdAynGKY84dG/MgrEMvlwqzSgFgSRwjopQMY274xAMIjsF4ta4DAFW6gg6dieCSy1R6QMqvpV+XIVBtmJ1x87nMlWaINM8AQujZAw9jW+NDvi++H0nBby8MRed5rjBxySqNiat8eqn6E120pEWabk/cqW4rBVMn51CifUSWOJYNpVMoz1cj/9D1FvmLJHYfBXrv2cqdulTBK06bBccc2DcWWu2Nm6UwQfsqV+ko4FqF+1MjPNzHhPJbocraF3YD6L2vTZfxBitaGmBTTsP6PUTuSvCPYbXFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199015)(9686003)(26005)(6512007)(186003)(66946007)(316002)(6916009)(66556008)(33716001)(86362001)(41300700001)(66476007)(4326008)(8676002)(8936002)(6666004)(478600001)(38100700002)(6506007)(2906002)(6486002)(44832011)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mzodtiISGBkC0BINjm2Zym9bBB+r5zw7Pej/d8jNLcr/C9GAb/FBJUFzeERg?=
 =?us-ascii?Q?GcBq9WBuVr1zt5ul4qgbhkPMPee5+aBkXjwLqCmxgt+pH6UOLsg0GRvECM5W?=
 =?us-ascii?Q?7KULAE6qf9fltfTvOk8pK1K8nP17fkZt1PX+f4ezFU24Vd079WNwDpuRNHwL?=
 =?us-ascii?Q?2ysP+mB+o/ZyZlzC1ZV6LEcMsuNg3GHadkCN/xc0mH+jnLiQ5p+Jv/v3UMkF?=
 =?us-ascii?Q?H+rmZ73SCWw+zFWVtRaz4VK2Uus03fByhe0pXynFx22PNbTcJiN/ZedDdQPz?=
 =?us-ascii?Q?Ek8YNlE4evlc+nN05SxTl72/72HAI4aTLdekR+5F0xjyoIzhdAGKLCStVRaE?=
 =?us-ascii?Q?1a9/Z7Nst06qmbxJZxsLiFV4KvhFVy2dcyZdhya7kQ7Czqh0oXlxia3Llp4p?=
 =?us-ascii?Q?AP1NWeMZ0MjIOllJRf1poPsuerfO2aV+eYODFfSEX1ak2njUbHQA0A5uANyr?=
 =?us-ascii?Q?BeSi/Vp9wX3p7pNQxVzs6uarEWxqd5dePk+w81U7t7LBxDt/O103YBaJV1VS?=
 =?us-ascii?Q?xLq1qK/BNHBbEakCsXiBIWYe9Dtb1XQqfZhxgvYrUbRp6CyesHCy9Ms/SEbR?=
 =?us-ascii?Q?jPXLxm0tIdGa/UtdCLZha1vawLuPxvPQMg4WawCjB00iRwvXGbFyjgD9pZo8?=
 =?us-ascii?Q?n4hVgYYxaO+pEbmpdL7U+YEE4yNQLY5ihKMGiUG9s6/Ty4pOQijQgZnxe+kW?=
 =?us-ascii?Q?7+BfJGjDu0DSPdtfwXW5xMKlRKvcoy14G0yhqJkyzvItUjLj2ISdqRmpEC+1?=
 =?us-ascii?Q?3KlcF2imtaoFD7EAcNa4ZnD2F7lxHvcwE14XqkBg3E4PLO8wkEo6tvpAzVZ6?=
 =?us-ascii?Q?DRc0uMY+s6WeVZv4Ln07nITfqo414PA6ZyV3dL1U9H78CzKu37b6cn6Qa9PL?=
 =?us-ascii?Q?XLSks2H/sL9YXomr4Kt4iEqHUYrolkt0rl5VDI4ZzqJhonV8h4fR7MME3zeY?=
 =?us-ascii?Q?vED9bUbN2mOPJdMbKaj+Knp4zd+LAuVvIUW/1/2bU1/tP1oT6DnJ9/BWdqRA?=
 =?us-ascii?Q?8YL8nrVI/TVgGBewuc547dMrGkZ4IYTK/BQ+fJKS2S3gIfIyiJZhO/AuT+CG?=
 =?us-ascii?Q?/2LwCUsuhoGJUOwf2UyiZABPjZm8p39Ap+IrR56I0Tsbz2hP+58OvxBVessq?=
 =?us-ascii?Q?jFuAZrWkffDW7ItN7NCA1E1QNg9Lf8R2lpLQDSctszjecNucDN6LEIpmH0JG?=
 =?us-ascii?Q?JKAPUJbJoSGxW+8Zxty5Ppm+SiHNNcMiQ3R71keJmci2fBl4yaUzSWfhGrki?=
 =?us-ascii?Q?95uYJoOFOc/Te4/GSjYJuSU0Z9EVPagSjh9fTQ1aGIYOpeuh4WhvXZMuX/sQ?=
 =?us-ascii?Q?ATmJBEY/L1Bh5cBjtZbqNTIEuRXmgcrj8rZlPrAiJgbQ3qLZ3HCSP4LCiqPB?=
 =?us-ascii?Q?kDKnN5vu5JgP8TPZlZ2u8ID0OcEmQ+ekSPBZwGb6Ld4SPGv47YwihkhLjf3l?=
 =?us-ascii?Q?HWpZhEtOfI3A6qDiXac5+TPTnSfGBdZKXvsQlJgTY1gl89f/JR8yVxm0Qphd?=
 =?us-ascii?Q?nI0byCmZlUXj7FMsg0pCpCDEW7UJGWLda6zR/yd0M8GCXnh+CLguHmxfltQF?=
 =?us-ascii?Q?iOWEfYwu/i2grE/9kNDn82oy8ld+L386AZC0FRoxPDsR5pPbeAS9kPFtV559?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e06f1af8-361a-4270-cd30-08daadf205e3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 14:40:22.0727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJ3YXSWAuj+hCFmfJW8QZyZ2jM2OZ6PcxpkDQtQ0PLJOceMTC02sOmFAkNS3FrGtq4SpnlNfRfQKSzsKPO6o2SN9vIuWUhayEGmiZKgyjXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5393
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_08,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140081
X-Proofpoint-GUID: PC7jlQvDE4OuweR6vEROSMpOzXH0V-Pe
X-Proofpoint-ORIG-GUID: PC7jlQvDE4OuweR6vEROSMpOzXH0V-Pe
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie Sahlberg,

The patch ab2ef9a696a6: "cifs: find and use the dentry for cached
non-root directories also" from Oct 12, 2022, leads to the following
Smatch static checker warning:

	fs/cifs/cached_dir.c:257 open_cached_dir()
	warn: missing error code here? 'IS_ERR()' failed. 'rc' = '0'

fs/cifs/cached_dir.c
    105 int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
    106                     const char *path,
    107                     struct cifs_sb_info *cifs_sb,
    108                     bool lookup_only, struct cached_fid **ret_cfid)
    109 {
    110         struct cifs_ses *ses;
    111         struct TCP_Server_Info *server;
    112         struct cifs_open_parms oparms;
    113         struct smb2_create_rsp *o_rsp = NULL;
    114         struct smb2_query_info_rsp *qi_rsp = NULL;
    115         int resp_buftype[2];
    116         struct smb_rqst rqst[2];
    117         struct kvec rsp_iov[2];
    118         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
    119         struct kvec qi_iov[1];
    120         int rc, flags = 0;
    121         __le16 *utf16_path = NULL;
    122         u8 oplock = SMB2_OPLOCK_LEVEL_II;
    123         struct cifs_fid *pfid;
    124         struct dentry *dentry = NULL;
    125         struct cached_fid *cfid;
    126         struct cached_fids *cfids;
    127 
    128         if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
    129             is_smb1_server(tcon->ses->server))
    130                 return -EOPNOTSUPP;
    131 
    132         ses = tcon->ses;
    133         server = ses->server;
    134         cfids = tcon->cfids;
    135 
    136         if (!server->ops->new_lease_key)
    137                 return -EIO;
    138 
    139         if (cifs_sb->root == NULL)
    140                 return -ENOENT;
    141 
    142         utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
    143         if (!utf16_path)
    144                 return -ENOMEM;
    145 
    146         cfid = find_or_create_cached_dir(cfids, path, lookup_only);
    147         if (cfid == NULL) {
    148                 kfree(utf16_path);
    149                 return -ENOENT;
    150         }
    151         /*
    152          * At this point we either have a lease already and we can just
    153          * return it. If not we are guaranteed to be the only thread accessing
    154          * this cfid.
    155          */
    156         if (cfid->has_lease) {
    157                 *ret_cfid = cfid;
    158                 kfree(utf16_path);
    159                 return 0;
    160         }
    161 
    162         /*
    163          * We do not hold the lock for the open because in case
    164          * SMB2_open needs to reconnect.
    165          * This is safe because no other thread will be able to get a ref
    166          * to the cfid until we have finished opening the file and (possibly)
    167          * acquired a lease.
    168          */
    169         if (smb3_encryption_required(tcon))
    170                 flags |= CIFS_TRANSFORM_REQ;
    171 
    172         pfid = &cfid->fid;
    173         server->ops->new_lease_key(pfid);
    174 
    175         memset(rqst, 0, sizeof(rqst));
    176         resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
    177         memset(rsp_iov, 0, sizeof(rsp_iov));
    178 
    179         /* Open */
    180         memset(&open_iov, 0, sizeof(open_iov));
    181         rqst[0].rq_iov = open_iov;
    182         rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
    183 
    184         oparms.tcon = tcon;
    185         oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
    186         oparms.desired_access = FILE_READ_ATTRIBUTES;
    187         oparms.disposition = FILE_OPEN;
    188         oparms.fid = pfid;
    189         oparms.reconnect = false;
    190 
    191         rc = SMB2_open_init(tcon, server,
    192                             &rqst[0], &oplock, &oparms, utf16_path);
    193         if (rc)
    194                 goto oshr_free;
    195         smb2_set_next_command(tcon, &rqst[0]);
    196 
    197         memset(&qi_iov, 0, sizeof(qi_iov));
    198         rqst[1].rq_iov = qi_iov;
    199         rqst[1].rq_nvec = 1;
    200 
    201         rc = SMB2_query_info_init(tcon, server,
    202                                   &rqst[1], COMPOUND_FID,
    203                                   COMPOUND_FID, FILE_ALL_INFORMATION,
    204                                   SMB2_O_INFO_FILE, 0,
    205                                   sizeof(struct smb2_file_all_info) +
    206                                   PATH_MAX * 2, 0, NULL);
    207         if (rc)
    208                 goto oshr_free;
    209 
    210         smb2_set_related(&rqst[1]);
    211 
    212         rc = compound_send_recv(xid, ses, server,
    213                                 flags, 2, rqst,
    214                                 resp_buftype, rsp_iov);
    215         if (rc) {
    216                 if (rc == -EREMCHG) {
    217                         tcon->need_reconnect = true;
    218                         pr_warn_once("server share %s deleted\n",
    219                                      tcon->tree_name);
    220                 }
    221                 goto oshr_free;
    222         }
    223 
    224         atomic_inc(&tcon->num_remote_opens);
    225 
    226         o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
    227         oparms.fid->persistent_fid = o_rsp->PersistentFileId;
    228         oparms.fid->volatile_fid = o_rsp->VolatileFileId;
    229 #ifdef CONFIG_CIFS_DEBUG2
    230         oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
    231 #endif /* CIFS_DEBUG2 */
    232 
    233         if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
    234                 goto oshr_free;
    235 
    236 
    237         smb2_parse_contexts(server, o_rsp,
    238                             &oparms.fid->epoch,
    239                             oparms.fid->lease_key, &oplock,
    240                             NULL, NULL);
    241 
    242         qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
    243         if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
    244                 goto oshr_free;
    245         if (!smb2_validate_and_copy_iov(
    246                                 le16_to_cpu(qi_rsp->OutputBufferOffset),
    247                                 sizeof(struct smb2_file_all_info),
    248                                 &rsp_iov[1], sizeof(struct smb2_file_all_info),
    249                                 (char *)&cfid->file_all_info))
    250                 cfid->file_all_info_is_valid = true;
    251 
    252         if (!path[0])
    253                 dentry = dget(cifs_sb->root);
    254         else {
    255                 dentry = path_to_dentry(cifs_sb, path);
    256                 if (IS_ERR(dentry))
--> 257                         goto oshr_free;

Should this be an error path?  There is a lot going on in the cleanup
code so maybe the error code is set later.

    258         }
    259         cfid->dentry = dentry;
    260         cfid->tcon = tcon;
    261         cfid->time = jiffies;
    262         cfid->is_open = true;
    263         cfid->has_lease = true;
    264 
    265 oshr_free:
    266         kfree(utf16_path);
    267         SMB2_open_free(&rqst[0]);
    268         SMB2_query_info_free(&rqst[1]);
    269         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
    270         free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
    271         spin_lock(&cfids->cfid_list_lock);
    272         if (!cfid->has_lease) {
    273                 if (cfid->on_list) {
    274                         list_del(&cfid->entry);
    275                         cfid->on_list = false;
    276                         cfids->num_entries--;
    277                 }
    278                 rc = -ENOENT;
    279         }
    280         spin_unlock(&cfids->cfid_list_lock);
    281         if (rc) {
    282                 free_cached_dir(cfid);
    283                 cfid = NULL;
    284         }
    285 
    286         if (rc == 0)
    287                 *ret_cfid = cfid;
    288 
    289         return rc;
    290 }

regards,
dan carpenter
