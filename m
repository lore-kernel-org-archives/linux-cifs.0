From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: revalidate inode before generic_file_aio_read
Date: Thu, 10 Mar 2011 15:44:14 +0530
Message-ID: <4D78A476.7050800@suse.de>
References: <AANLkTinfzBXvfNmerWHoMuZ8NkeZLJxNE=MJYcFhA8Nu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinfzBXvfNmerWHoMuZ8NkeZLJxNE=MJYcFhA8Nu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/10/2011 02:02 PM, Pavel Shilovsky wrote:
> Hi all!
> 
> As soon as we have tunable actimeo, I think we should revalidate inode
> all the time we want to read from it, like NFS does it.

Did you mean while using strict cache along with actimeo? Conceptually
one should not be needing to use them together, right?

> What do you think about it? If it's ok, I am ready to provide a patch for this.
> 


-- 
Suresh Jayaraman
