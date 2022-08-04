Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9238FC19F2A
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Aug 2022 14:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbiHDOda (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Aug 2022 10:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbiHDOd3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Aug 2022 10:33:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5381C2613B
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 07:33:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274EX9Oh006150;
        Thu, 4 Aug 2022 14:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=Z+l+nfwbz4muR+julzC9YxhfXZ2CxRCK7gjchPz+Suk=;
 b=SGvvXLXS7JpaA043Bbg9A/8uW/2r4XHca5c6T5k23b463z2f/aRBF2elQcGPMxAMwu2t
 d/YQVxGgn9S5sIJ71K3lV/DVYu3XNBVknU0G3X03Ytna+ImrSPjWJxqEtZ5gWmtaq3/3
 bwQ6U+GGQsOgp4ps15aRdw9q2UOGqppmACijQFtpXsn9WT5fmke1BGPXNyWNR07s//Dz
 wL/AcGmvmJUd5eph1vae7EZupuooA8MIGQZ6gj/OtGH1jiLZ0ULjhYCzICB/ZYPIi+e9
 WOwrj0qgT7aazDT0O7mi0nIlC9TT6Q60SjaUVvtwAV5vKYBbEkezykt/jbLzzSbhVVle Ow== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2ccta2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 14:33:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274E82vV003017;
        Thu, 4 Aug 2022 14:33:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34by6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 14:33:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3+a8VwRlRHozRHWFuOkuyr7l1e1oI68rFDBdhnXSjVruotBfdudK0+vFdx/gxR4nbKLXIJdb+UtZL7zPovfLsXkN+C9I/HMaH0o3ZmlhuxXB6aifE4gCaw9r2fR2Z/ga1cIf3bmi6RIaJarsqfNGc7kiSLz+avadXomtjWgkCWz4C9O/IoqEEIOaSKdrc0MpNOrnBrm2JUsG2tm7/WXstxAEOO+DaEBych5Ai8vwctK97Fv9hGqkZbptAAOfY4vbNuSMDxKhFXdmkCZtHPZPrjohXicqr/jheJNwdhLvUZ/zJcsmHPRtDjURvd5UTISCOtXMSETlMOemAkfeVTaTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+l+nfwbz4muR+julzC9YxhfXZ2CxRCK7gjchPz+Suk=;
 b=JWbOcOqJU/YoBy6TH13ILwJEhW7/kg0cuhl+jIVGf10dfEOXF9TaeY0jj+0MaQgOf9j2YVW9teamDgjgkNIfbxtlc8gwUAx0p5M5lu1jBEuji7OPeC5uhM0DBmMs9LEOo5nYyjAhjKVAVmrL8zprh7u/fUcRfKj5eCZnIIv4/032rT4KGqoURBBi8/YZF8QDWrPha0mKpfWfxmaBCvo2nMz7fuQSgQ3FgJi7BsEa+5KoKbXsD4MoOyrjZX5xTZGho0+4qdiAPcV+YkkHYpy7eYu/hzn/K+QGhmYw+xCjjUXSLx4PSIEUiJjCyzovPq6bBQ79xW1MHA24ULRi4Da8LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+l+nfwbz4muR+julzC9YxhfXZ2CxRCK7gjchPz+Suk=;
 b=L6I8e3QtjtqXnjKu2m+0eZR+o7MC574GjNK7eSGR7EbHpaaKIrpvq2ZPyImwAJt6u7SAZStpczB/EUXj607oFvkG3Yauo0pekqhmDtO3sdpoQpF4vmks9Q8NICP66w1Zpf0tms3aD6ZpDTroWMNPchI/UpzHIw03IkxLgKZ52Bw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1967.namprd10.prod.outlook.com
 (2603:10b6:300:10b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Thu, 4 Aug
 2022 14:33:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 14:33:15 +0000
Date:   Thu, 4 Aug 2022 17:33:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     linkinjeon@kernel.org
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] ksmbd: fix heap-based overflow in set_ntacl_dacl()
Message-ID: <YuvYoM5nknSDxJFj@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0094.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aeddd097-ed46-43f3-f2f8-08da76264421
X-MS-TrafficTypeDiagnostic: MWHPR10MB1967:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sqlRqgH7ruNd1NjiQ+Q1ihJzuF23cCwiTcWnualXyniv6Mq83VnDueYhTKxzJbu7zyMVYEsEaiGjboZs3EoWKAcwBrpdF1X88S+axKDCVIqjtZK845hFsatjw9WGiEvVSXWJXXbgu08oFgSXkn1TQvLIRsJEakvmuSmH02v2pnKunf6Jaxhf3DAPXBARtAA0UoPOWm8AppTmt6uHCSnm6yH05uW2/H8xcFYsYe7ymmkaeXSRRTFArM6dM7kxteOLdYNmm1k68FE7Ah5RtemW+ZQOCuFw6q+DFgHqDU1hrbGyv24FWWW5qTRj5nqKUAr4TWMWzOCoB1ZNfglrWCTksBQE1SN7ZZu9P6qvYkh7xG42OdqxqDOGG0stOHgSbj+UxKw9CzCL4+C3RmEM8DihcwwwRrsLo+qUsVr3YeRpJE0puBla1p6G6PSpvAwCcC5SFH3YCCmZWJtdNAunkawVN6192iqOWc8zpSSAmURbaCzS6ztFOgtVx3AHfWTc4LSFWoEQyCiIF92Ufu3lQ0yzy26kfLGmndU6B6FanAFvdjnVbEACOyEPejCQJAniiaIAPqZ0/CDk9VT7WQS8rGt9M1uvFPFtZiZshtife9/dYpwo2+QSnKetkMzrRqwvrGIrzeM0tPsVbD6SDvc5HPM8xZEoiAoCMckSmRmodFs/0uQN7Q6zfFuJbQHUUaQf45dBjVdf6iaWVYt/3sEgFKK6MH2nhgiWz/96U3Nir/Ss5m0aJ0wWBYScstY1YEUVoVMoeq+GJxmxMhmnjk/XQRpy4Pb9ZSz03eC9BQ5LU3TnsCaWIa87sZz+ooWvHX8iZXqx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(136003)(376002)(366004)(396003)(346002)(6916009)(44832011)(83380400001)(33716001)(38100700002)(52116002)(316002)(186003)(6506007)(38350700002)(2906002)(5660300002)(9686003)(6666004)(26005)(478600001)(6512007)(66946007)(6486002)(66556008)(66476007)(4326008)(8676002)(8936002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5llKaLoSjNr2MYE8IdbX6Zlav14A8qHDRiYKJbmCp3WBaHUXHQHia4iZfJNE?=
 =?us-ascii?Q?vASYnxPLL5GSdilydYJfw5PWPOqI1WUgJQ2VHSAEHRuQ3vZyLvFoRtm1fW5X?=
 =?us-ascii?Q?bcxzi9d+YCdFTgnEj3aw7gN8txB+lkDJjd6ZfD7PTbQINZpzundLrXTQSVhu?=
 =?us-ascii?Q?l6TJUG6v6CHeiRhRjf5Z9+kU+yeikowP+NQGEnPIfgDc96CMHVENnIDzuxZ/?=
 =?us-ascii?Q?XfmUUmXdfYhK0tdTHiQ/q0CFB70Et+K5sZED1m5YHn5UIqGjL/2FbxcfcUn2?=
 =?us-ascii?Q?IGmOF5M0qIhCKNLrnFAXbGSveF/0wt9Qr1W9JCU8XmE14NJqOMDWKS0ixb3e?=
 =?us-ascii?Q?yGmKWPKB0W9tZqiuYXjn3r30PW1ugZw+lrIzCm07Aphj+1YzI1Vz2BGR/dJm?=
 =?us-ascii?Q?j5QpUT8cr2PIlVAJeQb7pGeOITPpgplez9yGx8yHdaE9WSi3IJ5ac98NUdJh?=
 =?us-ascii?Q?/laz/HvFxdrtLHxDdmQpMW5ZYma4UZCzos9RXYIris+sPQt5HD8IK/0mWfQ+?=
 =?us-ascii?Q?d5WBGA4IdXpZEu89YAc7gxVemN/MwJtXC+ldUexEl+jmXgnqtD6wS7mGA1ij?=
 =?us-ascii?Q?bhdOtUEeLYF97D4elR4RfiHuJRK48MvRCxx4OsEJU/Pb4fwcFE6yzAcBmVEN?=
 =?us-ascii?Q?QAXWB6+bY4mJ7H0LlECzsPchpeNtCgOFncUWiFIBmOENzooIazp010Th4BXd?=
 =?us-ascii?Q?1tpBOaJpC3Mg5B7o5K0WsdN8LYoFuxiQapBSda0mapPvCXGtMe5NQ6+5iJUp?=
 =?us-ascii?Q?eAS5593yo2ZmiWaAREIoJF3ww6bN0W3U66KLdalEqBYf3WnARtsUusLiyDoE?=
 =?us-ascii?Q?maTXhP3spO4+zV8ExFS0bIW5qagTR8CW29T55Y4PeMS6xwbJ8ub7AV7HG8Wr?=
 =?us-ascii?Q?8ORDJWtwD0dyGyIvsbBwZ63K0Fd1f8hXT4pfH1QMRdYTEvpGX/RIjYJQimdI?=
 =?us-ascii?Q?doy1Yaod7RTC7RiLmR83aY8juW09AfhSg3ojIcaRKfslHjEe/XuQC7qLXqd8?=
 =?us-ascii?Q?fJRYtSTWypzWnTUqxNbN22n7n6keext/hPuOLWw6Ft/wED6eRvSM2QzhqA3K?=
 =?us-ascii?Q?ihxsAllRX2xiiWGl3ZCWHsJSaQ7n3MJDn7nLmxWy8fTo/HAyMHqnsbjO5MGe?=
 =?us-ascii?Q?jYzLTGHP7EWYoyR29aC5MC67yQjTewfitKQ4l3iDlglauD8M0UJWORe3vRx2?=
 =?us-ascii?Q?+T+QPAHpP8vwVXAf4H7GA7By16jKMsV0q0rbK0dpeeSdq3A8576LUygrjzMr?=
 =?us-ascii?Q?hySgg87cR7kbgYIKCzYngvLz+nUC9qzQx8G6qVooy35pS4pnm5L4gUn/ctyk?=
 =?us-ascii?Q?r4EH5tju1xzabd0IhkGT2RYYdqmni7T/CkUvDiARGmeAC3C1b7A0Gur2Iypj?=
 =?us-ascii?Q?fPKcagCehTz3QqiE62KxRpS+iEpBH9qekJQxRyBz4XaLHffh3sR90snnsEtR?=
 =?us-ascii?Q?Ubt9VdHMOhP6bfFBqZ4cWcS+PSwOgyYkevsjvP2s/0E2vs/z4umyR9k3IqTo?=
 =?us-ascii?Q?1vuEFtELMWr2WjB+iPjWmzwp+iFQDwzAzMbKzHYWZlolBUBakQu+RtdXaK2t?=
 =?us-ascii?Q?m0zZlaQ1SsbkMVQeB5EENr2DasdL08qJZZ9uXe2MlbfriD7vf8q7KfoKIMeK?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeddd097-ed46-43f3-f2f8-08da76264421
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 14:33:15.1194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myXn/YefRhp/tI0Z7JOZdBQ73GLvloYTQT7eriqoJR+4TSzDIvNExwXZ/8yW7a4SHdLfTYLG0l///Ur87UazbfWL5bnrVIpL8AZ9AoQgjoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040064
X-Proofpoint-GUID: DB4lr9m1mJ0tbMZbIWoK00eXgo6unC9O
X-Proofpoint-ORIG-GUID: DB4lr9m1mJ0tbMZbIWoK00eXgo6unC9O
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

The patch 982979772f2b: "ksmbd: fix heap-based overflow in
set_ntacl_dacl()" from Jul 28, 2022, leads to the following Smatch
static checker warning:

	fs/ksmbd/smb2pdu.c:5182 smb2_get_info_sec()
	error: uninitialized symbol 'secdesclen'.

fs/ksmbd/smb2pdu.c
    5109 static int smb2_get_info_sec(struct ksmbd_work *work,
    5110                              struct smb2_query_info_req *req,
    5111                              struct smb2_query_info_rsp *rsp)
    5112 {
    5113         struct ksmbd_file *fp;
    5114         struct user_namespace *user_ns;
    5115         struct smb_ntsd *pntsd = (struct smb_ntsd *)rsp->Buffer, *ppntsd = NULL;
    5116         struct smb_fattr fattr = {{0}};
    5117         struct inode *inode;
    5118         __u32 secdesclen;
    5119         unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
    5120         int addition_info = le32_to_cpu(req->AdditionalInformation);
    5121         int rc = 0, ppntsd_size = 0;
    5122 
    5123         if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
    5124                               PROTECTED_DACL_SECINFO |
    5125                               UNPROTECTED_DACL_SECINFO)) {
    5126                 ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n",
    5127                        addition_info);
    5128 
    5129                 pntsd->revision = cpu_to_le16(1);
    5130                 pntsd->type = cpu_to_le16(SELF_RELATIVE | DACL_PROTECTED);
    5131                 pntsd->osidoffset = 0;
    5132                 pntsd->gsidoffset = 0;
    5133                 pntsd->sacloffset = 0;
    5134                 pntsd->dacloffset = 0;
    5135 
    5136                 secdesclen = sizeof(struct smb_ntsd);
    5137                 rsp->OutputBufferLength = cpu_to_le32(secdesclen);
    5138                 inc_rfc1001_len(work->response_buf, secdesclen);
    5139 
    5140                 return 0;
    5141         }
    5142 
    5143         if (work->next_smb2_rcv_hdr_off) {
    5144                 if (!has_file_id(req->VolatileFileId)) {
    5145                         ksmbd_debug(SMB, "Compound request set FID = %llu\n",
    5146                                     work->compound_fid);
    5147                         id = work->compound_fid;
    5148                         pid = work->compound_pfid;
    5149                 }
    5150         }
    5151 
    5152         if (!has_file_id(id)) {
    5153                 id = req->VolatileFileId;
    5154                 pid = req->PersistentFileId;
    5155         }
    5156 
    5157         fp = ksmbd_lookup_fd_slow(work, id, pid);
    5158         if (!fp)
    5159                 return -ENOENT;
    5160 
    5161         user_ns = file_mnt_user_ns(fp->filp);
    5162         inode = file_inode(fp->filp);
    5163         ksmbd_acls_fattr(&fattr, user_ns, inode);
    5164 
    5165         if (test_share_config_flag(work->tcon->share_conf,
    5166                                    KSMBD_SHARE_FLAG_ACL_XATTR))
    5167                 ppntsd_size = ksmbd_vfs_get_sd_xattr(work->conn, user_ns,
    5168                                                      fp->filp->f_path.dentry,
    5169                                                      &ppntsd);
    5170 
    5171         /* Check if sd buffer size exceeds response buffer size */
    5172         if (smb2_resp_buf_len(work, 8) > ppntsd_size)
    5173                 rc = build_sec_desc(user_ns, pntsd, ppntsd, ppntsd_size,
    5174                                     addition_info, &secdesclen, &fattr);

"secdesclen" is not initialized on else path.

    5175         posix_acl_release(fattr.cf_acls);
    5176         posix_acl_release(fattr.cf_dacls);
    5177         kfree(ppntsd);
    5178         ksmbd_fd_put(work, fp);
    5179         if (rc)
    5180                 return rc;
    5181 
--> 5182         rsp->OutputBufferLength = cpu_to_le32(secdesclen);
    5183         inc_rfc1001_len(work->response_buf, secdesclen);
    5184         return 0;
    5185 }

regards,
dan carpenter
