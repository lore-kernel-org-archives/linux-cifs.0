Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BC836AB6B;
	Mon, 28 Sep 2026 05:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790574188; cv=fail; b=dgrvEuz0NKWZHVfDOJDGE29nr4LLXidUzA+zyq44Npmzmwj38yeLkkBKZkIZqHvqoa+mpS68cAOaEez5qHMfMZcsfuE/cH4fvQKXHiW7xaYFYJXWrmSdeCqdN0XQHjPXAVQOCCzW3Dk2zjhC8K7rIIQyYZdGZR8rkOM99RtTijA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790574188; c=relaxed/simple;
	bh=jrIoVeqM6uaDcPcSX8oTDKbFfrGsBjdfIwHK+gJmA2E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=i7rrKhTHFb0GXlI+Dx7qoFhbe/juPcEyJQGrnYJFi00tWJte8bV8u8JswYvflcbeE1xyIJ25Q12nhnA67Umni+1dupUOgaZnr7zZmWBzeGENAKlryv7Kb0KWGYjWk2I3zTIp7ZS5Md+9ZOVKIRFtTsLTKLA7Gh8k7XRjdaKloCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m2t8rE8O; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m2t8rE8O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790574184; x=1822110184;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jrIoVeqM6uaDcPcSX8oTDKbFfrGsBjdfIwHK+gJmA2E=;
  b=m2t8rE8OyOWe2jenLxKvEDyH1PXSYyd5cq1ALWmhm+djJ1VhEvf/R+ro
   E5Y7m8secGl7wmi0E/kFtaCawTJXfyEvvjvVDysEHP7INX7k6FsUAJrir
   yeHgKcbJMG5kzRXaXamTZXQ4RVIFOSQ5og6at9/MbG3UHtgeDZcsBxb3i
   gCb1roYJmk2gLZr4vdmpElmN0k9TQuZhZ1qFXPNjGG0eguoVrOb9j7MX2
   jW8vcwlZ30mdIYdI9MAD3UKiTLXLCyjbKAKjhWLfsxbq2QROE6KzH+Gp8
   HQZQBAHJP0UiGuMRgt4jTzznJW92P13xF1DC/EQA+S7bSTRTRdg3Nqi6U
   g==;
X-CSE-ConnectionGUID: AQDGZOEWSq6nBnqw6aPl+w==
X-CSE-MsgGUID: U6y/BOVqSEu3PTtQMx9elQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11918"; a="101922614"
X-IronPort-AV: E=Sophos;i="6.27,127,1787036400"; 
   d="scan'208";a="101922614"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 22:42:59 -0700
