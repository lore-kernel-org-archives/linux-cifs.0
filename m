From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Severe performance issue (Ubuntu 10.04 mounting an XP share)
Date: Fri, 2 Jul 2010 14:16:17 -0400
Message-ID: <20100702141617.46ec65a6@corrin.poochiereds.net>
References: <AANLkTilXnPMMoY-54RbO4CUeqP9b-zaM7NZQZQpHH5Gk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTilXnPMMoY-54RbO4CUeqP9b-zaM7NZQZQpHH5Gk-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2 Jul 2010 16:39:06 +0100
James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Jul  2 16:14:58 ubuntu kernel: [ 1378.833956] CIFS VFS: No response
> for cmd 50 mid 11112

The client is sending a SMB_COM_TRANSACTION2 and isn't getting a
response. You might want to sniff traffic and identify calls that
aren't getting responses. If there is some commonality between them
then that may point to where the problem is.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
