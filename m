Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DE420AF6B
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jan 2025 15:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736782955; cv=none; b=A/ibZwZPaU5SfdD3RB78nlI9OFKUjlTENAb+VStVetlfDMHrLs7BMEBljQNMTwj2eHePYvihCTWm5dneRj4UTdW/4i7ruStSddqOkyjN95dOrLLAPWH0VhQXmA0T41vtUpeKWG9GE7oBG4GaI9VkLV3b959faK3uR7CZGy7kFwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736782955; c=relaxed/simple;
	bh=pE3XhNZQcjRuHWLW6S2X/topppfYIj1L8s5etOKTr/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p1Hq6eMxd9GJrA92hlK3LE/lHgbQKjqDyaks4Ot3Ra2RVXXciXz9stmr23gyYgejEenzwjVBgttcQ5G0ZggO18JXwq+jK4G516PqKVQ8/FvxYcJuXTQxpnWPfJE3sOOzj/PXVONGFcwIs3oLmHRoUW52XEdnJVjW8Ux0EVTrdEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k1ruMpTI; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1ruMpTI"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d88c355e0dso7784952a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jan 2025 07:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736782952; x=1737387752; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/y5sHlVm++HJFVn9wT/Hx8hsYDg0zpKXAwu8bBATzg=;
        b=k1ruMpTIKn6sGAG+/wHBTbo+0QgnPMo3BlmF+TF36wQqI+fPUa1v3L9uDj1kLVuJ+c
         keKCyTGaGXsHTYId0raqnivaD7exAINKBqxbmDn0/4s8/T5WsByg5JXaNWyolvV3SBOI
         ocxmdSpYaeGYXEV5OrWWtCwUA4uKFSSLkBnh4UghLwnN/CCpN03lqjNP2rva/WNSZqnu
         0VUkze7JDdR9ejziCrIj+OVuOsRoGQhHtajAyJYbEVGmo2TC1bLcv07WqHAAlJ2Fjay7
         eDkUvAVmQGgMS/PlZD6C3gNmDkPfd1vJK7AzifhnG5nTBEB1/Nm5rXIMVA5bKZy8sgfD
         jnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736782952; x=1737387752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A/y5sHlVm++HJFVn9wT/Hx8hsYDg0zpKXAwu8bBATzg=;
        b=QvDZ60v1be8fF28a+22s0ZzDh4EfASKgBDPTkI+yz+6Vxq16fvQ7Z/CEOwdwZRmE+9
         KgB6aNR+AHUN+3GPCqTNHKZSQ5QxHvTDaFXBOdIIFLoBk1HOOwSdcH+SmhztZZMEm10b
         7cDPQPJ9BCBbm3+EfhedPQRkREjVrA/EEorSUqnlVnU4u5+DkKcbSbIkE5d5dSFQ7kSp
         jWxmj6I51xF3zNvuw5F4z6eFREAu8qFDAjrOz3+hjW3WtcQuV52aY3oT8BaH5Dma+Tfe
         14VD4ZIsDFT90S0hlOXFu91Pp1K/23b2lYkuyssfcjcPqg3IKNBpqak0UZjlzC3R+OXk
         HeVw==
X-Forwarded-Encrypted: i=1; AJvYcCWB1c5Y8tQwhS8hiOfWp6oI/VaBZ8Tlf0jPERYZRT97TZN/juzvPu24f7Dvqbg+IOI8d8BS2kpZQIXb@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc104OkLahfUtCyvkVqUuAh/KVEz9xuvGgbshfA5AIXX5Wlr+F
	n6lw+IieASAe2XC6oN7Zuc0RJszTP4WkoebheRs9fj7SJKhOCUL5ELWdQw1z2HqlHtF5DUem+xe
	atPBbVvmzA/6SICbXPTPgxjrivGH73Ez8
X-Gm-Gg: ASbGnctrbhJOZ+JREARkLTviAtzeagEhuOmxfHxvQ5rgkazzQ+Ho7cXLykQAqhneUEQ
	0C6raBciAPYFSLtVHCNSJw2ECTmPGOFr9PG1x+GAjvBvyWzxltIKl1QcPGncqqUVCKyCv
X-Google-Smtp-Source: AGHT+IFVxEBXdFP8KDY1Zo4jVTyb3SxBfboIdOMDsyCG4F8yMCgNzpS5VfTxnueIVtheT/a6kjqheK2EjTPlY/BmU0k=
X-Received: by 2002:a17:907:948d:b0:aac:29a:2817 with SMTP id
 a640c23a62f3a-ab2ab73bbf5mr1705064866b.26.1736782951421; Mon, 13 Jan 2025
 07:42:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=o-1V2ea-+Lj+M0h4=syXyJYu73JU3F0dXij=KVwWUTOw@mail.gmail.com>
 <eed163634d34c59bdfe3071c782276c2@manguebit.com>
In-Reply-To: <eed163634d34c59bdfe3071c782276c2@manguebit.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 13 Jan 2025 21:12:20 +0530
X-Gm-Features: AbW1kvarxUK31IvBcHKGW5L868kTYjX5QCjjjh8QbyT7zas4c90cVySyZq4hHoc
Message-ID: <CANT5p=rEjCwxm8t_zayJ3VGTcXYgBgnSaeFUHwkpuL0DfZY0=Q@mail.gmail.com>
Subject: Re: Negative dentries on Linux SMB filesystems
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <smfrench@gmail.com>, Bharath SM <bharathsm.hsk@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, 
	Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paulo,

Thanks for your replies.

On Mon, Jan 13, 2025 at 8:55=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > Ideally, negative dentries should allow a filename lookup to happen
> > entirely from the dentry cache if the lookup had happened once
> > already. But I noticed that the SMB client goes to the server every
> > time we do a stat of a file that does not exist.
>
> This is a network filesystem.  If the last lookup ended up with a
> negative dentry in dcache, that doesn't mean the file won't exist the
> next time we look it up again.  The file could have been created by a
> different client, so we need to query it on server.

I agree. But we do have tools to trade performance for accuracy using
parameters like actimeo/acdirmax/acregmax.
So we can avoid going to the server each time if it's within some interval.
If the server gives us dir leases, we can be sure that the dentries
have not changed without us knowing. So we can definitely cache the
negative dentries till as long as we have the lease.

>
> > I investigated this more and it looks like vfs_getattr does make use
> > of negative dentry, but the revalidate always comes to
> > cifs_d_revalidate even for negative dentries. And we do not have the
> > code necessary to deal with it.
>
> I think we do.  Check the places where we return 0 from
> cifs_d_revalidate(), meaning that the dentry will need to be looked up
> again and hopefully instantiated (e.g. file was created on server).

I was thinking so too. But I could see that a revalidate loop that
repeats every second is calling cifs_revalidate_dentry in
cifs_d_revalidate, which can only happen if d_really_is_positive
returns success.
        if (d_really_is_positive(direntry)) {
                inode =3D d_inode(direntry);
                if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(inode=
)))
                        CIFS_I(inode)->time =3D 0; /* force reval */

                rc =3D cifs_revalidate_dentry(direntry);    <<<<<<<<<<<<<<<=
<<<<
                if (rc) {
                        cifs_dbg(FYI, "cifs_revalidate_dentry failed
with rc=3D%d", rc);
....
                 }
                else {
....
                        return 1;
                }

>
> > We do use d_really_is_positive before we do the dentry validation, but
> > it looks like that comes to us as success, even in case of
> > non-existent dentries. Is this expected?
>
> I don't think so.
>
> Al, am I missing someting?

--=20
Regards,
Shyam
