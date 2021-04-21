Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A9EC433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 23:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5262E61422
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 23:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbhDUXeS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Apr 2021 19:34:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39924 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbhDUXeS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Apr 2021 19:34:18 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210421233341epoutp025a3bc4e9439855d213110b68bd6571e6~4A5jhe7up3007930079epoutp02g
        for <linux-cifs@vger.kernel.org>; Wed, 21 Apr 2021 23:33:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210421233341epoutp025a3bc4e9439855d213110b68bd6571e6~4A5jhe7up3007930079epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619048021;
        bh=I/DEkzJ9kyt8//k1QP5wJel7OucqE6WFoPo7drB45Ck=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=WVkt+Dci3EtPw9GcfgbOfepf9Hw6j+GdlyTAUOcvCqbu9tsO10vCc9zj105TeF+19
         PcbuM1tFxzcUSMTOCAe0jcukNfiMoQgFrGf74TI1KVIqcThA5t2WcSEGMel8fPIp3t
         mLE7BBxuHnNU4L33u1TVyc/zVlSL+PNzDbg78XMM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210421233340epcas1p2e634095c7e960d70b211bc84736ff62b~4A5jMMA-31097810978epcas1p2C;
        Wed, 21 Apr 2021 23:33:40 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.159]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FQcLq63C7z4x9Pv; Wed, 21 Apr
        2021 23:33:39 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.57.10258.356B0806; Thu, 22 Apr 2021 08:33:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210421233339epcas1p4c5ff7618a579d5ed91641745816310c9~4A5hqxC1x0176401764epcas1p4Y;
        Wed, 21 Apr 2021 23:33:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210421233339epsmtrp1b82c545415455274c1e4738655121619~4A5hqIERy2306223062epsmtrp1a;
        Wed, 21 Apr 2021 23:33:39 +0000 (GMT)
X-AuditID: b6c32a38-419ff70000002812-69-6080b653aa73
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.94.08163.356B0806; Thu, 22 Apr 2021 08:33:39 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210421233339epsmtip23345600d32e406e4e0016091dd0cb20c~4A5hfHBfG0844508445epsmtip2R;
        Wed, 21 Apr 2021 23:33:39 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     =?UTF-8?Q?'Aur=C3=A9lien_Aptel'?= <aaptel@suse.com>
Cc:     "'Steve French'" <smfrench@gmail.com>,
        "'CIFS'" <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>
