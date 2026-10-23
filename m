Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792718600;
	b=IKGXWgV3/s3ppEZiFWip2bHK58ryHQl0xbBdrS3rqjYDgVLufhyB4GxsFtxFUbUJ+Cvz
	 ZtZzX/mcp2/Y2Kq0lGdLH5/mxYCLkF91omm8N7UFiR8ROAmHBjWmT16Jp2cu6FrQJt26r
	 1X6qopVmUx7FAm4UtQ7T4JZhjwkkb+LYUiY+yMkG3/R0BN2drEImS25j48yP+ImrQK5/V
	 O7ZEoZ8ZQI2BhVVzDMN3GzcPrgbeuLE+aGqWPzwbMYkFiHPIEXHHGgO1OBtMdmX8Ugpuy
	 D/nlZFQvR+WCQQq7IgeJwSr7P/SwZZQcOEh4FKIqHxmSccjNsmJ0/omLHzWSRglgsSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792718600;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Content-Type:Content-Transfer-Encoding:MIME-Version:From:To:
	 Cc:Subject:In-reply-to:References:Date:Message-id:Reply-To;
	bh=7cFXi0L/JdhyCBHsqgbk8A7Ch3+1Xn76JLKJNL9bMo0=;
	b=5BNdcehjYBhijRX4APBp0x1neAPtFRCcNvuXtLZodEQZSqBrm8qBF4gLek4ZHnok8CEu
	 WBsrrlQ3OXLEMO1JWqsCfy6oINoNMqZGC9U1Qsf8FAYAdl7lCM+UOLcGTwuUp1mabAsY/
	 Tp7bCe0Cr3ALdLubSAyxsE056iNgxtf/IJQ5jXWbozqL/f0v74Q2sD7hiLX1UF1zKzaAl
	 amYlISbSnm8jcmcXOMhth8uEpUzmxfRdq9K7DuiBJLUi6Ce4eCI058+2bM3EEgLKoHU+2
	 iITOJ2335E6gHDoj3U/wgt2cLgERCJVBychQGw+X9ZWrHibDSentqQ/zTguAssTHpKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ownmail.net;
	spf=pass smtp.mailfrom=ownmail.net;
	dkim=pass header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=UfZqc+3Q;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=cmsmFIxe;
	arc=none smtp.remote-ip=202.12.124.155
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C0A606A319
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 01:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8C0A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm2 header.b=UfZqc+3Q;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=cmsmFIxe
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4084E7A0173
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 21:23:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 22 Oct 2026 21:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1792718598; x=1792804998; bh=7cFXi0L/JdhyCBHsqgbk8A7Ch3+1Xn76JLK
	JNL9bMo0=; b=UfZqc+3Qrfv23fsfZc2jvmU7RuFQ/CB0TSGHl3tztznkVS9LqM7
	u7tpvfZq9C7l71qOZ+tfjia2OgBi6BVDn8ZeNRHSsWtc15OSsiGGbH4P5FmSu4XL
	hXH0IvFh4K5NEEMEykG2IpTO3rkf/uLChSXzE3/7CqFcu71j1S2uCch/nOMebIFg
	N+OY8EJpSLd8vzn8zDmmRz1lW8uy3OThMVirxrFNsUh3MkEUrDSCBmAWSIQOFR3o
	t8oB00oO5c9eveC8hTgi/InXp019gaOPxDsU8DaPRWYGqmfgsCGyBSShFyd4s7g8
	qyzvhPAs2+HQqWQF8lv1iP9Lp4vCFHAqgbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792718598; x=
	1792804998; bh=7cFXi0L/JdhyCBHsqgbk8A7Ch3+1Xn76JLKJNL9bMo0=; b=c
	msmFIxeN/qxDjXj7JHu74YT46slPjygG0V4YKZ0ulfTzTIB2SMU/d5W+9bYZQkzO
	Z9U9BDdFOc/PBjzz8vt2JlQzMpyPDoA43SKp869dWkWRNol/in13WFQu1cgMuJ4T
	g38w357DCAY3rOla4Uy16+UM4nfm2hJ13WULtrYDvfJLs0StgxJO3u6tbt23fcQf
	Xo6p1qshEEvLbT/q7KHC5zOfGHt90oLMUE7Z8lqkgmJiJ+tGGr+D4HqNkjuSmou7
	RPDcIVjqmP9RCyCiuU6Og54Yv0jjZbVzPmkY0LjmHSYon0Ndl3I1UKXdFFTRZsGT
	Fw3O4OBK3dbe6yheVRr4A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792718598; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:KtIDB0gsHEpjJ3/Yna0jdkf0LExKzuWV6UKoLnbJRMQEkaH
	weAYT5uzF2yUVH2h+tbgMHFrq7au1/9SHDnMFaykp2UMxb3VebbUdG7YwO31btEc
	XMUcFbtC8wPFQoLzxxs88cBddY5TCbJCnycnW5CphNbMsQAyAQSU04CXNplf4+tE
	nrhb6d3aYy7rXx6N2q0ytV0C5+IM1w3w6dD/cvgxZzIpfK1LZBYFPajak8CgxzLO
	Efgsl/HOAX7k+Dj5wQ6/UMNBLIaZoiz91swpJdWob/V71xNvaBDnH0caV1u8SA4H
	Pwa1LwMNIAIHAz6/XdzFnSFd97GeSfTjm4ppTpw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,reply-to,
	subject,to;
