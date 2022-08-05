Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D93C00140
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Aug 2022 11:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbiHELm0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Aug 2022 07:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiHELmY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Aug 2022 07:42:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE5E22BD9
        for <linux-cifs@vger.kernel.org>; Fri,  5 Aug 2022 04:42:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275A5RcN030748;
        Fri, 5 Aug 2022 11:42:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=P6vh1DpvH7Fuh67YABHRxZlVFqSzCsAbJuG87GYst3g=;
 b=z8BqDXpTROetbsbVlY2qw4K2zK8YZrWFbLg4phcRkbnuF0NfV4REnAUN+dDZGJIFhCQb
 t9xv/3YAxnKI88cgqoF7fxXWLjR1cIa9yJjS2Cw/6NOmEo2hoi3u04p3ZeS888f4aT5h
 zUtDNA5tTBr8djTHbmLxQTIh+jvbswd6xKetrgcw+HGf2cu9BHyiK7pYwea2/udInMWw
 DCOCv5FZLhsGLI2pnqiaJt1ylw4AyvrXeQZOq+UipM4c2Ss5HAFC0kBGebeU6Sbj7dB+
 ZPzoXfuQL4ro02D1YFVnUdKBkdbHUzsn2DHdv8JK246V/BholvU5vX54D4s1tifRRQWD PQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu817h63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 11:42:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 275BD0Kl003140;
        Fri, 5 Aug 2022 11:42:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu35abk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 11:42:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIQzlk4zrYAh8q5nmE40/cXcisFFntaUmkNfKjiu8Z8QgHLNrNzzZMH4SiE1fgUyHnJHeB8kXiDzqke2U2MncMgeDB1IBzq52D3UZPcHmbI5fpxT5T4xDIUgcmijbxNYA3q3TPZdvQtwQo0ZWRTN06iAPAPchmEFhQ92RfttL0FFun8vitiG8MuCxUtajPZKEvRDoZeeoBs2d6nSJAAiOdhBrj7MC1OnJ5x8u85V6S+k4sSKxHal/azCJ0ObxEJ44WYrHur8oHKFtoNXUwSvJTidB3HnDlYQIx7I603GF9H4qs6vA36hfXkIC2fScOvqZQS6SNfqhxDBOA6bwRQ5QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6vh1DpvH7Fuh67YABHRxZlVFqSzCsAbJuG87GYst3g=;
 b=AH3cIMYe866aWQnoVsFL8zqC0ITGuMB1kfMZjO509H14GdBNXexPpb77tGheO+7rGIi+/H+if/Ym1F2VN/NgxLb1xEodTlE5+tNfewOdjh1YE3q4X1wXwVC8+An3Tt8mudp34bSTJCnUliHKx8ZXknrUOLj6AyifHfBgjLYgA4wdA7vWaLS+l981R2p4jSAUFDZkMX5iskwdPThnOWAOwSxTnr5vgaR3hju9SiaAge2DYfj9OV5gqLWB+nIihy2jQz7hs6Nn28JQXy6kyYe/M6uNaFLfuPciRQ4lStcpPoKU4qDhNgxFAwVNsAeXKyefleNo0517IQCIn/Ol002UAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6vh1DpvH7Fuh67YABHRxZlVFqSzCsAbJuG87GYst3g=;
 b=haNlXa/FbQHFvf6RZKwC8y0IMpVztzDeER9o7SJ7S1EbWc1qtCLpNYMHCFxrhnN69CzzgXMdxubdsRWEOkVd+Ip1qGR4V1VGr+QRp1jDPmthTkM7W5VzTH2HIPBkbVZzp8GDPbPCuq2CQsnSzZI1x+ot3vd72kWMbQ5CMCudllQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB4857.namprd10.prod.outlook.com
 (2603:10b6:610:c2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 11:42:16 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 11:42:16 +0000
Date:   Fri, 5 Aug 2022 14:42:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [bug report] ksmbd: fix heap-based overflow in set_ntacl_dacl()
Message-ID: <20220805114200.GM3460@kadam>
References: <YuvYoM5nknSDxJFj@kili>
 <CAKYAXd9PDUBLvoZqS26mMKqdS6J1b-MQ6LNgy=W7POjXu_+L4Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd9PDUBLvoZqS26mMKqdS6J1b-MQ6LNgy=W7POjXu_+L4Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc0664f1-511d-4aa0-41a4-08da76d78bd7
X-MS-TrafficTypeDiagnostic: CH0PR10MB4857:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFCTql162BDzZfx6/UApoaBn4NCGheeFtmCYrR7R2zaCss8MGPWrdgDaTAX/AkbIWFh9ZOR8Dp0ASahTlCMTJc1Wt5ZxtPUQrecFixVaIe6VNZXLWhNZgW5xm8oAdwh1afgJi3QVG4J09/DjBOhzxERgHVDHtDhuONswG7NYPGeWRtzQYdUGJv7TJfmffxbdePsNU88D+wzhaCaZLIELFDvAF4jK0JoJorSVRm7hwtaEhvpfnZwAiYJM9ySo9wjEu5E9Rel7dGVsXcoaczS1Ys9BmzjBgBTKZ7f+fDsA73eS3ZjFw+oDqigZT/efj7BjrJi3n3lVn1i93YsMqjxbLwfsZgN9FoXeh/QwZDKNeQNFiJyBo4ESsbGG96TWeuzUMsDMW3hkBabwpSn3o5OaZbSScH8sqfiYoVPUmnZoIifQBW+aZsX1pqLsDNcwIJv42fXmbx+p2hmxuAIzovHG5H1gqWDBaLTeGZkm8/+uq4LSAfhsLQjXDmB4uPdSctx5LOrjgyMxXyaKi535Xq3WsA3HN1+89KmDE/Hh9M7lXw3+wCUq5G4Nai1juZDWVxsSsd6AUdABFzk1AFa3riGkk0Tm4lYxoUBjaH0NmH6jYMm5r43pcacrcXUkzg3x4i1rhyYu+Rxk4bysPzQSJRWfiNWMQZOTOLS1SCcu1kFy+g7AMm3KIoZu6z58CSHGQar5kuNOUBoPWmjhYSAo6a4a59j8VvZ5VoClxxxMJiaKZK5GA+uWL1FagZz4x3YK0Rhfx8waPqWAyI/VnKHMFzoJs32wKdaSM1kv7E3QFuzdx1i/yWoiV5Q+PUIzv69MxTNIQ3cGFZZq4YonKh0O/Owgrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(39860400002)(396003)(346002)(376002)(366004)(966005)(6486002)(478600001)(86362001)(4326008)(8676002)(66946007)(66556008)(66476007)(316002)(6916009)(83380400001)(33716001)(38100700002)(38350700002)(26005)(52116002)(6506007)(9686003)(6512007)(6666004)(41300700001)(1076003)(186003)(8936002)(4744005)(2906002)(44832011)(5660300002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BF0AIz+ckN64P5Xdk9EAWgCtbTrqJTL5xIKOZOVYRcF3FDHHdf15YDnfnaA7?=
 =?us-ascii?Q?p3ddaIMVe0gk9+WdHExCtRVC83oSeaf5w9FX4JXFBPjuxwai+R49MsClQGUz?=
 =?us-ascii?Q?g1DbqWB5LjEpoBvUuDjvA0eVHhNQqAOtHW7b6eO/bFF5D/7h0IoWA8m+HD9D?=
 =?us-ascii?Q?WCdlBj1R1cNIYKyWvWcfZ2U4+lSOhhnusLKnvPv6/Xvt5xNaDGr2mEMHf+17?=
 =?us-ascii?Q?Z+xqiouKFEZnFOYSZaAUplYjSgIkmnuOp8lGTq5XYx4tsE/pNDJ0TyoSXElR?=
 =?us-ascii?Q?RuFiiVp47j63VUWiPBN1Vydu4grDA6krm0vxqvcv3gfB2+pcpLOzI6OqMzAc?=
 =?us-ascii?Q?l/OTlO3gkePlfAYTNNyYqmYxSPMXYBX21GKcxgenhnwhwb8Kkc9c7U4UneJO?=
 =?us-ascii?Q?cxJPXUmK6C3HhjUJfkl68v7VoH9TI/VvmXBc5A6IsgcpEcHGwJVbp66YnSKM?=
 =?us-ascii?Q?vRwwN0n82io9lRikAWTO4tBakjrF7Lbh4ovZ83ukjxB5ouKqa2OmrzsgBL+2?=
 =?us-ascii?Q?CX/M1a5bpZ00rkfetaceiN/mBmaU/UzVjUcuzYCYdKBr7rP6YowHsOQnY7R9?=
 =?us-ascii?Q?WHpGrs1Zw7nY+2hmZ05t/BYR5/cOKR0tzEOYysmt8v0woym0jKj/DaYtENtx?=
 =?us-ascii?Q?RW42aNXHMdSZBkfzWd10iIJdgBl5rs+i/6HF1rxrCPMbNTb080ARLFfFApRG?=
 =?us-ascii?Q?+V/sKwxNaO3C5dFd6TxVzplP55vZlx7x+K1UUHqb7X6O00OfZUwOQ1vddrad?=
 =?us-ascii?Q?JfEXhlVqT3X4ZY1bm3ADiGikHNXoEqzlIZbEf/emiy/ifc2Cmxss/tNon5CT?=
 =?us-ascii?Q?UyMpzBVabQy/BaK5jgyCmEZED0TiXhctIQWk+1ZqNrxKMp8QP7JWEYmrLQcP?=
 =?us-ascii?Q?vQNj+lk62463W2MiefD8t5dxxxJ1Aow81ViKXNeAm3rObvIRmEJtiKsMTvx6?=
 =?us-ascii?Q?Iwz42sWD4ypWujl1ulMzr+T0BlJj6ErpwNhDwtZWvplL03yZQgIpmrw/35Cz?=
 =?us-ascii?Q?eunyAIkP8Fq9DjdCYg8cYETWerpmfGlqhcBkYq18Sipw0sBcqEYqa5pEcewO?=
 =?us-ascii?Q?LB92wP8GIunIdmY6tul/HgCOa0zk6CWrAhiTltimWctvyfAMGZG5xDCyg9mS?=
 =?us-ascii?Q?E5PGkBBi8aRFqtmcQyuA1e43ynDPHPLWEF3gb/6e4497AhMqpSxR5WuZdcwh?=
 =?us-ascii?Q?/H1U82V/UXyDABFfChERDVtaUhX2plcMKyetswpAzzx9DBEh273Ja9XOwFbB?=
 =?us-ascii?Q?8cejFn5irk76lNpwiNBGLcKzDCHONStlpKFGVjqWomYzJNpTRSZd2fxFhYxR?=
 =?us-ascii?Q?kZvNnytADdEtTccffyU+Wy4ZfM9JZfExyLEDOY9zVDAJ+yRFkkKF9uag31tX?=
 =?us-ascii?Q?OBVcHz3BiezIlIG4D8n/O/Z+ggnrySCgcRwIX3SGfDcXRyIEiXINZIVdgQwa?=
 =?us-ascii?Q?Tp7LOl4ATbNJM8jhmSkRW5PE05Oi/yNDZWdvuqjnB81kWgn2BaiERqTlbDb3?=
 =?us-ascii?Q?+A0HKZC5hUwgfuYsLQ1y4Jak2utJGJqDf/tcCMyiRimHJVm2p1Z+8FksbfeW?=
 =?us-ascii?Q?z55KEWSp1w5kquVHC0bSSgvsLmKIrp8DA1E9Rce7v+OPrjOJF4RUI2gCrIin?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0664f1-511d-4aa0-41a4-08da76d78bd7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 11:42:16.5188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSqLlpuPxItOex3HA29k6zs43twCAnFfJxmby2wlboGbiwYHtLowdewHEKOYQ2K2eBWCa59nX2wamSCndCKsyexdcH53A1C1DV7MqyJUZ4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4857
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_05,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050058
X-Proofpoint-ORIG-GUID: BvdTApAailyj_inTUlQ4DKZ5fIPl1gK2
X-Proofpoint-GUID: BvdTApAailyj_inTUlQ4DKZ5fIPl1gK2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 05, 2022 at 08:03:04AM +0900, Namjae Jeon wrote:
> 2022-08-04 23:33 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> > Hello Namjae Jeon,
> Hi Dan,
> >
> > The patch 982979772f2b: "ksmbd: fix heap-based overflow in
> > set_ntacl_dacl()" from Jul 28, 2022, leads to the following Smatch
> > static checker warning:
> >
> > 	fs/ksmbd/smb2pdu.c:5182 smb2_get_info_sec()
> > 	error: uninitialized symbol 'secdesclen'.
> This was fixed on v4 patch :
>   https://marc.info/?l=linux-cifs&m=165939383203779&w=2 
> 
> Thanks for your report!

Oops.  Sorry, I didn't realize it was part of the kbuild warning...  The
kbuild warning didn't include that code so this was the first time I
was seeing the code myself.

regards,
dan carpenter

