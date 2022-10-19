Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51C5C4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Oct 2022 16:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJSQEw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Oct 2022 12:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbiJSQDu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Oct 2022 12:03:50 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E9A16F419
        for <linux-cifs@vger.kernel.org>; Wed, 19 Oct 2022 09:02:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z27I5Gfsf0IJeuKeDiSt/CKd7gr20vbXZ2jcmO7QR5wuhsEgCzUBj0spi7H5nX9tycFt/fL7wcuUHLs5Iq44MCLRcmyiLDEE/AGYfE87VwOzmSpQd6tZYT8onAtznXNFrpzVLzR66/aoaIoYbbBPj7zBJev7rlJAeI3VdA9xAGFd+KRuacS8mrbaTHNZj/ZMOBK89YJoIMOmOdZXpFW1MqvzrYIz6HJbcTvoOnB2Z3zImPIY5yksiethL0EMvFtZbrTURysjJTfVowyrLsu/ItpmZU0IdIBA7xgrvDwfUZiTklFML+KbUYiBY9EhQTy+tjBeIQy0ifxGMRyfnaPGGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fw+8pos+vCXTGsQ6RXIwYBRQaAOgIcr2cVCiLh5IvOw=;
 b=Pu+SFMJrgIJHYMQesSlQhpkQq/pRdDQWrLiQSpPF9WHtA2dD7dLmFYsjcFM7+2a3BRZmQqDJOYFYwRNgIEwE6lJiINna8oXnLm1b+ybWQSMr96PcjQsRKzP/h2oYo/gaT0v8pfNkyitnVtp1OaGd+OJtiKOnaBlcPQglF6tfjcVnaYt6TKjdeD8Qz/0HrcLhyQCQlc+lWaAp7kF/UqUubGcqNA7LWSx/QMkBwQGvS775t8w2o6feKPeLODE+ZDdfw7OM4c2WUvfJz65kdmE+rFbSG/G5G5hnCEs9mi7o2b11tsX4NN7fkQ+oMjuKuEah78IB/2I6l4GjxwiSDRIn0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL0PR01MB4434.prod.exchangelabs.com (2603:10b6:208:81::17) by
 SN6PR0102MB3407.prod.exchangelabs.com (2603:10b6:805:11::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.33; Wed, 19 Oct 2022 16:02:40 +0000
Received: from BL0PR01MB4434.prod.exchangelabs.com
 ([fe80::28a9:57b1:9a6:c5d4]) by BL0PR01MB4434.prod.exchangelabs.com
 ([fe80::28a9:57b1:9a6:c5d4%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 16:02:40 +0000
Message-ID: <139c8923-ec0b-6227-28de-d9b0a63abffa@talpey.com>
Date:   Wed, 19 Oct 2022 12:02:39 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] cifs: drop the lease for cached directories on rmdir or
 rename
Content-Language: en-US
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
References: <20221018073910.1732992-1-lsahlber@redhat.com>
 <20221018073910.1732992-2-lsahlber@redhat.com>
 <b1454884-cc28-9de5-8dc2-b96f92f1d8e4@talpey.com>
 <CAN05THTtZhkN-MVefP5Q4Z2GBsX_-xU2K4WCFfvjJogJSp0kFQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAN05THTtZhkN-MVefP5Q4Z2GBsX_-xU2K4WCFfvjJogJSp0kFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0378.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::23) To BL0PR01MB4434.prod.exchangelabs.com
 (2603:10b6:208:81::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR01MB4434:EE_|SN6PR0102MB3407:EE_
X-MS-Office365-Filtering-Correlation-Id: a57977c3-6c08-474d-8238-08dab1eb593d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8yMMaoyF4ZGd/Lug60nE/WfkHaQRkhVUQxZCasSlVfNV8nKGZY6fe2GguH9DeZ54nJsHCtXEQa80ETdttz5t2x9kWcd7l1ZA8tCgEDAY1O2UXCgUntYIMSlzg/IVyPlX1UanFhZuMMKrr/Lp0VmE96P9Qhy6zFYmwDG0j+4rGtPF2nIm2BpOmp0v4rC6jftSvhlBMeUfhW5GPmGA6JRX3sgPXpAhd4PwYB28dtI9rjtnJVsBKgg//IybNaBlPkF9/7Ex/09f/2/70JuH7CUS8jO15alEl+5aYfbe/u+LghGGQBzKK2IPycnE40k0Yad+np2QBDofq2519JNhRDWvwV2Prmzjc6jQrMqj9bb0vPBTleJB5WZSoFGu1z/b3fgpX1eHXXMSvKs5g005eNoiv2xonHAs4nNtZ1SaVE/8gS2Z+UyrLW0po3e0krqjq309A6BRxFO/V30U8Erpb5hgPP9S0Gbrlll4/GpHaqik8mDuALkVqr6ofACY6A6xNSg5y10LDM3R4Iow0r2xHnAbML9U6UZIFYJ1quIdbrHL5Po2TrpZlxMYvVJPSdYqYt472NT4D+N38SMFLy7qTmPSE3PgJa0DyL8YiJx9tnBB0DPUHpoy/CZAyrsszm4ukKtF5uEWo1aCMGLZjv1q4M67r/HLyOq4rCOtVn/huzC8LmH5nwgiXT0X72g4z/mc0wkYMNdvTmhq6xvdg/hvHhuPybxbNmLUblj+LurUKbKWGo0RNJCgp1ZRBU0LMHOtNx1/uVJlg5+YsRZ+FTz5LY3LHcEJau/ZawzjZPWczO/KDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR01MB4434.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39830400003)(136003)(451199015)(31686004)(8936002)(2906002)(5660300002)(4326008)(38100700002)(36756003)(54906003)(8676002)(66946007)(66476007)(66556008)(41300700001)(316002)(6506007)(6916009)(6486002)(2616005)(6512007)(38350700002)(186003)(52116002)(53546011)(26005)(83380400001)(31696002)(478600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2s4ZGpUZE9KTG5JczBMK2pSaklYblVjbXdEYWdIdUl3TjJBdWMydUZRYmRv?=
 =?utf-8?B?V29YWk9xNUNHQjFZR2dqV3BXaFFSMFZIUXpnWCtuWllpWHo3ai95cjgwNjlG?=
 =?utf-8?B?ME9KWnRrQTN4TDk4WGtRV1NISjIwSGtJdXNBNTE0NVlwOEx1T0hha25HWVdt?=
 =?utf-8?B?MEJVSmVRWWJReEdTME5FdURaODhsK0FIbFVTMVJNNGZCWDdwb3U0WDh0VHlE?=
 =?utf-8?B?Q0o4aEo0cGhDd1EyVkMrRmo0Zk9FOUpBTlpRMVR6QlRtaFhieUdTQ0pQVGlj?=
 =?utf-8?B?M1FVNDlhSFV1YVk4OGNlZjkzcEZTeGU5S0dMbWdTb0hESm8rUWtTYjZSbW1Z?=
 =?utf-8?B?a01aQ1ZYM3UrMkFtNTFYVWpuMkRsdmdVUUhtNFhaQWZ1RXZWSmU2NjY4dml2?=
 =?utf-8?B?UEVLRFdLRVQ0UkhDQ0V1SW9PaEtQZjVESFlQa3BGcktob1NpN3k5eHpzbDFT?=
 =?utf-8?B?M0NzTExjemwzeURycE01anpIMHVmdlpxd3ZKWDVwYTVQV1c4L0V3RktwU0NV?=
 =?utf-8?B?a2lpN2NEWVdWN01wc0VwbFIrY09XUkZlYlJvTVZXcm1HWnFzQlFHYmFyVEl2?=
 =?utf-8?B?REQvWHlYNndoWWZIa1cxR3h0TFQzRXVZb3dONjZPSU80MzhjNFVDajFBR0t5?=
 =?utf-8?B?ZWlZT25GNUJlTUxsN3RzL2lYSEIvWjNhUzV3dyt1cHMzWEc0d3ord0pzSEdh?=
 =?utf-8?B?enNZdFMrY1VJY002WlpVcjhYeEQrMFJqMnVjNWwxYVhLMkpFdjhRVG43WGtR?=
 =?utf-8?B?VTZzdy85ZzJLdDdGQ3RvOUw5bmoyNVRtK1B2VXJLSDBPR1J2Vm0wSW9pM2ho?=
 =?utf-8?B?WCtxK1RJb0U4aS9QVnd0Rnc5VWxZMGdFTHRiLytBRFVEZFRUcFhsaHlqcVp4?=
 =?utf-8?B?VmxKeWlReGx4OHNqbkZUQjl2ZWdqOGgwd2htRWJLUEhwcnRwOTVkb0ZxaENm?=
 =?utf-8?B?L0ozTzRLNTJhUGdlV0dlNWNVcWF3aXlBbTgzbzBKU3hNa3pBb3E2R0RpSks4?=
 =?utf-8?B?OCtaOHRDM3lFRTZVTXV2TENlNlNQN1JnVUhqeThORzRIUUNCWFVwMkdkT1NN?=
 =?utf-8?B?MWZWZ05mMDZCSDdZQVVVNitLeXJNQlljZVZpQWVNbFlOUGVHNVVtYXlwQzQ2?=
 =?utf-8?B?WHhIOWRkTFRMU0tyODBRMWlRZnRvalNOK0NJOW04SFpKVk9rcDBJVWVlV3hH?=
 =?utf-8?B?TUk4RFloOGRucE83MFgyWGRaM2JsYjlPS25QMFp1endsOWwwbC9mWmNDazVq?=
 =?utf-8?B?THYvYmVRU2RxbHNwUWNwaXVQZHRTdkdRdU5nWldoc25VSUxzdm1zeVkvOVNK?=
 =?utf-8?B?ZnJHMGZONGF3dWJxb1cxZDVvczlEZ0dURDFtemxXRk9ZSUEyV1dEQ3V4THBJ?=
 =?utf-8?B?cnBhNzdoOGI2ZXVDQ2c0VlFaOHliV29ibkxNNnY4TytuNDNZNDk5SEdwSjB5?=
 =?utf-8?B?aGlJU25NY2F4a084MUNidExsY2lyVTFTRGRLVUZOU21CMnFZSmI1NWR1eUJX?=
 =?utf-8?B?eTBMbDBDSktHejl2NHUwQ2FtUW5XZFNrWTc1T09RZTliZXkwOVh4TzEyZUtP?=
 =?utf-8?B?UGNyL2JDbVBhd0ZIZ0FFdjh3aE0wZlJITVRmZllpd203SG9mS0RqNlF5WW0x?=
 =?utf-8?B?TDVpM2ljOENMbWVoUWZ3d0ZSTlFQMktVdU9MZEF0c1pUMXI0QjdLQWNXWE1s?=
 =?utf-8?B?K0I3eUUrSjJJK3gvRUM4Tk5LUk9NdVpERW9DVk1BblNvNXlDNFNjUWRrbElQ?=
 =?utf-8?B?RExBS1EyZk9mblBZU3NQeHdqclRTTnJyR2s3QkJPclp2a2lqdU1WcVdqYVJI?=
 =?utf-8?B?c3lYNDlSbWZSWWZHaG85bHpRNUMvOGdDbzdLbndkais3dHczaUJnNUtBbjg3?=
 =?utf-8?B?TWZocWd1dFZzNTVwUFF1bXcwdjlPdDQzL0doeU5DeG9ZNkpDMjg2bUI2MGth?=
 =?utf-8?B?MUxaN04yeW9qdmlkaG9EcHF5MUpCOTNUSmJwdHJMUFg2Sm44K2MxSTQ3eml6?=
 =?utf-8?B?VDVpd1BsWXdxNmZ5UjM3VW0wWEtYVmN5YllHRU5MSmRzd2RCR2VyeC9UelNv?=
 =?utf-8?B?L2hvKy8yVTRsN1kyb2FsRzFMSEhWajVNcktrZy9Fa25ERWwyNmpzYVNTQUV0?=
 =?utf-8?Q?5Kj8=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57977c3-6c08-474d-8238-08dab1eb593d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR01MB4434.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 16:02:40.0074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMsMm00IxqeCl1vFiPHwCapgSPGqb7A0POZplx+KvW0fC5ZN5Ri++FRWc8YKjsAC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR0102MB3407
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/18/2022 7:47 PM, ronnie sahlberg wrote:
> On Wed, 19 Oct 2022 at 00:27, Tom Talpey <tom@talpey.com> wrote:
>>
>> On 10/18/2022 3:39 AM, Ronnie Sahlberg wrote:
>>> When we delete or rename a directory we must also drop any cached lease we have
>>> on the directory.
>>
>> Just curious, why drop the lease on rename? I guess this is related
>> to setting ReplaceIfExists, but that would apply to a lease on the
>> existing (replaced) directory, which would then become deleted?
> 
> You might be right in that, but I think the lease will be broken by
> the rename anyway
> so by deliberately closing it saves half a roundtrip for the rename to complete.
> (you get a lease break both for the directory you rename and also for
> the parent directory as far as I can see in traces)

Do both Windows and Samba servers break the lease on the renamed
directory? I'd certainly expect the parent lease to break, so that
much isn't surprising.

Tom.

>> I'm probably undercaffeinated, if not.
>>
>> Tom.
>>
>>> Fixes: a350d6e73f5e ("cifs: enable caching of directories for which a lease
>>> is held")
>>> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
>>> ---
>>>    fs/cifs/cached_dir.c | 21 +++++++++++++++++++++
>>>    fs/cifs/cached_dir.h |  4 ++++
>>>    fs/cifs/smb2inode.c  |  2 ++
>>>    3 files changed, 27 insertions(+)
>>>
>>> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
>>> index ffc924296e59..6e689c4c8d1b 100644
>>> --- a/fs/cifs/cached_dir.c
>>> +++ b/fs/cifs/cached_dir.c
>>> @@ -340,6 +340,27 @@ smb2_close_cached_fid(struct kref *ref)
>>>        free_cached_dir(cfid);
>>>    }
>>>
>>> +void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
>>> +                          const char *name, struct cifs_sb_info *cifs_sb)
>>> +{
>>> +     struct cached_fid *cfid = NULL;
>>> +     int rc;
>>> +
>>> +     rc = open_cached_dir(xid, tcon, name, cifs_sb, true, &cfid);
>>> +     if (rc) {
>>> +             cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
>>> +             return;
>>> +     }
>>> +     spin_lock(&cfid->cfids->cfid_list_lock);
>>> +     if (cfid->has_lease) {
>>> +             cfid->has_lease = false;
>>> +             kref_put(&cfid->refcount, smb2_close_cached_fid);
>>> +     }
>>> +     spin_unlock(&cfid->cfids->cfid_list_lock);
>>> +     close_cached_dir(cfid);
>>> +}
>>> +
>>> +
>>>    void close_cached_dir(struct cached_fid *cfid)
>>>    {
>>>        kref_put(&cfid->refcount, smb2_close_cached_fid);
>>> diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
>>> index e536304ca2ce..2f4e764c9ca9 100644
>>> --- a/fs/cifs/cached_dir.h
>>> +++ b/fs/cifs/cached_dir.h
>>> @@ -69,6 +69,10 @@ extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>>>                                     struct dentry *dentry,
>>>                                     struct cached_fid **cfid);
>>>    extern void close_cached_dir(struct cached_fid *cfid);
>>> +extern void drop_cached_dir_by_name(const unsigned int xid,
>>> +                                 struct cifs_tcon *tcon,
>>> +                                 const char *name,
>>> +                                 struct cifs_sb_info *cifs_sb);
>>>    extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
>>>    extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
>>>    extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
>>> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
>>> index a6640e6ea58b..68e08c85fbb8 100644
>>> --- a/fs/cifs/smb2inode.c
>>> +++ b/fs/cifs/smb2inode.c
>>> @@ -655,6 +655,7 @@ int
>>>    smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>>>           struct cifs_sb_info *cifs_sb)
>>>    {
>>> +     drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
>>>        return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
>>>                                CREATE_NOT_FILE, ACL_NO_MODE,
>>>                                NULL, SMB2_OP_RMDIR, NULL, NULL, NULL);
>>> @@ -698,6 +699,7 @@ smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
>>>    {
>>>        struct cifsFileInfo *cfile;
>>>
>>> +     drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
>>>        cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
>>>
>>>        return smb2_set_path_attr(xid, tcon, from_name, to_name,
> 
