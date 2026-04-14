Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazon11022097.outbound.protection.outlook.com [40.107.40.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EA83D5640;
	Tue, 14 Apr 2026 11:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.40.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776167450; cv=fail; b=f929LNK/N+L2zZn00dOuidhj9cB//5WbopSV4EQfUqf8+3v+8pxI+D5d3fopnH44HgrlLwGgTSrh4QWXbhxsxagCSTi0XjA/Durl399aJ9/4Ob1tzD7bAHTaF222AjnaGFhZiE9D7OPtL46aoWzL1SXWdJXtZusyeR0vCoLSdAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776167450; c=relaxed/simple;
	bh=FnktY08WLfdJpqcpBfJW9P7G/X9/aFH7An5y+1EIrNI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CC4fsYwMM7exnWHTAy0i67C+2456hSeFHVLT8c1b5D/aHBpvizTaHjA6pNv0L5kzw9k3pvdN6i1zPN3EY1Lq1wZGKXWb9VpbNBol9aMbGyKqzDTRj7dilU0tKKHOgwx/45XC8zYMAbg/fq+SBHap3HniMbtGo7l5zg9h+wcES7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai; spf=pass smtp.mailfrom=verivus.ai; dkim=fail (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b=BxOY93Tg reason="signature verification failed"; arc=fail smtp.client-ip=40.107.40.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b="BxOY93Tg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dCH1EJoOwfIcTxLGbwZ+ymF1p7U7te/d5vghovDFvJpeQIJSAwHWu9manJ9OxHB0FKn91ogYX1MFymJWk3pFC79Hv0Z/1zgKQEeWBxGb9WzFdY/TWlPh6TxAg5VDraZog4vxoiSccpMVuPK3VRPjloNXfPcnqRvp9ynlbGTB2OkSxIPINOUdrOmE0+tNfqm4Abk60FoC7RIdXbFDmx+g3bdvWy735jOo/LiK7Uu+vBlO/MfQ6xI36nBpriZ0bcC9tzZeK6FkRHCkYDNBNqqvnMVWheDHJapoGfjYuifK4LotFGFUjhEOOmQAMfcXyIWJ4fP6TaeCssW6c0Ps+jUjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Whuk5+gObE0bX9e1/WH4sL4w0oz9E2Ng4M10DL9N2w8=;
 b=g01yP5GakI5VY5aO6V6bh4SwcnZ8vbGMkDpx3jhAyK4RFJIDgc3w+jweQx0HQ9TDJ21aNBk7L2ZzDlOmT7+5mnYxayeGhEyGWDIdObGieiCuz+o1L+J4XVr+r3mQX8drAOHMBy5LtbdMIIkXmeRHG3daf12GJK+SXIG4FKZ/naRBrzG8BWz+WNPJgStXk4Sim5Th3ruUhrSUwHJLBejHZA1kYsxOYp22jXRvm2xPx9U82LGxjkF2fgp0YiaIGdgtZUBea6ZuauHletWeXBH9uvdKrJcuvAY9RBllWOpjqYMFdCEKw4lDpJ3lAUNSHGTW/nV++8I4tkI/jPsio/dKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.ai; dmarc=pass action=none header.from=verivus.ai;
 dkim=pass header.d=verivus.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.ai;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Whuk5+gObE0bX9e1/WH4sL4w0oz9E2Ng4M10DL9N2w8=;
 b=BxOY93Tga5j82DyXLqY5MARvLHJupVxkNWK+mwVtAl4x2PLZM/ZhxzNDT8kwemOoyd8SNA2E5Go9Pr1bb0sM+eLGV3z+43t/KghW6YzB0qj+xAtRAB6Ym1UMhNi/mBrAPpRBzg10cAll91BXyX/o+uvUT9PlwP5bO60TsRiZ9e2gmIKSlLouJulcfUG1HHLJD8Lx/TgIrycRJbpmNaMaG1vxhZjrVWBhXNb8KNiB0uJHuBV6fqNm/5MLVBplrQUHFBZyUR0h4zRNHOs0UiZqiKynK+tirNYu5wRBCG5kXLtQ3D5P7DL0sCiizDTsFIB1k8Cx0rt8bYt5ajfA40a26Q==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY2PPF495465E43.AUSP300.PROD.OUTLOOK.COM (2603:10c6:18::397) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 11:50:43 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9818.017; Tue, 14 Apr 2026
 11:50:42 +0000
From: Werner Kasselman <werner@verivus.ai>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC: "sfrench@samba.org" <sfrench@samba.org>, "pc@manguebit.org"
	<pc@manguebit.org>, "ronniesahlberg@gmail.com" <ronniesahlberg@gmail.com>,
	"sprasad@microsoft.com" <sprasad@microsoft.com>, "tom@talpey.com"
	<tom@talpey.com>, "bharathsm@microsoft.com" <bharathsm@microsoft.com>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Werner
 Kasselman <werner@verivus.ai>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: [PATCH] smb: client: fix OOB read in symlink error response parsing
Thread-Topic: [PATCH] smb: client: fix OOB read in symlink error response
 parsing
Thread-Index: AQHczATrjU+iZC/b2kiYDmi/0MRytg==
Date: Tue, 14 Apr 2026 11:50:42 +0000
Message-ID: <20260414115040.552945-1-werner@verivus.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.43.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.ai;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY2PPF495465E43:EE_
x-ms-office365-filtering-correlation-id: 79f1b76c-cc27-43ae-fed7-08de9a1c0e50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021|56012099003|18002099003;
x-microsoft-antispam-message-info:
 mnR8RqILLZh/6peOoeRsn6WODVYT3ar7Jmtj1chHGzC5J79j2OXSR1HwASWxFOn4o5V3PCRmMFOZhsBDPbQIWe9a3ieOn8z746upI3t4266vu99i9GtDK0jm2bFal8+VjctGxKOufXMPmyV3fFXOtJtKJTbtUOGmh4VBjhJjbqozomo2O393cHlQKaUV+dCwiDfU190P4y3khEgD0WqPAmxMpIrpgFN9Xs6utEoCoEVpMI4MmOd9w31W0o9zzju+JBduKvptMg2+W3aOZ6mmWTHr5Cf8hd3vL/s4JRmEZHmNAH0Wn+SGhDin/NZ6cVPFPT3khfYB53SLM9GA6FUEBzsJu8OAkgFblaNb3/LTD/RpWmBPBquqIzCak5mu4+NT5Gua/d3xW1hIPg5d9PfgZcWUs4PaG/zZxD5guhaaZAmgkCBIVERTt37HUgfjy8FRzTxb0kD87Ilc26s2mAsfTs6sQ4BmoZkG02dvHaZTvUNKAjtglBuh60XzFP0nJGUh5ELyrT5bDDDEK2ssU/5WIpz8yqp7nMz1SwT7GhkBb/2y0avqBTmVTA6Xcwtjl1QFC18dq4qrWA1b/lP0CmqwtnWIwzD0hrTxevI3cL7waa+GgxMC7NLbRloVvwWCodAxkpeJofOi3uv6ppVVuJoOJ4a8xAgqQRtdLtYppKxsEFnxw4jT14o10BxxNIz4mgqA/a3jFEDXsvnmAB6OWI0AYPkCtQrpw7jowa3Z70V62Sbfnx/Yr0LO+gwfRMKFD0eQ6QrSq/9xy8DqUr5hvniQzh+ri1SWivmQhBaoP2PmP/I=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021)(56012099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?MB4xuIYfFkLG64anHb7VBTSKZjri6FrUhwpUCraIFn3bHZJ4hDfSLzzJNe?=
 =?iso-8859-1?Q?kj40M5qUygFbrk39lCjJG1s5K6EQnimhQmutlqNjfNoeEBbEVkueuHs58e?=
 =?iso-8859-1?Q?oPeRc4yMZGfaLoVc1QEQsxrxKZMPcWM0CDWutqLA8MxCn1z6US+7IsoJ4v?=
 =?iso-8859-1?Q?RvfzEM1pTRwATW3N2UXlFITjMnkwMYXNcbPLFBlt310iBcD3RuL8QRKgFA?=
 =?iso-8859-1?Q?7V3a+g+baOSCg/HxQ8/I0NmZtvdaAfqvtXSI61Gpan85wjiEiYiBAZ0G8Z?=
 =?iso-8859-1?Q?7bGtpaTaw3RxCOpChncFfb0MBNYA7B58iWibZyqz0hfd82PgDY65r2oNNM?=
 =?iso-8859-1?Q?vZxfPOoNrvHPRSfK2MPUPYUdo66eqmTCwoX4VaOKvMYW7dpj+pTn0FRONd?=
 =?iso-8859-1?Q?SxoxTgx13XBjinO8pH3IxNjgWseNB6bT720aXVV+lc6MgpD59sbV/bz6BY?=
 =?iso-8859-1?Q?i2nfm548xlEMrM6gAdtsoM4QFSOjgh9BYRhgPhj+KRmMwz3uwZzLQWFEip?=
 =?iso-8859-1?Q?i0n+c0tSzwiSma4CD/oy2SMoAbYIv2MotdloYpWQNxU+EZXzS5cqZ1T6VA?=
 =?iso-8859-1?Q?U79Rt6uLy7iVoLoWt15hKd6cvyHaEu0E9E3I/CxcEvsA9E25r7tusx79TP?=
 =?iso-8859-1?Q?HEAiWlqMIsuZ/CKSPT5QjZ+dYYuZw0hkN6lAZVS2fUeBO+KLT4u2gQlGF3?=
 =?iso-8859-1?Q?yWbFW8YvzsM3pJZK7nDghw8vG7HwzIYTUXub7hTYrmg8uzOBXI7wJY1sYq?=
 =?iso-8859-1?Q?dV+bS30BZ3lcx9GYSwe0PBE57heM3+bo8D+CeCrpm7jNWreTe08dwxe/cE?=
 =?iso-8859-1?Q?ZNLYlfshhNz76i0xFtTtctlCvBEkkyrO8o1oFbs0Nkle0tICDhh35TuyJi?=
 =?iso-8859-1?Q?E1Ojuq1t/6PPJe94jRs4tt22rnUGAL8zinXLZ1c1/NsXgGWm87z3QtqinT?=
 =?iso-8859-1?Q?DL5sKnm8S189EtAHhFK+PHt53rQafw62kcJg7rS8kqhgPZqiz+9MkTFv7i?=
 =?iso-8859-1?Q?UI1OyIdki+5PAjFQFdrxHkNVdBsDlFE1xKeWwqREL8t4N9PcDHOR79w04T?=
 =?iso-8859-1?Q?9x7+2eMN+Oggx5KpS9yRPtYA+DrNqG+ufiG5ijFzP7QAfoAqneVpp3fSNg?=
 =?iso-8859-1?Q?KqxSeSwK9ZZFuFwxdcYoT+PM4vIlN5YeQHNz2hP8WoAl2Otji8Drr5mn8t?=
 =?iso-8859-1?Q?d+fg5HOaqSC1DLK35Z4yklthLg7oLHsRE5qji1kpE+lTMWJo32F6t+KVU/?=
 =?iso-8859-1?Q?nUrUmn8QPL8Z0Va+xY2q1k8+DWUQEJxmQsHIVXNpWkA5R5gCJuc//9Xr6i?=
 =?iso-8859-1?Q?jRf5xZJWYY8V1PjVGbdHupgogIc3oRRUFRzl+F0lBtNDPpewPh7o/jfceL?=
 =?iso-8859-1?Q?/RpbCBcap2klKbIZh6g3NOp0UrRXlFh4cPSGE2WfEeDVJz4mvnWvdHcHz4?=
 =?iso-8859-1?Q?n5H65UfXSV1x1SrwixfihzyJuCyAhFx7pYK3K/p3UruhIk/5jvaJg0477O?=
 =?iso-8859-1?Q?G9B1EzL6uKGvbgBM1NKJxYwRF/Oyx34q8YrQRPuSUsBy/k3QlXBRbzh9MH?=
 =?iso-8859-1?Q?+V1vygyVie6LLBM5KV1eCmVBJzULQ/HIBwSXj3pu111ogvPcVnDbdQCWa8?=
 =?iso-8859-1?Q?INEC3jJlwOjtk90+Oe0Gvauxj+LLWk5gfAxh8ebAHCAWiOuVhHTTCF2P0o?=
 =?iso-8859-1?Q?ZHOvVxKcvaUtIV/xVnOag2cboKitnXfPQM+vQVTVCSvS6cakE1XT4xyvYy?=
 =?iso-8859-1?Q?tIyfJVwGSBZSS6wj7sOR1ctMLhZZrKs8toBYT2nXEsMgQIgVi/z0UUSzEU?=
 =?iso-8859-1?Q?ud86cSR6IA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: verivus.ai
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f1b76c-cc27-43ae-fed7-08de9a1c0e50
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2026 11:50:42.2679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H2CyRyOpY99/YuQNcBDaYFqUont95g++4FWnB3U3edT+YdFVpNmJYzP7RR+JGzQzJDthL/y52cwt9TSkGRuBWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY2PPF495465E43

symlink_data() walks server-supplied SMB2 error contexts to locate the=0A=
smb2_symlink_err_rsp before returning it to smb2_parse_symlink_response().=
=0A=
When ErrorContextCount is non-zero, sym can land at an attacker-chosen=0A=
offset past the smb2_err_rsp header, bounded only by iov_len.=0A=
=0A=
Reads of p->ErrorId and p->ErrorDataLength in the walk loop occur=0A=
without checking that the smb2_error_context_rsp header fits in the=0A=
response buffer, and sym is dereferenced for SymLinkErrorTag/ReparseTag=0A=
without checking that sym itself fits.  A context header placed near=0A=
iov_end produces an OOB read.=0A=
=0A=
The bounds check in smb2_parse_symlink_response() uses the compile-time=0A=
SMB2_SYMLINK_STRUCT_SIZE as the base for SubstituteName and PrintName=0A=
ranges.  That only matches the fixed layout when ErrorContextCount is=0A=
zero; with contexts, the actual PathBuffer offset in iov is larger, and=0A=
the read of sym->PathBuffer + sub_offs for sub_len bytes can extend=0A=
past iov_len into adjacent slab memory.  The copied bytes reach=0A=
userspace via readlink() on data->symlink_target.=0A=
=0A=
STATUS_STOPPED_ON_SYMLINK responses are served from the 448-byte small=0A=
buffer pool, so the overread reliably crosses the slab object boundary.=0A=
=0A=
Bound each context header during the walk, verify sym fits in the=0A=
response before dereferencing its length fields, and compute the=0A=
PathBuffer bound from sym->PathBuffer's actual offset into iov.=0A=
=0A=
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Werner Kasselman <werner@verivus.com>=0A=
---=0A=
 fs/smb/client/smb2file.c | 22 +++++++++++++++++-----=0A=
 1 file changed, 17 insertions(+), 5 deletions(-)=0A=
=0A=
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c=0A=
index ed651c946251..6fda8ec7fe9b 100644=0A=
--- a/fs/smb/client/smb2file.c=0A=
+++ b/fs/smb/client/smb2file.c=0A=
@@ -41,6 +41,8 @@ static struct smb2_symlink_err_rsp *symlink_data(const st=
ruct kvec *iov)=0A=
 		p =3D (struct smb2_error_context_rsp *)err->ErrorData;=0A=
 		end =3D (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);=0A=
 		do {=0A=
+			if ((u8 *)p + sizeof(*p) > (u8 *)end)=0A=
+				return ERR_PTR(-EINVAL);=0A=
 			if (le32_to_cpu(p->ErrorId) =3D=3D SMB2_ERROR_ID_DEFAULT) {=0A=
 				sym =3D (struct smb2_symlink_err_rsp *)p->ErrorContextData;=0A=
 				break;=0A=
@@ -56,9 +58,15 @@ static struct smb2_symlink_err_rsp *symlink_data(const s=
truct kvec *iov)=0A=
 		sym =3D (struct smb2_symlink_err_rsp *)err->ErrorData;=0A=
 	}=0A=
 =0A=
-	if (!IS_ERR(sym) && (le32_to_cpu(sym->SymLinkErrorTag) !=3D SYMLINK_ERROR=
_TAG ||=0A=
-			     le32_to_cpu(sym->ReparseTag) !=3D IO_REPARSE_TAG_SYMLINK))=0A=
-		sym =3D ERR_PTR(-EINVAL);=0A=
+	if (IS_ERR(sym))=0A=
+		return sym;=0A=
+=0A=
+	if ((u8 *)sym + sizeof(*sym) > (u8 *)err + iov->iov_len)=0A=
+		return ERR_PTR(-EINVAL);=0A=
+=0A=
+	if (le32_to_cpu(sym->SymLinkErrorTag) !=3D SYMLINK_ERROR_TAG ||=0A=
+	    le32_to_cpu(sym->ReparseTag) !=3D IO_REPARSE_TAG_SYMLINK)=0A=
+		return ERR_PTR(-EINVAL);=0A=
 =0A=
 	return sym;=0A=
 }=0A=
@@ -115,6 +123,7 @@ int smb2_parse_symlink_response(struct cifs_sb_info *ci=
fs_sb, const struct kvec=0A=
 	struct smb2_symlink_err_rsp *sym;=0A=
 	unsigned int sub_offs, sub_len;=0A=
 	unsigned int print_offs, print_len;=0A=
+	size_t pathbuf_off;=0A=
 =0A=
 	if (!cifs_sb || !iov || !iov->iov_base || !iov->iov_len || !path)=0A=
 		return -EINVAL;=0A=
@@ -128,8 +137,11 @@ int smb2_parse_symlink_response(struct cifs_sb_info *c=
ifs_sb, const struct kvec=0A=
 	print_len =3D le16_to_cpu(sym->PrintNameLength);=0A=
 	print_offs =3D le16_to_cpu(sym->PrintNameOffset);=0A=
 =0A=
-	if (iov->iov_len < SMB2_SYMLINK_STRUCT_SIZE + sub_offs + sub_len ||=0A=
-	    iov->iov_len < SMB2_SYMLINK_STRUCT_SIZE + print_offs + print_len)=0A=
+	pathbuf_off =3D (const u8 *)sym->PathBuffer - (const u8 *)iov->iov_base;=
=0A=
+=0A=
+	if (pathbuf_off > iov->iov_len ||=0A=
+	    iov->iov_len - pathbuf_off < sub_offs + sub_len ||=0A=
+	    iov->iov_len - pathbuf_off < print_offs + print_len)=0A=
 		return -EINVAL;=0A=
 =0A=
 	return smb2_parse_native_symlink(path,=0A=
-- =0A=
2.43.0=0A=
=0A=
