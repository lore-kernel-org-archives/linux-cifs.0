From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: 2.6.34-rc3 BUG: unable to handle kernel NULL pointer
 dereference  at 0000000000000048 cifs_show_options
Date: Sat, 26 Jun 2010 11:58:10 -0400
Message-ID: <20100626115810.532913f5@tlielax.poochiereds.net>
References: <AANLkTilhTrEBYZd4HxeXQk8B6-yV8rCJ2C0jXsEREgIR@mail.gmail.com>
	<AANLkTimTmPEG-8gDKu7Xj8--LrXsF9oe-afbm0X_QHsX@mail.gmail.com>
	<20100626075125.3d1711ff@tlielax.poochiereds.net>
	<AANLkTikXz-zW3_nh0k941BPHWLJMN630l2R5sPoc35kC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikXz-zW3_nh0k941BPHWLJMN630l2R5sPoc35kC-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 26 Jun 2010 22:22:00 +1000
Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I have turned on cifs debug to try to catch it if happens again.
> 
> (gdb) list *(cifs_show_options+0xf9)
> 0x309 is in cifs_show_options (fs/cifs/cifsfs.c:336).
> 331	static void
> 332	cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
> 333	{
> 334		seq_printf(s, ",addr=");
> 335	
> 336		switch (server->addr.sockAddr.sin_family) {
> 337		case AF_INET:
> 338			seq_printf(s, "%pI4", &server->addr.sockAddr.sin_addr.s_addr);
> 339			break;
> 340		case AF_INET6:
> 
> 
> 
> 

Thanks, that helps. It looks like the "server" pointer in that function
was NULL or something close to it. Those should be properly refcounted
nowadays and that hasn't changed in quite a while. This function only
gets called from one place -- cifs_show_options. So something was
reading /proc/self/mountinfo and this pointer got zeroed out. Maybe
this raced with an unmount and the memory was recycled? Doesn't seem
like that ought to be possible though (I think vfsmount references are
held for each of these calls).

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
