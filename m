From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cifs: fix parsing of password mount option
Date: Tue, 12 Jun 2012 11:29:54 +0530
Message-ID: <4FD6DADA.8050004@suse.com>
References: <4FD60F7E.2060608@suse.com> <1339438697.2459.21.camel@localhost> <CAH2r5mukodjGqKNvbo6HB_PhUBzauckeSKCqCEYzpQGxbUtAMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mukodjGqKNvbo6HB_PhUBzauckeSKCqCEYzpQGxbUtAMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/12/2012 02:08 AM, Steve French wrote:
> Wouldn't this also have to go cc: stable since it involves password
> check logic in last release too?

yes, this has to go to stable, specifically for 3.1 and above.
Once reviewed and accepted, please add

  Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [3.1+]


Thanks
Suresh
