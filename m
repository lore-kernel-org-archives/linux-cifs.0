Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E005EEB64D8
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jun 2023 18:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjFUS3d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jun 2023 14:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjFUS3Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jun 2023 14:29:16 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2056.outbound.protection.outlook.com [40.107.96.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2702139
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 11:28:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDs3B9E32Zt1rNMZ/7j0HQTTFyY+s5e1hGUofsttnLJkPZhtdGE000k0ls47I0GjjL3Z2MmzVe+KQhQpfVIeI0D9c/FtA8CxcpphCSrtvI5laFpMLdXblwQdNzOL9LumVTliI+GtQLcD8vV7RhxIGW/d3+rjh/9GsB0tAVxgYyM6vpzv6Jk+6Fxbf5BEQHM+7sHAt09y1FvAKJFWSKWPlsSXghsOJGsJ93YRuo7f4c/pS74jnt0atrQ84mWoe9jVQaQHKmYJ0pv0ZFGXV7d8a2FaXQw9zj0v0gGAvFP3eBjHHYC962avp4WVCg+KkbBdJ9JPLAtuar+F0nawSRedww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Q1tBtlKYeH7RybBaF8A0zo6jx+MJY1Vbkbhn4qxdEA=;
 b=eAqMMxPwYxyZAUvexd5sh26zg8Hmd+iT8rVRfIFu9vXWT1KOrHEL4fish+irDCLUbsFjbOVwVmSqx/yhCLbvpw4UtTdpxyX/hGFVK9SwFPeUmaTf2eR2NO7WOxMAOAgwwBlUm2UA3GIkcjuVh9cPkFyKnk1Tfw9MzNCPuQ6qYo3oUyJNh8q+HAafEk+B8swBfYfYu53lWU9fQ6AIyAMd6twpkgX/vHpz0Hys39XhfMTGwIRQGMb1VIye8lqXzuh/PQs9+Ks3/nJKhcCNKBwvjzSXRjYmVRXW+OxDp4L23R16wjE9I00J1wEdYcWHsXJVjP5j66OLRxoLqEVHTYTIWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB8117.prod.exchangelabs.com (2603:10b6:510:29b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Wed, 21 Jun 2023 18:28:12 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 18:28:12 +0000
Message-ID: <75b0589f-1e7a-2cef-3a62-0f8b2437eaf1@talpey.com>
Date:   Wed, 21 Jun 2023 14:28:13 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [SMB CLIENT][PATCH] print more detail when invalide_inode_pages
 fails
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
References: <CAH2r5mvpS+XPMe_taXe7W8fc2GaG9eKVMXtUZQPg3AzY-QKdMg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mvpS+XPMe_taXe7W8fc2GaG9eKVMXtUZQPg3AzY-QKdMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR18CA0001.namprd18.prod.outlook.com
 (2603:10b6:208:23c::6) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: cfc96750-e86f-4609-98ec-08db72854570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AH/x8XWnEt1y7pL+w/ZgZnxKrSuRX1oZGXILTSDa0N2mKoWpfS7wY/bnC8iZRzOerN33T1FsZiJ7Alx05xQ+pEGR/7Ji1T0I3irzDKbagvG/Nba80wslwP+snYP1zPUeqp29mHHXB88w7J2lbORn3mfpt3zkaC2+2SFKJ2PjEc6HHy3gJzjhdMY6kOlB2cR7jmQJ1EcN2sbVOS+uhSxoq/2JkfTizM1xHf7ywErJOBAHdrsXtWWZp71Kku6NMrccUKtEEgq7bKHJQISqn7xXBheDx2F7nThujk6ByBeLluLkI/MSMtmWL6KA2zTM3Hd9e9nT5A+KRUR7Ua036u0H7CZbI0kosQApWTvBhbdyaZmRNJN6i67nWro0deC5oxR3w1+c3daNWAGVCvRmIyT9M9x5o20SAiOswXw+plpIrGJRCL+BImhzlWHSNKrtgYtGAagy0/ad8DBun2QILsdDQd7EccpoNbHZxANANuN6oJNnvgGTKqtUMVtd/oPG5ICBur9FfRYzpEnoFcWXo6+C0vd5+Z1T2X9IY7Zr0nAN1nR25p8ZyUVT9XxEB5jO8jStVHVYoZ+BU+lMAukM2J+Yhz/5j2CPadBrb5nS19Gp7mwhgKu9isoxKMiiLwGcSMJEUkxkrW+6LQY4tfuOAbXHOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(376002)(39840400004)(396003)(451199021)(8676002)(66946007)(186003)(8936002)(4326008)(66556008)(66476007)(5660300002)(110136005)(316002)(45080400002)(52116002)(38350700002)(6486002)(36756003)(478600001)(41300700001)(38100700002)(26005)(6512007)(53546011)(6506007)(31686004)(86362001)(31696002)(4744005)(83380400001)(2616005)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUwvakhnUlJGczJaZUlGajZqMjRjQlZ5M3dBeGwxbE4rc2ZwL2Z0YU12MVhY?=
 =?utf-8?B?Mk1sQkpjV09FN3VleEUybW9UOVlxKzNyOFg3ZUhhUGdlTFNFVkdSM3M1OWIy?=
 =?utf-8?B?b0tJYVNJZTdva2FCME9jNXhmT2hIZjZrVFZxamxuZmIxak1ubmwxTW5PdHhQ?=
 =?utf-8?B?azB2V2NydDFJV0tTb1IxaWhYaE5LV1lxUVFKOFJWTE9XM3NRMStUUWJjNTVD?=
 =?utf-8?B?RnNTL3NjcXd1cmIrbTB0ejYwOUhlM3ZISUdKVTdTSDFRQ2tpazcyMVpaR2Fl?=
 =?utf-8?B?YnJxQjJuazdaMDM1d01naUpJbkR4NXJkelYrMUtZck5YaTVQVWNPeUZIa29I?=
 =?utf-8?B?SVozZUhoY2NCblRqRjVScWhpdmFrWE4zNXJrSVhOTVBOdHd1YlJYaEM2SU5Y?=
 =?utf-8?B?MWRjZktKZVFVWHNSTXNrcHJ3TVFHVUthVHJ0anRvcE5aaXd4SFREZ3VBczZH?=
 =?utf-8?B?L21hcis3RVNjQkVaUEpGZU02ZlIweVBhUDkvZHJSL0hVSEdBRnZ4dnJ0WENO?=
 =?utf-8?B?NVEzVFJSUER0QW5SeHV0amdFMnlDZUJsWW14d2Z6MzlaYUhveFE4S29ZbXYx?=
 =?utf-8?B?cGNFeE12ZHNCYWZBbHNYOWJzazlBMkRvK2xtbmt5R1poV1JaWlhaZ2JGQ3pv?=
 =?utf-8?B?Q3ZPaURmdE1DaE5WWmpXajdJRG5JK0FhVGxkVnV0TE1BWmlYcERoU3gzd1da?=
 =?utf-8?B?SjYwVENkNkhmem52MHpIby9tbTk1Y0NWYUR5MkI4ckdwQ1hXNXhCR0MvdDhU?=
 =?utf-8?B?RmJJT2d1VDU5ZUdZTENETFpuOGY4U0ZxQzRsRXJqZ0JuSytZV2pCclJQQ2FI?=
 =?utf-8?B?SERxRmhLaFNKclpQVzNJWU15UFZVWmNwVlU0V3l1ZkhyS3hINlVtNjRtQkt2?=
 =?utf-8?B?Q3FFbWNJR1dmSWFYSFRvTEVWUi9hQlY3Qy9sMmNJMmRSSlRMRFlsSVFTTUs2?=
 =?utf-8?B?M0x6cElvZFNLUjI2WlhqTkNManQ5eTlrTU8yYm1Cc2krSDhGVVhZQnR5NTJT?=
 =?utf-8?B?QXVreXNkdlliZGZIa2lqQm9ldlZuZDFkclk3TTFpTlI4Q3Bjd1hSK2hwam5a?=
 =?utf-8?B?cU5mL0JFNERTQUtEZWdLS0QyY0RMM1BLbmFzKzZGb2RGSUNPamQ1NHJSeTQx?=
 =?utf-8?B?dE5vNS84SHBRTHgxVHlSZW94TFJoTzZhSHZQRkhhVlZ5VVdLT0RBM1hoTW51?=
 =?utf-8?B?eGlYTS9YTDZkNkg1cFBBbXFLcS80REVta3lkTHVvNHNkdDdnVTNyK1M2aDNw?=
 =?utf-8?B?SlQyNHBJZ2huN1gwckQ1elA3UGtpWUs5UWhkdVF0Z0pYcWJJSmdWOWdpMmp3?=
 =?utf-8?B?c21YVUM2RnF0RFNxWmV0OWFzcGd2dy9QKzhlc25Va2w5NFRYTUVUUUlqWU1O?=
 =?utf-8?B?QlZVUUt4alYyK3l1UEJQeTdUZjNkeG5KOGd5TGdZWDU0WDdLVTk3UHZDOEJU?=
 =?utf-8?B?eXVrVWI3NzVuWG9mRlkrc2FvOThFeE50S2hESmF4cUZ2R29tTUR6RnpTQjZK?=
 =?utf-8?B?RDY4QnhGSEpObmVVVk9TSXBabXpBc2p1dmxyaWQ0ZHAzSk41V2ZBTGE2eEVN?=
 =?utf-8?B?R1FRWk9ZOC95cVI4T0NjNCtkQVA3VG9qc3c4SHJNaTRRd2p5TEpzL2JlWnR6?=
 =?utf-8?B?eEgyTjRmcDk4RUhOVUEzdVRMaWN5N2tFZ2hZQUpnM09acUgreWNyZ1p6bXNM?=
 =?utf-8?B?OHJrUWl0NVNhWEtIUWhob2o2c2ZWZE5CUTFrZllSd2NVYjR4OTFWNGJXQmIx?=
 =?utf-8?B?RmVWTnFFTzZXbEF1Y21kSW45ZTBMSXZYalArMVUxNkQ3R2JYclQzZGE1MmpJ?=
 =?utf-8?B?Yko1YndNRUFiZmpVblZrNittR2tNOWJGbzdUNmxHbFp0Z0U4WmR1OExhYWJC?=
 =?utf-8?B?cnErRUxMWG5COXczcGFoQTgwa2d4d1lTS3FkRXhIcnRlVGttSVhkRjdCZENh?=
 =?utf-8?B?bnYzYVMrNXU3Nkc3SnhCaWhnZzgweUJSZ0d2VTVMbkJYZ2dkSWt6bUVIVTRn?=
 =?utf-8?B?c1l5djMzQzlvbGV1bjU3OE12Mm9GeXFJamxMcmpxSkRxUkRNMEtNT2xsYkpy?=
 =?utf-8?B?bTdsb2hmeVRKR052WllIc1hSNFJ6dzV3U3Q1RnRuRFQrRnNQeHI3QS9URnc1?=
 =?utf-8?Q?xY4KIEut2drgpOpaQyY9c+V0V?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc96750-e86f-4609-98ec-08db72854570
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 18:28:12.6015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8DKbYhNjvwZx/8rbrT5rFs+rrt9uZQvbqHYNwx3gX+Lc2a8mLhqqQmY9dMab/u8K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB8117
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/19/2023 9:52 PM, Steve French wrote:
>      We had seen cases where cifs_invalidate_mapping was logging:
>         "Could not invalidate inode ..."
>      if invalidate_inode_pages2 fails but this message does not show what
>      the rc is.  Update the logged message to also log the return code.
> 
>      Suggested-by: Shyam Prasad N <sprasad@microsoft.com>
> 
> (see attached)
> 

It's reasonable, but should we be printing kernel addresses like this?
Thinking Spectre, and all.

Wouldn't printing the inode number etc be more useful?

Tom.