X-CSE-ConnectionGUID: C+aayp/aSaWntEaWKF4Rjw==
X-CSE-MsgGUID: AjRzgS/BR066Tj9anNL4ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,127,1787036400"; 
   d="scan'208";a="273093051"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 22:42:58 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 27 Sep 2026 22:42:57 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Sun, 27 Sep 2026 22:42:57 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.35) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 27 Sep 2026 22:42:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=etUqiZiL0qPy4OTKIietT2Ux0vmnQC7e9RpAFPekAg83qNNMvjs8/b/RC8+mYcaFPUd4+tZjnKAu3V0E0MN2spEUfMoNDRqKbr7VA7F+Bj/mww7nKkkZPwS+cxqLdVc5PpcJvZKl3D/hKoiXFgFXvWqUxh1bLNl29ougluoajbCprHb+jC81oyQAM1d5qiu9tFEE1n+7Bb/YN2eoavfIqA7bZwGtq5w8PwdMl9ppv3mHKRmBKubdkvNDEEtWCjLgxyl8BOWdddFXplX2umU4K9ileHrdtq9fhAlQiQtJuRD1zK6Qa3wYKoM7Xi6CbtEUF6Cc+BZR+fQCYyUSeoP8cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlLyTGG+FHG0u7VVR8g9+814LBfjYIEtwSOdFaAxWiw=;
 b=U4sWyrWS1QhZ7WG9ECurUvP/S2t0fE0ZP1eBYc0wKZiiNLbaClCs3UEnVbD26xAc2JMewk8RIHCiI/UHVgi0T+bqpLBRWgtW/GpWMNGIvmbZ/Mr9/49XIBC3ewakCb7R5IHu5IbZap4CZJ8LR0FDmbMYH9L5JigDJk5LVMvub4e8pVTND9BYBdTZleura5rcnCc9XFc7TtgB1MKFbiQ51h7NvBAzMygU6MkAG5CSdKpHgojCE9reC5l3WKvS4Kc97viILod2to5/VGQYBP4WntA4svleMDSK8/JGgO6TWF9Tnx2Bf+ixEggMGFSbbekja8dzB8klqx80pwdQ2hAaSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS6PR11MB362586.namprd11.prod.outlook.com (2603:10b6:8:4c4::14)
 by CH3PR11MB8547.namprd11.prod.outlook.com (2603:10b6:610:1bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 05:42:51 +0000
Received: from DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a]) by DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a%6]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 05:42:51 +0000
Date: Mon, 28 Sep 2026 13:42:40 +0800
From: Philip Li <philip.li@intel.com>
To: Dan Carpenter <error27@gmail.com>
CC: Zihan Xi <zihanx@nebusec.ai>, <pc@manguebit.org>, <linkinjeon@kernel.org>,
	<ronniesahlberg@gmail.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
	<bharathsm@microsoft.com>, <dhowells@redhat.com>, <stfrench@microsoft.com>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, kernel test robot
	<lkp@intel.com>, Luxing Yin <root@tr0jan.top>
Subject: Re: [PATCH] smb: client: avoid NULL resp_iov dereference
Message-ID: <arn+UIhVhM4QDP0c@rli9-mobl>
References: <20260926132208.23360-1-zihanx@nebusec.ai>
 <arkuJtmhKDAFnzTl@stanley.mountain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <arkuJtmhKDAFnzTl@stanley.mountain>
