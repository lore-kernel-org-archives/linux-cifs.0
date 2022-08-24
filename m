Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C67C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 13:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbiHXNgY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 09:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238274AbiHXNgR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 09:36:17 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F01785AD
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 06:36:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvGKYHQRSmvNdc7e9ud1xS+OkcsFAtSpgS5/gzoGjIYwPy7qrA0R0k+Q5tRN1zYnv/vcZWNSXAup37sSgu49ZSL7a4iupMaB2wLP0Tyh2pApv+r5tS/sB1F6UVXGBZg9PoaCEPn7XuuqNkCeH0TObDJkOc7m/uTgRc1dyB4OUWa3YyeMX+6JNIU+D8x15Ryn7MrGSsjSTcpli5oU2kfn+0aUQExfsyyZBMuGzrUBa3YCnIHaQaJzF/3vf0GVyJylRvECjVPS03NtUq7TQnGNHxH61kqPNHGzntDgHWaBB7/+eQi519NIMoOUtDSKqyRa1DTNSD04pYt3WFFz9iiFaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebHr8GfrlxyhrnwBdytY167emlS9fC2y1Lkcci/CaHs=;
 b=d5fvoiiXRuXh5rwuOPx1hVfmGjTARER6UmWDUVY5tFQHxDdwL+be/n1I+0Qx4GddqKFHcJw6+UFABQeszcE4pdcAzqwnXAIzorySTZ+IstbAzpoHP5ZA9dCXEYccLpa+8cJCLAGAg6OjsMLrXHMVxTew8zQ0NXabKarFF0NARTjSOAuONQdZIdEULQZNyazJSuFlD0Ku/IAnlb1pJyhurd3tDoaflGDHgkaOjB+jY0J6iG8volEUzZW3q3n5BZO6e/njm8XLsg5sDcl9gS2iAEMoXsP8jEQZhgGMR7NBXwuomaKvYhv+Ij8+VLjnXwGhhoRwoVgcnBP7xohAMQ/qVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4774.prod.exchangelabs.com (2603:10b6:a03:88::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Wed, 24 Aug 2022 13:36:10 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Wed, 24 Aug 2022
 13:36:10 +0000
Message-ID: <5947fe51-049f-2896-b131-9f74d0d2677e@talpey.com>
Date:   Wed, 24 Aug 2022 09:36:08 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH 4/6] cifs: start caching all directories we open and get a
 lease for
Content-Language: en-US
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
References: <20220824002756.3659568-1-lsahlber@redhat.com>
 <20220824002756.3659568-5-lsahlber@redhat.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220824002756.3659568-5-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0001.namprd14.prod.outlook.com
 (2603:10b6:208:23e::6) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0caf246b-1357-416b-2cdb-08da85d59aec
