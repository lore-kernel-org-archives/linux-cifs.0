Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E24ECAAD8
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 22:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiIVW2u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 18:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiIVW2q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 18:28:46 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46E1D12C7
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 15:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNzmvx5sGKGFcwvVEf9rwLj6LBP568wERjaRVvCpQYA0LGLgqcTDoYIuvh2/w0YjChvZj4myh93LgR7D6WEINy318KXwRmJMgOh1N6tHKSKg+ZnMIrH+gM8jsBkSGBU14gZyOFJ5dQZeByQugUapw6oAUdjylfu99k2NOWv+VpphOSEo0jVxl6SGHmT/fPOSS9hBuPb4O0lEtOiPv+Nnd/VNWRm5FkuL73Nb89HsEDWOmvTEiImtzjrovgqPTP/yL8an6aSdZrnHZ9XezAyr+IUfz7aH5f8+5JBkik9Uu3C7azzyozRmH3+NGKi8u1eU33cgIPJi1Z0bun85xj+Qow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imN8/+WcvzDHHN0KuacTGt0z0QutP25JODGmMwe9gyQ=;
 b=n0LdXipvY8IrXNIx2XyidhZ/M5Jghz0CqV/jggin7cfpuXUb9d84Nx7CgDkX+Z8lbm3ju77DjLW3BHDyKGNbPAU10aBZ/o9sq+IRD2HEAgDKInQtnDExXIwFFdLHYlQ3I2ZV9xaV85Zd5YGztYZoRR3bp1hkH9T8bCCDlIejJPcZRFEOb8Tdu6s7KZk09YV02hRGQM9j4dBscektXOmAlXCJKl81W0g586gmNXM5ZL/nGa0PMej6/pQm67vAw3DV9sz8FZQM8okHmGq9To6VCb1TBXi5PgE4haOt++J8Bo0dNl57DWar3eHFKJ/tYv3zCSQaR5CAXjLFNZhOcmQ44w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 LV2PR01MB7600.prod.exchangelabs.com (2603:10b6:408:17b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.19; Thu, 22 Sep 2022 22:28:42 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 22:28:42 +0000
Message-ID: <7cf2749d-32ae-b947-f94f-f0875d1a646f@talpey.com>
Date:   Thu, 22 Sep 2022 18:28:41 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 3/3] ksmbd: fill sids in SMB_FIND_FILE_POSIX_INFO response
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <20220920132045.5055-1-linkinjeon@kernel.org>
 <20220920132045.5055-3-linkinjeon@kernel.org>
 <1799ec3e-5152-3dc9-1000-2f03396883c6@talpey.com>
 <CAKYAXd89K58kq8PXSP7CNrc2VsW5cVAFWtj-XpihWu-FkUt3ZQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd89K58kq8PXSP7CNrc2VsW5cVAFWtj-XpihWu-FkUt3ZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0027.namprd19.prod.outlook.com
 (2603:10b6:208:178::40) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|LV2PR01MB7600:EE_
