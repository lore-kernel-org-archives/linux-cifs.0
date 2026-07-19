Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CA13B4EB7
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 18:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484567; cv=fail; b=CFQBcmqYENjasBUvkg20JDVz8BgBY8eHSTHuQTPn28anir6UajVP0A5ruXaIVbZSH1a7FSPbhxu1jmqFw4RRLp2IZByGO8q3In5TDtgaRtZ8msFcsLvgb0PyRtIQ/eWU6/LpzLxNBLQjSEjyVJ81psBeP6BkQNjAaLDbGJHalC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484567; c=relaxed/simple;
	bh=tyuOQYFZ1Oiq7pjmD/yRCbLYLguVzaVJvjHOQ3V8dEg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=I1eeXCkIZm0TtRGPy6yR4KQzi812/QWaBQbg5kSGySgo30leFe0kz8AYDFeIBCuKAAQEMGnNGI+ZZp46ua5V3zfzFiHLcxaJ+EEDe16ozCsx3NWaiPvRjaaeEB1Sa9wQxSPyLrv5mrEXGIE1xQzbTQ0hvPPLEAabbHR1IS7Cvhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com; spf=pass smtp.mailfrom=gehealthcare.com; dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b=aZmDn8HQ; arc=fail smtp.client-ip=52.101.193.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b="aZmDn8HQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FZMJzKyLa7V5ifMp18BejUXWfec+W1tIWgKVLePxzX15+pOLiw0ay3kuRbUBhn/q4v/zbrTnOEOfU7D0Y0Cq6mSUw1C4XDEEjKnR2+2lht9iDqbX7Nv0LJPIh49CVzyuEaW21GKilNOHHdqsnufgYZ5i1u8DONc6JMZOAdYeDr7IdF4Me1NnGKl26dAdwH2CHfh8MCN7Q22G2pHK5Tg+F2dFIK4emjyqzIrAsgwXyXIKXAsWYcEW76jdiiNfTgj93Mu/FqCEUjgkgq8DopD7C9I7rHVg84xVuz5W4p5cujjp+KM2n1IB3DODKXwKuoHlvZNJCko95lpTr9kmuGx6HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0+PcH9fVlZRYRe5fpE2GaWtTw8nMpQY2pweOXIPlu8=;
 b=mJgtK4YzRnRNGFVpxJnmk37lTtLQCxPWYVK04BT32oYupM/pinabqo/ilVZ6IF4w254Oo0Mi/+HXIR/E+U62DmzlWD9Asg8guzK2SEJulGDkPE3Rt7XkL61OlnB2mwOPOStf6GbuYijH4Bj7YvuR9ZRxhJEiJDTGHPpmVa6CGbJ32fhy+afAs5yhMD5zyvqyLcwwTlaWymHruEWzHHd13gzEI6fg6h1ggIdvYSzT4ZQmk1iypHp308bdEAmweLAEXGL/vOMWz/pbJQhFwfnNIIFoqwjuVN6EahhS+D7Gt4PlEcE61ArcGRvB+Vb7KjCmegoIR7FAaEbJ2iyn22GyUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gehealthcare.com; dmarc=pass action=none
 header.from=gehealthcare.com; dkim=pass header.d=gehealthcare.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gehealthcare.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0+PcH9fVlZRYRe5fpE2GaWtTw8nMpQY2pweOXIPlu8=;
 b=aZmDn8HQExecTw+MRDo3D1f2gXzobEZ+Pot4/vIxn4uvaLWdT0+2O/BuTMaD/YT/WO8E3ST2Y3lif80THW5RvdpXKbDZ4o38pQ5PpFmUL2f74Od9PlSHmNHO+zNjNmrmxDPXsa5fSIX9e8VzjWdWFcbI2SDDJ/dFhLZNV2+HpaHJrtNksx+Lh7yETTdSEI4BhHtfQd9kTaCSJf9x/kjBWthR4duu5C1SoPTHeSXINOCzg4EN6x3pwI+qj+XvFQg/hvogBx5nEQGn2YfX2xj+kTZ7dvkpo8U6q/afuCVXzFq1LWz9fGeqe84kMtJmD2VABZ1/mDzmfs/pM/+RLUyCIg==
