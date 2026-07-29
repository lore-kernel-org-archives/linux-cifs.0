Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012023.outbound.protection.outlook.com [40.107.200.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481362D838E
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 19:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353531; cv=fail; b=GV80rTYcV1t9/46Ce/JarlNJfyANiAO0tvy3NCzZVHhnEwvkSGrK1SOYzVuabqaIO99oRrXNA8agEIBT8zcQwjTXBimJ20NEAL+00OtP/Bc79chNqpTNRhQblEC3Rw3wQYObc9mnwPM1sH+Sccx+Oj5Ducy+1lpGSy4TvMTIHM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353531; c=relaxed/simple;
	bh=UeGG4m76VSQrydaAwmC66slWMcBl2QKEiLsP9VAbKbQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kNeEdPpQ5NFDlP0OSilIcTtn3GYs5+x9ltM7RYGR+B9daoegACbgx7saVioGYKjQnOFalNRJtVPjgpcMvk3Esz1GoeLJV0nKhnf6eKzLxIMs9ez2OwsqO+7Nz1krYypJkgrNvuAZEUQNCe0rwa3nj+iIxsmtyjprwMweD3DqGk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com; spf=pass smtp.mailfrom=gehealthcare.com; dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b=sNMNrm5u; arc=fail smtp.client-ip=40.107.200.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b="sNMNrm5u"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j1S61XYxNwtpYvRCyCBBgG3qdMYvwh0mgzW0WCNwA2FXzzm6UnwW5WMy35MI3CfvQqoPrbsmQsvZRb/1ElPMRFB1NOhBhht9HXk5OC9LAjrbmkro7oBDkVIxjs7PdS2/9PmMgvghobraw6flUB6XP3dPPLYUOzX4vzp3UCZC2TFMPvkrF+FLwryFsLc9PYxJBLelRNqAHA1THskK3ccqI3wxiGrcGelqGEDCjwEJJiJfK7XnZ6gQd1TjQqJXC5H1I2SNd018VtyrEWB93DMog9+Eog1rVE6q3IHly3m1vUUqGB7n6jrIC7jtgfmFsi4qqQn7UGG3gpCevgHfQ3t8jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/yYxN++eUVbgk4UUIH8qkyiPra6J0VPjBocGjYPRvU=;
 b=aJFzgqum4anzrMVgTpsAaUxSbVO1BsidyFZZVLzdLr8PlbI23ff4Gn7LGlW8XY+dR948E3gRcVR2UXlRxANMQbtLLndHnFBysuE8opaDshxCE53i/z7vDWtO6IyN03GoGSLomBYEwdZUQMXKU5WbMp3QKw0Y4iiPbJlI+HwXIg1r+ZIWSvZDwb9psYSy4dLpeGNf+vdQps2PB3Twg0cTFPIKkUPEtX/LzxGyQI8znTgcL2riOxBk+Eh16KLRbjewGnlzJo3QgNqWVgDU51z4ntfR0P0NHvNM0lFSoq5aEjybusREygKzXj4DpQU75T1zrtEehsW1IABE1zd64Tn9zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gehealthcare.com; dmarc=pass action=none
 header.from=gehealthcare.com; dkim=pass header.d=gehealthcare.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gehealthcare.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/yYxN++eUVbgk4UUIH8qkyiPra6J0VPjBocGjYPRvU=;
 b=sNMNrm5uS+Hm7b4sMV2bPFE/ClQvuMPSHVGD47NBdmskUzEGBO962oU9nfRLc/YeUrh9HJaJSZA8DZkl7JaF/adTYBGwXQMAY3qK/X4UzCCfhczVWIiIct3UcpuBUrITez5moWvBoTgI9C80JFVFisY8bBi1L2GY0MZdJfow8T5Ord7Y7G7kBBOEnMoOq3o8NNwOlERcM3Ps3aKhI+FFCMKpSEb7zb0VezzgT/wuAFe81dhgTzpSYlNZP5Cuia4quNx2AqZEQO57g6zF1eKpp4ntxZyRUlj8mRa2KIsjNI9UBBiCcwZE3LhyuIaDomQeFg35HUfdv2ObG0lb5od1Ug==
Received: from SJ4PPFA6E5D1011.namprd22.prod.outlook.com
 (2603:10b6:a0f:fc02::fc2) by PH7PR22MB4720.namprd22.prod.outlook.com
 (2603:10b6:510:316::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Wed, 29 Jul
 2026 19:32:00 +0000
Received: from SJ4PPFA6E5D1011.namprd22.prod.outlook.com
 ([fe80::f30:a74d:5ed1:1a4a]) by SJ4PPFA6E5D1011.namprd22.prod.outlook.com
 ([fe80::f30:a74d:5ed1:1a4a%7]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 19:31:59 +0000
From: "Birtwhistle, Daniel" <daniel.birtwhistle@gehealthcare.com>
To: Paulo Alcantara <pc@manguebit.org>, Pavel Shilovsky <piastryyy@gmail.com>
CC: Steve French <smfrench@gmail.com>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] mount.cifs: prevent stolen creds through SUDO_UID
Thread-Topic: [PATCH] mount.cifs: prevent stolen creds through SUDO_UID
Thread-Index: AQHdHunNP0S87yE4bUy/WcVY3alJQ7aE4+CJ
Date: Wed, 29 Jul 2026 19:31:59 +0000
Message-ID:
 <SJ4PPFA6E5D1011B2AB6751329AF683DF0BEECA2@SJ4PPFA6E5D1011.namprd22.prod.outlook.com>
References: <20260728233532.3022799-1-pc@manguebit.org>
In-Reply-To: <20260728233532.3022799-1-pc@manguebit.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gehealthcare.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ4PPFA6E5D1011:EE_|PH7PR22MB4720:EE_
x-ms-office365-filtering-correlation-id: c9ad2996-50c0-42e4-dcfa-08deeda80ede
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|38070700021|6133799003|11063799006|56012099006|10067099003|5023799004|18002099003|22082099003;
x-microsoft-antispam-message-info:
 1/wHGMHKuR+Qd6CTuAAKmdLqFL+FTgN8OkswlkXCFwxbcyhVb37MRf7Pangz56H9FLWSBoRh58h17u8W332eLFsukYs3vjtPh5oDt2kjj3FD2gwuFs/5gqYVZ+7H+bFnseQRZdjsWzX2WRxCRq/uwjIsh12wEKc4WWKdoI7+/NZGSZR4LMkJb8nuvPiDHxe8cYuTZ4FhU+JbpQ9C1xpvkGDyYWhflVCXovWsZxrHNCaRrkEOD1A5mbvbwRCylKMM66c4nbXTlGpXrhtp+vJ4j7d87cObFNrMsy3EN45pzx6DbHbzjoS/f0m6o5ubPOXn1gQwdAJ9/i6n4HVRRSMFmmv05oPw28A2xoV7GCF06j9OskVVmGfLNM3HtViehKgNhf/MdrzvLyqDrRvB3RaoXfu2ysyqRfttErbD4zppVD1zVlhJ5SAvT/jm+MTpx42M4EfVJFLySSB5NIkJPo+YBiXiI9SZrFmg2Z8jShczwXNYztDewN2PAPiF+Gakb60rYcals4KJmfK6cdr8bkKLP66syI/C2XzxvQzO32ZRFeM4xzyxD15m68h9t5DEgKww0CTtptaZrmb3RrOzIx6VG5Ma0N724IKymeOIxCp1XXqGs3ETMvO3Cp36uI80xcFGZCiieq6hOwp8qpDs+YVNm1hFQqwDHlg7s3QbYh95qMVaHy+GjQZuGT3/fJArxnj29bI4g79C8w1wcjTKEE2uQyCdX5IXoFFTrBq2TeBVr/M=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ4PPFA6E5D1011.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(38070700021)(6133799003)(11063799006)(56012099006)(10067099003)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?kMa/NMxbshHOVLkWJnvDmmYBKccyODT1qWE7ToscCiYRa68AmqNHDlXi?=
 =?Windows-1252?Q?ykb3AEZK+Zpf1+IMI0Q6WxJoXdFiCqybzCfU66Nk4fcx6EmH74ToRH7/?=
 =?Windows-1252?Q?rIlPRXApZhR/i0TtN58WUJTwZHVtDqEJ4omg1JbeRfWdCz+Lwvpyf4dY?=
 =?Windows-1252?Q?Q99MRiccgwLVOp1gAIZnN0RA+Bk1MPoeNgyKwY+QX3YhR2CPtMo0ocVl?=
 =?Windows-1252?Q?Pr06FQaSi1epcxhR9/mjUJo0T/HdsMy222P06etR4E8Yz43OLUPGfnCZ?=
 =?Windows-1252?Q?FdX5Zh1y1AlZFgzWL3r7sQoiiFfcAdXRJ0UT1Lv0r6epg/DNW0uwi169?=
 =?Windows-1252?Q?eujADYIPFVyuAzVgJ+KcSHhrGqw/gKsxJqgYXI57iazjXRMwHr8dZvVY?=
 =?Windows-1252?Q?xKC0/LdQxpb2AuqbbPRmQKd45T6j4xyjASkt0+EmHW6CBIZH+uOG3nMN?=
 =?Windows-1252?Q?uqjt5iwpl88Y3NXsev54Zf/exOvtEA03Qi8L2wQjDJS/1HNPXrlnxDeY?=
 =?Windows-1252?Q?w7zGlnwzhX/nsZxq4FWCEVl60KJu38MiKaMElDH7iE9vPGOV1H+YWRUM?=
 =?Windows-1252?Q?0juKhIaihPHdtBikf7lo9kKU7dp7GQ755OIkeHdN7Q5nTemtCcRB0Hha?=
 =?Windows-1252?Q?HefZo3iMYv9iatqWOxKlEmrAgg6Excme7VcE5FsJXsr17kTVqNe/SGLt?=
 =?Windows-1252?Q?DZ1vUxnDx6IUIDoP/NDhNp1S/BAbWCDDZc4usECNDPnLcdxCoxN+Cts7?=
 =?Windows-1252?Q?DGh66pfFMzOx/6JmvI4Mm+uOmIVh3DePZnV8AEij54Vvu4huQ3vPtfMK?=
 =?Windows-1252?Q?I6OwNPxInGAI16dH2FXTcVupxuYZVjbUOHdrlkcxBV1rjJrD6cBXy//C?=
 =?Windows-1252?Q?xMY7U6GIf6qrLc22fJdgHbGvLkaTxjdiv8cIgu98AqHGzSOOflUwwAiF?=
 =?Windows-1252?Q?jSqA1MdBF/l/c/5GpJsI6I1Kf9nFtmE/ko+dGJwQ+ehU39eqhpYfpwPp?=
 =?Windows-1252?Q?UuzlOM6hpkNwa7eHfnGQbQ1rcU0ZJd5hNxAVHztg906lnlPdDom6DZ4v?=
 =?Windows-1252?Q?wg42mmFSFb1QXK4xvDOKgGY0RCXexBnX+3/EYcfVJaurAfIeaMJQwzjB?=
 =?Windows-1252?Q?lO6rJGd8qLWIHI3Ya3yOWKNiArmjNnXGdFp+O2aY448EP8V6CxmngM9H?=
 =?Windows-1252?Q?ZOBFFNZD+uJxXbTxpHPNBjKjCfOa85s8iwBz44Kbxa9/xYHA3MdWkxJ8?=
 =?Windows-1252?Q?CgT6vJN6Z7DfpYcyNEp1A3QgwPs9vSMbut6aZVnNxpdX01fwC7fNbtAt?=
 =?Windows-1252?Q?uR74jBveA4ueq216zieweH6aMahf9htiDsYvAsaNSaxI53Ccr7kGU9Ui?=
 =?Windows-1252?Q?hP6bay3CgFscSih5IDv4O8sQmp3SEWeoQ8nNuVuh54Fr/pN/xBaxNdRd?=
 =?Windows-1252?Q?RyMa/F7XZPxXea2U+NN//XO4uAd44k0DIkqvNCsM6/5HcS2MI604etXX?=
 =?Windows-1252?Q?Xkz8XW+zA1PdOru8KfH14c5fia2nK+SG/dNmEpX1qWz0G2U8ywLmhKGg?=
 =?Windows-1252?Q?itfz54yr+af7hwoFmtKVZWLF3W/SOl0EhlHOQLzv7otxGug0m8cjOzV4?=
 =?Windows-1252?Q?98D5/adCnsAvqyIHgVATHO5wHHb2TZ4iQO/LAjXV48IVcfFrWkuOYkTH?=
 =?Windows-1252?Q?Q05PTrgj1WwXc2Hx11/+iDwsl1i0yqOQ0pchOIyJOZePCr4nGUm9HO4Z?=
 =?Windows-1252?Q?UxaknndgPm4r3vg8Eju8V/VUz4TryBO2LNjNnQa9CjMFvTCzNrY52XdK?=
 =?Windows-1252?Q?EtCaJF2fLv5sJ9LC32nrGsaByjpDmQREuQpKUVFHprzJnnYF2iIcn/7I?=
 =?Windows-1252?Q?Kg/utcWR0rtLnA=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: gehealthcare.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ4PPFA6E5D1011.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ad2996-50c0-42e4-dcfa-08deeda80ede
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2026 19:31:59.2437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9a309606-d6ec-4188-a28a-298812b4bbbf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: anxWMCu265Q9l/X/RPPptBSkppYgtjpLI+UQpPbxFbXkxbVbmJ4v5VbijwNOlA8K3e/0HWmyl/LVk0eqLHa78hCcLAhu+aWzWVHY7rF4LbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR22MB4720

Hello Steve and Paulo,

Yes. I applied the exact patch to cifs-utils 7.7 at
3a7dc396306654aa225c35767e56ac1fb239922e, built it successfully, and tested=
 the ENOKEY retry decision using matched unpatched and patched setuid binar=
ies.

The results were:

- Unpatched direct setuid invocation (ruid=3D1000, euid=3D0, caller-control=
led SUDO_UID=3D4242): the ENOKEY retry added cruid=3D4242.
- Patched with the same identity and environment: no retry occurred and no =
cruid option was constructed.
- Patched root/sudo invocation (ruid=3D0, euid=3D0, SUDO_UID=3D4242): the r=
etry retained cruid=3D4242, preserving the intended sudo behavior.

My conclusion is that the patch closes the demonstrated SUDO_UID-to-cruid c=
redential-selection issue. I am also happy to test the final committed vers=
ion.

For clarity, this validation is specific to the SUDO_UID issue. The separat=
e credential-file TOCTOU/privilege-drop case and the remaining Low parse_un=
c hardening item are independent and are not addressed by this change.

Thank you for the quick fix and for including the credit.



Best Regards,

Daniel Birtwhistle
Senior Director Product Security & Assessment

________________________________________
From: Paulo Alcantara <pc@manguebit.org>
Sent: Tuesday, July 28, 2026 7:35 PM
To: Pavel Shilovsky
Cc: Birtwhistle, Daniel; Paulo Alcantara (Red Hat); Steve French; linux-cif=
s@vger.kernel.org
Subject: [PATCH] mount.cifs: prevent stolen creds through SUDO_UID

CAUTION: This email originated from outside of GE HealthCare. Only open lin=
ks or attachments if you trust the sender. Report suspicious emails using O=
utlook=92s =93Report=94 button.

When mount.cifs is invoked with setuid, a non-root user may set
SUDO_UID to be used on the retry kerberos authentication path,
therefore allowing it to mount shares by using credential caches from
different users in the system.

Fix this by trusting the value of SUDO_UID only when mount.cifs is
being executed by sudo or root.

Fixes: 1a1507654c5f ("mount.cifs: use SUDO_UID env variable for cruid")
Reported-by: Daniel Birtwhistle <daniel.birtwhistle@gehealthcare.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
---
 mount.cifs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index b57c7d346f42..f0e9bc7beae2 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -2145,7 +2145,7 @@ int main(int argc, char **argv)
        int rc =3D 0;
        int already_uppercased =3D 0;
        int sloppy =3D 0;
-       int fallback_sudo_uid =3D 0;
+       int fallback_sudo_uid =3D geteuid() || getuid();
        size_t options_size =3D MAX_OPTIONS_LEN;
        struct parsed_mount_info *parsed_info =3D NULL;
        struct parsed_mount_info *reinit_parsed_info =3D NULL;
--
2.55.0

