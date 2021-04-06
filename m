Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E33C433ED
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 23:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC42B61205
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 23:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhDFXcb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 19:32:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45885 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbhDFXcb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 19:32:31 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210406233221epoutp031dc09fe9b0b701cf2da964d90550ab73~zaNG9X1NF0722707227epoutp03S
        for <linux-cifs@vger.kernel.org>; Tue,  6 Apr 2021 23:32:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210406233221epoutp031dc09fe9b0b701cf2da964d90550ab73~zaNG9X1NF0722707227epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617751941;
        bh=+icwq8HzFK04rPCTliKc5O0j/gDq5vxE4uEsIv7eawU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=BvEwJCroMW+1RIY0JukVeYMck7e/FOqgxVSx8es9pDQtlOM66JCtfCeceqBgoM642
         YRmcvWBeurRXppSEVkU1Drnw3g6BwbpVwYP+bCV2H6hG3A4Hsp0FKgESKdNwNZ6jKj
         /SmA9BIursxyktWhCkSumjCBInVrTI+0H3i3mCeQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210406233220epcas1p16283303480b4fd62437bf6aab90c3681~zaNGvIPUP2190721907epcas1p1s;
        Tue,  6 Apr 2021 23:32:20 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.162]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4FFP2C70lwz4x9QC; Tue,  6 Apr
        2021 23:32:19 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.3A.23820.38FEC606; Wed,  7 Apr 2021 08:32:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210406233219epcas1p3ea2f8ffc6598656e27f338b6ab90ade5~zaNFAMLyX0424204242epcas1p3w;
        Tue,  6 Apr 2021 23:32:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210406233219epsmtrp294a02265002c42851dda9f1593a0c026~zaNE-c8Ue2149621496epsmtrp2a;
        Tue,  6 Apr 2021 23:32:19 +0000 (GMT)
X-AuditID: b6c32a37-a59ff70000015d0c-6a-606cef834f57
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.02.08745.28FEC606; Wed,  7 Apr 2021 08:32:18 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210406233218epsmtip1ec691a1838a1ffcbc42d622d1f5f6aa7~zaNE1sKHA2644826448epsmtip1E;
        Tue,  6 Apr 2021 23:32:18 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'L. A. Walsh'" <linux-cifs@tlinx.org>
