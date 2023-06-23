Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9095EEB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 16:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjFWQJU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 12:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjFWQJT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 12:09:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DC6B7
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 09:09:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auQe1X9s59s+wfbuMwmowztcKAxbF34N5+ptdnlG97InFOkG+o/SM6R1i+op9THdzuSmRrChdfkVxynyq/Dyu1vkS8XNfauNRpzVN8ohnjxGttDp5+9C1520ALN7qkz0d5Asz/qQd124l3aZLUJxb9XswMyBIH+ljZDo8DtT4+TzDAIIgHHiumf5ggTc22NWBj7CDxCR2vf2fsIJBt6wtzf6ucv6yqBhXaa0Vqln+gz+cBdkIDngmxCchA5sQGiQjjQtzMQt/bQcK9gOdeVo3nrQVwziuem+1op7HzEYZhibp0LHuPOOTgHnGA8A/vCbeoY1xpQ+Rs8JFjMkDr8VSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFwm2luQ/ZevP1/kbpcd+hLuG96UI4tvS5GZGKNjJ0k=;
 b=m7Fl6iHwAg2fg1ERji5q8dzXx/FVYxyZoCjIJ8bk81zBqp+KZ4WQThVznSiYj4DZJ4gMO2p9eFlVXbStVTrlDqqA1NLmLUhJ8so+0J5RGJntzi+V7ywPRbWvLAN8l7ln+32MhGUdToZ7stfIPFt7o3TEIjnNYyp1EOlh6PAyjJ0uyIroEKAifnZa2sdfBKl3VUzgLGSvHtUG8tiTmhR+3nfEQYDf1/9YJDDXjipqsr0//fZ8SQlrLZu+BMhg39N2G360KGgLcAeYBVBEoPkZi6wa+NHsOZerQqgZDnhETubWPqooMTgNe6WuNxj11Vh/4rQPsd2kgx+MMwyCsPOpiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA0PR01MB6204.prod.exchangelabs.com (2603:10b6:806:e9::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.24; Fri, 23 Jun 2023 16:09:15 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Fri, 23 Jun 2023
 16:09:14 +0000
