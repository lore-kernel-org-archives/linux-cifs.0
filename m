Return-Path: <SRS0=Aa8Y=2J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AD5C43603
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 07:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2849222C2
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 07:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WWig9+LX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfLSHBl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Dec 2019 02:01:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40793 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfLSHBl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Dec 2019 02:01:41 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191219070137epoutp014e630f3ae86967de033512d8952c0956~hs6x7LYNp2343323433epoutp01v
        for <linux-cifs@vger.kernel.org>; Thu, 19 Dec 2019 07:01:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191219070137epoutp014e630f3ae86967de033512d8952c0956~hs6x7LYNp2343323433epoutp01v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1576738897;
        bh=8QwGT0y1aYWUpdb7EOhrYegopaVTq6bjUWpiBGTkEjI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=WWig9+LXkq5oK+L0TiISvXmpNltv18dEieBjH4tRQxXeCGYRNgRqoIX7U9I05ZSa/
         3WyfDaft/lnLw3pFaEqbudNqYmyikHzgAn+RPe3XIfzVoy7MO1Y5FDSCw+DN5ioDC/
         NyGk2nEBKEf5PAa55V1cST0UhnONRdC1D0YRXcwo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20191219070137epcas1p2e056e742be61cff043861ab36450374e~hs6xb1fpC3013430134epcas1p2Z;
        Thu, 19 Dec 2019 07:01:37 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.165]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 47djTr2r4gzMqYlm; Thu, 19 Dec
        2019 07:01:36 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        5E.59.48019.0502BFD5; Thu, 19 Dec 2019 16:01:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20191219070135epcas1p38b95d57ce9ed480208b7dff28c2f4c35~hs6wHWXPj2933529335epcas1p3d;
        Thu, 19 Dec 2019 07:01:35 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191219070135epsmtrp29da239e36314504774b3153e656fc8e9~hs6wGr5X30396503965epsmtrp2w;
        Thu, 19 Dec 2019 07:01:35 +0000 (GMT)
X-AuditID: b6c32a38-257ff7000001bb93-dd-5dfb20506a4d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.63.06569.F402BFD5; Thu, 19 Dec 2019 16:01:35 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20191219070135epsmtip25b53e98b32600eaf9f07fb6b588fdca6~hs6v1tAjS0098100981epsmtip2j;
        Thu, 19 Dec 2019 07:01:35 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Xiaoli Feng'" <xifeng@redhat.com>
Cc:     "'linux-cifs'" <linux-cifs@vger.kernel.org>,
        "'Tom Talpey'" <ttalpey@microsoft.com>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        "'ronnie sahlberg'" <ronniesahlberg@gmail.com>,
        "'Hyeoncheol Lee'" <hyc.lee@gmail.com>