In-Reply-To: <875z0fzfui.fsf@suse.com>
Subject: RE: ksmbd testing progress - buildbot run passed
Date:   Thu, 22 Apr 2021 08:33:39 +0900
Message-ID: <029501d73706$c1d85270$4588f750$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGqunUKZP0ukLCojsS1cfECHSQHtAK1BdCWAQCx5k+q+uXL4A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdlhTTzd4W0OCwZutBhaNb0+zWLz4v4vZ
        4uf/74wWb14cZnNg8dg56y67x+4Fn5k81m+5yuLxeZNcAEtUjk1GamJKapFCal5yfkpmXrqt
        kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvp1NUX5pSapC
        Rn5xia1SakFKToGhQYFecWJucWleul5yfq6VoYGBkSlQZUJOxrll/SwF/6UrXk79wtzAOFu6
        i5GTQ0LARKK34yxjFyMXh5DADkaJ7rl9zBDOJ0aJ9sfnoDKfGSUeLdnODNOyccoFdojELkaJ
        5gWtUFUvGSXWvjrEAlLFJqAr8e/PfjYQW0TAXKJh0h92EJtZoFbi+pG9YDWcAmoSuzacAbOF
        BSwl3i/sYwKxWQRUJXZ3rwazeYHiR1/+hbIFJU7OfMICMUdbYtnC11AXKUj8fLqMFWKXk8Tu
        A2uhdolIzO5sA/tHQuAru8TqrTeYIBpcJDau/AFlC0u8Or6FHcKWknjZ3wZkcwDZ1RIf90PN
        72CUePHdFsI2lri5fgMrSAmzgKbE+l36EGFFiZ2/5zJCrOWTePe1hxViCq9ER5sQRImqRN+l
        w1BLpSW62j+wT2BUmoXksVlIHpuF5IFZCMsWMLKsYhRLLSjOTU8tNiwwQY7sTYzg5KhlsYNx
        7tsPeocYmTgYDzFKcDArifCuLW5IEOJNSaysSi3Kjy8qzUktPsRoCgzqicxSosn5wPScVxJv
        aGpkbGxsYWJmbmZqrCTOm+5cnSAkkJ5YkpqdmlqQWgTTx8TBKdXAZLxL0uy8xILcSft3tp7V
        2/lT1Gma26FzPBZ+kWesguUOKxitvBl9/sC9+uM8FY3rIp2Dbgqut3bjS3FsOsin/fvSRcFn
        HN8YMu5tWXhx57tsq/4tSrGffHcXRy+sOR3bKHfLI1JJ7X93jpbVArXATdnnd25btHrnsdnB
        9q82dh59cPC62kJLTuFoFwmtwoQrXuUmfRuDm8OFw1cZ5ahkfdm2pyjoZtyOW86xE4J2TIlT
        nrv4VwLje6PFRkEn24IaFiz98yHzkcPtLbvy1bOqVYLrnlZ5OOf3Xa7WiLJui3f/3qhlcFn+
        vb/SZKHgm7fzGCYVh7Jq1S67ZP6epVeLpUp/79NvP1N5ou2eCoorsRRnJBpqMRcVJwIA7LTb
        bBcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWy7bCSvG7wtoYEg6/fWC0a355msXjxfxez
        xc//3xkt3rw4zObA4rFz1l12j90LPjN5rN9ylcXj8ya5AJYoLpuU1JzMstQifbsEroxl29pY
        Cp4IV/w8uJK5gfERfxcjJ4eEgInExikX2LsYuTiEBHYwSvzaO58NIiEtcezEGeYuRg4gW1ji
        8OFiiJrnjBI3r39iBalhE9CV+PdnP1i9iIC5RMOkP+wgNrNAvcTmo60sEA17GCV+zjnFDJLg
        FFCT2LXhDAuILSxgKfF+YR8TiM0ioCqxu3s1mM0LFD/68i+ULShxcuYTFoih2hK9D1sZYexl
        C18zQxyqIPHz6TJWiCOcJHYfWAt1hIjE7M425gmMwrOQjJqFZNQsJKNmIWlZwMiyilEytaA4
        Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOE60tHYw7ln1Qe8QIxMH4yFGCQ5mJRHetcUNCUK8
        KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwVbPpzc/N9L9+
        aGH8Y68/3F93/l4gmn79vKvdhAmnPtexLvrE5K+SarPA10Rw4qa5haGCOzW2SKtf2bZ6QfdR
        I6YLkgsWrHpkPX1hcUO3ZRefxryfl2Rvmisuvf42s2Zz4B2ubwsmnVbm8XdKv/r3e9vUyV9/
        VZmJf/Ksj1kiGNr2UvvTj3rO1SkxJakGu1QuHfu8z7Tp0Zl2ueLfvHZFbxz8fho/vlQt+ire
        LjfovODCm5c6luT5i304/ujTpFWfN4iKhkqzhAg/7U+7sFqJj9t7R8Imme6/Crl1X2/cvMM1
        XePMVJGC2TOyZ5r8CHnvXSZecVfVbZXCd6WOlenpJsr9H2yuNojF/2xbknD1uxJLcUaioRZz
        UXEiACtYjb0CAwAA
X-CMS-MailID: 20210421233339epcas1p4c5ff7618a579d5ed91641745816310c9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210421175112epcas1p388a4e7425658c33eb511d6c491ca6a21
References: <CAH2r5mse7yH8VxL4x3bRz1qe2K1p69mo6ApMZzQH_v8ZLpy6kA@mail.gmail.com>
        <CGME20210421175112epcas1p388a4e7425658c33eb511d6c491ca6a21@epcas1p3.samsung.com>
        <875z0fzfui.fsf@suse.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

