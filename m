Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D66B179AC
	for <linux-cifs@vger.kernel.org>; Wed,  3 Jan 2024 06:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q3cE/f16"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704264942; x=1735800942;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=0FKsKRvGBItJ7UFI7ejeLfxL2EZOKHi3JZjsnigYBag=;
  b=Q3cE/f16gkgE+qFhyvUfiG5rwrvsZLg/yyHtD18uUDKF9LHKWbtDbQSO
   Fc7R8gdAu15L2XheCOjWCafYAEYwDtgPQFn/lu1IOfdG+KS3jjuktLJZo
   yr/65jdjM9X7G+1umNLr5uQSZcohIPpEuBhQoEy/PWYTEJFUvEPK4CYHg
   th6wqAGOQFicw1NfL+5Aaeap+NeUjaBRIG/gKLzAfkeSGKCuTyvrMN/jV
   qaLViwWhTXCGXXZTS9NZifg2nRA0b/x0c6USgDWTxWadDIDcphb4wr9Xb
   RZnvgpNlDzkZi6isFki/S3MU7WAk8N454jHYWjmZHqXca3JqQ9mBGEilE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="399740177"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="399740177"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 22:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="923449443"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="923449443"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Jan 2024 22:55:41 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Jan 2024 22:55:41 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 2 Jan 2024 22:55:41 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Jan 2024 22:55:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTMvA4NwEtYXmCYmlTQeGddjIfE3fokI+/JsrY6r6ySGHu5vy56NCcUnbYAs4so8eH9O+KF5PI77M+xNR1SKcX1/40gXaBo0m0gV2DqsHKiQPJ6AEi3UrUiyvc0ANRQdbcCvYgVBq3HALe/kDV77R+K+JGX4iJHz+94ptpdzT4JkXEU7yw2ntM82X8ZqEXml2qQgxqf4stJvTWeXGpR7EtKku69geBfteh5ZFJJMWB5flq0y7hXsi7DOx5MrMrjBG1K6CGTOxXgjC7rJi1jiNoba+EqMouwLRQ4ndTt3PXfmhinAy0gwTj8+uffKPseH9Ne7ht/fajDVee3c6lZC0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WVaJ+dCH3H3aw/K42SkxXIHqxRkUMMa2ha7EFkzkwQ=;
 b=IwLYRc2ATbvJETP9nlig6ZnazmtMF8fau1qbzBH9qp/eLQ5JmelmitymlzfofCmCPBwIKiUsBJ54cbrbxUV7lJcrR74mUebvYbOLZOVlpOC6ubJ9Vbbvi2j4Qtp0t7mULeUAiX++rjkZXi2jkI+ql6RA7y611EgIzSDsng2sjJIdmJ6kE6HOX/X3JjlmAmu5rQ+hPso43kJUO/HSzA2f9YYrEEG54nNrhBhy87c9jlcFyk71pOdCgMx+n6DJ2JBNv8A+amDS46RrOBt7zYMC9JwGnqhVvZNKLSPzTCbU9FAxZ5JblsgwQ2ORvB98vMSdZkH4agXeilybx9yQZARAzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SN7PR11MB6776.namprd11.prod.outlook.com (2603:10b6:806:263::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Wed, 3 Jan
 2024 06:55:39 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f%3]) with mapi id 15.20.7135.023; Wed, 3 Jan 2024
 06:55:38 +0000
Date: Wed, 3 Jan 2024 14:55:27 +0800
From: kernel test robot <oliver.sang@intel.com>
To: <meetakshisetiyaoss@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <sfrench@samba.org>, <pc@manguebit.com>,
	<lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
	<nspmangalore@gmail.com>, <bharathsm.hsk@gmail.com>, Meetakshi Setiya
	<msetiya@microsoft.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH 1/2] smb: client: reuse file lease key in compound
 operations