X-MS-TrafficTypeDiagnostic: BYAPR01MB4774:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WCjjSQuShsbjdakpFcyZxBP4+I4GdqvaGLohKdkSr9XR24Pk3128h0y+gDGTi1fhCLVxSxZ2c4uLdQRxzjeBnqE9+A+xNpdQmi9a7lNkSBekwe8A1Zj8CiMT7s4euZ50luTE/EOryEFq5wUlBfxxi91+nwcj3JRJd0X0D+M5daUEedgC7WAWxVbgQeho+WjtNpPU1+2Cu0FKHxPjWQHxaR8h0RqUgmVSGfEhSG8Df6st/Nj+etKMSO5/e9K1Ex9YDHjK5V48dwG5m5Mlt1/EKRLxobJ7qCBqG47IOIdBRJ6c23A5p8nBjN5uy5u4yv12rgx6Gl/jvTlFqQELtBWm47Z2M1RlSbck2DFEz5X5QQCrhsEOrquuT4nWNNosu+4EO+NiENncSLdT7cT1uAuhqZHm40iceteWX6gsF9RWDA9Is54CnRHAftwIf3EgDNrnjXxZLUgZyOekcq1Mr8OqUZnIkfyaEqfBIVaQflbDcGM7tdbX2X16rmr5GaFrvvkmtda1S+Evj+mUWFmN4XjDl4u6hDkKxpJ2QAjQ7U0KeLSEd35n8okcDbND50AXkl08MDlFx1DOuQp+Q8V0r+WMR7WkMdZrnctmN8P+12asN5HMHKUkDrsTb8YjiXAirWqCDFlBGriyV0nLyW1cMa0UpQYRYjxdDLk2eBJ90SQP5tLHljTgYaho5s1b9bQuurjr5hLM4E8io+DQo6d3XA2gl6kf7o6E1yRv67TF7KOo4Tk2uLRdNsVHGM7DWk7U4wzk6+VmDNiMN8m/gfkamJ63kxpXgoT48zN6WOYhxQ8c+zw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(39830400003)(366004)(396003)(31686004)(30864003)(6486002)(316002)(5660300002)(26005)(110136005)(8936002)(6506007)(478600001)(2906002)(186003)(86362001)(52116002)(2616005)(31696002)(6512007)(41300700001)(36756003)(38350700002)(38100700002)(53546011)(83380400001)(4326008)(66476007)(66556008)(8676002)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3daZ3Q2OTRYVGl0SUJycUM5TWhxMTl3a1VyalZUbnBtU3FtM1VGYWthMUlX?=
 =?utf-8?B?aVprUFFVOW5lNmlTZGtXaktTQ1NZQ1ovb3JZbFkvdDhzVzhNNnNzMXFVbEtT?=
 =?utf-8?B?bHhtZHVqSVNQZzVMdDd4REt3MDQzRG9DTFdCdi9FZ241QzloSVZzSGRadmw5?=
 =?utf-8?B?Z29ub0dwdkpjbS9INmZiMDhHRTZYc3RuMUxpSkhCUEEveWNJNllsblNnanAy?=
 =?utf-8?B?OE5nTDhhWHFTMFZlUTVMczZtcFBYbjdhbnRqR2YwdFZ4VGJuNU9XaHVxNFZy?=
 =?utf-8?B?MWszN0VZOWYrLzl2N0FWZnZ4d0xXeEtiZWRYbXJQQXdZZHVpZTRTcnIxNGFI?=
 =?utf-8?B?Ui9iV1k0Mjh2Z0VlRGU5c0tNNzlma0pWN1kwNW0xSDdOem0rWjNxYjIzTWhV?=
 =?utf-8?B?L1RNKzdBWXBQQ1pFY095YWxEK3Qxd3VuSzlQYnBPOUYvTTNxbk1DOUFmR2dn?=
 =?utf-8?B?RVlUbUJhQk9qRkkzNUE1WjhtWlMxOFB1bTJHNnBaVlBsUHVreEY4QWxqSTZt?=
 =?utf-8?B?aVNrUmo0WjZ4aVZSY1ZwR0ZBclNSK3ZzVWEyVTBrM09Oa1NSNVBsMUdCOWNQ?=
 =?utf-8?B?bnJwZU5yY05DektiNW9yUm1qcDBNWHR6YWJmYmJkT2l3R1JzMHdOSldwTU52?=
 =?utf-8?B?RElqcnhUVk53Y3lNcTMxNDJHRjY4NnU3MUxaN29wUkJGVWtWKzlvdDFBYnNq?=
 =?utf-8?B?QVNOdUhicmxoeUxVQzdUM0Jld2pLTmFDMkFpWFRGRDFTb1ZHVDlFQm9hbnla?=
 =?utf-8?B?REhmNnVOVHFXY1RYUFloa1phR1ZFM0hlR3pBeGwxOFNsa25mTTcrNUhkajBp?=
 =?utf-8?B?SUw5NWJOZWVPUVlpUjV1em16NG5DM1ZJRXVEMjltTHk4SFgyd2F2bDlkOE9n?=
 =?utf-8?B?Y1JnRUFaWWtjY2hvcEdPV0gzdXp0QW9NRUo0TWdUYmdQY1RXSmw4L1BMUzR2?=
 =?utf-8?B?RnBSV3J3SkJQWFF2WEtiVkFEaFNMWTYyblFDcVk1c3k5UGxMaVNWaUt3YzNM?=
 =?utf-8?B?RGx5OVpyelpjUEMzZXAvOFNNdXVRUklJUGV6UTRsYlp5cFR0SFNrd0NxbXNI?=
 =?utf-8?B?bnJwWWpIcjM0L3NHRjJDL1U0Wk9JZTI1OWd0UTRpTmk1R2xtRmNGZy9qRG1h?=
 =?utf-8?B?aTBUNG5TQXhVZkQ3VjVYc2IvRDZxTHBhWm9sUW9qUzNJczFTdmtablc2Z2cv?=
 =?utf-8?B?WFBGYnk1V253VmlSODhSNWMyNVpEYTh2QjhZVjdiMUVSQ0taWUdZdXpRbVJH?=
 =?utf-8?B?ajB2MEFQQmJnODczS3lPVFpwb0xuWFJrNkFzQWF5MkxWU1RWdjliUHYvNVVR?=
 =?utf-8?B?MTJ3K2hlSUtEZXBuVmF2RnF2K1hRbUhkUldyb3NXWkppbERic0VJU2psUVB3?=
 =?utf-8?B?R3ZBL21rVXQ4c3hHZWpWYnlRV2JRK3h1V2MxK1lEd01PUTJmUllCMXRlL3lE?=
 =?utf-8?B?VDJTRmVjc3ZnSUpUajFKcG5rMEJEV29YcjZsYUNtQ3JuOUtSSEFFWkhQd2RD?=
 =?utf-8?B?Q1A1cHhJOE84bmx1WWNnejNkVTRJUGpGT1BiK1dnNGFNWENPU3dkREsvdW1u?=
 =?utf-8?B?dGRraWtDOUcxRnZEeUc4aStOaVJ4dkdNZkVWN3RXQTFiWFBGK2gvcmhhdENV?=
 =?utf-8?B?VEE4elczZnJkWmtEZnVzTlluTjhaNzVCZXdOd1pQWGpWT1BWUm04aGRZZEFQ?=
 =?utf-8?B?VFBpUmkzM3IrUm9uc0V2RHFhc29IR1g0YnZ5RnptaVp5ekN1MHZCKzNKVTVG?=
 =?utf-8?B?Tk4yVzdoU3I2ZTVqU0FZU1o5OWZnaXRub2NlYTVzWXUra1FxYU9EQ1ZhcnFz?=
 =?utf-8?B?SzE5ckRTYWtUZzdTc3VrTjRma0tqMFBUMnE0V3lnL1ZFRnFORnB5Wk5KM0VS?=
 =?utf-8?B?OWl6VkkrSWVCSWxBRGVRSEhqUGtyWUgzK0ZOazNRYU1KT0wvMnVHM3AveU15?=
 =?utf-8?B?anNCL0Y5aWJFS3ZiSFdpUWpodkVPRVBRWVRFcWR0QktCdFNqNGVpWXJhdzBI?=
 =?utf-8?B?dVlGYU5TTytqYVV2ZXZnZFZqSSt2dFVKOWNaNmMwaisrVGdISlJKSHYrcnlE?=
 =?utf-8?B?STVnVkdVRDBPbmFWRnlEbk1SVlhmRFpjYlZmZ1J2WkoxeDArZ2pKWlMvbFNI?=
 =?utf-8?Q?yD0o=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0caf246b-1357-416b-2cdb-08da85d59aec
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 13:36:10.1606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Lqr7wKX3FyilFOj4kDYjA/A2bmF17AakLqyGg4VCcqJ9nKGUrAlbGDbB2ySLwhK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4774
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Comment on the subject.

