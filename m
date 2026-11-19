Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795126210;
	b=34Z3c8WJNSszEZ3+n6syJwHJm5OffhoHczlZoqGIVO1A0Ly0ADCv3Ij+TIoo2KRmpbZn
	 qZgRTzXu4DIN26ecot4nUkyvDJeK6/+qYIDrTR9uVHhSjyCJRV2Rb66Rrh5EM+Ob8KrHA
	 ls/VJg6GgS2UTmKGCwpu+hV/0ls50sAfONJbnWiER0TCcluR0D8ZPJpVHXatdB1521E7B
	 KoeANJegRTpRw2Rq/n2iFB/dYTFkdfKWlEBtOrOyq4AGJoPXcZlow1y4XUrct4h+iLttz
	 n7yhE11GhBO4iJTFJqCRe44iAn+nEhGXvmoYS/LQIFP4XiAevl5ReUoPvY6GqGx5Eaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795126210;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=XrQlXENkswmdOJaF0OEDBush4tY7hFip+Dmv215gdyM=;
	b=Uvn3YwIFXVzMSVMp30MmBSBDNn+YZ4TbbSxzApeRqzWEdgYjhiqCvHl3Ujz2GKFysrrw
	 zl2ovQuByqRADLNGtd5Hotmcf7dNg4HnvxU4zpNmKloCletTl9qQaNnkBuXT7L/pVpQN1
	 mjQgkn0ipPb9cEwvOOoJjRNvHvB03ptIKafMCpJu7+QuxWtV90f1wNiAdq+Itub7U3fqD
	 X5YQtUWqZBGj35Rs3i4Ma8cXU8YrU21ezTcXcyhjTA7xA+jRVlv4vK1L8CAlVJ0RdhpyA
	 reU1lOw3V3/RCiHjZ1dEiTAAn41EKGuzNYsm0JGO0aZk+cL6nR99HRcGIgUFoW+FC7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xtUBIJ29;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570F60A2605
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 22:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4570F60A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xtUBIJ29
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso1460435e9.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 14:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795126207; x=1795731007; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XrQlXENkswmdOJaF0OEDBush4tY7hFip+Dmv215gdyM=;
        b=xtUBIJ29oXmT3fjfopm3egaeNyVokeFHzGOW0CI+5zft7Q7cl9Yoz9f6Ie+jh6DjfK
         ceUxZ7jBcWsHyO1ACk1FMnrI8Bfq5eN4tYmVFPHumuU14uLbehBJ4GyxVc7LjDd4FCHj
         jZOXZgvWGYiQNRXS4pFtD6dkNari6rdPtF8cTfgmfuwhfDwjoTeOwZHNX2jqL+/cPzzQ
         OzHxuWgytEa2a1cXQfiejxRIxpzIeG5DYYX/BNWmGiX6s3N4LgoV1AePKP5Dyvu/XyUg
         fk0UKJ2CKqYWOlTSU4l6XfV7IxrrAwj5OpILl4eG8ydFPjVfHad6YcVmQnfxEQfYQVf/
         dl2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795126207; x=1795731007;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XrQlXENkswmdOJaF0OEDBush4tY7hFip+Dmv215gdyM=;
        b=auyxY4kgjaFk+UV8SqyWfI5BxGA1BOkSQ2fJDwAPdtoGZss21jSkZoA4GXlGWZeatU
         eGzKa4zNdeq/RdZr3t13RJNXipio9K/o46fKAV2WppxEaCrKe8QPRdWb0PzFJNJSfwa9
         KQZmTRBMRk8hrs4IATwob9bI7aLL9i6EfjiAvqYiyQYshWbzeSgjcV3AgQLOG19Jg5qk
         vnJZQC8EfuDoyREaIOy8YelRQ/IB2ziiGPnqeukEW7CXEoxqjav+/sLS7/CLPfgDq12x
         w2x3cvy4lEUZiu0PONQpCYzaevfbPoyNid03VWCjJBDS+iOHa1eM0ScBSc3ngSNP3ljR
         KQfQ==
X-Forwarded-Encrypted: i=1; AL+hErGpoT8aBBZ2DKv3FYxkBswLAmgFldXVpW3r0TIDAtUyBNe9v8NGdauFw/6GOAyc/1nyQJh4CMbrKwoa@vger.kernel.org
X-Gm-Message-State: APuU4Z996zN6EQF3iN8j3pS4/+fnQCqASzKKOYMfo0BXCwZdIbNhpCu4
	ITucaDSJQxu2HTc2T4z9D80fznBT5K3Qg+4+5HFrz1Rg9B4YwNmo4ucQ
