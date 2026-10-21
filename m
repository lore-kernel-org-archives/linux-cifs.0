Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792555009;
	b=xyH/HAKIyGRik9hxj7LFE5AG9kz22olERQmJdLXu1k7iSyf6MdPwHzlBadfiEHCWrzHE
	 qnvgzgjfo93cVpvrtXGs+Ubq2GHWGXSCX5d2UXxf0BrCEyncAe0DkF3uU6l8JHaVADLAA
	 uHfZTCTURfueQofcCDeVZwZG2M96yQlyaDxCcjZm1l8G28dIrFLORfI++/K1EJMYpMpEg
	 LrsJ1feJCKntTclU2vLvFi4haPuCKoETgjWbeVlinyt8Gd9FS804PPDneDTHOKNdkvPgU
	 r9Oo1VH4DRuKPheaOZcr0QRp5KnMC7YgR52LsgW6B9sym98c/FzcOo06eF3ZSwBocvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792555009;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=TsxIu5w5FY3ABJNnJou2C+ZIq2e5DebUIuAtyHX8ZHY=;
	b=OH46yUd+J7WS4lgHumd0RpZYfSCJoRy9NioCClaFmZq6C7ChqfF6tzNqsbbMS8KANk48
	 6455I+hiVEmKdQxK+SauyqIPpNMa8MQAf58yyuQTLtbMYuHOYrJmJCtwRtg7jQ65TK2tt
	 V1unN5AzhPcNjF/1FCPU2IOmt7zobwYnpbxd6CnXRZlbSO/RSO79X9TM9MYJZzsqx71/O
	 YoWDZ4yssNhdS7AeJ6WdD0/oKhhcboSOg+mtPpUuSgjOB4TkC11v8YrLHsUrUfC+KEZ44
	 43qTQO1obZVtytmVJRuU7rFjMGOsyUKoY16+YsWg2r66vWead0rv47penMDl4CHDulA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aL+Eihkq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.53
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE81606A31B
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 03:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FE81606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aL+Eihkq
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-917a707f37eso3493256d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 20:56:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792555008; cv=none;
        d=google.com; s=arc-20260327;
        b=eb8q7QnYDQp3L8Yq15HW/VJeZWqYWf4uVXGWxJ+5Y8rh/ihH4aYUTTe0uAX3lhPVsx
         tg6W0o0LTrEG4S3PVg3ldC3P9f/izJ9oXpAtsl/oDWfgR+I7gJ9Xg844auZR8eEUkVQ5
         lGdSwcp/b7Q60OewimV40bKEfhD95mXCtZUvXw05bp5N11hc+0KaPIfRr0XMFlwM1hlw
         LD+QA1isZgZsDrAEjyt6Zl3y5Q2lp1AG0JASP5H+EBPg3UR5PZXMD5J4lDTrb6smx+1l
         /mjoEpvo/bvQMW9szzz6ruAHxEy0036guoQYGpMg1CaqYaH1X/vCi58kRL48354Yx1nV
         tMyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TsxIu5w5FY3ABJNnJou2C+ZIq2e5DebUIuAtyHX8ZHY=;
        fh=11r49koYV8DhM6rZ3v3mn7Bjw2p8F6qkDo7yNYU5Ry4=;
        b=n3PELB7K97STVxST5oucPOqK6yNJSFYczqlogbktDkAZS8krgpQkz43nV/u5dmzwVI
         ipRXZuDDxM7Al9UCglojAhcGkKK/to1n1QAxMlAiy9C28NmaPyESOCLKLggLgW3i3G3k
         lHs++lb4VzJm+PVVMqk9m+9a3/bjtKUQ0P+LAUl+0LlukjtY7QkNi3HZ5qK/puxS4tu2
         iP3jxsTwjNjat8fhD9U5teclCmZ79ZTPLGPhpkQVJtXjp2QGR/r1nWUU1d5JruD8BYBi
         eR4UgiMe2TnGWlP3zf2GMYhX60Ar99f6QeEq/K8FtVb5/AyyvYesaHZCdkd0GB1bBCjh
         0PIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792555008; x=1793159808; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TsxIu5w5FY3ABJNnJou2C+ZIq2e5DebUIuAtyHX8ZHY=;
        b=aL+Eihkql5I2435do2UXmzZTjw8S+G0swn+RgK8kqDk4s/RGVdvrLOKwlYQjHWCTKK
         MsRNMDi1OItJ+BfgUKb3N3JitUpNb/cxGLxqNjV/ujmsI2V/T5akTWrXpBaBvzsoaxWl
         99WitaldvKWquvxj764wQpiTGzjEonBQgAomKgzssD7aCdqgq15zscQUoxQL7OPvK6cY
         NQO7eUGA0y4UW6YWNifG2olaIlFHW/ylik680h7hZr2b/z7oQmFaOv7FhOxNGA3lT7w7
         DLkN4USI4sjMYQYAOF5vEhP8CnE8VKRwzOEx2slax2gos05BXgN7g0wFbEeADwJhOZWl
         9kuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792555008; x=1793159808;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TsxIu5w5FY3ABJNnJou2C+ZIq2e5DebUIuAtyHX8ZHY=;
        b=rWBgEi/i5+kLwf9dElFR5no3vNpRrT8h5HIgOAJWoNOKavsT1ADZE3SQIPbtRSsnBC
         Y4iaf1igURCTorsy28Hq8wTIBLIIynd0SgnJw+6ivYbUlVBtDI0GKXXxynJmmQfzsQ7Y
         CK+3uiyqR0jGf6XOVCZWEH/RTU8iBa0PkKs8cC/3JciqFa6rskgffuiNp21xmhtYxjgA
         /hOYBj4Pb0r+u6tXoEQhzjPsWNRZdsEn08MnjyXEXR377nSlpWzNwCCUG7IX4BxCrRze
         jbafC4760hlw01Qkr0DZ2dBS75A6Ac10KxTDCdNr/XLcZUMiEU8i5fmynrRLxFvzH9fw
         g1rQ==
