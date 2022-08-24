Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0415C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 13:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbiHXNsj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 09:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238786AbiHXNsR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 09:48:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1319925F
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 06:43:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ko+rDa37VIPGqoI07WUqJCt6bkNsKIM0QTOp1pMk0C2qlAg6gD6q1qrR8pEPv5ylHqf15pgIxk4OnLbNZnvoJbdejMS0rdMZqLIE1tO2pAphbCNzEhPMyeEZnQvB82CVu7Xrno9D9UOTEwRCkzEGdMz6Ru5Kc0iOeqWXW+scvJXIZdJweTiiB237/i58jyw1d+5fR5TLII6leJDx7eB9owSAnLlMRJHTTJQmVHgOD+2cRPZ3sseV+ysyeSiYf3ncFQzgAbfWGXvIPsoGIlC/ilmjTaVUutTnYZpkz58T0Rr9dmm5+7sDFRazPvi/qfd1MIuISGzzHDb9rDkK1vlFMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojrM0VT+WQNRQJ1h+DEIEivH+aXObrRxqJcn2Gua1p8=;
 b=g58AlqW/kG8n451TAwD7jZKL6lRdfb7+bqVA/yX5idFKc/wV7HuGEFrWzTOvHLszGv+m5D9ublsTN9dwwM7W2QMBXKNt1KhwQ1FtZxGUJjTg/cVey7Mq/MA2WzIRY4SkKaS3KrNxQKNnAuhpAc3hQo0I/p8cnTRcyZ/4URgIuItpwvkhHKdLV6tfT9NAbU0mOScfB4HgcOwzJYrO0iBEXbnoOEj5PiBKyJSFToafOqbrSH5IqtqThIjnMZrVGO5sRpTNvTAm7GrjzfZfsroVhdfbdt96jpi2FkRLoTapx7Qium62O8WL/ofxp2HH03bknlzPzyi/lxSXjwkXE8tb+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR0102MB3507.prod.exchangelabs.com (2603:10b6:207:1e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Wed, 24 Aug 2022 13:43:13 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Wed, 24 Aug 2022
 13:43:13 +0000
Message-ID: <3c4e4b94-0807-0d58-c443-3ab9784b69be@talpey.com>
Date:   Wed, 24 Aug 2022 09:43:11 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH 5/6] cifs: find and use the dentry for cached non-root
 directories also
Content-Language: en-US
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
References: <20220824002756.3659568-1-lsahlber@redhat.com>
 <20220824002756.3659568-6-lsahlber@redhat.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220824002756.3659568-6-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:335::8) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7b8ced2-26a5-4e39-e692-08da85d696fc
