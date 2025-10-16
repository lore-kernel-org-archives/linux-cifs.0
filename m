Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5EA1DF970;
	Thu, 16 Oct 2025 03:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760583613; cv=pass; b=ZNS0qNOs9SpJS7s8TjAPfLgCKf8XYuLD1nCUWnKRDsr7s+oWKxYHLgwfhfsu8GpTVO7OgxNxPs22UKyM1o1+3NDAzGqplMjRC9/RbQC1xx16FqWqKDCXqVUUYi2w6B7bRhLlFwL4u5d5kIFDvUuDluMt8GNDdLMqoyZWAUnCuqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760583613; c=relaxed/simple;
	bh=xNL7BUuuMkQcf0GQtxXgcobtRppGXBjP+lpVoN3GOw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGJZUi38tPvhE70h7JMjV5KzwmZOCPEepq3AuGsHn+u7njadf/FC47qSRCzbEAkWII5A8SjR49k/xNuPItuNBPkiI3tEW5Un9tavONiayGcII62u5eXB9VvPssWeCHca3MduOur7CmIkCzEo5/o3hM0hoNMqhfLPEHCMsDiRVag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=AhSkdWzs; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="AhSkdWzs"
Received: from chcpu18 (191host009.mobilenet.cse.ust.hk [143.89.191.9])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 59G2xH853718095
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Oct 2025 10:59:23 +0800
ARC-Seal: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse; t=1760583564; cv=none;
	b=gPlLAmNE3uglVJKU/ySYsaw2efL6FSXrwGK5RkQVYdL0PdyjoujbYe34OXcCAMW4PUfQ/D32u25CWA9xW36DZdwZaPCS3aaSKKS6qRQ9LquEp3UWJJX2MBCTledXVfshgENwzEb/gq+svadeBVleAenFYnFJT4OwbfUVREqhK8g=
ARC-Message-Signature: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse;
	t=1760583564; c=relaxed/relaxed;
	bh=HYCtaGfdVH5nqhEJKMwDLQIIEDuLwR6AFmxJK7rQWn4=;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=DsM1py7cEg++50H+Bj9nfRnNTmb6mnx6GwPeD7WdSPwuvSCWpztLiyY2AGjYSLaYZ+y/Agi3uTT0pl3qAqjKHx64uvEc63M/SITY8VFu6KQFWB2z7/c/8HQJN9E/EYIMZe3wCFaIcALKZRUp8CGEjUehFcXAMpAYVhIBqJKKjd0=
ARC-Authentication-Results: i=1; cse.ust.hk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1760583564;
	bh=HYCtaGfdVH5nqhEJKMwDLQIIEDuLwR6AFmxJK7rQWn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AhSkdWzs4uA6ktb2nzfIfpNH7ckC+Rzv65GdxO+cpwgK+ribrcUkSqu69P0sMznZB
	 1YD0hNtdUYEKqnYbgq9m2GVs8Q14iw+g2MODNZSAao/2LVLyrMRU8lpUEKpAhx7sNO
	 HUg7J1yQgub+P68+982TYr6K74WNT2C+Bhpz+a7o=
Date: Thu, 16 Oct 2025 02:59:12 +0000
From: Shuhao Fu <sfual@cse.ust.hk>
To: Steve French <smfrench@gmail.com>
Cc: Markus Elfring <Markus.Elfring@web.de>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>,
        Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] smb: Fix refcount leak for cifs_sb_tlink
Message-ID: <aPBfgADPxxoV34tT@chcpu18>
References: <aOzRF9JB9VkBKapw@osx.local>
 <6599bf31-1099-426d-a8e5-902c3d98e032@web.de>
 <aO/DLq/OtAjvkgcY@chcpu18>
 <CAH2r5msK3SDhAM0_monUcNTrf5JCwydD+AJgARaiVziUUo0WmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5msK3SDhAM0_monUcNTrf5JCwydD+AJgARaiVziUUo0WmQ@mail.gmail.com>