This code doesn't cache *all* directories, it is limited to
MAX_CACHED_FIDS. And "open and get a lease for" is redundant
as well - leases are granted at open.

Suggest "Enable caching of directories for which a lease is held".

On 8/23/2022 8:27 PM, Ronnie Sahlberg wrote:
> This expands the directory caching to now cache an open handle for all
> directories (up to a maximum) and not just the root directory.
> 
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>   fs/cifs/cached_dir.c | 490 ++++++++++++++++++++++++++-----------------
>   fs/cifs/cached_dir.h |  20 +-
>   fs/cifs/inode.c      |   6 +-
>   fs/cifs/smb2ops.c    |   2 +-
>   4 files changed, 320 insertions(+), 198 deletions(-)
> 
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> index 594ec4385077..8732903aea03 100644
> --- a/fs/cifs/cached_dir.c
> +++ b/fs/cifs/cached_dir.c
> @@ -11,7 +11,107 @@
>   #include "smb2proto.h"
>   #include "cached_dir.h"
>   
> -struct cached_fid *init_cached_dir(const char *path);
> +static struct cached_fid *init_cached_dir(const char *path);
> +static void free_cached_dir(struct cached_fid *cfid);
> +
> +/*
> + * Locking and reference count for cached directory handles:
> + *
> + * The main function to get a reference to a cached handle is
> + * find_or_create_cached_dir() called from open_cached_dir()
> + * These functions are protected under the cfid_list_lock spin-lock
> + * to make sure we do not race creating new references for cached dirs
> + * with deletion of expired ones.
> + *
> + * An successful open_cached_dir() will take out 2 references to the cfid if
> + * this was the very first and successful call to open the directory and
> + * it acquired a lease from the server.
> + * One reference is for the lease  and the other is for the cfid that we
> + * return. The is lease reference is tracked by cfid->has_lease.
> + * If the directory already has a handle with an active lease, then we just
> + * take out one new reference for the cfid and return it.
> + * It can happen that we have a thread that tries to open a cached directory
> + * where we have a cfid already but we do not, yet, have a working lease. In
> + * this case we will just return NULL, and this the caller will fall back to
> + * the case when no handle was available.
> + *
> + * In this model the total number of references we have on a cfid is
> + * 1 for while the handle is open and we have a lease, and one additional
> + * reference for each open instance of a cfid.
> + *
> + *
> + * Once we get a lease break (cached_dir_lease_break()) we remove the
> + * cfid from the list under the spinlock. This prevents any new threads to
> + * use it, and we also call smb2_cached_lease_break() via the work_queue
> + * in order to drop the reference we got for the lease (we drop it outside
> + * of the spin-lock.)
> + * Anytime a thread calls close_cached_dir() we also drop a reference to the
> + * cfid.
> + * When the last reference to the cfid is released smb2_close_cached_fid()
> + * will be invoked which will drop the reference ot the dentry we held for
> + * this cfid and it will also, if we the handle is open/has a lease
> + * also call SMB2_close() to close the handle on the server.
> + *
> + *
> + * Two events require special handling:
> + * invalidate_all_cached_dirs() this function is called from SMB2_tdis()
> + * and cifs_mark_open_files_invalid().
> + * In both cases the tcon is either gone already or will be shortly so
> + * we do not need to actually close the handles. They will be dropped
> + * server side as part of the tcon dropping.
> + * But we have to be careful about a potential race with a concurrent
> + * lease break so we need to take out additional refences to avoid the
> + * cfid from being freed while we are still referencing it.
> + *
> + * free_cached_dirs() which is called from tconInfoFree().
> + * This is called quite late in the umount process so there should no longer
> + * be any open handles or files and we can just free all the remaining data.
> + */

