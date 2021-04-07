Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5196BC433B4
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 04:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15487613A9
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 04:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhDGECo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Apr 2021 00:02:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55680 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhDGECn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Apr 2021 00:02:43 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210407040232epoutp035b26fa74fb1509e3a359a42112dc32e6~zd5BGVemE1325313253epoutp03D
        for <linux-cifs@vger.kernel.org>; Wed,  7 Apr 2021 04:02:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210407040232epoutp035b26fa74fb1509e3a359a42112dc32e6~zd5BGVemE1325313253epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617768152;
        bh=zcbqFqizBG4x93lw92n+ul3+LiWPJreK8zRQAE+AREA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ryXr+6rP2sIPabTjr+r0MJrkoAtFrfoqAeCST30Wa/hAPVaz4/47YJG27vAXb0zvw
         MVexvN50KnNIxHYMuAebGI/aHliC30yxwEz2LPPLMYWQiC6Pr68CBpeyt9bFHULTt3
         ai0QxEVK6W4JUGUoBDMxhigBOyESH/WN3lPNGJsY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210407040232epcas1p3e6cf3072e8c0f126014cbba165483a07~zd5AsHfYW1551015510epcas1p31;
        Wed,  7 Apr 2021 04:02:32 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.161]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4FFW1y6XC4z4x9Q0; Wed,  7 Apr
        2021 04:02:30 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.0C.23820.5DE2D606; Wed,  7 Apr 2021 13:02:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210407040229epcas1p3ebb04fed73dc788ef93c5340840531ad~zd4_AfU2-0944609446epcas1p3L;
        Wed,  7 Apr 2021 04:02:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210407040229epsmtrp19bd169e4ccd520e7f841ea36eaf764cc~zd49-wkvZ1062110621epsmtrp1P;
        Wed,  7 Apr 2021 04:02:29 +0000 (GMT)
X-AuditID: b6c32a37-a59ff70000015d0c-91-606d2ed56f6a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5F.ED.33967.5DE2D606; Wed,  7 Apr 2021 13:02:29 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210407040228epsmtip27dedde954999bcabbe78ee2a16eea2dd~zd49m9-Oe0327403274epsmtip2z;
        Wed,  7 Apr 2021 04:02:28 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Zhang Xiaoxu'" <zhangxiaoxu5@huawei.com>
Cc:     <sfrench@samba.org>, <sergey.senozhatsky@gmail.com>,
        <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>, <yukuai3@huawei.com>
