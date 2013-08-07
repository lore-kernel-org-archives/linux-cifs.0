From: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] cifs: don't instantiate new dentries in readdir for inodes
 that need to be revalidated immediately
Date: Wed, 07 Aug 2013 14:42:27 +0100
Message-ID: <52024EC3.2070504@cam.ac.uk>
References: <51F92F0B.7030504@cam.ac.uk> <1375880647-22512-1-git-send-email-jlayton@redhat.com> <20130807090616.6ba44d6c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130807090616.6ba44d6c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/08/13 14:06, Jeff Layton wrote:

> This patch is untested (other than for compilation), but I think it'll
> do the right thing. Metze, David could you test it and let us know if
> it helps?

Hi Jeff,

Seems to work nicely; many thanks!

(Caveat: I'm testing this on a backported version of the 3.10 driver on
top of Ubuntu's 3.8 kernel.)

Tested-By: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>

Cheers,
David
-- 
David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Unix Specialist, University Computing Service
