Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ABA39B959
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 12:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777291341; cv=pass; b=aQVBfXKUS8Dz2Wv1scGjF3ZDXCm0DVKpLn+4IdFP6Ra/DbrBYXsmi0yScjRFjCzqSiT931BCK+eSp22XG5+qDGrxK0QrQrIIAdXJBKQg8p4KcuUIcWNaNp4wdBkeQ/CJEEMdM1ER8uHbRw3DKPTO5LksY6LIxvunoJi5NdY9UY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777291341; c=relaxed/simple;
	bh=f7oNU5FaDQl+Nkbi/6/Ivnlhsv7ogl5Ysmt1I3aNaRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eBCDJEAMBmEEag6ABr4SvCIdWH3oxxxb/lLHiH/UQg9WrDZFr02h8m4uy73EOtkkwN5LyqcZ7Nxwtrmphv7/nEk9rk5g8KHRZ2NWdkH8dcU4cYCU82mq7dUHDjIQIr1/QfE+waLj5250UdilXWR/kxE2rLYSmfN5fcdWC8V1TJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1Qji05Y; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1Qji05Y"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67893fba9c3so7820586a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 05:02:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777291339; cv=none;
        d=google.com; s=arc-20240605;
        b=KqIBDl6jReuhBMHLubW26HgRejvC/x6HVozpN8D4d8vUuxawhijJ0CvMIiraPZz2xJ
         y/uxeG6VbOP+NZ/6ZWvT5KthT65KPCCJ8dZvTrs7Nk8ox5JAOOtfksc5NC6G5HIvW3Fz
         df0+mTN7qUhJ6Db8akVNhu4+cycQz3h4lYYngB3K0OHvrSDza2dVog1rbwUltDHX0C7B
         W5hnNvG/0izzrIIdpapbRwvaNGYaP/O4Nh4OClHkl1KFAsBB36R3/78ad9+qYNrrTLsi
         D6RU2W/f2SC1mGt3E0Ijm37xBqHywf6VvMehXjhIR/m/1XhiPC2KQlf591kcHxUrjD6K
         SmMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bSw1aMO32TuHJYbNOmDfdqPOAHdqlsV6G0A1b+WUvMY=;
        fh=4oQIyvumlZBsyb90Glk6lrvy2BumXX/vaMEbkefBi6E=;
        b=dCSikrVnYTkw9rZfqE/7Z4EqJkdW6TfjD6UR+DVFDjTBPWMPEsc3Pge2RxVxVDW9Oc
         iLqoemxi7ARoOkdLsNkAyOHQNjjJOnaAqSKVjacHDpr6CMRtPJWNLH5U9LobxDM/EuBi
         opcpPQ9B2whrsxKL40MIQFQDYrUHT3orKhi0BX3p5MID+hvgGPMt34F2+ASKYysFXZVN
         9FQqvjSspl2WAvR2WgFZOIQmkELdPgEbGT/S7HEplqIiNxJ9LyGved7PoZTOXzpTW4+Z
         4JDAcwPA5nzE/gv9r79vo3JKbBU1JqfZGOv2PE2MjXazIX/yZQIPtnthYbrHa/UzdxCI
         R7xg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777291339; x=1777896139; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bSw1aMO32TuHJYbNOmDfdqPOAHdqlsV6G0A1b+WUvMY=;
        b=L1Qji05YBSR2Px1RPMh0Qij8MMdumsVHV5YhEmf2miBD194l4h2f4Z7suJgFn1jtUi
         nzfd7Qh5/RECtOiX7nuAY1uhhuzoTTrXeMLpEZrhbXjht25kKCDiiIthtTp3DVHH5Nqx
         eMrNP697teAtC8Hv70hpPCgecgtZdpvh2VsT5utyY5amkOAKY+Yw0YFGZ/BKhJ1O6/Lw
         qfJ3koSwuyZNC3NIanPJvHA7FAEzxMODU8ZsjqoAInWEwJvYyPQ2vbfnqaO+SOYsAp7/
         a/kbMqdC5MiCHNxJE+BLEO8y0jN6NVDA5IEUYIDJmJJouMA+qdoOSNLNGUIDhH2IoA7V
         DMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777291339; x=1777896139;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSw1aMO32TuHJYbNOmDfdqPOAHdqlsV6G0A1b+WUvMY=;
        b=GtL3ZgKLCiTwMR/+UHGxD+ARmm+n/o3+Q3aUVptlKjFaSBGk+HiGkpprzumAFvo60N
         vLs40xC4xHFPR3zjdBw9CCEQV3qw2PWnu3GnvPlnuD65XgADffEgSZL+e7Fbt0GYlTXl
         NFnnQmqpvjWGxAd2088duez1gAK1mO1QkkfbfU10Dlfc7SqvOiBAzmDStu0i/1pu0Xgq
         /6z4tL0ulPGlXwgDIp8hmXnh4gtX5Yi+LofpuYtxuCQW9Yy9DfKFhnXWgoD0LtWpXknl
         +uvP+v3WccIWnJEfQU5ZIiRngzk8WAFcNDvsQ1axIavsbrM7E18fdmb1XpBOspfPfJU6
         nSaA==
X-Forwarded-Encrypted: i=1; AFNElJ8xFPhqdga490eFyVzSFzHEv3XKsn5QHW9X4hoUN4Xk3oRqDdi2uMofQV/hnEdi3VeX+A3Prvr5ZWF9@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm17RnZxxXdg++pWK0RtKTnZDEupRa5myLXwbtVG+ruDS5m7DE
	hboPROL06RM8TvL2AfdwPOMX/emvRpq6BJXg3kvgCsHfYez3KM2i447cpJfrP3VSrSERIxenKng
	qU8NEYsNecFADwMdmNQD7XxCZP66p0pY=
