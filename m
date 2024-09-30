Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247BEEDE;
	Mon, 30 Sep 2024 21:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727731989; cv=pass; b=JKK9ynGS0odyjEAPiPhc9XekAnOq8PqiG8ovucc6dd3Do9CvpvTjGC4OylGC64m01Oxzrm2YmbwTwbzwBnS4B77Bbb4YCuDD1vuh8bmfAD8LiYmBSnfww0b9wp+/QgLP4Wa2tuLi+54t0ftN/XVVtyuzH6xDTTGmkNa++yN+alk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727731989; c=relaxed/simple;
	bh=kBqt/PxLo4aGIX0V+4W9o//rRdDJhhZEY1eMo3vvyfw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=oxRPgM+RxhSGcgUWOdHEieoZBB9AOiv4cPqI2x7twdtRXjdo1TiJRXMfZSHErqDXPKmCGiZ1WsPAX7CypqytNGU8pznNlXEvcsVuuMntmghAUjazQslI1y3Q0kANwtXU2GoVst5LAXf3DpB81ScR8hpWEiFMNBx/K0WmKYXi+rI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=OvlXWuNe; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="OvlXWuNe"
Message-ID: <0f46702ac6106b7a406d0ae2d19d1a0a@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727731986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1HzoV/mla8sK9dyrWH0WzzavJXSOX6A1DFy6cjDCIY=;
	b=OvlXWuNehK4fPpS87nwrTAUaYvy73FWhzWrimj2IFsvTZWxyhMX8hGului9Ff752pIrfuq
	F0sHANTfOKQ1tjF85d0OYobHVxZB6i66nxYexepFmr5aPlOjf1FN/flhDOznGT+mNbDaAT
	5loTZZm0Cd/6DPCCi0HOKrOdvRcRcn6UUiEVfm2FgTGL/mnb9KrBaLxZP2hl9gl4Qr3Yg+
	z0IBrZU2W4iR68oJC42yhOPBP4JDWRRrn+op5wilr6aKhHogScf3+KRg1kwNkSbR0TM6zn
	iyue2+hnIH3lHXWasgra3Gp0AuAlnZxejmtd4cTaekqKHjk1x4R2abkUc6EdKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727731986; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1HzoV/mla8sK9dyrWH0WzzavJXSOX6A1DFy6cjDCIY=;
	b=ZUrxKUxwQY8073HRkX0TVra5FlVrX40tzun4vm0p8iYK7agtw0MOTO2nSHjj6mCEkrOww2
	R8S1HqP7fj+sfr3pc49zlZAw3hO+qw6e3SpOiTfuGAAx6LObBtgm0ireycP2vtYFm+QyV7
	QDfmPdBjyr7uopIDEDU/JZXTh+ZOwFqB9axd9tYBIv/AFn3H1cJbxt/oaxxXmwNqTUTLxL
	LaR0TrfDBEHsu3/OY/ixVRSp70skPtRL+rDN5LZ598O8DtnxX8M/X22f8YbmgErqqX8IQQ
	Adu8oRltJA7Y8mRvqMB95FqLsRDrcpBqWMkmtXwfulnyf+j/taZyyfSa3ETfdw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1727731986; a=rsa-sha256;
	cv=none;
	b=NNaYcBlbqHtf15GVQXTwd3xaOf7bOmEJpxNIUm0HprX+xsCgPxT0Wx0jUG3Lou8JdyW2ef
	kq13t5/WhIayat3+5AAxiHbqz8rUt6Vd4qj3Q8V9qAbHFHAtE4YK5VCu3WhxPsVWgfkzGm
	y3PGanH06DAOaGJx38icMkDuRtttVeuTK64NbzDIKaOj7CBH0mVIAMiALZIhRw88xy4oCw
	q1CR+MMwTa9JZGh760PdEAwzleedhDR3dIJe1jZ/zMD4AesnzIZFY0uRLrG+tRo2zYCiB5
	os0r3mnSOTZxRNyURLWb5FyeDWtlpocuz9QQXDmN6Rq0l0vmwr/DnDyy94XmWA==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cifs: Remove intermediate object of failed create
 reparse call
