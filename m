Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CACC433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Oct 2022 14:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJROkh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Oct 2022 10:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJROkf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Oct 2022 10:40:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0191AA2876
        for <linux-cifs@vger.kernel.org>; Tue, 18 Oct 2022 07:40:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTGzEC5X1ewzQXP569NBk/Lp8Xw2R41NE/zTqOE/a9J1QubLd+Xy/AG5RJV66heFU250l4oVk1fCmAxDbF5nkiGmH04ZlZdbGVPNrbnh7TQZat9jfDcq2+522IGkNzinThzTM1mo6/yXonCq/lMtj7rrCrkpgVs5qAhy2IooA2ggKPEuwNlLd44QktEtk5PYHthvvpq/WmT/Dnie+RAeZeVbDnt3TcvfrE1Kib22DQYRrCs1bkrkxDWMDsvysUjx58YEJlAP83X3P/0KxqLJXsaRE5dLlgHy7YCHUn0vnX4T05wbq41Paar6fOJAw2t+BJ5COGYWRVeoJ4aEz9xlpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIPOecZwmG9gbb3k31uvVoFcI85UidMxtirmQMIr6Qw=;
 b=OaBzpmFO3NXqY+qUZW6tQDcWJMeMHz2JC+kY5O2daZILHHgjx+BHnkfkZ3B2CXpOpNyidtom/sio3HgrCstrPyu5yn0wN3m0wb3KH3pm5SgKGCcP8cCBZBN/X25g28Yuy02gEQXL2DMzBo7Lv5bTds7ygjOcGRkblkfSObDaHRfEMHgLALAwW4uNcEI4as4gMQv2VWKXGVz2ZrJCveyW6caIqygJ+jbKamzDSB6oFMLtYQjHUmXWbIpd7zDdJZLUVa7fHmrbVcVd4G/jAy4al43JDLtJ/YwVkrV9/nTCq7F/bU6i4POHuf3retJ1QFeLhVwQB2uMi+IxP5PZj9HqPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB5643.prod.exchangelabs.com (2603:10b6:5:1c8::33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.30; Tue, 18 Oct 2022 14:40:22 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:40:21 +0000
Message-ID: <24eb5cb0-75cf-9594-7171-ba0ccc3bb19e@talpey.com>
Date:   Tue, 18 Oct 2022 10:40:20 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH][SMB3 client]
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
References: <CAH2r5mt=zoWTmbQAsukALC4FEqatJtxDw40mR3=GepPp+KM+Uw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mt=zoWTmbQAsukALC4FEqatJtxDw40mR3=GepPp+KM+Uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:207:3c::39) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB5643:EE_
X-MS-Office365-Filtering-Correlation-Id: 429e0f91-7a9a-4751-b9c8-08dab116af71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m0v9r7KBvxRrtRixH3WoCWX5w5YvUtWPofJKGqZCzAr892QytJaabScm/RcuntllQ9YpgN1vH1N4rb6b99IyMMVPc1gpLAtnKIaFcSp5UF1WsV9Usyxj+iMSp8s201ZX6Pp5eNG9EGXpoBovEzGnsqO1stys1c6QzF4rdOwMLG9iHynHLn/kh6VCUBGr1tovEgme7WXTCnJ2st86LcjoCPG2U9C4tvQO2I85vYpJTW3NFFCaEz+gf8KH9oIS9kt/kDMt9BoXSvTFPKDcKF+ZP0rYU+/4xF3/NwvWF0ztwQ9dYKri8Hd6L6jk9wGDlMrKhiMSBffQmH8OfJLtRQATeY7ra/lXoXWB3e99iXmv3FPVsf960D0xWXgdNqG2UXUSNIYoFbJB5pWxi2pAstHf7SDKxADFgF/gUoN/ugFiGYAdTzwkuxd3y5E4OgKKh6P3MeHG14wdG6rj5psOj3Hh92j5dB/QWn0wsjsyyO25Sp7DREE8ZxP1n1IfXrJv1U1KriKshSvCk6dDYl7BcOS8BkLjGMqELzS12dHW5+I89i1Y/UG6XpLO1qVRcUIOMxmk4pXm2iVZtfKiOl9lDt6fWRgOtKnoqAQreOazKzCpg3iyg6KGUcqS6c3yCqPA5H+JP8diFlDRhUTQtUq1WjecGimZPQ0C72mqOd+gKr7FyVU5ZJHwcuRDFR56TOCbFrLSfXgCDCWTh0TsPdIlRtLTmyHhYHV5QVJNcErp2SyIy6CNBQGcaIvnz0Fbzwr3VPw9Q1wRwylu2nStACkJI0bAD6bHP597BC1FLp+oswPlSH0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39830400003)(376002)(136003)(346002)(396003)(451199015)(8936002)(54906003)(110136005)(478600001)(6486002)(4326008)(36756003)(8676002)(66556008)(66476007)(66946007)(5660300002)(41300700001)(316002)(38100700002)(86362001)(38350700002)(31696002)(52116002)(26005)(6506007)(6512007)(53546011)(83380400001)(2616005)(186003)(2906002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUpDcjNIN0hzYklFejdkb3piMDZWazNzZGJWeG9oKzhQUjd3SnZrWGhrbjNV?=
 =?utf-8?B?cXE0Y0p6Z1lHbSttSEtOcVJPV3I3NVFObkc3eVIzVnB2d0swQ2E3SzBBaTdt?=
 =?utf-8?B?SXFKNUpuT0Uwalc5SFZsUys4VDhkMndMaVM3QTE3K2hEOUZHSFhHVW40T0ZI?=
 =?utf-8?B?TWd1VGcvVEFIMzk5cmVEN283MjR5bzBjS1I3YUc0QmNBUHAzdW9hL3dzemRX?=
 =?utf-8?B?UEhrODVFQktnMVdpZnEwZkNmRjBZSDRHTVlrWkptZGFQL0dEMWVEY1Ixb2ky?=
 =?utf-8?B?cGpvT0hzeDZ5QUM2eFFMdlJkVWxDTHNVZFJ2dldTcXlqc2RTQ2o5TUNoQTIz?=
 =?utf-8?B?QzM1L3NqVWFrb0djNExoRDkycTRwUE1BSXRQNUpTV3hLUmRnMUJhOGJLeW1I?=
 =?utf-8?B?enZ3b0RTODNmY3BBZE9SZUtZQnZLWVlVbGQ4U0NYOVZxVFhpaEwxeE1GZnVy?=
 =?utf-8?B?UTY1Q1oyRFdHUUcrUUlQK1NSWGhNUTA4SEpVcGtUMFZ5TTkyY2d6L0FvSEJ2?=
 =?utf-8?B?Qitja1VGZHVQRmFNdlhvMXdERFVBYzY0bHJkN1hCRUU3VGd1aUpoUm1WNGpH?=
 =?utf-8?B?MWtRM0o2YStxUnNyRVBhcWo5Tm1RK1NDbjBaSmwwQlA4TDdmc2Z3NWVPdTIx?=
 =?utf-8?B?NUR2ejE4QVcrNXlkZDFSdVpGc1lkc0ZvUzVvbGRSM3ovZmRWT21BZ3ZpWEZV?=
 =?utf-8?B?K2xjWjFhUHl5QXltaWlyWmtTcDNrd1FZZE9PZXIxeDJRL0tITzczWUNqT0t0?=
 =?utf-8?B?UU40aDgvTE5VdkpBRGhxZnVOQ0tZWG9udDQySUdkWjZuRWE0U05Sa1IxOXpX?=
 =?utf-8?B?YjE5ejlMODlvT1N2bVdKOGhrd2MydCtUb3lWczNsbUxKN1lMZld1aVlrMGJB?=
 =?utf-8?B?RnF0cWZrRlJBc09JaEhzMjZraU1jQVh3eXdoUUJ0emhYYkM1Y2tmODM2MDZE?=
 =?utf-8?B?NkY5dVVmMktXc2FMWnJRTENGQ3hSSUwxOHkxbHhzSmsvL1ZzK2VIQUNGdkxY?=
 =?utf-8?B?T2ROV29DZTJ5Lzk4RWI3RytkUUU0UmZFYWgrQzN1MWp1aXJFZmdyM0JRV1dQ?=
 =?utf-8?B?SGVLckFVNmFTaTEvYS9LVURCZEdQUUNrY2g4cGZSZGFvVkpIejFWMmhVNXZv?=
 =?utf-8?B?eU1KY200cFovUGhZdUlWSmp0YnVGVEk4bENOMFk3dzhuM2FJbktpRDAzVXA4?=
 =?utf-8?B?YVA0N0RnellpQUJiYlNYLzNpWXNKRUtlTzRDR2V2Zk5mNmdOQ0VmejFJSStQ?=
 =?utf-8?B?NnNFYnMxQ1l0bncrbGZUcGt4T05hSldkMGJtTG8va1dScHUzZlY3QnpBTlRN?=
 =?utf-8?B?RzUxb251Q3RCbnJUSE9Xc1lQVHpXQ3JGckhzQnZRQUlNUFZJMm80SkNqRnQ3?=
 =?utf-8?B?cTFLOFkvdVhEUm9sZTZZOGdGdE9oREt5WE0wM1QzZFVOVjYyQTBIWFBOaHB1?=
 =?utf-8?B?a3UzRGZXb1ZGSE16TTUwSHhqaUcxbzNxZ3NLN2xqSHk5cDBwTVRLU2ExSjV1?=
 =?utf-8?B?QWR6WnovQ1B2TXhyZ2NLbzZPQmNPa05JVUpSRFNwQnRJMUxqQk1NMDhBdy9R?=
 =?utf-8?B?c0tiZVA1YTRlVXJKVnZFelNwSG1ZR01ua3g3aVJJWU83bTh1K0ZFKzhXREdF?=
 =?utf-8?B?RFhyT01McEE0OC96UTk5VzQyaUtidDBoanc0YVZ3ZDZmNzhDWG1JVnU4aEJy?=
 =?utf-8?B?OERZcW1XWll4WXhIanN4Ry8wYjNEV3dmWWN6NXFzNzFpbVFodkF2cEtVYW5I?=
 =?utf-8?B?emh5M005M2RYWWp5V3JySDJUcXFSQU4zUWR1NjVUVThEb3IyQVY0YXNQOEZI?=
 =?utf-8?B?U0c4Uk9GVjhlcWhlZEIvaWJEQXZsMmNyRnU0KzFNYi9Eajd5U2JLSE93MlAr?=
 =?utf-8?B?RE1lbU1PUUhOaGtJNUxFdmtKS0w1SWtJSHJUL01XTFZIaG1rT2RmbG1iUlo2?=
 =?utf-8?B?TG45WUQ1eXJhU2VyN0hvL2lhYUg2RVJvODNNNE9nS09WNWN6aE96U25lVkJH?=
 =?utf-8?B?ZS93ZWJUNXM3R2ZONm1HWEswMzZzYU10QUE1NnZLbzRpT1hIRXNSalJsL05i?=
 =?utf-8?B?UFZDVEpaUlJjMXM5UFRURmxqL01mYkpBWkJoR3FTOURZZlV0RjF5amFXQjJY?=
 =?utf-8?Q?KlJhoTaenqkSoba/cA5WrA5ZD?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429e0f91-7a9a-4751-b9c8-08dab116af71
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:40:21.8771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkC12bC+6lnNMM6El85UY27Ixe8zfWXll2K2QR1zT05hcIo0E9w9oiugeMK8Otu+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5643
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/15/2022 2:32 AM, Steve French wrote:
> Change notification is a commonly supported feature by most servers,
> and often used on other operating systems to detect when a file or
> directory has changed and why,  but the current ioctl to request
> notification when a directory is changed does not return the
> information about what changed (even though it is returned by
> the server in the SMB3 change notify response), it simply returns
> when there is a change.

It's a useful enhancement to the API to see the details of the
notification. What Linux applications might use it, was this
requested by soneone?

I do have one general comment on the implementation. I am pasting
some snippets from the patch you attached.

The new structure adds two fields:

+struct smb3_notify_info {
+	__u32	completion_filter;
+	bool	watch_tree;
+	__u32   data_len; /* size of notify data below */
+	__u8	notify_data[];
+} __packed;
+

however the vector adds a single boolean:

  	int (*notify)(const unsigned int xid, struct file *pfile,
-			     void __user *pbuf);
+			     void __user *pbuf, bool return_changes);

