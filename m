Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17C9C433FE
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Oct 2022 18:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJBSMJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiJBSMH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 14:12:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C621ADA2
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 11:12:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKtyHKF7AP6L5exATPHOP8k8eAhnZPvYTG8gT7ovoQlz65faIJSu0nlrvVjqsXXO53cJ3P3FX3LIJyEvf0OH4qAVH32Ovmw196fKkzT4nFETfUNwYm/tQnQTQe/Yik+DoDM7wobxrkL+FBKJEoSpAxXA0TdCWC7D5J1MZijK991ykVVKA2n2hRphD9lUvByZP3RIOtQdlu9HeNnnefu8R7H7SdZm6AWx9qlhEVHxqPL6QrXjT7hE2T0c+UCJ/viMEMV1fE0ZY5QYvR7RezyBoMMiVPWlVFM5/1/cSs9hQQSMyduCoY0lFakR5tpH03ReFnme+YXX5bq68YKx8FWg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLICrXhO/0oEFNrG4w3tFbUtYoj8snTNFVcomYv4bqU=;
 b=AEql3TUPkq0cw5g3ZknYLwFYgyEhvFB3lnsTRKXbYmkXqP8Xvx/rVZo48Bx3O+7O0AbMGDfyzzUdsAW2UqAb2RAQLVGVPlW/HRt/mBAeZ9PVQ4/XZtKfoYHXWP0f7XL40IDJGV75B8L6FO84KmqeckUExoQV401Vard5BNLGYcyaY1Rqc/YsLbepMJTBUmd/Gb70iUmICDnRwatszMqxZBFgBYjT1RmrPJO2W/i48bZKeV3XCnJ6j30IOoKkJNsciy0TF+viJbogfNh5M1E05FZO6me3XTOpDMtyRFseokV7FXxvDDTnjuHDYBKIDAvwvj042VNSp6iTUY+BZORY3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 BY3PR01MB6692.prod.exchangelabs.com (2603:10b6:a03:36a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Sun, 2 Oct 2022 18:12:02 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::b054:69db:e4d6:c1cc]) by BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::b054:69db:e4d6:c1cc%7]) with mapi id 15.20.5676.028; Sun, 2 Oct 2022
 18:12:02 +0000
