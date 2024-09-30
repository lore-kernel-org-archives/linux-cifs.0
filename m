Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7789C19006F;
	Mon, 30 Sep 2024 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727709952; cv=pass; b=of8RCioAdkq5KhptYosJxgkbT9z92+0ifmmJSdsNDDTEvlBE4Jr8t3vTq/fymFpiHk3yP1XtmSh68gxwy0e8XLerxHBANTOvxjdxN65S54/ZV8+16A7UPPHYPvBSjVZ9f92t4xwGMSi6EGUvNCr744mvlyXlQpa6TToE/I3aXYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727709952; c=relaxed/simple;
	bh=20hfKOAlqmEDqruN2uXHj2fi1xV7GxBSj3qINFXp+gU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Wc+bB6qhlLax9Pzfn+p+U7BNBZttn/GKD72HbajIc50HxzE8J+0E1df24cDIxmOXjSuRwS+Q2dlLOVtu92X8NgBTmi7LyxV504QKa8aaQI2YWjHsXusMz0ktIfTsBiuQyGJ1D7OhNFBB1mGrsn1K0U5nRcGatq9rv34DgGf6AlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=gal2qjXA; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="gal2qjXA"
Message-ID: <c5914322d267a2ef8ae1f712a293b258@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727709930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=INLc2tSrcn36QCY27uxhMv9M2y5U3XqU/kdk7BsQoxs=;
	b=gal2qjXAkD2e/DaqzvJ9Y2gQwhfY3IP7H70nD2EPqbIIBcCYwi/GvitF0k28+qItxF6SjA
	P8FmXRp9k1Z6vCP/OJam7vkkTHvvUY+egS7QkWCGCRj13YthsCup+h81HTuS9rppTLfWhw
	e4zMddOJvp+PfC8ZuZLWsHijtohSo7R6y+O7CeHMho3jyJT2mbb336jS9D7P0fexIxT3OY
	NLM831TuJWY8bZii+d5U8ID6E5OpapX01105/Obzc7sTL6trDlq41OdZIY28ea95rwQc2D
	1OtrknyihXH+eU25xI2iZnCnCEda4LqfCk/9meRT6/ZLUsMOD5L5h3+Eld2kyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727709930; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=INLc2tSrcn36QCY27uxhMv9M2y5U3XqU/kdk7BsQoxs=;
	b=LEBxyWoRYP1HKaMq8FITr2BqZ399TS1UNGly6smKYiJQ8Ow/uqp5Exy909clAwtoWj5Czs
	dJj9t/G1a5rK94r21a3ZjvpMaFUOlfkSqmpAmrcxGuBLIo00froUOhZisS/iRHBKKGD2Rb
	LeLWKyEVSUxpQApDZkGIyE5xFImXjLP2e6iUpclxZEJKObc1op+EtEPvr44AqLBIYq6JRd
	YgnDKH+Vb0UumjaHSbAdGHjDpqtD9mizSFH0nQLF2kUdCiHdDpHRN5wkrhmf6yllREp/Lq
	6KayNL0XyoZ5/GSvBgyNIpc2acEMq2HU8QhtqnTWcELNxCKbEa9svWhadF8B6w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1727709930; a=rsa-sha256;
	cv=none;
	b=TX1n43wl1/E9QoELkrRdPEFtGtWRQsCACAirFAi0SyKwwnT7ugDf6sJmWcustvhIwRTj4f
	dk21J+Bo8Z/ya+0EXYuZn3Y6Q0jin4Phk6/VCEIxcZb7OwuZ0v6V6Qs52OIWsxCBbJJDt8
	YmXg5TJTVwHoz6DGeL/eubGQrDA9zajtvzKoLf6bE7MiC+2UAGkea6e/ihwvNvJa3iI6ij
	HMGssVxBghXe8Jl/pzjX+l72LfXLbulIivyA9gr4LYNbTc0UI8zkOyOTqBLP8VF9wDWEF7
	tk9FHGsiRePc1XNH7jDHbmsEABJ+8Ht8LyKuLBI40U5GMBn3jC+95MYcZlp1CQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Steve French
 <sfrench@samba.org>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cifs: Remove intermediate object of failed create
 reparse call
In-Reply-To: <20240928215948.4494-3-pali@kernel.org>
References: <20240928215948.4494-1-pali@kernel.org>
 <20240928215948.4494-3-pali@kernel.org>
Date: Mon, 30 Sep 2024 12:25:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> If CREATE was successful but SMB2_OP_SET_REPARSE failed then remove the
> intermediate object created by CREATE. Otherwise empty object stay on the
> server when reparse call failed.
>
> This ensures that if the creating of special files is unsupported by the
> server then no empty file stay on the server as a result of unsupported
> operation.
>
> Fixes: 102466f303ff ("smb: client: allow creating special files via repar=
se points")
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/smb2inode.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 11a1c53c64e0..af42f44bdcf4 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1205,6 +1205,8 @@ struct inode *smb2_get_reparse_inode(struct cifs_op=
en_info_data *data,
>  	struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>  	struct cifsFileInfo *cfile;
>  	struct inode *new =3D NULL;
> +	int out_buftype[2] =3D {};
> +	struct kvec out_iov[2];
>  	struct kvec in_iov[2];
>  	int cmds[2];
>  	int rc;
> @@ -1228,7 +1230,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_op=
en_info_data *data,
>  		cmds[1] =3D SMB2_OP_POSIX_QUERY_INFO;
>  		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
>  		rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
> -				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
> +				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
>  		if (!rc) {
>  			rc =3D smb311_posix_get_inode_info(&new, full_path,
>  							 data, sb, xid);
> @@ -1237,12 +1239,27 @@ struct inode *smb2_get_reparse_inode(struct cifs_=
open_info_data *data,
>  		cmds[1] =3D SMB2_OP_QUERY_INFO;
>  		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
>  		rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
> -				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
> +				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
>  		if (!rc) {
>  			rc =3D cifs_get_inode_info(&new, full_path,
>  						 data, sb, xid, NULL);
>  		}
>  	}
> +
> +	if (rc) {
> +		/*
> +		 * If CREATE was successful but SMB2_OP_SET_REPARSE failed then
> +		 * remove the intermediate object created by CREATE. Otherwise
> +		 * empty object stay on the server when reparse call failed.
> +		 */
> +		if (((struct smb2_hdr *)out_iov[0].iov_base)->Status =3D=3D STATUS_SUC=
CESS &&
> +		    ((struct smb2_hdr *)out_iov[1].iov_base)->Status !=3D STATUS_SUCCE=
SS)
> +			smb2_unlink(xid, tcon, full_path, cifs_sb, NULL);
> +	}

You should handle the case where ->iov_base is NULL or out_buftype =3D=3D
CIFS_NO_BUFFER, otherwise you'll end up with a NULL ptr deref.