In-Reply-To: <CANFS6bY6b23MznmrGuugcVUEW3UuRbzAxBd4p35K3qdkz4DCAA@mail.gmail.com>
Subject: RE: [Linux-cifsd-devel] How to use SMB Direct
Date:   Thu, 19 Dec 2019 16:01:35 +0900
Message-ID: <004001d5b63a$271ae4d0$7550ae70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHuEumozE+Z4+kZWnwFPgYcpyhAqwFhkFm7AtmqaH4BmSgutgL3bXviAjvAwDcCRm6x9QID2nqKpxW8KOA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRTut/vYNVpdl9VhQa1LFlnTzbl5lYyg1+hBix70GnZzFyftxe5W
        aQVCmA9KKgpqWawiewgVc+l6LE3tbcICK3tQfxS9wCdpOntsu0b+953z+77znXN+h8LkPlJB
        FdjdvMvOWRlyLF7XPEelMiojJnW4J5F98b5Lyn75cwtjB/8MIPZQZS/Bfjy3mj068BRfSBpu
        et9JDbd9fRJDSfCX1NB1t5009PmnGYnN1vkWnjPzLiVvz3OYC+z5OcyKtbmLcnV6tUalyWIz
        GaWds/E5zOKVRtXSAmu0AUa5k7N6oikjJwhM2oL5LofHzSstDsGdw/BOs9WpUTtTBc4meOz5
        qXkOW7ZGrU7XRZnbrBbfSx/ubDfubq3yE8Xo+KoKlEABnQGhQ2FUgcZScjqIYH+glhSDXgQh
        7xNCDPoR+I81SP5JvlZeHWGFEDw6W4uLwVcEgeE7KMYiaRX8Hm4gYziJng3hlrdYjITRHxCc
        KC2Xxh4S6DXw62JvXDCR1kNXa2NcgNPJcHj4RhzL6CzwXxjARJwIj09+xGMYo+dC9dnvmNiS
        EgY/VROi2XZ40X6EFDlJcKr8QNwY6M8k1IcDpChYDPUlwRE8Eb49DEhFrIC+zlA0T0XxHuhp
        GKlfhuDLQI6ItdBx7ToRo2D0HLh2K01Mz4CbkdNItB0PnT8OEmIVGZQdkIuUZKh83jyyxKlQ
        UdotPYwY76jBvKMG844awPvfzIfwK2gy7xRs+bygcWaM/m0/il9nChtEd9pWNiGaQsw42c8l
        QyY5we0UCm1NCCiMSZK9KRs0yWVmrrCIdzlyXR4rLzQhXXTvRzDFpDxH9Nbt7lyNLl2r1bIZ
        +ky9TstMkVE/wyY5nc+5+R087+Rd/3QSKkFRjLQ7hiY0Tjg+FFE/e9VwZmNNR+G7jJ51s2jz
        1g3FkrnJNXh/9yuuJO9yZ//9o5tWkJynrtYwlPrdtLz9YBGtKCLmBRyTMsdIQgm6S2nTE5eN
        t3TD1nlk27aoV7Nj72lrvR7f1fIgssW/8dH6vnszewqqXp/XBoc/7NtwPZuJ+BYyuGDhNCmY
        S+D+AmY+RdmzAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXtdf4Xeswb02C4tr99+zW7z4v4vZ
        4uf/74wWvX2fWC2eLPK3mPT9NIsDm8fOWXfZPXYv+Mzk0brjL7vH+31X2Tw+b5ILYI3isklJ
        zcksSy3St0vgynjZeoG14IpJxd8HW1kbGPerdTFyckgImEi87FvH1sXIxSEksJtR4tecU4wQ
        CWmJYyfOMHcxcgDZwhKHDxeDhIUEnjNKzL3LDmKzCehK/Puznw3EFhFQl7h45A4zyBxmgUeM
        ElPOfmCCGLqOReLrvotgQzkFAiX+Lv8EZgsLmEm8P3MArJtFQFViwp+tYDavgKXEpqXfmSFs
        QYmTM5+wgNjMAtoSvQ9bGWHsZQtfM0McqiDx8+kyVogrkiSuXZ3IBlEjIjG7s415AqPwLCSj
        ZiEZNQvJqFlIWhYwsqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOIS2tHYwnTsQf
        YhTgYFTi4f3h+itWiDWxrLgy9xCjBAezkgjv7Y6fsUK8KYmVValF+fFFpTmpxYcYpTlYlMR5
        5fOPRQoJpCeWpGanphakFsFkmTg4pRoYS7XudS11fhOm1fpzrZmPa91OY4bkC5NKZRb8uSJ0
        e/FZjqXdJasvq/3ieRB02LZtE9NzjRPlVcul5oXOZuu0Cur7yPeiO/rpo0VrRdXcagpkmL8d
        dPRP2GwTosx07UzUOQE9u0x9wQ+zX2jH999TjnLbNsGbY+bW78of7t+wY1/Z9ex5b0S5Ektx
        RqKhFnNRcSIAeSQI5J0CAAA=
