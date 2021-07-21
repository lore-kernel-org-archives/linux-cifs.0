Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F311CC07E9B
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 07:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB15610D2
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 07:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhGUGou (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jul 2021 02:44:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26016 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbhGUGku (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jul 2021 02:40:50 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210721072118epoutp0307f9caecc42a0c8e32c5220690035943~TvViiCFwu2821828218epoutp03o
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jul 2021 07:21:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210721072118epoutp0307f9caecc42a0c8e32c5220690035943~TvViiCFwu2821828218epoutp03o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626852078;
        bh=e0JM3mDQgtuQMC///fy7/9ta6W2SlNddLcieBuu7dto=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=L0wxJnVmVhKp8FIqSJdJE/aWSDpVu0ZD5/Kj1YrJIaA/MeDz5c/ranuqDwSq1Xyuv
         RbwWkSb53DjichJ3HDwAm6EfV0rzq+vVTL8gcvIZ7DDjuwJ8507l9qpC07DJRHd8Wr
         zIz82YIhXSzpQ8F1ghrCBIgI3ThHSQxUTYJe9RLU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210721072118epcas1p4327bc5b23dbe7b17fe50e80538f9b588~TvViWRv1S1733517335epcas1p4H;
        Wed, 21 Jul 2021 07:21:18 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.159]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GV6Ss3Ht0z4x9Pv; Wed, 21 Jul
        2021 07:21:17 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.B3.09952.CEAC7F06; Wed, 21 Jul 2021 16:21:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210721072116epcas1p4aab6985941bf817145ebf2a9e8ce3fc6~TvVgSpiWH1779617796epcas1p4K;
        Wed, 21 Jul 2021 07:21:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210721072116epsmtrp2368fa922ecb350844fecb9236e5053e5~TvVgSBl-d3210732107epsmtrp2Z;
        Wed, 21 Jul 2021 07:21:16 +0000 (GMT)
X-AuditID: b6c32a35-447ff700000026e0-79-60f7caeca32f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A4.3F.08394.CEAC7F06; Wed, 21 Jul 2021 16:21:16 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210721072116epsmtip27ff8546d193a867b51c8bfa63b36f185~TvVgFZvlI2828228282epsmtip2v;
        Wed, 21 Jul 2021 07:21:16 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Ronnie Sahlberg'" <lsahlber@redhat.com>
Cc:     <linux-cifs@vger.kernel.org>
In-Reply-To: <014c01d77dd3$57add320$07097960$@samsung.com>
Subject: RE: [PATCH] cifs: only write 64kb at a time when fallocating a
 small region of a file
Date:   Wed, 21 Jul 2021 16:21:16 +0900
Message-ID: <016b01d77e00$fe61efd0$fb25cf70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQHxVlcgtFcS9XEREPWB6nfEmeiRZwGYsS+Aqww0hdA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsWy7bCmvu6bU98TDP7etLF48X8Xs8WCq/oO
        TB7v911l8/i8SS6AKSrHJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwdoupJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCgQK84Mbe4NC9d
        Lzk/18rQwMDIFKgyISfj3KWnrAWLZCoO7X7F3sD4WLiLkZNDQsBE4m9/N1sXIxeHkMAORomP
        F14zQjifGCU6Fk1jh3C+MUpMuLWEFaalu+ULVNVeRomnN69CVb1glLh0YyI7SBWbgK7Evz/7
        gQZzcIgA2du/V4GEmQUUJP5cvsAEYnMKWEls+jGNEcQWFkiQWHB9B1icRUBV4u37/2A2r4Cl
        RHfjRRYIW1Di5MwnLBBztCWWLXzNDHGQgsTPp8tYIeIiErM728DiIkDzP/XsZAG5TULgErvE
        gstroT5wkfhyeRpUs7DEq+Nb2CFsKYnP7/ayQdjlEidO/mKCsGskNszbxw7yi4SAsUTPixIQ
        k1lAU2L9Ln2ICkWJnb/nMkKcwCfx7msPK0Q1r0RHmxBEiapE36XDUAOlJbraP7BPYFSaheSx
        WUgem4XkmVkIyxYwsqxiFEstKM5NTy02LDBEjutNjOCEp2W6g3Hi2w96hxiZOBgPMUpwMCuJ
        8KoUfU0Q4k1JrKxKLcqPLyrNSS0+xGgKDOqJzFKiyfnAlJtXEm9oamRsbGxhYmZuZmqsJM77
        LRaoSSA9sSQ1OzW1ILUIpo+Jg1OqgekQV/iEJd+Oxkq3rWj0mCOzqvekgMR3XddjTx6aG678
        v7X/ocKVf3eiVHNEXnydU7WmKe6sqUfPskjFHunP6z7PvR5/88LmO6Iux65s5AlJ7Fr7puvo
        0g32m98vj7WfNHuWbbelPvuuq3WO72z4Fkm/88zKfnh08Tld8xfWuldi4iuOR4aGzm+72/nl
        O7MC89Eu/boHtV7Tn046LHBLdkJ6ppq+g3XY7qVnpc4dddGcGz3bJIXTT2DZ16vHb728yfxH
        vnnfukVVd+2231ppL234MvpEcI2i42qz2Pr3CoemvMsoy7vF/3zVohO+Yg1rU3U+9An1S4aF
        6TJs9T2+Qm2ix4dD4Ty3ZZYJf/8nzWarxFKckWioxVxUnAgAmqkXDwEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvO6bU98TDL4v57N48X8Xs8WCq/oO
        TB7v911l8/i8SS6AKYrLJiU1J7MstUjfLoErY93mTsaCK9IVzS/sGxgnCncxcnJICJhIdLd8
        YQSxhQR2M0rsOqsFEZeWOHbiDHMXIweQLSxx+HBxFyMXUMkzRol3e5axg9SwCehK/Puznw2k
        RgTI3v69CiTMLKAg8efyBSaI+m5GiZ+zDrGCJDgFrCQ2/ZgGtktYIE7i/8cdTCA2i4CqxNv3
        /8FsXgFLie7GiywQtqDEyZlPWCCGaks8vfkUzl628DUzxJ0KEj+fLmOFiItIzO5sA4uLAO36
        1LOTZQKj8Cwko2YhGTULyahZSNoXMLKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQI
        DnstzR2M21d90DvEyMTBeIhRgoNZSYRXpehrghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n
        44UE0hNLUrNTUwtSi2CyTBycUg1MPp82rV6redBn2aaJJzLrSyOWv2vZ6dQ73+W/2JF/Bf2F
        nOw10bZsAqVHhVLCPBmD1zr7nIzTcr2TJD3/c4lewd5I3VavTP+7xU65BUtn7ZV/tddvg6et
        3JpIrebwhdPPbXCZePnIcwO1Gec9Vkw7dPGw9/GrGlZeXi/qb1Reyr979tTmzRWKm266X47T
        yFJhvD/79YMpj0xzJ3jsPLlCjV/jdt6SVdOTa9k5niyxqar0DCy89uMA8+/nfqFvU4ViXpju
        mHiFVczvhrjAZNZrF6r51nx0/cLF8cH6YO5Oxe1TOTrSjr61ZW+eqHv+WDV3Mmfj7vN6Z2w6
        ddvyPi9a0LZX6ovjxnVr67qLxa5uVmIpzkg01GIuKk4EANDcIQrqAgAA
X-CMS-MailID: 20210721072116epcas1p4aab6985941bf817145ebf2a9e8ce3fc6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210721015429epcas1p4654c2b9348101aa7967bfe60d1d8da71
References: <CGME20210721015429epcas1p4654c2b9348101aa7967bfe60d1d8da71@epcas1p4.samsung.com>
        <014c01d77dd3$57add320$07097960$@samsung.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

> We only allow sending single credit writes through the SMB2_write() synch=
ronous api so split this into
> smaller chunks.
>=20
> Fixes: 966a3cb7c7db (=22cifs: improve fallocate emulation=22)
>=20
> Signed-off-by: Ronnie Sahlberg <lsahlber=40redhat.com>
> ---
>  fs/cifs/smb2ops.c =7C 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c index ba3c58e1f725..7f=
efa100887b 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> =40=40 -3617,7 +3617,7 =40=40 static int smb3_simple_fallocate_write_rang=
e(unsigned int xid,
>                                              char *buf)  =7B
>         struct cifs_io_parms io_parms =3D =7B0=7D;
> -       int nbytes;
> +       int rc, nbytes;
>         struct kvec iov=5B2=5D;
>=20
>         io_parms.netfid =3D cfile->fid.netfid; =40=40 -3625,13 +3625,25 =
=40=40 static int
> smb3_simple_fallocate_write_range(unsigned int xid,
>         io_parms.tcon =3D tcon;
>         io_parms.persistent_fid =3D cfile->fid.persistent_fid;
>         io_parms.volatile_fid =3D cfile->fid.volatile_fid;
> -       io_parms.offset =3D off;
> -       io_parms.length =3D len;
>=20
> -       /* iov=5B0=5D is reserved for smb header */
> -       iov=5B1=5D.iov_base =3D buf;
> -       iov=5B1=5D.iov_len =3D io_parms.length;
> -       return SMB2_write(xid, &io_parms, &nbytes, iov, 1);
> +       while (len) =7B
> +               io_parms.offset =3D off;
> +               io_parms.length =3D len;
> +               if (io_parms.length > 65536)
> +                       io_parms.length =3D 65536;
Minor nit, We can probably use a defined macro, SMB2_MAX_BUFFER_SIZE.

> +               /* iov=5B0=5D is reserved for smb header */
> +               iov=5B1=5D.iov_base =3D buf;
> +               iov=5B1=5D.iov_len =3D io_parms.length;
> +               rc =3D SMB2_write(xid, &io_parms, &nbytes, iov, 1);
> +               if (rc)
> +                       break;
> +               if (nbytes > len)
> +                       return -EINVAL;
> +               buf +=3D nbytes;
> +               off +=3D nbytes;
> +               len -=3D nbytes;
> +       =7D
> +       return rc;
>  =7D
>=20
>  static int smb3_simple_fallocate_range(unsigned int xid, =40=40 -3655,11=
 +3667,6 =40=40 static int
> smb3_simple_fallocate_range(unsigned int xid,
>                         (char **)&out_data, &out_data_len);
>         if (rc)
>                 goto out;
> -       /*
> -        * It is already all allocated
> -        */
> -       if (out_data_len =3D=3D 0)
> -               goto out;
Is there any reason to remove this code ?
Because xfstests generic/071 test failed against ksmbd without this code.

generic/071 files ... - output mismatch (see /home/linkinjeon/xfstests-ksmb=
d/results//generic/071.out.bad)
    --- tests/generic/071.out   2020-02-05 09:07:30.000000000 +0900
    +++ /home/linkinjeon/xfstests/xfstests-ksmbd/results//generic/071.out.b=
ad 2021-07-21 15:32:18.001170684 +0900
    =40=40 -6,4 +6,4 =40=40
     *
     1000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     *
    -2000000
    +4000000
    ...
    (Run 'diff -u /home/linkinjeon/xfstests-ksmbd/tests/generic/071.out /ho=
me/linkinjeon/xfstests-ksmbd/results//generic/071.out.bad'  to see the enti=
re diff)
Ran: generic/071
Failures: generic/071
Failed 1 of 1 tests

Thanks=21
>=20
>         buf =3D kzalloc(1024 * 1024, GFP_KERNEL);
>         if (buf =3D=3D NULL) =7B
> --
> 2.30.2


