Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB87C6377D
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 06:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9991F6100C
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 06:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhGVGN6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:13:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26711 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhGVGN5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jul 2021 02:13:57 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210722065431epoutp02083fa7d5b8ee4417b17c0f7343005e3d~UCncBgIVp2688226882epoutp02s
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 06:54:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210722065431epoutp02083fa7d5b8ee4417b17c0f7343005e3d~UCncBgIVp2688226882epoutp02s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626936871;
        bh=0eaevrlLAcOUtpr2me6xePaqjHCnsLalYJi4b2PsG+M=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=KpZkg3tuIu7bVujMjSFpU2p73n5RHqT/XecW9LtDf1WPVlQ5nxG/78CfB1QSOWvot
         o5c6jycDmvNPZa62qAHAbM+Qy6UN9q+h5adbizReE6XY/ACTOSeZUPxbbgCZSADw0Z
         r3l8MtS6CmAKcS/F0tO14vMDFedxzsK4AeUnNq74=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210722065431epcas1p30137a54728a488e1576205622b68a12c~UCnboDu5C1432814328epcas1p3e;
        Thu, 22 Jul 2021 06:54:31 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.162]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GVjqV1KzXz4x9Q0; Thu, 22 Jul
        2021 06:54:30 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.29.10119.62619F06; Thu, 22 Jul 2021 15:54:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210722065429epcas1p4c4985c8dade991867d0d9bccdf7cc0f0~UCnaQL3Oc1108411084epcas1p4L;
        Thu, 22 Jul 2021 06:54:29 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210722065429epsmtrp17ef9aad0653f5c3ba2a9a2f625d28809~UCnaPpCds2847728477epsmtrp1b;
        Thu, 22 Jul 2021 06:54:29 +0000 (GMT)
X-AuditID: b6c32a38-965ff70000002787-5c-60f9162694ad
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.F3.08289.52619F06; Thu, 22 Jul 2021 15:54:29 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210722065429epsmtip26bb18e319e57334db0a53f32e7383ae8~UCnaH8IeN1800618006epsmtip2f;
        Thu, 22 Jul 2021 06:54:29 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Leif Sahlberg'" <lsahlber@redhat.com>
Cc:     <linux-cifs@vger.kernel.org>
In-Reply-To: <CAGvGhF55Tq-sLUtKBn+QX6kWrL9dDzKkXFKdQ==gz3s=RkySKQ@mail.gmail.com>
Subject: RE: [PATCH] cifs: only write 64kb at a time when fallocating a
 small region of a file
