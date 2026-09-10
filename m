Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazolkn19013072.outbound.protection.outlook.com [52.103.51.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AEB4BFE85;
	Thu, 10 Sep 2026 00:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.51.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788999593; cv=fail; b=l7U0CDTecSUNjemdbaEHaltwX2CtuH4ViH34ckAfPmgzEeamVn5SsoTzXIa3ndm/rLVCeLLciE4lTmit14ZkP/7hUYjQHf6nzXv4qe6FWlzqmTlxOUEQrGM1pP1RImOdIgtbW2O0PK9UHP1VCiLjuyqTPQ/IeMRKSQVQzn+rqjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788999593; c=relaxed/simple;
	bh=fZ5lWMfrrE8HCDFgLlxUzLQRMYyZ3lMVV8vSJioBj/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BlpZKMIY6ZWG8z+q7wdksBrsb+oQvRGtDxb8d6HwYo8vMUr0kEpnOxP9kv0SNU2oB2OyHX4S90pJZgH8HXGycazVwRSXwpIlQkUqQSv2ds9SdPs4qX8y6I1U4PEzwJzpe0wz4NDqJvfEQpjJG5kCkWf7IG7K9eUq0Jw8EAIX/MM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=cao0fQlz; arc=fail smtp.client-ip=52.103.51.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="cao0fQlz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ny3PBGjlSxmQQdDAhbhxGi4HK10Gn/p9nNyduoDfiuHVSs0NYPf4fpnfu0aWXi4KRVPAf/b2GgL0f/PVYjR4ztFB/Dk6yz0SPmh2zRg9i35A2VWaLYSaJlQMREiFdhN3vQjQTcTx2T4uUqRyzCbuR74JVnif1a+i4fXkp2oxcz/wsqoxETgP1Q8diRLhrBsGx59g36hX1JDOwI0ddAVGYwIBbXkRHrvyXGTE1DZAAR1xWb55IBR///MafINSHUEl99oFDoauWUaI660QZnsGcJxCb2DzlssDnkrhfJnxsKbvmaROoiRnjXhLOlZwTcJ/QuXPqCA310AwZGUJJ5s+7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZ5lWMfrrE8HCDFgLlxUzLQRMYyZ3lMVV8vSJioBj/o=;
 b=bXYVsSotY8G5GZzlROORoaYov1v/Y1d3ncB2kNS8DovPjc8FUED340bb8PKUceJXV1BbQF4UjwmKQWoC3Y0qiBJGv2etLIe+qcDoNQtErrPOBAF/zW6N/fkXutaG73Xs775wLyQEOvSPg0XksOz6O7uPOPC77s+hcsLI8oBuM3Z8rN5bU62UBSB7EroLLpbDpF4jB/cdIryzWom9HQNF1WBMu4PQBvy/d6DeE2N2yeKcaIUFS0ruJaXFmvK6EEwR/EucULxNY2MujnLl/phS+HdtWa9lUg5I2AyLLf/Es3fAofOEjShR9Dr2WOvD10W3VbyC78XFA8lsXjy9jTOjMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZ5lWMfrrE8HCDFgLlxUzLQRMYyZ3lMVV8vSJioBj/o=;
 b=cao0fQlzwLKHEGkGuri3J6Cntg8AMMYbuFbYmlQdzhQEXiaVt4KpwjfXKxXCziwwtK8ppsoNRBl7SompTyGrMkX9MZryv8yOFSd1FVFl77h4TyMsauoCzjI0DtL95e2nV8QjnMh8kVrNbyxTaFwQyOuA/ixt91QN8h2VQGxF/ekGkYZkV/V95TfdR48kESr5R1py9sckzTbzcSbHftthEourJOqe1JlJo9/nYlwHuL2+1EcND1gCKF84wueo07JcYpvXVQloa0bZ4HL3/su5dJpnLr7WbWP/xq0VAq6gfVPGfbeVG8zRvikj23k1laNHIl+rwH0J/CM/bX7YznUO4Q==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by AS4P251MB0636.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:4bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 00:19:49 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 00:19:49 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksmbd: fix empty DACL handling in smb_check_perm_dacl()
Date: Thu, 10 Sep 2026 01:19:43 +0100
Message-ID:
 <AS8P251MB0001A092811DB995AD7C21A8C8BF2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <CAKYAXd8N6iFo_uvzyCzGE3QXYfwd0ysG2f_JsNfu5O5yQ=hL=A@mail.gmail.com>
References: <AS8P251MB000193FB2931EC2E2363F2B9C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <CAKYAXd8N6iFo_uvzyCzGE3QXYfwd0ysG2f_JsNfu5O5yQ=hL=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0340.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::21) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260910001944.31944-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|AS4P251MB0636:EE_
X-MS-Office365-Filtering-Correlation-Id: 91f463d5-3ea3-4e81-88d8-08df0ed13a05
X-MS-Exchange-SLBlob-MailProps:
	gMiuAN0LASL4Z831lB8tpzpdpKMUIXWl8rr/IQp2LuqYnGuQjxfYZAwUu/WPtcA/8WriKBpaBr2ttr7oeoI+z5Bgs9vcJJJ/pk7RwhNT7rtego+reEm1CKp/8RIiJ6v1dK8SG+9UO9PTwULBTunigK3ASQ5AUpA4RruDyfzCzMjjfeeEnWhOLJaPAmX2f6lGhJGRqIBKswMA6YoCwtyuGnpYHo+qnE5m4bdbiJnkMT7wASgsgv8nRSKUVBQgo+C2Q2PLa2iRnhp86y0jIUQDX1v/PO3kFi/yea4QQTGKoR90GB5m4xqwXxvsH7PDyS5hP7RuPd4Ht6ROwhZuEfFFwAv2Y7BrjT+lbVibu/7AmW1nIMonz1ZsYfxgNtOXN00moUxwRLEQb6ZB+BDGBCWaI5lXMl77CudWiFxIbLxv3KcZ1ihU+1LbHhj/9x5N2lM7K8lEScwplUOX12ODdmgXUWST4FebYP0bDqXj9I4s8Hk/jhMYxbrE+kBat5vVJXCnv9qoX15t6XKCaltlLjTcUMN2cxeNOptGTQiMZfKR2Sj+eaOzBnFxyzeM5zMN/vGmDow8ephnf4tTTKK9YBauEXVGOM4BUzoysRwOgbUkk8w/VXtD5ma1ljxgw2MG6QHRs8jCmmj6kwotHdZo4VojjoR6uk+25ZMHpzJUBQY3PIao8R2FpZmlWFEvFXz//+1QE3skMLiZAQyEcVma9TDjpQ==
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|55001999006|6090799003|5072599009|25031999004|23021999003|37011999003|25010399006|51005399006|19110799012|12121999013|15080799012|8060799015|440099028|26104999009|3412199025|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHlLeUJmdXpJdkc3TzNNb1RKYXVIenYvUkhWd1FCMzRRSHI3RzVFUXNkRTBs?=
 =?utf-8?B?dEpRUHRlcXhMVDhORkNHMXd2SDVkQXNVNmtodnNtNDE4Zm5Gc0pYc3VCblo0?=
 =?utf-8?B?c0ZkSGVYRmRpdkg3c2duUjQ1M0c5OWt2eFFlbVFvSDdjOXp2c1ZuQ1FmVTVG?=
 =?utf-8?B?b1I3M3NUL2cvaU1USHNRbDVpQ0ZnZFMwRDZWSyswNC9INE1hdU1FT3o1R1Zp?=
 =?utf-8?B?NHJrT3lKTExPZmlDV0ZrQ21yeUJaQ1Z2RUlINm5FTk0vd1JMQlZaVjkzQzRk?=
 =?utf-8?B?YzhFUFFzdWVoeVRBRE42T1EwTERyNXl5TysrZyswcDdiaXlRQkdRTUc5YjVp?=
 =?utf-8?B?NFQwYkl1MDlHWW52a1Q5a0F5QUcvdlRCS2wvRUtZcVFZem5YNzZqOHBGM2lN?=
 =?utf-8?B?dDF5SVEyN0FvOWJKeHQ4RkgxRUxIUnlhT0VUQkM1WW9UQ1ozQ3EvNlY4VXNi?=
 =?utf-8?B?cW5nRXpKN0FneDdSeXNZVEpoeFJUdmNBS1JZZUh3ZFNxcmlvM3NmanhyK05K?=
 =?utf-8?B?S2pVNU5iUi9Oc3FwUDc1VHY5VGFJYUFPb0twODFFY2w3b1FkZUI3Y2VhTnh4?=
 =?utf-8?B?VkNKWU9YWlZLNzJxNkdJNEJ5U3Fxd0VjNUdTNEVxTkdHUVl6K0Q0b3Y0NkE5?=
 =?utf-8?B?UTZWSHZzd0FTWUJheko1dCs1UzhQU291MU1KVTBMb2ZpZU9DOSsvWnY1MXNE?=
 =?utf-8?B?ZWlyUlJBbDJOMDFmTW9TbEZLQ0RmUFphN0NBOENSVmY4Nzd4ZTVwMnY2SXRV?=
 =?utf-8?B?NHBLSExEQ2w5VGcybitkTGsrdG9YL0E4Y2x6N1RxcmY5cnRHRzJsZUxBdzR0?=
 =?utf-8?B?VDB0ZHhPVUVxTWJKSlVPRGNNenVmMEtQeDdBVklIekI2V0doNDZmdU5lY0hW?=
 =?utf-8?B?QnVvcjU4eDhhZU5DWGR0T20xeS94MzdsWTY0b04vQy94U1BwekRqMGp3R2lM?=
 =?utf-8?B?Q24vdmRTcVNxcXh5T0lmaElaK01ITHdNYWs4dWp2TjlGRzY1dFQ0L1hGQ3JO?=
 =?utf-8?B?cHNsQWgvaWlFRU81SCtFdjlaRnBzdlkrVjNGL2t2UHFrNjNRU3dhR0RvTXYv?=
 =?utf-8?B?WTUxMjJpLzEzMWtib3htNldWMlBIRE1ucXNaL1VZWm1QL3RPRjVNK0NoYzdt?=
 =?utf-8?B?Z3o4SmkyZTRUV3JKTGdGQnk3RzVRQTBIVGx0WWdHZ25ZWnlwTVY0UzVVUEFK?=
 =?utf-8?B?SUsxN0hYRjlrN1ptU3RlSTdFTjRPejltVDZSdjYrekU1QUI3U1lXTHZUM21D?=
 =?utf-8?B?Z0dOWktLdGt4aVpUc21OTWZmemE4RzJKT2lIcFVZV3Z5TlhEeHlud09oRzFZ?=
 =?utf-8?B?YXU4c0dzbzd5Z3RmWFlLeXpNZnVFMmxCZWNTQVFSSFZYUXBXN3hPeUNMRG9V?=
 =?utf-8?B?M0NDMDVBbWxEYUo1OVNueUJJQThzSUF1OFV5R01qRHRFVHIxR0JxWFhWdEl4?=
 =?utf-8?B?eGFrWXBUa1pmcGJBZ0RKbkFMYlhBQzMwL2xBWUtHOWdyMmx2UHhJbEtVSHpE?=
 =?utf-8?Q?SNd+Rqsr5EeOIl9Muca0BEBuakL?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WG1QTG14bkNPZThVcjJNc2NVcGU4U0loTktVdXRER0RmeG8vbTBPbUhwWndo?=
 =?utf-8?B?czl1Qy8yTkpGaDNoM0pEeXBtaTRoSk94QzUxY0s5Y09wam44VFhhaU0yeUNh?=
 =?utf-8?B?bE10OE5rVnRQZGtraTRYTHNyQVI3eHlOWHhsWDBMcDlNUkdZRmtYTU9RMml4?=
 =?utf-8?B?dFVDUURLN2dyNURFcWUrc1M2TzJBdTVhSGRiWENGbmF6U0ZCdXN3YUZ6Z3gr?=
 =?utf-8?B?R1ZUWGxXb0xhM3A0OE5HNlZ4bTk4WkNqZVBPWFR6ZnJvaGZmbkhGVXNPM2xj?=
 =?utf-8?B?cHBIWHlhK2gvWktWSVJUbUFpMU0zejI1UTIzaHdDYkNZajdVUjA5YStyVnFS?=
 =?utf-8?B?WnpqaG9lS245dTErWFlvMDhYbDZnbm1xYi91MHljcWlnNW4zODlOdktJaGpw?=
 =?utf-8?B?MWROa0E3bWE5U25Wc0tqSzVQd0ZoeEFsQzFUL25tNmZuNGdvMDJLNDF4STRZ?=
 =?utf-8?B?SVM2QnB5OUszbTlzb3o1bXRUaHBhQ3oyMC9GUXJmdXNjRysrT1hEQzlWWFgy?=
 =?utf-8?B?aU5lNXo0UWFMaEs4NCs0bzlCUGY5aFJZbTBXTTA5SmxGK1F0TTJvalFxQkVy?=
 =?utf-8?B?bWFiQmNXdkRQQmhQcFV2Smc3YUlDU0NZLzRuanVhcDR6Nk01dGJlQUsvWXRM?=
 =?utf-8?B?UlZURlRsQjgzUHozSnkxN1FXSWo3YStxMTFKM05rQlhLR3lkaTluTVBQdm0r?=
 =?utf-8?B?TFFJQVVrZ2VrT3FlaElkdDJsMUsyUW1jWlJVODVUQXVGNjZWcTlwMy81Y3Ri?=
 =?utf-8?B?NEpCNkIvei96a1VXY01qNzY2UFBBeStWMGRTUFBZRVM5ejNGVi95UmhqcmVE?=
 =?utf-8?B?ZWE1Z2JUMTZmU2lJbnVYV0dmaVdSKzhpZlFKZTdMRWFiV3ZQNFplVDFKQVFk?=
 =?utf-8?B?NmowbzNvMGpIcDVISzdsQmlRdjVUeGRPWGlOMW1vOG9XTmtkdERtS0pWSUZK?=
 =?utf-8?B?QWROQnZ4cno4SkJUSEVsai93NEVOd2pKL1J1QXVhT0Uvak1LZDJuTllpaW0x?=
 =?utf-8?B?RERrdnBiWjRBTkV5bUJDcnNYVXpUc21rZUN5dUQ5Wm1MWmVmeEI5TE84Mjl5?=
 =?utf-8?B?Y1I5WUNNcmpYbVNDY3I5SE9QRVpsZXlWTnhKdUtvWllRUUhsTjJDMXZRRG40?=
 =?utf-8?B?bHI5TmdxTFJVYVBaZERHOXUveDhjK0J0ZzRqMkViRmJQdE9DdDErZ09PZnBP?=
 =?utf-8?B?WkI3SW16V1BFS2pFZ0dCaDVGazd2S0ZuVGpNL3N1TDd4OXhjWFBKYTVoa3B1?=
 =?utf-8?B?clRQMjVOM1hnQWxaL1hpcmZwNlBDamlycm9KdGxsQTNlcTkvZGtiVEYzZWlx?=
 =?utf-8?B?ekMyUHVMdjYrSTc1TmJ1d2ppUlAyamVrSlVUNDZlakZkbFBwV3hueHdJd3Fm?=
 =?utf-8?B?OFJvb0p0ZFkwclkrRjIreDgvZGtGWFZ6VFJWRGwxSkRGZ2JCTDFZeTNsS2VT?=
 =?utf-8?B?UmZwUGQzSXBxcm9naUEwZmMvSTZRbWdiU21YaXk0OC9KcDJzdlF3S01USTlX?=
 =?utf-8?B?bEhyYThNK0ViQmg5YVozZ0JGbkt2aGU2R25UUDJ4b2NUQVlsK2lsNmVIM0tp?=
 =?utf-8?B?QThMVW5xK3ZaVnVjZSt4UXpDMGxRc0prUG5TUWxSTmx4MzFBMXpoN1ZpOXpu?=
 =?utf-8?B?YUtyMjNJRHQzcmFhZGR5d1g3bHV6NStVL0ZxM0pPOS9hZVcvQytpeDU4bzlX?=
 =?utf-8?B?YVd0NjBLRXFNWlRsMWFZOVJPbHhqYWwrMG9QWXBqQlBBbDdBaSsvZWs2ODBY?=
 =?utf-8?B?UUZFa0Q1Ym9xaW5JU0cya2JLeWxLcXBHSzlhWkgrOVlyODkwY2NBSEhVVXFZ?=
 =?utf-8?B?QnNYL3kySlN5c3VuV2tMZHdEeG1UajRyRVJkb1hUWU5aN0FHTzUyMUQyVDNO?=
 =?utf-8?B?bWhHUU5hVmgwUGk3MEpaNDk2WjFROHUzMzZPeGIySDl3L0xDUXI3SGdIWStt?=
 =?utf-8?Q?E4Zm3bzm2vPN8awqsmi9iLuZ6NiyEDh0?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f463d5-3ea3-4e81-88d8-08df0ed13a05
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 00:19:49.7355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P251MB0636

On Tue, Sep 08, 2026 at 10:44:37AM +0900, Namjae Jeon wrote:
> This patch is same with "ksmbd: deny access for an empty DACL instead
> of granting the request". It seems like only the patch titles are
> different. Which one should I check?

Yes sorry, they are the same. It was sent by mistake. Please take
"ksmbd: deny access for an empty DACL instead of granting the request"
and drop this one.

Kind Regards

Aamir A.