X-MS-Office365-Filtering-Correlation-Id: 62004ece-d206-492d-20c4-08da9ce9cdad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WtqpjxcsvfvmhpjAIWcoASSwMGylYkUt+1V2rCXBZctwHkYHJ9Mrsk5UEmhTsKBoHPdOYLbUOFhLLkisCNmQ14Gc0Ls6MT38BU3GhV/H2QwMkj0KguQf7iGu55mNp0+kO5prKbbywumKGirT0pbyq0F9IpLrbn+zsQp9IruRud9AcpwpWS+EsLTPsJV0gaBSw9O5GCfH4CDAUU4EInMtG3Thcmswq+1AROAonpzbjKK/4DXMtofz47QhZU+AXDqY00fjBe1BUxO40SQJ4mLqFwcrI8PdI4T4RsVy/Op5MMws3705bk7DDGlRk0WX63oRIEmEPmveHPBkEfLboLWxqmv7bA3W85NeTuhdxM9mwma4JP51ZjshyHwCFpUnqT52kQHL8WrVLY3cRRbkHG33Sn1J9PbRAVlrPayWnCpVpEXDzm5Xux4EvwJdXcGv3muclg+Flz6YPcRY6LLkODAHz4iQmM6V7dlHimt0jxJzwatBdDx98UDkeAWleQ99VM3zEWtSh6jJpj4AnsgVJhzcPnQIHXyB6yUT4usFZAMrPwiukrUTxHY46dQq2Zl7nU/L6T/et2rhGVnjNVY2jA7PqBj/m7X4ey7iFN6pBNnY3Yy9VRGx0ZwgSOyl/E4gDOWoWNlW/517EBx6fMsXnHFkN6OcXBlmBIOF0f52iSyXktFSW5sHl6ET+g0YPWAupuHBNX1vhGAnWa2Tcv/qk11iSLqMRaHmCpoUtEC8p6A/e2Ui3oQN3EdYd9sMrrcLrHMM177wWrBSPwVTk1PvYExXIZ84L9ZTbcUh5l+7W4rsyzk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(39830400003)(376002)(366004)(451199015)(31696002)(38100700002)(8676002)(86362001)(6916009)(41300700001)(66946007)(4326008)(316002)(66476007)(66556008)(38350700002)(8936002)(5660300002)(83380400001)(2906002)(2616005)(6486002)(478600001)(186003)(26005)(36756003)(31686004)(6506007)(6512007)(53546011)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1Z6Y1JabFhaNldYRkMrTTk5Tk5EdDZ3TmRTYXRhZkVlRFhiQytnS0p3R29R?=
 =?utf-8?B?MEYyS2pSNnRKdklHcXVXV3llZGpGTnVkTkRJekMrNEdWLzVncGdOYVVTaUU0?=
 =?utf-8?B?eXg5MEdOVVJML3o4VFoxWFdDUjV3dS9iVXFOdGZSd2FiRG1pazdKaHpTM2RD?=
 =?utf-8?B?R1VPL2piTlRKQ2xCZ0c2dmdEQnVxTjZMMlR5MWVOMGRzTUxMQmNrUHA0VDlI?=
 =?utf-8?B?Lzg3c3N4N3FWWEd2SHVTeUxmTHJNakJHazRqUW5DZkcrR3BSYUhzblVqWVRu?=
 =?utf-8?B?ejFWMUtORWVDTHdJVG1vNEdobWpTdU54U1RwcCtaU0pCc0NpMGcvYTZmNVBS?=
 =?utf-8?B?OUlKbWVGRUZaamN0RVpXTkJGRUhZQnpUQVNUSGEyV1dMdzM1VmNSM2w3ZFdt?=
 =?utf-8?B?SjJjWHVCY2Z6dVNIWmtSOHZ4RVJwUlVoQVhObEhWV0ZnV04wWXdaWHAwWWNN?=
 =?utf-8?B?OEJUNHVlVjBaa0J2d3VqRndDZURManQvMDN4Z3NOVHJiazJNRkZRN2NqMlpX?=
 =?utf-8?B?VnhheVFTSGVXRGlRSkFyMGt6amQwVXpRclFXOFFKeUhFbmlHTjFUUmdrOHR5?=
 =?utf-8?B?dWd3RXR6RkhickZTbVNRcG5PaHl0QmgwZGUrU1RYL1hkQkMzUi8rbTh4K29h?=
 =?utf-8?B?cTJHNjFud3VyNG1oOThyYWswZmJVVVNVY3JqZUFYY04rNHc0Z01Sd0c5N3hQ?=
 =?utf-8?B?V3VTR3hxU1dDZ0MrSWdpQkw0TEJKcHE1dktpWkhqdlhaV0MzYkl5d3pINWlI?=
 =?utf-8?B?dDc4VGg0S0JiTnIwZktxbUJ4S3p6M1VlM2duL0ZQTnhzNlpoWU9telhObTNV?=
 =?utf-8?B?VE5FRndWSGlONUhGOFpqWVQrQUs1THg5UDFTNS9tZlBTTVhQdG5zSFY5cE96?=
 =?utf-8?B?bkw0TkxFanoySkNnMWRNZXJiTm9lNnNPV0YzRzR6cXp2K1dsVnppdkxaZkpW?=
 =?utf-8?B?WUg5MlFHS0xSZ2duT2t3SUJTemViZ2VUM1RDb0JHWXY0OHc1LzYyT2VBTEFx?=
 =?utf-8?B?SzEvcVMwbzZ3ZVNoZDduM2FES3NBUWlIZnRQQnJEWEtNc3FTV2pDLzl0YjZB?=
 =?utf-8?B?N21NSzlEZUkraUViaWQwYlpFM2tmQ0FNSnZ2TDIvWXpyMk9SRVc5WllmUjVn?=
 =?utf-8?B?OXpKVWt0dVhZcVF6RHRsZFZUQi9uZG92VFEveHNET1F6clhhcGFUV1BxWTJz?=
 =?utf-8?B?NWNGRGtJR3psUWdFMDN4NnhhNTlqYU5aRXA2eFVpQlRqZ1ZPWUlJdnZGWDZL?=
 =?utf-8?B?ZHQ3VytxRkdqMzVpeXVwTHkzbTJqV21ZWFBxd2szNlhFVndsV0k0blBXRytN?=
 =?utf-8?B?ZmhiTEIyYURLS3k5UTdTbFJlTXZNaEZjcVdJNmViR1hEemlyTENKaHBobWh5?=
 =?utf-8?B?aHlKN0dYTlhUN05ScjZhVmROL0tIL0FiZmsrY2hTOThQNFlDM2s4dk13Tk1l?=
 =?utf-8?B?TFV4UWNJY3JkeTI2VUlCOW4xUjEyMm1OZmtBS1VVZnN2RlM0WnZ6K1VpWkRh?=
 =?utf-8?B?U3hodlFBQStzdG9yYWdBNklkUjJOcU42ZUY2Umd6RXZaZW94Q1Q1dVVyUWM0?=
 =?utf-8?B?bWgrVld5WGY0UCtieUw5dFltMlQ0ODJhOVZQV01CQzl4K29YWFhlL3M3amJW?=
 =?utf-8?B?OGdTSXJrQVJrMng4czRoZjd5YnVlRDgxUXZud1ZFeW80dE1vQVJIYU92a1ZB?=
 =?utf-8?B?YUxjcnY1V21NZjFLVWc3dldVeG9yQ1VLYWlrdlNzYSs3SmlyRnI4eVRSWDJX?=
 =?utf-8?B?YW5ZQ3dmSmpra2h0Qm5LVUlVdE4vSktOMUJOL3M4bkcvckJsakozdGE1UEIz?=
 =?utf-8?B?dThjajUyclhiRGNyZ2tnajZJeVZnMnRqWHYxRTJLOTllZ09lMW9xL2Fqb3Nk?=
 =?utf-8?B?blAwQit1MDdmdTJzKzQ5Rm5NQkFEVTh3N2JUNWg0cm0xWjFnUXh3dTMzWHpE?=
 =?utf-8?B?RnRBclh2R2dXVkxOWmxMUHNEYkM0TS9LS244SUZTZWlPMkZQdUlEZVBrM2RS?=
 =?utf-8?B?K29LWXlFZ3RIb3FyZnpaZEtJbEhWOTFBb2Z4MW4wcTJWK2tKV3V3Zm1GN002?=
 =?utf-8?B?aThxY2dvRmowZlhaYlVWbW12TG5Ka3NkdGEvcFZJWkcwT24wRWVPMjJkNUFt?=
 =?utf-8?Q?ubI/X8djImXgYjTgMe3PeIOLf?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62004ece-d206-492d-20c4-08da9ce9cdad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 22:28:42.3803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mawrNWfoQbQCo9q7mgjc8g33HHP40yIrS+ni4iu+y/r5wjrAxdzpT3MPpNkq6asq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7600
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/20/2022 6:20 PM, Namjae Jeon wrote:
> 2022-09-21 6:05 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/20/2022 9:20 AM, Namjae Jeon wrote:
>>> This patch fill missing sids in SMB_FIND_FILE_POSIX_INFO response.
>>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    fs/ksmbd/smb2pdu.c | 15 ++++++++++++---
>>>    1 file changed, 12 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>> index 5c797cc09494..9dd6033bc4de 100644
>>> --- a/fs/ksmbd/smb2pdu.c
>>> +++ b/fs/ksmbd/smb2pdu.c
>>> @@ -4717,6 +4717,9 @@ static int find_file_posix_info(struct
>>> smb2_query_info_rsp *rsp,
>>>    {
>>>    	struct smb311_posix_qinfo *file_info;
>>>    	struct inode *inode = file_inode(fp->filp);
>>> +	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
>>> +	vfsuid_t vfsuid = i_uid_into_vfsuid(user_ns, inode);
>>> +	vfsgid_t vfsgid = i_gid_into_vfsgid(user_ns, inode);
>>>    	u64 time;
>>>
>>>    	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
>>> @@ -4734,9 +4737,15 @@ static int find_file_posix_info(struct
>>> smb2_query_info_rsp *rsp,
>>>    	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
>>>    	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
>>>    	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
>>> +
>>> +	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
>>> +		  SIDUNIX_USER, (struct smb_sid *)&file_info->Sids[0]);
>>> +	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
>>> +		  SIDUNIX_GROUP, (struct smb_sid *)&file_info->Sids[16]);
>>> +
>>>    	rsp->OutputBufferLength =
>>> -		cpu_to_le32(sizeof(struct smb311_posix_qinfo));
>>> -	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo));
>>> +		cpu_to_le32(sizeof(struct smb311_posix_qinfo) + 32);
>>> +	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo) + 32);
>>
>> These 32's, and the one just below, are really sizeof(sidbuffer), right?
> Yes.
>>
>> Why code it as a raw number?
> Sids is declared as flexible-array members.

Ugh - worse than that. The smb311_posix_qinfo looks to have
even more undefined payload:

	u8     Sids[];
	/*
	 * var sized owner SID
	 * var sized group SID
	 * le32 filenamelength
	 * u8  filename[]
	 */

This is pre-existing, nothing your patch should address, but
does need attention before we attempt to standardize it!!

MHO anyway.

Tom.


>>
>> Tom.
>>
>>>    	return 0;
>>>    }
>>>
>>> @@ -4858,7 +4867,7 @@ static int smb2_get_info_file(struct ksmbd_work
>>> *work,
>>>    			rc = -EOPNOTSUPP;
>>>    		} else {
>>>    			rc = find_file_posix_info(rsp, fp, work->response_buf);
>>> -			file_infoclass_size = sizeof(struct smb311_posix_qinfo);
>>> +			file_infoclass_size = sizeof(struct smb311_posix_qinfo) + 32;
>>>    		}
>>>    		break;
>>>    	default:
>>
> 
