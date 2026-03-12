Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8A02D9EF0
	for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 00:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773274513; cv=pass; b=jAqxwaxv0doblG6KqlC8DsLxMmizByQsZAqccSHR9ToQuP46Yxgib5Kudt2T8UyjOkvJtrRlXsgEKxr/HeyCYRZ0DkLdxZY+V+Smo40Jsuzv9Zihh5YBn8019s3AboXsIQE+FgRx+21YHtONcT7GXxaIOGx3kRTOvKC1hk6TqGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773274513; c=relaxed/simple;
	bh=6/itMLCFfyLvJoeA9cy22RHpmFM4fQuJ59IcW2RTNl4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ahTMsEeQJ6xhtZZPqAhNn54y7ybI4F2I8OPgDj4KtpJg6+O8CyiPVX7PVbKW2ErasBIxtm37WbQlHcxI2bcay0zzrakXvwybWklz+EJgRD7WS76BWe6YIYje1QxG0Rv7+8x2QOypNukpj7vRD0b7GU+HwxFcEW1BEq0r3SkeHfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d0N+x/xI; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d0N+x/xI"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-661be3380adso623118a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 17:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773274510; cv=none;
        d=google.com; s=arc-20240605;
        b=VOhXSmNP0CKix7E5pJjgjCBOVIsqZU4qLH/HvIJ4QtUyPQ3pceNDwC6rB2XrUQ8eAS
         +ISYzmAwGIs6t1CMkDlso+xHNlwNw87BUcBoY/OAfZwvfT9eZ4HBFnvicW7yvSqAaWgT
         FnPvxOZmgVmNQDH5hKb9JrR/ZDrcU+YUeNp/+k0DZMmh+a/aYiY7DLhHuAgZqtHAThzo
         nPkweN+F7lmBz+BeZtWZoCL2hDrJGi1znj+pOV2aZoIY+150cNPHHYcuzE8tXhGk811n
         bpVwQ+Wm87gpNExf3AfdIPlTYk1ffNwGTgOBifAqiRn+UeDtZNW5Z5ify0x6L3fK7+mi
         kPFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pbDxkeMXFgFuSfzV6w0UsHl8/LPcKe8YhwEDSHSsljs=;
        fh=nXaa8shPt5c7lBLzGz6ka+zCZDJTCjax8ubKRDOiyw8=;
        b=ku9XVeTDpzqV0AjsKMicfWFerjX8f66MS67PGOZ+LXvCc0wSewme+NMR51XWXsQ1IQ
         N+inJnxS1mY1JEvz6Tkl+NGn9W6dHv9JA2AWcStpfhBONfDcioUr6sT0BxjdpL9eQ7O5
         nh2E2kgmVvm0RPvx5O30we/xYAwOLSLa8OU8xrIvRCoqNC2FXBGyIqbcZPIPDGlRFmo+
         EHWJ/05dgBcC7MTelfJWsZwXp1rn9w6RddxjhgAVC8OxIuvofBMuh7pDBgyztKIUahK3
         FWwqwVhIRJI1INEEpv0sLtpUBV97lKzmRfCkM2qdteyyanUhoPAQEPaqvh7alfP30Yeg
         +5kQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773274510; x=1773879310; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbDxkeMXFgFuSfzV6w0UsHl8/LPcKe8YhwEDSHSsljs=;
        b=d0N+x/xI7jNXbvlXlndVml3xlssmPKFdOwIFUKKX8tra0DYDy62dh9oYazJVFlKx2i
         tLn1bHuf6IDvnhGaXUglVzlf04eqvRJeRSAiTtBPBDRLDnA7dgRTPlDHO/vaY0kkcXr4
         2qtuS5pTRjLoQYf0mF27Nqk2doAB57nrsd/x5eF/Kvib1j5m0lcq8EVi1g4nb+yKINJa
         EuiVDAU/8I+kUK+lx6Jka1QD0thYSfJmsPw+WELj5Bt2MwgYXteXUCxYhUWD4Vi9vox0
         +q4df3Vl0qlV2kC/7pEdX0VimR3Uqdp3w/9anJgrS3fMkqUCdaGXaPX8tl+cYcwM6iNs
         HVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773274510; x=1773879310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pbDxkeMXFgFuSfzV6w0UsHl8/LPcKe8YhwEDSHSsljs=;
        b=GH0VzKfiAWrleByrBKcNNW0EcEPwXIkd/xgflXNBis1OW4saFGObY4hoQm4UKLLBmo
         KSzRLrzKEYqxrCkurZ877E3jDBHV1zNiTMyPGqTs2SyW2H328xaTaXvhuZi4u6rts41D
         F1RKtUzqLaLYjEB9UXo4rVnaFWpkcGrl8VgJg6UlLBzsE5a9fGfXNwvF+qhwBAlBMQyq
         YZodxv6uA82TXZTZO+R/56lf0A2s/SQNNO/tqUU8LgcItaplbkNJ7jc4paDpihvxA3ZE
         tGVIONOgxjSwDQWEnAkVfY0Gjr8To7KOmf7fBCanX4mErI6GgAuHraw9hhCHchVAfKrq
         YV7g==