>=20
> Hi,
Hi Aur=C3=A9lien,=0D=0A=0D=0A>=20=0D=0A>=20I=20have=20started=20a=20small=
=20project=20to=20test=20ksmbd=20by=20fuzzing.=0D=0AReally=20great=20work=
=21,=20We=20can=20add=20this=20to=20buildbot=20test=20of=20ksmbd.=0D=0A=0D=
=0A>=20=0D=0A>=20It's=20based=20on=20an=20existing=20project=20called=20Fuz=
zotron=20and=20it's=20not=20finished=20yet.=20I=20have=20taken=20code=20fro=
m=0D=0A>=20libsmb2=20and=20other=20places=20to=20setup=20a=20valid=20connec=
tion=20(negprot,=20sess=20setup,=20tcon)=20before=20the=20fuzzing=0D=0A>=20=
starts.=20The=20code=20is=20very=20messy,=20not=20clean=20at=20all=20(all=
=20SMB2=20logic=20is=20in=20callback.c)=0D=0A>=20=0D=0A>=20https://protect2=
.fireeye.com/v1/url?k=3Dd034d6f7-8fafefb8-d0355db8-0cc47a30d446-=0D=0A>=20a=
31c437df7256da6&q=3D1&e=3D2ad65418-4da5-4fd7-85e8-=0D=0A>=2061c1b0dea5c7&u=
=3Dhttps%3A%2F%2Fgithub.com%2Faaptel%2Ffuzzotron=0D=0A>=20=0D=0A>=20I=20hav=
en't=20had=20time=20to=20finish=20it,=20TCON=20creation=20fails=20with=20AC=
CESS_DENIED,=20I=20haven't=20figured=20out=20why=0D=0A>=20yet=20:(=0D=0AOka=
y,=20I=20will=20join=20this=20project=20after=20ksmbd=20upstream=20is=20com=
pleted.=0D=0A=0D=0A>=20=0D=0A>=20Maybe=20there's=20a=20better=20project=20t=
o=20fuzz=20network=20servers,=20I've=20just=20used=20fuzzotron=20because=20=
the=20code=0D=0A>=20looked=20simple=20enough.=20The=20callback.c=20has=20al=
l=20the=20required=20code=20so=20it=20should=20be=20relatively=20easy=20to=
=20move=0D=0A>=20to=20another=20fuzzer.=0D=0ALet=20me=20check=20it.=0D=0A>=
=20=0D=0A>=20I=20think=20it=20would=20be=20very=20useful=20to=20run=20this=
=20on=20ksmbd,=20because:=0D=0A>=20=0D=0A>=20-=20the=20stakes=20of=20securi=
ty=20issues=20in=20that=20code=20are=20very=20high.=0D=0A>=20-=20it=20would=
=20make=20people=20trust=20ksmbd=20code=20a=20lot=20more=20if=20it=20passes=
=20this.=0D=0AAgreed.=0D=0A=0D=0A>=20=0D=0A>=20Quick=20how=20to=20if=20you=
=20want=20to=20give=20it=20a=20try:=0D=0A>=20*=20get=20radamsa=20https://gi=
tlab.com/akihe/radamsa=20and=20compile=20it,=20put=20it=20in=20=24PATH=0D=
=0A>=20*=20make=20a=20test=20folder=20to=20be=20used=20for=20test=20input=
=20samples=20(valid=20SMB2=20packets)=0D=0A>=20-=20dd=20if=3D/dev/urandom=
=20of=3Dtest/sample1=20bs=3D1K=20count=3D1=20(simple=20invalid=20test)=0D=
=0A>=20*=20make=20a=20script=20to=20test=20if=20server=20crashed,=20for=20e=
xample:=0D=0A>=20-=20echo=20'ping=20-c1=20192.168.2.110'=20>=20check.sh=0D=
=0A>=20*=20run=0D=0A>=20./fuzzotron=20--radamsa=20--directory=20=24PWD/test=
=20-h=20192.168.2.110=20-p=20445=20-P=20tcp=20-z=20=22=24PWD/check.sh=22=20=
-o=0D=0A>=20output=0D=0A>=20=0D=0A>=20Unfortunately=20it=20fails=20because=
=20of=20bad=20TCON=20creation=20right=20now,=20as=20I=20said=20earlier...=
=20I=20need=20to=20find=0D=0A>=20some=20time=20to=20find=20the=20issue.=0D=
=0AOkay,=20We=20are=20focusing=20on=20ksmbd=20upstream=20now,=20Only=20if=
=20it=20is=20completed,=20We=20will=20be=20able=20to=20work=20together.=0D=
=0AAnd=20It=20is=20really=20necessary=20for=20ksmbd=20and=20thank=20you=20f=
or=20sharing=20your=20work=21=0D=0A=0D=0A>=20=0D=0A>=20Cheers,=0D=0A>=20--=
=0D=0A>=20Aur=C3=A9lien=20Aptel=20/=20SUSE=20Labs=20Samba=20Team=0D=0A>=20G=
PG:=201839=20CB5F=209F5B=20FB9B=20AA97=20=208C99=2003C8=20A49B=20521B=20D5D=
3=20SUSE=20Software=20Solutions=20Germany=20GmbH,=0D=0A>=20Maxfeldstr.=205,=
=2090409=20N=C3=BCrnberg,=20DE=0D=0A>=20GF:=20Felix=20Imend=C3=B6rffer,=20M=
ary=20Higgins,=20Sri=20Rasiah=20HRB=20247165=20(AG=20M=C3=BCnchen)=0D=0A=0D=
=0A=0D=0A
