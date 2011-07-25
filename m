From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] factor dirent handling
Date: Mon, 25 Jul 2011 16:46:01 -0500
Message-ID: <CAH2r5ms60094VYmPr0xMnbuTY-QHY1rx0JgD9DOWSF2_hoTTOw@mail.gmail.com>
References: <20110716192334.GA26847@infradead.org>
	<20110719065749.2fdceac4@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110719065749.2fdceac4-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jul 19, 2011 at 5:57 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sat, 16 Jul 2011 15:23:34 -0400
> Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
>> Introduce a common cifs_dirent structure to abstract away the code
>> dealing with directory entries from the various on the wire forms.
>
> Nice cleanup, Christoph. I've looked over the set and it looks good to me.
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Yes.  Makes readdir.c much cleaner.  I fixed up the whitespace problems
with patch3 and merged.


-- 
Thanks,

Steve
