Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F59DC6FA82
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Sep 2022 15:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbiIYPlV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Sep 2022 11:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiIYPlT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Sep 2022 11:41:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D1C1C136
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 08:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ju6lyJ5sOIxALuq2xsHJM+anpKYgdp/NHhvuvHTuG8F19KubTolYPWpOq64tNC3sHA042a1Ebt6sNFsOzVHdRInCVlZT69CP7cwG2ijWcvkgnfCT7XTypOodwv+l4X1Lc5o86LqdTRtWj7J5AQ0VyWY7Vtv79epBGydSJEu8Wt6se5FVgfQwGm5fmD8IJ4SNlU3NRERta9e8CfiBkHX3plz7fvBj5PFWqN5e1OhTcMKpwBZaxEvOoRJ7Vu4eSbbD44431Aub1NybxqypwII708zgcUxv7oyrcd3HKC8g6upixwsxSUg/kr7LphNFHFAT7YpDcu6XhxSTVXFSIs45Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4qt4+CM/ExUa9wm78fAEv7p4jePcxgzJw8BEQOv8S4=;
 b=HU35qz4sb5AMidLiWh4LMz8Aqfmp9jzu1Fv5oO/IeRfERvRnzgkvUIyeEjS2RqNCmmveDbDJ+KFGnLdzHTHGfdS3yFn34QwE3B8ok767ptmH6Vjvnb1mw0Ca/NNivlG8p9HGDkE1HJsqXoNbAwXNXpXoswZesJf3XysBWRboBubO4In7GFGfAbiH/adL4S2N4cLgTzxKxjr+hjpNokiCj1ZHkIbF591XRQI2uWF009k5Nfoim3Pik9mlVv7EO+0XswRnpYoNZhs6AOXGBmNUsGB5FQlgOJ2esilEndRTsqUawzpUWj6+bl60XZkE8AGG/ePoBt/ZEnomjl1dGZ38og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB4923.prod.exchangelabs.com (2603:10b6:5:56::28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.22; Sun, 25 Sep 2022 15:41:15 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Sun, 25 Sep 2022
 15:41:15 +0000
Message-ID: <11e7b888-460e-efd1-0a8c-3dbf594d9429@talpey.com>
Date:   Sun, 25 Sep 2022 11:41:11 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 4/6] Reduce server smbdirect max send/receive segment
 sizes
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
References: <cover.1663961449.git.tom@talpey.com>
 <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
 <CAKYAXd97ZrGVPj3astSWz3ESHKYFQ9JAxeq3z65mB6wmoiujrQ@mail.gmail.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd97ZrGVPj3astSWz3ESHKYFQ9JAxeq3z65mB6wmoiujrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0010.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::23) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB4923:EE_
