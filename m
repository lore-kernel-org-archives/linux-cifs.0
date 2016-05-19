From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: manual merge of the vfs tree with Linus' tree
Date: Wed, 18 May 2016 21:02:09 -0500
Message-ID: <CAH2r5msJhov7j9sAH3YxJUaED3JATsZmraAzQAzV1ZteiGMsCQ@mail.gmail.com>
References: <20160519111702.752921f8@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20160519111702.752921f8@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

As noted below, it is easier to remove the obsolete comments and I
just pushed the following trivial patch to cifs-2.6.git for-next to do
that.

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=fea17ae8ac1c8c44b2fd1c02ae2e15b847d327d1



On Wed, May 18, 2016 at 8:17 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Al,
>
> Today's linux-next merge of the vfs tree got a conflict in:
>
>   fs/cifs/cifsfs.c
>
> between commit:
>
>   a9ae008f407b ("cifs: Switch to generic xattr handlers")
>
> from Linus' tree and commit:
>
>   51085a1f913a ("cifs: use C99 syntax for inode_operations initializer")
>
> from the vfs tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
> Al: the c99 fixup is not really necessary as the line is commented out
> and you didn't fix the one in the line above ... a better fix might be
> to delete both those lines?
> --
> Cheers,
> Stephen Rothwell
>
> diff --cc fs/cifs/cifsfs.c
> index 67f622df0858,586d4eadd49e..000000000000
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@@ -917,11 -919,13 +917,11 @@@ const struct inode_operations cifs_syml
>         .permission = cifs_permission,
>         /* BB add the following two eventually */
>         /* revalidate: cifs_revalidate,
> -          setattr:    cifs_notify_change, *//* BB do we need notify change */
> +       .setattr = cifs_notify_change, *//* BB do we need notify change */
>  -#ifdef CONFIG_CIFS_XATTR
>  -      .setxattr = cifs_setxattr,
>  -      .getxattr = cifs_getxattr,
>  +      .setxattr = generic_setxattr,
>  +      .getxattr = generic_getxattr,
>         .listxattr = cifs_listxattr,
>  -      .removexattr = cifs_removexattr,
>  -#endif
>  +      .removexattr = generic_removexattr,
>   };
>
>   static int cifs_clone_file_range(struct file *src_file, loff_t off,



-- 
Thanks,

Steve
