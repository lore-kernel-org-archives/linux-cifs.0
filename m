Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C34C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 15:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbiHXPrD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 11:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239550AbiHXPqr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 11:46:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E364A60CA
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 08:44:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmQBX/54EaSZpFtzHEAaP7ZSt+5vCJygTfhNSx/dTH+uYUiZKhrDntUfodPNesZWN6c5HaM3gm1Bzno1mxF3X2VnvnXJ4wVTZb2tfjdL42z5YENELc0CDppvl1rc6PqLBjcfvQNH6NDuA8clT+KjEs/zbo+ff2jv0XSM/4b+Kkts9DIV42mQRx36vttb/bpvADRSldzK23QLPp4AnQdSB8Q7URMXz0sQ7jGC5pK9Kn+tEvgz+s93wWp50cHKCN1O71SyN+PYIiFAsAdAwN1GxTDqVQYqkentxr7JLD4CW6LEVAbJRWdWdM6QbDfvm9jCv/h/3zY+NcBhVyCzUyJFDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XldbK+d0sMmkyUUOtqcGpIxgdkhMfS78RbQ91fXY0qE=;
 b=KRRTh6hGbxfK6sH6Wn4mAL1haZTvAmJyLxKlH7C01cZLXvk1//gLH2mCRO86xwrR5JCyKeBG41oc2x0bblncrXf92gAGzucQFvcKILy11F1qnymqJPCVwMT9bc0lXAzZAjaPsaIIRrmOUVQEcgRg+mxFiqFe4vRy4WVtrcJ15AgAqCRC8FuXNWtKODAA4tRJdp12pTj2bO9QwYUWvwybu2sXN/7VntzdzibLsp89C91Ht6GVLyp53OWjbP0IDYSvHAOCZOIt2oH1/7/72+jsTN8W0bByTlMEs2zcDRmHZxkRKUbqbcgs/vDpqRBEt7mX+LkPnziEYMXDqGpbW71Sbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN0PR01MB6911.prod.exchangelabs.com (2603:10b6:408:169::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.20; Wed, 24 Aug 2022 15:44:30 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Wed, 24 Aug 2022
 15:44:30 +0000
