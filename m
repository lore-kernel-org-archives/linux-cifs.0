Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795107871;
	b=l0vxe5VrRvsxIl6WNR7hKaj+gE51Lcb6E9VWvTLKA4WE/yMsKyKkrbbDTeU8fqOigXg+
	 Rmo8UoynGq/SIt7zztjG8Ns1GGmuN42HciYgbrQhDZXVjV4/rSr+vorW2XPvc6b7QxT3F
	 FzSUnP7VQrtnhurYaQWDYVrs9ufgAchJz/N/AiwJcUhLMXWlsJ4EE6sMJuW/HIwb0Xp9c
	 tcO75kxKtPtgskFgfETT0NHu+hG6b9856NVBmmtbKZiJZ0s5RuaptQmuljGlQVnwrpBS7
	 H4bq76XTR+WyyRNhrJiSqqs0BUSEVSqBJcoVkiCE8UorOe22KyiNccRUu48Dz4F4gDA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107871;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
	b=G+3LSGOnD4Vzms5ZRZiKQbKAtNgUDNAKJWznFk20aUkMAbFv7Od1Rba1S0IE9tfFeeVr
	 0DWNP6wzu/F3AovvTTMOJoP48A2i4sFOMRAmwhwXogSgQnkL3edVwXKULGapf871A3MaC
	 nv/LlMWJMZWul5xnhBSqn7bs+VyVHFfFvXVM6ZdRrP+qCgljz6L+pfDAJKVTaRYUbnY1U
	 WuPsMqzfPd8E+xJekIaCKXfInuGnUW3MCVSWdfnlsNXtsbylnr5C/3Dn0X1lJurdvAy+k
	 Ka2ub1VP1V4OYal5DNj81KuedgKbyTMjDG8RjUMP4MoGWH35aoKGt6KQ6KfXuMqwZLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s5zc6etq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FB3606A336
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 17:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51FB3606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s5zc6etq
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6ba1e22ff4dso882480a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 09:04:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795107869; cv=none;
        d=google.com; s=arc-20260327;
        b=G5P9XoxjxnLLXh3oxQCvZqUh1PJLSQHmap2cv3DTZkVNW4AKM50s2uV9EZRkx6YbzO
         NX8ZY0Auyx6dHmcTovfmAjwOYof1zRMDEo3G0OOveKJOxQhzuL0PVRIgKJhcKvk26P0o
         P6Ewb7KpH7/DkwkJIWUBasg0XENXTekf3NB1PcNZ8pcn8x6BLGThvV6BOdqdik2yOht1
         FXIKtfx1L+txuSuhQ1a+XOKDzk717yvpOehkXivwF0I0pIpjLT1E0HxgRcLdkFVCej7i
         3GuhV1YEGukaI0GzEQWdNG94TY4Rc4R6wmj37CqzaLZKZp78sJQjHhO7U/dVG7SH6Yax
         lUpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
        fh=IIAyQfFWrxWomvXHDHmRz9HLl+4qCYZCWqvZJA0gUhQ=;
        b=qIId6qeBG+o3xmBXYiywY/8aBnblJDmXrVdEuSe54knEEkfczWJX4daMSGMsRvnGMz
         +O9UUuAfM4e6/oo0MBN7ml+cZ1/YnTDG8TBg7e76U++b5C6PlLFhkxchpGQdlir9YhPx
         ODQaNfsOd6E85cHmMiMfG7L4Mg/dhuYmKiRYQ4XNRlKSthklPYvtXACQityaiVrWacvV
         yWnpES7jKydRI5YSILc/DQVlNB505dbHXMq9+qbjyDECEBJNuRDafWwaIk/qVEdSWpZn
         BxpFXj1Nl+vXIWlwtKHxj/HsbThs8fvKO1AhFO0Nsx+inag156RbAtRykGoVa6Cb+BM1
         VCeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795107869; x=1795712669; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
        b=s5zc6etqP3GKrfiHHgIM6qRwBj4GIrrYXAc6mNtEDxVzqmttJaHCzBqV1dtIN+vio3
         Bnt6ZD+22BFWnuCnU8EfLslCEzR54XnIaMRCfU4Wp6aReVvOjg7SSEeZ++TPablfbh0l
         nWScX+/5rkWM/Hp/yZ+hSStf6OX4OY+2MyRjQ6hvynNEq3yrt2g+oozsb2uIIRwN9Z0y
         kqeQwucwtBml5gJuvt9l9W1sgy2+Q505qHa2NQnc54/JOh7uClHStUwVlxpUu36xurI8
         7fgIaULXH+3INvDRKkck+rkIPO9DQA/oiLHBMSnEoMnziJpuqf6MgQUtU78WnH6opbGH
         aXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107869; x=1795712669;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2yLuK3u1QEHTUyBs9ayIe02GiJhaVWl6gJPjVQwJ7zg=;
        b=YRfWYZSum3ObbH2ptTv7dy1fdkTO0NsoIGwqCLCheyj8nEzY2JSAJS4HNG8Q/hPHFH
         +W2g4plc0fqd8i+ozsq2lzahp7VbVrsbP1WUHBz6I3j4zUnn4QTMiHWvMV8/VJy3VYGB
         2+q0g3e0JhK+rkN//twLZcsGfcxwRUF+3BBRFypuYXTVgoT2imBJ84+JkZa9LfFUBQyn
         /vnOGoULo+LHvGHUbxZmInwdOEubqhwCwYbsV9Zlo9IwgTh6PWSQZxWdnYFwr9bioBkd
         H1rE6TTIDGyGrGa7v52GbNu7Zm8zMTmOSqwT7djqYtE80HQVO1vzVFjYJzY6mzGzFjhZ
         1iPQ==
