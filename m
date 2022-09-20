Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E5AC54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 19:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiITTMK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 15:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiITTMI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 15:12:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE8375FCA
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 12:12:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/adUQOyIN4A4uWl9uEpdoyuL5cnPx36HEJuN2LN4DrcczvK0cc+9FeottexKrJtlkG0epD2qtT238VufDUrs3x6qBSTA4IJ9UtnFbWOAnVRz4Wh74BVkQ3af3p4wRHn6d7Unz99myT3aqKscc2t3pOM0D53CnPduW3eDtlilKmLlGxH3hgkunYOaw6h7ojLbPMGhiovRu9fsGLOs1mj0Uvoo6gJW9DWU6iRar/pOtZJWmOXL/UhFhDkpFyd/YFHxU5jIMSj+R43LgNjZNjtstg1JMgKvIuxDfxHKBPygE/Z7w7Hi0kBzKsBCZ7KWsrVjRFlwYVRLNxm4f66itYuMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZgDLwEFHQ1pfwHTEiGW71QYNoQcGIlBbW5QUThqBHs=;
 b=jabjO8VLlyYvwKvYiAOjtO+uv4JjXTkgr7c6ArZ46e5GKl405zkbYtV1iZmXyU7PZgnbIZ8Njp5lQgTJ87/1i+eTlCDqd1FhJNUCVoTNwG7U+rWXlZby6H5Yzhhf0y9wzbBa9f/kUMe6NIbH9I8fP75TdXJ1Ua7dt8SrLratSu1Hj3uMOvf2k//IqF/pU+W+5RY9ZCp5itQ4Swcn5W1436TemjGPDKUsaYUlSupUBnWHIebpWjVH+66in4YdhK2OBPsclqcZ23iG6IeUNM83v4Y7J0sNeYIV/GLN1ZYj9+i6JG2xLmTuwodI7kOPYFyx5eLRo4IQG7qsgHtjFaMVyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 CO2PR01MB2021.prod.exchangelabs.com (2603:10b6:100:1::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.18; Tue, 20 Sep 2022 19:12:04 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8])
 by BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8%5]) with
 mapi id 15.20.5632.021; Tue, 20 Sep 2022 19:12:04 +0000