Message-Instance: m=1; h=sha256:YrN/KlqvJbuKZP5+/zhM5/JVYqXjcKZo0i2ywgzsSYM=:hXcREjO32Ld50T+nbL2hR5exmKKcdTu1Lk84ebTml1k=;
X-ME-Sender: <xms:BrfaamyaXVGxedXYMFvgKLZdAq8aTe1L7ZMtzPVKUFiRKuiY21AcQw>
    <xme:BrfaaghOoCO7v3toHGHJI6Nxnvf5DQfxG6kyXV4ot6uGHswML_FQ9ODAJltSPLV9L
    mhPyeIjLcB0yP5G9GYzXnd6wuixkDzGbhmqwAIlO7dzSeCNF5jo>
X-ME-Received: <xmr:BrfaahqtCgjZh9fnhHbqjalQDsOuvi1S_aC8Dt44_R4I5wsgak7fcHni8MR37xS_W1SwoFZgH1HHm_nUFIh0DPgIRLFJ6vs>
X-ME-Proxy-Cause: dmFkZTFOPz9kVuRAJKXCexeAqCEJ3ruIe2UMXhbQkPVg2UFXrQecH2TQP0Zr0KlAgTNkSp
    FQPdZUhOcjOrbo3H82A3HH0nhqFCKDcix67y6wDLuWb2jiToCxZBBM2lrdj+ind51vGAwU
    GR9ab9wjgvmbx6ujLCAi0MMKBZUaxKiIob5+udC4a7+6gWEoQa4Hiq3BpWTO2vf+gKIp6J
    vm4y2vlh8d5zJAhFQ4naGPAGMt1hlMHD1YJj5d/Q8aRxan9IWFa6XtjtvQuLnfb4Vf7d4K
    Cbifv+b2sOwLuGZ/kXWROmW0/wbwEzJjoyEPVRrFkHmHXubXLJQNaPaw7Uw4JI1G5sePuG
    OhD5y0oLLdgt0FqDcj++kBSuJY9geFZGVApMi9XaTOhDTzNejzdNxccn4QvU+pvqtUDbyE
    cWofaU+0T+UxBnz2W7juRDB+jnt08EV0bdc0V7KvSwBe0299ybp65cehBMq8VoAJyeMv9B
    96VdUM+iq0U9/qjH3z0cfywfuuQlBwjuPLzTgPluPvNvwIzfLwHcXPDetLYYkDXbrVUayB
    mbQNC8VW5APsArPbdFOAvJqMHCjtQdVuEjtpTemJaE/IIMPEIktQuiJr/VdwweJzA4Jtaa
    9gjf8hrA3mnx68lCNYA9Ao7nbV2k99y3PRkwZt2Hc4DF3lXZ+ihGwtIYdkqw
