Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11011027.outbound.protection.outlook.com [40.107.192.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805C3173
	for <linux-cifs@vger.kernel.org>; Mon, 31 Mar 2025 19:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.192.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743450480; cv=fail; b=lFyreHFZxpBJCijJIsXxcw785W32Etl0yXhkXMb/e4Eyj11vOn4cr6uMpmTGUF1BpwFz6I+WoUCpTG6GaDZqA63PSiF9sedHUoGt48wyUE8JuqrjcvjhXs92S/w6LHXC3Sj9EYL1CIiaIM8QlBG59j5MOEUlnUwkeuvaNTwLK/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743450480; c=relaxed/simple;
	bh=e7IKmNfqrDFCkBymM/avdjLfr3EZOJ2D36DFjlpp8Ac=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JNcouyCCHQb6YLrojYKOIoZRqNJPG+NLxGzboOFcYSyDpn8mhR/ekH7HRvVaQFsmz62815AtDx2t83V7tRR6Xpd69pBHw7Eb1g+CV4GdmgfAcorworNWHkv2Q6u7fiLrV0SY+tFAwVcLZwEh8a5GWh+WYPIKVd6PR1EFV7pAT60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opentext.com; spf=pass smtp.mailfrom=opentext.com; dkim=pass (1024-bit key) header.d=opentext.com header.i=@opentext.com header.b=MZwHRJOi; arc=fail smtp.client-ip=40.107.192.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opentext.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opentext.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=opentext.com header.i=@opentext.com header.b="MZwHRJOi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QhoYWM3Il0pynRKlbKK6Bj7DXBxk4ddCkqLN+1zO56FFRIoCicaIoM1RAjRmwGOmF3Z/zKEtt8IK2FdvvOmXl16x6PzxP8v93577ZgwdmhvYkJl8BhOxnb1cdJhRhPmJW3eLxuqqsE5+JMIzqWItDcWFbykW5ghQAz9U9Q4BJlv5tr9UegGLPVEMelWL5Irov8EBBZnTo/pnsac+LY+VGPGRlvvDpkI5F25VxX4fZmcwftcr8Yg1JGPy7n9cYgYKrq4VoWjwvfzLhuyWZ3BlTMMZ5OYTmkChrapUwXJN62pRs4972Fcnu01UCHBMUvE8UghrEYRGPviI0+3fH3utmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvKJdwRBUvUCRx5Ep6A3CkJGm0vJDfp9x3p5fxdKdrg=;
 b=wcllp/UKVhPloCf/2SmEZr/C82y0RZ1b7V6QWDb5VpoTHCWurZeeBCcpeb8AC1Q7uEygm+k8czBFV8+3fOqxQyxGFc/9qN8Q0jCILkufj6s4CxsbattVH+dvHAf5g/YK8FKzB5TzHRkKc0bDmaeZi5y2K5+cojCz3ZUOhrFzK4/ndKmT9Dw107O8knAZQIi6t7fs6GtNmngiMNoMWc0ySNTy0Vp5+TWnaqLwWaI4Lmsd2t/n5EVuoaVL/Bd/w17quH8+JlQkyf65djPhmklo8KrZZeIWAh9JLVLp1eXtNWrSfHfxhgp5uP8jcRb5LYs2vRezPHhzsS77rw0kcJjdBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opentext.com; dmarc=pass action=none header.from=opentext.com;
 dkim=pass header.d=opentext.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=opentext.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvKJdwRBUvUCRx5Ep6A3CkJGm0vJDfp9x3p5fxdKdrg=;
 b=MZwHRJOi2asE0XWvUkQN0hsVYNt6MXV1Sa7M1FgnV13rY6tXmW96ju+zWzooTrTG21DmO9PMhaX4/KUtxB6yB6yej/Ti+MPNagnq/IJ/Pr/awX2iRJu/YW+CzsRnTkmpkIf3LrMhokxAiXW9x+jjnP6glqFumD2VKsylLVxAjt4=
Received: from YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:aa::5)
 by YT3PR01MB9804.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:8d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Mon, 31 Mar
 2025 19:47:53 +0000
