Return-Path: <SRS0=frs6=XI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3F8C49ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 17:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2641E20830
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 17:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ontad5so"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfIMRIs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Sep 2019 13:08:48 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37873 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbfIMRIs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Sep 2019 13:08:48 -0400
Received: by mail-lj1-f194.google.com with SMTP id c22so10157ljj.4
        for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2019 10:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+VWcpnIsNLuoM/pb2J9gTRNb5VYvPTmhDpFe2pQP1Wc=;
        b=Ontad5so3cxtnekrOgFw+KYUleXXXjDf+ot8QkPoZUcIslstl/QsgI/1qPZzeGjrbc
         YWkIRui8Jhr2ZHcQTxXi5ySa1PASrMICCM1Zu2UcGXu4yqeFWJD0tCXcPDfZz6Ygb/n9
         JN44sYMHFWkrjOrUqnlehqDwKlZuE/GZHjM2nMZQzufTLBBJDHAxDyxdVmeauXe0o3h0
         yNshiYqDVgBtr42wldYSc2Owi+Oxk1rJeukG3JRQvy/83D90AiK3eDr3ZetVb0aEpK7G
         H05O85YZuNP2NP8rTxqWaPPYfd/dM2+i1F/zRnN88sn68XPM6SCof37NDwI7TLYg44Vf
         0RMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+VWcpnIsNLuoM/pb2J9gTRNb5VYvPTmhDpFe2pQP1Wc=;
        b=CtgcQOaHIqd2+XPYQUqCAUprV3q7j5QNC0n3xGfguC3ZHfdkVNyJLi2z92+dbroh/N
         49h+eOrMWUS+floFPtuRSFg8ROnzqgPrI74kbKt+HrHzQbC4tLPIRPCmmYKA5x07QxEL
         EwyLcO+u97VYrF5QEPcAyfHGroOjTPSd42u3OKIH7Oe0PzKGJGuKwaZC+lzFOZI+x1SN
         Udn0lD22HRiTMoRD35KLG3lrfShGfWacZW81pKz2Lxi5yK6YOS/n34RBJMujKLd8EyDf
         3C9d08tLusJCW997uCjfyr9FK0y3T+samrUJQaf9Td+dirBeszlHae/QTWSynHq89bjF
         FUHg==
X-Gm-Message-State: APjAAAU9htMmPRBKxnMIGsSJH9WK18LLiUu4eRoIdrEvrH+HwFAj2vXh
        YzREadmbXXAlyc4DIlesHjTNvlhyacR59ywtig==
X-Google-Smtp-Source: APXvYqw07Gj5/VjFdsarA2YFCEydXl7rLRmobk1bnzh8/Q5fSgmYKp6+z5ooAnKPwUA7vpAv6IAnZBtvYKkOyP7vwjk=
X-Received: by 2002:a2e:9555:: with SMTP id t21mr14170756ljh.93.1568394525389;
 Fri, 13 Sep 2019 10:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190913134634.GR20699@kadam>
In-Reply-To: <20190913134634.GR20699@kadam>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 13 Sep 2019 10:08:34 -0700
Message-ID: <CAKywueTGT9=G-uYAdK8VY4P2a4TC8PsOKfz78n8tc0rngMWc7Q@mail.gmail.com>
Subject: Re: [cifs:for-next 24/31] fs/cifs/smb2ops.c:4056 smb2_decrypt_offload()
 error: we previously assumed 'mid' could be null (see line 4045)
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@01.org, Steve French <stfrench@microsoft.com>,
        kbuild-all@01.org, linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes, this is a bug.

Steve, let's move

+       mid->callback(mid);
+
+       cifs_mid_q_entry_release(mid);

under ELSE {} block above.

We should probably move

+       dw->server->lstrp =3D jiffies;

before we looking for a mid.