X-Forwarded-Encrypted: i=1; AL+hErF8wKVq6n27UKiidS1ZrTIM49oCjy8AaIauMLNI7wSTF8hmL1I86TmumQM2lL8ZF11NTcTpFozCfbRX@vger.kernel.org
X-Gm-Message-State: APuU4Z/+sM8vGaen1lIfx47WXa47y2UKeQJx8Lc05QSSBG0Hu2D/N2Cs
	EJX0DdRrwfW0xo9CSDua5KQdTcyrvijtKHmdgS835xMQ4VewxRq8xoyLqgzMEwc6LGLKr+hM8hE
	j5yFNFMWsadVaIXiqOkiss/JYNcdA2D8=
X-Gm-Gg: AYBFou0emk3CisXKl/NZhEElizhvrL0SDuEOmpbivw9iHkKiFesafCzLMGPdjmXu9JH
	GGoIk8V6QLiddUHvue90zySWGJAMc1ax8iRFjCeCpylyeQI1/OPFOzYa+lGuyMLC0D/zYkCnwUj
	5XKv6FdhnfeBXBGabcUeu6rV8phWS6AU/x1jGqKlCtRruKsz5rPgALnGYoHpKBcaGVBmW6Cf8Ox
	c10w5Q15T0bVf/er0DXPUB6jo5J/piNDzACqtqf3rbBXDRB/w5nPZieSQnwpTdmJBKszAwBG0YH
	y6tJRI2921GOqXKChD6gH6tFqqvDTxlOR3uE/SZ51BFWggz3ZC5SSrAte9i7xY2mDZ6nYAq9Mve
	epoL5Rv61pBQiKLqGKH1+ais4Kr4wXAi07Eo0ieyJOrsJLIMhmhv0inQAmAQ6FKPkCRg4qUk=