X-MS-Office365-Filtering-Correlation-Id: 33b2f5ef-810a-49e9-efcc-08da9f0c6020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2W/GI1XXtiRynE7QCUodRrCTHpwI12AO/PthJiUzwz4tdzpIqCMoQmfHbMfnK4wvbtvW703LyY7c03SDspeF1raJvhic+M7/O1S9wT28pVueJD3A+nA74i7vXsOwGtiA9OcBxLPseCbk+JB1Dj8gyxu2b5KN4Ok4RmnJZl9sAcqPfbwwfBYBm9WsfhaXwIcpe12Qco+3z7ueuKqpfxgDQ9Kja8LWoyuv3bEKWRaXSUFyjEPJr6CzeYSVYi9pU67IOb02GDLZTUcgr29J4yzOXpTr8G6L+bKZ8QiT4TLCX6WxM15nZStWXXw2wf1fOYl6+mkYTDlELP8MRa5WQazOmgaJr73Vox31WOq+IQsFychrde+SWrXFBnHjDFVWAJPtGHj9eFLFjvU0iDBF0Ma40obcC+TAnsQzWyZ9fAUBU7whuxEF0orydRhlNTOnrLPCycvXxmxE9lOfl9CuzLPZdXMAR/+jDbmPNjLdKnwt5Mv60n66W5Z+pSHRr8fXsyzNGvxaapPFqRRdctRpz3F2c7NfCYWofkVFGH0ttv7NWMH7964vyVgJ1MdMd7GWBL7zosstSAPaBeAUWBYIAfYb22y/KwN3WM3e5R/bpWq9yfct8if9gzkq1S9J8wxkSQd521MtQnAMoZy9S0pTM4LUg04m9xFF1tN9gFuUwu+14X1QCqcWgIu8NK20g2N/JkyAwHUrt8a79qdh+VZWwNUn+Ym35x5uCiNZvNSfQfyYdso5xyvfcT6fbjmkG6vQctNmT6Vv6ohz1HooQw4Cz478HOEc2UFbU/PZFhPzDuzayM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39830400003)(366004)(396003)(451199015)(31696002)(36756003)(2906002)(26005)(6512007)(8936002)(52116002)(6506007)(6666004)(53546011)(66476007)(66556008)(8676002)(66946007)(4326008)(316002)(6916009)(5660300002)(38100700002)(478600001)(38350700002)(41300700001)(86362001)(6486002)(31686004)(83380400001)(186003)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFN6NUJLVE1HTzRZZkpBL3FBaWlFWWdNOVhhTi9PVWF0cTYvRndMaEtpUS9B?=
 =?utf-8?B?ekl3RGJNTEN3b2RwaGxjMVpGSGhKdjRKaXBmaS82OEl5Y0F3aHltL0ZrQ3NL?=
 =?utf-8?B?K01EQWpMZzBnZFlIWk1WdTVrWCt5UWJENnhmQ3JxcTdXSndGNExjdC93d3NR?=
 =?utf-8?B?QjhCeE1ISVNTTVNlM1cyOEFXSzd3YWRIK2pCOGM2aXdXZUx3VjFGS3pDT3Ex?=
 =?utf-8?B?Z1I2REIzMDZXbzBTSWIrdnFaczJGVHlEYTNTakp3U3FoWDRlQmtLRFNBV2o2?=
 =?utf-8?B?TEpBN2JPZEMvY2IyejJyN3h1dkdiRzZ0RVpOdXc2YkU5bmZQSTVra3FFcXAz?=
 =?utf-8?B?VGxUL2xVcE1jRm5JeTk5U05IRFVBOG05a1JVUXBVQnhnUndvakxiMm5lSzV2?=
 =?utf-8?B?UnpGeVNlMlNzZ0pvVW0yOHZVY2VWV0ZYaURYcHUrazJrZXVaYm1KKzltdHpk?=
 =?utf-8?B?cHcvZDdNNXF3OVJzR2NmeVgwOFhsY2pPZGdjMzJKeEREblhHTkw1a2Rid21a?=
 =?utf-8?B?a25rTFF6SVMrMTRlQVRRYkJUWUF1U0kyU1ExOGhwUUtmTENBdnJMcWhLRU5o?=
 =?utf-8?B?N2lwQmIvaFVQRkcvNjAwTUJVRnBPWjM2Q3dQa1hVdWhWMW44TDZiNWg3aC9y?=
 =?utf-8?B?T0lUMjFwRTcrQyt0Q00xVTB5ZDVPMVRkV2tERzVNbkdlWHZqWklnUFZEOHFB?=
 =?utf-8?B?cWp2UkZ3eDR1UE9mZzdOYVdodDVQRExvMHJjRlRjNi9xakpnWG5FeFVOMGZT?=
 =?utf-8?B?WEJxa0FxTG9wODhtZzdSN0VxTWNTOWZsdXRYblVITkdZSVZMblI4ZGtvbmZR?=
 =?utf-8?B?WkcwYy8wTGcwN20weEd2ajNuZk0wZ2phZzZKaGxoMlgzZkhVOU12ZXFzbHhl?=
 =?utf-8?B?bHpVQk94SHhrSnhaTkZGWFdGV2RsZ2Fma3p1UVEzbFhMMmxFRTJkNzRsOTlF?=
 =?utf-8?B?TWZvcTliVk9rVG5KUG9jNlhMOHZaVURkMWZoeXlsNDYzUzdGWDl2YUY4WWlD?=
 =?utf-8?B?ZUpTWm9CbmlKYm1Xdzh1V203MHNCWmdiVHpXSkVyVmw2V1pvN0JZVWpmeFMz?=
 =?utf-8?B?c3Q0WGNiK29taDVDL3RqUXJ6RGVQTTJjOUFVYVh2VHJObjZOVTRIcGZncFNF?=
 =?utf-8?B?OUphcG93N2lBdGcrVTlRbis1SFcrYUJWMXJiTDAyVFJjZFQySHpkQTFHMm5s?=
 =?utf-8?B?MWJyYWdCWGg3aWQ0WkVhSUhadHEwUmJDbjVlQVJvdm9zYktsZU9Vb0hSbk1y?=
 =?utf-8?B?b2Z0N2JxREZEcU52MytEc0VMV1AyTGx2aFFnMTJuZGI4aFcyZ0tzdUJ3VE1N?=
 =?utf-8?B?MmhNV3JlRVBpQTRQUHhLL1hmWkJBKzY2cUdlQ213b1FpNXkwdno4a2VNSyt6?=
 =?utf-8?B?R1M4cFBrVjB1RUFpMUFmU2U2Vk1IZ3IxLzdlbHdTWE9yZmV5WVV6R0c0KzNW?=
 =?utf-8?B?RmNwNDVET0ZLY3RmdzErdnR5ZHNCTUhNMmJyYVpjS2t1bjVxMXAwQ3E1cDFn?=
 =?utf-8?B?VDdRbUlMRzRpeDREbjByMkNrVGtUc0k3bDNCNDdWaWc2YkdLd1FQY2xWeVQ1?=
 =?utf-8?B?ZzcrTVFrZldIMEd4WkhPaURJMVhXbEtCMjVxcXNMU2Z4MlU2bTFYV3NqYTMr?=
 =?utf-8?B?MHJlNTBteU1EOHRmeUVRb1FYUzBTSDR3WGFJQ0dIMGRWUTl1TkVEYXhhZS83?=
 =?utf-8?B?OUJ4TkpCbWhFRkRERnZGNDNNWENlZGFwQ1loaG9EREJxTjNKNUV1Y2J0NlVk?=
 =?utf-8?B?YzFON3JYdXE5UWJPZjYxdHlVSWNFcWZGTDJnSmVuSjFqY25vOUJDa1FWMldJ?=
 =?utf-8?B?YytReDJHZlNGNTdNZVBiYmhkVVlqOXd4QWZxbGd2eTJrcUZUT2pHMjFiNGhD?=
 =?utf-8?B?cGVuSGNUaWJnanE4aFM1TzRvaWNPaGRVL0JvdG9UME0wYnNoVzRhbWpOeEtu?=
 =?utf-8?B?TjRwRUgvY3p3ZjZmRzMySTlpMGxaYVc5MnVMOWhYWXIvVHRsTnRSNll2SjFp?=
 =?utf-8?B?NHd5S2hHUW9tczAzU3JQcXA3bUtUTm8xZ0JCVXlsQkR2cEFQbmUrbHl5WGFG?=
 =?utf-8?B?M2xwcXZNbVdzbnhab2NIanREYTAyZkF4S1RnOSs4eER5bU9wSFR4NzF5c3FU?=
 =?utf-8?Q?KpNQ=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b2f5ef-810a-49e9-efcc-08da9f0c6020
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 15:41:15.4102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8rgGGw1JsOj3aM6fP5ysBhIhpnuui8B0rDlrJHA23tqd9oU3mb+rojzarWRzyfZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4923
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/24/2022 11:40 PM, Namjae Jeon wrote:
> 2022-09-24 6:53 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> Reduce ksmbd smbdirect max segment send and receive size to 1364
>> to match protocol norms. Larger buffers are unnecessary and add
>> significant memory overhead.
>>
>> Signed-off-by: Tom Talpey <tom@talpey.com>
>> ---
>>   fs/ksmbd/transport_rdma.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>> index 494b8e5af4b3..0315bca3d53b 100644
>> --- a/fs/ksmbd/transport_rdma.c
>> +++ b/fs/ksmbd/transport_rdma.c
>> @@ -62,13 +62,13 @@ static int smb_direct_receive_credit_max = 255;
>>   static int smb_direct_send_credit_target = 255;
>>
>>   /* The maximum single message size can be sent to remote peer */
>> -static int smb_direct_max_send_size = 8192;
>> +static int smb_direct_max_send_size = 1364;
>>
>>   /*  The maximum fragmented upper-layer payload receive size supported */
>>   static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
>>
>>   /*  The maximum single-message size which can be received */
>> -static int smb_direct_max_receive_size = 8192;
>> +static int smb_direct_max_receive_size = 1364;
> Can I know what value windows server set to ?
> 
> I can see the following settings for them in MS-SMBD.pdf
> Connection.MaxSendSize is set to 1364.
> Connection.MaxReceiveSize is set to 8192.

