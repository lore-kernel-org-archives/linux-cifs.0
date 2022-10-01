Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AA4C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Oct 2022 23:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiJAXWz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Oct 2022 19:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiJAXWy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Oct 2022 19:22:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A265A2ED
        for <linux-cifs@vger.kernel.org>; Sat,  1 Oct 2022 16:22:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmcWvcsbOKBW6M5M26QkHrLIVsHY6DGcIrYuNkLd81beRf8MtfvmugAJRhwPXTQLIijTICGdTTvmR+4UspAHuT/rcgC33cckWoqtbfW3QJg7Cb6jH1y75X82eD+hAKqBqCvQHTNX68Uce04qEs7NvMFFNudP0RlElPdjSAWXVM/5KLR+kTNNak5gnAU5yCN325SpOcSlWN64jXcHLxXp57xPvNHuXU2OWsA4MZtRhuAxC7c1PX7ncH+cJ6lzIJjAGXsekDMjcfmcMCO4smhOozVyKEd6y9VPDeN3qo/ssZZXJ2PIeUYaBMZmUGBmcbuZ9yVEnf2G36R6GDrn71E65A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3T2DawNDQV5zK52dOsZQuQJ/dil8ofb38e3jCwvGug=;
 b=nuGtXF0YZzTx8W2wq09ix5hRuGikYJz5G07nYDMGgIOy3c9oR+67L9oeZme+lTcURiNXxEtJnTkSh8yhBDnQufP83R9fs1LJTeBu+5UnxA+2j7fgkam1N6FWuPr4KjAoldeO/ClAaF/m4RaNNVLnkjpAFJJ1xOyzVYZ6CfoP48tIK4NbgLCBsS89e43TdOrrcDqxzQ3ZonjpTgrJyxJk2f5yfWo9YFyXHib1Y3DG8YL3yETfEfLXfea/Fb5YFpE/Ig9dWw1qkKkLFp8Tcy60DidAshTbyZyGIcndP6BBLJ9s7Y6pQnBVWQeAQgOV1hAKusKnyC0++cc7UYBNn8PUCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB4256.prod.exchangelabs.com (2603:10b6:805:ae::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.18; Sat, 1 Oct 2022 23:22:52 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded%7]) with mapi id 15.20.5676.020; Sat, 1 Oct 2022
 23:22:52 +0000
Message-ID: <df473fde-e79d-ae90-37bb-3a3869d3aa9a@talpey.com>
Date:   Sat, 1 Oct 2022 19:22:49 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH][smb3 client] log less confusing message on multichannel
 mounts to Samba when no interfaces returned
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mvS6_AXjbK8sY_dEWUbmtRjodSYEtxeNz_NST9+EyC96A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mvS6_AXjbK8sY_dEWUbmtRjodSYEtxeNz_NST9+EyC96A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0142.namprd03.prod.outlook.com
 (2603:10b6:208:32e::27) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB4256:EE_