Message-ID: <2099a884-2e27-cc43-a293-69de617ab5d7@talpey.com>
Date:   Fri, 23 Jun 2023 12:09:12 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 6/6] cifs: fix sockaddr comparison in iface_cmp
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-6-sprasad@microsoft.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230609174659.60327-6-sprasad@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0363.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::8) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA0PR01MB6204:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d88ee97-0cd0-46db-bd5f-08db74043083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5y4CwqmPGjHQwlRlnA/Tq+DSUQXlckcZTftMn225a50S9lYf0zRL/7/mtmo3G0wfU0m8dPu/MYf/oDNU480HcIjeOnflYNpULEeSnmeAsGfCEatVL2tSPuseEweo7jX5rbzBg6Ir4ZS9l7PxiUNr7G2wpysT+CgqZk3pWI3XkzWQt5hwIfEtEP3SEBNupdtpu3HuIObmlDRQhEbhgP2hZBJJyN6ARYW85LGwWATWdT1NBGGOFOUxNA3YbzCbfuKrN/qeT44ewQjX95hkvaKN11mO4RvqZyaqPwE9S6XbcPytCoEhh3mWw2nvcsHbJUobtCd86YNmn4OzuKozyBsxigChDGqUl74h5Gi1lHqtMBlCVNipggJfKeUr2M4xWrN5BneHP4U2CW36KpMoQVU4mXhrq7fwrtkY5H2wmzpka5+WfZuL/kDFSlgOSJ9P5lb8eH0vJuSNLEXUxh9OQQ8GjkbzdczzBzPK+87eXuGMAsDY4hZcnp2B90ZN/31xTl+QE5GN/hZRdB2GMDVdeU9dXwP2cLy7Oki5jT2DtqllWClJDB8cn5RiHFVOn2WLJh1nVG7ZnBIbOBucnMstc6+NZUHKEfbson2bbQMc/7PythpHv1YO6bvHIhtdOINvVsOB7xCwTGbnIccnbeG/sCwLrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(39840400004)(396003)(346002)(451199021)(6506007)(5660300002)(66476007)(36756003)(66556008)(66946007)(4326008)(478600001)(316002)(31686004)(8676002)(8936002)(2906002)(41300700001)(54906003)(86362001)(31696002)(6486002)(38100700002)(45080400002)(38350700002)(26005)(52116002)(6512007)(53546011)(186003)(83380400001)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uzk3N2xsZDRnNm85VTdpbGtVc28rbWY4V3U2QUsvWmFWV1BCWW4wNDNTRkV3?=
 =?utf-8?B?Q3JDYmJuV3pQU01kN2Rsai9SOVZhUHVOa1F1bHFtYm1oc0FDbUdENmc2eUd3?=
 =?utf-8?B?UVZyejIvaGQwbzd2MjZ3OWovRGtBdko4VDU1R3Q2cXV2UmR1SUF6ay9sOEhD?=
 =?utf-8?B?Ymx1TEVnUGZ5aHFsZDg0Yk12bU1WTTR5Y2pVdzFDbUQwcU12WlI2eEtCK3dN?=
 =?utf-8?B?M2d2VlhrOGdVa0xkSElFaVQ0d3N1Qmh5cVl1WGV3N1VnZFR4b0xmL3hXbUFX?=
 =?utf-8?B?VVpyOWNINDljY3F5TGFMa1pWc2ZOQllmK3ZxSGwzcGg2S2o3cjVPS0J1YzNm?=
 =?utf-8?B?VU5hOU5rVkpEQk5Ka3YyaFd4QyswRW43QU1nZUpLNHpkdWVGWFFpbHZQRkJp?=
 =?utf-8?B?bUM0azBSVGtKK2xkNW1pWUt1VEF2SXVKbExsT2FuaUtmMmRjQzUwSURCcytE?=
 =?utf-8?B?N0h4U1N2K3N6WEJLZW5EaVBrT1NlZk1NSEJGVzVaYW1CbnJ4K0I0Rm9aR3NE?=
 =?utf-8?B?ZDRBVDdLY0tJSG9KZGp1dUtmNGZBVVBzRG0yREc5dnlGK3BmNlVzQmt0NVRK?=
 =?utf-8?B?eG9JUHkwVi9LcDc1UGJuUE56RFo5UlpRN3RISTliTytrRlo2NkFKMk9RSGN2?=
 =?utf-8?B?R1NiN3BaSlBVVUlkTC9NbmxObmNtYWZlL3dULytpeVBQSWN5cDhPUzlIZXlU?=
 =?utf-8?B?S2xNWm1ZUzhsSlk3Yy8wQ1V1WFdmTTFZTVVJblQrdkl5Q2RERmF1eGNLaitM?=
 =?utf-8?B?TGtFYW9vZmExdXhoQXl0eVh3TWJpOFhQT0ZIK3hFSzZnLzRFTE1OZEJBNmgw?=
 =?utf-8?B?cGVQNjI1MzlyQUNFWWd0VW8vZFpHd1FlYk5qWThYY21Cb2t6RmZudW9XeFF5?=
 =?utf-8?B?enZGTWZpWFpVTzJJMU5kK1A2SkRFWndBbjFuUjhGdWdYWnJsVHRTNzNjWkEv?=
 =?utf-8?B?bXFjRlVhbDFHZ0tKLzA5b1F5dGVDM0RvWGJTOEhPb1d0L3M5ZXoxdFZ0aTRK?=
 =?utf-8?B?WnFFRHpXNUhaNS9aM0Nma0ljMm85U2FvRDJiK2pCUitrZlZTb2V5OEY2NXdN?=
 =?utf-8?B?UlF6ZDgrUVdrS0pldXRlN2R1SWl3MS80NUNQeTE1TzZMdDRGYWFCYVZVQ0NP?=
 =?utf-8?B?dVZ4eVFYZ2x3dmRrQnlvQkVNTGpDZitnZ3FhcG1oVWp0TkN0V2V1SDd6THdS?=
 =?utf-8?B?NzNhMjVSNVlpVkNyS2cycGE5WCtpY3pVdzlXdXlSZDhKYk8xaXhFYzFrZDdt?=
 =?utf-8?B?ZEdmR2kvWDVaWFRpTFZsMURwdExuRjZ4ZlZzUnpyWW1rOHhBV2NvQkhHcEZZ?=
 =?utf-8?B?cVRBa0oyTk9JK1R6Y201ZHBpbnE4UUNGQzV5K1RZaFVpd3V2NmJOSFpHVUlH?=
 =?utf-8?B?ZW10Vm1OaG1XUW5mR09WRzBsZDdBVHhsUUh1eHM2MS9kS3M0cGJZaUZyQUx3?=
 =?utf-8?B?dVRYS0tlVXZoWEEzTWNlSVhIYkFQNWNZczlYRnBQdUFaT0p3UnExYk9PZTZH?=
 =?utf-8?B?M2h5ODljbkRoWk9Ib3JiR1N0V25iY3U4TU1tMlBkOVFKVzdCejA3WndlaEZ1?=
 =?utf-8?B?TUt2NjR1MStnS1pXWmJOS0pINW96bzR2NUEwZzdHd0orbjRxaVV5YzhtWWdJ?=
 =?utf-8?B?Um5qK09jd3FYSWlka1d4VmJLWVZndmp6RlF1c1IzbDdlaWRqNW5XS2JoMEE0?=
 =?utf-8?B?T0pVNGhKekFBRUpRV3FrNmRlQnp1Rys5U0UyYXl4WFNSdkR6a0FqVHMzU2tj?=
 =?utf-8?B?c3AzTlI2OU1SUjFjZkE3alh3RlpLZUZEWWNDdzcvdzBGSk9qcVRDcUFhZWtW?=
 =?utf-8?B?UWs4RFVXUFhOYnU0dnl3SjFQN2ZYRXhJam02b05GVHE3cHhnZWkxZjhpaUU5?=
 =?utf-8?B?Y3Z3S1pQWExpMHFrUHkxNTk2VjRxQmh2N1p0MWxseGFnZHRMRGFIU0U3MnJm?=
 =?utf-8?B?S1BLZUI0MmZxUDc1eGVaWHBYNDJSMjJoNWNaUjVUa1hJdkVKVTVpMy9RcXFW?=
 =?utf-8?B?SklEZFJWY0RGSDVySi9OUzdGeFFrK3dJQUdRc1VRbnlWcEhzeEFpM2ozOVFQ?=
 =?utf-8?B?S1cvbHlvcHdPT3VMM0VDRmtFT2lBSFRXNmZuRE9mVkNMemJIcTZBUGNaUXNv?=
 =?utf-8?Q?o3/vx+68WcSvMyUcsib0wYlsI?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d88ee97-0cd0-46db-bd5f-08db74043083
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:09:14.6928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kn0cegHK7woLv4wTD3POupzgwKOs8+eyaP2WmqVM9Ohm273CnIQ75uGT5qKWoO62
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6204
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/9/2023 1:46 PM, Shyam Prasad N wrote:
> iface_cmp used to simply do a memcmp of the two
> provided struct sockaddrs. The comparison needs to do more
> based on the address family. Similar logic was already
> present in cifs_match_ipaddr. Doing something similar now.
> 
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> ---
>   fs/smb/client/cifsglob.h  | 37 -----------------------------
>   fs/smb/client/cifsproto.h |  1 +
>   fs/smb/client/connect.c   | 50 +++++++++++++++++++++++++++++++++++++++
>   fs/smb/client/smb2ops.c   | 37 +++++++++++++++++++++++++++++
>   4 files changed, 88 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 0d84bb1a8cd9..b212a4e16b39 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -970,43 +970,6 @@ release_iface(struct kref *ref)
>   	kfree(iface);
>   }
>   
> -/*
> - * compare two interfaces a and b
> - * return 0 if everything matches.
> - * return 1 if a has higher link speed, or rdma capable, or rss capable
> - * return -1 otherwise.
> - */
> -static inline int
> -iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
> -{
> -	int cmp_ret = 0;
> -
> -	WARN_ON(!a || !b);
> -	if (a->speed == b->speed) {
> -		if (a->rdma_capable == b->rdma_capable) {
> -			if (a->rss_capable == b->rss_capable) {
> -				cmp_ret = memcmp(&a->sockaddr, &b->sockaddr,
> -						 sizeof(a->sockaddr));
> -				if (!cmp_ret)
> -					return 0;
> -				else if (cmp_ret > 0)
> -					return 1;
> -				else
> -					return -1;
> -			} else if (a->rss_capable > b->rss_capable)
> -				return 1;
> -			else
> -				return -1;
> -		} else if (a->rdma_capable > b->rdma_capable)
> -			return 1;
> -		else
> -			return -1;
> -	} else if (a->speed > b->speed)
> -		return 1;
> -	else
> -		return -1;
> -}
> -
>   struct cifs_chan {
>   	unsigned int in_reconnect : 1; /* if session setup in progress for this channel */
>   	struct TCP_Server_Info *server;
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index c1c704990b98..d127aded2f28 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -87,6 +87,7 @@ extern int cifs_handle_standard(struct TCP_Server_Info *server,
>   				struct mid_q_entry *mid);
>   extern int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
>   extern int smb3_parse_opt(const char *options, const char *key, char **val);
> +extern int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
>   extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
>   extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
>   extern int cifs_call_async(struct TCP_Server_Info *server,
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 1250d156619b..9d16626e7a66 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1288,6 +1288,56 @@ cifs_demultiplex_thread(void *p)
>   	module_put_and_kthread_exit(0);
>   }
>   
> +int
> +cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs)

