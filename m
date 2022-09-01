Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37561ECAAD1
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 13:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbiIANLk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbiIANLM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 09:11:12 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B838C8E0C8
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 06:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oezD0e45O2i6Rg14EboEsQ+FP/rsqvJSa7NwnsVo2Dgmotf9Oef52baX3aK/cuRGZ1lxcNuf4CZRpaMdzrUcRNyJZmVHaZqrGPlG6fiiTwf573eW5MzAyzbC/lBSIdeJSoFUio0lk+1Yr65hoLd/cmoMLiUXEmjxtD4wI4jhg2AIxqVUuh4IZtk3kedhQosYtVLqb8s72RJlA/hqOFN5E2ZmBxtA1+vNF2TOJuRqrh7xRrnEeqElpZzIs9p67M8OeF08K7JSTE1WyoTVRRXDxYXsGucGE3hbAfcKPyRZzwuA1X7/2OKx32veaO5YHS4CR6Fw8MLEoA+a04ZmG9Xu+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+QVKwKF9yr/uQljvayNik43JZxFjM2JQuxAXGbOI84=;
 b=CcNrHLj38jNdRA4rudFZJfqUocZUIA8GWkZAkpDr0PxI1g75uNA/4uFD85MzpTmgrgZi14m63vJ+lFgZSYt/yteh17KPlf9ClHvRxyqUSoHziIwKWI9O3EDuN1xVrubwAW49p6vrBgz1ZZTF4RzG+94kmd1Dt0/bKgeXelB/qvx6WLlrpUk8x+n1wr4YJ/UGiWZuKqSyoiaIpp3vJY3SHtwmVce5pO2VSUQCNJ6Ulm07ZySHm6+6JozxTe9sMTXxFVH60xl3PXtU52odRfJyFOQ1DCa3y1jVJHBaDFP+6nbZJmzB+oSBoVUAgGR6HtujEFcZnHFEogrdUS8aDJ2K0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW4PR01MB6132.prod.exchangelabs.com (2603:10b6:303:7f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Thu, 1 Sep 2022 13:06:09 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 13:06:09 +0000
Message-ID: <f7302043-44f9-35d8-2316-778985a14959@talpey.com>
Date:   Thu, 1 Sep 2022 09:06:07 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Content-Language: en-US
To:     atheik <atteh.mailbox@gmail.com>
Cc:     hyc.lee@gmail.com, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        smfrench@gmail.com
References: <47dbb75a-b299-066c-61cc-2b21ca96173f@talpey.com>
 <20220901051929.14421-1-atteh.mailbox@gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220901051929.14421-1-atteh.mailbox@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:36e::20) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cddb608-47db-4e65-5c23-08da8c1abcf4
