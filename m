Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C6F6EB5B
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 12:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713184579; cv=none; b=jm5tyVFuWKD6tHNDoml8ddb1XvGRmM3m4GAdBc1AvvxvImWsQTrUlV7d5xbii24TH958eCbeD9xt/pJM5b7OhKrFTC0dDYcEDOWFNMMl9HAQJKZiXLdxGOCcljeGpc5amTZFaj88VkxCD+xOR5ocY9qMzSxMXfRSGy9I+U0Dttw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713184579; c=relaxed/simple;
	bh=Dij0Ubqo6koV9aJXmZvZ+7qasNt9F3TawwhHN8OCsPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZgbZHn5ceBMxA7ADNslLjUEKvbfQHZHR8vglcntSEJMM99ehrqzxqlp6qZAykoG1sjnsDkT/uIJy7b1EtvodvMDzeHKtwMiq5r4hep7fNRHgbh0z7OI5Eh7BGlvroIwwm7aSJdJEvzhjiFugM8KBS1XkMThnM5emn7wP0fgdwAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=ISoCXSIy; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="ISoCXSIy"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a51f9ad7684so219348866b.2
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 05:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1713184574; x=1713789374; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIBY0YSXgqzgmdiCA+0Yct13G9c58Vm/DEwsrF35+DU=;
        b=ISoCXSIychHmlLEFNFscCaUJemoawcOBhk7VIs6ah9MYYM/t4TtZZK2pvKDyMWfScp
         yR/3zXEahhdIBA9JfMfKTBUR73v9U/oiXvAdgrLGgTLBWFX+8eBT/fSFzwJPto4qvuDr
         dMPvdSbOdMMZCqn2SZrxMi7/i4Ts7Fswu/wAd0cckhz1Vjhfv40/FPGsg0gCFNqge6Pe
         IXt3dY5U4u5GKf3cZwhk7y6KAWnOleYR7WENe/TnK09jwU4Awfc/+LO4a0bLuRUxENAC
         VsxD8dvLKYHz6teFM6oayKj/ABq/ldNF+0Y+bpJrhWOjyR93/V6eRwACWnHkiGRKWsws
         4OjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713184574; x=1713789374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rIBY0YSXgqzgmdiCA+0Yct13G9c58Vm/DEwsrF35+DU=;
        b=IO2mBvxv9jbhZmtd3NbDv+3tunpMRj7mFBokqfCW+EwgcapBfum2HdR+S+Yui0og5S
         Oz/wsRKBsRG7m2KZVxHM1Lr0wofZcDI0uKYkb1cKcVSrzMDGwhBRRiWvkS2JrWirweEf
         8fSegGqrbQHBjgSakaxMBvtjJN99sxot0CvK5xdk2ec676h61DvzySWVeO2HywXFqwXQ
         9+89ZRtBNczZA/GCb1I2l40dPjh2YPMkcTY0MXPdnVbwxwtAfVRiQn/9qln4V+sjdckf
         L3V2eqsUSJoX5MlWoMW0k0/eDzylDzbOopgPKJPWFyAjt8888KTEu2PBctblk2McYkHt
         8WfQ==
X-Gm-Message-State: AOJu0Yy8H1ShAWaANAx+ZaSZGmUMjdoMt/8Cu6sIJHFQLi4mpPqTCaw/
	u9dLbJBZBStQYz5yHvAAW4dr/U+rSRnXrt8DCJjjuAsWZjDMBmOPd06wJ8Honi+kxC7Fpjmp8pp
	ILpp+uDEuZjuInkz2mwcsCf2X1qQ3PcWD+Qi4GXfdMLD50Qt2lw0=