X-Forwarded-Encrypted: i=1; AKwUvByLVnVOR6MIIKc1LibAlCHWLP1+X9HmI35ZgwZ9VYten5apanIGZZhxgr3GBkui1ZWI2epsm0pWyDI9@vger.kernel.org
X-Gm-Message-State: AFq9FYIizcry3o/MrUOwRc6Ei3cuL/7Cv0DFFZJZGH4ZK34kUyBZG06n
	g+Ck18cW5QjJO6ywvTH0NnZQ4yBCK4whYuZkrPQ8v7cgbVTXF46MX8szttFbrUYn6HcyQ5FD7lv
	x2UPBs8rkQbeVJWU5x8mR786A4YEQICO8+KkoG7uCyA==
X-Gm-Gg: AYBFou2BTzUS4ZhPlz1C4bVc8Tlycr/vrsXQqZZ9uDHGoFO51Z8JmuODoHl44N1v5mY
	J13vkSfsV4tsHmL4nEH7RTcRfG9Uaw1tOx+m4Kkv+eipjW64dmojjZ9SHAVd51ATPbS6PFwnUG5
	t0heTCvMfy4iQjnHRq6g2HN82tWMoYLcDIWiACfDnvjNJ3btYmfyD9Y8MDMJ+Al/2eEq3gsfyOc
	XePK/2xYPxicbTSS0YsQde6MZedL8pg+xVPiB1M+jgA/H6Fbz0NjGFsdgHs1ANgTn5cukrt4klO
	uJrwZVN800EopCEJpDhtc9kfquxFew623L2jKYGJP4XUSXF7IXBkyp7Lh8IlFw6qADN60YhmkL2
	6+iUzxh2G0VgJGYuyR2l8v5mW684DZbEIktfiUuczRlrsfRfKdtgyHOBVn9ylaQtL/hxj
X-Received: by 2002:a05:6214:2b94:b0:914:4511:9271 with SMTP id
 6a1803df08f44-91c12f031bdmr16014616d6.22.1792555008068; Tue, 20 Oct 2026
 20:56:48 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020175254.900284-2-bestswngs@gmail.com> <CAKYAXd9nwp=X8AfzqTs9231i6SVoX7wuBqVvUfgBP2a8xrt+ow@mail.gmail.com>
