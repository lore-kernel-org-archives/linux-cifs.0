Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FE41B85C2;
	Tue, 24 Sep 2024 02:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727146431; cv=fail; b=f1GJV9VdjUDxHWSyhS1tnHOb3BJ8ctzPle8EAOlobdIelCSeBAmkCToeKO/Pn7q3cC4EqUaIM3TdjU3cNoNNqUMoactr/PdJAFFzs9/5hkMMvqk8vc54Ub+wtLeGDpl3gm+wCbGOBzlOC6cQKZcNKmAVFgreu2aqe2zleM8rGoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727146431; c=relaxed/simple;
	bh=RmarMj4gTEnzmnijKvmGM7djWcPetbfwFgv5ncHF8+Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K2S3sE540Dn67EQC49lS1np7DybVtdBKQ0anVK0VthUy0iTHjJA973l6J05YYsxB2gsr8XIT5E+bmdtlmXZigJm/d/8TgrYnX/3ZQoY3C00k8goLSVTsbUi2u+BRL4mEc9jErYWSfgptbrx7QDWNwY57xOAldGBzPPCM+NN6fCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nuH+nkpW; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nuH+nkpW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727146430; x=1758682430;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RmarMj4gTEnzmnijKvmGM7djWcPetbfwFgv5ncHF8+Q=;
  b=nuH+nkpWiFtxCcKDeFCdJ/Pr7jq5KUMdWRaPJBEpV3PL2ntGlKW3Q40P
   A37/1lekyVlV8wlEezot3tvMRze8vP6IHH+H0dINlGY2RWpj9fhUImZc1
   aycqAFMDeSc/ojxHnVI/rbLJdDzDF9Tu7cfCtz5sJh9jfhhfy0UUBo5VA
   AM3SuPSzZbqPMowzm1uooj0Mbwi1eFrvx0w4Wj/gXJts0lWY0pX9xPSwQ
   FLqxH3YfjNn3DrWB9vdZyCaQ63x3xTVVrFZG1BVhLBgR3b4yit/2kYwsl
   eUiPvAwkUeNUmU4y5qGA/VOmz1vKofUzkbJnVtKIQnd2SeZ3WjCp2FpM+
   w==;
X-CSE-ConnectionGUID: 5XI49FQ2QUiodNOe81XelQ==
X-CSE-MsgGUID: gywIHZrtSOys81vCDops5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="26312759"
X-IronPort-AV: E=Sophos;i="6.10,253,1719903600"; 
   d="scan'208";a="26312759"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 19:53:49 -0700
X-CSE-ConnectionGUID: wxElBCaMRDCiRI2FJV4Ihw==
X-CSE-MsgGUID: HN9qc4dJR6uav7omDIg8iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,253,1719903600"; 
   d="scan'208";a="71585931"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Sep 2024 19:53:49 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 19:53:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 23 Sep 2024 19:53:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 19:53:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G2Iho9SQPR8mPoSs9PhJ/vANgLSIcCtLmCy6gd9XeKyJwgbfOjxaCNlhAr1KDWPARbkh06g0pDeo89VfDuGcUx1HrZGzRPUKzZ5ddiak+MUn+X5g1+rBi7W/9Fq2ofG98e/rrp5bPbPQVcBsnkD9JMfGikl5jfhbgg7c9elMRnAr1XLt1whEzYD03VjhTNR5O8/YJoLmCUzfRiqgiWeGGr8RBBQdHhq5E9OOHM/8EU7KWmREgpTHvu9KmKFVbGVmDTy0QHr0VVecGkuRIjRZUfQxNWFLi5Yben51aIhY0kk1lan3xzKMMMDczE2qurN0y+ebeisTdT2BKsFHE7nAvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qs9WaIZRnHyI16X/m7sP/mEs8WEnGg6xwxIzrJYHZg=;
 b=yH9Ddd5Wbg5KcW/qbyGWTftT9SY6hP4K0epqpZfTMoTOt4M5CfYml6uIqkT/N2xRe4LA14rQceM5x6izhjiPiS+SRGM/yisnz9+tBI5Nia4hOrWZFm0ZVwI/VnI5RrjE2/y5skb4Cdx2CapljuLHcxyNyeG4jpzX/Tbs/ebUtUP6oTfmUHv6xizb54i38al1d7KzFNvSBY9up7N2ynsXU6S6RWytKMpcOrlNVC1XC9cBfnPved8bFvv3HoNlYvv81X7wKYrCS4Au3N9iYmgBTV8PysFUOkBv+PlD5D8wlN5MggRpOqJCR8wfvpfirVxALUW00HQGy8cq+U3TlleaxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by MN0PR11MB6302.namprd11.prod.outlook.com (2603:10b6:208:3c2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Tue, 24 Sep
 2024 02:53:41 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125%3]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 02:53:41 +0000