X-Gm-Gg: AeBDiev/vosJRKvhsoF6Yr91M0Aqn111/q5bGQs+jIqI80g+LCodaiKYdum8CjlVw6p
	2KgGcNaiFTwY0p7tB/W4voN0NMDKrkbAnCoQNlHEC+HOJ3y9v+jxgx+hAhpz8JbEa5SWBcwUdWJ
	qa6uQ8cwTKEGpCgD8bnt5M6VfN6eO//Q+JdYLdYzRJJ4yrgEdkM0/Yt0/Bvun2kWqlfHBtc9YTz
	fEDPNogtnqdQaBr3colUOVPDrNbqKpDWUCH3/ffrLJFUJljDhZt7QVe7ivWnNNaYmEfvOmZdbMF
	x5a7KVSqZcn08y7BabxaY/3rktsU
X-Received: by 2002:a05:6402:c46:b0:670:d548:da79 with SMTP id
 4fb4d7f45d1cf-672bfd87175mr18491070a12.3.1777291337998; Mon, 27 Apr 2026
 05:02:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260424-case-sensitivity-v11-0-de5619beddaf@oracle.com>
 <20260424-case-sensitivity-v11-12-de5619beddaf@oracle.com> <isfgwmd5hxjfn7dj7p54yzlhumx2hrkt3zw7fscs2ywm57g3hu@co27drpx24lq>
In-Reply-To: <isfgwmd5hxjfn7dj7p54yzlhumx2hrkt3zw7fscs2ywm57g3hu@co27drpx24lq>
From: Lionel Cons <lionelcons1972@gmail.com>
Date: Mon, 27 Apr 2026 14:02:00 +0200
X-Gm-Features: AVHnY4JzeOH_kK3jDOjK2FxeQTqZ9zkWJjZAaa-9jIyvUG0bleb4vaJ230stvGc
Message-ID: <CAPJSo4WmRu_64TxBsaimWOqz3VAU0TZ1H-_hw36HSqzQULm39w@mail.gmail.com>
Subject: Re: [PATCH v11 12/15] isofs: Implement fileattr_get for case sensitivity
To: Jan Kara <jack@suse.cz>
Cc: Chuck Lever <cel@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org, sj1557.seo@samsung.com, 
	yuezhang.mo@sony.com, almaz.alexandrovich@paragon-software.com, 
	slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, 
	hansg@kernel.org, senozhatsky@chromium.org, 
	Chuck Lever <chuck.lever@oracle.com>, Roland Mainz <roland.mainz@nrubsig.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 12:47, Jan Kara <jack@suse.cz> wrote:
>
> On Fri 24-04-26 21:53:14, Chuck Lever wrote:
> > From: Chuck Lever <chuck.lever@oracle.com>
> >
> > Upper layers such as NFSD need a way to query whether a
> > filesystem handles filenames in a case-sensitive manner so
> > they can provide correct semantics to remote clients. Without
> > this information, NFS exports of ISO 9660 filesystems cannot
> > advertise their filename case behavior.
> >
> > Implement isofs_fileattr_get() to report ISO 9660 case handling
> > behavior via the FS_XFLAG_CASEFOLD flag. The 'check=r' (relaxed)
> > mount option enables case-insensitive lookups, and this setting
> > determines the value reported. By default, Joliet extensions
> > operate in relaxed mode while plain ISO 9660 uses strict
> > (case-sensitive) mode. All ISO 9660 variants are case-preserving,
> > meaning filenames are stored exactly as they appear on the disc.
> >
> > Case handling is a superblock-wide property, so the callback
> > must report the same value for every inode type. Regular files
> > previously had no inode_operations; introduce
> > isofs_file_inode_operations to carry the callback. Symlinks
> > previously shared page_symlink_inode_operations; introduce
> > isofs_symlink_inode_operations, which wires page_get_link
> > alongside the callback, so that fileattr queries on a symlink
> > reach the isofs implementation instead of returning
> > -ENOIOCTLCMD. The flag is set in both fa->fsx_xflags and
> > fa->flags so FS_IOC_FSGETXATTR and FS_IOC_GETFLAGS agree.
> >
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Roland Mainz <roland.mainz@nrubsig.org>
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>
> ...
>
> > @@ -281,6 +293,18 @@ const struct file_operations isofs_dir_operations =
> >  const struct inode_operations isofs_dir_inode_operations =
> >  {
> >       .lookup = isofs_lookup,
> > +     .fileattr_get = isofs_fileattr_get,
> > +};
> > +
> > +const struct inode_operations isofs_file_inode_operations =
> > +{
> > +     .fileattr_get = isofs_fileattr_get,
> > +};
> > +
> > +const struct inode_operations isofs_symlink_inode_operations =
> > +{
> > +     .get_link = page_get_link,
> > +     .fileattr_get = isofs_fileattr_get,
> >  };
>
> Hum, I thought casefolding is a directory attribute. At least I don't see
> a big point in reporting it for regular files or symlinks (and then why not
> report it for device nodes or named pipes?). So why did you decide for this
> change?

Where do you see this being a per-directory attribute in
https://web.archive.org/web/20170404043745/http://www.ymi.com/ymi/sites/default/files/pdf/Rockridge.pdf

Lionel