Glad you asked, it's an interesting situation IMO.

In MS-SMBD, the following are documented as behavior notes:

Client-side (active connect):
  Connection.MaxSendSize is set to 1364.
  Connection.MaxReceiveSize is set to 8192.

Server-side (passive listen):
  Connection.MaxSendSize is set to 1364.
  Connection.MaxReceiveSize is set to 8192.

However, these are only the initial values. During SMBD
negotiation, the two sides adjust downward to the other's
maximum. Therefore, Windows connecting to Windows will use
1364 on both sides.

In cifs and ksmbd, the choices were messier:

Client-side smbdirect.c:
  int smbd_max_send_size = 1364;
  int smbd_max_receive_size = 8192;

Server-side transport_rdma.c:
  static int smb_direct_max_send_size = 8192;
  static int smb_direct_max_receive_size = 8192;

Therefore, peers connecting to ksmbd would typically end up
negotiating 1364 for send and 8192 for receive.

There is almost no good reason to use larger buffers. Because
RDMA is highly efficient, and the smbdirect protocol trivially
fragments longer messages, there is no significant performance
penalty.

And, because not many SMB3 messages require 8192 bytes over
smbdirect, it's a colossal waste of virtually contiguous kernel
memory to allocate 8192 to all receives.

By setting all four to the practical reality of 1364, it's a
consistent and efficient default, and aligns Linux smbdirect
with Windows.

Tom.

> 
> Why does the specification describe setting it to 8192?
>>
>>   static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
>>
>> --
>> 2.34.1
>>
>>
> 
