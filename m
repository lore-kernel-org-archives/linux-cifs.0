Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1A3C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Sep 2021 11:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ED72611C8
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Sep 2021 11:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhIQL75 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Sep 2021 07:59:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46764 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234705AbhIQL74 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 17 Sep 2021 07:59:56 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HBZ0KK024443;
        Fri, 17 Sep 2021 11:58:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=3Vb38cv/c4uRYyc/iL0HpfEGqheeIkuQcfHrrujQvF8=;
 b=Zoy4TcFKwqXieUdtBIZbcJdiZpSncDt+HTa1jBe1/kfHZhmTgFzXy31FJOdbWdjwHJJq
 kflZ6jCdUdmNrLopw4PUFH6EpRX9v29dm2e2YPFRaZ8JAQEcphvWowOR7nfiLpsp8cTw
 7QN3ZFR0eAOPj5mUBgXBabBfLocQ9+amZCoLB75mFfE6jSPb58cwavAOzp46LLyuGz4B
 CDWjeYYxqykxuqJSudz8JJQ3q7+kvhiYr/oFnqXkvyYGs+kgSGuBo8Dx29kQsu6lbviR
 m6NJPkesuCHY5DD95ZdgKxeyPM26VVvW2Q9ECKRjhwoLeRxgmABmCKwJhozEOzdHhFWV 7g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=3Vb38cv/c4uRYyc/iL0HpfEGqheeIkuQcfHrrujQvF8=;
 b=s0UUSERJd7VZ/4jXIK5IIChUV5pF+nVPP772U2WNDsfiqcACOEwC5eFo/4y2wYoRnE4+
 DbevVDT8UfpolHSEwn22ZQ1EFT+mH+ISanLCL2QwGSaw+bflxKEvwKts5bgKfVHBx3r1
 j/Ew6wCn2m3dzRbvr6x8TV5NTOaXsLOyu4zP5NiNW4JNLjA2a1pJnmf77ml8+W9MUqhs
 7dxRqdjRJ/GLZcUeNrkVAt8iow8lYXAOx36kbAb/ZfNl9nArcP0+B8zmBTJx8G0Xes8l
 MHh7VWUICDRDU6pTL6jbFLkzCVyt5MA4EOOtokWDWa3ZpqBw7w0MSIHHrn2879LeUbzq uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b4qv9gh4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 11:58:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18HBkYFb039568;
        Fri, 17 Sep 2021 11:58:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3b0m9artqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 11:58:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZat5Bf8Wy7kfrCOQNKTJLdhGXT8yUSR+jtixbQ6h4B5ef+8jB8uRvcyxJOJbVIXOLi9ERdFd1S+NIMVG9PsVTAD0/UreDtXLKivEJWI5hDtkpSQ+dS47WkrRDjRd2jpnkhiaufY00fc8FBv4gnXlV2IOaI6dzaKGDGXTp+K3P+sXV+GiO5478MpSS2vlfoISAQCS5BSl+1XMzV6IsZPFLuekJf0dDBf0Z9hnsf6XY87NfYgePHEO51XKEWfb9a5vvWGsUoe3Uq3AU4RYGdnsdf2UwfSI3bvpumSFuajgumV6Mp5uKoEhxFYZ3cPliNCJGOGGet2Ld/gt+Adiy0eYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3Vb38cv/c4uRYyc/iL0HpfEGqheeIkuQcfHrrujQvF8=;
 b=ZgBlFF3sDahGzI8DBgVuGOGMgeR/oEP1u8rRt4T1g0u0qF65R8e5UYpC1e1LAsYi+DJ4RAl9Rx1hDWKhdNtURcwk9PfXF4B7YpYhGfkL7dXtL8SwyS0W4Np+sUu/K1uHwKmfbsXyaciI4tB//qtTJidM6P7FROfi2P33ppOGelVcH2dpRCIs0lsc10V4sn2oYdM4lgMWkXSSAzuN+fqpErWfU5vOoi/xn/cHaURPn4aZ3KlbIpjuUhn2CMbt5eRja8bOzNNTmvjeL6q77yAMxhEXvz5dhZh8XI+enqdsN4gWag28EeihChB1cBQr0L+zQygBX5QnEmoGhzZHyu7yYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Vb38cv/c4uRYyc/iL0HpfEGqheeIkuQcfHrrujQvF8=;
 b=VCy7ehf3zJpbZXjatCy8Za8hHT6Bn94JABnfXGvdPDOoTTOGCzFw6Hmu8Rf9gfKk4KsGqN4DnWmRKhFZFnAoeUWmP7BmMeo6LMmFgJKM4CaDK4RCFR9SesDlid0llV7N0Gkrqqr+AaskN+492vqLBtfpaEjy3hCElFl7YcrnxGU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2255.namprd10.prod.outlook.com
 (2603:10b6:301:2f::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 17 Sep
 2021 11:58:30 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 11:58:30 +0000
Date:   Fri, 17 Sep 2021 14:58:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     lsahlber@redhat.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: refactor create_sd_buf() and and avoid corrupting
 the buffer
Message-ID: <20210917115820.GA27137@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::11) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 11:58:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f52e2ad0-6b76-41a1-50ce-08d979d27705
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2255:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB225540FD67F500EA794BE7838EDD9@MWHPR1001MB2255.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1WWVpZFFAcQWjaXO2InhMNuos9PcNGtrx91wHBi6TkBh0tWK4/kqDDqv7qxoGFB2koZlt09SCyTIBAAnwnIPY2p0HADAlH8Q1o7HAfDFndEGohRJMZLpgkWBsasDn0GL8goFVWGY4iiy0kflmBs8xexSuylKs0ZgINLk3K5SMsORSDd2d0xNu1A1NfExH7IlRLyiwXbjAGnYylh6oNd9a3pwlxxgahaYdZ5BV+/pDUrDrudtEKBCT2DPlVqEJ9tqqHouC4ZRUIVcw8odc7mtosBQZK3RpIqJxkKztOoO3mqOOb4DbRFdHGUulYva5YqsySaFlrNv/E2fhtj1omjrkqpAtlf8XJAXgPuaZQUIjQNXnQ9Bq2Qcxl0hgpjipujhVZY26kbUuT7w8iKaMHCstS/6cBa0eBcOI1wRqkmohsqO6q7GW0BIPUC24+pVX+Wm+xHRkoe3LYtxBoKa0Y74wVSPV9QTcDkpCXQyVWrNRhsNOFLEXdxT9eZYwWqVOdGkVL8ZnHdl98fQo+4EiPagr/0WA+GQ4Ix9xHlIlhIyPmpRJilfTaEUrOc5y1XNAhylv0clZg5Kloj8jTEeoVo+qTL0vBYnMtWfTppwJWKpdZv+ZB0+Anw449bD7KBbNM02Wm3MPSFsTcnhRW15W56CyglzmQzwntK8BmNiJ5zeTkAhw5E/Dxowvywjx1rCMnejtvX109yNrPohWtxS+5kuLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(396003)(366004)(83380400001)(38100700002)(8676002)(86362001)(26005)(8936002)(316002)(4326008)(33656002)(44832011)(66476007)(38350700002)(1076003)(478600001)(2906002)(956004)(6916009)(9686003)(55016002)(6496006)(33716001)(66556008)(186003)(9576002)(66946007)(6666004)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NHWfWtFW+MaEYXxKMCMh4qtPv7aphPZLsRUjoOhFqexQwruh3FK0OdpGY2Lq?=
 =?us-ascii?Q?q50nqbGdkdauF5eaoZuX7GIG8y8fmXhqOkKlfjHYR0ntxb9uAlI2hV302P8a?=
 =?us-ascii?Q?t3dPY8E6RIdnLKUpixkPh3zm3b2XlIqaIZ2bPBHGls/sY/cKexYUzrqfYPC3?=
 =?us-ascii?Q?zCuTpK1h3lkMwUPZzlPE9sKxIUMr72jOrzi7AcGhtMoZQ4bDfTRTdscqK2tm?=
 =?us-ascii?Q?WDm09/6IH5elGt/fjVlza8kLVTU3PnkAXxM6sYFG8COinG2sSi83DV7mUuHm?=
 =?us-ascii?Q?cwiOnVA7SsqZBQWsK2u29d03aJljRbfQJbq7x7c7F+I0E72rkKCE0eSU2s0N?=
 =?us-ascii?Q?74TCNmiefeW5eJ7h/OhUSU1YipwWhER5b8jhw1rnKnB/6ClmPa54ofGlu/ps?=
 =?us-ascii?Q?0dtGylrjwQVBv9QCyTuf6GXp4HcK0a9uYknoQxOP+QbMqZ6NThJuBUuR06vQ?=
 =?us-ascii?Q?T1JyDcNkbm5v4xxy0OZAR1IAgB3UHWMGi9M+eS+dPbmB+fpTETmPR0gn8Dda?=
 =?us-ascii?Q?w/SnwYMFJ8kLT5G9t6uZTgKb41h42mxzMUQOoO1JEItJ0WAfYd3gUapC1uPc?=
 =?us-ascii?Q?aeeLzXyQ+rNEUZiJWHc3fCtazfRokVpgCfmklZPxpmUvlaDVdl/UdNKqdEZX?=
 =?us-ascii?Q?XNt6HmcasvsdxWaWI+r0Hpy0ZfOr9H/DwpUnKjIQJZbWJrKY0MuZe5oCFhRD?=
 =?us-ascii?Q?6qzXEEuOHDRcCcFG0EOAgMhVCTqsFyMKCXHUdczBeSGKNxdYQQItfz19w5gk?=
 =?us-ascii?Q?de8vjFL5O4GZBDg9N+ed5E7WZQUPoX4Oi4t7ej1uW/YI9UUiDTIH0wbUonL+?=
 =?us-ascii?Q?76q+eM3Tk+OWpwjguI02ZhR+//6IP4nPAs8FC/zz6+jWWrOrl01BRK9zDz59?=
 =?us-ascii?Q?FcpD7UWaFk6cX83EPJhlAuPxul6KKHOPVzdismorNKe29NWyg2VO397gBpOj?=
 =?us-ascii?Q?yrG1BkK6kq0MThQxw3RXtO1EtchZ5viPTY9BIgd4E/WsTCSGQg9HTGQ9g2N+?=
 =?us-ascii?Q?18NMlh1ZyvKGVPgo+Lvz0W6LXEkOKPHxHNCrwcSKtpn5cSK6+lbkWx8QW6SO?=
 =?us-ascii?Q?eknVSzaFYIPJ4JMvFJW4YhuTCgvZSzkPZvA8WK2fVSUT3snB3drlzRVFCu5N?=
 =?us-ascii?Q?8+aQEWmL4t3xO3pf4hQ+jyoBmPotaiLDxK8WUIBFiMHuuxyDzR7Oil5nP9e9?=
 =?us-ascii?Q?kTE8/PpmtfMGdbxV+ul3rvING5IyRPBfAS3yupf4ro5r1yQZkxdrSsZ70yAv?=
 =?us-ascii?Q?J/HuIMiZvVVkBEKVC05niHxfy5waGyWFFllInB4dRVWQgjB9VL2KZvVtJ6d5?=
 =?us-ascii?Q?JdBEPkWYxz9sw2delq9VXwGt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52e2ad0-6b76-41a1-50ce-08d979d27705
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 11:58:29.9334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrcQeHfwUJutEKRglVs+lSu9Bxszej9C7Q6Wen3kd9yoqigF1jXCgZAQDwP7wbaCaoek1Wgwy3DnFz/iCCVJNxcATqfgq2i1UZzbzjlXav0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2255
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10109 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=804 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109170076
X-Proofpoint-ORIG-GUID: sOEw7O8mmS0mY3DzXKp30YRkBeql82Wc
X-Proofpoint-GUID: sOEw7O8mmS0mY3DzXKp30YRkBeql82Wc
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie Sahlberg,

