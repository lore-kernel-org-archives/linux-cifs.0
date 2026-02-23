Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021137.outbound.protection.outlook.com [52.101.62.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CC6361654
	for <linux-cifs@vger.kernel.org>; Mon, 23 Feb 2026 21:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771882628; cv=fail; b=jF4UZUvdc/o3DHl+2guETvDG5tseCpdnmorhuN0/VHka248M4xldLXtHf9QooFAWPldN9ukGs6c2vdvKM8sY9qLpr9Wx4nv12k5nDYElleDnNv25OEtg05WTFs2C+UkcZiiLxepZT3WTrGAeH7l5DavE7zO2LrH9pu6EdwMoyA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771882628; c=relaxed/simple;
	bh=ji4ev23VwyNx9DPHbt/M1wf7KEDJgso7HRZ1Ho+YvhE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IZ/uBgLYJC7wAPCA4x9PHpYDZmAnXiqeE0SNJQ18Gj8N5HZI/gAEaJMXiwJBFSNgu5Sa3VrBkCCoH1RoZS7bolMGBg1nwvLLgkiwX4EyVOuGrrhP81YaArNUZVixfMKRWGgrWDT5ueKNRXXdRWNvRfKmWecGCXDvEffNi2rngoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=capps.com; spf=pass smtp.mailfrom=capps.com; dkim=pass (2048-bit key) header.d=capps.com header.i=@capps.com header.b=WRR851R/; arc=fail smtp.client-ip=52.101.62.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=capps.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=capps.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=capps.com header.i=@capps.com header.b="WRR851R/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eE4J/qrKMuzA/LI+8ISwb880R9Bid7m/Vw53vKqnVZzNwU4PVnnTE6INKk2PcRYmJAEr8/Q3Ph7eFUQluO6R3k8ztR5I61uUuQZv5tbK12i2NTT5N/lwtWFLziR3vjNeucc5bsZ60GdfO7FFf/XBK4cuTzk6uT58e/cpW58bOK0a+q5bUIJmM/FWCd/B+i6EBkWLT12SOZNGnauG0wb2CRHFRju0wsJSokObrAOcPdKouXakE14g92GbicyFcbaB/QwFTuEoyWquSI8NHkMtFWI2QYHpJxk1oYd+0xDFE4bmXub3EuuiQDNqPWh0LR74UgPSX90a2caDy2rfM35Oow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fg0YerBNtsqIVO9s6Id0TQ91jTbfuNgALhgJ/OnqwrM=;
 b=xeIYL7LlSlG+d8+WSkSVTqxDQOekg1UDAxnFgDV1kc26wNE8kQlg+QD/vng2hcr4tUNDgD5fvxpr0JJ52fG+ZX6ViiacCWgy0fw8HTVeVH9sK5agAWj56zq3CGmUk+Pjo7ecWGBTEFVWeqSP8HF7my3GyrtWKPwidn4S2d4pzM4zUJwzWNFEzJ1ybEOW+sh+QcWlJH9Nma5tPYN/R+gkW/bXpiRvpIBTJd/3aQjfwBgsObmTcUfgTPy4Xsl84KpngikSH1qr6FaII6tf65HIiyLrpbfVN3aOwBk5Wnid/Abe4btp7VEEKqB+FpZBHZsvix8R4QierbaRH9Ty7L5BIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=capps.com; dmarc=pass action=none header.from=capps.com;
 dkim=pass header.d=capps.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=capps.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fg0YerBNtsqIVO9s6Id0TQ91jTbfuNgALhgJ/OnqwrM=;
 b=WRR851R/jAnYZczBVuJuhKUrhihF9ZxBRQCbG4Wz8d7pFSwOcO1rSN9DlsqbMRdKv+FYBh98bUfObsRNrTKUbpK9/NRA8Q0wtjGU5plaVczpxaiX/QviMrs2dpUAsOyNNC0GfFdeXFrck7cUehjR8k/lviZj/UJtyez0okicCK1IbnGek8XswwrxeU2B8wyewjQ7rqlNAbgNUC3LXJ6U3t5Xz+0PXFOYnC/NgB+NGTj6DvURQByIzg6+FNUtBs1/NIcdCFUff4Q2XKQQMa52tHhji7AHKRPayPEV6+rip77CG5KrMF66DXtPkzBv1Ny9+x2XnS7AsdB0oJ/fP7skvA==
Received: from LV8SPRMB0030.namprd22.prod.outlook.com (2603:10b6:408:225::9)
 by PH7PR22MB5300.namprd22.prod.outlook.com (2603:10b6:510:321::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 21:37:03 +0000
Received: from LV8SPRMB0030.namprd22.prod.outlook.com
 ([fe80::b2ec:9108:f882:2076]) by LV8SPRMB0030.namprd22.prod.outlook.com
 ([fe80::b2ec:9108:f882:2076%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 21:37:03 +0000
From: John Kendall <john@capps.com>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: mount.smb3 error 0xc00000bb STATUS_NOT_SUPPORTED
Thread-Topic: mount.smb3 error 0xc00000bb STATUS_NOT_SUPPORTED
Thread-Index: AQHcpQyMd5yAr8sk7EOMJgKaHRW19w==
Date: Mon, 23 Feb 2026 21:37:03 +0000
Message-ID: <CDC5B65B-2116-4FEF-AF59-AA41DBE2072B@capps.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=capps.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8SPRMB0030:EE_|PH7PR22MB5300:EE_
x-ms-office365-filtering-correlation-id: 36cf056f-b71b-4bb3-7257-08de7323af74
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|19033499003|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?U5K0TAUS+DLvZUOksQM6QZPQnuDmre02ic7AhZD2ihEkIJvCR2PXBqAM3MQn?=
 =?us-ascii?Q?h7/itZy3CWvNt8d/EQ3s/hph4ThOJJ5PL1LQeFce6RRsJcFcpYPUTV8Nxnky?=
 =?us-ascii?Q?YDhKCxrqCc6YIYrbUj2ssDG7CQrm/xWgVXKvBo6175KsceWhaDa/xGRtWGDR?=
 =?us-ascii?Q?zlsuUyzTg53pAEUHrBiYAOlbSbw7bSuCACn+bY0mYR+btVq+wtlfSyr5YspF?=
 =?us-ascii?Q?muffltTJeT+9mUdGjAWM+RY/pZW/K28vPCBgGywi/niJsnyQnnyuWeCZFTYJ?=
 =?us-ascii?Q?NqgE6cwkZ+u2j954edw6ZrddsJuXOnoqnF89prZZgdhSPVnFvp1EbjyOUmDY?=
 =?us-ascii?Q?Gcl2wCMil+bJycIKtdD6aWJ2b7U5EiXhECjLtMiH2VWBLkm2hM5VFBeHCV0y?=
 =?us-ascii?Q?jwjlhiz6X1pZMK6fmoVGj7CaMavavGMAVQAawaUfwE2Zo5R+Qxap1S8GJSS5?=
 =?us-ascii?Q?uUSqc7ULmhNHUG5rmfXaL1cro4N6CG3rcgyXEVJ2lwSU5tFMWiLc/N62JaO3?=
 =?us-ascii?Q?qycU+us2LYZg2iODrQNMNuzZTLudGRord3nXyQhYi6wK5lhqrs7Nca1DxEca?=
 =?us-ascii?Q?N1aOudo5xkY/tu92VQ6dDA5dIEbP8z1Mk4XMeBQZL13UzC5TuETNH7/opXDV?=
 =?us-ascii?Q?4Z2np6ocFhh3f7ZoJ9SWU0W4rd7ZThvXhIZYtPMSEPNwnUWmpROSrTat5gYu?=
 =?us-ascii?Q?RBSrWoTaPFa7UjWmNLmj5WheDHfu3XOG5gsG7HZJojcD0X/6EiIIWdzj+x87?=
 =?us-ascii?Q?3w+2eWjTKuz0Ory8APhtXBLLFhL7dyyKUEarV/dIApDALeUWKd36jzKK+wmK?=
 =?us-ascii?Q?dbPcWK73rwcyD7X+ApbwkN/60JbM6ZjQZHM5vdMFVWIdlusF09nfeU7FjlDg?=
 =?us-ascii?Q?B/RPMgmoOQTj4E3I24CpTWTRNMQFvaKSPvAS93wpprEmZ19bsUemv44Tpo3J?=
 =?us-ascii?Q?fTie0I74d0BvSp79XG9oRDgjmkBDGfxFKztFfoEelYy0tQSktXZJMk+gVx1b?=
 =?us-ascii?Q?qve+rM9hRJXVwoYSgHfdxDZvffF1wzmaN9KfjRPfBLam37ebO8KRi44KzJ0Z?=
 =?us-ascii?Q?ta47mEnc2LRYCblD/s8cFRmelQ40PCeOuYEb+E9o64iDfkNb05yfZSy10/OU?=
 =?us-ascii?Q?X+tQ2jaRUMTkWo1J+JGnrjvNOEpDSxNhVK/UaW/ZPD/zRwmRAm4cwQ2yyxcN?=
 =?us-ascii?Q?DaNtFOCQveLCqijwDKHfevYJFWzXEV+QNqPHjBM1ksCz7dHbeOG1zgVUtrw5?=
 =?us-ascii?Q?RaYMxTz30JPEdKvVAdnjcs4CcFnLwkTx1HaodEHHihkC3gOJGwdAkvYObkK/?=
 =?us-ascii?Q?Svu2oYGmmpqzLUlS7hg7m5Pl4nt5mAklE9UC00tH/SDVaJmgQBMH8UrCKxDv?=
 =?us-ascii?Q?YEm1I1Ug/qWfFpSQwdLzGY8mHaUhlCkZsvuw8/JdFmDbVk7Z3OS2BKPoVymF?=
 =?us-ascii?Q?aiGU6vCsZxQPdzP3L4RjoTtl3TPzheLZmNFhhu7SmWBYXXzLlUQUBEDIFlVA?=
 =?us-ascii?Q?jUR9NFJrnvidK2T6D1bmNY+bd3YuC9+FNhc1lpypT42oZVxCzHdgt/KKjoJj?=
 =?us-ascii?Q?iVjbKUK2oEmPvbUylOY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8SPRMB0030.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(19033499003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?iX6gIsAWlR78DGdi27ZmLO0n36joda90pzMBiVwf85f1AdBbjS/TN/GKNlcB?=
 =?us-ascii?Q?Yt/fnaDlwWBJBgblNGtqmhWO3v8fDWeDWq7qgELfu6FeMygRrB+hVqUTB+9+?=
 =?us-ascii?Q?cQfV/UN+gMV9H9Kxz786eeyqRlcZlVQxOp0tS4xXcm/x6IH8F+xgC4lRRY1J?=
 =?us-ascii?Q?E08PascTbE7khVFWFNyQ8aQG1RIMRKSNd1jpgDDaBsipuPZ1ZwtS40bTMj1C?=
 =?us-ascii?Q?KW5Smrh9dCUoTwmILH2waylIGedjmbBkRsp0K61R2EaS8UN6lXbufshBsCcq?=
 =?us-ascii?Q?YzKRHFjnHia9XOKL0ScqjZRc+qMiYK8MfvjJy9VYtiiBSoZQT9do7U/Soy3Q?=
 =?us-ascii?Q?Z19QZqFgE+I0JGlXvto86qBlAebT+d1q3HlYSdW/OCTQaE+ERmjBeXy6ZpMz?=
 =?us-ascii?Q?OqaYrTSg6k4evK/oPjF0q66b3+8JIJx8iXjtXwXG0H02XAaX6IgQik+hgp+m?=
 =?us-ascii?Q?AhMmhSnMinn2Yc57LAyd1yRFibLAoHTJVEJMr3E4k+ka26RfN2a37SO/xF8+?=
 =?us-ascii?Q?Bgxq8FyslNfN0n7YRQuaZGlD6gQRi3TWeAmGfNpZnJmKvBZM260XvFm+WgsL?=
 =?us-ascii?Q?ZSrP63GpISNTjPkgqP+Sc+rMtfwbSfDiGjvCqJW9mO2zIg5IwHluWYTDZQ3V?=
 =?us-ascii?Q?7L9PNSwMHhNMC9KiKK5SmbAsoN4Hz3Mg6DyYSCp11ximWPI6k5MO257j3H0M?=
 =?us-ascii?Q?c5wTo86jb0J76lH9w3b8FLhTaOIjOp4zmq8yKjFAPqxnZTFJVHWO/0MiTrxG?=
 =?us-ascii?Q?Iue58MqB7esOzxknFE1pncH1GDfGbzKPTP8QXrninLPrtgtjXS6UuCr8bmE3?=
 =?us-ascii?Q?xQvQ9g5wbgxMj3Y+f/ro40x435P6/QOo93bBU5pxp/v44i8DLINMxwAlX7OD?=
 =?us-ascii?Q?iPabcu03NBs1iW9ETwgSx/TAd47Kb9OSUlpFwjto/6xdv8SmWYm41mhoUSdK?=
 =?us-ascii?Q?0rQJwXjyh1f1/On+ArPP2chPcZsfT0Uq8pqoCkoYY6YOoqzrosWQkNecRXZk?=
 =?us-ascii?Q?sBw8sPHcZbyoRwpy4ggvcy1U4bypQKMnJeMfD/U3YbYLERDqUhuSOmRnmjyr?=
 =?us-ascii?Q?+OKOJS+kX5YdW1CplTw24bc6xTyWtx0e5Dchg3ECh7+lRWFXxdpuKmwRmjgz?=
 =?us-ascii?Q?6HfDQTMfj8jt9D1M9oZWCXgQ/tDS7+Kr35NZgKJQ+32h0iY4toPXKclaS5ek?=
 =?us-ascii?Q?OA0IqArlJyO6b9+a/YzslJIZIAr7QsOm/d/ToMxStHWq3EqgrYHTZ43YlYHo?=
 =?us-ascii?Q?bSHkf7I0ovtF4hMwKi3s9i2u3Hyz+nU5uKmHfuMY0ok6mBj/Sg4iY2PTyUTv?=
 =?us-ascii?Q?2aqp24I9AS77NRCm9BbDG5BIReE50WjV1cRuCCqAuAgesIUEqC29ZXnIYiLD?=
 =?us-ascii?Q?TJRJ6DNB22gdxLVHKEG1RyvuyooVz9BF5//p4GcqgmJT075oZa62e2h8p6jZ?=
 =?us-ascii?Q?3rrw2cGO+M/oGZHAywV0cXltqMqgJcqA+aLkH3PN6zCnQCvtmf89wn9RQuGM?=
 =?us-ascii?Q?J/5OxDmIsWnimePoQceTvpFWVvLjlw0pd7HXJvP7VyuaMmq3O3oaKEAlME/8?=
 =?us-ascii?Q?30+TJV0g+D96u+GTwunmbuPW/C16jiiHbca1jKKKNU7HN7zX+DcnVdN7WeOX?=
 =?us-ascii?Q?SyDvkh3bV47EpbAnjxMov62f1e629gtA9FWeshAItDAePCQ2E7w4gEoeZUoX?=
 =?us-ascii?Q?K4T6b+yiUm3rL+HHy2i32I0DEJ9lGdsTaQ6BOhMlaY+C692j7UlN3Lcq55Ln?=
 =?us-ascii?Q?MYzPZlu1nw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4B6D9F866C428E468598B04B7070C10F@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: capps.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8SPRMB0030.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36cf056f-b71b-4bb3-7257-08de7323af74
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2026 21:37:03.7699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5424fedc-061f-453d-8f8e-1ab52d9fef49
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 45S4uy4DkO3KKsP4Pc+iB7CbyCxd20zVTyaUo09nlf4Rr/yfR/6pfoWLOekRfAdt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR22MB5300

I hope this is a quick one. Thanks in advance.
John



kernel
5.14.0-611.30.1.el9_7.x86_64

=3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D

smbclient command (v4.22.4)
smbclient -A /etc/silomountuserpw //silo-azwest-fs.verqhaus.com/Invoices <h=
ttp://cai-azwest-fs.capps.com/Invoices>

works!

=3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D


mount command (v7.2)
mount --verbose -t smb3 //silo-azwest-fs.verqhaus.com/Invoices /mnt -o cred=
=3D/etc/silomountuserpw

returns:
Host "silo-azwest-fs.verqhaus.com" resolved to the following IP addresses: =
10.4.0.37
mount.smb3 kernel mount options: ip=3D10.4.0.37,unc=3D\\silo-azwest-fs.verq=
haus.com\Invoices,user=3Dsilomountuser@verqhaus.com,domain=3Dverqhaus.com,p=
ass=3D********
mount error(95): Operation not supported
Refer to the mount.smb3(8) manual page (e.g. man mount.smb3) and kernel log=
 messages (dmesg)


dmesg output with debuggin turned on:

[ 9733.032860] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs mount o=
ption 'source'
[ 9733.032902] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs mount o=
ption 'ip'
[ 9733.032914] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs mount o=
ption 'unc'
[ 9733.032919] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs mount o=
ption 'user'
[ 9733.032922] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs mount o=
ption 'domain'
[ 9733.032925] CIFS: fs/smb/client/fs_context.c: Domain name set
[ 9733.032928] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs mount o=
ption 'pass'
[ 9733.032931] CIFS: fs/smb/client/cifsfs.c: cifs_smb3_do_mount: devname=3D=
//silo-azwest-fs.verqhaus.com/Invoices flags=3D0x0
[ 9733.032937] CIFS: fs/smb/client/connect.c: file mode: 0755  dir mode: 07=
55
[ 9733.032942] CIFS: fs/smb/client/connect.c: VFS: in cifs_mount_get_sessio=
n as Xid: 105 with uid: 0
[ 9733.032947] CIFS: fs/smb/client/connect.c: UNC: \\silo-azwest-fs.verqhau=
s.com\Invoices
[ 9733.032951] CIFS: fs/smb/client/connect.c: generic_ip_connect: connectin=
g to 10.4.0.37:445
[ 9733.032963] CIFS: fs/smb/client/connect.c: Socket created
[ 9733.032966] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf 131072 rc=
vtimeo 0x1b58
[ 9733.035235] CIFS: fs/smb/client/connect.c: VFS: in cifs_get_smb_ses as X=
id: 106 with uid: 0
[ 9733.035241] CIFS: fs/smb/client/connect.c: Existing smb sess not found
[ 9733.035244] CIFS: fs/smb/client/connect.c: Demultiplex PID: 97842
[ 9733.035251] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[ 9733.035259] CIFS: fs/smb/client/transport.c: wait_for_free_credits: remo=
ve 1 credits total=3D0
[ 9733.035271] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=3D260
[ 9733.035925] CIFS: fs/smb/client/connect.c: RFC1002 header 0x134
[ 9733.035937] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 120 offset =
128
[ 9733.035940] CIFS: fs/smb/client/smb2misc.c: SMB2 len 248
[ 9733.035944] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad=
 0
[ 9733.035948] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added 1 cre=
dits total=3D1
[ 9733.035973] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result: cmd=
=3D0 mid=3D0 state=3D64
[ 9733.035986] CIFS: fs/smb/client/misc.c: Null buffer passed to cifs_small=
_buf_release
[ 9733.035995] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[ 9733.035997] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[ 9733.036006] CIFS: fs/smb/client/asn1.c: Decoding negTokenInit: unsupport=
ed OID 1.3.6.1.4.1.311.2.2.30
[ 9733.036015] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[ 9733.036020] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11 encryption neg=
 context of len 4
[ 9733.036034] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[ 9733.036046] CIFS: fs/smb/client/connect.c: cifs_setup_session: channel c=
onnect bitmap: 0x1
[ 9733.036052] CIFS: fs/smb/client/connect.c: Security Mode: 0x3 Capabiliti=
es: 0x300067 TimeAdjust: 0
[ 9733.036055] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[ 9733.036060] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[ 9733.036064] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[ 9733.036068] CIFS: fs/smb/client/transport.c: wait_for_free_credits: remo=
ve 1 credits total=3D0
[ 9733.036076] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=3D136
[ 9733.036557] CIFS: fs/smb/client/connect.c: RFC1002 header 0x11c
[ 9733.036581] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 212 offset =
72
[ 9733.036597] CIFS: fs/smb/client/smb2misc.c: SMB2 len 284
[ 9733.036613] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added 1 cre=
dits total=3D1
[ 9733.036655] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result: cmd=
=3D1 mid=3D1 state=3D64
[ 9733.036678] CIFS: Status code returned 0xc0000016 STATUS_MORE_PROCESSING=
_REQUIRED
[ 9733.036694] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2 status code=
 0xc0000016 to POSIX err -5
[ 9733.036704] CIFS: fs/smb/client/misc.c: Null buffer passed to cifs_small=
_buf_release
[ 9733.036709] CIFS: fs/smb/client/sess.c: decode_ntlmssp_challenge: negoti=
ate=3D0xe2088235 challenge=3D0xe2898235
[ 9733.036715] CIFS: fs/smb/client/smb2pdu.c: rawntlmssp session setup chal=
lenge phase
[ 9733.036719] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[ 9733.036762] CIFS: fs/smb/client/transport.c: wait_for_free_credits: remo=
ve 1 credits total=3D0
[ 9733.036777] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=3D508
[ 9733.041144] CIFS: fs/smb/client/connect.c: RFC1002 header 0x48
[ 9733.041219] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 0 offset 0
[ 9733.041224] CIFS: fs/smb/client/smb2misc.c: SMB2 len 73
[ 9733.041249] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added 1 cre=
dits total=3D1
[ 9733.041294] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result: cmd=
=3D1 mid=3D2 state=3D64
[ 9733.041315] CIFS: Status code returned 0xc00000bb STATUS_NOT_SUPPORTED
[ 9733.041330] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2 status code=
 0xc00000bb to POSIX err -95
[ 9733.041334] CIFS: fs/smb/client/misc.c: Null buffer passed to cifs_small=
_buf_release
[ 9733.041339] CIFS: VFS: \\silo-azwest-fs.verqhaus.com Send error in SessS=
etup =3D -95
[ 9733.041345] CIFS: fs/smb/client/connect.c: VFS: leaving cifs_get_smb_ses=
 (xid =3D 106) rc =3D -95
[ 9733.041367] CIFS: fs/smb/client/connect.c: VFS: leaving cifs_mount_put_c=
onns (xid =3D 105) rc =3D 0
[ 9733.041371] CIFS: VFS: cifs_mount failed w/return code =3D -95


