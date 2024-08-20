Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37F01C9DCA
	for <linux-cifs@vger.kernel.org>; Tue, 20 Aug 2024 23:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198056; cv=pass; b=OMjjtMjVNmyB2kVfk8ZlHrSGBJZR3cuZvTiw+O6Up3xCi2v/sDYrAOxcqcYT/0w1TyXJ5XDYm4tf+IC4GRw4G/b15b+/nzkTfktVgX1BmsEQ2NYLZuClvP85QwdYKvQiV8x9l5D7726ieWCq6JfBDbeDxUuxc/9pKpplKaRQxic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198056; c=relaxed/simple;
	bh=b6eVEwG5be110z2ucbappn0FNg1Plv9dIkQS3M9PSag=;
	h=Message-ID:From:To:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Up2+A8i7bGcTz9dqMu05QZ1BMjoxwET7+o2Ni0Aflfj3udLzr3swdBReXX3DcFenZGnq+kmiWK98COxEMaMazW8gg9kj551zNDzuN5jTMeATyYvLCKM8MZOgA/6b0xEeXgMPRyj3JnJ9t/KfaldRk+IH0xSjt+GjEr5SZS3u2S0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=MwDoz1H3; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="MwDoz1H3"
Message-ID: <54a46d0e05c754fbc5643af2b576e876@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1724197538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ytO4gjg2R5sO9zXXE6LHWNsoREeH2qp1MRGcCEpKls=;
	b=MwDoz1H3HRo/4yI552yk8ut6AEvu+sFIvTR1+nNGxjFqRkfft2nERuHFGPbQi9+VvwLHLq
	9lS58XscNGvbWEV+a3Wk4QDeHvRBTS79qsLR0I9JEvM3iPtHx6yTDiTbN5pcFakYIh4wtB
	L8vrq3B9BuGt2rUL442EpB1x+5c8FVHUpFEGEEMsU3vavTQG+A++ApZiSfs9ndqdjM2YR2
	RikWFnNDGsNZm7WMtg7HuZhzdsFb+o4rbBTEvOS1jdyiobRb68km5PMbMl9YZ4pMLfRPQA
	6wz/EdyEcjvFqx+kG1Stn9Tb2K0jm0/+DFwe34ullXoPim09XhF1o8wfEDMHrg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1724197538; a=rsa-sha256;
	cv=none;
	b=CAYOKiQ++K8OL6mJpgG8TvjZdNd9jt6vNIxDcP4um6HYQC0kyvw+PtU+5oTcDoz0bsa+pK
	ph9/0KgG7UeZ7RSCxMlMVDj5dUtdyhIeAcwcNxWpvSSjXsl7yo4OvyiGGio8nABc2VCsic
	fIWnfjFhw40fZgzdQjqdBPqE5iMC9FvUSnux9ZU7Lf7JNf0XtQcPF+UA8AvYpP9hG1aGf/
	5AKerkgeWhGqIKfVm/8OyPLEnfG6+XKrcsFS85o4NSdMSNOU0V1AJsCVby5b/FShv2gP04
	tQPSMZw9KnHYI8WHXV2+YjtbXw4hACDk+y+Cjy497YjubjcGXta9CKEVNVoggg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1724197538; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ytO4gjg2R5sO9zXXE6LHWNsoREeH2qp1MRGcCEpKls=;
	b=QWROjwJhXnL7g6qqgg+Cz5KAgnY7dij4lii/i2eDXSLF2m1bOym4vzwrIQ/+frU7ImRZ+1
	2ayBxnuRUiokBxHLAEau261Ky7fx8Tn5PHePNgttPJyE1hQahG0Mia86hW8//kBoTHOmCv
	RUMPjqCoAVB7LVflM+ngwQRAJRofpiIOmBngSEu1lwMZULQJNIpdG7kLbKakXZj+hwymsE
	1GQTUWVoIS9chXzxoS94KNzFIw7c12drTmeNeNjSFSuSDJU0fULS6k3UHXfH9Eu9Rw1/hB
	pG0SXrokd0028Lb2OTOardRkDz8wz5xjYevQvgDnyAnqLT891MOd2xJ7Qkt6Nw==
From: Paulo Alcantara <pc@manguebit.com>
To: Marc <1marc1@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Issue with kernel 6.8.0-40-generic?
In-Reply-To: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
References: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
Date: Tue, 20 Aug 2024 20:45:34 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Marc <1marc1@gmail.com> writes:

> This has been working great for many years. Yesterday, this stopped
> working. When I tried mounting the share, I would get the following
> error: "mount error(95): Operation not supported". In dmesg I see:
> "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" and
> "VFS: cifs_read_super: get root inode failed".

Can you try the following changes?  Thanks.

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 689d8a506d45..48c27581ec51 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			bool unicode, struct cifs_open_info_data *data)
 {
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
 	data->reparse.buf = buf;
 
 	/* See MS-FSCC 2.1.2 */
@@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_LX_CHR:
 	case IO_REPARSE_TAG_LX_BLK:
-		return 0;
+		break;
 	default:
-		cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%08x\n",
-			 __func__, le32_to_cpu(buf->ReparseTag));
-		return -EOPNOTSUPP;
+		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
+			      le32_to_cpu(buf->ReparseTag));
+		break;
 	}
+	return 0;
 }
 
 int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