Date: Tue, 24 Sep 2024 10:53:32 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: David Howells <dhowells@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, Steve French
	<stfrench@microsoft.com>, Paulo Alcantara <pc@manguebit.com>, "Christian
 Brauner" <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<oliver.sang@intel.com>
Subject: Re: [linus:master] [cifs] 43a64bd02f: xfstests.generic.465.fail
Message-ID: <ZvIprK+p09tqNk7c@xsang-OptiPlex-9020>
References: <202409221711.b537f7a8-oliver.sang@intel.com>
 <743744.1727075336@warthog.procyon.org.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <743744.1727075336@warthog.procyon.org.uk>
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|MN0PR11MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: e68a909d-5bd1-4031-0ea7-08dcdc4418cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?K7SXY9HStriYV9kJJEMDSQL7ERXV5t/Ku6h3wtGVzX0SRHq7T/ZS6ssRGJSG?=
 =?us-ascii?Q?DmcJtuxVNr+PsEQwES1LtSBX6xbXxTKxo2bHEpweRJtfUzGWepVMCcRw8A4Z?=
 =?us-ascii?Q?zKgvxpIl3KcWb44Q3al3rWL/Mx7pvkgOhyGBpiPoM8HFlpPrrHJ3peNFXpbu?=
 =?us-ascii?Q?SA+5EXlx9Pqr0JkaGuzNlJv03oDy4/MHM08eHyHZ1CooLD9hfcWeQeSdxS7x?=
 =?us-ascii?Q?8a0L8DNiUSyXRCncUZMtNn1GNhNl26BqWf0gM05c3tFZ4QE9fEv/xKxYPCZu?=
 =?us-ascii?Q?QMTAW/xn5JQYMR273aJalitp4bQPOm1XweDer7CKz3BqEkIl1oxZC0AKIzDJ?=
 =?us-ascii?Q?aXcQwkV3wcBxdtuUVJPPyClMUOd09EAjun842K93sPC9YT9lHPzxMfj9ApWk?=
 =?us-ascii?Q?c8tvnp7PAexN3i9r7Q/WgohgGMSBifjnI+PHYrLCe9U/+IAZjrYbGpYdF6uw?=
 =?us-ascii?Q?Y020TRzPFLaaVkB9GGoXzBcZ8VpAz08VNujFW/cvZKohc/3IJv6BuC68Y7As?=
 =?us-ascii?Q?oJvoYM5pegiwJ+Oipf2O9kaFM6JvYKadazERpThj5Csf6ub9LPjL5iOYVct7?=
 =?us-ascii?Q?i6GGwsi3VcgS/bQMNeK4tkCSwsG0r0bYtvQOkaAiEeDdNsrBfOLYcnMjFZkQ?=
 =?us-ascii?Q?Kw70GlJHZ16b67wD+P/2F/THT1uTQ8wzWMB12em+95xA0/PirMJQ1Xtc0Ldr?=
 =?us-ascii?Q?O93C7hWdgDvhUL9EuyQtcwDCnwImTX3NtK0PWbMoiUtaHTY6+V6t0Sfj0i2+?=
 =?us-ascii?Q?yUsgxD4zAfDWvkKh3FWtr4qdHGb4GNN0tYHTjvcys/h/RWSPsTha46pF65HT?=
 =?us-ascii?Q?4KV5ZHdYn05NNb7uJmK8N9QgVsPPntBZtJjcwhe2Tnqq8qpUmGXEuZspEr+j?=
 =?us-ascii?Q?6EkD3JVrypE/XRQbXNYSLoXMq60XaNRWqsOYmipxfw2YVYhbtzsoh+01oTrb?=
 =?us-ascii?Q?Yj0VPORV635ss2Z7OBEYK8k0WbwMCL+XSVJTup9HleHqi97owXdj+mMQyiAD?=
 =?us-ascii?Q?qpZW6diSbI0xDhjDKMzSBUi6oLUj7FAcnpvCnq68++ipKD7roZfk90BLG9yX?=
 =?us-ascii?Q?SPpnWOdF2tbGE22L7uvvwiWxwyBzVspr/fCXvOhNHxFccAs3sw/fmzJPpp8p?=
 =?us-ascii?Q?3PdG65EC+FWXt+v/9asgEgU263RaU1yWs4guKth9zTrk6qFxSIfbDGuC3iJ2?=
 =?us-ascii?Q?5EJJTI52kZlZ+cYJVOhBh8k3mINNRyTYKjscvuZRwCZgtbnLrmZ0rSNxd4RD?=
 =?us-ascii?Q?YJM3lKYHPys1GTyqVR4/wlrGQ1BdINdtxQXXOogVP5eGTxmsa6CeGSbiA5ZY?=
 =?us-ascii?Q?XPChweePYgYRVxyvDznnzjMwv1UPmjxTL9sVVZCoqR1llw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fwPVr6GXU8WoYCuu4bsSax/hXHjsW6hBmi61RexReUUbTqCcwZkYuoMOLrKp?=
 =?us-ascii?Q?lWRTsGlxuOsKU8OfUkVlkdEIoIY4co8DimGIJvPLqbyZYX7o3CqEEk6T6f7r?=
 =?us-ascii?Q?/Xfgv8O955zKmQJR1Hs4JV7HbBOVeY40Iq0oKAlOJc61iYaB/KY3X80CAk76?=
 =?us-ascii?Q?a+Rg9uPllalYEhUxbHfRa+wXgAHF2kYJ6LWg8/7EhxA3hira6KsVa6Q6NCY2?=
 =?us-ascii?Q?OHX1fbC7rpbvhKDIbZwnZJEJ1G5Kr/s2S/Cw1dPctb4JSjxcAaTQ78ZadCK7?=
 =?us-ascii?Q?foq/y89bcU4+8/SnnEBwVtLM/hnn2btSvfaI2tVMh3eQLob0z6FV7Fd2QEZr?=
 =?us-ascii?Q?s203+h5CUq58ASuFPmGLVl1VcaeN+lvXazTNCEyGA7YrvbKUos9baUNLOjRU?=
 =?us-ascii?Q?ST11XZc3eSFzKadfx89+ZY0i9cL7SIEeTXdH0hHVjLd4wKt4vS2Vg11KfXms?=
 =?us-ascii?Q?iK+GJqtHtMqbu3giN1mxxtnwhaL9/YkA+xoLrVyv5wq3U5wA/MNNUC9Bs99g?=
 =?us-ascii?Q?LD06I37Z+RAXxPNw4Gq14Gw1BaTmxSaE0mVEFgqIlKpbKZAT/4GbbFcNBm77?=
 =?us-ascii?Q?J7ezKzpypIjEYtRk/vtZOIXpxXTEWse6EePFiOYb4tRMS6KH59tvKx2Tr75L?=
 =?us-ascii?Q?QWwyR1TH8iGXUTy31cqGLwO3tdzNS5q4+x4e8HBbDRRamMFCyRyuhdw8Id42?=
 =?us-ascii?Q?+CMHRaXT1RlHSff/XF2tniE1y0ENKHjK+RykUI7EAWOe6U1vOjps4NvtRLbw?=
 =?us-ascii?Q?+c8FsxityiAcDu0r+LqeUWypWpYzq5BrkiO9AFRQHLyXY1EH5lz1qpoQlmOH?=
 =?us-ascii?Q?sJEGCCwAN18uJOTff+9GL+DgHjlKYz2dE5A4m9FX0HWHkjgJK9YYaPwlPRCq?=
 =?us-ascii?Q?Nhlnay4Jm7KTTzxy8Bk1TETrAWfTuAZtiink5SKszD7NtZb1tHDVO8Erl47N?=
 =?us-ascii?Q?LD9+xeoKQFHZFp6m8iFM+2ayM9K4Z2xTdMFcQuZxdAcAcAjxyz+RMW08MWy2?=
 =?us-ascii?Q?7VOyXKNXSR1TlJ7HYCIMo7z2dg2q1u2ffk9RIV6N2gIs4mvCI1avJdUV5QdO?=
 =?us-ascii?Q?ylw/AnM/sdEIa2GwkfaFzzhXALqrUpdIWmXM5dPwDbrCoCVJLdDfa3tTvnsh?=
 =?us-ascii?Q?AdhhVG6yG6MTd+3J6Czln7xIjk8ELJ9DjpzNwjS67TxxAhZs3hW4HKc+mwYV?=
 =?us-ascii?Q?TyszmuXAvZDxtg6bB5TKhBpafKvXf6zzQgQ6vH2XJ3MKXOLvDbhnyZSsWYlL?=
 =?us-ascii?Q?KtnLYTPv1uhXBX6kCXMiVx/4i29rA9gfHMmSjFjXuHbgIe4SaaAU6IacAm9Q?=
 =?us-ascii?Q?ju3musS4rhZtDt58OAr0Xehiu8+i5JnyIYt51FgQ5R1jB+BKSG2+s+tU3t3G?=
 =?us-ascii?Q?Zdqg0dLntdshqYmB/sEmbGOYuLsYs+snPrVBaCx1Y0pEs2QeM05pnpbISqwo?=
 =?us-ascii?Q?ju4IdApY9eYqvGPGlQiEThPkEoRO7if64sulcUzOt7DT9ohe4zFDf2i3soPv?=
 =?us-ascii?Q?GjDoAiZUCVtUNbcSneMimvrnc9vSO9deX8SBck7GyH/fZSGbNhDB4C3delte?=
 =?us-ascii?Q?E1vXfjCvGYi4jLqHuo4Hu4hcr6AswMkZucUuhBMwZwQfmPfj97Hb7YEEtdTU?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e68a909d-5bd1-4031-0ea7-08dcdc4418cc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 02:53:41.2558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhqh4v9WMPoa+ZeLYHB4GLTEJch7XwzbN19bkZssjQoJsiFhGRXzOBgcuf+8Y5Ts9dJbBMjya/vXzW2jRNPAAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6302
