Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEEC23D28C;
	Mon, 11 Aug 2025 10:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754909582; cv=none; b=ThG1Zoelte+Lfd4GumVMdNNEFJ1mbZg6PunzFi3b4b8jkyb17pnAsM/lcV1j1oY7uqGoknXzECBaE2SpQPo2kqc5zaj2R3V5V1sLrC2AYulqNruKEVi74k1Haqb5hn1MjcyVf/lyR9YH9b27SXD1iwHdt5/CiLUVg7LiL4tRC3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754909582; c=relaxed/simple;
	bh=1gGPyrJyshBlnSCLmfnaqE2KI5THYjimmqrm7wNgPoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h7s8S9jllgrWTK2nskwoP3abk7gmghEn2egae80hnjABqIdjWNTnxbKvZjYqMG/x4RXP0YUYjeCjmIf8b17rEgjYVJvni/HaOD1scmI2Y1FjNL5+5dk7S3/T7AfbHZfYq4QxFykOazuaaEbr4nBGMId940gxDR6Sx5bE7EHhiSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rm09YEH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rm09YEH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4E6C4CEED;
	Mon, 11 Aug 2025 10:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754909581;
	bh=1gGPyrJyshBlnSCLmfnaqE2KI5THYjimmqrm7wNgPoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rm09YEH331RyTN1fnnzsMNXCyXPPKpEMdm8E7L0Uo174gLkyJxEbIFIFy0JGeFj4E
	 Alwfz70vhC1HHuPdrM4/Wjt5WAQU4WcX4LL8rTCMOr0KcRbmR8+VeHM6cUZ2Lut0T7
	 IwnOMYbTD+nQ8ryLP1yP6asjj9y6C966KMoqMilQgwAvvOktIUt6z4uIcCR//206qV
	 fMYYLrQIEpjwV00Y2onGIx5cPXU2KA6aDaQZldtx726VAn6ZhKEczVNlx9J4m/aNDA
	 ORnY9H6Jn6oa3T67BKGawb+o9pJ6Q9n6mJnA9khiGO03j4FhP+mBFyiuXRkyn84umr
	 xV0+EbnrXRCUQ==
Received: by pali.im (Postfix)
	id A3085730; Mon, 11 Aug 2025 12:52:58 +0200 (CEST)
Date: Mon, 11 Aug 2025 12:52:58 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>,
	Jeremy Allison <jra@samba.org>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Do not use UID and GID from EAs
Message-ID: <20250811105258.t3r65wsytkmyguem@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali>
 <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
 <20240917202921.ty32zzmhrg33knpy@pali>
 <ZunnGhOogEQU2Hje@jeremy-rocky-laptop.localdomain>
 <20240917203431.w5dejuwfkmabrewz@pali>
 <CAN05THTVav8HOCk6V+5eg-BTESZDBx2BuQOF1c=Vn2dFv_UNxw@mail.gmail.com>
 <CAH2r5muUioziUN7mRFUAOV3tGPMLnb949j70GKYnRM2LygAWVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="m7txbpwkpe7pcfqc"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5muUioziUN7mRFUAOV3tGPMLnb949j70GKYnRM2LygAWVQ@mail.gmail.com>
User-Agent: NeoMutt/20180716