Cc:     "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?'Aur=C3=A9lien_Aptel'?= <aaptel@suse.com>
In-Reply-To: <606CE6F3.3010701@tlinx.org>
Subject: RE: cifsd: introduce <SMB2n3> kernel server
Date:   Wed, 7 Apr 2021 08:32:19 +0900
Message-ID: <003401d72b3d$15f42440$41dc6cc0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQI4mwLA9g4ye/IuJHeQH3Ush76f8QJ0wPNEAkQm6UwBdATcbwJrs9FaqaB6oDA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdlhTX7f5fU6Cwcs5mhaNb0+zWLz+N53F
        4s6J9WwWL/7vYnZg8fj49BaLx/otV1k8vn9U9vi8SS6AJSrHJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwNCgQK84Mbe4NC9dLzk/18rQwMDIFKgyISdj9rJdbAWTJCs2zmtibmDcIdHF
        yMkhIWAicfHQMuYuRi4OIYEdjBI/TrxkgXA+MUps7nkH5XxmlJj+9AwLTMvLQ4ehErsYJd6f
        OcQG4bxklJi5/wlYFZuArsS/P/vZQGwRAS2J6x++s4IUMQu0M0rcXvWFFSTBKaAp0f/vJDOI
        LQw0tnH7Z7A4i4CKxLd908DivAKWEl/23WCFsAUlTs6EWMAsoC2xbOFrZoiTFCR+Pl3GCrHM
        T2LxvW+sEDUiErM728C+kxD4yi6xZes7qAYXiXOHD0D9Iyzx6vgWdghbSuLzu71AV3MA2dUS
        H/dDlXcwSrz4bgthG0vcXL+BFaSEGej+9bv0IcKKEjt/z2WEWMsn8e5rDyvEFF6JjjYhiBJV
        ib5Lh5kgbGmJrvYP7BMYlWYheWwWksdmIXlgFsKyBYwsqxjFUguKc9NTiw0LjJFjexMjODlq
        me9gnPb2g94hRiYOxkOMEhzMSiK8O3qzE4R4UxIrq1KL8uOLSnNSiw8xmgKDeiKzlGhyPjA9
        55XEG5oaGRsbW5iYmZuZGiuJ8yYZPIgXEkhPLEnNTk0tSC2C6WPi4JRqYJojFffiS90Nrta5
        gseuxUTmPF0vtvO/enrbzqa/0xs4dtdseOqzL1Pj+Kqju1LDRM1PWG/fL+d1VGyh06fm928u
        Jvz98GMTb4URm4XPDKWnXMbzPl+Xd9wze6fnxCN75D7PFGtVORRkuFPI/MuP+DSt8vpnTgbb
        H8n3dCo3MuQ5tzs+W3GrIGqH/oxMpqsSDzt7rB9o69a2BKzUd6nherX0qoD7D9tN1f8/xU/m
        dVHfOEepd0/yzMP61y9MaHASmXC5+dHMzLX/bhcF8GtuD7BZNGdThEPREzfxs7b5GT2P5H+W
        6y7U2HQphufUm9vHO4JaPEojvVxTLDlsv3NZxv9KF1snVtbQqLppE+djbyWW4oxEQy3mouJE
        ADpwbVwXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnG7z+5wEg3f6Fo1vT7NYvP43ncXi
        zon1bBYv/u9idmDx+Pj0FovH+i1XWTy+f1T2+LxJLoAlissmJTUnsyy1SN8ugSuju+cGU0G/
        YMXX3qfMDYxreLsYOTkkBEwkXh46zAJiCwnsYJSYvdIDIi4tcezEGeYuRg4gW1ji8OHiLkYu
        oJLnjBK/z39hAqlhE9CV+PdnPxuILSKgJXH9w3dWkCJmgXZGiRXnp7JDdJxklPj1qZcdpIpT
        QFOi/99JZhBbGGhz4/bPrCA2i4CKxLd908DivAKWEl/23WCFsAUlTs58AnYds4C2RO/DVkYY
        e9nC18wQlypI/Hy6jBXiCj+Jxfe+sULUiEjM7mxjnsAoPAvJqFlIRs1CMmoWkpYFjCyrGCVT
        C4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCY0RLawfjnlUf9A4xMnEwHmKU4GBWEuHd0Zud
        IMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVANTqmFgVPq+
        aSLTjK9bGaz2z17gkTMlZNuMn5bfjAWdQ9RCAgRelvn+70vXZGLTqTu9t89VX57/2stLeRN8
        YpyvLb+ikT31kjpXbfP8P6cbFvqsSDv8Zuol7jBt90+e/23mpW1ZKntFucTY3synJfEJs6+R
        WeguFoOUOOkdBwyCBDaGBDy8o3N+c/Mrk9zLcWLFMk5LpF68ijb4mjfncm3QZq/qiUcSltcF
        KS+vniHMn7jimeeZU34yFhd3TrHPL1abnPt7mVNmhfE1g75X+cqTbjiXbri/Iixvw8fwVdqK
        Wjk9rxnkU/6uDkyK9+W8WnU/JF+QvcLfR6x1zp6anYZVkbrVL4Jlv39+/UiAWYmlOCPRUIu5
        qDgRAPuDZyQAAwAA
X-CMS-MailID: 20210406233219epcas1p3ea2f8ffc6598656e27f338b6ab90ade5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210406225558epcas1p2a840a3cc3ad789c5540b8e133f93f692
References: <YFNRsYSWw77UMxw1@mwanda> <606C1DD6.80606@tlinx.org>
        <87h7kj4t4c.fsf@suse.com>
        <CGME20210406225558epcas1p2a840a3cc3ad789c5540b8e133f93f692@epcas1p2.samsung.com>
        <606CE6F3.3010701@tlinx.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

