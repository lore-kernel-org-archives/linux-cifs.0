Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994D83376BC;
	Tue,  4 Nov 2025 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762275360; cv=pass; b=OSrgnJV52/CXUzyBi26EksaUeOH9F5dT3klDHsWOAe+HJH8I+KtpLLBrRV3GHsDs+gD33ecl3YJqWOxm+kB0JzDyBiujjKpPPEXZVlS0VLjB4hRWj1yL8d5AVatEQ1CPnxRkoUm66b01xH2n8ORtrmqJO0vWA7t1GW0To7R8lOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762275360; c=relaxed/simple;
	bh=vIyVfMR2buyGeGBDVl/rR50P06n+PXCb0BB6dzamIEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pG6xHPuEHF7P3xelkWNeoxFWAMrSQG2pY8rCEMb/LDcqKdLuxRFHm8ouc6NO/Qs1ETJUbqadZrwYfyWusRLc4s2+ggGpGcu0JSrJnuaclRebxH+0NRrcI1lsaX4Sw61B7/4dfx5Mvo1f3DPBQB7t27WuRZLVQI7vNYVpWOVBOI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=ewzmccYU; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="ewzmccYU"
Received: from chcpu18 (191host009.mobilenet.cse.ust.hk [143.89.191.9])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 5A4Gsrl8330884
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Nov 2025 00:54:59 +0800
ARC-Seal: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse; t=1762275300; cv=none;
	b=sYI+6aGH19CQHhqoLp/WQZaKoG7Bg9VutgkX64jzigzXU5Hiz5NH9okwGTlgGA/C35N5v5gRizHxy29JzKD8lOPVIpx4yUFIMfMaOureZNGt4cY71+B+Wf1rUDRz4B7NBPJnwzT2zuKrk2SCwYdMaNOb2+6xbArwZ+lOPlqlcVM=
ARC-Message-Signature: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse;
	t=1762275300; c=relaxed/relaxed;
	bh=eJJ7GoEEDG7agyk6UWtkeilQgobjPRDZEHv7pPF8c0w=;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=rnyq17N5QOGAHo1Ib0GUYmCJWlnR4k6hTXAxZfhkpUdjKOs7qMJqApLhUp71CaqAmmaWJXE/D3yK1CqFk5CqiSoLIfmRwGA7oDdMp/WSru8DMhTDPf1A08rRG1ed5F2o0+XGLvlGQvXM6fmZGNnf+btuhtelq15v8FdqbyBFB9s=
ARC-Authentication-Results: i=1; cse.ust.hk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1762275300;
	bh=eJJ7GoEEDG7agyk6UWtkeilQgobjPRDZEHv7pPF8c0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ewzmccYUUwYR4wtVidKKQUlxtdRbCgP6N+tNlUAbA2zEnK0XjHpdoqIonAK7+vVGo
	 7no71Sn2e1WOmwts5u1pITCSg55CKwLsBS7fDjSj5l4h0IIoxKzxt2pRRSH4mO7Ady
	 TIE6XSoNryDjL1OWItfSPo24/JZjVW+DfShw59zg=
Date: Tue, 4 Nov 2025 16:54:48 +0000
From: Shuhao Fu <sfual@cse.ust.hk>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix refcount leak in smb2_set_path_attr
Message-ID: <aQov2KFhe8Ro3CtC@chcpu18>
References: <aQoYCxKqMHwH4sOK@osx.local>
 <CAH2r5mu7s4p88RhUbCm5mqUvEVM60OOTTJOZ+rz09nFfc+t3mQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mu7s4p88RhUbCm5mqUvEVM60OOTTJOZ+rz09nFfc+t3mQ@mail.gmail.com>
X-Env-From: sfual

On Tue, Nov 04, 2025 at 10:12:13AM -0600, Steve French wrote:
> There are multiple callers - are there callers that don't call
> "set_writeable_path()" ?    And so could cause the reverse refcount
> issue?

I found three calls to `smb2_set_path_attr`. Two in `smb2_rename_path`
and one in `smb2_create_hardlink`. The one in `smb2_create_hardlink`
passes NULL for cfile. Therefore, it would not cause reverse refcount
issue here.

Thanks,
Shuhao
> 
> On Tue, Nov 4, 2025 at 9:21 AM Shuhao Fu <sfual@cse.ust.hk> wrote:
> >
> > Fix refcount leak in `smb2_set_path_attr` when path conversion fails.
> >
> > Function `cifs_get_writable_path` returns `cfile` with its reference
> > counter `cfile->count` increased on success. Function `smb2_compound_op`
> > would decrease the reference counter for `cfile`, as stated in its
> > comment. By calling `smb2_rename_path`, the reference counter of `cfile`
> > would leak if `cifs_convert_path_to_utf16` fails in `smb2_set_path_attr`.
> >
> > Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
> > Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
> > ---
> >  fs/smb/client/smb2inode.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index 09e3fc81d..69cb81fa0 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -1294,6 +1294,8 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
> >         smb2_to_name = cifs_convert_path_to_utf16(to_name, cifs_sb);
> >         if (smb2_to_name == NULL) {
> >                 rc = -ENOMEM;
> > +               if (cfile)
> > +                       cifsFileInfo_put(cfile);
> >                 goto smb2_rename_path;
> >         }
> >         in_iov.iov_base = smb2_to_name;
> > --
> > 2.39.5 (Apple Git-154)
> >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
