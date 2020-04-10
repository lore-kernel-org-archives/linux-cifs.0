Return-Path: <SRS0=iSrF=52=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE3CC2D0EC
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Apr 2020 18:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C35C20757
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Apr 2020 18:25:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuBRYMu3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgDJSZO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Apr 2020 14:25:14 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38281 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgDJSZO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Apr 2020 14:25:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id v16so2796560ljg.5;
        Fri, 10 Apr 2020 11:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/8e9T1aA34gtipux6MRR5JeX22u4u6r+1ck6KMnDmCE=;
        b=kuBRYMu3ElDdUOqhfqRSlgM/BaOIhxXtbQtiKml+rK+iyzUZA43MpO84UTIkfHrVN9
         Dvn1KyBG5uOLPETwcDcKZnG+2R35EJiA+e4Zb/nzsqh2CmhAX76tnPzDqSMeu+A6dZ4V
         gSL/kwpLt846Hk2vlz1vx+4AEg2KUVvde7y6jMWzwR3/kWVuECqx4qB4pbD0nQ5BLy6J
         aTkFFVl7e6OlRAqzXKZjBP6gLuqP+gszOlydcDkyctpCR67a6J7vO2Y7ekvjS1s7QK3e
         zNUmogZmUf665osEUT1X6SU0WhGtPtcXMRK06NMRCAXGf639kIUGjiThmt9k4RV3LFj3
         UdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/8e9T1aA34gtipux6MRR5JeX22u4u6r+1ck6KMnDmCE=;
        b=YIAUh781wGb8DL6WJconsWsHNCm5bN7vKkRv3Q+O3KtJQXEE/4ceg5gF2lL02X/ebm
         wJKdHSkSYknoxe9OjV2IJvDoQPgxl5C2Pf7+TNooqMUmAF7ORx+RrrymMToMrrjapuyi
         USgg+tR+9Z8SEiJEysplsQ23rYung0yE6eeI8AJgz9GuiTjNlMQc6DuAu1kd3VrJWwPh
         Nyup8Rsbzk8n2sfQS9S1dg++xZiK62HCQSTW3CmqfgegVpX40gxPi9VsQ3NIQoNVi+aw
         7py09/4BHDci7iBgdcNbjGmDFQjE1dXvo6DBV+kJ6D4GjpAfof/b4otoky4lkETZWufq
         Hr8g==
X-Gm-Message-State: AGi0PuYMu8KwiRnHvFipYXlNYtYdyM0y7bzNT5SsV4qeJjiUIzDDU8zw
        DN/Tlf/TtzGlQcsd4ih1o9x4Ir2kvo+C7L18rw==
X-Google-Smtp-Source: APiQypJLhl8RsaXEReBMlt91OnPROxZF63+qBAZ8RukrkovkRVtTQ56I5ehkCEz6EsrUA0oYgsuMJr129K7uzU2Va6Q=
X-Received: by 2002:a2e:2286:: with SMTP id i128mr3641945lji.109.1586543112254;
 Fri, 10 Apr 2020 11:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAEUGjKiLPQP9wp0AgLUvHgKBOe9We2a-RQaZ7cd7CvhnarwWiw@mail.gmail.com>
In-Reply-To: <CAEUGjKiLPQP9wp0AgLUvHgKBOe9We2a-RQaZ7cd7CvhnarwWiw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 10 Apr 2020 11:25:01 -0700
Message-ID: <CAKywueT0Q9WkANNsg8cEDwGZSMaaE5c4LHuEeMhVDzJAzycroQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: improve read performance for page size 64KB &
 cache=strict & vers=2.1+
