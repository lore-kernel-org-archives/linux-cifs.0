Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FCF30BF67;
	Wed, 15 Oct 2025 15:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760543622; cv=pass; b=ljO1h8iGvpHwpzEuiKjoLOXOlJ9aS4MEovEFfa2tCnag7ANSqme+5GT3tOS7DqOmYK6rJO9+snpFpU4ZD6w0+KYwpDuIoJD21BGy2pdN9IzFboTxtSg3Hrq7Rp9fHWCrQTdMUXINczR/8a9r280NoRiDHD4uCd4p8DlLb/Me/Oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760543622; c=relaxed/simple;
	bh=5Nc2LKagltXHEwEK+nSZyh6mH4us6mxrpatvyGL5Opg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DflgrbcGlMWlxrLVZQijCeX5EwqCUn5JfvDN+dNEeh3RyL+5qLi5ocFk8hR7g63Ij/Xy6pzBoWG5tO0kr6GTML8zr4kHF9Gv38A5/NNDHWSy9imAMLK6H1w9deDRcNtFuCYCUtLbjVfD5krj77Cv+y87XYdNdNOSPmXPPWJTRcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=Sc6iP+g7; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="Sc6iP+g7"
Received: from chcpu18 (191host009.mobilenet.cse.ust.hk [143.89.191.9])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 59FFqJiS3631000
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 23:52:25 +0800
ARC-Seal: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse; t=1760543546; cv=none;
	b=Xnz2tw+9fWGJNNp7lhSdmJoM4X3PPL5JqgteyJI3uzHfODvWGc8MWyF3qv6tv9zM7QzDgyXxMK/Z5u5nWcXSpj+DfksuQn6BT3lhF03Fna+55rGKrOyi0oC9wep+uYGig9F4qcExcnVtfzlKg3CKpACna0iE5a005CekKchCPmk=
ARC-Message-Signature: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse;
	t=1760543546; c=relaxed/relaxed;
	bh=OVt7WcWwgf/KRbchBl3ZUc8uuIGie1r/3IL5drq8IwA=;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=bQtGLbO53jHpJ5QZ/XLrHZPY0H3gozjpV0jWV+g5iBkLhXoLXF+/9zM70n4Hna9xWFfpf7JckcqicTtQetwO0gCkY3yWOnuZqhOW9WB3mqhMtZo0i32/8iWC053cTbyAtmwdzkHgIHWZPE+ukROSBxZL+fNg7kd+88hP2ykq9jU=
ARC-Authentication-Results: i=1; cse.ust.hk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1760543546;
	bh=OVt7WcWwgf/KRbchBl3ZUc8uuIGie1r/3IL5drq8IwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sc6iP+g7z3npeDwFOGeIj0lc9mrsy5VK466F5vyfyqBoyZhEgPS758lVa3WLbEfIS
	 9WWfsfNLF/iIfU4e6vrYMGIOgVqFsQeiGV7JvLq0ZilDBCV97YZwDKLv6W4mOHaXIZ
	 DvqLnvwRilgZ+EhWxdVV9yb3e/IXZXweESiUBVq4=
Date: Wed, 15 Oct 2025 15:52:14 +0000
From: Shuhao Fu <sfual@cse.ust.hk>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Bharath SM <bharathsm@microsoft.com>,
        Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>,
        Tom Talpey <tom@talpey.com>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] smb: Fix refcount leak for cifs_sb_tlink
Message-ID: <aO/DLq/OtAjvkgcY@chcpu18>
References: <aOzRF9JB9VkBKapw@osx.local>
 <6599bf31-1099-426d-a8e5-902c3d98e032@web.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6599bf31-1099-426d-a8e5-902c3d98e032@web.de>
X-Env-From: sfual

On Wed, Oct 15, 2025 at 04:52:23PM +0200, Markus Elfring wrote:
> > This patch fixes …
> 
> * Will another imperative wording approach become more helpful for an improved
>   change description?
>   https://apc01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Ftree%2FDocumentation%2Fprocess%2Fsubmitting-patches.rst%3Fh%3Dv6.17%23n94&data=05%7C02%7Csfual%40connect.ust.hk%7Caffcb410915f4b4bc8f308de0bfa853c%7C6c1d415239d044ca88d9b8d6ddca0708%7C1%7C0%7C638961367775911255%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=bThHSbvjokcDU6hNpnYxt4%2BlVyzlyxHl1JopGmCLY%2FQ%3D&reserved=0
> 
> * Would it be more helpful to use the label “put_tlink” instead of “out”?
> 
> * Can a subject like “smb: client: Complete reference counting in three functions”
>   be nicer?
> 
> 
> Regards,
> Markus

Hi,

Thanks for the suggestions. My apologies for the inapproriate wording. 
Here's my updates. Please do let me know if it still needs improvement.
I will definitely address these issues in patch v2.

1. An improved patch description

Fix three refcount inconsistency issues related to `cifs_sb_tlink`. 

Comments for `cifs_sb_tlink` state that `cifs_put_tlink()` needs to be 
called after successful calls to `cifs_sb_tlink`. Three callsites fail 
to update refcount accordingly, leading to possible resource leaks.

Fixes: 8ceb98437946 ("CIFS: Move rename to ops struct")
Fixes: 2f1afe25997f ("cifs: Use smb 2 - 3 and cifsacl mount options getacl functions")
Fixes: 366ed846df60 ("cifs: Use smb 2 - 3 and cifsacl mount options setacl function")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>

2. New subject: [PATCH v2] smb: client: Complete reference counting in three functions

3. Labels are changed accordingly

@@ -3212,8 +3212,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
        utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
        if (!utf16_path) {
                rc = -ENOMEM;
-               free_xid(xid);
-               return ERR_PTR(rc);
+               goto put_tlink;
        }

        oparms = (struct cifs_open_parms) {
@@ -3245,6 +3244,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
                SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
        }

+put_tlink:
        cifs_put_tlink(tlink);
        free_xid(xid);

@@ -3285,8 +3285,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
        utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
        if (!utf16_path) {
                rc = -ENOMEM;
-               free_xid(xid);
-               return rc;
+               goto put_tlink;
        }

        oparms = (struct cifs_open_parms) {
@@ -3307,6 +3306,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
                SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
        }

+put_tlink:
        cifs_put_tlink(tlink);
        free_xid(xid);
        return rc;

Thanks,
Shuhao
