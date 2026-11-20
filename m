Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795153941;
	b=TeGhoGYZEMfRobZ8f+dXHwhyXodadgI2NCpihu42I0O6tK7kaS7R6LRPBOpQi5Uw6tdD
	 QoK+jZ2wXo75qQ83euIhLn8XIDL+1PRYsbdW053hS6RERyAjIoWJTO51MvB10JiGlzA5g
	 ExVPEKRLmcrKnHmMkN6iEVlvagmyxtKjX2kQCH39qFLz6UIsUJSbJcWrd9Ny1FwvLdl2l
	 QwgCRD4/Ez+5PMowssUlszvI1fOznf/V4mvr2jYY6TipAD1QWONRtQ2QX/z0AR/y+pq16
	 dov9IkLl593Gm92/7f0QuxRAxp1Xj/XgADNvhse2pGMtZM+yODSwLM2n/sj7bZHYIhA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795153941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qqjvXkHLWKlzcTbLqLrZX5sRTWJ1QjhTUD6O+HEdyZk=;
	b=e8bCVOY/j7hfze3VbMvRVbK7Aj0/RQhcz/7xvMZYzUwnZ9lkBdSWxVvGNhVDNe8Inedz
	 TAArbpNqURvT6RI2ODiyOeAXMyOTb377EXtcXJFx7TQ9crYFmZJdsRB3dq1hC9kNJDUm0
	 XuVl/+bZ0iV9Jplwhuv2kqLVmpWI6ntEhKnWpSc0bsed17c5vC255KYFkim5I+QHwzYKx
	 G5zr58+L75J57y0rvgZFKm0yDy2eWPq09yXz75CpYjCEnwm4lmBB388PRwG3kZGTlAowV
	 xWluICeOxPaXGCaF+frCAnpEcZ1iInNk2KcHPRsiXyDrl4Jk/xfaX3oE5oc3DXZYacw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wmhJsyO7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B139606A32A
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 05:52:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B139606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wmhJsyO7
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b8815693e2so615117a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 21:52:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795153939; cv=none;
        d=google.com; s=arc-20260327;
        b=a3Mavk54GU4Uu4tiZM6rHQ5AX3vcrCtvMC/d7QQaHelcdK2ojfNL5I9tblR93Gv+hs
         7XO8q0j+/3q04UhT45RSKvLA/tAmvsVuYAiNEfWWPwXwBznfi/aXjvIZj74+lPyUCtzs
         IBEksl61vgj/1yPfW8Au7U7tztsiFq0ZGi+FFULpEwVHetkx8VkBVv/oTll0ZCvXx5c5
         gbUNTK94ZLOFioqk/1s5Fj36HoF0qLBSMxBwE9MYHUVVKFVxFtaJX1p2i0WhlMRs3jhj
         qMgC7AtgpbKtXeciUasyK1z0b2pBYD8pFx7ldhTkAu1a29hqBdmYKGCOlLGENTKYXLxe
         myhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qqjvXkHLWKlzcTbLqLrZX5sRTWJ1QjhTUD6O+HEdyZk=;
        fh=AlrmHFBBtPw8hIe+w/Lnzwo2e0HxfOiPmZV7GLxw2Z8=;
        b=AoPWCpes8+INIa2/zww3qCEnOJwrOtZnDi3NoxpkJmHbVH7vzUTiNSA1e/kMSuq7ED
         gUYTk3BOCNqypudWZY+Ne1O+1BIWwX5SVsphr3UnXCZwf0i2ZbKnq7liiXyoyOYjbQO0
         LdrX4kLqFcWrMF/w11S549sbD8I3p8UdnmBlNFkh4IqPr1BaFfZ41YC0+UhZPpVa/mE2
         /rCyMHe4Jtq7CwM0wDCRUAZCHdrj9v+3PttmeP3q8UIJLSqRBjipVwOJFAwztfVkuxNy
         5D/rsXnIxoEo/9aGN60KCnSRTKJi1qnjP+XaaxMxXZ6Jadov5EN719DEu4qyG9d+8FFQ
         V3Lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795153939; x=1795758739; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qqjvXkHLWKlzcTbLqLrZX5sRTWJ1QjhTUD6O+HEdyZk=;
        b=wmhJsyO7LXdtpOpN24yz8CRlOs4eSWNNVUOkZBY1tRFNTzDNjI6Vw/tltKajtxSSIy
         Z3RSrwlw2aN/7KOYSfwDmqv/8SZU9suzpStUneQeV26W3+gjUXaT/43AtR5t3so2X6OM
         KwcpyDeJ7+tuJ1CjehvUB6DAqJHDcpttecgsOgCwjbgXA4g123JxS+D5EPNithQ2Vsh5
         oBFbPBCrEuIbxdLL43qGPGkV3VoSMohUPHkEr/exxAgsRXzctsEwj7ghRkD5WmkbM/iT
         Ed+zlZcsMUS6AswLDEKiA5Nf3s4lcw/0GIiI9ofVSYoVfZo2ApeBHY/UhbOE3KbcvPxL
         8Uxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795153939; x=1795758739;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qqjvXkHLWKlzcTbLqLrZX5sRTWJ1QjhTUD6O+HEdyZk=;
        b=aNTDhwBbuf414qq9+9f/nKzywv+s+Ut+rjdlDA35zIK8QIE5ahHS0bMpjwnUV5YiRz
         BAlDgdoTRTLk5sR0Mlr4nW6enzoEH325AXhXxYNxd+32sTLqbGmctA6otTqwcoDiIm9n
         LVt48Q01eLRqmGbLRP6w4XNkMYeZ2Sjp/v+XWOQfXZHoCY2FeDGBFV0aKzg8tXeFc2as
         +uKKszY7JwtfjSrHn4O7X9VhKctr4ZgrXY5t1WgrBNXOrVcwSjk9L5Sp9tgxKKKNOy9S
         ATOD6e0EZbe/XPbSp+/0SzVqUo4LhTLN7JSnYnHqgRydF6Nu547XI08lsdmztmVpEdvJ
         HMIQ==
