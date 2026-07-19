Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010055.outbound.protection.outlook.com [52.101.46.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B58B3B0ACB
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484467; cv=fail; b=Qig8qfcBX74TNkNX7p/6K0VXZsGxSXUmIJsQ1djFjKuo9308kwfh+N7PR6uNnuD/nUvgffZJg3xI9QgI6ycmkP8cr4ci3mMAW34mQSAI+IGhI25h0a8eUU9FNaud6ONS+Z0dN4IPTD3KiL4JYGC1nAA7r7rAdofuWWrUk0vi3sE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484467; c=relaxed/simple;
	bh=LEqiX3KGxiI/16gDWNMCzkd0/jUVKhdvBkfVGMgWktk=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kfjh/GqcxZWiVIsjTNUv/MfC0o6tqLW5GxVQqvQMSjM2+fRZ+jfcJtDZM9si9BBcn4yNR3azyvuixaZYnaav5zacme27qPPSDqoEEiB1V3Kqq1z9vnnS5ra4JFObe00sZ+uaVGM/LGi5RtkJjimGk6uhxBbUGWldmO1D77q8vUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com; spf=pass smtp.mailfrom=gehealthcare.com; dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b=V8Q+UxeE; arc=fail smtp.client-ip=52.101.46.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b="V8Q+UxeE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ICeJEHnoc4ioQo0blxZVB+lU5jRJHsMzUyjvBbSyY+qiBy9OF1K+bUcb0PxK4gDv0yGI2Waiz+pY3V1GZhbmqv2U9Nh1uI4AW13KYFbQJbM4DRfY706buHiA16rakTFvgmT7T3s5ot3QAtTj3ctKKUz5dlwJZFm8E8Hq3ErqUwg9cXHG0pTlln5HmcCtnmqEimxvYPIznNHQ9Ib54gbAnw+ZQXvhoo6rZwkQX5C7bSfQJBUaz0HFL/QmrP/yIwSMDNlxentSr500OSLNqaFEZyT5Uc94+fUyvWB3vpqqNECYN+8MyEpENh6y0tCjc8otSV3/t3bsqQ7yeAk2UXIx5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/0bNMvEBdTVdsIaGlSn0x3XX22ZFNb6U7HgW470HfY=;
 b=TQGyAcMVJ8m7+8ScpcHYInAbGTc6WT2U6+6MJT4kQZ5p4vlhRvz4Myz62HxW4K3CydLZFz4GsJlZcihcI6KQL5B2/1CsXXas0wcfwu9WQrv6NOiyMQsy4JmgbMK90m0ajG0/SZJ7J8ECAQI6uzrUcIlRG3j6tNFNU4eNUlUFMI4fXUUOB4XZOt3Ig2Fa/77opmQPU2/mle3agFlZcP3ts6nSwvBhBv6Z66g+Xenb+HVkCKmCyQMHk0tYF8rXPMZhMNresG1p+sWoAY4y08VoyX8mwxFPk402/BVi6iort9VHjcvi7p4wYugo7y6blYrl/IXJxGXv6UxiDh3cV5+nQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gehealthcare.com; dmarc=pass action=none
 header.from=gehealthcare.com; dkim=pass header.d=gehealthcare.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gehealthcare.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/0bNMvEBdTVdsIaGlSn0x3XX22ZFNb6U7HgW470HfY=;
 b=V8Q+UxeEtpbTj9N02kFXY1pf3D4oySU2E9GlRdE1x/amPOtGWIxCOf5OOx2dMvzxot1V0mzF1IXkvCPnI7gUfvJg0OS86Sxmi1GiC8mQEhNjLl/hd3nwUtd+phEKDkhljLPfqh1Bc0hCO5nL5l46kIqNQ8/bhDfuiVGm4uNi/zZUyyONiDXBrvCQ8v9hpKUm2Y39rk2l16fiAxwZDASWp8JBKhfevvVhUo0oF4/ecDRwbgKZKntoDL4dmqqKA1XeBGh+iyDOF5J6EFLrIJlUQEU36FRGx+OneC1iN4a8rJPpn5MFbhcr8nuCyYCbyu9hPdph5NDGVmLnNdboe6bAoQ==
Received: from SN4PR22MB2888.namprd22.prod.outlook.com (2603:10b6:806:20b::14)
 by SJ4PPFF91BDE8E7.namprd22.prod.outlook.com (2603:10b6:a0f:fc02::fdb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Sun, 19 Jul
 2026 18:07:38 +0000
Received: from SN4PR22MB2888.namprd22.prod.outlook.com
 ([fe80::3f8e:f720:488d:3441]) by SN4PR22MB2888.namprd22.prod.outlook.com
 ([fe80::3f8e:f720:488d:3441%5]) with mapi id 15.21.0223.015; Sun, 19 Jul 2026
 18:07:38 +0000
From: "Birtwhistle, Daniel" <daniel.birtwhistle@gehealthcare.com>
To: Steve French <sfrench@samba.org>
CC: Paulo Alcantara <pc@manguebit.org>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "security@kernel.org" <security@kernel.org>
Subject: [BUG 2/3] smb: client: server-provided symlinks can escape mount
 confinement
Thread-Topic: [BUG 2/3] smb: client: server-provided symlinks can escape mount
 confinement
Thread-Index: AQHdF6ku1OVZLDYpy0yF//s0Z3FS6A==
Date: Sun, 19 Jul 2026 18:07:38 +0000
Message-ID:
 <SN4PR22MB2888DF178954D994BC30311FEEC42@SN4PR22MB2888.namprd22.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gehealthcare.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN4PR22MB2888:EE_|SJ4PPFF91BDE8E7:EE_
x-ms-office365-filtering-correlation-id: 33f4a18d-3fcc-406d-0b68-08dee5c09e3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|38070700021|18002099003|10067099003|56012099006|5023799004|11063799006|6133799003;
x-microsoft-antispam-message-info:
 ryZBqzNmnVWkJ2lfAN37UrM42QkjBU93fo9r109oMBVsiLc9uc2reIVkRgGAZGbM53ozm+1aDZwbwlQDeug4vOieTnqrSBH5OCOv2V5TkkkjxwqyaceUd23YfCyp8Me8MdhILlY1gjOa2gdBEktY1XnsG3+K9/jteiQ066axd0+ovVqZpKgpvDWHePU5gZZ/btFx5JjkS+vcMJEfkTVCvesm/8ohcYw+JGtuOdg4NsdQ/uneG0JSJA4TNhC3o2vGhJIU9Gq+jw/aHIh4g15G5P4CmRKsF42cRrb5/8LoTu4ckC52hP3/ACjpLx6/APELl1we/01L7M+OboRgBfNFKt/lE8e7KcwJLBKwg3IOxCvRqlnqt8/bpc+9HzfDbrlrt0IQAbkPgZ5Dd/7AX1YSsWNMmAkK3iWwzp8NmiWvyaikfkzbJeTVePv5JJ6MFRzw6r+oHtse69iqd2OGWtpxIM43DOSUh0rNkdoggmZOqyVtU1UxGhlmc+Y+t/UTdZPJv55QtpviHXmFk/KRK6PlQR+FAJWSnNSJdFEGbz7eMXKQS5I9X1agMvYUkeBt77uyzO2Glrk0vLZPtfybR71AD5YhfmbeGKe6WCxUBQ/eAz1fwu09FMktzHLN8EnBl+DEadnDvHkJ9tzGz1ut2bEZaMYjxc60rRvYW0OVqZ6Sf6C+uAMFakH03G8qrl3Yxp+1hdZzFD+tiWWApQ03v16VEA5yxAUz0bVXE5qV0uPFnHE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR22MB2888.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(38070700021)(18002099003)(10067099003)(56012099006)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?S4u9rjTQnS2lPLZw4Mqd0Ucu9FUX7dcDVTIuyWGdFWT7JID5SW6xKiFa0H?=
 =?iso-8859-1?Q?FSus2x4UK0rbVn63A/YWngl9fStj4W2SLN9wsr8iq/PYesktjD/rxJiYf8?=
 =?iso-8859-1?Q?XTtjAC4Tr0zAHc8oJiOGbgU8JsADiDtLDfkMFeDU9t72j/jRfvTOA+UjS2?=
 =?iso-8859-1?Q?SB8n3C6eBUgpLo5ox35xAaEzEI8sGLk3inusat1Rk1TddmZGoNSq0KUhob?=
 =?iso-8859-1?Q?l8liqEba8jhiHil3xQVQlxmhgu8ItuFHClNOderiYrGzIIshLbU1hkUWjg?=
 =?iso-8859-1?Q?ud44iuM1OR6+skJx9tEhcwq6xUN1lDRhjRhBOPES2IQoj8Sa+aXy6qbp6r?=
 =?iso-8859-1?Q?KV/P2QSVmkT1MRkqEwW9kwrpI56UmXqeRt7ZZzI70w0IqlRsIfTyBg3rky?=
 =?iso-8859-1?Q?Mnn0+QKBSfme92AhR1NQxABwJo8pOINRp8cAPvIGTGAOXq6ZoA1joOzRLV?=
 =?iso-8859-1?Q?yivS6ehp2Zjd6xOHgpPOpTuD3gcr33jKlKJDHBBlLm3IACdBbvwgmLopbG?=
 =?iso-8859-1?Q?0qw1p94N5ctyA4nQuwxJBYQAb7kmIB2xuWtETG3L7suuCxwPj5CH4mOQwK?=
 =?iso-8859-1?Q?1ylnmf0xvJ6Xw50QzdD8WrytBeaREdYcsEXoPELl0PT2TWZlJdRuIsxS5S?=
 =?iso-8859-1?Q?qTrFoh1rY9/TLNthgmRUDq7rwq/PPlNuB6HZaY8v5nrRYiYVvE2UIMPXYL?=
 =?iso-8859-1?Q?lZRqxBkXD1VF/gEgePxRIIJV5SYczeeQQoT9uOTSvcTY6PXexIcOZXoqDx?=
 =?iso-8859-1?Q?CFlI7tvi3V7A0b8My9SJBrJUuY4oAgVA+ftjPjFi8BjxIllCtXikkLH9iB?=
 =?iso-8859-1?Q?OGdfa7Vy7USQ1lBFQfvHiRUPfDHZsVQ2sA6TYeWiZcMBLhsZKfBfT07Tn3?=
 =?iso-8859-1?Q?t80pJXafG0rYUn33foYfGp4yOICdN44rVTbrF9QN92wp04mkMWFO1sC0Uw?=
 =?iso-8859-1?Q?4z2maQD/sj1qIWAWEXUwzyWhe8oKLWBThsahJHBdXEbm5SPyjQw34XzVDh?=
 =?iso-8859-1?Q?QiMpAO5P3kMo+vSKvTDUGEKa1zSsOg9TmCrJldsPfuybG2vb5b34HnSblp?=
 =?iso-8859-1?Q?Mum2SddUNgREVsZZep7cHFaSClGCgMpHxNMebpqYEh0vylMY1D2THyuLoz?=
 =?iso-8859-1?Q?5G3Vb1vC5jtJ7XsoovxFIm7gEDZOa+LffqtbPYtPGN/At+YiiKgth3Niak?=
 =?iso-8859-1?Q?lhnd9zExmxuZCxzMIKyu6ST1OwFoJ4XYNradvPW/q70ZGDqBrIrRj5vZ0h?=
 =?iso-8859-1?Q?yIrU7DFF+uGU/u11KLNU2h1bJ9lOVWtzJ3uCjr1I/nNexeS/Hvtjz9xuLL?=
 =?iso-8859-1?Q?J7Dh1qUUAFvvKBatbvGuSYzeB3U2KnonIjEjMqDqHXt1ZeDmLLx+IV7PUE?=
 =?iso-8859-1?Q?A+auVneZXUDq36BSg2SEhBCYt5+K7S9ppTvpcPUG/URCYCOlo+eW99CT2/?=
 =?iso-8859-1?Q?mRTDPxpL7rtcb8KwJMQRJENfugRsgNbK8Ctw5IUBD0bM2zpYa/O+21C5UR?=
 =?iso-8859-1?Q?JN91K53ONhzvna8P8GsfqNQKE5NOn7fl7LCZhjMKs6lKHmL1c5rf6pbmW2?=
 =?iso-8859-1?Q?LKtP8KSF3xYyg78SP58ibLqTOx2s7lNUe6Yf+dIlf6z8Mimt4+qXXoY/lc?=
 =?iso-8859-1?Q?Z88oD36x4Tcz/2GJxYxv2TvFIb8TctPzQh1qLnHqH09paYwHMp8rEtFlcI?=
 =?iso-8859-1?Q?59dm+Mnyh5vJy4peFjU5Vco0lDK6XcEW9oIaDgzR5RFLAhr4fnGpfj0fOg?=
 =?iso-8859-1?Q?KERvAr7BMply3yM1bKHgR7W8tTerFNEh6xen9xEKR9llHk3j+ll94vdCTn?=
 =?iso-8859-1?Q?6qwetxGo8A=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f4a18d-3fcc-406d-0b68-08dee5c09e3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2026 18:07:38.3887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9a309606-d6ec-4188-a28a-298812b4bbbf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kTVpgeuda2usuJe8A/F8r36siii9Tah2nV+crobQi1MD+3JXjdTqJzrPlrF/qY0l+2qkYBxneJEoVP01XNdestOLuVg46u8fNOiLTwiqqJA=
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
This is the second of three coordinated CIFS client reports. The first cove=
rs=0A=
SMB2/3 response-signature failures being logged but not enforced, and the t=
hird=0A=
covers client-required sealing being dropped after reconnect. This message=
=0A=
covers the independently fixable mount-confinement behavior and can be=0A=
classified separately.=0A=
=0A=
I am reporting security-relevant mount-confinement behavior and asking for =
the=0A=
maintainers' classification. I am not requesting a CVE or asserting a final=
=0A=
severity. Local resolution of UNIX-client symlinks is longstanding behavior=
,=0A=
was described publicly by Samba in connection with CVE-2010-0926, and was=
=0A=
deliberately preserved for existing users by 3363da82e02f. The narrower con=
cern=0A=
is that a modern ordinary share writer can trigger local traversal even on =
a=0A=
signed, encrypted, noposix SMB3.1.1 mount, with no selective CIFS option to=
=0A=
confine links while preserving safe in-share links.=0A=
=0A=
Observed behavior=0A=
=0A=
A server-provided absolute symlink target, or a relative target with enough=
=0A=
".." components, is returned by cifs_get_link() and resolved by the VFS in =
the=0A=
accessing process's local root rather than inside the SMB mount.=0A=
=0A=
I reproduced the common sink through:=0A=
=0A=
- STATUS_STOPPED_ON_SYMLINK with an absolute target;=0A=
- STATUS_STOPPED_ON_SYMLINK with an upward relative target; and=0A=
- FSCTL_GET_REPARSE_POINT with IO_REPARSE_TAG_NFS/NFS_SPECFILE_LNK.=0A=
=0A=
Versions and practical path=0A=
=0A=
- The full three-trigger read/write matrix ran on mainline=0A=
  94515f3a7d4256a5062176b7d6ed0471938cd51a and reproduced on Ubuntu=0A=
  6.8.0-117-generic.=0A=
- Upstream 980ab36ae5972c83f683b939e50c469c4947229e from 2026-07-19=0A=
  retains the same cifs_get_link() sink at fs/smb/client/cifsfs.c:1272-1297=
.=0A=
- The stopped-on-symlink path dates at least to b42bf88828cd (v3.12); the N=
FS=0A=
  reparse path dates at least to d5ecebc4900d (v5.3).=0A=
=0A=
In a separate SMB3.1.1 check on Kali 6.18.12, an ordinary authenticated=0A=
write-capable Samba user created a native absolute link and a fresh Linux=
=0A=
client mounted with mandatory signing, AES-128-GCM encryption, and noposix=
=0A=
followed it against its own process root. This does not exceed that process=
's=0A=
permissions or namespace. It becomes security-relevant when a privileged=0A=
automated consumer follows attacker-modifiable share paths, which is the sa=
me=0A=
general risk as following untrusted local symlinks.=0A=
=0A=
Controls and existing mitigation=0A=
=0A=
- Plain files and in-share relative links remained on the server.=0A=
- A chrooted accessor resolved against the chroot root, confirming that the=
=0A=
  accessor's namespace and credentials bound the effect.=0A=
- VFS MS_NOSYMFOLLOW blocked all tested paths, but also blocked legitimate=
=0A=
  in-share symlinks.=0A=
- reparse=3Dnone, symlink=3Dnone, and symlinkroot did not provide a general=
=0A=
  follow-time containment policy in the tested matrix.=0A=
=0A=
Possible fix direction=0A=
=0A=
I tested a cifs_get_link() guard that rejects absolute targets and relative=
=0A=
targets that climb above the mount while preserving lstat/readlink and=0A=
in-share relative links. The complete positive/negative matrix passed with=
=0A=
zero escapes. Because some users intentionally rely on local traversal, I=
=0A=
expect an explicit mount option or opt-in policy may be more compatible tha=
n=0A=
changing the default.=0A=
=0A=
Would you classify the modern share-writer path as a client security-bounda=
ry=0A=
bug, or as expected symlink semantics needing an opt-in containment feature=
?=0A=
If the latter, would an option such as "confine server-provided symlinks to=
=0A=
this mount" be acceptable in the CIFS client, or should this be addressed=
=0A=
through generic nosymfollow/cifs-utils support and documentation? I have a=
=0A=
tested source harness, raw transcripts, and a candidate patch with the rele=
vant=0A=
introduction commits. I have not posted the reproducer or attached it here,=
=0A=
but can provide it directly for review.=0A=
=0A=
Requested credit, if useful: Daniel Birtwhistle=0A=
=0A=
=0A=
=0A=
Best Regards,=0A=
=0A=
Daniel Birtwhistle=0A=
Senior Director Product Security & Assessment =
