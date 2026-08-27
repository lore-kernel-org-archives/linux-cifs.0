Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010034.outbound.protection.outlook.com [52.101.84.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27913CB54B
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 21:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787864795; cv=fail; b=k0+c+fU6cl6INu48uIRUg2P4juRYr4ZMn/Q+F6ka/naTePZ2d8BZCwhgd29dbggl9YoM/q18UlfF9so3DNt20rqgY3krCpn1/ukubxo0oSQ/rPzXhSS3q2Q5HW58bqMG2aHATpc/GcjKBj+QyWP7gHd/mmlH23voOtRn0PLa5QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787864795; c=relaxed/simple;
	bh=xAKeLJx+Vd8oznPJjqVIFO7q9ziOO/4zv1H6tx6d2jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vAiQs9M7DQcdsekHJf7ZaROp8UYa2hv65YQK4Hrunm/phYSkWn1JigAnaaqKZXX/Hbr3JCbGEHjsD3g66+0C4EBKsOndzzSYPio5e2TfS0JuQ32UlsIDwakLkO8jkPm0mWFmKMqxYRUgycp1F78cgXVJJK1lDWU4wXCRpM9la8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=t3oNNTYP; arc=fail smtp.client-ip=52.101.84.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="t3oNNTYP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UmHLcihTsQxHZUrLJ3zgN4PrMBvSuRoycqkCE5v4ryGQxS4f5IeHucB1d/kwIORRZmS/pD9K1X81Py7KF818gdyfcJCPmdZ1jkoQb8zx3uTvnVGIge/kF9OJlDG2rqRGX002ZC2PHOLbEeM+5kJ5jrZ2Hx77vQmOCFB1zOSEKRJ13IlwYjT/vEfdHILtoK4LFaks+ioqoPjT9n55hvSPIRuXqUTufwcf+/L73ZYg9TCcqHJ3BPkYJ7FDMkbKgNo9ept7S8LjNft33HLp0pkcooHy0SUoc33/pgIkigPGhe8C6FYU5wjNGlgPorGFO+RYuhxl4S/+O1hjGVGjKvwSeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSF2daRy8xxZK/55j79KDyNbIU+s3jTx4CGqOX4cZcw=;
 b=mjxY1wpSREFvvTEiBEige3exW2gwxM2dwPPerAKyGHfC9oC3IyYyUe+lFd7XST77jr3LVOZGh4deyWql5OGMohSfOSAbqlx8wq1JCCMAyBrqXTAvMr6mOT9UoF44f0aidwj0gwbH9fsG/ZLycNJeFKjpeazWOor+Drj09CIuvxk2a7OxRgziUtGV9HqUd8+ED/f/kn5MpPtomMTr2ISIoz43xl5f628opTeLm0hBoRNtBkBnCwSgi7nTQ/NYhp1H3E+RhfPA/A8BDb2nkck0K36baxbzmVtnw93XcqIEhwkQ8hWzbdIxvRWRquPGjO+cVJyUEF6JnZolhXojNag/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSF2daRy8xxZK/55j79KDyNbIU+s3jTx4CGqOX4cZcw=;
 b=t3oNNTYPLU4de8LkYsnSTZWAeKJLDhVvLl4/iynj8hg6mscK1CEwJ2ejehzVGbj1ZIf88SFy+AifGP1c4egocoxGtmJi0k1P+cYK++r2Gs/EAsEI69sX12S5TO+V0jprV0SaAJkrztm94GhAKsHUWj5zq7aJb9LzcVmmZatAFLB2giA1Nsv/D5JYWHdQe2OZt8rYx+2JGStYC21OX7cTzltBQfl5Q96eFbzyaX+1QwqvGR9bOlem4Rr5rr1UkRtiGRQjAcQgdmnnpeMAP+Vs0ir6CAUqQQy4gS6VdJGMHjKIb0sLJJRen4i475DXbIY2dKE+lxQaKPXirEgvE/25EQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by PRAP189MB1852.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:278::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 21:06:29 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 21:06:29 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
To: Kanishka De Silva <kpskanna1915@gmail.com>
Cc: Yunseong Kim <yunseong.kim@est.tech>,
	linux-cifs@vger.kernel.org
Subject: Re: [SECURITY REPORT] ksmbd IPC: unbounded veto_list_sz OOB read leads to LPE & Kernel Oops (KSMBD-IPC-OOB-2026-001)
Date: Thu, 27 Aug 2026 23:05:32 +0200
Message-ID: <20260827210535.1508421-1-yunseong.kim@est.tech>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKJ0_LemDON6OSAp=sxOs6bBxYYMyvabPXG5Fv9Qn+6q6BcpFw@mail.gmail.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0488.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::13) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|PRAP189MB1852:EE_
X-MS-Office365-Filtering-Correlation-Id: aa838e87-7adf-45b9-44f5-08df047f1027
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|10070799003|366016|6133799003|10067099003|56012099006|5023799004|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	r6iQVaaMq6vp+kh+J5blUPBaSkfxN865BNOCR92uKYcXYCfsX95QN0GSYEYXxCOqWol8O9SS2Jso2SfSy3yZktz28/6by75/qNOMUrWPhqfQ5GG+vkpurFLm2quI3Fm9o0ktWqlKjM5LcuXdybV4vaRfXTyMCS2U6Fjosc/EmaaOemK3KTaAyrtV86IvvYvruscv3rGuny9jx7dlFl8ussXSliyfLYFIK91jJSoxBtF00q34qwhi+TOPRYZqjNBGALic1/YqLKdeXuOoeiW+HZbdgdhCJUonfotofGXGhCHfo3whQ10t5EpHhgEQpeHzwD2pu0pdTbHxNjbByulcOx8iB3gGeRlXLETziyTgClMhA1xlRiX2GsEp9ALdX3crdohWpQoVsbNSzSIxK0oJ6AxB3yFWVnl0sMYi0mF7/bxfUrhzpmaxXdC8bKQpbmjuy6wuCulobC2vMwtSVJoucmSt/cMYd9AHjVmh1FLRziTRq+XfhtZ6bsEhkcx67fh2TTDikum0W1b5k9JPtv3QP0OyHd6m6TAxxqASfFsW4NHSXWN/TuhnzBLhsjRi2P4uAgtVbtjaxW7/x3nx0L44UN4VBcK2KUMyE6+5qVDk2BThO7RTlQwb5NFb1FgVys7eVWY1zaema8Z+yjSdOmC87uqoi8LcVe0szVEqPqZrKjE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(10070799003)(366016)(6133799003)(10067099003)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RFYx2augoaJKKsiO3+3r9V1OS3jfPizx5R2JQRkv6teT0Fdc0V/LuDN3UbKw?=
 =?us-ascii?Q?SEt5AiFrlhkzdM24X8kGzOf3uSEFVdjtSXos0sLS5q5I1xMjDiXb9yGV1DJJ?=
 =?us-ascii?Q?5KZWc9LO5lBa0S0OVPg+aVGIOM08MhwpKijwnzoYolNYqYVQjXflX3PDG7L0?=
 =?us-ascii?Q?p4ZXu2kXA46CTSZQmRcw6rDnhDF7tx3+LZpYZPgGIh4OgsQtYZfBcpA/N3/i?=
 =?us-ascii?Q?Wc7e31cF5YmJjzi1f4qri9rC9uVyumQxMIbhh4cyVlG0989gXTiiWtq7ei2x?=
 =?us-ascii?Q?5B3ZthHRR1OiOyqs4imFfJrW7HMfWIRnFkf3taH3admZPWO3190VNX2h7bJ5?=
 =?us-ascii?Q?NRfNdX/aL0k7GeDSKNDFFXREy9P9ugQecZOolfUAr4BT+poDHKPELcXH7C0U?=
 =?us-ascii?Q?irv8brNJb9aZnqMLw/VpHn1rtfAnNqojAAbRUxVtCDjRsM8rRdBCahguxF2q?=
 =?us-ascii?Q?rj4uberNafKHWCLe35WyUU9mJb3PMvSNqLY9dSMmkxePqS3UPJAp03k6aUci?=
 =?us-ascii?Q?Hr0etNrMUoVd/A86rNYobdV69xHo4peMFE5YL1fJ3LZi1/rGHh6nSMTNd3ND?=
 =?us-ascii?Q?ozgHPp2L2ircFTA4sGdq7VHj6QsKyoeDgZA+LIEJgqcyTKJbmzT4i0aSGD29?=
 =?us-ascii?Q?bMsazo0r8chCOcR2U/twtDxyGQAIMdg8dfZkNDbvgYl5dQmEBQpPOCb6Ey4O?=
 =?us-ascii?Q?HHC1IRpsZyFl9URYT+oTu/HS2E61t1jeLG48J2Sigb5Et0y3AcJu6WkTpsWk?=
 =?us-ascii?Q?dGFQXHJkSlGUYssyL2KcZg8whLDB5jPgf1iXc/+rjhHwfvVdiGkb5aZ1+aAZ?=
 =?us-ascii?Q?r0eTGr0IDqSLYidZwVjw/0zO39CYh5a5DxitiBHF+S8or7NnM33BIx8U9E3/?=
 =?us-ascii?Q?PX0vD0alHwbH8RwkSln7Nvef3yhyr4DIjZzKKxvj+dsYreiseUes8Ts4Y3Lu?=
 =?us-ascii?Q?m0M7IUpAcED/jSW7iI0pu1hFK1vWLfI/crUbfg441ymtZVndTatuyuWhfeVx?=
 =?us-ascii?Q?/jTmfBO5QWSbCm3ZVEm1Su7PTPsXKjFM/NzwCOiU8KgYKoeaOiYxLo5/hboi?=
 =?us-ascii?Q?1NKnGZqvNV8v5AIzryjGrLN2dlTc88gOsxcjORgU81A4Zk0iRfQnSpmkP7SZ?=
 =?us-ascii?Q?1Ebaj6rMsh+jqiwb2z8ykoLXezMR244XoIT6dypgx3FSKXew7n1EUGLLD47K?=
 =?us-ascii?Q?RXjU5Sw51u2QA/gX7/dFMqhz42NvMZ4Tnw+0ckBiYQ6ZGW8ODswPvOu86lN8?=
 =?us-ascii?Q?46Ya+ECUTW6YRaNdIrkjtji1aO5y1imQe7TbaBf+I9IhobXHSRb0XBJ4R4zX?=
 =?us-ascii?Q?PIcMAxTs/ZHK0PqUzMxC1m+cFIMYlzVoCA819JHiPu5Sr7USVeOORzF+x5+z?=
 =?us-ascii?Q?SMHinjccTZtUmhEjvjOdwcl4P/ekdU4atR9xMKAypvJYAg1fh6F95tMLsDCT?=
 =?us-ascii?Q?lU1mA/SQSv8RiUi7bcp1/w9T+2pQ1ZJby6fBMLz2D32WcfCCwOm57NJbNJ50?=
 =?us-ascii?Q?hEiocFmFsqRo6MukeCp0qh+2trjDhEHXtZRuCz88G/vBYoDUgwfbS7kellEh?=
 =?us-ascii?Q?QGIYEYCTCTqY31S+GfYYuoZ0JwlxMeIF2pT+TmxT3LTD3t8ZZjwof3Rz5M+b?=
 =?us-ascii?Q?fbNp/IBPR7l1ljLtNYT4rKlXL06k9867tiyOItgViCGipwpfjeN2X3Km6QBM?=
 =?us-ascii?Q?OHwQ/ERcPM6OuigKOG7rmBk4Tp7SnteSiULW654AJcn+MOoE8HyWwjYIo3nD?=
 =?us-ascii?Q?2e1PK5uuhJC8lVsWVLBaPQ7BksrZaKZN4aqmWwL3EvQO9RjNh4+3X8jue9vw?=