Received: from SN4PR22MB2888.namprd22.prod.outlook.com (2603:10b6:806:20b::14)
 by SJ4PPFF91BDE8E7.namprd22.prod.outlook.com (2603:10b6:a0f:fc02::fdb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Sun, 19 Jul
 2026 18:09:20 +0000
Received: from SN4PR22MB2888.namprd22.prod.outlook.com
 ([fe80::3f8e:f720:488d:3441]) by SN4PR22MB2888.namprd22.prod.outlook.com
 ([fe80::3f8e:f720:488d:3441%5]) with mapi id 15.21.0223.015; Sun, 19 Jul 2026
 18:09:20 +0000
From: "Birtwhistle, Daniel" <daniel.birtwhistle@gehealthcare.com>
To: Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.org>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "security@kernel.org" <security@kernel.org>
Subject: [BUG 3/3] smb: client: seal mount policy can be dropped after
 SMB3.1.1 reconnect
Thread-Topic: [BUG 3/3] smb: client: seal mount policy can be dropped after
 SMB3.1.1 reconnect
Thread-Index: AQHdF6mPPBXCoRhUL0KlFT4yno536w==
Date: Sun, 19 Jul 2026 18:09:20 +0000
Message-ID:
 <SN4PR22MB28886AB743AFFB419EFBA70EEEC42@SN4PR22MB2888.namprd22.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gehealthcare.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN4PR22MB2888:EE_|SJ4PPFF91BDE8E7:EE_
x-ms-office365-filtering-correlation-id: 8bf405ec-8f70-44e8-9be5-08dee5c0dad4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|38070700021|18002099003|10067099003|56012099006|5023799004|11063799006|6133799003;
x-microsoft-antispam-message-info:
 YddV1/yN75FeCAtA1VeSDOJpyhHjX4jkCWMoq41PCTZxApWnlOY+U+YB6XBX5VWtKeNwemGOMsTRyeNXK6ky0KmftpdlB5zufeR5X12eVd0s0OUMtwC0rboWcReQHSQE/b+ljnaorGjUXRFAVGdXOlueEUlXZWDA+QEYN9it3R9Tt/VAhdVVXO41UlT98YUiCaUuf5Y4w4fYj5Uu8cBA0li03bJ+RA1tNvQeHgE8ISnT7vQKtTi5/3qiDCeoqw19052IOry/QIT/mCHfdvPznogYTwL7oZunhnFpEeV37rwk4FUArsna6lK188AT+nOmXXYhtJCregtI25cNCJO+ulIjpyicSKGPOVvL6D1xE5JVdLCi3vE1BmA/bF70ikHrhAUovc/TynTNwWpBgsvSTZk58qE4KDlUSFvt8x/7Qe70DUbHvoxxwTznMCiNgT+kVSSM+FhX89NFkL9m2AI7poc0xQi/xL4LCYc8QfHZfxf2MqNfvrNhdeF4+WswTFeCY4nIwYCzn/VxwdPsmPDigAgk/ZfuD8UHgyRYGPNryb1jrsvU8bCAtRDV6XmR20fRNqx78TvyW1b1qwQ4Uj+vpp+f0QkFdyMCsAeqR5qAZEc6NljZvzIfsN/Tx4mkA69BAtubz/C/4Heq4yiDBPpwVlEwmZEZcZ8IpR06Yp605iiIyardo4pHP0s7e0UmATzapalJDgbb4tZIP1yPbo6HUkIff9qMb50gYnI0ZR1b6A8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR22MB2888.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(38070700021)(18002099003)(10067099003)(56012099006)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?v8ZH574ayHayP6JwbDLdj0ono2TVuT7bMnnQU6OnPHr2Zd8AfjC5VHwyAe?=
 =?iso-8859-1?Q?7vkGmrBBteNv3qVsLDI7zCilGHGvoACiAijGYC/jooGzeLlXu88UH3oec0?=
 =?iso-8859-1?Q?vtSY3QPQJKp+9bCU/oUx6y1WR/++mhi/OwW0/N0nQHZ4eYl4tAB71hUJiv?=
 =?iso-8859-1?Q?qy+ehVPRbxDpNefD5SZuaaZPkGXCi1KiKtyT2Ahh628c+SIEciIGAfi6vw?=
 =?iso-8859-1?Q?RpFX4H4dIZEHcyM8VeXiIfvCgGADNnlctNUYwghahJcwIXO+rQlIzNV/Xe?=
 =?iso-8859-1?Q?UQLtn0fWcqkvU1YdZRs1L7Ligx3LPIn0OScp9xZfmZGyj56iZremyMhCTT?=
 =?iso-8859-1?Q?GNZVXs/vgGCjUxNaZgCNrFoi/J6yg+bGiAkpRJElLWND6cUMuRWybwad23?=
 =?iso-8859-1?Q?3wFHRn6roP8vO7ghtht0EqGU5aKqlRlX2PEfLuWyeicGo5uFgpUeTKerpu?=
 =?iso-8859-1?Q?bHrTw3E++DGWyTEfg49ff04m7uI4QxP4p4eHq1cmpLMvj8rdnwj2ew5Llq?=
 =?iso-8859-1?Q?msq8s+7F727e/fs7Kd17pYYRI2LSJjKFyepjrc82hQAOPuSUSM1j2x0ovd?=
 =?iso-8859-1?Q?REjcbg7GxZH4xTCFtlZi7QsDm8ymS/5Rn8hoLow2L/eBshdapnEBBNeYuN?=
 =?iso-8859-1?Q?k93MJ7a4F6quw+1iqV+1gIyaFUqQgAboPay+s4GgoL0MeXCfJvpcB5SEd4?=
 =?iso-8859-1?Q?ve9mQdFHbSy+g1y8rtgvpGVTAN6QnxDGbcr1dTdPdwQJPcLB9vHskpGwnz?=
 =?iso-8859-1?Q?+iWUewPzg5uGDfMuh39+TEygksrW90AgTlnYHeqeG3uTRflPve8Rncncch?=
 =?iso-8859-1?Q?TKBnrRX8f/IN+FK9qT/YEOPlBO0qgPvSRv5KlUN8Vymuq/oWC1bZwqNRFw?=
 =?iso-8859-1?Q?ZtGyCqH58EKVXoP9CuQQl0a03jM/AN0r0ILqnGeBJNw1Ci6rdgkbwdkL0w?=
 =?iso-8859-1?Q?l+MrsM4A5jGDuBIXiYKvloVQX3kXyYFLKcgFHIhuYkq9I1SJOiEhJ0TpzX?=
 =?iso-8859-1?Q?bdW548E8S1g7E+Pl0IAc4yP4DQpUYYQipXVTDSf1D0hEoT8tlbKqJcTMD5?=
 =?iso-8859-1?Q?Ea9EHRDz5anvfwfHi8+SxXnaF1FRMLU8ElZ+QDLapqdy1u52mYt68dSpRj?=
 =?iso-8859-1?Q?RpaEsRFTpvUaDeRI/bzpB+1ZIVY532J3C5qChjDjoid8beSeRHd3/nuLuV?=
 =?iso-8859-1?Q?ANay1kYBIiU6i1ilGiFgam4bCDGDecEhmuFiUDlibtbo/oDNcn5g8+PLJk?=
 =?iso-8859-1?Q?N8y6TPYOlEuBn7Y8PK2znlCKT2vHlvwowLDGU62LUHLJOJykVmb3kI6viU?=
 =?iso-8859-1?Q?r9YDy4wjZPeGL9z9vmXLPvaLUtodnZYTtv5TqagA/AupTLYX5UARX6ItYt?=
 =?iso-8859-1?Q?m1+88SJlgRthS7tSkYDZzsPWP5TBSxK9Oetwlz+vHPIeiqVrvuW256phhL?=
 =?iso-8859-1?Q?AzmiziBR6Ts/HzP+p4u9M8ZZA6TTW1dVG9uooCbdHzgL8ixSVBYDCUmIEa?=
 =?iso-8859-1?Q?8X5gSdI6zl+YxIVXZ7ruY0aHe8vYVsfdn9tjQezmgdIaA0vme/ny7C3ZyX?=
 =?iso-8859-1?Q?I5xfelY+f8cBkdyzxgJZdlf/mXsDB72hZybxw5RxEDngFAS++GQXDGfqh2?=
 =?iso-8859-1?Q?uoYv9SyHbQTVDXe4hsv9ubW7jqwRHHCHX+NBI/WVR1lno4cu7jcTJ0t2Oz?=
 =?iso-8859-1?Q?qZQiiNLzSeARZzCemsNupmasX7uPmtQ86y9lpiFOWoPKAR6zsgXNKnbbt2?=
 =?iso-8859-1?Q?RPuzHha5LLdvy5Iyh05TZzdE+YFkLKDTiW1zjrBe1oXLUGxjH8e3CNxAlA?=
 =?iso-8859-1?Q?8ICNRtlphw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: gehealthcare.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR22MB2888.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf405ec-8f70-44e8-9be5-08dee5c0dad4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2026 18:09:20.0866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9a309606-d6ec-4188-a28a-298812b4bbbf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VdsnrmrBofi1EFfLq1mMvYyBaHxpkbLC8D1S4GnuGXYv2H1i6G01VJqhGZZBSdrwJLKolFpn+UU4d1yIABnF4tgFTObb4x1W9y3d7ANhJxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ4PPFF91BDE8E7

Resending in plain text because the original copy was rejected by linux-cif=
s due to Outlook always wanting talk html; apologies for the duplicate to d=
irect recipients...=0A=
=0A=
Hello Steve, Paulo, and linux-cifs maintainers,=0A=
=0A=
My name is Daniel Birtwhistle. In my role, I assess security properties of=
=0A=
software inherited by GE HealthCare products. I am writing personally as th=
e=0A=
researcher and technical contact.=0A=
=0A=
This is the third of three coordinated CIFS client reports. The first cover=
s=0A=
SMB2/3 response-signature enforcement, and the second asks for classificati=
on=0A=
of server-provided symlink mount confinement. This message covers a separat=
e=0A=
SMB3 reconnect invariant and can be fixed and classified independently.=0A=
=0A=
Summary=0A=
=0A=
An SMB3.1.1 tree mounted with the explicit client option "seal" can reconne=
ct=0A=
to an otherwise authenticated endpoint that does not advertise encryption a=
nd=0A=
continue in plaintext. The client logs "Encryption is requested but not=0A=
supported", but reconnect TREE_CONNECT succeeds and later file I/O is no=0A=
longer encrypted.=0A=
=0A=
Runtime confirmation=0A=
=0A=
I reproduced this on Linux 6.18.12+kali-arm64 with Samba 4.23.6, SMB 3.1.1,=
=0A=
NTLMSSP, mandatory signing, and client options sign,seal. The first server=
=0A=
supported AES-128-GCM but did not itself mandate encryption, so the client'=
s=0A=
seal option was the sole policy requirement.=0A=
=0A=
I then terminated the entire server service cgroup, including its per-clien=
t=0A=
worker, and compared two replacements on a fresh TCP connection:=0A=
=0A=
- An encryption-capable replacement reconnected successfully,=0A=
  smb3_encryption_required() remained 1, and all post-reconnect application=
=0A=
  traffic remained in encrypted transform frames.=0A=
- A replacement using the same test credential but omitting=0A=
  SMB2_ENCRYPTION_CAPABILITIES also reconnected successfully. The kernel lo=
gged=0A=
  the warning for both the data and IPC trees, smb3_encryption_required()=
=0A=
  changed to 0, both SMB2_tcon() calls returned 0, and a fixed canary was r=
ead=0A=
  through plaintext TREE_CONNECT, CREATE and READ messages.=0A=
=0A=
The matched packet captures each contain 88 packets. In the downgrade cell,=
=0A=
the initial stream has 36 encrypted transform frames, while the replacement=
=0A=
stream has none and its successful READ response visibly contains the fixed=
=0A=
test canary. The capable control has ten encrypted transform frames on its=
=0A=
replacement stream.=0A=
=0A=
Current source=0A=
=0A=
I rechecked upstream commit=0A=
980ab36ae5972c83f683b939e50c469c4947229e from 2026-07-19. Re-negotiate=0A=
replaces the active server capability state. On reconnect, SMB2_tcon() logs=
=0A=
when the existing tree requested sealing but the new server lacks encryptio=
n,=0A=
without returning an error. smb3_encryption_required() then conditions the=
=0A=
tree's seal request on that new capability and returns false, permitting th=
e=0A=
plaintext traffic observed above.=0A=
=0A=
The log-only reconnect check appears to have been introduced by=0A=
ae6f8dd4d0c8 in 2016 and remains present at the current commit above, givin=
g=0A=
an affected source range from that introduction through current mainline.=
=0A=
=0A=
Scope and fix direction=0A=
=0A=
The terminal downgrade replacement deliberately knew the test credential. I=
t=0A=
isolates and directly proves the encryption-policy failure; it is not a cla=
im=0A=
that an unauthenticated replacement completed this exact end-to-end chain.=
=0A=
Forged encrypted responses still fail AEAD authentication. The first compan=
ion=0A=
report separately addresses bad-signature response acceptance and may compo=
und=0A=
with this behavior, but I am not representing the combined no-key sealed=0A=
takeover as runtime-proven.=0A=
=0A=
The client invariant appears straightforward: an explicit must-seal policy=
=0A=
should survive re-negotiate, and reconnect should fail closed if the replac=
ement=0A=
cannot satisfy it. It may also be prudent to reject plaintext responses whi=
le=0A=
an active tree or session is under client-required sealing, instead of deci=
ding=0A=
only from the received header form.=0A=
=0A=
I built and differentially tested a candidate that rejects TREE_CONNECT bef=
ore=0A=
request construction when the retained client policy requires sealing but t=
he=0A=
new server cannot encrypt. On maintained 7.1.3+deb14-arm64, the capable=0A=
replacement still completed its sealed reconnect and canary read. The=0A=
capability-clearing replacement authenticated and established TCP, but ever=
y=0A=
tree reconnect returned -EOPNOTSUPP and the plaintext canary was never retu=
rned.=0A=
=0A=
I have the candidate patch, guarded matched harness, raw captures, transcri=
pts,=0A=
function-return traces and a hash manifest. I have not posted or attached t=
he=0A=
reproducer here, but can provide the minimum evidence directly and can test=
 a=0A=
proposed fix.=0A=
=0A=
Please let me know how you would like this classified and whether maintaine=
d=0A=
stable branches should receive the correction.=0A=
=0A=
Requested credit, if useful: Daniel Birtwhistle=0A=
=0A=
=0A=
=0A=
Best Regards,=0A=
=0A=
Daniel Birtwhistle=0A=
Senior Director Product Security & Assessment =
