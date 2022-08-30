Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C34EECAAD1
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 16:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiH3QNo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 12:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiH3QNo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 12:13:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C588BF7B0E
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 09:13:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fpl0kxfFtrq/QTzJeVT0GwlFrQ/gOT1tw2DRETGo+IsM43JNCfn3Q7c4dzO4j88CPZfvDakgvqatvnYgAqL+Ky5k03vXzqUQSZQ/QaDNp/tRASvYcn7Ztv55oNBqum+j1KOkLEC6xZy3HiPELDN/LsNETei5jWb1JCkaId1NiF5GrQVjVXrqeJy1hquddy31Rjl+M98G3DgRzCKnSIhEMQP3hGG/cCWqktQB2e18IpoVF4S21/h/bIdMTh8YG6q+GI1oVZ+9iTDVqMlE6rN9hbDwkDvFheECc1qdYHLAc9f4FeYdbr7HdKf7/3HZcee83hhf3ALRrAb31ThyqCi9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9iQTZ2OLUUSc/1XUcw56NHtB/Gy4XVOgfc2kmoJK+w=;
 b=R0wwhf89jaB7Y237RMZwBpcIHiG/r0AZu44xfUFKi/gFf7acnLX6Le7SNk/CLs5m+vA/pgLip+50m8UkFkVFK9B3jZJq0IGQwFmoe4N/OQtbUvQ72x1mhhTRtAYhH8ROUDd9Jw6j3CqkTXP5LSGT1+Xv4bs++zccpzrqIdu1YzRoWasHQlTgQJiF4KkjRoVhFbri5Q/ARhOuHxMTt2sd5Ask2NBmjEZfC1GDc59lQ/J55Zu9BQ43iH/3FeQ4p5AqG+SQ5JEoHgJ1I78bkcwgHq5ITgmuiEoIwIHDUvcCGHc5UAMXeWCRIsfZwlzlh03XCj3SXOSPVp1Z+YkkY70F1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CH2PR01MB5925.prod.exchangelabs.com (2603:10b6:610:40::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Tue, 30 Aug 2022 16:13:34 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 16:13:34 +0000
Message-ID: <47dbb75a-b299-066c-61cc-2b21ca96173f@talpey.com>
Date:   Tue, 30 Aug 2022 12:13:33 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org
References: <20220830141732.9982-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220830141732.9982-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0069.prod.exchangelabs.com
 (2603:10b6:208:25::46) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df5a5755-3430-4466-1fbc-08da8aa296a5
X-MS-TrafficTypeDiagnostic: CH2PR01MB5925:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQTYIiNo3saUo5CJoEkOYCTbhGYWEsgFmlxoQBG02irkpwRMyTuCU7LoOzWjQJpWS4HlKpT6Qgb2n6Lqh8u63tOSdWPknhLJ7rM69IggaybsV8FIa0CWzgHHE9zQlfdwGN7QRIOr60vL2Go7BTEI+NfD5J96JE74Hggi9ixCCSzZ6lrJ6bUBCzdL7nWhqLX7jcDR0l3G6BPhZLwdqf0pzzq+aVOOO6sKWifGxlvLsABcwkvQaT04h6WAY+ySmuLBaU15pQCb6B/3ffUGLnvTCHXstHB9SzBHybCWrnNhsOLd/fqISyzHPU5J45wfPfOZm8Hrw5+9rhxGs2qR8hlCXRHxHyur/XTsYdI0IcZJPEmX/RA+SiXWmaCrDYZFtgLWWZyFFgrxGqLPHkzWF3DYGB0lnDlJLXgnbFC+gU1efoUepd/Q04zeNNOXfm1D7i0dPEpIki1HTc1BWRALzKjcIa0wpkSnzVQLzf61/OiW1xNcLR5mWbbaOJ8K1Q2gX+KY6+m9vZcoT0ah563dROuyc1sNn2UqKrAKt8lRRLygEr89QlGdkt5NMf5o0O+YndNGInzMDw5G2QdRbe0uY1Nl9tH6b/i5N769Izyotj0RaedOyPLv7QO182pvvtng6CpHjXvRhMY/F5Jd5647Lv+Q2t4feGRK4PQdySZe98/rj1z6WYMjX1hIsQGiYQ38wd7DMOzofiBuC/Zd52p587Xz9Sr3ldt+9PB2p5x55S3MDSyV7ioElYlFhEqViMdUawuAWxJtDVeLxXTeU4TZB+odm9JgdeWsiEYPnbj1ELQqKKoqMU+wwGCudS8ER3BDkvAJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(376002)(136003)(366004)(346002)(396003)(4326008)(2906002)(31686004)(26005)(8676002)(41300700001)(66946007)(66476007)(66556008)(6486002)(6506007)(6512007)(8936002)(53546011)(316002)(52116002)(966005)(478600001)(83380400001)(38350700002)(86362001)(186003)(2616005)(31696002)(36756003)(15650500001)(5660300002)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTZmSVI3OWNKV1VicmI3TzJXcmlYQ0RQTXlmYVZYV0oxa2lsNmt3SjczMXhq?=
 =?utf-8?B?U25UVWhEQjlMdEVpWlFRQklCRmUvWnlSQ0prZ0xpdG1TMnY2cnFra3lDUFRD?=
 =?utf-8?B?MEU2NTJRTGVSR1hOeTdwYlNMVWpnd1JtZWsyaTE4WEoyUW1DSFlkTDJTVys2?=
 =?utf-8?B?RU9GcVUzd0gzRmY3bytBY0JNY29PVWljWjJQNUxPQlhRTkVGTHlqZmpYRnpi?=
 =?utf-8?B?bFVXYmMxL3VEa240OTU1SGdwbXdhOUNaSGxiMTlXNXhRY1Uzc0ZObElPY1FQ?=
 =?utf-8?B?eC9yTDUrRldRbU9zK3JJbGQxS0pra1dGMmZ4OXExc1FVaHF6ZmxuQ0tvamNQ?=
 =?utf-8?B?TkJMbU9Bd28vcjdDSGpzb1JZdS9WNEdmR2I2aUpVREVzMCtlTks4WGJpQUYx?=
 =?utf-8?B?MTY0TkhFc25HV0dMMG0ydlF6QWlFUFU0UjcyMlowK2wzOW5HKzVQTk8xTkUr?=
 =?utf-8?B?Lzc2bTdudnRNMVVLeXpUQXM2S1BUeXgwZ2NjUzVJUE9iMWdiQTdLSmVuRzht?=
 =?utf-8?B?eWdmRWVSQmtDRnY5TWhUT1pBdGhpRS9NYU1NVnFjVjFYTWRDWjZxaXFwV1hu?=
 =?utf-8?B?Wjh2MEJBcUw3ZUg2RG5WMEFBenkvakVUNExMakpUak5oQnFncWlaNTk1bXdm?=
 =?utf-8?B?RlBpOXhDNEw4MDVXNnB4Y0hXZzZ2Q3lIZXpmVjFzTjd1c1JUeTBIQzhzWW9i?=
 =?utf-8?B?UjBCZEVmMVVMK0UzcFZhZGtzQ1ZUMUdRbjNzcHNPYzZFTlV4aDB2WkFLOGR0?=
 =?utf-8?B?NURBaG5tMzF0ZHp2V1FiWGZ6a1RFd2xHTndId1JGU01jUHBVUEtGZ3pIWlpT?=
 =?utf-8?B?RXpkUjJRZHMrdUFtSGRLMjJGeVVBMTU4SFQyMXQzbm80ZVhrUG1SQUNxQzN3?=
 =?utf-8?B?eXNoWFJyT09jVWo2ei9Jamo1WGdhbGVvVlpXTTVZb04xSVc4K0ltdUJhWFhI?=
 =?utf-8?B?NlB6cTV4SlJwcTVSakxGNmFEVXExY0RydTdoMTdocmF1M2dxZDgvbWhCZVlz?=
 =?utf-8?B?Nk01NnRSVmZmeUl4OWlmdUdCNWgwSHVyOTZNQi9PbU94RWg1RkFISjBwMXFz?=
 =?utf-8?B?aFgrSE9jZlZ3UmpTRUc4a1pJUEtTNXB5T01jbEZXbVJTYm93MGd1V3lKRzVs?=
 =?utf-8?B?UjZDZERRWE0vQ3BoNmxFQUF2MFRqc0owTVluZ1BzTnpka2xJQjBScGRGZXVi?=
 =?utf-8?B?RDNLOWhQMnFQdFVFMlJuR21SOEJVMkI3ODJHdi9VUXF3cFdpZlJTWCtUckRK?=
 =?utf-8?B?Y0RQLzJxRmFrQXZHTmF1NTE0dEQvaDloQU9WRHFMQXJoUEFsSmVjK2xYM3hr?=
 =?utf-8?B?YnZyM0pidmRNcWZIT3NRMGJubG9wRms3aXVPYVhoNjJoT2hoancySzBvRzNq?=
 =?utf-8?B?WXlZNi9HNHhZWnNscXlPWU45aVB2VGxqN1l3a1Z4Qnk3YUlwZHJpcTErQi83?=
 =?utf-8?B?WHlXZ2lSZStKbTZFRVdjSEJJRTJKZDZkWVF3Tzl1YU4wMHRLSjF6dDdHRE5I?=
 =?utf-8?B?Ykhvd0NwRDB2eitaeHIzUEZ5dnVEYWJpbVZDVVJoMWdob1l2aUtnMlQ5WTJv?=
 =?utf-8?B?RlJQTjdBcGJQalNKS3l3SWFzRlA3NGJ6VXkwNnBjbUhCZExxcWluTUFXTnZB?=
 =?utf-8?B?enp3RHBYTE5DZ1o3cFJqOGJOTkNwajFsYmNhWW43VlhVMjJoSXlpcWovN2ZD?=
 =?utf-8?B?TTltVU0xQzk5VTNaV1lMc1Y4bC9uejVsTFFOZEVnZ0oyWnVuUXJTK3BqSk9m?=
 =?utf-8?B?MDZzNkFZOHdDSzBGcGw1Q25GTmFhaUhIQ1pOKzNlSXpkQ3FSeTNjUEhXSmpw?=
 =?utf-8?B?VkJUdUNTeDVRQ3l0UmZ0QkhucWpRem5UMWFDQ3RabXExeEl4enpMUnBhQlAr?=
 =?utf-8?B?NHlFbk9xVUxIc1ZvQjhjdFNXUmVXSG9wc3JpK0NsQTR6Rk5LTHM0VkFtb3c4?=
 =?utf-8?B?NkJBMjBDcG50R2k1MGRlcHI0MWtTcjV3N2oxM1RwRDM1a1NZNjRSc3lSV1pq?=
 =?utf-8?B?YVFIdVdXSGFIKythNWpTV3hjblZRUG83TCsxK0F2b2E0V0J6Q3FXZVBkb3Ba?=
 =?utf-8?B?MTNucDJvK0MzQTg3Qi8xMllFd0RNUTZteW16eTAyM0IvQkYyanpDeWZiWHp5?=
 =?utf-8?Q?bftE=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df5a5755-3430-4466-1fbc-08da8aa296a5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 16:13:34.5116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iM/t6eyBgNtBxK/i7qRDzge5mHtSR8t/quXQieU9NGs614SbWUqNuqnhSVz+57op
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB5925
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/30/2022 10:17 AM, Namjae Jeon wrote:
> configuration.txt in ksmbd-tools moved to smb.conf(5ksmbd) manpage.
> update it and more detailed ksmbd-tools build method.
> 
> Cc: Tom Talpey <tom@talpey.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   Documentation/filesystems/cifs/ksmbd.rst | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
> index 1af600db2e70..767e12d2045a 100644
> --- a/Documentation/filesystems/cifs/ksmbd.rst
> +++ b/Documentation/filesystems/cifs/ksmbd.rst
> @@ -121,20 +121,26 @@ How to run
>   1. Download ksmbd-tools and compile them.
>   	- https://github.com/cifsd-team/ksmbd-tools
>   
> +        # ./autogen.sh
> +        # ./configure --sysconfdir=/etc --with-rundir=/run
> +        # make & sudo make install

I believe you mean "make && sudo make install"? The single & will
kick off two make's in parallel.

>   2. Create user/password for SMB share.
>   
>   	# mkdir /etc/ksmbd/
>   	# ksmbd.adduser -a <Enter USERNAME for SMB share access>

It may be worth mentioning that it's not just single-user access, and
that additional users can be configured.

>   3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
> -	- Refer smb.conf.example and
> -          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
> +	- Refer smb.conf.example, See smb.conf(5ksmbd) for details.
> +
> +        # man smb.conf.5ksmbd

I like the new manpage, but that's a strange path. Are you sure
the various maintainers will deploy it that way?

Also, it has always bothered me that the name "smb.conf" is the
same as the Samba server's configuration file, just in a different
directory. If someone enters "man smb.conf", there may be confusion.
I really wish the file was called "ksmbd.conf".

Why not putting this under a simpler manpage title "man ksmbd"?
To me, that's much more logical and it avoids both the confusion
and having to somehow know that weird manpath.

>   4. Insert ksmbd.ko module
>   
>   	# insmod ksmbd.ko

Well, it's worth mentioning that a properly configured and built
kernel is a prerequisite here...

Also, sudo.

>   5. Start ksmbd user space daemon
> +
>   	# ksmbd.mountd

FYI, Ubuntu Jammy pre-configures ksmbd as a service, and there it's
as simple as "sudo service ksmbd start".

Do you not want to mention the other ksmbd.<foo> helpers here?

>   6. Access share from Windows or Linux using CIFS

Pointer to cifs.ko how-to page?

Basically, I'm encouraging these pages to be (much) more user
friendly! They're fine for developers, but way too fiddly IMO
for naive users, or even for admins. It has taken me days to get
this all going on my fresh machines.

Either way, thanks for the cleanup so far!!

Tom.
