Received: from SG2PR03CU006.outbound.protection.outlook.com (mail-southeastasiaazon11020003.outbound.protection.outlook.com [52.101.133.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143892F5B
	for <linux-cifs@vger.kernel.org>; Fri,  1 Mar 2024 07:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.133.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709278275; cv=fail; b=Cv6fFspTD6IHFBZbL08VXDRFoBsTBGo+ZOGhCMXA7CIdlZLQJclkg8MrKRwH8JvfFPclXIbfSwd9NNcFT5qFLSIghmNpsOoInKiMYv7ylH2wII1NHyw8MUz+ZyPnWhMR4ib0LveHNvSFirnZxK/F7HhbEOYUR2981n0nbZWIZ8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709278275; c=relaxed/simple;
	bh=N61VDYyvbeaGmDmdfPkf1bbQ0DWLaTUkb3S7cr+QZnM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gHu29T/uh6r0Z/eHzpnMDthWFSAEcMqsML/0XL3XcmmD5bM6A2VHNX4wlu7KaXoT8tZT5se+59Zi2FCL6dZgzKo1C0eJWBD+ZHCFx1k2s6jZqSbpcbAr1gJJOWps2iP0ix6DdPgMWCDeP189jJ4LqfhcWlivleYi0c2BzgTgsVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=Q7o1xLKB; arc=fail smtp.client-ip=52.101.133.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Q7o1xLKB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foDoG4yu5lGNwDprpf0ZV3N2wQN/8nlyvGzYftd87q+4oWJcyAkty6L88CDce7YnxaMWnYZbumUouGUzhBX+ychFfvbRrGVmut7FLwlFEOSm4W1dxUxcU8wzRnYuE2leQKbJ6fIUy6UVCUjRfTPWVQwK6vs42L1F+UCWFlXTHTmP/X75hztlYqPeO9M3sGUjsZH2kxFEIQ3kFI6GK17hDa+jhtuiB/STR8sThDZO/zhYEYaNXyaaTxY13aT3YlC8m+flZBrbPhPuLFPYCSJPDDe9fDvb3k/S4rff903djIAwoJg3cLT7EHPWm/DZ8iUScNCxE1hHH9M6qT6EUuEpIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqiLYrROoLFAKeceA/5PA29I7lO9ABOtGVyA1hKFfIQ=;
 b=lK8hCvpLnnra9TQeuxRwpkpsOo1we7U9mUk+F/WfYeedPI4OputCDJotpgDniJW5MF/y45UC1t55K0MrAPoTw2nyGMhUHO1mM+RvAjV/KCbBaCSyuPyuuuH4Od+qbyDca5u7efCEJ2Psw9g+eCkuHgHuVvMC1RFiiROg/xBZP+7zw0+IvOs5KxhrLOt902xgDtfzF6lpiY8MfVyr4se6AP+g/KQi9qgVq7MtUttzmnUtEDytNrw2ntixdOqTjrB9TuV64lJ1IXWHxK0MoYAwBxkDXHIuRlylB8j9DsHgTBPPPYV1Njs0fpoRwL/9P7yZc7A2oURncW7YrsIYChdcew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqiLYrROoLFAKeceA/5PA29I7lO9ABOtGVyA1hKFfIQ=;
 b=Q7o1xLKBaZycKbC4x8wdZ9jtMTJKuM6LfxkBCHXZT0wgpxrGRVpWHoNu/9aRln3qYeaJGIiulQ52+i+khkF2BLSdlFp0WoD+wH6Zh3yaRXV0gFuLi1GNG3S+gptLIGa8Dk0qWpU1QMhr9/KA3WIoYu3ereS5q7F6rxCXwlsHp5g=
Received: from KL1P15301MB0450.APCP153.PROD.OUTLOOK.COM (2603:1096:820:56::9)
 by SEZP153MB1022.APCP153.PROD.OUTLOOK.COM (2603:1096:101:1e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.18; Fri, 1 Mar
 2024 07:30:55 +0000
Received: from KL1P15301MB0450.APCP153.PROD.OUTLOOK.COM
 ([fe80::75a3:953b:91d2:28e5]) by KL1P15301MB0450.APCP153.PROD.OUTLOOK.COM
 ([fe80::75a3:953b:91d2:28e5%2]) with mapi id 15.20.7362.017; Fri, 1 Mar 2024
 07:30:53 +0000
From: Meetakshi Setiya <msetiya@microsoft.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: RE: [EXTERNAL] [bug report] smb: client: do not defer close open
 handles to deleted files
Thread-Topic: [EXTERNAL] [bug report] smb: client: do not defer close open
 handles to deleted files
Thread-Index: AQHaaZD9yCVuLjHlskKIxPHlogSALLEigNaQ
Date: Fri, 1 Mar 2024 07:30:53 +0000
Message-ID:
 <KL1P15301MB045056FBD4172633039051F3BF5E2@KL1P15301MB0450.APCP153.PROD.OUTLOOK.COM>
References: <eb0bd6c4-07a9-4f23-b857-2367835cb8ef@moroto.mountain>
In-Reply-To: <eb0bd6c4-07a9-4f23-b857-2367835cb8ef@moroto.mountain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7335cf56-3582-4f3d-8412-b86ec2105794;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2024-03-01T07:27:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1P15301MB0450:EE_|SEZP153MB1022:EE_
x-ms-office365-filtering-correlation-id: b6b67508-54dd-4061-9af1-08dc39c18715
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 e3DTpy9goa4ikSfHAOu0JLEO5hYXn/vP7Ro3Xx8y7dCxhx0e3lGZgOGHcpPT5ke3b4X3zQ/gm7CxxkasKirykQAlMcsk5K6juVTxMG2jgMRp7VGMoT2bejsvO3J4u2DJi+JnKKELY8TRMNeutH96N5tiojWam9Ym+i1FShcPXlAjazuaXtVC78zK8boIQ91KOD4O1GZOYfYKF+X4wntMk42SPDRjjGUF7KjIDIEcXq/gOcWasixV9NrJsmNNSe3+WL9Ti4oddrXvD+LkEtMSCyQ+7tVxXm2SI+SHvNV2MspNjfEMbotmAhNyf3KokD74P0sjCMZ0qx5KwhpLMtoQEXJmh8Y7w10VUHmEZ16lz1xZYvmID8n/huHRC14oZuY7E6g45vcQXQoePXQo1HZd6VSDGd3WE0JdABqvtKOx9AUtM3mb5/Gv8cVnqboVB1WG28Zt0ip0WPD4PECj0UsJxxGibdqqxcSIYgCDSsAb4JgaqZZlZXitCihKJUs+O+JFqw/6QVoLWbDya88KGFYBbEHDulOEWYeAwsTk6VktrCHlrHe478H/xVgsL3iLlbgO1FIeyQX+zmy9dakXVERtQZUZFZjcN7tHi5pT7IxhZhApOT041bT8ddnyZKOubR4JKHIUhuHpadvlDKYzXjC1ZJyyi94bjq+wQ7L4Mn2gq0jMkNXX/73GqUci9IznTCzCC+UN238JCk/2yKMY8X0Tfw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1P15301MB0450.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1LtfZH/RjnnWPaCCYrdXKSNiYZotS/Z3hC2xhCpa8b6OFy7Koac6/sltaGvM?=
 =?us-ascii?Q?/Hj7XEiIpfZdnmCYNI2JHm/HX1Wn57GkXT4+0zy3eTxMiHQNw/CifaEFP+lK?=
 =?us-ascii?Q?nFcHzhq1P0+8JhSPNSWPZfkSmN+Grodm256S6iRiiKx5wFE7PABJlAqWtkHb?=
 =?us-ascii?Q?0lN5CHgLQLyOVtijdS/fGSzS9g+Yxxm+UN2HHf4ACrP5UkxIF/hXqLd5tmfu?=
 =?us-ascii?Q?ecmZ2okmf+PvVb978snZgn4N1gBkiFDgX/4Dd8mnBh9UwQ1p0IlysXYJ5G79?=
 =?us-ascii?Q?cG4WolxSa3Yis8HQ6uhTI+hUB/Lsz9TITgtRT3ApHO44Zk0VLhr67vNNWSZp?=
 =?us-ascii?Q?DR0oDN9F7ArGstQLzDoVc5kTNB28TlLEx4m0GRjsYEKX7/+rjr0rIOTOr/EV?=
 =?us-ascii?Q?XRg30ZuTt/ipimRUBxyVt/OauRngn+nTd7+IkJWg2nu3hHm1pWRv8SPczH9F?=
 =?us-ascii?Q?sNFUdsabjWLsfnEGhOp2q64/QfXVOJligmLkWGIlJYyEfxUS9EDR7dC1Wakc?=
 =?us-ascii?Q?uyP2YwzIrCjT6ENQDM066RkbForJmCat/ApeajaIApZeRFYtytMXa2a6RRsU?=
 =?us-ascii?Q?nrl4Un3CsVA5xVCBvpzfnCH3ipAN7Y5OGxTahkExAvb1SkA4Gyr7nf6JvO9l?=
 =?us-ascii?Q?kZKVY4QFHHSzw+Ms2c7xhi/PJP3UtmcH13Og4IzD+VDkKjK3jsh/mle9OuwB?=
 =?us-ascii?Q?aB8UggUkdamntBwvIJL2Gs5vEhmttdixLR6+edCRx16S0c/xXu/uFTIJ0kUw?=
 =?us-ascii?Q?wQNRZ5U/pV8hW/elZbo/VeBF5XjwOMNE5JvDKOyKqd+R4dFDWeVEjsnqrYKb?=
 =?us-ascii?Q?Fkju/A8lpurdQeJab1M7qZ+Zx3FlTL6GgfwSDUg1BlvLS4wTSeXJCPbIgwBK?=
 =?us-ascii?Q?eQfQH+3wwYLIzJFSkUMG1YtiXvKDKJ3ziRCoYAw4jNfpH+QAQ6T8ox7xLyfx?=
 =?us-ascii?Q?ovWz5U2r+7x5KYLOQbKeMSGKP1rlpt9+3+4TRiNxhiC/HUIXeK8So9VOoIln?=
 =?us-ascii?Q?oXzoayWAe1xbMkBwBNlTPMJsLchwzzJob55C77/4IYE2kavD8Cs1T96NmEqR?=
 =?us-ascii?Q?nCYvJltFIhoE4FDWzLp9eitWcCAEF78xalM4nDof1LoFOAaorkmXKiF3PYgD?=
 =?us-ascii?Q?JOmUaVcgqOWst4BMMVW470WZ6wbHv3s2ZPs8CjAHK/c9qqSIDn6v7k1VLWPx?=
 =?us-ascii?Q?Z9Kh26eY9JABd0JlpPaOp6EyL6Unh5VEpRoPzqFvOfgR5nfJGDOwwcfzkH+6?=
 =?us-ascii?Q?BGAaosjah3akR8TVHW3yr+F5lL+L4vDzUVrJChibwW8HZObdCxSO50aPLTGE?=
 =?us-ascii?Q?OUu7nlSwzRNPdOwu9eOK4eJ6l2ueTR4wtOCRElCUx4lQ4ff8aYiTiXJkz/gs?=
 =?us-ascii?Q?eyl7UHWfZZSZC/0HvM5TnFv68SEhexpyj+2cK59xt0d2NKvyMEu9RIOZQg89?=
 =?us-ascii?Q?4v4bfB+Gzh8yk9KOE6kekjeXHrHZ0CkNwxaqV5Ph1sW7Fm0a5xwnSAgTCl89?=
 =?us-ascii?Q?F4+6XDXD6J/1fkGYMp83eqLdwPh6BEC2kshCSRej4407Z01+KVHPxNAnrz88?=
 =?us-ascii?Q?fQ5Xr7z0u/j1TjK707o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1P15301MB0450.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b67508-54dd-4061-9af1-08dc39c18715
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2024 07:30:53.7475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: knhxdRWC341cE9+W6p4j059z3eBDOL3PZKho2/ttTd/aHPhSzcEihKOLCfc+k7xvG3Ad3ZSvwfG9V1lisDiOpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZP153MB1022

Hi Dan,

Thanks for pointing it out. Seems like I did miss an error check for build_=
path_from_dentry. I will fix this and send the updated patch.

Regards
Meetakshi

-----Original Message-----
From: Dan Carpenter <dan.carpenter@linaro.org>=20
Sent: Tuesday, February 27, 2024 8:54 PM
To: Meetakshi Setiya <msetiya@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Subject: [EXTERNAL] [bug report] smb: client: do not defer close open handl=
es to deleted files

[You don't often get email from dan.carpenter@linaro.org. Learn why this is=
 important at https://aka.ms/LearnAboutSenderIdentification ]

Hello Meetakshi Setiya,

The patch 05211603b73a: "smb: client: do not defer close open handles to de=
leted files" from Feb 9, 2024 (linux-next), leads to the following Smatch s=
tatic checker warning:

        fs/smb/client/misc.c:871 cifs_mark_open_handles_for_deleted_file()
        error: 'full_path' dereferencing possible ERR_PTR()

fs/smb/client/misc.c
    860 void cifs_mark_open_handles_for_deleted_file(struct cifs_tcon *tcon=
,
    861                                              const char *path)
    862 {
    863         struct cifsFileInfo *cfile;
    864         void *page;
    865         const char *full_path;
    866
    867         page =3D alloc_dentry_path();
    868         spin_lock(&tcon->open_file_lock);
    869         list_for_each_entry(cfile, &tcon->openFileList, tlist) {
    870                 full_path =3D build_path_from_dentry(cfile->dentry,=
 page);

build_path_from_dentry() can only fail when the name is too long.  I don't =
know if that's possible here...

--> 871                 if (strcmp(full_path, path) =3D=3D 0)
                                   ^^^^^^^^^ This is the dereference Smatch=
 is warning about.  Feel free to ignore this warning if it's a false positi=
ve.  These are one time emails so it's not a huge stress situation.

    872                         cfile->status_file_deleted =3D true;
    873         }
    874         spin_unlock(&tcon->open_file_lock);
    875         free_dentry_path(page);
    876 }

regards,
dan carpenter