X-Env-From: sfual

On Wed, Oct 15, 2025 at 11:29:46AM -0500, Steve French wrote:
> I don't think the title needs to be changed, it seems clear enough.
> The other changes are minor (changing goto label) and also probably
> not needed but ok if you have to update it for other reasons.
> 

Thank you for your comments. I did some minor changes to this patch, 
including better wording and nicer goto labels.

Link to v2: https://lore.kernel.org/linux-cifs/aPBeBxTQLeyFl4mx@chcpu18/

Thanks,
Shuhao

> On Wed, Oct 15, 2025 at 10:52 AM Shuhao Fu <sfual@cse.ust.hk> wrote:
> >
> > On Wed, Oct 15, 2025 at 04:52:23PM +0200, Markus Elfring wrote:
> > > > This patch fixes …
> > >
> > > * Will another imperative wording approach become more helpful for an improved
> > >   change description?
> > >   https://apc01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Ftree%2FDocumentation%2Fprocess%2Fsubmitting-patches.rst%3Fh%3Dv6.17%23n94&data=05%7C02%7Csfual%40connect.ust.hk%7Cf73c7723b8104879a14408de0c0818dd%7C6c1d415239d044ca88d9b8d6ddca0708%7C1%7C0%7C638961426106746132%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=qBAe0Dgw57Ff%2BjixeyPqtA86BO8922uMmi9sldpDlbY%3D&reserved=0
> > >
> > > * Would it be more helpful to use the label “put_tlink” instead of “out”?
> > >
> > > * Can a subject like “smb: client: Complete reference counting in three functions”
> > >   be nicer?
> > >
> > >
> > > Regards,
> > > Markus
> >
> > Hi,
> >
> > Thanks for the suggestions. My apologies for the inapproriate wording.
> > Here's my updates. Please do let me know if it still needs improvement.
> > I will definitely address these issues in patch v2.
> >
> > 1. An improved patch description
> >
> > Fix three refcount inconsistency issues related to `cifs_sb_tlink`.
> >
> > Comments for `cifs_sb_tlink` state that `cifs_put_tlink()` needs to be
> > called after successful calls to `cifs_sb_tlink`. Three callsites fail
> > to update refcount accordingly, leading to possible resource leaks.
> >
> > Fixes: 8ceb98437946 ("CIFS: Move rename to ops struct")
> > Fixes: 2f1afe25997f ("cifs: Use smb 2 - 3 and cifsacl mount options getacl functions")
> > Fixes: 366ed846df60 ("cifs: Use smb 2 - 3 and cifsacl mount options setacl function")
> > Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
> >
> > 2. New subject: [PATCH v2] smb: client: Complete reference counting in three functions
> >
> > 3. Labels are changed accordingly
> >
> > @@ -3212,8 +3212,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
> >         utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> >         if (!utf16_path) {
> >                 rc = -ENOMEM;
> > -               free_xid(xid);
> > -               return ERR_PTR(rc);
> > +               goto put_tlink;
> >         }
> >
> >         oparms = (struct cifs_open_parms) {
> > @@ -3245,6 +3244,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
> >                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> >         }
> >
> > +put_tlink:
> >         cifs_put_tlink(tlink);
> >         free_xid(xid);
> >
> > @@ -3285,8 +3285,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
> >         utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> >         if (!utf16_path) {
> >                 rc = -ENOMEM;
> > -               free_xid(xid);
> > -               return rc;
> > +               goto put_tlink;
> >         }
> >
> >         oparms = (struct cifs_open_parms) {
> > @@ -3307,6 +3306,7 @@ set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
> >                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> >         }
> >
> > +put_tlink:
> >         cifs_put_tlink(tlink);
> >         free_xid(xid);
> >         return rc;
> >
> > Thanks,
> > Shuhao
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
