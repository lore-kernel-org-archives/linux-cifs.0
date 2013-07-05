From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use sensible file nlink values if unprovided
Date: Fri, 05 Jul 2013 18:26:32 -0400
Message-ID: <1373063192.2261.21.camel@tlielax.poochiereds.net>
References: <1372961186-19213-1-git-send-email-ddiss@suse.de>
	 <CAH2r5mtyaufgrOssd872OZzq32TQ8fyprE82aK8FV7MbxceU7g@mail.gmail.com>
	 <20130705184031.67afd669@f163.suse.de>
	 <1373061027.2261.14.camel@tlielax.poochiereds.net>
	 <CAH2r5msgztCnAZyvgmU3Y5Yupv-S=m1FXVzfN-RBQJbp0dRcyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msgztCnAZyvgmU3Y5Yupv-S=m1FXVzfN-RBQJbp0dRcyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2013-07-05 at 17:12 -0500, Steve French wrote:
> Yes - I noticed that too (although with David's patch at least it is
> better).  For the POSIX case for readdir we are ok, but for the
> non-posix case for readdir there is are only two infolevels, one too
> big and one too small (FILE_STANDARD_INFORMATION) that seem to return
> nlinks so we should be setting them to default values if we can't get
> them from the server (ie if cf_attr->nlink is 0).  This patch should
> fix it by catching it when we are about to update the inode to make
> sure we are putting a legal value in (I have not tested it yet).
> Thoughts on this minor followon patch?
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 449b6cf..8329c18 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -134,7 +134,13 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr
>         inode->i_mtime = fattr->cf_mtime;
>         inode->i_ctime = fattr->cf_ctime;
>         inode->i_rdev = fattr->cf_rdev;
> -       set_nlink(inode, fattr->cf_nlink);
> +       /* number of links on a directory is at least 2, at least 1 for file */
> +       if ((fattr->cf_cifsattrs & ATTR_DIRECTORY) && (fattr->cf_nlink < 2))
> +               set_nlink(inode, 2);
> +       else if (fattr->cf_nlink < 1)
> +               set_nlink(inode, 1);
> +       else
> +               set_nlink(inode, fattr->cf_nlink);
>         inode->i_uid = fattr->cf_uid;
>         inode->i_gid = fattr->cf_gid;
> 

There are cases where you might see a legit i_nlink value of 0. For
instance...

client> fd = open("file", ...);
server> unlink("file");
client> fstat(file, ...);

...now the server may legitimately report a link count of 0, but with
this patch we'll end up fudging it to something higher. Hence, I'm a
little leery of doing this sort of blanket overriding of cf_nlink value,
especially in the case where POSIX extensions are in force.

I think we should only do this when we really think we can't trust this
value -- i.e. the non-POSIX case. Experience has shown that
NumberOfLinks value is not *exactly* a 1:1 match with an i_nlink value
when talking to windows-y servers.

I dunno...maybe it's time to ask dochelp for clarification on what sort
of semantics we should be expecting from this field?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
