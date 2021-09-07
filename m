Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262BAC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EE96610FE
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbhIGIud (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 04:50:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36226 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244005AbhIGIub (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 04:50:31 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1876HKNp017560;
        Tue, 7 Sep 2021 08:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=G9hTDQK6DSZL7m4ZMkCNv9KudbY9EWKaRH7uWUP3sAQ=;
 b=Bi3fONvmtmf2OlSuGYkrXd1IO3f2/CtfeSJY+hHwbfuaAxr1sGOMuVDEOJoiAGntXGZJ
 kHh4/seNAHjq/vZGZIcEQRnnYBl+ntg/9TstCYBlNFnrfhRhhoRLRjehPl8CtGw3atO0
 Armm8mHzlAmk9/ZlRNYa6z73czx4p5p4wzCsKrC2XTTVitE68vcCQrVZEFmp3ADLsCxV
 lYQ1QZ6zUYj+2XpB8sGBvWe8KplNGEVISKFnBMzWPwEf7ZMz1/9wuDl/obI6TVD715yx
 C6GsH6J/4hDvrdNWId3DmUDOLfbReLUSLyz+I3pqa1ysooJ7yARiNKiXZvPa/MTdi/xb JQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=G9hTDQK6DSZL7m4ZMkCNv9KudbY9EWKaRH7uWUP3sAQ=;
 b=l4qAcwxEVRR4bNgoHhJqqGWqhCS+XDGcvBqq6RxXEGQu4E65S//x0jpNwBxp6WwEuhRg
 QfXEbs+AcsBsD5b9Ilq6B5YWpOWWESUWraj7pERzVdQhwHmjvP87d8rln3Q7IN/bfi/g
 pgSYSJEq2rj85yr46RsXs3IRCWBXPmkrTZnQlNroJ2HPvBduftredUKrQVgdQSYQntnK
 2OJNuIba7tXPb9prHH6YUqbN68O1NqTm2CByy4mtGMHUg9NpeSI2d4RpWEAIKBlIRzkX
 gQcMjO+v3loj1Kpav3iZ+Dj1rZ3QE27obWgckDKd7YIofilwqDNCJ6HsJjui8IHbPNTa VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3awq29h5fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 08:49:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1878eEEW118352;
        Tue, 7 Sep 2021 08:49:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 3avqtdes4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 08:49:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXJ2ks2qviihbrbbofd/ZgN4DD4q+oL0uCb2o90fXPR7UUlFAz24ARYHASJqXz/qtFcwNxWEHK6Fi6MhkF4551PtDdrFuCokbN1vNW06osMIU9IrR91hgY5oDHQYcYyxcDotI1NsIPKVIWquGj/j85PghWH0GuXpkBlwW09GyV1VFk8JUiMcvQctaewWhQWT9t0Zks4SomcCiwUFlM0Qoqt88P0RpdjZcVH83IVtm8LfdtnHbrVHn63Ka53654fH0iAWZ33hGtaTipQTQS/N+g5a9pK6mzivSXxccgc8iAI9ql4pkPo1jOzp5xXuju2vH9VW6yeOSmaBIfOj2wwOmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=G9hTDQK6DSZL7m4ZMkCNv9KudbY9EWKaRH7uWUP3sAQ=;
 b=mcu6jB2mKagrjm8YDu3Ytt5YYApWkW03EUaTVPpDIYCvs2cXWmYJYlwchTwXW9G1hlh+CFR9fEQwtDk4DDlinMz8Vd3Chp1+CMJIYKoTkOAl4N7rcv37ldsd6BjqybV3RfDoe6Ix0+StUdCkqUapSjQ/4ZjcZK8xDJhsJsXrj5SzAv+DSKZntv1+BVnwnX63tGAEANYRYmM0UWTpkxJkiMYwGNBfnF0QdVOLJ0plmysCk/VguuErpGSmDhWGRM7XVZa7tJ2ccUSZtVwZ6oeLWB1HkPyHc38bGNN7T5B/HNSyBLoJQ/MyMvU8gIh5YwqkicnSz/hmZAjEUcLH9WB8Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9hTDQK6DSZL7m4ZMkCNv9KudbY9EWKaRH7uWUP3sAQ=;
 b=FAR6+sBkLNPkkSgHwXy4fZybxDgfBNJ3ZjGx1C0nip3vmURzMLdZ6/CMSE9SilKL5ATmQqnHWwFMhlD3cTbNvax5ip/U7ACuYIQcIQKdZrx3Qeq8wiqwN44Yogp4juU4HL2h5c7juGMyJHTJJsGd/+LVre/vmhj98r/UM8sM2u4=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2159.namprd10.prod.outlook.com
 (2603:10b6:301:2c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24; Tue, 7 Sep
 2021 08:49:10 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 08:49:10 +0000
Date:   Tue, 7 Sep 2021 11:48:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: potential uninitialized error code in
 set_file_basic_info()
Message-ID: <20210907084851.GL1957@kadam>
References: <20210907073340.GC18254@kili>
 <YTccRzi/j+7t2eB9@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTccRzi/j+7t2eB9@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0009.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0009.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Tue, 7 Sep 2021 08:49:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f856b8c-8753-401a-e850-08d971dc5c27
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2159:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB21594A0315EB12AB90AB7A998ED39@MWHPR1001MB2159.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LzwlIEwGo5VX/1Pn1wKYz5DjdpjrVmJTSOZBnDy2Wsu8dIzIs5xtCr/uTobnGf2aoZCxvu/LYVRUkV/CbS8CbqSiuZZ3v2cUx6Gq1/fJoEUC0U18vRlOeK3IveOdm0C8e53NB6UFzS3I59xYiHY6sz5xaJryk0gE8AVz0HaIGjucY9VWgzkSgHEZZy8nxShJSJdVWeGgry6v+J3cRxwZaRRjOswJDdAEUZnsdpAQpLp15E9BnYVUJf3gsDV8qu7Tkjs5w/40/FBtCyYZQ9Cesh06g2dh9jubNFWmsNWQ228j+9KhRZv5VA9+UtXLq74oL+URyr50Tex/oWkOzVyYxmewVd1tHjWczCnb/zA8Ufo/nPJs98eHCHEPFeYaIh2ahkikP85PW0cA77VEVxvYS2dIv24XuIbIDA/fDy7YaH4DvS8Chzw800Y8KheGiirreGMBXl4EZ8y7WVgsvc1m2twJyvl80eSOZX0aDH30/ShdxnR7ZxcpUQBFagoF8pz9gy/wxGWaBU17bnJMZ9fI51oB+3XBxZDSyfhaiTWUhYoP/ZbmM2/OAlNlubh70v99Qm3QngajzKPEt95CV3EEUIKqi1uNIYv+9VI81Uek0hRVj2x9br7OMfJbSzzrt301+q86gzvKZWOnpgVbFmpSh/i6+JRroYGlPFy52ap+SqeCSWAYkA7Nz7XBbFxCpoPP3E3AkS2jEKNSKhp2LJMh+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(186003)(6496006)(4326008)(2906002)(44832011)(26005)(33656002)(66946007)(4744005)(508600001)(54906003)(8676002)(956004)(66556008)(33716001)(86362001)(1076003)(52116002)(6916009)(38350700002)(38100700002)(316002)(8936002)(6666004)(9576002)(55016002)(66476007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X6FKfUvymft0LE/+hTg3eZ5OCwbQj0xmv3UM2bGW2eFCDV8zMatTS/uDA5li?=
 =?us-ascii?Q?wdjJHglpGUaiBM8gAPG48wVst5Oi34XTV7JnkCQUR3o9rp5s/RGkU89GzH3o?=
 =?us-ascii?Q?pQDJcdNuIPwEYatgrQZ1IVOfR1ovF/DLWL8bhapJzmX62kFTj8EGEDe7YH7J?=
 =?us-ascii?Q?Rr0t5GUB/ZLq1sezcyI+l9WtVjhB0Nt0xK6KkdkE91G5mJN5Ry1PHmW77DuV?=
 =?us-ascii?Q?yGRDC0HY8QR0SkzTBpftDRU8vgYTRuEK8c0LuyknKzX5TR5eZo+N4aJJNfMt?=
 =?us-ascii?Q?QqGQpV8MUE0LL+a2T/6sm3teNvmD6Uv9DSk4WRCWwNBEDdtUT6ite5vnyIqX?=
 =?us-ascii?Q?WK7MCq3ANOIyRDNDDBp3RX4qpx/1VC9KuX74B9+MWBgcfPkh1+i151reOmhH?=
 =?us-ascii?Q?ssv73zH2k/0rmGH7RnzOFSNM/QgTpq1unds/s6XweGg6brYR0vE21RNTuVzQ?=
 =?us-ascii?Q?k5DwyUVN5Rh0aaFsbuXVDiP7CWZFFWnKHB+UfC9VegPhyC3fzQ4Le9oBeXiL?=
 =?us-ascii?Q?FKArWtOjFMpD+GQI4kcV1OSe3LILsVj832pPAJEa4QnX9TS6H8ItJDxq0RzX?=
 =?us-ascii?Q?7FizAuvbifvEayscEoOIb7aUDw6jws8Nu4QeAHRZknsQroO/bRE+Pu6zhAtj?=
 =?us-ascii?Q?tbF5TI7qat68xsvaDNlWVJR3FlzBbp9UAGkslU/P+F9vHZGuedi5mvren98o?=
 =?us-ascii?Q?+KD/9o/GGyTGP8YDKXrEDgM51Df1LWzOQjdkPDDazAAprjG22+PyOtonEuKY?=
 =?us-ascii?Q?QeGWuGizJyhIfabVV3XetywTBfYOlRepF1zcr9aS4PgImG1m7RXPny0oSfqe?=
 =?us-ascii?Q?ZG8nuarMYD+WmLwJkD4rIr+bQSXf3bCS4ihEzEEQm9ZWAsYPvVBU6JdcPsEC?=
 =?us-ascii?Q?CtmDcB8nA9SpxyUWTHa1ahB1D3fnS+AGLNGoWNVKbFaNuCTqyHZ8d1Bn6fo4?=
 =?us-ascii?Q?r0J5vOkbOqaoBVBhUM5QHPExH7Gte8HAw7yIebKQ1AyfdyhpQhWgv2JLR/fN?=
 =?us-ascii?Q?27d+YVmDbt6P77vUlZeqW6Z9dcAc1sbzeNz/0IHNmhgC+q2d9RSmBrht41LZ?=
 =?us-ascii?Q?kF6PB2fR9rOnaHOBv6tffIW3Zlw+j38R1JPfT4OCsuCyilQWg3fY+TYXUrZ3?=
 =?us-ascii?Q?WacTnXK7DSOhK5BczC80VSLPCc1BBHbmK4TtYQCA4qoZv96Lr37m7z3pirkN?=
 =?us-ascii?Q?IxNwkSxYuJl+Q0lBeOMOijrTTKwBPKR5BKyw5KPX1W1s+T0yAm4juekwewC3?=
 =?us-ascii?Q?2x0fOUw1NSHZf/YfxS6ksJU00KlB/64Hwy810+mFHC32HyTLBVLuAjdHjwFa?=
 =?us-ascii?Q?oLz+W+rO6rrdpXapH/x9O99t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f856b8c-8753-401a-e850-08d971dc5c27
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 08:49:10.3638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6ik/rfdypP/nZWoO1Opzg6+4hPGf44lz3VEPcl8prb89UmDV9ANo5OF8S0HOn9YvPlM4Dm4UtcU6TG1labsYihwc+UBOElOodbgHFQFd9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2159
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=713 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070057
X-Proofpoint-ORIG-GUID: nyc2E3hJo9F_pCf8OW_gEDsupmSkUkDH
X-Proofpoint-GUID: nyc2E3hJo9F_pCf8OW_gEDsupmSkUkDH
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 07, 2021 at 05:01:11PM +0900, Sergey Senozhatsky wrote:
> 
>                rc = setattr_prepare(user_ns, dentry, &attrs);
>                if (rc)
>                         return -EINVAL;
> 
> Either it should be used more, and probably be a return value, or we can
> just remove it.

You are looking at old code from before the bug was introduced.

regards,
dan carpenter


