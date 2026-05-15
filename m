Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98083CBE70
	for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 03:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778814669; cv=pass; b=DrrbWLjXBdVn7gAu5fG4UtX2AFnd4rWdmkqLhJKC6fP5gni8gounro6jOgotnDPj/qw3GFMFBE/va1PY6M8CT93T+nAlV1h00fNS/rn73znwfCHnXYfu3mMKWh0Cpl/03yZBLtDR6SxqcwmQBK2RZNfKhBf+rwl3UVjxpQd71PM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778814669; c=relaxed/simple;
	bh=WBzhUkFbzQTxwdmZ0DddBF/VYTlzYG0W/o96v8XXvVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TC5jxOMtR8Lu/4FNkG+iOZ6w8lMQKmQVREegqKaoMDUcIxPBLRH1Kr/qxHOILpYofr6hgwa7oxF3KQjyWHUE0qqKgQg8LG2O3+tEudpyWOOE4JdngKvRGYUmaaDE5fcE+LxaDgsxtlTGWMNLLItl6r1CZ3MY0fHJG2ZoJvWq4Zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kVMH+/As; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kVMH+/As"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899d6b7b073so83384776d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 20:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778814666; cv=none;
        d=google.com; s=arc-20240605;
        b=bcaALLp5hnyazxeZPDDshUBYRnXOtZFyVKBl1JorUOMOYZdIJkvaIQZxqWD46FQh4g
         xypj59rnYp5DxJ1oUk8xCaonghIV5GgVd28N9BXaJam/pGrDEpEaO5/9pNec/B1yDYJV
         ehJHSENC5HMxbGQU3pXHKatQ6OneDBhEq7upo6uO3FDlz88cZshZUPfAfTM9WJlv5l/f
         j2MbDvmhuI5jZ8vBr5BaVQlFVCIJVTD5iIpYHCSeu9WDAFJ/cOASjPCqZ/u8NlwpddlC
         nK5+XKyTX0m2MbJL72DGFlQPWE/9r583cMjJfBenJrtvPZpWNevW01n9peKDjJt79cOZ
         lEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=62xjzgBMlzfzuNOo9mzyAPb6sRch5lY4yZUszwPkHOc=;
        fh=84NGfN8An3jViS1G5/8zHKliBrafpyLwrdkXxhHezkI=;
        b=QP2reiUEgkBtwyWu9W2XcTkyLop9MtTyaI7de0vRijcRMLZti0vy4i/CQEuFNpzWaz
         VrnLEEpZDpOeDQJQYjc++4cnx7YD86VM9XQ/kEqRHijRgjRKa/IlL25hYu6lwi3BXI1k
         P3LWyRpNfhJChrodbkDAwB/OWeKLEbrkkgEvPtdK/ZGgoccrN59HjfpNM8MYZuk0MR9Q
         BZt2UZbemsG0O5m+851yS4HrNp/uZzGr5QWPwtELATUZH6gVkkF1hSDRCUfY3DTj89jE
         6aorfkM7hYsBUQ7VZKTUhpmGV+tTrynv2zp/qNQrJGUSTEL1whYR6Sy252vM9/+TvaPC
         l4Bg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778814666; x=1779419466; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62xjzgBMlzfzuNOo9mzyAPb6sRch5lY4yZUszwPkHOc=;
        b=kVMH+/AsQBhGT2lkoJHwaYL7po9cPQyKPqAJamHr86KqauP+gdWMOUI4CZioSmjJGH
         WF+M/hFVauYvZ66zQ0sFkh3f0pHzXZyvIyswo0C6XSTKLhJV6r5WVrhUHixuidmm/sgl
         yOASzEN9jmbcDLGieyABtqUhZ+6+ksyIAtmVAjjgRVa7A04nR8NqD5CDaHEBvKHoJ+0G
         39onWagO/Y0AqE/tIwqV6U3+6jGfIafkiJzojBDYTE1xSOr3lHvCq9fEBX4iI+wf7vTi
         pma67WIAAM5SNr+QrTGO4iDyqmnJjFkc9jnEcRKpVq2AbIAQhSubHeMy1XIGCdzvcjCV
         STmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778814666; x=1779419466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=62xjzgBMlzfzuNOo9mzyAPb6sRch5lY4yZUszwPkHOc=;
        b=SqV3ciDKDfGQOiYuTbQw8ALfJ13Awk9aFaYEzXebyAd/E1myDqlUIeC3ClIqOR1lDA
         /3ZXrsEIa7cTUWPqXaW/i8c4YW8TL2/RFUD08IJgDKcJaoZzIFVDGhKXRs3CzQ0mezFF
         d18baV/e6N1RC0FOZZr6PRd7Qx/oo4ma4uI+mBJSmLXYdoK7iyvxApPL+4dMMlog23xb
         0fV3EPxfPRuD2B1Zc30AapCUea5MKr0DVewmBHBjQ9FR+F3cuLCC2pFKOi0Oh5BzYV+L
         StOEUKmet4yosOR6rsuFq3A6CvEhtPmQ/AEGbRpRQfv31BZ4YiQA2l9PSUM3Z8SZhY7o
         Pj8A==
