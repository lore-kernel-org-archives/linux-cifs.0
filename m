From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Avoid calling unlock_page() twice in
 cifs_readpage() when using fscache
Date: Fri, 13 Sep 2013 14:41:25 +0100
Message-ID: <1379079685.7446.8.camel@sachin-laptop>
References: <1378997931-19954-1-git-send-email-sprabhu@redhat.com>
	 <31932.1379079033@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <31932.1379079033-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2013-09-13 at 14:30 +0100, David Howells wrote:
> Looking at this:
> 
> 	static int cifs_readpage_worker(struct file *file, struct page *page,
> 		loff_t *poffset)
> 	{
> 		char *read_data;
> 		int rc;
> 
> 		/* Is the page cached? */
> 		rc = cifs_readpage_from_fscache(file_inode(file), page);
> 		if (rc == 0)
> 			goto read_complete;
> 
> Should you return here if rc == -ENOMEM or -ERESTARTSYS?  That might break
> cifs_write_begin() though - which perhaps ought to check the return value.
> 
> Your patch, however, looks okay otherwise, so feel free to add:
> 
> 	Acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> David

According to the comment already above the call to
cifs_readpage_worker() in cifs_write_begin():

/*
 * might as well read a page, it is fast enough. If we get
 * an error, we don't need to return it. cifs_write_end will
 * do a sync write instead since PG_uptodate isn't set.
 */

With the patch, we ignore the error and set oncethru to 1 so that we
don't attempt to call cifs_readpage_worker() again and let
cifs_write_end do a sync_write.

Sachin Prabhu
