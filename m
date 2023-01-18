Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283B2C38147
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 17:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjARRiH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Jan 2023 12:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjARRiF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Jan 2023 12:38:05 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021023.outbound.protection.outlook.com [52.101.57.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89EF46158
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 09:38:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzQxg/gZD+g0NflpYWK/focJcvDb0PMBN3O839ijJMCXovzVMZUaYx5smbwDK+cv7wNPDO5TsS27CiSb9KhmaCvT/a+D+qbE6xRNQdqzzUu27UGD4zx9olMOk1cMigwVomzc6rFDpN1nyUfSRgoQzS07ATSHyXBbNAgtAyvrbncZoMUdBQvyf4V7J3Moscj0z3HDMUuYqgmYb2YWNxcTj5MqyFtI2j2Cqlpgz13ai6+08/s2zQJXU0mVXrpOH7CotIzicl1a/UU5iUsO9KbadHfD25EtWZkElxZt9/sbmhG5D4g15/aWAzSe5WP0vjhiQfxJzNsnRgFBOdjUVcTVEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orv8pdx7LaIVcoWZV2JEcLA/+T4GdcUMKGs9zih+2xg=;
 b=hYvIS0yMIoo4oYGtTvxq8iPlyHloz8YZ4YD1puHTrwfqJyhl7wfATZ7tvNDOtzB9sEBu9dHMxBvczkIe/7X+j/s3PFV/E7n/4mugDwuQqPPqvd/R4YlNj6ITcTMymJyDm7D4i8MExbLd0fqi1Uv1z9dkgX0wYIqbrGhu2TCXt/Ax+h+oOghxZxEsM9mPv6K7Fjd7nGIW8TM3k3FRychW+kfvXtbd7HKrutgThi3qvqRMrcOuUMSntEw5cXKaE2OfUcL18tl6mMLwCIHOETBt/8R8Q+6iDAxBwQ2hRJqpjtlVRCJPjXBRtT4bQzScaXDrL9VbLD15DPz6Mwkiu4sFJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orv8pdx7LaIVcoWZV2JEcLA/+T4GdcUMKGs9zih+2xg=;
 b=MbvhrYR2J3NJ2EC4dvVXFuND2PI2KoNBWvOBirNyl4sZEL2vlnucaq5Tjw9bGawgl8wtV87c4qv71eyBHElQ8M0h9kqtY+ZUBokUtiaKKJC6aFM0F6uR3yLFxMqWQs2QqnCJ0sL3qwJfDP+TwRqDrqq/BE8vJCP88fPQ0QkTwjg=
Received: from DM4PR21MB3441.namprd21.prod.outlook.com (2603:10b6:8:ac::18) by
 BY5PR21MB1394.namprd21.prod.outlook.com (2603:10b6:a03:21c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.5; Wed, 18 Jan
 2023 17:37:58 +0000
Received: from DM4PR21MB3441.namprd21.prod.outlook.com
 ([fe80::5daf:d9ee:f136:7d52]) by DM4PR21MB3441.namprd21.prod.outlook.com
 ([fe80::5daf:d9ee:f136:7d52%9]) with mapi id 15.20.6043.000; Wed, 18 Jan 2023
 17:37:58 +0000
From:   Steven French <Steven.French@microsoft.com>
To:     kernel test robot <lkp@intel.com>, pc <pc@cjr.nz>
CC:     "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: RE: [EXTERNAL] [cifs:for-next 2/7] fs/cifs/dfs_cache.c:1070:7:
 warning: variable 'rc' is used uninitialized whenever 'if' condition is true
Thread-Topic: [EXTERNAL] [cifs:for-next 2/7] fs/cifs/dfs_cache.c:1070:7:
 warning: variable 'rc' is used uninitialized whenever 'if' condition is true
Thread-Index: AQHZK1oeqpJkEmBsXUW2ryAx2Q2Qn66kcDWg
Date:   Wed, 18 Jan 2023 17:37:58 +0000
Message-ID: <DM4PR21MB3441603BD730F2E36E96206EE4C79@DM4PR21MB3441.namprd21.prod.outlook.com>
References: <202301190004.bEHvbKG6-lkp@intel.com>
In-Reply-To: <202301190004.bEHvbKG6-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e51c6527-a924-4705-92c8-6dbb41c65ac0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-18T17:36:54Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR21MB3441:EE_|BY5PR21MB1394:EE_
x-ms-office365-filtering-correlation-id: 6a53aca0-3c30-4c43-bd46-08daf97abd2d
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Puq5n9uHWyakvbChLD6SAL5w4oI3qVBAqtQB+QKiQzAsWO1pTa3TizuePXCaH1FQqajjIC0PoYcA+TJbJzA3Vmj97zl11DEeLgoy3jrVYw4frtuq4AbBzAj4mVSmmO9QC3YGfUDrJ7GDpDKZ9AIVA6JrH6UywztcqCiIIqmSX5e6n96uJ0MZ5ellJN/NsEjBRzEbGoriwvCCi6WUmC8T3sTcSfQNmxi7dAciGaWIz4nkw+dpj18//blfeR8H6ItT56YIo/p5u5NqOdkDa2YFzFHflyuOKQtBnGnYtWDsGqdaOyPCifIXZpa0unuruSi8bU9eRctK//dS0OblGJfPeUSzpGTMpG13b5PfY3lVnKoQ5NtYYZely8gyxFjiGcw3rzuMl4lnmFj1WFjRlXiwP2rrHNwNCbFkj9czrSZRRA/8UP7SsMeC7SsUEvTa2BsWm8471y3TP16CnHx4cpLwzQ4eWfkboO7QFjh1ebqUOPP+OX/gLS32oHJGIO8j+MvgP4zfmZNjohpkasqqNP0YpyogXUgm4EG5zCHuCBN+ThBK3PVPIGeNSCVUV6VGO6LlK6U4kfbzL8yIwHbXpD8Mw8H7grDfK8Z0CS9RKRQM8M2OIK34P6tnq8kiuiLtAGTvb9FKZ3IV/M+vb86u5RFqldbBeDYzG06F7cYwwT9+4sEWUhWpAZa2BoQx8o7ZdNyheDmwNwDNlae8Zh/uTykeyGa8n621hEKF+dd0fKXPHhWhJYnk77fRzsyrvY+lmZBhW40s1SK1ma5KCpe6PVt0ndiXYN8Q4obccnzg/oX7QIf3hC5RpDEtBqWsElPkIhk8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR21MB3441.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199015)(5660300002)(30864003)(82950400001)(4001150100001)(2906002)(122000001)(82960400001)(38100700002)(8990500004)(8676002)(33656002)(55016003)(7696005)(83380400001)(478600001)(86362001)(10290500003)(71200400001)(66446008)(38070700005)(26005)(52536014)(76116006)(66946007)(66556008)(66476007)(9686003)(316002)(4326008)(64756008)(110136005)(54906003)(186003)(966005)(6506007)(53546011)(41300700001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?evMYMQRPuUcUyJG5S1zE54S/1wPZR0jaE9REwxmZ1DkY2rGm41I4s3aw61Ld?=
 =?us-ascii?Q?1oK8eSaCSPGdUTvkay1eyprMzJNKJ2fM4CRdWm25HPveq0XyYkIsIxjletAp?=
 =?us-ascii?Q?ZCKs7/W38I7s9+n4fA5lG+FHEFJ/T74kkeaKCIWBZhNdgrqwhDbf1MNUIeFl?=
 =?us-ascii?Q?9MmtIhIniIHvFK+lnwM5kcDJPgC/6HZwps5sVHCKAzQLZUDT9Bw50SxUDLzl?=
 =?us-ascii?Q?YzJ4/T6NO3/YpEE8Pb3eA2qvRPpkQs2dwlpvdJE8D5+bQL8zVNfTDia6dc1Z?=
 =?us-ascii?Q?vSi4ygq/JvQLjMXf6ZJrDCGCLu2XXb+syZwAbE8J3IRw3CVM7wJ4ue4ArjHe?=
 =?us-ascii?Q?MuXFOcdNWNNh6H2QFWInbel9ff97zg97nf08myUPb0XbeWk20mxM2JEgkrU0?=
 =?us-ascii?Q?9f7WoDSF0LYv6ryk1rghrLqHZL5XvxRDZ3Oj2Cj1bpsqyNBIYlJBSV+Wu5zt?=
 =?us-ascii?Q?AvbVZCZ3BkY+YopNJJJHmAqhbU2fUlXQRtaOszmI138BdzpVWhNtGYw3J1Ll?=
 =?us-ascii?Q?qAgzqXzEi+9cqfLqkPe0MMUvdKEcWoq6Fjy0QbPAeTAMUKCquOab8C5EymGV?=
 =?us-ascii?Q?b19/P298PkA90rdI16GdcvcGjTGFILAEJgc1WseJVM/bajaWW131ZyYt05U7?=
 =?us-ascii?Q?z45go5aNxMV7Nwvnf8IZ0yuIMUbhPfu8OFXrbVBWQmkvX7pSDYeZGl9WMQXa?=
 =?us-ascii?Q?m3vvkpLFzyIKCG39P/JFtsNNg7nNtmV4bOLoKmF4Wt0Hubh12yM3rKdnIsUh?=
 =?us-ascii?Q?kWULeTVS+s/FN5y4vHn2/xBG1GtA72hFZB35WGcmnGxC1U3czwBipUrZRaiB?=
 =?us-ascii?Q?cROJ8wuLpTb46NIHJRGM+rzIEjIeL2l70DXw518R3xoEIf21mO0AMmBR/Opk?=
 =?us-ascii?Q?PCRmcjB3WsvaKR0074R3kb7tFLvLiDSIPjjzpEfzQJPGyUNzFeIlbaCySK2s?=
 =?us-ascii?Q?ghX2/+5ImJwhAvL2p12s6dqfg0G6vGO8yvD1hb5TvcQNVm/TtyQbQySj8/KF?=
 =?us-ascii?Q?H+REz7jjlGNAyXfFtMlzWllnOKWoc5qWt1gKrjwN9AzkzjVYk83cE8MaHCv4?=
 =?us-ascii?Q?eWwWDL4NLdEYg0Y1ZG3DZM9EAXbUNWkQHi5UEM28XQ/BrwQOxydk6X01GhV0?=
 =?us-ascii?Q?VFf8+O9SfouEmx3XYxfyesGaXszUJ9lojHP5fyybJAfLELQkRuQVm5ovMxHq?=
 =?us-ascii?Q?SPQuzLwEi5A3HJiUId7wTDC+uX+dEHX+Kf0JDSYGfjcpBh9wAYCqslNYszlv?=
 =?us-ascii?Q?6cIAnXekDCZVYH4HJYGaj8ssMWIS+ozPmmmF+Xjo1GQjASm07HrQiFYisbdg?=
 =?us-ascii?Q?h75gvs1sP6aqLrrtiZee/erK+gDGGL921k7XB8ps2eF+9+4Aa9T56NECoQQ7?=
 =?us-ascii?Q?ZOhIOzVQEzRVmtvb0mJZ70hIOrRIaSZWSjHfjmn6s0JcrYkdJr9IA20pdjfW?=
 =?us-ascii?Q?XraByQNriJKdygL/YrFcr4jUA8F02upz9TOdqKX8Xf7AqGqEY5ZPxRMUi70X?=
 =?us-ascii?Q?pnjTCrgAOtSYGzCAmAca1nwanFSg4ra2d+9iaZxwfFJ0Jal7+jrqiLfAbHyY?=
 =?us-ascii?Q?RzvkBuLD73fFrW3+D/Wd217W2jzJD3Y3cZ7PgmUi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR21MB3441.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a53aca0-3c30-4c43-bd46-08daf97abd2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 17:37:58.1095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yx2KBNphdfRtyjyDCNHJKMLHd+IjG94rjppsAUr4Fe0nl3Z9bUYCi3cRbvvtA9BEnHyPkye5RXTjW4aC1XZvfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1394
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thx for the report - now fixed by Paulo in "cifs: fix return of uninitializ=
ed rc in dfs_cache_update_tgthint()"

https://git.samba.org/?p=3Dsfrench/cifs-2.6.git;a=3Dpatch;h=3Dd6a49e8c4ca4d=
399ed65ac219585187fc8c2e2b1
-----Original Message-----
From: kernel test robot <lkp@intel.com>=20
Sent: Wednesday, January 18, 2023 10:29 AM
To: pc <pc@cjr.nz>
Cc: llvm@lists.linux.dev; oe-kbuild-all@lists.linux.dev; linux-cifs@vger.ke=
rnel.org; samba-technical@lists.samba.org; Steven French <Steven.French@mic=
rosoft.com>
Subject: [EXTERNAL] [cifs:for-next 2/7] fs/cifs/dfs_cache.c:1070:7: warning=
: variable 'rc' is used uninitialized whenever 'if' condition is true

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   027c69ea2097550090545e7c539e01a1998f7438
commit: 9e2e1207815ca38386ab7cb40ebcebc2a3918cb0 [2/7] cifs: avoid re-looku=
ps in dfs_cache_find()
config: s390-randconfig-r034-20230116 (https://nam06.safelinks.protection.o=
utlook.com/?url=3Dhttps%3A%2F%2Fdownload.01.org%2F0day-ci%2Farchive%2F20230=
119%2F202301190004.bEHvbKG6-lkp%40intel.com%2Fconfig&data=3D05%7C01%7CSteve=
n.French%40microsoft.com%7C1833e410654f404ca35708daf9713f39%7C72f988bf86f14=
1af91ab2d7cd011db47%7C1%7C0%7C638096562049062332%7CUnknown%7CTWFpbGZsb3d8ey=
JWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%=
7C%7C&sdata=3D5LeoPwPYSRBjtu1PmH3OlLgHpFqvibQNUh1Cif%2FJ2JQ%3D&reserved=3D0=
)
compiler: clang version 16.0.0 (https://nam06.safelinks.protection.outlook.=
com/?url=3Dhttps%3A%2F%2Fgithub.com%2Fllvm%2Fllvm-project&data=3D05%7C01%7C=
Steven.French%40microsoft.com%7C1833e410654f404ca35708daf9713f39%7C72f988bf=
86f141af91ab2d7cd011db47%7C1%7C0%7C638096562049062332%7CUnknown%7CTWFpbGZsb=
3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C300=
0%7C%7C%7C&sdata=3D7L7bbCEVbaQ3BwNUDH8uhkJNAui0Rel93tLX1XlmD8g%3D&reserved=
=3D0 4196ca3278f78c6e19246e54ab0ecb364e37d66a)
reproduce (this is a W=3D1 build):
        wget https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A=
%2F%2Fraw.githubusercontent.com%2Fintel%2Flkp-tests%2Fmaster%2Fsbin%2Fmake.=
cross&data=3D05%7C01%7CSteven.French%40microsoft.com%7C1833e410654f404ca357=
08daf9713f39%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63809656204906233=
2%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1ha=
WwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3D75yyDPhXVdagZbTTg7fFw7%2BmpS0vSY%=
2Fyx63EjkawG3k%3D&reserved=3D0 -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch --no-tags cifs for-next
        git checkout 9e2e1207815ca38386ab7cb40ebcebc2a3918cb0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=3D=
1 O=3Dbuild_dir ARCH=3Ds390 olddefconfig
        COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=3D=
1 O=3Dbuild_dir ARCH=3Ds390 SHELL=3D/bin/bash drivers/net/ethernet/mellanox=
/mlx5/core/ fs/cifs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from fs/cifs/dfs_cache.c:15:
   In file included from fs/cifs/cifsglob.h:14:
   In file included from include/linux/inet.h:42:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val =3D __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val =3D __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + a=
ddr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from mac=
ro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from fs/cifs/dfs_cache.c:15:
   In file included from fs/cifs/cifsglob.h:14:
   In file included from include/linux/inet.h:42:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val =3D __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + a=
ddr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from mac=
ro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from fs/cifs/dfs_cache.c:15:
   In file included from fs/cifs/cifsglob.h:14:
   In file included from include/linux/inet.h:42:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr)=
;
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr)=
;
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic =
on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> fs/cifs/dfs_cache.c:1070:7: warning: variable 'rc' is used uninitialized=
 whenever 'if' condition is true [-Wsometimes-uninitialized]
                   if (!strcasecmp(t->name, it->it_name)) {
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/cifs/dfs_cache.c:1082:9: note: uninitialized use occurs here
           return rc;
                  ^~
   fs/cifs/dfs_cache.c:1070:3: note: remove the 'if' if its condition is al=
ways false
                   if (!strcasecmp(t->name, it->it_name)) {
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> fs/cifs/dfs_cache.c:1069:2: warning: variable 'rc' is used uninitialized=
 whenever 'for' loop exits because its condition is false [-Wsometimes-unin=
itialized]
           list_for_each_entry(t, &ce->tlist, list) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/list.h:675:7: note: expanded from macro 'list_for_each_ent=
ry'
                !list_entry_is_head(pos, head, member);                    =
\
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/cifs/dfs_cache.c:1082:9: note: uninitialized use occurs here
           return rc;
                  ^~
   fs/cifs/dfs_cache.c:1069:2: note: remove the condition if it is always t=
rue
           list_for_each_entry(t, &ce->tlist, list) {
           ^
   include/linux/list.h:675:7: note: expanded from macro 'list_for_each_ent=
ry'
                !list_entry_is_head(pos, head, member);                    =
\
                ^
   fs/cifs/dfs_cache.c:1066:6: warning: variable 'rc' is used uninitialized=
 whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (likely(!strcasecmp(it->it_name, t->name)))
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:77:20: note: expanded from macro 'likely'
   # define likely(x)      __builtin_expect(!!(x), 1)
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/cifs/dfs_cache.c:1082:9: note: uninitialized use occurs here
           return rc;
                  ^~
   fs/cifs/dfs_cache.c:1066:2: note: remove the 'if' if its condition is al=
ways false
           if (likely(!strcasecmp(it->it_name, t->name)))
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/cifs/dfs_cache.c:1038:8: note: initialize the variable 'rc' to silenc=
e this warning
           int rc;
                 ^
                  =3D 0
   15 warnings generated.


vim +1070 fs/cifs/dfs_cache.c

54be1f6c1c3749 Paulo Alcantara        2018-11-14  1015 =20
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1016  /**
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1017   * dfs_cache_update=
_tgthint - update target hint of a DFS cache entry
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1018   *
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1019   * If it doesn't fi=
nd the cache entry, then it will get a DFS referral for @path
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1020   * and create a new=
 entry.
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1021   *
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1022   * In case the cach=
e entry exists but expired, it will get a DFS referral
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1023   * for @path and th=
en update the respective cache entry.
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1024   *
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1025   * @xid: syscall id
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1026   * @ses: smb sessio=
n
c870a8e70e6827 Paulo Alcantara        2021-06-04  1027   * @cp: codepage
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1028   * @remap: type of =
character remapping for paths
c870a8e70e6827 Paulo Alcantara        2021-06-04  1029   * @path: path to l=
ookup in DFS referral cache
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1030   * @it: DFS target =
iterator
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1031   *
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1032   * Return zero if t=
he target hint was updated successfully, otherwise non-zero.
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1033   */
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1034  int dfs_cache_updat=
e_tgthint(const unsigned int xid, struct cifs_ses *ses,
c870a8e70e6827 Paulo Alcantara        2021-06-04  1035  			     const struc=
t nls_table *cp, int remap, const char *path,
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1036  			     const struc=
t dfs_cache_tgt_iterator *it)
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1037  {
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1038  	int rc;
9cfdb1c12bae26 Al Viro                2021-03-18  1039  	const char *npath;
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1040) 	struct cache_entry=
 *ce;
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1041) 	struct cache_dfs_t=
gt *t;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1042 =20
c870a8e70e6827 Paulo Alcantara        2021-06-04  1043  	npath =3D dfs_cach=
e_canonical_path(path, cp, remap);
c870a8e70e6827 Paulo Alcantara        2021-06-04  1044  	if (IS_ERR(npath))
c870a8e70e6827 Paulo Alcantara        2021-06-04  1045  		return PTR_ERR(np=
ath);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1046 =20
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1047) 	cifs_dbg(FYI, "%s:=
 update target hint - path: %s\n", __func__, npath);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1048)=20
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1049  	ce =3D cache_refre=
sh_path(xid, ses, npath);
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1050  	if (IS_ERR(ce)) {
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1051  		rc =3D PTR_ERR(ce=
);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1052) 		goto out_free_pat=
h;
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1053  	}
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1054)=20
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1055  	up_read(&htable_rw=
_lock);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1056) 	down_write(&htable=
_rw_lock);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1057 =20
42caeba713b12e Paulo Alcantara        2021-06-04  1058  	ce =3D lookup_cach=
e_entry(npath);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1059  	if (IS_ERR(ce)) {
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1060  		rc =3D PTR_ERR(ce=
);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1061) 		goto out_unlock;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1062  	}
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1063 =20
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1064) 	t =3D ce->tgthint;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1065 =20
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1066) 	if (likely(!strcas=
ecmp(it->it_name, t->name)))
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1067) 		goto out_unlock;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1068 =20
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04 @1069) 	list_for_each_entr=
y(t, &ce->tlist, list) {
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04 @1070) 		if (!strcasecmp(t=
->name, it->it_name)) {
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1071) 			ce->tgthint =3D =
t;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1072  			cifs_dbg(FYI, "%=
s: new target hint: %s\n", __func__,
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1073  				 it->it_name);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1074  			break;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1075  		}
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1076  	}
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1077 =20
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1078) out_unlock:
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1079) 	up_write(&htable_r=
w_lock);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1080) out_free_path:
c870a8e70e6827 Paulo Alcantara        2021-06-04  1081  	kfree(npath);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1082  	return rc;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1083  }
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1084 =20

:::::: The code at line 1070 was first introduced by commit
:::::: 185352ae6171c845951e21017b2925a6f2795904 cifs: Clean up DFS referral=
 cache

:::::: TO: Paulo Alcantara (SUSE) <pc@cjr.nz>
:::::: CC: Steve French <stfrench@microsoft.com>

--=20
0-DAY CI Kernel Test Service
https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithub.=
com%2Fintel%2Flkp-tests&data=3D05%7C01%7CSteven.French%40microsoft.com%7C18=
33e410654f404ca35708daf9713f39%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7=
C638096562049062332%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2l=
uMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3D2%2FaMr%2BJRh%2=
F9Eq1wPTvesvBKIQmq4dVdxboQrKRSHjIk%3D&reserved=3D0