This is a helpful comment during the review phase, but it's mighty
detailed, and therefore subject to being wrong, in the future.

> +
> +static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
> +						    const char *path,
> +						    bool lookup_only)
> +{
> +	struct cached_fid *cfid;
> +
> +	spin_lock(&cfids->cfid_list_lock);
> +	list_for_each_entry(cfid, &cfids->entries, entry) {
> +		if (!strcmp(cfid->path, path)) {
> +			/*
> +			 * If it doesn't have a lease it is either not yet
> +			 * fully cached or it may be in the process of
> +			 * being deleted due to a lease break.
> +			 */
> +			if (!cfid->has_lease) {
> +				spin_unlock(&cfids->cfid_list_lock);
> +				return NULL;
> +			}
> +			kref_get(&cfid->refcount);
> +			spin_unlock(&cfids->cfid_list_lock);
> +			return cfid;
> +		}
> +	}
> +	if (lookup_only) {
> +		spin_unlock(&cfids->cfid_list_lock);
> +		return NULL;
> +	}
> +	if (cfids->num_entries >= MAX_CACHED_FIDS) {
> +		spin_unlock(&cfids->cfid_list_lock);
> +		return NULL;
> +	}
> +	cfid = init_cached_dir(path);
> +	if (cfid == NULL) {
> +		spin_unlock(&cfids->cfid_list_lock);
> +		return NULL;
> +	}
> +	cfid->cfids = cfids;
> +	cfids->num_entries++;
> +	list_add(&cfid->entry, &cfids->entries);
> +	cfid->on_list = true;
> +	kref_get(&cfid->refcount);
> +	spin_unlock(&cfids->cfid_list_lock);
> +	return cfid;
> +}
>   
>   /*
>    * Open the and cache a directory handle.
> @@ -33,62 +133,65 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
>   	struct kvec qi_iov[1];
>   	int rc, flags = 0;
> -	__le16 utf16_path = 0; /* Null - since an open of top of share */
> +	__le16 *utf16_path = NULL;
>   	u8 oplock = SMB2_OPLOCK_LEVEL_II;
>   	struct cifs_fid *pfid;
> -	struct dentry *dentry;
> +	struct dentry *dentry = NULL;
>   	struct cached_fid *cfid;
> +	struct cached_fids *cfids;
> +	
>   
> -	if (tcon == NULL || tcon->nohandlecache ||
> +	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
>   	    is_smb1_server(tcon->ses->server))
> -		return -EOPNOTSUPP;
> +		return -ENOTSUPP;

Good catch - there's no operation here.