In-Reply-To: <CAKYAXd9nwp=X8AfzqTs9231i6SVoX7wuBqVvUfgBP2a8xrt+ow@mail.gmail.com>
From: Weiming Shi <bestswngs@gmail.com>
Date: Wed, 21 Oct 2026 11:56:09 +0800
X-Gm-Features: AclHuK9edLT7Ue1NZq0Si5aKsqQpW65ATZGLO5S5vLoxrR-P6z-TcbrWHv5GkKc
Message-ID: <CANgPUi1Tn8vvQTWNCXUB9qPmy-LqXk_G8YiwS4DMU2kei3eHaA@mail.gmail.com>
Subject: Re: [PATCH] smb/server: prevent file publication after tree disconnect
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Xiang Mei <xmei5@asu.edu>, stable@vger.kernel.org, 
	co+d531129f2f9fbf88@bugs.sh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Namjae Jeon <linkinjeon@kernel.org> =E4=BA=8E2026=E5=B9=B410=E6=9C=8821=E6=
=97=A5=E5=91=A8=E4=B8=89 10:06=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Oct 21, 2026 at 2:53=E2=80=AFAM Weiming Shi <bestswngs@gmail.com>=
 wrote:
> >
> > TREE_DISCONNECT closes the tree's published file handles before marking=
 and
> > removing the tree connection. A concurrent CREATE that already holds a =
tree
> > reference can therefore publish its file after the close pass. When CRE=
ATE
> > drops its reference, the tree can be freed while the published file sti=
ll
> > points to it.
> >
> > Mark and remove the tree connection before closing its files, and seria=
lize
> > both new-open and durable-reconnect volatile ID publication with that s=
tate
> > transition. An opener is then either published in time for the close pa=
ss
> > or rejected after disconnect with STATUS_NETWORK_NAME_DELETED.
> >
> > Keep a tree reference while a file carries its tree pointer. This prote=
cts
> > asynchronous users that can defer the file's final destruction past tre=
e
> > disconnect.
> >
> > The close pass can race the successful FP_NEW to FP_INITED transition.
> > Take the opening request's file reference atomically with that transiti=
on.
> > This keeps the file alive until request completion even if teardown rem=
oves
> > the ID immediately.
> >
> >   BUG: KASAN: slab-use-after-free in proc_show_files (fs/smb/server/vfs=
_cache.c:126)
> >   Read of size 4 at addr ff11000101540f80 by task poc/153
> >
> >   Call Trace:
> >     proc_show_files (fs/smb/server/vfs_cache.c:126)
> >     seq_read_iter (fs/seq_file.c:231)
> >     proc_reg_read_iter (fs/proc/inode.c:299)
> >     vfs_read (fs/read_write.c:574)
> >     ksys_read (fs/read_write.c:716)
> >     do_syscall_64 (arch/x86/entry/syscall_64.c:84)
> >     entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
> >
> >   Allocated by:
> >     ksmbd_tree_conn_connect (fs/smb/server/mgmt/tree_connect.c:35)
> >     smb2_tree_connect (fs/smb/server/smb2pdu.c:2819)
> >     handle_ksmbd_work (fs/smb/server/server.c:368)
> >
> >   Freed by:
> >     kfree (mm/slub.c:6801)
> >     handle_ksmbd_work (fs/smb/server/server.c:332)
> >
> > Fixes: f44158485826 ("cifsd: add file operations")
> > Cc: stable@vger.kernel.org
> > Reported-by: <co+d531129f2f9fbf88@bugs.sh>
> > Assisted-by: LLM
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> This patch does not apply cleanly to the ksmbd-for-next branch. Could
> you please rebase it onto that branch and resend it?
> Thanks!

Thanks for the heads-up. I'll rebase the patch onto the latest
ksmbd-for-next branch and resend it shortly.

Best regards,
Weiming Shi