Message-ID: <7e06ff88-baa5-c2c1-9184-2cb48d6182a5@talpey.com>
Date:   Sun, 2 Oct 2022 14:11:59 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] ksmbd: call ib_drain_qp when disconnected
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com, Hyunchul Lee <hyc.lee@gmail.com>
References: <20221002030123.11409-1-linkinjeon@kernel.org>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221002030123.11409-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0177.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::32) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB4438:EE_|BY3PR01MB6692:EE_
X-MS-Office365-Filtering-Correlation-Id: d3be4666-f5c1-44b3-2c66-08daa4a19aa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvO1mcl57Aaj5aYZIK/NJ7mLJRWN0qiD1uIQXgiKfnH+uZDCtR9Q9WuLQipPjJ38G64NDMX3Sc26XqQlRMsxIN5smSF4XSOFiYHnstJuys35WvH0QY0SWrIuljbn6rMpiQgemBWx3gZrSCpoFK8ui2rdudgFdDBhP2bZaS2+LKF7igYk5ahIzprdx+qGXg4dQLzePmxgLUe4pYkUYs7tlSvDwY8vz+lav18R/ybLPw6eHpg4p4hie5S26hnoW2A/LUK2grsTAaevsmcxXNrMJ2nlx7pBud6QFYzRrqbM67utVDi/GfNm7dsFEnq2c50IlTBaB31ORZmQ29DjMVM8Tzl6YN79Q/dX4YwWxxvT5gFTdjQX9t+NhWAv5BNP4l+TpqOYiAwJUqUUhZ8vTi7hlUb+xoQyDKjSu3LFEZ81hv9NGhiWSgLVURlYntLNkHj3F2ymBmaguzzfx+gpd9jAS1mv4xyhIHBOpMkMNZdy6SRkPGZRg9OYdMREzYK1g2OsEe9Va2M4e8twm7gL35UZek6XjjI2hRLB7c0ZIF+Klh1jkMDOCXu9DcOtSyGWx7oVooQN9xv0u8GR9H9OZp+LmqCntPcz97J9+ch+qVAYPyn6TuIyVuWyCpRXsh6Rr6+7bw2C1YvY9xD060KzlUxgjFLeyqRPBeAFc9U7K1nhNLm1SOuVIeL9HDUZuxGGp22bY0rjYEM4flnV2BJr5ORrkbRvjGSxkWyoEBlB7BpU4KRmy2sBuJXQZ7oSmeW+EJbDwswxX0bFaXvYqJ5PtaU0BwqSC6H8cgT+U0XxCSpmGjU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(136003)(39830400003)(396003)(451199015)(31686004)(83380400001)(4326008)(186003)(6506007)(53546011)(6486002)(38350700002)(38100700002)(2616005)(52116002)(478600001)(6512007)(316002)(26005)(41300700001)(8676002)(86362001)(5660300002)(8936002)(31696002)(36756003)(2906002)(6666004)(66556008)(66476007)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlVKakxRRGxSdmlBOTZLS2JyRWlvaGIwRzg5eDh5ZXZyZ0F4OHpnRUg2TjRP?=
 =?utf-8?B?Q1pnWGVDQWRiSG0rdEFkT1UwQ1ZWK1FQUXNlMzQ0MlNxWDQ1cnN1bkIvM3E4?=
 =?utf-8?B?TzFlaGp5UmQ3UHlMQ1IxWTF5SFpGZWlFTmRTdVhkcDNVdXRWSFRZRUhPZlZJ?=
 =?utf-8?B?WlR5NW9yL0xGRW9qRmpMZDNoRXErNDJsSm00K0xhNDYwbGI3eStjZlBnek04?=
 =?utf-8?B?Q0NhOFN3aHVzSUFRN05ieHRxeDJZSmROTm1xUUtmM09FS00rdkU3b0twN3Bz?=
 =?utf-8?B?blgzTDRpRFN1cFVWOFYwdVNEa3hVZG5xZ09Md2ZLWGlTMEF1RnYzT2dQT2Nv?=
 =?utf-8?B?ZyttZTc3cHdacGdhTG5BajFNeVZXS1JocXBub24vckhzcWxIa1d4K2VkbW16?=
 =?utf-8?B?djJiYzJwWGttUXl4Rmtrbk1nS3kyUzBoWGlvSm9SN0Rhd2pZZHhCVG1uZ3BL?=
 =?utf-8?B?RHFDUmM4cThNK0t3YjI3Z0RaYkR5WmFsOThyVHd5TG1OUnpoZXpQb2h3WWtO?=
 =?utf-8?B?QVk5aEZNUy9YbGtyellCSFlGOWNXbU51WXdTdndYWlJtRitoWUpSN2NFTkRo?=
 =?utf-8?B?ZDR5S2lwbFRMVEloNENLV3hZeTgxS1Mwb056U0h3OVhnVGlwRlB1OUE5dEg3?=
 =?utf-8?B?YVQ0d0U4YitRQzYraVJjL3ZpbldqMzB1Yi8zM1BDTUNXZjFYV3ZQSlM3MzNu?=
 =?utf-8?B?M3l0bnVvWWdEL3g2TG9MQWw4Y21ubzVyNjZRSkN1Znpaa08vQTRkQ3pLQWNW?=
 =?utf-8?B?NWJPQXFad3l5NmNwSXBTaVJPaFVxL3JlVUNmYkg4TUZ2YUd6UTRjbnNHN2dK?=
 =?utf-8?B?b3F2ZE53YzhBaDZORzArS0NIVFhlUTdnQ2Y2ekhxVlBNYnBtTlJ6T0pSMVFZ?=
 =?utf-8?B?WnlqM2xXWlhSR2RmT2RjUmxuNEZKdnJiZ0UvQ0pYcjRqcTFSZ244dzhEMi9K?=
 =?utf-8?B?VGxXc25semxJQmNLc2g0SlhEVDFBZWNkS3NYam9HR3ZQUGJoRGJ2RUQ2dFBr?=
 =?utf-8?B?Q2hNTDQxTE1JcHBsdlQ4TmR0STRqcC80ajN1VnJmeXc5QXpYTHBualhDN0cv?=
 =?utf-8?B?SnZrZDU0bGNhRUo5R0pRM1Jzcy84Y1VUMGtqbWpHQ3o5czJVZ1E4RFRNcGVl?=
 =?utf-8?B?enhvUzVJU1M0MWQyWXhibXByU0k4M0VwWmJNNGpOWFVzMkYwRXhyZVEySTUy?=
 =?utf-8?B?a2RXRmtFNzNobktRcmpjaDFQL0dOMCt4S2tqdEcwQ0l6Wmlubk5melVQSno1?=
 =?utf-8?B?Yjg0NndoR2NmNWcxQXVLYXBQa3ppZERGVnUxRWh0MXJTM2FMd3lsV0xlNUov?=
 =?utf-8?B?VWRkZGVxUVZvU2xJSE5YSW1UNnE2MHcrdHlIdUZaMnI5UnFROGpQVm9LTmoy?=
 =?utf-8?B?SWZqOSt2TXVEcnlzVVdEeXlRTUJKR0s3d3VvNjJ5TTVwMDM4T1BycGtmSzZp?=
 =?utf-8?B?MFJXeFBFaCtRcVFWK1p1VytQcWJpUWx0cXpzc0tIT3BTM1NFdm9qdGM1UWIx?=
 =?utf-8?B?d3FRZGtXQi92OVE4eUg1SlVITFJmQ2xIb1dSTkdsRmx4cWpnZHkzRWtZM2R3?=
 =?utf-8?B?bkk1ajRzRmV6djdlNUhMZTRYbC91U3lLREFORjVPcUxuRUpDaWJMMmFHRW4y?=
 =?utf-8?B?b05CTUpEYUxleGNWSGRpN21oT2VWaDNCbUJuNFF3UElsd3JLTFdMTnNCa0pr?=
 =?utf-8?B?Z1h5SE5hc0l0ekY2TnoyS3BIVmtjNEE0bkFxWUFYQUhlWC8zbVhSNEFOQ3Nt?=
 =?utf-8?B?ZmNvUjlUVWlJZHBqZ3E5di9SdWthWnpweEZ3dFVmUHNJMmZzMkZvczFWVGNE?=
 =?utf-8?B?TkZnd0JiUFVSVXhYRlZaVm1mN0JzQVN0TDMra0dZeDk5U0R4OWQxNnR5Mndz?=
 =?utf-8?B?Wk14b25QWnY1UlBHSXgzczgvbXdZY1V5WDl0TEtVNnBrejFNUnd2VHdKUlRl?=
 =?utf-8?B?MlNNWTRwTDJESzNBRnliQkpDcjZGbUtNZUxqbG50OHVxZXB2YU1OL043WG1j?=
 =?utf-8?B?YjZ0YmNjemttY0lHUE96dURxZjN6WUswWDg2QkpPeVJMUkttdDZwaENSMXFB?=
 =?utf-8?B?MERXck9OTUwzTlMzN21PTGQwZ09HQ2x0cXRoak9BRlQyeFJrZldOY0hJVVln?=
 =?utf-8?Q?4QQWf7bDJGv/of2A99rrToYnx?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3be4666-f5c1-44b3-2c66-08daa4a19aa0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 18:12:01.9724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4bqbpqwIxNtQAm3jHviQGFa4Q+LFH4jphb6EWODveyW/tOeoUMoeN1U2WKBg1EB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6692
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/1/2022 11:01 PM, Namjae Jeon wrote:
> When disconnected, call ib_drain_qp to cancel all pending work requests
> and prevent ksmbd_conn_handler_loop from waiting for a long time
> for those work requests to compelete.
> 
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/transport_rdma.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 0315bca3d53b..096eda9ef873 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -1527,6 +1527,8 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
>   	}
>   	case RDMA_CM_EVENT_DEVICE_REMOVAL:
>   	case RDMA_CM_EVENT_DISCONNECTED: {
> +		ib_drain_qp(t->qp);
> +
>   		t->status = SMB_DIRECT_CS_DISCONNECTED;
>   		wake_up_interruptible(&t->wait_status);
>   		wake_up_interruptible(&t->wait_reassembly_queue);

Because we're now flushing the cancelled work requests, don't
we need to also wake up &t->wait_send_pending, to abort any
waiters on the send wq?

Tom.