The patch ea64370bcae1: "cifs: refactor create_sd_buf() and and avoid
corrupting the buffer" from Nov 30, 2020, leads to the following
Smatch static checker warning:

	fs/smbfs_client/smb2pdu.c:2425 create_sd_buf()
	warn: struct type mismatch 'smb3_acl vs cifs_acl'

fs/smbfs_client/smb2pdu.c
    2344 static struct crt_sd_ctxt *
    2345 create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
    2346 {
    2347         struct crt_sd_ctxt *buf;
    2348         __u8 *ptr, *aclptr;
    2349         unsigned int acelen, acl_size, ace_count;
    2350         unsigned int owner_offset = 0;
    2351         unsigned int group_offset = 0;
    2352         struct smb3_acl acl;
                 ^^^^^^^^^^^^^^^^^^^

    2353 
    2354         *len = roundup(sizeof(struct crt_sd_ctxt) + (sizeof(struct cifs_ace) * 4), 8);
    2355 
    2356         if (set_owner) {
    2357                 /* sizeof(struct owner_group_sids) is already multiple of 8 so no need to round */
    2358                 *len += sizeof(struct owner_group_sids);
    2359         }
    2360 
    2361         buf = kzalloc(*len, GFP_KERNEL);
    2362         if (buf == NULL)
    2363                 return buf;
    2364 
    2365         ptr = (__u8 *)&buf[1];
    2366         if (set_owner) {
    2367                 /* offset fields are from beginning of security descriptor not of create context */
    2368                 owner_offset = ptr - (__u8 *)&buf->sd;
    2369                 buf->sd.OffsetOwner = cpu_to_le32(owner_offset);
    2370                 group_offset = owner_offset + offsetof(struct owner_group_sids, group);
    2371                 buf->sd.OffsetGroup = cpu_to_le32(group_offset);
    2372 
    2373                 setup_owner_group_sids(ptr);
    2374                 ptr += sizeof(struct owner_group_sids);
    2375         } else {
    2376                 buf->sd.OffsetOwner = 0;
    2377                 buf->sd.OffsetGroup = 0;
    2378         }
    2379 
    2380         buf->ccontext.DataOffset = cpu_to_le16(offsetof(struct crt_sd_ctxt, sd));
    2381         buf->ccontext.NameOffset = cpu_to_le16(offsetof(struct crt_sd_ctxt, Name));
    2382         buf->ccontext.NameLength = cpu_to_le16(4);
    2383         /* SMB2_CREATE_SD_BUFFER_TOKEN is "SecD" */
    2384         buf->Name[0] = 'S';
    2385         buf->Name[1] = 'e';
    2386         buf->Name[2] = 'c';
    2387         buf->Name[3] = 'D';
    2388         buf->sd.Revision = 1;  /* Must be one see MS-DTYP 2.4.6 */
    2389 
    2390         /*
    2391          * ACL is "self relative" ie ACL is stored in contiguous block of memory
    2392          * and "DP" ie the DACL is present
    2393          */
    2394         buf->sd.Control = cpu_to_le16(ACL_CONTROL_SR | ACL_CONTROL_DP);
    2395 
    2396         /* offset owner, group and Sbz1 and SACL are all zero */
    2397         buf->sd.OffsetDacl = cpu_to_le32(ptr - (__u8 *)&buf->sd);
    2398         /* Ship the ACL for now. we will copy it into buf later. */
    2399         aclptr = ptr;
    2400         ptr += sizeof(struct cifs_acl);
    2401 
    2402         /* create one ACE to hold the mode embedded in reserved special SID */
    2403         acelen = setup_special_mode_ACE((struct cifs_ace *)ptr, (__u64)mode);
    2404         ptr += acelen;
    2405         acl_size = acelen + sizeof(struct smb3_acl);
                                            ^^^^^^^^^^^^^^^
    2406         ace_count = 1;
    2407 
    2408         if (set_owner) {
    2409                 /* we do not need to reallocate buffer to add the two more ACEs. plenty of space */
    2410                 acelen = setup_special_user_owner_ACE((struct cifs_ace *)ptr);
    2411                 ptr += acelen;
    2412                 acl_size += acelen;
    2413                 ace_count += 1;
    2414         }
    2415 
    2416         /* and one more ACE to allow access for authenticated users */
    2417         acelen = setup_authusers_ACE((struct cifs_ace *)ptr);
    2418         ptr += acelen;
    2419         acl_size += acelen;
    2420         ace_count += 1;
    2421 
    2422         acl.AclRevision = ACL_REVISION; /* See 2.4.4.1 of MS-DTYP */
    2423         acl.AclSize = cpu_to_le16(acl_size);
    2424         acl.AceCount = cpu_to_le16(ace_count);
--> 2425         memcpy(aclptr, &acl, sizeof(struct cifs_acl));
                                      ^^^^^^^^^^^^^^^^^^^^^^^
smb3_acl and cifs_acl structs are both 8 bytes, but their data is quite
different.

(This old warnings are all showing up as new warnings because the file
was moved).

    2426 
    2427         buf->ccontext.DataLength = cpu_to_le32(ptr - (__u8 *)&buf->sd);
    2428         *len = roundup(ptr - (__u8 *)buf, 8);
    2429 
    2430         return buf;
    2431 }

regards,
dan carpenter