Message-ID: <4a349c98-0359-acc9-0d6f-0ccac6f53377@talpey.com>
Date:   Wed, 24 Aug 2022 11:44:28 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Content-Language: en-US
To:     Long Li <longli@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>
From:   Tom Talpey <tom@talpey.com>
Subject: smbd_max_receive_size == 8192?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:207:3c::21) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fe39f3a-8afd-4795-17d1-08da85e788c3
X-MS-TrafficTypeDiagnostic: BN0PR01MB6911:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5EyO/zdY9waNaB+F64RO7Tll9O/8BeCYLvRHEBN0BHfwHzWbB5R1jSDggfViNhDJwQCfJqfqsxkrGGHdpYe3Ci2xrFr2s+/MAWqX1INWYC/v6l7VzjjnHNlM/5qq9m1Fg8eWJLaKdKUBpmg0y7sZFAyahIwADaz4c9CjjftTC9gtxNSiwdzgy1nALYqnkzJK+ezE37A67sl9anrAqr4Uf9gQ8vaF3ip+2JKU/f5rWhmd31w5MrlFs5Dgde/mxIB0BxUu3c65CPk0aIYi4xiaPnLe8AQA/6VxRLl/zIwF6gZmtcpjnRDUTJyYWmxmE8eWKi97pNHEvpHuV8MALgidmjjo01S2sEL5OgNzXXgSl/bOJTp1TzxJl3MMvwmbd780ReBb2mDCmWt7jfmpuLGklIBaWXEXf78FgNQVluEFoJ4galps2An++nIesI3+sE3Tk8xHQ42JFvQ4nGkgd1TlPKvz/M7EutrY8syYWQ8cjNeQt9uzc+soz/3leefEW+nOgDmx7cVomZJelOyqsdA7HC36+9uAm7mjNpGOcnnDEtLHqD0/v+utbZT3RDa5fMStlJbQairDDhNAR2V3tbrKQ+tjwCbe1+EdkcRAmKBakybquii7NI5Nd/RoTcTogGD06End8HfpqUGfL95hIP7wSnFUxI2fuRmqQIFm63KXMjl7RVEHaQIbVVkpPqEpIJdySNM+2WD84ucmAPVjLsOcksLmiamcWP56mMCKt2PUME0HBHzpnUDELgtxHZPGbQXrVaS6iQnZgDRc0/YagzsjjKpc7CkkjFC3+yEYwT/X4vs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(376002)(39830400003)(346002)(52116002)(2906002)(6512007)(26005)(83380400001)(2616005)(6506007)(186003)(31696002)(86362001)(8936002)(38350700002)(38100700002)(316002)(4744005)(66476007)(41300700001)(66946007)(5660300002)(66556008)(6486002)(36756003)(110136005)(8676002)(478600001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3RwNW96L0ROYVBtdmkxNyt5QmlhU0lqUEFzc2hxY21DQ2MrQjRKTm9DVzNy?=
 =?utf-8?B?UHZocW16cUhwSkJmaERIcmhzY1Rad0ZDcVNRbjZDYXEvQklWVUVUajFZSDhE?=
 =?utf-8?B?RkoxS0EvMmZDWmNJMmVoYzFOSmZqbGEvSStpa2NxMWN6L045NkZFL2lYcW5y?=
 =?utf-8?B?blNIL0N1eUY2ME1jRWFXaVZKUGJXeUpPQUZLaVhYOXJNclhXS0U2ckZVUjBG?=
 =?utf-8?B?TDFZdzcza29VdUh1c1h0eDl5STJBekxiTVZPRnZIMkM1NUNDakxTYzFJelJK?=
 =?utf-8?B?QXVoQXYvZXp5dnRRS1FaRDFqTzZlcGgweWwyUFE3QjNRMGJnbWdTT3pHV2hC?=
 =?utf-8?B?RkZYeVFKMUlDVDRXcFVQV2t1Y2ZRMmtRVUhnZk43YURQUkpqTlE2T09SRStR?=
 =?utf-8?B?VTBnaFZ2TUtQYXduYUVqazlWU2JxTDNZbk44ckVuSXlxYXVrUHc1WFY0U3Fa?=
 =?utf-8?B?T0NGY2RGUUFZbVZ6UnhTbmgvRnRUZVZYWnZpZkx0bWpEL1dycnFHQXo0MlZa?=
 =?utf-8?B?ZERWMW9IdkxHTFAzYUhBOHUzSkNBSVJjRCtuOW9Pa1I1Q21nckZ1QW55UWN2?=
 =?utf-8?B?eTNKZlF1eUNJMEJaSzZsWnBzYkhMb3RqUGFXQTFvNExKb1VyWVBkUDEzSWYr?=
 =?utf-8?B?V2poYTdxWVF5NFNtUWNMSXRZVE9rTUhkaTl0ZVN5ZUk1OVdqZWN0OHpHS29R?=
 =?utf-8?B?R280YkYzaEZyek9tMzdWcXhhVmpNM0Z2QXRBd2phMmdzaFp3YldwVitCbkdy?=
 =?utf-8?B?Q0hpMzk3T1krZkV1NlJISktqWDNJcnhCTVhlVUFKblA0dDd1SVNJMSs5Z0g3?=
 =?utf-8?B?VFB5bzk5M1pTZ2ZRcE05MmM1ellYWTUwb3RUTW9PZDFVVm1sSE9INFBkcm1m?=
 =?utf-8?B?dkRJUjZKSkJSZjVCNW5oQlhxbHVHeFBmSkVkcWtxSDQvdkFWQU9LVEMwZENP?=
 =?utf-8?B?OTYra0t5KzZXZmxtZVNKVStjRS9aZ0pLSy9mMmh1eFFoR01NU0RDYzFZWm9H?=
 =?utf-8?B?b3FPUUpRSTVCaElWVFJpYjZXMk9Ea1Nsc2poZVhTUXN0dHhXT1dlNmcySk5t?=
 =?utf-8?B?aDFaeGJxb0hiY0FxMUtpVEtEaTlXT1I0WDlhWFNKS1B6UmpMbzFsYXhJYWJZ?=
 =?utf-8?B?THI4WWNaOHphZVVERzd0a2RjOTU3UkxqbHpIQnZCUDIxL21MOGZ0RnlRVHNG?=
 =?utf-8?B?VDcwRERicEdrOUo2UTdMMmZCQVl3U3RuWmNabm1KNENuOWRoQ3YwYzJ6Rm9k?=
 =?utf-8?B?WmFhZk1jaEtIQ3h1VzFUVHh6QlZLN2w5R1ErQ3F3VUNyVStUZllCT3FEZXZr?=
 =?utf-8?B?NHJqaWZkYldpdEJObzhab1dxY1RrVnA0TEhVUHQ2bnpycnROQlA4YXVTQ1hF?=
 =?utf-8?B?WUNtdzF1QWo2eEhIL3lSUFpDRlZzYkNHV21LK0RQYXM0K1p2ZmgwRzhIK3Ba?=
 =?utf-8?B?YjZyNHdoM1BZT0x2dWFBZ3JvdlpCcTlxeGg1UWl0M2VBR3hGeDJ0bks5RUJa?=
 =?utf-8?B?TW1qSEY3d2JMdjhOR3d6TzVtYjAvc3hNTEt1c3NPajhjalNFYkExbUxWVUtU?=
 =?utf-8?B?ZGwyMVUrVjVLdlROQ245NDJWbWlETmlDZnVHUW9FM3RzbUZNUEE5NHNrTlhi?=
 =?utf-8?B?dTNOaUpkRzBWOEZNUTNTM2R6QnphTGMyOGhwY1habEV1Zkx6TkRWTzEyVDcv?=
 =?utf-8?B?ZnNQbXpUL3ZCSjVmVGJYQmVCVlA2MFd1U2hCVFBkaXFlZEN1VWtpVE9rekZ6?=
 =?utf-8?B?M1JRZDc5WEd2U3FENk5NSktsR2UyZlNXZUd2T2QwdG5qL1J1MU1BYUk3VTJ4?=
 =?utf-8?B?am9PWS9OMDdOSDd4TDF6WXJaN1dLdkF4Nm9yTnJYMTNvQ1AyVmZ5ZGJlS24v?=
 =?utf-8?B?d0lRdGw0UXZJZ25vQSt2NXZFTldlMldDUy9uSkJ3ZDBQSVFHdlh3N053aGMx?=
 =?utf-8?B?S2pJeHcwT1NhVit0RGl4ajRiWkxTNHNpT1JaRjI2MXNMZ1VZKzlkbGZGS0dx?=
 =?utf-8?B?OVNJeGxTNzhUS2tjUkx6RldVTTMzNWhpUlhDL2t6R043dFQxdzhIY3RBSzdD?=
 =?utf-8?B?VDd6VmhQY0JUT1ZYWm1SV3VScUptaEhqOTBvK2RtaTYzQ2ZoWDBZalJpaFpP?=
 =?utf-8?Q?4EIvZVkbSU8wf8VG5G6AsSTix?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe39f3a-8afd-4795-17d1-08da85e788c3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 15:44:30.6804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIEOu/8xjOeQ7H5ce2QogIoQOeVeGWNbPuatSvyrEB16V/QIZexww7dS/QmEtwRL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB6911
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Long, I notice that smbdirect.c sets the max receive size to 8192.
It's tunable, but I'm curious why the default is so large. The
SMBDirect protocol normally limits its packets to 1364 bytes.

With an SMBDirect credit limit of 255, the present default allocates
over 500 pages/connection, in O(2) granularity, when 85 O(1) pages
would suffice. Kernel virtual mapping would also be greatly reduced
as buffers can be arranged to share, and never extend beyond, a page.

Any insight into the 8192? Thanks.

Tom.
