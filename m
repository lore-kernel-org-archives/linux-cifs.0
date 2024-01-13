Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B7F15BD;
	Sat, 13 Jan 2024 09:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2ToNoTZ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33677fb38a3so6607701f8f.0;
        Sat, 13 Jan 2024 01:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705138309; x=1705743109; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=opM7SLrUV92LeRt9jPrfn8XuUI+wI1iBDU8hNXHjbfc=;
        b=e2ToNoTZQsoeBqWeu/L3NRfWBWeVIOkpK1GouCISQ9zRnqAD4LKk4QnngMMZmCLNJj
         OX+lvsMJAo8WTZwp5CqArg6D4ka/WCCWZxJX6wbhPHGHaNGgFtZitNyIXRN3/+OEhaVC
         IlbNb01PwnvYkMunNH8unDT6jnsc8vlURbXj33+gC41RbNE9ZTbPzDVP73McFx1g1iWj
         4X+sJCYINOxRwEcjoyQCi5JP8zTgMXMl05y+BzZ7b9sXhoE4kaBpFn+eh6nTtmFGM13K
         OF+/jLBFs0hmbQadndUknmWj/gR9W8HRwLU+HcM2hJrFCMGeXywO9wstBf40y+LyzW64
         bNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705138309; x=1705743109;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opM7SLrUV92LeRt9jPrfn8XuUI+wI1iBDU8hNXHjbfc=;
        b=jq3P7aLUq3T/xdeUV4hhkbF+rgGn47H3g76eT7fGyO93V3zSPcmI5Cg60GVFNC05bR
         hhBDxBzz/tCT3fHv9Xhnid+VHVASMWXLDJgf0fqzl5K7imKFe0n5j2Uo8EcEsLpaDj3i
         4cxDZb2hcfW0tJGUSdhU8aotUI8BF4ExtUTn7IZsHyXkeG33b6nURGeC60cIc1DnrYUb
         Wbvy/ny5n/j1NVvFWfyjftFP8CmA3Uhs5QMSitpNdxqM2FVJGDgDzcpDuIraPeExFDkl
         6VLBoJetHEB6Smi6Ge7nVLoG3KxB71OPpXnAR3PbYk/ljfR5tBMEo/Bcgwmz0NEfPy+G
         Gfxw==
X-Gm-Message-State: AOJu0YxYkBCxCUhdSpN03Y3xiXyNKCzKqxJBN+9VI6fSq14RGT2X0s6t
	dmVmZcIXxGnhgiYC3av/iP4=
X-Google-Smtp-Source: AGHT+IFWeho2w4T+a6I6b9eXtNrBJ3WfBM9sSehTQUYNxMkbMZNmI5zb4k+0KVCWCJVfERbqYZ2Fdg==
X-Received: by 2002:a5d:5583:0:b0:336:6ad2:b64e with SMTP id i3-20020a5d5583000000b003366ad2b64emr1342497wrv.48.1705138308668;
        Sat, 13 Jan 2024 01:31:48 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id m6-20020adffa06000000b00336c6b77584sm6249431wrr.91.2024.01.13.01.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jan 2024 01:31:47 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 0BF12BE2DE0; Sat, 13 Jan 2024 10:31:47 +0100 (CET)
Date: Sat, 13 Jan 2024 10:31:46 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	"Jitindar Singh, Suraj" <surajjs@amazon.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org,
	Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [Regression 6.1.y] From "cifs: Fix flushing, invalidation and
 file size with copy_file_range()"
Message-ID: <ZaJYgkI9o5J1U3TX@eldamar.lan>
References: <2023121124-trifle-uncharted-2622@gregkh>
 <a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com>
 <ZZhrpNJ3zxMR8wcU@eldamar.lan>
 <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info>
 <ZZk6qA54A-KfzmSz@eldamar.lan>
 <13a70cc5-78fc-49a4-8d78-41e5479e3023@leemhuis.info>
 <ZZ7Dy69ZJCEyKhhS@eldamar.lan>
 <2024011115-neatly-trout-5532@gregkh>
 <2162049.1705069551@warthog.procyon.org.uk>
 <CAH2r5mtBSvp9D8s3bX7KNWjXdTuOHPx5Z005jp8F5kuJgU3Z-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtBSvp9D8s3bX7KNWjXdTuOHPx5Z005jp8F5kuJgU3Z-g@mail.gmail.com>

Hi,

