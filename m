Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8A3EB64D9
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Jun 2023 12:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjFSMKK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Jun 2023 08:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjFSMKI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Jun 2023 08:10:08 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EF2127
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jun 2023 05:10:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDl+hFKTvws6m+s1vKtc8bdVyL2NjPEYBDqVzmOxa1UW5OGgXSTbqnzUu48s5dvlUMKgbbeBJuOLfkPboSe0qEpsCvGblKI+dKke7jIgta+5j12VbUq2pyRYe1gllMh/zbXYJgraRfil6Kd2WBaYM0isHGevhwcnEwTPSmkgj+YBFyYGFhpaKS/1JzjhyCo29ZJvqFZps7dEbX0ui946x3ZIhu6Gq5F0k8jmUCL64wIwHqgvOcvInsovQOQRO8jLmnY3wo3njjFLWyeXLmiy0tx76snOK29ZTg6c/CK+vxl8X3gvdNF8DMMGd9WqzO4rwI/EnMdrvOQR+b/2dO8qdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFBlHN4g32vQD4Kb92y3R7nX31hQtHCNa/pS9BuQ14A=;
 b=jymkNgNClFF69gJ+JkjgVhKK5X+k5Xaoo5kDgWLBSBGmhfhXMsbk3j6ZlI02/Rx0tQUYf65HbBXTi7SmOATXBV860Am6d/iYN5+TjkIkwrMh4+NDfOaAO1bUAv9wVzCSaNkheYtWaoaVkZIa1/OLjuJBmSrGw0wrEwfJrpVizBF/AK9NN/3pdhubUoId0RsU+Z0DEUS3e8VG9ici3BsCLdeLPtFVty2WsI5YDrixKAUnoPqq6fjx5OoGEL5O7crmwjTksaEgVgDkP4zY7rTZRkWaI88zAxFcq2YdV80mPOLlUjcurcyE33rF0onwkncNuSRAP5e1bFkLciF1vrHneg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DS7PR01MB7760.prod.exchangelabs.com (2603:10b6:8:7f::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.36; Mon, 19 Jun 2023 12:10:02 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6500.031; Mon, 19 Jun 2023
 12:10:01 +0000
Message-ID: <5a83a490-dc32-901c-5ea5-85458f815e0d@talpey.com>
Date:   Mon, 19 Jun 2023 08:10:01 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] SMB3: Do not send lease break acknowledgment if all file
 handles have been closed
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>
Cc:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, linux-cifs@vger.kernel.org,
        bharathsm@microsoft.com, nspmangalore@gmail.com