Received: from YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::a233:82d0:bb5c:678d]) by YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::a233:82d0:bb5c:678d%6]) with mapi id 15.20.8534.045; Mon, 31 Mar 2025
 19:47:53 +0000
From: Mark A Whiting <whitingm@opentext.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
CC: Steve French <smfrench@gmail.com>, "Heckmann, Ilja"
	<heckmann@izw-berlin.de>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "henrique.carvalho@suse.com"
	<henrique.carvalho@suse.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
Thread-Topic: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
Thread-Index: AQHbonXJwSJc2BJO50O65vrBdnChjg==
Date: Mon, 31 Mar 2025 19:47:51 +0000
Message-ID:
 <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
References:
 <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de>
 <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
In-Reply-To: <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opentext.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: YT1PR01MB9451:EE_|YT3PR01MB9804:EE_
x-ms-office365-filtering-correlation-id: ee2fc5cc-9554-434a-892e-08dd708cec68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?NIRl4xlH7y/SGpPt1D/kcC/sklXfbxyflV0wz1w+hTYhf7gfxDZ93ykX/yaG?=
 =?us-ascii?Q?CeLCdnjJWoCSbPgtDh82mDR+ROCtp9dBInfFdKDWAtGbAYIc3ak6R8Gl0y+A?=
 =?us-ascii?Q?JDJ2YEzuN4L+gnVKwmoqLrxsuYwfSNq73LHenIBoJzBwOA6j0uZcqRCfstlh?=
 =?us-ascii?Q?UqylZJDtTOAfkWOvgNWfIEw79B2PW+gQapdzslo6Z0rUt2Ob34WV6/8JGa1k?=
 =?us-ascii?Q?KouBLS88OtpRZoC3XO2mqJq3zrGvqGBbX0PHWwX2Wj5XEWAeoApXk4uei7MB?=
 =?us-ascii?Q?4WBR4UoZ5dWIPYGUy5Cg+OY9vkPi2WRLS+v/kZyQ+K8OR/0+idREn7QDUg5t?=
 =?us-ascii?Q?1VIhSIlKPr3C6Q8RYTnHfk+j9NNnzchxmVrHJQ0taDk6Tu2NQz7VbXij/kvU?=
 =?us-ascii?Q?YBO//BwKrjWCWPrV1qlFXccEuuEhdm5ZNP1O8v7AeHayzqnF2aHz9nLVxXsz?=
 =?us-ascii?Q?Q4cWYj9SJJdo8ShodkoFU0NS3HmLGjuR+9/aEgpF/wp33C9zcLDWiTzit4lB?=
 =?us-ascii?Q?LQuEX5OU1t6W4AWC3Fc3URob/OISBmu5icxeOA73joPLtQ3Rk8JXZ6ao4vNr?=
 =?us-ascii?Q?oWRxUxUfSO0Bg6Qh7lwghWVdXHoTOSV0ZIsJDfS4PYx57Y2CMoMUK5u3w5EP?=
 =?us-ascii?Q?Neb24FyB7O67sMrGL2bObD+INc+O/ChkK9x8wMSoolDFgxmh+lFV47V76GfV?=
 =?us-ascii?Q?DW5mBjCJaDpGf3LNSBPvRT5N7HY5A0OFlGu6YOJfFfqnSHIgog7AlW2lddPD?=
 =?us-ascii?Q?kEnSexoKscmUHMARGfrrGgz9aCF4bPQJ9y8ZT8ENlsY+Yze6xGrFYSw108Ai?=
 =?us-ascii?Q?+fTpIriZqOL2pL04kYSnQ18kMhFJOdikdXTF2RiA/naZ0GfiZg65ZVw5iwl7?=
 =?us-ascii?Q?KK+I6gWcfYlEBGYSlp4G12701AbQxLGEfIBg0BRW6TB8cFlIgXWNe+YHsSej?=
 =?us-ascii?Q?cl4RXZfraWqCFIRUHyi4NKUFwbKzHId3fIz0JCMr4kWpLbdmS+j9edPRmdxF?=
 =?us-ascii?Q?1/L6Ug4miooICpVgKZjqD/Io37L1mOtz440feUphcgUjTjc6cTzfZTSzsrPn?=
 =?us-ascii?Q?rwd8KnSu21NPgHmegYLA318LVGbdiUXe5g3dFgGCIE9W7PjsgukKY6eLUQyB?=
 =?us-ascii?Q?5VlaVp2JV0fMYeYIK0eDBBaso1GgvYFgwK6uvjZp7WJ3ThLaK1t3zhC9yLMy?=
 =?us-ascii?Q?guJFgGSA+i4h3yYYdei+oNGBtAHrAMoEuibFctA1od3bDtAM1zQp0TBZbWBL?=
 =?us-ascii?Q?L8jgQJ897rcQlZXXN3ThNBpFxOYqUL7JDJGELpmLcBwvRl/fqwfC6I0fpBOd?=
 =?us-ascii?Q?nCqa84etlrNjGsMTvNKN7OBwinbpduJFiRVUvHxi6iPgESDmavgvDL4obY9p?=
 =?us-ascii?Q?hjiet9vU8o5GoD5E7/YzdAYqy5Bs8btRNv3/XbcM2dhNFdgLU6ea6yRfmrSV?=
 =?us-ascii?Q?I1j7ptecjs9yj9Y4u5lxyw1e8Y2shR0O?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?fbrajLg2eJEnyPkNm86r/72G1qu8Th1UM33eAQ9kbBATi+IPGyxXChZUREk4?=
 =?us-ascii?Q?Wve4OL4U0w0zk6I3Cl3kRZuRWid+Esqg90gAVUN+gyutTScoJdi8lQpULyfz?=
 =?us-ascii?Q?eSlAYXcxMwYr6wLRZEMi7FiyLrSNsMYIfS1ojdd3jA7bSy4P7hAxYr7KRkAV?=
 =?us-ascii?Q?MemoK3r/UEJs1OtCt6OGFA8DCMeFrIP2lCRX0w5TNVb5CQwx967KYYnwtUXa?=
 =?us-ascii?Q?e4thcSCX6hvM0brl0WRAgp+SqZELQfx6y04RlE++21oFCXFjySnm5P3SbpUX?=
 =?us-ascii?Q?KpPdPEboZByVufZM1+zsyMyTN1AH3T4LvxRXx75O8fA34YvTHIDmPdMD2F7u?=
 =?us-ascii?Q?EzIbWaucUT1zCZx9ZR3H3VhjUbavD9Hmli/aoXvCfoP5R5EWUEsYgPjY94Ik?=
 =?us-ascii?Q?KdUPoLc3vAp/f9FRVha+f++9N0oTbG1SZqlj8UBWDNUB2X3G2XSfybWPYYtc?=
 =?us-ascii?Q?9nGR5qnhBhrrvf2Hxyl5by1nZyVpsuc9BRhRTi80X/pzQSLWr5QohOsMJl5M?=
 =?us-ascii?Q?w29wXQH5N7s+gIbejKt4bvLklOOjx1EX1iMW8HUF8bPei8Lu+sq9mTOMNV69?=
 =?us-ascii?Q?MDUYEFjeCV04wxQZo66dOM0MJC77DT9jI2UzPpm2YVhq54DAPplZ2DJnmnGv?=
 =?us-ascii?Q?065LbcFcepyY9Hx6J7rsnlTWb+XJecrjSstmkxK4OhGuVxWIGbgdmG7+tbzx?=
 =?us-ascii?Q?+pTyQIjaIwaNIVRbD8uaSj2E5mo8JW2frM9041FdRcjWNrH7NsEsEnbbe/DP?=
 =?us-ascii?Q?JACFklXaypGdcEujVoTkrz6sl48jUVApl4qFyfCk6+XUTKP5UZ1UUw4uOCcn?=
 =?us-ascii?Q?9wq1cB+zCGqC0uzitcYpKQ3pTPAdXHLVo5xBO6cpcphLhU/J8sQK/yuAkS2R?=
 =?us-ascii?Q?XgvHZv+oapFkmoncwHaR/VzI7mfP3v1LF3Xs7j4KDMe6+UycgVr43ny7NOHy?=
 =?us-ascii?Q?vZGOQwMhV29OMApmrH7okC/KIgT5fsUy1Lp0uXfom+gBd3Z6hyfR+UaZrZiF?=
 =?us-ascii?Q?OvZMCWFj1lU3Iul8axFMuB1RyWuglwlMpZvrzXrpHQcW/moPKe+Jn3Wi7MR0?=
 =?us-ascii?Q?j4YKnxzAkLI3vNsi74c4lbx2mn7d5eovI5US8COdT9NkQYivaSY0tRZkU/VR?=
 =?us-ascii?Q?FlAdp+5T0kdDaoYoJe2nC9dTbI4A7YdKLcbSIryIgcQ6kFPqVygMnpfkvq8l?=
 =?us-ascii?Q?KoQyAbAxCLtmJZDxMKJKry0tp6zcmZsA0tTiWFE9Wj4gv3kr4MkIiFl3XwMc?=
 =?us-ascii?Q?/NJrnu/L8JxWDF42bCw8GeJ/iuAY4rw8n7YE3xXDotzV+7leq425KyWIEcZY?=
 =?us-ascii?Q?A0Vwc6/fy5ss0c3Y+uUsa2L96xKP1KQ50d2IgwYpFJij0eTNQDev2fchIPIa?=
 =?us-ascii?Q?Z+lFct7xfZ1Ph8vXa+UO7fm2a6mTZPXjmaWd3uLqSE13kwcHcJMjxycTN2wZ?=
 =?us-ascii?Q?63avMOSfufQ7sK64vpMjY4h0+9+m1mlwAgGwj7w80RxIkq9w5QEjpWtlFqaX?=
 =?us-ascii?Q?CnJoOLsv7TxxCAwr5ioHr9T5oPlGi/AkiJ+5RbwNZ/kW33+FzL6DUDB65m9a?=
 =?us-ascii?Q?t3I9P1i/IiCf2zavFSIVCOAp+NGKaUdG49x557i1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: opentext.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ee2fc5cc-9554-434a-892e-08dd708cec68
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2025 19:47:51.9998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 10a18477-d533-4ecd-a78d-916dbd849d7c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OC1Bw9JHB63PoYpG2X6LCr9YWtZ65RpjQX4XCjd3ewk3PdZmxKeJrrKHq3Yx/7Zhbej9MHKwpoIzYbhU0TljoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9804