X-MS-TrafficTypeDiagnostic: MW4PR01MB6132:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2++ykNcFZGuInG5/JNrC8Ho5L6jrrd74Q8QVjRdFOfGsmk61HK5pWzHcz2irMin2SHIvvbIdSysYL6/m8vWfhzThtrkK4TCqzO/+Wjgaz+bN1eyxoOAXOguMUCQCL+1tYmMxpksg2WI/D5MM07G0MkEgfZitvLcYgKHbTBRzbFOAWCjG8EE7KxvZTG7Sb4K/QSiTKtr9fQfjX/z2Drlcnd1IWVNIaGfMeW0ADYaBemrb/QTR9wz1sMslcNFOfI5Zh/4OKnl1d+lj9shk0PtokoEPFHN2Gnz6WitaiJgG6U2qq1Jp/69duNfwLKsAUiSySQhg6o06ywTZMqcRdZnJHSNzJkeok1XOd+PTBJyWAp+TfgTWjrLHxTDVRNRPhXj6zUyxvtPPlzVNIck3nEHAWpcIFgc1PsX9lMopEtvY6q08/2z4XWhOU+nC2xhshHBUWN+Z1mgh6PmgVhOOwVM5ECi9D+JiyQdbfJBK2+0QdPdkpjY1RbTlT+57ppSbVrumH7r0M4QxkpqdN1KLiX+1gqdDxWyZHCVYNW7CuQaOlHbxb2xmLVTC0rp+fT0kPEyIFgTuD/vUuLbhjgDZp7ptcL6FxF/3DM0FLKSlS214uOqNzTKtLWciKxvi0EayV62+kogvEmmYXr8zHN7/NLv3I2kCBBke5dU0ZFpF83PNP3KKF3hic94V48B8d/SFpqoBjRSlZI4Q8E7p2YlmDHYSaE4MGOwCpdom8QMPBMmhfsHjfpfy2TBvrffEifzqbsgohsVdYlJKNo3Afh4fEMlMam608tUq1fMOQ/29rL6BoLtYGl/ZAYewtYSbpq2+f05
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(366004)(376002)(39830400003)(5660300002)(41300700001)(8936002)(31696002)(2906002)(6512007)(26005)(15650500001)(6506007)(52116002)(53546011)(86362001)(38350700002)(38100700002)(186003)(2616005)(83380400001)(316002)(66556008)(66476007)(66946007)(4326008)(8676002)(36756003)(6916009)(966005)(6486002)(478600001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDZoYWpJZ0JNR1BxcGRmTlRmZEpuT0lmQ1JwTzM0YTZhRnFlTUdPMGhSTjhj?=
 =?utf-8?B?TzRHbDhqVzhoazhlVWtnWmxCRXhHWjJUUk1ZUG9FVHhrY1I4c2g4djJoeC80?=
 =?utf-8?B?V1hJRWx4TE1hWjdidmhxTTExOTVEQ0dpS2hVMmZ0bGJndyswMm5oZ2VpdmYy?=
 =?utf-8?B?VDhoUkN3QXJQbHJWTmk4NkRwcXVnU3pFNTArQWlDZGNKNjc1dFErR1NGU3VX?=
 =?utf-8?B?SHAwSVRXM042bWpkNDhUSjlWZHNuUjhGaURUMmxYZ0M0cHhQcmtqQmJEN2lD?=
 =?utf-8?B?elA0VTJIRHpTKytjOENDRnFsSVFJUk14bW0yMFNjRDhtTHZJbW9UMFZPTEVF?=
 =?utf-8?B?RWZGNEVkQVV2Q0JPUG5SdmROV3dIQVZlbTNMU1FyRjdRN21mRXNkQ3o5OVdI?=
 =?utf-8?B?TFZwYXpENEdTS0NxbnZPUi9CbGEzd1JGa205VGhGcEh4dmRSZDQ0L3dZSE1l?=
 =?utf-8?B?am1hQUUxQU1JcTN6UlNYM29jbjV2V3orTm4vZVdNV1hkb2JhTkhMT21Qd0pJ?=
 =?utf-8?B?QTRLdTZYMmtObS9CNnQwWDViSWc4MS9ZNzZGLzZEOW1ORXRJNFVnQk9OWkNv?=
 =?utf-8?B?YVJhVkFZcVRubHhTckRuRnVuTWNVQzZZd2xMYVBZNkthRFdNWWdybzF4QTJk?=
 =?utf-8?B?MWNoNDdGSldwR3krTzFZZlhBNUpZaE4zTW8rMU5IOGxrN09qNVZHcDF1ODFk?=
 =?utf-8?B?YUIxc1NNRU0xbFZYbTE4MFgrbEo4eExuUVArT3ErMUZ1NkJDQ0FzWUxhN0w2?=
 =?utf-8?B?UHZXd2ZSVFBkMUtxNXh5MXZnS3VlSGcxdWx5VTFYVllpMUQxKzhMakRSVnI1?=
 =?utf-8?B?SktxemNTMjBieit4YmN0SE4wYXRhYVV6aEljNnMxYWh1bno1SVNYalFwSVc3?=
 =?utf-8?B?SFhjeGJwSEVXTFBFNWYwZzBPeFNtSEVyb1FiVHBEUWVzMk0zTmN4cnpmVjFn?=
 =?utf-8?B?NmtQS3hCczJFTlFSN1VSZXJHTFd5empGSGFaZzB0TE94NlFUTGlmRXFaZFdI?=
 =?utf-8?B?VnJKektoN3lNa2J6T3RNZFRKdmdON1FsaGhHcytGL1lYRXNwUjg5QUJlTFI3?=
 =?utf-8?B?WnhUMk9WcFlTRUdTQWE2dHZMbUY2VW4vYnk2c2d1YnQ5L3RDRHhRVmdsVFVm?=
 =?utf-8?B?M3NJUzRUSVpPK3d4eml0QWFnSVYyTnRVZUErb0ZDazVydmFLNGJKV1lJNlFz?=
 =?utf-8?B?dVVWZkhvcXJReDFTV25mWWg0YTFCL3VTQnV1OEpLZFhsZ2xxOGJvL1NEeEZS?=
 =?utf-8?B?elhuSkFic1dSUWR4OG8zR25DK2ZoOGNrSmpBOWR6eWFIYXI5RlYxL2N6Tlho?=
 =?utf-8?B?TUdFTms3cGpncHplZ0lyeTRpVnh3WUpMZ1R6NDh1RUhSL0ZseDRFZ2Z2M0M1?=
 =?utf-8?B?UFliWmJJWnRMa3J0M2QyNlZLbWJFQUdPdm9STnBQOU9LQ0NJV1lGMDN2UUVt?=
 =?utf-8?B?WEZSS2NNNS80dFUrQVowSHhLUDJsM0NCRk1HN0lSMG10blZ6Ni93TDl5Wldp?=
 =?utf-8?B?L3NnbVJLbW8xQW44bjM0cGt2VnRJVWJ5bjZtT1hwdXhsNTNpNnM0cWNtVGZ6?=
 =?utf-8?B?Q0Mwek5wcjdRWmxuQ0pTck9CNTdxWXgwSW1GZVhJeGVvUXFydTBoRmFJL083?=
 =?utf-8?B?a21rajIvd2Z4N3RHSUFaWEJ4ZlJlU05YcjJPbWVjRUhXTmlrUm4wRWR1ZFJL?=
 =?utf-8?B?a0VZVytvbTV6MS9EcUVNZlRNdmRiYmUwQUlYQkQrLzI3cVYzekJNZS92eFVU?=
 =?utf-8?B?Vk1nV1BZRWVpQ28yOHhvd2UxcUVJdDVFWVZMaCs5NFFEOGgxTVZlcHBHUHlP?=
 =?utf-8?B?cXVTL25zalI2cU45Mk5DRFhWMUVCK2lDd3dKRlJGbTd3emMzN29zQWxHNjJj?=
 =?utf-8?B?dzN4U2xwVnJMaUgwMEVCUTZYMjRwMUtLY0VzQktTdjNwUDErc3dYdjZ2WnFm?=
 =?utf-8?B?L3pROVdLc3RDUTJMKzdGbzg5NXFGbys0d2dkRU82Tk5wUHJybG9TemlmTTBI?=
 =?utf-8?B?aTg2TUp4ak9RUUVod3lHL1RUUXhtc0t6VGlqaWZhRE1DWGY1SSt5MU94TTZx?=
 =?utf-8?B?NEQ1Mks0Um1OeFJQOTVqL1Nicjd4SkQxREw2NjRKdklFbWpqb05xQTlXMTFF?=
 =?utf-8?Q?2ZzJYbI7bCekH0dan5dryMasr?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cddb608-47db-4e65-5c23-08da8c1abcf4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 13:06:09.5390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMw23Z4MJDSxA0ZE3s/PlxxXBjLw97JSUxFWpwts75lw5BSxKDYMw+vQrO3EXwGR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6132
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/1/2022 1:19 AM, atheik wrote:
> On 8/30/2022 12:33 PM, Tom Talpey wrote:
>> On 8/30/2022 10:17 AM, Namjae Jeon wrote:
>>> configuration.txt in ksmbd-tools moved to smb.conf(5ksmbd) manpage.
>>> update it and more detailed ksmbd-tools build method.
>>>
>>> Cc: Tom Talpey <tom@talpey.com>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    Documentation/filesystems/cifs/ksmbd.rst | 10 ++++++++--
>>>    1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
>>> index 1af600db2e70..767e12d2045a 100644
>>> --- a/Documentation/filesystems/cifs/ksmbd.rst
>>> +++ b/Documentation/filesystems/cifs/ksmbd.rst
>>> @@ -121,20 +121,26 @@ How to run
>>>    1. Download ksmbd-tools and compile them.
>>>    	- https://github.com/cifsd-team/ksmbd-tools
>>>    
>>> +        # ./autogen.sh
>>> +        # ./configure --sysconfdir=/etc --with-rundir=/run
>>> +        # make & sudo make install
>>
>> I believe you mean "make && sudo make install"? The single & will
>> kick off two make's in parallel.
> 
> Also, Jeon, since `#' indicates root prompt, there shouldn't be `sudo'.
> If you want to use `sudo' in the instructions, then use `$' prompt.
> With that `./configure' invocation, the utilities end up in
> `/usr/local/sbin'. Since `sysconfdir=/etc' is associated with the
> `/usr' prefix, it might be better to put the utilities in there also.
> Meaning that `--prefix=/usr' should be given to `./configure', so
> `sbindir' becomes `/usr/sbin'. Alternatively, `sysconfdir=/etc'
> should be removed so that `/usr/local/etc' is used. This way the
> user-built ksmbd-tools doesn't conflict with ksmbd-tools installed
> using the package manager.
> 
>>
>>>    2. Create user/password for SMB share.
>>>    
>>>    	# mkdir /etc/ksmbd/
> 
> Jeon, the install target already creates `/etc/ksmbd'.
> 
>>>    	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
>>
>> It may be worth mentioning that it's not just single-user access, and
>> that additional users can be configured.
>>
>>>    3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
>>> -	- Refer smb.conf.example and
>>> -          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
>>> +	- Refer smb.conf.example, See smb.conf(5ksmbd) for details.
>>> +
>>> +        # man smb.conf.5ksmbd
>>
>> I like the new manpage, but that's a strange path. Are you sure
>> the various maintainers will deploy it that way?
> 
> Jeon, it should be `man 5ksmbd smb.conf'. `5' is the section number and
> `ksmbd' further differentiates it from Samba's `smb.conf'. Currently,
> just `5k' is enough to do so.
> 
>>
>> Also, it has always bothered me that the name "smb.conf" is the
>> same as the Samba server's configuration file, just in a different
>> directory. If someone enters "man smb.conf", there may be confusion.
>> I really wish the file was called "ksmbd.conf".
> 
> Talpey, in what way is it strange? If both Samba and ksmbd-tools are
> installed, `man 5 smb.conf' is the Samba page. Then
> `man 5ksmbd smb.conf' (or just `man 5k smb.conf') is the ksmbd-tools
> page. If only ksmbd-tools is installed, `man 5 smb.conf' is the
> ksmbd-tools page. The same applies for just `man smb.conf' since there
> is only a page with that name in section 5. This makes sense since
> Samba's `smb.conf' is authoritative and ksmbd-tools tries to be
> compatible.

Ok, two things. What I found strange is the "man smb.conf.5ksmbd", and
as you say that should be man 5k smb.conf. Sounds ok to me.

But the second thing I'm concerned about is the reuse of the smb.conf
filename. It's perfectly possible to install both Samba and ksmbd on
a system, they can be configured to use different ports, listen on
different interfaces, or any number of other deployment approaches.

And, Samba provides MUCH more than an SMB server, and configures many
other services in smb.conf. So I feel ksmbd should avoid such filename
conflicts. To me, calling it "ksmbd.conf" is much more logical.

Tom.


>> Why not putting this under a simpler manpage title "man ksmbd"?
>> To me, that's much more logical and it avoids both the confusion
>> and having to somehow know that weird manpath.
>>
>>>    4. Insert ksmbd.ko module
>>>    
>>>    	# insmod ksmbd.ko
>>
>> Well, it's worth mentioning that a properly configured and built
>> kernel is a prerequisite here...
>>
>> Also, sudo.
>>
>>>    5. Start ksmbd user space daemon
>>> +
>>>    	# ksmbd.mountd
>>
>> FYI, Ubuntu Jammy pre-configures ksmbd as a service, and there it's
>> as simple as "sudo service ksmbd start".
>>
>> Do you not want to mention the other ksmbd.<foo> helpers here?
>>
>>>    6. Access share from Windows or Linux using CIFS
>>
>> Pointer to cifs.ko how-to page?
>>
>> Basically, I'm encouraging these pages to be (much) more user
>> friendly! They're fine for developers, but way too fiddly IMO
>> for naive users, or even for admins. It has taken me days to get
>> this all going on my fresh machines.
>>
>> Either way, thanks for the cleanup so far!!
>>
>> Tom.
>>
> 
> Atte Heikkilä
> 
