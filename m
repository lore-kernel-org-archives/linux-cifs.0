Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5AEC6FA8E
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Mar 2023 19:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCBTcw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Mar 2023 14:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCBTcv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Mar 2023 14:32:51 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311333D923
        for <linux-cifs@vger.kernel.org>; Thu,  2 Mar 2023 11:32:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKBjS9PvZTCfQIzcrM/BBrx+VpdOwhM1XVEcweGQAQJSabiH/gkMwtqW5twwBYCGuvJuueGSxHdhRb+4+1MHjHvCtfUf8nvfviI+TW5uQ1VTcmENQCLc3/3ZwM1oc86FJ9fZpcCpPi7qNBneFnmh4tCj5SapvaDtC7VqF4AY1n+mCzDGQDahIw1TKKhWYFRLmuiMlwrVCnksHgUNSRY+R9GnOcMUB8+xqlzP1ZZ/a3hFOpiXdWJbBAquBxMSLnaBkagHbiFE9K9ytuO1aeBwAlpWLzWQVIUCzARqnVLQ5HQxXVDb2/UyIpOy5PkP6SUMnNpw0gO47xa8fqjIfIWFww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAMMDAsNYwYGOz9sZWaOrfDljBfzKz16LYmW7BGl8SU=;
 b=F8sDYrR1lXAwbEqXnQbAWY7jK5X4ZzeqxmMvZaGKBedBcAcu/fZzkINpuE75B4kUdGiHmLUZuI3DiQUbWxO37uVn2BRI+Jhib83ETzSA+TeT26s5RuBaaxDIk1p95FYrxxGsDoHkaUTz+LiC2qmDOXiWAcoKzgkBj5kVX+ZfHDuvF+S/9iKljZk2GtLTca9IrSBck/uCGWdHalN/mAea48cWuSyUt57p4OlB2+aqZ80+qyX109BfsEfY+/ozDbvxedWusoiSuQD60P2qYqt0C/rdUo0n1Z2zWaXdPybI6u2hwefG0ofEZmevzlwuzawxxJvgbrROdQfNypDHdL6obA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN2PR01MB5613.prod.exchangelabs.com (2603:10b6:208:10f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.20; Thu, 2 Mar 2023 19:32:40 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1d6d:194:ddc0:999d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1d6d:194:ddc0:999d%6]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 19:32:40 +0000
