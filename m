Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF17623EABC;
	Wed,  8 Apr 2026 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775641175; cv=none; b=LA/p9uHNJTA/BsPG1YRZs0Vt4M3G9b3Vy6areDdFbkOsdud8iVDfF1vc+Y61RPwfnNOFegUrHpGlOZt0yZU2ydCnhZLY5sP316ACAH1hzkN9y9sDy3rI8Gh+bwj/crGFUS38fdBCo0O82Tj/JLlOEuVRxqh6rDDQ1x/7Xls31mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775641175; c=relaxed/simple;
	bh=Gb1Xrqu+8dtdfVKpK50SdS/TSSqAO94bBFu2WIbxl0Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YU8JwICKuyImISx+IWAS+JD/a8ZC53WWL4KCcieuu2DnzWNk364/MnsPgKlisl4gG26XBcmpvMj61IcQyhaJm19kZADAbZTLsonSsCeksP5Uw5AqqCuDew0SHWEDwl/WX7EYundicjfWMETqBFARp3If1cJyu2+mIm7fXzBLoYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn; spf=pass smtp.mailfrom=stu.pku.edu.cn; dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b=GXsqupK7; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b="GXsqupK7"
Received: from smtpclient.apple (unknown [58.206.232.189])
	by smtp.qiye.163.com (Hmail) with ESMTP id 39f15eb4b;
	Wed, 8 Apr 2026 17:39:20 +0800 (GMT+08:00)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 1/2] smb: client: fix off-by-8 bounds check in
 check_wsl_eas()
From: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
In-Reply-To: <2026040636-unsigned-jackal-e239@gregkh>
Date: Wed, 8 Apr 2026 17:39:09 +0800
Cc: linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>,
 Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>,
 samba-technical@lists.samba.org,
 stable <stable@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1F39D765-2631-40EB-9B1A-131B5753599A@stu.pku.edu.cn>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3864.500.181)
X-HM-Tid: 0a9d6c75e9d103a1kunm5a3f7b8137c0f
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZSRofVh0eHRpJTBgfTk4ZTVYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJS01VSUhJVUpDQllXWRYaDxIVHRRZQVlPS0hVSktISk5MTlVKS0tVSk
	JLS1kG
DKIM-Signature: a=rsa-sha256;
	b=GXsqupK7a0b2A/VSDyK1MDTRIg4W9KC2eY3eoW+UlxC1qdG2ZRED6RrzzNuD4QB6wsp+LwVBKH19lJwfHd5bVCCkMTlPjpULAY+GHwkrnUFMlahO0+ueYsamoIJY8Xmi27mn8abHBL0pAWq53jCBSljKpWX00zp1uhaCSkRqatw=; s=default; c=relaxed/relaxed; d=stu.pku.edu.cn; v=1;
	bh=RY0WK+afdMqPqSsi6g+9H/saDXURk1JzxJogWSYhZCY=;
	h=date:mime-version:subject:message-id:from;

[PATCH] smb: client: add bounds checks when iterating SMB1 WSL EAs

Add boundary and overflow checks when traversing extended attribute (EA)
entries for SMB1 WSL reparse points in cifs_query_path_info(), to =
prevent
out-of-bounds memory accesses from malformed next_entry_offset values.

This is necessary because SMB1 WSL EA iteration does not currently have
any explicit bounds checking, unlike SMB2 path which has =
check_wsl_eas().
The new checks ensure the current EA pointer plus its size does not
exceed the end of the EA buffer during iteration and before parsing.

