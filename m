From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: find_smb_session problem
Date: Fri, 11 Mar 2011 06:23:15 -0500
Message-ID: <20110311062315.34df713a@tlielax.poochiereds.net>
References: <AANLkTikk0Qef1B4myQwUOnyQLOWsQbebsCkGcgUFFmcY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikk0Qef1B4myQwUOnyQLOWsQbebsCkGcgUFFmcY-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 11 Mar 2011 12:29:17 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi to all!
> 
> I faced with such a problem:
> 1) user1 mounts a remote share with user=guest,pass=231
> 2) user2 mounts the same share with user=guest,pass=222(wrong
> password) and succeed (!).
> 
> The problem is that user2 doesn't know a true password of the share
> but can mount it if user1 successfully mounted it with the true
> password.
> 
> Looking through the code I noticed that we don't have any checks in
> find_smb_session for passwords - only username check. I think it's a
> big security issue.
> 

I think you must be looking at an old tree. See commit
4ff67b720c02c36e54d55b88c2931879b7db1cd2.


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