Message-ID: <490e8a90-5c34-810b-157c-e5fb832c2941@talpey.com>
Date:   Tue, 20 Sep 2022 15:12:02 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [MAINTAINERS][PATCH] Add Tom Talpey as reviewer
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mt-jYkgr+YBUitbj+hsx1pwdbA43ZqV+uLWmQZE=MPn4A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mt-jYkgr+YBUitbj+hsx1pwdbA43ZqV+uLWmQZE=MPn4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:208:239::15) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB4438:EE_|CO2PR01MB2021:EE_
X-MS-Office365-Filtering-Correlation-Id: 658eb7f0-47f4-4a61-ffa6-08da9b3c00d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NH8/fYQvVaU26X0pe6hKhoa72KwxtlpkxoAMnCDRETLL1X74ivr7UA1h0hzJzgbf1vSdhRq9PfXavPMvljASmR1ksqdx+36VJEKoK/Tnvzf2IsOa3SD20wxrZybfv14Yjl22+PmZFoE6KuVHwYHZjEmbTqXMmGKo+MFakzq83+XEyZ2hubbINrXh8TxkxD4cEhFShOrQiuSl8nM5DBoxOPuGY5hGgvkBcKWYTgsaxlWNLzROjT5Vs4Dc+NCyaQ2OHbCpho+GSY/fAn+bxgxOSEJtzR+IrYrz0zJHvDvVPce308sbi8kpwAv/esEa9VztIRtup+1gMvi0VssAekIBFz8vgVxHJ6+kkKgM8fZvli4BeewBTuUYQNk3tiXpcF2cSAj3Q1ztBhJBqgInvYIW4SwDDZ8VhX2G4WhaHGbyXChX92CSyP5wTZzwKhwQ04fYjICJgj0W/45IsChl+U0y7s0yMV6MXquMQxlXKdZHTjjHDMl6FcCPLfVna4t2DxI/vMTgviIkkVdzmgxa1xHz+7lnOUNhVk+kng9b+Iy4K7nyk7vuu0NVOiD24eAWKJ7hkR4icVi1zidNvOGI6pxRMh377TBjuQFIwDrWNRlnSnpoA5Kd1Hn/UEOrw3TPNYw6W8HBP3169L8CaiLHOrh86UjMhbJzOpQXpxhCxwLH3JtnD6n7k/6loHlS1Ei+9d9GDy518k6OxTvQCz6H9c9UWxZvLWvBic1tmAyW3oQNYsxd4rZ6ygj04BaAHQUPgHwsSBoMmlqVP9Go8rC6RFsRp/c5mCEn6Hz3zcH1cQW5TpE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(39830400003)(396003)(376002)(451199015)(41300700001)(45080400002)(31686004)(478600001)(316002)(6486002)(36756003)(38100700002)(38350700002)(2616005)(86362001)(186003)(110136005)(26005)(53546011)(52116002)(6506007)(6512007)(66946007)(66556008)(66476007)(31696002)(5660300002)(8936002)(4744005)(8676002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2dPVnJ5cm1tM0NsblZUYVpQMkthaXAzQkFoeVg3V2dmRUlkRFoxNERHY2p4?=
 =?utf-8?B?R2grRkJxeGJZZFJjUkdQT0dtcHRzanJ5Y2ZOZlpyR3pFblc4WEwvcTZvNXBm?=
 =?utf-8?B?VkNTWmM5U0NZTThDRnZFTGhiSXo2b0hGRHVMcHYwK0V1N202Uy9aKzhrak1O?=
 =?utf-8?B?TFlqNVVFZnJ4ZFJJQURnTy8zWnNSb0p2V2RGaXpaQ1JoT2VqSkRRUXA1dGhr?=
 =?utf-8?B?VGVzeUxtdjZNVnNub2wrYk5zOWIwZXhkUUdpcTNHbllydTd0aG5GM2dCVFNt?=
 =?utf-8?B?MTU2TzZTM1VhU3hYQ0FQQUNiSTZ4bmJkNVdEYWVzVzA5Z0h2VlV4SGtid3Iv?=
 =?utf-8?B?Zk9OOWdmdGlXZkxQcktuRDYrbEF0cmlYeFRzTDY4WHI3eHJPV1NXaUZQRGR1?=
 =?utf-8?B?K0FrWHBIZTZ5b1ptYnpDL3JOZXRYMXpVV1NVUER1RW4wTDJRT1NMamMwMUdW?=
 =?utf-8?B?VGpzTUI3L2Nrd3dEcGdTcXFkKzdJRWJoZ1UybHBSVHNOb0F1ZDBlazRUU3dm?=
 =?utf-8?B?YUtpL2JiS20zWjI5ai80WXRmY2xyTnBZNlRUd3pEZGRPVy9aRUpkVlZ2d08r?=
 =?utf-8?B?UFhCWlQ1T04vTU5IK1JCZlFnc1NzTGhQK2RxYndaUnFhSmhUQjZnR0liU2tj?=
 =?utf-8?B?MG95V01XOEVmMzlkU2RmdU5qTUMvUEVSYnA0ZnpaQ1YxaWJuMEkxLzdvT1Br?=
 =?utf-8?B?STFDZ3NaOCtuWUxJV3F1eDEzeGxxVm5vQWtEV3IrMDdaWmkxa0d0U1d3enMr?=
 =?utf-8?B?QVFvb0x0UkZTM2NYSzdnSDJoUkhWQlZnc2ZoVXNDa1ZXUHRwdVh1TlJScklV?=
 =?utf-8?B?QXJDU0M4TGZzTHo1T1JxMzBpeW5WaTUwOFJES2VKZ2tMakhIWS9DTU1LdmRn?=
 =?utf-8?B?SmkzTVBEYTVuYlJrRU01cWRjNTRQcHRuUCsrSGs3dlByeTNUeHRXaFhBbmR0?=
 =?utf-8?B?ZlVKOUVCWmExb0VURDBkV1hSQTB5OGNyRXd4RWtOVGpnMERWRS91azJjYzg1?=
 =?utf-8?B?ZHFzU21hQ3I3Nk5vOVB4RkpiTUtnQ0pJOC81VUxQL0xUdzFqVVFnbmoyV1U4?=
 =?utf-8?B?VnNuWmExcG5hdjVnalRqNmNNSUNFS2svM0kvcDE1ekFURGNTNnREYU1BZHR3?=
 =?utf-8?B?MUdvZEVMVzNkT0xKZStPOVJMdGhyek5XYWlGSTUzM2paYnQ5NEwxKzFhd2tu?=
 =?utf-8?B?VmY0andJRDlJbnBNVkR4V0I4eWxVOXI2WHhkYmtYTWIzN0d3dVFLeEpxdDVH?=
 =?utf-8?B?NHNzVlJWYnNEY0JVOGQySmdKL2F4b2xxclpmeG13Q2s0dDNWdkV4b05tYS9G?=
 =?utf-8?B?Y0YvZnowai9kQlBLSzcxb0FNRG1hM05ITWJKTDI0em14dHJadUNPWDJPVFVD?=
 =?utf-8?B?OEsxeUhweUdRemw4VWhhQ2ZwR2h0R0JPUDRmNFVWMUo4Z3pEaU11UUpJRjJx?=
 =?utf-8?B?K0ltdWJ2TG5UZzJ0Rm9GZTdOQXJOVW1vTnpCZVdqS25pVVJ0TEhwWWdyTkRO?=
 =?utf-8?B?QU1xY0ZmdjYweTMweWVwaGREemxZZXFHLzNudWpEbTErdlcxM213cjVtMENk?=
 =?utf-8?B?Q2Rld0FvVXZYQmhsMUh5MmtqQkI5QWt1b2RUblhNOGExOGc4Y3JETmI4dlR2?=
 =?utf-8?B?elFmT1NpUU1UdmtBZm95VmNHaFhzSThBZnJnQk9NOU5XVjJrZEFBV0NkVHo3?=
 =?utf-8?B?dUtqMGpKYVhWdnE5QnpGTFplYzNabGVUOThpZ3F6Z2JhVStuZzhmRDdUSGV1?=
 =?utf-8?B?RmFzaFBxc3dvR0NFNTFQSExDREFsWHVwMWxJbjVoNXRjRkRWS2J3NndOdEhW?=
 =?utf-8?B?UnNDNzdZbEhWRndSV0JoN0tQK082Mi9yVjRTVkd3aGozL0lKN0pyclh4Q0hw?=
 =?utf-8?B?TGFOblhIbWwwYkdxUWppbzZLRittY1E5SVdvL1BoL1VHUmpMckorNW9xbzR0?=
 =?utf-8?B?YUVnSXdCOXlpeG1aMFZNWEM5UmZOenFvR3lVNmtlWmJ5dGczMzVVZVUzaFYr?=
 =?utf-8?B?bUh3QjlQbjVSeTQyNWo5UUsrVmtPRU9kTzZtZTZhYStSbDRJdCttcEE0em5o?=
 =?utf-8?B?aVNtbXdEbWdDWVpPM0NlOVBuNGwvamxBdm42N3dFVWNSbXJtUUNDWHRaZFZX?=
 =?utf-8?Q?dVe3V/AElXH6dzh6rYQtpq95G?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658eb7f0-47f4-4a61-ffa6-08da9b3c00d9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 19:12:04.3632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ZqJNTGTBq+PQe1Eh8hbo6r3tFIIGQUAVEbBf9VkJOcUx1o4+KwRSE++U0Y3K2uH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR01MB2021
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/20/2022 12:11 AM, Steve French wrote:
> Tom has been reviewing/contributing a lot for RDMA/smbdirect so note
> that in the MAINTAINERS file for cifs.ko as well

Happy to!

Acked-by: Tom Talpey <tom@talpey.com>

You've REALLY, REALLY got to take my obsolete Microsoft email
out of your address book, Steve. :)
