From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Avoid calling unlock_page() twice in cifs_readpage() when using fscache
Date: Fri, 13 Sep 2013 14:30:33 +0100
Message-ID: <31932.1379079033@warthog.procyon.org.uk>
References: <1378997931-19954-1-git-send-email-sprabhu@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378997931-19954-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Looking at this:

	static int cifs_readpage_worker(struct file *file, struct page *page,
		loff_t *poffset)
	{
		char *read_data;
		int rc;

		/* Is the page cached? */
		rc = cifs_readpage_from_fscache(file_inode(file), page);
		if (rc == 0)
			goto read_complete;

Should you return here if rc == -ENOMEM or -ERESTARTSYS?  That might break
cifs_write_begin() though - which perhaps ought to check the return value.

Your patch, however, looks okay otherwise, so feel free to add:

	Acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

David
