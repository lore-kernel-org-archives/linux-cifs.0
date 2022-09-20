Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F64C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 21:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiITVBF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 17:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiITVAs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 17:00:48 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB6677564
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 14:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4KbpLcRuBGLeOOrCqxBjdKz0HgyEH4XK9aWdmaz1W2PcCuiaJ/V+EAFZAPe7oYcizbWXd5eo7i0z49iMn6hyiV/PT+KNaJXp79cMtH3iDcvaiHMHzQE2rx8LGlGC0YAOKuMpQ6lltQ7dks7HkLE12ozWmN6qnM+Ql9hJn58fgE4OhTzZ79YpX1UNoxcEZvWjZJ9xxZPN2z8fCO5iAbOZZwQWs4afU1ZBD7zSN4xtPiTjECYTaShxzfZKkXDKXZQLEyaFYIf1xw3BMdOYy61mk36a3XvyBCE6Y/t14ZJJq/pKIBvmZjfNK+lEyXYUwbwqiARwx1ds0hoSFmye1+/hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7JfWVMEiXjwd9pJ35VVuL9COlmtB/5l6P55momVNclM=;
 b=a1iTkbbiZJGqN0i+F/FsWQhVdk3tYRF99KVjIZ+89IyCHmAien0+lqQqiKBy26UDPDQphEMG5XgXCBhNoMMJ4/Cvhl8bI1ZRtogLYk6K+BNrwno9lNuoL2fOf6roRDvf7wZbuWvJcbCVMB5aS6WhSxSgL0hEB0Kx2bzl305m0o850bJ5Jux6v94XYFRY2GMyMLGpvrn/s9/qIfzyxtlzX1xuC5mmc2Jz8w6oc6tQURqPdHwGiIRZV7BXKo7f14qdks/SFJreWfgp2nQ+3DJfazNk87qBUOVNs0xYbtwvhKFkC9KC0KQO3cNW/JGO8b4Aj+RTwNVfWImbICsxJ5izng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 BL3PR01MB7147.prod.exchangelabs.com (2603:10b6:208:342::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.16; Tue, 20 Sep 2022 21:00:36 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8])
 by BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8%5]) with
 mapi id 15.20.5632.021; Tue, 20 Sep 2022 21:00:36 +0000
Message-ID: <885b9a45-41e0-80f5-773d-81035a25f197@talpey.com>
Date:   Tue, 20 Sep 2022 17:00:34 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/3] ksmbd: set only file permisson to mode for posix
 extension
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
References: <20220920132045.5055-1-linkinjeon@kernel.org>
 <20220920132045.5055-2-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220920132045.5055-2-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::30) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB4438:EE_|BL3PR01MB7147:EE_