Date:   Thu, 22 Jul 2021 15:54:29 +0900
Message-ID: <006601d77ec6$6b1b13c0$41513b40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHxVlcgtFcS9XEREPWB6nfEmeiRZwGYsS+AAo3wyigCil6ALarlVrMg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmvq6a2M8Eg8k9bBYv/u9itlhwVd+B
        yeP9vqtsHp83yQUwReXYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoq
        ufgE6Lpl5gBNV1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUGBoU6BUn5haX5qXr
        JefnWhkaGBiZAlUm5GS83HyBsWAtX8W84wdYGxh3c3YxcnJICJhIPN50lqmLkYtDSGAHo8T2
        k1fYIJxPjBJPLi1khHA+M0pcOfeVpYuRA6zlx+NgiPguRokjl7uhil4wStyf08MGMpdNQFfi
        35/9YLaIgLbEoZ3TWEBsZgEFiT+XLzCB2JwCgRInF3xgB7GFBRIkFlzfARZnEVCV2HoRop5X
        wFLiS/teKFtQ4uTMJ1Bz5CW2v53DDPGDgsTPp8tYQY4TEXCT6PiiAVEiIjG7s40Z5DYJgVvs
        ErO/9zBC1LtIrFzXBGULS7w6voUdwpaSeNnfBmWXS5w4+YsJwq6R2DBvHzvE88YSPS9KQExm
        AU2J9bv0ISoUJXb+nssIsZZP4t3XHlaIal6JjjYhiBJVib5Lh6EGSkt0tX9gn8CoNAvJX7OQ
        /DULyQOzEJYtYGRZxSiWWlCcm55abFhgghzVmxjB6U7LYgfj3Lcf9A4xMnEwHmKU4GBWEuFV
        KfqaIMSbklhZlVqUH19UmpNafIjRFBjSE5mlRJPzgQk3ryTe0NTI2NjYwsTM3MzUWEmc91ss
        UJNAemJJanZqakFqEUwfEwenVAMTbwVz2YIw56zc9zMjbexiOH7XXW7tYezYO7F/MpMfd2HP
        B7YDKS7OXFfXePZxnNCfNWfpYq3ln/okz4b6fGi5d0lRf9vzyIvPVQJd6xjuK+tcDZF1Xsr4
        scIi6tvxIwna3k0qM3afbC89eXf/o32cSVv5ulyCVz9SSMt5LFbm+U5bS0Yh3XuiQ8Dk/UyT
        pqT5TA3caaT1M0396P823Ql/ovaWXgx+af3rm2TK64ZpV1Iev9sWnCJ3Y9M7jl7mPNbcbfH7
        xRRT8haZXOrx7rx2jtmsfo4Om6gT16JfWyOT7vxkv9l58D7vrpnOvw8afqj22XfBuz/o985N
        PA/NBZcUFv15rXzudZjj1HmHUtYrsRRnJBpqMRcVJwIAK66b8gAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvK6q2M8Eg9Vt2hYv/u9itlhwVd+B
        yeP9vqtsHp83yQUwRXHZpKTmZJalFunbJXBlvNx8gbFgLV/FvOMHWBsYd3N2MXJwSAiYSPx4
        HNzFyMkhJLCDUaKzuwrElhCQljh24gwzRImwxOHDxV2MXEAlzxgllk9rYwWpYRPQlfj3Zz8b
        iC0ioC1xaOc0FhCbWUBB4s/lC0wQDf8YJZp3HwJr4BQIlDi54AM7iC0sECfx/+MOJhCbRUBV
        YutFiGZeAUuJL+17oWxBiZMzn0AN1ZbofdjKCGHLS2x/O4cZ4lAFiZ9Pl7GCHCoi4CbR8UUD
        okREYnZnG/MERuFZSCbNQjJpFpJJs5C0LGBkWcUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpec
        n7uJERz2Wlo7GPes+qB3iJGJg/EQowQHs5IIr0rR1wQh3pTEyqrUovz4otKc1OJDjNIcLEri
        vBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamOqb5u5zlOWozZI58iKET2qj3HcdxUlX6rinzZ/N
        85X7/munponfNq9dxHDh/lfedU78ylukjl+T2Vl58U6Pveu0J29eHf5/c/NO5le2qdyCqZFz
        ZqpW3Kw7GJXU/06qZ8e3B0pMTzbzOTop9T589Tnt+pdPzCb3RL2qmLzkvj1glhRjf/pzVdiH
        2i3nr3b9uLXbT7S3mKVAzaN7qcvOKUs33Xt5N/VAW4lFnPH539L1AeLX+Ne7yljOU2vfKSn0
        U8zte9lV1h0qf6om6Ue9W3BUpvTNDXOpTfvC780/rMjxTvd051p/kabJ7nXsXg9Vli7arf1y
        dZhC6D3G4nvSi6yeZUzrByabxdIPJsbGHFNiKc5INNRiLipOBADzVCB26gIAAA==
X-CMS-MailID: 20210722065429epcas1p4c4985c8dade991867d0d9bccdf7cc0f0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210721015429epcas1p4654c2b9348101aa7967bfe60d1d8da71
References: <CGME20210721015429epcas1p4654c2b9348101aa7967bfe60d1d8da71@epcas1p4.samsung.com>
        <014c01d77dd3$57add320$07097960$@samsung.com>
        <016b01d77e00$fe61efd0$fb25cf70$@samsung.com>
        <CAGvGhF55Tq-sLUtKBn+QX6kWrL9dDzKkXFKdQ==gz3s=RkySKQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> This code is actually bogus and does the opposite of what the comment says.
> If out_data_len is 0 then that means that the entire region is unallocated and then we should not
> bail out but proceed and allocate the hole.

> generic/071 works against a windows server for me.


> If it fails with this code removed it might mean that generic/071 never worked with cifs.ko correctly.

generic/071 create preallocated extent by calling fallocate with keep size flags.
It means the file size should not be increased.
But if (out_buf_len == 0) check is removed, 1MB write is performed using SMB2_write loop().
It means the file size becomes 1MB.

And then, generic/071 call again fallocate(0, 512K) which mean file size should be 512K.
but SMB2_set_eof() in cifs is not called due to the code below(->i_size is bigger than off + len),
So 071 test failed as file size remains 1MB.

        /*
         * Extending the file
         */
        if ((keep_size == false) && i_size_read(inode) < off + len) {
                rc = inode_newsize_ok(inode, off + len);
                if (rc)
                        goto out;

                if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
                        smb2_set_sparse(xid, tcon, cfile, inode, false);

                eof = cpu_to_le64(off + len);
                rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
                                  cfile->fid.volatile_fid, cfile->pid, &eof);
                if (rc == 0) {
                        cifsi->server_eof = off + len;
                        cifs_setsize(inode, off + len);
                        cifs_truncate_page(inode->i_mapping, inode->i_size);
                        truncate_setsize(inode, off + len);
                }
                goto out;
        }

