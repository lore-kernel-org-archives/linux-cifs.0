Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011013.outbound.protection.outlook.com [52.101.52.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D303B1EEF
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484308; cv=fail; b=gWd9/lEUynkC56OurmCgbmn0foH2uYMrz2GuOSYR8nQHzYVa3nkbW0Ve5G7IzDNnTHG3PCcMogfXaQ6b35HBzT/TBwlJkak5gcx8cFLdOaVF9tcCErZulg96C8wqdknO4003PrZNepLFIOUtW/YzinQuabbL681mXd+QIWyYSro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484308; c=relaxed/simple;
	bh=6MNLhQOu8Dd1PIsd46IAj7cfeIjgD297dQaJk/aJxHA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=V2/GlZFX4dW8CIzjVbBrtxWgz5NvqpkRMid6KfrGXFTLjjm6v1VhF8qZAedMAC79xCIjEW5Sv1/8Ow7yoKRw8IFHpgxl+icYNZA5G+w8Sw6AyWbJ7I06l3SeEGC86/V9GK2R4g93cj1K+gZ35KlI4Kzq1utN5ePMbmm9gt8QMgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com; spf=pass smtp.mailfrom=gehealthcare.com; dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b=arRNB6lc; arc=fail smtp.client-ip=52.101.52.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b="arRNB6lc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VI98WI2G97eMb1s8PnDgGCAV75vz9Z+/XK5xGeRrPPlCt2lfqVLz6521lKoqlnXyTB7lYhK6nE9Ok6bA6OUAHTRMg7rZKaDX1/32r/M6kL1+M8K3DlQIEAiAFSaaKak1ImpHxybNItnFFP8VO0y6mromLLdJ/cZngaMleNKap3LfwdPV41nV4saVcaqjoikCRcR+GasV7fYJwU1JsDv5A7UsBrYupWZdNgpk2KFEDxN+fMGSZDVHctlqL9IYJNkEW2CaGwIBs/69mw9mxhlRcZeLgDhdrqdZUuWhRNAok3dd73sWSNSBDjf631hIlHmtFEmwjsuxnPNBAQVThExipQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLAvWKXIiU1VX4zp47d4bxdZB+vDPqeO8uJFabCCJvw=;
 b=KuyTkEAwVxBRgQE19Uhfanfmd8lbea0GQOsElPSdMMBfhrS4bnx4F5ml5MO6KX4+CqUH4h2N9QrANpFijnsgM0+FGSSAhOXgEEAitor+ksHKoRuByrXEw0DIZXCXN3hH5K9ac9j7ILVYlXyPCKo+GpvJ+w5Ne0mC2LNiS6TfK2xYFs6gIgzTvL0tSvmfDp13YsoTgWXSsxC5giCk1LgTPexMqff5sUbIhqNiBkpXL41J/2LM0MfubEe3wQ2jwdKneO74Bjwo9SRBSwDX3C3FHXYRK4IEfKTtl4Fv0+LNoZwDRFFgnKt1qNEK+14uQNACwc06XHyZri7Gdq7BwWQQGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gehealthcare.com; dmarc=pass action=none
 header.from=gehealthcare.com; dkim=pass header.d=gehealthcare.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gehealthcare.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLAvWKXIiU1VX4zp47d4bxdZB+vDPqeO8uJFabCCJvw=;
 b=arRNB6lcfG0VO/3n9OFJVrzWoPNmSzrYJefxsXNkvX80uu1lPI0c3XKRI5o6qMWiYkGDA2KdrLriRmFzVxWigzKsq9l3HPOC4WKkkmpMFnVg023I+OcRARtVX7WI7MsgAT6iTHwlEs5TaejDbJn3zPPiXAfk1g7+8KLfwrGbfzdh3s8rXcHcALlnKgz3lRINX6f3O287+ZS7hLBD+4DPKoBKNiBLfrjYDooy1PA7Y4fy1TF3Xp2PwIbumUt2Qh5PUW4BnO9W16Wy1b7AGiiqgFx6kIMLX8zkcKS+ojYfwS6294Hb+Ku9zhkephYW2MV+uHEeNWyVKG0vie2voz0pvA==
Received: from SN4PR22MB2888.namprd22.prod.outlook.com (2603:10b6:806:20b::14)
 by CYYPR22MB4202.namprd22.prod.outlook.com (2603:10b6:930:ba::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Sun, 19 Jul
 2026 18:05:02 +0000
Received: from SN4PR22MB2888.namprd22.prod.outlook.com
 ([fe80::3f8e:f720:488d:3441]) by SN4PR22MB2888.namprd22.prod.outlook.com
 ([fe80::3f8e:f720:488d:3441%5]) with mapi id 15.21.0223.015; Sun, 19 Jul 2026
 18:05:01 +0000
From: "Birtwhistle, Daniel" <daniel.birtwhistle@gehealthcare.com>
To: Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.org>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "security@kernel.org" <security@kernel.org>
Subject: [BUG 1/3] smb: client: SMB2/3 signature failures are logged but the
 response is accepted
Thread-Topic: [BUG 1/3] smb: client: SMB2/3 signature failures are logged but
 the response is accepted
Thread-Index: AQHdF6iRtdczLk+zuESZipdBMHnh1A==
Date: Sun, 19 Jul 2026 18:05:01 +0000
Message-ID:
 <SN4PR22MB28883DAF57E0B4D4BFB1C22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gehealthcare.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN4PR22MB2888:EE_|CYYPR22MB4202:EE_
x-ms-office365-filtering-correlation-id: e075054f-1015-4395-768c-08dee5c040cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|38070700021|18002099003|11063799006|56012099006|10067099003|3023799007;
x-microsoft-antispam-message-info:
 RdhjqhL2qdSf+UaG0VbY5mi6d1vViorhIF3ijtSiEA8BnB1qND8VZIt88x4kvDM5WPAgXVC+xltYaVcalclKCthn/ysE94Bo0rks/UtexK6twdAVcQM05G62bGyKi+Ybf44f8/MdBvgzqBU2aOTslKuusbA0FQW23yITMyH30DNgaxRfzNvDE2+R1oPCv5MJHAGolzPvUkbxIN8D9ac+Tfn/h6L4HGaL9z74E2GR/mpMEEy1BZs4ao4wXxGNSHCcLlFyyyt4hpsiD6mcx1n7DfIStXpAXlui2LpmncWHFrXERgiouv4ZCX34eu3QHJayMG0G0KZPpwTPSKB6l0PAmQoM709x6tSu3gjiAnugacm8PoKl5WpkdwboL7OOJBottsF1E3WEVck8RYaUhD0/LChovORUZp7N1tHghhvt5N9veR70iTlZd3+SPp0SkMcTriGDphfjpw1j2MX0YZav61KiVBeezgQEheZ/Qu50GimZIlM4rf/rsI0gzhVxeotPnaWM25alcbbSNPrearuDvNLYtNppPWjBrXzGpaQKAe8vfT+sHELSt74Uo4tmuGXDt7ZLDJay/LtE+KmEBzYk4evm06+V+m/22ylZINWF1ui9LHPc8wviyD2qCJrDc3oZx+ZC1VPa1c8fvxRfdvT1HdTmcqbwN6UsvSKuYqiRvQmgevLXc9pWIblnBuFeAC4bjUdqQuxLUcll9KAffpkfKm+6+3FUGXC+auuM5BdzlV0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR22MB2888.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(38070700021)(18002099003)(11063799006)(56012099006)(10067099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?eHCT4TluUIzHz/LwKVadzc0WFCrzWOBBrO61EfbUKD8rYEV1DqJpArWP5x?=
 =?iso-8859-1?Q?W4zApG98jFskRAmofJt0nOg7aJHwTetvXFGz8C6zN7PUxEur5ufn2scBSL?=
 =?iso-8859-1?Q?e1lSPEs1K98R5einrROXxqT75582NBrQxfhb+/3DOXXrn9bfKz3pDrDUGY?=
 =?iso-8859-1?Q?OQem/uT3jlAbwFVa1FBkk6w4Ymxaej2Pe8cXAbXUY1z7MYeN06c/CJcjgs?=
 =?iso-8859-1?Q?Eq5UhllgKq1nTP3BgMSpOTTaSI+y5Q5DAtE/7apEcJeY7/hxDM8qfoocwh?=
 =?iso-8859-1?Q?LYp5fbx9KH4JgRdjCzvqQB6vVAWlchXdR6xAMDH6USj6LOG7faun9Iqvj/?=
 =?iso-8859-1?Q?GdqpAwokp4y56jvkvYtkrmXURIfb6DH/QXDuCh68HGmIP9oTCLtugyRwln?=
 =?iso-8859-1?Q?6S1guf9BpmRCWwqCef63Ekp3OR4nyQdI8Y67SB9xc+FyzVIKEIXvf9l+nH?=
 =?iso-8859-1?Q?tpbGujaCLKTfzRwxTWzKiIIph5YvhFRQDPuheUtEc9Qy9L/csCcQv4J9Cv?=
 =?iso-8859-1?Q?zjRKS2W8BK41Xd/LGH30UinVkH/iAlbvH8z+jlAKW1UfbcRfr0tfElT4l5?=
 =?iso-8859-1?Q?IrZdwc9zPDNBTDi1CDAfe9om0PYQDa6lMjc5FHhuv70NsnekUdY0Bp1hoD?=
 =?iso-8859-1?Q?tZejKGdxl19Dis7L99PQN9IMp6Y8X9leSBT0mxyzlAWo7dp+XZAtMwfzWs?=
 =?iso-8859-1?Q?9BOWp/c1iT9ASgA/jvqUcjBZcogcfv/0g7ms5eUnYEI+dS7GRGzr5db6Z7?=
 =?iso-8859-1?Q?C/fnh38z6oxhi44PMeWhVc5QZzsh8++DmB6sOCpPw4fh6GImtAnDTInEP+?=
 =?iso-8859-1?Q?nlIGIrXOmYBGhfMUUwkSFiIsQ4Eir8hJFfRHpZ1M8TxCLJ3p8iyFrrxXGS?=
 =?iso-8859-1?Q?oIejmADxZfWIqffM/n2bjZkumzWlc4uqMpNvFdYnlx1cm5jXnaWY84CLVJ?=
 =?iso-8859-1?Q?IJ5h7CKXLGV+kLWVfNnBhyy7cPHPPZQalztfUuNmxUDPe9LuyZ+AHVP8J7?=
 =?iso-8859-1?Q?aq3NBDpcrLZPp/G5HATvV+rSISzDOI16vaANOTPWxnrqs2PRPOHzxIN3ZB?=
 =?iso-8859-1?Q?64UwPQhfn6OgQPmqnqrEUCXzJIdvdPrQvcBmKIVtQ2wy8CM14xxGN5+A8A?=
 =?iso-8859-1?Q?y34zzsNffDMiG61V1q2add+3w5wAqRND0GM6aSr5KCGFDmwhsvKwDWtRw9?=
 =?iso-8859-1?Q?6c3wQohMlEPsEH32G8UWFnkUikjvi32Z+2R46WNxsJTKfDa0wV0XbModgz?=
 =?iso-8859-1?Q?bHKqrPAy/dzVixu+SNs6H6+GtQiFjffvGE03u0pTm6mZmkZG1/CJfKGhQN?=
 =?iso-8859-1?Q?/yeHb29I48pWdd3PGJ1wU12knN+7wo9I4GKtCF32nZBXaizXsj7/te5sdB?=
 =?iso-8859-1?Q?bh3/Ra9sHxufo1t4KjJIGS5NGLdB95s+iByRQbw3N5uBzs9yP+28Rr8gqZ?=
 =?iso-8859-1?Q?Kh+E5ypfGeDPIbP7zOR0H7eTZ6d3vrndFyDuT/tnG/OLLKcRJBCCt5w+s8?=
 =?iso-8859-1?Q?ZXbVebJ3l540qGtiBTm2/5pOIeTRJpfKXgPBwF2mfAYrmMxXX/DU/V7at0?=
 =?iso-8859-1?Q?bKU0PSLXcAVxALBwkcatTbis445Wjw7NMi6/Y8DhKUExx8+4T45l0gI49p?=
 =?iso-8859-1?Q?jaZXkBuiN2E2nAoe0Eb5eaVHW18H+Aj8VGGM4jLs7WgNYV1aM/+F010Pxr?=
 =?iso-8859-1?Q?WqxeZAh3PiPw+9voKINJDRXuMbfuLHPrmYzLt1xCu9TXQoZZCmTI0rG3F4?=
 =?iso-8859-1?Q?Hz3imI86tAai/NRjDF7bsvnjX2/bCSdjnfSfZDu1hRReTN0HOGvU8FogO5?=
 =?iso-8859-1?Q?LnHlHlCWMQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e075054f-1015-4395-768c-08dee5c040cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2026 18:05:01.6781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9a309606-d6ec-4188-a28a-298812b4bbbf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tAawciE4eDLTEqj6uRG9VEhXcoG3ZzvoIBlc8Xj6OaTuy4TUhHh6ZlSRvvdehx8OL7sBxUAHIE0qrCxLAvoAahiKOoD45dmDE+JOh05Oles=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR22MB4202

Resending in plain text because the original copy was rejected by linux-cif=
s due to Outlook always wanting talk html; apologies for the duplicate to d=
irect recipients...=0A=
=0A=
=0A=
Hello Steve, Paulo, and linux-cifs maintainers,=0A=
=0A=
My name is Daniel Birtwhistle. In my role, I assess security properties of=
=0A=
software inherited by GE HealthCare products. I am writing personally as th=
e=0A=
researcher and technical contact.=0A=
=0A=
This is the first of three coordinated CIFS client reports. This message co=
vers=0A=
response-signature enforcement. The companions cover server-provided symlin=
ks=0A=
escaping mount confinement and client-required sealing being dropped after=
=0A=
reconnect; all three defects have different fixes and can be classified=0A=
independently.=0A=
=0A=
Summary=0A=
=0A=
On a signed SMB2/3 connection, smb2_check_receive() calls=0A=
smb2_verify_signature() and logs a verification error, but then returns onl=
y=0A=
the server-provided SMB status. A response with a bad signature can therefo=
re=0A=
be consumed as successful on this synchronous receive path.=0A=
=0A=
Current source=0A=
=0A=
I rechecked upstream commit=0A=
980ab36ae5972c83f683b939e50c469c4947229e from 2026-07-19.=0A=
fs/smb/client/smb2transport.c:694-716 still has this sequence:=0A=
=0A=
    rc =3D smb2_verify_signature(&rqst, server);=0A=
    if (rc)=0A=
        cifs_server_dbg(...);=0A=
    ...=0A=
    return map_smb2_to_linux_error(mid->resp_buf, log_error);=0A=
=0A=
The verification rc does not reach the caller. All current SMB2, SMB2.1,=0A=
SMB3.0 and SMB3.1.1 operation tables select smb2_check_receive.=0A=
=0A=
Runtime confirmation=0A=
=0A=
I confirmed the behavior on SLES 15 SP6 kernel=0A=
6.4.0-150600.23.60-default in a controlled reconnect test. The replacement=
=0A=
SMB endpoint did not know the password, NT hash or real session key. The=0A=
client logged repeated signature verification failures with -EACCES, includ=
ing=0A=
for TREE_CONNECT and later synchronous commands, but TREE_CONNECT returned=
=0A=
success and the client consumed the subsequent responses. A harmless synthe=
tic=0A=
canary demonstrated the resulting path; no production system or data was us=
ed.=0A=
=0A=
The result is not dependent on the separate symlink classification: accepti=
ng=0A=
a successful response after its required signature failed verification is t=
he=0A=
integrity failure. The companion report provides one concrete downstream=0A=
consequence.=0A=
=0A=
History and fix direction=0A=
=0A=
The path originates in 3c1bf7e48e9e ("CIFS: Enable signing in SMB2"). Commi=
t=0A=
dc96f01d54cc in v7.0-rc1 described the same log-without-action behavior and=
=0A=
added enforcement to the SMB1 receive path, but it did not change=0A=
smb2_check_receive(). Commit 2c1238a7477a changed read/write callback behav=
ior,=0A=
but the synchronous path above remains.=0A=
=0A=
The expected correction appears to be propagating the signature-verificatio=
n=0A=
error rather than mapping or consuming the untrusted response status. A sta=
ble=0A=
backport would be needed for affected maintained branches.=0A=
=0A=
I built and differentially tested that minimal candidate against maintained=
=0A=
7.1.3+deb14-arm64. A real Samba mandatory-signing control mounted and read=
=0A=
normally. After replacement authentication without the real password, every=
=0A=
bad-signed TREE_CONNECT returned -EACCES and twenty bounded reads failed; t=
he=0A=
canary was never returned. The candidate deliberately does not force reconn=
ect=0A=
from smb2_check_receive(); it returns the verification failure and leaves=
=0A=
transport-lifecycle policy to the existing caller paths.=0A=
=0A=
I have the minimal candidate patch, source harness, raw transcript, trace=
=0A=
results and matched controls. I have not posted or attached the reproducer,=
=0A=
but can provide it directly for review and can test a maintainer-proposed f=
ix.=0A=
=0A=
Requested credit, if useful: Daniel Birtwhistle=0A=
=0A=
=0A=
=0A=
Best Regards,=0A=
=0A=
Daniel Birtwhistle=0A=
Senior Director Product Security & Assessment =0A=