X-ME-Proxy: <xmx:Brfaavji7RqzwhfR13ZV_DCsuBKIsH-quVNcy4lpnxBQYhZtVaIUlw>
    <xmx:BrfaarOOn01-vrZm67Wv3971pvk2uuVoaFX5XWd9UQxuwh9rox6yOQ>
    <xmx:Brfaahz_WetjwDvrsrgntQ0787cceiiVZLYM67C9eQFVfn40mpURcQ>
    <xmx:BrfaaloApk53qIOMRg-shDhcJPwjZEd0lV1M4NJUopTm7DZWWNUA9w>
    <xmx:BrfaaqcDF_DQeZh0rDC46IK5HxHcb8X-UGBenopU5gf6-uiO-OgFxEeb>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 21:23:15 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Tom Talpey" <tom@talpey.com>
Cc: "Paulo Alcantara" <pc@manguebit.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 "Jan Kara" <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH 1/3] smb/client: don't unhash and rehash to prevent new opens.
In-reply-to: <6233e33a-e6e2-4c9d-8372-5aa75f4f3314@talpey.com>
References: <20260928012812.2890035-1-neilb@ownmail.net>
  <20260928012812.2890035-2-neilb@ownmail.net>
  <6233e33a-e6e2-4c9d-8372-5aa75f4f3314@talpey.com>
Date: Fri, 23 Oct 2026 12:23:11 +1100
Message-id: <179271859119.2068970.332034501939522955@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Thu, 22 Oct 2026, Tom Talpey wrote:
> One nit below...
>=20
> On 9/27/2026 9:25 PM, NeilBrown wrote:
> > From: NeilBrown <neil@brown.name>
> >=20
> > smb/client needs to block new opens of the target of unlink and rename
> > while the operation is progressing.  This stablises d_count() and allows
> > a determination of whether a "silly-rename" is required.
> >=20
> > It currently unhashes the dentry which will cause lookup to block on
> > the parent directory i_rwsem.  Proposed changes to locking will cause
> > this approach to stop working as the exclusivity will be provided for
> > the dentry only, and only while it is hashed.
> >=20
> > So we introduce a new machanism similar to that used by nfs.
> > DCACHE_PRIVATE (given the name DCACHE_BLOCKED) is set when lookups need
> > to be blocked.  ->d_revalidate checks for this and blocks.  This might
> > still allow d_count() to increment, but once it has been tested as 1,
> > there can be no new opens completed.
> >=20
> > Unlike unhash which does not need to be reverted on error, and which
> > must not be reverted on a successful d_move, blocking of opens must
> > always be reverted.  So we don't block the open until after the last
> > early "return", and we always unblock on the final "return".
> >=20
> > Strictly speaking it is only necessary to block opens before the value
> > of d_count() is tested under ->d_lock. But we block as early as possible
> > to discourage new opens from starting.  As open is path-based in cifs a
> > concurrent rename can be confused a rename of one other the paths.  Once
> > cifs_open() has generated the full_path it doesn't hold any locks to
> > prevent a rename from making that path invalid.
> >=20
> > The important details of the interlock between __cifs_unlink (which both
> > unlink and rename use) and "open" are that __cifs_unlink() sets
> > DCACHE_BLOCKED  *before* testing d_count() which is
> > in a d_lock locked region,  and cifs_d_revalidate() tests the bit *after*
> > ->d_lock is taken by e.g. __d_lookup() to increment d_count().
> > Thus ->d_lock provide serialization between the set and the test
> > even though the test isn't in a locked region.
> > (The fact that cifs_d_revalidate() always returned -ECHILD when
> >   LOOKUP_RCU is important for this sequencing to work as it ensures
> >   d_revalidate() is called *after* d_count() is incremented).
> >=20
> > Signed-off-by: NeilBrown <neil@brown.name>
> > ---
> >   fs/smb/client/cifsfs.h |  8 +++++
> >   fs/smb/client/dir.c    |  3 ++
> >   fs/smb/client/inode.c  | 68 ++++++++++++++++++++++++------------------
> >   3 files changed, 50 insertions(+), 29 deletions(-)
> >=20
> > diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> > index 0c85daa8386e..bcc0fb5c2c9b 100644
> > --- a/fs/smb/client/cifsfs.h
> > +++ b/fs/smb/client/cifsfs.h
> > @@ -42,6 +42,14 @@ static inline unsigned long cifs_get_time(struct dentr=
y *dentry)
> >   	return (unsigned long) dentry->d_fsdata;
> >   }
> >  =20
> > +/*
> > + * This is set to block d_revalidate on a dentry that is being removed -
> > + * the target of unlink or rename.  This causes any open attempt to
> > + * block.  There may be existing opens but they can be detected by
> > + * checking d_count() under ->d_lock.
> > + */
> > +#define DCACHE_BLOCKED DCACHE_PRIVATE
>=20
> Why the alias? The blocking behavior is reasonable but #defining a
> flag value which is purely local to this file seems unnecessary and
> confusing. What if another file in fs/smb/client also overloads the
> DCACHE_PRIVATE flag, for example. Consider removing this hunk.