X-Google-Smtp-Source: AGHT+IEQG9/2CCTRAPYqJkOzEOU2/JRwTx8LQpqYqKPD6YmV8x6yB8BUyk6y11OVLLADPYDBDNUl0GFa6VciRfqhvGQ=
X-Received: by 2002:a50:d5d9:0:b0:568:abe3:52b2 with SMTP id
 g25-20020a50d5d9000000b00568abe352b2mr6870218edj.23.1713184574281; Mon, 15
 Apr 2024 05:36:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313130708.2915988-1-mmakassikis@freebox.fr>
 <CAF6XXKVNTF2yZK=QdKi-YNZC5N93x-NrN7a=hDGZNNCUfxTAwA@mail.gmail.com> <CAKYAXd9o2d0Ky-242+UV3DcHWs1ZMYd+ErP8Ueqn3nvucMQtJA@mail.gmail.com>
In-Reply-To: <CAKYAXd9o2d0Ky-242+UV3DcHWs1ZMYd+ErP8Ueqn3nvucMQtJA@mail.gmail.com>
From: Marios Makassikis <mmakassikis@freebox.fr>
Date: Mon, 15 Apr 2024 14:36:02 +0200
Message-ID: <CAF6XXKUjE-vo+z5aKrfXEet59EJB+yjy3uh1xhJQRQaFppdWkw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: clear RENAME_NOREPLACE before calling vfs_rename
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 12:51=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org=
> wrote:
>
> 2024=EB=85=84 4=EC=9B=94 15=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 6:01,=
 Marios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
> >
> > On Wed, Mar 13, 2024 at 2:07=E2=80=AFPM Marios Makassikis
> > <mmakassikis@freebox.fr> wrote:
> > >
> > > File overwrite case is explicitly handled, so it is not necessary to
> > > pass RENAME_NOREPLACE to vfs_rename.
> > >
> > > Clearing the flag fixes rename operations when the share is a ntfs-3g
> > > mount. The latter uses an older version of fuse with no support for
> > > flags in the ->rename op.
> > >
> > > Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> > > ---
> > >  fs/smb/server/vfs.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> >
> > Bumping this as I haven't received any feedback.
> > Are there any issues with the patch ?
> Sorry for missing this patch. Please cc me when submitting the patch
> to the list next time.
> I didn't understand why it is a problem with ntfs-3g yet.
> Is it just clean-up patch ? or this flags cause some issue with ntfs-3g ?
> Could you please elaborate more ?
>
> Thanks!

Until commit 74d7970febf ("ksmbd: fix racy issue from using ->d_parent
and ->d_name"),
the logic to overwrite a file or fail depending on the ReplaceIfExists
flag was open-coded.
This is the same as calling vfs_rename() with the RENAME_NOREPLACE flag, so=
 it
makes sense to use that instead.

When using FUSE, the behaviour depends on the userland application implemen=
ting
the fs. On the kernel side, this is the function that ends up being called:

fs/fuse/dir.c:
static int fuse_rename2(struct mnt_idmap *idmap, struct inode *olddir,
                        struct dentry *oldent, struct inode *newdir,
                        struct dentry *newent, unsigned int flags)
{
        struct fuse_conn *fc =3D get_fuse_conn(olddir);
        int err;

        if (fuse_is_bad(olddir))
                return -EIO;

        if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT)=
)
                return -EINVAL;

        if (flags) {
                if (fc->no_rename2 || fc->minor < 23)
                        return -EINVAL;

                err =3D fuse_rename_common(olddir, oldent, newdir, newent, =
flags,
                                         FUSE_RENAME2,
                                         sizeof(struct fuse_rename2_in));
                if (err =3D=3D -ENOSYS) {
                        fc->no_rename2 =3D 1;
                        err =3D -EINVAL;
                }
        } else {
                err =3D fuse_rename_common(olddir, oldent, newdir, newent, =
0,
                                         FUSE_RENAME,
                                         sizeof(struct fuse_rename_in));
        }

        return err;
}

Because ntfs-3g uses an older version of the FUSE API and flags are
passed by ksmbd,
rename attempts fail because of this bit:

        if (flags) {
                if (fc->no_rename2 || fc->minor < 23)
                        return -EINVAL;

ksmbd already handles the overwrite case before even calling
vfs_rename(). So passing
the flag doesn't add much.

--
Marios
