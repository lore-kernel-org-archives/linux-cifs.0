Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BE4C77B7D
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 13:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjEQNta (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 09:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjEQNtS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 09:49:18 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 May 2023 06:49:17 PDT
Received: from esa2.hc3370-68.iphmx.com (esa2.hc3370-68.iphmx.com [216.71.145.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A36198B
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 06:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1684331357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RFOAU+W156YVqZv0dISYof/PqdrYZVMkusV+cyfEtKE=;
  b=HKWDD9vFbxb5SsMVxttcykP7QxhjhiNIkonyRFH+tdmqDwZj2qy6f5fI
   NVReOZZGX9d71dXXFedpcwEfWiaTFIYULoTGOAdH7rHjxiT97OGw+qI2d
   YscX7zrH1WkIeq3HjML7UCfZbQznYC+pKFEDiMJhAfnLPTnnhpnxrfYq/
   s=;
X-IronPort-RemoteIP: 104.47.59.168
X-IronPort-MID: 109258299
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:xC7OsalU6vizlqIcJDCrA+/o5gwCJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xJKXzzXafbfMWvzf48kPY2+8BtUvpbcnIc1HApv+S4wQiMWpZLJC+rCIxarNUt+DCFhoGFPt
 JxCN4aafKjYaleG+39B55C49SEUOZmgH+a6U6icfHgqH2eIcQ954Tp7gek1n4V0ttawBgKJq
 LvartbWfVSowFaYCEpNg064gE4p7aWaVA8w5ARkPqgW5QCGzRH5MbpETU2PByqgKmVrNrbSq
 9brlNmR4m7f9hExPdKp+p6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTbZLwXXx/mTSR9+2d/
 f0W3XCGpaXFCYWX8AgVe0Ew/yiTpsSq8pefSZS0mZT7I0Er7xIAahihZa07FdRwxwp5PY1B3
 dhBEBQuQwLbu9qrna3lYclln58SHca+aevzulk4pd3YJdAPZMmZBonvu5pf1jp2gd1SF/HDY
 cZfcSBocBnLfxxIPBEQFY46m+CrwHL4dlW0qnrM/fZxvzeVkV03iea9WDbWUoXiqcF9hEGDv
 STC9mv0GA4TMNi3wjuZ6HO8wOTImEsXXapLTOziq64w0Qz7Kmo7Lk0SdXWQvOaD122ZcNVND
 2BTwgMEhP1nnKCsZpynN/Gim1aYuRs0R9NUC+ArrgqKz8L8+AKeGUAfRztLYZohrsBebTgr0
 EKZ2tjoCydHrrKYUzSe+62SoDf0PjIaRUcZazUJSwAFy8LqpYs6yBXVQb5LCKWdhd/vXzfiq
 xiOtyE+g78el+YR2qm79EyBiDWpzrDSVhQ8/Qzbdmek5Rl+f4mre8qj7l2zxexHLIeFTkKpu
 XkPgc+F6+4SS5qKkUSwrP4lGbio47OJNWPaiFs2RZ05rW3zqzikYJxa5yx4KAFxKMEYdDT1Y
 UjV/wRM+JtUO3jsZqhyC26sN/kXIWHbPYyNfpjpghBmOPCdqCfvEPlSWHOt
IronPort-HdrOrdr: A9a23:ayOAyqAs1brKHQDlHelo55DYdb4zR+YMi2TDt3oddfU1SL38qy
 nKpp4mPHDP5wr5NEtPpTniAtjjfZq/z/5ICOAqVN/PYOCPggCVxepZnOjfKlPbehEX9oRmpN
 1dm6oVMqyMMbCt5/yKnDVRELwbsaa6GLjDv5a785/0JzsaE52J6W1Ce2GmO3wzfiZqL7wjGq
 GR48JWzgDQAkj+PqyAdx84t/GonayzqK7b
X-Talos-CUID: 9a23:9UAb7GEqIeRlAl4uqmJDrXYwOe03KkHl0SrPfWSYAH8yeYyaHAo=
X-Talos-MUID: =?us-ascii?q?9a23=3AAe9ERQ1B+s+6gEgHxkqQNzaywDUjxfSqKG4mjIo?=
 =?us-ascii?q?85uqjHitiHxvatB2da9py?=
X-IronPort-AV: E=Sophos;i="5.99,282,1677560400"; 
   d="scan'208";a="109258299"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 May 2023 09:48:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqhRNdUDcYHT0E3K4bPwhdBQQXLM51ZckQ+uDetC/VnbBWx1k/iNlxo7u5DaCliJ6E+h3kBc/acCJvwW6gsnUURpS1L63y4DQIS1s3lfe9DOHS2FgSJLpE7ta4c5CUbkMPxYQw4eDrh/8dEIvA5S7SSYxUe1zxOUq2OQ17DVHtGoH2khwMp0luwPDjQ2bQO5UHCrmKdvJ0WoiUIHNcuIPMLryohxsysAjIf0p9B/hbKOHSdcNOk9KFIWwD2JrKS1Muc84yIJCaWNUuIQeG+PmkxtYXr9D6JHX+R/sspW/oTx0xy/61oqSAEFpidLN4euKpZaBj7h7AkEnmCFXptBUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFOAU+W156YVqZv0dISYof/PqdrYZVMkusV+cyfEtKE=;
 b=h0JpWtz/pchiNts82J9Zh5nOfhQhba2ZZMEGdRry3yvx0avFnB+H6nVDEJYhOo0eIltG+AsWsBqhqlEe7eemKO2rO9yfoZQ/SWzZYdfCu0R6nsY2smvT7My3imf+BPiEmiK/jk3ki9OCzntFniXSUspi5/ihepLAXYpNmQ4StSvOomlL5Kum4UK3Mn+onaNEjfntjMXShlmMspgUZ6FThrd4kGMOJnR9P3y4DL/ehWT6Lqlt4zkFwPjKO8gEAjGQ74u59NZqs0xRYWqFGA/a3r6c1ROyUdiJ/JwW507b80ty9WBPkQeZJYBjPxfHkqVxWQqcarvrkXs8xcT7QHaAyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFOAU+W156YVqZv0dISYof/PqdrYZVMkusV+cyfEtKE=;
 b=IHuVYnLfsRVdGO8jx3lQk7BjzQeMZ3L+bp5jUNpfzkPbmFxQwRkgvEcglbWnh9jVrXl1iP2EFwcNFBhR87V5azuGKREavbuzYMq6bDENSlVFNux2oziCSKfhdKDuJe0xFmKYptaLqCb/t93S6zZOgpzv2isbJW7EnhqqCzlBzao=
Received: from DM6PR03MB5372.namprd03.prod.outlook.com (2603:10b6:5:24f::15)
 by SA0PR03MB5594.namprd03.prod.outlook.com (2603:10b6:806:b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 13:48:11 +0000
Received: from DM6PR03MB5372.namprd03.prod.outlook.com
 ([fe80::53f7:d006:1645:81e2]) by DM6PR03MB5372.namprd03.prod.outlook.com
 ([fe80::53f7:d006:1645:81e2%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 13:48:11 +0000
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
To:     Tom Talpey <tom@talpey.com>, Ralph Boehme <slow@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Rohith Surabattula <rohiths@microsoft.com>
Subject: Re: [PATCH] cifs: Close deferred files that may be open via hard
 links
Thread-Topic: [PATCH] cifs: Close deferred files that may be open via hard
 links
Thread-Index: AQHZiAdjwVeGRDUqzk+4gN1288JV8a9dO+MAgADjel6AACtPgIAAKwkAgAAEGFc=
Date:   Wed, 17 May 2023 13:48:11 +0000
Message-ID: <DM6PR03MB53724D5342CB69F587909ED6F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>
References: <20230516150153.1864023-1-ross.lagerwall@citrix.com>
 <55740ab3-e020-df8c-07bc-02386486539f@talpey.com>
 <DM6PR03MB5372810EDDBE8C9A5192B1F3F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>
 <8c79fa5a-d84b-13dc-73d6-27dbbd21dbfa@samba.org>
 <193b610a-32b2-fe39-2cec-47724ad7d608@talpey.com>
In-Reply-To: <193b610a-32b2-fe39-2cec-47724ad7d608@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR03MB5372:EE_|SA0PR03MB5594:EE_
x-ms-office365-filtering-correlation-id: 70c832d4-1f8f-4b99-3d72-08db56dd5ab3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LdM8VSZ6knz7S7KJQM/Fv4aEdB/6twYgRZvqHBd2GiHIQHe7hQ4YHHOG8N6SQ5T8OuzfIaFn3I2zLgOSpwDFJaWExgPZPTEk4o5aw+64KuOa4Gi9KpBjqIqqxKQln0NxstLCDGbTsNcZEJzSp5gK7ZYD7Q+CK0/PfHZeygr8dKiwhZtTYMquxx8D+9w+0PtmCzaC6uMZ04HKli4jFFFUWQfao1262/lnVjSc4vTL66xL20kUUrH2fr7yJc/rpdG1qfaRBwS1+TNgUDNmAiGgNb491o/L4T6z1sO/1yVH8LUXhpfW2iREvRxnwdPJkBsJcLPY2wiJsyWWZxh98J/1IwqiV5xsYDEppDYEGbathS51EdRM3Pk87qfoxfD2fdZtGIcMZdHE1qQkvyhxhG8RUoY2wJjqq2/AZi5463C50Kfk5XJBLp7ZM54vMSvDPs7uoJcVhaFazcDDNsG72A2AHp0xNEPmmKUeDaUIyPgGWG6FkfYB9Kh1OXItxbl1eiQwp+xxNESrOQTPmP6pnt/XHa6hYurRCB2hX5+xCOxPYe0YkbRHlnt3IGjmgNyIjyAcW3xpMDLQzFsdyGyGpyBxTTDcnw5DuqrnEq1lxLRGvOpotbEMAUO2qop5tRNMG+Ez
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB5372.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199021)(5660300002)(44832011)(52536014)(41300700001)(71200400001)(2906002)(83380400001)(122000001)(33656002)(86362001)(38070700005)(38100700002)(82960400001)(26005)(186003)(55016003)(8676002)(8936002)(6506007)(66446008)(9686003)(53546011)(66476007)(64756008)(66556008)(76116006)(66946007)(91956017)(478600001)(7696005)(110136005)(316002)(4326008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ISYAeqA0NAER7EvS9XMWMb+LWWq+4P022dXBSGOXF2zensJdA2bHUL/oP/?=
 =?iso-8859-1?Q?gYH6CT2pqxeSi1pSpt8NN2xYPocn+wemMKiOKSFdMeReIfhSrOUjeUrcue?=
 =?iso-8859-1?Q?vPANbPhfb2DhjEMSeo+2Z7EGnWhKa8huHpzpRCk9QWJyuWCQcl//TVhRll?=
 =?iso-8859-1?Q?ONDxys42Ru93q+yLVJzsJJrbBqqHdrLMj5jsGaloS08gizytclGamlyQWB?=
 =?iso-8859-1?Q?at+5PhbGh91ejafv8tFzrfdahCCDURdW1e/TpQ6Po6wc5uHC3DZh3rpOpX?=
 =?iso-8859-1?Q?qlzFfemdYyo9khjbHP+LXD5sakAiVK6NGwAGSOCRy2kh3ZICQLWu/hi/rt?=
 =?iso-8859-1?Q?7HGCf3ZOfJdcb4P4eZM7GD1ZemkCWXbL+w7tFMvMgrDPXfV58xEqLDCQtm?=
 =?iso-8859-1?Q?qiGUVuWnYDyDB4Mw8hKxuYWYIWZOeHf723i7XHobGpd/o0noF0nwerPr2Q?=
 =?iso-8859-1?Q?kqouNm9+L5IqGvkAULm3zNlKJDot84MgzpNIdj1KNPsiy3O7+O9J/+ZvOT?=
 =?iso-8859-1?Q?pygtIIfDsmbR++NMGUzxDA+RgZnYXYMaly0Os6qh4kHBM5MHg66QwwWALD?=
 =?iso-8859-1?Q?04NlbdJInv46FdKu4otu3izTzE6figPRV2/jBtjSqWYGd6pilpVKaqMscP?=
 =?iso-8859-1?Q?R8pT9dpCqHIsxnNsw3yXTLY/yh1cyC3++rRf1JeXI1snmWtC26r79lfhb2?=
 =?iso-8859-1?Q?102hoAirTyIFM/Wi/jPYF5uefMZce/3rs5zx7coWEF82ug2D9s2VUnGCBP?=
 =?iso-8859-1?Q?7rH845PgHtgLanTz+LQHzaFyqV8/qngGYaWfPYLbwqGRs7SSDBn/+2vUBe?=
 =?iso-8859-1?Q?SdYcX5vUBC4tPh4XCxXjp2UwmmArNKY7yB9yn4oYw5SVJaz1sKv+JveOKp?=
 =?iso-8859-1?Q?aU3Qh8mpOd+VmvqaNIPXet//asgFmlHXIgytBuMmAWoVsSHqD4n5G1Vtl0?=
 =?iso-8859-1?Q?CTrfn47sE99R2r4sXd7Nxw23Nt9CMAwpty45SGnTR+moMuNudA2+RcrI2K?=
 =?iso-8859-1?Q?nWJU3pR6YVh1h4CUGtBKDdpZAw/BoBgKBIdukqwvgQb4z4nd6DcFDv85fI?=
 =?iso-8859-1?Q?TJIrrLE9t7SOu0Ob3PkL4ziEoFkEQSqQ5u/C+kUB4V3scnVMt9gAbF6RAn?=
 =?iso-8859-1?Q?hDrowv0YO0bY5tfAbZ/HrhpLURZAZv/EJik6Cwm5FYVBsvJelPWF6x3REz?=
 =?iso-8859-1?Q?MurYBw55YVLQ8MLDT5b+wjpwba9bQURzbj5SqW9xo7kCTNaYuY5RKagD31?=
 =?iso-8859-1?Q?0Pw+W2lTc4kAh1hmY3HebJhQ1WURsIQ6BL4i6+or5xQjHRLVfj+Rp1Vy+M?=
 =?iso-8859-1?Q?Hx5oBgfNClc4m1lrPIZWRyoJicOOEbYR8u0z9M1lN7AKJQA9zA/jl+kDSI?=
 =?iso-8859-1?Q?EQb/mYNdDFndymwY1+12o4js9RlndFaZURBY0MuYhV1A1KID1vG3mucb3Z?=
 =?iso-8859-1?Q?SNKItTROFT1W46sdsA7jz6ZJxc0u2FuVkVZbODfucVXJqw7GmGRlMof+pW?=
 =?iso-8859-1?Q?H2zVZDGEBoOs2GWVs7rKhc2NOl3EwF8oYszpUMZbz/o6hdkBrN7m+egffK?=
 =?iso-8859-1?Q?o207ccKdNXfBBO1RqjmGEph786A27oicUkB9X+3//8ET//z8/J0Wfrn6/+?=
 =?iso-8859-1?Q?ccRPzKGvGofPkgZ5uJn9kodf1lsXMkcwLf?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Sr/k6wyl5c1D+qZk9kp6dgL3m8mtih/D0T6yM3JmdeBqY+woOgZcyIcq39miacutehGgN1IYXjcv33Z7heRKmaNLAXeB/U6CHOP5wChtwE26j8yufWX/uQTKEgDeQf8psM8I/nv7NYzAzRSt9PBUIalGQnpY+0cyXBzXyudwXgRBdpUUZzfyY7cVO/MpfdiIfcXQNq/JX19yGk+JsAvQduLfSjgfInRXgf+Ce6EhT8YjDKETJTVTLSqvv9gGx1fwbyKQShZWMwQnUuYPokXAZ8/ko7xN+wh6kWAolmQ7MtLGzLtCmvNxiJTRlbNVL8R3nQTkLQ+Qv1hnFRGPxUB+lQg0xkeyLZ4E6DcQzsx788MwpxleWSY7jVkQa3p2eoF9HOF/AXd/iGq+njRUSD6Lrr1rfK1JF1Ew4CSiB9pJtt+G9l4OGg9omiC0WR6JQD4BBAvWqp9Ap9m51Qoqj+NXOhM+xnC6XG2IJW15DsBLOrWVSaybCIk2dK7LAksQYpPfT0Pc8v8YGpekWcLzI2ceMID/KXso6hkOL4vt2yqJksKZq/hDPuWujXY9F7zppXy2RgUBLlRkqQDUUPeXpjWiZY1PYz85Icvhk64XuFTa3nwM8mBUlNLGJP/AnMdkE8tSTjG52Cyufu/m+r4cTTELSpw8oeKtSnRgB9LFJT/kG2u+zOxM5vjVob8I9mGkidxSU+zfJh4QWQVu5h5rBlwd756ENAHjJ4zjl5B2K2idbH9dZueVtonsJ8Yop0J/dk7iyn32EnemFRijJb8dRDju5MlFvUeWLVW7sDK//Q4Zj8rDGXAnxutEoLo5iSyMZ2wwAFtjuxiWyHHnYWVxSZyxntm3XO87nfiW3Rh7ZnpLRxxmwpfATFEjdW0RKE1/86vfItqzWYGUuWyhbgWfdcAwYg==
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB5372.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70c832d4-1f8f-4b99-3d72-08db56dd5ab3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 13:48:11.2093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8g+dxzNHrSzPRFkMWAxOWHHz4MbbkdXq8b1Hym+V/Tu1+F/5QcqQpzb+l4LRPJ0x/BO7HPXJzMTv6+Ncv+k+TuDNqf1CJWMTqbrJ/rBGkh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR03MB5594
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> From: Tom Talpey <tom@talpey.com>=0A=
> Sent: Wednesday, May 17, 2023 2:24 PM=0A=
> To: Ralph Boehme <slow@samba.org>; Ross Lagerwall <ross.lagerwall@citrix.=
com>; linux-cifs@vger.kernel.org <linux-cifs@vger.kernel.org>=0A=
> Cc: Steve French <sfrench@samba.org>; Paulo Alcantara <pc@cjr.nz>; Ronnie=
 Sahlberg <lsahlber@redhat.com>; Shyam Prasad N <sprasad@microsoft.com>; Ro=
hith Surabattula <rohiths@microsoft.com>=0A=
> Subject: Re: [PATCH] cifs: Close deferred files that may be open via hard=
 links =0A=
> =A0=0A=
> [CAUTION - EXTERNAL EMAIL] DO NOT reply, click links, or open attachments=
 unless you have verified the sender and know the content is safe.=0A=
> =0A=
> On 5/17/2023 6:50 AM, Ralph Boehme wrote:=0A=
> > On 5/17/23 10:27, Ross Lagerwall wrote:=0A=
> >> In any case, I have attached a packet trace from running the above=0A=
> >> Python reproducer.=0A=
> > =0A=
> > afaict the STATUS_INVALID_PARAMETER comes from the lease code as you're=
 =0A=
> > passing the same lease key for the open on the link which is illegal af=
air.=0A=
> > =0A=
> > Can you retry the experiment without requesting a lease or ensuring the=
 =0A=
> > second open on the link uses a different lease key?=0A=
> =0A=
> Indeed, the same lease key is coming in both opens, first in=0A=
> packet 3 where it opens "test", and again in packet 18 where=0A=
> it opens the link "new". So it's triggering this assertion in=0A=
> MS-SMB2 section 3.3.5.9.11=0A=
> =0A=
> > The server MUST attempt to locate a Lease by performing a lookup in the=
 LeaseTable.LeaseList=0A=
> > using the LeaseKey in the SMB2_CREATE_REQUEST_LEASE_V2 as the lookup ke=
y. If a lease is found,=0A=
> > Lease.FileDeleteOnClose is FALSE, and Lease.Filename does not match the=
 file name for the=0A=
> > incoming request, the request MUST be failed with STATUS_INVALID_PARAME=
TER=0A=
> =0A=
> Steve/Rohith, is this new behavior in the client code?=0A=
> =0A=
> Tom.=0A=
=0A=
It looks like smb2_get_lease_key() returns the lease key stored in the=0A=
inode, which clearly breaks that assertion when hard links are=0A=
involved.=0A=
=0A=
I can confirm that when the lease keys are forced to be different, the=0A=
test does not fail.=0A=
=0A=
Ross=