In-Reply-To: <20240930172027.yt6qijriln4sv5hc@pali>
References: <20240928215948.4494-1-pali@kernel.org>
 <20240928215948.4494-3-pali@kernel.org>
 <c5914322d267a2ef8ae1f712a293b258@manguebit.com>
 <20240930172027.yt6qijriln4sv5hc@pali>
Date: Mon, 30 Sep 2024 18:33:03 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Monday 30 September 2024 12:25:27 Paulo Alcantara wrote:
>> Pali Roh=C3=A1r <pali@kernel.org> writes:
>>=20
>> > If CREATE was successful but SMB2_OP_SET_REPARSE failed then remove the
>> > intermediate object created by CREATE. Otherwise empty object stay on =
the
>> > server when reparse call failed.
>> >
>> > This ensures that if the creating of special files is unsupported by t=
he
>> > server then no empty file stay on the server as a result of unsupported
>> > operation.
>> >
>> > Fixes: 102466f303ff ("smb: client: allow creating special files via re=
parse points")
>> > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
>> > ---
>> >  fs/smb/client/smb2inode.c | 21 +++++++++++++++++++--
>> >  1 file changed, 19 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
>> > index 11a1c53c64e0..af42f44bdcf4 100644
>> > --- a/fs/smb/client/smb2inode.c
>> > +++ b/fs/smb/client/smb2inode.c
>> > @@ -1205,6 +1205,8 @@ struct inode *smb2_get_reparse_inode(struct cifs=
_open_info_data *data,
>> >  	struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>> >  	struct cifsFileInfo *cfile;
>> >  	struct inode *new =3D NULL;
>> > +	int out_buftype[2] =3D {};
>> > +	struct kvec out_iov[2];
>> >  	struct kvec in_iov[2];
>> >  	int cmds[2];
>> >  	int rc;
>> > @@ -1228,7 +1230,7 @@ struct inode *smb2_get_reparse_inode(struct cifs=
_open_info_data *data,
>> >  		cmds[1] =3D SMB2_OP_POSIX_QUERY_INFO;
>> >  		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
>> >  		rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
>> > -				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
>> > +				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
>> >  		if (!rc) {
>> >  			rc =3D smb311_posix_get_inode_info(&new, full_path,
>> >  							 data, sb, xid);
>> > @@ -1237,12 +1239,27 @@ struct inode *smb2_get_reparse_inode(struct ci=
fs_open_info_data *data,
>> >  		cmds[1] =3D SMB2_OP_QUERY_INFO;
>> >  		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
>> >  		rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
>> > -				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
>> > +				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
>> >  		if (!rc) {
>> >  			rc =3D cifs_get_inode_info(&new, full_path,
>> >  						 data, sb, xid, NULL);
>> >  		}
>> >  	}
>> > +
>> > +	if (rc) {
>> > +		/*
>> > +		 * If CREATE was successful but SMB2_OP_SET_REPARSE failed then
>> > +		 * remove the intermediate object created by CREATE. Otherwise
>> > +		 * empty object stay on the server when reparse call failed.
>> > +		 */
>> > +		if (((struct smb2_hdr *)out_iov[0].iov_base)->Status =3D=3D STATUS_=
SUCCESS &&
>> > +		    ((struct smb2_hdr *)out_iov[1].iov_base)->Status !=3D STATUS_SU=
CCESS)
>> > +			smb2_unlink(xid, tcon, full_path, cifs_sb, NULL);
>> > +	}
>>=20
>> You should handle the case where ->iov_base is NULL or out_buftype =3D=3D
>> CIFS_NO_BUFFER, otherwise you'll end up with a NULL ptr deref.
>
> Ok, thanks for info! I will send v3 with those checks.
>
> Anyway, what does it mean if iov_base stay NULL or out_buftype is
> CIFS_NO_BUFFER? Does it mean that the server has not returned reply for
> that command?

Not necessarily.  Just consider a simple case where smb2_compound_op()
would fail to allocate memory for @vars, then it would return -ENOMEM
and you would end up dereferencing ->iov_base which is still NULL.  That
is, compound_send_recv() wasn't called and then no response buffers were
set yet.