In-Reply-To: <20210407034546.2314958-1-zhangxiaoxu5@huawei.com>
Subject: RE: [PATCH] cifsd: Select SG_POOL for SMB_SERVER
Date:   Wed, 7 Apr 2021 13:02:29 +0900
Message-ID: <007901d72b62$d3d59be0$7b80d3a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFIjX3SMW6sGUXLi2xfmsA7j/HxTwDaa5ISq77VNMA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsWy7bCmnu5VvdwEgy+bTCyu3X/PbvHi/y5m
        i5//vzNarP38mN2i4+VRZos5C9ksHs1ay+LA7rFz1l12j5Yjb1k9di/4zOQxd1cfo8fnTXIB
        rFE5NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
        lCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCgwNCvSKE3OLS/PS9ZLzc60MDQyMTIEq
        E3Iy5v85xVywWbji1OyvTA2ML4S6GDk5JARMJL5c3sDaxcjFISSwg1Fi7ftbbBDOJ0aJ1smX
        mCCcb4wSHQvnMsK0zDvcwgxiCwnsZZRYMD0Youglo8ScL7vYQBJsAroS//7sB7NFBPQkdhw+
        DjaWWWA9o8STo2fAujkF7CVOrvsBViQsYCmxZ1MvmM0ioCJx99INJhCbFyg+9cI9KFtQ4uTM
        JywgNrOAtsSyha+ZIS5SkPj5dBkrxDIriQtdK5ggakQkZne2QdX0ckgc2mIOYbtIrD39hhXC
        FpZ4dXwLO4QtJfGyvw3I5gCyqyU+7odq7WCUePHdFsI2lri5HhReHEDjNSXW79KHCCtK7PwN
        CR9mAT6Jd197WCGm8Ep0tEFDWlWi79JhJghbWqKr/QP7BEalWUj+moXkr1lI7p+FsGwBI8sq
        RrHUguLc9NRiwwJj5LjexAhOoFrmOxinvf2gd4iRiYPxEKMEB7OSCO+O3uwEId6UxMqq1KL8
        +KLSnNTiQ4ymwJCeyCwlmpwPTOF5JfGGpkbGxsYWJmbmZqbGSuK8SQYP4oUE0hNLUrNTUwtS
        i2D6mDg4pRqYrjKKzNp+dHXq68UsXO+/st7QrNR91ZvC3X5HeM7qqXKpP1W/Rv8r2/edR/rt
        Dp9Jtx5Yzv/03cBN2b7hoNwG9wR+r0+7FmivUVyVoHb6+2H/CFmtm9r2R3f+uxKUvf+AYnPY
        4p8fzfIZN815vcW/PaBjQqXsYkn3JQLOhoHnj29+IVHwwuOp36yO38HKexqvbdr46tm+Z5by
        9tp88tlyGu+j7S2PybnGzJ0hLL7/WkK715Kt6zlnHhW8f8N7+iEhY2Eh3yvG3EJmG6ZW2jJc
        K1lmUqIiK+B360+I5oyNNy6kPT2k5K660lL6qo2vU3v1i/LXa3dkWvBun3vujGqI7vfbSzum
        uDH+7H466yzXSSWW4oxEQy3mouJEADVCgIwpBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJXveqXm6Cwf7f3BbX7r9nt3jxfxez
        xc//3xkt1n5+zG7R8fIos8WchWwWj2atZXFg99g56y67R8uRt6weuxd8ZvKYu6uP0ePzJrkA
        1igum5TUnMyy1CJ9uwSujEev5rMVXOGtuDHrElMDYwd3FyMnh4SAicS8wy3MXYxcHEICuxkl
        Pi//wQKRkJY4duIMUIIDyBaWOHy4GKLmOaPEy+nfmUFq2AR0Jf792c8GYosI6EnsOHwczGYW
        2Moo8fi/HUTDBKCh2+YwgSQ4BewlTq77AVYkLGApsWdTL5jNIqAicffSDbAaXqD41Av3oGxB
        iZMzn7BADNWW6H3YyghjL1v4mhniUAWJn0+XsUIcYSVxoWsFE0SNiMTszjbmCYzCs5CMmoVk
        1Cwko2YhaVnAyLKKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4mrQ0dzBuX/VB7xAj
        EwfjIUYJDmYlEd4dvdkJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgt
        gskycXBKNTCtWvx3VuQjhi917HYKNVUzSgSm5GgvrxScMK1yk72zjubHaW/LN/zS6Hy27/Sf
        JM3El30bBFdvn/RWxvzSQ51rylMUwx2UTq05HdF4RFZkQdEv3o+2VjfFemLWnzzdev1/+OK8
        5n8s0yxtds6tnSH4R+OrWbTHIdGtmpILmuOn7jRbtfGMji2H7TXhHquA6gW2ifpWYkscrjju
        +3WfsWKV+pPt8dNnlPz7bLzQ1+Ka7TPtn7nCd9exlrMxGPcc+2SyymNZ/NZb7hcUbx1mzVdZ
        8uu2xb2zAif4AlVqnvt//C5x4Gp+/qNbSyf9Zp91QHnv+lVpeneT27P2GOziedb4Ruv+jaIq
        qzoe/cYovl0XlViKMxINtZiLihMBP/eIeRUDAAA=
X-CMS-MailID: 20210407040229epcas1p3ebb04fed73dc788ef93c5340840531ad
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210407034026epcas1p30694eae719a68b92f759dc4e5a92b542
References: <CGME20210407034026epcas1p30694eae719a68b92f759dc4e5a92b542@epcas1p3.samsung.com>
        <20210407034546.2314958-1-zhangxiaoxu5@huawei.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> hulk-robot following build error:
