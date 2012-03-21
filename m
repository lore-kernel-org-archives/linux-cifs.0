From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 21 Mar 2012 19:16:49 +0000
Message-ID: <1332357411.31424.14.camel@sprabhu.fab.redhat.com>
References: <1331307197.10670.2.camel@localhost>
	 <20120321133855.52901c60@redhat.com> <1332354787.2818.7.camel@localhost>
	 <4F6A1F9F.6070101@gmail.com>
	 <1332356942.31424.12.camel@sprabhu.fab.redhat.com>
	 <CAFB9KM0YywoKwjMxijp+T-SxqZLjuOhiXkMRa5y57eYuTHOc6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM0YywoKwjMxijp+T-SxqZLjuOhiXkMRa5y57eYuTHOc6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2012-03-21 at 15:14 -0400, Scott Lovenberg wrote:
>         
>         > Are there any other options that are implicitly set?  Or,
>         more
>         > generally, will this solution scale?
>         
>         
>         For a one off case like this, a solution like this is
>         acceptable. If
>         there are more number of such options where we can could pass
>         a blank,
>         we could add some code to make parsing them easier.
>         
>         I don't see us facing much problems scaling here.
>         
>         Sachin Prabhu
>         
> 
> 
> Sorry if this seemed like a silly question, I'm just always curious
> about coding styles and studying the craft. I realized after I asked
> how silly it sounded. :)

I am in the same boat. We are all learning here.

Sachin Prabhu
