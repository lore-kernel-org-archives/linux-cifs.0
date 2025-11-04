Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE1733710D;
	Tue,  4 Nov 2025 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762275447; cv=pass; b=qVqoLjakDhA6+9yC0HpAjY90rDJQrD5clEyE51paVJrd+0vbsK9dVVwZGQBEvArgyS4ruxSqa8hjVQHendXEbHdT6toGzJLJdCKXGx9GNTy5y3lyMBgyt9/F4JJfJWJ9o4LB2yhaj/eX4sDX8NMY01jx9/8enalZwcwREZ5gQsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762275447; c=relaxed/simple;
	bh=YYIMH53HBHk2TPn5jU8Fcn4xNukezoAye4WzOc7qoSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMI7yobxZ7W4accP+soSfGgYh50z9Nz3CUKSPClZiT4uRmDM70vb5dkNZ8VaULGWhrTOph0LBcDx+LE0US5g2RxrHAq739dBDnpsAdUL7D53MsNSH7qNu2G0c/mHGOicykh0lkFGaMJhH8qJf5oHrAMTsmgjGyGjIZ/NK2UFQ3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=zYPp8PRd; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="zYPp8PRd"
Received: from chcpu18 (191host009.mobilenet.cse.ust.hk [143.89.191.9])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 5A4GueO5331024
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Nov 2025 00:56:41 +0800
ARC-Seal: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse; t=1762275402; cv=none;
	b=U1HuaaCt6Ocr0p+yRso7dGbzhpnPPBdV6o45qeWz/xxaLpfvGo2QRVUn4+2O2tAnzKpngHsYJJ/JltfZqCj2hmZAWBWSaYO08SGnNDcAc9BCZAUA/wm+6lr0KicTIZXy/Lf/WMh6P5ZezkpO2WeEFdrgenhtV8lLGcmFA8f1yig=
ARC-Message-Signature: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse;
	t=1762275402; c=relaxed/relaxed;
	bh=dF21PmcLWVQ+pvG3FJNdRfJkuHk9+cjzqFLWm9fZJ6U=;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=U0JwSIlWtZE27e3lT2cRsekwwQwNvnIzjPIjO2VzFmaxn8nTfAh7fAFNxIN9wFUBxQyIUE9jRGTjJqlTu+DYZtt4yb24NrBVoZHnVLRDyD2rBmbDHHvslCBUtoub5wUzuokjMJI2p+FOIxtQJ7/e1SSniA2RNoGDHLJIVBpXKpI=
ARC-Authentication-Results: i=1; cse.ust.hk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1762275402;
	bh=dF21PmcLWVQ+pvG3FJNdRfJkuHk9+cjzqFLWm9fZJ6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zYPp8PRdtH57eRd2TiXY+M8K3eBkh8x76ADf8fuDlWOR+chL6ZGfgT1O52JuXMI7i
	 N3KGpd1ceNkziudAdnGYLPw8aSVaU0XuCHWJbXBlFzq0o7FRrI+jXVNZLGteWGG4a9
	 O/kCPgfK0VS45xsSPXrvzC5UuOziR9sxEk1npn/8=
Date: Tue, 4 Nov 2025 16:56:35 +0000
From: Shuhao Fu <sfual@cse.ust.hk>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Steve French <sfrench@samba.org>, Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH] smb: client: fix refcount leak in smb2_set_path_attr
Message-ID: <aQowQ7gCdDruGVro@chcpu18>
References: <aQoYCxKqMHwH4sOK@osx.local>
 <CAH2r5mu7s4p88RhUbCm5mqUvEVM60OOTTJOZ+rz09nFfc+t3mQ@mail.gmail.com>
 <648b7b14-d285-449a-a1b3-4cd062a55b02@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <648b7b14-d285-449a-a1b3-4cd062a55b02@suse.com>
X-Env-From: sfual

On Tue, Nov 04, 2025 at 01:23:33PM -0300, Henrique Carvalho wrote:
> 
> 
> On 11/4/25 1:12 PM, Steve French via samba-technical wrote:
> > There are multiple callers - are there callers that don't call
> > "set_writeable_path()" ?    And so could cause the reverse refcount
> > issue?
> 
> Yes... Even if it does not cause an issue today, that fix looks like it
> belongs inside smb2_rename_path?

I placed decrement in `smb2_set_path_attr` since it seems like a wrapper
of `smb2_compound_op`. I figured that this wrapper should handle the
failure cases the same way as `smb2_compound_op`.

Thanks,
Shuhao
> 
> > 
> > On Tue, Nov 4, 2025 at 9:21 AM Shuhao Fu <sfual@cse.ust.hk> wrote:
> >>
> >> Fix refcount leak in `smb2_set_path_attr` when path conversion fails.
> >>
> >> Function `cifs_get_writable_path` returns `cfile` with its reference
> >> counter `cfile->count` increased on success. Function `smb2_compound_op`
> >> would decrease the reference counter for `cfile`, as stated in its
> >> comment. By calling `smb2_rename_path`, the reference counter of `cfile`
> >> would leak if `cifs_convert_path_to_utf16` fails in `smb2_set_path_attr`.
> >>
> >> Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
> >> Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
> >> ---
> >>  fs/smb/client/smb2inode.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> >> index 09e3fc81d..69cb81fa0 100644
> >> --- a/fs/smb/client/smb2inode.c
> >> +++ b/fs/smb/client/smb2inode.c
> >> @@ -1294,6 +1294,8 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
> >>         smb2_to_name = cifs_convert_path_to_utf16(to_name, cifs_sb);
> >>         if (smb2_to_name == NULL) {
> >>                 rc = -ENOMEM;
> >> +               if (cfile)
> >> +                       cifsFileInfo_put(cfile);
> >>                 goto smb2_rename_path;
> >>         }
> >>         in_iov.iov_base = smb2_to_name;
> >> --
> >> 2.39.5 (Apple Git-154)
> >>
> >>
> > 
> > 
> 
> -- 
> Henrique
> SUSE Labs
