Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010021.outbound.protection.outlook.com [52.101.84.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E0D345EC6;
	Thu, 27 Aug 2026 21:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787865690; cv=fail; b=DqdqyccZdPEEWAK049qNhf9yoqQ7MuRHo1G7FEi+NdoAt1NLHyTM/iCLLe90IWadSM9y5rweKAxiNQrUOq8sC+iOZM9b97x9S89JDDQt7HmJf3o95dZ6iWpCrXX8cH9sgHXV6p6yh2J6Am+avw99SDaqyxJvbYJMNfDNKvk8WxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787865690; c=relaxed/simple;
	bh=cl+y2dzcSVGMg0vt3DbJ0Vq4xnM5Bng07uviUyQFzFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C/meMWZetgmWk2i9xPuEAeUg4Xq+4bb0l8EAM9Y7vplsqCU0TT70ez5PPIRXoVh61nWp+SiMvcMRKSGo74zszHzLP/kqHLhvK2tjDuWUz9joIsP13nsjM2Fd7V9Xycv3Jz1xofBuxV5fs9eS4Xm0YyHhQLzTAwM0N9nVW+d3HyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=smAItZqB; arc=fail smtp.client-ip=52.101.84.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="smAItZqB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=piBRZFjjA2H1VRsKMeKyHEPNVuIJa3HKA/1LiFOiH2Bp+BaLpEchH2ELD023jTamuONPLiTdBjhxFEoP0MjzjY3TZb60r6qAJhZmll5wzLlxj+P57goiU74SJuOJpvfsk1Ah5hVlMpV497dJdxm+Dz2q8edd2CCRhilMt5Ep4rCSih9hc1hBU0oOR7kzX9xWdKVopKQM8mbgCQKTKpeXxfdVrfNQpvIqw4AtbpY68tmlbHmG/LQjl4dBbwj3lunKLIfIrSN41mA9LEC0mskZ2+KWPBoUJBTSrqoAiOibV4cTEBkHhY4J9d5BCtlCzGceE8j+yeqsa97OFOUxPIulfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LT817R2tqviyORLUcOIvxD8CA6iwufS43vZZm6g4l7c=;
 b=GufM2V1BVSafxMBMRSDN/n8JfUnBM1zcfl9SAexcshqBoxu6EhVEv8r6SMub/G7doHuieAGKQg4FYge0YqOhgM4Hm8AbNXXGi1monXMN0eXJYvaplnQRqGRoT96alRONuE3Vsw+VqoBYFmhuLELTIdomwAqTUD7TM49V+vKCAaYwLDBM8A1ug+BRH6WwCBH+DrCixkqrhUKcgSOhaPJRvjcbeGMYrRixvvco5Qlz6XxH1rQ1Rih6GPcxklKex2RgyOU8pdFCvJZmV8ZcE0S33w6GvLnsqF3zKbg6nMiEEmkr5MnrO69W3whGp5OpggxYhEubnan/ZaWJRLhchuYTMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LT817R2tqviyORLUcOIvxD8CA6iwufS43vZZm6g4l7c=;
 b=smAItZqBNuR/8bo7WWZhe0VBspwvpFaFmQl5bGyAyEI6RiDbSABjLnowEGtmRXzJNAkryZ3SVAM9hCWazH3nCTqHEcOnKnVNMLZjNAdtbXWnGjpY0JtniTm1BriEjMg8HmqA7vRD0SXLbBgIMFYv/kGIoeaCHKpBF0UnXmGV8LtmuZS+lAvPeCTbvnwamvUbiYKcXOpRcXJKsx3js7Jt0/EP05API0BtNjgT/sBskoU+doQCONy+9Ce4KMItTg04ABIDS1Lrj4fgu81VwAbKQo8HtDn8Vrw5T6z30Meyd0fstkcdIWqyHaKtJH+b4qN8mQNXuexqsxeSrZXQSC3m9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by DB9P189MB1812.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:327::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 21:21:25 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 21:21:25 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Yunseong Kim <yunseong.kim@est.tech>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ysk@kzalloc.com
Subject: Re: [PATCH 0/4] ksmbd: implement Continuously Available (CA) share support
Date: Thu, 27 Aug 2026 23:21:14 +0200
Message-ID: <20260827212118.1509990-1-yunseong.kim@est.tech>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKYAXd_Pp=197vL1w88d2=Y6yrpbfxzULuR04gDo1Y0-woTinA@mail.gmail.com>
References:
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0158.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::17) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|DB9P189MB1812:EE_
X-MS-Office365-Filtering-Correlation-Id: 725430b6-bbd9-464b-c57c-08df04812674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|23010399003|376014|56012099006|6133799003|10067099003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	4GAnB+pu63j41xY/qSP/Me/OIeRFluYScAf4B71eZ4HQCSO8BA+VxC80n3DLhbGpNzkCpKmGi2+TDzvetmVPbl4ERTZNlfBhpPsw+D7BxcS1JeDiI8ps9a4YDcde7UXRrC/lWtZKlG3TrCGWAnEC3jPcF0eup8MOG+HHIhxM7tLsGW5ukRMyhX1hGNkdXPbuFGfDva1LdMYff85mAQ/99nTeB9YlMSnFex2LQd7NJJ7uc3i44CyNcUkdCDLy0jqY3kHpL+BYk4WV1yo4q3OvwzS0gTTkM3K7B69CE9wACIAlaa3t0UD6edRNlL9ujue3HoHKeIayq+8RaBQdNaK5kJO5LDxPx/m6ooANqdo3+cVNUPl3XgQ9fTSC3FMLLIFAJ/gESfDUAe0L2AIiWv3AsWYnJ/goIMc9iNjwXdUw8Eyz4TTQhIyCmFy9SX+7ZmFXmM7dN1kFoPoG+h5qfdbzWT1aRwLA7AUutK7M0/Br/lUIxS1tUvLerWQzxt8O9rba+mZi1gGPtGs69GzkfEO7qnO0QK670H8HVCi7/daJkbKOawkQ0CpYWVwz5g8avk9SZIRvLGoZ+yysedbdig7STyDB155NhhuOrkwl5ZISIgti8zejcAsOtE0PW+QAwKZtj9WpwpZ343c0qDWrjCkMzdWtKscNxuLi56xsA6LbPkE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(23010399003)(376014)(56012099006)(6133799003)(10067099003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHpHa1pTS0dBTzA2MjBRVFFNUnFISFNDQWgyWktXSndLV2cvR0p5d3ROa015?=
 =?utf-8?B?UFJ0aHdrSC9mSnY0VnNTck01OHpLd3MvcWd4NkNiM3JvZWNhMDdmNDN0Yjdn?=
 =?utf-8?B?alhWZVlaMThvTmxMQVkycFF4YjllYUZHcDVBOXZqVVpJMkdVWFNFVmwxaEtJ?=
 =?utf-8?B?OG0vaUZvTkM4OTgvdUpjbEVkY0RQcTlMalhYQXJib1RVc25rWlNOVG5PRjA5?=
 =?utf-8?B?Z2NsY3pkOFhMd3lvTlQxK0ZmSkpYZnVNVFVBT0svZkNsNDRTSGlVNUpCZGVB?=
 =?utf-8?B?Zi8wUVBTWXpJa0o2aTZiRTkwTUttYVhLSG5VcGdGZytUblhjZUtnQXhIZCs4?=
 =?utf-8?B?bWNSZGhoS2R2TUVSK0ZUVUhvTnN2c3Nqc3NSMEVmaVF3RG95T29LNmxSU1l6?=
 =?utf-8?B?VkdiR0cwNHRodG5haysxVWlBb1NOaytuNyttOXZ2RkdGeXhWc3lpTEtVczY5?=
 =?utf-8?B?TlFOUXJmOW5XdTY5S0JBT2loSzhURUFkd3prY255Y3BRckltUkU0dmJUWHpl?=
 =?utf-8?B?YWVzQVVFQlo1eEZVUzE4SWJoNzVrdFo2c2ZqYlZ3cUt1SDhRUFk2NllCcGtQ?=
 =?utf-8?B?NHhad21GZlo1NXZRMnB5SzFBV3RVc0hlZUhsOWVmdkF0blozVjJYR1g5bUdq?=
 =?utf-8?B?S1N3VkNBL2lkY1M5YURqYzFUKzh6amRNZlBETzhwTFIrTUNEV0FFcFdXakxQ?=
 =?utf-8?B?dndpRXZhbXNzSHVHYUVnVjR5VzQrNUtVREJrc2JxaHl5eDNQUHJTamxodkNC?=
 =?utf-8?B?SmpGLzM2RjdqYXFFdmVnUXZacTJuZUV0RytVTm5TZUZLM08zbjRRL0NDYkc4?=
 =?utf-8?B?YWs0dm1td01CSlRGaU1MSE5KcFRQeHR1eU9LQWNzN212cFYvQ0MvRDFYNnJx?=
 =?utf-8?B?a1UwY2UyRXN5R3NXdGhQVnRFYXJhc0Y5SWlGMjJMdVBDSEdUSXgxVkJmZWtS?=
 =?utf-8?B?ZmlER29BMUV4YlhGZGRRdENKZVhhbFVHZzhXWDRBVnVmN2V5VlpLaUlXR1dM?=
 =?utf-8?B?WnR0UWY2MkVuYnRPckVqSFIxU21lZzBERlFtV1diYjRmRUM3OWZLTGxpWDcw?=
 =?utf-8?B?bG9aSG5JNUNyQjg4OWM2cVlUdWV1MDFLYUNicGRJcE5RRWR4TElGRVplZzZ3?=
 =?utf-8?B?dExGYUt3RHFZRlIraWl0a3owVWVrQkx1VjdEcUsrbHBCSlhXLytHdGZ6OW5B?=
 =?utf-8?B?RnpTWGlnZnVoRWJxd2hxdUUvTVVuR1lvS0RWa2hmcjRmbHNNeFdpY1pXcEhn?=
 =?utf-8?B?Z0ZWZ0ZwQjhBYWJWZk1MY3JDT2FMWmpBZytlc3ZoUWdrbHpyOUdUelRLeTM0?=
 =?utf-8?B?YUtRd1NmY2tBbW5wOEo1blgzVUs0blBjSDNUM0hFd2JEU3FJMGhORHJzWnZu?=
 =?utf-8?B?aEp3WTJNRUVMZHpOYVhZaXQyWHFMaE1oSkNCSmdVaHFwOVR1cC9RbUxobTUw?=
 =?utf-8?B?RWVHUFJwL1ZMdngvZnZHMGJLT3BUckZndWh0N3h1T3VBanZSbThxTHNkR2ta?=
 =?utf-8?B?ZVFsU20vSk05Y1hXSys1dVNTblBaOGpZNUpJOG5qalhNUmpyemQ0OVMramdZ?=
 =?utf-8?B?TjZHQzlPZTdpblozamh3SkhmNjZTNmhNNWV1Z0VhLzlZV2IvaG5nSm5Eb0o1?=
 =?utf-8?B?L0N4djYxbjNrb2RKNDg1a1pWMUdDS2NDaUwzam13WndERVZtREdJWGtTY2RT?=
 =?utf-8?B?Z3d3TXJ5WFRUOFVVNWN3ZVhXS1dzUDZEM2pDYUFJQkNaWFNUYXQwYlV0Y1hW?=
 =?utf-8?B?QVVQYVdXbWtyaUR0VU1KQnh4ZzBKUnE0K1diT3Q1MFo4anhoUG9FcGExVTdB?=
 =?utf-8?B?T2pSQkdpZXZnNVBEVWdQemdaeTN0ZW5qbTIxOEplRUpFOXBtU3FWVy95VWt2?=
 =?utf-8?B?SUR3QUFZTGZHY3B2dGczeUw1ZjY5dFVIVDI2ME9yUmFzR2VMTEdQWjlGektz?=
 =?utf-8?B?TmNPbTJyM0ZiUW1NWXJKalQ3ODFvK1E5QUo4d0lOdXYxK1I3bU5LZU4wNlZM?=
 =?utf-8?B?em5Xa0VJTFhYQy9OYWx6SE55ZGVRVjhESEppWXlRLy85VnFaSjFHMDF3UWVo?=
 =?utf-8?B?Sk5MQ3lXZ0R3YndXeEphRWV6bHd0aGdsWndmWFZuN1IyWXBUa2sydGV5dDhU?=
 =?utf-8?B?cjdWUk1JUE5neFpGc2lQb2RGTXd6dTRhZ3liNFhtNkVwM094Y0txdVo0NWNr?=
 =?utf-8?B?MEY4NlhhSnU5RWpKR08vSXVHWXlNMDlWQVhwVFpNcTlzOXhRNUI3VWdlZVVY?=
 =?utf-8?B?YW03WndWa29yc1JJcmlNZFNYRzBYM25mS3lpVXNoTElGMlhUcm9RT25TYW9l?=
 =?utf-8?B?S1BRRmswMkU1ZFdnSzFwc3FCRFg4QXBBL3gycWtYSkt6ZTMxSVRHV3JUM1Na?=
 =?utf-8?Q?Ym+ZI+yYtHGuGyp/LHCkOGI0RBILa7McvC9Fl9BgwxzUg?=
X-MS-Exchange-AntiSpam-MessageData-1: IIPyV4Vlk/+zrA==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 725430b6-bbd9-464b-c57c-08df04812674
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 21:21:25.3945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4rwYJDyQYFGFs8qk7HYqM+drmLf9QIAnrAMPWqhPvMSDihh6qKzTJShv7JHOar5Vmb4z1OBhJuvyv5Tn52ql1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P189MB1812

Hi Namjae,

On Thu, 27 Aug 2026 16:54:30 +0900 Namjae Jeon <linkinjeon@kernel.org> wrote:

> On Mon, Aug 24, 2026 at 9:56 AM Yunseong Kim <yunseong.kim@est.tech> wrote:
> >
> > Enable the Continuously Available (CA) share infrastructure in ksmbd,
> > allowing SMB clients to request and use persistent handles on configured shares.
> >
> > Background
> > =====
> >
> > KSMBD already has a complete in-memory durable handle v1/v2
> > implementation including the persistent handle data model
> > (fp->is_persistent), protocol parsing (DH2Q with
> > SMB2_DHANDLE_FLAG_PERSISTENT), and reconnect validation (DH2C). However,
> > the server never advertises SMB2_GLOBAL_CAP_PERSISTENT_HANDLES or sets
> > SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY, making this code path unreachable
> > by clients.
> >
> > Per MS-SMB2, a client can only request a persistent handle on a share
> > that advertises SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY. This creates a
> > chicken-and-egg: we cannot test persistent handles without first
> > advertising the CA capability.
> This looks like a useful first step, but I don't think it provides CA
> support yet.

I agree, I was considering the validation aspects when I wrote this
v1 draft patch series.

> The handle state is still kept only in memory. The existing code can
> reconnect a durable handle after a connection or session loss while
> the server is still running, but that state is lost when ksmbd or the
> kernel is restarted. The server therefore can not reconstruct the open
> from the persistent-id or CreateGuid.
 
Thank you for summarizing this information.

> I think this should be implemented in two stages:

> 1. Standalone CA: add a local crash-safe journal/state store and
> recover the open state after a server restart, including
> persistent-handle, lease/oplock, ownership, and replay state.

Okay, I've been starting "Standalone CA" supports for the next v2 patch
series.

> 2. Cluster CA: make the persistent open state available to the node
> that takes over the share, then add cluster ownership management,
> stale-node fencing, and cross-node failover support.

After the standalone version has been verified and merged, I will work on it.

> Standalone CA should be implemented and validated first. Cluster CA,
> including cross-node failover, should then be built on top of it.
> Until standalone recovery is available, advertising the
> persistent-handle and CA capabilities seems premature. It seems that
> many updates will be needed to ksmbd-tools when implementing Cluster
> CA.

Understood, making a solid foundation first.

> Thanks.
> 

Thank you!

Best regards,
Yunseong
