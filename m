Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F053D1CA8
	for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768503273; cv=none; b=aaptgYjy7HrSQs9QfsAQSnL+jGKIJBtL8uQTjhgXOttLZvCcEzsu+yd6gdZacIlx+vHQ4RWFTKBC4sR9+irVNgeF1HcAfRvcILYh03Wdg+qNU6UFD45kFWa1pyqSAtkGa7ipxTNGnVIqIvIJlApy3XzQVZRcDEY88pUwsxxMM/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768503273; c=relaxed/simple;
	bh=AgB8BlDrSqCt2vWmdgQdkVNbgorviCbIMxtlMVxqyDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NB0WraPNtu3ca0Qrjj6Ei9gOGemhWlwDo9vtk+3yZ/wuNFeOBNpK7Y2Pw6CNsIZbylD5k6FxiEgfmFiDEVLgSw43x9JYdodZbMiIA+pNhhKwpGnTz6VGHtNliPJ+OQ4RSVVyoOoBJE3Lj9r2WdXByBdjQ8U8lfeu54jNFT+Dge4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MSUUWslM; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSUUWslM"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-432da746749so614622f8f.0
        for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 10:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768503269; x=1769108069; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/pIR9g5xBWqOZmQj/jDCO8xKQONNisoQQHHakrcMdk=;
        b=MSUUWslM7So/8e5qCKM9JU2cE4putYAvpi8UdtuonqryPMUNC+1PUocWSNmRX6iGft
         Llsnn4u2ChuSQFRjdQYh1n4dcKLsda/c9h8OBQlFkmYO6AbGHtLLYM0SAWhirNpaoF4n
         lakVf7f1knSaC/T5LidHJsjH0TVakBR0PiniEdlaUsoRuFln+7VFqUwQfgRz0i4x4AvS
         ZYRXMKaX2NnbWxFRzsRhO2KaJ3DxCOuFwkiLa7v70xNShq3EGNuiEqzLBa7apuvs8Ev8
         8lR89uWCNysQXzJycZ3fgJA46czSOxtOhpmR8aUQ39pBmNkdExztbB4bfrrOFL9eSKRt
         1A2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768503269; x=1769108069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R/pIR9g5xBWqOZmQj/jDCO8xKQONNisoQQHHakrcMdk=;
        b=g5rTQnUJfkHHUeQLVzPLlSW24hMucMMw6+hhjaybbJ5hatqQcUKU4sdOPOkASErUka
         kSYyT3DJd753UWhLZPMPMxhzlbu/CFSJ5S+HSaoSgg3iCB2Anh61822ojc0ZaLBAGyBB
         /gXhkd96u1fUR1aE9EldcTzSfLZ29lowIvP/VKIXdlZava66TNdho0o8EMVGRPwfEbDI
         naX3St4uToL1KAOFAJmKIC+teVtiV1A3v7FnhcF54T91RYwD7iqCkIwhMoA+JG/WKlsI
         37zH44Xw9evy9ugPCoG7EkGCoWejgy9YD4ev8+ygkj9+Ey1yEdTTNfjAzo0YDmPPHyO4
         ZYgA==
X-Forwarded-Encrypted: i=1; AJvYcCWkBKb2Ph4+oE/H5WRKzhYxoXxIZ6JesQWd9N3uou8xQ+pFXNNwnqiEzpKpPKs624fkIo6JfMyJ3r4e@vger.kernel.org
X-Gm-Message-State: AOJu0YxAPk7xWgRZ9lN4+W60tGKyMTel9cTHHCeW0Yor+nsBTkU8AJqY
	tmU1GvsUIRzOh0C+8i7/4txOaLatq7UNDQmglMXCC/jIwhNhOjW9SOO2fG3B1BxAnIZvzO1qZ16
	oaLdo9k4/EduG/GZxybDT7tjLSQU4g8E=
X-Gm-Gg: AY/fxX7zUKeGOdAUZrAo8GSzzTf/QWsJ5yVD2DOlF9MberYmXnqEAbMwL9/OWpB6C42
	wkNyytpEJ6gMF3noHxVOI8VtZbr89/6QidUcRITR04lDJRnYskZ6f+7WTqmrG9oct4uk7ktpbvy
	Tl2HXMXmvQytc7SkhnLIL8sGQsVXnh+Ts6xHzHlzeVRtnT16pbbbD4byTKjXzPTT1kCLjiAltun
	vXQNwHqRqeNHcw14wTk0rLIWpF2tZVzkcH+A7neOPHxMqJYE8mR/apmHKzYxqh/R0T4D+PMNvqy
	BIsW5qqoT6vfXSAi4Q9KeL7Hcs6tHA==
X-Received: by 2002:a05:6000:2313:b0:432:5c43:76 with SMTP id
 ffacd0b85a97d-43569bc17ebmr434376f8f.39.1768503268480; Thu, 15 Jan 2026
 10:54:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-26-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-26-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:54:17 +0100
X-Gm-Features: AZwV_QgNgqINU2MW0ct-_EKOImgQ1uAwJfq7nKBHPoIgHpyzlMCSNbXGV-6zTEg
Message-ID: <CAOQ4uxh4VaVL9PD7-_Op9Xs-z5Qrx8g6x2x5FccujQX-Cw9RqQ@mail.gmail.com>
Subject: Re: [PATCH 26/29] fuse: add EXPORT_OP_STABLE_HANDLES flag to export operations
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 6:50=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Add the EXPORT_OP_STABLE_HANDLES flag to fuse export operations to indica=
te
> that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/fuse/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 819e50d666224a6201cfc7f450e0bd37bfe32810..1652a98db639fd75e8201b681=
a29c68b4eab093c 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1208,6 +1208,7 @@ static struct dentry *fuse_get_parent(struct dentry=
 *child)
>  /* only for fid encoding; no support for file handle */
>  static const struct export_operations fuse_export_fid_operations =3D {
>         .encode_fh      =3D fuse_encode_fh,
> +       .flags          =3D EXPORT_OP_STABLE_HANDLES,
>  };

These are used when the server declares FUSE_NO_EXPORT_SUPPORT
so do not opt in for NFS export.

The sad thing w.r.t FUSE is that in most likelihood server does not provide
persistent handles also when it does not declare FUSE_NO_EXPORT_SUPPORT
but we are stuck with that.

Thanks,
Amir.