Why a boolean? Wouldn't it be more logical, and general, to pass
the length instead? If zero, it's the existing behavior, and if
set to a length, then that many bytes max are requested?

It would also be logical to return the actual number of bytes returned,
so perhaps passing the length by reference.

  	int (*notify)(const unsigned int xid, struct file *pfile,
-			     void __user *pbuf);
+			     void __user *pbuf, int *length);

Finally, both the existing smb3_notify and the new smb3_notify_info
use a strange combination of native and size-specific types, packed
into a struct as if they were required to be wire-encoded. The __u32
packed with a bool, in both cases, and the __u32 length in the new
one. The bool could be anything, how does the "packed" attribute
actually work? Any why the inflexible __u32's?

struct smb3_notify {
	__u32	completion_filter;
	bool	watch_tree;
} __packed;


It seems to me that these structs should be defined in base
types and marshaled/unmarshaled in the smb3_notify processing.
Of course, the existing smb3_notify maybe needs to remain for
binary compatibility, but the new structure should not copy and
extend it.

Tom.

> This ioctl improves upon CIFS_IOC_NOTIFY by returning the notify
> information structure which includes the name of the file(s) that
> changed and why. See MS-SMB2 2.2.35 and MS-FSCC 2.7.1 for details
> on the individual filter flags and the file_notify_information
> structure returned.
> 
> To use this simply pass in the following (with enough space
> to fit at least one file_notify_information structure)
> 
> struct __attribute__((__packed__)) smb3_notify {
>         uint32_t completion_filter;
>         bool     watch_tree;
>         uint32_t data_len;
>         uint8_t  data[];
> } __packed;
> 
> using CIFS_IOC_NOTIFY_INFO 0xc009cf0b
>   or equivalently _IOWR(CIFS_IOCTL_MAGIC, 11, struct smb3_notify_info)
> 
> The ioctl will block until the server detects a change to that
> directory or its subdirectories (if watch_tree is set). See attached.
> 
> Also attached is a simple sample program to demonstrate its use.  As an example
> if you ran:
>       # ./new-inotify-ioc-test /mnt-on-client1/subdir
> it will block until a change occurs. If you then do a
>       # touch /mnt-on-client2/subdir/newfile
> you will see the following printed (in our sample program) showing the
> notify information struct returned to the user
> indicating the name of the file that was changed and what kind of change
>     notify completed. returned data size is 28
>     00000000:  00 00 00 00 03 00 00 00  0e 00 00 00 6e 00 65 00 ............n.e.
>     00000010:  77 00 66 00 69 00 6c 00  65 00 00 00             w.f.i.l.e...
> 
> 
