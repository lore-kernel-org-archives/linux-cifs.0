Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1A732FA2C
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 18:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773253854; cv=pass; b=hHTJejCTp6FVDZEa8sF1/tf5HIIrhuz57SHS1mnyqvJnExHQHAPzrMcXqAX80mnWcyucV+5Tr5lSFTaVHWNSBdbFBJPTcxeDOgJKb0xqKSwNg+OR2tyIuYoWggjOhazVLpETZrhS+zCyITc4Rd4YDi35LJW6wqd0mX1HTQjIeJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773253854; c=relaxed/simple;
	bh=FKAphfj+vbjBMx1fo0kitY04r3B0cepQosEg5F3tOJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KpSi5p9pQAS4WJozRYJykJDI5jds00L43T1ockwHOuUIe2c30iCjy4/1toeuzwF5ikfL+3fmyl8Vd5dcgnErkST0M1+yt5tRaxgDnJwOZWlRrV/40++t8WHBGJipg7j0Xl9sMcoP61+VfURMeEpjIC+/DS7f8YgO8LVdjaUJ3f4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjpJKjN+; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjpJKjN+"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50902b1006cso1315001cf.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 11:30:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773253852; cv=none;
        d=google.com; s=arc-20240605;
        b=Sfc9zw0P0Nsn0vd0vU3NucP/YaVF3lwGqwEntmtYqatVTf0hEHd20waS+j3iOfs0fr
         QWPN7FRqjwHE7uefM/7svJiNUSLylpKtuIDV5YOmPkike79L9iKxMMCHohPmZQTQubfZ
         HVTR/v92xAfw2kqYazEcU91BE1yzzKBsQPTbOgxRsztoiR15EgYMHTzAgV9NQxZHWxvS
         er5utuGjCWYP9rhTg6N1exOKyeC5PbSP44oDKO4B+ey0viptfdBBLhfK1am3CUiqOdHB
         Sbj65yA7sn+mc+en3FQ1FOes02ujpcofd6FnH74PnoxzUMmZHgN9HBwGZQZ6Lef57LYB
         0HHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NXU5+1joNF1hpozpium1vq3MyYKKFSSUHLSiAVt73fc=;
        fh=o/B8/amzGxBR3et9KmoBBIUURBBvNT4HmkTHQxBFvrk=;
        b=kB2FwqMM1IOoI/pvNHivA46s6nqWloQvIfMbnL9c8T7vlUoLGCISBn/lFC+3SMdJOr
         OnN6WSGj1HwXiy4B7pFfE03C9wjsFM9VjVPYe53L0lP295oum8P2WNUU2csjoN97FdvS
         Cs3h3q4c4IN/9jKdZOft1iymqnDWXqt+LRt5cwTi8uTdOR7oIXtNRt0KxV4JJVZxQcdJ
         VUAiB2AC8KCFoPvh/fwr0vtfWPSpgs/Ad18UkTPAQ9q7YbeBCTRLd+JUgfreVXxiFium
         7QYlgJy8Y+K83wOh94MugZugjKX47f0FVFJIhoOQviT0eB7DENq9yZjS4qHRGzpGWu+a
         YGcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773253852; x=1773858652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NXU5+1joNF1hpozpium1vq3MyYKKFSSUHLSiAVt73fc=;
        b=LjpJKjN+k+bMEU3gntbgtjSxKf0d2BwwA/UjVIugnDmSKyBqaTVcm40m8mXsznzHLm
         5XvvspZ5RKgfDZ9qthipNkToDDAUOqE3zoidDs2VJoeAD5nHiITt7jTVSDHBUhzYEsW5
         eK0t1z7DgCZ6at9+Z0fdpjxTZrjfhuimqmf5L0Ba9CBFowRUmVn235jMsB6jlRdMx+Cb
         FRR5kd8obA54vXDQcCI5OYXeVwxwyYZKEvkBNWSClJh1C2c9XqDE+7tSr2BDu9AXG/8o
         BwtovxvT1hCghiPzF8dDBobNtIcvkXEtDfU4Wp2/+HLjvFVx5l3/q/8HWlCf2f1k3MtH
         08xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773253852; x=1773858652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NXU5+1joNF1hpozpium1vq3MyYKKFSSUHLSiAVt73fc=;
        b=n1ofEgRPBf5jpzUv/lS28+Muk3c2TABK6dmnoV3utVdNcqFLxXdr7lzBrwMomODLNU
         nZpdTGQLOq/2vKbgRjgO4PNGrldo3nUnUb2mwDt6aHrtA7koolpQ7gc2z/1LDCiYdKS9
         0sp4F2+E9bwlA3Qy09DCRIBhFK5ShDLNQ1S0GsP6BELwajO6H6YzsF5aMcGTZ3neoaam
         fOq95ObDivzkDYE3pDdOM9CRVdVTAQSlF1wtPsvaQpGa3cZNJ6YpMPmAVlxKkfvfp4wo
         Ci8G+crXo90l62j2ZnJRnhDQR6jdHSVoD1mPfgyBN866GOk01XBJXL2wByhTirHTIIUd
         xBfg==
