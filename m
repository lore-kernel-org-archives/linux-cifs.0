Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D192D3733
	for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501070; cv=pass; b=KkBjgSEVTpfsdJk/Pd3oDrtw6FJNflQIjJUVSebm0y9K9ddNJ5ZztGksBVBAnlR7ocFrwn63GnhQVWNSQsLQT6+qt/AgH5gNCUfENKDkPO0Ke+rCcgvxqffhdA9yOkIZ9EEV2+XV8wSkqtyGhq6csVauG5od3tdczCwui+hTOC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501070; c=relaxed/simple;
	bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n2lwoU82V071XbC7vbtit8lye8o4ELPpNcWxh1CBkvSZO75elLWZ3qRMfwqSFCvgAFxj9Uan1TByqewt8VlAUFTdK99SaE9nD/iXLslg+t0UMLixNMOi9wL6kFURI3fQziVqmdgBBAxXDaOCeP02JKM+PPWKGaErvAKRm9hPU44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRqy9Oiq; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRqy9Oiq"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b9230f564so1674491a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 10:17:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768501067; cv=none;
        d=google.com; s=arc-20240605;
        b=GJyCVS65xmRkECGY8l4o+CfoIimFl3zyfN4EQbGgANaJPOVGmC6topZqNjNfgOetHB
         fUZG3chPCiVF8iDbd8HGIGTzZe7pFwzy1MPOvRtjBMMCLaiFJEYAdeBELQh0y1GTnCmd
         v/1C4ZneN53mezwQX/RijmL7h2QDZ2/iPjBwXvd3fT5mqFgCD3+iPiHdf5BblySM8I7e
         8Oud5Q4FHtPpaHK9u/6F7EM7JlXHN+EYoQ6MFtcIm/H7nLH9T40892wIQ/9zvt+pZk/C
         jyGUhM7AWhpEpfw9y5D+PSeKCDdm9KGyZKEOVW0VhJ1H9H55x5MbJDtc6sVCajSM7LFP
         EW7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        fh=QfucfzLtZjKi0cmJLnLN5JULlBm/sUKBH2tn9mW8nnE=;
        b=egzRfaBZPiZdce7NXrBOnFhADPm+IwkoWDEbnrusY3Wjte0WUtnki3064I2wGTQcQU
         OsAz+mpNazy5rBsiGpnBbrqmx3iyJqCCEz1k54av6Tj7sAA5OW0e2WZmM1eXNbR2HPHm
         faP5buN/TZBbu2d1QwT6csM81sTUfQVlLqVqKUNJBEFHhY+YIouDrx8y1noBxJAxWSG2
         QfKXqdAREUSDIKc0V2wbb0dLgKaffHrPYU0NPmHSmrJMvNvjimpbYn1ahnfg1lRkefuI
         zfBQ6hx8WCTfyvpqHqPm+mhFeE8sUGUt+AWFRxM0Mzb2SaduORbxYtQ+qxPJvwUiLXEV
         RVuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768501067; x=1769105867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=JRqy9OiqbHt3NQq3XCkGStTAlcxglCMEMq+vkPdztBR4c+MkrffxyXlppZJ7bL4sv3
         +FXHo4WCeS6ifCEJXW+UdjZqdayxLi0mNMYJfj32IOulawR+3uE9C6Ut2x3X5eVTlY8+
         6iRo29sMNevgrrtfjtiRzEF0k4plHYlK2kgxZb4KZPdGjfbpVgT/wXn6hxIwTOtPADbq
         2v6VOk25RJEEoHnf4r5a+RfNediJCsI/4TTnPiMJgJQLHdyofqjBzPnr34u+fCoLT989
         FV5CVbIQ4AFknrnsxqTVaClS78Bq+9klbvidUC90tZ/EK9JmXeohHKVG3ipODkA8GlnY
         LSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501067; x=1769105867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=AhjOx4eczdiDduImJmeNVMg+6fcJogc/6PmoV2NSFWN3t+/rXYVte25+OENaP1JhxD
         0GKanLdJ1czqCbTaF4MIHwpUdiJrLc1LBfMveFKxozh4QqYkI1SP3DnNFkwy9fP5RlhX
         PK/sTuG8XCfP5sOBZixda9PJ/o9AdauXqMj9dvYT00a0aHy3CVZdVatejQr4zOvxulAl
         xggGTx57sXiE7S7mIEzsZ0wjCFNvYPBtjuMl/52pzWJE08DXNKmie4Mgf0hGdBDsDKdR
         5owXa4HNrFaAsH1GTm70Rtu+c2JF4wdgQn5wUJ+Aqa77eC0dl92gEQc6dncX4AefQMsf
         7ehw==
X-Forwarded-Encrypted: i=1; AJvYcCUO8+vJFAlHhhsSWl8NoCZ2Wm+uzbAmvZuD1UkZGmGFocLqSl518XEnIn+6BjIS1CzPfEYcOdslzFe+@vger.kernel.org
X-Gm-Message-State: AOJu0YxzRsPR6lyDBJjJ7ScXxuGYxH/QPCoVvUwPjDAc4unZ+bi+BvOk
	Q77KqqqN25X3FCCmsjpJCsutTHiJRfDSUaaRm84IDCWtPsLA2BeswQvDAFoMyaB5562lvTHS9RZ
	J34c2w4CsrAIb1iwxkYV6FhdbOkxRhsc=
X-Gm-Gg: AY/fxX5bkfAvCph8XuhZ66n9hH3NAJxwC76uPMdkOXlAzYNRrM+XH9/2h0HamLlWMHh
	a7D26NM+GFn14RdgUV8e3dVBi5t7UKvx3dKl8O2pIIwQkGyejSpY7VwBP42BDVzxEvJBuBJAAUD
	xlMgm1Yg8IWyB/W/eq1NUpLbZhsQwfi3H2Cn/hhyEue2Y4WyISHpcj176BAz2vL+yvTafKVNk5l
	hs3OPXDaIJVwNhuWiL+g16oETlKxpsm4eBw/9vA7qveYpJQuTCTuKo9YLtzovGDdW8KBVhqKZxz
	6BevHszqZXbclEEPp3p5iQWAco3wzA==
X-Received: by 2002:a05:6402:510f:b0:64b:7eba:39ed with SMTP id
 4fb4d7f45d1cf-654525ccad4mr346097a12.13.1768501066374; Thu, 15 Jan 2026
 10:17:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:17:35 +0100
X-Gm-Features: AZwV_QjhT3ZtgvkbHJB7796GEklGCbcNDL5CeRwrn_YYeN3X8FqPO-3_iRnRORw
Message-ID: <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> In recent years, a number of filesystems that can't present stable
> filehandles have grown struct export_operations. They've mostly done
> this for local use-cases (enabling open_by_handle_at() and the like).
> Unfortunately, having export_operations is generally sufficient to make
> a filesystem be considered exportable via nfsd, but that requires that
> the server present stable filehandles.

Where does the term "stable file handles" come from? and what does it mean?
Why not "persistent handles", which is described in NFS and SMB specs?

Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
by both Christoph and Christian:

https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e93c0=
0c@brauner/

Am I missing anything?

Thanks,
Amir.