X-MS-Office365-Filtering-Correlation-Id: 64ce0d8a-834d-472c-6496-08da9b4b2a2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BGVZfTV/Yo4E6Yjl46TsjCdg4CmpfL8kEZ1npQ9Tfu+QmQ+VKGvuZGiUapawE5ugWx1Cy1QUlgQpyAeMIr1VYSA6CzFGQcSCIGVJidOxcrUm2zvLi+y8OaWTx28RpJT2UUOrN+1WXj9czu+Dy2ZX2Gj7ynW3MSNscghwrRBSIiMw08o7AtI9kjBRhwvGnhSVNkz6X8Tr3zPP3Qz9D0F2wfZ/ss4EqT3WqfgfGQnrxrlLYRdsb9ElXPoR6FGcw4KZLipU93TXSX8HJ0b79FjDCAC/STnXoHeRPemglqjWvecq/bK1G+/6AjaYw41h3yDhf36oQlXxcRdmozqbiUgSKK+FAIOA84AK0LrkoBScuQO52BmzJ0ZfLLYHs03Ev63zRfSN8DjwclDj0+todGtoohf/2iPmo/NJ9SrjN8waZ0xi3uX5CnUrlq9quvuoZdUVV8DLQKf23nKCHg/YT6ZI9YuciaLR8pETYoq7swMZKhpUynoZLNfdXqNipF5ajH64NY6TkhuUtdJCWKtJ/vUYhrYjxaSkmGFk858IT5FnRlIp4Pn+hoGA57UDM/w2XPfeiZ0FuAJj6Oa2fcT6CFfep4nqIBwq9Wa3vVgCq0qfik6+AWPunVjYSofH9VrohMMrG1RPkxPlv8spnr1x6nj07+agZ1oCWrvBlST6V3DB2RMB0M06oDDrNTOwztd/AHvxKVKqJUM2xk780cf4L+QVfLjViWhOtg7b0Vj6OemQ9MXH760lsmvJp50/QO7l+/vCyvD1bCRYpgMaGVWJp8Vz/HIIEWJRyaz1UgKnEgsgZl4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(39830400003)(376002)(136003)(451199015)(31686004)(36756003)(2906002)(31696002)(316002)(5660300002)(38100700002)(38350700002)(4326008)(8676002)(66946007)(66476007)(66556008)(8936002)(86362001)(478600001)(186003)(2616005)(6512007)(26005)(83380400001)(6506007)(41300700001)(6486002)(53546011)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkdPc21rSXd2ckQzS216VWFhSXhtYjQwQkxoZU40MithWHhndGhLdWVIN1cv?=
 =?utf-8?B?UnMzcWVwaGRMVVFSbFBES2tNb3dGL29pclV0K09ZVkRqMFBpb2d3cHdjOEha?=
 =?utf-8?B?a004aUdwY3lNbjRCd2VVTXlXdjJWbVFMeHFWUjVBYlkyViswSkRORU9QK2Q4?=
 =?utf-8?B?aXJDMitsTjhuR3VmVTdVQ0l1d0U1YklQYm5DbTNKM05NODY4ZHE5c1EzcC9m?=
 =?utf-8?B?aXJiNFB4OGlXS0lMdEFYQ295elZPODIyblYxVmNzKzkyRDhKZW14K1hNZVdh?=
 =?utf-8?B?dGZHZzhBbC83aDhlRVJsck91RVdSSlhRaFNUTExSUUJhbmtwT0pkamgvTTNK?=
 =?utf-8?B?Z3RSbXUxcUk3NFVyVjZybG12TjloQXJSMVRLQ1ZOS1NtelNCbENkTXliQUl5?=
 =?utf-8?B?eXIzNE15NVlLNkZOKzVkSWRWbG1zbTdpKzBSUFZPSmF6MjByRlpFTHFpaER4?=
 =?utf-8?B?NE1VY3lJY1ZLZENDaXdINWZrNG1uOGxiRWhEb0lYUWtMaWhXdU5lb3ByZ3B1?=
 =?utf-8?B?dDJ0Q3diU2E3Zi9BeDU5MEU4SXIrM0FnaGtOMGlGclJ6WjFvcFRHek54ZnlV?=
 =?utf-8?B?OVJteElNZm5tcEhwZ0JwQThXSmxSTXFXOVRVYVdtdGVXblZjMThjb2lnRk92?=
 =?utf-8?B?VERqYWI2a0hEem83Ny9aaWlyNmE5NUFsajNEVXRoTHUzcEdBeWdEamY1V056?=
 =?utf-8?B?RVNRSkV3WUcwN0RnWHBrK1haTjc5V003Nm8veUVyemdsUmVPMEludWE3NzUw?=
 =?utf-8?B?Uy9WZEg2RjFmS2xIc3hXOWR4M2xEaFd6bXQ3anFWZWp4dm5RZmMwamQvTWFD?=
 =?utf-8?B?Ymc2SDc4OEl5NjhpU0lIZ0FueUZVbWNEa1F3bVBVaVhLaWNxNERFVk81ZmJi?=
 =?utf-8?B?TnUzeFp2M05PQUhJUEp1dkoyWXlJbFN0czFla3Q0K291UHdPYVRFUncrWUxH?=
 =?utf-8?B?dVFJRXpucSs4aEppbklWUm0wUzhJKzU5VlltVk1XcDFmcS92N1pQbXV5cTBO?=
 =?utf-8?B?QU9VanE4VkRQMHZwUFlkMnk3ZWNyLzFPOEJlVTY4dXo1UUZtR0xpNWVpTEJY?=
 =?utf-8?B?MURCcWFtTElvdTNNOGNlUTVTQVBOVmNPZTRFbHllN0d5ZGd2L0NDVko2ZXpV?=
 =?utf-8?B?eHd0T3ZCSUNLWmxhTk5IOThxaFJDek1TUzNTNytjUWhTOWF2aDBEMDBYNXFs?=
 =?utf-8?B?WkdwTmxNajNZUTdvVXovdnYwcEFFZ084T0lNVUgrN0Exck1DWmdYZ3dPaHBU?=
 =?utf-8?B?QnJiUWQ1eTExekU4NDMwL2d3anFsWW5KVTkzTU0zSitRZmsyQXRGRjFTVXF6?=
 =?utf-8?B?d2tBT1BKL3JRSTRBY1lrVmNvOHdJa3NneFJ5K1labG1oSzVYVGJhT1hLRXNr?=
 =?utf-8?B?dzN2MGh1Z3hRRjFjd3dLVlpwQjRHNW9hY2pJSTQrSWErZTA5YTBvanVvZkkv?=
 =?utf-8?B?Q2xlSGVIU3Jlbkg0SHZsUzJkek84Yys3ME1JVlVtbEZuY2FzWDZHcUIydm9p?=
 =?utf-8?B?Y0g2aFE0TVVZemFOZVFtNDdHc0MzTTM3NHZJemE4RVZPREVEOEp3T0RXOVZS?=
 =?utf-8?B?dElLZk5WUXV3Smc5bjQ4TXM3VUlNSUlpd2JjajN6dmkrVjQ0TXhPcThjRldZ?=
 =?utf-8?B?TXlENzh1eDRRcUZEaDcydkFqTi9IeEZ5YXcrTWg5aU1UcHZHNlVMUktzbFpi?=
 =?utf-8?B?RkNXb3AyR1Z5S1EvdUdPSTVxM1BUMGRrZm1UZ0hIL204a0gxTzFjbnJldGl5?=
 =?utf-8?B?eWRhOGVlaUUyWGl6SWQzZGYvdXBCQkpBYVk4dHBwa0IxM09SS0JraGlyWVZI?=
 =?utf-8?B?alk3ajdLTFg1YnJDUHJGeGxnWkwyRGNQaHVJZHhsQm9qOUZncXozdzhxcFl2?=
 =?utf-8?B?LzdNb1BsUjUzcFk2Yk4yNGdTMlE3WnUweCtOaXBDSmoyUGRjYXE0SFpmdzRG?=
 =?utf-8?B?d2dna0ZjNDdwL0thWG55cUJ6RVdNVjFSWjAxL21XVUNoeGhKTGtZSjcwUXpy?=
 =?utf-8?B?L1BvNlg2Y3c3SmZ0YnAvcjc5OWxOVTh3aGNrY3ZoMzhXd1NCWmlyOGRiWlZ3?=
 =?utf-8?B?eUhtRnNpMHBuSFBUTm51UFg0Q1dJTStBRFFhaWxLMC9PcXRlVXZSU2VkWWN6?=
 =?utf-8?Q?XdvDp6BL0w4YAAMt9nO8zcHJg?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ce0d8a-834d-472c-6496-08da9b4b2a2f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 21:00:36.0666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5kmWoW6EOwU2vZF7yBYVkDitsRLTmQEJGqA/qnxQwdnypBSFzDNiCF4kLxLH2ef
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB7147
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/20/2022 9:20 AM, Namjae Jeon wrote:
> Set only file permisson to mode for posix extension like samba.