X-Forwarded-Encrypted: i=1; AJvYcCUasyQ3KMXpXcAeqzWmDDea5m/B7tcmOggMlRb40pHIs3sHgd0qj81W2wu2ioxgb/b7F5f8/vejO78y@vger.kernel.org
X-Gm-Message-State: AOJu0YwDEBUZUG8+suflyNHlkf1fhMcOfaJY9OEvWIEdplcYP5Va5GbQ
	ZzSpz+sKrCNx8BlJ9w0dh+24xtUAbWI8ryrO1KB0IapNbhHVbIdePAcmnCiqez4x8cByJEay30+
	QUZwJqMtMKbfQPv8eQr3js5u8e5pLXXY=
X-Gm-Gg: ATEYQzxEMkTjEHdGIZlUPZ0yqx5+AHsvE8pnGA3Gny2grNKxAAA2dvwho4u6FvMAQDv
	amnDO1PiUaUejGdkf/OJFCOK5x09s8YMu3E1Ph+IM5EpcNY/vptZGYf1N9D+6eSsCZsAGfBBBGW
	awUhdEqExjaRp7ilXUAykVRtxPeNGv6KMqXZHD0FksgRCmyL5BC73ZNu+I5Iy20QBiobY0/IrkA
	c2AOwAvOWEaSkelwgas45CCv8KU6W3e9Ix10ye919ijHUjnfE5j0BVVkM2c66Q2vEDZiiMk6n5z
	LX4K9y2L3sKxUVOLTPTsJpHBONudtGWmg5nhdSCQmNpL7BIA+gAXoeIffOsfpq/poxwtwvE7BjB
	8GM8phdfCwEJ9LqH+F9WTOsaR+bcex/trToC7qPgZ21JJndcEhfP3XYWvwh/DpQ==
X-Received: by 2002:ac8:578b:0:b0:4ee:280:2e49 with SMTP id
 d75a77b69052e-5093a1c3d31mr42578001cf.66.1773253852041; Wed, 11 Mar 2026
 11:30:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311051854.2584907-1-sprasad@microsoft.com> <CAGypqWzCfeckKxZs0KJuqoQMmHyfb_iJ+ObysO5-VFxGGVJwgw@mail.gmail.com>
In-Reply-To: <CAGypqWzCfeckKxZs0KJuqoQMmHyfb_iJ+ObysO5-VFxGGVJwgw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Mar 2026 13:30:40 -0500
X-Gm-Features: AaiRm52ia21s6kfRtinwc0tm7VhxEfa80TtC6t5NIa4HGMDj2y6R4joJYpaO3VI
Message-ID: <CAH2r5mtKrA9ni3_dRtaSKbATik8fPAjJ-q9jEHhtxPcdWoWTyQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: make default value of retrans as zero
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: nspmangalore@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-2.6.git for-next pending additional testing and reviews

On Wed, Mar 11, 2026 at 12:26=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> On Tue, Mar 10, 2026 at 10:19=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > When retrans mount option was introduced, the default value was set
> > as 1. However, in the light of some bugs that this has exposed recently
> > we should change it to 0 and retain the old behaviour before this optio=
n
> > was introduced.
> >
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/fs_context.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index 54090739535fb..a4a7c7eee038c 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -1997,7 +1997,7 @@ int smb3_init_fs_context(struct fs_context *fc)
> >         ctx->backupuid_specified =3D false; /* no backup intent for a u=
ser */
> >         ctx->backupgid_specified =3D false; /* no backup intent for a g=
roup */
> >
> > -       ctx->retrans =3D 1;
> > +       ctx->retrans =3D 0;
> >         ctx->reparse_type =3D CIFS_REPARSE_TYPE_DEFAULT;
> >         ctx->symlink_type =3D CIFS_SYMLINK_TYPE_DEFAULT;
> >         ctx->nonativesocket =3D 0;
> > --
> > 2.43.0
>
> Thanks, Looks good to me.



--=20
Thanks,

Steve