X-MS-Office365-Filtering-Correlation-Id: a846dd21-20c4-4cfa-685b-08daa403dd05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ZBvhi+vDcg0PgXoeMTdHPkO6vdkwXx1yFKcGI4Q3/iDf1G7l8GVeG2oQ7mJqMXWAoWYt3maPOzsKkC2PEM92a43OtOhKSJ5oGrtDguAuF1B/fIuiIvx6FOq4qLulnW+tG+WzC6j3qFI3wq5HcgyRIyjQwDXkWv4SvtmzjVyd7erTrcsxC120cxW+NSjcDzgyFMd8pataBztj3h94t+I+uoWvk3J6SQ/ZdjfGm+miCB6Z8qJWzPyzUkc4ulLSt1TX5bte18zIZZn73tfNzYNgriGsF/wAFjKExnr0AW6eFYU8wv0QKG2POl9fcCPFk6T/9FmsDoUPLudXb3dIUeBOu43xhcgchx+1W5NnH2Dz7PCbwd5hA2vm55ufqSE2l6ubLFAI1r6a+uP+hduK5LqzV2RUviHo+9RwcHfy1oovhbWZGxIoB5FdCFTnbqnENXf7vL9c973ql51fgRG9wB1lat8LV+V5PIHdirGal04e2/qVWibztl5beZ2YY+EGydO8F86w4HnT+1vjFIfVTv7aGzJNH4TDFZVG0+GHDf0ZYbL/za2z25hM2K7zI1m+I9gVp4EiWoSnAyTdnlFZJqkMIlVmZ9LXlTOiP2EPsQwite825dB999e2TJvrF0dj0qx2uOWeR7Uqg3opDDBZ7fRKCXDs/zG8cNDHc7/ExobCFeRDvSlt3R864YzqKsBvoZec/2CstcfCx8Z7nG/gNCPdJ+15ITPToj75iF5bVKdDXqJXNu9xL4lMmIQZfh7uT7LHvSI1aO8XKWlFXKhcFTjFz84eYDVZgWHJ3jxsnGlUS0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(39830400003)(396003)(136003)(451199015)(41300700001)(8936002)(6666004)(53546011)(66476007)(2906002)(45080400002)(6506007)(66946007)(4326008)(6486002)(478600001)(66556008)(52116002)(38350700002)(4744005)(31696002)(6512007)(86362001)(2616005)(186003)(26005)(38100700002)(5660300002)(83380400001)(316002)(110136005)(8676002)(31686004)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDE5THI1eUZxM1NuMUZhVERGUFNXWjdHc3FPT2dRVlNHRGgzdmNNYTE0SWZv?=
 =?utf-8?B?ejhwNkZGdzdUT3dnWkxjVk4xNU1DRHh6MGhjTVJORkYwUWJMYWxqM3I0R0VF?=
 =?utf-8?B?QmJjZEltV3hPS1NKVGEzZ3FCcGwwdXhvTmhHWDE0RGFZMkJXaTUrNmdLaVd0?=
 =?utf-8?B?ZlhUVHdUT3JKL0EraWxOTmZTSkVybTlRV3d6SzVpZEVnYmZRUGEzcFR2VE1H?=
 =?utf-8?B?S2N4T0JGUXprSDRPNzhpdndhYzEwQmxHY2hSTWljYkZ5UzZ3QktJbVZFSFBv?=
 =?utf-8?B?WTBNdHBhMW5VM28wSUxZT3hhR3F0dEIxQ2VhM1RUcjNmaHhNNGI0UzZreGVy?=
 =?utf-8?B?bVd0WW1vUXJtZlVFODVHdUhpR2JHbG9mcGlwVmNPUzdpRXdaWmRsR094THly?=
 =?utf-8?B?cWlYdGZPbUppRUVxRGw3Ymdmekt3RnkxTkRramJLeGptclppNE1KckJEOHov?=
 =?utf-8?B?SStuNlMycTZwVGtYTTl4VzJzQzlONDBrS2kyY0NmYkt3Ui9jVjJhN3NFOWVa?=
 =?utf-8?B?TkpuTk1WcWh1dUovZG9vTFFmWXh4R2JiWVJ1QVdpd3lBSVVlTDFJZFV4dUVx?=
 =?utf-8?B?bVFza0dnS04yMnBGSTd5OEtid1AyU3JQT29Wb0xHOHI5L3JpMW9XK2VkRkg5?=
 =?utf-8?B?MzhodHRBN1N4QmpjbE5xTDAraFk2azhKY0FOZDRNb2Y2MisvWGZ3NGRuYWFZ?=
 =?utf-8?B?dXlndDJVdk40ZFEwWlpQWTdzWFh0YTYzblNFdEoxd2ZwajVaQVNTVnBtU1VY?=
 =?utf-8?B?dnM3MzJRZFp6K0txSGIvcXlGblF5RnFIaWdFZ1Z1VDJnVGRXVEtyNVhsVkFu?=
 =?utf-8?B?SU4xYXNZZFFNTnp5eUVvbnNUYnpEREhaQlZHOUdnajFHd1I5M3E0SWJyQkIr?=
 =?utf-8?B?WlU4enY2SXNnMWtNMmNOT2J5M1NBYU1JTjJTNnUxdW5TcjhLMi8ycFI0TzBP?=
 =?utf-8?B?ZmNmb3JFUlc5TGVZU0pwbmtXZ1MvTERoZ0lEaSs2Rkt3Ly9aekNYQ2M2WHht?=
 =?utf-8?B?QUE3M0VlczQvQUZnVVRScHZraG5MUDdBa1dRRHZ1UGEzdmcrM2FXUGErTFcx?=
 =?utf-8?B?UVhpSEpGMk1kcjlZSDJ5b0MrcUNXMHdNYkhTQSt0Mm50RjlRSGU3NFVNdVJX?=
 =?utf-8?B?eWNZM25OQ0t0YVZqYy80eFVxUnNWbTN1NURFMG9tSmFlbVF2ME9IbGlPSFQ0?=
 =?utf-8?B?bmlITms4VGNHaEVERTNPbG5VVzkrbDRpWEdic2lIOWVTQjhLZ1A1MWNkUGFW?=
 =?utf-8?B?YmlKK2x0azh3WVZOMTE4OWJDRTNvYXZJM0J2NkVnV29FUnh4MkZSUEhwLzNu?=
 =?utf-8?B?S1ovT3lxUEJoS0IyenpNVG9NK1p3SExjUzdyclVMWmkrTk84T3BwSGFCaHRC?=
 =?utf-8?B?d3hoYTNwcVlTU3NMWGhmS1ZxYWJpZGcxNzF2OFhVTFdiNlNoYy91M2k3MFJD?=
 =?utf-8?B?NDEvVVlYNVZsdml6LzNRT2pEOHdxZE9iTmcvc002MGtGQ3JoVXdEVlhscWJj?=
 =?utf-8?B?dXZnUFRsb0J3Q0tuK01MZWVkK0k0dWRZRFhGWFRmZ25ET29xcENiaFoyRTZn?=
 =?utf-8?B?YjhVc1ZweHlKa1NCZUE1ZjZqenoraWpnNWdVNzMyVWJ6cXEzdGx0eUhLUkRH?=
 =?utf-8?B?elRsTEQ5OVVUbjY5cTZySWNNNTVRa2pwTEZhM09pTDAwd1RwdTJxa1gxa0pG?=
 =?utf-8?B?NVV0bWcxc3gxS1BlQ2ZKMmhCYkdRbzVscklNbGhET0FxOEhXUkdlSUN6S3pS?=
 =?utf-8?B?bGRpelFRZ2RUUUxiRnN5cm1mWXQ3TmZoKzQ1TkVuY0JLZ3ZxeENFUXVIbjRZ?=
 =?utf-8?B?WFlYRlZBckllRmZYT0R1WXBQWFllM2EyTFVFenZxV1VJVFpES2liKzA3RzFT?=
 =?utf-8?B?Wk1TazMyODZMY0ErbnBEejMvc3E5NmUwZm1ZZzduS3lNTitPWTM1aHJ2OGwx?=
 =?utf-8?B?OHVXdStFaDhkTG14RngzYS90YVZ3dHZNK25Qdk5hTlJaL3JYSzVYSzc2SWR4?=
 =?utf-8?B?QVFYaWlzTTRMVE5mbTZVQU5xeGx0dDViS1NnZlUwNVNueGIxKy8vM0liTWlk?=
 =?utf-8?B?OUx0RmJRYkpjWDlwVUxBL3hXeEErT21IOEpVdEROZUhoMStCTHBhNlV0N0xW?=
 =?utf-8?Q?6K04Y+uDW3nDIiW9wX7NUMb8u?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a846dd21-20c4-4cfa-685b-08daa403dd05
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 23:22:52.7885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /iR2VMHdXYSxUwUZKhVsqL8bhaQUin3gy3Z+BO/Lf+EJsCgRfDsJ8Qtlqi9fgmkW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4256
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/1/2022 12:54 PM, Steve French wrote:
> Some servers can return an empty network interface list so, unless
> multichannel is requested, no need to log an error for this, and
> when multichannel is requested on mount but no interfaces, log
> something less confusing.  For this case change
>     parse_server_interfaces: malformed interface info
> to
>     empty network interface list returned by server

Will this spam the log if it happens on every MC refresh (10 mins)?
It might be helpful to identify the servername, too.

Tom.


> Cc: <stable@vger.kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> 
> See attached patch
> 
