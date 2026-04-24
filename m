Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DFE211A28
	for <linux-cifs@vger.kernel.org>; Fri, 24 Apr 2026 04:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777003618; cv=pass; b=gZJ6d1Ysjs2XrtWTmoTFw5MCwePBXGGWfMg28xb3hf2wRc+8KvpfYazsC4bZ1SZi6F3TPpVblN1tinlM0uod9sYZGzQE86O1GinD6msHmJcPr2OXq2vWvuhjP1EoNL6wAtYskjVhLtGIRWImAmjAGUCU93hmGk72r0iqBAEqkVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777003618; c=relaxed/simple;
	bh=ZeMSoxm5J56pCcvQzGBEzz5ZDcItPYQcH5DkOuSS+uM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KSjT8OxLhHKpe4302XrJJb20U9sOmH9pmT5bKMZwstgLCOSfkkK8wJKBtOXFsNWwryqOUvHgfPqedUoI3PCAtTLsYNdvOE6NG27X9i0+h0fVl8Fahw8vPEWOFlgOxa/wtGLFvBB4wMowMem4AgUcr2k30sPQDOa1xt/XHj6qJq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M9RbQ45/; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9RbQ45/"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67845996252so3118740a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 21:06:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777003616; cv=none;
        d=google.com; s=arc-20240605;
        b=UsmmFjgoSjl0To2GNZBHPwLRIKgy3lDfsqf29JKeOoTFVvTYHXdMPh2KENnLAfL3wg
         3PQzdFVEYTAYSlth6DzxbC+NVg1XJ8oCLXm5W1HW2VA5I/3iqygc2BbdXK8LX/pO4tBt
         dhfW3R+HlHXX+42tRZU5L2V9Qr39nyxcZQfIAOfN7iMnW14D+dgEdX9zvJDDI3YVS82z
         bm4mS/TUhj3i2yqcfMcqvZR3cdKq5ss0yWiMCY1Uzt4swhkFlC4e78TF29fY4vNjq0pe
         Rzf561o1Dx4SbFKLderkwa668C7VkuaQtuZnhyBbGWtVaGdDIKCTH9FmRGTFfXE8SZUc
         g+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u1qEV7FDucr2Oma7YgmbpI0eIOoUHkUaFY9SQRTBH3U=;
        fh=KUxQK/NEwTqWJy7v5tO6GgQtjZUUyRr+f4DkWFVnrJM=;
        b=Weq/pMTo/tKImMcpWYjt9RJmci+qCHPvR5B+0sVVhmbUqowGLeEEvt/lMeNve0JzNe
         GLD/ncI1YUg2C2v7+7xThKE1t9XaKA4EJ4SUu/na2sbTnNszeFicM8iln7otGGrFLAgp
         wq+fAYu86n4B5VV+Br08H5WUVvVHUSy3GVcjcfYXiATSR9VZmWOmMdRi3G4d6rumFjd+
         nRpJ+WfHo5PoHMRKVcZQom35b/izFFGx2IXS35OirlTgBPwWAU/gfZPfYhYRKMhW7Ehh
         N1xgoVtOaGrnagKoSirii0b1j9BVHkT9HCH8QNBl5/0JlPrz/xdDN3ZVb7EHwmU4Yyln
         iZbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777003616; x=1777608416; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1qEV7FDucr2Oma7YgmbpI0eIOoUHkUaFY9SQRTBH3U=;
        b=M9RbQ45/sv5qLxDA1Pos04z/gwcCipJEQvCzpcLXFFDuWeHC7cy3s4ZTvX7RBs5UkT
         APpMILWsMp0+x1WrQgEdWfCTVhqXHQe4uEJumstRW8U3hvKkq+AGGMjJa8nKgi2hV0x2
         WIU1poisXsBJZVzZnfOWVcxWI9N0GEuaQHd6AKbUcJQatAWn1poAgxCTQZW9Swdvxt31
         YOPvQ8FcYn9Z4+xcJvqmYPL1ROhQynSWogOooSYjDSDl0axYyq9VEKtBfpCBjuOMJ3M1
         6yO5UaBOwEtdOUhYomQir0u9rakQGbvDh/qef0lETKgfT64/czMPHFmGKnGnjAK7JIfE
         ZK0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777003616; x=1777608416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u1qEV7FDucr2Oma7YgmbpI0eIOoUHkUaFY9SQRTBH3U=;
        b=e8gZVOx4HXdTgS7vY6ktVW2zsnnxG39FBlrfrWT+AK2dYZdW/pipKSo3whOYqLAVqA
         iBIooy6wV5X50Hxg8jHewyIUL9A8UVnS8RrHfbtFLW/CwPGgr5Zub2AjVNk1Dlr/U64u
         DRf036QRKhEOKLXj75jHCOMeVG+OTbgywbJzM5AzQgzOAqYOZPGUeEvv+5FQxnOhLEEf
         2eRb3heHBiXW/ud6bansGm1H76awcuUOKpf6obTk2cYGhcmnYYs3u74p633LrQugVvEQ
         F+CqF0aj5TRGJ7hfRKrYbjPLkEAsQbQd665sXZ7Lg7Chk+4TY9DPWKIhuDdiyqrDarx2
         0Pxw==