X-CMS-MailID: 20191219070135epcas1p38b95d57ce9ed480208b7dff28c2f4c35
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20191219064806epcas1p31ff25d186265e636eeceb59116eafa19
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com>
        <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com>
        <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com>
        <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com>
        <CAN05THShz43rw51JP-1X7JFjbuPCLAH2jcv+8x=d65UtMT+2hQ@mail.gmail.com>
        <2122939021.2041834.1576722876658.JavaMail.zimbra@redhat.com>
        <CGME20191219064806epcas1p31ff25d186265e636eeceb59116eafa19@epcas1p3.samsung.com>
        <CANFS6bY6b23MznmrGuugcVUEW3UuRbzAxBd4p35K3qdkz4DCAA@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please read README file to build cifsd

And SMB direct disabled by default.
Enable smb direct support on config.

<M>   CIFS server support=20
 =5B*=5D     Support for SMB Direct protocol=20

> -----Original Message-----
> From: Hyeoncheol Lee <hyc.lee=40gmail.com>
> Sent: Thursday, December 19, 2019 3:48 PM
> To: Xiaoli Feng <xifeng=40redhat.com>
> Cc: linux-cifs <linux-cifs=40vger.kernel.org>; Tom Talpey
> <ttalpey=40microsoft.com>; linux-cifsd-devel=40lists.sourceforge.net; ron=
nie
> sahlberg <ronniesahlberg=40gmail.com>
> Subject: Re: =5BLinux-cifsd-devel=5D How to use SMB Direct
>=20
> Hello Xiaoli,
>=20
> cifsd is an in-kernel SMB server which supports SMB Direct.
> If you want to test SMB Direct with cifs, you can use cifsd.
>=20
> Currently we have tested SMB Direct between two old fashioned Mellanox
> ConnectX devices which are connected directly, and between two soft RoCE
> devices in kernel.
>=20
> You can get cifsd's code from the following url, and If you have any
> questions, we will help you.
>=20
> https://protect2.fireeye.com/url?k=3D02be8777-5f6a3b1f-02bf0c38-
> 0cc47a3356b2-b295524a9bc31dd5&u=3Dhttps://github.com/cifsd-team/cifsd.git
>=20
> Thank you.
>=20
>=20
> 2019=EB=85=84=2012=EC=9B=94=2019=EC=9D=BC=20(=EB=AA=A9)=20=EC=98=A4=EC=A0=
=84=2011:35,=20Xiaoli=20Feng=20<xifeng=40redhat.com>=EB=8B=98=EC=9D=B4=20=
=EC=9E=91=EC=84=B1:=0D=0A>=20>=0D=0A>=20>=20Thanks=20Ronnie=20for=20the=20i=
nformation.=20Last=20question:=20Is=20it=20supported=20that=0D=0A>=20>=20mo=
unt=20the=20windows=20file=20server(has=20rdma=20hardware)=20with=20SMB=20D=
irect=20in=0D=0A>=20linux=20client(has=20rdma=20hardware)?=0D=0A>=20>=0D=0A=
>=20>=20-----=20Original=20Message=20-----=0D=0A>=20>=20>=20From:=20=22ronn=
ie=20sahlberg=22=20<ronniesahlberg=40gmail.com>=0D=0A>=20>=20>=20To:=20=22X=
iaoli=20Feng=22=20<xifeng=40redhat.com>=0D=0A>=20>=20>=20Cc:=20=22Tom=20Tal=
pey=22=20<ttalpey=40microsoft.com>,=20=22linux-cifs=22=0D=0A>=20>=20>=20<li=
nux-cifs=40vger.kernel.org>=0D=0A>=20>=20>=20Sent:=20Wednesday,=20December=
=2018,=202019=204:12:32=20PM=0D=0A>=20>=20>=20Subject:=20Re:=20How=20to=20u=
se=20SMB=20Direct=0D=0A>=20>=20>=0D=0A>=20>=20>=20I=20don't=20think=20samba=
=20supports=20SMB=20Direct.=0D=0A>=20>=20>=20Metze=20used=20to=20have=20a=
=20private=20repo=20with=20some=20experimental=20patches=20but=0D=0A>=20>=
=20>=20I=20don't=20think=20it=20has=20landed=20in=20official=20samba=20yet.=
=0D=0A>=20>=20>=0D=0A>=20>=20>=20For=20a=20linux=20server,=20there=20is=20a=
n=20experimental=20kernel=20based=20server=0D=0A>=20>=20>=20called=20cifsd=
=20which=20should=20support=20SMBDirect=20but=20is=20incomplete=20in=0D=0A>=
=20>=20>=20other=20areas.=20It=20is=20not=20part=20of=20linus=20tree=20yet=
=20(but=20soon=20I=20hope).=0D=0A>=20>=20>=0D=0A>=20>=20>=20Windows=20serve=
rs=20support=20SMBDirect=20but=20I=20am=20not=20aware=20of=20any=0D=0A>=20>=
=20>=20soft-rdma=20support=20so=20you=20might=20be=20limited=20to=20just=20=
using=20real=20hw=20for=0D=0A>=20>=20>=20any=20tests.=0D=0A>=20>=20>=0D=0A>=
=20>=20>=20Linux=20serverside=20SMBD=20support=20is=20not=20ready=20afaik.=
=0D=0A>=20>=20>=0D=0A>=20>=20>=20On=20Wed,=20Dec=2018,=202019=20at=2012:49=
=20PM=20Xiaoli=20Feng=20<xifeng=40redhat.com>=20wrote:=0D=0A>=20>=20>=20>=
=0D=0A>=20>=20>=20>=20Hello=20Tom,=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20=
Then=20I=20try=20to=20use=20IP=20to=20mount,=20it=20show=20this=20error:=0D=
=0A>=20>=20>=20>=20=5B79912.177783=5D=20CIFS=20VFS:=20_smbd_get_connection:=
1740=20rdma_connect=0D=0A>=20>=20>=20>=20failed=0D=0A>=20>=20>=20>=20port=
=3D5445=0D=0A>=20>=20>=20>=20=5B79912.220723=5D=20CIFS=20VFS:=20_smbd_get_c=
onnection:1740=20rdma_connect=0D=0A>=20>=20>=20>=20failed=0D=0A>=20>=20>=20=
>=20port=3D445=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20Client:=0D=0A>=20>=
=20>=20>=20=24=20mount=20//172.31.0.250/cifs=20cifs=20-o=20user=3Droot,pass=
word=3Dredhat,rdma=0D=0A>=20>=20>=20>=20mount=20error(2):=20No=20such=20fil=
e=20or=20directory=20Refer=20to=20the=0D=0A>=20>=20>=20>=20mount.cifs(8)=20=
manual=20page=20(e.g.=20man=20mount.cifs)=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=
=20>=20Server:=0D=0A>=20>=20>=20>=20=24=20ib=20addr=20=7Cgrep=20172.31.0.25=
0/=0D=0A>=20>=20>=20>=20mlx4_ib0:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20Link=20UP,=20Interface=20UP=20=20=20172.31.0.250/24=0D=0A>=20>=20>=20>=
=0D=0A>=20>=20>=20>=20Samba=20version=20is=204.11.2.=20And=20firewalld=20is=
=20stopped.=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20-----=20Original=20Mess=
age=20-----=0D=0A>=20>=20>=20>=20>=20From:=20=22Tom=20Talpey=22=20<ttalpey=
=40microsoft.com>=0D=0A>=20>=20>=20>=20>=20To:=20=22Xiaoli=20Feng=22=20<xif=
eng=40redhat.com>,=0D=0A>=20>=20>=20>=20>=20linux-cifs=40vger.kernel.org=0D=
=0A>=20>=20>=20>=20>=20Sent:=20Tuesday,=20December=2017,=202019=201:11:24=
=20AM=0D=0A>=20>=20>=20>=20>=20Subject:=20RE:=20How=20to=20use=20SMB=20Dire=
ct=0D=0A>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20>=20-----Original=20Mess=
age-----=0D=0A>=20>=20>=20>=20>=20>=20From:=20linux-cifs-owner=40vger.kerne=
l.org=0D=0A>=20>=20>=20>=20>=20>=20<linux-cifs-owner=40vger.kernel.org>=0D=
=0A>=20>=20>=20>=20>=20>=20On=0D=0A>=20>=20>=20>=20>=20>=20Behalf=20Of=20Xi=
aoli=20Feng=0D=0A>=20>=20>=20>=20>=20>=20Sent:=20Monday,=20December=2016,=
=202019=2010:30=20AM=0D=0A>=20>=20>=20>=20>=20>=20To:=20linux-cifs=40vger.k=
ernel.org=0D=0A>=20>=20>=20>=20>=20>=20Subject:=20=5BEXTERNAL=5D=20How=20to=
=20use=20SMB=20Direct=0D=0A>=20>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20>=
=20Hello=20guys,=0D=0A>=20>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20>=20I'=
d=20like=20to=20test=20SMB=20Direct.=20But=20it's=20failed.=20I'm=20not=20s=
ure=20if=0D=0A>=20>=20>=20>=20>=20>=20it=20works=20in=20upstream.=0D=0A>=20=
>=20>=20>=20>=20>=20I=20setup=20samba=20server=20on=20one=20rdma=20machine=
=20with=205.5.0-rc1+=0D=0A>=20>=20>=20>=20>=20>=20kernel.=20The=20smb.conf=
=20is:=0D=0A>=20>=20>=20>=20>=20>=20=5Bcifs=5D=0D=0A>=20>=20>=20>=20>=20>=
=20path=3D/mnt/cifs=0D=0A>=20>=20>=20>=20>=20>=20writeable=3Dyes=0D=0A>=20>=
=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20>=20Then=20I=20try=20to=20mount=
=20the=20share=20on=20another=20rdma=20machine=20with=0D=0A>=20>=20>=20>=20=
>=20>=205.5.0-rc1+=20kernel.=0D=0A>=20>=20>=20>=20>=20>=20=20=20=20mount=20=
//=24RDMA/cifs=20cifs=20-o=0D=0A>=20>=20>=20>=20>=20>=20user=3Droot,passwor=
d=3D=24password,rdma=0D=0A>=20>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20>=
=20It's=20failed=20because=20of=20=22CIFS=20VFS:=20smbd_create_id:614=0D=0A=
>=20>=20>=20>=20>=20>=20rdma_resolve_addr()=0D=0A>=20>=20>=20>=20>=20>=20co=
mpleted=20-113=22=0D=0A>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20Errno=201=
13=20is=20=22no=20route=20to=20host=22.=20Sounds=20like=20a=20network=20or=
=20address=0D=0A>=20issue.=0D=0A>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20=
Tom.=0D=0A>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20>=20Does=20SMB=20Direc=
t=20work=20fine=20in=20upstream?=0D=0A>=20>=20>=20>=20>=20>=0D=0A>=20>=20>=
=20>=20>=20>=20Thanks.=0D=0A>=20>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20=
>=20=24=20cat=20/boot/config-5.5.0-rc1+=20=7Cgrep=20SMB_DIRECT=0D=0A>=20>=
=20>=20>=20>=20>=20CONFIG_CIFS_SMB_DIRECT=3Dy=20=24=20ibstat=20CA=20'mlx4_0=
'=0D=0A>=20>=20>=20>=20>=20>=20=20=20=20=20CA=20type:=20MT4099=0D=0A>=20>=
=20>=20>=20>=20>=20=20=20=20=20Number=20of=20ports:=202=0D=0A>=20>=20>=20>=
=20>=20>=20=20=20=20=20Firmware=20version:=202.42.5000=0D=0A>=20>=20>=20>=
=20>=20>=20=20=20=20=20Hardware=20version:=201=0D=0A>=20>=20>=20>=20>=20>=
=20=20=20=20=20Node=20GUID:=200xf4521403007be0e0=0D=0A>=20>=20>=20>=20>=20>=
=20=20=20=20=20System=20image=20GUID:=200xf4521403007be0e3=0D=0A>=20>=20>=
=20>=20>=20>=20=20=20=20=20Port=201:=0D=0A>=20>=20>=20>=20>=20>=20=20=20=20=
=20=20=20=20=20=20=20=20=20State:=20Active=0D=0A>=20>=20>=20>=20>=20>=20=20=
=20=20=20=20=20=20=20=20=20=20=20Physical=20state:=20LinkUp=0D=0A>=20>=20>=
=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20Rate:=2056=0D=0A>=20>=20=
>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20Base=20lid:=2029=0D=0A>=
=20>=20>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20LMC:=200=0D=0A>=
=20>=20>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20SM=20lid:=201=0D=
=0A>=20>=20>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20Capability=
=20mask:=200x0259486a=0D=0A>=20>=20>=20>=20>=20>=20=20=20=20=20=20=20=20=20=
=20=20=20=20Port=20GUID:=200xf4521403007be0e1=0D=0A>=20>=20>=20>=20>=20>=20=
=20=20=20=20=20=20=20=20=20=20=20=20Link=20layer:=20InfiniBand=0D=0A>=20>=
=20>=20>=20>=20>=20=20=20=20=20Port=202:=0D=0A>=20>=20>=20>=20>=20>=20=20=
=20=20=20=20=20=20=20=20=20=20=20State:=20Active=0D=0A>=20>=20>=20>=20>=20>=
=20=20=20=20=20=20=20=20=20=20=20=20=20Physical=20state:=20LinkUp=0D=0A>=20=
>=20>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20Rate:=2040=0D=0A>=
=20>=20>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20Base=20lid:=2044=
=0D=0A>=20>=20>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20LMC:=201=
=0D=0A>=20>=20>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20SM=20lid:=
=2036=0D=0A>=20>=20>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20Capa=
bility=20mask:=200x02594868=0D=0A>=20>=20>=20>=20>=20>=20=20=20=20=20=20=20=
=20=20=20=20=20=20Port=20GUID:=200xf4521403007be0e2=0D=0A>=20>=20>=20>=20>=
=20>=20=20=20=20=20=20=20=20=20=20=20=20=20Link=20layer:=20InfiniBand=0D=0A=
>=20>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20>=0D=0A>=20>=20>=20>=20>=20>=
=20--=0D=0A>=20>=20>=20>=20>=20>=20Best=20regards=21=0D=0A>=20>=20>=20>=20>=
=20>=20XiaoLi=20Feng=20=E5=86=AF=E5=B0=8F=E4=B8=BD=0D=0A>=20>=20>=20>=20>=
=20>=0D=0A>=20>=20>=20>=20>=20>=20Red=20Hat=20Software=20(Beijing)=20Co.,Lt=
d=20filesystem-qe=20Team=0D=0A>=20>=20>=20>=20>=20>=20IRC:xifeng=EF=BC=8C=
=23channel:=20fs-qe=0D=0A>=20>=20>=20>=20>=20>=20Tel:+86-10-8388112=0D=0A>=
=20>=20>=20>=20>=20>=209/F,=20Raycom=0D=0A>=20>=20>=20>=20>=0D=0A>=20>=20>=
=20>=20>=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=0D=0A>=20>=20>=0D=0A>=20>=0D=0A>=
=20=0D=0A>=20=0D=0A>=20_______________________________________________=0D=
=0A>=20Linux-cifsd-devel=20mailing=20list=0D=0A>=20Linux-cifsd-devel=40list=
s.sourceforge.net=0D=0A>=20https://lists.sourceforge.net/lists/listinfo/lin=
ux-cifsd-devel=0D=0A=0D=0A
