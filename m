Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D654EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 13:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjF1NkR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jun 2023 09:40:17 -0400
Received: from mail-mw2nam04on2073.outbound.protection.outlook.com ([40.107.101.73]:11265
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232123AbjF1Njf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 28 Jun 2023 09:39:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkYl1uyQuwVS1EGpAWS/sTWUQCxBwzYti0g2Y3bVhdPi4sJ5FliE/EDgRmv8LG4q6hjSS0KcnBg0vyfOxmhhr1kXRsqSzJc/vEhE5Vu69h95V/9530Y/5Ml57w1r1IMGpS1yXuqWOKYtB6sDFd4RCu2O34mTFQiaWKTUblgS3EYOWmJk2vcNAIYO0gfZfNua3bXS50eewKQpod7Cr+TNXYntvwIk9t8WOXvQIoytjI00h4zQmWIkumrsA/qMyb8vUUmwjQnMhcvLry0uf3LMLo5OTf2MJ+iCBP15pz78IOjuzRk93DhJsfv0Se68THdq9/4kPFMJzyuanC7U5q9z1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OihemvsfSEcAkX5vUuxN0rRjlYi2+DYlXLtFHwNvEaM=;
 b=jWRpx2M1jDgYjW+rEtxNAJ/wGlaTWjKxpk0uqSIJgq2ih9KnYSPm0nFu1cONjJymfNgVrigWoRUGyseiMf//uEPxxVjpZQTFDX0Ne9PaUt+nIVZoLYDQXoFjfl1OR7FFoc0yVm3BQCtOyLfB9XAnwR1iuMVNUZH9+G5cBu5KYDWsmHmFtiNe3P8K7BCDBCQ6COEZuFV30zGP8uBUNVYQ+aXGMHK57D5zn01vpKiiBqejM6DJ6SUIYuhcMcbZgUq5g8/q9hw5p7CNRdjRrPbs4Z9bQZtojEB9bIE8/crPZ9Qs8h6J0kxjpKvqUwlFNBWCdy7ZjpUf7utirgW9Z34GrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CYYPR01MB8310.prod.exchangelabs.com (2603:10b6:930:c9::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.23; Wed, 28 Jun 2023 13:39:31 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Wed, 28 Jun 2023
 13:39:31 +0000
Message-ID: <12279206-25f3-0d1c-2db9-1010b3526d12@talpey.com>
Date:   Wed, 28 Jun 2023 09:39:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com>
 <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
 <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
 <1ca61d08-6e34-48aa-62b2-e246a5bb3ef2@talpey.com>
 <CANT5p=pW-O7UQgfRKR6XpFnnFka9PVQQ0y1YtOz+DcaQt9yH3Q@mail.gmail.com>
 <CANT5p=qdS6FFj9ay3bDiP+mWnU1b-NJp2TLb0YdAFyvkqZcKFw@mail.gmail.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=qdS6FFj9ay3bDiP+mWnU1b-NJp2TLb0YdAFyvkqZcKFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0418.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::33) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|CYYPR01MB8310:EE_