X-Gm-Message-State: AOJu0YzjouCwgAA/0ii3ztgKZe8I5WEq3kHt7gNKpjaYNm6w2CtQsnH9
	mpkes8E8EAbMHQYe5E2Q41ixh2aRw2pMyPJ6mCtrYFnLWKyQdqhaAxaDpcoLPl35mvobBAVbsZq
	8dnOiD4mAJVef8lPsWYZy+1e73TNR0PQ=
X-Gm-Gg: AeBDieuFHWgQ7Xkv4yiHbpwowNyx8z/4AP6i/FgX9/VyduelEqBYvqnR9ojjTQpv0jD
	Pdp2/SROJy8najjrQYWcIheld3ht6VsNWmpTh+5amd4Xomaq1mhNvOLz7vBGJ4DIYrsmuhfXC7R
	jOB4xuwZfgjsX1qYUJcuDhwigbsCnfB5f14MYtH93HMVgIWPLqr3AVnW7PdNVFRk7bmoy54pj1C
	LOY+ZU9/5jsg3oMb8hTy9Gyze1sNtx7ZuIFr3RPpsxaPca6jrLwa9JiAlj2yDI54Rm9NkGuNoK+
	44FKQdEVYqBMTaTI
X-Received: by 2002:a17:907:3f0f:b0:bab:7930:db48 with SMTP id
 a640c23a62f3a-bab79401ea6mr498302066b.46.1777003615416; Thu, 23 Apr 2026
 21:06:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421063955.99164-1-sprasad@microsoft.com> <20260421063955.99164-2-sprasad@microsoft.com>
 <CAGypqWzrOmR6rUimbBJa9qJ-=+KJFzccMjere9dX=KwWeDFe+A@mail.gmail.com>
In-Reply-To: <CAGypqWzrOmR6rUimbBJa9qJ-=+KJFzccMjere9dX=KwWeDFe+A@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 24 Apr 2026 09:36:43 +0530
X-Gm-Features: AQROBzAJ-73VnnQjn9jxamNohqWFvDhzqHJpUDI2Ld9Tk85kL8Hk85ywSY7ptQk
Message-ID: <CANT5p=rJ28LCOT1qcn9Xtcutq4mJB9t+jX9e79fDOXg0cHh0Ow@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] cifs: abort open_cached_dir if we don't request leases
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	ematsumiya@suse.de, Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 8:56=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> On Mon, Apr 20, 2026 at 11:40=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > It is possible that SMB2_open_init may not set lease context based
> > on the requested oplock level. This can happen when leases have been
> > temporarily or permanently disabled. When this happens, we will have
> > open_cached_dir making an open without lease context and the response
> > will anyway be rejected by open_cached_dir (thereby forcing a close to
> > discard this open). That's unnecessary two round-trips to the server.
> >
> > This change adds a check before making the open request to the server
> > to make sure that SMB2_open_init did add the expected lease context
> > to the open in open_cached_dir.
> >
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cached_dir.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > index 04bb95091f498..e9917e5204b00 100644
> > --- a/fs/smb/client/cached_dir.c
> > +++ b/fs/smb/client/cached_dir.c
> > @@ -286,6 +286,13 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >                             &rqst[0], &oplock, &oparms, utf16_path);
> >         if (rc)
> >                 goto oshr_free;
> > +
> > +       if (oplock !=3D SMB2_OPLOCK_LEVEL_II) {
> > +               rc =3D -EINVAL;
> > +               cifs_dbg(FYI, "unexpected oplock level %d for cached di=
rectory\n", oplock);
> Should we reword the log from "'unexpected' oplock level for cached
> directory" to something like
> lease not available for cached dir.? Considering  the client itself
> might be disabling oplock temporarily.
> "unexpected" might look misleading.

Hi Bharath,
Thanks for the review. Will make the change.

>
> > +               goto oshr_free;
> > +       }
> > +
> >         smb2_set_next_command(tcon, &rqst[0]);
> >
> >         memset(&qi_iov, 0, sizeof(qi_iov));
>
> Other than the above minor comment, Changes look good to me.
> Reviewed-by: Bharath SM <bharathsm@microsoft.com>



--=20
Regards,
Shyam