>  fs/cifsd/transport_rdma.c: In function =E2=80=98read_write_done=E2=80=99=
:=0D=0A>=20=20fs/cifsd/transport_rdma.c:1297:2:=20error:=20implicit=20decla=
ration=20of=20function=20=E2=80=98sg_free_table_chained=E2=80=99=20=5B-=0D=
=0A>=20Werror=3Dimplicit-function-declaration=5D=0D=0A>=20=20=201297=20=7C=
=20=20sg_free_table_chained(&msg->sgt,=20SG_CHUNK_SIZE);=0D=0A>=20=0D=0A>=
=20The=20reason=20is=20CONFIG_SG_POOL=20is=20not=20enabled=20in=20the=20con=
fig,=20to=20avoid=20such=20failure,=20select=20SG_POOL=20in=0D=0A>=20Kconfi=
g=20for=20SMB_SERVER.=0D=0A>=20=0D=0A>=20Fixes:=2075b8988dfe83=20(=22cifsd:=
=20add=20server=20handler=20for=20central=20processing=20and=20tranport=20l=
ayers=22)=0D=0A>=20Signed-off-by:=20Zhang=20Xiaoxu=20<zhangxiaoxu5=40huawei=
.com>=0D=0A>=20---=0D=0A>=20=20fs/cifsd/Kconfig=20=7C=201=20+=0D=0A>=20=201=
=20file=20changed,=201=20insertion(+)=0D=0A>=20=0D=0A>=20diff=20--git=20a/f=
s/cifsd/Kconfig=20b/fs/cifsd/Kconfig=20index=20d1ac53c83125..fb57672424be=
=20100644=0D=0A>=20---=20a/fs/cifsd/Kconfig=0D=0A>=20+++=20b/fs/cifsd/Kconf=
ig=0D=0A>=20=40=40=20-17,6=20+17,7=20=40=40=20config=20SMB_SERVER=0D=0A>=20=
=20=09select=20CRYPTO_AEAD2=0D=0A>=20=20=09select=20CRYPTO_CCM=0D=0A>=20=20=
=09select=20CRYPTO_GCM=0D=0A>=20+=09select=20SG_POOL=0D=0A>=20=20=09default=
=20n=0D=0A>=20=20=09help=0D=0A>=20=20=09=20=20Choose=20Y=20here=20if=20you=
=20want=20to=20allow=20SMB3=20compliant=20clients=0D=0Atransport_rdma.c=20i=
s=20built=20when=20SMB_SERVER_SMBDIRECT=20is=20set.=0D=0ASo=20we=20need=20t=
o=20move=20it=20to=20config=20SMB_SERVER_SMBDIRECT.=0D=0A=0D=0Adiff=20--git=
=20a/fs/cifsd/Kconfig=20b/fs/cifsd/Kconfig=0D=0Aindex=20d1ac53c83125..b94cf=
1158182=20100644=0D=0A---=20a/fs/cifsd/Kconfig=0D=0A+++=20b/fs/cifsd/Kconfi=
g=0D=0A=40=40=20-43,6=20+43,7=20=40=40=20config=20SMB_SERVER=0D=0A=20config=
=20SMB_SERVER_SMBDIRECT=0D=0A=20=20=20=20=20=20=20=20bool=20=22Support=20fo=
r=20SMB=20Direct=20protocol=22=0D=0A=20=20=20=20=20=20=20=20depends=20on=20=
SMB_SERVER=3Dm=20&&=20INFINIBAND=20&&=20INFINIBAND_ADDR_TRANS=20=7C=7C=20SM=
B_SERVER=3Dy=20&&=20INFINIBAND=3Dy=20&&=20INFINIBAND_ADDR_TRANS=3Dy=0D=0A+=
=20=20=20=20=20=20=20select=20SG_POOL=0D=0A=20=20=20=20=20=20=20=20default=
=20n=0D=0A=20=0D=0A=20=20=20=20=20=20=20=20help=0D=0A=0D=0AI=20will=20direc=
tly=20update=20your=20patch.=0D=0AThanks=20for=20your=20patch=21=0D=0A>=20-=
-=0D=0A>=202.25.4=0D=0A=0D=0A=0D=0A
