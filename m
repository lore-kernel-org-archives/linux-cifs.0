From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/9] fallback to CIFSSMBQPathInfoBasic() in
 cifs_is_path_accessible()
Date: Fri, 22 Nov 2013 09:52:06 -0500
Message-ID: <20131122095206.1a6d92a1@tlielax.poochiereds.net>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
	<1385116018-14068-1-git-send-email-gbeck@sernet.de>
	<1385116018-14068-6-git-send-email-gbeck@sernet.de>
	<20131122143546.GA27665@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131122143546.GA27665-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Nov 2013 06:35:46 -0800
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> Please provide a helper that encapsulates the calls for the different
> info levels, and then formats them into a in-kernel sanitized structure
> instead of casting around the on the wire structures, similar to how
> the directory code translates that various info levels in a cifs_dirent
> structure.
> 

Agreed. What we really need to do is to have these functions pass
around the container we already have for this: a struct cifs_fattr
rather than FILE_ALL_INFO. It's really an API abortion that even the
SMB2 calls have to pass around an SMB1 on-the-wire data structure.

Gregor, it would be best to do a patchset to fix that mess first and
then layer these changes on top of it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