Suggest rewording this for clarity:

  "Set file permission mode to match Samba server posix extension behavior".

Acked-by: Tom Talpey <tom@talpey.com>

> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/oplock.c  | 2 +-
>   fs/ksmbd/smb2pdu.c | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
> index c26f02086783..9bfd1ef6debd 100644
> --- a/fs/ksmbd/oplock.c
> +++ b/fs/ksmbd/oplock.c
> @@ -1640,7 +1640,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
>   
>   	buf->nlink = cpu_to_le32(inode->i_nlink);
>   	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
> -	buf->mode = cpu_to_le32(inode->i_mode);
> +	buf->mode = cpu_to_le32(inode->i_mode & 0777);
>   	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
>   		  SIDOWNER, (struct smb_sid *)&buf->SidBuffer[0]);
>   	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index bc6c7ce17ea8..5c797cc09494 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -3565,7 +3565,7 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
>   		posix_info->AllocationSize = cpu_to_le64(ksmbd_kstat->kstat->blocks << 9);
>   		posix_info->DeviceId = cpu_to_le32(ksmbd_kstat->kstat->rdev);
>   		posix_info->HardLinks = cpu_to_le32(ksmbd_kstat->kstat->nlink);
> -		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode);
> +		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode & 0777);
>   		posix_info->Inode = cpu_to_le64(ksmbd_kstat->kstat->ino);
>   		posix_info->DosAttributes =
>   			S_ISDIR(ksmbd_kstat->kstat->mode) ?
> @@ -4732,7 +4732,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
>   	file_info->EndOfFile = cpu_to_le64(inode->i_size);
>   	file_info->AllocationSize = cpu_to_le64(inode->i_blocks << 9);
>   	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
> -	file_info->Mode = cpu_to_le32(inode->i_mode);
> +	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
>   	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
>   	rsp->OutputBufferLength =
>   		cpu_to_le32(sizeof(struct smb311_posix_qinfo));
