From: Jeff Layton <jlayton@samba.org>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Thu, 13 Oct 2011 13:27:55 -0400
Message-ID: <20111013132755.6c5db87e@barsoom.rdu.redhat.com>
References: <20110927212810.GA12900@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20110927212810.GA12900@elgon.mountain>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 28 Sep 2011 00:28:10 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> This solves a problem for where a user without write permissions
> was creating empty files.  This function was supposed to do a lookup
> only, the create happens later.
> 

Not quite. This uses the open-intent goop in the VFS layer that Al Viro
is trying to get rid of. The idea here is that doing a lookup just to
do an open is a waste, when you could just attempt the open. There's no
real reason to exempt creates from that if cifs used a sane permissions
model...

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 72d448b..8515afe 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -566,11 +566,13 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  		if (nd && !(nd->flags & LOOKUP_DIRECTORY) &&
>  		     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_open &&
>  		     (nd->intent.open.file->f_flags & O_CREAT)) {
> +			unsigned int f_flags;
> +
> +			f_flags = (nd->intent.open.file->f_flags & ~O_CREAT);
>  			rc = cifs_posix_open(full_path, &newInode,
>  					parent_dir_inode->i_sb,
>  					nd->intent.open.create_mode,
> -					nd->intent.open.file->f_flags, &oplock,
> -					&fileHandle, xid);
> +					f_flags, &oplock, &fileHandle, xid);

	...so this makes it only do the open at lookup time if the
	file already exists.

	I suspect the real problem here is that cifs is trying to
	enforce permissions on the client, which happens after the
	lookup.

	If the client simply allowed the server to handle the
	permissions (and used the right credentials for each user),
	then this would probably work fine. Another nail in the coffin
	for the whole model of client side permissions enforcement,
	IMO...

	In any case, this seems fine to me, so...

>  			/*
>  			 * The check below works around a bug in POSIX
>  			 * open in samba versions 3.3.1 and earlier where

Acked-by: Jeff Layton <jlayton@samba.org>