On Fri, Jan 12, 2024 at 11:20:53PM -0600, Steve French wrote:
> Here is a patch similar to what David suggested.  Seems
> straightforward fix.  See attached.
> I did limited testing on it tonight with 6.1 (will do more tomorrow,
> but feedback welcome) but it did fix the regression in xfstest
> generic/001 mentioned in this thread.
> 
> 
> 
> 
> On Fri, Jan 12, 2024 at 8:26 AM David Howells <dhowells@redhat.com> wrote:
> >
> > gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:
> >
> > > I guess I can just revert the single commit here?  Can someone send me
> > > the revert that I need to do so as I get it right?
> >
> > In cifs_flush_folio() the error check for filemap_get_folio() just needs
> > changing to check !folio instead of IS_ERR(folio).
> >
> > David
> >
> >
> 
> 
> --
> Thanks,
> 
> Steve

> From ba288a873fb8ac3d1bf5563366558a905620c071 Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Fri, 12 Jan 2024 23:08:51 -0600
> Subject: [PATCH] cifs: fix flushing folio regression for 6.1 backport
> 
> filemap_get_folio works differenty in 6.1 vs. later kernels
> (returning NULL in 6.1 instead of an error).  Add
> this minor correction which addresses the regression in the patch:
>   cifs: Fix flushing, invalidation and file size with copy_file_range()
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Reported-by: Salvatore Bonaccorso <carnil@debian.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/smb/client/cifsfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 2e15b182e59f..ac0b7f229a23 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -1240,7 +1240,7 @@ static int cifs_flush_folio(struct inode *inode, loff_t pos, loff_t *_fstart, lo
>  	int rc = 0;
>  
>  	folio = filemap_get_folio(inode->i_mapping, index);
> -	if (IS_ERR(folio))
> +	if ((!folio) || (IS_ERR(folio)))
>  		return 0;
>  
>  	size = folio_size(folio);

I was able to test the patch with the case from the Debian bugreport
and seems to resolve the issue. Even if late, as Greg just queued up
already:

Tested-by: Salvatore Bonaccorso <carnil@debian.org>

I wonder, but cannot(!) confirm, might there have been other such
backports in 6.1.y which are incorrect? At least it does not seem the
case so far for other uses of checking IS_ERR(folio) in v6.1.72 where
were using filemap_get_folio. So I guess the other cases are all okay.
In v6.1.72 finding those:

block/partitions/core.c-
block/partitions/core.c-        folio = read_mapping_folio(mapping, n >> PAGE_SECTORS_SHIFT, NULL);
block/partitions/core.c:        if (IS_ERR(folio))
--
drivers/scsi/scsicam.c-
drivers/scsi/scsicam.c- folio = read_mapping_folio(mapping, 0, NULL);
drivers/scsi/scsicam.c: if (IS_ERR(folio))
--
fs/ceph/addr.c-
fs/ceph/addr.c- folio = read_mapping_folio(inode->i_mapping, 0, file);
fs/ceph/addr.c: if (IS_ERR(folio)) {
--
fs/erofs/data.c-                folio = read_cache_folio(mapping, index, NULL, NULL);
fs/erofs/data.c-                memalloc_nofs_restore(nofs_flag);
fs/erofs/data.c:                if (IS_ERR(folio))
--
fs/ext2/dir.c-  struct folio *folio = read_mapping_folio(mapping, n, NULL);
fs/ext2/dir.c-
fs/ext2/dir.c:  if (IS_ERR(folio))
--
fs/smb/client/cifsfs.c-
fs/smb/client/cifsfs.c- folio = filemap_get_folio(inode->i_mapping, index);
fs/smb/client/cifsfs.c: if (IS_ERR(folio))
--
fs/verity/enable.c-                     page_cache_sync_ra(&ractl, remaining_pages);
fs/verity/enable.c-             folio = read_cache_folio(ractl.mapping, index, NULL, file);
fs/verity/enable.c:             if (IS_ERR(folio))
--
mm/filemap.c-
mm/filemap.c-   folio = do_read_cache_folio(mapping, index, filler, file, gfp);
mm/filemap.c:   if (IS_ERR(folio))
--
mm/shmem.c-     huge_gfp = limit_gfp_mask(huge_gfp, gfp);
mm/shmem.c-     folio = shmem_alloc_and_acct_folio(huge_gfp, inode, index, true);
mm/shmem.c:     if (IS_ERR(folio)) {
--
mm/shmem.c-             folio = shmem_alloc_and_acct_folio(gfp, inode, index, false);
mm/shmem.c-     }
mm/shmem.c:     if (IS_ERR(folio)) {

where only fs/smb/client/cifsfs.c was using filemap_get_folio() in this context.

Regards,
Salvatore