I thought that giving the flag a meaningful name would make the code
that uses it easier to read. But I'm happy to drop it.
I'll resend with the IS_ERR_OR_NULL change too.

Thanks,
NeilBrown




>=20
> Tom.
>=20
>=20
> > +
> >   extern struct file_system_type cifs_fs_type, smb3_fs_type;
> >   extern const struct address_space_operations cifs_addr_ops;
> >   extern const struct address_space_operations cifs_addr_ops_smallbuf;
> > diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> > index 6fa6d48fdfd3..88fff65320f5 100644
> > --- a/fs/smb/client/dir.c
> > +++ b/fs/smb/client/dir.c
> > @@ -872,6 +872,9 @@ cifs_d_revalidate(struct inode *dir, const struct qst=
r *name,
> >   	if (flags & LOOKUP_RCU)
> >   		return -ECHILD;
> >  =20
> > +	/* Wait for pending rename/unlink */
> > +	wait_var_event(&direntry->d_flags, !(direntry->d_flags & DCACHE_BLOCKED=
));
> > +
> >   	if (d_really_is_positive(direntry)) {
> >   		int rc;
> >   		struct inode *inode =3D d_inode(direntry);
> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> > index 12ed8db10e00..4d34c5622cd4 100644
> > --- a/fs/smb/client/inode.c
> > +++ b/fs/smb/client/inode.c
> > @@ -1967,24 +1967,31 @@ static int __cifs_unlink(struct inode *dir, struc=
t dentry *dentry, bool sillyren
> >   	__u32 dosattr =3D 0, origattr =3D 0;
> >   	struct TCP_Server_Info *server;
> >   	struct iattr *attrs =3D NULL;
> > -	bool rehash =3D false;
> > +	bool unblock =3D false;
> >  =20
> >   	cifs_dbg(FYI, "cifs_unlink, dir=3D0x%p, dentry=3D0x%p\n", dir, dentry);
> >  =20
> >   	if (unlikely(cifs_forced_shutdown(cifs_sb)))
> >   		return smb_EIO(smb_eio_trace_forced_shutdown);
> >  =20
> > -	/* Unhash dentry in advance to prevent any concurrent opens */
> > -	spin_lock(&dentry->d_lock);
> > -	if (!d_unhashed(dentry)) {
> > -		__d_drop(dentry);
> > -		rehash =3D true;
> > -	}
> > -	spin_unlock(&dentry->d_lock);
> > -
> >   	tlink =3D cifs_sb_tlink(cifs_sb);
> >   	if (IS_ERR(tlink))
> >   		return PTR_ERR(tlink);
> > +
> > +	/* opens might already be blocked by rename */
> > +	if (!(dentry->d_flags & DCACHE_BLOCKED)) {
> > +		/*
> > +		 * Block opens - and all lookups that involve d_revalidate.
> > +		 * This guarantees that if another thread tries to open(), it
> > +		 * will either block, or will increment d_count()
> > +		 * before we test it below.
> > +		 */
> > +		spin_lock(&dentry->d_lock);
> > +		dentry->d_flags |=3D DCACHE_BLOCKED;
> > +		spin_unlock(&dentry->d_lock);
> > +		unblock =3D true;
> > +	}
> > +
> >   	tcon =3D tlink_tcon(tlink);
> >   	server =3D tcon->ses->server;
> >  =20
> > @@ -2107,8 +2114,13 @@ static int __cifs_unlink(struct inode *dir, struct=
 dentry *dentry, bool sillyren
> >   	kfree(attrs);
> >   	free_xid(xid);
> >   	cifs_put_tlink(tlink);
> > -	if (rehash)
> > -		d_rehash(dentry);
> > +	/* Allow lookups/opens */
> > +	if (unblock) {
> > +		spin_lock(&dentry->d_lock);
> > +		store_release_wake_up(&dentry->d_flags,
> > +				      dentry->d_flags &~ DCACHE_BLOCKED);
> > +		spin_unlock(&dentry->d_lock);
> > +	}
> >   	return rc;
> >   }
> >  =20
> > @@ -2536,7 +2548,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode =
*source_dir,
> >   	struct cifs_sb_info *cifs_sb;
> >   	struct tcon_link *tlink;
> >   	struct cifs_tcon *tcon;
> > -	bool rehash =3D false;
> >   	unsigned int xid;
> >   	int rc, tmprc;
> >   	int retry_count =3D 0;
> > @@ -2552,20 +2563,20 @@ cifs_rename2(struct mnt_idmap *idmap, struct inod=
e *source_dir,
> >   	if (unlikely(cifs_forced_shutdown(cifs_sb)))
> >   		return smb_EIO(smb_eio_trace_forced_shutdown);
> >  =20
> > -	/*
> > -	 * Prevent any concurrent opens on the target by unhashing the dentry.
> > -	 * VFS already unhashes the target when renaming directories.
> > -	 */
> > -	if (d_is_positive(target_dentry) && !d_is_dir(target_dentry)) {
> > -		if (!d_unhashed(target_dentry)) {
> > -			d_drop(target_dentry);
> > -			rehash =3D true;
> > -		}
> > -	}
> > -
> >   	tlink =3D cifs_sb_tlink(cifs_sb);
> >   	if (IS_ERR(tlink))
> >   		return PTR_ERR(tlink);
> > +
> > +	/*
> > +	 * Block opens - and all lookups that involve d_revalidate.
> > +	 * This guarantees that if another thread tries to open(), it
> > +	 * will either block, or will increment d_count()
> > +	 * before we test it in __cifs_unlink().
> > +	 */
> > +	spin_lock(&target_dentry->d_lock);
> > +	target_dentry->d_flags |=3D DCACHE_BLOCKED;
> > +	spin_unlock(&target_dentry->d_lock);
> > +
> >   	tcon =3D tlink_tcon(tlink);
> >   	server =3D tcon->ses->server;
> >  =20
> > @@ -2605,8 +2616,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode =
*source_dir,
> >   		}
> >   	}
> >  =20
> > -	if (!rc)
> > -		rehash =3D false;
> >   	/*
> >   	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
> >   	 */
> > @@ -2698,8 +2707,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode =
*source_dir,
> >   			}
> >   			rc =3D cifs_do_rename(xid, source_dentry, from_name,
> >   					    target_dentry, to_name);
> > -			if (!rc)
> > -				rehash =3D false;
> >   		}
> >   	}
> >  =20
> > @@ -2713,8 +2720,11 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode=
 *source_dir,
> >   	CIFS_I(source_dir)->time =3D CIFS_I(target_dir)->time =3D 0;
> >  =20
> >   cifs_rename_exit:
> > -	if (rehash)
> > -		d_rehash(target_dentry);
> > +	/* Allow lookups/opens */
> > +	spin_lock(&target_dentry->d_lock);
> > +	store_release_wake_up(&target_dentry->d_flags,
> > +			      target_dentry->d_flags &~ DCACHE_BLOCKED);
> > +	spin_unlock(&target_dentry->d_lock);
> >   	kfree(info_buf_source);
> >   	free_dentry_path(page2);
> >   	free_dentry_path(page1);
> >=20
> > base-commit: 3879f51857325da9bf3cfb073280257cd16ae067
>=20
>=20