X-Forwarded-Encrypted: i=1; AJvYcCUPRln7G7RiA+uNooyoNtHSMNIKYfxG8g658ScdEGsAfXy8dmirP4hWHgmVQ5isHMRTHAr8mssN1b9u@vger.kernel.org
X-Gm-Message-State: AOJu0YzsNDe3mwFjabAWliXzofSJvegJDIIXcKJEzbmJt71k7YZ261yL
	tPXYyWC4pVHFi9x0cyhzCHNsIOemxGeqG5eDgIW1Vpr9VmI7He4MvSLMocjYPLSJgF9+4UMuLaG
	vwXB9PxRy56bPvHxYKka/MxMcShwDJO3pjsJY7Ew=
X-Gm-Gg: ATEYQzyA3kQzOuR7BmIhjVf2sDRx7fm4MGnCgV7dupTyMkpU8b+mqgaUWI+QAXFgbRR
	jqsJ2kc8D2L2bjA5EgsHdnk3u09TQXGiJJbOZ4bHKyL1BRAFaQZ/S5dBomYCYzMd+UewC/eKIGA
	TVTT9jTeVn+5TVtgIGXWmXvG07EEUFxC+xNwpyN/FksbtmUW1EGIctesu5RwNgZ8lPEZjHMC0SZ
	K0735rrOJN78tbE5JzY3ochQfiT0g+x3umdjtYMHxANu3jA5KrUVIWI62NURRc7ga2WC621CFrI
	SQZddSCFmOo04oDK
X-Received: by 2002:a05:6402:5109:b0:660:f98d:227f with SMTP id
 4fb4d7f45d1cf-66319ee21aemr2290781a12.28.1773274509925; Wed, 11 Mar 2026
 17:15:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310235642.6d9798f4@plasteblaster> <c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
In-Reply-To: <c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 12 Mar 2026 05:44:58 +0530
X-Gm-Features: AaiRm50oWdiNjT1ebRKWHilt31EW_fjU4bk5ELRtpIJIFmb-N6WXXm4YQx0WL0s
Message-ID: <CANT5p=q2Lv4pSvEm5EWcM73b7NZsbt1kYEFJtjaAZRS6Gz_OjQ@mail.gmail.com>
Subject: Re: [REGRESSION] failure to reconnect on SMB server restart with
 custom TCP port (not 445): Host is down (at least since 6.6.95)
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>, Steve French <sfrench@samba.org>, 
	linux-cifs@vger.kernel.org, regressions@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 7:37=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On Tue, Mar 10, 2026 at 11:56:42PM +0100, Dr. Thomas Orgis wrote:
> > Dear Linux-CIFS maintainer(s),
> >
> > I stumbled upon a regression in the Linux cifs/smb3 client when working
> > with a smbd using a non-standard port. I am not the first to note this,=
 see
> >
> >       https://bbs.archlinux.org/viewtopic.php?id=3D306712
> >
> > which is a report from mid last year, indicating the problem sometime
> > after Linux 6.6.72. It is a very simple issue, where details of the
> > kernel builds or mount setup don't seem to matter much: Older kernels
> > reconnect to a SMB server that was restarted (old processes killed and
> > replaced), newer kernels do not and just have a defunct mount.
> >
> > I reproduced this in our HPC cluster environment with such smb.conf on
> > the server side
> >
> > [global]
> > security =3D user
> > map to guest =3D Bad Password
> > server role =3D standalone server
> > smb ports =3D 1445
> >
> > [public]
> > path =3D /some/path
> > guest ok =3D yes
> > read only =3D yes
> >
> > and such a mount command on the client:
> >
> > mount -t smb3 -o port=3D1445,user=3Dguest,password=3Dfoo //server/publi=
c dir
> >
> > When I kill and re-start smbd on the server, older client kernels
> > reconnect and continue to return listings and files from the share,
> > while newer kernels give this:
> >
>
> My suspicion is that the regression was introduced by:
>
>     5713127da855 ("cifs: update dstaddr whenever channel iface is updated=
")
>
> That change causes parse_server_interfaces() -- should this be running
> without multichannel mount option? -- to overwrite the port stored in
> server->dstaddr with CIFS_PORT.
>
> The attached patch preserves the existing port from server->dstaddr.
>
> Note that I have not yet tested this patch or confirmed the regression
> with a bisect. If you can't, I will try to do that tomorrow.
>
> --
> Henrique
> SUSE Labs

Hi Henrique,

AFAIK, the ignoring of port from the results was by design and part of
the original code back in 2018:
CIFS: parse and store info on iface queries

Also, the comment in the code just above says why this is so.
[MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these

I checked this section and it says:
Port (2 bytes): This field MUST NOT be used and MUST be reserved. The
server SHOULD set this field to zero, and the client MUST ignore it on
receipt.

Based on the conversations here, it looks like smbd ignores this.

I think the right fix would be to make sure that
cifs_chan_update_iface gets called only for secondary channels. That
way, it will not get called for single channel scenarios.

--=20
Regards,
Shyam