X-MS-Exchange-AntiSpam-MessageData-1: RORIL+61hzizAg==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: aa838e87-7adf-45b9-44f5-08df047f1027
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 21:06:29.0100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvGygqhoMwIOohb89nZslXTeiLl+8VcwrTI/K+PxoGrrsNgqgy+Mytz2CdUFisB9nYcyDhK6AmtVtt4KSJe+qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PRAP189MB1852

On Thu, 27 Aug 2026 21:08:03 +0530 Kanishka De Silva <kpskanna1915@gmail.com> wrote:

Kanishka, Cc a security mailing list with public mailing list is not a right
way. You sent both public and private emails regarding the same issue.

  https://docs.kernel.org/process/security-bugs.html

Read the documentation first. Kernel developers may not react positively
if you have not covered the basics.

> Hi KSMBD Maintainers & Linux Kernel Security Team,
> 
> I have identified and runtime-verified an out-of-bounds read
> vulnerability in the ksmbd subsystem (fs/smb/server/transport_ipc.c)
> on Linux mainline (v7.2-rc range up to commit 73e3f0710014).
> 
> Summary:
> In ipc_validate_msg(), when payload_sz == 0 in
> KSMBD_EVENT_SHARE_CONFIG_RESPONSE, boundary checks are bypassed.
> Consequently, an attacker controlling or forging netlink IPC messages
> can set an arbitrary veto_list_sz. The consumer
> (ksmbd_share_config_path) calculates the path pointer by adding
> veto_list_sz + 1 to the payload base, causing out-of-bounds heap reads
> in kstrndup().
> 
> Impact:
> 1. Steerable Info Leak / Heap Read: Memory contents (or sprayed heap
> markers) are copied into share->path and leaked to dmesg.
> 2. Local Privilege Escalation (LPE): By grooming the heap to inject a
> path (e.g. "/") and setting force_uid=0 / force_gid=0 in the forged
> share config, an unprivileged user can gain full root read/write file
> access on the host.
> 3. Denial of Service: Large veto_list_sz values cause kernel page
> faults and oops in ksmbd-io worker threads.
> 
> I have attached the complete submission package containing the
> detailed report, PoC implementation, remediation patch, and KASAN
> verification logs.

I cannot find any ksmbd-tools configuration file in your attachments.

> Report ID: KSMBD-IPC-OOB-2026-001
> CWE: CWE-125 / CWE-200
> 
> Best regards,
> KANISHKA DE SILVA
> 

It would be better to send a fix patch only after fully understanding the bug,
rather than simply reporting it.

Best regards,
Yunseong