Hi Enzo,

I now have a couple days of testing done. The good news is that we've run s=
everal terabytes of data through cifs and haven't had a single failure with=
 the patch you provided.

Now for the not as good news. Even though we aren't seeing any data corrupt=
ion or failures. We are regularly and very frequently hitting a WARN_ON in =
cifs_extend_writeback() on line 2866.=20

>for (i =3D 0; i < folio_batch_count(&batch); i++) {
>	folio =3D batch.folios[i];
>	/* The folio should be locked, dirty and not undergoing
>	 * writeback from the loop above.
>	 */
>	if (!folio_clear_dirty_for_io(folio))
>		WARN_ON(1);

Reading through the folio_clear_dirty_for_io() function it appears the only=
 way this would happen is if the folio is clean, i.e., the dirty flag is no=
t set.

>if (folio_test_writeback(folio)) {
>	/*
>	 * For data-integrity syscalls (fsync(), msync()) we must wait for
>	 * the I/O to complete on the page.
>	 * For other cases (!sync), we can just skip this page, even if
>	 * it's dirty.
>	 */
>	if (!sync) {
>		stop =3D false;
>		goto unlock_next;
>	} else {
>		folio_wait_writeback(folio);

Reading through your patch, unless I missed something, this folio_wait_writ=
eback() call is the only addition that could affect the dirty flag indirect=
ly. I'm assuming that when the current writeback is complete it would mark =
the folio clean. Then when it's added to the current batch and later checke=
d, it's clean instead of the dirty flag being set as expected.

Since you wrote the patch, is this expected behavior and that WARN_ON isn't=
 valid anymore? Or is this something I should be worried about?

Thanks,
Mark Whiting