>   
>   	ses = tcon->ses;
>   	server = ses->server;
> +	cfids = tcon->cfids;
>   
> +	if (!server->ops->new_lease_key)
> +		return -EIO;
> +	
>   	if (cifs_sb->root == NULL)
>   		return -ENOENT;
>   
> +	/*
> +	 * TODO: for better caching we need to find and use the dentry also
> +	 * for non-root directories.
> +	 */
>   	if (!strlen(path))
>   		dentry = cifs_sb->root;
>   
> -	if (strlen(path))
> -		return -ENOENT;
> +	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> +	if (!utf16_path)
> +		return -ENOMEM;
>   
> -	cfid = tcon->cfids->cfid;
> +	cfid = find_or_create_cached_dir(cfids, path, lookup_only);
>   	if (cfid == NULL) {
> -		cfid = init_cached_dir(path);
> -		tcon->cfids->cfid = cfid;
> +		kfree(utf16_path);
> +		return -ENOENT;
>   	}
> -	if (cfid == NULL)
> -		return -ENOMEM;
> -
> -	mutex_lock(&cfid->fid_mutex);
> -	if (cfid->is_valid) {
> -		cifs_dbg(FYI, "found a cached root file handle\n");
> +	/*
> +	 * At this point we either have a lease already and we can just
> +	 * return it. If not we are guaranteed to be the only thread accessing
> +	 * this cfid.
> +	 */
> +	if (cfid->has_lease) {
>   		*ret_cfid = cfid;
> -		kref_get(&cfid->refcount);
> -		mutex_unlock(&cfid->fid_mutex);
> +		kfree(utf16_path);
>   		return 0;
>   	}
>   
>   	/*
>   	 * We do not hold the lock for the open because in case
> -	 * SMB2_open needs to reconnect, it will end up calling
> -	 * cifs_mark_open_files_invalid() which takes the lock again
> -	 * thus causing a deadlock
> +	 * SMB2_open needs to reconnect.
> +	 * This is safe because no other thread will be able to get a ref
> +	 * to the cfid until we have finished opening the file and (possibly)
> +	 * aquired a lease.
>   	 */
> -	mutex_unlock(&cfid->fid_mutex);
> -
> -	if (lookup_only)
> -		return -ENOENT;
> -
>   	if (smb3_encryption_required(tcon))
>   		flags |= CIFS_TRANSFORM_REQ;
>   
> -	if (!server->ops->new_lease_key)
> -		return -EIO;
> -
>   	pfid = &cfid->fid;
>   	server->ops->new_lease_key(pfid);
>   
> @@ -109,7 +212,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	oparms.reconnect = false;
>   
>   	rc = SMB2_open_init(tcon, server,
> -			    &rqst[0], &oplock, &oparms, &utf16_path);
> +			    &rqst[0], &oplock, &oparms, utf16_path);
>   	if (rc)
>   		goto oshr_free;
>   	smb2_set_next_command(tcon, &rqst[0]);
> @@ -132,47 +235,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	rc = compound_send_recv(xid, ses, server,
>   				flags, 2, rqst,
>   				resp_buftype, rsp_iov);
> -	mutex_lock(&cfid->fid_mutex);
> -
> -	/*
> -	 * Now we need to check again as the cached root might have
> -	 * been successfully re-opened from a concurrent process
> -	 */
> -
> -	if (cfid->is_valid) {
> -		/* work was already done */
> -
> -		/* stash fids for close() later */
> -		struct cifs_fid fid = {
> -			.persistent_fid = pfid->persistent_fid,
> -			.volatile_fid = pfid->volatile_fid,
> -		};
> -
> -		/*
> -		 * caller expects this func to set the fid in cfid to valid
> -		 * cached root, so increment the refcount.
> -		 */
> -		kref_get(&cfid->refcount);
> -
> -		mutex_unlock(&cfid->fid_mutex);
> -
> -		if (rc == 0) {
> -			/* close extra handle outside of crit sec */
> -			SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> -		}
> -		rc = 0;
> -		goto oshr_free;
> -	}
> -
> -	/* Cached root is still invalid, continue normaly */
> -
>   	if (rc) {
>   		if (rc == -EREMCHG) {
>   			tcon->need_reconnect = true;
>   			pr_warn_once("server share %s deleted\n",
>   				     tcon->treeName);
>   		}
> -		goto oshr_exit;
> +		goto oshr_free;
>   	}
>   
>   	atomic_inc(&tcon->num_remote_opens);
> @@ -185,49 +254,56 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   #endif /* CIFS_DEBUG2 */
>   
>   	cfid->tcon = tcon;
> -	cfid->is_valid = true;
> -	cfid->dentry = dentry;
> -	if (dentry)
> +	if (dentry) {
> +		cfid->dentry = dentry;
>   		dget(dentry);
> -	kref_init(&cfid->refcount);
> -
> +	}
>   	/* BB TBD check to see if oplock level check can be removed below */
> -	if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
> -		/*
> -		 * See commit 2f94a3125b87. Increment the refcount when we
> -		 * get a lease for root, release it if lease break occurs
> -		 */
> -		kref_get(&cfid->refcount);
> -		cfid->has_lease = true;
> -		smb2_parse_contexts(server, o_rsp,
> -				&oparms.fid->epoch,
> -				    oparms.fid->lease_key, &oplock,
> -				    NULL, NULL);
> -	} else
> -		goto oshr_exit;
> +	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
> +		goto oshr_free;
> +	}
>   
> +	smb2_parse_contexts(server, o_rsp,
> +			    &oparms.fid->epoch,
> +			    oparms.fid->lease_key, &oplock,
> +			    NULL, NULL);
> +	
>   	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
>   	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
> -		goto oshr_exit;
> +		goto oshr_free;
>   	if (!smb2_validate_and_copy_iov(
>   				le16_to_cpu(qi_rsp->OutputBufferOffset),
>   				sizeof(struct smb2_file_all_info),
>   				&rsp_iov[1], sizeof(struct smb2_file_all_info),
>   				(char *)&cfid->file_all_info))
>   		cfid->file_all_info_is_valid = true;
> -
>   	cfid->time = jiffies;
> +	cfid->is_open = true;
> +	cfid->has_lease = true;
>   
> -oshr_exit:
> -	mutex_unlock(&cfid->fid_mutex);
>   oshr_free:
> +	kfree(utf16_path);
>   	SMB2_open_free(&rqst[0]);
>   	SMB2_query_info_free(&rqst[1]);
>   	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
>   	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> -	if (rc == 0)
> -		*ret_cfid = cfid;
> -
> +	spin_lock(&cfids->cfid_list_lock);
> +	if (!cfid->has_lease) {
> +		if (cfid->on_list) {
> +			list_del(&cfid->entry);
> +			cfid->on_list = false;
> +			cfids->num_entries--;
> +		}
> +		rc = -ENOENT;
> +	}
> +	spin_unlock(&cfids->cfid_list_lock);
> +	if (rc) {
> +		free_cached_dir(cfid);
> +		cfid = NULL;
> +	}
> +	if (rc == 0) {
> +		*ret_cfid = cfid;	
> +	}
>   	return rc;
>   }
>   
> @@ -236,20 +312,22 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>   			      struct cached_fid **ret_cfid)
>   {
>   	struct cached_fid *cfid;
> +	struct cached_fids *cfids = tcon->cfids;
>   
> -	cfid = tcon->cfids->cfid;
> -	if (cfid == NULL)
> +	if (cfids == NULL)
>   		return -ENOENT;
>   
> -	mutex_lock(&cfid->fid_mutex);
> -	if (cfid->dentry == dentry) {
> -		cifs_dbg(FYI, "found a cached root file handle by dentry\n");
> -		*ret_cfid = cfid;
> -		kref_get(&cfid->refcount);
> -		mutex_unlock(&cfid->fid_mutex);
> -		return 0;
> +	spin_lock(&cfids->cfid_list_lock);
> +	list_for_each_entry(cfid, &cfids->entries, entry) {
> +		if (dentry && cfid->dentry == dentry) {
> +			cifs_dbg(FYI, "found a cached root file handle by dentry\n");
> +			kref_get(&cfid->refcount);
> +			*ret_cfid = cfid;	
> +			spin_unlock(&cfids->cfid_list_lock);
> +			return 0;
> +		}
>   	}
> -	mutex_unlock(&cfid->fid_mutex);
> +	spin_unlock(&cfids->cfid_list_lock);
>   	return -ENOENT;
>   }
>   
> @@ -258,63 +336,29 @@ smb2_close_cached_fid(struct kref *ref)
>   {
>   	struct cached_fid *cfid = container_of(ref, struct cached_fid,
>   					       refcount);
> -	struct cached_dirent *dirent, *q;
>   
> -	if (cfid->is_valid) {
> -		cifs_dbg(FYI, "clear cached root file handle\n");
> -		SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
> -			   cfid->fid.volatile_fid);
> +	spin_lock(&cfid->cfids->cfid_list_lock);
> +	if (cfid->on_list) {
> +		list_del(&cfid->entry);
> +		cfid->on_list = false;
> +		cfid->cfids->num_entries--;
>   	}
> +	spin_unlock(&cfid->cfids->cfid_list_lock);
>   
> -	/*
> -	 * We only check validity above to send SMB2_close,
> -	 * but we still need to invalidate these entries
> -	 * when this function is called
> -	 */
> -	cfid->is_valid = false;
> -	cfid->file_all_info_is_valid = false;
> -	cfid->has_lease = false;
> -	if (cfid->dentry) {
> -		dput(cfid->dentry);
> -		cfid->dentry = NULL;
> -	}
> -	/*
> -	 * Delete all cached dirent names
> -	 */
> -	mutex_lock(&cfid->dirents.de_mutex);
> -	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
> -		list_del(&dirent->entry);
> -		kfree(dirent->name);
> -		kfree(dirent);
> +	dput(cfid->dentry);
> +	cfid->dentry = NULL;
> +
> +	if (cfid->is_open) {
> +		SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
> +			   cfid->fid.volatile_fid);
>   	}
> -	cfid->dirents.is_valid = 0;
> -	cfid->dirents.is_failed = 0;
> -	cfid->dirents.ctx = NULL;
> -	cfid->dirents.pos = 0;
> -	mutex_unlock(&cfid->dirents.de_mutex);
>   
> +	free_cached_dir(cfid);
>   }
>   
>   void close_cached_dir(struct cached_fid *cfid)
>   {
> -	mutex_lock(&cfid->fid_mutex);
>   	kref_put(&cfid->refcount, smb2_close_cached_fid);
> -	mutex_unlock(&cfid->fid_mutex);
> -}
> -
> -void close_cached_dir_lease_locked(struct cached_fid *cfid)
> -{
> -	if (cfid->has_lease) {
> -		cfid->has_lease = false;
> -		kref_put(&cfid->refcount, smb2_close_cached_fid);
> -	}
> -}
> -
> -void close_cached_dir_lease(struct cached_fid *cfid)
> -{
> -	mutex_lock(&cfid->fid_mutex);
> -	close_cached_dir_lease_locked(cfid);
> -	mutex_unlock(&cfid->fid_mutex);
>   }
>   
>   /*
> @@ -327,41 +371,62 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
>   	struct cached_fid *cfid;
>   	struct cifs_tcon *tcon;
>   	struct tcon_link *tlink;
> +	struct cached_fids *cfids;
>   
>   	for (node = rb_first(root); node; node = rb_next(node)) {
>   		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
>   		tcon = tlink_tcon(tlink);
>   		if (IS_ERR(tcon))
>   			continue;
> -		cfid = tcon->cfids->cfid;
> -		if (cfid == NULL)
> +		cfids = tcon->cfids;
> +		if (cfids == NULL)
>   			continue;
> -		mutex_lock(&cfid->fid_mutex);
> -		if (cfid->dentry) {
> +		list_for_each_entry(cfid, &cfids->entries, entry) {
>   			dput(cfid->dentry);
>   			cfid->dentry = NULL;
>   		}
> -		mutex_unlock(&cfid->fid_mutex);
>   	}
>   }
>   
>   /*
> - * Invalidate and close all cached dirs when a TCON has been reset
> + * Invalidate all cached dirs when a TCON has been reset
>    * due to a session loss.
>    */
>   void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
>   {
> -	struct cached_fid *cfid = tcon->cfids->cfid;
> -
> -	if (cfid == NULL)
> -		return;
> -
> -	mutex_lock(&cfid->fid_mutex);
> -	cfid->is_valid = false;
> -	/* cached handle is not valid, so SMB2_CLOSE won't be sent below */
> -	close_cached_dir_lease_locked(cfid);
> -	memset(&cfid->fid, 0, sizeof(struct cifs_fid));
> -	mutex_unlock(&cfid->fid_mutex);
> +	struct cached_fids *cfids = tcon->cfids;
> +	struct cached_fid *cfid, *q;
> +	struct list_head entry;
> +
> +	INIT_LIST_HEAD(&entry);
> +	spin_lock(&cfids->cfid_list_lock);
> +	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> +		list_del(&cfid->entry);
> +		list_add(&cfid->entry, &entry);
> +		cfids->num_entries--;
> +		cfid->is_open = false;
> +		/* To prevent race with smb2_cached_lease_break() */
> +		kref_get(&cfid->refcount);
> +	}
> +	spin_unlock(&cfids->cfid_list_lock);
> +
> +	list_for_each_entry_safe(cfid, q, &entry, entry) {
> +		cfid->on_list = false;
> +		list_del(&cfid->entry);
> +		cancel_work_sync(&cfid->lease_break);
> +		if (cfid->has_lease) {
> +			/*
> +			 * We lease was never cancelled from the server so we
> +			 * we need to drop the reference.
> +			 */
> +			spin_lock(&cfids->cfid_list_lock);
> +			cfid->has_lease = false;
> +			spin_unlock(&cfids->cfid_list_lock);
> +			kref_put(&cfid->refcount, smb2_close_cached_fid);
> +		}
> +		/* Drop the extra reference opened above*/
> +		kref_put(&cfid->refcount, smb2_close_cached_fid);
> +	}
>   }
>   
>   static void
> @@ -370,51 +435,83 @@ smb2_cached_lease_break(struct work_struct *work)
>   	struct cached_fid *cfid = container_of(work,
>   				struct cached_fid, lease_break);
>   
> -	close_cached_dir_lease(cfid);
> +	spin_lock(&cfid->cfids->cfid_list_lock);
> +	cfid->has_lease = false;
> +	spin_unlock(&cfid->cfids->cfid_list_lock);
> +	kref_put(&cfid->refcount, smb2_close_cached_fid);
>   }
>   
>   int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
>   {
> -	struct cached_fid *cfid = tcon->cfids->cfid;
> +	struct cached_fids *cfids = tcon->cfids;
> +	struct cached_fid *cfid;
>   
> -	if (cfid == NULL)
> +	if (cfids == NULL)
>   		return false;
>   
> -	if (cfid->is_valid &&
> -	    !memcmp(lease_key,
> -		    cfid->fid.lease_key,
> -		    SMB2_LEASE_KEY_SIZE)) {
> -		cfid->time = 0;
> -		INIT_WORK(&cfid->lease_break,
> -			  smb2_cached_lease_break);
> -		queue_work(cifsiod_wq,
> -			   &cfid->lease_break);
> -		return true;
> +	spin_lock(&cfids->cfid_list_lock);
> +	list_for_each_entry(cfid, &cfids->entries, entry) {
> +		if (cfid->has_lease &&
> +		    !memcmp(lease_key,
> +			    cfid->fid.lease_key,
> +			    SMB2_LEASE_KEY_SIZE)) {
> +			cfid->time = 0;
> +			/*
> +			 * We found a lease remove it from the list
> +			 * so no threads threads can access it.
> +			 */
> +			list_del(&cfid->entry);
> +			cfid->on_list = false;
> +			cfids->num_entries--;
> +
> +			queue_work(cifsiod_wq,
> +				   &cfid->lease_break);
> +			spin_unlock(&cfids->cfid_list_lock);
> +			return true;
> +		}
>   	}
> +	spin_unlock(&cfids->cfid_list_lock);
>   	return false;
>   }
>   
> -struct cached_fid *init_cached_dir(const char *path)
> +static struct cached_fid *init_cached_dir(const char *path)
>   {
>   	struct cached_fid *cfid;
>   
> -	cfid = kzalloc(sizeof(*cfid), GFP_KERNEL);
> +	cfid = kzalloc(sizeof(*cfid), GFP_ATOMIC);
>   	if (!cfid)
>   		return NULL;
> -	cfid->path = kstrdup(path, GFP_KERNEL);
> +	cfid->path = kstrdup(path, GFP_ATOMIC);
>   	if (!cfid->path) {
>   		kfree(cfid);
>   		return NULL;
>   	}
>   
> +	INIT_WORK(&cfid->lease_break, smb2_cached_lease_break);
> +	INIT_LIST_HEAD(&cfid->entry);
>   	INIT_LIST_HEAD(&cfid->dirents.entries);
>   	mutex_init(&cfid->dirents.de_mutex);
> -	mutex_init(&cfid->fid_mutex);
> +	spin_lock_init(&cfid->fid_lock);
> +	kref_init(&cfid->refcount);
>   	return cfid;
>   }
>   
> -void free_cached_dir(struct cached_fid *cfid)
> +static void free_cached_dir(struct cached_fid *cfid)
>   {
> +	struct cached_dirent *dirent, *q;
> +
> +	dput(cfid->dentry);
> +	cfid->dentry = NULL;
> +
> +	/*
> +	 * Delete all cached dirent names
> +	 */
> +	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
> +		list_del(&dirent->entry);
> +		kfree(dirent->name);
> +		kfree(dirent);
> +	}
> +
>   	kfree(cfid->path);
>   	cfid->path = NULL;
>   	kfree(cfid);
> @@ -427,15 +524,34 @@ struct cached_fids *init_cached_dirs(void)
>   	cfids = kzalloc(sizeof(*cfids), GFP_KERNEL);
>   	if (!cfids)
>   		return NULL;
> -	mutex_init(&cfids->cfid_list_mutex);
> +	spin_lock_init(&cfids->cfid_list_lock);
> +	INIT_LIST_HEAD(&cfids->entries);
>   	return cfids;
>   }
>   
> +/*
> + * Called from tconInfoFree when we are tearing down the tcon.
> + * There are no active users or open files/directories at this point.
> + */
>   void free_cached_dirs(struct cached_fids *cfids)
>   {
> -	if (cfids->cfid) {
> -		free_cached_dir(cfids->cfid);
> -		cfids->cfid = NULL;
> +	struct cached_fid *cfid, *q;
> +	struct list_head entry;
> +
> +       	INIT_LIST_HEAD(&entry);
> +	spin_lock(&cfids->cfid_list_lock);
> +	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> +		cfid->on_list = false;
> +		cfid->is_open = false;
> +		list_del(&cfid->entry);
> +		list_add(&cfid->entry, &entry);
> +	}
> +	spin_unlock(&cfids->cfid_list_lock);
> +
> +	list_for_each_entry_safe(cfid, q, &entry, entry) {
> +		list_del(&cfid->entry);
> +		free_cached_dir(cfid);
>   	}
> -	kfree(cfids);
> +
> + 	kfree(cfids);
>   }
> diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
> index bdf6c3866653..e536304ca2ce 100644
> --- a/fs/cifs/cached_dir.h
> +++ b/fs/cifs/cached_dir.h
> @@ -31,14 +31,17 @@ struct cached_dirents {
>   };
>   
>   struct cached_fid {
> +	struct list_head entry;
> +	struct cached_fids *cfids;
>   	const char *path;
> -	bool is_valid:1;	/* Do we have a useable root fid */
> -	bool file_all_info_is_valid:1;
>   	bool has_lease:1;
> +	bool is_open:1;
> +	bool on_list:1;
> +	bool file_all_info_is_valid:1;
>   	unsigned long time; /* jiffies of when lease was taken */
>   	struct kref refcount;
>   	struct cifs_fid fid;
> -	struct mutex fid_mutex;
> +	spinlock_t fid_lock;
>   	struct cifs_tcon *tcon;
>   	struct dentry *dentry;
>   	struct work_struct lease_break;
> @@ -46,9 +49,14 @@ struct cached_fid {
>   	struct cached_dirents dirents;
>   };
>   
> +#define MAX_CACHED_FIDS 16
>   struct cached_fids {
> -	struct mutex cfid_list_mutex;
> -	struct cached_fid *cfid;
> +	/* Must be held when:
> +	 * - accessing the cfids->entries list
> +	 */
> +	spinlock_t cfid_list_lock;
> +	int num_entries;
> +	struct list_head entries;
>   };
>   
>   extern struct cached_fids *init_cached_dirs(void);
> @@ -61,8 +69,6 @@ extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>   				     struct dentry *dentry,
>   				     struct cached_fid **cfid);
>   extern void close_cached_dir(struct cached_fid *cfid);
> -extern void close_cached_dir_lease(struct cached_fid *cfid);
> -extern void close_cached_dir_lease_locked(struct cached_fid *cfid);
>   extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
>   extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
>   extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index bac08c20f559..a42397b52882 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2265,13 +2265,13 @@ cifs_dentry_needs_reval(struct dentry *dentry)
>   		return true;
>   
>   	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
> -		mutex_lock(&cfid->fid_mutex);
> +		spin_lock(&cfid->fid_lock);
>   		if (cfid->time && cifs_i->time > cfid->time) {
> -			mutex_unlock(&cfid->fid_mutex);
> +			spin_unlock(&cfid->fid_lock);
>   			close_cached_dir(cfid);
>   			return false;
>   		}
> -		mutex_unlock(&cfid->fid_mutex);
> +		spin_unlock(&cfid->fid_lock);
>   		close_cached_dir(cfid);
>   	}
>   	/*
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 96f3b0573606..1ed4b4992025 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -787,7 +787,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>   
>   	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
>   	if (!rc) {
> -		if (cfid->is_valid) {
> +		if (cfid->has_lease) {
>   			close_cached_dir(cfid);
>   			return 0;
>   		}