Please, please, please, let's not add a new shared entry starting with
this four-letter word.

> +{
> +	struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
> +	struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
> +	struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
> +	struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;

I don't see the value in these variables. Why not simply add the casts
in the very few places they're used?

> +
> +	switch (srcaddr->sa_family) {
> +	case AF_UNSPEC:
> +		switch (rhs->sa_family) {
> +		case AF_UNSPEC:
> +			return 0;
> +		case AF_INET:
> +		case AF_INET6:
> +			return 1;
> +		default:
> +			return -1;
> +		}
> +	case AF_INET: {
> +		switch (rhs->sa_family) {
> +		case AF_UNSPEC:
> +			return -1;
> +		case AF_INET:
> +			return memcmp(saddr4, vaddr4,
> +				      sizeof(struct sockaddr_in));
> +		case AF_INET6:
> +			return 1;
> +		default:
> +			return -1;
> +		}
> +	}
> +	case AF_INET6: {
> +		switch (rhs->sa_family) {
> +		case AF_UNSPEC:
> +		case AF_INET:
> +			return -1;
> +		case AF_INET6:
> +			return memcmp(saddr6,
> +				      vaddr6,
> +				      sizeof(struct sockaddr_in6));
> +		default:
> +			return -1;
> +		}
> +	}
> +	default:
> +		return -1; /* don't expect to be here */
> +	}
> +}
> +
>   /*
>    * Returns true if srcaddr isn't specified and rhs isn't specified, or
>    * if srcaddr is specified and matches the IP address of the rhs argument
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 18faf267c54d..046341115add 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -513,6 +513,43 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
>   	return rsize;
>   }
>   
> +/*
> + * compare two interfaces a and b
> + * return 0 if everything matches.
> + * return 1 if a is rdma capable, or rss capable, or has higher link speed
> + * return -1 otherwise.
> + */
> +static int
> +iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
> +{
> +	int cmp_ret = 0;
> +
> +	WARN_ON(!a || !b);
> +	if (a->rdma_capable == b->rdma_capable) {
> +		if (a->rss_capable == b->rss_capable) {
> +			if (a->speed == b->speed) {
> +				cmp_ret = cifs_ipaddr_cmp((struct sockaddr *) &a->sockaddr,
> +							  (struct sockaddr *) &b->sockaddr);
> +				if (!cmp_ret)
> +					return 0;
> +				else if (cmp_ret > 0)
> +					return 1;
> +				else
> +					return -1;
> +			} else if (a->speed > b->speed)
> +				return 1;
> +			else
> +				return -1;
> +		} else if (a->rss_capable > b->rss_capable)
> +			return 1;
> +		else
> +			return -1;
> +	} else if (a->rdma_capable > b->rdma_capable)
> +		return 1;
> +	else
> +		return -1;
> +}
> +

The { <0 / 0 / >0 } behavior of this code has been a source of
incorrect comparisons in the past, and it still makes my head hurt
to attempt a review.

So I'll ask, have you thoroughly tested this to be certain that it
doesn't result in new channels being created needlessly?

>   static int
>   parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
>   			size_t buf_len, struct cifs_ses *ses, bool in_mount)

Tom.
