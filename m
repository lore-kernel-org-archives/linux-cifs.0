Received: from clt-mbsout-01.mbs.boeing.net (clt-mbsout-01.mbs.boeing.net [130.76.144.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0503416F8F5
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jul 2024 17:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=130.76.144.162
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720806730; cv=fail; b=rR6jr3VXucnDCqwqF/bdUjosnLJsQX+9sKwnQAoF24+okXzqOFZ0SnKW5F/zbBKMf3rVUGl/osz88FOsu60wYw9KoyTkHbMGuagR/jDjqe8WxCd8XFXQK32+BDevXc/rSaQRZvs7T5T1kTlkX9pYjMqKP9p6hK4uoA6WH1i5n2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720806730; c=relaxed/simple;
	bh=2eXtg+cIG/YgtceXqIdR6HRZHHqtQNXAugzp7EtyjmU=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nSLL/5QD9MKrOpnMyyk6SlMmJ8xGm97erLdmE1uTj3NoUWqEG6gSNMRyJDHIu1zO858qU1HVsH4yEeG/xl7Wewr0M4y74RVpFyJIOH9ttoHafVyoyj6JgzJnyFh/glBN/5VumMNomsua6A786kz0N3o5c2+VLErfRlRh+piyRZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=boeing.com; spf=pass smtp.mailfrom=boeing.com; dkim=pass (2048-bit key) header.d=boeing.com header.i=@boeing.com header.b=Gqa0Nr3N; dkim=pass (1024-bit key) header.d=boeing.onmicrosoft.com header.i=@boeing.onmicrosoft.com header.b=mjXjTADf; arc=fail smtp.client-ip=130.76.144.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=boeing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=boeing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=boeing.com header.i=@boeing.com header.b="Gqa0Nr3N";
	dkim=pass (1024-bit key) header.d=boeing.onmicrosoft.com header.i=@boeing.onmicrosoft.com header.b="mjXjTADf"
Received: from localhost (localhost [127.0.0.1])
	by clt-mbsout-01.mbs.boeing.net (8.15.2/8.15.2/DOWNSTREAM_MBSOUT) with SMTP id 46CHq5WS002846;
	Fri, 12 Jul 2024 13:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=boeing.com;
	s=boeing-s1912; t=1720806726;
	bh=2eXtg+cIG/YgtceXqIdR6HRZHHqtQNXAugzp7EtyjmU=;
	h=From:To:Subject:Date:From;
	b=Gqa0Nr3NCDbp/GUt/CNAXX8VxxVX4X+3LhjJ0bekJ/G9q1YshROm1m31bV6N1Xy+B
	 YEZItaI4p+QyA45IXTnE7Yq0GuJQA3YlbGG/p9v/BHEaUmyBjjPWN1qpnHc+ycn0yS
	 0SMi+69nDHKoGY5RBqGDqjGzE/0H/w/HHCdm9bYI61sCZLEievVzm05Y7t8bdvOdpp
	 fw1vGPC+Rt/vgD3ChKV4fw8QcBGy8Ovlje//bVxvLXMmtoMl1hL+dX7U0k2rEu73VB
	 MSfkIvOQ8j4RwK5o0fEk3ELoPUv3uDNRLi9vdPLus9Iz1pVP2e13/MlWMdtXRPafqx
	 WunXHclXc5JLQ==
Received: from XCH16-08-10.nos.boeing.com (xch16-08-10.nos.boeing.com [144.115.66.118])
	by clt-mbsout-01.mbs.boeing.net (8.15.2/8.15.2/8.15.2/UPSTREAM_MBSOUT) with ESMTPS id 46CHprLO002682
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jul 2024 13:51:53 -0400
Received: from XCH16-07-07.nos.boeing.com (144.115.66.109) by
 XCH16-08-10.nos.boeing.com (144.115.66.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 12 Jul 2024 10:51:51 -0700
Received: from XCH19-EDGE-C01.nos.boeing.com (130.76.144.197) by
 XCH16-07-07.nos.boeing.com (144.115.66.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39 via Frontend Transport; Fri, 12 Jul 2024 10:51:51 -0700
Received: from USG02-BN3-obe.outbound.protection.office365.us (23.103.199.146)
 by boeing.com (130.76.144.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 12 Jul
 2024 10:51:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector5401; d=microsoft.com; cv=none;
 b=tJvm0TjmdBfRJTFpSABZmus09vn68SommNpuQtESQNrpbGSg7ME4z8j5b0M4Limy3X1JKtxUNDCreaCkuizL8KR1dRsBz/q4RSIgYsB+kfmPANuhRdlY8o73DlBapdlhWsNGg82gKlfPSg8Gg9m0Ou8+eVHx8uXVyTHr9e2n/uB5xYNFxiKUd0jKZZ7GqN6s/wpsHoPYDDjT6HmFff8Dt8M6RNoa7dcXCEQpAn/Lkj3KpbIgxQ8QTdibb/Yw3lKfp+fVQyDPIgkF7QC83ViBHIhFVfx3XQ4cIsRpHcomMsgRzC+0tLnm4jD1IbaL2WRS9RHZzkVLpwSmME2kxTXhUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector5401;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eXtg+cIG/YgtceXqIdR6HRZHHqtQNXAugzp7EtyjmU=;
 b=EAoITBuHxwVLmXrqNQhaPo52UJBq8VGN3PyfiCcU+FO+/pgXkD+83/s+K4Z3jTseaETFO8MhTvaxiaaGSJe0ypYlqErMuf3kJHxjIQzPz8DcdpZAOCPLkVaafgXtt2WwGbdvLfknZGvdfzjm46lj0xqpzxsClAy50TQSI4aYoeIHvd2jvsJShqsfHJyKV7Zth99SdJvzg2VbNODoy3DvQOliWfvKR+ZXCVbPu5rI/NPp866h501DW+eQ5+wjrFki76La4oVISWNRc1SPwLrxQH0sCw7cF9YoRZeyWU2QnsOxNTcD3LrDxgsQ2sv2jVtp0jB1TRS9THL+Uvia33I25A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=boeing.com; dmarc=pass action=none header.from=boeing.com;
 dkim=pass header.d=boeing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=boeing.onmicrosoft.com; s=selector1-boeing-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2eXtg+cIG/YgtceXqIdR6HRZHHqtQNXAugzp7EtyjmU=;
 b=mjXjTADfClpB8f99oh0SyimEQOoDoDJpuCWIrTzFjyTs0PW1sKxACXg2hNUUDugG4UNzNHd95rkMmPBSWrsFeorw/9kK0NBDWAG5qJRa6Ua98fUB0n8a9eJyJbH5kdT2/ZeK1lnL1WuLyjuFwiryNClzS7Dn4CArTgN2zHXULto=
Received: from SA1P110MB1279.NAMP110.PROD.OUTLOOK.COM (2001:489a:200:197::6)
 by SA1P110MB2283.NAMP110.PROD.OUTLOOK.COM (2001:489a:200:199::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.41; Fri, 12 Jul
 2024 17:51:26 +0000
Received: from SA1P110MB1279.NAMP110.PROD.OUTLOOK.COM
 ([fe80::77fd:c39a:a6af:ba8a]) by SA1P110MB1279.NAMP110.PROD.OUTLOOK.COM
 ([fe80::77fd:c39a:a6af:ba8a%4]) with mapi id 15.20.7741.033; Fri, 12 Jul 2024
 17:51:26 +0000
From: "Greene (US), Geoffrey N" <geoffrey.n.greene@boeing.com>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: file descriptor leak in 4.18.6 but not 4.17.5 with the automounter
Thread-Topic: file descriptor leak in 4.18.6 but not 4.17.5 with the
 automounter
Thread-Index: AdrUhAf2jaYmhAjDT82qb/IMARMWfQ==
Date: Fri, 12 Jul 2024 17:51:26 +0000
Message-ID: <SA1P110MB1279B820806667903DE37941CEA6A@SA1P110MB1279.NAMP110.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=boeing.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1P110MB1279:EE_|SA1P110MB2283:EE_
x-ms-office365-filtering-correlation-id: 8a683117-9461-4151-d596-08dca29b4057
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?or5ZQBhAdeHMt/ijdlt7V3Xdqwu1Zxid6g9SbUxCSepqCIShEM1c+f89fg?=
 =?iso-8859-1?Q?fVc90arPF0zePv3vLcugYGLIfoTiBkPgUWEM4HuTg1Y0D0/1zlTHqL33sJ?=
 =?iso-8859-1?Q?CLxVa9RAWzIh0Z28ts/pi+XWGc5zJOF6cuwnuIYlWkEoyo0AeNTykd5Tk8?=
 =?iso-8859-1?Q?szX42WLyz2ty/nby38zjshDMsSlKiepl1VVOnq2ZnEPxIj1LI726um1/OV?=
 =?iso-8859-1?Q?P7VCHJeHgDMhs4dAqxhy6zP3z3JrJ++eIupYzkScZFCCHBdOc2uWheAJ//?=
 =?iso-8859-1?Q?o27V5Z2dcy5bczkbXNNYSGxO666d6n3M1ORy/i3XZOoxPQEKxJWk0KaW1l?=
 =?iso-8859-1?Q?k/gt4uHGbfuaFvL8L+zCpfhUfxyDUYTtIGae0y8hE4noZzY4Izlm6GN9hz?=
 =?iso-8859-1?Q?3NxJ501VHlGJ3aWq0KTFACiXy34t34qh5RxlWiQMCNIOU8e9Rp75tjCwAL?=
 =?iso-8859-1?Q?E+OJrFGQQ7B2xAxkFX3+AAsSEtp2OyFtIE2S7snDXVKndoCLUpgbE0lQCj?=
 =?iso-8859-1?Q?6ep3ySBjqq2e2Pax2wmOTTicDXdcR+J9JcoIjQtUy5oCv15ZOPfXoqB3QF?=
 =?iso-8859-1?Q?nR9gXiHG1WUWCZBglZZhjU6x566s9ZVH1yBlDi+zvtGvMtAY63AmtDWxl9?=
 =?iso-8859-1?Q?Wt+nOLwMaEcwgJu8RKgC7i74w26mFSbB5skNHNLQ5/oWzs82/JqhQPXlbu?=
 =?iso-8859-1?Q?njBctwY6F6PQS90CUP7XKmWBqMw9nJOgKR8U5TQX4j/Jsn3JyAuB/zKWJC?=
 =?iso-8859-1?Q?QEVvcy0i3CZDfLlBPhcQCm+dQVOjKHxFeBYzdF6IzJuJBcYKXDc92T6YT2?=
 =?iso-8859-1?Q?aw+DhbygxfO6v0fqAaAqDJr6ws3+TKIxURF/DqXtA5xxENSTPsrn5vsnfW?=
 =?iso-8859-1?Q?6dAMiV1pfHY9s2UbVCopql8o+uSnwPYdziLxpzMoMU5mjU157o2WnbTcl9?=
 =?iso-8859-1?Q?drolzGjhGzGcF5SMj/0/c/jm4qZGmeTQ8yO3NlVg4iT9Cfbf+nmu7hAdiE?=
 =?iso-8859-1?Q?5u9D1rbeC0i2PcIzIPO04SM3YYWZUFGwG1jmleDO4n1lVmvui6K63l95BI?=
 =?iso-8859-1?Q?/Chscg8kfHx3je5gcU+7I8E6+RGtZXSBaAHGSFjrPOWYGU4HFjdG+bJFis?=
 =?iso-8859-1?Q?jSFHfLvi0Ys/lJns1pxwdrgKTZq1O3sF79XvW+yumTgFKT0g1iuaSpQasg?=
 =?iso-8859-1?Q?zbANOfyR7SeTC/YhwY6Ce+ToJAVFYOCDREy/Tda0+2aTF3NzarQ8CIy1CZ?=
 =?iso-8859-1?Q?zkgiSZfsnagQ/lOI3UEYIcAhGvfmQCHzd4eSQTWu7DiyOo0OIfe1uqb/Vi?=
 =?iso-8859-1?Q?kQpICx44E3c3QGLqlLQiIhhabFeZY880+VK/uEpXGenRWJiQzCFWmu6VQK?=
 =?iso-8859-1?Q?vUDqQ7duqoQhTmskRjzWgdHQaUCc9SXLePC5yb7n8d4rR4J4QeRo0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1P110MB1279.NAMP110.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?H03JMktiPASzuxXl2NWC1JXO4ICArAU40jTQN6wyQMgSnhNubw2yxarYpb?=
 =?iso-8859-1?Q?MPGUqzEn259iz4M/y0oscUUvI5kAmH1hcxiE9hBL9NGJlBD97o5IWtyeIm?=
 =?iso-8859-1?Q?X5Pkq33z8ZFYDmvOUlGfbXwemvJMPbccwNYd7WXRay9KQBAEHVQ9FfHvDu?=
 =?iso-8859-1?Q?bE+X5GO5c8vPt2KOtm6AaBCuj+IHtUYnYUXepYKay4JPnRtWHSh3ZTHgyU?=
 =?iso-8859-1?Q?lUQuG+0lhzRVSnfwDIZZWOR32iEviEPCHBgRHvSanmVJD2iUA3njlsRk8/?=
 =?iso-8859-1?Q?5JwENO7w9i5E4TgNtPz219t8vxFGY7CphhtX2oVjwP063PSPewOJmyRXI+?=
 =?iso-8859-1?Q?33RwSfgjBWpkD1iI+U7G+L3jOJq0oMTlUGNjctorlnZB2dG08CSrL+PNSu?=
 =?iso-8859-1?Q?2St5JosQ9FAowg8KUfj5OBEzWdoRgSEHltEB/fty/FXEILF+Xe7NDgT7Nu?=
 =?iso-8859-1?Q?T943Q0jD3Dwcf8Cz4AvzfjK7W+0B/4ZxWMl6VPfZXKB0Rt2Te8cqROFyQa?=
 =?iso-8859-1?Q?ltcKQ1EkqzQHRakIvBmE2ab9uUDtjTVKRp/TYg/c53D0Vg6MqrgYAoAazn?=
 =?iso-8859-1?Q?0ssagg5kfWmK5eEFP1wiybtsFsIk4UO5ePw/IGV3AYTV9X2A1KN48GS1pE?=
 =?iso-8859-1?Q?KyoHEr3jSx9f5eQrFRBxN+RO+DKxrkRtG3dU6YVlgtQCeOZ3VQ5S4MriKx?=
 =?iso-8859-1?Q?gNJ+56wqaLofrzw53bVuxe6KBK5HeezcWt0okZAjjvGLFtyJ9yPqE0DQI7?=
 =?iso-8859-1?Q?B3fExbLagLkXNEBX3pilitPpWERxdY4RweXml8sKdSAIH7a5eFglNcenGK?=
 =?iso-8859-1?Q?5dzJwjLkCEEtM7ZroAbXo5weto+SXpMYLqqjlPDct1I0uSyHgIJpOPlUlc?=
 =?iso-8859-1?Q?VTxtSo6OI1NTuFf9dzHD0J/iMPyoWhK08hmqeMNVRxxvE1nqWmgSSDOOF2?=
 =?iso-8859-1?Q?8vomz6JJLDqqIlfvGGwdP90SElMsnQrSKDnB1aocbaVtQ4X6N8JtK1J303?=
 =?iso-8859-1?Q?6YSyEuKgWD7FArz+YOK7OgbZT+5ijY3hEiAq8cPYrsjHgdEzDC3qaKrsR1?=
 =?iso-8859-1?Q?0feCqvHDgv94GWZuUS7SIVSsd1GyfViOilh94/01R1vSApi5A3kzryGEBs?=
 =?iso-8859-1?Q?AIcuRWBvdGcUWb8XFAiVGdC/6JysyPKEM2QVRe7P5zcMbBNs5Y+P7GEeOB?=
 =?iso-8859-1?Q?m8rSYoAXrB3lqXq2C62Tme3OLLivS+MOgslY045rgLJS0eLm/eJUxIILqv?=
 =?iso-8859-1?Q?e0OZozIsAadMQGcIvkAQZSc/ETL9RmO+mJq+6rp4dmnb9nJtk3a8Dru9UG?=
 =?iso-8859-1?Q?ieoLLmi2qJsZtWq8P9IPTZrvMs39WNaTmOtYOt/dafuUQSKTw6G8bO9aQ5?=
 =?iso-8859-1?Q?l/pr74bT7nHP7h9jn/IzSC8RFqpB1BGtQvyhGqH1+ymlrOjXgwd5vYuflc?=
 =?iso-8859-1?Q?lrtaHspOljqlq5E3Db03l6Ntxd6QJabq+aTmFHH/zEzYxuIUUYhxH+GZOp?=
 =?iso-8859-1?Q?3oNkxqnJNKKSsq/2LTPH8fZhCoFY0AYIx6B9+blv4VLZrHwBm2fvhUuUX+?=
 =?iso-8859-1?Q?26FabpDxd+ojOmvchg7TJIfEJGLh?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1P110MB1279.NAMP110.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a683117-9461-4151-d596-08dca29b4057
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2024 17:51:26.2767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bcf48bba-4d6f-4dee-a0d2-7df59cc36629
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1P110MB2283
X-OriginatorOrg: boeing.com
X-TM-SNTS-SMTP:
	7ED67F44F4CE275704BB2EEA199CD03D877B4165860DEFCAD7E0B2D47FF4AE222000:8
X-TM-AS-GCONF: 00

Im running Oracle linux 9

using autofs =A0to mount about 45 shares on demand when you cd into them.

As you know, using the automounter, you can mount a machine's worth of driv=
es using a single username/password.=A0 I used a slightly modified version =
of=A0 these instructions:

https://serverfault.com/questions/219615/mount-cifs-share-with-autofs (see =
the accepted answer)

I've discovered that using samba-client-libs v 4.18.6, as soon as you attem=
pt to mount a directory that you do NOT have permissions to,
autofs starts leaking file descriptors =A0at the rate of about 20-30/minute=
. Eventually you run out of file descriptors. (lsof | grep automount, you c=
an see the count continually increasing)

If you have permissions to EVERY share, everything is fine.


Yes, I realize that mounting things you don't have access ot is a bit silly=
, but this is still a degradation in functionality, and furthermore crashes=
 the automounter, even if you do it accidently. I think there's a real leak=
 here.

Using samba-client-libs v 4.17.5 (and =A04.0.16), and =A0everything works f=
ine, no climb in file descriptors

I'm considering upgrading to 4.19 and see if this fixes it, does anyone kno=
w if this issue has been discovered / changed.?



Geoff Greene
Associate Technical Fellow / Senior Software Ninjaneer