--m7txbpwkpe7pcfqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tuesday 17 September 2024 16:19:08 Steve French wrote:
> On Tue, Sep 17, 2024 at 3:45 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > On Wed, 18 Sept 2024 at 06:37, Pali Rohár <pali@kernel.org> wrote:
> > >
> > > On Tuesday 17 September 2024 13:31:22 Jeremy Allison wrote:
> > > > On Tue, Sep 17, 2024 at 10:29:21PM +0200, Pali Rohár wrote:
> > > > > On Tuesday 17 September 2024 13:23:40 Jeremy Allison wrote:
> > > > > > On Tue, Sep 17, 2024 at 10:06:00PM +0200, Pali Rohár wrote:
> > > > > > > And seems that SMB2_OP_QUERY_WSL_EA is useful not only for reparse
> > > > > > > points, but also for any regular file or directory as it can contain
> > > > > > > UNIX mode and UID/GID ownership.
> > > > > >
> > > > > > uid/gid should *never* be exposed over the wire for SMB.
> > > > > >
> > > > > > That way lies madness.
> > > > >
> > > > > Hello Jeremy, if I understood wsl_to_fattr() function correctly then it
> > > > > is already doing it, it fills uid/gid for stat() from data which were
> > > > > exposed over the wire for SMB. Could you check that function if it is
> > > > > truth?
> > > >
> > > > I'm sure the Windows implementation is doing it - however, any Linux
> > > > server implementations should not do this (IMHO).
> > > >
> > > > It will break all SID -> uid / gid mapping that servers must
> > > > carefully set up.
> > > >
> > > > On the wire - SIDs must be the only source of identity.
> > >
> > > Ok. But then I do not understand why Linux client parses and uses uid
> > > and gids which are sent over the wire. If you are saying that the SIDs
> > > must be the only source of truth then Linux client should rather ignore
> > > uid and gid values?
> >
> > What I think Jeremy is refering to is that mixing uids and sids in the
> > protocol itself is
> > a protocol design mistake.
> > Because this means that some PDUs in the protocol operate on SIDs but
> > others operate on
> > UID/GIDs and this means there is great risk of mistakes and have the
> > sid<->uid mapping return
> > different results depending on the actual PDU.
> >
> > Sometimes the sid<->uid mapping happens in the server, at other times
> > the mapping happens in the client
> > and it is very difficult to guarantee that the mapping is consistent
> > across PDUs in the protocol as well as across different clients.
> 
> Yes - agreed.
> 
> SIDs are globally unique and should always be used/sent over the wire
> (never send or use the local uid/gid which is not guaranteed to be
> unique).  Whether retrieving ownership information via
> the SMB ACL or via an SMB3.1.1 POSIX response, the SID is the correct
> thing to send/use in the protocol.  For cases where the client is not
> domain joined, the UID/GID can be encoded in the SID, for cases that
> are domain joined the Linux UIDs/GIDs can be mapped consistently via
> the SID.
> 
> -- 
> Thanks,
> 
> Steve

Hello Steve, based on the above discussion I'm proposing a change which
stops parsing UID and GID values stored in EAs on the SMB server for
SMB2 and SMB3 dialects. Change is in the attachment.

Steve, Ronnie, Jeremy and Paulo, could you review this change?

--m7txbpwkpe7pcfqc
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-cifs-Do-not-use-WSL-EAs-LXUID-LXGID-and-LXMOD-for-ow.patch"
Content-Transfer-Encoding: 8bit

From e72661de4214b135b5852b95be9ff6f66014df41 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Thu, 30 Jan 2025 22:43:31 +0100
Subject: [PATCH] cifs: Do not use WSL EAs $LXUID, $LXGID and $LXMOD for
 ownership/permissions
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When retrieving stat information about reparse points, do not use WSL EAs
$LXUID, $LXGID and $LXMOD for deducing Linux UID, GID and permission bits
of MODE. The source of truth for ownership and permissions should be always
only the SMB Security Descriptor, hence the ownership should comes from the
SID and permissions from ACL.

WSL EA $LXMOD contains not only permission bits, but also the file type
information. WSL subsystem requires from special files that this EA is
present and its encoded file type matches the reparse point type.

So let the EA $LXMOD code there, but use it only for validation of file
type (S_DT bits) that it matches the file type from reparse point tag.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c   |  7 +------
 fs/smb/client/smb2inode.c | 10 ++--------
 fs/smb/client/smb2pdu.h   | 20 ++++++++++----------
 3 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index a1aa10a572c2..3660f7353258 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1358,15 +1358,10 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 		nlen = ea->ea_name_length;
 		v = (void *)((u8 *)ea->ea_data + ea->ea_name_length + 1);
 
