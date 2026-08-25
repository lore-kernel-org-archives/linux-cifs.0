Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012027.outbound.protection.outlook.com [52.101.66.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85FE23EA94;
	Tue, 25 Aug 2026 23:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787700873; cv=fail; b=amhnrBWfJFsNdZaus067CZQKillkhdTfI4GwEendnTqo3P6BeY0oGM2QEhxc80+O+vmTpcppoaaFX63chcvmbF6RrZ8rroG4Rx4/1kVXHxL8qzBBbOeZVpxMHsh0kB9kX79Noa3gfjFr+UYVrw8+XoR6R5VBPvgLZpVGyEfT2Cc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787700873; c=relaxed/simple;
	bh=ffNYhB4TaRIPtXlxyb/12g2v862MavDZCAE4fYwdM44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fbKVzaZ+D+ir+P5SHn9AEeSp0oHZuUzetbyvXjdNYZtWahsORMA6bpu6cg6luhKs4BeLA5D0qYixlPaIJ6KFAF0A6WArVm6PawGunRwTU7+9v3vKU4B6jz3icjQRCPmLhTfq285pbzXQUS2vrj279OJt+G0R+amDTMuRM/29JVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=A6K7EeoI; arc=fail smtp.client-ip=52.101.66.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="A6K7EeoI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SwE+ihW5/cXDgOW0NfGm5M6hr3GdLwO1PE5pq1PUu4zQqXoizR87VXcZuWv+8KVqBtfIu0nPvyQ71s972S9G0YiyXKc36LtVkx3L4zney5CXK78h7HEW+GsRdZFdKxjEWD/05pw1YcTvn13jL8+CImzcrrHmstLoETr3TqutFeolRuopg4CCF+spL3EPHDmw9W/L6CACTKsvsgECNP4pKlCIWTKfdbgixT2FGuoJpOMGxz5hA6YKJxcG4i03G0etEfpMK2+DEGdlKWg780OiU+wo6rFqFdTgnIzpkLGN1x/Q58dT3IQhRxvfr9rsqrhrXfOcURZYNqNy2HpQ71tpWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WqaN1Em/Iwz62aWvELl3+Z8WQ2K3a9446SaPh5WJJY=;
 b=P1sSW6/P3zObNJhiuQTy0IGb+8d8rnJjGhSuhOZH0ZHekoeNk2gvEC2FMjtqaiFaHK66W0BNm3tlCA98Ehkg3TEKLAaiI7pnqZ67+9aGz82vSg5CXL1ViBZ5x+Rla5sULNPkjXYgpRFhG2DytAKGPtecNJnDkHhuVP6ioJjH80OVy1ZzxlWzJhUY9ZROcpEgKayoz0tov3up9o5zua9pJM6MrKkhGK5wuOVH9ueUOndsdd0YBzWmrtDK2HCB9BWkPyWJJsXiEaMXRgCU6zCSmfcDBycP36NIFlMYzuu9PN6FmlTityL2lmc3DHjjSjWkK1TTJmNtVIsREtIgrzGJPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WqaN1Em/Iwz62aWvELl3+Z8WQ2K3a9446SaPh5WJJY=;
 b=A6K7EeoI4vv6HrTMRSC/UT6yy9ZBGSgU9RZiYg2doKPguFsjsCq91Ckbob/acDkaUCANt9yc4rsn+Vh+VADJJUxdpZ3OHMphs3L6zQywZqbDhyW4KeOoPDJaIo6SfK9E3gntx11ShEXf5JPMGdpTaX2qC71T55LIkx+rD2cjURE7zK24VJ8AKNC8hwKNx+QT7NQwcr6rupQn+asZNq8oDkpH0egjib1+c8iIyi4A7G8umPHyfbPDqKCOc2snqYCNr+6ReCpGWF6bF9GR70TNPyneCMQ51Ji88olRVSUnj7ysS2WpHO0LuPcDZDd8lF4J9AUAOJr4kzOpTI98M/Fypw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by AS1P189MB1936.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:48e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.8; Tue, 25 Aug
 2026 23:34:28 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.006; Tue, 25 Aug 2026
 23:34:27 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Yunseong Kim <yunseong.kim@est.tech>,
	Steve French <stfrench@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH v1 1/1] smb: client: transport: Fix debug printing in __release_mid()