References: <20230619033436.808928-1-bharathsm@microsoft.com>
 <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0109.namprd02.prod.outlook.com
 (2603:10b6:208:35::14) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DS7PR01MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: be401448-9e46-4a6e-1ab5-08db70be1b08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TOgIQLlJhLJhlwgxUdMuH66oCoJhvpwP7qqhE6Z7w27ukSS7zw1E0c3+qR1jO4o1QndVhYjgw5axKLBKbx1a5by/ower47TrkX4h2TqNlG1xd3+1sUquJB4+2rr5tfSU1LtV2mzFT0Npf270IRZBcEMu8pm/3iUiZ2POs7i9ZrojkEmMqhQ/OiADC5MWv6HDqe5Qx6v3Yz2q9fh6U+0/ZZqNPNYx0kVqXs4fq1NcfLOCah8q9PuNfutDBvrb+YuGotqNmGUZfGC9X0osIkxD6CrPVGeqPRTRaDSS+CnD5dPDjpl3ODhhN6MHZM+YPRKyeSl1pX5gX/+WmDsLe3bXji7GEgn6K2wgfO/gWB9jBe6eM22eBuayxa8jeMY+JIVHKpEeRP9OPD6eEdHpWzxoDUE3FIdRgR0aac2/7IJJSqxVNHEgUa3lyolCXf7vSOAy+yOCKpkpsvyaMDmo5KKRZxiE3AL2XSRJXPg2qMewfXxwZX9R27wShPjevlRoheb9saKoiuxH3BS7/wHluRXCJ/HUydJhkAzXx9pfPaQSNchWatHX4c4Wobpankd45QkVWCdUn/kFxg/pLcDV/EddVdfA+tYweWJ0u0uJLJMj8KwK73XP5SDtnIXno8U79r5v06Y/d9Yq8EneN4M7IzPdCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(396003)(39830400003)(376002)(451199021)(186003)(26005)(6512007)(53546011)(6506007)(2616005)(83380400001)(38350700002)(38100700002)(478600001)(45080400002)(4326008)(41300700001)(66556008)(66476007)(31686004)(66946007)(8676002)(36756003)(316002)(8936002)(110136005)(52116002)(6486002)(31696002)(86362001)(2906002)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFN1QlIrSWRzdzF1YzU1a084MHA2Z3dVQWtUY2UySE0xU0poTUR6bTZIblVq?=
 =?utf-8?B?dlpBenMva2o4eHZLYUhneVo3SGZROHdqQkVydnNmYW1VdzcxOUlITlI5RGNo?=
 =?utf-8?B?dGwwdGZmVjRyd2FtSnpQYmQ1VmZqUG9RYWpRN0IvUTA4cDN0ZW9KTldyeVdi?=
 =?utf-8?B?UW5PZnhVWTArdEk1aFRWVzlYRWxyZTNjc3poaEEyejQzbHZYaVVPM2NZZml6?=
 =?utf-8?B?SzFYaGpxRnhWandHaCt4a1ltZlpmbWROK0pjQlZ0SXlNaWdUL29OTUJkNnBm?=
 =?utf-8?B?ZWJGS2tVQ2xzWGNxWVk3OHE1bUdoaFRoanplL2ZGbFByTzJ6ZWZyL1V1d29h?=
 =?utf-8?B?dURETDMvMTV1TzF6UUhCaGlXa0ErS1N5Y3hkSkpvdFgvdVIyQmI0dUhoVHBk?=
 =?utf-8?B?NGZtMlpBbFhzZVVBRUVSUzNxUUVVTzBXM1FOeldocEFSaHc3RWE1YzRtb3pa?=
 =?utf-8?B?TTVDaVA2TDlVaU1oZERjMWUzY0FQNGRnN0VPclRyWUphOS96ZVk2bWt3Y1V6?=
 =?utf-8?B?ek8zU01HQUJWR01LYWp1WE1sM0htclNhS2RqZm5PSVJMMkJBTVF5RmVYR2NI?=
 =?utf-8?B?dEVBT3ZCMGpHKzRkQWxxUjBCYXdTMG5CdGZiSkVBK0Z2U082UGQxMnY4Yzl3?=
 =?utf-8?B?dHJMbVU4U2pGU3Z6V2RGQUxCd0p3MkZQaE03VG53Yi9ENEh0NExDTlBvWHVY?=
 =?utf-8?B?b2c3Tno0Um1xblFJZkRzNitFOWNDK1o4ZFVFMGNNZ2hCMjBjUFFiUTV2T2t4?=
 =?utf-8?B?NDRkbkFKR0Rza2lENlJUdFQvaDhiamFjcVU4RWVrVzNIam1uQmJjQjVwa2VT?=
 =?utf-8?B?YmZOWnhSUEhhMUJtR3JQc2JFOVF6Z29pMFNJTDF4SmZ0QjF4RHZCY0Fzbk1x?=
 =?utf-8?B?UFJEZCtPbDR6enl0ak1jOFg1cEtDNDZTV1Ayd01hNkJMQ1VTS3J4K2NQSkxZ?=
 =?utf-8?B?M0lZTFI2a2NIUXlGWmRpZWZsR3p4Y0ZZV2RSL2xWSmYvN3hLZU90cStBeDQ4?=
 =?utf-8?B?YnozZm84UEovKzJKYVRnbmw1elN6NjhoY1RFa251Z3VVajRlSkVJYnoxeGhy?=
 =?utf-8?B?a0EzZmRnSjc3UkJUN291Y1h4NEpwRW1uckh4NXY0a2JxbWRXT2ZVNE05ODBM?=
 =?utf-8?B?RGVsZTJjMk02SjNvQUZaWHMzZFVKRFdDNm5DQTc2NGNGS3gyM3RuNjRBYi9E?=
 =?utf-8?B?dXlwVXJRNHZ6NmpvZEhxVTA0Q0J3b0hZQk56b1FDc05DZTQzelQvRVdIRWM1?=
 =?utf-8?B?U2lqcWJuR3JEclVvRTd5RVdyN2NDanVmUXpTWXZNTWJvKzB1UHRqVmdOSTBp?=
 =?utf-8?B?dFUwMUh5QVd4R0phbWV4ZktrQjNSMW5OdTljemoweXNkQzE3UlU1dXp6bWxh?=
 =?utf-8?B?VTYxWC9EcjBXL2x2WTRlVnpxOWo1UERCMWFrWXJWTzZoMnFZc2MyVTgyYmxk?=
 =?utf-8?B?REJzZ1BoQVhUd1ZCUWM4Ym5iRnJId2dzN3J2ZTZQaXc3d2R4Z1VLMjl6RDVa?=
 =?utf-8?B?QmtvR3BzalFyNExITzRUSVBHOHpvUUlNcUxBNWdPMURBYlcrN29uSDlTY0dK?=
 =?utf-8?B?K3k1WGFZNFNiTzdKMzV6VUpDank4YmZDNlMrcmQ3Zm5mdWU5Z0JMM3dsK3pu?=
 =?utf-8?B?TnUwQzVRRzlGS05pKzFYOXdONjRWbEw0VEJQZlo3NG05SmJsc3hRL2h3Rjhk?=
 =?utf-8?B?dWpuRG1NK3UxYlFZcDlsQjhWd1djczhsTDUxNEVTajY2MDg4SHdoSVZSUm5Y?=
 =?utf-8?B?THVhSndFaW1xN0N2dlFhbGxxWG1vWU9ZcjBCZ3N5NVRhd0ljeVZiNlREMXN5?=
 =?utf-8?B?ejViU1pOR0tTOTJVblBpVEtoZ0Rsblpja29sUWRqcWYrR2FySUQycGhzRUdu?=
 =?utf-8?B?MGtnd3BuTi9UemdremlUK0NUeGNheGlLY1ppNlNLSklNOWJ6VDl4RmZhaFFu?=
 =?utf-8?B?LzNsTDl4eHN0Yzdac0hYZTJqL0g2L3ltSU1LMUlnU0Z3eCtXSVNwSnQwWTVx?=
 =?utf-8?B?MHkrOG5ZMjljWHZ6eC82WjM5UzUvK1FOQi8yMUJHNmlOL21wWS8zYkx4Slkx?=
 =?utf-8?B?NnFKVXVNUzA4YzdMMEp4ZlFlbWdHd3JsTFlmQlFTOCtqdlQ0M2ZQS0xqUzlI?=
 =?utf-8?Q?O1o4pyDmBSfOQCZX9bTv8D0rw?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be401448-9e46-4a6e-1ab5-08db70be1b08
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 12:10:00.9248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gt/nNNouv+yXt3zdn/4REyPiwmwGNI/7VaCdPhPL+OqA3nkFrmrmI77KmmS7JgWy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR01MB7760
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/19/2023 12:54 AM, Steve French wrote:
> tentatively merged into cifs-2.6.git for-next pending more testing
> 
> On Sun, Jun 18, 2023 at 10:57 PM Bharath SM <bharathsm.hsk@gmail.com> wrote:
>>
>> In case if all existing file handles are deferred handles and if all of
>> them gets closed due to handle lease break then we dont need to send
>> lease break acknowledgment to server, because last handle close will be
>> considered as lease break ack.
>> After closing deferred handels, we check for openfile list of inode,
>> if its empty then we skip sending lease break ack.
>>
>> Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending oplock break")
>> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>> ---
>>   fs/smb/client/file.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>> index 051283386e22..b8a3d60e7ac4 100644
>> --- a/fs/smb/client/file.c
>> +++ b/fs/smb/client/file.c
>> @@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct *work)
>>           * not bother sending an oplock release if session to server still is
>>           * disconnected since oplock already released by the server
>>           */