X-Forwarded-Encrypted: i=1; AL+hErFAu8b0Vz6MTWa5sLqkLz6yGMFQrKdXABKCvvwAAZxjstcaAUhif5ZgQ7e9jvyeQTLlgPlvOnYyYOJx@vger.kernel.org
X-Gm-Message-State: APuU4Z/rxDEhEi1zgDfkDs27wlLhkaQTnzEIK1xNKpPtuARIZZYokvEV
	Pbvt62zPdlfb3kYoeRTT+zpRssiQQ/pFqmcLF20XZX3ffCaAAsyAUSJ5wHvqnyakr7QVFOdj7QT
	Q/ZwkS3lL8g0j2F3Bz+jEIoPwkJwcsR8=
X-Gm-Gg: AZFdTZfC2rUOPtGx0+PQ+NWZEdF/H7irMfh8DD2iUIZkgKC/SxXPdolrF9uZiNY/AD4
	app5o2CBy/6lrbQOtrk/vFcOjeQccAz44EA79+cTJxMlv7ap4sPznCTZovslLoH6XenrgqxBODq
	B+BjEtWFYPLAg0uJKczHpeqgrTyJVDT0huRlMc6O1FM4a8V+aVRjH31BSBWcmDoIPXKLPtkp23G
	CICu0jgtSb2ec6HWboF9dfbB3TS6Reh1XNj9vJkE9NEPfaK3MZoseh+3THo8DjhSslekoMxTJzG
	AiY8Lmp5bWw7fYqZyuFla61NJTQNOFCpo56SdcCVnDJBnfhXkxceEA79JHtpznGe8rTl7RRdMTO
	4a5HXNP8Xr7K60+nOB8SJ7qpq7YGIpomLnTcjmpNKjZEFEeRt11X7ST0/Fd2+wngZw03MWk+b1d
	MGozwD5eEWiCJ0MLk=
X-Received: by 2002:a05:6402:c4e2:10b0:6b8:8131:4fc3 with SMTP id
 4fb4d7f45d1cf-6ba37d5c08dmr826270a12.8.1795153938406; Thu, 19 Nov 2026
 21:52:18 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <av4Hn9u80fs8iHZ6@dread> <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com>