Message-ID: <202401031449.d24cef1f-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
X-ClientProxiedBy: SG2PR02CA0137.apcprd02.prod.outlook.com
 (2603:1096:4:188::17) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SN7PR11MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 59d057ed-03a8-473a-106c-08dc0c28fdf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hTMU7yVf1pXb4NsM6ozdTEyoDJmY7fQPaYUfz0xGDoSS7XoFpQMNpMSl7qAfpBE58XG2NFNNeITwYav4P95bXdFUMisVweV57T50njN8B1kOKozry61XKMW1M18xnSoQJKUS+lH/j9bWApfieRWE3F88I7bsJeyNNOUw+/cHHYzRZWMuTMSCw+o3Mi6PVI37FTrEsMTeu2UBVQ8UlBE4rOpkK/97EYo6MPqJwzXXxTgKp/IcZSUTQdQMhnKrmnGUJknwAtIjF7aAqZ7gAxGqkoAFmNk8fGO6XIA16rbg5gNy3303cj87GZqL/PTLL8SvOtX4tc8Lz10+fgFqaIDxegJb88s03xQRneiDdVh9T61yZnNCplnrHeFnQe9afoSEi7Sq+sXkrvpmMUgkj4mVdM+VHeryzyvAZ1kN6w0JXfuCA+mrZUcmpwybOKLldiVDveLARJjpOsziD7kBwmFKIpFKjLOpb6Oa2+xEkitd9L4TdqUVcnwVxyBnYHbWwHUdEEKLPdurlC/gXHH1nwDa/6/rFPNUOCmquh/6DHMeN7nMrWE1D9OAQCFznUk/dTJ/p8ioHIR2nRIaLuyiElPz5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(346002)(366004)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(36756003)(6916009)(66476007)(6512007)(6506007)(66946007)(66556008)(6486002)(86362001)(107886003)(38100700002)(82960400001)(83380400001)(1076003)(2616005)(26005)(2906002)(478600001)(6666004)(7416002)(5660300002)(4001150100001)(966005)(41300700001)(8676002)(316002)(8936002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1SnhmfCXOOLnBiCQVqtBzeMg4uf3BTsv/wbP+iyDrd7rNfeXblU19Go3HJik?=
 =?us-ascii?Q?lMc0wdcmxCz9u8aSTg2Us+ZZjA52GCMfhuwcbYdfgyfQC1lKbQFquDD9vAYI?=
 =?us-ascii?Q?5a+cOvo6nRrvAgFMYFt2A7S2uH76GbDQ9qI7yCXbvloXCVJsBM61mw4vLLKY?=
 =?us-ascii?Q?+9Ze1j3+PTi3XmkdBpVDF1T6vHLw61LFeD+mb7ITYkU+n1wSMWD6iCRQsFCO?=
 =?us-ascii?Q?bTK9tHdhHE037gIKPDkRVyXR/KPtYPzLJ0jqU4kUM7gQ/45VsvBa43rBQzr9?=
 =?us-ascii?Q?evpWz2CEDzMuNAxh74J/PGDln/iFtxAGlwZL3lzavhpPdng3l2D1b39xPzJx?=
 =?us-ascii?Q?sV/n06iwmhnrMEi2WqWggUBPaQ3sKHwsZyBotJR4xGiKmBHgwGykKkIYpqG9?=
 =?us-ascii?Q?4OrHU06YkCg2NKuw8SfL9LogClvNn+cgaDaMUwjsTfu4sBXhoqXGNLcrdKcO?=
 =?us-ascii?Q?Pzh+r0jiLfFoWtI3lbESWSi/Pzg1RbN455LQnpE/5o4JzkePE9uOtxZjzlBs?=
 =?us-ascii?Q?HcQU4ZoAYaAwmYzyixylp0zXUzsM+a8VMFqVOfzU/bXgt9+wJgfxhiPHE/2Z?=
 =?us-ascii?Q?kCf24Sd/Z89ZWhLw7nUNZ4xjLQjwPThIJSHdpquEhnpIvz+AHDA22YYgqO1s?=
 =?us-ascii?Q?ozma1fd5WbU61tukLVSpTaF/nGl5Vgc0Cx8fg8LC9joMXHD9oTVR5RLau+9H?=
 =?us-ascii?Q?D1ygN/NCjve4u2HUPB3In7t/FmERN9yvmGdU10vNCayaWtUGsIzk7TEBh3s2?=
 =?us-ascii?Q?bLQZFfHw3S1/EgjjTjve1uFoFA65X8V5nuM38+OMR717M+N2J4tsfTCv22qE?=
 =?us-ascii?Q?qeFBXEVuB+VlLJ4Of2preNNaEsVHSzVBReemwvMxWd/9x5SDuWHG/jDCTzU+?=
 =?us-ascii?Q?dXVlv76xQiXktjLe9YQ86HUS0ZnuJNwakt3HQyhadrxqhczUEpsNEjo4sWXC?=
 =?us-ascii?Q?Jd6SRWZQMKP0IAZ3S3tLdpKzjNy2G1YF6zwm/JrKlMhYXeV5Ue4FpczsN8Ak?=
 =?us-ascii?Q?Y8Ag+iizNTKjXGuLsjhtnw6u2jzr8R04bARw28te9y8FiSjae0aoxINs0RtF?=
 =?us-ascii?Q?x3iN10Lhb3XRuQlv9OSJ9tQuFzKxLeAf4r92ka2PEkc0VkRwt/b4I4Y1ITwD?=
 =?us-ascii?Q?qaXEHJ99nViuuGwKTqI4YCFWnTA6nWnAd+ImCI5KQpE/Sc9mrRMW+UmIN49n?=
 =?us-ascii?Q?3S6slTegdaL2092424I/NCTwWng4JtURcHmzvutB3VUqDnyP3eGjzl8ou/Zb?=
 =?us-ascii?Q?2qnrDsGvM1jSJrLCRLg+AuB9D8Iz0ithQD7dD46+Mhac0v3LHww1eccNZwnX?=
 =?us-ascii?Q?oB1B/M6MY1iMmKEFaBdvbmfcpShbFZkQqSK0fiATAqg4REtpzyQpFrs6zGUR?=
 =?us-ascii?Q?FFgbj22v5sptKIi+yPlKq6XKFNoleyAQQlsYhvzDzwSAektPD7QHS6oU0RAE?=
 =?us-ascii?Q?a8/9DRwEPYoKWLWQ5U1II720jfbvHQjgMkK9+b5drp02W08/UYNxYe4kyZKN?=
 =?us-ascii?Q?iT6dp0PeZLrksA2ORgkUf6BEzpj6eL8+npBkY0xkds9iiR/mIH25m0dq76Db?=
 =?us-ascii?Q?USg0jav1J495W+60almyHJktkp/VGOK9PxtSFjOEvrecMkahW82yMldN3Aoj?=
 =?us-ascii?Q?nQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d057ed-03a8-473a-106c-08dc0c28fdf8
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2024 06:55:38.2548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C7jnGywH9g5jyIjm1SWW+lCCAe1MUm/mnjuKZTXb6dJA5DxXGiu6Q/M7Rp/Wb32NF/oQNYgcnQgTVGdLGzxxDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6776
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.generic.591.fail" on:

commit: 3334196d7efd8db2a7a850331d01c3c4627879ff ("[PATCH 1/2] smb: client: reuse file lease key in compound operations")
url: https://github.com/intel-lab-lkp/linux/commits/meetakshisetiyaoss-gmail-com/smb-client-retry-compound-request-without-reusing-lease/20231229-223806
base: git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link: https://lore.kernel.org/all/20231229143521.44880-1-meetakshisetiyaoss@gmail.com/
patch subject: [PATCH 1/2] smb: client: reuse file lease key in compound operations

in testcase: xfstests
version: xfstests-x86_64-f814a0d8-1_20231225
with following parameters:

	disk: 4HDD
	fs: ext4
	fs2: smbv3
	test: generic-591



compiler: gcc-12
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202401031449.d24cef1f-oliver.sang@intel.com

2023-12-31 06:57:39 mount /dev/sdb1 /fs/sdb1
2023-12-31 06:57:40 mkdir -p /smbv3//cifs/sdb1
2023-12-31 06:57:40 export FSTYP=cifs
2023-12-31 06:57:40 export TEST_DEV=//localhost/fs/sdb1
2023-12-31 06:57:40 export TEST_DIR=/smbv3//cifs/sdb1
2023-12-31 06:57:40 export CIFS_MOUNT_OPTIONS=-ousername=root,password=pass,noperm,vers=3.0,mfsymlinks,actimeo=0
2023-12-31 06:57:40 echo generic/591
2023-12-31 06:57:40 ./check -E tests/cifs/exclude.incompatible-smb3.txt -E tests/cifs/exclude.very-slow.txt generic/591
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 lkp-skl-d05 6.7.0-rc7-00010-g3334196d7efd #1 SMP PREEMPT_DYNAMIC Sun Dec 31 14:28:02 CST 2023

generic/591       - output mismatch (see /lkp/benchmarks/xfstests/results//generic/591.out.bad)
    --- tests/generic/591.out	2023-12-25 18:24:02.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/591.out.bad	2023-12-31 07:00:17.990085717 +0000
    @@ -2,4 +2,6 @@
     concurrent reader with O_DIRECT
     concurrent reader without O_DIRECT
     sequential reader with O_DIRECT
    +splice-test: open: /smbv3/cifs/sdb1/a: No such file or directory
     sequential reader without O_DIRECT
    +splice-test: open: /smbv3/cifs/sdb1/a: No such file or directory
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/591.out /lkp/benchmarks/xfstests/results//generic/591.out.bad'  to see the entire diff)
Ran: generic/591
Failures: generic/591
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240103/202401031449.d24cef1f-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