Date: Wed, 26 Aug 2026 01:34:06 +0200
Message-ID: <20260825233419.762040-1-yunseong.kim@est.tech>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260825083043.4037868-1-andriy.shevchenko@linux.intel.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0699.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::6) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|AS1P189MB1936:EE_
X-MS-Office365-Filtering-Correlation-Id: 24e79867-7949-4346-aeb3-08df03016667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|10070799003|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	f6Or4q8vH0s5lpWRSSDu/MSXqNBhAU41xVG63AVHvty8w06CCD1nmu37iKiBx8urKJbrjwNUx1BVQv/79Na0rJKnLEWgToOCjdEGP5Atj/zkgnthjsQXmXc6Mg1DbXkpyKaVmUydPMwTI+Nmp8ZHFo5/xfPJhuyaW4BhHh5XQKbtmXFCq3JDoSlkmBAAweeeYPXrTQITOz9l2W+RAAYkBFQRQTHCqmWBfv/gzDBVJq7+KzpjCruTEhBQtJLyf4XkIg29e7jyAJ/y66PydJIiJ5CZozANAAOdQGSFp9L6Xsb2cvHsWR4ffCeFbZCDA40KmxIvNQCvTVtJ83uXZ553TFedA9/G05Lndx5HDiwV+gAnK1NsVfPiC+gtwLVco//a7d3ueZ7VDwPBkSFlQSe666cjvs7mu1jtVHrEGAZZ7neBVz+ZHz7Xjtz68ob06xwMnDRmt4dRWgdKaTzTvOkh2LodQcAhK0SPWI3tC4hHSJeLia72i7NDgpRYbcnpE3Y2/1Bcm0zWGSp+R6Xk92O1FqMPZPsJfSDAJtehRdEN+99tZukRYdkV7E4661pt9wVnUZcff4Img+5zpF0fpI3yXuB3d9I7HtvPZvrgIfg8lv/8p2UaO+Ow6HkwZueKqkWMULlhEeLnKZSPYmtRLGx9VcP0BjootIA3gH1x8R0xpZU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(10070799003)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fXZc75RhBCbJMpLUP4tMW8KBexg68q8cp3rMJiKUElyP+PgqSeoGsR/fYzgg?=
 =?us-ascii?Q?CH7SSpN/vihddwwDk7PKB+mLTHRzxcIYhAVzxvrz5nuHx1zGfSdqkYCfoczu?=
 =?us-ascii?Q?l6zsUifdxJNvs0s1+07afRgEqc0PnveNAGS8HzktS7c4VsJ7oki62vkSGwEZ?=
 =?us-ascii?Q?xUFCLCr0CZmOEgqouuPTrBHlAeE1J6OaP0t0Wubm597faoIFcx+XPdS/6hzF?=
 =?us-ascii?Q?aIrXJif4QmQluoFshwsQkOxMBQD1CTzR4xXpHoY9iewbDl/EhtISoZatR7hG?=
 =?us-ascii?Q?KOwfXmQpAgERWkUjqQDwrLgPjpfs4PhdjAUa/M4FGvAIgtZ2Xyo8QDowruJZ?=
 =?us-ascii?Q?XrO56mQ7LlMsnMKaZ3O942wA2yJKN2e9MMtdQfn36OUOz5IdyN0SJ4zM4UA9?=
 =?us-ascii?Q?tNItfBI1ccYUHeh9YHJv7PfXX994YpGiR5TThrI97SwVb4XOWRvr7QH4CME9?=
 =?us-ascii?Q?Avj5I0aIEmVbjWA1fgnmYjOvMztceMYUft921TOkalm8hjjBN9YwBbL1laHW?=
 =?us-ascii?Q?VVDHH59iAeV8QfkB76QqREsbOM1l1rLkBdDR3RN6T36jYcs0BjUqC7CCF+XW?=
 =?us-ascii?Q?yAXb8xg08zp7GhOwYvvH5o6jEEwsMkmBXcAvk4yoKcJDA0AYXtYPpXZ9KPNr?=
 =?us-ascii?Q?uSTX/jaoWHLODoGc44tAWGTS+xin0QhdlIFYr0Gc9+yn6aS9fx8Not89IiAu?=
 =?us-ascii?Q?WJrBkBm2NATEfit6Ws1ophSOLm3UHQzJMsGKsQ4f6hVssma8pc2GFWsK4yda?=
 =?us-ascii?Q?K4c/Qgo2T2HussUq7Qhwr2Z335trb1w46n3EIsxeSCbhnkhMkvNlKziHLO6+?=
 =?us-ascii?Q?mRSo3Y/GyHgaA5w+mECWS+DaRJ51Bal9fDj2gZdTdBikfyHsbB8npnBbgoSz?=
 =?us-ascii?Q?csz3/TgzXOB3H8GrOBSua1FOnW8t0WORGB6AdwCwoimC2OpaxXVz5bXWJrkY?=
 =?us-ascii?Q?yk/rAlEg0MP1Xh/u62/aTPEO8sVa23WVREusMfs8ows+CSq0+t9Sujf7iOn1?=
 =?us-ascii?Q?vHXObvI67DHia/Xda+0xkE9g7vkpGB8GlGRYQf9sHSBjgrVanWgANpFjoTU0?=
 =?us-ascii?Q?SbGYo25629M5Xav9SxI2RYNUrPnlh71oZsrZNhlNEqVQjhVkOgUba3v8mTQX?=
 =?us-ascii?Q?qEh+ImYP+NGMq2/M6c4O5Cr7lcv/YwRHE/C3vyaupUo2TLZ0niCr8fdK5szw?=
 =?us-ascii?Q?Xkt3muzjMVA65Gjj89CZ2ljdK68TXeN3B2tI/7GdGOf7HjIMOjTlFHPb6xhP?=
 =?us-ascii?Q?EsofvQc1wuvC2oZifv1nPahduuc/zgZ0BeoHMCXyXmz7ZmsdUsHTul2/JH+H?=
 =?us-ascii?Q?7YcV/1Fh6oFXSokrbDE15LVsDlrOM4XMeBPJQk8bAartk237l48F8pmUXZxY?=
 =?us-ascii?Q?yrUR/gJ4O/qU76iUpPC7LEZVyRLixta7TrVEb9V8xIbDfNJ19bSxMu1pIUf/?=
 =?us-ascii?Q?T/seuOzstW3bCUb9gt4hdIPlj2jo1pSjD2v/l3ki4PbJde9XOn1svj12G16y?=
 =?us-ascii?Q?69nUPzrkhVfqYk5xH4pCThHerC0enQfTyINiWyGdfCTMQ0rc0TNMigekUG1/?=
 =?us-ascii?Q?ECD/W5gofkHD7gm+wzWJlFtP55U+Z8a6UsOOf6KDqZB+Az4fsv3t4RgKXF0o?=
 =?us-ascii?Q?sv+Mf9FpsX1/N4HDHLV0KbMYpxWffVKGsOjzOI6RyYTk+dTFCuYUJ0kY/Xwj?=
 =?us-ascii?Q?/WT6qkdWhzscSahOwqdt5Ew4W0dFnS0TjAF/M8oVuE6Qy0UhmwArDmD/CLTP?=
 =?us-ascii?Q?fpIlUkuGVw5SCwCTjruHy47aA6cK7nlT8Ne+twEaWaVdaxlX4B+tj83m67+E?=
