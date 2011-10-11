From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Purpose of GLOBAL_EXTERN macro
Date: Tue, 11 Oct 2011 07:08:21 -0400
Message-ID: <20111011070821.6c153d53@tlielax.poochiereds.net>
References: <4E940EF9.7030603@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E940EF9.7030603-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Oct 2011 15:10:09 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> I bumped into the GLOBAL_EXTERN macro in the cifs code. I'm not sure I
> understand the purpose of this. Can someone explain why we need this
> instead of simply using "extern"?
> 

I've never been quite sure what that's all about either. I think the
idea was to allow you to put global declarations in an include file but
then have only one .c file actually do them?

Seems like there was a patch to remove it a few years ago, but Steve
never merged it for some reason...

In any case, I agree with akpm's thoughts on the matter:

    https://lkml.org/lkml/2008/11/14/367

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
