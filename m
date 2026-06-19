Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020100.outbound.protection.outlook.com [52.101.85.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D6CC15C;
	Fri, 19 Jun 2026 02:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781836299; cv=fail; b=AXFw00zGPzmYvJ2+QAmnU6oMD9ROF9c9anOgCp6Lg+6DKCYSZ3bJC/Dav9JSo1H3VRZw+0ZNP/Hin0qPjX6J4I0wSKuuZIZgN4cgBhheFMmhus8eznTrhfmIOgjoCGlxcoMJ4hEPDNooXpeX+7u3kW5TpI4mYK70V7QUpdRvy8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781836299; c=relaxed/simple;
	bh=cos/Hy7AZR//BpEqfNX8MQsiT7JvuonhX6NrbqSCA4w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XIV9/C54od38yIWcIkX2f9lcj/Shg2K5E43lWR7V+2U0IEaP3gonqNSE43DF8Xd9cJlHp8UzZUzitdtO5HNBLGtLCW3e50hTSwbCKpoXFUTg7NCJZ6s39VrlOsyCcTyF/laHfcmilyBjSRjR+meyme3Quv8jcn5fDsy/cyOJEH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=GwYpERtg; arc=fail smtp.client-ip=52.101.85.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="GwYpERtg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJpAJGVr5FaY7jJ9v6I8qkl54ft7ST+FIwXmmB6HbxLA7ZylGNktUG665vw14gjngpBdiI0Qm2zrJOkJdKGEtdLrgXyiwnVTJCY9BRQtmpFh5ymkDQOZNsg4CqlSj9RfStgg1A7aPT7pbXjw0Egmr0V+36Bi8hPmm5YAO5TnzWNONR/VVkzqQKJJTcGxHN1ALcGYsSUMQSOKyo5MwGp9Hy1ovCGHnHFjcHKuGlOyf/EJA+x+773X9+mHeDBz36uuh7AYbaS0KEk9mcgC/IndnxBp1jCQAtesu9EV1W2fnTZxYapkorHpYgioEozyxs2b84t+ondlQ16/8Dja6Nu3tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fe55M7A1HMZI/H2xJXG43fyTJepE4py06qWOu9KlH9g=;
 b=qvtYvQzSyRXdgbpjf/oeI235hD5OLc125DQA7zNuOAciSynltECGn7KdqQnHF3+HQFA/WpA8Ud6E+ZHA4C/2bwlelkGvOYVyJk7B2GnWkiXdJRc+MSkB4w659i7IEGeCzKHBGpAwBCkGSqPkmnf/fMTdcPJD/PwYMPeSe2jMvXroVZZyg2aCHH2w/7cihCGWGzkGtedFCKtqGbAopjv0Lf7H+UhTOytX6YnJpanKSheHUHU90GrIK+j4X2m1qRSB7wi/MpHjesJOfZLOdtEEU29ZrWxnCjOObgRT0k5febSlhdta8XVMyt/DFym5pRfhHSq9Gte5tLXsMfkvxoHrGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fe55M7A1HMZI/H2xJXG43fyTJepE4py06qWOu9KlH9g=;
 b=GwYpERtgKsWmGBiIdF6fFoH14Qm4rfMhdAEeyVYnsPUA5LPq4MV9xn+eRzwHnImj3oqaOeyLrsMQ6/JnQXNHHs1Vt7wd2LyzFnJsZSXy5+6suH0Xam0a0RQrOTpfNkX05OcgQIw18kobuOs8dsBOlqmk2mz9G14cxHRiOFeUtss=
Received: from LV4PR21MB6511.namprd21.prod.outlook.com (2603:10b6:408:356::15)
 by LV0PR21MB6212.namprd21.prod.outlook.com (2603:10b6:408:335::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.0; Fri, 19 Jun
 2026 02:31:35 +0000
Received: from LV4PR21MB6511.namprd21.prod.outlook.com
 ([fe80::b834:b80d:5ad0:75ac]) by LV4PR21MB6511.namprd21.prod.outlook.com
 ([fe80::b834:b80d:5ad0:75ac%4]) with mapi id 15.21.0139.005; Fri, 19 Jun 2026
 02:31:35 +0000
From: Steven French <Steven.French@microsoft.com>
To: tanze <tanze@kylinos.cn>, Chuck Lever <chuck.lever@oracle.com>, Christian
 Brauner <brauner@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ChenXiaoSong
	<chenxiaosong@chenxiaosong.com>, CIFS <linux-cifs@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: linux-next: build failure after merge of the nfsd
 tree
Thread-Topic: [EXTERNAL] Re: linux-next: build failure after merge of the nfsd
 tree
Thread-Index: AQHc81hfPnMs1gSf+0yOPX5norpaZrZFQGPA
Date: Fri, 19 Jun 2026 02:31:35 +0000
Message-ID:
 <LV4PR21MB65113DF2FCDB2CD61A7FA6F0E4E22@LV4PR21MB6511.namprd21.prod.outlook.com>
References: <ah_kp-LWg7pndPkq@sirena.org.uk>
 <1b9a93f4-f9f7-48a5-9a2c-d8370ae5aeba@kylinos.cn>
In-Reply-To: <1b9a93f4-f9f7-48a5-9a2c-d8370ae5aeba@kylinos.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ba67e6c0-06af-44c5-8b82-573d05f643eb;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-06-19T02:30:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV4PR21MB6511:EE_|LV0PR21MB6212:EE_
x-ms-office365-filtering-correlation-id: 519d9c64-f0d9-4576-ed06-08decdaae1fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|38070700021|7053199004|18002099003|4133799003|22082099003|4143699003|11063799006|56012099006;
x-microsoft-antispam-message-info:
 rx1nlvlsSmLjyN6h+bj0dH4a7BrAfI+8+Mcbunr7Ozwu5UdzYBaojKmmyR9W8SYSXKTo1yyouW+SsRqnObt5W6rPgQenk5Vmmd5Mqd9xsXoyRaYvQ8gGcFpsAXk7c+XqSXuQ+VCfsHd2Ez4pPux+xLTvE2De/1m9lAeXhpakhZK3t2vVWoJDwBj03zptr/Yar6jWozMD1ZxcV/4adWXTNS66NvsTc1XzfT3aCXmpBOilXrWK+IbN2KuvsPVlJ6xUuCdd3kLKVHVUiG2G88SsPM5+f4g7wfwqS1WxANvW5B4D1OVSBWiQHZUNFErloV+2ic2bIKVQJ/js3MmBgCaWybaDlVBxfhBeCwTCFjGE2WzuGkAhuXuf4mQmr8JQ6VMV7/ga3MUqg1uerIBDKd7ubeVik7AhwixufkCajyWEInGhs3iQZ0i4SnHyDdC4Q98K/IF8BIRsDgBImQ7NmT7I7oEp8xv42zIYOHfrQfkVKDxhtscFaLdLlNS65HoKZxjvnVhAhLRFQzyh/Tj5dtAEhWoaLtfEuq768P6Tnh9GBN7FHxg4ZcFSnjjccop2fwY0bvijTHKA3xuz+366u26M0pIcZ7lh9AodhZQh5kT5vGSfkDV3flt0Li6SV22XglrS17DBJppR8ALqBKDmdvbahL/wSI/J78ekPJ9JSN6H3ekDn0mwTfHqcM8Rg/GZpBjz8ou/WCNQ7duztrgLFI17wJgB7wOGdHOOH+YV2IX+vt0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV4PR21MB6511.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(38070700021)(7053199004)(18002099003)(4133799003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?Nm0rNllnZE5IenZqck1rdnBkTUhQemVOTmlNN3NnU3VweGZsWUxpRDNx?=
 =?iso-2022-jp?B?c09jQU9PSXBRQkk4d3FGZUhyNUswSlhNZWRLSVRBRWJaaTByKzFZNjRL?=
 =?iso-2022-jp?B?emVFTmxVbjdPZTErV1lMRTB2RnAxaUltWThwZjVER1lEVXRWS3JUYjZt?=
 =?iso-2022-jp?B?ZlFjSmZ0WkNWbXJTQkduL3FnczBwS3NkdFRobXFxQjVBU0UwOHNnb1JJ?=
 =?iso-2022-jp?B?bCtESnQvMEVkczVvN21aakRjdkR4dnNydTlWeXhydGd1OFJ3YVljVGRh?=
 =?iso-2022-jp?B?ejZ6YlVhUjlCei9XVkdzeTU1UGUwODIzb3liaytpa241bHZONlF1Sjl2?=
 =?iso-2022-jp?B?TEFmUFRxanl3TEM3SnZKUGN3ZzJCRTBPQzg2QjFvMEtDb1dLMy8wdSt2?=
 =?iso-2022-jp?B?U1FGajEvUnFTSDNJRkhyMTNGWGtmVUI1RCsrRmp1SmFBUU1jMGxFME9w?=
 =?iso-2022-jp?B?RWVWZm9oczdianBmcmFBOW9ScjNDaURsSHMvb29iZ2RocFBHSk50UUF6?=
 =?iso-2022-jp?B?ZlpHUHN2Yy9NYXhLclkza0gzWEU4SWNlLytHZnRuV3dVRTY3YW11L0Nh?=
 =?iso-2022-jp?B?MnZVSkJVcFBkLyt1UlJlbFowVW1PU1MybmZjajE1TkZWampDM3BPQ1lZ?=
 =?iso-2022-jp?B?bnFucXduZ1dxc2lFR2I5RGdndGY1bkREZlBBNEF5RTNjOU1vOHZUSFFD?=
 =?iso-2022-jp?B?ZnNZbHBRenpJL2VNKzZ1K3NjYitRNUF6WHJCUmlmb3kxK2h0bk13Q1hZ?=
 =?iso-2022-jp?B?eDRISExkcnB1c09BaEVTYlJ4YjdOM3BHT3l2UzRBSVBzZHRDSGlXbzZM?=
 =?iso-2022-jp?B?bHpqZWVkTkVvaU1zNHhqeGNQeWxvSnV4RFhBYXFmcDB5WUpJME4rcyt6?=
 =?iso-2022-jp?B?VXB2dUJySzkrZHJWMFVxRWJiNkNmMEt6elNzcUE1aWxWeDY4ajFmMnNI?=
 =?iso-2022-jp?B?VnVwZTV6RGx1aUhld1RMdWlGUVJxcWUzMDBINmt3UEZQdDBEMFBUWlJX?=
 =?iso-2022-jp?B?MXVCMEFNSzk1RzlDMkNlZVNLQ0VGSkVJZkdwcGd3TEFNdWVpNFRQRTF1?=
 =?iso-2022-jp?B?TnF0aHFwZ2tOTVNkUkZVd3dhRkNBc2FMQ3ZJVThCZVBRb01NZFJVRkh3?=
 =?iso-2022-jp?B?b3M0bC9xcHlubVNmRDNtcGsrN2xRRXpINUlCeDZLVTRkYUE0YXo1VTBB?=
 =?iso-2022-jp?B?OEdJK1NPQlhveE00S000VEhFazlrZlhaNmdFbW9RT2JJdkFGbUlyNTZs?=
 =?iso-2022-jp?B?TmpMRUdNR0dNV1oya3JETWh6V1c2S2ZFL2dhVDJvZEF0MnpZRkk3UXRU?=
 =?iso-2022-jp?B?cWUrZDNIbFFxbFpxNHJDMitFVWV6aTRwMUFpalVMeCs2THlQZTA3WGRE?=
 =?iso-2022-jp?B?MVQ1Zkg0bVBIU1BpOVZzMUY1c2N5MjA5NmFMVU8rOUtqekJDSEV1dmVn?=
 =?iso-2022-jp?B?S1Q5alptOHNhTzZTVFNyK1ZNeWpaMXpIOVJTR0l5bWdqeElnZG9ZQjl3?=
 =?iso-2022-jp?B?OGxycG0wc2VKSVNDUnhJSnB6YkFyNHBsbkd0NU9yMjRRb0ZJVUozUHBB?=
 =?iso-2022-jp?B?Z0pJYzYwU2p0ODBIZW9BSjF3Ly9Gb0MwTk5CNnNWdU5IUGFtRzMza1V0?=
 =?iso-2022-jp?B?emRlNG1OSmxvamgrWGRGcll0MUlMOWIzUUtobk4wekZab01LNlM2OEtz?=
 =?iso-2022-jp?B?K2JzdFZDZlV6Wmx0bmRhQkwrczRxUDh6dC9MTlBxTmVHVU1iYUJmV2Nz?=
 =?iso-2022-jp?B?TURGMVpKN0JQTzdNdmVnR01DQVIwS1RsYmRjMkxOa0JjeFc0NDNBMHJG?=
 =?iso-2022-jp?B?YkVHcnQ5OXEwbzhaZGxIeUFBNFJnV1J1d0RWeUc0Y3o3c3BpbzhJUE1p?=
 =?iso-2022-jp?B?bmdSRm5Id0hSNXEvdEZNZ0V3b3hrVnhkOEVlZkZEQUxTanZZTEJZKzFh?=
 =?iso-2022-jp?B?b0hYZXJmbytnellUdlpGRmE5RWJUZWpkMmdPZTBnUk1ZZUEvVHc3cCs1?=
 =?iso-2022-jp?B?eTNtdUJGZjN2SFVNYlZ3S1RDSXBEV3FValBpV1lObzd2RVRKRi91QjR5?=
 =?iso-2022-jp?B?ZFkvN3FaTzVzRmdweTdqZDJIY3dyYUJReUVtT29NTFhZdWtHSFcyNTZO?=
 =?iso-2022-jp?B?VEpVbnRwZGVUY0FhVDd6ZElaZGhQL0EvV2FEL0MvdHczRUlJcmZuT2hJ?=
 =?iso-2022-jp?B?bCtpYitVb2RGMlc0OHJQbWJnektMWWtWeHRTUklza2NMQXFXby9MTEdQ?=
 =?iso-2022-jp?B?NHpWTDN3RldxZ2wzYnljOVFjM3p1dWhkYzdMRy9GRnJ0ejlOK2wxY1VR?=
 =?iso-2022-jp?B?dkhpajNBZ0lTMDNQSGU0eTMyNkpvTEc3RkE0SjEzL1pDMmVYMnJhcDdH?=
 =?iso-2022-jp?B?c283OXFReG42MVJGZFkvbTUxajJ3NHhUVk9wNE9ZSnh0NG5PNWR2ZFVn?=
 =?iso-2022-jp?B?UnRVMEdZM1JHR2ZYUEY1SU9zTWp0V2pyYitYd2lhalNxRSttUkRKN2k5?=
 =?iso-2022-jp?B?QnJscWRCTEV0V1RzNEZOWTQwY2ZmSFBVQWFTdz09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV4PR21MB6511.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 519d9c64-f0d9-4576-ed06-08decdaae1fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2026 02:31:35.2816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3PUqxay/QLERdm0GryQnW9Vt60Znlk1lYkQLOrVuTX8GJzrN0Wz6C3rJdJbMQwaAx4uW1+y9SnRX64LElZ7LNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR21MB6212

Now that Chuck's patch is merged, I wanted to confirm that the followon pat=
ch suggested by Tanze was decided that it wasn't needed or whether anyone t=
hinks the revalidate would be helpful

-----Original Message-----
From: tanze <tanze@kylinos.cn>
Sent: Wednesday, June 3, 2026 7:56 AM
To: Mark Brown <broonie@kernel.org>; Chuck Lever <chuck.lever@oracle.com>; =
Christian Brauner <brauner@kernel.org>; Steven French <Steven.French@micros=
oft.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Linux Next Ma=
iling List <linux-next@vger.kernel.org>; ChenXiaoSong <chenxiaosong@chenxia=
osong.com>
Subject: [EXTERNAL] Re: linux-next: build failure after merge of the nfsd t=
ree

[You don't often get email from tanze@kylinos.cn. Learn why this is importa=
nt at https://aka.ms/LearnAboutSenderIdentification ]

Hi Steve, Mark,

Thanks for your suggestions.

Based on commit e50bc12f5a365 (cifs: Implement fileattr_get for case sensit=
ivity),

I have added the following patch:

https://github.com/shepardtanze/smb-work/blob/main/test-patch/v1-0001-smb-c=
lient-revalidate-attrs-before-reporting-FS_C.patch

Please let me know if you have any thoughts or feedback on this.


=1B$B:_=1B(B 2026/6/3 16:24, Mark Brown =1B$B<LF;=1B(B:
> Hi all,
>
> After merging the nfsd tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ld.lld: error: duplicate symbol: cifs_fileattr_get
>>>> defined at cifsfs.c
>>>>             fs/smb/client/cifsfs.o:(cifs_fileattr_get)
>>>> defined at inode.c
>>>>             fs/smb/client/inode.o:(.text+0x14780)
> Caused by commit
>
>    e50bc12f5a365 (cifs: Implement fileattr_get for case sensitivity)
>
> interacting with
>
>    4adb7181f4d80 (smb: client: implement fileattr_get to support
> FS_IOC_GETFLAGS)
>
> from the cifs tree.  I have applied a revert of the latter purely
> because it is the most recent of the two commits and doing so fixes
> the build but I do not think this is the best fix, it looks like we
> need a merge of the two (eg, adding cifs_revalidate_dentry_attr() to
> the nfsd version).
