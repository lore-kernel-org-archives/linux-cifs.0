Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B313C25B08
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Aug 2022 21:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241707AbiHQVLG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Aug 2022 17:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241740AbiHQVLF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Aug 2022 17:11:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DEBAB4E6
        for <linux-cifs@vger.kernel.org>; Wed, 17 Aug 2022 14:10:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JB3seNQLaBHf4QLLRkIKoAkreFYFzBD4E1bdM0y6kHoUN/w+MqRY9schOzQQVhCGWmHEembrufF5F5RgUZsK/KLejkXiKRSbSyzTBBlzHDBnUICetJUN4KjZy6+8Vh3Mc1rLnoZ8kIlHkuoLkX5TQxewioGMdGYaxEBHGaNCApAsCndBzmynTDn/T8iZD8Ykh8ovjCzlq4onoVljheVikSaEANsjU/g4SioXRltq3s1ZLFQA7h9yhIbxdChD4pJRZ83iI7cXaSxD/JqSvSpgtnjjLsTsxiDNniFi/ipF2IclUm7alkAjDFR3DIqNtXUa45RO+fGZv/PmCsiRZ7LANw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2B792umrpNu9gKQDKL3qVHrIx9vVcSq61eG3qTWEMUE=;
 b=h7gvYYAx/Z/I4Pk3TzX3w7hojwBP4a/S3rx1HplcTNP7XCG5qVxAgk/EHTvh+1qC/wJ+daoyeKbFkPPtYK7G+zKwsjYkKf9bHZp/xgifd9sgv748svCSrw7BI0P++moA/HymX1YW6EBS0oHS0k2BaBm3O7I1GatOCbJXoUYup6DIC8mx6RFU13qHSnYWMtk136UqkbW0crgt8OOs40GZByO3pVC+RBrOdS8RLgF4ObvxGl3MZdFsaT44aWZ3ag0gvQ39Slx8nDWJzdq9T3UXjGIRLgzgul8QDAtXaG2IKNAq7aOUyzrexd45X3sbqbbDviRt3qipDtOEltPg7nR5UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CY4PR01MB2806.prod.exchangelabs.com (2603:10b6:903:eb::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.17; Wed, 17 Aug 2022 21:10:57 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5504.028; Wed, 17 Aug 2022
 21:10:57 +0000
Message-ID: <d9e8a34e-a4a6-2088-1a6d-afda0b64fafb@talpey.com>
Date:   Wed, 17 Aug 2022 17:10:57 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH] cifs: remove useless parameter 'is_fsctl' from
 SMB2_ioctl()
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
References: <20220817190834.15137-1-ematsumiya@suse.de>
 <CAH2r5mvjeBo7pDVyrD5Hqu5=2L-f8DD=j2-r2iPRPeC8PoR2JA@mail.gmail.com>
 <20220817195916.gkmc4dera3syo5nh@cyberdelia>
 <CAH2r5mvR0ciqQ4WY=cfXkF+bpymZcWLApc=dDhF4WNFhZfr_gw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mvR0ciqQ4WY=cfXkF+bpymZcWLApc=dDhF4WNFhZfr_gw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0084.namprd02.prod.outlook.com
 (2603:10b6:208:51::25) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 044bc9a9-499e-4992-59ae-08da8094faa7