-		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen))
-			fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen))
-			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
+		if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
 			if (S_DT(reparse_mode_type) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;
-			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
 			have_xattr_mode = true;
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 2a0316c514e4..18e5376a63ab 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -94,8 +94,6 @@ struct wsl_query_ea {
 #define NEXT_OFF cpu_to_le32(sizeof(struct wsl_query_ea))
 
 static const struct wsl_query_ea wsl_query_eas[] = {
-	{ .next = NEXT_OFF, .name_len = SMB2_WSL_XATTR_NAME_LEN, .name = SMB2_WSL_XATTR_UID, },
-	{ .next = NEXT_OFF, .name_len = SMB2_WSL_XATTR_NAME_LEN, .name = SMB2_WSL_XATTR_GID, },
 	{ .next = NEXT_OFF, .name_len = SMB2_WSL_XATTR_NAME_LEN, .name = SMB2_WSL_XATTR_MODE, },
 	{ .next = 0,        .name_len = SMB2_WSL_XATTR_NAME_LEN, .name = SMB2_WSL_XATTR_DEV, },
 };
@@ -130,9 +128,7 @@ static int check_wsl_eas(struct kvec *rsp_iov)
 
 		switch (vlen) {
 		case 4:
-			if (strncmp(ea->ea_data, SMB2_WSL_XATTR_UID, nlen) &&
-			    strncmp(ea->ea_data, SMB2_WSL_XATTR_GID, nlen) &&
-			    strncmp(ea->ea_data, SMB2_WSL_XATTR_MODE, nlen))
+			if (strncmp(ea->ea_data, SMB2_WSL_XATTR_MODE, nlen))
 				return -EINVAL;
 			break;
 		case 8:
@@ -140,9 +136,7 @@ static int check_wsl_eas(struct kvec *rsp_iov)
 				return -EINVAL;
 			break;
 		case 0:
-			if (!strncmp(ea->ea_data, SMB2_WSL_XATTR_UID, nlen) ||
-			    !strncmp(ea->ea_data, SMB2_WSL_XATTR_GID, nlen) ||
-			    !strncmp(ea->ea_data, SMB2_WSL_XATTR_MODE, nlen) ||
+			if (!strncmp(ea->ea_data, SMB2_WSL_XATTR_MODE, nlen) ||
 			    !strncmp(ea->ea_data, SMB2_WSL_XATTR_DEV, nlen))
 				break;
 			fallthrough;
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 3c09a58dfd07..914e2737d1a2 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -425,7 +425,6 @@ struct smb2_create_ea_ctx {
 #define SMB2_WSL_XATTR_MODE		"$LXMOD"
 #define SMB2_WSL_XATTR_DEV		"$LXDEV"
 #define SMB2_WSL_XATTR_NAME_LEN	6
-#define SMB2_WSL_NUM_XATTRS		4
 
 #define SMB2_WSL_XATTR_UID_SIZE	4
 #define SMB2_WSL_XATTR_GID_SIZE	4
@@ -433,16 +432,17 @@ struct smb2_create_ea_ctx {
 #define SMB2_WSL_XATTR_DEV_SIZE	8
 
 #define SMB2_WSL_MIN_QUERY_EA_RESP_SIZE \
-	(ALIGN((SMB2_WSL_NUM_XATTRS - 1) * \
-	       (SMB2_WSL_XATTR_NAME_LEN + 1 + \
-		sizeof(struct smb2_file_full_ea_info)), 4) + \
-	 SMB2_WSL_XATTR_NAME_LEN + 1 + sizeof(struct smb2_file_full_ea_info))
+	(ALIGN(sizeof(struct smb2_file_full_ea_info) + \
+	       SMB2_WSL_XATTR_NAME_LEN + 1, 4) + \
+	 sizeof(struct smb2_file_full_ea_info) + \
+	 SMB2_WSL_XATTR_NAME_LEN + 1)
 
 #define SMB2_WSL_MAX_QUERY_EA_RESP_SIZE \
-	(ALIGN(SMB2_WSL_MIN_QUERY_EA_RESP_SIZE + \
-	       SMB2_WSL_XATTR_UID_SIZE + \
-	       SMB2_WSL_XATTR_GID_SIZE + \
-	       SMB2_WSL_XATTR_MODE_SIZE + \
-	       SMB2_WSL_XATTR_DEV_SIZE, 4))
+	(ALIGN(sizeof(struct smb2_file_full_ea_info) + \
+	       SMB2_WSL_XATTR_NAME_LEN + 1 + \
+	       SMB2_WSL_XATTR_MODE_SIZE, 4) + \
+	 sizeof(struct smb2_file_full_ea_info) + \
+	 SMB2_WSL_XATTR_NAME_LEN + 1 + \
+	 SMB2_WSL_XATTR_DEV_SIZE)
 
 #endif				/* _SMB2PDU_H */
-- 
2.20.1


--m7txbpwkpe7pcfqc--