X-Received: by 2002:a05:6402:15cb:b0:6b7:b872:27a0 with SMTP id
 4fb4d7f45d1cf-6b887e9b3a2mr4758592a12.21.1795107868285; Thu, 19 Nov 2026
 09:04:28 -0800 (PST)
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
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
In-Reply-To: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 18:04:14 +0100
X-Gm-Features: AclHuK_v3fdGGegcviRdfo5LNeBocqyxiM32rnjQTLwAQD9spb3t-0FSAl1IioM
Message-ID: <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: koraynilay <koray.fra@gmail.com>
Cc: Lauri Gates <lauri.gates@gmail.com>, Dave Chinner <dgc@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Christian Brauner <christian@brauner.io>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 12:00=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Thu Nov 19, 2026 at 10:59 AM CET, Lauri Gates wrote:
> > On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
> >> I really don't care if it is exposed by statx or file_attr; checking
> >> the flag through either interface will be orders of magnitude faster
> >> than using FIEMAP to iterate extents on every file to find shared
> >> extents. My concern with statx is coherency - it runs completely
> >> unlocked and so can race with operations that add/remove the reflink
> >> flag...
> >
> > Thanks, Dave and Christian. Given Christian's preference and the
> > coherency point, I'll write the RFC against file_attr, once the
> > question at the end is settled. xfs_fileattr_get() already reads the
> > flags under XFS_ILOCK_SHARED, so the new flag gets that without extra
> > work. The answer can still go stale right after the call, as with any
> > stat result: a clone that lands after the read is missed, just as one
> > that lands after FIEMAP returns is missed today.
> >
> > As I suggested on the 6th, the flag would take the inverted meaning,
> > so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
> > ("no extents shared with another file"), read-only, in
> > FS_XFLAG_RDONLY_MASK next to the case-folding flags.
>
> Hello, I don't have any say in the FIEMAP issue, but I wanted to let you
> know that, since also a mask was mentioned and your patch would be
> touching the fileattr API, there is work going[1] on for adding a
> fsx_xflags_mask that filesystem use[2][3] to advertise supported flags (o=
n
> get, like stx_attributes_mask) and users use to say what they want to
> change (on set).
> It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
> change, but I thought it was worth pointing out, especially because this
> patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MASK
> to have a way to include both legacy and newly added xflags, so
> FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).
>
> > Christian, one question on the shape within file_attr: would you take
> > the inverted flag, or would you rather keep a plain "may share" flag
> > and add a mask to struct file_attr that says which xflags the
> > filesystem reports?
>
> And if Christian chooses the mask approach, then my patch[4] becomes
> relevant.
> (in [4] I put the patch that will be sent in v5 of [1], since in [1]
> it's merged with the ptime change)
>
> (For Amir who I just CC'd, [5] is the main link for this thread)

Thanks for the CC and the link

>
> Thanks,
> koraynilay
>
> [1]: https://lore.kernel.org/all/20261115180343.576773-1-koray.fra@gmail.=
com/T/#u
> [2]: https://lore.kernel.org/all/CAOQ4uxj82K4z+2OiY5W1g7NyWAFOFjqqWnZSS3p=
rytW36j1LgA@mail.gmail.com/
> [3]: https://lore.kernel.org/all/CAOQ4uxiuJ=3DeZu28FZAUz3rpqPKqCimPxJucOn=
YYuBowvD09_Cw@mail.gmail.com/
> [5]: https://lore.kernel.org/linux-xfs/20261102193533.93690-1-lauri.gates=
@gmail.com/T/#u
>
> [4]:
> commit 0efe0de3b5cc2b767aa6e2bb9174eb05b0d818f1
> Author: koraynilay <koray.fra@gmail.com>
> Date:   Tue Nov 17 14:57:47 2026 +0100
>
>     vfs: add xflags mask to file_attr API
>
>     Add fa_xflags_mask to struct file_attr and equivalent fsx_xflags_mask
>     to struct file_kattr.
>
>     This lets filesystems advertise their support for specific xflags and
>     users specify only what they want to change, behaving like
>     statx.stx_attributes_mask:
>     - on GET (file_getattr): each filesystem fills the mask according to
>       its supported xflags, e.g. FS_XFLAG_COWEXTSIZE or FS_XFLAG_EXTSIZE,
>       and provides the values in the corresponding struct fields;
>     - on SET (file_setattr): userspace fills the mask according to which
>       xflags it wants to change, VFS validates this and preserves xflags
>       that were not specified in the mask;
>     - if xflags_mask =3D=3D 0, use legacy full-struct replacement to keep
>       compatibility with older programs.
>
>     Furthermore, add the missing FS_XFLAG_PROJID flag, to allow userspace=
 to
>     set the projid using file_[sg]etattr().

Correction. usersapce can already set projid using file_[sg]etattr().
With FS_XFLAG_PROJID in fsx_xflags_mask, chattr -p <projid>
could set the projid without having to read and set all the other xflags.

>
>     Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from accept=
ing
>     FS_XFLAG_PROJID, add an FS_FILE_ATTR_XFLAGS_MASK to support new xflag=
s
>     and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
>     validate that the xflags passed in fa_xflags and fa_xflags_mask field=
s
>     are valid.
>
>     Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
>     Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c           | 46 ++++++++++++++++++++++++++++++++++++++++++=
----
>  include/linux/fileattr.h |  5 +++++
>  include/uapi/linux/fs.h  |  3 +++
>  3 files changed, 50 insertions(+), 4 deletions(-)
>
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 833e03810b24..56ea65f790f1 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -102,10 +102,18 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>                                   struct file_attr *fattr)
>  {
> -       __u32 mask =3D FS_XFLAGS_MASK;
> +       /*
> +        * fsx_xflags_mask contains only flags added after the
> +        * file_[gs]etattr() API, so we need to tell userspace the filesy=
stem
> +        * actually supports all legacy (FS_XFLAGS_MASK and FS_XFLAG_PROJ=
ID,
> +        * which lacked its own bit) and new advertised flags.
> +        */
> +       __u32 mask =3D (FS_XFLAGS_MASK | FS_XFLAG_PROJID | fa->fsx_xflags=
_mask) &
> +                    FS_FILE_ATTR_XFLAGS_MASK;

This is not exactly how I envisioned exporting fa_xflags_mask.

fa_xflags_mask =3D=3D 0 means old kernel or unmodified fs.

For a new kernel with fs that supports flags other than
FS_XFLAGS_MASK it's the fs responsibility to advertise its supported
flags.

Something like:

     __u32 mask =3D (fa->fsx_xflags_mask ?: FS_XFLAGS_MASK) &
                              FS_FILE_ATTR_XFLAGS_MASK;

     memset(fattr, 0, sizeof(struct file_attr));
     fattr->fa_xflags =3D fa->fsx_xflags & mask;
     fattr->fa_xflags_mask =3D fa->fsx_xflags_mask ? mask : 0;

Then you can add filesystems that support get/set of new
attributes without support for legacy attributes.

And specific filesytems could opt-into the set of an individual
attribute like projid by advertising
fa->fsx_xflags_mask =3D FS_XFLAGS_MASK | FS_XFLAG_PROJID
or a subset thereof.

And I am still on the fence wrt should API also advertise the
fsx_xflags_ro_mask in addition to the supported mask.

The advantage being that it makes the interface symmetric.
User can alway setattr() with the buffer they got from getattr()
and instead of randomly ignoring flags in set, the fsx_ro_mask
along with fsx_mask defines the behavior exactly.

Thanks,
Amir.