--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 13 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 06:47, Dan C=
arpenter <dan.carpenter@oracle.com>:
>
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   5fc321fb644fc787710353be11129edadd313f3a
> commit: a091c5f67c994d154e8faf95ab774644be2f4dd7 [24/31] smb3: allow para=
llelizing decryption of reads
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> New smatch warnings:
> fs/cifs/smb2ops.c:4056 smb2_decrypt_offload() error: we previously assume=
d 'mid' could be null (see line 4045)
>
> git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
> git remote update cifs
> git checkout a091c5f67c994d154e8faf95ab774644be2f4dd7
> vim +/mid +4056 fs/cifs/smb2ops.c
>
> a091c5f67c994d Steve French 2019-09-07  4030  static void smb2_decrypt_of=
fload(struct work_struct *work)
> a091c5f67c994d Steve French 2019-09-07  4031  {
> a091c5f67c994d Steve French 2019-09-07  4032    struct smb2_decrypt_work =
*dw =3D container_of(work,
> a091c5f67c994d Steve French 2019-09-07  4033                            s=
truct smb2_decrypt_work, decrypt);
> a091c5f67c994d Steve French 2019-09-07  4034    int i, rc;
> a091c5f67c994d Steve French 2019-09-07  4035    struct mid_q_entry *mid;
> a091c5f67c994d Steve French 2019-09-07  4036
> a091c5f67c994d Steve French 2019-09-07  4037    rc =3D decrypt_raw_data(d=
w->server, dw->buf, dw->server->vals->read_rsp_size,
> a091c5f67c994d Steve French 2019-09-07  4038                          dw-=
>ppages, dw->npages, dw->len);
> a091c5f67c994d Steve French 2019-09-07  4039    if (rc) {
> a091c5f67c994d Steve French 2019-09-07  4040            cifs_dbg(VFS, "er=
ror decrypting rc=3D%d\n", rc);
> a091c5f67c994d Steve French 2019-09-07  4041            goto free_pages;
> a091c5f67c994d Steve French 2019-09-07  4042    }
> a091c5f67c994d Steve French 2019-09-07  4043
> a091c5f67c994d Steve French 2019-09-07  4044    mid =3D smb2_find_mid(dw-=
>server, dw->buf);
> a091c5f67c994d Steve French 2019-09-07 @4045    if (mid =3D=3D NULL)
> a091c5f67c994d Steve French 2019-09-07  4046            cifs_dbg(FYI, "mi=
d not found\n");
>
> Return here?
>
> a091c5f67c994d Steve French 2019-09-07  4047    else {
> a091c5f67c994d Steve French 2019-09-07  4048            mid->decrypted =
=3D true;
> a091c5f67c994d Steve French 2019-09-07  4049            rc =3D handle_rea=
d_data(dw->server, mid, dw->buf,
> a091c5f67c994d Steve French 2019-09-07  4050                             =
     dw->server->vals->read_rsp_size,
> a091c5f67c994d Steve French 2019-09-07  4051                             =
     dw->ppages, dw->npages, dw->len);
> a091c5f67c994d Steve French 2019-09-07  4052    }
> a091c5f67c994d Steve French 2019-09-07  4053
> a091c5f67c994d Steve French 2019-09-07  4054    dw->server->lstrp =3D jif=
fies;
> a091c5f67c994d Steve French 2019-09-07  4055
> a091c5f67c994d Steve French 2019-09-07 @4056    mid->callback(mid);
>                                                 ^^^^^^^^^^^^^
> Potential NULL derference.
>
> a091c5f67c994d Steve French 2019-09-07  4057
> a091c5f67c994d Steve French 2019-09-07  4058    cifs_mid_q_entry_release(=
mid);
> a091c5f67c994d Steve French 2019-09-07  4059
> a091c5f67c994d Steve French 2019-09-07  4060  free_pages:
> a091c5f67c994d Steve French 2019-09-07  4061    for (i =3D dw->npages-1; =
i >=3D 0; i--)
> a091c5f67c994d Steve French 2019-09-07  4062            put_page(dw->ppag=
es[i]);
> a091c5f67c994d Steve French 2019-09-07  4063
> a091c5f67c994d Steve French 2019-09-07  4064    kfree(dw->ppages);
> a091c5f67c994d Steve French 2019-09-07  4065    cifs_small_buf_release(dw=
->buf);
> a091c5f67c994d Steve French 2019-09-07  4066  }
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Ce=
nter
> https://lists.01.org/pipermail/kbuild-all                   Intel Corpora=
tion