The comment just above is a woefully incorrect SMB1 artifact, and
it's even worse now.

Here's what it currently says:

> 	/*
> 	 * releasing stale oplock after recent reconnect of smb session using
> 	 * a now incorrect file handle is not a data integrity issue but do
> 	 * not bother sending an oplock release if session to server still is
> 	 * disconnected since oplock already released by the server
> 	 */

One option is deleting it entirely, but I suggest:

"MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not require
  an acknowledgement to be sent when the file has already been closed."

>> -       if (!oplock_break_cancelled) {
>> +       spin_lock(&cinode->open_file_lock);
>> +       if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)) {
>> +               spin_unlock(&cinode->open_file_lock);
>>                  /* check for server null since can race with kill_sb calling tree disconnect */
>>                  if (tcon->ses && tcon->ses->server) {
>>                          rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
>> @@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct *work)
>>                          cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
>>                  } else
>>                          pr_warn_once("lease break not sent for unmounted share\n");

Also, I think this warning is entirely pointless, in addition to
being similarly incorrect post-SMB1. Delete it. You will be able
to refactor the if/else branches more clearly in this case too.

With those changes considered,
Reviewed-by: Tom Talpey <tom@talpey.com>

Tom.

>> -       }
>> +       } else
>> +               spin_unlock(&cinode->open_file_lock);
>>
>>          cifs_done_oplock_break(cinode);
>>   }
>> --
>> 2.34.1
>>
> 
> 
