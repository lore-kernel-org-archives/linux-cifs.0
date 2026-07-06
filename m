Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8892343847B;
	Mon,  6 Jul 2026 21:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783371768; cv=none; b=TvofLR2kcMxIGNLSDmZEHrldGyMYyM7T/TBfULrLqij9SZqkGWkKostkPTsHNGPdoHpFAgqVilZ4xJHmW4fuf1wBxo+150kmkv6Sd/hd0dz6wXNFor/srxW2mH/m2blq1NKN4lCXjtP5rkGc0Mhtnqiy36lND5eQxkd43XtfaxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783371768; c=relaxed/simple;
	bh=UvjyQ7WU/4Cq5u9Oe4Ee1ASfpsIqcmsytEkWMshdjF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFVm/abE59G2tRkNDm5IiYlnf86R+IHrMDPEaA3tlc0F7uIUMu6IXmzMkBewwNedA3CIvunjDeSPIJ5l+M57ej2jC6547wXZH8nfDEl/06cNFANe3NU2RI/rlX6QbDUFNwxHYPSMst6TgX8M99utTIVsZHhsbtRbzECINpGA5FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+P7u26B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+P7u26B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3D91F000E9;
	Mon,  6 Jul 2026 21:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783371764;
	bh=2hOD7wx4KJbt6RDVRygJ7yG+Cc2VeGK1j1O8HOxLCnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R+P7u26BIbwfFH49q0dujXBPWMTvuc71ibqbqwst9rrpfR5APhMIGmwH04Qh17xq0
	 15KWS0nSq4yYfdCdr0+eUFYYe/i6Q6U5hTFJl6dr8BxOgql65w4UGjAdzyDHguvFDb
	 DRo+CQUSLCR2P01eiOPVlBhmH0n4wyvTcWqxKjFsxl5Bol/NWRvmPlGBFZBdd9Kd29
	 kl6nBTNR86nWPXkxMWRGMqVPu1yAfRqvz4YyorTu0Ei0dfe9fl2dlfKfMavvDWXEQG
	 7mFxwxfgzm3gqXidH7DXRYrZqVzse2Rk39WAxPlkITBjMMDXojjqI0MvooqchUqb6E
	 LzmKMrSd7cGBw==
Received: by pali.im (Postfix)
	id 333E95D7; Mon,  6 Jul 2026 23:02:41 +0200 (CEST)
Date: Mon, 6 Jul 2026 23:02:41 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 10/11] cifs: Add support for parsing WSL symlinks
 in version 1 format
Message-ID: <20260706210241.p5i4rxkab2sharmp@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260706184819.22124-11-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260706184819.22124-11-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Monday 06 July 2026 20:48:18 Pali Rohár wrote:
> +	switch (version) {
> +	case 1:
> +		/*
> +		 * Layout version 1 stores the symlink target in the data section of
> +		 * the file encoded in UTF-8 without trailing null-term byte.
> +		 */
>  
> -	if (version != 2) {
> +		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_DATA,
> +				     FILE_OPEN, CREATE_NOT_DIR | OPEN_REPARSE_POINT,
> +				     ACL_NO_MODE);
> +		oparms.fid = &fid;
> +		oplock = tcon->ses->server->oplocks ? REQ_OPLOCK : 0;
> +		rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
> +		if (rc)
> +			goto out;
> +
> +		free_symname_utf8 = true;
> +		symname_utf8_len = le64_to_cpu(data->fi.EndOfFile);

And Sashiko found another issue
https://sashiko.dev/#/patchset/20260706184819.22124-1-pali%40kernel.org

  Does this unconditionally read EndOfFile from the smb2_file_all_info
  struct, even when data->contains_posix_file_info is true?

  If the mount uses POSIX extensions, smb311_posix_get_fattr() populates the
  posix_fi union member instead of fi, so could this read garbage data
  overlaying DosAttributes and Inode? Also, should there be a bounds check
  against something like PATH_MAX before passing this length to kmalloc()?

I did not though about combining POSIX extensions and WSL together.

And I must admit that it is tricky that sometimes it is needed to read
data from data->posix_fi and sometimes from data->fi. Following change
should address this issue. About bounds checks, do you have any
suggestion which one to use?


diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 3fe57d166776..d7cb8eca7838 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1114,6 +1114,7 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 	__le16 *symname_utf16;
 	int symname_utf16_len;
 	struct cifs_fid fid;
+	u64 file_size;
 	__u32 oplock;
 	int buf_type;
 	int rc = 0;
@@ -1133,8 +1134,12 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 		 * the file encoded in UTF-8 without trailing null-term byte.
 		 */

+		file_size = data->contains_posix_file_info ?
+			le64_to_cpu(data->posix_fi.EndOfFile) :
+			le64_to_cpu(data->fi.EndOfFile);
+
 		free_symname_utf8 = true;
-		symname_utf8_len = le64_to_cpu(data->fi.EndOfFile);
+		symname_utf8_len = file_size;
 		symname_utf8 = kmalloc(symname_utf8_len, GFP_KERNEL);
 		if (!symname_utf8) {
 			rc = -ENOMEM;
@@ -1162,7 +1167,7 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 						       &symname_utf8_len,
 						       &symname_utf8,
 						       &buf_type);
-		if (!rc && symname_utf8_len != le64_to_cpu(data->fi.EndOfFile))
+		if (!rc && symname_utf8_len != file_size)
 			rc = -EIO;

 		tcon->ses->server->ops->close(xid, tcon, &fid);