To:     Jones Syue <jonessyue@qnap.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 10 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 09:50, Jones Syue =
via samba-technical
<samba-technical@lists.samba.org>:
>
> Hello list,
>
> please help review whether the attached patch is correct, thank you.
>
> Found a read performance issue when linux kernel page size is 64KB.
> If linux kernel page size is 64KB and mount options cache=3Dstrict &
> vers=3D2.1+,
> it does not support cifs_readpages(). Instead, it is using cifs_readpage(=
)
> and
> cifs_read() with maximum read IO size 16KB, which is much slower than rea=
d
> IO
> size 1MB when negotiated SMB 2.1+. Since modern SMB server supported SMB
> 2.1+
> and Max Read Size can reach more than 64KB (for example 1MB ~ 8MB), this
> patch
> do one more check on max_read to determine whether server support
> readpages()
> and improve read performance for page size 64KB & cache=3Dstrict & vers=
=3D2.1+.
>
> The client is a linux box with linux kernel 4.2.8,
> page size 64KB (CONFIG_ARM64_64K_PAGES=3Dy),
> cpu arm 1.7GHz, and use mount.cifs as smb client.
> The server is another linux box with linux kernel 4.2.8,
> share a file '10G.img' with size 10GB,
> and use samba-4.7.12 as smb server.
>
> The client mount a share from the server with different
> cache options: cache=3Dstrict and cache=3Dnone,
> mount -tcifs //<server_ip>/Public /cache_strict
> -overs=3D3.0,cache=3Dstrict,username=3D<xxx>,password=3D<yyy>
> mount -tcifs //<server_ip>/Public /cache_none
> -overs=3D3.0,cache=3Dnone,username=3D<xxx>,password=3D<yyy>
>
> The client download a 10GbE file from the server accross 1GbE network,
> dd if=3D/cache_strict/10G.img of=3D/dev/null bs=3D1M count=3D10240
> dd if=3D/cache_none/10G.img of=3D/dev/null bs=3D1M count=3D10240
>
> Found that cache=3Dstrict (without patch) is slower read throughput and
> smaller
> read IO size than cache=3Dnone.
> cache=3Dstrict (without patch): read throughput 40MB/s, read IO size is 1=
6KB
> cache=3Dstrict (with patch): read throughput 113MB/s, read IO size is 1MB
> cache=3Dnone: read throughput 109MB/s, read IO size is 1MB
>
> Looks like if page size is 64KB,
> cifs_set_ops() would use cifs_addr_ops_smallbuf instead of cifs_addr_ops,
>
> /* check if server can support readpages */
> if (cifs_sb_master_tcon(cifs_sb)->ses->server->maxBuf <
> PAGE_SIZE + MAX_CIFS_HDR_SIZE)
> inode->i_data.a_ops =3D &cifs_addr_ops_smallbuf;
> else
> inode->i_data.a_ops =3D &cifs_addr_ops;
>
> maxBuf is came from 2 places, SMB2_negotiate() and CIFSSMBNegotiate(),
> (SMB2_MAX_BUFFER_SIZE is 64KB)
> SMB2_negotiate():
> /* set it to the maximum buffer size value we can send with 1 credit */
> server->maxBuf =3D min_t(unsigned int, le32_to_cpu(rsp->MaxTransactSize),
>       SMB2_MAX_BUFFER_SIZE);
> CIFSSMBNegotiate():
> server->maxBuf =3D le32_to_cpu(pSMBr->MaxBufferSize);
>
> Page size 64KB and cache=3Dstrict lead to read_pages() use cifs_readpage(=
)
> instead
> of cifs_readpages(), and then cifs_read() using maximum read IO size 16KB=
,
> which is much slower than maximum read IO size 1MB.
> (CIFSMaxBufSize is 16KB by default)
>
> /* FIXME: set up handlers for larger reads and/or convert to async */
> rsize =3D min_t(unsigned int, cifs_sb->rsize, CIFSMaxBufSize);
>

Hi Jones,

Thanks for the patch!

It will work although it is probably a little bit cleaner to
initialize server->max_read to server->maxBuf for SMB1 and use the
server->max_read in the readpages condition check instead.

@Others, thoughts?

--
Best regards,
Pavel Shilovsky
