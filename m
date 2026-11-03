Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.36
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793697222;
	b=mu0+86SWfCwFPL6mndrCQx+7drWELQxsZLZud7dKe5yXHBgqwY+TUCBgET4xfxIINdiD
	 x4P/HNQYPWXCYT2q5RGHljnsnpWXuCnteiLFJxHZBnPvrw7+qanBbH6eEUeOyGOMeBUTq
	 IMCS/q9/kEZ7QMzks25AzZqDnLjzXXlDG2VRggebYpkGcXvgAz3djba+YvdCoWsgzf3eO
	 QS6ZWfqFYLsSVvWtJhco5meaqIpW2KlzAioUtsXrIGOP5yWcpxve3lo6obR6UPCv0GTBn
	 MvdsdEdUGaEFPuuvqDoyByPibAcHOphv37arqV5TOCYO0Ji8lAz6CnNd8lCT+XDQUVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697222;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=KIAfD6Yql6AKYBeYhml8NxXCuADg6fq8BdcnR8kcYcY=;
	b=fMhT/PI1LkhEbuy/ak5jdODPCw/fi3yu9Wktih38ADhPAJKDAXxNIPNAzJEwIpAzCsTN
	 OqnOL71WH+CjqQQMhooJVLC40oVxStAeXooGUp2XW0UCAzTjF/H0e8Jy4xPcfnxxSkGVO
	 acU4WwQbgZctitmVTSF912u8zRzWFEluYyXIQLoHHcEOGvprNGgCJQOOMww7AI48YcCiP
	 xzclS+3E/ICkKsBFB154Bat1XTvDGoyAxMgufQSPmUWsiVmE6vCxNJl6g904MOW86JIYd
	 S5lowWNA6J5td/DNV0NKPwuUKpQ6N5pNMac0re2NWy+XW3vyLx1Wnvl5KGZx3tF8u9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=est.tech;
	spf=pass smtp.mailfrom=est.tech;
	dkim=pass header.d=est.tech header.i=@est.tech header.a=rsa-sha256 header.s=selector1 header.b=hWSqmBXI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.36
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013036.outbound.protection.outlook.com [40.107.159.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EA5606A32C;
	Tue,  3 Nov 2026 09:13:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16EA5606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=est.tech header.i=@est.tech header.a=rsa-sha256 header.s=selector1 header.b=hWSqmBXI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B7ZI0kGgmfLPH9ugUgWRGnH2zhMksVKglqk1+D76RnwhLHpVbSLQRGoEV3Rvubvcnu/ZjxWLLJhY57C7CbgYpIcBxX7ip60rxwFH4NvqDDsV/+pJs0I2eHNVJo1uIq1QwYnYNF+PXbz/Gej65zAHgrparDgrlhG5TLaz/51QmJd69OMd2NVFLY8CLHzNvs5/LLLZC2gsaxm9k9JnfycYMST7REmjIJitI8+2cgzzff77qIcZL6BrDrSNZOAjTl+Sy5yvEp+D5V7Rde3z2KvUa8pOIzmCgRhXeeWZ4Yp01FxhlaAdQ4kwieGLo8HZKmRUTH49tQGhCjt07KCSbN0O0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KIAfD6Yql6AKYBeYhml8NxXCuADg6fq8BdcnR8kcYcY=;
 b=vtEoUwegvaukPawhh8wmCsu62qh19gs+wmeyC08wRNYhedETVaud23HdjGv2CzezM88nsCAfwx0AcwucINr3mtDZUE8qTr2JQH0Xwe9iidhaAjVYsZZPJAyIIGfIvfFuqGWQSi7PHg5bre8LQUWG9ViKbptyVWmzrrQ89eyVK31ivcxUQts0z8gsMPQ7PVkM1y+7Rex1Zwq7GeeBF2OWOVjFZGatog/4OCXOGp2/yNf+f3VFOMUyMQ8dLJR34Op7BA8v4kdmhEMxu9/wXPOL8W2VFHFYd/Cy7rC4kjgNVrypPyehvk3oT1jHmKvy5ernlE7Qh2HNVDswFd7ONqoyYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KIAfD6Yql6AKYBeYhml8NxXCuADg6fq8BdcnR8kcYcY=;
 b=hWSqmBXIp7l01kAiiLb9Fu+n1kc9wUU9goO6/hloOZMHzOlS8jJjUeTzhnckLd6yHgKcgLMdshBTgyyv15qRQXimI99gqh8YZFtjtjZNYzlnp6+aoHGEIUBncccixCf3P1yj61V8PEnXnjRytnKGuCNprgTvbo/ok2rrSMZFE77VR7KuoQC8wI3Z79WT9+9kWfKx9dAZ79Dss/MEVIeQ2tcbDijZ2x9tUNKIDhgeb7rL9Gu2mf4PpM1nMA/uCVZ9hbPac+aXqNoagPXDmvkawnOlZq6E85tBKz7k7E70LIMi4iu4CALwaa97J4m06x7GOpVRRLZWA6U33VwtE083fg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from FRWP189MB3398.EURP189.PROD.OUTLOOK.COM (2603:10a6:d10:1a3::22)
 by DB9P189MB3527.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:5f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 09:13:38 +0000
Received: from FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 ([fe80::4658:dbd6:d572:896a]) by FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 ([fe80::4658:dbd6:d572:896a%4]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 09:13:38 +0000
Message-ID: <22e50a64-ea78-4ac7-8680-845b7651db07@est.tech>
Date: Tue, 3 Nov 2026 10:13:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] RDMA/iwcm: allow aborting an active connect awaiting
 CONNECT_REPLY
To: Stefan Metzmacher <metze@samba.org>,
 Bernard Metzler <bernard.metzler@linux.dev>,
 Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>,
 Bart Van Assche <bvanassche@acm.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Tom Talpey <tom@talpey.com>, Yunseong Kim <yunseong.kim@ericsson.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260805000159.321645-2-yunseong.kim@est.tech>
 <20260901124103.GL24140@unreal>
 <47142579-3af7-453b-875c-ff6d610f26a7@samba.org>
 <46f83a1c-02ed-4c64-9eeb-2fc435fdfb24@linux.dev>
 <473d9515-b951-4cff-a553-b8ed471d0112@samba.org>
Content-Language: en-US
From: Yunseong Kim <yunseong.kim@est.tech>
In-Reply-To: <473d9515-b951-4cff-a553-b8ed471d0112@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DUZP191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:4f9::12) To FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:d10:1a3::22)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FRWP189MB3398:EE_|DB9P189MB3527:EE_
X-MS-Office365-Filtering-Correlation-Id: caf14dd6-3d17-47ae-629d-08df398abec7
X-LD-Processed: d2585e63-66b9-44b6-a76e-4f4b217d97fd,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|10067099003|18002099003|22082099003|4143699003|11063799006|261022075727099003|261026140227099003|261021123027099003|261026121527099003|261009223027099003|261028144727099003|261022105027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 hDzRfLWVtXQLB/jfqRh4G95SoimZm7YirpOVAOMmQzr4fSBXM9gMSRCv2Q3WIuuLZC6ixSDUriJAmhX5iBy0o82qhe+WHLZWsoW7rn6wADQnTSl0GKvOah+0t/pa9xT3/9td3EulWhgV6JKPtqGtJnh4XE2l3cPaU5CbZj5yrzwWiCWevXMAolZIc4AOQ6E72dZo+u+9DZjwfW8Q9CsuV27aikswb7jQgWm5kkWxwoMCRDy7IbkW7DALpLYVenLI6kVCac4J4bpe2tEUDqK0Tej3i+lZXjRWFJs5mFkT+sMYbrrZ0W+8oelIyBOEYPY7Ubd8u5Ozpe2kyUrvtlxA6GZyka5t1MkKzl2P7mIF4QmY0fRB4D2VhPfhkx8OK0pBuXQhk84YqOSXGRjTLHRDrmIuE0RGeFQLojTOwYDHRedqU1nHELXOy3oro4s7qzO+neWSIFuMsB9Y0G/XWVtst3OH8GeZfP3nxpkOmFkwShdOcDeyxcz7ua2YD13ukmj0XGip+AKOqWhiDaNmrAJT7D5KtqaDw09Rw8m8j/r/joO3Y1PWTrZ0oDPP+QrJ7npxA8zCxzoziIsNTDHR53YB6+Up/pB93g9iqTeZQX2Q7iU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRWP189MB3398.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(10067099003)(18002099003)(22082099003)(4143699003)(11063799006)(261022075727099003)(261026140227099003)(261021123027099003)(261026121527099003)(261009223027099003)(261028144727099003)(261022105027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?a2JNY3hrVXR1YzZkSkU1SERwU2NGY2RIUmJ4MUJreDFFcEhKbTZ0MHI5Lzha?=
 =?utf-8?B?ZDY2YnBLd3EvcTVselVrb0NtZEF2M08zaXhKZy95aVVkRDFPd3Y0ZHB2QUp6?=
 =?utf-8?B?b09oNTlQOUlmQVVGckhJeW92WE9Wc3RPUThpU0FWK0ZVc2EyL055dTA3eEpL?=
 =?utf-8?B?MU5IZnhXNlhqTjhyaE5MWEE5NzBTUW5KemRGaEpjbU5ZNGw0czJ5Y1ZuS2FY?=
 =?utf-8?B?aUl2SjAvb3ZybmM4dTI0UVFsdmd2RGN5b2dILzlLUDUyVHRZQWY5MHJPaUQ0?=
 =?utf-8?B?WUo1cmFRNmdWcHp0VnlJRXNlemhmb2l4WjBRTHAvUE5nSndzQk1ic2ROOUNS?=
 =?utf-8?B?c3VWdlMyLy9EN3BJdzVjVk96SlFGQm5Xa3FQanoyZGNvT0YwbE5pdW9NUmxY?=
 =?utf-8?B?S1FoNStodk9tUjZEaFZQc05JTjBjNi9EY3NESXpscm1YR3luU2xNeGwvdnYr?=
 =?utf-8?B?b24yT2p0TXFqdEtYS1RkY3FDVmhxeUsycHNpUnpHbXFybCtNS0NSandlc0VV?=
 =?utf-8?B?eHZTcWVTT0R3MjBlb09qOHFDcTQ1dE9MOEd4VVlvY29OR3R2UFlpUW03NFdO?=
 =?utf-8?B?ck00akd0WXpsQ3hZaTJDelJ0T0pLWFJ5WStkMVhvR2FQQllDRHhVbGh4cGU1?=
 =?utf-8?B?a24xU3RCSjBHa0p2QTlmQnR3MTUwSVJoTVY1NGZGdkM1TWtIcWtYYVNBNzJh?=
 =?utf-8?B?OWo2bWk4S0crd1llMUZ5SE14RU9vcUJFVTdUSFJzSU0rZzVwOENXaDR4VGMz?=
 =?utf-8?B?a2YwV0w3RS9Nc0tUemtySkJmZFdzT0xoQ0tHWWhSQytlZ3ZIVktDQkNVbG9C?=
 =?utf-8?B?VzRFUHFVMTVWWXI1NlBDd3RWNjRuY0UwRzBzdGlMcm5TZEZNNGNZbzA4N3lk?=
 =?utf-8?B?N2xvQlBHWGtrbUFlOHRCa0pSZnZFbUZraFc3bmpuODJJdVU0ZUx1MkFOTll2?=
 =?utf-8?B?cEJjNHhmSG5oTzBuQllaK240WjNZN1VqTVBWd1FFcHZ1aXdJWTd2MmtuK0dz?=
 =?utf-8?B?VkQ3L3Zad0VoQjJxSmtxd0t6MlNRMFpSS1JhZUE3NDBCY1NSR3pvQU5vRC9t?=
 =?utf-8?B?S2EwR2NRYmJ2UjhGRlAyVDN1VDFyc0gyY0ZweENQVVhqNlhYTEdzbmtMVE5u?=
 =?utf-8?B?K3ZzWEFkUHhXbmVxQ2J5cTVza2pSRVJXZ0xtWkFWQWtlTnd1VGtNZmZLVzVo?=
 =?utf-8?B?bUxGZ0ZmSXJsVkEreWRoZEVnVGVUOTlIb1kvdlFOWUNqMUN1akVCUFBLRUJG?=
 =?utf-8?B?OHJzeWZyL0Zka2liWFpMbUpmL0pPcDhSYU01b3BqUkhYa3lLWDU2aDRzV1c2?=
 =?utf-8?B?SGV5TEpDaENyanJsRDhrM2dYVFg0RjNQS0w0alA4TUJNbi9FUlRHazcvRUhQ?=
 =?utf-8?B?S0xYdFRHc0sxUVF2RCtBdldISktzSUo5cXRHSjh5ZDltL3lUUHdBd1BkeStk?=
 =?utf-8?B?M3M0bGZ0dmtuWHM5clRKRUNmZTFpc3ROUjF2OWpGMTVVRStNRHFrTVo2S2xk?=
 =?utf-8?B?ZXFlZXppUXRqeUluYWFDZHVMSWhNTVJsRms1cnUrejBncUIwajBqdDduVkRk?=
 =?utf-8?B?eGNQbUhGVlp1SDUySEUxUGtQK1VXQnVUZlpoVkRBYmdUUUNXdXFIV0hkSkVn?=
 =?utf-8?B?VzlsckFMaWZ0aEtEbEoxQkNtdlFEb1RTSEdnRFU0Nk0vQnVPVGlCRERFRUJK?=
 =?utf-8?B?ejE3NzA5S0ErbnZ6SW9JYlo1VjJFWHE3ZjVSQnBIN1J1SDdhQ2Q2NlIxV3Rv?=
 =?utf-8?B?dG0wNEYvV1QzRmE0ODRxWndENDJidGdwNjhFeTQxaThWRGpmanpHczVTa0Uw?=
 =?utf-8?B?NGc0ZlZoaGh5TjJmbmljc21FY2ZvMzdSZWxZUFg4QjJEV2FkbERDQXlmMXBa?=
 =?utf-8?B?cHNZOTAxOVVTeEJxTWVsL1RtZUx6eExnZW95OHVubmxhWDZ3TlN5VUwvUG4z?=
 =?utf-8?B?ZEZzbm53Q2tCcFcrNzRWVkh5QzhxdzdZOER4dVVnSFptL2FPcmQra2lFNHRh?=
 =?utf-8?B?WC85b05XMHkrS3FPV2drKy9yUE9hWjRYZTM4TzdEbTZVY01JZHdSWFNSMjda?=
 =?utf-8?B?c0RwekY4S2VTZGowWjRHOUJoSmpFWU9NWFNMdWs3S0lMeFdOSnR5YytHL2Mv?=
 =?utf-8?B?RFROaEE4bHdqTXRyeXVwRXZIQ3JzblZKbUVtakZZTEptRytwSFJxQm12V1No?=
 =?utf-8?B?TEJwVHY4b210a0dwc0NXWDNLb0tIZk5RZS9BQU51QVVxWm5UbEMwYkxoUS9x?=
 =?utf-8?B?Q25sVWNKYjZzZDFrUVFTNFhocnIyd2Ntem9WbkJBbDZyTzBtZ2lTMEkvZFJp?=
 =?utf-8?B?eUxNSENmV2NuSjVFRVY2TlBnOU5heW5JcG8rcTErWVo0dHIvTk0wZz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: caf14dd6-3d17-47ae-629d-08df398abec7
X-MS-Exchange-CrossTenant-AuthSource: FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 09:13:38.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x6WqB+XZ7JntxW0COBQTrH/WoTwNU1nbB8djWPnlUqkZGJYuSIKiaJUkNtGS9/X3qwJO8qADlPx88JuE76aYVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P189MB3527

Hi Stefan,

On 16/10/2026 11:25 am, Stefan Metzmacher wrote:
> Am 03.09.26 um 12:42 schrieb Bernard Metzler:
>> On 01.09.2026 18:50, Stefan Metzmacher wrote:
>>> Hi Leon,
>>>
>>>> On Wed, Aug 05, 2026 at 02:02:00AM +0200, Yunseong Kim wrote:
>>>>> [snip...]
> It actually still hangs in here:
> 
>     For an active iWarp connect that is still waiting for the MPA reply
>     (e.g. the peer accepted the TCP connection, but never answers the
>     MPA request), irdma doesn't flush the marker before the pending
>     connect is aborted, which only happens in rdma_destroy_id().
>     smbdirect_socket_destroy_sync() calls ib_drain_qp() before that, so
>     it waits forever:
> 
>       __ib_drain_sq+0x139/0x1b0 [ib_core]
>       ib_drain_sq+0x7f/0x90 [ib_core]
>       ib_drain_qp+0x16/0x40 [ib_core]
>       smbdirect_socket_destroy_sync+0x2bd/0xa90 [smbdirect]
>       smbdirect_socket_release+0x61/0xb0 [smbdirect]
>       smbd_get_connection+0x22c/0x280 [cifs]
> 
> 
> Here's my work in progress branch to fix these problems:
> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.3/rdma-backport-testing

Thank you again for checking this!

> There I'm able to eliminate all hangs I was able to reproduce with siw, rxe, iw_cxgb4, irdma, mlx5_ib.
> I tested the following situations:
> - server iptables drop (port 5445 and 4791)
> - server nc -lk 5445 (tcp connection accepted by no responses)
> - ip address del (on the client)
> - ip link down (on the client)
> 
> It likely takes a while until I rechecked all commits
> and submit them in small chunks, but it's good to see
> that it's possible to avoid deadlocks or very large timeouts.
> 
> So at least that patch doesn't solve all problems.
> 
> metze

I'll also rerun my automated tests based on your branch when I have some time.

Best regards,
Yunseong