X-ClientProxiedBy: TY4P301CA0126.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:37e::7) To DS6PR11MB362586.namprd11.prod.outlook.com
 (2603:10b6:8:4c4::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS6PR11MB362586:EE_|CH3PR11MB8547:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae8da53-f83e-4cd0-f2dc-08df1d235598
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|3023799007|10067099003|11063799006|56012099006|4143699003|20046099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: TrF0PRPoLApJecnhlWFwE2hYfzXWeyZA08+v+z3bl1hA7TbOnClKbmGb74t/QBMPWKdGoTpVMOHBdIMQhZQ6wE343dbsLI9JMspNjqrQXobMdkx/Wc259xtSkVcxakrdI/WBhGECJS24Dsw6pVVU2aGmRSJBn/tAAQO22fONkMvE6Il0W/ocJ4hw81H/R5hbvLw/WeLICxkapRrZeVFyLdNR7BS5cuFVKCgIuyfDKdmIpMZVIfWPlLOmseOwyR1G9JGzeX9CEUzeJA3XwwM67OVxGomUv6rZzkjlAcD65FYiWteta+bfQvwkk1oSom0KN4iJuyf0ZfKgTNS3RGow+jUBTNXLA3EoMBfNNokBWE7gfp5VI52krShXc3mWhG+DkkJkNU42zFE1DcIOaD1VTGc91lkjen7yZKe9xi8FNYrg7xomebA3mkZoYkA4YYuQ6xKJoBmn04w83TCT0vfg9/c/l8d4nE9LDcbIDeg733Pgs7TxjhYk0UjXqmdNYc56S2/keyK0GBDjfRcrU06grN5T2SunjP9WeKeAqp/NovvTBjGsMsFqKp8ZZSlpzQjd31mYJiYHOwvGmuRjyIzYlR2wBz1lDoC1UR1sFHg5Fle5xBwhh570kql+LS3/E3o5gwHqGc76awuw/8Aj9gn4tviV7vq0UT92Rbpp/HGAdUg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS6PR11MB362586.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(3023799007)(10067099003)(11063799006)(56012099006)(4143699003)(20046099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C9yF6d3eGMwBrZJardxnJaypdzF4XLKibIZRypR84sRcGqtQOHvVmh9VJtME?=
 =?us-ascii?Q?fnYlamau8ktrS4JdNcKxCNKUK8SYCejDUf7MayxsuGF8V4so9IYsNvKpPNmg?=
 =?us-ascii?Q?lg9Ow692IvuWPv/WuDhi/dtt935Op9tau/BCZMsAR9C9lYGPaC19SU5GHiB7?=
 =?us-ascii?Q?2ZDi6iMgMOBpMfiXuymdXN01B7In9lXfePAPJPLm3SCs1xT8bYrMp0MPbRrs?=
 =?us-ascii?Q?5gDW+Y1z82cq63Y/F0s1m6GC7lpNkUfqgB/+6xE6Q7vPrtZ8aB8alVMawVNE?=
 =?us-ascii?Q?2FGv+A4jI29dkWzB8THzqJSHchthQcwH3E3yJKKU1L43AwFkAJcxLf09rREM?=
 =?us-ascii?Q?EaZE7qs8/38J6PBxV6jRapcVKnNzpe5dQ9n86o9322hMTisrkdXQU0gmbDui?=
 =?us-ascii?Q?8MmnopNKY6i05jzYY+9W5BLsg6QQ96mOyl6xBRTeZxbS8uLxzugjz/65464q?=
 =?us-ascii?Q?lgtbIa2SZfJvQanFGcP5clGsJXL7oeJmIQQJd5V8wCuM9RPjaeSgYuAlKfOY?=
 =?us-ascii?Q?4r/r1C0XUGRHl4wk8tb4+lgiTOYhFjyugZMnSGDNVALLPI2xt+x/TeKAM4ww?=
 =?us-ascii?Q?YYh2iHrG5n7BpViluMY+xuIe987cufJbJqsbPWnCcHLFxfHza29fRcYM5Sch?=
 =?us-ascii?Q?2OWkT9V1cV445euL2mVmhStsY0DersroQ53VZ+VPmhDAKcvEABkiML/eCt20?=
 =?us-ascii?Q?4h2GfrrUbPuQFBy+8dvg7yOsYDrZ7H+28GBVrO1Ss7g7MFAzqfsKRqatnGSg?=
 =?us-ascii?Q?LMo+PwpG/zsurMgFWo6gxqWsl5s8HOwASBf9aPFOw8zxeJr0/HWtizO9boKl?=
 =?us-ascii?Q?PGuUFMrnMuCY3sjziiIQSd4xuyN9gPMhUeA60LbS8rgIxH47GVX0ak9xlysq?=
 =?us-ascii?Q?M1hoSgYEfAbPDXt6VO9t8LPXQMVZhgBOu1dSdntIk2UHroZyJk/Ply+loBX/?=
 =?us-ascii?Q?Q9pC3PYDMSsJFSR6o63xlc3zOtijBD4ZNMb63IhpK3t21LLWO4g7VGnyqVHk?=
 =?us-ascii?Q?MdKpDinzLhJLJA7KWxpD3xCeRTT8dpBFAW1lp0iceJZAKvVs0xA9vzUwOetQ?=
 =?us-ascii?Q?HEbaXGdxKiMKTrYdZz2eT8RDuR9wcG9toTfP4Q76AKGaku9T899Uv0x0OQdl?=
 =?us-ascii?Q?Eicvj304WP/TB2CFEPolkoqHTjAXOzJTGmCEfJv2x0ZGN98nYitzPz5rc+QW?=
 =?us-ascii?Q?PPpN2GfwriK8T4Xu/MSDg76+RzTzSJeJbBvzK9eU2NM306k25CzubQLEwTgt?=
 =?us-ascii?Q?iIHziytUh/1MhKM7EMfwUHsBMqG3AnzhtQIwIot+Gu6JGybUJ8FBMH7FPPMV?=
 =?us-ascii?Q?UcjfFzD/zMvTWkXoJckMcD60BWfNFUR3LTEgdM85c/x+5Es+NiyqMebPiiXD?=
 =?us-ascii?Q?ZOC7Km4meOoLgeUZ9uEanet2q9uSScLVY7UTPWpbhoUKdMV6yd/GCqhvlDPo?=
 =?us-ascii?Q?T8YBu8qnf9cuxI5c5kYLatnCrjByLADC1D9z6E+z1vyJjeWiH14IPfVAz7p6?=
 =?us-ascii?Q?uQx+ce7wuu+R4ISGoPX/cz72BNHD9b8GqSqbM4rYuKhiz8EXRlMgyJGfUd9e?=
 =?us-ascii?Q?h5tIY1Hme5UOjf5AhBMUJTI+XIXvl6LRwM4dPho8GMlpvxH+D3/bMZzC0Hyg?=
 =?us-ascii?Q?KS2rPTQpB9wfehfdqu/FPdsc1lbcMy5Z9Pg+/bVgqjmwl7LPsfkHw7v4omIy?=
 =?us-ascii?Q?qHVQO1mRHB8BDj41QxvMmeiXgGR2USu9PD3ImCh6qcMPL0mVuY4b2aCr4o2C?=
 =?us-ascii?Q?PY976TDpOw=3D=3D?=
X-Exchange-RoutingPolicyChecked: QbsqlVEvFR9NWPtNZ8VCg29FL8W7lfVP/U5cpgsADt1s6uxL2g4sug+D0Dw9up2mwJR5LsLRdfvpnKJXae5P8Gy59WTpQ2Y0I5VJDf9k3/T4namoZdnrcHDzSGBny+CM/UZaRa7cgvq8SGSpCp3OO5/c1xtVCiUhKInDakXy27QwRpK/CDo7IqQ1CJJm7ZPOhJPjj+ZrmbUc2z9+5Q0e7QpunT0TnCmXzD43+owrK2z0NE0MayJaaa6IMz727TbDRcmdCdikiIUjb9khskg9udNVJESpeThY0ba6gpaEFy5VUEI+xMC7jGddNF4b+onEd7C1qzgO3bTgNAdWw5ZhPQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae8da53-f83e-4cd0-f2dc-08df1d235598
X-MS-Exchange-CrossTenant-AuthSource: DS6PR11MB362586.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 05:42:50.9029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lP9yhWpL1GwcvWAg2WcYBgu+L6MMifYKs0gnzvHgdRJzNKvTX5EpYTj4KX3FC4lS/T9sZ3NY5/zUVUs93N5TZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8547
X-OriginatorOrg: intel.com

On Sun, Sep 27, 2026 at 05:54:30PM +0300, Dan Carpenter wrote:
> On Sat, Sep 26, 2026 at 01:22:08PM +0000, Zihan Xi wrote:
> > compound_send_recv() only populates response vectors when resp_iov is
> > non-NULL. The final pre-authentication hash update nevertheless
> > dereferences resp_iov[0] whenever all compound requests complete.
> > 
> > Guard the update with resp_iov to match the response-buffer handling and
> > avoid a NULL pointer dereference on callers that do not request response
> > vectors.
> > 
> > Fixes: 62432a3f5145 ("cifs: Clean up some places where an extra kvec[] was required for rfc1002")
> > Cc: stable@vger.kernel.org
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Closes: https://lore.kernel.org/all/202609241449.HlHmnZFZ-lkp@intel.com/
> 
> Originally the idea was that I would review these and filter out
> the false positives, but these days people use lei to read email so
> they recieve the unfiltered warnings.  The zero day bot should
> probably put a "Unfiltered warning" note at the top to let people
> know the warning hasn't been reviewed.

Got it, I will add this note to the bot report for unfiltered warnings.

Thanks

> 
> regards,
> dan carpenter
> 
> 
> 