Message-ID: <0a9990d0-84bf-d5b3-db11-8eafad22f618@talpey.com>
Date:   Thu, 2 Mar 2023 14:32:36 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Nested NTFS volumes within Windows SMB share may result in inode
 collisions in linux client
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     Andrew Walker <awalker@ixsystems.com>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
 <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com>
 <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
 <CAH2r5mv52koGnKbvtRKE95c_JwwtitTXFaRc6mcM8nwLmWNo9A@mail.gmail.com>
 <300597ce-06a5-a987-5110-aa6ec24ea199@talpey.com>
 <CAH2r5msjKi-FMQRaHptk5fPycZRSS5ZQNC-u=1wE8oxBUhN5Ug@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5msjKi-FMQRaHptk5fPycZRSS5ZQNC-u=1wE8oxBUhN5Ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR0102CA0063.prod.exchangelabs.com
 (2603:10b6:208:25::40) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MN2PR01MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: ad3371e8-e599-4dfe-ed2e-08db1b54e2ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtcvHzoaP0lrOJzK+cgPtnS9hIPvey3Y1mKTIUaeUADZgdwny1jejKrCPStHM1q2E5gNGq9/d7jM+74jgdHen819Lq7xYDCfd5OLi3tUmZ2Nci8EAKGPffTxmgoy8ql34SfxCPBVbXeEy+xF+P3JX1jjFJgl5WYOeqRRWkBgbPzekQaz6Q9yk0OQxdWUfqCkF5K2acnigeECS85sJH1QqaP1wpEnTgqTuHEX1x/1DIE9HEJSAA+ZH8cy0zuqjxKM33Prr8v1dIoLnyWPVPS5aWa6HSCKxOhsvJjFGVUQtSc/FdlQ6TftWAob2frGTnR3eCqrBkJWP0VL6W/kIJYBw+MvjxdLUKR4isin8apYxnK+EpB8k0l/JAoRtTm59RfWB3AhaFhZmpXXpxQxTKDrQsrN1BTflxDb5wbmYDG8MxTgSLu4uh9Ye8vPZLY09p/PfceCmjAZyAVHXqczld1sQrnICj+9w6T4DTVRXyz8DkQVzJQt1RAv3ZRVrNLkcjEZqZsZMA7l3RlUqzqlkaHSgyFyfTtNkloVm8ME6tkZXSTZ4CuBpDOZe/BloYBf9IfJyQi/Fg8LYNpaH/wqt1lbZz2L2O10x7mluFSzGLQMVCtx4d34ruQDhfpSGc14oin6NxDX/nnrUO8wUI4XLNIMEA4utqYeY6tu2/NONoPoLhle+wK+DwLbk52tLblPiqWzfArnKlfapay+50kij5jo9XUM4i22c+/FrxqT9waL8js=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(366004)(346002)(376002)(39830400003)(451199018)(31686004)(5660300002)(41300700001)(8676002)(38100700002)(4326008)(38350700002)(83380400001)(8936002)(6916009)(66556008)(66946007)(66476007)(36756003)(316002)(2616005)(2906002)(186003)(52116002)(86362001)(31696002)(54906003)(6486002)(478600001)(6512007)(53546011)(26005)(6506007)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2FlVElBaXdSYzloY24wQm1ncHZlYW9lVGhTMEhYNUJnMDZabjg2bk10c1Uv?=
 =?utf-8?B?cnkraWg4Z1NOdXRCUWlrUEY0dzdZREttRndDUmRGVVVOblRRUUc1czNyNmlu?=
 =?utf-8?B?VnE1b3NaRENwNS80L3RXanBqdkUvSThYNi9xZlVqR1dsOWQ4b0Z4RXI5Z2M4?=
 =?utf-8?B?cmxjQllseTZVL2Y1ZWxNUVZxekNRMmNUdmJreC9HTEJZQ2l6SnphK2NEL2tI?=
 =?utf-8?B?SmJ0UTVuWCtSNnZ0MDUva1EzdDRVNU9RY3lDQmNWeWEwc3d1SnFUNHdjdjJ4?=
 =?utf-8?B?QXQ0RnR3ZDJRdGRlaXduZjVPazh0eHBDNjJVWlM0Ly9Ma0Q0Zy9yMFBKaCs4?=
 =?utf-8?B?UU00NzFxc1owVXJVem9ZdnIzQThqeXdYQkgxUUQveDhObTB5RHdCVldQZWdw?=
 =?utf-8?B?dEd1MXpBMmlvVFF5WTBkV2lUL205UnFmNHh4blVvNlRZTXdrbWhVYWpxUWhP?=
 =?utf-8?B?cjY0Mk40NUFNeGJ6T1oxb1BZOWg2QVVaUmNSRGwvM2dnZ2NqNm5XNXU3SUlD?=
 =?utf-8?B?K0dCR204WUU1NUJFRTI2Um9MbTZRVExSNEJBSmdzTCs3ZEhmaGVLbTZrQ1V4?=
 =?utf-8?B?UWpXdjRhQmF0a2hpRWROeVR4cm5mREtKUk9VdFpQUk9UMnR5RUZBNDZxR2Nr?=
 =?utf-8?B?aUl5OGhsQWZQRm5MaFRpZWc3L1N0M213UnlzMzhKRTFkOGNNL0p0TzFVejAz?=
 =?utf-8?B?Qmk2RTdML01NdlFoMTErTDFkdjRpYmM4ZThNbmFxZU0zRjZDY1UrTHBoN242?=
 =?utf-8?B?Sy9DU2dEcHp5SmZyNjlFN3k0b1NaYlloYmJGYndSMHd0M3l6UEo5bGxsVGlD?=
 =?utf-8?B?TjhsWnZZdUt0SzFhaE5RL2U4OGpidlQ5NFgycWNMbVI5NVZpTUNNNWJYUHFm?=
 =?utf-8?B?ZUwyMWZFdnJWcWZjR0FJVURIbmNlcUs3UVE4LzhITk9ac0RQVVg4T3dEUGxr?=
 =?utf-8?B?ZjhMQnNjdzJ6SHMrOER4aHlBWUFMcHlpUHpNY3F2ZlNMd2FtelE3dVlmdnll?=
 =?utf-8?B?SklXTFNNMVVCU1dNRklYN3JSL3ZpVnNqT0RvYUhmMEZGSlRja3hDamdtVEFQ?=
 =?utf-8?B?dGhLMlBLWW5ETE5oVW8xR0VVelE5QVVnOWNlZnZWYkR4S1pjdy9VTkw3amlo?=
 =?utf-8?B?cmJaUkMzVW4vL3VlOVFGdEcvTGpJdUo5Sk5ITmJ0NndKQlBlN3N3K20zTlpT?=
 =?utf-8?B?VUdnSllGS04rbDFNWHBBS3pLRGZyb1pDTDBwTDNhK0x3MHZsblhRaGQ2dDBv?=
 =?utf-8?B?M1h4dk1CVENuQk9ULytia1lyN3hSQ0dXM3h3Yy9jbWt6QXhMbGtwR2FrTDFo?=
 =?utf-8?B?c3F5U3ZyVHZLVUNuNVBNN0xkQ3pYeVAzeFhldG1WK2wrZlZadEN1bG5uYWxm?=
 =?utf-8?B?bGc5OUFsSWo3TmcrZ2tQUTFQMkEvRkR6ckRCWnRBUi8reGYxQXRGKzZ6dGpz?=
 =?utf-8?B?dDNNcm9NUVNOV242ZzZ6RWtzSldBZVNLcHdNam1qNTgwQWJqRWpQL1pmdkhD?=
 =?utf-8?B?R2lUcW9rclZFWms2N0c5QSt2NUg0bDBsN2FyOTRndE5nZWVjMmh6MTlQRFUv?=
 =?utf-8?B?c1p6dGdJUmN1UU9GdzZaTVpoZkhzdGJLK2NsZzY3VnQ2TEJKNkxoUzNEWTZl?=
 =?utf-8?B?N0pqZ1VrN1pSZkNya3RRVFFObW9rbzIrOXo2azV4YmZJWTRlRDdmOFJOTnhW?=
 =?utf-8?B?ZXFPK0U4emNnemhPd1RGREhsUU1zRjJtWXZRMng5SERUZ0pRSDdPeW1kVGVN?=
 =?utf-8?B?WEFGaWVML21FY090R0tEZ2lBRmxQTXNkbDZzWnhDVGJtMW5HUm9ZK0VZSjkx?=
 =?utf-8?B?MkpscTU3ZjUyYi9JcVNzajhnTWIyVkZ5MGNSS1h0K0hJbHRJL2JNRy9DZWhs?=
 =?utf-8?B?TEJZb2gwdkFpaXdPMGpEUDBEaVYrS21KdUZPUEw2S1VPUkVGc3MxMWp1dzJm?=
 =?utf-8?B?QU9tcktCVlJReWhrNCs1cHcxaHRQV1lZdHZoRFdReE5kOW4vQVNhbzBvOSt0?=
 =?utf-8?B?R0Z4Ry93L0dEd0IvYzBwYXlFV1FjMFlwekNsME90NDRLcFFQUGxrcTh1dGp5?=
 =?utf-8?B?R1lsWEVSZW5weTBZU3BDNjlVZWRXR09yRk9aSmNkaEpCUStvdjFadHhBaDZo?=
 =?utf-8?Q?HHwhUGDDhgkpQC6YKG3ePghTN?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad3371e8-e599-4dfe-ed2e-08db1b54e2ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 19:32:39.9118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OL9OAy8t+SAK8gL/isJzTBXNZsw+rClGSare8Z+MIfqemKKQUprdnDD1Ipkg33PX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5613
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/2/2023 2:23 PM, Steve French wrote:
>> Why isn't this behavior simply the default?
> 
> Without persisted inode numbers (UniqueId) it would cause problems
> with hardlinks (ie mounting with noserverino).  We could try a trick
> of hashing them with the volume id if we could detect the transition
> to a different volume (as original thread was discussing) -
> fortunately in Linux you have to walk a path component by component so
> might be possible to spot these more easily.

Well yeah, it can't be a random assignment, and the fileid is only
unique within the scope of a volumeid. Blindly using the server's
fileid as a client inode without checking for a volume crossing is
a client protocol violation, right?


> On Thu, Mar 2, 2023 at 1:19 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 3/1/2023 8:49 PM, Steve French wrote:
>>> I would expect when the inode collision is noted that
>>> "cifs_autodisable_serverino()" will get called in the Linux client and
>>> you should see: "Autodisabling the user of server inode numbers on
>>> ..."
>>> "Consider mounting with noserverino to silence this message"
>>
>> Why isn't this behavior simply the default? It's going to be
>> data corruption (sev 1 issue) if the inode number is the same
>> for two different fileid's, so this seems entirely backwards.
>>
>> Also, the words "to silence this message" really don't convey
>> the severity of the situation.
>>
>> Tom.
> 
> 
> 
