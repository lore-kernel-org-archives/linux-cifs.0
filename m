Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0625A640
	for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 08:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879673; cv=none; b=iyL7ff9MTlozk4WCEKgVPcUSJPkLiHAx+d/Exj19RNkyDTemEvgIJ7Rtl3Ep0SWbKB0gu1NUEGqLhzIltEYVz7wqcyQwcCmeWLHVesPfpOxEV40PKRCkdegIgz0j5nyoIHPR3dqEBK2iGlTZ9D3bS1Dabml442/5RMJgaVsm/BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879673; c=relaxed/simple;
	bh=Q1ZUZj0TrDvLlUjGc+rPtgZLtX4k62OwUnwSY/hrXRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mg9iBxG+BAAOIowaN1U3sCQXkroOcEqRLay4XvrxVt800Mr4GJ25qinSzJS5zQbdEaKxvJ64fHINSOjpGCJIka1SZssBB/TrML4ySEzzpHXLxDyRORyhEZisSm1uI0SPf0VQflggozH6mo+rbxs7TvZj2qywX3JdXuQ4nWnlRbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2x228TI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2x228TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9E51F00898
	for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 08:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791879671;
	bh=5SAhQTaNcMRtwja2o2FkzgaQHUx4Xm89yldxtGSqLPo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=R2x228TI75y6UxuHW9L8DtwrBHn6fPmvy7PfbPNbsQH7o5IxsWPYrhK7nhIoTpCqE
	 MPjeFrjkdAu8MYGJx6hzBuZQbZfsTob6gdI24gYXFKlYomWS2RdP1+B3u1qPcp0HkJ
	 PC6olCpyQQFEoZ53Yg2XGdNd7h00MMCoG0VVBNd2+zNv9NyUHYm8R9qadSKBMEMfBS
	 gZwBXM/KOjkgWTWWTvMpu5zGffDVA0ZyHdI6D8diwcJpoj2PHTr6u3tDJt9sVddfbS
	 yneiazf4LX80BAbWd2KldfdGMQe412RZ1xhKHRnRnYDLsRTgtojI9cWSFsUOtSIRoH
	 qpQr6P7AhIUsg==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2e6df2742cso396635366b.2
        for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 01:21:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwLjjzTr2NoAvgx1mfl0vxEdY2n03POWpDMVJILRctBjCNqX5beBj5V9hHEULwNcXdb3QRaHNmQN56i@vger.kernel.org
X-Gm-Message-State: AFq9FYLcVAv874fBd8e+zLnhFAa/CXeW8+wpyyFQQZMIWl3doTY8kj22
	x3cSvuYQpzdDhYVT5YeB83a1EeVlCoDIrVQhozDV4Xv6nynDV6NV6xxyHF0MZ7EHhypzLhSgGFg
	CFsSz9GPlHo69EhU/xD7awjcuM7wsP/0=
X-Received: by 2002:a17:907:f447:b0:c2a:f7f2:b732 with SMTP id
 a640c23a62f3a-c31aa0bee0emr1110425866b.45.1791879670217; Tue, 13 Oct 2026
 01:21:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821214722.q7rkflclyyugdxll@pali> <20260825230622.24617-1-pali@kernel.org>
 <20261012141053.4ud5pihrtrxpkxfy@pali> <CAKYAXd_FP7F1U_ETWx+0QKwpDuEFp=UJzhMjrSmuT9uG3nAxEA@mail.gmail.com>
 <20261013065503.rndxu2qxauehudil@pali> <CAKYAXd90dbd9p8uh3nyT_e=gr=P9qQeJd5TE0=+K4+gV2-JG8w@mail.gmail.com>
 <20261013081145.fel4juluk55wbfcy@pali>
In-Reply-To: <20261013081145.fel4juluk55wbfcy@pali>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 13 Oct 2026 17:20:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-9uMpHwNbBt4BSX5cAvskyS8VQHFHEe3aDrku4q5=qvQ@mail.gmail.com>
X-Gm-Features: AclHuK_dcoG_ib47_Oc26vv2pWJkb4SC1Rp4Ic7hZ9hULapm9B-_1uLt_FN3jiE
Message-ID: <CAKYAXd-9uMpHwNbBt4BSX5cAvskyS8VQHFHEe3aDrku4q5=qvQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] Various changes
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 5:11=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Tuesday 13 October 2026 16:56:30 Namjae Jeon wrote:
> > > PATCH 8/9 comment 1 - unbound memory allocation based on symlink leng=
th
> > > - this is valid, but unfortunately all the symlink parsing code would=
 do
> > > similar thing. And we have already more symlink types. Do we have som=
e
> > > limit how long could be symlink? Does it make sense to address only t=
his
> > > one issue and let all other untouched? I would rather propose to defi=
ne
> > > one common limit and fix this issue on all places.
> > I agree that a common limit is preferable. cifs.ko already has
> > REPARSE_SYM_PATH_MAX(4060) for native reparse symlinks.
>
> Lets this for followup change.
>
> > >
> > > PATCH 8/9 comment 2 - fid.netfid initialization - I'm not sure here.
> > > I had an impression that this is a right pattern how to open and read
> > > file. Can somebody else recheck this?
> > For smb2, open() sets persistent_fid and volatile_fid, but not netfid.
> > Therefore, .netfid =3D fid.netfid reads an uninitialized value.
> > smb2_sync_read() uses the persistent and volatile IDs instead, so the
> > .netfid initializer is unnecessary and should be removed in PATCH 8/9.
>
> Ok. So this would be also simple change to just remove .netfid setting.
>
> > +               io_parms =3D (struct cifs_io_parms) {
> > +                       .netfid =3D fid.netfid,
> >
> > >
> > > PATCH 9/9 - masking sync_write error by -EI - This looks to be valid.
> > > The fix is simple, just adding "rc &&" before "bytes_written !=3D".
> > Okay. Thanks.
>
> So just these two simple fixups are from the sashiko review, right?
For now, yes. If you send the next version, there may be different
review opinions from Sashiko.