X-MS-TrafficTypeDiagnostic: BL0PR0102MB3507:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1e+zmyiFcCCCO7ZysrF0XOu/l1IHtZKzUkYUDBkj0NGk06MXLH9MgzjnCZk3og4rcIBdrNjlL4qXzq+lM0d1ma2umFF+ykuZ5zWsoR6UMAApqbJpm8DE0bWRUR11RNcWAubzdbl5k1k2pxuNigUA81h068VA8ClIh/2UPMF8gELl5U1JFTfLNIpCl/XVJt/NuzitdIU8VFT9Qr9FZfoEAWLTrsUvXUrm13DLT50dp9QcXhn0NwbJi8MBF6MsbAxJSv1bqXEB4g92ZWyAWLXgs++0czlId79crP+ZZ+zMGwzYUgw9KxRS7oX44FMhzoIpgCZv4rIZ4fshYQ4+23v/WTt6kkpnem7kSjrnzc4IIHcTR1JdHF+ScYfNCdUVtDLh1W/Hhm2nejvOfA2VjZftOfK5bpuE4u830MWmKP2D8zJn+XecdKVHIHbbk5ly18MSUfpVnXBpwN/CpiI0p4uxpO6YYBsKKKI7oWyfoWJSmu2pJ/ESelPbLlI8it4CQjdUjbOa2HaZobFxokT+FTanH7Y/hYbIg9ElELg8fj2QEToyT17B/TK/IqN/rqte/nDfXgsHpWo240pPTiOkZVJ/aheCewmzXPjhXympgFwbleJYbTEsG+eY1zFtjr8+BnNbk2X+TW6lcQeIKEcTe1YNEgckprLhW3HUcdo1AJYQWwBzx5dc9WZk3InWqCe3kOP7kyc8t+UFgCYJSP6Wqm+wl/zaZx9PB16Fm/QWyp53D1HvxDaHegXBPnXo/aHR1PNrwf3fy21i6PYSF5s9XO8d0EWQXH+6FcMxCs0/UGwvAwk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39830400003)(346002)(376002)(136003)(366004)(6486002)(478600001)(6506007)(38100700002)(6512007)(26005)(38350700002)(2616005)(31686004)(5660300002)(66476007)(4326008)(186003)(52116002)(8936002)(36756003)(53546011)(2906002)(31696002)(8676002)(66556008)(66946007)(86362001)(316002)(83380400001)(110136005)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEx2TmV1cW8va3NMQlU4dlM4S05UTXBLYllNR1JPR3hJWFU4V0pNSFJSUDFV?=
 =?utf-8?B?SkZUVUo5TTVzb0hQQXBlN3RxNVJYZGNPQW9IR2J1alR6Y3BIaUJ1Z3FlQXJC?=
 =?utf-8?B?bWplMi9WeGIzTElHNnQ3NlV4aUFLSmxnSU4vaEVqRmsyQ3pKbUNvQXFZTGFi?=
 =?utf-8?B?c1dpMm0wNWdBZmNHWW12RUxrbmxJZE5OSTdIbEs2eDNnOHVCWThkYzVUeG81?=
 =?utf-8?B?cGgzUUNzSmFXU1hrZzI0YVdOeURkcjJJMkoxWWFqNVlRYndSLzRpNmM3Q2lS?=
 =?utf-8?B?YlBCVGxaY0lpemV4THpsVWlJRHhDTDcyNExKNnFEaFBETFg1UTM5d3NiQ2NL?=
 =?utf-8?B?clVURlF5S3lvZ2ZUY2locWVHTXVESzVuV3hLVW1JVUhXamdrMnhleEJZdnRx?=
 =?utf-8?B?dllLeU9pdGNycE9RanIwdzNGdU1rd0UvU0o3bmtqdDFQOHAwVlBsc01yUlNZ?=
 =?utf-8?B?ZWhBUjRBa1Z2REl2bGhJaW11WlVXb1VSM1Y1dVB0NmZWRktIZmVqRmxpekZS?=
 =?utf-8?B?eXhmSEdQb0RKQmo1Y0lSc3ErQ2JHS2FmaGwwQ2NPZnBzL24wZ2REaUUzbklJ?=
 =?utf-8?B?VzRCdzFFNFBvV2x2NkxRY3ArTysrZndMdEQwdzNYeTMvZUNaeGRLa2Z5dG1I?=
 =?utf-8?B?VndPMnJWamhLZ0tVT0o5ZUxsMEUrRnVOQ3JWNm9OVkd3cnRRWXVzTGNLRFQ0?=
 =?utf-8?B?ZjJRWWlTTUdFWkl4MHNHMStYVENZSFZ3ODRPNWNXSmZQUThnalo2OC9Wd0NK?=
 =?utf-8?B?Um5odndEbzBQSlVzYnF6OUZhb3lDUmZUMmw5ZTZ3K3c3N1NOTnFjWkxEb2NU?=
 =?utf-8?B?ZTZnalg5ZTNZSGJ6bUZhcTFDcWVsTnBBbnRlWlRuZWFad0xCUlVOdjVDUnZw?=
 =?utf-8?B?b05jdjAzdFUzYmtERURYTHphczV2RjRtSGV0OWp5WWZENzB5TzBnQ2c1ZElo?=
 =?utf-8?B?RmVSdlVTY1dzL1pXajRKRTVyT2NkRWRIVXZyRzVhVGgwUS9FQ1hhdjVzM1RN?=
 =?utf-8?B?TGpvaVM2ejNWRTVlaUQ0S1VxcDMwNXQvbm53RFpYenBLcGw5UVRhYmRiRk1S?=
 =?utf-8?B?Ui8zTXBLY2FQZ2hEUURpOVN6SElRUmhzZ3h4Q0pVaVlMMUFxUlJML0NqVjhx?=
 =?utf-8?B?bi9sNW1zeUVWN3ZweFhpTm85eHkxc0x1Y3dFYmRYYWlWbTVVVHpKZ2tTTndX?=
 =?utf-8?B?eVQ4MVMwNnZFNGN3VEZkeGNVS0hKRkRGUkxJZEhDTlowNXk3Ym1vcWZ3L1FC?=
 =?utf-8?B?R25ocDRVQzhkWHo5Z2ZCY3oyMmZDOXd1Rm9adFpCSGJGY0JHQzV4cEtzNzF4?=
 =?utf-8?B?S01OUWMwNk4wRVhXUmwzSGFmelVrUUJxYzFMbk5vZHUrYk5KbXhob01jYTY4?=
 =?utf-8?B?enZZWWcvTG02bmU1Ri9mUVZxVkdVYjlaNmJtY1RseTh6N0pEK2RxMUxkM24w?=
 =?utf-8?B?YjdTamFzaXZvaGo4djRJbEo2UGFKZ0ExazdyVFVtT1c5WWsybG45WGNwcytw?=
 =?utf-8?B?S0JwMSswL1ovZ2RWSnVCK2xIeldIejNxQlFsN2gvcmVJck9FbmhKbnVKajRk?=
 =?utf-8?B?STJkZ3B1b3ZxWGZ4NmVFOTlhNzB4RzM5bXdPczhITWVtUVF4VU1uZFRIVkZM?=
 =?utf-8?B?MExwN205Ym44MDZrUjJsc3FxQ0NnblVMSmJCQk1VbW5NK0t0cm9TUURIV3ho?=
 =?utf-8?B?Q2JLbFVPSmVQTWtiVmpWVW9SVUhqREkzREd1d1RsaUgrY0lVZzBvaDNYN1Zh?=
 =?utf-8?B?SkxLcFNONnpoUGRRNk83L2JtY2NFM3NEdkZCcEVYczBHdFFDejF4WmQvMGNS?=
 =?utf-8?B?YW5FT3pvWDVIRkhRaGF6ek9INU1DbitEZEhzWS92WUpoa3ZwUkt0M3o1OUlO?=
 =?utf-8?B?cmR5Y1d2akNiR2l4cGJDbG9NbnpreExqK2tFYVZxYk5SNE9jbXkxcThhTXpM?=
 =?utf-8?B?WU5QSC9yaCs1cjR3ZkVOZEQxSHdJQzFHYUZVeEtPbmVLeitoVGVISmdUaUwv?=
 =?utf-8?B?blJwbDM3RW44aDhsNXAzSDJsbm5PU1VMR0Vmd1NzdTY5bjcydjh4VzhQUFUv?=
 =?utf-8?B?dXRpdXhWUFVKZDg0Y0QrcUJGaWU2R095WnZ1QjFIaS9LY2pkSlB4NGd1SER2?=
 =?utf-8?Q?syRw=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b8ced2-26a5-4e39-e692-08da85d696fc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 13:43:13.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1DzOTbNvhDug/QqGnHscxEiqmS+FvT/jw0eZsd7XHG+ZcFdtpOeTMFMt10n2rA6U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR0102MB3507
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/23/2022 8:27 PM, Ronnie Sahlberg wrote:
> This allows us to use cached attributes for the entries in a cached
> directory for as long as a lease is held on the directory itself.
> Previously we have always allowed "used cached attributes for 1 second"
> but this extends this to the lifetime of the lease as well as making the
> caching safer.
> 
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>   fs/cifs/cached_dir.c | 70 +++++++++++++++++++++++++++++++++++---------
>   1 file changed, 56 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> index 8732903aea03..f4d7700827b3 100644
> --- a/fs/cifs/cached_dir.c
> +++ b/fs/cifs/cached_dir.c
> @@ -5,6 +5,7 @@
>    *  Copyright (c) 2022, Ronnie Sahlberg <lsahlber@redhat.com>
>    */
>   
> +#include <linux/namei.h>
>   #include "cifsglob.h"
>   #include "cifsproto.h"
>   #include "cifs_debug.h"
> @@ -113,6 +114,50 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
>   	return cfid;
>   }
>   
> +static struct dentry *
> +path_to_dentry(struct cifs_sb_info *cifs_sb, const char *full_path)
> +{
> +	struct dentry *dentry;
> +	char *path = NULL;
> +	char *s, *p;
> +	char sep;
> +
> +	path = kstrdup(full_path, GFP_ATOMIC);
> +	if (path == NULL)
> +		return ERR_PTR(-ENOMEM);

Why make a copy of the path? I don't see anything in the code
below that modifies its contents...

> +
> +	sep = CIFS_DIR_SEP(cifs_sb);
> +	dentry = dget(cifs_sb->root);
> +	s = path;
> +
> +	do {
> +		struct inode *dir = d_inode(dentry);
> +		struct dentry *child;
> +
> +		if (!S_ISDIR(dir->i_mode)) {
> +			dput(dentry);
> +			dentry = ERR_PTR(-ENOTDIR);
> +			break;
> +		}
> +
> +		/* skip separators */
> +		while (*s == sep)
> +			s++;
> +		if (!*s)
> +			break;
> +		p = s++;
> +		/* next separator */
> +		while (*s && *s != sep)
> +			s++;
> +
> +		child = lookup_positive_unlocked(p, dentry, s - p);
> +		dput(dentry);
> +		dentry = child;
> +	} while (!IS_ERR(dentry));
> +	kfree(path);
> +	return dentry;
> +}
> +
>   /*
>    * Open the and cache a directory handle.
>    * If error then *cfid is not initialized.
> @@ -139,7 +184,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	struct dentry *dentry = NULL;
>   	struct cached_fid *cfid;
>   	struct cached_fids *cfids;
> -	
>   
>   	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
>   	    is_smb1_server(tcon->ses->server))
> @@ -155,13 +199,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	if (cifs_sb->root == NULL)
>   		return -ENOENT;
>   
> -	/*
> -	 * TODO: for better caching we need to find and use the dentry also
> -	 * for non-root directories.
> -	 */
> -	if (!strlen(path))
> -		dentry = cifs_sb->root;

Test path[0] instead of calling strlen?

> -
>   	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
>   	if (!utf16_path)
>   		return -ENOMEM;
> @@ -253,12 +290,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
>   #endif /* CIFS_DEBUG2 */
>   
> -	cfid->tcon = tcon;
> -	if (dentry) {
> -		cfid->dentry = dentry;
> -		dget(dentry);
> -	}
> -	/* BB TBD check to see if oplock level check can be removed below */
>   	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
>   		goto oshr_free;
>   	}
> @@ -277,6 +308,17 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   				&rsp_iov[1], sizeof(struct smb2_file_all_info),
>   				(char *)&cfid->file_all_info))
>   		cfid->file_all_info_is_valid = true;
> +
> +	if (!strlen(path)) {
> +		dentry = dget(cifs_sb->root);
> +		cfid->dentry = dentry;
> +	} else{
> +		dentry = path_to_dentry(cifs_sb, path);
> +		if (IS_ERR(dentry))
> +			goto oshr_free;
> +		cfid->dentry = dentry;
> +	}

Pull cfid->dentry = dentry out of the above conditionals and
just set it here for both cases.

> +	cfid->tcon = tcon;
>   	cfid->time = jiffies;
>   	cfid->is_open = true;
>   	cfid->has_lease = true;