X-Gm-Gg: AYBFou3jgDn/FPQIPpjHlVRimz03+VWJf+WP2IMGS5+CrSPy34BaVf6+ggTPk7H3+2m
	TST552/8hrj2tGc/eb+b8qXDDX7xujVA4T9R2OpcH6KVI/pZt3P5G1CL6XAXygNbTe5sWMJ1hYp
	qL6maKzabpKA5IAJCrIIAUoP91zwdoUYj5W+pcCI2UYeLdP5VWrpReCnkn0JnYCbASeIZZ0noFN
	tqSGoktbLtiElsvsH20auWvH76gNQ521XK2HT5dWecu5Jc5zPFohydU3Q0QA5NSEO1kaKyEvYBK
	4FW3JFvLQHweHasRx+0wbIYelvIzDOO0/j3JX3NbuyShew1YF+0M4JkBICHYUgTwziCiycHE727
	fx2OW3PrFs3NtC/IKhbMBSlvvBXFF1i/02OaEpqIFDvinJROoxAIOSIUxcmK9xkjMdlw5vwIPOR
	bStg0rOZSL9BQ83l2uR/xy2zMkkrEzW4wFcx6xAITIVj4c2IRc0i6lXHC2DqbRwzKj3nia6oSMl
	XltAJQUEzbBrkuh/FjmxWjVh8dNs7mCrxT66dUo0+1DGMQaOOxcXLKZgW30AFtf3DNnCBXsGOiW
	G8N/yEIPoSlvhfcFCSPCjVisOw==
X-Received: by 2002:a05:600c:46d3:b0:4bb:6687:5394 with SMTP id 5b1f17b1804b1-4bb888097b0mr22161085e9.9.1795126207129;
        Thu, 19 Nov 2026 14:10:07 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm64509225e9.5.2026.11.19.14.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 14:10:06 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=3d15f75e39637138c31b5eb6b42e208a295fb1f9999d6996307de0cb3004;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 19 Nov 2026 23:10:04 +0100
Message-Id: <DMZJ4PL1JVA4.2YEB7EPYJR5Q7@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 08/10] nfs: add provenance time (ptime) via
 FATTR4_TIME_CREATE
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-9-koray.fra@gmail.com>
 <CAOQ4uxgoNsOH82FyrCxc+qSoid_CFmbmpL0qgWFw-e8E689fFA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgoNsOH82FyrCxc+qSoid_CFmbmpL0qgWFw-e8E689fFA@mail.gmail.com>

