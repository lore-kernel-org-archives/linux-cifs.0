Return-Path: <SRS0=jcY3=YX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA519CA9EC7
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Oct 2019 21:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD22F20874
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Oct 2019 21:51:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPGbPi+e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfJ3Vv3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Oct 2019 17:51:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34889 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfJ3Vv2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Oct 2019 17:51:28 -0400
Received: by mail-lj1-f193.google.com with SMTP id m7so4392713lji.2
        for <linux-cifs@vger.kernel.org>; Wed, 30 Oct 2019 14:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hzQ7ZCxCw2voSz0nFzH8qFrFRT7ebImy8OY0L6WN67Y=;
        b=YPGbPi+eJbjUl/tJPbiBJAGdyLxsCyt0mzJJS0VnTXTEFNi2M3ryJ0kh5vjJFDzEOr
         bb1m4gTLHiMXkAiZsfgyzsNKKtD46Wu4HLAX2EZu8ySDIgqMQo3czW69srWvqIrHK3CA
         0mmHW/FI3qBIJYojqDJrUSpq8lm5ArcOaAd/rzDd4jHIAnNQV+dAZI1H82RH4vsdh5Ze
         TpRqnLjdleFf18E89xvm4srSj+O81RrmENiNr1N2WxPWKN8Y7dnCj4tHoGTJ9VF5+K/4
         7RfTKx4bqMW699TM0nTtR9OUE1MWWfguSASlynrMv+Cj8rPtVTojs8bwozW8pBsFUMRP
         h1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hzQ7ZCxCw2voSz0nFzH8qFrFRT7ebImy8OY0L6WN67Y=;
        b=BLC0JL6GAru/trT/8g7iMXUx2Z+np3CJSvLhWqjVaqpqZr90PgrKWqChWsCvP2ymE7
         C6Qh+TwVClNwz7YkJ1V9nA9No3eBhpDjVbFr1GsPctdRi3Ed2dLQD4RNdlq2FpFYJPHQ
         qR28kwPB108g5Z1V1Jt8ne7Gt/+z3A9yf5vaR3QUwjjPVsR7XBcbiQwtf235+/s7AZ3Z
         7ZXzdRp/al0TVblDf5qOXZHjpfAbzUVYVlES1tdtG4it2Doj/Ziwc2isvJnoFtbgOyau
         tBntwPgLaBE/VkuvobxB1opdC618Rp+GvRJV7F8CgZUTNdEqBH3fge94anNmu+oNcP01
         LLsQ==
X-Gm-Message-State: APjAAAWEDK19OVH1pgGS4EU0w+1BXu0qHMV0JgbRdi61BSASBn6+lm+f
        ebyQeKgZchqL01GybPHp8/FoQim7C3t0yYzSn5BIh1s=
X-Google-Smtp-Source: APXvYqxyZbdlR6BWdD/VHlO4XNuVw4yuuxJ4gDAfjdcxoTv2/MV6FiBjdcvXOfR48eVqwpjz4ZXFL1J9c0jOPB5Uu3E=
X-Received: by 2002:a2e:91c9:: with SMTP id u9mr1319494ljg.227.1572472286675;
 Wed, 30 Oct 2019 14:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
 <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee> <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
 <CAKywueTOjoP-Jh7WWCi5XJhfzgK+KZs3kvHKuVG_HW0fnYYY7A@mail.gmail.com>
 <CAKywueQUuwRK7hbbJhdquVVPre2+8GBCvnrG76L-KodoMm9m6g@mail.gmail.com>
 <b7b7a790feac88d59fe00c9ca2f5960d@moritzmueller.ee> <CAKywueQ7g9VYe=d7WU4AzL2Hv+pPznUgQBD7-RVi0ygBkhtGRw@mail.gmail.com>
 <bdf21b8770373c9ea4c37c27a12344d8@moritzmueller.ee> <CAKywueQ8woeupNRqspAuOqL8rG1hNpWN_hwLCjFUpkk4mXeCvQ@mail.gmail.com>
 <6492326ef9d8d1a9401fac243160646f@moritzmueller.ee>
In-Reply-To: <6492326ef9d8d1a9401fac243160646f@moritzmueller.ee>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 30 Oct 2019 14:51:15 -0700
Message-ID: <CAKywueSWxDA5veCWjf+vGM96TSKrJbiddt93dv=arXyizJCbmw@mail.gmail.com>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
To:     Moritz M <mailinglist@moritzmueller.ee>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Moritz,

I think there is a difference in your setup between v5.2.21 and v5.3.7
kernels. I found the issue in oplock break processing that can happen
if you have several shares from the same server mounted on the client.
We put such shares in the list and any new share is being attached to
the beginning of the list. There is a bug in the code that causes the
client to process only the 1st share in the list skipping all the
others. I could repro it by mounting two shares in the order (test and
test2) and then doing two subsequent opens like in your original
repro. I doesn't repro if only one share is mounted for the reasons
mentioned before.

Could you test the patch to see if it works for your environment?

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 8db6201b18ba..527c9efd3de0 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -664,10 +664,10 @@ smb2_is_valid_oplock_break(char *buffer, struct
TCP_Server_Info *server)
        spin_lock(&cifs_tcp_ses_lock);
        list_for_each(tmp, &server->smb_ses_list) {
                ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
+
                list_for_each(tmp1, &ses->tcon_list) {
                        tcon =3D list_entry(tmp1, struct cifs_tcon, tcon_li=
st);

-                       cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_b=
rks);
                        spin_lock(&tcon->open_file_lock);
                        list_for_each(tmp2, &tcon->openFileList) {
                                cfile =3D list_entry(tmp2, struct cifsFileI=
nfo,
@@ -679,6 +679,8 @@ smb2_is_valid_oplock_break(char *buffer, struct
TCP_Server_Info *server)
                                        continue;

                                cifs_dbg(FYI, "file id match, oplock break\=
n");
+                               cifs_stats_inc(
+                                   &tcon->stats.cifs_stats.num_oplock_brks=
);
                                cinode =3D CIFS_I(d_inode(cfile->dentry));
                                spin_lock(&cfile->file_info_lock);
                                if (!CIFS_CACHE_WRITE(cinode) &&
@@ -702,9 +704,6 @@ smb2_is_valid_oplock_break(char *buffer, struct
TCP_Server_Info *server)
                                return true;
                        }
                        spin_unlock(&tcon->open_file_lock);
-                       spin_unlock(&cifs_tcp_ses_lock);
-                       cifs_dbg(FYI, "No matching file for oplock break\n"=
);
-                       return true;
                }
        }
        spin_unlock(&cifs_tcp_ses_lock);


--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 30 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 06:26, Moritz M <m=
ailinglist@moritzmueller.ee>:
>
> Pavel,
>
> meanwhile I updated to the supported kernels. The strange thing is, in
> the kernel 5.2.21 in my distro (Manjaro) it works.
>
> While it is not working with 5.3.7.
>
> I checked the kernel sources of my distro and the patch is included
> there.
>
> I've attached a pcap and the dmesg output when using my small demo tool.
>
> Can you check if it is the same issue as before or something different?
>
>
>
> $ uname -r
> 5.3.7-2-MANJARO
>
> $ mount.cifs -V
> mount.cifs version: 6.8
>
> $ samba --version
> Version 4.10.8
>
> Thanks
> Moritz