Signed-off-by: YuanfuXie <yuanfuxie@stu.pku.edu.cn>
---
 fs/smb/client/smb1ops.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 9694117050a6..940bae49b2cc 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -645,13 +645,17 @@ static int cifs_query_path_info(const unsigned int =
xid,
 	if (!rc && data->reparse_point) {
 		struct smb2_file_full_ea_info *ea;
 		u32 next =3D 0;
+		u8 *eas_end =3D data->wsl.eas + data->wsl.eas_len;
=20
 		ea =3D (struct smb2_file_full_ea_info *)data->wsl.eas;
 		do {
 			ea =3D (void *)((u8 *)ea + next);
+			if ((u8 *)ea + sizeof(*ea) > eas_end)
+				break;
 			next =3D le32_to_cpu(ea->next_entry_offset);
 		} while (next);
-		if (le16_to_cpu(ea->ea_value_length)) {
+		if ((u8 *)ea + sizeof(*ea) <=3D eas_end &&
+		    le16_to_cpu(ea->ea_value_length)) {
 			ea->next_entry_offset =3D =
cpu_to_le32(ALIGN(sizeof(*ea) +
 						ea->ea_name_length + 1 +
 						=
le16_to_cpu(ea->ea_value_length), 4));
@@ -691,13 +695,17 @@ static int cifs_query_path_info(const unsigned int =
xid,
 	if (!rc && data->reparse_point) {
 		struct smb2_file_full_ea_info *ea;
 		u32 next =3D 0;
+		u8 *eas_end =3D data->wsl.eas + data->wsl.eas_len;
=20
 		ea =3D (struct smb2_file_full_ea_info *)data->wsl.eas;
 		do {
 			ea =3D (void *)((u8 *)ea + next);
+			if ((u8 *)ea + sizeof(*ea) > eas_end)
+				break;
 			next =3D le32_to_cpu(ea->next_entry_offset);
 		} while (next);
-		if (le16_to_cpu(ea->ea_value_length)) {
+		if ((u8 *)ea + sizeof(*ea) <=3D eas_end &&
+		    le16_to_cpu(ea->ea_value_length)) {
 			ea->next_entry_offset =3D =
cpu_to_le32(ALIGN(sizeof(*ea) +
 						ea->ea_name_length + 1 +
 						=
le16_to_cpu(ea->ea_value_length), 4));
--=20
2.43.0

> On Apr 6, 2026, at 21:49, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> The bounds check uses (u8 *)ea + nlen + 1 + vlen as the end of the EA
> name and value, but ea_data sits at offset sizeof(struct
> smb2_file_full_ea_info) =3D 8 from ea, not at offset 0.  The strncmp()
> later reads ea->ea_data[0..nlen-1] and the value bytes follow at
> ea_data[nlen+1..nlen+vlen], so the actual end is ea->ea_data + nlen + =
1
> + vlen.  Isn't pointer math fun?
>=20
> The earlier check (u8 *)ea > end - sizeof(*ea) only guarantees the
> 8-byte header is in bounds, but since the last EA is placed within 8
> bytes of the end of the response, the name and value bytes are read =
past
> the end of iov.
>=20
> Fix this mess all up by using ea->ea_data as the base for the bounds
> check.
>=20
> An "untrusted" server can use this to leak up to 8 bytes of kernel =
heap
> into the EA name comparison and influence which WSL xattr the data is
> interpreted as.
>=20
> Cc: Steve French <sfrench@samba.org>
> Cc: Paulo Alcantara <pc@manguebit.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Cc: stable <stable@kernel.org>
> Assisted-by: gregkh_clanker_t1000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> fs/smb/client/smb2inode.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 364bdcff9c9d..fe1c9d776580 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -128,7 +128,7 @@ static int check_wsl_eas(struct kvec *rsp_iov)
> 		nlen =3D ea->ea_name_length;
> 		vlen =3D le16_to_cpu(ea->ea_value_length);
> 		if (nlen !=3D SMB2_WSL_XATTR_NAME_LEN ||
> -		    (u8 *)ea + nlen + 1 + vlen > end)
> +		    (u8 *)ea->ea_data + nlen + 1 + vlen > end)
> 			return -EINVAL;
>=20
> 		switch (vlen) {
> --=20
> 2.53.0
>=20
>=20
>=20
>=20