X-MS-Exchange-AntiSpam-MessageData-1: 1vQbh6ukkyd7OQ==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e79867-7949-4346-aeb3-08df03016667
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 23:34:27.3996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txyRtjjre6xITaCadsaUS+6GBIFgR0vGGPbP7/XzheBcPK65M7r0k0U5b7aVeQ0ayXP8B/zfxVulrgwoNf1Kug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1P189MB1936

Hi Andy,

On Tue, 25 Aug 2026 10:30:43 +0200 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Long time ago during upgrading printk():s to the respective pr_<level>()
> calls one misconversion happened and nobody has noticed that. So,
> previously printk(KERN_DEBUG) + printk() worked as one long debug print
> since the trailing '\n' is only present in the followup printk() format
> string. The culprit change missed that and split the message to two on
> the different levels. Restore the original behaviour to make users be
> less confused in the most likely never happen cases of partially getting
> that message.
> 
> Fixes: 0b456f04bcdf ("cifs: convert printk(LEVEL...) to pr_<level>")
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  fs/smb/client/transport.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index fdf4e50c27ce..e266859818a4 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -101,12 +101,11 @@ void __release_mid(struct TCP_Server_Info *server, struct mid_q_entry *midEntry)
>  		trace_smb3_slow_rsp(smb_cmd, midEntry->mid, midEntry->pid,
>  			       midEntry->when_sent, midEntry->when_received);
>  		if (cifsFYI & CIFS_TIMER) {
> -			pr_debug("slow rsp: cmd %d mid %llu",
> -				 midEntry->command, midEntry->mid);
> -			cifs_info("A: 0x%lx S: 0x%lx R: 0x%lx\n",
> -				  now - midEntry->when_alloc,
> -				  now - midEntry->when_sent,
> -				  now - midEntry->when_received);
> +			pr_debug("slow rsp: cmd %d mid %llu A: 0x%lx S: 0x%lx R: 0x%lx\n",
> +				 midEntry->command, midEntry->mid,

The change looks correct to me.

One minor suggestion: could the format string be split using adjacent
string literals to avoid the long source line?

    pr_debug("slow rsp: cmd %d mid %llu "
             "A: 0x%lx S: 0x%lx R: 0x%lx\n",
             ...);

> +				 now - midEntry->when_alloc,
> +				 now - midEntry->when_sent,
> +				 now - midEntry->when_received);
>  		}
>  	}
>  #endif
> -- 
> 2.50.1
> 
> 

Thank you!

Best regards,
Yunseong
