Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2101.outbound.protection.outlook.com [40.107.12.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8165605DC
	for <linux-cifs@vger.kernel.org>; Wed,  6 Mar 2024 12:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.12.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709728538; cv=fail; b=eqTcV3cg88D4PyITBM9mM7TGyezaH8larCp1QJfJw7uwK1QqQb+yfNwDMzDrdMazH2Gvdi1YMgmxuwMB1UYb4m6IdcMUZpVU2E4yWtlEZvQHgJ2nejQWIupFPiHXFFU6WhXK9f9fgCuJ8vEZdgHVX7RfLaXfVAHSfUh47s5+F34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709728538; c=relaxed/simple;
	bh=vfImhSYQumL2i5LKhcH3X+oHj+/ENB7P5fwmgc+Y9k8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y/WhOS3X8uky4Oc/su9WZBAjIBW2P9onDE9a0V712kUw8qufdGAzvw4/9CIl1EqnenIyV76M0hm/irmWDcgskfwq+LaqYrNa8C5Unau5+bEBKE+ZbnjlS9AppO26bUtIdXYHgfYgYx8G5b83KnQD+8Jy60xoNjBmqJek/wnOAXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=biocoop.fr; spf=pass smtp.mailfrom=biocoop.fr; dkim=pass (1024-bit key) header.d=biocoop.fr header.i=@biocoop.fr header.b=fwCXytLf; arc=fail smtp.client-ip=40.107.12.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=biocoop.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=biocoop.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=biocoop.fr header.i=@biocoop.fr header.b="fwCXytLf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXo1oWk77IWDpjc9HbxMoW9z05CMbWN3FL3+oqq/e8FPNTZHaaxsjRDGwCX/HqMHLgG6RiM79s2u35nIZJhb0Iu2x7cdnGQ0sTSTJeDjMYcs8sOoHEgGC9pr4bt1T91v32A9/QAOXWDPNuV0N1l5K7pAv/yDzgp7ys2+W2SzUf15PZQTVorMk+uLpVSgJmrm87nvfdBEFUxy7AqGjg3fQCYl1K3zJwWCY5X1nesAIiG0qKwxFZYMwRm5gtiQJ1G9xEd191W1uXfe/mkwaVdywRQxs27Gqir3Ss0zL2l33Uk1uwtDwkyr6eokxVNl32l1iwBbD8Q17gxIaLvfycHmVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NRbaWkzveiwkLnQcgPN3np1FEj6HvlLmg6fakNB0TY4=;
 b=I+hLDcBe3YmS4W2dvmGgsDy7E27qbQJoMKp+acEf/iZgmbela8lK07OiUXRwk1B6tH5eqo+hy6Y88bJXGxrBjLpYc2Voo7QxRly9ewQLmPZS1PT1zYQ0hGwibYpkA7njMnfLtVtFSi3mibY6v9SXfE2giVaskeG43wxvkNtUQoW4mP7wYmXJ6ONtEwHxDDgiCtqpBMxzdpb0doB9OUgt4P9ZXGbj/oRuVhpkiKqvsIk5n9ksZk6LauSxTgXRdg2maCftRGg6HQTtaPits0rFrgYrICY9LoE2GzP74EPOh+9CBV20hDAwhvZqzfu2tXOE9Etzn3tWGK5RZCRoyGArBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=biocoop.fr; dmarc=pass action=none header.from=biocoop.fr;
 dkim=pass header.d=biocoop.fr; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=biocoop.fr;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRbaWkzveiwkLnQcgPN3np1FEj6HvlLmg6fakNB0TY4=;
 b=fwCXytLfFdmavqxvm5be1WpcYV/YVPqr6HeARJV2EWiEOTR1UhM3el9pyi29RrUwZmlPeDS55RFDJIEkpOO7DYYvDpQGx+7jSfvBNc7z9xc2pFZJB2yj5c7dRXNbMiiJmyN2ze0VH4eQhZbSKNZR9w8W2z5+9vuu0rgKYtWIdfQ=
Received: from MRXP264MB0726.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:17::22)
 by MR1P264MB3746.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Wed, 6 Mar
 2024 12:35:33 +0000
Received: from MRXP264MB0726.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ed11:6059:5c42:c9ab]) by MRXP264MB0726.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ed11:6059:5c42:c9ab%7]) with mapi id 15.20.7339.035; Wed, 6 Mar 2024
 12:35:33 +0000
