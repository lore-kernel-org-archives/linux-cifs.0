Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C92C77B75
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 16:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbjEWQae (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 12:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbjEWQad (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 12:30:33 -0400
Received: from esa6.hc3370-68.iphmx.com (esa6.hc3370-68.iphmx.com [216.71.155.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B839CDD
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 09:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1684859431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ID0kZr/kNdye0gszp6lgqopOzLnKqqcYMqfH0UR2ozw=;
  b=dZRfdRw2k81rA+KI2pIjhk3CA8g/1KvwEAtauPlprbz5YljPPadCxyaB
   WFDj3b/jqpg7RlTnIukAKhsEYr/71bND83OFZiB13J8mEMzkHbR806INm
   k8loVkCYzDJHCjq8m+YHdFU77/3bTh2drb2nL1yaB5IUvkjScev5oF8OY
   k=;
X-IronPort-RemoteIP: 104.47.51.45
X-IronPort-MID: 109421910
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:rnmwDqy9jy2YHz/XPFh6t+e3xyrEfRIJ4+MujC+fZmUNrF6WrkUAz
 TAbWGyFb/ffNzP8KthyaY2/9RsBupbXy9FqHQo+rSAxQypGp/SeCIXCJC8cHc8wwu7rFxs7s
 ppEOrEsCOhuExcwcz/0auCJQUFUjP3OHfykTrafYEidfCc8IA85kxVvhuUltYBhhNm9Emult
 Mj75sbSIzdJ4RYtWo4vw/zF8EsHUMja4mtC5QRjP6sT5jcyqlFOZH4hDfDpR5fHatE88t6SH
 47r0Ly/92XFyBYhYvvNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ai87XAME0e0ZP4whlqvgqo
 Dl7WT5cfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQq2pYjqhljJBheAGEWxgp4KTgWy
 b8kIwwfVS2om9ua0r6EYOxcu+12eaEHPKtH0p1h5RfwKK58BLrlGuDN79Ie2yosjMdTG/qYf
 9AedTdkcBXHZVtIJ0sTD5U92uyvgxETcRUB8A7T+fVxvjGVkFEZPLvFabI5fvSQQt5O2EKRq
 W/c4G39BjkRNcCFyCrD+XWp7gPKtXqjCd5ITezhrpaGhnWX5kATVxk7ameFmsvl20uQXdFgF
 3Abr39GQa8asRbDosPGdwG/pVaYtxoEVssWGOo/gCmWzq3Lyx2QA2INCDlbZ7QOsM4wWCxv3
 V6HhPv3CjF19r6YU3SQ8vGTtzzaETMbN2IEbi8sVgIA6dClp5s85jrXRf5oErTziM+dMTXry
 jCOpiUkr68egc4Cy+Ow+lWvqym0vJHSRwId4wTcRGW+6Q1lIoWiYuSA81/b7OpAN66cT1Kbu
 2MDldTY5+cLZaxhjwSISeQJWbuvvvCMNWWGhUY1R8V8sTOw53SkYIZcpilkI1tkOdoFfjmvZ
 1LPvQRW59lYO37CgbJLXr9dwv8ClcDIfekJnNiNBjaSSvCdrDO6wRw=
IronPort-HdrOrdr: A9a23:N7Tcvaug7qrt2hfzmftr6pPd7skDddV00zEX/kB9WHVpmwKj5q
 eTdZUgpHnJYVMqMk3I9urwW5VoLUm9yXcX2+gs1NWZLWvbUQKTRekI0WKI+UyEJ8SRzJ846U
 6iScRD4R/LYGSSQfyU3OBwKbgd/OU=
X-Talos-CUID: 9a23:v0auBG4R5gF/wDCFINssrRYoWfwuTm/m8VzMGmOqBVlDTY2oYArF
X-Talos-MUID: 9a23:tL9Uewag2CTrB+BTsx/AhG5mGfhU3Z+cVBEIv5MFhPW4Onkl
X-IronPort-AV: E=Sophos;i="6.00,186,1681185600"; 
   d="scan'208";a="109421910"
Received: from mail-bn1nam02lp2045.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.45])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 May 2023 12:30:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nm8uYeCaJ+oZRMsDPWbzDjjVk+mraaMdWPU8oMlP8z73HmauP6Yskn9YabeQK33LEh+Bm3eTbaggDh3Fva1B15byhZhL58d85HOldhQsfituxiDy6hDzCwejKOBangm2zM5EsfAgevsjcR/5CcgRGKVP63jvi21UzaQvy9BDwDsHecWSakCtZA0xbjlr17guSsCckXJx6bYq52gc1qopDsuHNLYo1MvjIa6Xn/Jc+2b9/gaQO5bjxbqUcIkSQjvh23MVlUyVJJK9MDL1B4RPtXAClxdzP+tbixG1icBuh9ApgdZoTcXFmLV1P++jF+tVWMpaAKvqjMFT+mJ/6qrAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ID0kZr/kNdye0gszp6lgqopOzLnKqqcYMqfH0UR2ozw=;
 b=YqvxAS8+sFmS91fu3C1GCfQYugcBL4r8GHc1DrS6FT9S3T+mva8b1KuCjMkEqaWjUukXtcsYgXLt/20vvnVhnaMhFpSaAdnY3A6px5Ou1QOTFEXeQqhG5WPJ8Eow/UGeRaGxwYYCufq9mB2CLYJrZJWoVgIdot/sbH0PHNoM0lXXFMCQIDK6p6UIjC8wuZ/TJvdVbYOah/fWL1GSQLtK9tUgRN7Sk5NKShIqzV2MZT3/Z4yGijUULceA6bkPURDqYW0/ihogyVuBZo6v43WB8d8xwlz4OQhcJ8at9WYATHhRowZvqeRibM3zpDNXxI3ijQbTggHJZtBK2Gma0beG4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ID0kZr/kNdye0gszp6lgqopOzLnKqqcYMqfH0UR2ozw=;
 b=IzHt2IKlYF6LKqSGVAXhkK3oDIhuGPrjg7xhCHXah5FpsWC6d52z79PHnokYxgYj444nfwSUJhjozUpqwFAds6TX2dJB+VlzfmSHnP88YVexwxy5pt1OBKe10rN2uYVldrMlFG6OQu5dErvA4AJ2m21WYQ+ruBHcgAFf1Ib3Zyc=
Received: from DM6PR03MB5372.namprd03.prod.outlook.com (2603:10b6:5:24f::15)
 by BN8PR03MB4913.namprd03.prod.outlook.com (2603:10b6:408:df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 16:30:23 +0000
Received: from DM6PR03MB5372.namprd03.prod.outlook.com
 ([fe80::53f7:d006:1645:81e2]) by DM6PR03MB5372.namprd03.prod.outlook.com
 ([fe80::53f7:d006:1645:81e2%6]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 16:30:23 +0000
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
Thread-Index: AQHZiAdjwVeGRDUqzk+4gN1288JV8a9dO+MAgADjel6AACtPgIAAKwkAgAAEGFeACZs4Bg==
Date:   Tue, 23 May 2023 16:30:22 +0000
Message-ID: <DM6PR03MB537265393AE53D1A34F1F5CBF0409@DM6PR03MB5372.namprd03.prod.outlook.com>
References: <20230516150153.1864023-1-ross.lagerwall@citrix.com>
 <55740ab3-e020-df8c-07bc-02386486539f@talpey.com>
 <DM6PR03MB5372810EDDBE8C9A5192B1F3F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>
 <8c79fa5a-d84b-13dc-73d6-27dbbd21dbfa@samba.org>
 <193b610a-32b2-fe39-2cec-47724ad7d608@talpey.com>
 <DM6PR03MB53724D5342CB69F587909ED6F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>
In-Reply-To: <DM6PR03MB53724D5342CB69F587909ED6F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR03MB5372:EE_|BN8PR03MB4913:EE_
x-ms-office365-filtering-correlation-id: 2b50fbdd-83ed-4389-8780-08db5bab01bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x8+LETygZLTU+zViXGqWquRa/jO+JzPwRNELfQGEl+5jMzUXl2XGMXl1FdT415VAH4q18r6WLOm2Q1Os60nYFnJat0PhsoP3+rs9FSlxkpe6QFNeriE9S5zEroc70DYIq78HGQNcRofBXtAV/QYmQBPTyfjSksjUZgG2odFAS19VyCelaPE0wT5nMzg08G+WHio3XHOAhuVOUMAjOxqB4EN056U8Zl/NlhscRUAE/AnbJQoneojyMGJpUFp6FpQumrJLhusR+4VI4XNhPsyJbMzdBDGOwwyuZ+cdnCqORvz1Ymg04QSr9LpzeePefHrtZZcedooCJjiSwy8hGRYJridVbzuGSVUmyWUEuTDyEV5Jng+QrXvmW4eo2ShTGEbyqUGhu1GVichvv68I7P+ZvviJNNc51IGTCOopT58raMCqnrf22x6MAsrOXPHJ6OpvSnvzvHfl+cEV0cbUTFn44LNyjFj5yqXjaZZGxujQ60cMbNSsOJfhuuO4dPshneCGGZuGiU/Y8f3bDIgR/XhXRzjxzUI8fVBA2QRtCOL4r/5+TY9UHVqVj7d8gg71DkP5x6s4JisN4vF3SrpxaAKasR1CA81C3u91ssGaB913yTnXHVpKKzXS50ZO2aFtTQTp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB5372.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199021)(55016003)(26005)(186003)(122000001)(53546011)(33656002)(6506007)(9686003)(82960400001)(38100700002)(44832011)(83380400001)(2906002)(41300700001)(7696005)(71200400001)(316002)(54906003)(110136005)(478600001)(66446008)(76116006)(66946007)(66556008)(66476007)(64756008)(91956017)(4326008)(38070700005)(86362001)(8936002)(8676002)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?n/T+94yNWxD7bOgBFccZgB1T1AI02QCVerV7OTRGPojUJfUsaCjdCUe1tx?=
 =?iso-8859-1?Q?oMIKUDAAQT+YMjkNzKsktEvdB1Q1LUkD08HHJBCQTX/jaX2N6sbHNwOTUO?=
 =?iso-8859-1?Q?UZbCEksuf1+bvPdFVcoHLJxcadlPYERW6tRqgkbMi/Rc0Dzr+Eab5ZGphY?=
 =?iso-8859-1?Q?YVyD8Esp3d7U6A3zCVtyKsqCAtJV2jlWg6m8SmG29wsUFZge/lD+7oHvv2?=
 =?iso-8859-1?Q?03sObDmin6oYUMEqbgNLZjfgKySqyITYX8p2syXRf0r82dFPjF+t4EVGlV?=
 =?iso-8859-1?Q?VtbxDOoGcPjgVPd0ofPVxAXzk4UwnMEIx+N2zqPEVPLgIX14pzeU/6Coui?=
 =?iso-8859-1?Q?S8yn7NXGy4qDngfofm1bpSRgrUDQbXWKVSWqczp3V9/L6n4DujkvneOOVQ?=
 =?iso-8859-1?Q?p3SE3PAh09sUz3wEr/Bt0aLzahVk6BU9OAhHP0WanVq+79uC7W45UXUxCO?=
 =?iso-8859-1?Q?TFoQ2fvDNq89gP9O4NMY/v5smooDrAbTq3VdJaF7AxrRg6mqG7QcX6uLJj?=
 =?iso-8859-1?Q?/x6qZB1pL8DHkGx44L54WiYQBc+gIk9ci/C8s/G+zdhqRzHwl8Gyn4EcTD?=
 =?iso-8859-1?Q?V/xR1A2iMW4jWA2tGtxqrmRN/yG9SUoIriYwY8830ZIjvWSqocV0g7Lj4U?=
 =?iso-8859-1?Q?8LG02HnCcsNxvUSMlTsKXreOgXO5/1/1wYgT+Glh2+Xt4wdr18/HozswTu?=
 =?iso-8859-1?Q?ulF3L6MsE9bIEvG+g+ISBTwXpV9uAX+2c+rcXbLc46QMLdd9J1VpLl+Pzt?=
 =?iso-8859-1?Q?aXHeLfrnyGtRDYuKZfRwlBK24i03VMQmvVe0DJOfMp+DM4uPagGSvOG0yu?=
 =?iso-8859-1?Q?MuuPk4snB857BlMaCx4nmRG7o0sXvc0AdHr9RbcTlKwchx/CVOuVArbEJS?=
 =?iso-8859-1?Q?C96PapxGu9ZNJm5DDWHZmXRZQ3K3ooS9y9qNAGqHdjjLqru2/DV0gpaVrq?=
 =?iso-8859-1?Q?F4nxIj0hcYa+4pu86wS4+Ozhc7w2JdOqPG62RzT+5oeeA11yE5fYwrZowg?=
 =?iso-8859-1?Q?xv0uaFxMZlGy9KTMrcyi+acDjn6eCtgXg3koLnXCx4+Ff/VvglSxI9xSod?=
 =?iso-8859-1?Q?I65EV0zThqGDHlR9vDMgjbVtJMUv7ZqYqj+89YTdjnjPo4J7xryMGLe2MR?=
 =?iso-8859-1?Q?4sC3o/fcLkPDF/sKXpcxUqLMvXZx6KjU3da1DpfAE/2euDBSsdVONr+oWk?=
 =?iso-8859-1?Q?+lQFpejx8+dFAzfoCqDY0LBcWuoEfsyKXjEGgXazKRc0cMvHrSb5/hSH5l?=
 =?iso-8859-1?Q?2G01qZQuhUFJVDPyij7zzfBNqZH7pCqEO+bF7/uEvC/Iwsti+qt/pktLhp?=
 =?iso-8859-1?Q?+y1qUgfO7wvtuEdNBonc0MPbcvuktsLOZMwvLjSeHEMBPBgDAlAzEgjPcf?=
 =?iso-8859-1?Q?s4CoOF9K2lUykcEaz4gSr0J9nlffV5jG32u0/UBxV6D6A2GMbaJryEAjdg?=
 =?iso-8859-1?Q?WW3PJWdrYHFk7izPwynrNwna06eUQS8h8/qHouLIOfBxYJ/c7w7uxLGUpT?=
 =?iso-8859-1?Q?dshomDnBjJx0/AnfpCNiNiXJ/xsAUJRQfWXzgN8Q65x/DuDeXB5kxnUIyQ?=
 =?iso-8859-1?Q?ZWNV3s2W+F6K+gltVSQe1bfSgSfohmJ8QwKNOU19c1uf5P2lfpHRg7oRDg?=
 =?iso-8859-1?Q?e4gPIY8u7bulMChoAC5W6CA9hF/GgOor+R?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lUOGhbr5bUd69nYFYa5Sw0nIbygEmzGlbKn+q3buPeEyvmUMXo0AVCMtzotbKBBEa8uwP/6k/I7+2FfOLqNaezFlgZ1IFw63qYVPtUzfCjsG3mmUmhQC/RLBNtXHys2kCbwUzE6yCkFBCgXZ3sBkwvLiKwZiXfqOKBXbgkwFVz1+PoF7cIp1wncx//AXixhzayvDB9tDOWJkgdrblRsyFoobQT3iEduZamWm/HHa8w56Fk2idIARicSk7l+iPNqnsr8l8HYCpaLu76/HsOUbVVy2yoGt1HpkUEpX9KFTB9Yp4WG2zPSYkg6L+uQIHC34ngdGz/CwPc7sBQIHJXGtXjNlcZT2g4q+2WK2noR1dS+phXIYxCnOce9dZnuaBKy2JUUsRq9hLngqrF87mq5OXM8ozalWNIoNTADaUX7MIQoENNyErcVJHEJUP+XvDkzw7qU6Op94qu9E7OS74sDo2EZ/qyg7uXTVAjY/kKBY03Ea6qqNW2VboTuNeIn76BO+eecN6g+PcZHgsQNIFp5A3vQTrrARBTl1a6SgPsFUJaMW0R/B4/QvWRqbkYXBa/iTBM6NBkAFq1u4tF0eWii1tZBch73gIvo8WCxSpp0dRZjg71PplQezYbwONOxOZ+EdLp9KH5JOJ7qi9D/CdBadU8BNrjBgJQuWa3Nuehd+NKN+W7xdrAfjhjzYz40tRwT8wig8c2O90l8cWf3slpo0vqHHRBoeDDK+Eijfinw07GM2c+XgIXg4HICFWypQfDo5uO97LfkjiIqYawi/OJCvTlOukK1WRTXbOHsSL4EC6FOxE3SzJJ4FHUCzkWb39iyFckfH9Zxg77MTkeZGhCCY+/2uA8+XW4K3Ts2zszSf7dgPDCd/9FV3soNStmSBFgBBGq8yYO7GZbP5vQcO++88lQ==
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB5372.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b50fbdd-83ed-4389-8780-08db5bab01bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 16:30:22.9325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GzFz1ZKi2QsPCgDcYTxmWAOZo73pV/3KZtfN8PDn1wBo97I8/jYxeDGQGQjesjrMOAhcAcKZ7zmkKMYtfYFuqkmQFHt7u5/P7ckfFe41Dv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB4913
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> From: Ross Lagerwall <ross.lagerwall@citrix.com>=0A=
> Sent: Wednesday, May 17, 2023 2:48 PM=0A=
> To: Tom Talpey <tom@talpey.com>; Ralph Boehme <slow@samba.org>; linux-cif=
s@vger.kernel.org <linux-cifs@vger.kernel.org>=0A=
> Cc: Steve French <sfrench@samba.org>; Paulo Alcantara <pc@cjr.nz>; Ronnie=
 Sahlberg <lsahlber@redhat.com>; Shyam Prasad N <sprasad@microsoft.com>; Ro=
hith Surabattula <rohiths@microsoft.com>=0A=
> Subject: Re: [PATCH] cifs: Close deferred files that may be open via hard=
 links =0A=
> =A0=0A=
> > From: Tom Talpey <tom@talpey.com>=0A=
> > Sent: Wednesday, May 17, 2023 2:24 PM=0A=
> > To: Ralph Boehme <slow@samba.org>; Ross Lagerwall <ross.lagerwall@citri=
x.com>; linux-cifs@vger.kernel.org <linux-cifs@vger.kernel.org>=0A=
> > Cc: Steve French <sfrench@samba.org>; Paulo Alcantara <pc@cjr.nz>; Ronn=
ie Sahlberg <lsahlber@redhat.com>; Shyam Prasad N <sprasad@microsoft.com>; =
Rohith Surabattula <rohiths@microsoft.com>=0A=
> > Subject: Re: [PATCH] cifs: Close deferred files that may be open via ha=
rd links =0A=
> > =A0=0A=
> > On 5/17/2023 6:50 AM, Ralph Boehme wrote:=0A=
> > > On 5/17/23 10:27, Ross Lagerwall wrote:=0A=
> > >> In any case, I have attached a packet trace from running the above=
=0A=
> > >> Python reproducer.=0A=
> > > =0A=
> > > afaict the STATUS_INVALID_PARAMETER comes from the lease code as you'=
re =0A=
> > > passing the same lease key for the open on the link which is illegal =
afair.=0A=
> > > =0A=
> > > Can you retry the experiment without requesting a lease or ensuring t=
he =0A=
> > > second open on the link uses a different lease key?=0A=
> > =0A=
> > Indeed, the same lease key is coming in both opens, first in=0A=
> > packet 3 where it opens "test", and again in packet 18 where=0A=
> > it opens the link "new". So it's triggering this assertion in=0A=
> > MS-SMB2 section 3.3.5.9.11=0A=
> > =0A=
> > > The server MUST attempt to locate a Lease by performing a lookup in t=
he LeaseTable.LeaseList=0A=
> > > using the LeaseKey in the SMB2_CREATE_REQUEST_LEASE_V2 as the lookup =
key. If a lease is found,=0A=
> > > Lease.FileDeleteOnClose is FALSE, and Lease.Filename does not match t=
he file name for the=0A=
> > > incoming request, the request MUST be failed with STATUS_INVALID_PARA=
METER=0A=
> > =0A=
> > Steve/Rohith, is this new behavior in the client code?=0A=
> > =0A=
> > Tom.=0A=
> =0A=
> It looks like smb2_get_lease_key() returns the lease key stored in the=0A=
> inode, which clearly breaks that assertion when hard links are=0A=
> involved.=0A=
> =0A=
> I can confirm that when the lease keys are forced to be different, the=0A=
> test does not fail.=0A=
> =0A=
=0A=
Hi,=0A=
=0A=
Am I correct in the assertion that the client is associating lease keys wit=
h=0A=
the inode and that is incompatible with the spec (at least when hard links=
=0A=
are involved)?=0A=
=0A=
A brief look at the code suggests changing that would be somewhat involved.=
..=0A=
At least more work than I have time to spare at the moment.=0A=
=0A=
Thanks,=0A=
Ross=