>=20
> On 2021/04/06 03:14, Aur=C3=A9lien=20Aptel=20wrote:=0D=0A>=20>=20=22L.=20=
A.=20Walsh=22=20<linux-cifs=40tlinx.org>=20writes:=0D=0A>=20>=0D=0A>=20>>=
=20On=202021/03/18=2006:12,=20Dan=20Carpenter=20wrote:=0D=0A>=20>>=0D=0A>=
=20>>>=20=5B=20cifsd:=20introduce=20SMB3=20kernel=20server=22=0D=0A>=20>>>=
=0D=0A>=20>>=20Is=20it=20to=20be=20Linux=20policy=20that=20it=20will=20give=
=20in-kernel=20support=20for=20only=0D=0A>=20>>=20for=20smb3,=20or=20is=20i=
t=20planned=20to=20move=20the=20rest=20of=20the=20proto=20into=20the=0D=0A>=
=20>>=20kernel=20as=20well?=20=20It=20sorta=20seems=20like=20earlier=20part=
s=20of=20the=20protocol,=0D=0A>=20>>=20still=20dominant=20on=20home=20netwo=
rks,=20though=20it=20seems=20linux=20not=20supporting=0D=0A>=20>>=20all=20o=
f=20linux's=20smb=20devices,=20from=20smb2.1=20and=20before.=0D=0A>=20>>=0D=
=0A>=20>=0D=0A>=20>=20smb1=20(aka=20cifs)=20is=20unsecure,=20out=20of=20sup=
port=20and=20being=20actively=0D=0A>=20>=20deprecated=20for=20over=2010=20y=
ears.=20Microsoft=20is=20uninstalling=20the=20smb1=0D=0A>=20>=20server=20on=
=20Windows=20updates.=20That's=20how=20hard=20they=20want=20to=20kill=20it.=
=20Samba=0D=0A>=20>=20is=20planning=20to=20drop=20smb1=20too=20eventually.=
=0D=0A>=20>=0D=0A>=20Dropping=20Smb1=20support=20for=20linux-serving=20woul=
d=20seem=20to=20be=20a=20reasonable=20step,=20since=20I=20would=20be=20hard=
-=0D=0A>=20pressed=20to=20find=20a=20client=20that=20still=20only=20talked=
=20Smb1=20(clients=20from=20XP-era).=0D=0A>=20=0D=0A>=20I=20am=20more=20con=
cerned=20about=20the=20more=20secure=20smb2=20&=20smb2.1=20dialects.=0D=0A>=
=20I=20have=20heard=20there=20is=20a=20security=20difference=20even=20betwe=
en=202=20&=202.1,=20though,=20I=20don't=20often=20see=20a=20breakout=0D=0A>=
=20between=202.0(only)+2.1,=20with=20both=20seeming=20to=20be=20lumped=20in=
=20under=20Smb2.=0D=0A>=20=0D=0A>=20So=20lets=20say=20dropping=20smb1=20isn=
't=20an=20issue...=0D=0A>=20>=0D=0A>=20>=0D=0A>=20>>=20Isn't=20the=20base=
=20of=20an=20smb3=20server=20the=20same=20functions=20of=20an=20smb2.x=0D=
=0A>=20>>=20server=20with=20the=20new=20smb3=20extensions?=0D=0A>=20>>=0D=
=0A>=20>=0D=0A>=20>=20AFAICT=20Namjae's=20ksmbd=20support=20smb2=20and=20ab=
ove.=0D=0A>=20>=0D=0A>=20---=0D=0A>=20=20=20=20=20Then=20would=20it=20be=20=
a=20problem=20if=20it=20is=20called=20something=20like=20=22smb2n3=22=20so=
=20it=20can=20be=20readily=20understood=0D=0A>=20to=20support=20both?=0D=0A=
>=20=0D=0A>=20=20=20=20=20It's=20just=20a=20small=20comfort=20issue,=20sinc=
e=20'smb3'=20really=20doesn't=20seem=20to=20be=20very=20convincing=20about=
=20its=0D=0A>=20smb2-support.=0D=0AYou=20probably=20didn't=20check=20the=20=
cover=20letter=20of=20ksmbd=20patch=20series.=20Supported=20dialects=20was=
=20specified=20in=20it.=0D=0ASee:=0D=0A=20=20https://www.spinics.net/lists/=
linux-cifs/msg21154.html=0D=0AWell,=20It=20seems=20unnecessary=20to=20renam=
e=20subject=20that=20is=20more=20difficult=20to=20understand=20because=20it=
=20is=20specified=0D=0Ain=20the=20document=20and=20cover=20letter.=0D=0A=0D=
=0AThanks=21=0D=0A>=20=0D=0A>=20>=20Cheers,=0D=0A>=20>=0D=0A>=20Likewise=21=
=0D=0A>=20=0D=0A=0D=0A=0D=0A