X-Forwarded-Encrypted: i=1; AFNElJ9/qEDQKhu1EJBu84oT5DUBo7DqS5tvKhI8PiUSOkQZy4ThDEKBQZiQDPj7hlnPtQg2hZ857RTJ7HTb@vger.kernel.org
X-Gm-Message-State: AOJu0YwZCc49K689ffQAcpeGOnhGwp4siutC+B7Kl1hidEzEGSZiZPOG
	cBnkO6Iuoqtd7tzNluS8jPJxmQZKkHkoDSU4O5uX8M/vbF9En7aiSxrXHBSQfYX7u3T0cD5TzEl
	/0WOc1eZSLvlagulCvtqy1daO9bSgrgtf9Lcc
X-Gm-Gg: Acq92OGt5gLuUQxDABdJqZQy7ZTyPl1cHQS0BJ4QLNgwjbu//a1y5TxBaqP4+EA2BsD
	y4c+RSTuERCmP5atAAGfkaX8EvCnC/WIBVoUPCWvzOcgBYwyhuFAG13rZnuHzmX2wfq4hbMBdX9
	mgfuXoL8a+2J0p4qZMKS3K2BAjI4LRJrfm0jpBnGT2x1dqt5abGv1AO3f0v8XiqNhdd92moHf9d
	GN+plbYbRLY7CQt1h8zBUN0pFbjFPd1yEL/GbN48AW+P2y8KMxyjdbBxfFe3QP/nsb9sNWCgcvz
	qOlLAwtzICUi/GEdftW2RCaCrPy7098RxvZ4iv8gLVkoHOc6ieEpYQrjrQiFt/hBIOr65Pxn6Uu
	DnP1vvsC7EulI8zKDkek+hXdROisFQ3NPYWkcvWik8Pra4+d/McpQtDPde8mBREy+UKbLW1VcnX
	svArAA39Z6id3ZTxpHO7+Y
X-Received: by 2002:a05:6214:130e:b0:8ca:17c9:c8b5 with SMTP id
 6a1803df08f44-8ca17c9cb45mr1134516d6.24.1778814666472; Thu, 14 May 2026
 20:11:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514231825.63211-1-henrique.carvalho@suse.com> <CANT5p=r1Y3h44dE62DB+VWbGOToQv5CGBc+dR-tr14vah3SObw@mail.gmail.com>
In-Reply-To: <CANT5p=r1Y3h44dE62DB+VWbGOToQv5CGBc+dR-tr14vah3SObw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 14 May 2026 22:10:54 -0500
X-Gm-Features: AVHnY4Jm74Xa4bIG0zfrDjU9iOEiiQDh1Nj6AOK6619lzzpz8yUzY4yoRXGRRqo
Message-ID: <CAH2r5mv4jNREvwU4P_X5b6gsGVBb83sYyWtMh-FJEcW71A_WtA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: protect tc_count increment in smb2_find_smb_sess_tcon_unlocked()
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, ematsumiya@suse.de, linux-cifs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next, pending more testing

On Thu, May 14, 2026 at 8:06=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Fri, May 15, 2026 at 4:48=E2=80=AFAM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > Commit 96c4af418586 ("cifs: Fix locking usage for tcon fields")
> > refactored cifs code to change cifs_tcp_ses_lock for tc_lock around
> > tc_count changes.
> >
> > There was missing lock around tc_count increment inside
> > smb2_find_smb_sess_tcon_unlocked().
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 96c4af418586 ("cifs: Fix locking usage for tcon fields")
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/smb2transport.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transpor=
t.c
> > index e8eeff9e50d6..1143ee52470a 100644
> > --- a/fs/smb/client/smb2transport.c
> > +++ b/fs/smb/client/smb2transport.c
> > @@ -169,7 +169,9 @@ smb2_find_smb_sess_tcon_unlocked(struct cifs_ses *s=
es, __u32  tid)
> >         list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
> >                 if (tcon->tid !=3D tid)
> >                         continue;
> > +               spin_lock(&tcon->tc_lock);
> >                 ++tcon->tc_count;
> > +               spin_unlock(&tcon->tc_lock);
> >                 trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
> >                                     netfs_trace_tcon_ref_get_find_sess_=
tcon);
> >                 return tcon;
> > --
> > 2.54.0
> >
> >
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
>
> --
> Regards,
> Shyam
>


--=20
Thanks,

Steve