X-OriginatorOrg: intel.com

hi, David,

On Mon, Sep 23, 2024 at 08:08:56AM +0100, David Howells wrote:
> kernel test robot <oliver.sang@intel.com> wrote:
> 
> > kernel test robot noticed "xfstests.generic.465.fail" on:
> 
> It works fine for me.  Can you grab the contents of /proc/fs/netfs/stats after
> it has failed?

as below

root@lkp-skl-d05 /tmp# cat /proc/fs/netfs/stats
Reads  : DR=513 RA=0 RF=0 WB=0 WBZ=0
Writes : BW=0 WT=0 DW=261 WP=0 2C=0
ZeroOps: ZR=0 sh=0 sk=0
DownOps: DL=8208 ds=8208 df=0 di=0
CaRdOps: RD=0 rs=0 rf=0
UpldOps: UL=4101 us=4101 uf=0
CaWrOps: WR=0 ws=0 wf=0
Objs   : rr=0 sr=0 foq=0 wsc=0
WbLock : skip=0 wait=0
-- FS-Cache statistics --
Cookies: n=0 v=0 vcol=0 voom=0
Acquire: n=0 ok=0 oom=0
LRU    : n=0 exp=0 rmv=0 drp=0 at=0
Invals : n=0
Updates: n=0 rsz=0 rsn=0
Relinqs: n=0 rtr=0 drop=0
NoSpace: nwr=0 ncr=0 cull=0
IO     : rd=0 wr=0 mis=0


> 
> David
> 
> 