In-Reply-To: <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 06:52:07 +0100
X-Gm-Features: AclHuK-YsoPheARTk1Y-k0Sf7l8kI7S9AqS3vA0HZDdsJRePZdUYZxVxtnQosZU
Message-ID: <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: koraynilay <koray.fra@gmail.com>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Christian Brauner <christian@brauner.io>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 11:21=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Thu Nov 19, 2026 at 6:04 PM CET, Amir Goldstein wrote:
> > On Thu, Nov 19, 2026 at 12:00=E2=80=AFPM koraynilay <koray.fra@gmail.co=
m> wrote:
> >>
> >> On Thu Nov 19, 2026 at 10:59 AM CET, Lauri Gates wrote:
> >> > On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
> >> >> I really don't care if it is exposed by statx or file_attr; checkin=
g
> >> >> the flag through either interface will be orders of magnitude faste=
r
> >> >> than using FIEMAP to iterate extents on every file to find shared
> >> >> extents. My concern with statx is coherency - it runs completely
> >> >> unlocked and so can race with operations that add/remove the reflin=
k
> >> >> flag...
> >> >
> >> > Thanks, Dave and Christian. Given Christian's preference and the
> >> > coherency point, I'll write the RFC against file_attr, once the
> >> > question at the end is settled. xfs_fileattr_get() already reads the
> >> > flags under XFS_ILOCK_SHARED, so the new flag gets that without extr=
a
> >> > work. The answer can still go stale right after the call, as with an=
y
> >> > stat result: a clone that lands after the read is missed, just as on=
e
> >> > that lands after FIEMAP returns is missed today.
> >> >
> >> > As I suggested on the 6th, the flag would take the inverted meaning,
> >> > so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
> >> > ("no extents shared with another file"), read-only, in
> >> > FS_XFLAG_RDONLY_MASK next to the case-folding flags.
> >>
> >> Hello, I don't have any say in the FIEMAP issue, but I wanted to let y=
ou
> >> know that, since also a mask was mentioned and your patch would be
> >> touching the fileattr API, there is work going[1] on for adding a
> >> fsx_xflags_mask that filesystem use[2][3] to advertise supported flags=
 (on
> >> get, like stx_attributes_mask) and users use to say what they want to
> >> change (on set).
> >> It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
> >> change, but I thought it was worth pointing out, especially because th=
is
> >> patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MAS=
K
> >> to have a way to include both legacy and newly added xflags, so
> >> FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).
> >>
> >> > Christian, one question on the shape within file_attr: would you tak=
e
> >> > the inverted flag, or would you rather keep a plain "may share" flag
> >> > and add a mask to struct file_attr that says which xflags the
> >> > filesystem reports?
> >>
> >> And if Christian chooses the mask approach, then my patch[4] becomes
> >> relevant.
> >> (in [4] I put the patch that will be sent in v5 of [1], since in [1]
> >> it's merged with the ptime change)
> >>
> >> (For Amir who I just CC'd, [5] is the main link for this thread)
> >
> > Thanks for the CC and the link
> >
> >>
> >> Thanks,
> >> koraynilay
> >>
> >> [1]: https://lore.kernel.org/all/20261115180343.576773-1-koray.fra@gma=
il.com/T/#u
> >> [2]: https://lore.kernel.org/all/CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZS=
S3prytW36j1LgA@mail.gmail.com/
> >> [3]: https://lore.kernel.org/all/CAOQ4uxiuJ=3DeZu28FZAUz3rpqPKqCimPxJu=
cOnYYuBowvD09_Cw@mail.gmail.com/
> >> [5]: https://lore.kernel.org/linux-xfs/20261102193533.93690-1-lauri.ga=
tes@gmail.com/T/#u
> >>
> >> [4]:
> >> commit 0efe0de3b5cc2b767aa6e2bb9174eb05b0d818f1
> >> Author: koraynilay <koray.fra@gmail.com>
> >> Date:   Tue Nov 17 14:57:47 2026 +0100
> >>
> >>     vfs: add xflags mask to file_attr API
> >>
> >>     Add fa_xflags_mask to struct file_attr and equivalent fsx_xflags_m=
ask
> >>     to struct file_kattr.
> >>
> >>     This lets filesystems advertise their support for specific xflags =
and
> >>     users specify only what they want to change, behaving like
> >>     statx.stx_attributes_mask:
> >>     - on GET (file_getattr): each filesystem fills the mask according =
to
> >>       its supported xflags, e.g. FS_XFLAG_COWEXTSIZE or FS_XFLAG_EXTSI=
ZE,
> >>       and provides the values in the corresponding struct fields;
> >>     - on SET (file_setattr): userspace fills the mask according to whi=
ch
> >>       xflags it wants to change, VFS validates this and preserves xfla=
gs
> >>       that were not specified in the mask;
> >>     - if xflags_mask =3D=3D 0, use legacy full-struct replacement to k=
eep
> >>       compatibility with older programs.
> >>
> >>     Furthermore, add the missing FS_XFLAG_PROJID flag, to allow usersp=
ace to
> >>     set the projid using file_[sg]etattr().
> >
> > Correction. usersapce can already set projid using file_[sg]etattr().
> > With FS_XFLAG_PROJID in fsx_xflags_mask, chattr -p <projid>
> > could set the projid without having to read and set all the other xflag=
s.
>
> Oh right, thanks, I'll fix it.
>
> >>
> >>     Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from acc=
epting
> >>     FS_XFLAG_PROJID, add an FS_FILE_ATTR_XFLAGS_MASK to support new xf=
lags
> >>     and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
> >>     validate that the xflags passed in fa_xflags and fa_xflags_mask fi=
elds
> >>     are valid.
> >>
> >>     Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
> >>     Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/file_attr.c           | 46 +++++++++++++++++++++++++++++++++++++++=
+++----
> >>  include/linux/fileattr.h |  5 +++++
> >>  include/uapi/linux/fs.h  |  3 +++
> >>  3 files changed, 50 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/file_attr.c b/fs/file_attr.c
> >> index 833e03810b24..56ea65f790f1 100644
> >> --- a/fs/file_attr.c
> >> +++ b/fs/file_attr.c
> >> @@ -102,10 +102,18 @@ EXPORT_SYMBOL(vfs_fileattr_get);
> >>  static void fileattr_to_file_attr(const struct file_kattr *fa,
> >>                                   struct file_attr *fattr)
> >>  {
> >> -       __u32 mask =3D FS_XFLAGS_MASK;
> >> +       /*
> >> +        * fsx_xflags_mask contains only flags added after the
> >> +        * file_[gs]etattr() API, so we need to tell userspace the fil=
esystem
> >> +        * actually supports all legacy (FS_XFLAGS_MASK and FS_XFLAG_P=
ROJID,
> >> +        * which lacked its own bit) and new advertised flags.
> >> +        */
> >> +       __u32 mask =3D (FS_XFLAGS_MASK | FS_XFLAG_PROJID | fa->fsx_xfl=
ags_mask) &
> >> +                    FS_FILE_ATTR_XFLAGS_MASK;
> >
> > This is not exactly how I envisioned exporting fa_xflags_mask.
>
> This is exactly why I CC'd you :D
>
> > fa_xflags_mask =3D=3D 0 means old kernel or unmodified fs.
> >
> > For a new kernel with fs that supports flags other than
> > FS_XFLAGS_MASK it's the fs responsibility to advertise its supported
> > flags.
> >
> > Something like:
> >
> >      __u32 mask =3D (fa->fsx_xflags_mask ?: FS_XFLAGS_MASK) &
> >                               FS_FILE_ATTR_XFLAGS_MASK;
> >
> >      memset(fattr, 0, sizeof(struct file_attr));
> (I'm sorry, but why memset if we assign the fields right after?)
> >      fattr->fa_xflags =3D fa->fsx_xflags & mask;
> >      fattr->fa_xflags_mask =3D fa->fsx_xflags_mask ? mask : 0;
> >
> > Then you can add filesystems that support get/set of new
> > attributes without support for legacy attributes.
> >
> > And specific filesytems could opt-into the set of an individual
> > attribute like projid by advertising
> > fa->fsx_xflags_mask =3D FS_XFLAGS_MASK | FS_XFLAG_PROJID
> > or a subset thereof.
>
> I agree, this is definitely better.
>
> > And I am still on the fence wrt should API also advertise the
> > fsx_xflags_ro_mask in addition to the supported mask.
> >
> > The advantage being that it makes the interface symmetric.
> > User can alway setattr() with the buffer they got from getattr()
> > and instead of randomly ignoring flags in set, the fsx_ro_mask
> > along with fsx_mask defines the behavior exactly.
>
> Hmm, so ro_mask would be ignored by vfs on set so users don't have to
> manually remove the read only flags, correct?
>

Correct.
With non-zero xflags_mask, internal contact masks
can be used for -EINVAL not for silent ignoring.

> Also I think I'll try writing some basic userspace programs that use
> this API and see how I'd expect it to be.
>

Don't write programs please contribute to chattr (e2fsprogs) and
xfs_io (xfsprogs). The latter already support the new syscalls, the
former not yet.

>
> Anyway, I think it would be better to split the _mask change into its
> own separate patch series, so it can more easily be used by this shared
> extent patch and it's easier to reason about the API when it's
> disconnected from the ptime/btime change.

Agree.

Thanks,
Amir.