X-MS-Office365-Filtering-Correlation-Id: 03bba060-84f7-49db-6a66-08db77dd1a41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGSzQ9AQjDvrfiq1WQHDg4NWn7GeJjJ3TnwBMnUvH8Jb15cMcc8bhOm5WU1R1k6VCG4BoTkaha3VDiTMptNqXD9a+J7HRg0zwGenWQFIi7hYeCfYgiH4X3C9GdW+xQdJwdbgLCtrXeRRP72O+sYAMDO0R6WQTYjc6W4h5IU1VXE6apdf0VAvn4VTLDqvRPhEKaId4qDdkupUvjJVRDUP+X9h8UR+DRVZQRfVQclJOmFOrQeOU73KNPNoWnK+KBUiFSVPi8fkh27mhrG38fh/wBn0M9zRzYIwuzllb1IUxFZG0uraZnQW7PXd24+0rFIlypWTjNeeVpXD4lJoyt7lvm13wQMG5nKtdP3FeXTxhN96EzrXO2FJjw4madDbUhsX85YzObJoUTUtv4PdUQn5QNnjmLy+o6FkuU8rU+W0CSmeV1homRJv8PWiZIEbHWdmcsKBrBR9T4Z+9buLiC05OYk4vpQv+dttK2nXcAMta1V9EKoyj95tQtV60vZY7vs8MOLz3JuXljtW4Jjn3C3B5snYkQ+gbm3NY89wA9DIwV2tv7HjKQV6IyYKaF3sEMBevxMzI0wCdicq/2g7ayWdXbmu0QhLJaHuFmtpoDmPHrUKTiLioFOv21Nl/oLDNUtqDOTmJ2irwh0RX4M+Ygb2Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(396003)(366004)(346002)(376002)(136003)(451199021)(186003)(4744005)(2906002)(2616005)(316002)(66556008)(31686004)(41300700001)(66476007)(6916009)(66946007)(4326008)(8936002)(54906003)(8676002)(6486002)(52116002)(478600001)(38100700002)(38350700002)(86362001)(53546011)(6506007)(31696002)(6512007)(26005)(36756003)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWdNR3VGRWg5VkF5WENGZVdDemM3dGxYMnUraklsSDJXVUppT2tld0pUbVRL?=
 =?utf-8?B?Tld6V1ByK0NBRG9uUkZUcWJNRkN1ZVB6VDdzQTNIQmtGZHc1UjlpWGFxQWNm?=
 =?utf-8?B?NFBQWlBwNlJ0K3Z5V3JxbjI2dXAxYmxVWmdqU2JKQVQ0K1RML1JNTitnRnpn?=
 =?utf-8?B?RlZlRzNJeDhjTm5oaExObEVMenEvTDZuVnVWM3VvSzViQW41RHBSZkF3akZQ?=
 =?utf-8?B?Q1ZESkgzTEI4WElCeGJxdld3Rnh5amxLZkxDcklFZzRjMS8xQnB3MDVQM3lZ?=
 =?utf-8?B?cEFqWVJUK1ZVZFRnMmJ5MHRIKzFMMUpZVFNFcWczV1NSZWR3QmI0cmhVbTBQ?=
 =?utf-8?B?VnNOYzFyUUpTSWFaQVU1MXBFZUp3MTdpNDJyOXQ2N1YwSGlrbncyZzBxblov?=
 =?utf-8?B?emJ4L0h1MzNuelhFd0ZmbzQrbVM0VDBVazh6NnRTODhoOThvOEk1WEc5OHph?=
 =?utf-8?B?WHE1KzhNWDVTN3pCd2RRbXBQWHpwVGs4UXFmYWIvUXZBVDZiVkZCeTFtellj?=
 =?utf-8?B?UXN5bzk0bC9lZVFoTWpTMEVkczZjWXZ3dDZvbjFGR2NnT2h0UnZ2eHJ0cU9F?=
 =?utf-8?B?bEdMYUtiSjhoT2FUL09KOUtZeDNMaGxTb1d6Mkdjd1JxbjV2MVdEL2ttbFRn?=
 =?utf-8?B?MGRxY3k4dmRhRGRVdjUvc0VFRy9ldXowcHl2V2NTbExjenhPQ2U3bklBeTR0?=
 =?utf-8?B?S3BCL2xvcmhzakMzblJENzlsVytiVXdRYlBKU20vTzFLS2wyb08vZVRmd2tJ?=
 =?utf-8?B?UDlkRlkvQk1xV1Q3UmkveHRnb0huQzh6UUYzZUUyc2hDUDQ4VXFUY2dnc2d3?=
 =?utf-8?B?NnRqRmlLYzhOT01mN1NRZzVER3U2VyszWWpGYlRMQzZTYmJMblNKTHZXeVVP?=
 =?utf-8?B?dStpVW9aUkV2N3BYbk1EVnRwcHN2Tk5aUGRqVFNKdStFTkptWXlxTEFIbS9K?=
 =?utf-8?B?WmlRWmRKTWx0SW9qanpoa3ZuQTM3RUVHcVFpdDhSMUYzaksxekpmbFZZLzZj?=
 =?utf-8?B?T29hSGNCTDNRMVhvTVFSVzFHL1IvSTgxRnUvb1V6ZGZ0ZHJwano0dDdTUkg3?=
 =?utf-8?B?bVpYTldGdTB2aEhrNndDSEQwR04vYWM0aHVYelVCbTdzeVdiVHVlQXNUbEtl?=
 =?utf-8?B?UkQ0SGVmcDVkT21jaVBYVjArWnR2Nm4xbmwrcG1lRkNqbU12d3hER0Q3aVpr?=
 =?utf-8?B?SjVleFpxNmI2YW5qV3VySFkrVUJkNHlrR1VNckxpbFJCR3M3eW1aL3VWaUJD?=
 =?utf-8?B?QzhIZllmSWJPeTBacGdRVy9DRWtIY2lRQjc0T0FlaXhwQVJvblArMmY5cWFX?=
 =?utf-8?B?MDRaK1VpdSsyQzNYUGVGR1FtOVUxUGo1bGZmSXVsck5oV3FEQXIvcGU2MGNH?=
 =?utf-8?B?cWczYkZLY0J4cEY1VE85NCtyeE9lbFVHL0Q5Tms3QW01ZVVzUWorSUxRMmlZ?=
 =?utf-8?B?WWlSWXk4OFAzR3prS3RZVlQ5K01XOGI4MXVmNEdMelhWbTBKNFpYVnp5RVdT?=
 =?utf-8?B?QzVsdUhJVVg3d3NDUFRoUDhtYS9jMEdDRXpobkI2SFYrNXB1QmdEYjVHNE5t?=
 =?utf-8?B?bU41cWhUbytNa0pZcTVxT292Vm5EU1RDTXNMQVlnVUkyaTRtYWxHd1h2ZG5n?=
 =?utf-8?B?YlQ3cDdCK3N4ekFzaGNSSThxem1GSUVubXRJRkR2N1V4cHM3MTNXazRwWjAv?=
 =?utf-8?B?M0ZUbkZneThXaXBhZ3BuQUxJTVNWWG5TTWlhUktoS2Z0ZFRaT1ZVT2lMOWxG?=
 =?utf-8?B?dHRhYUFKMTdwamU2RU9TZWVYWUlFMHBmRktXcThmb3dka2pSVzRHWnhncmk0?=
 =?utf-8?B?NWI5amthQUlJV2U3aDlTQkErbzR2M2grRXRsV2VQRlVjTThKS3cxSTRTVC9D?=
 =?utf-8?B?bmV5SlprV1VTNWQ3WXhaUlViZnRTUmtmSDJtM2hTWVNGMllTNE5kTXdRNlNW?=
 =?utf-8?B?MmZjK29KZGpDdmgwc3F4MFhaZ3BIYTFOV1VEZHBvNFpnY2tDQXpENGZnRDZX?=
 =?utf-8?B?SzBMT08vamd5OG5Da3BRWUdVT3dMNHI0SEpMaTVLUFk1NUxJcktsQnV0SFpS?=
 =?utf-8?B?amU3eDRzbVo0WkhTbUdwOFZNUHVkbnpMVHpOTFZIMjk5ZXpDK3c2NTI2VERM?=
 =?utf-8?Q?Ox0OUFKq7jyDzI6BKQmJJopGe?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03bba060-84f7-49db-6a66-08db77dd1a41
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 13:39:31.6772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vuIE5o2kiiTI66jFhn0O4y9IYfp+TQjIumKVRVNodC5OZ3dZUD08RxH7SJr35XlH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR01MB8310
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/28/2023 6:20 AM, Shyam Prasad N wrote:
> Here's a version of the patch with changes for RDMA as well.
> But I don't know how to test this, as I do not have a setup with RDMA.
> @Tom Talpey Can you please review and test out this patch?

I'm happy to test but it will take me a day to find the time.

Would you like a how-to recipe for setting up software RDMA between
two Linux machines? It's quite easy, and can be done over RoCEv1 (rxe)
and/or softiWARP (siw).

Tom.
