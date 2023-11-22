Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ees8dQZ0"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D64092
	for <linux-cifs@vger.kernel.org>; Wed, 22 Nov 2023 07:16:06 -0800 (PST)
Message-ID: <e18f51d8eca56a0f948ff6b9fa37f61c@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700666164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gcs5RYGWs3iVuxomdifA+yfPnoapKGRfQvFhls2WexA=;
	b=ees8dQZ0BU1vuVDJFTHgGkV6EXB1sSGbuQOwsbdPkg2w2g/m6VbhVI/9n6uPiJ+f+WYkaF
	iBxVaFZctxM/jQWnw2YQIsVFiCzf1BtAuQzyAt3QI3IoQ8JlkArYGjALSk50WEMMAwW98V
	F1iv0emU2ImEoCinb1qZqSVr/TAIGfD1hoQ/n85auyZ5eajSySkE83isk7aArtHBs1C2Yv
	jXNBPzugRNhk/9Yi7tg+lbCXn6nBJKNjHFxHX6VoSoxJs0+Xs2+ek5+B9a7exnvwvQQgXk
	wKJLCz/RtCYjhZ36uRFD02t3XPbLKk4VWosWQHl0L/XXIB1B2lFGYxJ56esGCw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700666164; a=rsa-sha256;
	cv=none;
	b=XSeC5Y8fdVGDO2NIZhBPpUyQok1Acn2/dw8ca/rzSt1gYh6n6KuQe7PSx+5kK638c1lvoj
	J7z/aQ/Y39KBdxZGT8r98gW1m1IU4BEf0HZo7BfVnok648VoOcySc3P74HAwDOLuziebSO
	ceWlfiP+Z426QbqE32J001yNfOWnAs6BM4Hw/5aSKwGcVIIoOTrkP+8KoKlYhpQfLLu/pD
	6I8IMf4jR6PBlWdRitJQzH00NjwPudHH4RATavOR37MrpaEarH8VXrQclnl88F6KpEzPdG
	SBzB0vDOVvoLZo8halPZmFLZx/iHuZnlgRj13rRSSurhe0HP4cNQLTC+xIMhEQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700666164; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gcs5RYGWs3iVuxomdifA+yfPnoapKGRfQvFhls2WexA=;
	b=oZyUyxWii0dywbvmvdgy0voLx7Ms/s1pQUVvgI5sH2nSq9Y9g6X+3YUyaVON9iIwO1xWmt
	mR1NMOeQo3u9EvTbtp4IkkNIwde/DhT8swckmJWIMnigxG7xy/5I5eXv5bTTAcc1JJHtM/
	AXJfqLNDxWLTxnf8skwv9LFP221X1/A1abP/Ydd+lG5zXky8bDLdpAi6Ad7VgcEWazA7XG
	hJcXavKOEE1I/XgT5BtpaPOOWvM10cSwz6s2QO5Ds4+1Ld/Y/eofbEUA7DT2Gx9QJAqeJo
	rxda4V8UI1BvP2QCiPvMCb8S4PQFzlZsjhazfnQJ/Xc3sXcfbf6OO9roGkZYyQ==
From: Paulo Alcantara <pc@manguebit.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 5/7] smb: client: allow creating special files via
 reparse points
In-Reply-To: <20231121231258.29562-5-pc@manguebit.com>
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231121231258.29562-1-pc@manguebit.com>
 <20231121231258.29562-5-pc@manguebit.com>
Date: Wed, 22 Nov 2023 12:16:01 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.com> writes:

> +static int create_nfs_reparse(const unsigned int xid,
> +			      struct cifs_tcon *tcon,
> +			      struct cifs_sb_info *cifs_sb,
> +			      const char *full_path, mode_t mode,
> +			      struct reparse_posix_data *buf)
> +{
> +	u64 type;
> +	u16 len, dlen;
> +
> +	len = sizeof(*buf);
> +
> +	switch ((type = mode_nfs_type(mode))) {
> +	case NFS_SPECFILE_BLK:
> +	case NFS_SPECFILE_CHR:
> +		dlen = sizeof(__le64);
> +		break;
> +	case NFS_SPECFILE_FIFO:
> +	case NFS_SPECFILE_SOCK:
> +		dlen = 0;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	buf->ReparseTag = cpu_to_le32(IO_REPARSE_TAG_NFS);
> +	buf->InodeType = cpu_to_le64(type);
> +	buf->ReparseDataLength = cpu_to_le16(len + dlen -
> +					     sizeof(struct reparse_data_buffer));

Err, forgot having @buf->Reserved set to 0 here, sorry.  MS-FSCC
doesnt't say we _must_ to, however it's better not sending garbage over
the wire.

Let me know if you'd need v2 for the above.