X-MS-TrafficTypeDiagnostic: CY4PR01MB2806:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5r0duZgkk8YWAVguNk5L876SoenGlNwKYdbXFmNdrE3HohsFakU49ZzDAVVlC/QGHgl5Q1BGTGP30QuEEE6h0t7RtSGNFlwwb2Nt2nrkR3e1l6TgQQyy69CUHqoFXUDQpuZRYJ+MIBn683JO2zPq0w+32SQ7HBiAt57pAfSK6b++qRSKThQw+A3bZume3AD9H1eKf6BHdwWHgzRhDNzIMJsIT4CRXVfC8a8CGz35GtO/BsIbbhmzMyHOcHQMqvZCpHW/Ii506XmYRs1KxdQ1qazUG05X+GnfLTX1nBC0NQ7wTLAjcoFIb7PsrccNLGofJZo9d8YDpC76B46gxNVnzkjUCCwnBvdLs0h2ydm9MgSDpioF0vnS5ZMM8R78EUwS2AANfbmCbuAWPqsiDrEc85oTDw3K+dWI8PUkad6BADxrbbHLNQfIXPz+ZWRK51uMHOq9uNlD6gEzayM0q/tO26DxXV38eTXUuSU09IiuQ00LPDFIEIGI7eawOnt/UHv6Yv0KNKkDYhg6adGh4k9GAmdVjWjp28b0Hl/KCFpf6LzRD0v1hXMyMofV80WROvSWgy3V7U2hZ6JTAsgisvm388zSKwynZFS2f2peQKsgbvxMGadfr4ZyVaGqI48RgYAoH8zW5R2QQ6HziOWOi8wtjmirmC38KNqBtgdgEGr9mpDdFJl9xAcbWqfLe9g5yoEv+y7R2X7xfUPVCbB30nzvrfP1s1adY+/5R0Qnxn2rrbWPymPhhLqjSb7iHjb8nSw25x1IcvqxaL5uuNbLs6u52HHaPfhLgxGHLLHRyPNwPT0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39830400003)(376002)(366004)(346002)(136003)(2906002)(30864003)(5660300002)(31696002)(86362001)(26005)(6512007)(53546011)(6506007)(2616005)(52116002)(478600001)(6486002)(41300700001)(83380400001)(186003)(4326008)(66556008)(66476007)(66946007)(8676002)(38100700002)(38350700002)(8936002)(110136005)(54906003)(316002)(36756003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QStBS2hhZTlKc2ZNZzJXMEFqRHJnaDhrRTZmQmMxeEFGSmtxVGFaS2pQMHVq?=
 =?utf-8?B?ZFo1QmF0MHQ0cmcrVmwzWFlhM25HTFdBTlZuSDRjRFR1Z3A3SzBwNEZqc0Zh?=
 =?utf-8?B?Ryt2dlNYU01TM1lNRTJqZ0NEYjg3WHkzcHpOSnI5YUFrbVVhc0RSMGtyMUVS?=
 =?utf-8?B?UlkxeVBGL2MrNlYva1hjVFNJTWV5QUhwRDgvbUVkcEFFd1FZZURpVjErN0Nx?=
 =?utf-8?B?emdpekZWU1NTamUyRHA1c01scFdWVFNRK2ZoN1Z3RTc3Wml0WUc0bVp6SVUv?=
 =?utf-8?B?SURiTXpyTWdCK253eUpaWFVmTTROUll6eUFwWFNxZUpOTndlSjNUaEJBeDFE?=
 =?utf-8?B?cGJIRTlyOUZYNmZ0TTl1Ni9KUGpSQ2JncmlCM2daOVlEYjkwM3E5V3plNDRo?=
 =?utf-8?B?MzBCeU4vZHZ0bitmUGxOYlJXTHEybEhYYi9RbS91dk9wS1VQOTVmVTVkNzY2?=
 =?utf-8?B?RTJEVHNaTnpUcXpYcy9MTngrRmNoNU02WXZwU09mcGhycjdhcWNIMHJaZkFo?=
 =?utf-8?B?UkVFeGpiNlZab0xSVXN1cEZNL2RVcmhvTWV6ZmRENm1TL3lvaFhrNzU2YmFM?=
 =?utf-8?B?RnAvZytBcXRnbWUxSUxoeDlnaHZBbit6OS9uSEt6cUNaTE9hNURSN3BDT2ty?=
 =?utf-8?B?Zm1ialdJbkFvMlN2M3hRSHI3NUxpVmdtVi8yL1BST29aUVJoYWxLa0R0REhT?=
 =?utf-8?B?cFRVMkhGQWw4ZWpQekptTHdzUVF2OUE4eHlGWUVwdkxGTjRWdUJ0dm9PdDRT?=
 =?utf-8?B?Zm1rK2lLUTdySGxONGMreFNuWTNiMXFWMUhaOEcxbUZma3dmY1Q0YkV6R3NP?=
 =?utf-8?B?VjBQeWNJaURxWk1QdXExTzZ3WjNBdmZHSE9zbDl5eXhaLzAwNTYvdWZwUnlB?=
 =?utf-8?B?TjdCeC9wazZlQ1VZazdlY2hTekdHL2FuTk5FYmJDL3pVZE9KdjFDTFJWaXFj?=
 =?utf-8?B?WUp4WHpXdzhNUjh1WjgxZGFhQUdvdVV2MEU5WnByVWdUdHF2RnE4a3lhTTJr?=
 =?utf-8?B?K09rRXF1N0lOK2Y5UTI3UkswMnNmQVA2TmZDcFNVNzNVcGdURDJLams3VHZU?=
 =?utf-8?B?TkdvZTUza0ZRZ1ZsUStDOUJMRWcxTVh4VXhmcmRFbW4ySGJpRUp3Z2c1UnN6?=
 =?utf-8?B?bVZoYndwSzVuZFhySkMrRXJjUE80cFc2a2VscGJHckY5T1dWZXAwM29Pclhj?=
 =?utf-8?B?aFVmRHFjSXFsaStqSmtzK29CTTdiN1AxUlpVTllvWW1nN05aamNrWTcwcDdh?=
 =?utf-8?B?dFJvT1ZXcFQwRDkrdmYxQ1l5amk5WjRMU3IxTklwa1YxQnB1N0lVbkxVQ0o4?=
 =?utf-8?B?a3hkd2MrSWFDL2ZGU2VscTJTQlRFWTkzNllINEFDSTBGRXBOT2M4aHMwRUQz?=
 =?utf-8?B?TjVLR3FyeUt2TTRESUV2cFQxU2d6cHNxaDdPTklvY2h5NElWcG1ScXAwZlp0?=
 =?utf-8?B?YXAwU2JrdGY1YXpKMDdIaWo5RzFPUzgyd3JkVUxFVGo2a3lvdnlmN1VUZzJx?=
 =?utf-8?B?aXI5YlA3K1BpdHBUSlNRVzNRK05LMU95dEcrSlhzZkJxekg2RVhaZzNHemha?=
 =?utf-8?B?NEg2ZWhHYjduZUZQdGFHN3B6RkVOVC83MVZaSXVJRU1VZnBMeFNnUkU4czJp?=
 =?utf-8?B?L2ZQTVJHNlNjSzhaTEV2bXpiY1hLcStxSW5TZi9ISGZnVi9ONmlkNTMvelZU?=
 =?utf-8?B?U2sxS3A3cHhSaEREVmViMEd1V0JqQzhqTEVPN0U5emJaRVowbXlxZnB4UUt0?=
 =?utf-8?B?emE0MTdvZW84eXBPSjVMditrSndCclRIRmhpaFJQVklyUFFoNDdLMGt4ZldL?=
 =?utf-8?B?aDlFYnhidVNxQzU4ODI4UU8vQjZvRVRDVEpxcG1NeFhDL3BmcHE0L2twMjFr?=
 =?utf-8?B?TnRaMGpMRXd4ejBaVVpDemZhd25ZdVBVSTRuMWFoaUo4OVV1TDJEdlZsRjNy?=
 =?utf-8?B?bUFKbzdzc3RNZ2s2ZXhRUlh4U0lwdVo4cW16c1VsTEZOZmZhZFBGSzAzOFN4?=
 =?utf-8?B?TFRvY1A3NElsNzhLNStvR2ErbzdmU0tEZkl1ekVHMnBhSmtqMzBPaG9JeFgy?=
 =?utf-8?B?T1k1M3Rjb1BKNzA3KzlVMG5rS0JCdU9ocUVqcDQ0RVZzNGUzR2U5eUZJc2ZJ?=
 =?utf-8?Q?9pRA=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 044bc9a9-499e-4992-59ae-08da8094faa7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 21:10:57.6383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/wreOqEmdnUCtuoBgSP3PiBfJfhPflKLWeZawBZC8QDzqtqfFCdY2K9MEHLV9BB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR01MB2806
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Sending that bit violates the protocol. So if you are keeping
it in reserve, what protocol extension will use it? And, will
it be documented like MS-SMB2??

I'm with Enzo IOW.

Tom.

On 8/17/2022 4:14 PM, Steve French wrote:
> Let's think about this one more, maybe try some experiments at the
> upcoming plugfest with other servers.
> 
> There is a small possibility that there may be debug workloads that
> supported this on some servers, and no hurry to remove this parm.
> 
> On Wed, Aug 17, 2022 at 2:59 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>
>> On 08/17, Steve French wrote:
>>> One alternative would be to allow the user space "pass through ioctl"
>>> to set this flag to false (in case there were cases where a server did
>>> support it and a test program or userspace utility needs to set it).
>>
>> I don't really see the point of having so.
>>
>>> Do both Samba and ksmbd always reject it if isFsctl is false?
>>
>> Yes.
>>
>> For reference, Samba in smbd_smb2_request_ioctl_done() (source3/smbd/smb2_ioctl.c):
>>
>> 7599         if (req->Flags != cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL)) {
>> 7600                 rsp->hdr.Status = STATUS_NOT_SUPPORTED;
>> 7601                 goto out;
>> 7602         }
>>
>> and in ksmbd smb2_ioctl() (fs/ksmbd/smb2pdu.c):
>>
>> 7599         if (req->Flags != cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL)) {
>> 7600                 rsp->hdr.Status = STATUS_NOT_SUPPORTED;
>> 7601                 goto out;
>> 7602         }
>>
>>
>> Cheers,
>>
>> Enzo
>>
>>> On Wed, Aug 17, 2022 at 2:08 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>>>
>>>> SMB2_ioctl() is always called with is_fsctl = true, so doesn't make any
>>>> sense to have it at all.
>>>>
>>>> Thus, always set SMB2_0_IOCTL_IS_FSCTL flag on the request.
>>>>
>>>> Also, as per MS-SMB2 3.3.5.15 "Receiving an SMB2 IOCTL Request", servers
>>>> must fail the request if the request flags is zero anyway.
>>>>
>>>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>>> ---
>>>>   fs/cifs/smb2file.c  |  1 -
>>>>   fs/cifs/smb2ops.c   | 35 +++++++++++++----------------------
>>>>   fs/cifs/smb2pdu.c   | 20 +++++++++-----------
>>>>   fs/cifs/smb2proto.h |  4 ++--
>>>>   4 files changed, 24 insertions(+), 36 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
>>>> index f5dcc4940b6d..9dfd2dd612c2 100644
>>>> --- a/fs/cifs/smb2file.c
>>>> +++ b/fs/cifs/smb2file.c
>>>> @@ -61,7 +61,6 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
>>>>                  nr_ioctl_req.Reserved = 0;
>>>>                  rc = SMB2_ioctl(xid, oparms->tcon, fid->persistent_fid,
>>>>                          fid->volatile_fid, FSCTL_LMR_REQUEST_RESILIENCY,
>>>> -                       true /* is_fsctl */,
>>>>                          (char *)&nr_ioctl_req, sizeof(nr_ioctl_req),
>>>>                          CIFSMaxBufSize, NULL, NULL /* no return info */);
>>>>                  if (rc == -EOPNOTSUPP) {
>>>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>>>> index f406af596887..c8ada000de7f 100644
>>>> --- a/fs/cifs/smb2ops.c
>>>> +++ b/fs/cifs/smb2ops.c
>>>> @@ -681,7 +681,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
>>>>          struct cifs_ses *ses = tcon->ses;
>>>>
>>>>          rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>>>> -                       FSCTL_QUERY_NETWORK_INTERFACE_INFO, true /* is_fsctl */,
>>>> +                       FSCTL_QUERY_NETWORK_INTERFACE_INFO,
>>>>                          NULL /* no data input */, 0 /* no data input */,
>>>>                          CIFSMaxBufSize, (char **)&out_buf, &ret_data_len);
>>>>          if (rc == -EOPNOTSUPP) {
>>>> @@ -1323,9 +1323,8 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
>>>>          struct resume_key_req *res_key;
>>>>
>>>>          rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
>>>> -                       FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
>>>> -                       NULL, 0 /* no input */, CIFSMaxBufSize,
>>>> -                       (char **)&res_key, &ret_data_len);
>>>> +                       FSCTL_SRV_REQUEST_RESUME_KEY, NULL, 0 /* no input */,
>>>> +                       CIFSMaxBufSize, (char **)&res_key, &ret_data_len);
>>>>
>>>>          if (rc == -EOPNOTSUPP) {
>>>>                  pr_warn_once("Server share %s does not support copy range\n", tcon->treeName);
>>>> @@ -1467,7 +1466,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>>>>                  rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
>>>>
>>>>                  rc = SMB2_ioctl_init(tcon, server, &rqst[1], COMPOUND_FID, COMPOUND_FID,
>>>> -                                    qi.info_type, true, buffer, qi.output_buffer_length,
>>>> +                                    qi.info_type, buffer, qi.output_buffer_length,
>>>>                                       CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
>>>>                                       MAX_SMB2_CLOSE_RESPONSE_SIZE);
>>>>                  free_req1_func = SMB2_ioctl_free;
>>>> @@ -1643,9 +1642,8 @@ smb2_copychunk_range(const unsigned int xid,
>>>>                  retbuf = NULL;
>>>>                  rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>>>>                          trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
>>>> -                       true /* is_fsctl */, (char *)pcchunk,
>>>> -                       sizeof(struct copychunk_ioctl), CIFSMaxBufSize,
>>>> -                       (char **)&retbuf, &ret_data_len);
>>>> +                       (char *)pcchunk, sizeof(struct copychunk_ioctl),
>>>> +                       CIFSMaxBufSize, (char **)&retbuf, &ret_data_len);
>>>>                  if (rc == 0) {
>>>>                          if (ret_data_len !=
>>>>                                          sizeof(struct copychunk_ioctl_rsp)) {
>>>> @@ -1805,7 +1803,6 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
>>>>
>>>>          rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>>>>                          cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
>>>> -                       true /* is_fctl */,
>>>>                          &setsparse, 1, CIFSMaxBufSize, NULL, NULL);
>>>>          if (rc) {
>>>>                  tcon->broken_sparse_sup = true;
>>>> @@ -1888,7 +1885,6 @@ smb2_duplicate_extents(const unsigned int xid,
>>>>          rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>>>>                          trgtfile->fid.volatile_fid,
>>>>                          FSCTL_DUPLICATE_EXTENTS_TO_FILE,
>>>> -                       true /* is_fsctl */,
>>>>                          (char *)&dup_ext_buf,
>>>>                          sizeof(struct duplicate_extents_to_file),
>>>>                          CIFSMaxBufSize, NULL,
>>>> @@ -1923,7 +1919,6 @@ smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
>>>>          return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>>>>                          cfile->fid.volatile_fid,
>>>>                          FSCTL_SET_INTEGRITY_INFORMATION,
>>>> -                       true /* is_fsctl */,
>>>>                          (char *)&integr_info,
>>>>                          sizeof(struct fsctl_set_integrity_information_req),
>>>>                          CIFSMaxBufSize, NULL,
>>>> @@ -1976,7 +1971,6 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
>>>>          rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>>>>                          cfile->fid.volatile_fid,
>>>>                          FSCTL_SRV_ENUMERATE_SNAPSHOTS,
>>>> -                       true /* is_fsctl */,
>>>>                          NULL, 0 /* no input data */, max_response_size,
>>>>                          (char **)&retbuf,
>>>>                          &ret_data_len);
>>>> @@ -2699,7 +2693,6 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
>>>>          do {
>>>>                  rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>>>>                                  FSCTL_DFS_GET_REFERRALS,
>>>> -                               true /* is_fsctl */,
>>>>                                  (char *)dfs_req, dfs_req_size, CIFSMaxBufSize,
>>>>                                  (char **)&dfs_rsp, &dfs_rsp_size);
>>>>                  if (!is_retryable_error(rc))
>>>> @@ -2906,8 +2899,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>>>>
>>>>          rc = SMB2_ioctl_init(tcon, server,
>>>>                               &rqst[1], fid.persistent_fid,
>>>> -                            fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
>>>> -                            true /* is_fctl */, NULL, 0,
>>>> +                            fid.volatile_fid, FSCTL_GET_REPARSE_POINT, NULL, 0,
>>>>                               CIFSMaxBufSize -
>>>>                               MAX_SMB2_CREATE_RESPONSE_SIZE -
>>>>                               MAX_SMB2_CLOSE_RESPONSE_SIZE);
>>>> @@ -3087,8 +3079,7 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
>>>>
>>>>          rc = SMB2_ioctl_init(tcon, server,
>>>>                               &rqst[1], COMPOUND_FID,
>>>> -                            COMPOUND_FID, FSCTL_GET_REPARSE_POINT,
>>>> -                            true /* is_fctl */, NULL, 0,
>>>> +                            COMPOUND_FID, FSCTL_GET_REPARSE_POINT, NULL, 0,
>>>>                               CIFSMaxBufSize -
>>>>                               MAX_SMB2_CREATE_RESPONSE_SIZE -
>>>>                               MAX_SMB2_CLOSE_RESPONSE_SIZE);
>>>> @@ -3358,7 +3349,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>>>>          fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
>>>>
>>>>          rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>>>> -                       cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, true,
>>>> +                       cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
>>>>                          (char *)&fsctl_buf,
>>>>                          sizeof(struct file_zero_data_information),
>>>>                          0, NULL, NULL);
>>>> @@ -3421,7 +3412,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
>>>>
>>>>          rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>>>>                          cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
>>>> -                       true /* is_fctl */, (char *)&fsctl_buf,
>>>> +                       (char *)&fsctl_buf,
>>>>                          sizeof(struct file_zero_data_information),
>>>>                          CIFSMaxBufSize, NULL, NULL);
>>>>          free_xid(xid);
>>>> @@ -3481,7 +3472,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
>>>>          in_data.length = cpu_to_le64(len);
>>>>          rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>>>>                          cfile->fid.volatile_fid,
>>>> -                       FSCTL_QUERY_ALLOCATED_RANGES, true,
>>>> +                       FSCTL_QUERY_ALLOCATED_RANGES,
>>>>                          (char *)&in_data, sizeof(in_data),
>>>>                          1024 * sizeof(struct file_allocated_range_buffer),
>>>>                          (char **)&out_data, &out_data_len);
>>>> @@ -3802,7 +3793,7 @@ static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offs
>>>>
>>>>          rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>>>>                          cfile->fid.volatile_fid,
>>>> -                       FSCTL_QUERY_ALLOCATED_RANGES, true,
>>>> +                       FSCTL_QUERY_ALLOCATED_RANGES,
>>>>                          (char *)&in_data, sizeof(in_data),
>>>>                          sizeof(struct file_allocated_range_buffer),
>>>>                          (char **)&out_data, &out_data_len);
>>>> @@ -3862,7 +3853,7 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
>>>>
>>>>          rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>>>>                          cfile->fid.volatile_fid,
>>>> -                       FSCTL_QUERY_ALLOCATED_RANGES, true,
>>>> +                       FSCTL_QUERY_ALLOCATED_RANGES,
>>>>                          (char *)&in_data, sizeof(in_data),
>>>>                          1024 * sizeof(struct file_allocated_range_buffer),
>>>>                          (char **)&out_data, &out_data_len);
>>>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>>>> index 9b31ea946d45..918152fb8582 100644
>>>> --- a/fs/cifs/smb2pdu.c
>>>> +++ b/fs/cifs/smb2pdu.c
>>>> @@ -1173,7 +1173,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>>>>          }
>>>>
>>>>          rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>>>> -               FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
>>>> +               FSCTL_VALIDATE_NEGOTIATE_INFO,
>>>>                  (char *)pneg_inbuf, inbuflen, CIFSMaxBufSize,
>>>>                  (char **)&pneg_rsp, &rsplen);
>>>>          if (rc == -EOPNOTSUPP) {
>>>> @@ -3056,7 +3056,7 @@ int
>>>>   SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
>>>>                  struct smb_rqst *rqst,
>>>>                  u64 persistent_fid, u64 volatile_fid, u32 opcode,
>>>> -               bool is_fsctl, char *in_data, u32 indatalen,
>>>> +               char *in_data, u32 indatalen,
>>>>                  __u32 max_response_size)
>>>>   {
>>>>          struct smb2_ioctl_req *req;
>>>> @@ -3131,10 +3131,8 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
>>>>          req->hdr.CreditCharge =
>>>>                  cpu_to_le16(DIV_ROUND_UP(max(indatalen, max_response_size),
>>>>                                           SMB2_MAX_BUFFER_SIZE));
>>>> -       if (is_fsctl)
>>>> -               req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
>>>> -       else
>>>> -               req->Flags = 0;
>>>> +       /* always an FSCTL (for now) */
>>>> +       req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
>>>>
>>>>          /* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
>>>>          if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
>>>> @@ -3161,9 +3159,9 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
>>>>    */
>>>>   int
>>>>   SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>>>> -          u64 volatile_fid, u32 opcode, bool is_fsctl,
>>>> -          char *in_data, u32 indatalen, u32 max_out_data_len,
>>>> -          char **out_data, u32 *plen /* returned data len */)
>>>> +          u64 volatile_fid, u32 opcode, char *in_data, u32 indatalen,
>>>> +          u32 max_out_data_len, char **out_data,
>>>> +          u32 *plen /* returned data len */)
>>>>   {
>>>>          struct smb_rqst rqst;
>>>>          struct smb2_ioctl_rsp *rsp = NULL;
>>>> @@ -3205,7 +3203,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>>>>
>>>>          rc = SMB2_ioctl_init(tcon, server,
>>>>                               &rqst, persistent_fid, volatile_fid, opcode,
>>>> -                            is_fsctl, in_data, indatalen, max_out_data_len);
>>>> +                            in_data, indatalen, max_out_data_len);
>>>>          if (rc)
>>>>                  goto ioctl_exit;
>>>>
>>>> @@ -3297,7 +3295,7 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
>>>>                          cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
>>>>
>>>>          rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
>>>> -                       FSCTL_SET_COMPRESSION, true /* is_fsctl */,
>>>> +                       FSCTL_SET_COMPRESSION,
>>>>                          (char *)&fsctl_input /* data input */,
>>>>                          2 /* in data len */, CIFSMaxBufSize /* max out data */,
>>>>                          &ret_data /* out data */, NULL);
>>>> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
>>>> index 51c5bf4a338a..7001317de9dc 100644
>>>> --- a/fs/cifs/smb2proto.h
>>>> +++ b/fs/cifs/smb2proto.h
>>>> @@ -137,13 +137,13 @@ extern int SMB2_open_init(struct cifs_tcon *tcon,
>>>>   extern void SMB2_open_free(struct smb_rqst *rqst);
>>>>   extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
>>>>                       u64 persistent_fid, u64 volatile_fid, u32 opcode,
>>>> -                    bool is_fsctl, char *in_data, u32 indatalen, u32 maxoutlen,
>>>> +                    char *in_data, u32 indatalen, u32 maxoutlen,
>>>>                       char **out_data, u32 *plen /* returned data len */);
>>>>   extern int SMB2_ioctl_init(struct cifs_tcon *tcon,
>>>>                             struct TCP_Server_Info *server,
>>>>                             struct smb_rqst *rqst,
>>>>                             u64 persistent_fid, u64 volatile_fid, u32 opcode,
>>>> -                          bool is_fsctl, char *in_data, u32 indatalen,
>>>> +                          char *in_data, u32 indatalen,
>>>>                             __u32 max_response_size);
>>>>   extern void SMB2_ioctl_free(struct smb_rqst *rqst);
>>>>   extern int SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
>>>> --
>>>> 2.35.3
>>>>
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
> 
> 
> 