From: MATHIEU Vincent <v.mathieu@biocoop.fr>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Oracle linux 9 - last kernel - Resource temporarily unavailable on
 cifs mount
Thread-Topic: Oracle linux 9 - last kernel - Resource temporarily unavailable
 on cifs mount
Thread-Index: AdpvtANNj2t7hY6gQ2Or6c8JHqp87AADqYqg
Date: Wed, 6 Mar 2024 12:35:33 +0000
Message-ID:
 <MRXP264MB072607F16FDE71DA2925A00886212@MRXP264MB0726.FRAP264.PROD.OUTLOOK.COM>
References:
 <MRXP264MB07267BE5C9D0059C5FD18CBC86212@MRXP264MB0726.FRAP264.PROD.OUTLOOK.COM>
In-Reply-To:
 <MRXP264MB07267BE5C9D0059C5FD18CBC86212@MRXP264MB0726.FRAP264.PROD.OUTLOOK.COM>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=biocoop.fr;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRXP264MB0726:EE_|MR1P264MB3746:EE_
x-ms-office365-filtering-correlation-id: 20c62d7f-1fd9-4c56-4c9e-08dc3dd9ea7c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xji8GOnZrCuXuW8f1FANOGqMiokTis7jsV27afvidHE8cQsgmExotF5cjnK5KWOCHmeOGkCK/AW74pw0Q+WjpSCF5gNsr2Mu02+sYq9+VTy5TAaTQIfmPjJ6dZXdUCsQdWCa0sRT6yIVPQjAFCADNtj+MgJNfor5+7tcHxRo49M5Wsb8ButH38xm6bZkcueMmijyQ+7Y/SeJJ333Um1BlQPWPxeu6ZkZmBh/Ppz8zEyJQWYn0jWoPV/boGSJIdBsU7b9INo1rjbSe6Xtad0bCYTv79SnDKLG2dcE/XTG3IUaIqjUmikzaEXJmgkQWhCKkFP+rlObFMl/UBSnMs4GtFNT+qboqarv569/jDeSRnrk2qTMN2BGzlhCD7bjOZDvkky1geaxw8hTjNvIe0RJNZs0Fb3KY/GMqY1f0xPxkZ2mYS0DNy8PXbwnG/CYiIkIoZSWC0zau40uoZejxLCoWXsu34Bhx14it6/H0J2vqYQ71xyu5Uk724eoBlYc6ZYdYCpsHEdGs59FRYAQeJPNCymyr28deGf7DWJ3qEcSs+r6GB/43hUofefkAOEJ+t77K14JWTFxihZbmxZG2NBrejGAuiVjpxR4ofeiM3HuSz81xw6sKmeFP9039Ze735H7uS7VfZwE4eQFdKwoPyL4A+2dhX181nQDfkl2PT3QYJ7ps4bAEfnpa3dzRZ3HgJ4aYb799vV0ngmlaUqFfyMBbmOE8Z9aIuWx+1cAmJs+LTw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRXP264MB0726.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?45BD3nh95Fa441O1brrVWGkMauvZPO6mJAmk0x0HzbpbPyRCGJfgPzC2pP+w?=
 =?us-ascii?Q?S2Qjwz5xaf+FHFhSBf4ojgN6ZPADlBFk+vPUDzkHU5/NABNubb+QbC6KA8Yq?=
 =?us-ascii?Q?V978FKSN0tCN8rgPJIGQgW6O3l9MaSrUcuV8zWhCDgLav2utPwnsr2av1/iI?=
 =?us-ascii?Q?9kX8gYx9A9hZ2BrxshP6YWXPaJSZANxbBMZQxK/zFeOy5yuc31WWfAJRc3Kd?=
 =?us-ascii?Q?2sI3aUrIgTAJ+L4/bbP0zBHTOg95kdFOZtGtUn5WV5ckoO2WwNTW8rM4EYrS?=
 =?us-ascii?Q?MszAM6GuL6HLy7Ci3Fusr1ktWkv07HXf3AtCTzrQqAewo0JXLo4Ylan6R55K?=
 =?us-ascii?Q?5NWlfZ+8XP80LVCs6j9tTc0LWLGufO3aXWLQisALFldVsD/FXGeEYNA8qvCf?=
 =?us-ascii?Q?tarFOalhKPU+ntuDGT4RXwD5tids7WUK6+R2dfpcXi1kKrJfctZXADlLkvia?=
 =?us-ascii?Q?GLy4OL1ZiNNMkI8Bstm1XZXR7WTiJzjQqfq6CpAN5CJTBX5lUwyrSIW9AaA3?=
 =?us-ascii?Q?OW2C9JuxTtQKwxt9Ss0UIjoJERkKoBH1z6rt1pMSPtYFTBWAgk+yFC0QO0SS?=
 =?us-ascii?Q?/nG6Cfn+qvzmmSpwI5d5jL74UZg4QdsvF1CqChq/GcYYaJ6W5kj+6OU6hFg5?=
 =?us-ascii?Q?cGR88SPbb6RMG/NeLuSCvYNzZcNeasw1sftRaFNUaDKx1ec2W4BIwHrmQDZ6?=
 =?us-ascii?Q?KlG/2XpKn0WhdcVMuPSb9sz3AFc2b+TLRqLcb7wGLy9AMS6j6iQ0ToEbCB1C?=
 =?us-ascii?Q?3+jAmrPjZMiODwq8hRxuPAauAyxYfjZnXuUZTe6/HoKk18lbZWiY79YxRj3Z?=
 =?us-ascii?Q?ullC5C7gS/MSZhkhABoipacqZJ0hHWWOtqT4M6dvO0zu4pRJzWAfRnFuNU7E?=
 =?us-ascii?Q?Opjw1BiPqDl9Hs1rybhbbmBhqR2bZDdK50qD9wThRgIyJTtuE4POOii1H1Sr?=
 =?us-ascii?Q?MvDIEkSZZIuDtGXiWb6aL7ZH9SNobZQi0rJNowvpxpOwJ2kxxwD1L1W1gheF?=
 =?us-ascii?Q?5SCSLbHswJeXvqjl5L9ymxWz85+JAYFxdm+o1MMrw6+UHQeC7y54T9ok54h6?=
 =?us-ascii?Q?6BB2/dtWwydrv0GuJdCKvyPXx4w+0WZ6+KmZHV1bMfMCfYLR5pwqoIwDyVKs?=
 =?us-ascii?Q?ip7MHj5XHpWHFVuiSzlg69XtPgjONbEHqzC/6kMWFtivugiSW4tXGXJGRQUP?=
 =?us-ascii?Q?TUXSqExXSS3KdHxYUoYMWSrqJK0uXYvpdrFVQ2Ev5bW03l3s1Z7DSRic+T1S?=
 =?us-ascii?Q?Mc4s2yHJTh/VIXW61vCJdA3gWjOqfwRDdAhuZrdpAstkQYmUUw2L5NFAS1/y?=
 =?us-ascii?Q?kKUEUNGNNkv+vNFtyVSHOhrDAu02f4cHfb0nCnHgHE2UTD6DltJKAqwSLpbC?=
 =?us-ascii?Q?SBZx06JQSveRy84VA16ihggo88jY4J8Bgt0Ti4HJpzVX86G9bWdRRnCkDD1w?=
 =?us-ascii?Q?fKS/BPTE7E83uE3Hur0+EpG6czuFfXlb0qscW2sNfAcfI95kxqSke3R4tbSi?=
 =?us-ascii?Q?/uvDqd11PeVr646RY+5Gxr85k8yuzwTbv5xNKtg2wEr82/CfgMQzmKXc01BO?=
 =?us-ascii?Q?9DBE/lZFynJle6Lx3zO1h2uBQ9XRfQyfhKcFBqei?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: biocoop.fr
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRXP264MB0726.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c62d7f-1fd9-4c56-4c9e-08dc3dd9ea7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2024 12:35:33.0855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 254ce57b-bda2-49bb-9b4d-dc236c664f5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MXCKe7BmifD/VJI7h4dT9OtQf+WIhmD9dlLxVeaoNepwsdON3KIYuAM10sgH73n+yxd9Gy467PjGXB36nOVRYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3746

Hello,

I have an issue with the last kernel on Oracle Linux 9 (5.15.0-203.146.5.1.=
el9uek.x86_64), when I do a 'df -h' and/or with python/java script to acces=
s to files on a cifs mount :

      df: /mnt/data_appli_test : Resource temporarily unavailable

However, I have access to the files on the mount point on linux command lin=
e.

mount.cifs version: 7.0.
Windows 2019 standard server for the network share.

No problem with another precedent kernel like 5.15.0-201.135.6.el9uek.x86_6=
4.

Is this problem known ?
An idea to resolve it please ?

Vincent.