--3d15f75e39637138c31b5eb6b42e208a295fb1f9999d6996307de0cb3004
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 19, 2026 at 7:06 PM CET, Amir Goldstein wrote:
> On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Implement provenance time (ptime) in the NFS client, as introduced in a
>> previous commit ("vfs: add provenance time (ptime)").
>>
>> Support reading ptime via statx(2) and file_getattr(), returning the
>> cached creation time when the server advertises NFS_ATTR_FATTR_BTIME.
>>
>> Implement sending FATTR4_TIME_CREATE, asking the server to persist the
>> file creation time using ptime on the underlying filesystem.
>>
>> Also add .fileattr_set to struct nfs_rpc_ops and set it to
>> nfs4_fileattr_set() in nfs_v4_clientops. Provide a generic
>> nfs_fileattr_set() dispatcher so even symlinks can update ptime under
>> NFSv4 while cleanly returning -EOPNOTSUPP on NFSv2/v3.
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/nfs/inode.c          | 27 ++++++++++++++++----
>>  fs/nfs/internal.h       |  2 ++
>>  fs/nfs/nfs4proc.c       | 56 ++++++++++++++++++++++++++++++++++++++---
>>  fs/nfs/nfs4xdr.c        | 19 +++++++++-----
>>  fs/nfs/symlink.c        |  1 +
>>  include/linux/nfs_xdr.h |  3 +++
>>  6 files changed, 93 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
>> index e0a2e92952af..2ddcfd872616 100644
>> --- a/fs/nfs/inode.c
>> +++ b/fs/nfs/inode.c
>> @@ -955,7 +955,7 @@ static u32 nfs_get_valid_attrmask(struct inode *inod=
e)
>>                 reply_mask |=3D STATX_BLOCKS;
>>         if (!(cache_validity & NFS_INO_INVALID_BTIME) &&
>>             (fattr_valid & NFS_ATTR_FATTR_BTIME))
>> -               reply_mask |=3D STATX_BTIME;
>> +               reply_mask |=3D STATX_BTIME | STATX_PTIME;
>>         if (!(cache_validity & NFS_INO_INVALID_CHANGE))
>>                 reply_mask |=3D STATX_CHANGE_COOKIE;
>>         return reply_mask;
>> @@ -978,10 +978,10 @@ int nfs_getattr(const struct mnt_idmap *idmap, con=
st struct path *path,
>>         request_mask &=3D STATX_TYPE | STATX_MODE | STATX_NLINK | STATX_=
UID |
>>                         STATX_GID | STATX_ATIME | STATX_MTIME | STATX_CT=
IME |
>>                         STATX_INO | STATX_SIZE | STATX_BLOCKS | STATX_BT=
IME |
>> -                       STATX_CHANGE_COOKIE;
>> +                       STATX_PTIME | STATX_CHANGE_COOKIE;
>>
>>         if (!(fattr_valid & NFS_ATTR_FATTR_BTIME))
>> -               request_mask &=3D ~STATX_BTIME;
>> +               request_mask &=3D ~(STATX_BTIME | STATX_PTIME);
>>
>>         if ((query_flags & AT_STATX_DONT_SYNC) && !force_sync) {
>>                 if (readdirplus_enabled)
>> @@ -1015,7 +1015,7 @@ int nfs_getattr(const struct mnt_idmap *idmap, con=
st struct path *path,
>>         if (!(request_mask & (STATX_MODE|STATX_NLINK|STATX_ATIME|STATX_C=
TIME|
>>                                         STATX_MTIME|STATX_UID|STATX_GID|
>>                                         STATX_SIZE|STATX_BLOCKS|STATX_BT=
IME|
>> -                                       STATX_CHANGE_COOKIE)))
>> +                                       STATX_PTIME|STATX_CHANGE_COOKIE)=
))
>>                 goto out_no_revalidate;
>>
>>         /* Check whether the cached attributes are stale */
>> @@ -1038,7 +1038,7 @@ int nfs_getattr(const struct mnt_idmap *idmap, con=
st struct path *path,
>>                 do_update |=3D cache_validity & NFS_INO_INVALID_OTHER;
>>         if (request_mask & STATX_BLOCKS)
>>                 do_update |=3D cache_validity & NFS_INO_INVALID_BLOCKS;
>> -       if (request_mask & STATX_BTIME)
>> +       if (request_mask & (STATX_BTIME | STATX_PTIME))
>>                 do_update |=3D cache_validity & NFS_INO_INVALID_BTIME;
>>
>>         if (do_update) {
>> @@ -1061,6 +1061,7 @@ int nfs_getattr(const struct mnt_idmap *idmap, con=
st struct path *path,
>>         if (S_ISDIR(inode->i_mode))
>>                 stat->blksize =3D NFS_SERVER(inode)->dtsize;
>>         stat->btime =3D NFS_I(inode)->btime;
>> +       stat->ptime =3D NFS_I(inode)->btime;
>>
>
> As an example of what would be needed per the mutable btime proposal,
> adding stat->ptime and STATX_PTIME will not be needed...
>
>>         /* Special handling for STATX_DIOALIGN and STATX_DIO_READ_ALIGN
>>          * - NFS doesn't have DIO alignment constraints, avoid getting
>> @@ -1092,10 +1093,26 @@ int nfs_fileattr_get(struct dentry *dentry, stru=
ct file_kattr *fa)
>>         }
>>         if (nfs_server_capable(inode, NFS_CAP_CASE_NONPRESERVING))
>>                 fa->fsx_xflags |=3D FS_XFLAG_CASENONPRESERVING;
>
> This would need:
>                   fa->fsx_xflags |=3D FS_XFLAG_CASEFOLD;
> +                fa->fsx_xflags_mask |=3D FS_XFLAG_CASEFOLD;
> +                fa->fsx_xflags_ro_mask |=3D FS_XFLAG_CASEFOLD;
> +                /* unlink other fs FS_CASEFOLD_FL is read-only */
(oh, s/unlink/unlike/?)

>                   fa->flags |=3D FS_CASEFOLD_FL;
With the new API and vfs helpers, this would need to get removed, as vfs
would already handle this for legacy ioctls, correct?

>         }
>                    fa->fsx_xflags |=3D FS_XFLAG_CASENONPRESERVING;
> +                 fa->fsx_xflags_mask |=3D FS_XFLAG_CASENONPRESERVING;
> +                 fa->fsx_xflags_ro_mask |=3D FS_XFLAG_CASENONPRESERVING;
Uhm, why both in _mask and _ro_mask? If it's a RDONLY flag shouldn't
it *only* be in _ro_mask? (same for CASEFOLD)

>
>> +       if (NFS_SERVER(inode)->fattr_valid & NFS_ATTR_FATTR_BTIME) {
>> +               fa->fsx_xflags |=3D FS_XFLAG_PTIME;
>> +               fa->fsx_xflags_mask |=3D FS_XFLAG_PTIME;
>> +               fa->fsx_ptime =3D NFS_I(inode)->btime;
>> +       }
>
> +               fa->fsx_xflags |=3D FS_XFLAG_BTIME;
> +               fa->fsx_xflags_mask |=3D FS_XFLAG_BTIME;
> +               fa->fsx_btime =3D NFS_I(inode)->btime;
>
> Fs with immutable btime could either not advertise the BTIME flag
> in xflags/xflags_mask or advertise the flag also in xflags_ro_mask.

That makes sense.

>>         return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(nfs_fileattr_get);
>>
>> +int nfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dent=
ry,
>> +                    struct file_kattr *fa)
>> +{
>> +       const struct nfs_rpc_ops *ops =3D NFS_PROTO(d_inode(dentry));
>> +
>> +       if (ops->fileattr_set)
>> +               return ops->fileattr_set(idmap, dentry, fa);
>> +       return -EOPNOTSUPP;
>> +}
>> +EXPORT_SYMBOL_GPL(nfs_fileattr_set);
>> +
>>  static void nfs_init_lock_context(struct nfs_lock_context *l_ctx)
>>  {
>>         refcount_set(&l_ctx->count, 1);
>> diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
>> index 5af6a032f145..0e47fad944de 100644
>> --- a/fs/nfs/internal.h
>> +++ b/fs/nfs/internal.h
>> @@ -458,6 +458,8 @@ extern int nfs_wait_bit_killable(struct wait_bit_key=
 *key, int mode);
>>
>>  struct file_kattr;
>>  int nfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
>> +int nfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dent=
ry,
>> +                    struct file_kattr *fa);
>>
>>  #if IS_ENABLED(CONFIG_NFS_LOCALIO)
>>  /* localio.c */
>> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
>> index e1018b03c1cb..31d58ceb4dc0 100644
>> --- a/fs/nfs/nfs4proc.c
>> +++ b/fs/nfs/nfs4proc.c
>> @@ -55,6 +55,7 @@
>>  #include <linux/utsname.h>
>>  #include <linux/freezer.h>
>>  #include <linux/iversion.h>
>> +#include <linux/fileattr.h>
>>
>>  #include "nfs4_fs.h"
>>  #include "delegation.h"
>> @@ -98,7 +99,8 @@ static int _nfs4_proc_getattr(struct nfs_server *serve=
r, struct nfs_fh *fhandle,
>>                               struct nfs_fattr *fattr, struct inode *ino=
de);
>>  static int nfs4_do_setattr(struct inode *inode, const struct cred *cred=
,
>>                             struct nfs_fattr *fattr, struct iattr *sattr=
,
>> -                           struct nfs_open_context *ctx, struct nfs4_la=
bel *ilabel);
>> +                           struct nfs_open_context *ctx, struct nfs4_la=
bel *ilabel,
>> +                           const struct timespec64 *time_create);
>>  static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp,
>>                 const struct cred *cred,
>>                 struct nfs4_slot *slot,
>> @@ -3216,7 +3218,7 @@ static int _nfs4_do_open(struct inode *dir,
>>                         nfs_fattr_init(opendata->o_res.f_attr);
>>                         status =3D nfs4_do_setattr(state->inode, cred,
>>                                         opendata->o_res.f_attr, sattr,
>> -                                       ctx, label);
>> +                                       ctx, label, NULL);
>>                         if (status =3D=3D 0) {
>>                                 nfs_setattr_update_inode(state->inode, s=
attr,
>>                                                 opendata->o_res.f_attr);
>> @@ -3380,7 +3382,8 @@ static int _nfs4_do_setattr(struct inode *inode,
>>
>>  static int nfs4_do_setattr(struct inode *inode, const struct cred *cred=
,
>>                            struct nfs_fattr *fattr, struct iattr *sattr,
>> -                          struct nfs_open_context *ctx, struct nfs4_lab=
el *ilabel)
>> +                          struct nfs_open_context *ctx, struct nfs4_lab=
el *ilabel,
>> +                          const struct timespec64 *time_create)
>>  {
>>         struct nfs_server *server =3D NFS_SERVER(inode);
>>         __u32 bitmask[NFS4_BITMASK_SZ];
>> @@ -3391,6 +3394,7 @@ static int nfs4_do_setattr(struct inode *inode, co=
nst struct cred *cred,
>>                 .server         =3D server,
>>                 .bitmask =3D bitmask,
>>                 .label          =3D ilabel,
>> +               .time_create    =3D time_create,
>>         };
>>         struct nfs_setattrres  res =3D {
>>                 .fattr          =3D fattr,
>> @@ -3414,6 +3418,9 @@ static int nfs4_do_setattr(struct inode *inode, co=
nst struct cred *cred,
>>         if (sattr->ia_valid & ATTR_MTIME)
>>                 adjust_flags |=3D NFS_INO_INVALID_MTIME;
>>
>> +       if (time_create)
>> +               adjust_flags |=3D NFS_INO_INVALID_BTIME;
>> +
>>         do {
>>                 nfs4_bitmap_copy_adjust(bitmask, nfs4_bitmask(server, fa=
ttr->label),
>>                                         inode, adjust_flags);
>> @@ -4587,7 +4594,7 @@ nfs4_proc_setattr(struct dentry *dentry, struct nf=
s_fattr *fattr,
>>         if ((sattr->ia_valid & (ATTR_MODE|ATTR_UID|ATTR_GID)) !=3D 0)
>>                 nfs4_inode_make_writeable(inode);
>>
>> -       status =3D nfs4_do_setattr(inode, cred, fattr, sattr, ctx, NULL)=
;
>> +       status =3D nfs4_do_setattr(inode, cred, fattr, sattr, ctx, NULL,=
 NULL);
>>         if (status =3D=3D 0) {
>>                 nfs_setattr_update_inode(inode, sattr, fattr);
>>                 nfs_setsecurity(inode, fattr);
>> @@ -10845,6 +10852,44 @@ static void nfs4_disable_swap(struct inode *ino=
de)
>>         wake_up_var(&clp->cl_state);
>>  }
>>
>> +#define NFS4_SUPPORTED_XFLAGS  (FS_XFLAG_PTIME)
>> +static int nfs4_fileattr_set(const struct mnt_idmap *idmap, struct dent=
ry *dentry,
>> +                            struct file_kattr *fa)
>> +{
>> +       struct inode *inode =3D d_inode(dentry);
>> +       struct nfs_server *server =3D NFS_SERVER(inode);
>> +       struct nfs_fattr *fattr;
>> +       struct iattr sattr =3D { .ia_valid =3D 0 };
>> +       const struct timespec64 *time_create =3D NULL;
>> +       int error;
>> +
>> +       if (!(server->fattr_valid & NFS_ATTR_FATTR_BTIME))
>> +               return -EOPNOTSUPP;
>> +
>> +       if (fa->flags_valid)
>> +               return -EOPNOTSUPP;
>> +
>> +       if (fileattr_has_fsx_mask(fa, NFS4_SUPPORTED_XFLAGS))
>> +               return -EOPNOTSUPP;
>> +
>> +       if (fa->fsx_xflags_mask & ~NFS4_SUPPORTED_XFLAGS)
>> +               return -EOPNOTSUPP;
>> +
>
> These two checks look semantically identical.
> I am not sure yet what you intention was with the
> fileattr_has_fsx_mask() helper - I know you had reservations about it
> but at least in this code, it doesn't look like it is needed at all.

Eh, the name is not the best, but they aren't, _mask & check the _mask
field, has_fsx_mask checks the xflags field (which is why I added the
question of keeping its name as it is or changing it to
"fileattr_has_unsupported_fsx").
But I'm not even sure we still need this helper, so I may just drop it.

Thanks,
koraynilay

>> +       if (fa->fsx_xflags_mask & FS_XFLAG_PTIME)
>> +               time_create =3D &fa->fsx_ptime;
>
> This would be BTIME/btime but otherwise the same.
>
> Thanks,
> Amir.



--3d15f75e39637138c31b5eb6b42e208a295fb1f9999d6996307de0cb3004
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCav9zvAAKCRDmj22qf5IG
XEu7AP0c9QT/KQu0eG63cpYzurcE7LoPHmzKV1r0ma0pNA660wEAz/ZrwIX/0f7l
NT9CD1fW2/fXVSRBSR06DNatdB/xhwc=
=Pvsm
-----END PGP SIGNATURE-----

--3d15f75e39637138c31b5eb6b42e208a295fb1f9999d6996307de0cb3004--
